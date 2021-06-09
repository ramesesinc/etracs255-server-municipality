CREATE DATABASE `queue` CHARACTER SET utf8;

USE `queue`;

--
-- TABLE STRUCTURES 
--

CREATE TABLE `queue_announcement` ( 
   `objid` varchar(50) NOT NULL, 
   `state` varchar(25) NULL, 
   `dtfiled` datetime NULL, 
   `name` varchar(50) NULL, 
   `content` text NULL, 
   `dtexpiry` datetime NULL,
   CONSTRAINT `pk_queue_announcement` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `queue_counter` ( 
   `objid` varchar(50) NOT NULL, 
   `code` varchar(2) NULL,
   CONSTRAINT `pk_queue_counter` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE UNIQUE INDEX `uix_code` ON `queue_counter` (`code`)
;


CREATE TABLE `queue_counter_section` ( 
   `counterid` varchar(50) NOT NULL, 
   `sectionid` varchar(50) NOT NULL,
   CONSTRAINT `pk_queue_counter_section` PRIMARY KEY (`counterid`, `sectionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `fk_queue_counter_section_sectionid` ON `queue_counter_section` (`sectionid`)
;


CREATE TABLE `queue_group` ( 
   `objid` varchar(50) NOT NULL, 
   `title` varchar(255) NOT NULL,
   CONSTRAINT `pk_queue_group` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `queue_number` ( 
   `objid` varchar(50) NOT NULL, 
   `groupid` varchar(50) NOT NULL, 
   `sectionid` varchar(50) NOT NULL, 
   `seriesno` int NOT NULL, 
   `txndate` datetime NOT NULL, 
   `state` varchar(25) NOT NULL, 
   `ticketno` varchar(20) NULL,
   CONSTRAINT `pk_queue_number` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `fk_queue_number_groupid` ON `queue_number` (`groupid`)
;
CREATE INDEX `fk_queue_number_sectionid` ON `queue_number` (`sectionid`)
;
CREATE INDEX `ix_ticketno` ON `queue_number` (`ticketno`)
;


CREATE TABLE `queue_number_archive` ( 
   `objid` varchar(50) NOT NULL, 
   `dtfiled` datetime NOT NULL, 
   `state` varchar(25) NOT NULL, 
   `ticketno` varchar(20) NOT NULL, 
   `group_objid` varchar(50) NOT NULL, 
   `group_title` varchar(255) NULL, 
   `section_objid` varchar(50) NOT NULL, 
   `section_title` varchar(255) NULL, 
   `startdate` datetime NULL, 
   `enddate` datetime NULL, 
   `servedby_objid` varchar(50) NULL, 
   `servedby_name` varchar(180) NULL, 
   `counter_objid` varchar(50) NULL, 
   `counter_code` varchar(10) NULL,
   CONSTRAINT `pk_queue_number_archive` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_counter_code` ON `queue_number_archive` (`counter_code`)
;
CREATE INDEX `ix_counter_objid` ON `queue_number_archive` (`counter_objid`)
;
CREATE INDEX `ix_dtfiled` ON `queue_number_archive` (`dtfiled`)
;
CREATE INDEX `ix_enddate` ON `queue_number_archive` (`enddate`)
;
CREATE INDEX `ix_group_objid` ON `queue_number_archive` (`group_objid`)
;
CREATE INDEX `ix_section_objid` ON `queue_number_archive` (`section_objid`)
;
CREATE INDEX `ix_servedby_objid` ON `queue_number_archive` (`servedby_objid`)
;
CREATE INDEX `ix_startdate` ON `queue_number_archive` (`startdate`)
;
CREATE INDEX `ix_ticketno` ON `queue_number_archive` (`ticketno`)
;


CREATE TABLE `queue_number_counter` ( 
   `objid` varchar(50) NOT NULL, 
   `counterid` varchar(50) NOT NULL,
   CONSTRAINT `pk_queue_number_counter` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE UNIQUE INDEX `uix_counterid` ON `queue_number_counter` (`counterid`)
;


CREATE TABLE `queue_section` ( 
   `objid` varchar(50) NOT NULL, 
   `groupid` varchar(50) NOT NULL, 
   `title` varchar(255) NOT NULL, 
   `currentseries` int NOT NULL, 
   `prefix` varchar(1) NULL, 
   `sortorder` int NOT NULL, 
   `dtexpiry` datetime NULL, 
   `lockid` varchar(50) NULL,
   CONSTRAINT `pk_queue_section` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `fk_queue_section_groupid` ON `queue_section` (`groupid`)
;
CREATE INDEX `ix_dtexpiry` ON `queue_section` (`dtexpiry`)
;



--
-- FOREIGN KEYS 
--

ALTER TABLE `queue_counter_section` ADD CONSTRAINT `fk_queue_counter_section_counterid` 
   FOREIGN KEY (`counterid`) REFERENCES `queue_counter` (`objid`)
;
ALTER TABLE `queue_counter_section` ADD CONSTRAINT `fk_queue_counter_section_sectionid` 
   FOREIGN KEY (`sectionid`) REFERENCES `queue_section` (`objid`)
;


ALTER TABLE `queue_number` ADD CONSTRAINT `fk_queue_number_groupid` 
   FOREIGN KEY (`groupid`) REFERENCES `queue_group` (`objid`)
;
ALTER TABLE `queue_number` ADD CONSTRAINT `fk_queue_number_sectionid` 
   FOREIGN KEY (`sectionid`) REFERENCES `queue_section` (`objid`)
;


ALTER TABLE `queue_number_counter` ADD CONSTRAINT `fk_queue_number_counter` 
   FOREIGN KEY (`counterid`) REFERENCES `queue_counter` (`objid`)
;
ALTER TABLE `queue_number_counter` ADD CONSTRAINT `fk_queue_number_counter_objid` 
   FOREIGN KEY (`objid`) REFERENCES `queue_number` (`objid`)
;


ALTER TABLE `queue_section` ADD CONSTRAINT `fk_queue_section_groupid` 
   FOREIGN KEY (`groupid`) REFERENCES `queue_group` (`objid`)
;
ALTER TABLE `queue_section` ADD CONSTRAINT `queue_section_ibfk_1` 
   FOREIGN KEY (`groupid`) REFERENCES `queue_group` (`objid`)
;
