/* COMPROMISE UPDATE */
alter table rptcompromise_item add qtr int;

/* 255-03013 */
alter table resection_item add newfaas_claimno varchar(25);
alter table resection_item add faas_claimno varchar(25);

/* 255-03015 */

CREATE TABLE `rptcertification_online` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `reftype` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `refdate` date NOT NULL,
  `orno` varchar(25) DEFAULT NULL,
  `ordate` date DEFAULT NULL,
  `oramount` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orno` (`orno`),
  CONSTRAINT `fk_rptcertification_online_rptcertification` FOREIGN KEY (`objid`) REFERENCES `rptcertification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `assessmentnotice_online` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `reftype` varchar(25) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `refdate` date NOT NULL,
  `orno` varchar(25) DEFAULT NULL,
  `ordate` date DEFAULT NULL,
  `oramount` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orno` (`orno`),
  CONSTRAINT `fk_assessmentnotice_online_assessmentnotice` FOREIGN KEY (`objid`) REFERENCES `assessmentnotice` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



/*===============================================================
**
** FAAS ANNOTATION
**
===============================================================*/
CREATE TABLE `faasannotation_faas` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `faas_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table faasannotation_faas 
add constraint fk_faasannotationfaas_faasannotation foreign key(parent_objid)
references faasannotation (objid)
;

alter table faasannotation_faas 
add constraint fk_faasannotationfaas_faas foreign key(faas_objid)
references faas (objid)
;

create index ix_parent_objid on faasannotation_faas(parent_objid)
;

create index ix_faas_objid on faasannotation_faas(faas_objid)
;


create unique index ux_parent_faas on faasannotation_faas(parent_objid, faas_objid)
;

alter table faasannotation modify column faasid varchar(50) null
;



-- insert annotated faas
insert into faasannotation_faas(
  objid, 
  parent_objid,
  faas_objid 
)
select 
  objid, 
  objid as parent_objid,
  faasid as faas_objid 
from faasannotation
;



/*============================================
*
*  LEDGER FAAS FACTS
*
=============================================*/
INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('rptledger_rule_include_ledger_faases', '0', 'Include Ledger FAASes as rule facts', 'checkbox', 'LANDTAX')
;

INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('rptledger_post_ledgerfaas_by_actualuse', '0', 'Post by Ledger FAAS by actual use', 'checkbox', 'LANDTAX')
;

/* 255-03016 */

/*================================================================
*
* RPTLEDGER REDFLAG
*
================================================================*/

CREATE TABLE `rptledger_redflag` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `caseno` varchar(25) NULL,
  `dtfiled` datetime NULL,
  `type` varchar(25) NOT NULL,
  `finding` text,
  `remarks` text,
  `blockaction` varchar(25) DEFAULT NULL,
  `filedby_objid` varchar(50) DEFAULT NULL,
  `filedby_name` varchar(255) DEFAULT NULL,
  `filedby_title` varchar(50) DEFAULT NULL,
  `resolvedby_objid` varchar(50) DEFAULT NULL,
  `resolvedby_name` varchar(255) DEFAULT NULL,
  `resolvedby_title` varchar(50) DEFAULT NULL,
  `dtresolved` datetime NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_parent_objid on rptledger_redflag(parent_objid)
;
create index ix_state on rptledger_redflag(state)
;
create unique index ux_caseno on rptledger_redflag(caseno)
;
create index ix_type on rptledger_redflag(type)
;
create index ix_filedby_objid on rptledger_redflag(filedby_objid)
;
create index ix_resolvedby_objid on rptledger_redflag(resolvedby_objid)
;

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_rptledger foreign key (parent_objid)
references rptledger(objid)
;

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_filedby foreign key (filedby_objid)
references sys_user(objid)
;

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_resolvedby foreign key (resolvedby_objid)
references sys_user(objid)
;





/*==================================================
* RETURNED TASK 
==================================================*/
alter table faas_task add returnedby varchar(100)
;
alter table subdivision_task add returnedby varchar(100)
;
alter table consolidation_task add returnedby varchar(100)
;
alter table cancelledfaas_task add returnedby varchar(100)
;
alter table resection_task add returnedby varchar(100)
;


/* 255-03017 */

/*================================================================
*
* LANDTAX SHARE POSTING
*
================================================================*/

alter table rptpayment_share 
	add iscommon int,
	add `year` int
;

update rptpayment_share set iscommon = 0 where iscommon is null 
;


CREATE TABLE `cashreceipt_rpt_share_forposting` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `txndate` datetime NOT NULL,
  `error` int(255) NOT NULL,
  `msg` text,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


create UNIQUE index `ux_receiptid_rptledgerid` on cashreceipt_rpt_share_forposting (`receiptid`,`rptledgerid`)
;
create index `fk_cashreceipt_rpt_share_forposing_rptledger` on cashreceipt_rpt_share_forposting (`rptledgerid`)
;
create index `fk_cashreceipt_rpt_share_forposing_cashreceipt` on cashreceipt_rpt_share_forposting (`receiptid`)
;

