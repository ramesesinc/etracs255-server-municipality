use etracs255_asuncion;


-- ## 2020-05-15

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
  (case when (c.formtype = 'serial') then 0 else 1 end) AS formtypeindex, 
  cri.receiptid AS receiptid, 
  c.receiptdate AS receiptdate, 
  c.receiptno AS receiptno, 
  c.controlid as controlid, 
  c.series as series, 
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
  (case when v.objid is null then 0.0 else cri.amount end) AS voidamount  
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
  v.remittanceid AS remittanceid, 
  v.remittance_controldate AS remittance_controldate, 
  v.remittance_controlno AS remittance_controlno, 
  v.collectionvoucherid AS collectionvoucherid, 
  v.collectiontype_objid AS collectiontype_objid, 
  v.collectiontype_name AS collectiontype_name, 
  v.org_objid AS org_objid, 
  v.org_name AS org_name, 
  v.formtype AS formtype, 
  v.formno AS formno, 
  v.formtypeindex AS formtypeindex, 
  v.receiptid AS receiptid, 
  v.receiptdate AS receiptdate, 
  v.receiptno AS receiptno, 
  v.controlid as controlid,
  v.series as series,
  v.paidby AS paidby, 
  v.paidbyaddress AS paidbyaddress, 
  v.collectorid AS collectorid, 
  v.collectorname AS collectorname, 
  v.collectortitle AS collectortitle, 
  v.fundid AS fundid, 
  v.acctid AS acctid, 
  v.acctcode AS acctcode, 
  v.acctname AS acctname, 
  v.amount AS amount, 
  v.voided AS voided, 
  v.voidamount AS voidamount, 
  v.remarks as remarks 
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptitem v on v.collectionvoucherid = cv.objid 
;



-- ## 2020-06-06

alter table aftxn add lockid varchar(50) null 
; 

alter table af_control modify `allocid` varchar(50) character set utf8 NULL
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


UPDATE sys_usergroup_member SET usergroup_objid = 'RULEMGMT.DEV' where usergroup_objid = 'RULEMGMT.MASTER' 
;
UPDATE sys_usergroup_member SET usergroup_objid = 'WORKFLOW.DEV' where usergroup_objid = 'WORKFLOW.MASTER' 
;



-- ## 2020-08-18

drop table if exists paymentorder_paid
;
drop table if exists paymentorder
;
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

