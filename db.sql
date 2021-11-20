-- Adminer 4.7.7 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `acl_permission`;
CREATE TABLE `acl_permission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `menu_text` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `link` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `acl_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_menu` smallint(6) NOT NULL DEFAULT '0',
  `ordering` smallint(6) NOT NULL,
  `adding` smallint(6) NOT NULL DEFAULT '0',
  `edit` smallint(6) NOT NULL DEFAULT '0',
  `view` smallint(6) NOT NULL DEFAULT '0',
  `trash` smallint(6) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `acl_permission` (`id`, `group_id`, `menu_text`, `link`, `icon`, `acl_key`, `parent_menu`, `ordering`, `adding`, `edit`, `view`, `trash`, `created_at`, `updated_at`) VALUES
(1,	1,	'User Panel',	'',	'<i class=\"fa fa-user\"></i>',	'extensionsvalley.dashboard.userpanel',	0,	1,	0,	0,	1,	0,	'2016-12-01 22:11:31',	NULL),
(2,	1,	'Manage Users',	'/admin/ExtensionsValley/dashboard/list/users',	'',	'extensionsvalley.dashboard.users',	5,	2,	1,	1,	1,	1,	'2016-12-01 22:11:31',	NULL),
(3,	1,	'User Groups',	'/admin/ExtensionsValley/dashboard/list/groups',	'',	'extensionsvalley.dashboard.groups',	5,	1,	1,	1,	1,	1,	'2016-12-01 22:11:31',	NULL);

DROP TABLE IF EXISTS `extension_manager`;
CREATE TABLE `extension_manager` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vendor` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `version` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_paid` smallint(6) NOT NULL DEFAULT '0',
  `status` smallint(6) NOT NULL DEFAULT '1',
  `package_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `update_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `author` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `extension_manager` (`id`, `name`, `vendor`, `description`, `version`, `is_paid`, `status`, `package_type`, `icon`, `update_url`, `author`, `website`, `contact_email`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1,	'Dashboard',	'WalksWithMe',	'Core Package',	'2.0.0',	1,	1,	'wwmladmin-package',	'packages/extensionsvalley/dashboard/package_icons/icon.png',	'https://github.com/LaFlux/Laflux',	'Jobin <support@walkswithme.net>',	'http://www.walkswithme.net/contact-me',	'support@walkswithme.net',	'2021-10-29 08:35:17',	'2021-10-29 08:35:17',	NULL);

DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `gen_settings`;
CREATE TABLE `gen_settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `settings_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `settings_value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `gen_settings_settings_key_unique` (`settings_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` smallint(6) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `groups_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `groups` (`id`, `name`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1,	'Super Admin',	1,	'2021-10-29 08:35:17',	NULL,	NULL),
(2,	'Senders',	1,	'2021-10-29 08:35:17',	NULL,	NULL),
(3,	'Bikers',	1,	'2021-10-29 08:35:17',	NULL,	NULL);

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1,	'2014_10_12_000000_create_users_table',	1),
(2,	'2014_10_12_100000_create_password_resets_table',	1),
(3,	'2015_08_25_062200_Alter_Users_Table',	1),
(4,	'2015_08_25_062201_Create_Groups_Table',	1),
(5,	'2015_08_25_062202_Create_ACL_Table',	1),
(6,	'2015_08_25_062203_Create_Settings_Table',	1),
(7,	'2015_09_01_061101_Create_Users_Profile_Table',	1),
(8,	'2016_09_28_062203_Create_ExtensionManager_Table',	1),
(9,	'2019_08_19_000000_create_failed_jobs_table',	1),
(10,	'2021_10_26_062201_Create_Parcel_Orders_Table',	1),
(11,	'2021_10_26_062202_Create_Parcel_Order_Details_Table',	1);

DROP TABLE IF EXISTS `parcel_orders`;
CREATE TABLE `parcel_orders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) NOT NULL,
  `order_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pickup_address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `delivery_address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `parcel_orders_order_id_unique` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `parcel_orders` (`id`, `sender_id`, `order_id`, `pickup_address`, `delivery_address`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1,	3,	'617bb27db7dea',	'sss',	'ssss',	'2021-10-29 08:36:13',	'2021-10-29 08:36:13',	NULL);