alter table cashreceipt_rpt_share_forposting add CONSTRAINT `fk_cashreceipt_rpt_share_forposing_rptledger` 
FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
;
alter table cashreceipt_rpt_share_forposting add CONSTRAINT `fk_cashreceipt_rpt_share_forposing_cashreceipt` 
FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`)
;




/*==================================================
**
** BLDG DATE CONSTRUCTED SUPPORT 
**
===================================================*/

alter table bldgrpu add dtconstructed date;


/* 255-03018 */

/*==================================================
**
** ONLINE BATCH GR 
**
===================================================*/
drop table if exists zz_tmp_batchgr_item 
;
drop table if exists zz_tmp_batchgr
;

create table zz_tmp_batchgr 
select * from batchgr
;

create table zz_tmp_batchgr_item 
select * from batchgr_item
;

drop table if exists batchgr_task
;

alter table batchgr 
  add txntype_objid varchar(50),
  add txnno varchar(25),
  add txndate datetime,
  add effectivityyear int,
  add effectivityqtr int,
  add originlgu_objid varchar(50)
;


create index ix_ry on batchgr(ry)
;
create index ix_txnno on batchgr(txnno)
;
create index ix_classificationid on batchgr(classification_objid)
;
create index ix_section on batchgr(section)
;

alter table batchgr 
add constraint fk_batchgr_lguid foreign key(lgu_objid) 
references sys_org(objid)
;

alter table batchgr 
add constraint fk_batchgr_barangayid foreign key(barangay_objid) 
references sys_org(objid)
;

alter table batchgr 
add constraint fk_batchgr_classificationid foreign key(classification_objid) 
references propertyclassification(objid)
;


alter table batchgr_item add subsuffix int
;

alter table batchgr_item 
add constraint fk_batchgr_item_faas foreign key(objid) 
references faas(objid)
;

create table `batchgr_task` (
  `objid` varchar(50) not null,
  `refid` varchar(50) default null,
  `parentprocessid` varchar(50) default null,
  `state` varchar(50) default null,
  `startdate` datetime default null,
  `enddate` datetime default null,
  `assignee_objid` varchar(50) default null,
  `assignee_name` varchar(100) default null,
  `assignee_title` varchar(80) default null,
  `actor_objid` varchar(50) default null,
  `actor_name` varchar(100) default null,
  `actor_title` varchar(80) default null,
  `message` varchar(255) default null,
  `signature` longtext,
  `returnedby` varchar(100) default null,
  primary key (`objid`),
  key `ix_assignee_objid` (`assignee_objid`),
  key `ix_refid` (`refid`)
) engine=innodb default charset=utf8;

alter table batchgr_task 
add constraint fk_batchgr_task_batchgr foreign key(refid) 
references batchgr(objid)
;




drop view if exists vw_batchgr
;

create view vw_batchgr 
as 
select 
  bg.*,
  l.name as lgu_name,
  b.name as barangay_name,
  pc.name as classification_name,
  t.objid AS taskid,
  t.state AS taskstate,
  t.assignee_objid 
from batchgr bg
inner join sys_org l on bg.lgu_objid = l.objid 
left join sys_org b on bg.barangay_objid = b.objid
left join propertyclassification pc on bg.classification_objid = pc.objid 
left join batchgr_task t on bg.objid = t.refid  and t.enddate is null 
;


/* insert task */
insert into batchgr_task (
  objid,
  refid,
  parentprocessid,
  state,
  startdate,
  enddate,
  assignee_objid,
  assignee_name,
  assignee_title,
  actor_objid,
  actor_name,
  actor_title,
  message,
  signature,
  returnedby
)
select 
  concat(b.objid, '-appraiser') as objid,
  b.objid as refid,
  null as parentprocessid,
  'appraiser' as state,
  b.appraiser_dtsigned as startdate,
  b.appraiser_dtsigned as enddate,
  null as assignee_objid,
  b.appraiser_name as assignee_name,
  null as assignee_title,
  null as actor_objid,
  b.appraiser_name as actor_name,
  null as actor_title,
  null as message,
  null as signature,
  null as returnedby
from batchgr b
where b.appraiser_name is not null
;


insert into batchgr_task (
  objid,
  refid,
  parentprocessid,
  state,
  startdate,
  enddate,
  assignee_objid,
  assignee_name,
  assignee_title,
  actor_objid,
  actor_name,
  actor_title,
  message,
  signature,
  returnedby
)
select 
  concat(b.objid, '-taxmapper') as objid,
  b.objid as refid,
  null as parentprocessid,
  'taxmapper' as state,
  b.taxmapper_dtsigned as startdate,
  b.taxmapper_dtsigned as enddate,
  null as assignee_objid,
  b.taxmapper_name as assignee_name,
  null as assignee_title,
  null as actor_objid,
  b.taxmapper_name as actor_name,
  null as actor_title,
  null as message,
  null as signature,
  null as returnedby
from batchgr b
where b.taxmapper_name is not null
;


insert into batchgr_task (
  objid,
  refid,
  parentprocessid,
  state,
  startdate,
  enddate,
  assignee_objid,
  assignee_name,
  assignee_title,
  actor_objid,
  actor_name,
  actor_title,
  message,
  signature,
  returnedby
)
select 
  concat(b.objid, '-recommender') as objid,
  b.objid as refid,
  null as parentprocessid,
  'recommender' as state,
  b.recommender_dtsigned as startdate,
  b.recommender_dtsigned as enddate,
  null as assignee_objid,
  b.recommender_name as assignee_name,
  null as assignee_title,
  null as actor_objid,
  b.recommender_name as actor_name,
  null as actor_title,
  null as message,
  null as signature,
  null as returnedby
from batchgr b
where b.recommender_name is not null
;



insert into batchgr_task (
  objid,
  refid,
  parentprocessid,
  state,
  startdate,
  enddate,
  assignee_objid,
  assignee_name,
  assignee_title,
  actor_objid,
  actor_name,
  actor_title,
  message,
  signature,
  returnedby
)
select 
  concat(b.objid, '-approver') as objid,
  b.objid as refid,
  null as parentprocessid,
  'approver' as state,
  b.approver_dtsigned as startdate,
  b.approver_dtsigned as enddate,
  null as assignee_objid,
  b.approver_name as assignee_name,
  null as assignee_title,
  null as actor_objid,
  b.approver_name as actor_name,
  null as actor_title,
  null as message,
  null as signature,
  null as returnedby
from batchgr b
where b.approver_name is not null
;


alter table batchgr 
  drop column appraiser_name,
  drop column appraiser_dtsigned,
  drop column taxmapper_name,
  drop column taxmapper_dtsigned,
  drop column recommender_name,
  drop column recommender_dtsigned,
  drop column approver_name,
  drop column approver_dtsigned
;  




/*===========================================
*
*  ENTITY MAPPING (PROVINCE)
*
============================================*/

DROP TABLE IF EXISTS `entity_mapping`
;

CREATE TABLE `entity_mapping` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `org_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


drop view if exists vw_entity_mapping
;
drop table if exists vw_entity_mapping
;

create view vw_entity_mapping
as 
select 
  r.*,
  e.entityno,
  e.name, 
  e.address_text as address_text,
  a.province as address_province,
  a.municipality as address_municipality
from entity_mapping r 
inner join entity e on r.objid = e.objid 
left join entity_address a on e.address_objid = a.objid
left join sys_org b on a.barangay_objid = b.objid 
left join sys_org m on b.parent_objid = m.objid 
;




/*===========================================
*
*  CERTIFICATION UPDATES
*
============================================*/
drop view if exists vw_rptcertification_item
;

create view vw_rptcertification_item
as 
SELECT 
  rci.rptcertificationid,
  f.objid as faasid,
  f.fullpin, 
  f.tdno,
  e.objid as taxpayerid,
  e.name as taxpayer_name, 
  f.owner_name, 
  f.administrator_name,
  f.titleno,  
  f.rpuid, 
  pc.code AS classcode, 
  pc.name AS classname,
  so.name AS lguname,
  b.name AS barangay, 
  r.rputype, 
  r.suffix,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalav,
  r.totalmv, 
  rp.street,
  rp.blockno,
  rp.cadastrallotno,
  rp.surveyno,
  r.taxable,
  f.effectivityyear,
  f.effectivityqtr
FROM rptcertificationitem rci 
  INNER JOIN faas f ON rci.refid = f.objid 
  INNER JOIN rpu r ON f.rpuid = r.objid 
  INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
  INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
  INNER JOIN barangay b ON rp.barangayid = b.objid 
  INNER JOIN sys_org so on f.lguid = so.objid 
  INNER JOIN entity e on f.taxpayer_objid = e.objid 
;



/*===========================================
*
*  SUBDIVISION ASSISTANCE
*
============================================*/
drop table if exists subdivision_assist_item
; 

drop table if exists subdivision_assist
; 

CREATE TABLE `subdivision_assist` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `taskstate` varchar(50) NOT NULL,
  `assignee_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table subdivision_assist 
add constraint fk_subdivision_assist_subdivision foreign key(parent_objid)
references subdivision(objid)
;

alter table subdivision_assist 
add constraint fk_subdivision_assist_user foreign key(assignee_objid)
references sys_user(objid)
;

create index ix_parent_objid on subdivision_assist(parent_objid)
;

create index ix_assignee_objid on subdivision_assist(assignee_objid)
;

create unique index ux_parent_assignee on subdivision_assist(parent_objid, taskstate, assignee_objid)
;


CREATE TABLE `subdivision_assist_item` (
`objid` varchar(50) NOT NULL,
  `subdivision_objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `pintype` varchar(10) NOT NULL,
  `section` varchar(5) NOT NULL,
  `startparcel` int(255) NOT NULL,
  `endparcel` int(255) NOT NULL,
  `parcelcount` int(11) DEFAULT NULL,
  `parcelcreated` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision foreign key(subdivision_objid)