CREATE TABLE `sys_domain` (
  `name` varchar(50) NOT NULL,
  `connection` varchar(50) NOT NULL,
  constraint pk_sys_domain PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
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



-- ## 2021-09-15

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
  c.series as series,
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



-- ## 2021-09-24

INSERT IGNORE INTO sys_var (name, value, description, datatype, category) 
VALUES ('CASHBOOK_CERTIFIED_BY_NAME', NULL, 'Cashbook Report Certified By Name', 'text', 'REPORT');

INSERT IGNORE INTO sys_var (name, value, description, datatype, category) 
VALUES ('CASHBOOK_CERTIFIED_BY_TITLE', NULL, 'Cashbook Report Certified By Title', 'text', 'REPORT');



-- ## 2021-09-27

DROP TABLE report_bpdelinquency_item;
DROP TABLE report_bpdelinquency;

CREATE TABLE `report_bpdelinquency` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NULL,
  `dtfiled` datetime NULL,
  `userid` varchar(50) NULL,
  `username` varchar(160) NULL,
  `totalcount` int(255) NULL,
  `processedcount` int(255) NULL,
  `billdate` date NULL,
  `duedate` date NULL,
  `lockid` varchar(50) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
CREATE INDEX `ix_state` ON report_bpdelinquency (`state`);
CREATE INDEX `ix_dtfiled` ON report_bpdelinquency (`dtfiled`);
CREATE INDEX `ix_userid` ON report_bpdelinquency (`userid`);
CREATE INDEX `ix_billdate` ON report_bpdelinquency (`billdate`);
CREATE INDEX `ix_duedate` ON report_bpdelinquency (`duedate`);


CREATE TABLE `report_bpdelinquency_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `applicationid` varchar(50) NOT NULL,
  `tax` decimal(16,2) NOT NULL DEFAULT '0',
  `regfee` decimal(16,2) NOT NULL DEFAULT '0',
  `othercharge` decimal(16,2) NOT NULL DEFAULT '0',
  `surcharge` decimal(16,2) NOT NULL DEFAULT '0',
  `interest` decimal(16,2) NOT NULL DEFAULT '0',
  `total` decimal(16,2) NOT NULL DEFAULT '0',
  `duedate` date NULL,
  `year` int NOT NULL,
  `qtr` int NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
CREATE INDEX `ix_parentid` ON report_bpdelinquency_item (`parentid`); 
CREATE INDEX `ix_applicationid` ON report_bpdelinquency_item (`applicationid`); 
CREATE INDEX `ix_year` ON report_bpdelinquency_item (`year`); 
CREATE INDEX `ix_qtr` ON report_bpdelinquency_item (`qtr`); 
ALTER TABLE report_bpdelinquency_item ADD CONSTRAINT fk_report_bpdelinquency_item_parentid
  FOREIGN KEY (parentid) REFERENCES report_bpdelinquency (objid) 
; 

CREATE TABLE `report_bpdelinquency_app` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `applicationid` varchar(50) NOT NULL,
  `appdate` date not null,
  `appyear` int not null,
  `lockid` varchar(50) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create unique index uix_parentid_applicationid on report_bpdelinquency_app (parentid, applicationid); 
CREATE INDEX `ix_parentid` ON report_bpdelinquency_app (`parentid`); 
CREATE INDEX `ix_applicationid` ON report_bpdelinquency_app (`applicationid`); 
CREATE INDEX `ix_appdate` ON report_bpdelinquency_app (`appdate`); 
CREATE INDEX `ix_appyear` ON report_bpdelinquency_app (`appyear`); 
CREATE INDEX `ix_lockid` ON report_bpdelinquency_app (`lockid`); 
ALTER TABLE report_bpdelinquency_app ADD CONSTRAINT fk_report_bpdelinquency_app_parentid
  FOREIGN KEY (parentid) REFERENCES report_bpdelinquency (objid) 
; 



-- ## 2021-10-01

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('cashbook_report_allow_multiple_fund_selection', '0', 'Cashbook Report: Allow Multiple Fund Selection', 'checkbox', 'TC');

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('liquidate_remittance_as_of_date', '1', 'Liquidate Remittances as of Date', 'checkbox', 'TC');

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('cashreceipt_reprint_requires_approval', 'false', 'CashReceipt Reprinting Requires Approval', 'checkbox', 'TC');

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('cashreceipt_void_requires_approval', 'true', 'CashReceipt Void Requires Approval', 'checkbox', 'TC');

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('deposit_collection_by_bank_account', '0', 'Deposit collection by bank account instead of by fund', 'checkbox', 'TC');



-- ## 2021-11-06

INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) 
VALUES ('TREASURY.MANAGER', 'TREASURY MANAGER', 'TREASURY', 'usergroup', NULL, 'MANAGER');

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('treasury_remote_orgs', '', NULL, 'text', 'TC');


update remittance_af raf, af_control_detail d set 
  raf.controlid = d.controlid, 
  raf.receivedstartseries = d.receivedstartseries, 
  raf.receivedendseries = d.receivedendseries, 
  raf.qtyreceived = d.qtyreceived, 
  raf.beginstartseries = d.beginstartseries, 
  raf.beginendseries = d.beginendseries, 
  raf.qtybegin = d.qtybegin, 
  raf.issuedstartseries = d.issuedstartseries, 
  raf.issuedendseries = d.issuedendseries, 
  raf.qtyissued = d.qtyissued, 
  raf.endingstartseries = d.endingstartseries, 
  raf.endingendseries = d.endingendseries, 
  raf.qtyending = d.qtyending, 
  raf.qtycancelled = d.qtycancelled, 
  raf.remarks = d.remarks 
where raf.objid = d.objid 
  and raf.controlid is null 
; 

create table ztmp_20220211_af_control_detail 
select 
  (select currentdetailid from af_control where objid = d.controlid) as currentdetailid, 
  d.* 
from af_control_detail d 
where d.reftype='remittance' and d.txntype = 'forward' 
; 
create table ztmp_20220211_af_control_for_update 
select distinct controlid 
from ztmp_20220211_af_control_detail
where objid = currentdetailid 
; 
update af_control set currentdetailid = null where objid in (
  select controlid from ztmp_20220211_af_control_for_update 
)
;
delete from af_control_detail where reftype='remittance' and txntype = 'forward' 
; 
update af_control set 
  currentdetailid = (
    select objid from af_control_detail 
    where controlid = af_control.objid 
    order by refdate desc, txndate desc, indexno desc 
    limit 1 
  )
where objid in (
  select controlid from ztmp_20220211_af_control_for_update 
)
;
update 
  af_control a, af_control_detail d, ztmp_20220211_af_control_for_update z 
set 
  a.currentindexno = d.indexno 
where a.objid = z.controlid 
  and d.objid = a.currentdetailid 
;
drop table ztmp_20220211_af_control_for_update
;
drop table ztmp_20220211_af_control_detail
;


insert into sys_usergroup_member (
  objid, usergroup_objid, user_objid, user_username, user_firstname, user_lastname 
) 
select * 
from ( 
  select 
    concat('UGM-',MD5(concat(u.objid, ug.objid))) as objid, 
    ug.objid as usergroup_objid, u.objid as user_objid, 
    u.username as user_username, u.firstname as user_firstname, u.lastname as user_lastname
  from sys_user u, sys_usergroup ug 
  where u.username='admin'
    and ug.domain='TREASURY' 
    and ug.objid in ('TREASURY.AFO_ADMIN','TREASURY.COLLECTOR_ADMIN','TREASURY.LIQ_OFFICER_ADMIN','TREASURY.MANAGER')
)t0 
where (
  select count(*) from sys_usergroup_member 
  where usergroup_objid = t0.usergroup_objid 
    and user_objid = t0.user_objid 
) = 0 
;



-- ## 2021-11-25

create table online_business_application_doc (
  objid varchar(50) not null, 
  parentid varchar(50) not null, 
  doc_type varchar(50) not null, 
  doc_title varchar(255) not null, 
  attachment_objid varchar(50) not null,
  attachment_name varchar(255) not null, 
  attachment_path varchar(255) not null,
  fs_filetype varchar(10) not null, 
  fs_filelocid varchar(50) null, 
  fs_fileid varchar(50) null, 
  lockid varchar(50) null, 
  constraint pk_online_business_application_doc PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index ix_parentid on online_business_application_doc (parentid)
;
create index ix_attachment_objid on online_business_application_doc (attachment_objid)
;
create index ix_fs_filelocid on online_business_application_doc (fs_filelocid)
;
create index ix_fs_fileid on online_business_application_doc (fs_fileid)
;
create index ix_lockid on online_business_application_doc (lockid)
;
alter table online_business_application_doc 
  add CONSTRAINT fk_online_business_application_doc_parentid 
  FOREIGN KEY (`parentid`) REFERENCES `online_business_application` (`objid`)
; 


CREATE TABLE `online_business_application_doc_fordownload` (
  `objid` varchar(50) NOT NULL,
  `scheduledate` datetime NOT NULL,
  `msg` text NULL,
  `filesize` int NOT NULL DEFAULT '0',
  `bytesprocessed` int NOT NULL DEFAULT '0',
  `lockid` varchar(50) NULL,
  constraint pk_online_business_application_doc_fordownload PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index ix_scheduledate on online_business_application_doc_fordownload (scheduledate)
;
create index ix_lockid on online_business_application_doc_fordownload (lockid)
;
alter table online_business_application_doc_fordownload 
  add CONSTRAINT `fk_online_business_application_doc_fordownload_objid` 
  FOREIGN KEY (`objid`) REFERENCES `online_business_application_doc` (`objid`)
; 



CREATE TABLE `sys_fileloc` (
  `objid` varchar(50) NOT NULL,
  `url` varchar(255) NOT NULL,
  `rootdir` varchar(255) NULL,
  `defaultloc` int NOT NULL,
  `loctype` varchar(20) NULL,
  `user_name` varchar(50) NULL,
  `user_pwd` varchar(50) NULL,
  `info` text,
  constraint pk_sys_fileloc PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_loctype` on sys_fileloc (`loctype`)
;

CREATE TABLE `sys_file` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(50) NULL,
  `filetype` varchar(50) NULL,
  `dtcreated` datetime NULL,
  `createdby_objid` varchar(50) NULL,
  `createdby_name` varchar(255) NULL,
  `keywords` varchar(255) NULL,
  `description` text,
  constraint pk_sys_file PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_dtcreated` on sys_file (`dtcreated`)
;
create index `ix_createdby_objid` on sys_file (`createdby_objid`)
;
create index `ix_keywords` on sys_file (`keywords`)
;
create index `ix_title` on sys_file (`title`)
;

CREATE TABLE `sys_fileitem` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NULL,
  `parentid` varchar(50) NULL,
  `dtcreated` datetime NULL,
  `createdby_objid` varchar(50) NULL,
  `createdby_name` varchar(255) NULL,
  `caption` varchar(155) NULL,
  `remarks` varchar(255) NULL,
  `filelocid` varchar(50) NULL,
  `filesize` int NULL,
  `thumbnail` text,
  constraint pk_sys_fileitem PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_parentid` on sys_fileitem (`parentid`)
;
create index `ix_filelocid` on sys_fileitem (`filelocid`)
;
alter table sys_fileitem 
  add CONSTRAINT `fk_sys_fileitem_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `sys_file` (`objid`)
;


alter table online_business_application_doc add `fs_state` varchar(20) NOT NULL
;

INSERT INTO sys_fileloc (objid, url, rootdir, defaultloc, loctype, user_name, user_pwd, info) 
VALUES ('bpls-fileserver', '127.0.0.1', NULL, '0', 'ftp', 'ftpuser', 'P@ssw0rd#', NULL);

INSERT INTO sys_fileloc (objid, url, rootdir, defaultloc, loctype, user_name, user_pwd, info) 
VALUES ('bpls-fileserver-pub', '127.0.0.1', NULL, '0', 'ftp', 'ftpuser', 'P@ssw0rd#', NULL);



-- ## 2021-11-26

CREATE TABLE `sys_email_template` (
  `objid` varchar(50) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

INSERT INTO `sys_email_template` (`objid`, `subject`, `message`) 
VALUES ('business_permit', 'Business Permit ${permitno}', 'Dear valued customer, <br><br>Please see attached Business Permit document. This is an electronic transaction. Please do not reply.');



-- ## 2022-01-17

update 
  business aa, 
  (
    select 
      b.objid, b.yearstarted as oldyearstarted, 
      min(a.yearstarted) as newyearstarted
    from business b, business_application a 
    where a.business_objid = b.objid 
    group by b.objid, b.yearstarted 
    having b.yearstarted <> min(a.yearstarted)
  )bb 
set 
  aa.yearstarted = bb.newyearstarted 
where 
  aa.objid = bb.objid 
; 

update 
  business_application a, 
  business b 
set 
  a.yearstarted = b.yearstarted 
where 
  a.business_objid = b.objid and 
  a.yearstarted <> b.yearstarted 
; 



-- ## 2022-03-07

delete from sys_wf_transition where processname = 'business_application' and parentid = 'approval' and action = 'submit' 
;

insert into sys_wf_transition (
  parentid, processname, action, `to`, idx, eval, properties, permission, caption, ui
) 
values (
  'approval', 'business_application', 'submit', 'payment', '0', NULL, 
  '[\r\n  caption:\"Approve For Payment\",\r\n  icon:\"approve\",\r\n  confirm: ''You are about to submit this for payment. Proceed?'', \r\n  depends: ''currentSection'', \r\n  visibleWhen: ''#{(has_loaded_assessment == true && entity.totals.total > 0)}''\r\n]', NULL, NULL, NULL
)

;
insert into sys_wf_transition (
  parentid, processname, action, `to`, idx, eval, properties, permission, caption, ui
) 
values (
  'approval', 'business_application', 'submit', 'release', '0', NULL, 
  '[\r\n  caption:\"Approve For Release\",\r\n  icon:\"approve\",\r\n  confirm: ''You are about to submit this for release. Proceed?'', \r\n  depends: ''currentSection'', \r\n  visibleWhen: ''#{(has_loaded_assessment == true && entity.totals.total == 0)}''\r\n]', NULL, NULL, NULL
)
;



-- ## 2022-04-07

insert into sys_rule_fact_field (
  objid, parentid, name, title, sortorder, `handler`, datatype, vardatatype 
) 
select 
  concat(f.objid, '.year') as objid, f.objid as parentid, 'year' as name, 'Year' as title, 
  4 as sortorder, 'integer' as `handler`, 'integer' as datatype, 'integer' as vardatatype 
from sys_rule_fact f 
  left join sys_rule_fact_field ff on (ff.parentid = f.objid and ff.name = 'year') 
where f.factclass = 'bpls.facts.BillItem'
  and ff.objid is null 
; 



-- ## 2022-04-11

INSERT INTO sys_rule_fact (objid, name, title, factclass, sortorder, handler, defaultvarname, dynamic, lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.LGUBarangay', 'treasury.facts.LGUBarangay', 'LGU Barangay', 'treasury.facts.LGUBarangay', '100', NULL, 'BRGY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', 'enterprise.facts.Org');
INSERT INTO sys_rule_fact (objid, name, title, factclass, sortorder, handler, defaultvarname, dynamic, lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.LGUMunicipality', 'treasury.facts.LGUMunicipality', 'LGU Municipality', 'treasury.facts.LGUMunicipality', '100', NULL, 'MUNI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', 'enterprise.facts.Org');
INSERT INTO sys_rule_fact (objid, name, title, factclass, sortorder, handler, defaultvarname, dynamic, lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.LGUProvince', 'treasury.facts.LGUProvince', 'LGU Province', 'treasury.facts.LGUProvince', '100', NULL, 'PROV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', 'enterprise.facts.Org');

INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUBarangay.orgid', 'treasury.facts.LGUBarangay', 'orgid', 'Org ID', 'string', '1', 'lookup', 'org:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUBarangay.orgclass', 'treasury.facts.LGUBarangay', 'orgclass', 'Org Class', 'string', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUBarangay.root', 'treasury.facts.LGUBarangay', 'root', 'Is Root Org?', 'boolean', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUMunicipality.orgid', 'treasury.facts.LGUMunicipality', 'orgid', 'Org ID', 'string', '1', 'lookup', 'org:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUMunicipality.orgclass', 'treasury.facts.LGUMunicipality', 'orgclass', 'Org Class', 'string', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUMunicipality.root', 'treasury.facts.LGUMunicipality', 'root', 'Is Root Org?', 'boolean', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUProvince.orgid', 'treasury.facts.LGUProvince', 'orgid', 'Org ID', 'string', '1', 'lookup', 'org:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUProvince.orgclass', 'treasury.facts.LGUProvince', 'orgclass', 'Org Class', 'string', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.LGUProvince.root', 'treasury.facts.LGUProvince', 'root', 'Is Root Org?', 'boolean', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);

INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.LGUBarangay');
INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.LGUMunicipality');
INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.LGUProvince');


INSERT INTO sys_rule_fact (objid, name, title, factclass, sortorder, handler, defaultvarname, dynamic, lookuphandler, lookupkey, lookupvalue, lookupdatatype, dynamicfieldname, builtinconstraints, domain, factsuperclass) VALUES ('treasury.facts.CollectionType', 'treasury.facts.CollectionType', 'Collection Type', 'treasury.facts.CollectionType', '0', NULL, 'CT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', NULL);

INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.CollectionType.objid', 'treasury.facts.CollectionType', 'objid', 'ID', 'string', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.CollectionType.name', 'treasury.facts.CollectionType', 'name', 'Name', 'string', '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO sys_rule_fact_field (objid, parentid, name, title, datatype, sortorder, handler, lookuphandler, lookupkey, lookupvalue, lookupdatatype, multivalued, required, vardatatype, lovname) VALUES ('treasury.facts.CollectionType.handler', 'treasury.facts.CollectionType', 'handler', 'Handler', 'string', '2', 'lookup', 'collectiontype_handler:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);

INSERT INTO sys_ruleset_fact (ruleset, rulefact) VALUES ('revenuesharing', 'treasury.facts.CollectionType');



-- ## 2022-04-15

drop view if exists vw_cashbook_cashreceipt
; 
CREATE VIEW vw_cashbook_cashreceipt AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno,
  'cashreceipt' AS reftype, 
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ci.item_fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  ci.amount as dr, null as cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid
  inner join cashreceiptitem ci on ci.receiptid = c.objid
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceipt_share
; 
CREATE VIEW vw_cashbook_cashreceipt_share AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt' AS reftype, 
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  -cs.amount AS dr, null AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  cs.refitem_objid AS refitemid, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted   
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.refitem_objid 
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceipt_share_payable
; 
CREATE VIEW vw_cashbook_cashreceipt_share_payable AS 
select  
  c.objid AS objid, 
  c.state as state,
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt' AS reftype, 
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  cs.amount AS dr, null AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  cs.payableitem_objid AS payableitemid, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted   
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid  
  left join remittance r on r.objid = c.remittanceid 
;


drop view if exists vw_cashbook_cashreceiptvoid
; 
CREATE VIEW vw_cashbook_cashreceiptvoid AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ci.item_fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  (case 
    when r.objid is null then -ci.amount
    when v.txndate <= IFNULL(r.dtposted, v.txndate) then -ci.amount
    when v.txndate > IFNULL(r.dtposted, v.txndate) and c.receiptdate < cast(v.txndate as date) then -ci.amount
  end) as dr,  
  (case 
    when r.objid is null then null 
    when v.txndate > IFNULL(r.dtposted, v.txndate) then -ci.amount
  end) as cr,  
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate, 
  c.receiptdate, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceiptitem ci on ci.receiptid = c.objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceiptvoid_share
; 
CREATE VIEW vw_cashbook_cashreceiptvoid_share AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  (case 
    when r.objid is null then cs.amount
    when v.txndate <= IFNULL(r.dtposted, v.txndate) then cs.amount
    when v.txndate > IFNULL(r.dtposted, v.txndate) and c.receiptdate < cast(v.txndate as date) then cs.amount
  end) as dr,  
  (case 
    when r.objid is null then null 
    when v.txndate > IFNULL(r.dtposted, v.txndate) then cs.amount
  end) as cr,  
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate, 
  c.receiptdate, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.refitem_objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;

drop view if exists vw_cashbook_cashreceiptvoid_share_payable
; 
CREATE VIEW vw_cashbook_cashreceiptvoid_share_payable AS 
select  
  v.objid AS objid, 
  c.state as state,
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  (case 
    when r.objid is null then -cs.amount
    when v.txndate <= IFNULL(r.dtposted, v.txndate) then -cs.amount
    when v.txndate > IFNULL(r.dtposted, v.txndate) and c.receiptdate < cast(v.txndate as date) then -cs.amount
  end) as dr,  
  (case 
    when r.objid is null then null 
    when v.txndate > IFNULL(r.dtposted, v.txndate) then -cs.amount
  end) as cr,  
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate, 
  c.receiptdate, 
  c.remittanceid, 
  r.controldate as remittancedate, 
  r.dtposted as remittancedtposted 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;


drop view if exists vw_cashbook_remittance
;
CREATE VIEW vw_cashbook_remittance AS 
select  
  r.objid AS objid, 
  r.state as state,
  r.dtposted AS txndate, 
  r.controldate AS refdate, 
  r.objid AS refid, 
  r.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  ci.item_fund_objid AS fundid, 
  r.collector_objid AS collectorid, 
  null as dr, 
  (case 
    when v.objid is null then ci.amount 
    when r.dtposted < IFNULL(v.txndate, r.dtposted) then ci.amount
    else null 
  end) as cr,  
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series, 
  NULL AS controlid, 
  r.dtposted AS sortdate, 
  r.liquidatingofficer_objid, 
  r.liquidatingofficer_name, 
  v.objid as voidid, 
  v.txndate as voiddate 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptitem ci on ci.receiptid = c.objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;

drop view if exists vw_cashbook_remittance_share
;
CREATE VIEW vw_cashbook_remittance_share AS 
select  
  r.objid AS objid, 
  r.state as state,
  r.dtposted AS txndate, 
  r.controldate AS refdate, 
  r.objid AS refid, 
  r.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  ia.fund_objid AS fundid, 
  r.collector_objid AS collectorid, 
  null as dr, 
  (case 
    when v.objid is null then -cs.amount 
    when r.dtposted < IFNULL(v.txndate, r.dtposted) then -cs.amount 
    else null 
  end) as cr, 
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series,
  NULL AS controlid, 
  r.dtposted AS sortdate, 
  r.liquidatingofficer_objid, 
  r.liquidatingofficer_name,   
  v.objid as voidid, 
  v.txndate as voiddate 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.refitem_objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;

drop view if exists vw_cashbook_remittance_share_payable
;
CREATE VIEW vw_cashbook_remittance_share_payable AS 
select  
  r.objid AS objid, 
  r.state as state,
  r.dtposted AS txndate, 
  r.controldate AS refdate, 
  r.objid AS refid, 
  r.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  ia.fund_objid AS fundid, 
  r.collector_objid AS collectorid, 
  null as dr, 
  (case 
    when v.objid is null then cs.amount 
    when r.dtposted < IFNULL(v.txndate, r.dtposted) then cs.amount 
    else null 
  end) as cr, 
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series,
  NULL AS controlid, 
  r.dtposted AS sortdate, 
  r.liquidatingofficer_objid, 
  r.liquidatingofficer_name,   
  v.objid as voidid, 
  v.txndate as voiddate 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid
  left join cashreceipt_void v on v.receiptid = c.objid 
;
