Any time you make a change to the schema files, remember to increment the database schema version. Generally increment the minor number, major should be reserved for significant changes to the schema. Both values go up to 255.

Make sure to also update `DB_MAJOR_VERSION` and `DB_MINOR_VERSION`, which can be found in `code/__DEFINES/subsystem.dm`.

The latest database version is 5.34 (for bubberstation) (5.32 for /tg/); The query to update the schema revision table is:

```sql
INSERT INTO `schema_revision` (`major`, `minor`) VALUES (5, 34);
```

or

```sql
INSERT INTO `SS13_schema_revision` (`major`, `minor`) VALUES (5, 34);
```

In any query remember to add a prefix to the table names if you use one.

---

Version 5.32, 31 May 2025, by TealSeer
Change column name of `manifest` table because `character` is a reserved word.

```sql
ALTER TABLE `manifest`
	RENAME COLUMN `character` TO `character_name`;
```

---

Version 5.31, 3 May 2025, by Atlanta-Ned
Adds a `manifest` table.

```sql
CREATE TABLE `manifest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_ip` int(10) unsigned NOT NULL,
  `server_port` smallint(5) NOT NULL,
  `round_id` int(11) NOT NULL,
  `ckey` text NOT NULL,
  `character` text NOT NULL,
  `job` text NOT NULL,
  `special` text DEFAULT NULL,
  `latejoin` tinyint(1) NOT NULL DEFAULT 0,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
```

---

Version 5.30, 1 May 2025, by Rengan
Adds `crime_desc` field to the `citation` table to save the description of the crime.

```sql
ALTER TABLE `citation`
ADD COLUMN `crime_desc` TEXT NULL DEFAULT NULL AFTER `crime`;
```

---

Version 5.29, 4 February 2024, by Tiviplus
Fixed admin rank table flags being capped at 16 in the DB instead of 24 (byond max)

```sql
ALTER TABLE `admin_ranks`
	MODIFY COLUMN `flags` mediumint(5) unsigned NOT NULL,
	MODIFY COLUMN `exclude_flags` mediumint(5) unsigned NOT NULL,
	MODIFY COLUMN `can_edit_flags` mediumint(5) unsigned NOT NULL;
```

---

Version 5.28, 1 November 2024, by Ghommie
Added `fish_progress` as the first 'progress' subtype of 'datum/award/scores'

```sql
CREATE TABLE `fish_progress` (
  `ckey` VARCHAR(32) NOT NULL,
  `progress_entry` VARCHAR(32) NOT NULL,
  `datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ckey`,`progress_entry`)
) ENGINE=InnoDB;
```

---

Version 5.27, 26 April 2024, by zephyrtfa
Add the ip intel whitelist table

```sql
DROP TABLE IF EXISTS `ipintel_whitelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ipintel_whitelist` (
	`ckey` varchar(32) NOT NULL,
	`admin_ckey` varchar(32) NOT NULL,
	PRIMARY KEY (`ckey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
```

---

Version 5.29, 08 January 2024, by Useroth
Add a new table for age-checking purposes. Optional if you don't ever intend to use the age prompt.

```sql
CREATE TABLE `player_dob` (
    `ckey` VARCHAR(32) NOT NULL,
    `dob_year` smallint(5) NOT NULL,
    `dob_month` smallint(5) NOT NULL,
    PRIMARY KEY (`ckey`)
);
```

---

Version 5.28, 03 December 2023, by distributivgesetz
Set the default value of cloneloss to 0, as it's obsolete and it won't be set by blackbox anymore.

```sql
ALTER TABLE `death` MODIFY COLUMN `cloneloss` SMALLINT(5) UNSIGNED DEFAULT '0';
```

---

Version 5.27, 27 September 2023, by Jimmyl
Removes the text_adventures table because it is no longer used

```sql
 DROP TABLE IF EXISTS `text_adventures`;
```

---

Version 5.26, 17 May 2023, by LemonInTheDark
Modified the library action table to fit ckeys properly, and to properly store ips.

```sql
 ALTER TABLE `library_action` MODIFY COLUMN `ckey` varchar(32) NOT NULL;
 ALTER TABLE `library_action` MODIFY COLUMN `ip_addr` int(10) unsigned NOT NULL;
```

---