DROP TABLE IF EXISTS `parcel_order_details`;
CREATE TABLE `parcel_order_details` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `biker_id` int(11) DEFAULT NULL,
  `parcel_order_id` int(11) NOT NULL,
  `pickup_time` timestamp NULL DEFAULT NULL,
  `delivery_time` timestamp NULL DEFAULT NULL,
  `status` smallint(6) NOT NULL DEFAULT '0' COMMENT '0- Pending , 1 - Picked Up, 2 - Delivered',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `parcel_order_details_parcel_order_id_unique` (`parcel_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `parcel_order_details` (`id`, `biker_id`, `parcel_order_id`, `pickup_time`, `delivery_time`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1,	7,	1,	'2021-10-29 14:07:27',	'2021-10-29 14:08:25',	2,	'2021-10-29 08:36:13',	'2021-10-29 08:38:27',	NULL);

DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `groups` smallint(6) NOT NULL DEFAULT '3',
  `status` smallint(6) NOT NULL DEFAULT '1',
  `api_token` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_api_token_unique` (`api_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `groups`, `status`, `api_token`, `remember_token`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1,	'Admin',	'admin@wwm.com',	NULL,	'$2y$10$4lGPmAdi9TNcOxT.vXjQKulmUnXm/dXv0Xy45QZMoTpsxPvgBXPW.',	1,	1,	NULL,	NULL,	'2021-10-29 08:35:17',	'2021-10-29 08:35:17',	NULL),
(2,	'Sender 1',	'sender1@wwm.com',	NULL,	'$2y$10$.nmDwQEl2Po2GTcOrC0UKeFZgPISHRkhtjRCvqsuoIj9x3kuMia/6',	2,	1,	NULL,	NULL,	'2021-10-29 08:35:17',	NULL,	NULL),
(3,	'Sender 2',	'sender2@wwm.com',	NULL,	'$2y$10$x1sp9TYoZwDiMSyuj4j1MuQEidzHqlARx7xLu0cZiHKR3PKd7UYCm',	2,	1,	NULL,	NULL,	'2021-10-29 08:35:17',	NULL,	NULL),
(4,	'Sender 3',	'sender3@wwm.com',	NULL,	'$2y$10$wtkhCLG.l9dmk1G34OzHW.BtNyDjD36KEWfjH8ubEfmUj.YTpvnCC',	2,	1,	NULL,	NULL,	'2021-10-29 08:35:17',	NULL,	NULL),
(5,	'Sender 4',	'sender4@wwm.com',	NULL,	'$2y$10$ULydQcY5JL2MpyoV5kTZH.IW3AMuWR9Lsa0AbS89FOUz/7OHnmNFe',	2,	1,	NULL,	NULL,	'2021-10-29 08:35:17',	NULL,	NULL),
(6,	'Sender 5',	'sender5@wwm.com',	NULL,	'$2y$10$fVpj/WFk3nreH0eeuEniyuVy3zhy0Dr3tfPyhpQqjL5WM7UxIG25C',	2,	1,	NULL,	NULL,	'2021-10-29 08:35:18',	NULL,	NULL),
(7,	'Biker 1',	'biker1@wwm.com',	NULL,	'$2y$10$/o20avFrgSN/FL1Nk8pYju50adHP0bVdDfISPZxx81iihyFNXktHC',	3,	1,	NULL,	NULL,	'2021-10-29 08:35:18',	NULL,	NULL),
(8,	'Biker 2',	'biker2@wwm.com',	NULL,	'$2y$10$XEC.fOeidJbnu4T8EEvo/usUTdIHJNVlVpzF8jnKLFCysscWhXGNW',	3,	1,	NULL,	NULL,	'2021-10-29 08:35:18',	NULL,	NULL),
(9,	'Biker 3',	'biker3@wwm.com',	NULL,	'$2y$10$b2gWycg77ZxXsOzIcsM3DeGQqaV2pxiOOTiQWoAPVYNv2dHZBIALy',	3,	1,	NULL,	NULL,	'2021-10-29 08:35:18',	NULL,	NULL),
(10,	'Biker 4',	'biker4@wwm.com',	NULL,	'$2y$10$lm7uQ/W7HZ6IERQNH3240.rObejJUrETsXAAZ2pzsVyXJpdeodMO.',	3,	1,	NULL,	NULL,	'2021-10-29 08:35:18',	NULL,	NULL),
(11,	'Biker 5',	'biker5@wwm.com',	NULL,	'$2y$10$sG1ExUVuWRM28H/tJyivt.9iCsuLI2GsH53LIJqMp841jIyy0cVJq',	3,	1,	NULL,	NULL,	'2021-10-29 08:35:18',	NULL,	NULL),
(12,	'Biker 6',	'biker6@wwm.com',	NULL,	'$2y$10$.a0s7LgaaopdtedDrqfG9uTYo44O.Em9Zd0tyYM69/jzeAC33nVci',	3,	1,	NULL,	NULL,	'2021-10-29 08:35:18',	NULL,	NULL),
(13,	'Biker 7',	'biker7@wwm.com',	NULL,	'$2y$10$ESeIkFCjn4YZD8nM6f0rDesGV6NZF85YcB4lcp2Z5nF1MkAJ2jrq2',	3,	1,	NULL,	NULL,	'2021-10-29 08:35:18',	NULL,	NULL),
(14,	'Biker 8',	'biker8@wwm.com',	NULL,	'$2y$10$kWrx9/0IA6LV8qq4KTmJw..v1HBtO/3qg.znMcfSYXpUB1hffQioG',	3,	1,	NULL,	NULL,	'2021-10-29 08:35:18',	NULL,	NULL),
(15,	'Biker 9',	'biker9@wwm.com',	NULL,	'$2y$10$BGIv9/S65SoMN2bX8C.kP.HFqe/lWd5VRGG8in3IPMSBj2QfLrwhu',	3,	1,	NULL,	NULL,	'2021-10-29 08:35:18',	NULL,	NULL),
(16,	'Biker 10',	'biker10@wwm.com',	NULL,	'$2y$10$txZxSgq0yYV5ZxLE.IvtVe3P19zZ.ECjBa8rvLTgI47te1/Rj8Prq',	3,	1,	NULL,	NULL,	'2021-10-29 08:35:18',	NULL,	NULL);

DROP TABLE IF EXISTS `user_profile`;
CREATE TABLE `user_profile` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `street` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `media` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `zip` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mobile` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_profile_user_id_unique` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 2021-11-09 08:44:52
