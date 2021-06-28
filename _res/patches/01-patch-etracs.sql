-- 
-- Patches from 2020-06-06 to 2021-01-31 
-- 

-- ## 2020-06-06

alter table aftxn add lockid varchar(50) null 
; 

-- alter table af_control add constraint fk_af_control_afid 
--    foreign key (afid) references af (objid) 
-- ; 

alter table af_control modify allocid varchar(50) character set utf8 NULL
; 
alter table af_control add constraint fk_af_control_allocid 
	foreign key (allocid) references af_allocation (objid) 
; 

drop view if exists vw_af_inventory_summary
;
CREATE VIEW vw_af_inventory_summary AS 
select 
	af.objid, af.title, u.unit, af.formtype, 
	(case when af.formtype='serial' then 0 else 1 end) as formtypeindex, 
	(select count(0) from af_control where afid = af.objid and state = 'OPEN') AS countopen, 
	(select count(0) from af_control where afid = af.objid and state = 'ISSUED') AS countissued, 
	(select count(0) from af_control where afid = af.objid and state = 'ISSUED' and currentseries > endseries) AS countclosed, 
	(select count(0) from af_control where afid = af.objid and state = 'SOLD') AS countsold, 
	(select count(0) from af_control where afid = af.objid and state = 'PROCESSING') AS countprocessing, 
	(select count(0) from af_control where afid = af.objid and state = 'HOLD') AS counthold
from af, afunit u 
where af.objid = u.itemid
order by (case when af.formtype='serial' then 0 else 1 end), af.objid 
;

alter table af_control add salecost decimal(16,2) not null default '0.0'
;


insert into sys_usergroup (
	objid, title, domain, role, userclass
) values (
	'TREASURY.AFO_ADMIN', 'TREASURY AFO ADMIN', 'TREASURY', 'AFO_ADMIN', 'usergroup' 
); 

insert into sys_usergroup_permission (
	objid, usergroup_objid, object, permission, title 
) values ( 
	'TREASURY-AFO-ADMIN-aftxn-changetxntype', 'TREASURY.AFO_ADMIN', 'aftxn', 'changeTxnType', 'Change Txn Type'
); 



-- ## 2020-06-09
insert into sys_usergroup (
	objid, title, domain, role, userclass
) values (
	'TREASURY.COLLECTOR_ADMIN', 'TREASURY COLLECTOR ADMIN', 'TREASURY', 'COLLECTOR_ADMIN', 'usergroup' 
); 

insert into sys_usergroup_permission (
	objid, usergroup_objid, object, permission, title 
) values ( 
	'TREASURY-COLLECTOR-ADMIN-aftxn-changetxntype', 'TREASURY.COLLECTOR_ADMIN', 'remittance', 'rebuildFund', 'Rebuild Remittance Fund'
); 



-- ## 2020-06-10
update af_control_detail set reftype = 'ISSUE' where txntype='SALE' and reftype <> 'ISSUE' 
; 

update 
	af_control_detail aa, ( 
		select 
			(select count(*) from cashreceipt where controlid = d.controlid) as receiptcount, 
			d.objid, d.controlid, d.endingstartseries, d.endingendseries, d.qtyending 
		from af_control_detail d 
		where d.txntype='SALE' 
			and d.qtyending > 0
	)bb 
set 
	aa.issuedstartseries = bb.endingstartseries, aa.issuedendseries = bb.endingendseries, aa.qtyissued = bb.qtyending, 
	aa.endingstartseries = null, aa.endingendseries = null, aa.qtyending = 0 
where aa.objid = bb.objid 
	and bb.receiptcount = 0 
;

update 
	af_control_detail aa, ( 
		select 
			(select count(*) from cashreceipt where controlid = d.controlid) as receiptcount, 
			d.objid, d.controlid, d.endingstartseries, d.endingendseries, d.qtyending 
		from af_control_detail d 
		where d.txntype='SALE' 
			and d.qtyending > 0
	)bb 
