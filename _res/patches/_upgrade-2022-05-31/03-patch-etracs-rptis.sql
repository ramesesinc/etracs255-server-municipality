alter table assessmentnotice add deliverytype_objid varchar(50)
;

DROP TABLE IF EXISTS `bldgtype_storeyadjustment_bldgkind`
;

CREATE TABLE `bldgtype_storeyadjustment_bldgkind` (
  `objid` varchar(50) NOT NULL,
  `bldgrysettingid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `bldgtypeid` varchar(50) NOT NULL,
  `floorno` int(11) NOT NULL,
  `bldgkindid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_bldgtype_kind_floorno` (`bldgtypeid`,`bldgkindid`,`floorno`),
  KEY `fk_storeyadjustment_bldgkind_bldgrysetting` (`bldgrysettingid`),
  KEY `fk_storeyadjustment_bldgkind_parent` (`parentid`),
  CONSTRAINT `fk_storeyadjustment_bldgkind_bldgrysetting` FOREIGN KEY (`bldgrysettingid`) REFERENCES `bldgrysetting` (`objid`),
  CONSTRAINT `fk_storeyadjustment_bldgkind_bldgtype` FOREIGN KEY (`bldgtypeid`) REFERENCES `bldgtype` (`objid`),
  CONSTRAINT `fk_storeyadjustment_bldgkind_parent` FOREIGN KEY (`parentid`) REFERENCES `bldgtype_storeyadjustment` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



DROP TABLE IF EXISTS `examiner_finding`
;

CREATE TABLE `examiner_finding` (
  `objid` varchar(50) NOT NULL,
  `findings` text,
  `parent_objid` varchar(50) DEFAULT NULL,
  `dtinspected` date DEFAULT NULL,
  `inspectors` varchar(500) DEFAULT NULL,
  `notedby` varchar(100) DEFAULT NULL,
  `notedbytitle` varchar(50) DEFAULT NULL,
  `photos` varchar(255) DEFAULT NULL,
  `recommendations` varchar(500) DEFAULT NULL,
  `inspectedby_objid` varchar(50) DEFAULT NULL,
  `inspectedby_name` varchar(100) DEFAULT NULL,
  `inspectedby_title` varchar(50) DEFAULT NULL,
  `doctype` varchar(50) DEFAULT NULL,
  `txnno` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ix_txnno` (`txnno`),
  KEY `ix_dtinspected` (`dtinspected`) USING BTREE,
  KEY `ix_examiner_finding_inspectedby_objid` (`inspectedby_objid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table memoranda_template add fields text
;

alter table report_rptdelinquency_barangay add idx int
;

drop table if exists rpt_syncdata_item;
drop table if exists rpt_syncdata_forsync;
drop table if exists rpt_syncdata_error;
drop table if exists rpt_syncdata_completed;
drop table if exists rpt_syncdata;
drop table if exists rpt_syncdata_fordownload;
drop table if exists rpt_syncdata_downloaded;

CREATE TABLE `rpt_syncdata_downloaded` (
  `objid` varchar(255) NOT NULL,
  `etag` varchar(64) NOT NULL,
  `error` int(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_error` (`error`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_fordownload` (
  `objid` varchar(255) NOT NULL,
  `etag` varchar(64) NOT NULL,
  `error` int(255) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_error` (`error`) USING BTREE,
  KEY `ix_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_forsync` (
  `objid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `createdby_title` varchar(50) DEFAULT NULL,
  `remote_orgid` varchar(15) DEFAULT NULL,
  `state` varchar(25) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(25) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_error` (
  `objid` varchar(50) NOT NULL,
  `filekey` varchar(1000) NOT NULL,
  `error` text,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `idx` int(11) NOT NULL,
  `info` text,
  `parent` text,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_filekey` (`filekey`(255)) USING BTREE,
  KEY `ix_remote_orgid` (`remote_orgid`) USING BTREE,
  KEY `ix_remote_orgcode` (`remote_orgcode`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `idx` int(11) NOT NULL,
  `info` text,
  `error` text,
  `filekey` varchar(1200) DEFAULT NULL,
  `etag` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  CONSTRAINT `rpt_syncdata_item_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `rpt_syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


drop table if exists rptacknowledgement_item;
drop table if exists rptacknowledgement;

CREATE TABLE `rptacknowledgement` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `txntype_objid` varchar(50) DEFAULT NULL,
  `releasedate` datetime DEFAULT NULL,
  `releasemode` varchar(50) DEFAULT NULL,
  `receivedby` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `pin` varchar(25) DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(150) DEFAULT NULL,
  `createdby_title` varchar(100) DEFAULT NULL,
  `dtchecked` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rptacknowledgement_txnno` (`txnno`),
  KEY `ix_rptacknowledgement_pin` (`pin`),
  KEY `ix_rptacknowledgement_taxpayerid` (`taxpayer_objid`),
  KEY `ix_rptacknowledgement_createdby_objid` (`createdby_objid`),
  KEY `ix_rptacknowledgement_createdby_name` (`createdby_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rptacknowledgement_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `trackingno` varchar(25) DEFAULT NULL,
  `ref_objid` varchar(50) DEFAULT NULL,
  `newfaas_objid` varchar(50) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rptacknowledgement_itemno` (`trackingno`),
  KEY `ix_rptacknowledgement_parentid` (`parent_objid`),
  KEY `ix_rptacknowledgement_item_faasid` (`ref_objid`),
  KEY `ix_rptacknowledgement_item_newfaasid` (`newfaas_objid`),
  CONSTRAINT `fk_rptacknowledgement_item_rptacknowledgement` FOREIGN KEY (`parent_objid`) REFERENCES `rptacknowledgement` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table `rptcertification`  add taskid varchar(50)
;


CREATE TABLE `rptcertification_task` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `refid` varchar(50) DEFAULT NULL,
  `parentprocessid` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `startdate` datetime DEFAULT NULL,
  `enddate` datetime DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  `assignee_name` varchar(100) DEFAULT NULL,
  `assignee_title` varchar(80) DEFAULT NULL,
  `actor_objid` varchar(50) DEFAULT NULL,
  `actor_name` varchar(100) DEFAULT NULL,
  `actor_title` varchar(80) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `signature` longtext,
  `returnedby` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_assignee_objid` (`assignee_objid`) USING BTREE,
  CONSTRAINT `rptcertification_task_ibfk_1` FOREIGN KEY (`refid`) REFERENCES `rptcertification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table `rpttaxclearance`  add reporttype varchar(50)
;

drop TABLE if exists `rpttracking`
;


CREATE TABLE `rpttracking` (
  `objid` varchar(50) NOT NULL,
  `filetype` varchar(50) DEFAULT NULL,
  `trackingno` varchar(25) NOT NULL,
  `dtfiled` datetime DEFAULT NULL,
  `taxpayer_objid` varchar(50) DEFAULT NULL,
  `txntype_objid` varchar(50) DEFAULT NULL,
  `releasedate` datetime DEFAULT NULL,
  `releasemode` varchar(50) DEFAULT NULL,
  `receivedby` varchar(255) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `landcount` int(11) DEFAULT '0',
  `bldgcount` int(11) DEFAULT '0',
  `machcount` int(11) DEFAULT '0',
  `planttreecount` int(11) DEFAULT '0',
  `misccount` int(11) DEFAULT '0',
  `pin` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rpttracking_trackingno` (`trackingno`),
  KEY `ix_rpttracking_receivedby` (`receivedby`),
  KEY `ix_rpttracking_remarks` (`remarks`),
  KEY `ix_rpttracking_pin` (`pin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table rpu add stewardparentrpumasterid varchar(50)
;



drop view if exists vw_report_orc
;


create view vw_report_orc as 
select 
	f.objid,
	f.state,
	e.objid as taxpayerid,
	e.name as taxpayer_name,
	e.address_text as taxpayer_address,
  	o.name as lgu_name,
	o.code as lgu_indexno,
	f.dtapproved,
	r.rputype,
	pc.code as classcode,
	pc.name as classification,
	f.fullpin as pin,
	f.titleno,
	rp.cadastrallotno,
	f.tdno,
	'' as arpno,
	f.prevowner,
	b.name as location,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv, 
	r.totalav,
	case when f.state = 'CURRENT' then '' else 'CANCELLED' end as remarks
from faas f
inner join rpu r on f.rpuid = r.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
inner join propertyclassification pc on r.classification_objid = pc.objid 
inner join entity e on f.taxpayer_objid = e.objid 
inner join sys_org o on rp.lguid = o.objid 
inner join barangay b on rp.barangayid = b.objid 
where f.state in ('CURRENT', 'CANCELLED')
;





DROP TABLE IF EXISTS `cashreceipt_rpt_share_forposting_repost`
;


CREATE TABLE `cashreceipt_rpt_share_forposting_repost` (
  `objid` varchar(50) NOT NULL,
  `rptpaymentid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `receiptdate` date NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_receiptid_rptledgerid` (`receiptid`,`rptledgerid`),
  KEY `fk_rptshare_repost_rptledgerid` (`rptledgerid`),
  KEY `fk_rptshare_repost_cashreceiptid` (`receiptid`),
  CONSTRAINT `fk_rptshare_repost_cashreceipt` FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`),
  CONSTRAINT `fk_rptshare_repost_rptledger` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

update sys_sequence set objid = CONCAT('TDNO-', objid ) where objid REGEXP('^[0-9][0-9]') = 1
;

CREATE TABLE `faas_requested_series` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `series` varchar(255) NOT NULL,
  `requestedby_name` varchar(255) NOT NULL,
  `requestedby_date` date NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `createdby_date` datetime NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_faas_requested_series_sys_sequence` (`parentid`),
  CONSTRAINT `fk_faas_requested_series_sys_sequence` FOREIGN KEY (`parentid`) REFERENCES `sys_sequence` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


drop table if exists rpt_syncdata_item_completed;
drop table if exists rpt_syncdata_completed;
drop table if exists rpt_syncdata_forsync;
drop table if exists rpt_syncdata_fordownload;
drop table if exists rpt_syncdata_error;
drop table if exists rpt_syncdata_item;
drop table if exists rpt_syncdata;

CREATE TABLE `rpt_syncdata` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(25) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `idx` int(11) NOT NULL,
  `info` text,
  `error` text,
  `filekey` varchar(1200) DEFAULT NULL,
  `etag` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  CONSTRAINT `rpt_syncdata_item_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `rpt_syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_forsync` (
  `objid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `createdby_title` varchar(50) DEFAULT NULL,
  `remote_orgid` varchar(15) DEFAULT NULL,
  `state` varchar(25) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_fordownload` (
  `objid` varchar(255) NOT NULL,
  `etag` varchar(64) NOT NULL,
  `error` int(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_error` (`error`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_error` (
  `objid` varchar(50) NOT NULL,
  `filekey` varchar(1000) NOT NULL,
  `error` text,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `idx` int(11) NOT NULL,
  `info` text,
  `parent` text,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_filekey` (`filekey`(255)) USING BTREE,
  KEY `ix_remote_orgid` (`remote_orgid`) USING BTREE,
  KEY `ix_remote_orgcode` (`remote_orgcode`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_completed` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(25) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_item_completed` (
  `objid` varchar(255) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `idx` int(255) DEFAULT NULL,
  `info` text,
  `error` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_remote_orgid` (`parentid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

drop TABLE if exists `cashreceipt_rpt_share_forposting_repost`
;

CREATE TABLE `cashreceipt_rpt_share_forposting_repost` (
  `objid` varchar(100) NOT NULL,
  `rptpaymentid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `receiptdate` date NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `error` int(11) DEFAULT NULL,
  `msg` text,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_receiptid_rptledgerid` (`receiptid`,`rptledgerid`) USING BTREE,
  KEY `fk_rptshare_repost_rptledgerid` (`rptledgerid`) USING BTREE,
  KEY `fk_rptshare_repost_cashreceiptid` (`receiptid`) USING BTREE,
  CONSTRAINT `cashreceipt_rpt_share_forposting_repost_ibfk_1` FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`),
  CONSTRAINT `cashreceipt_rpt_share_forposting_repost_ibfk_2` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

drop TABLE if exists `rpt_syncdata_completed` 
;

CREATE TABLE `rpt_syncdata_completed` (
  `objid` varchar(50) NOT NULL,
  `idx` int,
  `action` varchar(50) ,
  `refid` varchar(50) ,
  `reftype` varchar(50) ,
  `refno` varchar(50) ,
  `parent_orgid` varchar(50) ,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `dtcreated` datetime,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_parent_orgid` (`parent_orgid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table cashreceipt_rpt_share_forposting_repost add receipttype varchar(10)
;

alter table cashreceipt_rpt_share_forposting_repost drop foreign key cashreceipt_rpt_share_forposting_repost_ibfk_1
;


/* MACHUSE: TAXABLE SUPPORT  */

alter table machuse add taxable int
;
update machuse set taxable = 1 where taxable is null
;
create unique index ux_actualuseid_taxable on machuse(machrpuid, actualuse_objid, taxable)
;


/* SYNCDATA: pre-download file */

drop table if exists rpt_syncdata_item_completed;
drop table if exists rpt_syncdata_completed;
drop table if exists rpt_syncdata_item;
drop table if exists rpt_syncdata;
drop table if exists rpt_syncdata_forsync;
drop table if exists rpt_syncdata_fordownload;

CREATE TABLE `rpt_syncdata_forsync` (
  `objid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `createdby_title` varchar(50) DEFAULT NULL,
  `remote_orgid` varchar(15) DEFAULT NULL,
  `state` varchar(25) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_fordownload` (
  `objid` varchar(255) NOT NULL,
  `etag` varchar(64) NOT NULL,
  `error` int(255) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_error` (`error`) USING BTREE,
  KEY `ix_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) NOT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(5) DEFAULT NULL,
  `remote_orgclass` varchar(25) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_orgid` (`orgid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `idx` int(11) NOT NULL,
  `info` text,
  `error` text,
  `filekey` varchar(1200) DEFAULT NULL,
  `etag` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE,
  CONSTRAINT `rpt_syncdata_item_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `rpt_syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_completed` (
  `objid` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(80) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `info` text,
  `dtfiled` datetime DEFAULT NULL,
  `orgid` varchar(50) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(25) DEFAULT NULL,
  `remote_orgclass` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_refno` (`refno`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `rpt_syncdata_item_completed` (
  `objid` varchar(255) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `idx` int(255) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`) USING BTREE,
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_remote_orgid` (`parentid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;




/* RPT CERTIFICATION WORKFLOW */
delete from sys_wf_transition where processname = 'rptcertification';
delete from sys_wf_node where processname = 'rptcertification';

INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'rptcertification', 'Start', 'start', '1', NULL, NULL, NULL, '[:]', '[fillColor:\"#00ff00\",size:[32,32],pos:[102,127],type:\"start\"]', NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'rptcertification', 'Received', 'state', '2', NULL, 'RPT', 'CERTIFICATION_ISSUER', '[:]', '[fillColor:\"#c0c0c0\",size:[114,40],pos:[206,127],type:\"state\"]', '1');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('verifier', 'rptcertification', 'For Verification', 'state', '3', NULL, 'RPT', 'CERTIFICATION_VERIFIER', '[:]', '[fillColor:\"#c0c0c0\",size:[129,44],pos:[412,127],type:\"state\"]', '1');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'rptcertification', 'For Approval', 'state', '4', NULL, 'RPT', 'CERTIFICATION_APPROVER', '[:]', '[fillColor:\"#c0c0c0\",size:[118,42],pos:[604,141],type:\"state\"]', '1');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-releaser', 'rptcertification', 'Releasing', 'state', '6', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:\"#c0c0c0\",size:[118,42],pos:[604,141],type:\"state\"]', '1');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('releaser', 'rptcertification', 'For Release', 'state', '7', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:\"#c0c0c0\",size:[118,42],pos:[604,141],type:\"state\"]', '1');
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('released', 'rptcertification', 'Released', 'end', '8', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:\"#ff0000\",size:[32,32],pos:[797,148],type:\"end\"]', '1');

INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'rptcertification', 'assign', 'receiver', '1', NULL, '[:]', NULL, 'Assign', '[size:[72,0],pos:[134,142],type:\"arrow\",points:[134,142,206,142]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'rptcertification', 'cancelissuance', 'end', '5', NULL, '[caption:\'Cancel Issuance\', confirm:\'Cancel issuance?\',closeonend:true]', NULL, 'Cancel Issuance', '[size:[559,116],pos:[258,32],type:\"arrow\",points:[262,127,258,32,817,40,813,148]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'rptcertification', 'submit', 'verifier', '6', NULL, '[caption:\'Submit to Verifier\', confirm:\'Submit to verifier?\', messagehandler:\'rptmessage:info\',targetrole:\'RPT.CERTIFICATION_VERIFIER\']', NULL, 'Submit to Verifier', '[size:[92,0],pos:[320,146],type:\"arrow\",points:[320,146,412,146]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('verifier', 'rptcertification', 'return_receiver', 'receiver', '10', NULL, '[caption:\'Return to Issuer\', confirm:\'Return to issuer?\', messagehandler:\'default\']', NULL, 'Return to Receiver', '[size:[160,63],pos:[292,64],type:\"arrow\",points:[452,127,385,64,292,127]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('verifier', 'rptcertification', 'submit', 'approver', '11', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit for approval?\', messagehandler:\'rptmessage:sign\',targetrole:\'RPT.CERTIFICATION_APPROVER\']', NULL, 'Submit to Approver', '[size:[63,4],pos:[541,152],type:\"arrow\",points:[541,152,604,156]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'rptcertification', 'return_receiver', 'receiver', '15', NULL, '[caption:\'Return to Issuer\', confirm:\'Return to issuer?\', messagehandler:\'default\']', NULL, 'Return to Receiver', '[size:[333,113],pos:[285,167],type:\"arrow\",points:[618,183,414,280,285,167]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'rptcertification', 'submit', 'assign-releaser', '16', NULL, '[caption:\'Approve\', confirm:\'Approve?\', messagehandler:\'rptmessage:sign\']', NULL, 'Approve', '[size:[75,0],pos:[722,162],type:\"arrow\",points:[722,162,797,162]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-releaser', 'rptcertification', 'assign', 'releaser', '20', NULL, '[caption:\'Assign to Me\', confirm:\'Assign task to you?\']', NULL, 'Assign To Me', '[size:[63,4],pos:[541,152],type:\"arrow\",points:[541,152,604,156]]');
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('releaser', 'rptcertification', 'submit', 'released', '100', '', '[caption:\'Release Certification\', confirm:\'Release certifications?\', closeonend:false, messagehandler:\'rptmessage:info\']', '', 'Release Certification', '[:]');

INSERT IGNORE INTO  `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_APPROVER', 'CERTIFICATION_APPROVER', 'RPT', NULL, NULL, 'CERTIFICATION_APPROVER');
INSERT IGNORE INTO  `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_ISSUER', 'CERTIFICATION_ISSUER', 'RPT', 'usergroup', NULL, 'CERTIFICATION_ISSUER');
INSERT IGNORE INTO  `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_RELEASER', 'RPT CERTIFICATION_RELEASER', 'RPT', NULL, NULL, 'CERTIFICATION_RELEASER');
INSERT IGNORE INTO  `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_VERIFIER', 'RPT CERTIFICATION_VERIFIER', 'RPT', NULL, NULL, 'CERTIFICATION_VERIFIER');


drop TABLE if exists `rptcertification_task`
;

CREATE TABLE `rptcertification_task` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `refid` varchar(50) DEFAULT NULL,
  `parentprocessid` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `startdate` datetime DEFAULT NULL,
  `enddate` datetime DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  `assignee_name` varchar(100) DEFAULT NULL,
  `assignee_title` varchar(80) DEFAULT NULL,
  `actor_objid` varchar(50) DEFAULT NULL,
  `actor_name` varchar(100) DEFAULT NULL,
  `actor_title` varchar(80) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `signature` longtext,
  `returnedby` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_assignee_objid` (`assignee_objid`) USING BTREE,
  CONSTRAINT `rptcertification_task_ibfk_1` FOREIGN KEY (`refid`) REFERENCES `rptcertification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


/* STOREY ADJUSTMENT SUPPORT */
alter table bldgtype add storeyadjtype varchar(10)
;
update bldgtype set storeyadjtype = 'bytype' where storeyadjtype is null
;


alter table bldgflooradditional add issystem int
;
update bldgflooradditional set issystem = 0 where issystem is null 
;

INSERT INTO `rptparameter` (`objid`, `state`, `name`, `caption`, `description`, `paramtype`, `minvalue`, `maxvalue`) 
VALUES ('MULTI_STOREY_RATE', 'APPROVED', 'MULTI_STOREY_RATE', 'MULTI-STOREY RATE', NULL, 'decimal', '0.00', '0.00')
;


INSERT INTO `bldgadditionalitem` (`objid`, `bldgrysettingid`, `code`, `name`, `unit`, `expr`, `previd`, `type`, `addareatobldgtotalarea`, `idx`) 
select
  concat('BMSA-', r.objid) as objid, 
  r.objid as bldgrysettingid, 
  'BMSA' as code, 
  'MULTI-STOREY ADJUSTMENT' as name, 
  'RATE' as unit, 
  'SYS_AREA * SYS_BASE_VALUE * MULTI_STOREY_RATE  / 100.0' as expr, 
  NULL as previd, 
  'adjustment' as type, 
  '0' as addareatobldgtotalarea, 
  '100' as idx
from bldgrysetting r
;


DROP TABLE IF EXISTS `bldgtype_storeyadjustment_bldgkind`
;
DROP TABLE IF EXISTS `bldgtype_storeyadjustment`
;


CREATE TABLE `bldgtype_storeyadjustment` (
  `objid` varchar(50) NOT NULL,
  `bldgrysettingid` varchar(50) NOT NULL,
  `bldgtypeid` varchar(50) NOT NULL,
  `floorno` int(10) NOT NULL,
  `rate` decimal(16,2) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_bldgtype_storeyadjustment` (`bldgtypeid`,`floorno`,`rate`) USING BTREE,
  KEY `bldgtypeid` (`bldgtypeid`) USING BTREE,
  KEY `FK_bldgtype_storeyadjustment` (`previd`) USING BTREE,
  KEY `FK_bldgtype_storeyadjustment_bldgrysetting` (`bldgrysettingid`) USING BTREE,
  CONSTRAINT `bldgtype_storeyadjustment_ibfk_1` FOREIGN KEY (`previd`) REFERENCES `bldgtype_storeyadjustment` (`objid`),
  CONSTRAINT `bldgtype_storeyadjustment_ibfk_2` FOREIGN KEY (`bldgrysettingid`) REFERENCES `bldgrysetting` (`objid`),
  CONSTRAINT `bldgtype_storeyadjustment_ibfk_3` FOREIGN KEY (`bldgtypeid`) REFERENCES `bldgtype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



drop TABLE if exists `bldgtype_storeyadjustment_bldgkind`
;

CREATE TABLE `bldgtype_storeyadjustment_bldgkind` (
  `objid` varchar(50) NOT NULL,
  `bldgrysettingid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `bldgtypeid` varchar(50) NOT NULL,
  `floorno` int(11) NOT NULL,
  `bldgkindid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_bldgtype_kind_floorno` (`bldgtypeid`,`bldgkindid`,`floorno`),
  KEY `fk_storeyadjustment_bldgkind_bldgrysetting` (`bldgrysettingid`),
  KEY `fk_storeyadjustment_bldgkind_parent` (`parentid`),
  CONSTRAINT `fk_storeyadjustment_bldgkind_bldgrysetting` FOREIGN KEY (`bldgrysettingid`) REFERENCES `bldgrysetting` (`objid`),
  CONSTRAINT `fk_storeyadjustment_bldgkind_bldgtype` FOREIGN KEY (`bldgtypeid`) REFERENCES `bldgtype` (`objid`),
  CONSTRAINT `fk_storeyadjustment_bldgkind_parent` FOREIGN KEY (`parentid`) REFERENCES `bldgtype_storeyadjustment` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


drop view if exists vw_assessment_notice_item;
drop view if exists vw_assessment_notice;
drop view if exists vw_batch_rpttaxcredit_error;
drop view if exists vw_batchgr;
drop view if exists vw_building;
drop view if exists vw_certification_land_improvement;
drop view if exists vw_certification_landdetail;
drop view if exists vw_faas_lookup;
drop view if exists vw_landtax_abstract_of_collection_detail;
drop view if exists vw_landtax_abstract_of_collection_detail_eor;
drop view if exists vw_landtax_collection_detail;
drop view if exists vw_landtax_collection_detail_eor;
drop view if exists vw_landtax_collection_disposition_detail;
drop view if exists vw_landtax_collection_disposition_detail_eor;
drop view if exists vw_landtax_collection_share_detail;
drop view if exists vw_landtax_collection_share_detail_eor;
drop view if exists vw_landtax_eor;
drop view if exists vw_landtax_eor_remittance;
drop view if exists vw_landtax_lgu_account_mapping;
drop view if exists vw_landtax_report_rptdelinquency_detail;
drop view if exists vw_landtax_report_rptdelinquency;
drop view if exists vw_machine_smv;
drop view if exists vw_machinery;
drop view if exists vw_newly_assessed_property;
drop view if exists vw_online_rptcertification;
drop view if exists vw_real_property_payment;
drop view if exists vw_report_orc;
drop view if exists vw_rptcertification_item;
drop view if exists vw_rptledger_avdifference;
drop view if exists vw_rptledger_cancelled_faas;
drop view if exists vw_rptpayment_item_detail;
drop view if exists vw_rpu_assessment;

drop table if exists vw_assessment_notice_item;
drop table if exists vw_assessment_notice;
drop table if exists vw_batch_rpttaxcredit_error;
drop table if exists vw_batchgr;
drop table if exists vw_building;
drop table if exists vw_certification_land_improvement;
drop table if exists vw_certification_landdetail;
drop table if exists vw_faas_lookup;
drop table if exists vw_landtax_abstract_of_collection_detail;
drop table if exists vw_landtax_abstract_of_collection_detail_eor;
drop table if exists vw_landtax_collection_detail;
drop table if exists vw_landtax_collection_detail_eor;
drop table if exists vw_landtax_collection_disposition_detail;
drop table if exists vw_landtax_collection_disposition_detail_eor;
drop table if exists vw_landtax_collection_share_detail;
drop table if exists vw_landtax_collection_share_detail_eor;
drop table if exists vw_landtax_eor;
drop table if exists vw_landtax_eor_remittance;
drop table if exists vw_landtax_lgu_account_mapping;
drop table if exists vw_landtax_report_rptdelinquency_detail;
drop table if exists vw_landtax_report_rptdelinquency;
drop table if exists vw_machine_smv;
drop table if exists vw_machinery;
drop table if exists vw_newly_assessed_property;
drop table if exists vw_online_rptcertification;
drop table if exists vw_real_property_payment;
drop table if exists vw_report_orc;
drop table if exists vw_rptcertification_item;
drop table if exists vw_rptledger_avdifference;
drop table if exists vw_rptledger_cancelled_faas;
drop table if exists vw_rptpayment_item_detail;
drop table if exists vw_rpu_assessment;


CREATE VIEW `vw_landtax_eor` AS select `eor`.`eor`.`objid` AS `objid`,`eor`.`eor`.`receiptno` AS `receiptno`,`eor`.`eor`.`receiptdate` AS `receiptdate`,`eor`.`eor`.`txndate` AS `txndate`,`eor`.`eor`.`state` AS `state`,`eor`.`eor`.`partnerid` AS `partnerid`,`eor`.`eor`.`txntype` AS `txntype`,`eor`.`eor`.`traceid` AS `traceid`,`eor`.`eor`.`tracedate` AS `tracedate`,`eor`.`eor`.`refid` AS `refid`,`eor`.`eor`.`paidby` AS `paidby`,`eor`.`eor`.`paidbyaddress` AS `paidbyaddress`,`eor`.`eor`.`payer_objid` AS `payer_objid`,`eor`.`eor`.`paymethod` AS `paymethod`,`eor`.`eor`.`paymentrefid` AS `paymentrefid`,`eor`.`eor`.`remittanceid` AS `remittanceid`,`eor`.`eor`.`remarks` AS `remarks`,`eor`.`eor`.`amount` AS `amount`,`eor`.`eor`.`lockid` AS `lockid` from `eor`.`eor`
;
CREATE VIEW `vw_landtax_eor_remittance` AS select `eor`.`eor_remittance`.`objid` AS `objid`,`eor`.`eor_remittance`.`state` AS `state`,`eor`.`eor_remittance`.`controlno` AS `controlno`,`eor`.`eor_remittance`.`partnerid` AS `partnerid`,`eor`.`eor_remittance`.`controldate` AS `controldate`,`eor`.`eor_remittance`.`dtcreated` AS `dtcreated`,`eor`.`eor_remittance`.`createdby_objid` AS `createdby_objid`,`eor`.`eor_remittance`.`createdby_name` AS `createdby_name`,`eor`.`eor_remittance`.`amount` AS `amount`,`eor`.`eor_remittance`.`dtposted` AS `dtposted`,`eor`.`eor_remittance`.`postedby_objid` AS `postedby_objid`,`eor`.`eor_remittance`.`postedby_name` AS `postedby_name`,`eor`.`eor_remittance`.`lockid` AS `lockid` from `eor`.`eor_remittance`
;

CREATE VIEW `vw_assessment_notice` AS select `a`.`objid` AS `objid`,`a`.`state` AS `state`,`a`.`txnno` AS `txnno`,`a`.`txndate` AS `txndate`,`a`.`taxpayerid` AS `taxpayerid`,`a`.`taxpayername` AS `taxpayername`,`a`.`taxpayeraddress` AS `taxpayeraddress`,`a`.`dtdelivered` AS `dtdelivered`,`a`.`receivedby` AS `receivedby`,`a`.`remarks` AS `remarks`,`a`.`assessmentyear` AS `assessmentyear`,`a`.`administrator_name` AS `administrator_name`,`a`.`administrator_address` AS `administrator_address`,`fl`.`tdno` AS `tdno`,`fl`.`displaypin` AS `fullpin`,`fl`.`cadastrallotno` AS `cadastrallotno`,`fl`.`titleno` AS `titleno` from ((`assessmentnotice` `a` join `assessmentnoticeitem` `i` on((`a`.`objid` = `i`.`assessmentnoticeid`))) join `faas_list` `fl` on((`i`.`faasid` = `fl`.`objid`)))
;
CREATE VIEW `vw_assessment_notice_item` AS select `ni`.`objid` AS `objid`,`ni`.`assessmentnoticeid` AS `assessmentnoticeid`,`f`.`objid` AS `faasid`,`f`.`effectivityyear` AS `effectivityyear`,`f`.`effectivityqtr` AS `effectivityqtr`,`f`.`tdno` AS `tdno`,`f`.`taxpayer_objid` AS `taxpayer_objid`,`e`.`name` AS `taxpayer_name`,`e`.`address_text` AS `taxpayer_address`,`f`.`owner_name` AS `owner_name`,`f`.`owner_address` AS `owner_address`,`f`.`administrator_name` AS `administrator_name`,`f`.`administrator_address` AS `administrator_address`,`f`.`rpuid` AS `rpuid`,`f`.`lguid` AS `lguid`,`f`.`txntype_objid` AS `txntype_objid`,`ft`.`displaycode` AS `txntype_code`,`rpu`.`rputype` AS `rputype`,`rpu`.`ry` AS `ry`,`rpu`.`fullpin` AS `fullpin`,`rpu`.`taxable` AS `taxable`,`rpu`.`totalareaha` AS `totalareaha`,`rpu`.`totalareasqm` AS `totalareasqm`,`rpu`.`totalbmv` AS `totalbmv`,`rpu`.`totalmv` AS `totalmv`,`rpu`.`totalav` AS `totalav`,`rp`.`section` AS `section`,`rp`.`parcel` AS `parcel`,`rp`.`surveyno` AS `surveyno`,`rp`.`cadastrallotno` AS `cadastrallotno`,`rp`.`blockno` AS `blockno`,`rp`.`claimno` AS `claimno`,`rp`.`street` AS `street`,`o`.`name` AS `lguname`,`b`.`name` AS `barangay`,`pc`.`code` AS `classcode`,`pc`.`name` AS `classification` from (((((((((`assessmentnoticeitem` `ni` join `faas` `f` on((`ni`.`faasid` = `f`.`objid`))) left join `txnsignatory` `ts` on(((`ts`.`refid` = `f`.`objid`) and (`ts`.`type` = 'APPROVER')))) join `rpu` on((`f`.`rpuid` = `rpu`.`objid`))) join `propertyclassification` `pc` on((`rpu`.`classification_objid` = `pc`.`objid`))) join `realproperty` `rp` on((`f`.`realpropertyid` = `rp`.`objid`))) join `barangay` `b` on((`rp`.`barangayid` = `b`.`objid`))) join `sys_org` `o` on((`f`.`lguid` = `o`.`objid`))) join `entity` `e` on((`f`.`taxpayer_objid` = `e`.`objid`))) join `faas_txntype` `ft` on((`f`.`txntype_objid` = `ft`.`objid`)))
;
CREATE VIEW `vw_batch_rpttaxcredit_error` AS select `br`.`objid` AS `objid`,`br`.`parentid` AS `parentid`,`br`.`state` AS `state`,`br`.`error` AS `error`,`br`.`barangayid` AS `barangayid`,`rl`.`tdno` AS `tdno` from (`batch_rpttaxcredit_ledger` `br` join `rptledger` `rl` on((`br`.`objid` = `rl`.`objid`))) where (`br`.`state` = 'ERROR')
;
CREATE VIEW `vw_batchgr` AS select `bg`.`objid` AS `objid`,`bg`.`state` AS `state`,`bg`.`ry` AS `ry`,`bg`.`lgu_objid` AS `lgu_objid`,`bg`.`barangay_objid` AS `barangay_objid`,`bg`.`rputype` AS `rputype`,`bg`.`classification_objid` AS `classification_objid`,`bg`.`section` AS `section`,`bg`.`memoranda` AS `memoranda`,`bg`.`txntype_objid` AS `txntype_objid`,`bg`.`txnno` AS `txnno`,`bg`.`txndate` AS `txndate`,`bg`.`effectivityyear` AS `effectivityyear`,`bg`.`effectivityqtr` AS `effectivityqtr`,`bg`.`originlgu_objid` AS `originlgu_objid`,`l`.`name` AS `lgu_name`,`b`.`name` AS `barangay_name`,`b`.`pin` AS `barangay_pin`,`pc`.`name` AS `classification_name`,`t`.`objid` AS `taskid`,`t`.`state` AS `taskstate`,`t`.`assignee_objid` AS `assignee_objid` from ((((`batchgr` `bg` join `sys_org` `l` on((`bg`.`lgu_objid` = `l`.`objid`))) left join `barangay` `b` on((`bg`.`barangay_objid` = `b`.`objid`))) left join `propertyclassification` `pc` on((`bg`.`classification_objid` = `pc`.`objid`))) left join `batchgr_task` `t` on(((`bg`.`objid` = `t`.`refid`) and isnull(`t`.`enddate`))))
;
CREATE VIEW `vw_building` AS select `f`.`objid` AS `objid`,`f`.`state` AS `state`,`f`.`rpuid` AS `rpuid`,`f`.`realpropertyid` AS `realpropertyid`,`f`.`tdno` AS `tdno`,`f`.`fullpin` AS `fullpin`,`f`.`taxpayer_objid` AS `taxpayer_objid`,`f`.`owner_name` AS `owner_name`,`f`.`owner_address` AS `owner_address`,`f`.`administrator_name` AS `administrator_name`,`f`.`administrator_address` AS `administrator_address`,`f`.`lguid` AS `lgu_objid`,`o`.`name` AS `lgu_name`,`b`.`objid` AS `barangay_objid`,`b`.`name` AS `barangay_name`,`r`.`classification_objid` AS `classification_objid`,`pc`.`name` AS `classification_name`,`rp`.`pin` AS `pin`,`rp`.`section` AS `section`,`rp`.`ry` AS `ry`,`rp`.`cadastrallotno` AS `cadastrallotno`,`rp`.`blockno` AS `blockno`,`rp`.`surveyno` AS `surveyno`,`bt`.`objid` AS `bldgtype_objid`,`bt`.`name` AS `bldgtype_name`,`bk`.`objid` AS `bldgkind_objid`,`bk`.`name` AS `bldgkind_name`,`bu`.`basemarketvalue` AS `basemarketvalue`,`bu`.`adjustment` AS `adjustment`,`bu`.`depreciationvalue` AS `depreciationvalue`,`bu`.`marketvalue` AS `marketvalue`,`bu`.`assessedvalue` AS `assessedvalue`,`al`.`objid` AS `actualuse_objid`,`al`.`name` AS `actualuse_name`,`r`.`totalareaha` AS `totalareaha`,`r`.`totalareasqm` AS `totalareasqm`,`r`.`totalmv` AS `totalmv`,`r`.`totalav` AS `totalav` from (((((((((((`faas` `f` join `rpu` `r` on((`f`.`rpuid` = `r`.`objid`))) join `propertyclassification` `pc` on((`r`.`classification_objid` = `pc`.`objid`))) join `realproperty` `rp` on((`f`.`realpropertyid` = `rp`.`objid`))) join `barangay` `b` on((`rp`.`barangayid` = `b`.`objid`))) join `sys_org` `o` on((`f`.`lguid` = `o`.`objid`))) join `bldgrpu_structuraltype` `bst` on((`r`.`objid` = `bst`.`bldgrpuid`))) join `bldgtype` `bt` on((`bst`.`bldgtype_objid` = `bt`.`objid`))) join `bldgkindbucc` `bucc` on((`bst`.`bldgkindbucc_objid` = `bucc`.`objid`))) join `bldgkind` `bk` on((`bucc`.`bldgkind_objid` = `bk`.`objid`))) join `bldguse` `bu` on((`bst`.`objid` = `bu`.`structuraltype_objid`))) join `bldgassesslevel` `al` on((`bu`.`actualuse_objid` = `al`.`objid`)))
;
CREATE VIEW `vw_certification_land_improvement` AS select `f`.`objid` AS `faasid`,`pt`.`name` AS `improvement`,`ptd`.`areacovered` AS `areacovered`,`ptd`.`productive` AS `productive`,`ptd`.`nonproductive` AS `nonproductive`,`ptd`.`basemarketvalue` AS `basemarketvalue`,`ptd`.`marketvalue` AS `marketvalue`,`ptd`.`unitvalue` AS `unitvalue`,`ptd`.`assessedvalue` AS `assessedvalue` from ((`faas` `f` join `planttreedetail` `ptd` on((`f`.`rpuid` = `ptd`.`landrpuid`))) join `planttree` `pt` on((`ptd`.`planttree_objid` = `pt`.`objid`)))
;
CREATE VIEW `vw_certification_landdetail` AS select `f`.`objid` AS `faasid`,`ld`.`areaha` AS `areaha`,`ld`.`areasqm` AS `areasqm`,`ld`.`assessedvalue` AS `assessedvalue`,`ld`.`marketvalue` AS `marketvalue`,`ld`.`basemarketvalue` AS `basemarketvalue`,`ld`.`unitvalue` AS `unitvalue`,`lspc`.`name` AS `specificclass_name` from ((`faas` `f` join `landdetail` `ld` on((`f`.`rpuid` = `ld`.`landrpuid`))) join `landspecificclass` `lspc` on((`ld`.`landspecificclass_objid` = `lspc`.`objid`)))
;
CREATE VIEW `vw_faas_lookup` AS select `fl`.`objid` AS `objid`,`fl`.`state` AS `state`,`fl`.`rpuid` AS `rpuid`,`fl`.`utdno` AS `utdno`,`fl`.`tdno` AS `tdno`,`fl`.`txntype_objid` AS `txntype_objid`,`fl`.`effectivityyear` AS `effectivityyear`,`fl`.`effectivityqtr` AS `effectivityqtr`,`fl`.`taxpayer_objid` AS `taxpayer_objid`,`fl`.`owner_name` AS `owner_name`,`fl`.`owner_address` AS `owner_address`,`fl`.`prevtdno` AS `prevtdno`,`fl`.`cancelreason` AS `cancelreason`,`fl`.`cancelledbytdnos` AS `cancelledbytdnos`,`fl`.`lguid` AS `lguid`,`fl`.`realpropertyid` AS `realpropertyid`,`fl`.`displaypin` AS `fullpin`,`fl`.`originlguid` AS `originlguid`,`e`.`name` AS `taxpayer_name`,`e`.`address_text` AS `taxpayer_address`,`pc`.`code` AS `classification_code`,`pc`.`code` AS `classcode`,`pc`.`name` AS `classification_name`,`pc`.`name` AS `classname`,`fl`.`ry` AS `ry`,`fl`.`rputype` AS `rputype`,`fl`.`totalmv` AS `totalmv`,`fl`.`totalav` AS `totalav`,`fl`.`totalareasqm` AS `totalareasqm`,`fl`.`totalareaha` AS `totalareaha`,`fl`.`barangayid` AS `barangayid`,`fl`.`cadastrallotno` AS `cadastrallotno`,`fl`.`blockno` AS `blockno`,`fl`.`surveyno` AS `surveyno`,`fl`.`pin` AS `pin`,`fl`.`barangay` AS `barangay_name`,`fl`.`trackingno` AS `trackingno` from ((`faas_list` `fl` left join `propertyclassification` `pc` on((`fl`.`classification_objid` = `pc`.`objid`))) left join `entity` `e` on((`fl`.`taxpayer_objid` = `e`.`objid`)))
;
CREATE VIEW `vw_landtax_abstract_of_collection_detail` AS select `liq`.`objid` AS `liquidationid`,`liq`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`dtposted` AS `remittancedate`,`cr`.`objid` AS `receiptid`,`cr`.`receiptdate` AS `ordate`,`cr`.`receiptno` AS `orno`,`cr`.`collector_objid` AS `collectorid`,`rl`.`objid` AS `rptledgerid`,`rl`.`fullpin` AS `fullpin`,`rl`.`titleno` AS `titleno`,`rl`.`cadastrallotno` AS `cadastrallotno`,`rl`.`rputype` AS `rputype`,`rl`.`totalmv` AS `totalmv`,`b`.`name` AS `barangay`,`rp`.`fromqtr` AS `fromqtr`,`rp`.`toqtr` AS `toqtr`,`rpi`.`year` AS `year`,`rpi`.`qtr` AS `qtr`,`rpi`.`revtype` AS `revtype`,(case when isnull(`cv`.`objid`) then `rl`.`owner_name` else '*** voided ***' end) AS `taxpayername`,(case when isnull(`cv`.`objid`) then `rl`.`tdno` else '' end) AS `tdno`,(case when isnull(`m`.`name`) then `c`.`name` else `m`.`name` end) AS `municityname`,(case when isnull(`cv`.`objid`) then `rl`.`classcode` else '' end) AS `classification`,(case when isnull(`cv`.`objid`) then `rl`.`totalav` else 0.0 end) AS `assessvalue`,(case when isnull(`cv`.`objid`) then `rl`.`totalav` else 0.0 end) AS `assessedvalue`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `basiccurrentyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `basicpreviousyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic')) then `rpi`.`discount` else 0.0 end) AS `basicdiscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `basicpenaltycurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `basicpenaltyprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `sefcurrentyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `sefpreviousyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef')) then `rpi`.`discount` else 0.0 end) AS `sefdiscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `sefpenaltycurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `sefpenaltyprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `basicidlecurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `basicidleprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle')) then `rpi`.`amount` else 0.0 end) AS `basicidlediscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `basicidlecurrentpenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `basicidlepreviouspenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `shcurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `shprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh')) then `rpi`.`discount` else 0.0 end) AS `shdiscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `shcurrentpenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `shpreviouspenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'firecode')) then `rpi`.`amount` else 0.0 end) AS `firecode`,(case when isnull(`cv`.`objid`) then ((`rpi`.`amount` - `rpi`.`discount`) + `rpi`.`interest`) else 0.0 end) AS `total`,(case when isnull(`cv`.`objid`) then `rpi`.`partialled` else 0 end) AS `partialled` from ((((((((((`collectionvoucher` `liq` join `remittance` `rem` on((`rem`.`collectionvoucherid` = `liq`.`objid`))) join `cashreceipt` `cr` on((`rem`.`objid` = `cr`.`remittanceid`))) left join `cashreceipt_void` `cv` on((`cr`.`objid` = `cv`.`receiptid`))) join `rptpayment` `rp` on((`rp`.`receiptid` = `cr`.`objid`))) join `rptpayment_item` `rpi` on((`rpi`.`parentid` = `rp`.`objid`))) join `rptledger` `rl` on((`rl`.`objid` = `rp`.`refid`))) join `barangay` `b` on((`b`.`objid` = `rl`.`barangayid`))) left join `district` `d` on((`b`.`parentid` = `d`.`objid`))) left join `city` `c` on((`d`.`parentid` = `c`.`objid`))) left join `municipality` `m` on((`b`.`parentid` = `m`.`objid`)))
;
CREATE VIEW `vw_landtax_abstract_of_collection_detail_eor` AS select `rem`.`objid` AS `liquidationid`,`rem`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controldate` AS `remittancedate`,`eor`.`objid` AS `receiptid`,`eor`.`receiptdate` AS `ordate`,`eor`.`receiptno` AS `orno`,`rem`.`createdby_objid` AS `collectorid`,`rl`.`objid` AS `rptledgerid`,`rl`.`fullpin` AS `fullpin`,`rl`.`titleno` AS `titleno`,`rl`.`cadastrallotno` AS `cadastrallotno`,`rl`.`rputype` AS `rputype`,`rl`.`totalmv` AS `totalmv`,`b`.`name` AS `barangay`,`rp`.`fromqtr` AS `fromqtr`,`rp`.`toqtr` AS `toqtr`,`rpi`.`year` AS `year`,`rpi`.`qtr` AS `qtr`,`rpi`.`revtype` AS `revtype`,(case when isnull(`cv`.`objid`) then `rl`.`owner_name` else '*** voided ***' end) AS `taxpayername`,(case when isnull(`cv`.`objid`) then `rl`.`tdno` else '' end) AS `tdno`,(case when isnull(`m`.`name`) then `c`.`name` else `m`.`name` end) AS `municityname`,(case when isnull(`cv`.`objid`) then `rl`.`classcode` else '' end) AS `classification`,(case when isnull(`cv`.`objid`) then `rl`.`totalav` else 0.0 end) AS `assessvalue`,(case when isnull(`cv`.`objid`) then `rl`.`totalav` else 0.0 end) AS `assessedvalue`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `basiccurrentyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `basicpreviousyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic')) then `rpi`.`discount` else 0.0 end) AS `basicdiscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `basicpenaltycurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basic') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `basicpenaltyprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `sefcurrentyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `sefpreviousyear`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef')) then `rpi`.`discount` else 0.0 end) AS `sefdiscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `sefpenaltycurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sef') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `sefpenaltyprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `basicidlecurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `basicidleprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle')) then `rpi`.`amount` else 0.0 end) AS `basicidlediscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `basicidlecurrentpenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'basicidle') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `basicidlepreviouspenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`amount` else 0.0 end) AS `shcurrent`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`amount` else 0.0 end) AS `shprevious`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh')) then `rpi`.`discount` else 0.0 end) AS `shdiscount`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('current','advance'))) then `rpi`.`interest` else 0.0 end) AS `shcurrentpenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'sh') and (`rpi`.`revperiod` in ('previous','prior'))) then `rpi`.`interest` else 0.0 end) AS `shpreviouspenalty`,(case when (isnull(`cv`.`objid`) and (`rpi`.`revtype` = 'firecode')) then `rpi`.`amount` else 0.0 end) AS `firecode`,(case when isnull(`cv`.`objid`) then ((`rpi`.`amount` - `rpi`.`discount`) + `rpi`.`interest`) else 0.0 end) AS `total`,(case when isnull(`cv`.`objid`) then `rpi`.`partialled` else 0 end) AS `partialled` from (((((((((`vw_landtax_eor_remittance` `rem` join `vw_landtax_eor` `eor` on((`rem`.`objid` = `eor`.`remittanceid`))) left join `cashreceipt_void` `cv` on((`eor`.`objid` = `cv`.`receiptid`))) join `rptpayment` `rp` on((`eor`.`objid` = `rp`.`receiptid`))) join `rptpayment_item` `rpi` on((`rpi`.`parentid` = `rp`.`objid`))) join `rptledger` `rl` on((`rl`.`objid` = `rp`.`refid`))) join `barangay` `b` on((`b`.`objid` = `rl`.`barangayid`))) left join `district` `d` on((`b`.`parentid` = `d`.`objid`))) left join `city` `c` on((`d`.`parentid` = `c`.`objid`))) left join `municipality` `m` on((`b`.`parentid` = `m`.`objid`)))
;
CREATE VIEW `vw_landtax_collection_detail` AS 
select 
  `cv`.`objid` AS `liquidationid`,
  `cv`.`controldate` AS `liquidationdate`,
  `rem`.`objid` AS `remittanceid`,
  `rem`.`controldate` AS `remittancedate`,
  `cr`.`receiptdate` AS `receiptdate`,
  `o`.`objid` AS `lguid`,
  `o`.`name` AS `lgu`,
  `b`.`objid` AS `barangayid`,
  `b`.`indexno` AS `brgyindex`,
  `b`.`name` AS `barangay`,
  `ri`.`revperiod` AS `revperiod`,
  `ri`.`revtype` AS `revtype`,
  `ri`.`year` AS `year`,
  `ri`.`qtr` AS `qtr`,
  `ri`.`amount` AS `amount`,
  `ri`.`interest` AS `interest`,
  `ri`.`discount` AS `discount`,
  `pc`.`name` AS `classname`,
  `pc`.`orderno` AS `orderno`,
  `pc`.`special` AS `special`,
  (case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basic')) then `ri`.`amount` else 0.0 end) AS `basiccurrent`,
  (case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0.0 end) AS `basicdisc`,
  (case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basic')) then `ri`.`amount` else 0.0 end) AS `basicprev`,
  (case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basic')) then `ri`.`interest` else 0.0 end) AS `basiccurrentint`,
  (case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basic')) then `ri`.`interest` else 0.0 end) AS `basicprevint`,
  (case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `basicnet`,
  (case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sef')) then `ri`.`amount` else 0.0 end) AS `sefcurrent`,
  (case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0.0 end) AS `sefdisc`,
  (case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sef')) then `ri`.`amount` else 0.0 end) AS `sefprev`,
  (case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sef')) then `ri`.`interest` else 0.0 end) AS `sefcurrentint`,
  (case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sef')) then `ri`.`interest` else 0.0 end) AS `sefprevint`,
  (case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `sefnet`,
  (case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basicidle')) then `ri`.`amount` else 0.0 end) AS `idlecurrent`,
  (case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basicidle')) then `ri`.`amount` else 0.0 end) AS `idleprev`,
  (case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0.0 end) AS `idledisc`,
  (case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `idleint`,
  (case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `idlenet`,
  (case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sh')) then `ri`.`amount` else 0.0 end) AS `shcurrent`,
  (case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sh')) then `ri`.`amount` else 0.0 end) AS `shprev`,
  (case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0.0 end) AS `shdisc`,
  (case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,
  (case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `shnet`,
  (case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `firecode`,
  0.0 AS `levynet`,
  case when crv.objid is null then 0 else 1 end as voided
from (((((((((`remittance` `rem` 
join `collectionvoucher` `cv` on((`cv`.`objid` = `rem`.`collectionvoucherid`))) 
join `cashreceipt` `cr` on((`cr`.`remittanceid` = `rem`.`objid`))) left 
join `cashreceipt_void` `crv` on((`cr`.`objid` = `crv`.`receiptid`))) 
join `rptpayment` `rp` on((`cr`.`objid` = `rp`.`receiptid`))) 
join `rptpayment_item` `ri` on((`rp`.`objid` = `ri`.`parentid`))) left 
join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) left 
join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left 
join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left 
join `propertyclassification` `pc` on((`rl`.`classification_objid` = `pc`.`objid`))) 
;
CREATE VIEW `vw_landtax_collection_detail_eor` AS select `rem`.`objid` AS `liquidationid`,`rem`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controldate` AS `remittancedate`,`eor`.`receiptdate` AS `receiptdate`,`o`.`objid` AS `lguid`,`o`.`name` AS `lgu`,`b`.`objid` AS `barangayid`,`b`.`indexno` AS `brgyindex`,`b`.`name` AS `barangay`,`ri`.`revperiod` AS `revperiod`,`ri`.`revtype` AS `revtype`,`ri`.`year` AS `year`,`ri`.`qtr` AS `qtr`,`ri`.`amount` AS `amount`,`ri`.`interest` AS `interest`,`ri`.`discount` AS `discount`,`pc`.`name` AS `classname`,`pc`.`orderno` AS `orderno`,`pc`.`special` AS `special`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basic')) then `ri`.`amount` else 0.0 end) AS `basiccurrent`,(case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0.0 end) AS `basicdisc`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basic')) then `ri`.`amount` else 0.0 end) AS `basicprev`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basic')) then `ri`.`interest` else 0.0 end) AS `basiccurrentint`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basic')) then `ri`.`interest` else 0.0 end) AS `basicprevint`,(case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `basicnet`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sef')) then `ri`.`amount` else 0.0 end) AS `sefcurrent`,(case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0.0 end) AS `sefdisc`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sef')) then `ri`.`amount` else 0.0 end) AS `sefprev`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sef')) then `ri`.`interest` else 0.0 end) AS `sefcurrentint`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sef')) then `ri`.`interest` else 0.0 end) AS `sefprevint`,(case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `sefnet`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'basicidle')) then `ri`.`amount` else 0.0 end) AS `idlecurrent`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'basicidle')) then `ri`.`amount` else 0.0 end) AS `idleprev`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0.0 end) AS `idledisc`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `idleint`,(case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `idlenet`,(case when ((`ri`.`revperiod` = 'current') and (`ri`.`revtype` = 'sh')) then `ri`.`amount` else 0.0 end) AS `shcurrent`,(case when ((`ri`.`revperiod` in ('previous','prior')) and (`ri`.`revtype` = 'sh')) then `ri`.`amount` else 0.0 end) AS `shprev`,(case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0.0 end) AS `shdisc`,(case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,(case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `shnet`,(case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` - `ri`.`discount`) + `ri`.`interest`) else 0 end) AS `firecode`,0.0 AS `levynet` from (((((((`vw_landtax_eor_remittance` `rem` join `vw_landtax_eor` `eor` on((`rem`.`objid` = `eor`.`remittanceid`))) join `rptpayment` `rp` on((`eor`.`objid` = `rp`.`receiptid`))) join `rptpayment_item` `ri` on((`rp`.`objid` = `ri`.`parentid`))) left join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) left join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left join `propertyclassification` `pc` on((`rl`.`classification_objid` = `pc`.`objid`)))
;
CREATE VIEW `vw_landtax_collection_disposition_detail` 
AS 
select 
  `cv`.`objid` AS `liquidationid`,
  `cv`.`controldate` AS `liquidationdate`,
  `rem`.`objid` AS `remittanceid`,
  `rem`.`controldate` AS `remittancedate`,
  `cr`.`receiptdate` AS `receiptdate`,
  `ri`.`revperiod` AS `revperiod`,
  (case when ((`ri`.`revtype` in ('basic','basicint','basicidle','basicidleint')) and (`ri`.`sharetype` in ('province','city'))) then `ri`.`amount` else 0.0 end) AS `provcitybasicshare`,
  (case when ((`ri`.`revtype` in ('basic','basicint','basicidle','basicidleint')) and (`ri`.`sharetype` = 'municipality')) then `ri`.`amount` else 0.0 end) AS `munibasicshare`,
  (case when ((`ri`.`revtype` in ('basic','basicint')) and (`ri`.`sharetype` = 'barangay')) then `ri`.`amount` else 0.0 end) AS `brgybasicshare`,
  (case when ((`ri`.`revtype` in ('sef','sefint')) and (`ri`.`sharetype` in ('province','city'))) then `ri`.`amount` else 0.0 end) AS `provcitysefshare`,
  (case when ((`ri`.`revtype` in ('sef','sefint')) and (`ri`.`sharetype` = 'municipality')) then `ri`.`amount` else 0.0 end) AS `munisefshare`,
  0.0 AS `brgysefshare`,
  case when crv.objid is null then 0 else 1 end as voided
from (((((`remittance` `rem` 
join `collectionvoucher` `cv` on((`cv`.`objid` = `rem`.`collectionvoucherid`))) 
join `cashreceipt` `cr` on((`cr`.`remittanceid` = `rem`.`objid`))) left 
join `cashreceipt_void` `crv` on((`cr`.`objid` = `crv`.`receiptid`))) 
join `rptpayment` `rp` on((`cr`.`objid` = `rp`.`receiptid`))) 
join `rptpayment_share` `ri` on((`rp`.`objid` = `ri`.`parentid`))) 
;
CREATE VIEW `vw_landtax_collection_disposition_detail_eor` AS select `rem`.`objid` AS `liquidationid`,`rem`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controldate` AS `remittancedate`,`eor`.`receiptdate` AS `receiptdate`,`ri`.`revperiod` AS `revperiod`,(case when ((`ri`.`revtype` in ('basic','basicint','basicidle','basicidleint')) and (`ri`.`sharetype` in ('province','city'))) then `ri`.`amount` else 0.0 end) AS `provcitybasicshare`,(case when ((`ri`.`revtype` in ('basic','basicint','basicidle','basicidleint')) and (`ri`.`sharetype` = 'municipality')) then `ri`.`amount` else 0.0 end) AS `munibasicshare`,(case when ((`ri`.`revtype` in ('basic','basicint')) and (`ri`.`sharetype` = 'barangay')) then `ri`.`amount` else 0.0 end) AS `brgybasicshare`,(case when ((`ri`.`revtype` in ('sef','sefint')) and (`ri`.`sharetype` in ('province','city'))) then `ri`.`amount` else 0.0 end) AS `provcitysefshare`,(case when ((`ri`.`revtype` in ('sef','sefint')) and (`ri`.`sharetype` = 'municipality')) then `ri`.`amount` else 0.0 end) AS `munisefshare`,0.0 AS `brgysefshare` from (((`vw_landtax_eor_remittance` `rem` join `vw_landtax_eor` `eor` on((`rem`.`objid` = `eor`.`remittanceid`))) join `rptpayment` `rp` on((`eor`.`objid` = `rp`.`receiptid`))) join `rptpayment_share` `ri` on((`rp`.`objid` = `ri`.`parentid`)))
;
CREATE VIEW `vw_landtax_collection_share_detail` AS select `cv`.`objid` AS `liquidationid`,`cv`.`controlno` AS `liquidationno`,`cv`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controlno` AS `remittanceno`,`rem`.`controldate` AS `remittancedate`,`cr`.`objid` AS `receiptid`,`cr`.`receiptno` AS `receiptno`,`cr`.`receiptdate` AS `receiptdate`,`cr`.`txndate` AS `txndate`,`o`.`name` AS `lgu`,`b`.`objid` AS `barangayid`,`b`.`name` AS `barangay`,`cra`.`revtype` AS `revtype`,`cra`.`revperiod` AS `revperiod`,`cra`.`sharetype` AS `sharetype`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic')) then `cra`.`amount` else 0 end) AS `brgycurr`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic')) then `cra`.`amount` else 0 end) AS `brgyprev`,(case when (`cra`.`revtype` = 'basicint') then `cra`.`amount` else 0 end) AS `brgypenalty`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgycurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgyprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgypenaltyshare`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `citycurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `cityprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `citypenaltyshare`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmunicurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmuniprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmunipenaltyshare`,`cra`.`amount` AS `amount`,`cra`.`discount` AS `discount`,(case when isnull(`crv`.`objid`) then 0 else 1 end) AS `voided` from ((((((((`remittance` `rem` join `collectionvoucher` `cv` on((`cv`.`objid` = `rem`.`collectionvoucherid`))) join `cashreceipt` `cr` on((`cr`.`remittanceid` = `rem`.`objid`))) join `rptpayment` `rp` on((`cr`.`objid` = `rp`.`receiptid`))) join `rptpayment_share` `cra` on((`rp`.`objid` = `cra`.`parentid`))) left join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) left join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left join `cashreceipt_void` `crv` on((`cr`.`objid` = `crv`.`receiptid`)))
;
CREATE VIEW `vw_landtax_collection_share_detail_eor` AS select `rem`.`objid` AS `liquidationid`,`rem`.`controlno` AS `liquidationno`,`rem`.`controldate` AS `liquidationdate`,`rem`.`objid` AS `remittanceid`,`rem`.`controlno` AS `remittanceno`,`rem`.`controldate` AS `remittancedate`,`eor`.`objid` AS `receiptid`,`eor`.`receiptno` AS `receiptno`,`eor`.`receiptdate` AS `receiptdate`,`eor`.`txndate` AS `txndate`,`o`.`name` AS `lgu`,`b`.`objid` AS `barangayid`,`b`.`name` AS `barangay`,`cra`.`revtype` AS `revtype`,`cra`.`revperiod` AS `revperiod`,`cra`.`sharetype` AS `sharetype`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic')) then `cra`.`amount` else 0 end) AS `brgycurr`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic')) then `cra`.`amount` else 0 end) AS `brgyprev`,(case when (`cra`.`revtype` = 'basicint') then `cra`.`amount` else 0 end) AS `brgypenalty`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgycurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgyprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` = 'barangay')) then `cra`.`amount` else 0 end) AS `brgypenaltyshare`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `citycurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `cityprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` = 'city')) then `cra`.`amount` else 0 end) AS `citypenaltyshare`,(case when ((`cra`.`revperiod` = 'current') and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmunicurrshare`,(case when ((`cra`.`revperiod` in ('previous','prior')) and (`cra`.`revtype` = 'basic') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmuniprevshare`,(case when ((`cra`.`revtype` = 'basicint') and (`cra`.`sharetype` in ('province','municipality'))) then `cra`.`amount` else 0 end) AS `provmunipenaltyshare`,`cra`.`amount` AS `amount`,`cra`.`discount` AS `discount` from (((((((`vw_landtax_eor_remittance` `rem` join `vw_landtax_eor` `eor` on((`rem`.`objid` = `eor`.`remittanceid`))) join `rptpayment` `rp` on((`eor`.`objid` = `rp`.`receiptid`))) join `rptpayment_share` `cra` on((`rp`.`objid` = `cra`.`parentid`))) left join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) left join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left join `cashreceipt_void` `crv` on((`eor`.`objid` = `crv`.`receiptid`)))
;
CREATE VIEW `vw_landtax_lgu_account_mapping` AS select `ia`.`org_objid` AS `org_objid`,`ia`.`org_name` AS `org_name`,`o`.`orgclass` AS `org_class`,`p`.`objid` AS `parent_objid`,`p`.`code` AS `parent_code`,`p`.`title` AS `parent_title`,`ia`.`objid` AS `item_objid`,`ia`.`code` AS `item_code`,`ia`.`title` AS `item_title`,`ia`.`fund_objid` AS `item_fund_objid`,`ia`.`fund_code` AS `item_fund_code`,`ia`.`fund_title` AS `item_fund_title`,`ia`.`type` AS `item_type`,`pt`.`tag` AS `item_tag` from (((`itemaccount` `ia` join `itemaccount` `p` on((`ia`.`parentid` = `p`.`objid`))) join `itemaccount_tag` `pt` on((`p`.`objid` = `pt`.`acctid`))) join `sys_org` `o` on((`ia`.`org_objid` = `o`.`objid`))) where (`p`.`state` = 'ACTIVE')
;
CREATE VIEW `vw_landtax_report_rptdelinquency` AS select `ri`.`objid` AS `objid`,`ri`.`rptledgerid` AS `rptledgerid`,`ri`.`barangayid` AS `barangayid`,`ri`.`year` AS `year`,`ri`.`qtr` AS `qtr`,`r`.`dtgenerated` AS `dtgenerated`,`r`.`dtcomputed` AS `dtcomputed`,`r`.`generatedby_name` AS `generatedby_name`,`r`.`generatedby_title` AS `generatedby_title`,(case when (`ri`.`revtype` = 'basic') then `ri`.`amount` else 0 end) AS `basic`,(case when (`ri`.`revtype` = 'basic') then `ri`.`interest` else 0 end) AS `basicint`,(case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0 end) AS `basicdisc`,(case when (`ri`.`revtype` = 'basic') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicdp`,(case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicnet`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`amount` else 0 end) AS `basicidle`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `basicidleint`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0 end) AS `basicidledisc`,(case when (`ri`.`revtype` = 'basicidle') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicidledp`,(case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicidlenet`,(case when (`ri`.`revtype` = 'sef') then `ri`.`amount` else 0 end) AS `sef`,(case when (`ri`.`revtype` = 'sef') then `ri`.`interest` else 0 end) AS `sefint`,(case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0 end) AS `sefdisc`,(case when (`ri`.`revtype` = 'sef') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `sefdp`,(case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `sefnet`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`amount` else 0 end) AS `firecode`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`interest` else 0 end) AS `firecodeint`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`discount` else 0 end) AS `firecodedisc`,(case when (`ri`.`revtype` = 'firecode') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `firecodedp`,(case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `firecodenet`,(case when (`ri`.`revtype` = 'sh') then `ri`.`amount` else 0 end) AS `sh`,(case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,(case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0 end) AS `shdisc`,(case when (`ri`.`revtype` = 'sh') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `shdp`,(case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `shnet`,((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) AS `total` from (`report_rptdelinquency_item` `ri` join `report_rptdelinquency` `r` on((`ri`.`parentid` = `r`.`objid`)))
;
CREATE VIEW `vw_landtax_report_rptdelinquency_detail` AS select `ri`.`objid` AS `objid`,`ri`.`rptledgerid` AS `rptledgerid`,`ri`.`barangayid` AS `barangayid`,`ri`.`year` AS `year`,`ri`.`qtr` AS `qtr`,`r`.`dtgenerated` AS `dtgenerated`,`r`.`dtcomputed` AS `dtcomputed`,`r`.`generatedby_name` AS `generatedby_name`,`r`.`generatedby_title` AS `generatedby_title`,(case when (`ri`.`revtype` = 'basic') then `ri`.`amount` else 0 end) AS `basic`,(case when (`ri`.`revtype` = 'basic') then `ri`.`interest` else 0 end) AS `basicint`,(case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0 end) AS `basicdisc`,(case when (`ri`.`revtype` = 'basic') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicdp`,(case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicnet`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`amount` else 0 end) AS `basicidle`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `basicidleint`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0 end) AS `basicidledisc`,(case when (`ri`.`revtype` = 'basicidle') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicidledp`,(case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicidlenet`,(case when (`ri`.`revtype` = 'sef') then `ri`.`amount` else 0 end) AS `sef`,(case when (`ri`.`revtype` = 'sef') then `ri`.`interest` else 0 end) AS `sefint`,(case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0 end) AS `sefdisc`,(case when (`ri`.`revtype` = 'sef') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `sefdp`,(case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `sefnet`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`amount` else 0 end) AS `firecode`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`interest` else 0 end) AS `firecodeint`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`discount` else 0 end) AS `firecodedisc`,(case when (`ri`.`revtype` = 'firecode') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `firecodedp`,(case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `firecodenet`,(case when (`ri`.`revtype` = 'sh') then `ri`.`amount` else 0 end) AS `sh`,(case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,(case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0 end) AS `shdisc`,(case when (`ri`.`revtype` = 'sh') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `shdp`,(case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `shnet`,((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) AS `total` from (`report_rptdelinquency_item` `ri` join `report_rptdelinquency` `r` on((`ri`.`parentid` = `r`.`objid`)))
;
CREATE VIEW `vw_machine_smv` AS select `ms`.`objid` AS `objid`,`ms`.`parent_objid` AS `parent_objid`,`ms`.`machine_objid` AS `machine_objid`,`ms`.`expr` AS `expr`,`ms`.`previd` AS `previd`,`m`.`code` AS `code`,`m`.`name` AS `name` from (`machine_smv` `ms` join `machine` `m` on((`ms`.`machine_objid` = `m`.`objid`)))
;
CREATE VIEW `vw_machinery` AS select `f`.`objid` AS `objid`,`f`.`state` AS `state`,`f`.`rpuid` AS `rpuid`,`f`.`realpropertyid` AS `realpropertyid`,`f`.`tdno` AS `tdno`,`f`.`fullpin` AS `fullpin`,`f`.`taxpayer_objid` AS `taxpayer_objid`,`f`.`owner_name` AS `owner_name`,`f`.`owner_address` AS `owner_address`,`f`.`administrator_name` AS `administrator_name`,`f`.`administrator_address` AS `administrator_address`,`f`.`lguid` AS `lgu_objid`,`o`.`name` AS `lgu_name`,`b`.`objid` AS `barangay_objid`,`b`.`name` AS `barangay_name`,`r`.`classification_objid` AS `classification_objid`,`pc`.`name` AS `classification_name`,`rp`.`pin` AS `pin`,`rp`.`section` AS `section`,`rp`.`ry` AS `ry`,`rp`.`cadastrallotno` AS `cadastrallotno`,`rp`.`blockno` AS `blockno`,`rp`.`surveyno` AS `surveyno`,`m`.`objid` AS `machine_objid`,`m`.`name` AS `machine_name`,`mu`.`basemarketvalue` AS `basemarketvalue`,`mu`.`marketvalue` AS `marketvalue`,`mu`.`assessedvalue` AS `assessedvalue`,`al`.`objid` AS `actualuse_objid`,`al`.`name` AS `actualuse_name`,`r`.`totalareaha` AS `totalareaha`,`r`.`totalareasqm` AS `totalareasqm`,`r`.`totalmv` AS `totalmv`,`r`.`totalav` AS `totalav` from (((((((((`faas` `f` join `rpu` `r` on((`f`.`rpuid` = `r`.`objid`))) join `propertyclassification` `pc` on((`r`.`classification_objid` = `pc`.`objid`))) join `realproperty` `rp` on((`f`.`realpropertyid` = `rp`.`objid`))) join `barangay` `b` on((`rp`.`barangayid` = `b`.`objid`))) join `sys_org` `o` on((`f`.`lguid` = `o`.`objid`))) join `machuse` `mu` on((`r`.`objid` = `mu`.`machrpuid`))) join `machdetail` `md` on((`mu`.`objid` = `md`.`machuseid`))) join `machine` `m` on((`md`.`machine_objid` = `m`.`objid`))) join `machassesslevel` `al` on((`mu`.`actualuse_objid` = `al`.`objid`)))
;
CREATE VIEW `vw_newly_assessed_property` AS select `f`.`objid` AS `objid`,`f`.`owner_name` AS `owner_name`,`f`.`tdno` AS `tdno`,`b`.`name` AS `barangay`,(case when (`f`.`rputype` = 'land') then 'LAND' when (`f`.`rputype` = 'bldg') then 'BUILDING' when (`f`.`rputype` = 'mach') then 'MACHINERY' when (`f`.`rputype` = 'planttree') then 'PLANT/TREE' else 'MISCELLANEOUS' end) AS `rputype`,`f`.`totalav` AS `totalav`,`f`.`effectivityyear` AS `effectivityyear` from (`faas_list` `f` join `barangay` `b` on((`f`.`barangayid` = `b`.`objid`))) where ((`f`.`state` in ('CURRENT','CANCELLED')) and (`f`.`txntype_objid` = 'ND'))
;
CREATE VIEW `vw_online_rptcertification` AS select `c`.`objid` AS `objid`,`c`.`txnno` AS `txnno`,`c`.`txndate` AS `txndate`,`c`.`opener` AS `opener`,`c`.`taxpayer_objid` AS `taxpayer_objid`,`c`.`taxpayer_name` AS `taxpayer_name`,`c`.`taxpayer_address` AS `taxpayer_address`,`c`.`requestedby` AS `requestedby`,`c`.`requestedbyaddress` AS `requestedbyaddress`,`c`.`certifiedby` AS `certifiedby`,`c`.`certifiedbytitle` AS `certifiedbytitle`,`c`.`official` AS `official`,`c`.`purpose` AS `purpose`,`c`.`orno` AS `orno`,`c`.`ordate` AS `ordate`,`c`.`oramount` AS `oramount`,`c`.`taskid` AS `taskid`,`t`.`state` AS `task_state`,`t`.`startdate` AS `task_startdate`,`t`.`enddate` AS `task_enddate`,`t`.`assignee_objid` AS `task_assignee_objid`,`t`.`assignee_name` AS `task_assignee_name`,`t`.`actor_objid` AS `task_actor_objid`,`t`.`actor_name` AS `task_actor_name` from (`rptcertification` `c` join `rptcertification_task` `t` on((`c`.`taskid` = `t`.`objid`)))
;
CREATE VIEW `vw_real_property_payment` AS select `cv`.`controldate` AS `cv_controldate`,`rem`.`controldate` AS `rem_controldate`,`rl`.`owner_name` AS `owner_name`,`rl`.`tdno` AS `tdno`,`pc`.`name` AS `classification`,(case when (`rl`.`rputype` = 'land') then 'LAND' when (`rl`.`rputype` = 'bldg') then 'BUILDING' when (`rl`.`rputype` = 'mach') then 'MACHINERY' when (`rl`.`rputype` = 'planttree') then 'PLANT/TREE' else 'MISCELLANEOUS' end) AS `rputype`,`b`.`name` AS `barangay`,`rpi`.`year` AS `year`,`rpi`.`qtr` AS `qtr`,((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) AS `amount`,(case when isnull(`v`.`objid`) then 0 else 1 end) AS `voided` from ((((((((`collectionvoucher` `cv` join `remittance` `rem` on((`cv`.`objid` = `rem`.`collectionvoucherid`))) join `cashreceipt` `cr` on((`rem`.`objid` = `cr`.`remittanceid`))) join `rptpayment` `rp` on((`cr`.`objid` = `rp`.`receiptid`))) join `rptpayment_item` `rpi` on((`rp`.`objid` = `rpi`.`parentid`))) join `rptledger` `rl` on((`rp`.`refid` = `rl`.`objid`))) join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) join `propertyclassification` `pc` on((`rl`.`classification_objid` = `pc`.`objid`))) left join `cashreceipt_void` `v` on((`cr`.`objid` = `v`.`receiptid`)))
;
CREATE VIEW `vw_report_orc` AS select `f`.`objid` AS `objid`,`f`.`state` AS `state`,`e`.`objid` AS `taxpayerid`,`e`.`name` AS `taxpayer_name`,`e`.`address_text` AS `taxpayer_address`,`o`.`name` AS `lgu_name`,`o`.`code` AS `lgu_indexno`,`f`.`dtapproved` AS `dtapproved`,`r`.`rputype` AS `rputype`,`pc`.`code` AS `classcode`,`pc`.`name` AS `classification`,`f`.`fullpin` AS `pin`,`f`.`titleno` AS `titleno`,`rp`.`cadastrallotno` AS `cadastrallotno`,`f`.`tdno` AS `tdno`,'' AS `arpno`,`f`.`prevowner` AS `prevowner`,`b`.`name` AS `location`,`r`.`totalareaha` AS `totalareaha`,`r`.`totalareasqm` AS `totalareasqm`,`r`.`totalmv` AS `totalmv`,`r`.`totalav` AS `totalav`,(case when (`f`.`state` = 'CURRENT') then '' else 'CANCELLED' end) AS `remarks` from ((((((`faas` `f` join `rpu` `r` on((`f`.`rpuid` = `r`.`objid`))) join `realproperty` `rp` on((`f`.`realpropertyid` = `rp`.`objid`))) join `propertyclassification` `pc` on((`r`.`classification_objid` = `pc`.`objid`))) join `entity` `e` on((`f`.`taxpayer_objid` = `e`.`objid`))) join `sys_org` `o` on((`rp`.`lguid` = `o`.`objid`))) join `barangay` `b` on((`rp`.`barangayid` = `b`.`objid`))) where (`f`.`state` in ('CURRENT','CANCELLED'))
;
CREATE VIEW `vw_rptcertification_item` AS select `rci`.`rptcertificationid` AS `rptcertificationid`,`f`.`objid` AS `faasid`,`f`.`fullpin` AS `fullpin`,`f`.`tdno` AS `tdno`,`e`.`objid` AS `taxpayerid`,`e`.`name` AS `taxpayer_name`,`f`.`owner_name` AS `owner_name`,`f`.`administrator_name` AS `administrator_name`,`f`.`titleno` AS `titleno`,`f`.`rpuid` AS `rpuid`,`pc`.`code` AS `classcode`,`pc`.`name` AS `classname`,`so`.`name` AS `lguname`,`b`.`name` AS `barangay`,`r`.`rputype` AS `rputype`,`r`.`suffix` AS `suffix`,`r`.`totalareaha` AS `totalareaha`,`r`.`totalareasqm` AS `totalareasqm`,`r`.`totalav` AS `totalav`,`r`.`totalmv` AS `totalmv`,`rp`.`street` AS `street`,`rp`.`blockno` AS `blockno`,`rp`.`cadastrallotno` AS `cadastrallotno`,`rp`.`surveyno` AS `surveyno`,`r`.`taxable` AS `taxable`,`f`.`effectivityyear` AS `effectivityyear`,`f`.`effectivityqtr` AS `effectivityqtr` from (((((((`rptcertificationitem` `rci` join `faas` `f` on((`rci`.`refid` = `f`.`objid`))) join `rpu` `r` on((`f`.`rpuid` = `r`.`objid`))) join `propertyclassification` `pc` on((`r`.`classification_objid` = `pc`.`objid`))) join `realproperty` `rp` on((`f`.`realpropertyid` = `rp`.`objid`))) join `barangay` `b` on((`rp`.`barangayid` = `b`.`objid`))) join `sys_org` `so` on((`f`.`lguid` = `so`.`objid`))) join `entity` `e` on((`f`.`taxpayer_objid` = `e`.`objid`)))
;
CREATE VIEW `vw_rptledger_avdifference` AS select `rlf`.`objid` AS `objid`,'APPROVED' AS `state`,`d`.`parent_objid` AS `rptledgerid`,`rl`.`faasid` AS `faasid`,`rl`.`tdno` AS `tdno`,`rlf`.`txntype_objid` AS `txntype_objid`,`rlf`.`classification_objid` AS `classification_objid`,`rlf`.`actualuse_objid` AS `actualuse_objid`,`rlf`.`taxable` AS `taxable`,`rlf`.`backtax` AS `backtax`,`d`.`year` AS `fromyear`,1 AS `fromqtr`,`d`.`year` AS `toyear`,4 AS `toqtr`,`d`.`av` AS `assessedvalue`,1 AS `systemcreated`,`rlf`.`reclassed` AS `reclassed`,`rlf`.`idleland` AS `idleland`,1 AS `taxdifference` from ((`rptledger_avdifference` `d` join `rptledgerfaas` `rlf` on((`d`.`rptledgerfaas_objid` = `rlf`.`objid`))) join `rptledger` `rl` on((`d`.`parent_objid` = `rl`.`objid`)))
;
CREATE VIEW `vw_rptledger_cancelled_faas` AS select `rl`.`objid` AS `objid`,`rl`.`state` AS `state`,`rl`.`faasid` AS `faasid`,`rl`.`lastyearpaid` AS `lastyearpaid`,`rl`.`lastqtrpaid` AS `lastqtrpaid`,`rl`.`barangayid` AS `barangayid`,`rl`.`taxpayer_objid` AS `taxpayer_objid`,`rl`.`fullpin` AS `fullpin`,`rl`.`tdno` AS `tdno`,`rl`.`cadastrallotno` AS `cadastrallotno`,`rl`.`rputype` AS `rputype`,`rl`.`txntype_objid` AS `txntype_objid`,`rl`.`classification_objid` AS `classification_objid`,`rl`.`classcode` AS `classcode`,`rl`.`totalav` AS `totalav`,`rl`.`totalmv` AS `totalmv`,`rl`.`totalareaha` AS `totalareaha`,`rl`.`taxable` AS `taxable`,`rl`.`owner_name` AS `owner_name`,`rl`.`prevtdno` AS `prevtdno`,`rl`.`titleno` AS `titleno`,`rl`.`administrator_name` AS `administrator_name`,`rl`.`blockno` AS `blockno`,`rl`.`lguid` AS `lguid`,`rl`.`beneficiary_objid` AS `beneficiary_objid`,`pc`.`name` AS `classification`,`b`.`name` AS `barangay`,`o`.`name` AS `lgu` from (((((`rptledger` `rl` join `faas` `f` on((`rl`.`faasid` = `f`.`objid`))) left join `barangay` `b` on((`rl`.`barangayid` = `b`.`objid`))) left join `sys_org` `o` on((`rl`.`lguid` = `o`.`objid`))) left join `propertyclassification` `pc` on((`rl`.`classification_objid` = `pc`.`objid`))) join `entity` `e` on((`rl`.`taxpayer_objid` = `e`.`objid`))) where ((`rl`.`state` = 'APPROVED') and (`f`.`state` = 'CANCELLED'))
;
CREATE VIEW `vw_rptpayment_item_detail` AS select `rpi`.`objid` AS `objid`,`rpi`.`parentid` AS `parentid`,`rpi`.`rptledgerfaasid` AS `rptledgerfaasid`,`rpi`.`year` AS `year`,`rpi`.`qtr` AS `qtr`,`rpi`.`revperiod` AS `revperiod`,(case when (`rpi`.`revtype` = 'basic') then `rpi`.`amount` else 0 end) AS `basic`,(case when (`rpi`.`revtype` = 'basic') then `rpi`.`interest` else 0 end) AS `basicint`,(case when (`rpi`.`revtype` = 'basic') then `rpi`.`discount` else 0 end) AS `basicdisc`,(case when (`rpi`.`revtype` = 'basic') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `basicdp`,(case when (`rpi`.`revtype` = 'basic') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `basicnet`,(case when (`rpi`.`revtype` = 'basicidle') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `basicidle`,(case when (`rpi`.`revtype` = 'basicidle') then `rpi`.`interest` else 0 end) AS `basicidleint`,(case when (`rpi`.`revtype` = 'basicidle') then `rpi`.`discount` else 0 end) AS `basicidledisc`,(case when (`rpi`.`revtype` = 'basicidle') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `basicidledp`,(case when (`rpi`.`revtype` = 'sef') then `rpi`.`amount` else 0 end) AS `sef`,(case when (`rpi`.`revtype` = 'sef') then `rpi`.`interest` else 0 end) AS `sefint`,(case when (`rpi`.`revtype` = 'sef') then `rpi`.`discount` else 0 end) AS `sefdisc`,(case when (`rpi`.`revtype` = 'sef') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `sefdp`,(case when (`rpi`.`revtype` = 'sef') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `sefnet`,(case when (`rpi`.`revtype` = 'firecode') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `firecode`,(case when (`rpi`.`revtype` = 'sh') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `sh`,(case when (`rpi`.`revtype` = 'sh') then `rpi`.`interest` else 0 end) AS `shint`,(case when (`rpi`.`revtype` = 'sh') then `rpi`.`discount` else 0 end) AS `shdisc`,(case when (`rpi`.`revtype` = 'sh') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `shdp`,(case when (`rpi`.`revtype` = 'sh') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `shnet`,((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) AS `amount`,`rpi`.`partialled` AS `partialled` from `rptpayment_item` `rpi`
;
CREATE VIEW `vw_rpu_assessment` AS select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `landassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`))) union select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `bldgassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`))) union select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `machassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`))) union select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `planttreeassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`))) union select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `miscassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`)))
;
DROP VIEW IF EXISTS `vw_txn_log`
;
CREATE VIEW `vw_txn_log` AS select distinct `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`txndate` AS `txndate`,`t`.`ref` AS `ref`,`t`.`action` AS `action`,1 AS `cnt` from (`txnlog` `t` join `sys_user` `u` on((`t`.`userid` = `u`.`objid`))) union select `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`enddate` AS `txndate`,'faas' AS `ref`,(case when (`t`.`state` like '%receiver%') then 'receive' when (`t`.`state` like '%examiner%') then 'examine' when (`t`.`state` like '%taxmapper_chief%') then 'approve taxmap' when (`t`.`state` like '%taxmapper%') then 'taxmap' when (`t`.`state` like '%appraiser%') then 'appraise' when (`t`.`state` like '%appraiser_chief%') then 'approve appraisal' when (`t`.`state` like '%recommender%') then 'recommend' when (`t`.`state` like '%approver%') then 'approve' else `t`.`state` end) AS `action`,1 AS `cnt` from (`faas_task` `t` join `sys_user` `u` on((`t`.`actor_objid` = `u`.`objid`))) where (not((`t`.`state` like '%assign%'))) union select `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`enddate` AS `txndate`,'subdivision' AS `ref`,(case when (`t`.`state` like '%receiver%') then 'receive' when (`t`.`state` like '%examiner%') then 'examine' when (`t`.`state` like '%taxmapper_chief%') then 'approve taxmap' when (`t`.`state` like '%taxmapper%') then 'taxmap' when (`t`.`state` like '%appraiser%') then 'appraise' when (`t`.`state` like '%appraiser_chief%') then 'approve appraisal' when (`t`.`state` like '%recommender%') then 'recommend' when (`t`.`state` like '%approver%') then 'approve' else `t`.`state` end) AS `action`,1 AS `cnt` from (`subdivision_task` `t` join `sys_user` `u` on((`t`.`actor_objid` = `u`.`objid`))) where (not((`t`.`state` like '%assign%'))) union select `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`enddate` AS `txndate`,'consolidation' AS `ref`,(case when (`t`.`state` like '%receiver%') then 'receive' when (`t`.`state` like '%examiner%') then 'examine' when (`t`.`state` like '%taxmapper_chief%') then 'approve taxmap' when (`t`.`state` like '%taxmapper%') then 'taxmap' when (`t`.`state` like '%appraiser%') then 'appraise' when (`t`.`state` like '%appraiser_chief%') then 'approve appraisal' when (`t`.`state` like '%recommender%') then 'recommend' when (`t`.`state` like '%approver%') then 'approve' else `t`.`state` end) AS `action`,1 AS `cnt` from (`subdivision_task` `t` join `sys_user` `u` on((`t`.`actor_objid` = `u`.`objid`))) where (not((`t`.`state` like '%consolidation%'))) union select `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`enddate` AS `txndate`,'cancelledfaas' AS `ref`,(case when (`t`.`state` like '%receiver%') then 'receive' when (`t`.`state` like '%examiner%') then 'examine' when (`t`.`state` like '%taxmapper_chief%') then 'approve taxmap' when (`t`.`state` like '%taxmapper%') then 'taxmap' when (`t`.`state` like '%appraiser%') then 'appraise' when (`t`.`state` like '%appraiser_chief%') then 'approve appraisal' when (`t`.`state` like '%recommender%') then 'recommend' when (`t`.`state` like '%approver%') then 'approve' else `t`.`state` end) AS `action`,1 AS `cnt` from (`subdivision_task` `t` join `sys_user` `u` on((`t`.`actor_objid` = `u`.`objid`))) where (not((`t`.`state` like '%cancelledfaas%')))
;


drop TABLE if exists `bldgtype_storeyadjustment_bldgkind` 
;

CREATE TABLE `bldgtype_storeyadjustment_bldgkind` (
  `objid` varchar(50) NOT NULL,
  `bldgrysettingid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `bldgtypeid` varchar(50) NOT NULL,
  `floorno` int(11) NOT NULL,
  `bldgkindid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_bldgtype_kind_floorno` (`bldgtypeid`,`bldgkindid`,`floorno`),
  KEY `fk_storeyadjustment_bldgkind_bldgrysetting` (`bldgrysettingid`),
  KEY `fk_storeyadjustment_bldgkind_parent` (`parentid`),
  CONSTRAINT `fk_storeyadjustment_bldgkind_bldgrysetting` FOREIGN KEY (`bldgrysettingid`) REFERENCES `bldgrysetting` (`objid`),
  CONSTRAINT `fk_storeyadjustment_bldgkind_bldgtype` FOREIGN KEY (`bldgtypeid`) REFERENCES `bldgtype` (`objid`),
  CONSTRAINT `fk_storeyadjustment_bldgkind_parent` FOREIGN KEY (`parentid`) REFERENCES `bldgtype_storeyadjustment` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;




/* CHANGE RPUT TYPE  */
INSERT INTO `faas_txntype` (`objid`, `name`, `newledger`, `newrpu`, `newrealproperty`, `displaycode`, `allowEditOwner`, `allowEditPin`, `allowEditPinInfo`, `allowEditAppraisal`, `opener`, `checkbalance`, `reconcileledger`, `allowannotated`) VALUES ('CK', 'Change Kind', '0', '1', '1', 'DP', '1', '1', '1', '1', '', '0', '0', '0')
;


create table zzztmp_examiner_finding 
select * from examiner_finding
;

alter table zzztmp_examiner_finding  add oid int auto_increment primary key
;

create index ix_objid on zzztmp_examiner_finding (objid)
;

update examiner_finding f, zzztmp_examiner_finding z set 
	f.txnno = concat('S', lpad(z.oid, 6, '0'))
where f.objid = z.objid 
;

drop table zzztmp_examiner_finding
;



/* OCULAR INSPECTION */
drop view if exists vw_ocular_inspection 
;

create view vw_ocular_inspection 
as 
select 
  ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
join faas f on ef.parent_objid = f.objid  
join rpu r on f.rpuid = r.objid  
join realproperty rp on f.realpropertyid = rp.objid  
join sys_org b on rp.barangayid = b.objid  
join sys_org o on f.lguid = o.objid  


union all 



select ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.parent_objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
  join subdivision_motherland sm on ef.parent_objid = sm.subdivisionid  
  join faas f on sm.landfaasid = f.objid  
  join rpu r on f.rpuid = r.objid  
  join realproperty rp on f.realpropertyid = rp.objid  
  join sys_org b on rp.barangayid = b.objid  
  join sys_org o on f.lguid = o.objid  

union all 

select ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.parent_objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
  join consolidation c on ef.parent_objid = c.objid  
  join faas f on c.newfaasid = f.objid  
  join rpu r on f.rpuid = r.objid  
  join realproperty rp on f.realpropertyid = rp.objid  
  join sys_org b on rp.barangayid = b.objid  
  join sys_org o on f.lguid = o.objid  

union all 

select ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  '' AS owner_name,
  '' AS owner_address,
  '' AS titleno,
  '' AS fullpin,
  '' AS blockno,
  '' AS cadastrallotno,
  0 AS totalareaha,
  0 AS totalareasqm,
  0 AS totalmv,
  0 AS totalav,
  o.objid AS lguid,
  o.name AS lgu_name,
  b.objid AS barangayid,
  b.name AS barangay_name,
  b.parent_objid AS barangay_parentid,
  '' AS purok,
  '' AS street 
from  examiner_finding ef 
  join batchgr bgr on ef.parent_objid = bgr.objid  
  join sys_org b on bgr.barangay_objid = b.objid  
  join sys_org o on bgr.lgu_objid = o.objid 

union all 

select 
  ef.objid AS objid,
  ef.findings AS findings,
  ef.parent_objid AS parent_objid,
  ef.dtinspected AS dtinspected,
  ef.inspectors AS inspectors,
  ef.notedby AS notedby,
  ef.notedbytitle AS notedbytitle,
  ef.photos AS photos,
  ef.recommendations AS recommendations,
  ef.inspectedby_objid AS inspectedby_objid,
  ef.inspectedby_name AS inspectedby_name,
  ef.inspectedby_title AS inspectedby_title,
  ef.doctype AS doctype,
  ef.txnno AS txnno,
  f.owner_name AS owner_name,
  f.owner_address AS owner_address,
  f.titleno AS titleno,
  f.fullpin AS fullpin,
  rp.blockno AS blockno,
  rp.cadastrallotno AS cadastrallotno,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalmv AS totalmv,
  r.totalav AS totalav,
  f.lguid AS lguid,
  o.name AS lgu_name,
  rp.barangayid AS barangayid,
  b.name AS barangay_name,
  b.objid AS barangay_parentid,
  rp.purok AS purok,
  rp.street AS street 
from  examiner_finding ef 
join cancelledfaas cf on ef.parent_objid = cf.objid  
join faas f on cf.faasid = f.objid  
join rpu r on f.rpuid = r.objid  
join realproperty rp on f.realpropertyid = rp.objid  
join sys_org b on rp.barangayid = b.objid  
join sys_org o on f.lguid = o.objid  
;


/* SUBDIVISION VIEWS */
drop view if exists vw_report_subdividedland
;

create view vw_report_subdividedland
as 
select 
	sl.objid,
	s.objid as subdivisionid,
	s.txnno, 
	b.name as barangay,
	o.name as lguname,
	pc.code as classcode,
	f.tdno,
	f.owner_name,
	f.administrator_name,
	f.titleno,
	f.lguid,
	f.titledate,
	f.fullpin,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	r.totalareaha,
	r.rputype,
	r.totalareasqm,
	r.totalmv,
	r.totalav,
	f.txntype_objid,
	ft.displaycode as txntype_code,
	e.name as taxpayer_name
from subdividedland sl 
	inner join subdivision s on sl.subdivisionid = s.objid 
	inner join faas f on sl.newfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join barangay b on rp.barangayid = b.objid
	inner join sys_org o on f.lguid = o.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid
	inner join entity e on f.taxpayer_objid = e.objid
	inner join propertyclassification pc on r.classification_objid = pc.objid
;

drop view if exists vw_report_motherland_summary
;

create view vw_report_motherland_summary
as 
select 
	m.subdivisionid,
	f.tdno,
	f.owner_name,
	b.name as barangay,
	o.name as lguname,
	f.titleno,
	f.titledate,
	f.fullpin,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	r.totalareaha,
	r.totalareasqm,
	r.rputype,
	r.totalmv,
	r.totalav,
	f.administrator_name,
	pc.code as classcode,
	ft.displaycode as txntype_code,
	e.name as taxpayer_name 
from subdivision_motherland m
	inner join faas f on m.landfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid
	inner join barangay b on rp.barangayid = b.objid
	inner join sys_org o on f.lguid = o.objid
	inner join propertyclassification pc on r.classification_objid = pc.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid
	inner join entity e on f.taxpayer_objid = e.objid
;



/* CONSOLIDATION VIEWS */
drop view if exists vw_report_consolidation
;

create view vw_report_consolidation
as 
select 
	c.objid,
	c.txnno,
	b.name as barangay,
	o.name as lguname,
	f.tdno,
	f.owner_name,
	f.administrator_name,
	f.titleno, 
	f.fullpin,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	r.totalareaha,
	r.totalareasqm,
	r.rputype,
	r.totalmv,
	r.totalav,
	f.txntype_objid,
	pc.code as classcode,
	ft.displaycode as txntype_code,
	e.name as taxpayer_name 
from consolidation c
	inner join faas f on c.newfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 	
	inner join barangay b on rp.barangayid = b.objid
	inner join sys_org o on f.lguid = o.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid
	inner join entity e on f.taxpayer_objid = e.objid
	inner join propertyclassification pc on r.classification_objid = pc.objid
;

drop view if exists vw_report_consolidated_land
;

create view vw_report_consolidated_land
as 
select 
	cl.consolidationid,
	f.tdno,
	f.owner_name,
	b.name as barangay,
	o.name as lguname,
	f.titleno, 
	f.fullpin,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	r.totalareaha,
	r.totalareasqm,
	r.rputype,
	r.totalmv,
	r.totalav,
	f.administrator_name,
	f.txntype_objid,
	pc.code as classcode,
	ft.displaycode as txntype_code,
	e.name as taxpayer_name 
from consolidatedland cl 
	inner join faas f on cl.landfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid
	inner join barangay b on rp.barangayid = b.objid
	inner join sys_org o on f.lguid = o.objid
	inner join propertyclassification pc on r.classification_objid = pc.objid
	inner join faas_txntype ft on f.txntype_objid = ft.objid
	inner join entity e on f.taxpayer_objid = e.objid
;



/* SYNC2: DOWNLOADED */
drop table if exists rpt_syncdata_downloaded
; 

CREATE TABLE `rpt_syncdata_downloaded` (
  `objid` varchar(255) NOT NULL,
  `etag` varchar(64) NOT NULL,
  `error` int(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_error` (`error`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

insert into rpt_syncdata_downloaded(
	objid, 
	etag,
	error
)
select 
	objid,
	etag,
	error
from rpt_syncdata_fordownload
where state = 'DOWNLOADED'
;

insert into rpt_syncdata_downloaded(
	objid, 
	etag,
	error
)
select 
	filekey,
	'-',
	1
from rpt_syncdata_error
;

delete from rpt_syncdata_fordownload 
where state = 'DOWNLOADED'
;



/* REPORT VIEW: OCULAR INSPECTION */
DROP VIEW IF EXISTS `vw_ocular_inspection` 
;

CREATE VIEW `vw_ocular_inspection` 
AS 
select 
  `ef`.`objid` AS `objid`,
  `ef`.`findings` AS `findings`,
  `ef`.`parent_objid` AS `parent_objid`,
  `ef`.`dtinspected` AS `dtinspected`,
  `ef`.`inspectors` AS `inspectors`,
  `ef`.`notedby` AS `notedby`,
  `ef`.`notedbytitle` AS `notedbytitle`,
  `ef`.`photos` AS `photos`,
  `ef`.`recommendations` AS `recommendations`,
  `ef`.`inspectedby_objid` AS `inspectedby_objid`,
  `ef`.`inspectedby_name` AS `inspectedby_name`,
  `ef`.`inspectedby_title` AS `inspectedby_title`,
  `ef`.`doctype` AS `doctype`,
  `ef`.`txnno` AS `txnno`,
  `f`.`owner_name` AS `owner_name`,
  `f`.`owner_address` AS `owner_address`,
  `f`.`titleno` AS `titleno`,
  `f`.`fullpin` AS `fullpin`,
  `rp`.`blockno` AS `blockno`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  `f`.`lguid` AS `lguid`,
  `o`.`name` AS `lgu_name`,
  `rp`.`barangayid` AS `barangayid`,
  `b`.`name` AS `barangay_name`,
  `b`.`objid` AS `barangay_parentid`,
  `rp`.`purok` AS `purok`,
  `rp`.`street` AS `street` 
from  `examiner_finding` `ef` 
join `faas` `f` on `ef`.`parent_objid` = `f`.`objid`  
join `rpu` `r` on `f`.`rpuid` = `r`.`objid`  
join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid`  
join `sys_org` `b` on `rp`.`barangayid` = `b`.`objid`  
join `sys_org` `o` on `f`.`lguid` = `o`.`objid`  

union all 

select `ef`.`objid` AS `objid`,
  `ef`.`findings` AS `findings`,
  `ef`.`parent_objid` AS `parent_objid`,
  `ef`.`dtinspected` AS `dtinspected`,
  `ef`.`inspectors` AS `inspectors`,
  `ef`.`notedby` AS `notedby`,
  `ef`.`notedbytitle` AS `notedbytitle`,
  `ef`.`photos` AS `photos`,
  `ef`.`recommendations` AS `recommendations`,
  `ef`.`inspectedby_objid` AS `inspectedby_objid`,
  `ef`.`inspectedby_name` AS `inspectedby_name`,
  `ef`.`inspectedby_title` AS `inspectedby_title`,
  `ef`.`doctype` AS `doctype`,
  `ef`.`txnno` AS `txnno`,
  `f`.`owner_name` AS `owner_name`,
  `f`.`owner_address` AS `owner_address`,
  `f`.`titleno` AS `titleno`,
  `f`.`fullpin` AS `fullpin`,
  `rp`.`blockno` AS `blockno`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  `f`.`lguid` AS `lguid`,
  `o`.`name` AS `lgu_name`,
  `rp`.`barangayid` AS `barangayid`,
  `b`.`name` AS `barangay_name`,
  `b`.`parent_objid` AS `barangay_parentid`,
  `rp`.`purok` AS `purok`,
  `rp`.`street` AS `street` 
from  `examiner_finding` `ef` 
left join `subdivision_motherland` `sm` on `ef`.`parent_objid` = `sm`.`subdivisionid`  
left join `faas` `f` on `sm`.`landfaasid` = `f`.`objid`  
left join `rpu` `r` on `f`.`rpuid` = `r`.`objid`  
left join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid`  
left join `sys_org` `b` on `rp`.`barangayid` = `b`.`objid`  
left join `sys_org` `o` on `f`.`lguid` = `o`.`objid`  

union all 

select `ef`.`objid` AS `objid`,
  `ef`.`findings` AS `findings`,
  `ef`.`parent_objid` AS `parent_objid`,
  `ef`.`dtinspected` AS `dtinspected`,
  `ef`.`inspectors` AS `inspectors`,
  `ef`.`notedby` AS `notedby`,
  `ef`.`notedbytitle` AS `notedbytitle`,
  `ef`.`photos` AS `photos`,
  `ef`.`recommendations` AS `recommendations`,
  `ef`.`inspectedby_objid` AS `inspectedby_objid`,
  `ef`.`inspectedby_name` AS `inspectedby_name`,
  `ef`.`inspectedby_title` AS `inspectedby_title`,
  `ef`.`doctype` AS `doctype`,
  `ef`.`txnno` AS `txnno`,
  `f`.`owner_name` AS `owner_name`,
  `f`.`owner_address` AS `owner_address`,
  `f`.`titleno` AS `titleno`,
  `f`.`fullpin` AS `fullpin`,
  `rp`.`blockno` AS `blockno`,
  `rp`.`cadastrallotno` AS `cadastrallotno`,
  `r`.`totalareaha` AS `totalareaha`,
  `r`.`totalareasqm` AS `totalareasqm`,
  `r`.`totalmv` AS `totalmv`,
  `r`.`totalav` AS `totalav`,
  `f`.`lguid` AS `lguid`,
  `o`.`name` AS `lgu_name`,
  `rp`.`barangayid` AS `barangayid`,
  `b`.`name` AS `barangay_name`,
  `b`.`parent_objid` AS `barangay_parentid`,
  `rp`.`purok` AS `purok`,
  `rp`.`street` AS `street` 
from  `examiner_finding` `ef` 
join `consolidation` `c` on `ef`.`parent_objid` = `c`.`objid`  
left join `faas` `f` on `c`.`newfaasid` = `f`.`objid`  
left join `rpu` `r` on `f`.`rpuid` = `r`.`objid`  
left join `realproperty` `rp` on `f`.`realpropertyid` = `rp`.`objid`  
left join `sys_org` `b` on `rp`.`barangayid` = `b`.`objid`  
left join `sys_org` `o` on `f`.`lguid` = `o`.`objid`  

union all 

select `ef`.`objid` AS `objid`,
  `ef`.`findings` AS `findings`,
  `ef`.`parent_objid` AS `parent_objid`,
  `ef`.`dtinspected` AS `dtinspected`,
  `ef`.`inspectors` AS `inspectors`,
  `ef`.`notedby` AS `notedby`,
  `ef`.`notedbytitle` AS `notedbytitle`,
  `ef`.`photos` AS `photos`,
  `ef`.`recommendations` AS `recommendations`,
  `ef`.`inspectedby_objid` AS `inspectedby_objid`,
  `ef`.`inspectedby_name` AS `inspectedby_name`,
  `ef`.`inspectedby_title` AS `inspectedby_title`,
  `ef`.`doctype` AS `doctype`,
  `ef`.`txnno` AS `txnno`,'
  ' AS `owner_name`,'
  ' AS `owner_address`,'
  ' AS `titleno`,'
  ' AS `fullpin`,'
  ' AS `blockno`,'
  ' AS `cadastrallotno`
  ,0 AS `totalareaha`
  ,0 AS `totalareasqm`
  ,0 AS `totalmv`
  ,0 AS `totalav`,
  `o`.`objid` AS `lguid`,
  `o`.`name` AS `lgu_name`,
  `b`.`objid` AS `barangayid`,
  `b`.`name` AS `barangay_name`,
  `b`.`parent_objid` AS `barangay_parentid`,'
  ' AS `purok`,'
  ' AS `street` 
from  `examiner_finding` `ef` 
join `batchgr` `bgr` on `ef`.`parent_objid` = `bgr`.`objid`  
join `sys_org` `b` on `bgr`.`barangay_objid` = `b`.`objid`  
join `sys_org` `o` on `bgr`.`lgu_objid` = `o`.`objid` 
;






set @ruleset = 'rptledger' 
;

delete from sys_rule_action_param where parentid in ( 
  select ra.objid 
  from sys_rule r, sys_rule_action ra 
  where r.ruleset=@ruleset and ra.parentid=r.objid 
)
;
delete from sys_rule_actiondef_param where parentid in ( 
  select ra.objid from sys_ruleset_actiondef rsa 
    inner join sys_rule_actiondef ra on ra.objid=rsa.actiondef 
  where rsa.ruleset=@ruleset
);
delete from sys_rule_actiondef where objid in ( 
  select actiondef from sys_ruleset_actiondef where ruleset=@ruleset 
);
delete from sys_rule_action where parentid in ( 
  select objid from sys_rule 
  where ruleset=@ruleset 
)
;
delete from sys_rule_condition_constraint where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)
;
delete from sys_rule_condition_var where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)
;
delete from sys_rule_condition where parentid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)
;
delete from sys_rule_deployed where objid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)
;
delete from sys_rule where ruleset=@ruleset 
;
delete from sys_ruleset_fact where ruleset=@ruleset
;
delete from sys_ruleset_actiondef where ruleset=@ruleset
;
delete from sys_rulegroup where ruleset=@ruleset 
;
delete from sys_ruleset where name=@ruleset 
;


set @ruleset = 'rptbilling' 
;

delete from sys_rule_action_param where parentid in ( 
  select ra.objid 
  from sys_rule r, sys_rule_action ra 
  where r.ruleset=@ruleset and ra.parentid=r.objid 
)
;
delete from sys_rule_actiondef_param where parentid in ( 
  select ra.objid from sys_ruleset_actiondef rsa 
    inner join sys_rule_actiondef ra on ra.objid=rsa.actiondef 
  where rsa.ruleset=@ruleset
);
delete from sys_rule_actiondef where objid in ( 
  select actiondef from sys_ruleset_actiondef where ruleset=@ruleset 
);
delete from sys_rule_action where parentid in ( 
  select objid from sys_rule 
  where ruleset=@ruleset 
)
;
delete from sys_rule_condition_constraint where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)
;
delete from sys_rule_condition_var where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)
;
delete from sys_rule_condition where parentid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)
;
delete from sys_rule_deployed where objid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)
;
delete from sys_rule where ruleset=@ruleset 
;
delete from sys_ruleset_fact where ruleset=@ruleset
;
delete from sys_ruleset_actiondef where ruleset=@ruleset
;
delete from sys_rulegroup where ruleset=@ruleset 
;
delete from sys_ruleset where name=@ruleset 
;




SET FOREIGN_KEY_CHECKS = 0;

alter table sys_rule add _ukey varchar(255);

INSERT IGNORE INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('rptbilling', 'RPT Billing Rules', 'rptbilling', 'LANDTAX', 'RULE_AUTHOR', NULL);
INSERT IGNORE INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('rptledger', 'Ledger Billing Rules', 'rptledger', 'LANDTAX', 'RULE_AUTHOR', NULL);
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_DISCOUNT', 'rptbilling', 'After Discount Computation', '10');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_PENALTY', 'rptbilling', 'After Penalty Computation', '8');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_SUMMARY', 'rptbilling', 'After Summary', '21');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_TAX', 'rptledger', 'Post Tax Computation', '3');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE_SUMMARY', 'rptbilling', 'Before Summary ', '19');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BRGY_SHARE', 'rptbilling', 'Barangay Share Computation', '25');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('DISCOUNT', 'rptbilling', 'Discount Computation', '9');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('INIT', 'rptbilling', 'Init', '0');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('INIT', 'rptledger', 'Init', '0');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('LEDGER_ITEM', 'rptledger', 'Ledger Item Posting', '1');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('LGU_SHARE', 'rptbilling', 'LGU Share Computation', '26');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('PENALTY', 'rptbilling', 'Penalty Computation', '7');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('PROV_SHARE', 'rptbilling', 'Province Share Computation', '27');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('SUMMARY', 'rptbilling', 'Summary', '20');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('TAX', 'rptledger', 'Tax Computation', '2');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddBasic');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.AddBillItem');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddFireCode');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddIdleLand');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddSef');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.AddShare');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddSocialHousing');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.AggregateLedgerItem');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.CalcDiscount');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.CalcInterest');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.CalcTax');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.CreateTaxSummary');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.RemoveLedgerItem');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.SetBillExpiryDate');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.SplitByQtr');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.SplitLedgerItem');
INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.UpdateAV');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'CurrentDate');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.AssessedValue');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.Bill');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.Classification');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTBillItem');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTIncentive');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTLedgerFact');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.RPTLedgerFact');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTLedgerItemFact');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.RPTLedgerItemFact');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTLedgerTag');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.RPTLedgerTag');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.ShareFact');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-1a2d6e9b:1692d429304:-7779', 'DEPLOYED', 'BASIC_AND_SEF', 'rptledger', 'LEDGER_ITEM', 'BASIC_AND_SEF', NULL, '50000', NULL, NULL, '2019-02-27 12:48:06', 'USR-12b70fa0:16929d068ad:-7e8e', 'LANDTAX', '1', 'RUL-1a2d6e9b:1692d429304:-7779');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-2a65218f:180558e7346:-77a0', 'DEPLOYED', 'DISCOUNT_CURRENT', 'rptbilling', 'DISCOUNT', 'DISCOUNT_CURRENT', NULL, '50000', NULL, NULL, '2022-04-23 16:56:17', 'USR7e15465b:14a51353b1a:-7fb7', 'ADMIN', '1', '');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL-2ede6703:16642adb9ce:-7ba0', 'DEPLOYED', 'EXPIRY_ADVANCE_BILLING', 'rptbilling', 'BEFORE_SUMMARY', 'EXPIRY ADVANCE BILLING', NULL, '5000', NULL, NULL, '2018-10-05 01:28:47', 'USR6bd70b1f:1662cdef89a:-7e3e', 'RAMESES', '1', 'RUL-2ede6703:16642adb9ce:-7ba0');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL1262ad19:166ae41b1fb:-7c88', 'DEPLOYED', 'TOTAL_PREVIOUS', 'rptbilling', 'SUMMARY', 'TOTAL PREVIOUS', NULL, '50000', NULL, NULL, '2018-10-25 22:55:00', 'USR6de55768:158e0e57805:-74f2', 'ADMIN', '1', 'RUL1262ad19:166ae41b1fb:-7c88');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL3e7cce43:16b25a6ae3b:-2657', 'DEPLOYED', 'PENALTY_1992_TO_LESS_CY', 'rptbilling', 'PENALTY', 'PENALTY_1992_TO_LESS_CY', NULL, '50000', NULL, NULL, '2019-06-05 03:46:36', 'USR-ADMIN', 'ADMIN', '1', 'RUL3e7cce43:16b25a6ae3b:-2657');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL3e7cce43:16b25a6ae3b:-2ade', 'DEPLOYED', 'PENALTY_1986_TO_1991', 'rptbilling', 'PENALTY', 'PENALTY_1986_TO_1991', NULL, '50000', NULL, NULL, '2019-06-05 03:43:12', 'USR-ADMIN', 'ADMIN', '1', 'RUL3e7cce43:16b25a6ae3b:-2ade');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL3e7cce43:16b25a6ae3b:-2c01', 'DEPLOYED', 'PENALTY_1985_BELOW', 'rptbilling', 'PENALTY', 'PENALTY_1985_BELOW', NULL, '50000', NULL, NULL, '2019-06-05 03:40:48', 'USR-ADMIN', 'ADMIN', '1', 'RUL3e7cce43:16b25a6ae3b:-2c01');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL483027b0:16be9375c61:-77e6', 'DEPLOYED', 'BASIC_AND_SEF_TAX', 'rptledger', 'TAX', 'BASIC AND SEF TAX', NULL, '50000', NULL, NULL, '2019-07-13 10:51:37', 'USR-ADMIN', 'ADMIN', '1', 'RUL483027b0:16be9375c61:-77e6');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL560f5a64:1735a1dbaf4:-788a', 'DEPLOYED', 'BACKTAX_ADJ', 'rptbilling', 'AFTER_PENALTY', 'BACKTAX ADJUSTMENT', NULL, '50000', NULL, NULL, '2020-07-17 11:00:23', 'USR74d5cecb:1504597ea1b:-7e0b', 'LEE', '1', 'RUL560f5a64:1735a1dbaf4:-788a');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RUL7e02b404:166ae687f42:-5511', 'DEPLOYED', 'PENALTY_CURRENT_YEAR', 'rptbilling', 'PENALTY', 'PENALTY_CURRENT_YEAR', NULL, '50000', NULL, NULL, '2018-10-25 23:53:42', 'USR6de55768:158e0e57805:-74f2', 'ADMIN', '1', 'RUL7e02b404:166ae687f42:-5511');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-255e', 'DEPLOYED', 'BUILD_BILL_ITEMS', 'rptbilling', 'AFTER_SUMMARY', 'BUILD BILL ITEMS', NULL, '50000', NULL, NULL, '2018-09-29 00:27:14', 'USR-ADMIN', 'ADMIN', '1', 'RULec9d7ab:166235c2e16:-255e');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-26bf', 'DEPLOYED', 'TOTAL_ADVANCE', 'rptbilling', 'SUMMARY', 'TOTAL ADVANCE', NULL, '50000', NULL, NULL, '2018-09-29 00:26:00', 'USR-ADMIN', 'ADMIN', '1', 'RULec9d7ab:166235c2e16:-26bf');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-26d0', 'DEPLOYED', 'TOTAL_CURRENT', 'rptbilling', 'SUMMARY', 'TOTAL_CURRENT', NULL, '50000', NULL, NULL, '2018-09-29 00:25:49', 'USR-ADMIN', 'ADMIN', '1', 'RULec9d7ab:166235c2e16:-26d0');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-2f1f', 'DEPLOYED', 'EXPIRY_DATE_DEFAULT', 'rptbilling', 'BEFORE_SUMMARY', 'EXPIRY DATE DEFAULT', NULL, '10000', NULL, NULL, '2018-09-29 00:17:38', 'USR-ADMIN', 'ADMIN', '1', 'RULec9d7ab:166235c2e16:-2f1f');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-319f', 'DEPLOYED', 'EXPIRY_DATE_ADVANCE_YEAR', 'rptbilling', 'BEFORE_SUMMARY', 'EXPIRY_DATE_ADVANCE_YEAR', NULL, '5000', NULL, NULL, '2018-09-29 00:14:01', 'USR-ADMIN', 'ADMIN', '1', 'RULec9d7ab:166235c2e16:-319f');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-3811', 'DEPLOYED', 'SPLIT_QUARTERLY_BILLED_ITEMS', 'rptbilling', 'BEFORE_SUMMARY', 'SPLIT QUARTERLY BILLED ITEMS', NULL, '50000', NULL, NULL, '2018-09-29 00:07:10', 'USR-ADMIN', 'ADMIN', '1', 'RULec9d7ab:166235c2e16:-3811');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-3c17', 'DEPLOYED', 'AGGREGATE_PREVIOUS_ITEMS', 'rptbilling', 'BEFORE_SUMMARY', 'AGGREGATE PREVIOUS ITEMS', NULL, '60000', NULL, NULL, '2018-09-29 00:05:33', 'USR-ADMIN', 'ADMIN', '1', 'RULec9d7ab:166235c2e16:-3c17');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-4197', 'DEPLOYED', 'DISCOUNT_ADVANCE', 'rptbilling', 'DISCOUNT', 'DISCOUNT_ADVANCE', NULL, '40000', NULL, NULL, '2018-09-29 00:02:22', 'USR-ADMIN', 'ADMIN', '1', 'RULec9d7ab:166235c2e16:-4197');
INSERT IGNORE INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`, `_ukey`) VALUES ('RULec9d7ab:166235c2e16:-5fcb', 'DEPLOYED', 'SPLIT_QTR', 'rptbilling', 'INIT', 'SPLIT_QTR', NULL, '50000', NULL, NULL, '2018-09-28 23:48:57', 'USR-ADMIN', 'ADMIN', '1', 'RULec9d7ab:166235c2e16:-5fcb');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-1a2d6e9b:1692d429304:-7779', '\npackage rptledger.BASIC_AND_SEF;\nimport rptledger.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BASIC_AND_SEF\"\n	agenda-group \"LEDGER_ITEM\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		AVINFO: rptis.landtax.facts.AssessedValue (  YR:year,AV:av ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"AVINFO\", AVINFO );\n		\n		bindings.put(\"YR\", YR );\n		\n		bindings.put(\"AV\", AV );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"avfact\", AVINFO );\r\n_p0.put( \"year\", YR );\r\n_p0.put( \"av\", (new ActionExpression(\"AV\", bindings)) );\r\naction.execute( \"add-sef\",_p0,drools);\r\nMap _p1 = new HashMap();\r\n_p1.put( \"avfact\", AVINFO );\r\n_p1.put( \"year\", YR );\r\n_p1.put( \"av\", (new ActionExpression(\"AV\", bindings)) );\r\naction.execute( \"add-basic\",_p1,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-2a65218f:180558e7346:-77a0', '\npackage rptbilling.DISCOUNT_CURRENT;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"DISCOUNT_CURRENT\"\n	agenda-group \"DISCOUNT\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year,CQTR:qtr ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CY,qtr >= CQTR,TAX:amtdue ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"CQTR\", CQTR );\n		\n		bindings.put(\"TAX\", TAX );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND(TAX * 0.20)\", bindings)) );\r\naction.execute( \"calc-discount\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-2ede6703:16642adb9ce:-7ba0', '\npackage rptbilling.EXPIRY_ADVANCE_BILLING;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"EXPIRY_ADVANCE_BILLING\"\n	agenda-group \"BEFORE_SUMMARY\"\n	salience 5000\n	no-loop\n	when\n		\n		\n		BILL: rptis.landtax.facts.Bill (  advancebill == true ,BILLDATE:billdate ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"BILL\", BILL );\n		\n		bindings.put(\"BILLDATE\", BILLDATE );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"bill\", BILL );\r\n_p0.put( \"expr\", (new ActionExpression(\"@MONTHEND( BILLDATE )\", bindings)) );\r\naction.execute( \"set-bill-expiry\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL1262ad19:166ae41b1fb:-7c88', '\npackage rptbilling.TOTAL_PREVIOUS;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOTAL_PREVIOUS\"\n	agenda-group \"SUMMARY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year < CY ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"revperiod\", \"previous\" );\r\naction.execute( \"create-tax-summary\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL3e7cce43:16b25a6ae3b:-2657', '\npackage rptbilling.PENALTY_1992_TO_LESS_CY;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"PENALTY_1992_TO_LESS_CY\"\n	agenda-group \"PENALTY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year < CY,NMON:monthsfromjan,year >= 1992,TAX:amtdue ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"NMON\", NMON );\n		\n		bindings.put(\"TAX\", TAX );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND(@IIF( NMON * 0.02 > 0.72, TAX * 0.72, TAX * NMON * 0.02))\", bindings)) );\r\naction.execute( \"calc-interest\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL3e7cce43:16b25a6ae3b:-2ade', '\npackage rptbilling.PENALTY_1986_TO_1991;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"PENALTY_1986_TO_1991\"\n	agenda-group \"PENALTY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  NMON:monthsfromjan,year >= 1986,TAX:amtdue,year <= 1991 ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"NMON\", NMON );\n		\n		bindings.put(\"TAX\", TAX );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND(TAX * NMON * 0.02)\", bindings)) );\r\naction.execute( \"calc-interest\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL3e7cce43:16b25a6ae3b:-2c01', '\npackage rptbilling.PENALTY_1985_BELOW;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"PENALTY_1985_BELOW\"\n	agenda-group \"PENALTY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year <= 1985,NMON:monthsfromjan,TAX:amtdue ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"NMON\", NMON );\n		\n		bindings.put(\"TAX\", TAX );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND(TAX * 0.24)\", bindings)) );\r\naction.execute( \"calc-interest\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL483027b0:16be9375c61:-77e6', '\npackage rptledger.BASIC_AND_SEF_TAX;\nimport rptledger.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BASIC_AND_SEF_TAX\"\n	agenda-group \"TAX\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  AV:av ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"AV\", AV );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"AV * 0.01\", bindings)) );\r\naction.execute( \"calc-tax\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL560f5a64:1735a1dbaf4:-788a', '\npackage rptbilling.BACKTAX_ADJ;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BACKTAX_ADJ\"\n	agenda-group \"AFTER_PENALTY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  backtax == true  ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLI\", RLI );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"0\", bindings)) );\r\naction.execute( \"calc-interest\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL7e02b404:166ae687f42:-5511', '\npackage rptbilling.PENALTY_CURRENT_YEAR;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"PENALTY_CURRENT_YEAR\"\n	agenda-group \"PENALTY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year,CQTR:qtr > 1 ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  revtype matches \"basic|sef\",year == CY,TAX:amtdue,NMON:monthsfromjan ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"CQTR\", CQTR );\n		\n		bindings.put(\"NMON\", NMON );\n		\n		bindings.put(\"TAX\", TAX );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"TAX * NMON * 0.02\", bindings)) );\r\naction.execute( \"calc-interest\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-255e', '\npackage rptbilling.BUILD_BILL_ITEMS;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BUILD_BILL_ITEMS\"\n	agenda-group \"AFTER_SUMMARY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		RLTS: rptis.landtax.facts.RPTLedgerTaxSummaryFact (   ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLTS\", RLTS );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"taxsummary\", RLTS );\r\naction.execute( \"add-billitem\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-26bf', '\npackage rptbilling.TOTAL_ADVANCE;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOTAL_ADVANCE\"\n	agenda-group \"SUMMARY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year > CY ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"revperiod\", \"advance\" );\r\naction.execute( \"create-tax-summary\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-26d0', '\npackage rptbilling.TOTAL_CURRENT;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOTAL_CURRENT\"\n	agenda-group \"SUMMARY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CY ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"revperiod\", \"current\" );\r\naction.execute( \"create-tax-summary\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-2f1f', '\npackage rptbilling.EXPIRY_DATE_DEFAULT;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"EXPIRY_DATE_DEFAULT\"\n	agenda-group \"BEFORE_SUMMARY\"\n	salience 10000\n	no-loop\n	when\n		\n		\n		BILL: rptis.landtax.facts.Bill (  CDATE:currentdate ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"BILL\", BILL );\n		\n		bindings.put(\"CDATE\", CDATE );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"bill\", BILL );\r\n_p0.put( \"expr\", (new ActionExpression(\"@MONTHEND( CDATE )\", bindings)) );\r\naction.execute( \"set-bill-expiry\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-319f', '\npackage rptbilling.EXPIRY_DATE_ADVANCE_YEAR;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"EXPIRY_DATE_ADVANCE_YEAR\"\n	agenda-group \"BEFORE_SUMMARY\"\n	salience 5000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RL: rptis.landtax.facts.RPTLedgerFact (  lastyearpaid == CY,lastqtrpaid == 4 ) \n		\n		BILL: rptis.landtax.facts.Bill (  billtoyear > CY ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RL\", RL );\n		\n		bindings.put(\"BILL\", BILL );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"bill\", BILL );\r\n_p0.put( \"expr\", (new ActionExpression(\"@MONTHEND(@DATE(CY, 12, 1));\", bindings)) );\r\naction.execute( \"set-bill-expiry\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-3811', '\npackage rptbilling.SPLIT_QUARTERLY_BILLED_ITEMS;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"SPLIT_QUARTERLY_BILLED_ITEMS\"\n	agenda-group \"BEFORE_SUMMARY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  qtrly == false ,revtype matches \"basic|sef\" ) \n		\n		BILL: rptis.landtax.facts.Bill (  forpayment == true  ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"BILL\", BILL );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\naction.execute( \"split-bill-item\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-3c17', '\npackage rptbilling.AGGREGATE_PREVIOUS_ITEMS;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"AGGREGATE_PREVIOUS_ITEMS\"\n	agenda-group \"BEFORE_SUMMARY\"\n	salience 60000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year < CY,qtrly == true  ) \n		\n		BILL: rptis.landtax.facts.Bill (  forpayment == false  ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"BILL\", BILL );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\naction.execute( \"aggregate-bill-item\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-4197', '\npackage rptbilling.DISCOUNT_ADVANCE;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"DISCOUNT_ADVANCE\"\n	agenda-group \"DISCOUNT\"\n	salience 40000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year > CY,TAX:amtdue ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"TAX\", TAX );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND(TAX * 0.20)\", bindings)) );\r\naction.execute( \"calc-discount\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-5fcb', '\npackage rptbilling.SPLIT_QTR;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"SPLIT_QTR\"\n	agenda-group \"INIT\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year >= CY ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\naction.execute( \"split-by-qtr\",_p0,drools);\r\n\nend\n\n\n	');
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('CurrentDate', 'CurrentDate', 'Current Date', 'CurrentDate', '1', '', '', NULL, '', '', '', '', '', '', 'LANDTAX', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.AssessedValue', 'rptis.landtax.facts.AssessedValue', 'Assessed Value', 'rptis.landtax.facts.AssessedValue', '2', NULL, 'AVINFO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'Bill', 'rptis.landtax.facts.Bill', '2', NULL, 'BILL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.Classification', 'rptis.landtax.facts.Classification', 'Classification', 'rptis.landtax.facts.Classification', '0', NULL, 'CLASS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTBillItem', 'rptis.landtax.facts.RPTBillItem', 'Bill Item', 'rptis.landtax.facts.RPTBillItem', '3', NULL, 'BILLITEM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTIncentive', 'rptis.landtax.facts.RPTIncentive', 'Incentive', 'rptis.landtax.facts.RPTIncentive', '10', NULL, 'INCENTIVE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTLedgerFact', 'rptis.landtax.facts.RPTLedgerFact', 'Ledger', 'rptis.landtax.facts.RPTLedgerFact', '5', NULL, 'RL', '0', '', '', '', '', '', NULL, 'landtax', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'Ledger Item', 'rptis.landtax.facts.RPTLedgerItemFact', '6', NULL, 'RLI', NULL, '', '', '', '', '', NULL, 'landtax', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTLedgerTag', 'rptis.landtax.facts.RPTLedgerTag', 'Ledger Tag', 'rptis.landtax.facts.RPTLedgerTag', '20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'LANDTAX', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'Tax Summary', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', '21', NULL, 'RLTS', NULL, '', '', '', '', '', NULL, 'landtax', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.ShareFact', 'rptis.landtax.facts.ShareFact', 'Share', 'rptis.landtax.facts.ShareFact', '50', NULL, 'LSH', NULL, '', '', '', '', '', NULL, 'landtax', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT17d6e7ce:141df4b60c2:-7c21', 'assessedvalue', 'Assessed Value Data', 'rptis.landtax.facts.AssessedValueFact', '20', NULL, NULL, NULL, '', '', '', '', '', NULL, 'LANDTAX', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT357018a9:1452a5dcbf7:-793b', 'ShareInfoFact', 'LGU Share Info', 'rptis.landtax.facts.ShareInfoFact', '50', NULL, 'LSH', NULL, '', '', '', '', '', NULL, 'LANDTAX', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT547c5381:1451ae1cd9c:-75e0', 'paymentoption', 'Payment Option', 'rptis.landtax.facts.PaymentOptionFact', '2', NULL, NULL, NULL, '', '', '', '', '', NULL, 'LANDTAX', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('CurrentDate.day', 'CurrentDate', 'day', 'Day', 'integer', '4', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('CurrentDate.month', 'CurrentDate', 'month', 'Month', 'integer', '3', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('CurrentDate.qtr', 'CurrentDate', 'qtr', 'Quarter', 'integer', '2', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('CurrentDate.year', 'CurrentDate', 'year', 'Year', 'integer', '1', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-20603cf4:146f0c708c1:-7a25', 'RULFACT357018a9:1452a5dcbf7:-793b', 'lguid', 'LGU', 'string', '4', 'lookup', 'municipality:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD17d6e7ce:141df4b60c2:-7c0c', 'RULFACT17d6e7ce:141df4b60c2:-7c21', 'assessedvalue', 'Assessed Value', 'decimal', '2', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD17d6e7ce:141df4b60c2:-7c13', 'RULFACT17d6e7ce:141df4b60c2:-7c21', 'year', 'Year', 'integer', '1', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-332b', 'RULFACT357018a9:1452a5dcbf7:-793b', 'lgutype', 'LGU Type', 'string', '1', 'lov', '', '', '', '', NULL, '1', 'string', 'RPT_BILLING_LGU_TYPES');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3ee8', 'RULFACT357018a9:1452a5dcbf7:-793b', 'sefint', 'SEF Interest', 'decimal', '11', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f01', 'RULFACT357018a9:1452a5dcbf7:-793b', 'sefdisc', 'SEF Discount', 'decimal', '10', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f1a', 'RULFACT357018a9:1452a5dcbf7:-793b', 'sef', 'SEF', 'decimal', '9', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f33', 'RULFACT357018a9:1452a5dcbf7:-793b', 'basicint', 'Basic Interest', 'decimal', '8', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f4c', 'RULFACT357018a9:1452a5dcbf7:-793b', 'basicdisc', 'Basic Discount', 'decimal', '7', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f65', 'RULFACT357018a9:1452a5dcbf7:-793b', 'basic', 'Basic', 'decimal', '6', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-45b2', 'RULFACT357018a9:1452a5dcbf7:-793b', 'revperiod', 'Revenue Period', 'string', '3', 'lov', '', '', '', '', NULL, '1', 'string', 'RPT_REVENUE_PERIODS');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-608c', 'RULFACT357018a9:1452a5dcbf7:-793b', 'barangay', 'Barangay', 'string', '5', 'lookup', 'barangay:lookup', 'objid', 'name', '', NULL, NULL, 'string', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD2701c487:141e346f838:-7f2e', 'RULFACT17d6e7ce:141df4b60c2:-7c21', 'rptledger', 'RPT Ledger', 'string', '3', 'var', '', '', '', '', NULL, NULL, 'rptis.landtax.facts.RPTLedgerFact', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD357018a9:1452a5dcbf7:-7765', 'RULFACT357018a9:1452a5dcbf7:-793b', 'sharetype', 'Share Type', 'string', '2', 'lov', '', '', '', '', NULL, '0', 'string', 'RPT_BILLING_SHARE_TYPES');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD441bb08f:1436c079bff:-7fc1', 'RULFACT17d6e7ce:141df4b60c2:-7c21', 'qtrlyav', 'Quarterly Assessed Value', 'decimal', '4', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD547c5381:1451ae1cd9c:-75c6', 'RULFACT547c5381:1451ae1cd9c:-75e0', 'type', 'Type', 'string', '1', 'lov', '', '', '', '', NULL, NULL, 'string', 'RPT_BILLING_PAYMENT_OPTIONS');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.actualuse', 'rptis.landtax.facts.AssessedValue', 'actualuse', 'Actual Use', 'string', '4', 'var', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, '0', 'rptis.landtax.facts.Classification', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.av', 'rptis.landtax.facts.AssessedValue', 'av', 'Assessed Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, '1', 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.basicav', 'rptis.landtax.facts.AssessedValue', 'basicav', 'Basic Assessed Value', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.classification', 'rptis.landtax.facts.AssessedValue', 'classification', 'Classification', 'string', '3', 'var', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'rptis.landtax.facts.Classification', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.idleland', 'rptis.landtax.facts.AssessedValue', 'idleland', 'Is Idle Land?', 'boolean', '9', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.rputype', 'rptis.landtax.facts.AssessedValue', 'rputype', 'Property Type', 'string', '1', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_RPUTYPES');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.sefav', 'rptis.landtax.facts.AssessedValue', 'sefav', 'SEF Assessed Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.txntype', 'rptis.landtax.facts.AssessedValue', 'txntype', 'Transaction Type', 'string', '2', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_TXN_TYPES');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.year', 'rptis.landtax.facts.AssessedValue', 'year', 'Year', 'integer', '5', 'integer', NULL, NULL, NULL, NULL, NULL, '1', 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.advancebill', 'rptis.landtax.facts.Bill', 'advancebill', 'Is Advance Billing?', 'boolean', '6', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.billdate', 'rptis.landtax.facts.Bill', 'billdate', 'Bill Date', 'date', '5', 'date', NULL, NULL, NULL, NULL, NULL, NULL, 'date', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.billtoqtr', 'rptis.landtax.facts.Bill', 'billtoqtr', 'Quarter', 'integer', '2', 'integer', NULL, NULL, NULL, NULL, NULL, '0', 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.billtoyear', 'rptis.landtax.facts.Bill', 'billtoyear', 'Year', 'integer', '1', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.currentdate', 'rptis.landtax.facts.Bill', 'currentdate', 'Current Date', 'date', '3', 'date', NULL, NULL, NULL, NULL, NULL, NULL, 'date', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.forpayment', 'rptis.landtax.facts.Bill', 'forpayment', 'Is for Payment?', 'boolean', '4', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Classification.objid', 'rptis.landtax.facts.Classification', 'objid', 'Classification', 'string', '1', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.amount', 'rptis.landtax.facts.RPTBillItem', 'amount', 'Amount', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.parentacctid', 'rptis.landtax.facts.RPTBillItem', 'parentacctid', 'Account', 'string', '1', 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.revperiod', 'rptis.landtax.facts.RPTBillItem', 'revperiod', 'Revenue Period', 'string', '3', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_REVENUE_PERIODS');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.revtype', 'rptis.landtax.facts.RPTBillItem', 'revtype', 'Revenue Type', 'string', '2', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BILLING_REVENUE_TYPES');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.sharetype', 'rptis.landtax.facts.RPTBillItem', 'sharetype', 'Share Type', 'string', '4', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BILLING_LGU_TYPES');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.basicrate', 'rptis.landtax.facts.RPTIncentive', 'basicrate', 'Basic Rate', 'decimal', '2', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.fromyear', 'rptis.landtax.facts.RPTIncentive', 'fromyear', 'From Year', 'integer', '4', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.rptledger', 'rptis.landtax.facts.RPTIncentive', 'rptledger', 'Ledger', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerFact', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.sefrate', 'rptis.landtax.facts.RPTIncentive', 'sefrate', 'SEF Rate', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.toyear', 'rptis.landtax.facts.RPTIncentive', 'toyear', 'To Year', 'integer', '5', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.barangay', 'rptis.landtax.facts.RPTLedgerFact', 'barangay', 'Barangay', 'string', '8', 'lookup', 'barangay:lookup', 'objid', 'name', '', NULL, NULL, 'string', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.barangayid', 'rptis.landtax.facts.RPTLedgerFact', 'barangayid', 'Barangay ID', 'string', '12', 'lookup', 'barangay:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.firstqtrpaidontime', 'rptis.landtax.facts.RPTLedgerFact', 'firstqtrpaidontime', '1st Qtr is Paid On-Time', 'boolean', '4', 'boolean', '', '', '', '', NULL, NULL, 'boolean', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.lastqtrpaid', 'rptis.landtax.facts.RPTLedgerFact', 'lastqtrpaid', 'Last Qtr Paid', 'integer', '3', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.lastyearpaid', 'rptis.landtax.facts.RPTLedgerFact', 'lastyearpaid', 'Last Year Paid', 'integer', '2', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.lguid', 'rptis.landtax.facts.RPTLedgerFact', 'lguid', 'LGU ID', 'string', '11', 'lookup', 'municipality:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.missedpayment', 'rptis.landtax.facts.RPTLedgerFact', 'missedpayment', 'Has missed current year Quarterly Payment?', 'boolean', '7', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.objid', 'rptis.landtax.facts.RPTLedgerFact', 'objid', 'Objid', 'string', '1', 'lookup', 'rptledger:lookup', 'objid', 'tdno', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.parentlguid', 'rptis.landtax.facts.RPTLedgerFact', 'parentlguid', 'Parent LGU', 'string', '10', 'lookup', 'province:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.qtrlypaymentpaidontime', 'rptis.landtax.facts.RPTLedgerFact', 'qtrlypaymentpaidontime', 'Quarterly Payment is Paid On-Time', 'boolean', '5', 'boolean', '', '', '', '', NULL, NULL, 'boolean', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.rputype', 'rptis.landtax.facts.RPTLedgerFact', 'rputype', 'Property Type', 'string', '9', 'lov', '', '', '', '', NULL, NULL, 'string', 'RPT_RPUTYPES');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.undercompromise', 'rptis.landtax.facts.RPTLedgerFact', 'undercompromise', 'Is under Compromise?', 'boolean', '6', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.actualuse', 'rptis.landtax.facts.RPTLedgerItemFact', 'actualuse', 'Actual Use', 'string', '9', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'rptis.landtax.facts.RPTLedgerItemFact', 'amtdue', 'Tax', 'decimal', '21', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.av', 'rptis.landtax.facts.RPTLedgerItemFact', 'av', 'Assessed Value', 'decimal', '4', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.backtax', 'rptis.landtax.facts.RPTLedgerItemFact', 'backtax', 'Is Back Tax?', 'boolean', '18', 'boolean', '', '', '', '', NULL, NULL, 'boolean', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.basicav', 'rptis.landtax.facts.RPTLedgerItemFact', 'basicav', 'AV for Basic', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.classification', 'rptis.landtax.facts.RPTLedgerItemFact', 'classification', 'Classification', 'string', '8', 'lookup', 'propertyclassification:lookup', 'objid', 'name', '', '0', NULL, 'string', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.discount', 'rptis.landtax.facts.RPTLedgerItemFact', 'discount', 'Discount', 'decimal', '23', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.fullypaid', 'rptis.landtax.facts.RPTLedgerItemFact', 'fullypaid', 'Is Fully Paid?', 'boolean', '13', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.idleland', 'rptis.landtax.facts.RPTLedgerItemFact', 'idleland', 'Is Idle Land?', 'boolean', '12', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.interest', 'rptis.landtax.facts.RPTLedgerItemFact', 'interest', 'Interest', 'decimal', '22', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.monthsfromjan', 'rptis.landtax.facts.RPTLedgerItemFact', 'monthsfromjan', 'Number of Months from January', 'integer', '17', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.monthsfromqtr', 'rptis.landtax.facts.RPTLedgerItemFact', 'monthsfromqtr', 'Number of Months From Quarter', 'integer', '16', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.originalav', 'rptis.landtax.facts.RPTLedgerItemFact', 'originalav', 'Original AV', 'decimal', '10', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.qtr', 'rptis.landtax.facts.RPTLedgerItemFact', 'qtr', 'Qtr', 'integer', '2', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.qtrly', 'rptis.landtax.facts.RPTLedgerItemFact', 'qtrly', 'Is quarterly computed?', 'boolean', '24', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.qtrlypaymentavailed', 'rptis.landtax.facts.RPTLedgerItemFact', 'qtrlypaymentavailed', 'Is Quarterly Payment?', 'boolean', '14', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.reclassed', 'rptis.landtax.facts.RPTLedgerItemFact', 'reclassed', 'Is Reclassed?', 'boolean', '11', 'boolean', '', '', '', '', NULL, NULL, 'boolean', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.revperiod', 'rptis.landtax.facts.RPTLedgerItemFact', 'revperiod', 'Revenue Period', 'string', '20', 'lov', '', '', '', '', NULL, NULL, 'string', 'RPT_REVENUE_PERIODS');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.revtype', 'rptis.landtax.facts.RPTLedgerItemFact', 'revtype', 'Revenue Type', 'string', '19', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BILLING_REVENUE_TYPES');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.rptledger', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptledger', 'RPT Ledger', 'string', '3', 'var', '', '', '', '', NULL, '0', 'rptis.landtax.facts.RPTLedgerFact', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.sefav', 'rptis.landtax.facts.RPTLedgerItemFact', 'sefav', 'AV for SEF', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.taxdifference', 'rptis.landtax.facts.RPTLedgerItemFact', 'taxdifference', 'Is Tax Difference?', 'boolean', '15', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.txntype', 'rptis.landtax.facts.RPTLedgerItemFact', 'txntype', 'Txn Type', 'string', '7', 'lov', '', '', '', '', NULL, NULL, 'string', 'RPT_TXN_TYPES');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.year', 'rptis.landtax.facts.RPTLedgerItemFact', 'year', 'Year', 'integer', '1', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTag.tag', 'rptis.landtax.facts.RPTLedgerTag', 'tag', 'Tag', 'string', '1', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.amount', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'amount', 'Amount', 'decimal', '6', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.discount', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'discount', 'Discount', 'decimal', '7', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.firecode', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'firecode', 'Fire Code', 'decimal', '10', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.interest', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'interest', 'Interest', 'decimal', '8', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.ledger', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'ledger', 'Ledger', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerFact', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.objid', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'objid', 'Variable Name', 'string', '2', 'lookup', 'rptparameter:lookup', 'name', 'name', '', NULL, '0', 'string', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.revperiod', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'revperiod', 'Revenue Period', 'string', '5', 'lov', NULL, NULL, NULL, NULL, NULL, '0', 'string', 'RPT_REVENUE_PERIODS');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.revtype', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'revtype', 'Revenue Type', 'string', '4', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BILLING_REVENUE_TYPES');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.rptledger', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'rptledger', 'RPT Ledger', 'string', '3', 'var', '', '', '', '', NULL, NULL, 'rptis.landtax.facts.RPTLedgerFact', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.sef', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'sef', 'SEF', 'decimal', '7', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.sefdisc', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'sefdisc', 'SEF Discount', 'decimal', '8', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.sefint', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'sefint', 'SEF Interest', 'decimal', '9', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.sh', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'sh', 'Socialized Housing Tax', 'decimal', '11', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.shdisc', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'shdisc', 'Socialized Housing Discount', 'decimal', '13', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.shint', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'shint', 'Socialized Housing Interest', 'decimal', '12', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.amount', 'rptis.landtax.facts.ShareFact', 'amount', 'Amount', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.barangay', 'rptis.landtax.facts.ShareFact', 'barangay', 'Barangay', 'string', '7', 'lookup', 'barangay:lookup', 'objid', 'name', '', NULL, NULL, 'string', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.basic', 'rptis.landtax.facts.ShareFact', 'basic', 'Basic', 'decimal', '6', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.basicdisc', 'rptis.landtax.facts.ShareFact', 'basicdisc', 'Basic Discount', 'decimal', '7', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.basicint', 'rptis.landtax.facts.ShareFact', 'basicint', 'Basic Interest', 'decimal', '8', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.discount', 'rptis.landtax.facts.ShareFact', 'discount', 'Discount', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.lguid', 'rptis.landtax.facts.ShareFact', 'lguid', 'LGU', 'string', '5', 'lookup', 'municipality:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.lgutype', 'rptis.landtax.facts.ShareFact', 'lgutype', 'LGU Type', 'string', '1', 'lov', '', '', '', '', NULL, '1', 'string', 'RPT_BILLING_LGU_TYPES');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.revperiod', 'rptis.landtax.facts.ShareFact', 'revperiod', 'Revenue Period', 'string', '4', 'lov', '', '', '', '', NULL, '1', 'string', 'RPT_REVENUE_PERIODS');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.revtype', 'rptis.landtax.facts.ShareFact', 'revtype', 'Revenue Type', 'string', '3', 'lov', NULL, NULL, NULL, NULL, NULL, '1', 'string', 'RPT_BILLING_REVENUE_TYPES');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sef', 'rptis.landtax.facts.ShareFact', 'sef', 'SEF', 'decimal', '9', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sefdisc', 'rptis.landtax.facts.ShareFact', 'sefdisc', 'SEF Discount', 'decimal', '10', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sefint', 'rptis.landtax.facts.ShareFact', 'sefint', 'SEF Interest', 'decimal', '11', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sh', 'rptis.landtax.facts.ShareFact', 'sh', 'Socialized Housing Tax', 'decimal', '12', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sharetype', 'rptis.landtax.facts.ShareFact', 'sharetype', 'Share Type', 'string', '2', 'lov', '', '', '', '', NULL, '1', 'string', 'RPT_BILLING_SHARE_TYPES');
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.shdisc', 'rptis.landtax.facts.ShareFact', 'shdisc', 'Socialized Housing Discount', 'decimal', '14', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.shint', 'rptis.landtax.facts.ShareFact', 'shint', 'Socialized Housing Interest', 'decimal', '13', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC-17442746:16be936f033:-7e86', 'RUL483027b0:16be9375c61:-77e6', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC-287581a5:180558e600d:-7d5d', 'RUL-2a65218f:180558e7346:-77a0', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC-287581a5:180558e600d:-7d61', 'RUL-2a65218f:180558e7346:-77a0', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC122cd182:16b250d7a42:-123b', 'RUL3e7cce43:16b25a6ae3b:-2c01', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC122cd182:16b250d7a42:-8f9', 'RUL3e7cce43:16b25a6ae3b:-2657', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC122cd182:16b250d7a42:-8fe', 'RUL3e7cce43:16b25a6ae3b:-2657', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC122cd182:16b250d7a42:-e9f', 'RUL3e7cce43:16b25a6ae3b:-2ade', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC440e47f4:166ae4152f1:-7fbe', 'RUL1262ad19:166ae41b1fb:-7c88', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC440e47f4:166ae4152f1:-7fc0', 'RUL1262ad19:166ae41b1fb:-7c88', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC70978a15:166ae6875d1:-7f22', 'RUL7e02b404:166ae687f42:-5511', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC70978a15:166ae6875d1:-7f24', 'RUL7e02b404:166ae687f42:-5511', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fad', 'RULec9d7ab:166235c2e16:-26bf', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7faf', 'RULec9d7ab:166235c2e16:-26bf', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fb4', 'RULec9d7ab:166235c2e16:-26d0', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fb6', 'RULec9d7ab:166235c2e16:-26d0', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fbb', 'RULec9d7ab:166235c2e16:-319f', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fbd', 'RULec9d7ab:166235c2e16:-319f', 'rptis.landtax.facts.RPTLedgerFact', 'rptis.landtax.facts.RPTLedgerFact', 'RL', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fc0', 'RULec9d7ab:166235c2e16:-319f', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '2', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fc7', 'RULec9d7ab:166235c2e16:-3811', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fc9', 'RULec9d7ab:166235c2e16:-3811', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '2', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fcf', 'RULec9d7ab:166235c2e16:-4197', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fd4', 'RULec9d7ab:166235c2e16:-4197', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-1a2d6e9b:1692d429304:-7748', 'RUL-1a2d6e9b:1692d429304:-7779', 'rptis.landtax.facts.AssessedValue', 'rptis.landtax.facts.AssessedValue', 'AVINFO', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-2ede6703:16642adb9ce:-7a39', 'RUL-2ede6703:16642adb9ce:-7ba0', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND560f5a64:1735a1dbaf4:-7826', 'RUL560f5a64:1735a1dbaf4:-788a', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-24fc', 'RULec9d7ab:166235c2e16:-255e', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'RLTS', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-2ec7', 'RULec9d7ab:166235c2e16:-2f1f', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-3905', 'RULec9d7ab:166235c2e16:-3c17', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '2', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-3b0b', 'RULec9d7ab:166235c2e16:-3c17', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-3baa', 'RULec9d7ab:166235c2e16:-3c17', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-5e7c', 'RULec9d7ab:166235c2e16:-5fcb', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-5f7f', 'RULec9d7ab:166235c2e16:-5fcb', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC-17442746:16be936f033:-7e86', 'RC-17442746:16be936f033:-7e86', 'RUL483027b0:16be9375c61:-77e6', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC-287581a5:180558e600d:-7d5d', 'RC-287581a5:180558e600d:-7d5d', 'RUL-2a65218f:180558e7346:-77a0', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC122cd182:16b250d7a42:-123b', 'RC122cd182:16b250d7a42:-123b', 'RUL3e7cce43:16b25a6ae3b:-2c01', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC122cd182:16b250d7a42:-8fe', 'RC122cd182:16b250d7a42:-8fe', 'RUL3e7cce43:16b25a6ae3b:-2657', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC122cd182:16b250d7a42:-e9f', 'RC122cd182:16b250d7a42:-e9f', 'RUL3e7cce43:16b25a6ae3b:-2ade', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC440e47f4:166ae4152f1:-7fc0', 'RC440e47f4:166ae4152f1:-7fc0', 'RUL1262ad19:166ae41b1fb:-7c88', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC70978a15:166ae6875d1:-7f22', 'RC70978a15:166ae6875d1:-7f22', 'RUL7e02b404:166ae687f42:-5511', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7faf', 'RC7280357:166235c1be7:-7faf', 'RULec9d7ab:166235c2e16:-26bf', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fb6', 'RC7280357:166235c1be7:-7fb6', 'RULec9d7ab:166235c2e16:-26d0', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fbd', 'RC7280357:166235c1be7:-7fbd', 'RULec9d7ab:166235c2e16:-319f', 'RL', 'rptis.landtax.facts.RPTLedgerFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fc0', 'RC7280357:166235c1be7:-7fc0', 'RULec9d7ab:166235c2e16:-319f', 'BILL', 'rptis.landtax.facts.Bill', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fc7', 'RC7280357:166235c1be7:-7fc7', 'RULec9d7ab:166235c2e16:-3811', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fc9', 'RC7280357:166235c1be7:-7fc9', 'RULec9d7ab:166235c2e16:-3811', 'BILL', 'rptis.landtax.facts.Bill', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fd4', 'RC7280357:166235c1be7:-7fd4', 'RULec9d7ab:166235c2e16:-4197', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC-17442746:16be936f033:-7e83', 'RC-17442746:16be936f033:-7e86', 'RUL483027b0:16be9375c61:-77e6', 'AV', 'decimal', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC-287581a5:180558e600d:-7d5b', 'RC-287581a5:180558e600d:-7d5d', 'RUL-2a65218f:180558e7346:-77a0', 'TAX', 'decimal', '3');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC-287581a5:180558e600d:-7d60', 'RC-287581a5:180558e600d:-7d61', 'RUL-2a65218f:180558e7346:-77a0', 'CY', 'integer', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-1239', 'RC122cd182:16b250d7a42:-123b', 'RUL3e7cce43:16b25a6ae3b:-2c01', 'NMON', 'integer', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-123a', 'RC122cd182:16b250d7a42:-123b', 'RUL3e7cce43:16b25a6ae3b:-2c01', 'TAX', 'decimal', '3');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8f8', 'RC122cd182:16b250d7a42:-8f9', 'RUL3e7cce43:16b25a6ae3b:-2657', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8fc', 'RC122cd182:16b250d7a42:-8fe', 'RUL3e7cce43:16b25a6ae3b:-2657', 'NMON', 'integer', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8fd', 'RC122cd182:16b250d7a42:-8fe', 'RUL3e7cce43:16b25a6ae3b:-2657', 'TAX', 'decimal', '3');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-e9d', 'RC122cd182:16b250d7a42:-e9f', 'RUL3e7cce43:16b25a6ae3b:-2ade', 'NMON', 'integer', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-e9e', 'RC122cd182:16b250d7a42:-e9f', 'RUL3e7cce43:16b25a6ae3b:-2ade', 'TAX', 'decimal', '3');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC440e47f4:166ae4152f1:-7fbd', 'RC440e47f4:166ae4152f1:-7fbe', 'RUL1262ad19:166ae41b1fb:-7c88', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC70978a15:166ae6875d1:-7f23', 'RC70978a15:166ae6875d1:-7f24', 'RUL7e02b404:166ae687f42:-5511', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fac', 'RC7280357:166235c1be7:-7fad', 'RULec9d7ab:166235c2e16:-26bf', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fb3', 'RC7280357:166235c1be7:-7fb4', 'RULec9d7ab:166235c2e16:-26d0', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fba', 'RC7280357:166235c1be7:-7fbb', 'RULec9d7ab:166235c2e16:-319f', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fcd', 'RC7280357:166235c1be7:-7fcf', 'RULec9d7ab:166235c2e16:-4197', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fd3', 'RC7280357:166235c1be7:-7fd4', 'RULec9d7ab:166235c2e16:-4197', 'TAX', 'decimal', '3');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-1a2d6e9b:1692d429304:-7748', 'RCOND-1a2d6e9b:1692d429304:-7748', 'RUL-1a2d6e9b:1692d429304:-7779', 'AVINFO', 'rptis.landtax.facts.AssessedValue', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-2ede6703:16642adb9ce:-7a39', 'RCOND-2ede6703:16642adb9ce:-7a39', 'RUL-2ede6703:16642adb9ce:-7ba0', 'BILL', 'rptis.landtax.facts.Bill', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND560f5a64:1735a1dbaf4:-7826', 'RCOND560f5a64:1735a1dbaf4:-7826', 'RUL560f5a64:1735a1dbaf4:-788a', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-24fc', 'RCONDec9d7ab:166235c2e16:-24fc', 'RULec9d7ab:166235c2e16:-255e', 'RLTS', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-2ec7', 'RCONDec9d7ab:166235c2e16:-2ec7', 'RULec9d7ab:166235c2e16:-2f1f', 'BILL', 'rptis.landtax.facts.Bill', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-3905', 'RCONDec9d7ab:166235c2e16:-3905', 'RULec9d7ab:166235c2e16:-3c17', 'BILL', 'rptis.landtax.facts.Bill', '2');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-3b0b', 'RCONDec9d7ab:166235c2e16:-3b0b', 'RULec9d7ab:166235c2e16:-3c17', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-5e7c', 'RCONDec9d7ab:166235c2e16:-5e7c', 'RULec9d7ab:166235c2e16:-5fcb', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-1a2d6e9b:1692d429304:-7746', 'RCOND-1a2d6e9b:1692d429304:-7748', 'RUL-1a2d6e9b:1692d429304:-7779', 'AV', 'decimal', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-1a2d6e9b:1692d429304:-7747', 'RCOND-1a2d6e9b:1692d429304:-7748', 'RUL-1a2d6e9b:1692d429304:-7779', 'YR', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-24ff7cfb:1675d220a6c:-56ab', 'RC70978a15:166ae6875d1:-7f22', 'RUL7e02b404:166ae687f42:-5511', 'NMON', 'integer', '4');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-2a65218f:180558e7346:-7670', 'RC-287581a5:180558e600d:-7d61', 'RUL-2a65218f:180558e7346:-77a0', 'CQTR', 'integer', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-2ede6703:16642adb9ce:-79c8', 'RCOND-2ede6703:16642adb9ce:-7a39', 'RUL-2ede6703:16642adb9ce:-7ba0', 'BILLDATE', 'date', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST5ffbdc02:166e7b2c367:-641c', 'RC70978a15:166ae6875d1:-7f22', 'RUL7e02b404:166ae687f42:-5511', 'TAX', 'decimal', '4');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST7e02b404:166ae687f42:-54ad', 'RC70978a15:166ae6875d1:-7f24', 'RUL7e02b404:166ae687f42:-5511', 'CQTR', 'integer', '1');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-2ea1', 'RCONDec9d7ab:166235c2e16:-2ec7', 'RULec9d7ab:166235c2e16:-2f1f', 'CDATE', 'date', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-3b8e', 'RCONDec9d7ab:166235c2e16:-3baa', 'RULec9d7ab:166235c2e16:-3c17', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-5f63', 'RCONDec9d7ab:166235c2e16:-5f7f', 'RULec9d7ab:166235c2e16:-5fcb', 'CY', 'integer', '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-17442746:16be936f033:-7e83', 'RC-17442746:16be936f033:-7e86', 'rptis.landtax.facts.RPTLedgerItemFact.av', 'av', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-287581a5:180558e600d:-7d5b', 'RC-287581a5:180558e600d:-7d5d', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-287581a5:180558e600d:-7d5c', 'RC-287581a5:180558e600d:-7d5d', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCC-287581a5:180558e600d:-7d60', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-287581a5:180558e600d:-7d60', 'RC-287581a5:180558e600d:-7d61', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-1238', 'RC122cd182:16b250d7a42:-123b', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than or equal to', '<=', '0', NULL, NULL, NULL, '1985', NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-1239', 'RC122cd182:16b250d7a42:-123b', 'rptis.landtax.facts.RPTLedgerItemFact.monthsfromjan', 'monthsfromjan', 'NMON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-123a', 'RC122cd182:16b250d7a42:-123b', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8f8', 'RC122cd182:16b250d7a42:-8f9', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8fa', 'RC122cd182:16b250d7a42:-8fe', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'greater than or equal to', '>=', NULL, NULL, NULL, NULL, '1992', NULL, NULL, NULL, '3');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8fb', 'RC122cd182:16b250d7a42:-8fe', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than', '<', '1', 'RCC122cd182:16b250d7a42:-8f8', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8fc', 'RC122cd182:16b250d7a42:-8fe', 'rptis.landtax.facts.RPTLedgerItemFact.monthsfromjan', 'monthsfromjan', 'NMON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8fd', 'RC122cd182:16b250d7a42:-8fe', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-e9b', 'RC122cd182:16b250d7a42:-e9f', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'greater than or equal to', '>=', NULL, NULL, NULL, NULL, '1986', NULL, NULL, NULL, '3');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-e9d', 'RC122cd182:16b250d7a42:-e9f', 'rptis.landtax.facts.RPTLedgerItemFact.monthsfromjan', 'monthsfromjan', 'NMON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-e9e', 'RC122cd182:16b250d7a42:-e9f', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC440e47f4:166ae4152f1:-7fbd', 'RC440e47f4:166ae4152f1:-7fbe', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC440e47f4:166ae4152f1:-7fbf', 'RC440e47f4:166ae4152f1:-7fc0', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than', '<', '1', 'RCC440e47f4:166ae4152f1:-7fbd', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC70978a15:166ae6875d1:-7f1d', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.revtype', 'revtype', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[\"basic\",\"sef\"]', NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC70978a15:166ae6875d1:-7f23', 'RC70978a15:166ae6875d1:-7f24', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fac', 'RC7280357:166235c1be7:-7fad', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fae', 'RC7280357:166235c1be7:-7faf', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'greater than', '>', '1', 'RCC7280357:166235c1be7:-7fac', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fb3', 'RC7280357:166235c1be7:-7fb4', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fb5', 'RC7280357:166235c1be7:-7fb6', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCC7280357:166235c1be7:-7fb3', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fba', 'RC7280357:166235c1be7:-7fbb', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fbc', 'RC7280357:166235c1be7:-7fbd', 'rptis.landtax.facts.RPTLedgerFact.lastyearpaid', 'lastyearpaid', NULL, 'equal to', '==', '1', 'RCC7280357:166235c1be7:-7fba', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fbf', 'RC7280357:166235c1be7:-7fc0', 'rptis.landtax.facts.Bill.billtoyear', 'billtoyear', NULL, 'greater than', '>', '1', 'RCC7280357:166235c1be7:-7fba', 'CY', NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fc6', 'RC7280357:166235c1be7:-7fc7', 'rptis.landtax.facts.RPTLedgerItemFact.qtrly', 'qtrly', NULL, 'not true', '== false', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fc8', 'RC7280357:166235c1be7:-7fc9', 'rptis.landtax.facts.Bill.forpayment', 'forpayment', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fcd', 'RC7280357:166235c1be7:-7fcf', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fd0', 'RC7280357:166235c1be7:-7fd4', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'greater than', '>', '1', 'RCC7280357:166235c1be7:-7fcd', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fd3', 'RC7280357:166235c1be7:-7fd4', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-1a2d6e9b:1692d429304:-7746', 'RCOND-1a2d6e9b:1692d429304:-7748', 'rptis.landtax.facts.AssessedValue.av', 'av', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-1a2d6e9b:1692d429304:-7747', 'RCOND-1a2d6e9b:1692d429304:-7748', 'rptis.landtax.facts.AssessedValue.year', 'year', 'YR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-24ff7cfb:1675d220a6c:-56ab', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.monthsfromjan', 'monthsfromjan', 'NMON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '4');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2a65218f:180558e7346:-7572', 'RC-287581a5:180558e600d:-7d5d', 'rptis.landtax.facts.RPTLedgerItemFact.qtr', 'qtr', NULL, 'greater than or equal to', '>=', '1', 'RCONST-2a65218f:180558e7346:-7670', 'CQTR', NULL, NULL, NULL, NULL, NULL, '2');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2a65218f:180558e7346:-7670', 'RC-287581a5:180558e600d:-7d61', 'CurrentDate.qtr', 'qtr', 'CQTR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2ede6703:16642adb9ce:-79c8', 'RCOND-2ede6703:16642adb9ce:-7a39', 'rptis.landtax.facts.Bill.billdate', 'billdate', 'BILLDATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2ede6703:16642adb9ce:-7a03', 'RCOND-2ede6703:16642adb9ce:-7a39', 'rptis.landtax.facts.Bill.advancebill', 'advancebill', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST3e7cce43:16b25a6ae3b:-2882', 'RC122cd182:16b250d7a42:-e9f', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than or equal to', '<=', NULL, NULL, NULL, NULL, '1991', NULL, NULL, NULL, '3');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST560f5a64:1735a1dbaf4:-7748', 'RCOND560f5a64:1735a1dbaf4:-7826', 'rptis.landtax.facts.RPTLedgerItemFact.backtax', 'backtax', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST5ffbdc02:166e7b2c367:-641c', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '4');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST5ffbdc02:166e7b2c367:-66a5', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCC70978a15:166ae6875d1:-7f23', 'CY', NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST7e02b404:166ae687f42:-54ad', 'RC70978a15:166ae6875d1:-7f24', 'CurrentDate.qtr', 'qtr', 'CQTR', 'greater than', '>', NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-2ea1', 'RCONDec9d7ab:166235c2e16:-2ec7', 'rptis.landtax.facts.Bill.currentdate', 'currentdate', 'CDATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-311f', 'RC7280357:166235c1be7:-7fbd', 'rptis.landtax.facts.RPTLedgerFact.lastqtrpaid', 'lastqtrpaid', NULL, 'equal to', '==', NULL, NULL, NULL, NULL, '4', NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-36b2', 'RC7280357:166235c1be7:-7fc7', 'rptis.landtax.facts.RPTLedgerItemFact.revtype', 'revtype', NULL, 'is any of the ff.', 'matches', '0', NULL, NULL, NULL, NULL, NULL, '[\"basic\",\"sef\"]', NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-38dd', 'RCONDec9d7ab:166235c2e16:-3905', 'rptis.landtax.facts.Bill.forpayment', 'forpayment', NULL, 'not true', '== false', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-39af', 'RCONDec9d7ab:166235c2e16:-3b0b', 'rptis.landtax.facts.RPTLedgerItemFact.qtrly', 'qtrly', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-3abb', 'RCONDec9d7ab:166235c2e16:-3b0b', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than', '<', '1', 'RCONSTec9d7ab:166235c2e16:-3b8e', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-3b8e', 'RCONDec9d7ab:166235c2e16:-3baa', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-5e2c', 'RCONDec9d7ab:166235c2e16:-5e7c', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'greater than or equal to', '>=', '1', 'RCONSTec9d7ab:166235c2e16:-5f63', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-5f63', 'RCONDec9d7ab:166235c2e16:-5f7f', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA-17442746:16be936f033:-7e82', 'RUL483027b0:16be9375c61:-77e6', 'rptis.landtax.actions.CalcTax', 'calc-tax', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA-287581a5:180558e600d:-7d5a', 'RUL-2a65218f:180558e7346:-77a0', 'rptis.landtax.actions.CalcDiscount', 'calc-discount', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA122cd182:16b250d7a42:-1237', 'RUL3e7cce43:16b25a6ae3b:-2c01', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA122cd182:16b250d7a42:-8f7', 'RUL3e7cce43:16b25a6ae3b:-2657', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA440e47f4:166ae4152f1:-7fbc', 'RUL1262ad19:166ae41b1fb:-7c88', 'rptis.landtax.actions.CreateTaxSummary', 'create-tax-summary', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA7280357:166235c1be7:-7fab', 'RULec9d7ab:166235c2e16:-26bf', 'rptis.landtax.actions.CreateTaxSummary', 'create-tax-summary', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA7280357:166235c1be7:-7fb2', 'RULec9d7ab:166235c2e16:-26d0', 'rptis.landtax.actions.CreateTaxSummary', 'create-tax-summary', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA7280357:166235c1be7:-7fb9', 'RULec9d7ab:166235c2e16:-319f', 'rptis.landtax.actions.SetBillExpiryDate', 'set-bill-expiry', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA7280357:166235c1be7:-7fcc', 'RULec9d7ab:166235c2e16:-4197', 'rptis.landtax.actions.CalcDiscount', 'calc-discount', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-1a2d6e9b:1692d429304:-7649', 'RUL-1a2d6e9b:1692d429304:-7779', 'rptis.landtax.actions.AddSef', 'add-sef', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-1a2d6e9b:1692d429304:-7700', 'RUL-1a2d6e9b:1692d429304:-7779', 'rptis.landtax.actions.AddBasic', 'add-basic', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-2ede6703:16642adb9ce:-794c', 'RUL-2ede6703:16642adb9ce:-7ba0', 'rptis.landtax.actions.SetBillExpiryDate', 'set-bill-expiry', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT3e7cce43:16b25a6ae3b:-274e', 'RUL3e7cce43:16b25a6ae3b:-2ade', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT560f5a64:1735a1dbaf4:-76c3', 'RUL560f5a64:1735a1dbaf4:-788a', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT5ffbdc02:166e7b2c367:-6229', 'RUL7e02b404:166ae687f42:-5511', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-249a', 'RULec9d7ab:166235c2e16:-255e', 'rptis.landtax.actions.AddBillItem', 'add-billitem', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-2e2e', 'RULec9d7ab:166235c2e16:-2f1f', 'rptis.landtax.actions.SetBillExpiryDate', 'set-bill-expiry', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-35b3', 'RULec9d7ab:166235c2e16:-3811', 'rptis.landtax.actions.SplitLedgerItem', 'split-bill-item', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-3879', 'RULec9d7ab:166235c2e16:-3c17', 'rptis.landtax.actions.AggregateLedgerItem', 'aggregate-bill-item', '0');
INSERT IGNORE INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-5b6f', 'RULec9d7ab:166235c2e16:-5fcb', 'rptis.landtax.actions.SplitByQtr', 'split-by-qtr', '0');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddBasic', 'add-basic', 'Add Basic Entry', '1', 'add-basic', 'landtax', 'rptis.landtax.actions.AddBasic');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddBillItem', 'add-billitem', 'Add Bill Item', '25', 'add-billitem', 'landtax', 'rptis.landtax.actions.AddBillItem');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddFireCode', 'add-firecode', 'Add Fire Code', '10', 'add-firecode', 'landtax', 'rptis.landtax.actions.AddFireCode');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddIdleLand', 'add-basicidle', 'Add Idle Land Entry', '6', 'add-basicidle', 'landtax', 'rptis.landtax.actions.AddIdleLand');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddSef', 'add-sef', 'Add SEF Entry', '5', 'add-sef', 'landtax', 'rptis.landtax.actions.AddSef');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddShare', 'add-share', 'Add Revenue Share', '28', 'add-share', 'landtax', 'rptis.landtax.actions.AddShare');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddSocialHousing', 'add-sh', 'Add Social Housing Entry', '8', 'add-sh', 'landtax', 'rptis.landtax.actions.AddSocialHousing');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AggregateLedgerItem', 'aggregate-bill-item', 'Aggregate Ledger Items', '12', 'aggregate-bill-item', 'landtax', 'rptis.landtax.actions.AggregateLedgerItem');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.CalcDiscount', 'calc-discount', 'Calculate Discount', '6', 'calc-discount', 'landtax', 'rptis.landtax.actions.CalcDiscount');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.CalcInterest', 'calc-interest', 'Calculate Interest', '5', 'calc-interest', 'landtax', 'rptis.landtax.actions.CalcInterest');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.CalcTax', 'calc-tax', 'Calculate Tax', '1001', 'calc-tax', 'landtax', 'rptis.landtax.actions.CalcTax');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.CreateTaxSummary', 'create-tax-summary', 'Create Tax Summary', '20', 'create-tax-summary', 'landtax', 'rptis.landtax.actions.CreateTaxSummary');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.RemoveLedgerItem', 'remove-bill-item', 'Remove Ledger Item', '11', 'remove-bill-item', 'landtax', 'rptis.landtax.actions.RemoveLedgerItem');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.SetBillExpiryDate', 'set-bill-expiry', 'Set Bill Expiry Date', '20', 'set-bill-expiry', 'landtax', 'rptis.landtax.actions.SetBillExpiryDate');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.SplitByQtr', 'split-by-qtr', 'Split By Quarter', '0', 'split-by-qtr', 'LANDTAX', 'rptis.landtax.actions.SplitByQtr');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.SplitLedgerItem', 'split-bill-item', 'Split Ledger Item', '10', 'split-bill-item', 'landtax', 'rptis.landtax.actions.SplitLedgerItem');
INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.UpdateAV', 'update-av', 'Update AV', '1000', 'update-av', 'LANDTAX', 'rptis.landtax.actions.UpdateAV');
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddBasic.av', 'rptis.landtax.actions.AddBasic', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddBasic.avfact', 'rptis.landtax.actions.AddBasic', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddBasic.year', 'rptis.landtax.actions.AddBasic', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddBillItem.taxsummary', 'rptis.landtax.actions.AddBillItem', 'taxsummary', '1', 'Tax Summary', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddFireCode.av', 'rptis.landtax.actions.AddFireCode', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddFireCode.avfact', 'rptis.landtax.actions.AddFireCode', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddFireCode.year', 'rptis.landtax.actions.AddFireCode', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddIdleLand.av', 'rptis.landtax.actions.AddIdleLand', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddIdleLand.avfact', 'rptis.landtax.actions.AddIdleLand', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddIdleLand.year', 'rptis.landtax.actions.AddIdleLand', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSef.av', 'rptis.landtax.actions.AddSef', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSef.avfact', 'rptis.landtax.actions.AddSef', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSef.year', 'rptis.landtax.actions.AddSef', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.amtdue', 'rptis.landtax.actions.AddShare', 'amtdue', '5', 'Amount Due', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.billitem', 'rptis.landtax.actions.AddShare', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTBillItem', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.orgclass', 'rptis.landtax.actions.AddShare', 'orgclass', '2', 'Share Type', NULL, 'lov', NULL, NULL, NULL, NULL, 'RPT_BILLING_LGU_TYPES');
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.orgid', 'rptis.landtax.actions.AddShare', 'orgid', '3', 'Org', NULL, 'var', 'org:lookup', 'objid', 'name', 'String', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.payableparentacct', 'rptis.landtax.actions.AddShare', 'payableparentacct', '4', 'Payable Account', NULL, 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.rate', 'rptis.landtax.actions.AddShare', 'rate', '6', 'Share (decimal)', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSocialHousing.av', 'rptis.landtax.actions.AddSocialHousing', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSocialHousing.avfact', 'rptis.landtax.actions.AddSocialHousing', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSocialHousing.year', 'rptis.landtax.actions.AddSocialHousing', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AggregateLedgerItem.rptledgeritem', 'rptis.landtax.actions.AggregateLedgerItem', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcDiscount.expr', 'rptis.landtax.actions.CalcDiscount', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcDiscount.rptledgeritem', 'rptis.landtax.actions.CalcDiscount', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcInterest.expr', 'rptis.landtax.actions.CalcInterest', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcInterest.rptledgeritem', 'rptis.landtax.actions.CalcInterest', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcTax.expr', 'rptis.landtax.actions.CalcTax', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcTax.rptledgeritem', 'rptis.landtax.actions.CalcTax', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CreateTaxSummary.revperiod', 'rptis.landtax.actions.CreateTaxSummary', 'revperiod', '2', 'Revenue Period', NULL, 'lov', NULL, NULL, NULL, NULL, 'RPT_REVENUE_PERIODS');
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CreateTaxSummary.rptledgeritem', 'rptis.landtax.actions.CreateTaxSummary', 'rptledgeritem', '1', 'RPT Ledger Item', '', 'var', '', '', '', 'rptis.landtax.facts.RPTLedgerItemFact', '');
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CreateTaxSummary.var', 'rptis.landtax.actions.CreateTaxSummary', 'var', '3', 'Variable Name', NULL, 'lookup', 'rptparameter:lookup', 'name', 'name', NULL, '');
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.RemoveLedgerItem.rptledgeritem', 'rptis.landtax.actions.RemoveLedgerItem', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.SetBillExpiryDate.bill', 'rptis.landtax.actions.SetBillExpiryDate', 'bill', '1', 'Bill', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.Bill', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.SetBillExpiryDate.expr', 'rptis.landtax.actions.SetBillExpiryDate', 'expr', '2', 'Expiry Date', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.SplitByQtr.rptledgeritem', 'rptis.landtax.actions.SplitByQtr', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.SplitLedgerItem.rptledgeritem', 'rptis.landtax.actions.SplitLedgerItem', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.UpdateAV.avfact', 'rptis.landtax.actions.UpdateAV', 'avfact', '1', 'Assessed Value', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.UpdateAV.expr', 'rptis.landtax.actions.UpdateAV', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP-17442746:16be936f033:-7e80', 'RA-17442746:16be936f033:-7e82', 'rptis.landtax.actions.CalcTax.rptledgeritem', NULL, NULL, 'RC-17442746:16be936f033:-7e86', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP-17442746:16be936f033:-7e81', 'RA-17442746:16be936f033:-7e82', 'rptis.landtax.actions.CalcTax.expr', NULL, NULL, NULL, NULL, 'AV * 0.01', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP-287581a5:180558e600d:-7d58', 'RA-287581a5:180558e600d:-7d5a', 'rptis.landtax.actions.CalcDiscount.expr', NULL, NULL, NULL, NULL, '@ROUND(TAX * 0.20)', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP-287581a5:180558e600d:-7d59', 'RA-287581a5:180558e600d:-7d5a', 'rptis.landtax.actions.CalcDiscount.rptledgeritem', NULL, NULL, 'RC-287581a5:180558e600d:-7d5d', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP122cd182:16b250d7a42:-1235', 'RA122cd182:16b250d7a42:-1237', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RC122cd182:16b250d7a42:-123b', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP122cd182:16b250d7a42:-1236', 'RA122cd182:16b250d7a42:-1237', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, '@ROUND(TAX * 0.24)', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP122cd182:16b250d7a42:-8f5', 'RA122cd182:16b250d7a42:-8f7', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RC122cd182:16b250d7a42:-8fe', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP122cd182:16b250d7a42:-8f6', 'RA122cd182:16b250d7a42:-8f7', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, '@ROUND(@IIF( NMON * 0.02 > 0.72, TAX * 0.72, TAX * NMON * 0.02))', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP440e47f4:166ae4152f1:-7fba', 'RA440e47f4:166ae4152f1:-7fbc', 'rptis.landtax.actions.CreateTaxSummary.rptledgeritem', NULL, NULL, 'RC440e47f4:166ae4152f1:-7fc0', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP440e47f4:166ae4152f1:-7fbb', 'RA440e47f4:166ae4152f1:-7fbc', 'rptis.landtax.actions.CreateTaxSummary.revperiod', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'previous', NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fa9', 'RA7280357:166235c1be7:-7fab', 'rptis.landtax.actions.CreateTaxSummary.rptledgeritem', NULL, NULL, 'RC7280357:166235c1be7:-7faf', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7faa', 'RA7280357:166235c1be7:-7fab', 'rptis.landtax.actions.CreateTaxSummary.revperiod', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'advance', NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fb0', 'RA7280357:166235c1be7:-7fb2', 'rptis.landtax.actions.CreateTaxSummary.rptledgeritem', NULL, NULL, 'RC7280357:166235c1be7:-7fb6', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fb1', 'RA7280357:166235c1be7:-7fb2', 'rptis.landtax.actions.CreateTaxSummary.revperiod', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'current', NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fb7', 'RA7280357:166235c1be7:-7fb9', 'rptis.landtax.actions.SetBillExpiryDate.bill', NULL, NULL, 'RC7280357:166235c1be7:-7fc0', 'BILL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fb8', 'RA7280357:166235c1be7:-7fb9', 'rptis.landtax.actions.SetBillExpiryDate.expr', NULL, NULL, NULL, NULL, '@MONTHEND(@DATE(CY, 12, 1));', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fca', 'RA7280357:166235c1be7:-7fcc', 'rptis.landtax.actions.CalcDiscount.rptledgeritem', NULL, NULL, 'RC7280357:166235c1be7:-7fd4', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fcb', 'RA7280357:166235c1be7:-7fcc', 'rptis.landtax.actions.CalcDiscount.expr', NULL, NULL, NULL, NULL, '@ROUND(TAX * 0.20)', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-7607', 'RACT-1a2d6e9b:1692d429304:-7649', 'rptis.landtax.actions.AddSef.av', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-7622', 'RACT-1a2d6e9b:1692d429304:-7649', 'rptis.landtax.actions.AddSef.year', NULL, NULL, 'RCONST-1a2d6e9b:1692d429304:-7747', 'YR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-7639', 'RACT-1a2d6e9b:1692d429304:-7649', 'rptis.landtax.actions.AddSef.avfact', NULL, NULL, 'RCOND-1a2d6e9b:1692d429304:-7748', 'AVINFO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-76bc', 'RACT-1a2d6e9b:1692d429304:-7700', 'rptis.landtax.actions.AddBasic.av', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-76d7', 'RACT-1a2d6e9b:1692d429304:-7700', 'rptis.landtax.actions.AddBasic.year', NULL, NULL, 'RCONST-1a2d6e9b:1692d429304:-7747', 'YR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-76ef', 'RACT-1a2d6e9b:1692d429304:-7700', 'rptis.landtax.actions.AddBasic.avfact', NULL, NULL, 'RCOND-1a2d6e9b:1692d429304:-7748', 'AVINFO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2ede6703:16642adb9ce:-7926', 'RACT-2ede6703:16642adb9ce:-794c', 'rptis.landtax.actions.SetBillExpiryDate.expr', NULL, NULL, NULL, NULL, '@MONTHEND( BILLDATE )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2ede6703:16642adb9ce:-793c', 'RACT-2ede6703:16642adb9ce:-794c', 'rptis.landtax.actions.SetBillExpiryDate.bill', NULL, NULL, 'RCOND-2ede6703:16642adb9ce:-7a39', 'BILL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT3e7cce43:16b25a6ae3b:-2728', 'RACT3e7cce43:16b25a6ae3b:-274e', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, '@ROUND(TAX * NMON * 0.02)', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT3e7cce43:16b25a6ae3b:-273e', 'RACT3e7cce43:16b25a6ae3b:-274e', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RC122cd182:16b250d7a42:-e9f', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT560f5a64:1735a1dbaf4:-769d', 'RACT560f5a64:1735a1dbaf4:-76c3', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, '0', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT560f5a64:1735a1dbaf4:-76b3', 'RACT560f5a64:1735a1dbaf4:-76c3', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RCOND560f5a64:1735a1dbaf4:-7826', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT5ffbdc02:166e7b2c367:-6203', 'RACT5ffbdc02:166e7b2c367:-6229', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, 'TAX * NMON * 0.02', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT5ffbdc02:166e7b2c367:-6219', 'RACT5ffbdc02:166e7b2c367:-6229', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RC70978a15:166ae6875d1:-7f22', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-248e', 'RACTec9d7ab:166235c2e16:-249a', 'rptis.landtax.actions.AddBillItem.taxsummary', NULL, NULL, 'RCONDec9d7ab:166235c2e16:-24fc', 'RLTS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-2e08', 'RACTec9d7ab:166235c2e16:-2e2e', 'rptis.landtax.actions.SetBillExpiryDate.expr', NULL, NULL, NULL, NULL, '@MONTHEND( CDATE )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-2e1e', 'RACTec9d7ab:166235c2e16:-2e2e', 'rptis.landtax.actions.SetBillExpiryDate.bill', NULL, NULL, 'RCONDec9d7ab:166235c2e16:-2ec7', 'BILL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-35a7', 'RACTec9d7ab:166235c2e16:-35b3', 'rptis.landtax.actions.SplitLedgerItem.rptledgeritem', NULL, NULL, 'RC7280357:166235c1be7:-7fc7', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-386d', 'RACTec9d7ab:166235c2e16:-3879', 'rptis.landtax.actions.AggregateLedgerItem.rptledgeritem', NULL, NULL, 'RCONDec9d7ab:166235c2e16:-3b0b', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-5b63', 'RACTec9d7ab:166235c2e16:-5b6f', 'rptis.landtax.actions.SplitByQtr.rptledgeritem', NULL, NULL, 'RCONDec9d7ab:166235c2e16:-5e7c', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
SET FOREIGN_KEY_CHECKS = 1;


INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT', 'ACTIVE', '588-004', 'RPT BASIC PENALTY CURRENT', 'RPT BASIC PENALTY CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT:02702', 'ACTIVE', '-', 'BARAS RPT BASIC PENALTY CURRENT', 'BARAS RPT BASIC PENALTY CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02702', 'BARAS', 'RPT_BASICINT_CURRENT', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0001', 'ACTIVE', '-', 'POBLACION RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'POBLACION RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0001', 'POBLACION', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0002', 'ACTIVE', '-', 'ABIHAO RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'ABIHAO RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0002', 'ABIHAO', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0003', 'ACTIVE', '-', 'AGBAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'AGBAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0003', 'AGBAN', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0004', 'ACTIVE', '-', 'BENTICAYAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'BENTICAYAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0004', 'BENTICAYAN', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0005', 'ACTIVE', '-', 'CARAGUMIHAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'CARAGUMIHAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0005', 'CARAGUMIHAN', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0006', 'ACTIVE', '-', 'DANAO RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'DANAO RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0006', 'DANAO', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0007', 'ACTIVE', '-', 'GENITLIGAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'GENITLIGAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0007', 'GENITLIGAN', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0008', 'ACTIVE', '-', 'GUINSAANAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'GUINSAANAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0008', 'GUINSAANAN', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0009', 'ACTIVE', '-', 'MACUTAL RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'MACUTAL RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0009', 'MACUTAL', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0010', 'ACTIVE', '-', 'MONING RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'MONING RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0010', 'MONING', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0011', 'ACTIVE', '-', 'NAGBARORONG RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'NAGBARORONG RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0011', 'NAGBARORONG', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0012', 'ACTIVE', '-', 'OSMEÃ‘A RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'OSMEÃ‘A RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0012', 'OSMEÃ‘A', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0013', 'ACTIVE', '-', 'PANIQUIHAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PANIQUIHAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0013', 'PANIQUIHAN', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0014', 'ACTIVE', '-', 'PURARAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PURARAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0014', 'PURARAN', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0015', 'ACTIVE', '-', 'PUTSAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PUTSAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0015', 'PUTSAN', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0016', 'ACTIVE', '-', 'RIZAL RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'RIZAL RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0016', 'RIZAL', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0017', 'ACTIVE', '-', 'SALVACION RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'SALVACION RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0017', 'SALVACION', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0018', 'ACTIVE', '-', 'SAN MIGUEL RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'SAN MIGUEL RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0018', 'SAN MIGUEL', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-02-0019', 'ACTIVE', '-', 'TILOD RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'TILOD RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0019', 'TILOD', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'CATANDUANES RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASICINT_CURRENT_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS', 'ACTIVE', '588-005', 'RPT BASIC PENALTY PREVIOUS', 'RPT BASIC PENALTY PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS:02702', 'ACTIVE', '-', 'BARAS RPT BASIC PENALTY PREVIOUS', 'BARAS RPT BASIC PENALTY PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02702', 'BARAS', 'RPT_BASICINT_PREVIOUS', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0001', 'ACTIVE', '-', 'POBLACION RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'POBLACION RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0001', 'POBLACION', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0002', 'ACTIVE', '-', 'ABIHAO RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'ABIHAO RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0002', 'ABIHAO', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0003', 'ACTIVE', '-', 'AGBAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'AGBAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0003', 'AGBAN', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0004', 'ACTIVE', '-', 'BENTICAYAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'BENTICAYAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0004', 'BENTICAYAN', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0005', 'ACTIVE', '-', 'CARAGUMIHAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'CARAGUMIHAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0005', 'CARAGUMIHAN', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0006', 'ACTIVE', '-', 'DANAO RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'DANAO RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0006', 'DANAO', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0007', 'ACTIVE', '-', 'GENITLIGAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'GENITLIGAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0007', 'GENITLIGAN', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0008', 'ACTIVE', '-', 'GUINSAANAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'GUINSAANAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0008', 'GUINSAANAN', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0009', 'ACTIVE', '-', 'MACUTAL RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'MACUTAL RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0009', 'MACUTAL', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0010', 'ACTIVE', '-', 'MONING RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'MONING RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0010', 'MONING', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0011', 'ACTIVE', '-', 'NAGBARORONG RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'NAGBARORONG RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0011', 'NAGBARORONG', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0012', 'ACTIVE', '-', 'OSMEÃ‘A RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'OSMEÃ‘A RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0012', 'OSMEÃ‘A', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0013', 'ACTIVE', '-', 'PANIQUIHAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PANIQUIHAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0013', 'PANIQUIHAN', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0014', 'ACTIVE', '-', 'PURARAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PURARAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0014', 'PURARAN', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0015', 'ACTIVE', '-', 'PUTSAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PUTSAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0015', 'PUTSAN', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0016', 'ACTIVE', '-', 'RIZAL RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'RIZAL RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0016', 'RIZAL', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0017', 'ACTIVE', '-', 'SALVACION RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'SALVACION RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0017', 'SALVACION', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0018', 'ACTIVE', '-', 'SAN MIGUEL RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'SAN MIGUEL RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0018', 'SAN MIGUEL', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-02-0019', 'ACTIVE', '-', 'TILOD RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'TILOD RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0019', 'TILOD', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'CATANDUANES RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR', 'ACTIVE', '588-006', 'RPT BASIC PENALTY PRIOR', 'RPT BASIC PENALTY PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR:02702', 'ACTIVE', '-', 'BARAS RPT BASIC PENALTY PRIOR', 'BARAS RPT BASIC PENALTY PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02702', 'BARAS', 'RPT_BASICINT_PRIOR', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0001', 'ACTIVE', '-', 'POBLACION RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'POBLACION RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0001', 'POBLACION', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0002', 'ACTIVE', '-', 'ABIHAO RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'ABIHAO RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0002', 'ABIHAO', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0003', 'ACTIVE', '-', 'AGBAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'AGBAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0003', 'AGBAN', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0004', 'ACTIVE', '-', 'BENTICAYAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'BENTICAYAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0004', 'BENTICAYAN', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0005', 'ACTIVE', '-', 'CARAGUMIHAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'CARAGUMIHAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0005', 'CARAGUMIHAN', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0006', 'ACTIVE', '-', 'DANAO RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'DANAO RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0006', 'DANAO', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0007', 'ACTIVE', '-', 'GENITLIGAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'GENITLIGAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0007', 'GENITLIGAN', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0008', 'ACTIVE', '-', 'GUINSAANAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'GUINSAANAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0008', 'GUINSAANAN', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0009', 'ACTIVE', '-', 'MACUTAL RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'MACUTAL RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0009', 'MACUTAL', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0010', 'ACTIVE', '-', 'MONING RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'MONING RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0010', 'MONING', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0011', 'ACTIVE', '-', 'NAGBARORONG RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'NAGBARORONG RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0011', 'NAGBARORONG', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0012', 'ACTIVE', '-', 'OSMEÃ‘A RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'OSMEÃ‘A RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0012', 'OSMEÃ‘A', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0013', 'ACTIVE', '-', 'PANIQUIHAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PANIQUIHAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0013', 'PANIQUIHAN', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0014', 'ACTIVE', '-', 'PURARAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PURARAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0014', 'PURARAN', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0015', 'ACTIVE', '-', 'PUTSAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PUTSAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0015', 'PUTSAN', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0016', 'ACTIVE', '-', 'RIZAL RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'RIZAL RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0016', 'RIZAL', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0017', 'ACTIVE', '-', 'SALVACION RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'SALVACION RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0017', 'SALVACION', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0018', 'ACTIVE', '-', 'SAN MIGUEL RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'SAN MIGUEL RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0018', 'SAN MIGUEL', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-02-0019', 'ACTIVE', '-', 'TILOD RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'TILOD RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0019', 'TILOD', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'CATANDUANES RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASICINT_PRIOR_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE', 'ACTIVE', '588-007', 'RPT BASIC ADVANCE', 'RPT BASIC ADVANCE', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE:02702', 'ACTIVE', '-', 'BARAS RPT BASIC ADVANCE', 'BARAS RPT BASIC ADVANCE', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02702', 'BARAS', 'RPT_BASIC_ADVANCE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE BARANGAY SHARE', 'RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0001', 'ACTIVE', '-', 'POBLACION RPT BASIC ADVANCE BARANGAY SHARE', 'POBLACION RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0001', 'POBLACION', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0002', 'ACTIVE', '-', 'ABIHAO RPT BASIC ADVANCE BARANGAY SHARE', 'ABIHAO RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0002', 'ABIHAO', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0003', 'ACTIVE', '-', 'AGBAN RPT BASIC ADVANCE BARANGAY SHARE', 'AGBAN RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0003', 'AGBAN', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0004', 'ACTIVE', '-', 'BENTICAYAN RPT BASIC ADVANCE BARANGAY SHARE', 'BENTICAYAN RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0004', 'BENTICAYAN', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0005', 'ACTIVE', '-', 'CARAGUMIHAN RPT BASIC ADVANCE BARANGAY SHARE', 'CARAGUMIHAN RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0005', 'CARAGUMIHAN', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0006', 'ACTIVE', '-', 'DANAO RPT BASIC ADVANCE BARANGAY SHARE', 'DANAO RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0006', 'DANAO', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0007', 'ACTIVE', '-', 'GENITLIGAN RPT BASIC ADVANCE BARANGAY SHARE', 'GENITLIGAN RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0007', 'GENITLIGAN', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0008', 'ACTIVE', '-', 'GUINSAANAN RPT BASIC ADVANCE BARANGAY SHARE', 'GUINSAANAN RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0008', 'GUINSAANAN', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0009', 'ACTIVE', '-', 'MACUTAL RPT BASIC ADVANCE BARANGAY SHARE', 'MACUTAL RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0009', 'MACUTAL', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0010', 'ACTIVE', '-', 'MONING RPT BASIC ADVANCE BARANGAY SHARE', 'MONING RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0010', 'MONING', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0011', 'ACTIVE', '-', 'NAGBARORONG RPT BASIC ADVANCE BARANGAY SHARE', 'NAGBARORONG RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0011', 'NAGBARORONG', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0012', 'ACTIVE', '-', 'OSMEÃ‘A RPT BASIC ADVANCE BARANGAY SHARE', 'OSMEÃ‘A RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0012', 'OSMEÃ‘A', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0013', 'ACTIVE', '-', 'PANIQUIHAN RPT BASIC ADVANCE BARANGAY SHARE', 'PANIQUIHAN RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0013', 'PANIQUIHAN', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0014', 'ACTIVE', '-', 'PURARAN RPT BASIC ADVANCE BARANGAY SHARE', 'PURARAN RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0014', 'PURARAN', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0015', 'ACTIVE', '-', 'PUTSAN RPT BASIC ADVANCE BARANGAY SHARE', 'PUTSAN RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0015', 'PUTSAN', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0016', 'ACTIVE', '-', 'RIZAL RPT BASIC ADVANCE BARANGAY SHARE', 'RIZAL RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0016', 'RIZAL', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0017', 'ACTIVE', '-', 'SALVACION RPT BASIC ADVANCE BARANGAY SHARE', 'SALVACION RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0017', 'SALVACION', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0018', 'ACTIVE', '-', 'SAN MIGUEL RPT BASIC ADVANCE BARANGAY SHARE', 'SAN MIGUEL RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0018', 'SAN MIGUEL', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-02-0019', 'ACTIVE', '-', 'TILOD RPT BASIC ADVANCE BARANGAY SHARE', 'TILOD RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0019', 'TILOD', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE PROVINCE SHARE', 'RPT BASIC ADVANCE PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC ADVANCE PROVINCE SHARE', 'CATANDUANES RPT BASIC ADVANCE PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASIC_ADVANCE_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT', 'ACTIVE', '588-001', 'RPT BASIC CURRENT', 'RPT BASIC CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT:02702', 'ACTIVE', '-', 'BARAS RPT BASIC CURRENT', 'BARAS RPT BASIC CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02702', 'BARAS', 'RPT_BASIC_CURRENT', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT BARANGAY SHARE', 'RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0001', 'ACTIVE', '-', 'POBLACION RPT BASIC CURRENT BARANGAY SHARE', 'POBLACION RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0001', 'POBLACION', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0002', 'ACTIVE', '-', 'ABIHAO RPT BASIC CURRENT BARANGAY SHARE', 'ABIHAO RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0002', 'ABIHAO', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0003', 'ACTIVE', '-', 'AGBAN RPT BASIC CURRENT BARANGAY SHARE', 'AGBAN RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0003', 'AGBAN', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0004', 'ACTIVE', '-', 'BENTICAYAN RPT BASIC CURRENT BARANGAY SHARE', 'BENTICAYAN RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0004', 'BENTICAYAN', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0005', 'ACTIVE', '-', 'CARAGUMIHAN RPT BASIC CURRENT BARANGAY SHARE', 'CARAGUMIHAN RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0005', 'CARAGUMIHAN', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0006', 'ACTIVE', '-', 'DANAO RPT BASIC CURRENT BARANGAY SHARE', 'DANAO RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0006', 'DANAO', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0007', 'ACTIVE', '-', 'GENITLIGAN RPT BASIC CURRENT BARANGAY SHARE', 'GENITLIGAN RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0007', 'GENITLIGAN', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0008', 'ACTIVE', '-', 'GUINSAANAN RPT BASIC CURRENT BARANGAY SHARE', 'GUINSAANAN RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0008', 'GUINSAANAN', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0009', 'ACTIVE', '-', 'MACUTAL RPT BASIC CURRENT BARANGAY SHARE', 'MACUTAL RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0009', 'MACUTAL', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0010', 'ACTIVE', '-', 'MONING RPT BASIC CURRENT BARANGAY SHARE', 'MONING RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0010', 'MONING', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0011', 'ACTIVE', '-', 'NAGBARORONG RPT BASIC CURRENT BARANGAY SHARE', 'NAGBARORONG RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0011', 'NAGBARORONG', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0012', 'ACTIVE', '-', 'OSMEÃ‘A RPT BASIC CURRENT BARANGAY SHARE', 'OSMEÃ‘A RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0012', 'OSMEÃ‘A', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0013', 'ACTIVE', '-', 'PANIQUIHAN RPT BASIC CURRENT BARANGAY SHARE', 'PANIQUIHAN RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0013', 'PANIQUIHAN', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0014', 'ACTIVE', '-', 'PURARAN RPT BASIC CURRENT BARANGAY SHARE', 'PURARAN RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0014', 'PURARAN', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0015', 'ACTIVE', '-', 'PUTSAN RPT BASIC CURRENT BARANGAY SHARE', 'PUTSAN RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0015', 'PUTSAN', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0016', 'ACTIVE', '-', 'RIZAL RPT BASIC CURRENT BARANGAY SHARE', 'RIZAL RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0016', 'RIZAL', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0017', 'ACTIVE', '-', 'SALVACION RPT BASIC CURRENT BARANGAY SHARE', 'SALVACION RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0017', 'SALVACION', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0018', 'ACTIVE', '-', 'SAN MIGUEL RPT BASIC CURRENT BARANGAY SHARE', 'SAN MIGUEL RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0018', 'SAN MIGUEL', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-02-0019', 'ACTIVE', '-', 'TILOD RPT BASIC CURRENT BARANGAY SHARE', 'TILOD RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0019', 'TILOD', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT PROVINCE SHARE', 'RPT BASIC CURRENT PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC CURRENT PROVINCE SHARE', 'CATANDUANES RPT BASIC CURRENT PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASIC_CURRENT_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS', 'ACTIVE', '588-002', 'RPT BASIC PREVIOUS', 'RPT BASIC PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS:02702', 'ACTIVE', '-', 'BARAS RPT BASIC PREVIOUS', 'BARAS RPT BASIC PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02702', 'BARAS', 'RPT_BASIC_PREVIOUS', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0001', 'ACTIVE', '-', 'POBLACION RPT BASIC PREVIOUS BARANGAY SHARE', 'POBLACION RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0001', 'POBLACION', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0002', 'ACTIVE', '-', 'ABIHAO RPT BASIC PREVIOUS BARANGAY SHARE', 'ABIHAO RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0002', 'ABIHAO', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0003', 'ACTIVE', '-', 'AGBAN RPT BASIC PREVIOUS BARANGAY SHARE', 'AGBAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0003', 'AGBAN', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0004', 'ACTIVE', '-', 'BENTICAYAN RPT BASIC PREVIOUS BARANGAY SHARE', 'BENTICAYAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0004', 'BENTICAYAN', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0005', 'ACTIVE', '-', 'CARAGUMIHAN RPT BASIC PREVIOUS BARANGAY SHARE', 'CARAGUMIHAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0005', 'CARAGUMIHAN', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0006', 'ACTIVE', '-', 'DANAO RPT BASIC PREVIOUS BARANGAY SHARE', 'DANAO RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0006', 'DANAO', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0007', 'ACTIVE', '-', 'GENITLIGAN RPT BASIC PREVIOUS BARANGAY SHARE', 'GENITLIGAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0007', 'GENITLIGAN', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0008', 'ACTIVE', '-', 'GUINSAANAN RPT BASIC PREVIOUS BARANGAY SHARE', 'GUINSAANAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0008', 'GUINSAANAN', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0009', 'ACTIVE', '-', 'MACUTAL RPT BASIC PREVIOUS BARANGAY SHARE', 'MACUTAL RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0009', 'MACUTAL', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0010', 'ACTIVE', '-', 'MONING RPT BASIC PREVIOUS BARANGAY SHARE', 'MONING RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0010', 'MONING', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0011', 'ACTIVE', '-', 'NAGBARORONG RPT BASIC PREVIOUS BARANGAY SHARE', 'NAGBARORONG RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0011', 'NAGBARORONG', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0012', 'ACTIVE', '-', 'OSMEÃ‘A RPT BASIC PREVIOUS BARANGAY SHARE', 'OSMEÃ‘A RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0012', 'OSMEÃ‘A', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0013', 'ACTIVE', '-', 'PANIQUIHAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PANIQUIHAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0013', 'PANIQUIHAN', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0014', 'ACTIVE', '-', 'PURARAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PURARAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0014', 'PURARAN', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0015', 'ACTIVE', '-', 'PUTSAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PUTSAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0015', 'PUTSAN', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0016', 'ACTIVE', '-', 'RIZAL RPT BASIC PREVIOUS BARANGAY SHARE', 'RIZAL RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0016', 'RIZAL', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0017', 'ACTIVE', '-', 'SALVACION RPT BASIC PREVIOUS BARANGAY SHARE', 'SALVACION RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0017', 'SALVACION', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0018', 'ACTIVE', '-', 'SAN MIGUEL RPT BASIC PREVIOUS BARANGAY SHARE', 'SAN MIGUEL RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0018', 'SAN MIGUEL', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-02-0019', 'ACTIVE', '-', 'TILOD RPT BASIC PREVIOUS BARANGAY SHARE', 'TILOD RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0019', 'TILOD', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC PREVIOUS PROVINCE SHARE', 'CATANDUANES RPT BASIC PREVIOUS PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR', 'ACTIVE', '588-003', 'RPT BASIC PRIOR', 'RPT BASIC PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR:02702', 'ACTIVE', '-', 'BARAS RPT BASIC PRIOR', 'BARAS RPT BASIC PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02702', 'BARAS', 'RPT_BASIC_PRIOR', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR BARANGAY SHARE', 'RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0001', 'ACTIVE', '-', 'POBLACION RPT BASIC PRIOR BARANGAY SHARE', 'POBLACION RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0001', 'POBLACION', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0002', 'ACTIVE', '-', 'ABIHAO RPT BASIC PRIOR BARANGAY SHARE', 'ABIHAO RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0002', 'ABIHAO', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0003', 'ACTIVE', '-', 'AGBAN RPT BASIC PRIOR BARANGAY SHARE', 'AGBAN RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0003', 'AGBAN', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0004', 'ACTIVE', '-', 'BENTICAYAN RPT BASIC PRIOR BARANGAY SHARE', 'BENTICAYAN RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0004', 'BENTICAYAN', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0005', 'ACTIVE', '-', 'CARAGUMIHAN RPT BASIC PRIOR BARANGAY SHARE', 'CARAGUMIHAN RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0005', 'CARAGUMIHAN', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0006', 'ACTIVE', '-', 'DANAO RPT BASIC PRIOR BARANGAY SHARE', 'DANAO RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0006', 'DANAO', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0007', 'ACTIVE', '-', 'GENITLIGAN RPT BASIC PRIOR BARANGAY SHARE', 'GENITLIGAN RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0007', 'GENITLIGAN', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0008', 'ACTIVE', '-', 'GUINSAANAN RPT BASIC PRIOR BARANGAY SHARE', 'GUINSAANAN RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0008', 'GUINSAANAN', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0009', 'ACTIVE', '-', 'MACUTAL RPT BASIC PRIOR BARANGAY SHARE', 'MACUTAL RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0009', 'MACUTAL', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0010', 'ACTIVE', '-', 'MONING RPT BASIC PRIOR BARANGAY SHARE', 'MONING RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0010', 'MONING', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0011', 'ACTIVE', '-', 'NAGBARORONG RPT BASIC PRIOR BARANGAY SHARE', 'NAGBARORONG RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0011', 'NAGBARORONG', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0012', 'ACTIVE', '-', 'OSMEÃ‘A RPT BASIC PRIOR BARANGAY SHARE', 'OSMEÃ‘A RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0012', 'OSMEÃ‘A', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0013', 'ACTIVE', '-', 'PANIQUIHAN RPT BASIC PRIOR BARANGAY SHARE', 'PANIQUIHAN RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0013', 'PANIQUIHAN', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0014', 'ACTIVE', '-', 'PURARAN RPT BASIC PRIOR BARANGAY SHARE', 'PURARAN RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0014', 'PURARAN', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0015', 'ACTIVE', '-', 'PUTSAN RPT BASIC PRIOR BARANGAY SHARE', 'PUTSAN RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0015', 'PUTSAN', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0016', 'ACTIVE', '-', 'RIZAL RPT BASIC PRIOR BARANGAY SHARE', 'RIZAL RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0016', 'RIZAL', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0017', 'ACTIVE', '-', 'SALVACION RPT BASIC PRIOR BARANGAY SHARE', 'SALVACION RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0017', 'SALVACION', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0018', 'ACTIVE', '-', 'SAN MIGUEL RPT BASIC PRIOR BARANGAY SHARE', 'SAN MIGUEL RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0018', 'SAN MIGUEL', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-02-0019', 'ACTIVE', '-', 'TILOD RPT BASIC PRIOR BARANGAY SHARE', 'TILOD RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-02-0019', 'TILOD', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR PROVINCE SHARE', 'RPT BASIC PRIOR PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC PRIOR PROVINCE SHARE', 'CATANDUANES RPT BASIC PRIOR PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASIC_PRIOR_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_CURRENT', 'ACTIVE', '455-050', 'RPT SEF PENALTY CURRENT', 'RPT SEF PENALTY CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_CURRENT:02702', 'ACTIVE', '-', 'BARAS RPT SEF PENALTY CURRENT', 'BARAS RPT SEF PENALTY CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02702', 'BARAS', 'RPT_SEFINT_CURRENT', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_CURRENT_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF CURRENT PENALTY PROVINCE SHARE', 'CATANDUANES RPT SEF CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEFINT_CURRENT_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PENALTY PREVIOUS', 'RPT SEF PENALTY PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PREVIOUS:02702', 'ACTIVE', '-', 'BARAS RPT SEF PENALTY PREVIOUS', 'BARAS RPT SEF PENALTY PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02702', 'BARAS', 'RPT_SEFINT_PREVIOUS', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PREVIOUS_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'CATANDUANES RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PENALTY PRIOR', 'RPT SEF PENALTY PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PRIOR:02702', 'ACTIVE', '-', 'BARAS RPT SEF PENALTY PRIOR', 'BARAS RPT SEF PENALTY PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02702', 'BARAS', 'RPT_SEFINT_PRIOR', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PRIOR_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF PRIOR PENALTY PROVINCE SHARE', 'CATANDUANES RPT SEF PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEFINT_PRIOR_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_ADVANCE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE', 'RPT SEF ADVANCE', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_ADVANCE:02702', 'ACTIVE', '-', 'BARAS RPT SEF ADVANCE', 'BARAS RPT SEF ADVANCE', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02702', 'BARAS', 'RPT_SEF_ADVANCE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_ADVANCE_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE PROVINCE SHARE', 'RPT SEF ADVANCE PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_ADVANCE_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF ADVANCE PROVINCE SHARE', 'CATANDUANES RPT SEF ADVANCE PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEF_ADVANCE_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_CURRENT', 'ACTIVE', '455-050', 'RPT SEF CURRENT', 'RPT SEF CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_CURRENT:02702', 'ACTIVE', '-', 'BARAS RPT SEF CURRENT', 'BARAS RPT SEF CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02702', 'BARAS', 'RPT_SEF_CURRENT', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT PROVINCE SHARE', 'RPT SEF CURRENT PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_CURRENT_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF CURRENT PROVINCE SHARE', 'CATANDUANES RPT SEF CURRENT PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEF_CURRENT_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS', 'RPT SEF PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PREVIOUS:02702', 'ACTIVE', '-', 'BARAS RPT SEF PREVIOUS', 'BARAS RPT SEF PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02702', 'BARAS', 'RPT_SEF_PREVIOUS', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS PROVINCE SHARE', 'RPT SEF PREVIOUS PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PREVIOUS_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF PREVIOUS PROVINCE SHARE', 'CATANDUANES RPT SEF PREVIOUS PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEF_PREVIOUS_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PRIOR', 'RPT SEF PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PRIOR:02702', 'ACTIVE', '-', 'BARAS RPT SEF PRIOR', 'BARAS RPT SEF PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02702', 'BARAS', 'RPT_SEF_PRIOR', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR PROVINCE SHARE', 'RPT SEF PRIOR PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PRIOR_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF PRIOR PROVINCE SHARE', 'CATANDUANES RPT SEF PRIOR PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEF_PRIOR_PROVINCE_SHARE', '0', '0', '0');

INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASICINT_CURRENT', 'RPT_BASICINT_CURRENT', 'rpt_basicint_current');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE', 'RPT_BASICINT_CURRENT_BRGY_SHARE', 'rpt_basicint_current');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASICINT_CURRENT_PROVINCE_SHARE', 'RPT_BASICINT_CURRENT_PROVINCE_SHARE', 'rpt_basicint_current');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASICINT_PREVIOUS', 'RPT_BASICINT_PREVIOUS', 'rpt_basicint_previous');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', 'rpt_basicint_previous');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', 'rpt_basicint_previous');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASICINT_PRIOR', 'RPT_BASICINT_PRIOR', 'rpt_basicint_prior');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE', 'RPT_BASICINT_PRIOR_BRGY_SHARE', 'rpt_basicint_prior');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASICINT_PRIOR_PROVINCE_SHARE', 'RPT_BASICINT_PRIOR_PROVINCE_SHARE', 'rpt_basicint_prior');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASIC_ADVANCE', 'RPT_BASIC_ADVANCE', 'rpt_basic_advance');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE', 'RPT_BASIC_ADVANCE_BRGY_SHARE', 'rpt_basic_advance');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASIC_ADVANCE_PROVINCE_SHARE', 'RPT_BASIC_ADVANCE_PROVINCE_SHARE', 'rpt_basic_advance');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASIC_CURRENT', 'RPT_BASIC_CURRENT', 'rpt_basic_current');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE', 'RPT_BASIC_CURRENT_BRGY_SHARE', 'rpt_basic_current');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASIC_CURRENT_PROVINCE_SHARE', 'RPT_BASIC_CURRENT_PROVINCE_SHARE', 'rpt_basic_current');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASIC_PREVIOUS', 'RPT_BASIC_PREVIOUS', 'rpt_basic_previous');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', 'rpt_basic_previous');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASIC_PREVIOUS_PROVINCE_SHARE', 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE', 'rpt_basic_previous');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASIC_PRIOR', 'RPT_BASIC_PRIOR', 'rpt_basic_prior');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE', 'RPT_BASIC_PRIOR_BRGY_SHARE', 'rpt_basic_prior');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_BASIC_PRIOR_PROVINCE_SHARE', 'RPT_BASIC_PRIOR_PROVINCE_SHARE', 'rpt_basic_prior');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEFINT_CURRENT', 'RPT_SEFINT_CURRENT', 'rpt_sefint_current');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEFINT_CURRENT_PROVINCE_SHARE', 'RPT_SEFINT_CURRENT_PROVINCE_SHARE', 'rpt_sefint_current');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEFINT_PREVIOUS', 'RPT_SEFINT_PREVIOUS', 'rpt_sefint_previous');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', 'rpt_sefint_previous');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEFINT_PRIOR', 'RPT_SEFINT_PRIOR', 'rpt_sefint_prior');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEFINT_PRIOR_PROVINCE_SHARE', 'RPT_SEFINT_PRIOR_PROVINCE_SHARE', 'rpt_sefint_prior');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEF_ADVANCE', 'RPT_SEF_ADVANCE', 'rpt_sef_advance');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEF_ADVANCE_PROVINCE_SHARE', 'RPT_SEF_ADVANCE_PROVINCE_SHARE', 'rpt_sef_advance');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEF_CURRENT', 'RPT_SEF_CURRENT', 'rpt_sef_current');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEF_CURRENT_PROVINCE_SHARE', 'RPT_SEF_CURRENT_PROVINCE_SHARE', 'rpt_sef_current');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEF_PREVIOUS', 'RPT_SEF_PREVIOUS', 'rpt_sef_previous');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEF_PREVIOUS_PROVINCE_SHARE', 'RPT_SEF_PREVIOUS_PROVINCE_SHARE', 'rpt_sef_previous');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEF_PRIOR', 'RPT_SEF_PRIOR', 'rpt_sef_prior');
INSERT INTO `itemaccount_tag` (`objid`, `acctid`, `tag`) VALUES ('RPT_SEF_PRIOR_PROVINCE_SHARE', 'RPT_SEF_PRIOR_PROVINCE_SHARE', 'rpt_sef_prior');
