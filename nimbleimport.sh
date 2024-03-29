. config.sh
. functions.sh

db_connect="mysql -h $db_hostname -u $db_user -p$db_pw $db_name -e"
auth_bearer="Authorization: Bearer $api_key"
trunc_statement="truncate "
scrver="0.7"

cont_full=""
insert_fields=""
insert_values=""
nimble_ref=""

if [ $truncrec -eq 1 ]
then
	echo "$(timestamp) Truncating rec tables" >> $fn_logfile
	query="$trunc_statement rec_nimb_cont_id"
	$db_connect "$query"
	query="$trunc_statement rec_nimb_cont_det"
	$db_connect "$query"
	query="$trunc_statement rec_nimb_cont_det_sub"
	$db_connect "$query"
	query="$trunc_statement rec_nimb_cont_childids"
	$db_connect "$query"
fi

if [ $recids -eq 1 ]
then
	echo "$(timestamp) Populating Contact IDs in Rec" >> $fn_logfile
	total_pages=$( curl -H "$auth_bearer" https://api.nimble.com/api/v1/contacts/ids | jq --raw-output '.meta.pages' )
	echo "$(timestamp) Starting Contact ID batch loop - 1 of $total_pages pages" >> $fn_logfile
	END=$total_pages
	for ((i=1;i<=END;i++)); do
		id_set=$( curl -H "$auth_bearer" https://api.nimble.com/api/v1/contacts/ids?page=$i | jq --raw-output '.resources' )
		id_set="${id_set:4}"
		id_set="${id_set::-1}"
		id_set=${id_set//\"/}
		id_set=${id_set//[$'\t\r\n']}
		id_set=${id_set//[[:blank:]]/}
		id_set=${id_set//,/ }
		IFS=', ' read -r -a id_arr <<< "$id_set"
		for id_single in "${id_arr[@]}"
		do
			query="insert into rec_nimb_cont_id (nimb_cont_id) VALUES('$id_single')"
			$db_connect "$query"
		done
	done
	echo "$(timestamp) Completed Contact ID batch loop" >> $fn_logfile
fi

if [ $recdetails -eq 1 ]
then
	echo "$(timestamp) Populating Contact Details" >> $fn_logfile
	rm $fn_contactjson
	while read rec_nimb_cont_id
	do
		insert_fields="cont_id"
		insert_values="'$rec_nimb_cont_id'"
		cont_full=$( curl -H "$auth_bearer" https://api.nimble.com/api/v1/contact/$rec_nimb_cont_id | jq --raw-output '.resources' )
		if [ "$rec_nimb_cont_id" != "nimb_cont_id" ]
		then
			completerecord=$(jq -r ".[]" <<< "$cont_full")
			echo "$completerecord" >> $fn_contactjson
			
			#Contact details
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
			#echo "$(timestamp) Insert statement: $insert_statement" >> $fn_logfile
			$db_connect "$insert_statement"

			#Contact child IDs
			target_table="rec_nimb_cont_childids"
			while IFS=$'\t' read nimble_ref sql_field;
			do
				if [ "$nimble_ref" != "nimble_ref" ]
				then
					childids=$(jq ".[].${nimble_ref}" <<< "$cont_full")
					childids=${childids//\"/,}
					childids=${childids//[$'\t\r\n']}
					IFS=$',' read -r -a childidarr <<< "$childids"
					for childid in "${childidarr[@]}"
					do
						insert_values="'$rec_nimb_cont_id','$childid'"
						insert_fields="cont_id,$sql_field"
						insert_statement="INSERT INTO $target_table ($insert_fields) VALUES ($insert_values)"
						$db_connect "$insert_statement"
					done
				fi
			done < <($db_connect "SELECT DISTINCT nimble_ref, sql_field FROM etl_mapping WHERE map_profile = 'cont_det' AND sql_table = '$target_table'")
			insert_statement="INSERT INTO $target_table ($insert_fields) VALUES ($insert_values)"

			#Sub details
			target_table="rec_nimb_cont_det_sub"
			while IFS=$'\t' read nimble_ref sql_field;
			do
				if [ "$nimble_ref" != "nimble_ref" ]
				then
					for ((i=0;i<=10000;i++))
				    do
						currentdetailset=$(jq -r ".[].${nimble_ref}[$i].modifier" <<< "$cont_full")
						#echo "$(timestamp) Current detail set: $currentdetailset" >> $fn_logfile
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
									pointless="Very"
								else
									detail="${detail:1}"
									detailvalue="${detailvalue:1}"
									checkchars="${detail: -1} ${detailvalue: -1}"
									if [[ $checkchars == *","* ]] || [[ $checkchars == *":"* ]]
									then
										detail="${detail::-1}"
										detailvalue="${detailvalue::-1}"									
									else
										detail="${detail::-2}"
										detailvalue="${detailvalue::-2}"
									fi
									detail=${detail//\"/}
									detailvalue=${detailvalue//\"/}
									insert_values="'$rec_nimb_cont_id','$sql_field','$modifier','$detailvalue','$label','$detail','$i'"
									insert_fields="cont_id,field,modifier,value,label,detail,address_id"
									insert_statement="INSERT INTO $target_table ($insert_fields) VALUES ($insert_values)"
									$db_connect "$insert_statement"								
								fi
							done < <(jq -r "." <<< "$value")
						else
							insert_values="'$rec_nimb_cont_id','$sql_field','$modifier','$value','$label'"
							insert_fields="cont_id,field,modifier,value,label"
							insert_statement="INSERT INTO $target_table ($insert_fields) VALUES ($insert_values)"
							#echo "$(timestamp) Insert statement: $insert_statement" >> $fn_logfile
							$db_connect "$insert_statement"
						fi
				    done
				fi
			done < <($db_connect "SELECT DISTINCT nimble_ref, sql_field FROM etl_mapping WHERE map_profile = 'cont_det' AND sql_table = '$target_table'")
		fi
	done < <($db_connect "SELECT DISTINCT * FROM rec_nimb_cont_id")
fi

if [ $loadstaging -eq 1 ]
then
	echo "$(timestamp) Loading Staging Tables" >> $fn_logfile
	$db_connect "call load_rectostg()"
fi