set 
	aa.reftype = 'ISSUE', aa.txntype = 'COLLECTION', aa.remarks = 'COLLECTION' 
where aa.objid = bb.objid 
	and bb.receiptcount > 0 
;


alter table sys_usergroup_permission modify objid varchar(100) not null 
;

insert into sys_usergroup_permission (
	objid, usergroup_objid, object, permission, title 
) values ( 
	'TREASURY-COLLECTOR-ADMIN-remittance-modifyCashBreakdown', 'TREASURY.COLLECTOR_ADMIN', 'remittance', 'modifyCashBreakdown', 'Modify Remittance Cash Breakdown'
); 



-- ## 2020-06-11

update 
	af_control_detail aa, ( 
		select objid, issuedstartseries, issuedendseries, qtyissued 
		from af_control_detail 
		where txntype='sale' 
			and qtyissued > 0 
	) bb  
set 
	aa.receivedstartseries = bb.issuedstartseries, aa.receivedendseries = bb.issuedendseries, aa.qtyreceived = bb.qtyissued, 
	aa.beginstartseries = null, aa.beginendseries = null, aa.qtybegin = 0 
where aa.objid = bb.objid 
; 


update 
	af_control aa, ( 
		select a.objid 
		from af_control a 
		where a.objid not in (
			select distinct controlid from af_control_detail where controlid = a.objid
		) 
	)bb 
set aa.currentdetailid = null, aa.currentindexno = 0 
where aa.objid = bb.objid 
; 


update 
	af_control aa, ( 
		select d.controlid 
		from af_control_detail d, af_control a 
		where d.txntype = 'SALE' 
			and d.controlid = a.objid 
			and a.currentseries <= a.endseries 
	)bb 
set aa.currentseries = aa.endseries+1 
where aa.objid = bb.controlid 
; 


update af_control set 
	currentindexno = (select indexno from af_control_detail where objid = af_control.currentdetailid)
where currentdetailid is not null 
; 


insert into sys_usergroup_permission (
	objid, usergroup_objid, object, permission, title 
) values ( 
	'TREASURY-COLLECTOR-ADMIN-remittance-voidReceipt', 'TREASURY.COLLECTOR_ADMIN', 'remittance', 'voidReceipt', 'Void Receipt'
); 




-- ## 2020-06-12

insert into sys_usergroup (
	objid, title, domain, role, userclass
) values (
	'TREASURY.LIQ_OFFICER_ADMIN', 'TREASURY LIQ. OFFICER ADMIN', 
	'TREASURY', 'LIQ_OFFICER_ADMIN', 'usergroup' 
); 

insert into sys_usergroup_permission (
	objid, usergroup_objid, object, permission, title 
) values ( 
	'UGP-d2bb69a6769517e0c8e672fec41f5fd7', 'TREASURY.LIQ_OFFICER_ADMIN', 
	'collectionvoucher', 'changeLiqOfficer', 'Change Liquidating Officer'
); 

insert into sys_usergroup_permission (
	objid, usergroup_objid, object, permission, title 
) values ( 
	'UGP-3219ec222220f68d1f69d4d1d76021e0', 'TREASURY.LIQ_OFFICER_ADMIN', 
	'collectionvoucher', 'modifyCashBreakdown', 'Modify Cash Breakdown'
); 

insert into sys_usergroup_permission (
	objid, usergroup_objid, object, permission, title 
) values ( 
	'UGP-4e508bdd04888894926f677bbc0be374', 'TREASURY.LIQ_OFFICER_ADMIN', 
	'collectionvoucher', 'rebuildFund', 'Rebuild Fund Summary'
); 

insert into sys_usergroup_permission (
	objid, usergroup_objid, object, permission, title 
) values ( 
	'UGP-cf543fabc2aca483c6e5d3d48c39c4cc', 'TREASURY.LIQ_OFFICER_ADMIN', 
	'incomesummary', 'rebuild', 'Rebuild Income Summary'
); 


INSERT INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) 
VALUES ('RULEMGMT.DEV', 'RULEMGMT DEV', 'RULEMGMT', NULL, NULL, 'DEV');

