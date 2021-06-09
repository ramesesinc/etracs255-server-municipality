CREATE DATABASE `etracs_notification` CHARACTER SET utf8;

USE `etracs_notification`;

--
-- TABLE STRUCTURES 
--

CREATE TABLE `async_notification` ( 
   `objid` varchar(50) NOT NULL, 
   `dtfiled` datetime NULL, 
   `messagetype` varchar(50) NULL, 
   `data` longtext NULL,
   CONSTRAINT `pk_async_notification` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtfiled` ON `async_notification` (`dtfiled`)
;


CREATE TABLE `async_notification_delivered` ( 
   `objid` varchar(50) NOT NULL, 
   `dtfiled` datetime NULL, 
   `refid` varchar(50) NULL,
   CONSTRAINT `pk_async_notification_delivered` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtfiled` ON `async_notification_delivered` (`dtfiled`)
;
CREATE INDEX `ix_refid` ON `async_notification_delivered` (`refid`)
;


CREATE TABLE `async_notification_failed` ( 
   `objid` varchar(50) NOT NULL, 
   `dtfiled` datetime NULL, 
   `refid` varchar(50) NULL, 
   `errormessage` text NULL,
   CONSTRAINT `pk_async_notification_failed` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtfiled` ON `async_notification_failed` (`dtfiled`)
;
CREATE INDEX `ix_refid` ON `async_notification_failed` (`refid`)
;


CREATE TABLE `async_notification_pending` ( 
   `objid` varchar(50) NOT NULL, 
   `dtretry` datetime NULL, 
   `retrycount` smallint NULL DEFAULT '0',
   CONSTRAINT `pk_async_notification_pending` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `async_notification_processing` ( 
   `objid` varchar(50) NOT NULL, 
   `dtfiled` datetime NULL,
   CONSTRAINT `pk_async_notification_processing` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `cloud_notification` ( 
   `objid` varchar(50) NOT NULL, 
   `dtfiled` datetime NULL, 
   `sender` varchar(160) NULL, 
   `senderid` varchar(50) NULL, 
   `groupid` varchar(32) NULL, 
   `message` varchar(255) NULL, 
   `messagetype` varchar(50) NULL, 
   `filetype` varchar(50) NULL, 
   `channel` varchar(50) NULL, 
   `channelgroup` varchar(50) NULL, 
   `origin` varchar(50) NULL, 
   `data` longtext NULL, 
   `attachmentcount` smallint NULL DEFAULT '0',
   CONSTRAINT `pk_cloud_notification` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtfiled` ON `cloud_notification` (`dtfiled`)
;
CREATE INDEX `ix_groupid` ON `cloud_notification` (`groupid`)
;
CREATE INDEX `ix_objid` ON `cloud_notification` (`objid`)
;
CREATE INDEX `ix_origin` ON `cloud_notification` (`origin`)
;
CREATE INDEX `ix_senderid` ON `cloud_notification` (`senderid`)
;


CREATE TABLE `cloud_notification_attachment` ( 
   `objid` varchar(50) NOT NULL, 
   `parentid` varchar(50) NOT NULL, 
   `dtfiled` datetime NULL, 
   `indexno` smallint NULL, 
   `name` varchar(50) NULL, 
   `type` varchar(50) NULL, 
   `description` varchar(255) NULL, 
   `fileid` varchar(50) NULL,
   CONSTRAINT `pk_cloud_notification_attachment` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtfiled` ON `cloud_notification_attachment` (`dtfiled`)
;
CREATE INDEX `ix_fileid` ON `cloud_notification_attachment` (`fileid`)
;
CREATE INDEX `ix_name` ON `cloud_notification_attachment` (`name`)
;
CREATE INDEX `ix_parentid` ON `cloud_notification_attachment` (`parentid`)
;


CREATE TABLE `cloud_notification_delivered` ( 
   `objid` varchar(50) NOT NULL, 
   `dtfiled` datetime NULL, 
   `traceid` varchar(50) NULL, 
   `tracetime` datetime NULL,
   CONSTRAINT `pk_cloud_notification_delivered` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtfiled` ON `cloud_notification_delivered` (`dtfiled`)
;
CREATE INDEX `ix_traceid` ON `cloud_notification_delivered` (`traceid`)
;
CREATE INDEX `ix_tracetime` ON `cloud_notification_delivered` (`tracetime`)
;


CREATE TABLE `cloud_notification_failed` ( 
   `objid` varchar(50) NOT NULL, 
   `dtfiled` datetime NULL, 
   `refid` varchar(50) NULL, 
   `reftype` varchar(25) NULL, 
   `errormessage` text NULL,
   CONSTRAINT `pk_cloud_notification_failed` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtfiled` ON `cloud_notification_failed` (`dtfiled`)
;
CREATE INDEX `ix_refid` ON `cloud_notification_failed` (`refid`)
;


CREATE TABLE `cloud_notification_pending` ( 
   `objid` varchar(50) NOT NULL, 
   `dtfiled` datetime NULL, 
   `dtexpiry` datetime NULL, 
   `dtretry` datetime NULL, 
   `type` varchar(25) NULL, 
   `state` varchar(50) NULL,
   CONSTRAINT `pk_cloud_notification_pending` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtexpiry` ON `cloud_notification_pending` (`dtexpiry`)
;
CREATE INDEX `ix_dtfiled` ON `cloud_notification_pending` (`dtfiled`)
;
CREATE INDEX `ix_dtretry` ON `cloud_notification_pending` (`dtretry`)
;


CREATE TABLE `cloud_notification_received` ( 
   `objid` varchar(50) NOT NULL, 
   `dtfiled` datetime NULL, 
   `traceid` varchar(50) NULL, 
   `tracetime` datetime NULL,
   CONSTRAINT `pk_cloud_notification_received` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtfiled` ON `cloud_notification_received` (`dtfiled`)
;
CREATE INDEX `ix_traceid` ON `cloud_notification_received` (`traceid`)
;
CREATE INDEX `ix_tracetime` ON `cloud_notification_received` (`tracetime`)
;


CREATE TABLE `notification` ( 
   `objid` varchar(50) NOT NULL, 
   `dtfiled` datetime NOT NULL, 
   `sender` varchar(160) NOT NULL, 
   `senderid` varchar(50) NOT NULL, 
   `groupid` varchar(32) NULL, 
   `message` varchar(255) NULL, 
   `messagetype` varchar(50) NULL, 
   `filetype` varchar(50) NULL, 
   `channel` varchar(50) NOT NULL, 
   `channelgroup` varchar(50) NOT NULL, 
   `origin` varchar(50) NOT NULL, 
   `origintype` varchar(25) NULL, 
   `chunksize` int NOT NULL, 
   `chunkcount` int NOT NULL, 
   `txnid` varchar(50) NULL, 
   `txnno` varchar(50) NULL,
   CONSTRAINT `pk_notification` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtfiled` ON `notification` (`dtfiled`)
;
CREATE INDEX `ix_groupid` ON `notification` (`groupid`)
;
CREATE INDEX `ix_senderid` ON `notification` (`senderid`)
;
CREATE INDEX `ix_txnid` ON `notification` (`txnid`)
;
CREATE INDEX `ix_txnno` ON `notification` (`txnno`)
;


CREATE TABLE `notification_async` ( 
   `objid` varchar(50) NOT NULL,
   CONSTRAINT `pk_notification_async` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `notification_async_pending` ( 
   `objid` varchar(50) NOT NULL,
   CONSTRAINT `pk_notification_async_pending` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `notification_data` ( 
   `objid` varchar(50) NOT NULL, 
   `parentid` varchar(50) NOT NULL, 
   `indexno` int NOT NULL, 
   `content` mediumtext NOT NULL, 
   `contentlength` int NOT NULL,
   CONSTRAINT `pk_notification_data` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_parentid` ON `notification_data` (`parentid`)
;


CREATE TABLE `notification_fordownload` ( 
   `objid` varchar(50) NOT NULL, 
   `indexno` int NOT NULL,
   CONSTRAINT `pk_notification_fordownload` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `notification_forprocess` ( 
   `objid` varchar(50) NOT NULL, 
   `indexno` int NULL,
   CONSTRAINT `pk_notification_forprocess` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `notification_pending` ( 
   `objid` varchar(50) NOT NULL, 
   `indexno` int NOT NULL,
   CONSTRAINT `pk_notification_pending` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `notification_setting` ( 
   `objid` varchar(50) NOT NULL, 
   `value` varchar(255) NULL,
   CONSTRAINT `pk_notification_setting` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `sms_inbox` ( 
   `objid` varchar(50) NOT NULL, 
   `state` varchar(25) NULL, 
   `dtfiled` datetime NULL, 
   `channel` varchar(25) NULL, 
   `keyword` varchar(50) NULL, 
   `phoneno` varchar(15) NULL, 
   `message` varchar(160) NULL,
   CONSTRAINT `pk_sms_inbox` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtfiled` ON `sms_inbox` (`dtfiled`)
;
CREATE INDEX `ix_phoneno` ON `sms_inbox` (`phoneno`)
;


CREATE TABLE `sms_inbox_pending` ( 
   `objid` varchar(50) NOT NULL, 
   `dtexpiry` datetime NULL, 
   `dtretry` datetime NULL, 
   `retrycount` smallint NULL DEFAULT '0',
   CONSTRAINT `pk_sms_inbox_pending` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtexpiry` ON `sms_inbox_pending` (`dtexpiry`)
;
CREATE INDEX `ix_dtretry` ON `sms_inbox_pending` (`dtretry`)
;


CREATE TABLE `sms_outbox` ( 
   `objid` varchar(50) NOT NULL, 
   `state` varchar(25) NULL, 
   `dtfiled` datetime NULL, 
   `refid` varchar(50) NULL, 
   `phoneno` varchar(15) NULL, 
   `message` text NULL, 
   `creditcount` smallint NULL DEFAULT '0', 
   `remarks` varchar(160) NULL, 
   `dtsend` datetime NULL, 
   `traceid` varchar(100) NULL,
   CONSTRAINT `pk_sms_outbox` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtfiled` ON `sms_outbox` (`dtfiled`)
;
CREATE INDEX `ix_dtsend` ON `sms_outbox` (`dtsend`)
;
CREATE INDEX `ix_phoneno` ON `sms_outbox` (`phoneno`)
;
CREATE INDEX `ix_refid` ON `sms_outbox` (`refid`)
;
CREATE INDEX `ix_traceid` ON `sms_outbox` (`traceid`)
;


CREATE TABLE `sms_outbox_pending` ( 
   `objid` varchar(50) NOT NULL, 
   `dtexpiry` datetime NULL, 
   `dtretry` datetime NULL, 
   `retrycount` smallint NULL DEFAULT '0',
   CONSTRAINT `pk_sms_outbox_pending` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtexpiry` ON `sms_outbox_pending` (`dtexpiry`)
;
CREATE INDEX `ix_dtretry` ON `sms_outbox_pending` (`dtretry`)
;


CREATE TABLE `sys_notification` ( 
   `notificationid` varchar(50) NOT NULL, 
   `objid` varchar(50) NULL, 
   `dtfiled` datetime NULL, 
   `sender` varchar(160) NULL, 
   `senderid` varchar(50) NULL, 
   `recipientid` varchar(50) NULL, 
   `recipienttype` varchar(50) NULL, 
   `message` varchar(255) NULL, 
   `filetype` varchar(50) NULL, 
   `data` longtext NULL, 
   `tag` varchar(255) NULL,
   CONSTRAINT `pk_sys_notification` PRIMARY KEY (`notificationid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtfiled` ON `sys_notification` (`dtfiled`)
;
CREATE INDEX `ix_objid` ON `sys_notification` (`objid`)
;
CREATE INDEX `ix_recipientid` ON `sys_notification` (`recipientid`)
;
CREATE INDEX `ix_recipienttype` ON `sys_notification` (`recipienttype`)
;
CREATE INDEX `ix_senderid` ON `sys_notification` (`senderid`)
;
CREATE INDEX `ix_tag` ON `sys_notification` (`tag`)
;
