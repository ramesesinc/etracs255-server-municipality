CREATE DATABASE `eor` CHARACTER SET utf8;

USE `eor`;

--
-- TABLE STRUCTURES 
--

CREATE TABLE `eor` ( 
   `objid` varchar(50) NOT NULL, 
   `receiptno` varchar(50) NULL, 
   `receiptdate` date NULL, 
   `txndate` datetime NULL, 
   `state` varchar(10) NULL, 
   `partnerid` varchar(50) NULL, 
   `txntype` varchar(20) NULL, 
   `traceid` varchar(50) NULL, 
   `tracedate` datetime NULL, 
   `refid` varchar(50) NULL, 
   `paidby` varchar(255) NULL, 
   `paidbyaddress` varchar(255) NULL, 
   `payer_objid` varchar(50) NULL, 
   `paymethod` varchar(20) NULL, 
   `paymentrefid` varchar(50) NULL, 
   `remittanceid` varchar(50) NULL, 
   `remarks` varchar(255) NULL, 
   `amount` decimal(16,4) NULL, 
   `lockid` varchar(50) NULL,
   CONSTRAINT `pk_eor` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE UNIQUE INDEX `uix_eor_receiptno` ON `eor` (`receiptno`)
;
CREATE INDEX `ix_lockid` ON `eor` (`lockid`)
;
CREATE INDEX `ix_paidby` ON `eor` (`paidby`)
;
CREATE INDEX `ix_partnerid` ON `eor` (`partnerid`)
;
CREATE INDEX `ix_payer_objid` ON `eor` (`payer_objid`)
;
CREATE INDEX `ix_paymentrefid` ON `eor` (`paymentrefid`)
;
CREATE INDEX `ix_receiptdate` ON `eor` (`receiptdate`)
;
CREATE INDEX `ix_refid` ON `eor` (`refid`)
;
CREATE INDEX `ix_remittanceid` ON `eor` (`remittanceid`)
;
CREATE INDEX `ix_traceid` ON `eor` (`traceid`)
;
CREATE INDEX `ix_txndate` ON `eor` (`txndate`)
;


CREATE TABLE `eor_for_email` ( 
   `objid` varchar(50) NOT NULL, 
   `txndate` datetime NULL, 
   `email` varchar(255) NULL, 
   `mobileno` varchar(50) NULL, 
   `state` int NULL, 
   `dtsent` datetime NULL, 
   `errmsg` varchar(255) NULL,
   CONSTRAINT `pk_eor_for_email` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `eor_item` ( 
   `objid` varchar(50) NOT NULL, 
   `parentid` varchar(50) NULL, 
   `item_objid` varchar(50) NULL, 
   `item_code` varchar(100) NULL, 
   `item_title` varchar(100) NULL, 
   `amount` decimal(16,4) NULL, 
   `remarks` varchar(255) NULL, 
   `item_fund_objid` varchar(50) NULL,
   CONSTRAINT `pk_eor_item` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `fk_eoritem_eor` ON `eor_item` (`parentid`)
;
CREATE INDEX `ix_item_fund_objid` ON `eor_item` (`item_fund_objid`)
;
CREATE INDEX `ix_item_objid` ON `eor_item` (`item_objid`)
;


CREATE TABLE `eor_manual_post` ( 
   `objid` varchar(50) NOT NULL, 
   `state` varchar(10) NULL, 
   `paymentorderno` varchar(50) NULL, 
   `amount` decimal(16,4) NULL, 
   `txntype` varchar(50) NULL, 
   `paymentpartnerid` varchar(50) NULL, 
   `traceid` varchar(50) NULL, 
   `tracedate` datetime NULL, 
   `reason` tinytext NULL, 
   `createdby_objid` varchar(50) NULL, 
   `createdby_name` varchar(255) NULL, 
   `dtcreated` datetime NULL,
   CONSTRAINT `pk_eor_manual_post` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE UNIQUE INDEX `uix_eor_manual_post_paymentorderno` ON `eor_manual_post` (`paymentorderno`)
;


CREATE TABLE `eor_number` ( 
   `objid` varchar(255) NOT NULL, 
   `currentno` int NOT NULL DEFAULT '1',
   CONSTRAINT `pk_eor_number` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `eor_payment_error` ( 
   `objid` varchar(50) NOT NULL, 
   `txndate` datetime NOT NULL, 
   `paymentrefid` varchar(50) NOT NULL, 
   `errmsg` longtext NOT NULL, 
   `errdetail` longtext NULL, 
   `errcode` int NULL, 
   `laststate` int NULL,
   CONSTRAINT `pk_eor_payment_error` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE UNIQUE INDEX `ix_paymentrefid` ON `eor_payment_error` (`paymentrefid`)
;
CREATE INDEX `ix_txndate` ON `eor_payment_error` (`txndate`)
;


CREATE TABLE `eor_paymentorder` ( 
   `objid` varchar(50) NOT NULL, 
   `txndate` datetime NULL, 
   `txntype` varchar(50) NULL, 
   `txntypename` varchar(100) NULL, 
   `payer_objid` varchar(50) NULL, 
   `payer_name` text NULL, 
   `paidby` text NULL, 
   `paidbyaddress` varchar(150) NULL, 
   `particulars` varchar(500) NULL, 
   `amount` decimal(16,2) NULL, 
   `expirydate` date NULL, 
   `refid` varchar(50) NULL, 
   `refno` varchar(50) NULL, 
   `info` text NULL, 
   `origin` varchar(100) NULL, 
   `controlno` varchar(50) NULL, 
   `locationid` varchar(25) NULL, 
   `items` mediumtext NULL, 
   `state` varchar(32) NULL, 
   `email` varchar(255) NULL, 
   `mobileno` varchar(25) NULL,
   CONSTRAINT `pk_eor_paymentorder` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_state` ON `eor_paymentorder` (`state`)
;


CREATE TABLE `eor_paymentorder_cancelled` ( 
   `objid` varchar(50) NOT NULL, 
   `txndate` datetime NULL, 
   `txntype` varchar(50) NULL, 
   `txntypename` varchar(100) NULL, 
   `payer_objid` varchar(50) NULL, 
   `payer_name` longtext NULL, 
   `paidby` longtext NULL, 
   `paidbyaddress` varchar(150) NULL, 
   `particulars` text NULL, 
   `amount` decimal(16,2) NULL, 
   `expirydate` date NULL, 
   `refid` varchar(50) NULL, 
   `refno` varchar(50) NULL, 
   `info` longtext NULL, 
   `origin` varchar(100) NULL, 
   `controlno` varchar(50) NULL, 
   `locationid` varchar(25) NULL, 
   `items` longtext NULL, 
   `state` varchar(10) NULL, 
   `email` varchar(255) NULL, 
   `mobileno` varchar(50) NULL,
   CONSTRAINT `pk_eor_paymentorder_cancelled` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_controlno` ON `eor_paymentorder_cancelled` (`controlno`)
;
CREATE INDEX `ix_expirydate` ON `eor_paymentorder_cancelled` (`expirydate`)
;
CREATE INDEX `ix_locationid` ON `eor_paymentorder_cancelled` (`locationid`)
;
CREATE INDEX `ix_payer_name` ON `eor_paymentorder_cancelled` (`payer_name`)
;
CREATE INDEX `ix_payer_objid` ON `eor_paymentorder_cancelled` (`payer_objid`)
;
CREATE INDEX `ix_refid` ON `eor_paymentorder_cancelled` (`refid`)
;
CREATE INDEX `ix_refno` ON `eor_paymentorder_cancelled` (`refno`)
;
CREATE INDEX `ix_txndate` ON `eor_paymentorder_cancelled` (`txndate`)
;
CREATE INDEX `ix_txntype` ON `eor_paymentorder_cancelled` (`txntype`)
;


CREATE TABLE `eor_paymentorder_paid` ( 
   `objid` varchar(50) NOT NULL, 
   `txndate` datetime NULL, 
   `txntype` varchar(50) NULL, 
   `txntypename` varchar(100) NULL, 
   `payer_objid` varchar(50) NULL, 
   `payer_name` longtext NULL, 
   `paidby` longtext NULL, 
   `paidbyaddress` varchar(150) NULL, 
   `particulars` text NULL, 
   `amount` decimal(16,2) NULL, 
   `expirydate` date NULL, 
   `refid` varchar(50) NULL, 
   `refno` varchar(50) NULL, 
   `info` longtext NULL, 
   `origin` varchar(100) NULL, 
   `controlno` varchar(50) NULL, 
   `locationid` varchar(25) NULL, 
   `items` longtext NULL, 
   `state` varchar(10) NULL, 
   `email` varchar(255) NULL, 
   `mobileno` varchar(50) NULL,
   CONSTRAINT `pk_eor_paymentorder_paid` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_controlno` ON `eor_paymentorder_paid` (`controlno`)
;
CREATE INDEX `ix_expirydate` ON `eor_paymentorder_paid` (`expirydate`)
;
CREATE INDEX `ix_locationid` ON `eor_paymentorder_paid` (`locationid`)
;
CREATE INDEX `ix_payer_name` ON `eor_paymentorder_paid` (`payer_name`)
;
CREATE INDEX `ix_payer_objid` ON `eor_paymentorder_paid` (`payer_objid`)
;
CREATE INDEX `ix_refid` ON `eor_paymentorder_paid` (`refid`)
;
CREATE INDEX `ix_refno` ON `eor_paymentorder_paid` (`refno`)
;
CREATE INDEX `ix_txndate` ON `eor_paymentorder_paid` (`txndate`)
;
CREATE INDEX `ix_txntype` ON `eor_paymentorder_paid` (`txntype`)
;


CREATE TABLE `eor_remittance` ( 
   `objid` varchar(50) NOT NULL, 
   `state` varchar(50) NULL, 
   `controlno` varchar(50) NULL, 
   `partnerid` varchar(50) NULL, 
   `controldate` date NULL, 
   `dtcreated` datetime NULL, 
   `createdby_objid` varchar(50) NULL, 
   `createdby_name` varchar(255) NULL, 
   `amount` decimal(16,4) NULL, 
   `dtposted` datetime NULL, 
   `postedby_objid` varchar(50) NULL, 
   `postedby_name` varchar(255) NULL, 
   `lockid` varchar(50) NULL,
   CONSTRAINT `pk_eor_remittance` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `eor_remittance_fund` ( 
   `objid` varchar(100) NOT NULL, 
   `remittanceid` varchar(50) NULL, 
   `fund_objid` varchar(50) NULL, 
   `fund_code` varchar(50) NULL, 
   `fund_title` varchar(255) NULL, 
   `amount` decimal(16,4) NULL, 
   `bankaccount_objid` varchar(50) NULL, 
   `bankaccount_title` varchar(255) NULL, 
   `bankaccount_bank_name` varchar(255) NULL, 
   `validation_refno` varchar(50) NULL, 
   `validation_refdate` date NULL,
   CONSTRAINT `pk_eor_remittance_fund` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `fk_eor_remittance_fund_remittance` ON `eor_remittance_fund` (`remittanceid`)
;


CREATE TABLE `eor_share` ( 
   `objid` varchar(50) NOT NULL, 
   `parentid` varchar(50) NOT NULL, 
   `refitem_objid` varchar(50) NULL, 
   `refitem_code` varchar(25) NULL, 
   `refitem_title` varchar(255) NULL, 
   `payableitem_objid` varchar(50) NULL, 
   `payableitem_code` varchar(25) NULL, 
   `payableitem_title` varchar(255) NULL, 
   `amount` decimal(16,4) NULL, 
   `share` decimal(16,2) NULL, 
   `receiptitemid` varchar(50) NULL,
   CONSTRAINT `pk_eor_share` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `epayment_plugin` ( 
   `objid` varchar(50) NOT NULL, 
   `connection` varchar(50) NULL, 
   `servicename` varchar(255) NULL,
   CONSTRAINT `pk_epayment_plugin` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `jev` ( 
   `objid` varchar(150) NOT NULL, 
   `jevno` varchar(50) NULL, 
   `jevdate` date NULL, 
   `fundid` varchar(50) NULL, 
   `dtposted` datetime NULL, 
   `txntype` varchar(50) NULL, 
   `refid` varchar(50) NULL, 
   `refno` varchar(50) NULL, 
   `reftype` varchar(50) NULL, 
   `amount` decimal(16,4) NULL, 
   `state` varchar(32) NULL, 
   `postedby_objid` varchar(50) NULL, 
   `postedby_name` varchar(255) NULL, 
   `verifiedby_objid` varchar(50) NULL, 
   `verifiedby_name` varchar(255) NULL, 
   `dtverified` datetime NULL, 
   `batchid` varchar(50) NULL, 
   `refdate` date NULL,
   CONSTRAINT `pk_jev` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_batchid` ON `jev` (`batchid`)
;
CREATE INDEX `ix_dtposted` ON `jev` (`dtposted`)
;
CREATE INDEX `ix_dtverified` ON `jev` (`dtverified`)
;
CREATE INDEX `ix_fundid` ON `jev` (`fundid`)
;
CREATE INDEX `ix_jevdate` ON `jev` (`jevdate`)
;
CREATE INDEX `ix_jevno` ON `jev` (`jevno`)
;
CREATE INDEX `ix_postedby_objid` ON `jev` (`postedby_objid`)
;
CREATE INDEX `ix_refdate` ON `jev` (`refdate`)
;
CREATE INDEX `ix_refid` ON `jev` (`refid`)
;
CREATE INDEX `ix_refno` ON `jev` (`refno`)
;
CREATE INDEX `ix_reftype` ON `jev` (`reftype`)
;
CREATE INDEX `ix_verifiedby_objid` ON `jev` (`verifiedby_objid`)
;


CREATE TABLE `jevitem` ( 
   `objid` varchar(150) NOT NULL, 
   `jevid` varchar(150) NULL, 
   `accttype` varchar(50) NULL, 
   `acctid` varchar(50) NULL, 
   `acctcode` varchar(32) NULL, 
   `acctname` varchar(255) NULL, 
   `dr` decimal(16,4) NULL, 
   `cr` decimal(16,4) NULL, 
   `particulars` varchar(255) NULL, 
   `itemrefid` varchar(255) NULL,
   CONSTRAINT `pk_jevitem` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_acctcode` ON `jevitem` (`acctcode`)
;
CREATE INDEX `ix_acctid` ON `jevitem` (`acctid`)
;
CREATE INDEX `ix_acctname` ON `jevitem` (`acctname`)
;
CREATE INDEX `ix_itemrefid` ON `jevitem` (`itemrefid`)
;
CREATE INDEX `ix_jevid` ON `jevitem` (`jevid`)
;
CREATE INDEX `ix_ledgertype` ON `jevitem` (`accttype`)
;


CREATE TABLE `paymentpartner` ( 
   `objid` varchar(50) NOT NULL, 
   `code` varchar(50) NULL, 
   `name` varchar(100) NULL, 
   `branch` varchar(255) NULL, 
   `contact` varchar(255) NULL, 
   `mobileno` varchar(32) NULL, 
   `phoneno` varchar(32) NULL, 
   `email` varchar(255) NULL, 
   `indexno` varchar(3) NULL,
   CONSTRAINT `pk_paymentpartner` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `sys_email_queue` ( 
   `objid` varchar(50) NOT NULL, 
   `refid` varchar(50) NOT NULL, 
   `state` int NOT NULL, 
   `reportid` varchar(50) NULL, 
   `dtsent` datetime NOT NULL, 
   `to` varchar(255) NOT NULL, 
   `subject` varchar(255) NOT NULL, 
   `message` text NOT NULL, 
   `errmsg` longtext NULL, 
   `connection` varchar(50) NULL,
   CONSTRAINT `pk_sys_email_queue` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE INDEX `ix_dtsent` ON `sys_email_queue` (`dtsent`)
;
CREATE INDEX `ix_refid` ON `sys_email_queue` (`refid`)
;
CREATE INDEX `ix_reportid` ON `sys_email_queue` (`reportid`)
;
CREATE INDEX `ix_state` ON `sys_email_queue` (`state`)
;


CREATE TABLE `sys_email_template` ( 
   `objid` varchar(50) NOT NULL, 
   `subject` varchar(255) NOT NULL, 
   `message` longtext NOT NULL,
   CONSTRAINT `pk_sys_email_template` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `unpostedpayment` ( 
   `objid` varchar(50) NOT NULL, 
   `txndate` datetime NOT NULL, 
   `txntype` varchar(50) NOT NULL, 
   `txntypename` varchar(150) NOT NULL, 
   `paymentrefid` varchar(50) NOT NULL, 
   `amount` decimal(16,2) NOT NULL, 
   `orgcode` varchar(20) NOT NULL, 
   `partnerid` varchar(50) NOT NULL, 
   `traceid` varchar(100) NOT NULL, 
   `tracedate` datetime NOT NULL, 
   `refno` varchar(50) NULL, 
   `origin` varchar(50) NULL, 
   `paymentorder` longtext NULL, 
   `errmsg` text NOT NULL, 
   `errdetail` longtext NULL,
   CONSTRAINT `pk_unpostedpayment` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE UNIQUE INDEX `ix_paymentrefid` ON `unpostedpayment` (`paymentrefid`)
;
CREATE INDEX `ix_origin` ON `unpostedpayment` (`origin`)
;
CREATE INDEX `ix_partnerid` ON `unpostedpayment` (`partnerid`)
;
CREATE INDEX `ix_refno` ON `unpostedpayment` (`refno`)
;
CREATE INDEX `ix_tracedate` ON `unpostedpayment` (`tracedate`)
;
CREATE INDEX `ix_traceid` ON `unpostedpayment` (`traceid`)
;
CREATE INDEX `ix_txndate` ON `unpostedpayment` (`txndate`)
;
CREATE INDEX `ix_txntype` ON `unpostedpayment` (`txntype`)
;



--
-- FOREIGN KEYS 
--

ALTER TABLE `eor` ADD CONSTRAINT `fk_eor_remittanceid` 
   FOREIGN KEY (`remittanceid`) REFERENCES `eor_remittance` (`objid`)
;


ALTER TABLE `eor_item` ADD CONSTRAINT `fk_eoritem_eor` 
   FOREIGN KEY (`parentid`) REFERENCES `eor` (`objid`)
;


ALTER TABLE `eor_remittance_fund` ADD CONSTRAINT `fk_eor_remittance_fund_remittance` 
   FOREIGN KEY (`remittanceid`) REFERENCES `eor_remittance` (`objid`)
;


ALTER TABLE `jevitem` ADD CONSTRAINT `fk_jevitem_jevid` 
   FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`)
;


INSERT INTO `paymentpartner` (`objid`, `code`, `name`, `branch`, `contact`, `mobileno`, `phoneno`, `email`, `indexno`) 
VALUES ('DBP', '101', 'DEVELOPMENT BANK OF THE PHILIPPINES', NULL, NULL, NULL, NULL, NULL, '101');

INSERT INTO `paymentpartner` (`objid`, `code`, `name`, `branch`, `contact`, `mobileno`, `phoneno`, `email`, `indexno`) 
VALUES ('LBP', '102', 'LAND BANK OF THE PHILIPPINES', NULL, NULL, NULL, NULL, NULL, '102');

INSERT INTO `paymentpartner` (`objid`, `code`, `name`, `branch`, `contact`, `mobileno`, `phoneno`, `email`, `indexno`) 
VALUES ('PAYMAYA', '103', 'PAYMAYA', NULL, NULL, NULL, NULL, NULL, '103');

INSERT INTO `paymentpartner` (`objid`, `code`, `name`, `branch`, `contact`, `mobileno`, `phoneno`, `email`, `indexno`) 
VALUES ('GCASH', '104', 'GCASH', NULL, NULL, NULL, NULL, NULL, '104');