references subdivision(objid)
;

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision_assist foreign key(parent_objid)
references subdivision_assist(objid)
;

create index ix_subdivision_objid on subdivision_assist_item(subdivision_objid)
;

create index ix_parent_objid on subdivision_assist_item(parent_objid)
;



/*==================================================
**
** REALTY TAX CREDIT
**
===================================================*/

drop table if exists rpttaxcredit
;



CREATE TABLE `rpttaxcredit` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `type` varchar(25) NOT NULL,
  `txnno` varchar(25) DEFAULT NULL,
  `txndate` datetime DEFAULT NULL,
  `reftype` varchar(25) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(25) NOT NULL,
  `refdate` date NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtapplied` decimal(16,2) NOT NULL,
  `rptledger_objid` varchar(50) NOT NULL,
  `srcledger_objid` varchar(50) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `approvedby_objid` varchar(50) DEFAULT NULL,
  `approvedby_name` varchar(150) DEFAULT NULL,
  `approvedby_title` varchar(75) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


create index ix_state on rpttaxcredit(state)
;

create index ix_type on rpttaxcredit(type)
;

create unique index ux_txnno on rpttaxcredit(txnno)
;

create index ix_reftype on rpttaxcredit(reftype)
;

create index ix_refid on rpttaxcredit(refid)
;

create index ix_refno on rpttaxcredit(refno)
;

create index ix_rptledger_objid on rpttaxcredit(rptledger_objid)
;

create index ix_srcledger_objid on rpttaxcredit(srcledger_objid)
;

alter table rpttaxcredit
add constraint fk_rpttaxcredit_rptledger foreign key (rptledger_objid)
references rptledger (objid)
;

alter table rpttaxcredit
add constraint fk_rpttaxcredit_srcledger foreign key (srcledger_objid)
references rptledger (objid)
;

alter table rpttaxcredit
add constraint fk_rpttaxcredit_sys_user foreign key (approvedby_objid)
references sys_user(objid)
;





/*==================================================
**
** MACHINE SMV
**
===================================================*/

CREATE TABLE `machine_smv` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `machine_objid` varchar(50) NOT NULL,
  `expr` varchar(255) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_parent_objid on machine_smv(parent_objid)
;
create index ix_machine_objid on machine_smv(machine_objid)
;
create index ix_previd on machine_smv(previd)
;
create unique index ux_parent_machine on machine_smv(parent_objid, machine_objid)
;



alter table machine_smv
add constraint fk_machinesmv_machrysetting foreign key (parent_objid)
references machrysetting (objid)
;

alter table machine_smv
add constraint fk_machinesmv_machine foreign key (machine_objid)
references machine(objid)
;


alter table machine_smv
add constraint fk_machinesmv_machinesmv foreign key (previd)
references machine_smv(objid)
;


create view vw_machine_smv 
as 
select 
  ms.*, 
  m.code,
  m.name
from machine_smv ms 
inner join machine m on ms.machine_objid = m.objid 
;

alter table machdetail 
  add smvid varchar(50),
  add params text
;

update machdetail set params = '[]' where params is null
;

create index ix_smvid on machdetail(smvid)
;


alter table machdetail 
add constraint fk_machdetail_machine_smv foreign key(smvid)
references machine_smv(objid)
;




/*==================================================
**
** AFFECTED FAS TXNTYPE (DP)
**
===================================================*/

INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('faas_affected_rpu_txntype_dp', '0', 'Set affected improvements FAAS txntype to DP e.g. SD and CS', 'checkbox', 'ASSESSOR')
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



create index ix_year on rptpayment_item (year)
;
create index ix_revperiod on rptpayment_item (revperiod)
;
create index ix_revtype on rptpayment_item (revtype)
;


create index ix_year on rptpayment_share (year)
;
create index ix_revperiod on rptpayment_share (revperiod)
;
create index ix_revtype on rptpayment_share (revtype)
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


alter table bldgrpu add occpermitno varchar(25)
;

alter table rpu add isonline int
;

update rpu set isonline = 0 where isonline is null 
;


drop table if exists sync_data_forprocess
;
drop table if exists sync_data_pending
;
drop table if exists sync_data
;

CREATE TABLE `syncdata_forsync` (
  `objid` varchar(50) NOT NULL,
  `reftype` varchar(100) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `action` varchar(100) NOT NULL,
  `orgid` varchar(25) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `createdby_title` varchar(100) DEFAULT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_createdbyid` (`createdby_objid`),
  KEY `ix_reftype` (`reftype`) USING BTREE,
  KEY `ix_refno` (`refno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `syncdata` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `action` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `orgid` varchar(50) DEFAULT NULL,
  `remote_orgid` varchar(50) DEFAULT NULL,
  `remote_orgcode` varchar(20) DEFAULT NULL,
  `remote_orgclass` varchar(20) DEFAULT NULL,
  `sender_objid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(150) DEFAULT NULL,
  `fileid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_reftype` (`reftype`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orgid` (`orgid`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `ix_fileid` (`fileid`),
  KEY `ix_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `syncdata_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `reftype` varchar(255) NOT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `error` text,
  `idx` int(255) NOT NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  CONSTRAINT `fk_syncdataitem_syncdata` FOREIGN KEY (`parentid`) REFERENCES `syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



CREATE TABLE `syncdata_forprocess` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  CONSTRAINT `fk_syncdata_forprocess_syncdata_item` FOREIGN KEY (`objid`) REFERENCES `syncdata_item` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `syncdata_pending` (
  `objid` varchar(50) NOT NULL,
  `error` text,
  `expirydate` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_expirydate` (`expirydate`),
  CONSTRAINT `fk_syncdata_pending_syncdata` FOREIGN KEY (`objid`) REFERENCES `syncdata` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;




/* PREVTAXABILITY */
alter table faas_previous add prevtaxability varchar(10)
;


update faas_previous pf, faas f, rpu r set 
  pf.prevtaxability = case when r.taxable = 1 then 'TAXABLE' else 'EXEMPT' end 
where pf.prevfaasid = f.objid
and f.rpuid = r.objid 
and pf.prevtaxability is null 
;



/* 255-03020 */

alter table syncdata_item add async int default 0
;
alter table syncdata_item add dependedaction varchar(100)
;

create index ix_state on syncdata(state)
;
create index ix_state on syncdata_item(state)
;

create table syncdata_offline_org (
	orgid varchar(50) not null,
	expirydate datetime not null,
	primary key(orgid)
)
;




/*=======================================
*
*  QRRPA: Mixed-Use Support
*
=======================================*/

drop view if exists vw_rpu_assessment
;

create view vw_rpu_assessment as 
select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join landassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join bldgassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join machassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join planttreeassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join miscassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid
;




drop table if exists syncdata_offline_org
;

DROP TABLE if exists `syncdata_org` 
; 


CREATE TABLE `syncdata_org` (
  `orgid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `errorcount` int default 0,
  PRIMARY KEY (`orgid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_state on syncdata_org(state)
;

insert into syncdata_org (
  orgid, 
  state, 
  errorcount
)
select 
  objid,
  'ACTIVE',
  0
from sys_org
where orgclass = 'province'
;


drop table if exists syncdata_forprocess
;

CREATE TABLE `syncdata_forprocess` (
  `objid` varchar(50) NOT NULL,
  `processed` int(11) DEFAULT '0',
  PRIMARY KEY (`objid`),
  CONSTRAINT `fk_forprocess_syncdata_item` FOREIGN KEY (`objid`) REFERENCES `syncdata_item` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;




alter table rptledger_item 
	add fromqtr int,
	add toqtr int;


DROP TABLE if exists `batch_rpttaxcredit_ledger_posted`
;

DROP TABLE if exists `batch_rpttaxcredit_ledger`
;

DROP TABLE if exists `batch_rpttaxcredit`
;

CREATE TABLE `batch_rpttaxcredit` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txndate` date NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `paymentfrom` date DEFAULT NULL,
  `paymentto` varchar(255) DEFAULT NULL,
  `creditedyear` int(255) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `validity` date NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_txnno` (`txnno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `batch_rpttaxcredit_ledger` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `error` varchar(255) NULL,
	barangayid varchar(50) not null, 
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_state` (`state`),
KEY `ix_barangayid` (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table batch_rpttaxcredit_ledger 
add constraint fk_rpttaxcredit_rptledger_parent foreign key(parentid) references batch_rpttaxcredit(objid)
;

alter table batch_rpttaxcredit_ledger 
add constraint fk_rpttaxcredit_rptledger_rptledger foreign key(objid) references rptledger(objid)
;




CREATE TABLE `batch_rpttaxcredit_ledger_posted` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_barangayid` (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table batch_rpttaxcredit_ledger_posted 
add constraint fk_rpttaxcredit_rptledger_posted_parent foreign key(parentid) references batch_rpttaxcredit(objid)
;

alter table batch_rpttaxcredit_ledger_posted 
add constraint fk_rpttaxcredit_rptledger_posted_rptledger foreign key(objid) references rptledger(objid)
;

create view vw_batch_rpttaxcredit_error
as 
select br.*, rl.tdno
from batch_rpttaxcredit_ledger br 
inner join rptledger rl on br.objid = rl.objid 
where br.state = 'ERROR'
;

alter table rpttaxcredit add info text
;


alter table rpttaxcredit add discapplied decimal(16,2) not null
;

update rpttaxcredit set discapplied = 0 where discapplied is null 
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
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orgid` (`orgid`)
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
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_orgid` (`orgid`)
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
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_state` (`state`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  CONSTRAINT `FK_parentid_rpt_syncdata` FOREIGN KEY (`parentid`) REFERENCES `rpt_syncdata` (`objid`)
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
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_filekey` (`filekey`(255)),
  KEY `ix_remote_orgid` (`remote_orgid`),
  KEY `ix_remote_orgcode` (`remote_orgcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('assesser_new_sync_lgus', NULL, 'List of LGUs using new sync facility', NULL, 'ASSESSOR')
;



ALTER TABLE rpt_syncdata_forsync ADD remote_orgid VARCHAR(15)
;


INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) VALUES ('fileserver_upload_task_active', '0', 'Activate / Deactivate upload task', 'boolean', 'SYSTEM')
;



INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('fileserver_download_task_active', '1', 'Activate / Deactivate download task', 'boolean', 'SYSTEM')
;


CREATE TABLE `rpt_syncdata_completed` (
  `objid` varchar(255) NOT NULL,
  `idx` int(255) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `parent_orgid` varchar(50) DEFAULT NULL,
  `sender_name` varchar(255) DEFAULT NULL,
  `sender_title` varchar(255) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_refid` (`refid`),
  KEY `ix_parent_orgid` (`parent_orgid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table rpt_syncdata_forsync add info text
;
alter table rpt_syncdata add info text
;


drop view if exists vw_landtax_lgu_account_mapping
;

drop table if exists vw_landtax_lgu_account_mapping
;

CREATE VIEW vw_landtax_lgu_account_mapping 
AS 
select 
    ia.org_objid AS org_objid,
    ia.org_name AS org_name,
    o.orgclass AS org_class,
    p.objid AS parent_objid,
    p.code AS parent_code,
    p.title AS parent_title,
    ia.objid AS item_objid,
    ia.code AS item_code,
    ia.title AS item_title,
    ia.fund_objid AS item_fund_objid,
    ia.fund_code AS item_fund_code,
    ia.fund_title AS item_fund_title,
    ia.type AS item_type,
    pt.tag AS item_tag 
from itemaccount ia 
    inner join itemaccount p on ia.parentid = p.objid 
    inner join itemaccount_tag pt on p.objid = pt.acctid 
    inner join sys_org o on ia.org_objid = o.objid 
where p.state = 'ACTIVE' 
  and ia.state = 'ACTIVE'
;


drop view if exists vw_batchgr
;

create view vw_batchgr 
as 
select 
    bg.objid AS objid,
    bg.state AS state,
    bg.ry AS ry,
    bg.lgu_objid AS lgu_objid,
    bg.barangay_objid AS barangay_objid,
    bg.rputype AS rputype,
    bg.classification_objid AS classification_objid,
    bg.section AS section,
    bg.memoranda AS memoranda,
    bg.txntype_objid AS txntype_objid,
    bg.txnno AS txnno,
    bg.txndate AS txndate,
    bg.effectivityyear AS effectivityyear,
    bg.effectivityqtr AS effectivityqtr,
    bg.originlgu_objid AS originlgu_objid,
    l.name AS lgu_name,
    b.name AS barangay_name,
    b.pin AS barangay_pin,
    pc.name AS classification_name,
    t.objid AS taskid,
    t.state AS taskstate,
    t.assignee_objid AS assignee_objid 
from batchgr bg join sys_org l on bg.lgu_objid = l.objid 
    left join barangay b on bg.barangay_objid = b.objid 
    left join propertyclassification pc on bg.classification_objid = pc.objid 
    left join batchgr_task t on bg.objid = t.refid and t.enddate is null 
;


drop table if exists `cashreceipt_rpt_share_forposting_repost` 
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


/*===================================================== 
	IMPORTANT: BEFORE EXECUTING !!!!

	CHANGE "eor" database name to match the LGUs 
	eor production database name

=======================================================*/
drop view if exists vw_landtax_eor
;


create view vw_landtax_eor 
as 
select * from eor.eor
;


drop view if exists vw_landtax_eor_remittance
;

create view vw_landtax_eor_remittance 
as 
select * from eor.eor_remittance
;



CREATE TABLE `rpt_syncdata_fordownload` (
  `objid` varchar(255) NOT NULL,
  `etag` varchar(64) NOT NULL,
  `error` int(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_error` (`error`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

drop view if exists vw_landtax_abstract_of_collection_detail
;

create view vw_landtax_abstract_of_collection_detail
as 
select
	liq.objid as liquidationid,
	liq.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.dtposted as remittancedate,
	cr.objid as receiptid, 
	cr.receiptdate as ordate, 
	cr.receiptno as orno, 
	cr.collector_objid as collectorid,
	rl.objid as rptledgerid,
	rl.fullpin,
	rl.titleno, 
	rl.cadastrallotno, 
	rl.rputype, 
	rl.totalmv, 
	b.name as barangay, 
	rp.fromqtr,
  rp.toqtr,
  rpi.year,
	rpi.qtr,
	rpi.revtype,
	case when cv.objid is null then rl.owner_name else '*** voided ***' end as taxpayername, 
	case when cv.objid is null then rl.tdno else '' end as tdno, 
	case when m.name is null then c.name else m.name end as municityname, 
	case when cv.objid is null  then rl.classcode else '' end as classification, 
	case when cv.objid is null then rl.totalav else 0.0 end as assessvalue,
	case when cv.objid is null then rl.totalav else 0.0 end as assessedvalue,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as basiccurrentyear,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as basicpreviousyear,
	case when cv.objid is null  and rpi.revtype = 'basic' then rpi.discount else 0.0 end as basicdiscount,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as basicpenaltycurrent,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as basicpenaltyprevious,

	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as sefcurrentyear,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as sefpreviousyear,
	case when cv.objid is null  and rpi.revtype = 'sef' then rpi.discount else 0.0 end as sefdiscount,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as sefpenaltycurrent,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as sefpenaltyprevious,

	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as basicidlecurrent,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as basicidleprevious,
	case when cv.objid is null  and rpi.revtype = 'basicidle' then rpi.amount else 0.0 end as basicidlediscount,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as basicidlecurrentpenalty,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as basicidlepreviouspenalty,

	
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as shcurrent,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as shprevious,
	case when cv.objid is null  and rpi.revtype = 'sh' then rpi.discount else 0.0 end as shdiscount,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as shcurrentpenalty,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as shpreviouspenalty,

	case when cv.objid is null and rpi.revtype = 'firecode' then rpi.amount else 0.0 end as firecode,
	
	case 
			when cv.objid is null 
			then rpi.amount - rpi.discount + rpi.interest 
			else 0.0 
	end as total,
	case when cv.objid is null then rpi.partialled else 0 end as partialled
from collectionvoucher liq
	inner join remittance rem on rem.collectionvoucherid = liq.objid 
	inner join cashreceipt cr on rem.objid = cr.remittanceid
	left join cashreceipt_void cv on cr.objid = cv.receiptid 
	inner join rptpayment rp on rp.receiptid= cr.objid 
	inner join rptpayment_item rpi on rpi.parentid = rp.objid
	inner join rptledger rl on rl.objid = rp.refid
	inner join barangay b on b.objid  = rl.barangayid
	left join district d on b.parentid = d.objid 
	left join city c on d.parentid = c.objid 
	left join municipality m on b.parentid = m.objid 
;



drop view if exists vw_landtax_abstract_of_collection_detail_eor
;

create view vw_landtax_abstract_of_collection_detail_eor
as 
select
	rem.objid as liquidationid,
	rem.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	eor.objid as receiptid, 
	eor.receiptdate as ordate, 
	eor.receiptno as orno, 
	rem.createdby_objid as collectorid,
	rl.objid as rptledgerid,
	rl.fullpin,
	rl.titleno, 
	rl.cadastrallotno, 
	rl.rputype, 
	rl.totalmv, 
	b.name as barangay, 
	rp.fromqtr,
  rp.toqtr,
  rpi.year,
	rpi.qtr,
	rpi.revtype,
	case when cv.objid is null then rl.owner_name else '*** voided ***' end as taxpayername, 
	case when cv.objid is null then rl.tdno else '' end as tdno, 
	case when m.name is null then c.name else m.name end as municityname, 
	case when cv.objid is null  then rl.classcode else '' end as classification, 
	case when cv.objid is null then rl.totalav else 0.0 end as assessvalue,
	case when cv.objid is null then rl.totalav else 0.0 end as assessedvalue,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as basiccurrentyear,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as basicpreviousyear,
	case when cv.objid is null  and rpi.revtype = 'basic' then rpi.discount else 0.0 end as basicdiscount,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as basicpenaltycurrent,
	case when cv.objid is null  and rpi.revtype = 'basic' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as basicpenaltyprevious,

	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as sefcurrentyear,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as sefpreviousyear,
	case when cv.objid is null  and rpi.revtype = 'sef' then rpi.discount else 0.0 end as sefdiscount,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as sefpenaltycurrent,
	case when cv.objid is null  and rpi.revtype = 'sef' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as sefpenaltyprevious,

	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as basicidlecurrent,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as basicidleprevious,
	case when cv.objid is null  and rpi.revtype = 'basicidle' then rpi.amount else 0.0 end as basicidlediscount,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as basicidlecurrentpenalty,
	case when cv.objid is null  and rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as basicidlepreviouspenalty,

	
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end as shcurrent,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end as shprevious,
	case when cv.objid is null  and rpi.revtype = 'sh' then rpi.discount else 0.0 end as shdiscount,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end as shcurrentpenalty,
	case when cv.objid is null  and rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end as shpreviouspenalty,

	case when cv.objid is null and rpi.revtype = 'firecode' then rpi.amount else 0.0 end as firecode,
	
	case 
			when cv.objid is null 
			then rpi.amount - rpi.discount + rpi.interest 
			else 0.0 
	end as total,
	case when cv.objid is null then rpi.partialled else 0 end as partialled
from vw_landtax_eor_remittance rem
	inner join vw_landtax_eor eor on rem.objid = eor.remittanceid 
	left join cashreceipt_void cv on eor.objid = cv.receiptid 
	inner join rptpayment rp on eor.objid = rp.receiptid 
	inner join rptpayment_item rpi on rpi.parentid = rp.objid
	inner join rptledger rl on rl.objid = rp.refid
	inner join barangay b on b.objid  = rl.barangayid
	left join district d on b.parentid = d.objid 
	left join city c on d.parentid = c.objid 
	left join municipality m on b.parentid = m.objid 
;


drop view if exists vw_landtax_collection_detail
;

create view vw_landtax_collection_detail
as 
select 
	cv.objid as liquidationid,
	cv.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	cr.receiptdate,
	o.objid as lguid,
	o.name as lgu,
	b.objid as barangayid,
	b.indexno as brgyindex,
	b.name as barangay,
	ri.revperiod,
	ri.revtype,
	ri.year,
	ri.qtr,
	ri.amount,
	ri.interest,
	ri.discount,
  pc.name as classname, 
	pc.orderno, 
	pc.special,  
  case when ri.revperiod='current' and ri.revtype = 'basic' then ri.amount else 0.0 end  as basiccurrent,
  case when ri.revtype = 'basic' then ri.discount else 0.0 end  as basicdisc,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.amount else 0.0 end  as basicprev,
  case when ri.revperiod='current' and ri.revtype = 'basic'  then ri.interest else 0.0 end  as basiccurrentint,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.interest else 0.0 end  as basicprevint,
  case when ri.revtype = 'basic' then ri.amount - ri.discount+ ri.interest else 0 end as basicnet, 

  case when ri.revperiod='current' and ri.revtype = 'sef' then ri.amount else 0.0 end  as sefcurrent,
  case when ri.revtype = 'sef' then ri.discount else 0.0 end  as sefdisc,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.amount else 0.0 end  as sefprev,
  case when ri.revperiod='current' and ri.revtype = 'sef'  then ri.interest else 0.0 end  as sefcurrentint,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.interest else 0.0 end  as sefprevint,
  case when ri.revtype = 'sef' then ri.amount - ri.discount+ ri.interest else 0 end as sefnet, 

  case when ri.revperiod='current' and ri.revtype = 'basicidle' then ri.amount else 0.0 end  as idlecurrent,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basicidle'  then ri.amount else 0.0 end  as idleprev,
  case when ri.revtype = 'basicidle' then ri.discount else 0.0 end  as idledisc,
  case when ri.revtype = 'basicidle' then ri.interest else 0 end   as idleint, 
  case when ri.revtype = 'basicidle'then ri.amount - ri.discount + ri.interest else 0 end as idlenet, 

  case when ri.revperiod='current' and ri.revtype = 'sh' then ri.amount else 0.0 end  as shcurrent,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sh' then ri.amount else 0.0 end  as shprev,
  case when ri.revtype = 'sh' then ri.discount else 0.0 end  as shdisc,
  case when ri.revtype = 'sh' then ri.interest else 0 end  as shint, 
  case when ri.revtype = 'sh' then ri.amount - ri.discount + ri.interest else 0 end as shnet, 

  case when ri.revtype = 'firecode' then ri.amount - ri.discount + ri.interest else 0 end  as firecode,

  0.0 as levynet 
from remittance rem 
  inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
  inner join cashreceipt cr on cr.remittanceid = rem.objid 
  left join cashreceipt_void crv on cr.objid = crv.receiptid
  inner join rptpayment rp on cr.objid = rp.receiptid 
  inner join rptpayment_item ri on rp.objid = ri.parentid
  left join rptledger rl ON rp.refid = rl.objid  
	left join barangay b on rl.barangayid = b.objid 
	left join sys_org o on rl.lguid = o.objid  
  left join propertyclassification pc ON rl.classification_objid = pc.objid 
where crv.objid is null 
;


drop view if exists vw_landtax_collection_disposition_detail
;

create view vw_landtax_collection_disposition_detail
as 
select   
	cv.objid as liquidationid,
	cv.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	cr.receiptdate,
	ri.revperiod,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitybasicshare,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munibasicshare,
    case when ri.revtype in ('basic', 'basicint') and ri.sharetype in ('barangay') then ri.amount else 0.0 end as brgybasicshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitysefshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munisefshare,
    0.0 as brgysefshare 
  from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
		left join cashreceipt_void crv on cr.objid = crv.receiptid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share ri on rp.objid = ri.parentid
  where crv.objid is null 
;


drop view if exists vw_landtax_collection_detail_eor
;

create view vw_landtax_collection_detail_eor
as 
select 
	rem.objid as liquidationid,
	rem.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	eor.receiptdate,
	o.objid as lguid,
	o.name as lgu,
	b.objid as barangayid,
	b.indexno as brgyindex,
	b.name as barangay,
	ri.revperiod,
	ri.revtype,
	ri.year,
	ri.qtr,
	ri.amount,
	ri.interest,
	ri.discount,
  pc.name as classname, 
	pc.orderno, 
	pc.special,  
  case when ri.revperiod='current' and ri.revtype = 'basic' then ri.amount else 0.0 end  as basiccurrent,
  case when ri.revtype = 'basic' then ri.discount else 0.0 end  as basicdisc,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.amount else 0.0 end  as basicprev,
  case when ri.revperiod='current' and ri.revtype = 'basic'  then ri.interest else 0.0 end  as basiccurrentint,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.interest else 0.0 end  as basicprevint,
  case when ri.revtype = 'basic' then ri.amount - ri.discount+ ri.interest else 0 end as basicnet, 

  case when ri.revperiod='current' and ri.revtype = 'sef' then ri.amount else 0.0 end  as sefcurrent,
  case when ri.revtype = 'sef' then ri.discount else 0.0 end  as sefdisc,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.amount else 0.0 end  as sefprev,
  case when ri.revperiod='current' and ri.revtype = 'sef'  then ri.interest else 0.0 end  as sefcurrentint,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.interest else 0.0 end  as sefprevint,
  case when ri.revtype = 'sef' then ri.amount - ri.discount+ ri.interest else 0 end as sefnet, 

  case when ri.revperiod='current' and ri.revtype = 'basicidle' then ri.amount else 0.0 end  as idlecurrent,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basicidle'  then ri.amount else 0.0 end  as idleprev,
  case when ri.revtype = 'basicidle' then ri.discount else 0.0 end  as idledisc,
  case when ri.revtype = 'basicidle' then ri.interest else 0 end   as idleint, 
  case when ri.revtype = 'basicidle'then ri.amount - ri.discount + ri.interest else 0 end as idlenet, 

  case when ri.revperiod='current' and ri.revtype = 'sh' then ri.amount else 0.0 end  as shcurrent,
  case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sh' then ri.amount else 0.0 end  as shprev,
  case when ri.revtype = 'sh' then ri.discount else 0.0 end  as shdisc,
  case when ri.revtype = 'sh' then ri.interest else 0 end  as shint, 
  case when ri.revtype = 'sh' then ri.amount - ri.discount + ri.interest else 0 end as shnet, 

  case when ri.revtype = 'firecode' then ri.amount - ri.discount + ri.interest else 0 end  as firecode,

  0.0 as levynet 
from vw_landtax_eor_remittance rem 
  inner join vw_landtax_eor eor on rem.objid = eor.remittanceid
  inner join rptpayment rp on eor.objid = rp.receiptid 
  inner join rptpayment_item ri on rp.objid = ri.parentid
  left join rptledger rl ON rp.refid = rl.objid  
	left join barangay b on rl.barangayid = b.objid
	left join sys_org o on rl.lguid = o.objid   
  left join propertyclassification pc ON rl.classification_objid = pc.objid 
;


drop view if exists vw_landtax_collection_disposition_detail_eor
;

create view vw_landtax_collection_disposition_detail_eor
as 
select   
	rem.objid as liquidationid,
	rem.controldate as liquidationdate,
	rem.objid as remittanceid,
	rem.controldate as remittancedate,
	eor.receiptdate,
	ri.revperiod,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitybasicshare,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munibasicshare,
    case when ri.revtype in ('basic', 'basicint') and ri.sharetype in ('barangay') then ri.amount else 0.0 end as brgybasicshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitysefshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munisefshare,
    0.0 as brgysefshare 
  from vw_landtax_eor_remittance rem 
    inner join vw_landtax_eor eor on rem.objid = eor.remittanceid
		inner join rptpayment rp on eor.objid = rp.receiptid 
    inner join rptpayment_share ri on rp.objid = ri.parentid
  
;


create view vw_newly_assessed_property as 
select
	f.objid,
	f.owner_name,
	f.tdno,
	b.name as barangay,
	case 
		when f.rputype = 'land' then 'LAND' 
		when f.rputype = 'bldg' then 'BUILDING' 
		when f.rputype = 'mach' then 'MACHINERY' 
		when f.rputype = 'planttree' then 'PLANT/TREE' 
		else 'MISCELLANEOUS'
	end as rputype,
	f.totalav,
	f.effectivityyear
from faas_list f 
	inner join barangay b on f.barangayid = b.objid 
where f.state in ('CURRENT', 'CANCELLED') 
and f.txntype_objid = 'ND'
;

create view vw_real_property_payment as 
select 
	cv.controldate as cv_controldate,
	rem.controldate as rem_controldate,
	rl.owner_name,
	rl.tdno,
	pc.name as classification, 
	case 
		when rl.rputype = 'land' then 'LAND' 
		when rl.rputype = 'bldg' then 'BUILDING' 
		when rl.rputype = 'mach' then 'MACHINERY' 
		when rl.rputype = 'planttree' then 'PLANT/TREE' 
		else 'MISCELLANEOUS'
	end as rputype,
	b.name as barangay,
	rpi.year, 
	rpi.qtr,
	rpi.amount + rpi.interest - rpi.discount as amount,
	case when v.objid is null then 0 else 1 end as voided
from collectionvoucher cv 
	inner join remittance rem on cv.objid = rem.collectionvoucherid
	inner join cashreceipt cr on rem.objid = cr.remittanceid
	inner join rptpayment rp on cr.objid = rp.receiptid 
	inner join rptpayment_item rpi on rp.objid = rpi.parentid 
	inner join rptledger rl on rp.refid = rl.objid 
	inner join barangay b on rl.barangayid = b.objid 
	inner join propertyclassification pc on rl.classification_objid = pc.objid 
	left join cashreceipt_void v on cr.objid = v.receiptid
;

drop view if exists vw_rptledger_cancelled_faas 
;

create view vw_rptledger_cancelled_faas 
as 
select 
	rl.objid,
	rl.state,
	rl.faasid,
	rl.lastyearpaid,
	rl.lastqtrpaid,
	rl.barangayid,
	rl.taxpayer_objid,
	rl.fullpin,
	rl.tdno,
	rl.cadastrallotno,
	rl.rputype,
	rl.txntype_objid,
	rl.classification_objid,
	rl.classcode,
	rl.totalav,
	rl.totalmv,
	rl.totalareaha,
	rl.taxable,
	rl.owner_name,
	rl.prevtdno,
	rl.titleno,
	rl.administrator_name,
	rl.blockno,
	rl.lguid,
	rl.beneficiary_objid,
	pc.name as classification,
	b.name as barangay,
	o.name as lgu
from rptledger rl 
	inner join faas f on rl.faasid = f.objid 
	left join barangay b on rl.barangayid = b.objid 
	left join sys_org o on rl.lguid = o.objid 
	left join propertyclassification pc on rl.classification_objid = pc.objid 
	inner join entity e on rl.taxpayer_objid = e.objid 
where rl.state = 'APPROVED' 
and f.state = 'CANCELLED' 
;


drop view if exists vw_certification_landdetail 
;

create view vw_certification_landdetail 
as 
select 
	f.objid as faasid,
	ld.areaha,
	ld.areasqm,
	ld.assessedvalue,
	ld.marketvalue,
	ld.basemarketvalue,
	ld.unitvalue,
	lspc.name as specificclass_name
from faas f 
	inner join landdetail ld on f.rpuid = ld.landrpuid
	inner join landspecificclass lspc on ld.landspecificclass_objid = lspc.objid 
;


drop view if exists vw_certification_land_improvement
;

create view vw_certification_land_improvement
as 
select 
	f.objid as faasid,
	pt.name as improvement,
	ptd.areacovered,
	ptd.productive,
	ptd.nonproductive,
	ptd.basemarketvalue,
	ptd.marketvalue,
	ptd.unitvalue,
	ptd.assessedvalue
from faas f 
	inner join planttreedetail ptd on f.rpuid = ptd.landrpuid
	inner join planttree pt on ptd.planttree_objid = pt.objid
;





INSERT INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_APPROVER', 'CERTIFICATION_APPROVER', 'RPT', NULL, NULL, 'CERTIFICATION_APPROVER')
;
INSERT INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_VERIFIER', 'RPT CERTIFICATION_VERIFIER', 'RPT', NULL, NULL, 'CERTIFICATION_VERIFIER')
;



INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'rptcertification', 'Start', 'start', '1', NULL, NULL, NULL, '[:]', '[fillColor:\"#00ff00\",size:[32,32],pos:[102,127],type:\"start\"]', NULL)
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'rptcertification', 'Receiver', 'state', '2', NULL, 'RPT', 'CERTIFICATION_ISSUER', '[:]', '[fillColor:\"#c0c0c0\",size:[114,40],pos:[206,127],type:\"state\"]', '1')
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('verifier', 'rptcertification', 'Verifier', 'state', '3', NULL, 'RPT', 'CERTIFICATION_VERIFIER', '[:]', '[fillColor:\"#c0c0c0\",size:[129,44],pos:[412,127],type:\"state\"]', '1')
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'rptcertification', 'Approver', 'state', '4', NULL, 'RPT', 'CERTIFICATION_APPROVER', '[:]', '[fillColor:\"#c0c0c0\",size:[118,42],pos:[604,141],type:\"state\"]', '1')
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approved', 'rptcertification', 'Approved', 'end', '5', NULL, NULL, NULL, '[:]', '[fillColor:\"#ff0000\",size:[32,32],pos:[797,148],type:\"end\"]', NULL)
;

INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'rptcertification', 'assign', 'receiver', '1', NULL, '[:]', NULL, 'Assign', '[size:[72,0],pos:[134,142],type:\"arrow\",points:[134,142,206,142]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'rptcertification', 'cancelissuance', 'end', '5', NULL, '[caption:\'Cancel Issuance\', confirm:\'Cancel issuance?\',closeonend:true]', NULL, 'Cancel Issuance', '[size:[559,116],pos:[258,32],type:\"arrow\",points:[262,127,258,32,817,40,813,148]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'rptcertification', 'submit', 'verifier', '6', NULL, '[caption:\'Submit to Verifier\', confirm:\'Submit to verifier?\', messagehandler:\'rptmessage:info\',targetrole:\'RPT.CERTIFICATION_VERIFIER\']', NULL, 'Submit to Verifier', '[size:[92,0],pos:[320,146],type:\"arrow\",points:[320,146,412,146]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('verifier', 'rptcertification', 'return_receiver', 'receiver', '10', NULL, '[caption:\'Return to Issuer\', confirm:\'Return to issuer?\', messagehandler:\'default\']', NULL, 'Return to Receiver', '[size:[160,63],pos:[292,64],type:\"arrow\",points:[452,127,385,64,292,127]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('verifier', 'rptcertification', 'submit', 'approver', '11', NULL, '[caption:\'Submit for Approval\', confirm:\'Submit for approval?\', messagehandler:\'rptmessage:sign\',targetrole:\'RPT.CERTIFICATION_APPROVER\']', NULL, 'Submit to Approver', '[size:[63,4],pos:[541,152],type:\"arrow\",points:[541,152,604,156]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'rptcertification', 'return_receiver', 'receiver', '15', NULL, '[caption:\'Return to Issuer\', confirm:\'Return to issuer?\', messagehandler:\'default\']', NULL, 'Return to Receiver', '[size:[333,113],pos:[285,167],type:\"arrow\",points:[618,183,414,280,285,167]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'rptcertification', 'submit', 'approved', '16', NULL, '[caption:\'Approve\', confirm:\'Approve?\', messagehandler:\'rptmessage:sign\']', NULL, 'Approve', '[size:[75,0],pos:[722,162],type:\"arrow\",points:[722,162,797,162]]')
;


drop view if exists vw_landtax_report_rptdelinquency_detail
;
drop view if exists vw_landtax_report_rptdelinquency
;
drop table if exists vw_landtax_report_rptdelinquency_detail
;
drop table if exists vw_landtax_report_rptdelinquency
;

CREATE VIEW `vw_landtax_report_rptdelinquency_detail` AS select `ri`.`objid` AS `objid`,`ri`.`rptledgerid` AS `rptledgerid`,`ri`.`barangayid` AS `barangayid`,`ri`.`year` AS `year`,`ri`.`qtr` AS `qtr`,`r`.`dtgenerated` AS `dtgenerated`,`r`.`dtcomputed` AS `dtcomputed`,`r`.`generatedby_name` AS `generatedby_name`,`r`.`generatedby_title` AS `generatedby_title`,(case when (`ri`.`revtype` = 'basic') then `ri`.`amount` else 0 end) AS `basic`,(case when (`ri`.`revtype` = 'basic') then `ri`.`interest` else 0 end) AS `basicint`,(case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0 end) AS `basicdisc`,(case when (`ri`.`revtype` = 'basic') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicdp`,(case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicnet`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`amount` else 0 end) AS `basicidle`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `basicidleint`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0 end) AS `basicidledisc`,(case when (`ri`.`revtype` = 'basicidle') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicidledp`,(case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicidlenet`,(case when (`ri`.`revtype` = 'sef') then `ri`.`amount` else 0 end) AS `sef`,(case when (`ri`.`revtype` = 'sef') then `ri`.`interest` else 0 end) AS `sefint`,(case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0 end) AS `sefdisc`,(case when (`ri`.`revtype` = 'sef') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `sefdp`,(case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `sefnet`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`amount` else 0 end) AS `firecode`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`interest` else 0 end) AS `firecodeint`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`discount` else 0 end) AS `firecodedisc`,(case when (`ri`.`revtype` = 'firecode') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `firecodedp`,(case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `firecodenet`,(case when (`ri`.`revtype` = 'sh') then `ri`.`amount` else 0 end) AS `sh`,(case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,(case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0 end) AS `shdisc`,(case when (`ri`.`revtype` = 'sh') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `shdp`,(case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `shnet`,((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) AS `total` from (`report_rptdelinquency_item` `ri` join `report_rptdelinquency` `r` on((`ri`.`parentid` = `r`.`objid`)))
;

CREATE VIEW `vw_landtax_report_rptdelinquency` AS select `ri`.`objid` AS `objid`,`ri`.`rptledgerid` AS `rptledgerid`,`ri`.`barangayid` AS `barangayid`,`ri`.`year` AS `year`,`ri`.`qtr` AS `qtr`,`r`.`dtgenerated` AS `dtgenerated`,`r`.`dtcomputed` AS `dtcomputed`,`r`.`generatedby_name` AS `generatedby_name`,`r`.`generatedby_title` AS `generatedby_title`,(case when (`ri`.`revtype` = 'basic') then `ri`.`amount` else 0 end) AS `basic`,(case when (`ri`.`revtype` = 'basic') then `ri`.`interest` else 0 end) AS `basicint`,(case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0 end) AS `basicdisc`,(case when (`ri`.`revtype` = 'basic') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicdp`,(case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicnet`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`amount` else 0 end) AS `basicidle`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `basicidleint`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0 end) AS `basicidledisc`,(case when (`ri`.`revtype` = 'basicidle') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicidledp`,(case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicidlenet`,(case when (`ri`.`revtype` = 'sef') then `ri`.`amount` else 0 end) AS `sef`,(case when (`ri`.`revtype` = 'sef') then `ri`.`interest` else 0 end) AS `sefint`,(case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0 end) AS `sefdisc`,(case when (`ri`.`revtype` = 'sef') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `sefdp`,(case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `sefnet`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`amount` else 0 end) AS `firecode`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`interest` else 0 end) AS `firecodeint`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`discount` else 0 end) AS `firecodedisc`,(case when (`ri`.`revtype` = 'firecode') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `firecodedp`,(case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `firecodenet`,(case when (`ri`.`revtype` = 'sh') then `ri`.`amount` else 0 end) AS `sh`,(case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,(case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0 end) AS `shdisc`,(case when (`ri`.`revtype` = 'sh') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `shdp`,(case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `shnet`,((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) AS `total` from (`report_rptdelinquency_item` `ri` join `report_rptdelinquency` `r` on((`ri`.`parentid` = `r`.`objid`)))
;

drop table if exists vw_rptpayment_item_detail
;

drop view if exists vw_rptpayment_item_detail
;


CREATE VIEW `vw_rptpayment_item_detail` AS select `rpi`.`objid` AS `objid`,`rpi`.`parentid` AS `parentid`,`rpi`.`rptledgerfaasid` AS `rptledgerfaasid`,`rpi`.`year` AS `year`,`rpi`.`qtr` AS `qtr`,`rpi`.`revperiod` AS `revperiod`,(case when (`rpi`.`revtype` = 'basic') then `rpi`.`amount` else 0 end) AS `basic`,(case when (`rpi`.`revtype` = 'basic') then `rpi`.`interest` else 0 end) AS `basicint`,(case when (`rpi`.`revtype` = 'basic') then `rpi`.`discount` else 0 end) AS `basicdisc`,(case when (`rpi`.`revtype` = 'basic') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `basicdp`,(case when (`rpi`.`revtype` = 'basic') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `basicnet`,(case when (`rpi`.`revtype` = 'basicidle') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `basicidle`,(case when (`rpi`.`revtype` = 'basicidle') then `rpi`.`interest` else 0 end) AS `basicidleint`,(case when (`rpi`.`revtype` = 'basicidle') then `rpi`.`discount` else 0 end) AS `basicidledisc`,(case when (`rpi`.`revtype` = 'basicidle') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `basicidledp`,(case when (`rpi`.`revtype` = 'sef') then `rpi`.`amount` else 0 end) AS `sef`,(case when (`rpi`.`revtype` = 'sef') then `rpi`.`interest` else 0 end) AS `sefint`,(case when (`rpi`.`revtype` = 'sef') then `rpi`.`discount` else 0 end) AS `sefdisc`,(case when (`rpi`.`revtype` = 'sef') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `sefdp`,(case when (`rpi`.`revtype` = 'sef') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `sefnet`,(case when (`rpi`.`revtype` = 'firecode') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `firecode`,(case when (`rpi`.`revtype` = 'sh') then `rpi`.`amount` else 0 end) AS `sh`,(case when (`rpi`.`revtype` = 'sh') then `rpi`.`interest` else 0 end) AS `shint`,(case when (`rpi`.`revtype` = 'sh') then `rpi`.`discount` else 0 end) AS `shdisc`,(case when (`rpi`.`revtype` = 'sh') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `shdp`,(case when (`rpi`.`revtype` = 'sh') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `shnet`,((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) AS `amount`,`rpi`.`partialled` AS `partialled` from `rptpayment_item` `rpi`
;


