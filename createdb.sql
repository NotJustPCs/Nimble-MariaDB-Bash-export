-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 08, 2019 at 02:06 PM
-- Server version: 10.3.17-MariaDB
-- PHP Version: 7.2.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nimbledb`
--
CREATE DATABASE IF NOT EXISTS `nimbledb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `nimbledb`;

-- --------------------------------------------------------

--
-- Table structure for table `etl_mapping`
--

CREATE TABLE `etl_mapping` (
  `map_id` int(11) NOT NULL,
  `map_profile` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `nimble_ref` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `sql_table` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `sql_field` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `etl_mapping`
--

INSERT INTO `etl_mapping` (`map_id`, `map_profile`, `nimble_ref`, `sql_table`, `sql_field`) VALUES
(1, 'cont_det', 'updated', 'rec_nimb_cont_det', 'updated'),
(2, 'cont_det', 'updater', 'rec_nimb_cont_det', 'updater'),
(3, 'cont_det', 'creator', 'rec_nimb_cont_det', 'creator'),
(4, 'cont_det', 'created', 'rec_nimb_cont_det', 'created'),
(5, 'cont_det', 'object_type', 'rec_nimb_cont_det', 'object_type'),
(6, 'cont_det', 'record_type', 'rec_nimb_cont_det', 'record_type'),
(7, 'cont_det', 'avatar_url', 'rec_nimb_cont_det', 'avatar_url'),
(8, 'cont_det', 'is_important', 'rec_nimb_cont_det', 'is_important'),
(9, 'cont_det', 'reminder', 'rec_nimb_cont_det', 'reminder'),
(10, 'cont_det', 'owner_id', 'rec_nimb_cont_det', 'owner_id'),
(11, 'cont_det', 'fields.Gender[].value', 'rec_nimb_cont_det', 'gender'),
(12, 'cont_det', 'fields.\"first name\"[].value', 'rec_nimb_cont_det', 'first_name'),
(13, 'cont_det', 'fields.\"last name\"[].value', 'rec_nimb_cont_det', 'last_name'),
(14, 'cont_det', 'fields.title[].value', 'rec_nimb_cont_det', 'title'),
(15, 'cont_det', 'fields.\"Mailchimp Rating\"[].value', 'rec_nimb_cont_det', 'mailchimp_rating'),
(16, 'cont_det', 'fields.\"Form Name\"[].value', 'rec_nimb_cont_det', 'form_name'),
(17, 'cont_det', 'fields.COP[].value', 'rec_nimb_cont_det', 'cop'),
(18, 'cont_det', 'fields.Calendar[].value', 'rec_nimb_cont_det', 'calendar'),
(19, 'cont_det', 'fields.email[].value', 'rec_nimb_cont_det', 'email'),
(20, 'cont_det', 'fields.Ethnicity[].value', 'rec_nimb_cont_det', 'ethnicity'),
(21, 'cont_det', 'fields.\"CMS ID\"[].value', 'rec_nimb_cont_det', 'cms_id'),
(22, 'cont_det', 'fields.source[].value', 'rec_nimb_cont_det', 'source'),
(23, 'cont_det', 'fields.\"Old Source\"[].value', 'rec_nimb_cont_det', 'old_source'),
(24, 'cont_det', 'fields.\"Special Needs\"[].value', 'rec_nimb_cont_det', 'special_needs'),
(25, 'cont_det', 'fields.\"Old Lead Type\"[].value', 'rec_nimb_cont_det', 'old_lead_type'),
(26, 'cont_det', 'fields.\"Any Contact\"[].value', 'rec_nimb_cont_det', 'any_contact'),
(27, 'cont_det', 'fields.MailPref[].value', 'rec_nimb_cont_det', 'mailpref'),
(28, 'cont_det', 'fields.\"Home Contact\"[].value', 'rec_nimb_cont_det', 'home_contact'),
(29, 'cont_det', 'fields.Post[].value', 'rec_nimb_cont_det', 'post'),
(30, 'cont_det', 'fields.\"Xmas Email\"[].value', 'rec_nimb_cont_det', 'xmas_email'),
(31, 'cont_det', 'fields.\"company name\"[].value', 'rec_nimb_cont_det', 'company_name'),
(32, 'cont_det', 'fields.\"parent company\"[].value', 'rec_nimb_cont_det', 'parent_company'),
(33, 'cont_det', 'fields.AREA[].value', 'rec_nimb_cont_det', 'area'),
(34, 'cont_det', 'fields.domain', 'rec_nimb_cont_det_sub', 'domain'),
(35, 'cont_det', 'fields.instagram', 'rec_nimb_cont_det_sub', 'instagram'),
(36, 'cont_det', 'fields.twitter', 'rec_nimb_cont_det_sub', 'twitter'),
(37, 'cont_det', 'fields.facebook', 'rec_nimb_cont_det_sub', 'facebook'),
(38, 'cont_det', 'fields.linkedin', 'rec_nimb_cont_det_sub', 'linkedin'),
(39, 'cont_det', 'fields.\"lead status\"[].value', 'rec_nimb_cont_det', 'lead_status'),
(40, 'cont_det', 'fields.\"lead type\"[].value', 'rec_nimb_cont_det', 'lead_type'),
(41, 'cont_det', 'fields.birthday[].value', 'rec_nimb_cont_det', 'birthday'),
(42, 'cont_det', 'fields.\"LAST QUAL\"[].value', 'rec_nimb_cont_det', 'last_qual'),
(43, 'cont_det', 'fields.\"CIPD No.\"[].value', 'rec_nimb_cont_det', 'cipd_no'),
(44, 'cont_det', 'fields.\"Date Won/Lost\"[].value', 'rec_nimb_cont_det', 'date_wonlost'),
(45, 'cont_det', 'fields.\"Qual Start Year\"[].value', 'rec_nimb_cont_det', 'qual_start_year'),
(46, 'cont_det', 'fields.Qualification[].value', 'rec_nimb_cont_det', 'qualification'),
(47, 'cont_det', 'fields.\"Old Salesperson\"[].value', 'rec_nimb_cont_det', 'old_salesperson'),
(48, 'cont_det', 'fields.\"annual revenue\"[].value', 'rec_nimb_cont_det', 'annual_revenue'),
(49, 'cont_det', 'fields.URL', 'rec_nimb_cont_det_sub', 'url'),
(50, 'cont_det', 'fields.description', 'rec_nimb_cont_det_sub', 'description'),
(51, 'cont_det', 'fields.address', 'rec_nimb_cont_det_sub', 'address'),
(52, 'cont_det', 'fields.phone', 'rec_nimb_cont_det_sub', 'phone'),
(53, 'cont_det', 'fields.\"skype id\"', 'rec_nimb_cont_det_sub', 'skype_id');

-- --------------------------------------------------------

--
-- Table structure for table `rec_nimb_cont_det`
--

CREATE TABLE `rec_nimb_cont_det` (
  `cont_id` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updater` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `creator` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `object_type` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `record_type` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar_url` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_important` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reminder` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `owner_id` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_name` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_company` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ethnicity` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_name` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `form_name` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mailchimp_rating` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `any_contact` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mailpref` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `home_contact` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `post` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `xmas_email` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cop` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `calendar` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cms_id` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_source` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_lead_type` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `special_needs` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lead_status` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lead_type` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_qual` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cipd_no` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_wonlost` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qual_start_year` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qualification` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_salesperson` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `annual_revenue` text COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rec_nimb_cont_det_sub`
--

CREATE TABLE `rec_nimb_cont_det_sub` (
  `cont_id` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `field` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `modifier` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `label` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `detail` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rec_nimb_cont_id`
--

CREATE TABLE `rec_nimb_cont_id` (
  `nimb_cont_id` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `etl_mapping`
--
ALTER TABLE `etl_mapping`
  ADD PRIMARY KEY (`map_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `etl_mapping`
--
ALTER TABLE `etl_mapping`
  MODIFY `map_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
