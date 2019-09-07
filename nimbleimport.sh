. config.sh

db_connect="mysql -h $db_hostname -u $db_user -p$db_pw $db_name -e"
auth_bearer="Authorization: Bearer $api_key"
trunc_statement="truncate "

cont_full=""
insert_fields=""
insert_values=""
nimble_ref=""

if [ $truncrec -eq 1 ]
then
	echo "Truncating rec tables"
	query="$trunc_statement rec_nimb_cont_id"
	$db_connect "$query"
	query="$trunc_statement rec_nimb_cont_det"
	$db_connect "$query"
fi

if [ $recids -eq 1 ]
then
	echo "Populating Contact IDs in Rec"
	total_pages=$( curl -H "$auth_bearer" https://api.nimble.com/api/v1/contacts/ids | jq --raw-output '.meta.pages' )

	END=$total_pages
	for ((i=1;i<=END;i++)); do
		#echo $i
		id_set=$( curl -H "$auth_bearer" https://api.nimble.com/api/v1/contacts/ids?page=$i | jq --raw-output '.resources' )
		id_set="${id_set:4}"
		id_set=${id_set//\"/}
		id_set=${id_set//[$'\t\r\n']}
		id_set=${id_set//[[:blank:]]/}
		id_set=${id_set//,/ }
		IFS=', ' read -r -a id_arr <<< "$id_set"
		for id_single in "${id_arr[@]}"
		do
			echo "$id_single"
			query="insert into rec_nimb_cont_id (nimb_cont_id) VALUES('$id_single')"
			$db_connect "$query"
		done
	done
fi

if [ $recdetails -eq 1 ]
then
    echo "Populating Contact Details"
	while read rec_nimb_cont_id
	do
		insert_fields="cont_id"
		insert_values="'$rec_nimb_cont_id'"
		cont_full=$( curl -H "$auth_bearer" https://api.nimble.com/api/v1/contact/$rec_nimb_cont_id | jq --raw-output '.resources' )
		if [ "$rec_nimb_cont_id" != "nimb_cont_id" ]
		then
			#echo "$cont_full" >> fullcontact.txt
			target_table="rec_nimb_cont_det"
			while IFS=$'\t' read nimble_ref sql_field;
			do
				if [ "$nimble_ref" != "nimble_ref" ]
				then
					insert_value=$(jq -r ".[].${nimble_ref}" <<< "$cont_full")
					insert_values="$insert_values,'$insert_value'"
					insert_fields="$insert_fields,$sql_field"
				fi
			done < <($db_connect "SELECT DISTINCT nimble_ref, sql_field FROM etl_mapping WHERE map_profile = 'cont_det' AND sql_table = '$target_table'")
			insert_statement="INSERT INTO $target_table ($insert_fields) VALUES ($insert_values)"
			#echo "Insert statement: $insert_statement"
			$db_connect "$insert_statement"

			#Sub details
			target_table="rec_nimb_cont_det_sub"
			while IFS=$'\t' read nimble_ref sql_field;
			do
				if [ "$nimble_ref" != "nimble_ref" ]
				then
					#echo ".[].${nimble_ref}."
					#echo jq -r ".[].${nimble_ref}."
				    #This needs to read each value in with nimble_ref, and insert them all into a table. So another JQ loop through the value from the table.
					for ((i=0;i<=10000;i++))
				    do
						currentdetailset=$(jq -r ".[].${nimble_ref}[$i].modifier" <<< "$cont_full")
						#echo "$currentdetailset"
						if [ -z "$currentdetailset" ] || [ $currentdetailset == "null" ]
						then
							break
						fi
						modifier=$(jq -r ".[].${nimble_ref}[$i].modifier" <<< "$cont_full")
						label=$(jq -r ".[].${nimble_ref}[$i].label" <<< "$cont_full")
						value=$(jq -r ".[].${nimble_ref}[$i].value" <<< "$cont_full")
						if [[ ${value:0:1} == "{" ]]
						then
							while read -r detail detailvalue
							do
								if [ $detail == "{" ] || [ $detail == "}" ]
								then
									echo "Skip"
								else
									echo "$detail"
									detail="${detail:1}"
									echo "$detail"
									detail="${detail::-2}"
									echo "$detail"
									detailvalue="${detailvalue:1}"
									detailvalue="${detailvalue::-2}"
									insert_values="'$rec_nimb_cont_id','$sql_field','$modifier','$detailvalue','$label','$detail'"
									insert_fields="cont_id,field,modifier,value,label,detail"
									insert_statement="INSERT INTO $target_table ($insert_fields) VALUES ($insert_values)"
									echo "Insert statement: $insert_statement"
									$db_connect "$insert_statement"								
								fi
							done < <(jq -r "." <<< "$value")
						else
							insert_values="'$rec_nimb_cont_id','$sql_field','$modifier','$value','$label'"
							insert_fields="cont_id,field,modifier,value,label"
							insert_statement="INSERT INTO $target_table ($insert_fields) VALUES ($insert_values)"
							#echo "Insert statement: $insert_statement"
							$db_connect "$insert_statement"
						fi
				    done
				fi
			done < <($db_connect "SELECT DISTINCT nimble_ref, sql_field FROM etl_mapping WHERE map_profile = 'cont_det' AND sql_table = '$target_table'")
		fi
	done < <($db_connect "SELECT DISTINCT * FROM rec_nimb_cont_id")
fi