INSERT INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) 
VALUES ('WORKFLOW.DEV', 'WORKFLOW DEV', 'WORKFLOW', NULL, NULL, 'DEV');




-- ## 2020-08-18
drop table if exists paymentorder_type
;
CREATE TABLE `paymentorder_type` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(150) NULL,
  `collectiontype_objid` varchar(50) NULL,
  `queuesection` varchar(50) NULL,
  `system` int(11) NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_paymentorder_type_collectiontype` (`collectiontype_objid`),
  CONSTRAINT `paymentorder_type_ibfk_1` FOREIGN KEY (`collectiontype_objid`) REFERENCES `collectiontype` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

drop table if exists paymentorder
;
CREATE TABLE `paymentorder` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NULL,
  `payer_objid` varchar(50) NULL,
  `payer_name` text,
  `paidby` text,
  `paidbyaddress` varchar(150) NULL,
  `particulars` text,
  `amount` decimal(16,2) NULL,
  `expirydate` date NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `info` text,
  `locationid` varchar(50) NULL,
  `origin` varchar(50) NULL,
  `issuedby_objid` varchar(50) NULL,
  `issuedby_name` varchar(150) NULL,
  `org_objid` varchar(50) NULL,
  `org_name` varchar(255) NULL,
  `items` text,
  `queueid` varchar(50) NULL,
  `paymentordertype_objid` varchar(50) NULL,
  `controlno` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_issuedby_name` (`issuedby_name`),
  KEY `ix_issuedby_objid` (`issuedby_objid`),
  KEY `ix_locationid` (`locationid`),
  KEY `ix_org_name` (`org_name`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_paymentordertype_objid` (`paymentordertype_objid`),
  CONSTRAINT `fk_paymentorder_paymentordertype_objid` FOREIGN KEY (`paymentordertype_objid`) REFERENCES `paymentorder_type` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

drop table if exists paymentorder_paid
;
CREATE TABLE `paymentorder_paid` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NULL,
  `payer_objid` varchar(50) NULL,
  `payer_name` text,
  `paidby` text,
  `paidbyaddress` varchar(150) NULL,
  `particulars` text,
  `amount` decimal(16,2) NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `info` text,
  `locationid` varchar(50) NULL,
  `origin` varchar(50) NULL,
  `issuedby_objid` varchar(50) NULL,
  `issuedby_name` varchar(150) NULL,
  `org_objid` varchar(50) NULL,
  `org_name` varchar(255) NULL,
  `items` text,
  `paymentordertype_objid` varchar(50) NULL,
  `controlno` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_issuedby_name` (`issuedby_name`),
  KEY `ix_issuedby_objid` (`issuedby_objid`),
  KEY `ix_locationid` (`locationid`),
  KEY `ix_org_name` (`org_name`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_paymentordertype_objid` (`paymentordertype_objid`),
  CONSTRAINT `fk_paymentorder_paid_paymentordertype_objid` FOREIGN KEY (`paymentordertype_objid`) REFERENCES `paymentorder_type` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;




-- ## 2020-10-13

update cashreceipt_plugin set `connection` = objid 
; 




-- ## 2020-11-06
create table sys_email_queue (
	`objid` varchar(50) not null, 
	`refid` varchar(50) not null, 
	`state` int not null, 
	`reportid` varchar(50) null, 
	`dtsent` datetime not null, 
	`to` varchar(255) not null, 
	`subject` varchar(255) not null, 
	`message` text not null, 
	`errmsg` longtext null, 
	constraint pk_sys_email_queue primary key (objid) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 
create index ix_refid on sys_email_queue (refid)
; 
create index ix_state on sys_email_queue (state)
; 
create index ix_reportid on sys_email_queue (reportid)
; 
create index ix_dtsent on sys_email_queue (dtsent)
; 


alter table sys_email_queue add connection varchar(50) null 
;



CREATE TABLE `online_business_application` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(20) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `createdby_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(100) NOT NULL,
  `controlno` varchar(25) NOT NULL,
  `prevapplicationid` varchar(50) NOT NULL,
  `business_objid` varchar(50) NOT NULL,
  `appyear` int(11) NOT NULL,
  `apptype` varchar(20) NOT NULL,
  `appdate` date NOT NULL,
  `lobs` text NOT NULL,
  `infos` longtext NOT NULL,
  `requirements` longtext NOT NULL,
  `step` int(11) NOT NULL DEFAULT '0',
  `dtapproved` datetime DEFAULT NULL,
  `approvedby_objid` varchar(50) DEFAULT NULL,
  `approvedby_name` varchar(150) DEFAULT NULL,
  `approvedappno` varchar(25) DEFAULT NULL,
  constraint pk_online_business_application PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_state` on online_business_application (`state`)
;
create index `ix_dtcreated` on online_business_application (`dtcreated`)
;
create index `ix_controlno` on online_business_application (`controlno`)
;
create index `ix_prevapplicationid` on online_business_application (`prevapplicationid`)
;
create index `ix_business_objid` on online_business_application (`business_objid`)
;
create index `ix_appyear` on online_business_application (`appyear`)
;
create index `ix_appdate` on online_business_application (`appdate`)
;
create index `ix_dtapproved` on online_business_application (`dtapproved`)
;
create index `ix_approvedby_objid` on online_business_application (`approvedby_objid`)
;
create index `ix_approvedby_name` on online_business_application (`approvedby_name`)
;
alter table online_business_application add CONSTRAINT `fk_online_business_application_business_objid` 
	FOREIGN KEY (`business_objid`) REFERENCES `business` (`objid`)
;
alter table online_business_application add CONSTRAINT `fk_online_business_application_prevapplicationid` 
	FOREIGN KEY (`prevapplicationid`) REFERENCES `business_application` (`objid`)
;




-- ## 2020-12-22
alter table online_business_application add (
	contact_name varchar(255) not null, 
	contact_address varchar(255) not null, 
	contact_email varchar(255) not null, 
	contact_mobileno varchar(15) null 
)
;




-- ## 2020-12-23
alter table business_recurringfee add txntype_objid varchar(50) null 
; 
create index ix_txntype_objid on business_recurringfee  (txntype_objid)
; 
alter table business_recurringfee add constraint fk_business_recurringfee_txntype_objid 
  foreign key (txntype_objid) references business_billitem_txntype (objid)
; 




-- ## 2020-12-24
create table ztmp_fix_business_billitem_txntype 
select 'BPLS' as domain, 'OBO' as role, t1.*, 
	(select title from itemaccount where objid = t1.acctid) as title, 
	(
		select r.taxfeetype 
		from business_receivable r, business_application a 
		where r.account_objid = t1.acctid 
			and a.objid = r.applicationid 
		order by a.txndate desc limit 1 
	) as feetype 
from ( select distinct account_objid as acctid from business_recurringfee )t1 
where t1.acctid not in ( 
	select acctid from business_billitem_txntype where acctid = t1.acctid 
) 
;

insert into business_billitem_txntype (
	objid, title, acctid, feetype, domain, role
) 
select 
	acctid, title, acctid, feetype, domain, role
from ztmp_fix_business_billitem_txntype
;

update business_recurringfee aa set 
	aa.txntype_objid = (
		select objid from business_billitem_txntype 
		where acctid = aa.account_objid 
		limit 1
	) 
where aa.txntype_objid is null 
; 

drop table if exists ztmp_fix_business_billitem_txntype
;



alter table online_business_application add partnername varchar(50) not null 
;




-- ## 2021-01-05
drop view if exists vw_remittance_cashreceiptitem
;
create view vw_remittance_cashreceiptitem AS 
select 
  c.remittanceid AS remittanceid, 
  r.controldate AS remittance_controldate, 
  r.controlno AS remittance_controlno, 
  r.collectionvoucherid AS collectionvoucherid, 
  c.collectiontype_objid AS collectiontype_objid, 
  c.collectiontype_name AS collectiontype_name, 
  c.org_objid AS org_objid, 
  c.org_name AS org_name, 
  c.formtype AS formtype, 
  c.formno AS formno, 
  cri.receiptid AS receiptid, 
  c.receiptdate AS receiptdate, 
  c.receiptno AS receiptno, 
  c.controlid as controlid, 
  c.series as series, 
  c.stub as stubno, 
  c.paidby AS paidby, 
  c.paidbyaddress AS paidbyaddress, 
  c.collector_objid AS collectorid, 
  c.collector_name AS collectorname, 
  c.collector_title AS collectortitle, 
  cri.item_fund_objid AS fundid, 
  cri.item_objid AS acctid, 
  cri.item_code AS acctcode, 
  cri.item_title AS acctname, 
  cri.remarks AS remarks, 
  (case when v.objid is null then cri.amount else 0.0 end) AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else cri.amount end) AS voidamount,   
  (case when (c.formtype = 'serial') then 0 else 1 end) AS formtypeindex
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptitem cri on cri.receiptid = c.objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;


drop view if exists vw_collectionvoucher_cashreceiptitem
;
create view vw_collectionvoucher_cashreceiptitem AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.*  
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptitem v on v.collectionvoucherid = cv.objid 
;



drop view if exists vw_remittance_cashreceiptshare
;
create view vw_remittance_cashreceiptshare AS 
select 
	c.remittanceid AS remittanceid, 
	r.controldate AS remittance_controldate, 
	r.controlno AS remittance_controlno, 
	r.collectionvoucherid AS collectionvoucherid, 
	c.formno AS formno, 
	c.formtype AS formtype, 
  c.controlid as controlid, 
	cs.receiptid AS receiptid, 
	c.receiptdate AS receiptdate, 
	c.receiptno AS receiptno, 
	c.paidby AS paidby, 
	c.paidbyaddress AS paidbyaddress, 
	c.org_objid AS org_objid, 
	c.org_name AS org_name, 
	c.collectiontype_objid AS collectiontype_objid, 
	c.collectiontype_name AS collectiontype_name, 
	c.collector_objid AS collectorid, 
	c.collector_name AS collectorname, 
	c.collector_title AS collectortitle, 
	cs.refitem_objid AS refacctid, 
	ia.fund_objid AS fundid, 
	ia.objid AS acctid, 
	ia.code AS acctcode, 
	ia.title AS acctname, 
	(case when v.objid is null then cs.amount else 0.0 end) AS amount, 
	(case when v.objid is null then 0 else 1 end) AS voided, 
	(case when v.objid is null then 0.0 else cs.amount end) AS voidamount, 
	(case when (c.formtype = 'serial') then 0 else 1 end) AS formtypeindex  
from remittance r 
	inner join cashreceipt c on c.remittanceid = r.objid 
	inner join cashreceipt_share cs on cs.receiptid = c.objid 
	inner join itemaccount ia on ia.objid = cs.payableitem_objid 
	left join cashreceipt_void v on v.receiptid = c.objid 
; 


drop view if exists vw_collectionvoucher_cashreceiptshare
;
create view vw_collectionvoucher_cashreceiptshare AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.* 
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptshare v on v.collectionvoucherid = cv.objid 
; 



drop view if exists vw_remittance_cashreceiptpayment_noncash
; 
create view vw_remittance_cashreceiptpayment_noncash AS 
select 
  nc.objid AS objid, 
  nc.receiptid AS receiptid, 
  nc.refno AS refno, 
  nc.refdate AS refdate, 
  nc.reftype AS reftype, 
  nc.particulars AS particulars, 
  nc.fund_objid as fundid, 
  nc.refid AS refid, 
  nc.amount AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else nc.amount end) AS voidamount, 
  cp.bankid AS bankid, 
  cp.bank_name AS bank_name, 
  c.remittanceid AS remittanceid, 
  r.collectionvoucherid AS collectionvoucherid  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'CHECK') 
  inner join checkpayment cp on cp.objid = nc.refid 
  left join cashreceipt_void v on v.receiptid = c.objid 
union all 
select 
  nc.objid AS objid, 
  nc.receiptid AS receiptid, 
  nc.refno AS refno, 
  nc.refdate AS refdate, 
  'EFT' AS reftype, 
  nc.particulars AS particulars, 
  nc.fund_objid as fundid, 
  nc.refid AS refid, 
  nc.amount AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else nc.amount end) AS voidamount, 
  ba.bank_objid AS bankid, 
  ba.bank_name AS bank_name, 
  c.remittanceid AS remittanceid, 
  r.collectionvoucherid AS collectionvoucherid  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'EFT') 
  inner join eftpayment eft on eft.objid = nc.refid 
  inner join bankaccount ba on ba.objid = eft.bankacctid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;




-- ## 2021-01-08
INSERT INTO sys_ruleset (name, title, packagename, domain, role, permission) 
VALUES ('firebpassessment', 'Fire Assessment Rules', NULL, 'bpls', 'DATAMGMT', NULL);

INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) 
VALUES ('firefee', 'firebpassessment', 'Fire Fee Computation', '0');

INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) 
VALUES ('postfirefee', 'firebpassessment', 'Post Fire Fee Computation', '1');

insert into sys_ruleset_actiondef (
	ruleset, actiondef 
) 
select t1.* 
from ( 
	select 'firebpassessment' as ruleset, actiondef 
	from sys_ruleset_actiondef 
	where ruleset='bpassessment'
)t1 
	left join sys_ruleset_actiondef a on (a.ruleset = t1.ruleset and a.actiondef = t1.actiondef) 
where a.ruleset is null 
; 

insert into sys_ruleset_fact (
	ruleset, rulefact  
) 
select t1.* 
from ( 
	select 'firebpassessment' as ruleset, rulefact  
	from sys_ruleset_fact 
	where ruleset='bpassessment'
)t1 
	left join sys_ruleset_fact a on (a.ruleset = t1.ruleset and a.rulefact = t1.rulefact) 
where a.ruleset is null 
; 




CREATE TABLE `sys_domain` (
  `name` varchar(50) NOT NULL,
  `connection` varchar(50) NOT NULL,
  constraint pk_sys_domain PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;




-- ## 2021-01-11
alter table business add lockid varchar(50) null 
; 




-- ## 2021-01-16

INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) 
VALUES ('BPLS.ONLINE_DATA_APPROVER', 'BPLS - ONLINE DATA APPROVER', 'BPLS', 'usergroup', NULL, 'ONLINE_DATA_APPROVER')
;



DROP VIEW IF EXISTS vw_online_business_application 
;
CREATE VIEW vw_online_business_application AS 
select 
  oa.objid AS objid, 
  oa.state AS state, 
  oa.dtcreated AS dtcreated, 
  oa.createdby_objid AS createdby_objid, 
  oa.createdby_name AS createdby_name, 
  oa.controlno AS controlno, 
  oa.apptype AS apptype, 
  oa.appyear AS appyear, 
  oa.appdate AS appdate, 
  oa.prevapplicationid AS prevapplicationid, 
  oa.business_objid AS business_objid, 
  b.bin AS bin, 
  b.tradename AS tradename, 
  b.businessname AS businessname, 
  b.address_text AS address_text, 
  b.address_objid AS address_objid, 
  b.owner_name AS owner_name, 
  b.owner_address_text AS owner_address_text, 
  b.owner_address_objid AS owner_address_objid, 
  b.yearstarted AS yearstarted, 
  b.orgtype AS orgtype, 
  b.permittype AS permittype, 
  b.officetype AS officetype, 
  oa.step AS step 
from online_business_application oa 
  inner join business_application a on a.objid = oa.prevapplicationid 
  inner join business b on b.objid = a.business_objid
;




-- ## 2021-01-31

alter table cashreceipt_share add receiptitemid varchar(50) null 
;

create index ix_receiptitemid on cashreceipt_share (receiptitemid) 
; 
