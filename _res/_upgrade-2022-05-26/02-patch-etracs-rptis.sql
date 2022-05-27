/* 03018 */


/*================================================= 
*
*  PROVINCE-MUNI LEDGER SYNCHRONIZATION SUPPORT 
*
====================================================*/
CREATE TABLE `rptledger_remote` (
  `objid` varchar(50) NOT NULL,
  `remote_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `createdby_title` varchar(100) DEFAULT NULL,
  `dtcreated` datetime NOT NULL,
  PRIMARY KEY (`objid`),
  CONSTRAINT `FK_rptledgerremote_rptledger` FOREIGN KEY (`objid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



/*======================================
* AUTOMATIC MACH AV RECALC SUPPORT
=======================================*/
INSERT INTO `rptparameter` (`objid`, `state`, `name`, `caption`, `description`, `paramtype`, `minvalue`, `maxvalue`) 
VALUES ('TOTAL_VALUE', 'APPROVED', 'TOTAL_VALUE', 'TOTAL VALUE', '', 'decimal', '0', '0');




/* BATCH GR ADDITIONAL SUPPORT */
alter table batchgr_items_forrevision add section varchar(3);
alter table batchgr_items_forrevision add classification_objid varchar(50);


/* 254032-03018 */

alter table faasbacktax modify column tdno varchar(25) null;



/*===============================================================
* REALTY TAX ACCOUNT MAPPING  UPDATE 
*==============================================================*/

CREATE TABLE `landtax_lgu_account_mapping` (
  `objid` varchar(50) NOT NULL,
  `lgu_objid` varchar(50) NOT NULL,
  `revtype` varchar(50) NOT NULL,
  `revperiod` varchar(50) NOT NULL,
  `item_objid` varchar(50) NOT NULL,
  KEY `FK_landtaxlguaccountmapping_sysorg` (`lgu_objid`),
  KEY `FK_landtaxlguaccountmapping_itemaccount` (`item_objid`),
  KEY `ix_revtype` (`revtype`),
  KEY `ix_objid` (`objid`),
  CONSTRAINT `fk_landtaxlguaccountmapping_itemaccount` FOREIGN KEY (`item_objid`) REFERENCES `itemaccount` (`objid`),
  CONSTRAINT `fk_landtaxlguaccountmapping_sysorg` FOREIGN KEY (`lgu_objid`) REFERENCES `sys_org` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



 
delete from sys_rulegroup where ruleset = 'rptbilling' and name in ('BEFORE-MISC-COMP','MISC-COMP');





/*======================================================
* RPTLEDGER PAYMENT
*=====================================================*/ 
drop table if exists cashreceiptitem_rpt_noledger;
drop table if exists cashreceiptitem_rpt;
drop table if exists rptledger_payment_share; 
drop table if exists rptledger_payment_item; 
drop table if exists rptledger_payment;


CREATE TABLE `rptledger_payment` (
  `objid` varchar(100) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `type` varchar(20) NOT NULL,
  `receiptid` varchar(50) NULL,
  `receiptno` varchar(50) NOT NULL,
  `receiptdate` date NOT NULL,
  `paidby_name` longtext NOT NULL,
  `paidby_address` varchar(150) NOT NULL,
  `postedby` varchar(100) NOT NULL,
  `postedbytitle` varchar(50) NOT NULL,
  `dtposted` datetime NOT NULL,
  `fromyear` int(11) NOT NULL,
  `fromqtr` int(11) NOT NULL,
  `toyear` int(11) NOT NULL,
  `toqtr` int(11) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `collectingagency` varchar(50) DEFAULT NULL,
  `voided` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `fk_rptledger_payment_rptledger` on rptledger_payment(`rptledgerid`) using btree;
create index `fk_rptledger_payment_cashreceipt` on rptledger_payment(`receiptid`) using btree;
create index `ix_receiptno` on rptledger_payment(`receiptno`) using btree;

alter table rptledger_payment 
add constraint `fk_rptledger_payment_cashreceipt` foreign key (`receiptid`) references `cashreceipt` (`objid`);

alter table rptledger_payment 
add constraint `fk_rptledger_payment_rptledger` foreign key (`rptledgerid`) references `rptledger` (`objid`);


CREATE TABLE `rptledger_payment_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(100) NOT NULL,
  `rptledgerfaasid` varchar(50) DEFAULT NULL,
  `rptledgeritemid` varchar(50) DEFAULT NULL,
  `rptledgeritemqtrlyid` varchar(50) DEFAULT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) NOT NULL,
  `basic` decimal(16,2) NOT NULL,
  `basicint` decimal(16,2) NOT NULL,
  `basicdisc` decimal(16,2) NOT NULL,
  `basicidle` decimal(16,2) NOT NULL,
  `basicidledisc` decimal(16,2) DEFAULT NULL,
  `basicidleint` decimal(16,2) DEFAULT NULL,
  `sef` decimal(16,2) NOT NULL,
  `sefint` decimal(16,2) NOT NULL,
  `sefdisc` decimal(16,2) NOT NULL,
  `firecode` decimal(10,2) DEFAULT NULL,
  `sh` decimal(16,2) NOT NULL,
  `shint` decimal(16,2) NOT NULL,
  `shdisc` decimal(16,2) NOT NULL,
  `total` decimal(16,2) DEFAULT NULL,
  `revperiod` varchar(25) DEFAULT NULL,
  `partialled` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `FK_rptledger_payment_item_parentid` on rptledger_payment_item(`parentid`) using btree;
create index `FK_rptledger_payment_item_rptledgerfaasid` on rptledger_payment_item(`rptledgerfaasid`) using btree;
create index `ix_rptledgeritemid` on rptledger_payment_item(`rptledgeritemid`) using btree;
create index `ix_rptledgeritemqtrlyid` on rptledger_payment_item(`rptledgeritemqtrlyid`) using btree;


alter table rptledger_payment_item 
  add constraint `fk_rptledger_payment_item_parentid` 
  foreign key (`parentid`) references `rptledger_payment` (`objid`);
alter table rptledger_payment_item 
  add constraint `fk_rptledger_payment_item_rptledgerfaasid` 
  foreign key (`rptledgerfaasid`) references `rptledgerfaas` (`objid`);


create table rptledger_payment_share (
  objid varchar(50) not null,
  parentid varchar(100) null,
  revperiod varchar(25) not null,
  revtype varchar(25) not null,
  item_objid varchar(50) not null,
  amount decimal(16,4) not null,
  sharetype varchar(25) not null,
  discount decimal(16,4) null,
  primary key (objid)
) engine=innodb charset=utf8;

alter table rptledger_payment_share
  add constraint FK_rptledger_payment_share_parentid foreign key (parentid) 
  references rptledger_payment(objid);

alter table rptledger_payment_share
  add constraint FK_rptledger_payment_share_itemaccount foreign key (item_objid) 
  references itemaccount(objid);

create index FK_parentid on rptledger_payment_share(parentid) using btree;
create index FK_item_objid on rptledger_payment_share(item_objid) using btree;



insert into rptledger_payment(
  objid,
  rptledgerid,
  type,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided 
)
select 
  x.objid,
  x.rptledgerid,
  x.type,
  x.receiptid,
  x.receiptno,
  x.receiptdate,
  x.paidby_name,
  x.paidby_address,
  x.postedby,
  x.postedbytitle,
  x.dtposted,
  x.fromyear,
  (select min(qtr) from cashreceiptitem_rpt_online 
    where rptledgerid = x.rptledgerid and rptreceiptid = x.receiptid and year = x.fromyear) as fromqtr,
  x.toyear,
  (select max(qtr) from cashreceiptitem_rpt_online 
    where rptledgerid = x.rptledgerid and rptreceiptid = x.receiptid and year = x.toyear) as toqtr,
  x.amount,
  x.collectingagency,
  0 as voided
from (
  select
    concat(cro.rptledgerid, '-', cr.objid) as objid,
    cro.rptledgerid,
    cr.txntype as type,
    cr.objid as receiptid,
    c.receiptno as receiptno,
    c.receiptdate as receiptdate,
    c.paidby as paidby_name,
    c.paidbyaddress as paidby_address,
    c.collector_name as postedby,
    c.collector_title as postedbytitle,
    c.txndate as dtposted,
    min(cro.year) as fromyear,
    max(cro.year) as toyear,
    sum(
      cro.basic + cro.basicint - cro.basicdisc + cro.sef + cro.sefint - cro.sefdisc + cro.firecode +
      cro.basicidle + cro.basicidleint - cro.basicidledisc
    ) as amount,
    null as collectingagency
  from cashreceipt_rpt cr 
  inner join cashreceipt c on cr.objid = c.objid 
  inner join cashreceiptitem_rpt_online cro on c.objid = cro.rptreceiptid
  left join cashreceipt_void cv on c.objid = cv.receiptid 
  where cv.objid is null 
  group by 
    cr.objid,
    cro.rptledgerid,
    cr.txntype,
    c.receiptno,
    c.receiptdate,
    c.paidby,
    c.paidbyaddress,
    c.collector_name,
    c.collector_title,
    c.txndate 
)x;


insert into rptledger_payment_item(
  objid,
  parentid,
  rptledgerfaasid,
  rptledgeritemid,
  rptledgeritemqtrlyid,
  year,
  qtr,
  basic,
  basicint,
  basicdisc,
  basicidle,
  basicidledisc,
  basicidleint,
  sef,
  sefint,
  sefdisc,
  firecode,
  sh,
  shint,
  shdisc,
  total,
  revperiod,
  partialled
)
select
  cro.objid,
  concat(cro.rptledgerid, '-', cro.rptreceiptid) as parentid,
  cro.rptledgerfaasid,
  cro.rptledgeritemid,
  cro.rptledgeritemqtrlyid,
  cro.year,
  cro.qtr,
  cro.basic,
  cro.basicint,
  cro.basicdisc,
  cro.basicidle,
  cro.basicidledisc,
  cro.basicidleint,
  cro.sef,
  cro.sefint,
  cro.sefdisc,
  cro.firecode,
  0 as sh,
  0 as shint,
  0 as shdisc,
  cro.total,
  cro.revperiod,
  cro.partialled
from cashreceipt_rpt cr 
inner join cashreceipt c on cr.objid = c.objid 
inner join cashreceiptitem_rpt_online cro on c.objid = cro.rptreceiptid 
left join cashreceipt_void cv on c.objid = cv.receiptid 
where cv.objid is null ;



insert into rptledger_payment_share(
  objid,
  parentid,
  revperiod,
  revtype,
  item_objid,
  amount,
  sharetype,
  discount
)
select 
  x.objid,
  x.parentid,
  x.revperiod,
  x.revtype,
  x.item_objid,
  x.amount,
  x.sharetype,
  x.discount
from (
  select
    cra.objid,
    concat(cra.rptledgerid, '-', cra.rptreceiptid) as parentid,
    cra.revperiod,
    cra.revtype,
    cra.item_objid,
    cra.amount,
    cra.sharetype,
    cra.discount
  from cashreceipt_rpt cr 
  inner join cashreceipt c on cr.objid = c.objid 
  inner join cashreceiptitem_rpt_account cra on c.objid = cra.rptreceiptid 
  left join cashreceipt_void cv on c.objid = cv.receiptid 
  where cv.objid is null 
    and cra.rptledgerid is not null 
    and exists(select * from rptledger where objid = cra.rptledgerid)
    and not exists(select * from rptledger_payment_share where objid = cra.objid)
) x 
where exists(select * from rptledger_payment where objid= x.parentid);


insert into rptledger_payment(
  objid,
  rptledgerid,
  type,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided 
)
select 
  objid,
  rptledgerid,
  type,
  null as receiptid,
  refno as receiptno,
  refdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  (basic + basicint - basicdisc + sef + sefint - sefdisc + basicidle + firecode) as amount,
  collectingagency,
  0 as voided 
from rptledger_credit;



alter table rptledgeritem 
  add sh decimal(16,2),
  add shdisc decimal(16,2),
  add shpaid decimal(16,2),
  add shint decimal(16,2);

update rptledgeritem set 
    sh = 0, shdisc=0, shpaid = 0, shint = 0
where sh is null ;


alter table rptledgeritem_qtrly 
  add sh decimal(16,2),
  add shdisc decimal(16,2),
  add shpaid decimal(16,2),
  add shint decimal(16,2);

update rptledgeritem_qtrly set 
    sh = 0, shdisc = 0, shpaid = 0, shint = 0
where sh is null ;



alter table rptledger_compromise_item add sh decimal(16,2);
alter table rptledger_compromise_item add shpaid decimal(16,2);
alter table rptledger_compromise_item add shint decimal(16,2);
alter table rptledger_compromise_item add shintpaid decimal(16,2);

update rptledger_compromise_item set 
    sh = 0, shpaid = 0, shint = 0, shintpaid = 0
where sh is null ;


alter table rptledger_compromise_item_credit add sh decimal(16,2);
alter table rptledger_compromise_item_credit add shint decimal(16,2);

update rptledger_compromise_item_credit set 
    sh = 0, shint = 0
where sh is null ;


/* 254032-03019 */

/*==================================================
*
*  CDU RATING SUPPORT 
*
=====================================================*/

alter table bldgrpu add cdurating varchar(15);

alter table bldgtype add usecdu int;
update bldgtype set usecdu = 0 where usecdu is null;

alter table bldgtype_depreciation 
  add excellent decimal(16,2),
  add verygood decimal(16,2),
  add good decimal(16,2),
  add average decimal(16,2),
  add fair decimal(16,2),
  add poor decimal(16,2),
  add verypoor decimal(16,2),
  add unsound decimal(16,2);



alter table batchgr_error drop column barangayid;
alter table batchgr_error drop column barangay;
alter table batchgr_error drop column tdno;

drop table if exists vw_batchgr_error;
drop view if exists vw_batchgr_error;

create view vw_batchgr_error 
as 
select 
    err.*,
    f.tdno,
    f.prevtdno, 
    f.fullpin as fullpin, 
    rp.pin as pin,
    b.name as barangay,
    o.name as lguname
from batchgr_error err 
inner join faas f on err.objid = f.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
inner join barangay b on rp.barangayid = b.objid 
inner join sys_org o on f.lguid = o.objid;




/*=============================================================
*
* SKETCH 
*
==============================================================*/
CREATE TABLE `faas_sketch` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `drawing` text NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



create index FK_faas_sketch_faas  on faas_sketch(objid);

alter table faas_sketch 
  add constraint FK_faas_sketch_faas foreign key(objid) 
  references faas(objid);


  
/*=============================================================
*
* CUSTOM RPU SUFFIX SUPPORT
*
==============================================================*/  

CREATE TABLE `rpu_type_suffix` (
  `objid` varchar(50) NOT NULL,
  `rputype` varchar(20) NOT NULL,
  `from` int(11) NOT NULL,
  `to` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 



insert into rpu_type_suffix (
  objid, rputype, `from`, `to`
)
values('LAND', 'land', 0, 0),
('BLDG-1001-1999', 'bldg', 1001, 1999),
('MACH-2001-2999', 'mach', 2001, 2999),
('PLANTTREE-3001-6999', 'planttree', 3001, 6999),
('MISC-7001-7999', 'misc', 7001, 7999)
;



/*=============================================================
*
* MEMORANDA TEMPLATE UPDATE 
*
==============================================================*/  
alter table memoranda_template add fields text;

update memoranda_template set fields = '[]' where fields is null;
  


/* 254032-03019.01 */

/*==================================================
*
*  BATCH GR UPDATES
*
=====================================================*/
drop table batchgr_error;
drop table batchgr_items_forrevision;
drop table batchgr_log;
drop view vw_batchgr_error;

CREATE TABLE `batchgr` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `ry` int(255) NOT NULL,
  `lgu_objid` varchar(50) NOT NULL,
  `barangay_objid` varchar(50) NOT NULL,
  `rputype` varchar(15) DEFAULT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `section` varchar(10) DEFAULT NULL,
  `count` int(255) NOT NULL,
  `completed` int(255) NOT NULL,
  `error` int(255) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `ix_barangay_objid` on batchgr(`barangay_objid`);
create index `ix_state` on batchgr(`state`);
create index `fk_lgu_objid` on batchgr(`lgu_objid`);

alter table batchgr add constraint `fk_barangay_objid` 
  foreign key (`barangay_objid`) references `barangay` (`objid`);
  
alter table batchgr add constraint `fk_lgu_objid` 
  foreign key (`lgu_objid`) references `sys_org` (`objid`);



CREATE TABLE `batchgr_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `rputype` varchar(15) NOT NULL,
  `tdno` varchar(50) NOT NULL,
  `fullpin` varchar(50) NOT NULL,
  `pin` varchar(50) NOT NULL,
  `suffix` int(255) NOT NULL,
  `newfaasid` varchar(50) DEFAULT NULL,
  `error` text,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



create index `fk_batchgr_item_batchgr` on batchgr_item (`parent_objid`);
create index `fk_batchgr_item_newfaasid` on batchgr_item (`newfaasid`);
create index `fk_batchgr_item_tdno` on batchgr_item (`tdno`);
create index `fk_batchgr_item_pin` on batchgr_item (`pin`);


alter table batchgr_item add constraint `fk_batchgr_item_objid` 
	foreign key (`objid`) references `faas` (`objid`);

alter table batchgr_item add constraint `fk_batchgr_item_batchgr` 
	foreign key (`parent_objid`) references `batchgr` (`objid`);

alter table batchgr_item add constraint `fk_batchgr_item_newfaasid` 
	foreign key (`newfaasid`) references `faas` (`objid`);


CREATE TABLE `batchgr_forprocess` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `fk_batchgr_forprocess_parentid` on batchgr_forprocess(`parent_objid`);

alter table batchgr_forprocess add constraint `fk_batchgr_forprocess_parentid` 
	foreign key (`parent_objid`) references `batchgr` (`objid`);

alter table batchgr_forprocess add constraint `fk_batchgr_forprocess_objid` 
	foreign key (`objid`) references `batchgr_item` (`objid`);

	


/* 254032-03019.02 */

/*==============================================
* EXAMINATION UPDATES
==============================================*/

alter table examiner_finding 
	add inspectedby_objid varchar(50),
	add inspectedby_name varchar(100),
	add inspectedby_title varchar(50),
	add doctype varchar(50)
;

create index ix_examiner_finding_inspectedby_objid on examiner_finding(inspectedby_objid)
;


update examiner_finding e, faas f set 
	e.inspectedby_objid = (select assignee_objid from faas_task where refid = f.objid and state = 'examiner' order by enddate desc limit 1),
	e.inspectedby_name = e.notedby,
	e.inspectedby_title = e.notedbytitle,
	e.doctype = 'faas'
where e.parent_objid = f.objid
;

update examiner_finding e, subdivision s set 
	e.inspectedby_objid = (select assignee_objid from subdivision_task where refid = s.objid and state = 'examiner' order by enddate desc limit 1),
	e.inspectedby_name = e.notedby,
	e.inspectedby_title = e.notedbytitle,
	e.doctype = 'subdivision'
where e.parent_objid = s.objid
;

update examiner_finding e, consolidation c set 
	e.inspectedby_objid = (select assignee_objid from consolidation_task where refid = c.objid and state = 'examiner' order by enddate desc limit 1),
	e.inspectedby_name = e.notedby,
	e.inspectedby_title = e.notedbytitle,
	e.doctype = 'consolidation'
where e.parent_objid = c.objid
;

update examiner_finding e, cancelledfaas c set 
	e.inspectedby_objid = (select assignee_objid from cancelledfaas_task where refid = c.objid and state = 'examiner' order by enddate desc limit 1),
	e.inspectedby_name = e.notedby,
	e.inspectedby_title = e.notedbytitle,
	e.doctype = 'cancelledfaas'
where e.parent_objid = c.objid
;



/*======================================================
*
*  ASSESSMENT NOTICE 
*
======================================================*/
alter table assessmentnotice modify column dtdelivered date null
;
alter table assessmentnotice add deliverytype_objid varchar(50)
;
update assessmentnotice set state = 'DELIVERED' where state = 'RECEIVED'
;


drop view if exists vw_assessment_notice
;

create view vw_assessment_notice
as 
select 
	a.objid,
	a.state,
	a.txnno,
	a.txndate,
	a.taxpayerid,
	a.taxpayername,
	a.taxpayeraddress,
	a.dtdelivered,
	a.receivedby,
	a.remarks,
	a.assessmentyear,
	a.administrator_name,
	a.administrator_address,
	fl.tdno,
	fl.displaypin as fullpin,
	fl.cadastrallotno,
	fl.titleno
from assessmentnotice a 
inner join assessmentnoticeitem i on a.objid = i.assessmentnoticeid
inner join faas_list fl on i.faasid = fl.objid
;


drop view if exists vw_assessment_notice_item 
;

create view vw_assessment_notice_item 
as 
select 
	ni.objid,
	ni.assessmentnoticeid, 
	f.objid AS faasid,
	f.effectivityyear,
	f.effectivityqtr,
	f.tdno,
	f.taxpayer_objid,
	e.name as taxpayer_name,
	e.address_text as taxpayer_address,
	f.owner_name,
	f.owner_address,
	f.administrator_name,
	f.administrator_address,
	f.rpuid, 
	f.lguid,
	f.txntype_objid, 
	ft.displaycode as txntype_code,
	rpu.rputype,
	rpu.ry,
	rpu.fullpin ,
	rpu.taxable,
	rpu.totalareaha,
	rpu.totalareasqm,
	rpu.totalbmv,
	rpu.totalmv,
	rpu.totalav,
	rp.section,
	rp.parcel,
	rp.surveyno,
	rp.cadastrallotno,
	rp.blockno,
	rp.claimno,
	rp.street,
	o.name as lguname, 
	b.name AS barangay,
	pc.code AS classcode,
	pc.name as classification 
FROM assessmentnoticeitem ni 
	INNER JOIN faas f ON ni.faasid = f.objid 
	LEFT JOIN txnsignatory ts on ts.refid = f.objid and ts.type='APPROVER'
	INNER JOIN rpu rpu ON f.rpuid = rpu.objid
	INNER JOIN propertyclassification pc ON rpu.classification_objid = pc.objid
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid
	INNER JOIN barangay b ON rp.barangayid = b.objid 
	INNER JOIN sys_org o ON f.lguid = o.objid 
	INNER JOIN entity e on f.taxpayer_objid = e.objid 
	INNER JOIN faas_txntype ft on f.txntype_objid = ft.objid 
;



/*======================================================
*
*  TAX CLEARANCE UPDATE
*
======================================================*/

alter table rpttaxclearance add reporttype varchar(15)
;

update rpttaxclearance set reporttype = 'fullypaid' where reporttype is null
;




/*REVENUE PARENT ACCOUNTS  */

INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_ADVANCE', 'APPROVED', '588-007', 'RPT BASIC ADVANCE', 'RPT BASIC ADVANCE', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_CURRENT', 'APPROVED', '588-001', 'RPT BASIC CURRENT', 'RPT BASIC CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_CURRENT', 'APPROVED', '588-004', 'RPT BASIC PENALTY CURRENT', 'RPT BASIC PENALTY CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PREVIOUS', 'APPROVED', '588-002', 'RPT BASIC PREVIOUS', 'RPT BASIC PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PREVIOUS', 'APPROVED', '588-005', 'RPT BASIC PENALTY PREVIOUS', 'RPT BASIC PENALTY PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PRIOR', 'APPROVED', '588-003', 'RPT BASIC PRIOR', 'RPT BASIC PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PRIOR', 'APPROVED', '588-006', 'RPT BASIC PENALTY PRIOR', 'RPT BASIC PENALTY PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;

INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_ADVANCE', 'APPROVED', '455-050', 'RPT SEF ADVANCE', 'RPT SEF ADVANCE', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_CURRENT', 'APPROVED', '455-050', 'RPT SEF CURRENT', 'RPT SEF CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEFINT_CURRENT', 'APPROVED', '455-050', 'RPT SEF PENALTY CURRENT', 'RPT SEF PENALTY CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_PREVIOUS', 'APPROVED', '455-050', 'RPT SEF PREVIOUS', 'RPT SEF PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEFINT_PREVIOUS', 'APPROVED', '455-050', 'RPT SEF PENALTY PREVIOUS', 'RPT SEF PENALTY PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_PRIOR', 'APPROVED', '455-050', 'RPT SEF PRIOR', 'RPT SEF PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEFINT_PRIOR', 'APPROVED', '455-050', 'RPT SEF PENALTY PRIOR', 'RPT SEF PENALTY PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
;





insert into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE' as objid, 'RPT_BASIC_ADVANCE' as acctid, 'rpt_basic_advance' as tag
union 
select  'RPT_BASIC_CURRENT' as objid, 'RPT_BASIC_CURRENT' as acctid, 'rpt_basic_current' as tag
union 
select  'RPT_BASICINT_CURRENT' as objid, 'RPT_BASICINT_CURRENT' as acctid, 'rpt_basicint_current' as tag
union 
select  'RPT_BASIC_PREVIOUS' as objid, 'RPT_BASIC_PREVIOUS' as acctid, 'rpt_basic_previous' as tag
union 
select  'RPT_BASICINT_PREVIOUS' as objid, 'RPT_BASICINT_PREVIOUS' as acctid, 'rpt_basicint_previous' as tag
union 
select  'RPT_BASIC_PRIOR' as objid, 'RPT_BASIC_PRIOR' as acctid, 'rpt_basic_prior' as tag
union 
select  'RPT_BASICINT_PRIOR' as objid, 'RPT_BASICINT_PRIOR' as acctid, 'rpt_basicint_prior' as tag
union 
select  'RPT_SEF_ADVANCE' as objid, 'RPT_SEF_ADVANCE' as acctid, 'rpt_sef_advance' as tag
union 
select  'RPT_SEF_CURRENT' as objid, 'RPT_SEF_CURRENT' as acctid, 'rpt_sef_current' as tag
union 
select  'RPT_SEFINT_CURRENT' as objid, 'RPT_SEFINT_CURRENT' as acctid, 'rpt_sefint_current' as tag
union 
select  'RPT_SEF_PREVIOUS' as objid, 'RPT_SEF_PREVIOUS' as acctid, 'rpt_sef_previous' as tag
union 
select  'RPT_SEFINT_PREVIOUS' as objid, 'RPT_SEFINT_PREVIOUS' as acctid, 'rpt_sefint_previous' as tag
union 
select  'RPT_SEF_PRIOR' as objid, 'RPT_SEF_PRIOR' as acctid, 'rpt_sef_prior' as tag
union 
select  'RPT_SEFINT_PRIOR' as objid, 'RPT_SEFINT_PRIOR' as acctid, 'rpt_sefint_prior' as tag
;





/* BARANGAY SHARE PAYABLE */

INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC ADVANCE BARANGAY SHARE', 'RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC CURRENT BARANGAY SHARE', 'RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC PRIOR BARANGAY SHARE', 'RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE', 'APPROVED', '455-049', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
;



insert into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE_BRGY_SHARE' as objid, 'RPT_BASIC_ADVANCE_BRGY_SHARE' as acctid, 'rpt_basic_advance' as tag
union 
select  'RPT_BASIC_CURRENT_BRGY_SHARE' as objid, 'RPT_BASIC_CURRENT_BRGY_SHARE' as acctid, 'rpt_basic_current' as tag
union 
select  'RPT_BASICINT_CURRENT_BRGY_SHARE' as objid, 'RPT_BASICINT_CURRENT_BRGY_SHARE' as acctid, 'rpt_basicint_current' as tag
union 
select  'RPT_BASIC_PREVIOUS_BRGY_SHARE' as objid, 'RPT_BASIC_PREVIOUS_BRGY_SHARE' as acctid, 'rpt_basic_previous' as tag
union 
select  'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as objid, 'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as acctid, 'rpt_basicint_previous' as tag
union 
select  'RPT_BASIC_PRIOR_BRGY_SHARE' as objid, 'RPT_BASIC_PRIOR_BRGY_SHARE' as acctid, 'rpt_basic_prior' as tag
union 
select  'RPT_BASICINT_PRIOR_BRGY_SHARE' as objid, 'RPT_BASICINT_PRIOR_BRGY_SHARE' as acctid, 'rpt_basicint_prior' as tag
;






/* PROVINCE SHARE PAYABLE */

INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASIC_ADVANCE_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC ADVANCE PROVINCE SHARE', 'RPT BASIC ADVANCE PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASIC_CURRENT_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC CURRENT PROVINCE SHARE', 'RPT BASIC CURRENT PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASICINT_CURRENT_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASIC_PREVIOUS_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASIC_PRIOR_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC PRIOR PROVINCE SHARE', 'RPT BASIC PRIOR PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASICINT_PRIOR_PROVINCE_SHARE', 'APPROVED', '455-049', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL);

INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEF_ADVANCE_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF ADVANCE PROVINCE SHARE', 'RPT SEF ADVANCE PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEF_CURRENT_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF CURRENT PROVINCE SHARE', 'RPT SEF CURRENT PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEFINT_CURRENT_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEF_PREVIOUS_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF PREVIOUS PROVINCE SHARE', 'RPT SEF PREVIOUS PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEF_PRIOR_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF PRIOR PROVINCE SHARE', 'RPT SEF PRIOR PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEFINT_PRIOR_PROVINCE_SHARE', 'APPROVED', '455-050', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL);



insert into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE_PROVINCE_SHARE' as objid, 'RPT_BASIC_ADVANCE_PROVINCE_SHARE' as acctid, 'rpt_basic_advance' as tag
union 
select  'RPT_BASIC_CURRENT_PROVINCE_SHARE' as objid, 'RPT_BASIC_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_basic_current' as tag
union 
select  'RPT_BASICINT_CURRENT_PROVINCE_SHARE' as objid, 'RPT_BASICINT_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_basicint_current' as tag
union 
select  'RPT_BASIC_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_basic_previous' as tag
union 
select  'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_basicint_previous' as tag
union 
select  'RPT_BASIC_PRIOR_PROVINCE_SHARE' as objid, 'RPT_BASIC_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_basic_prior' as tag
union 
select  'RPT_BASICINT_PRIOR_PROVINCE_SHARE' as objid, 'RPT_BASICINT_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_basicint_prior' as tag
union 
select  'RPT_SEF_ADVANCE_PROVINCE_SHARE' as objid, 'RPT_SEF_ADVANCE_PROVINCE_SHARE' as acctid, 'rpt_sef_advance' as tag
union 
select  'RPT_SEF_CURRENT_PROVINCE_SHARE' as objid, 'RPT_SEF_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_sef_current' as tag
union 
select  'RPT_SEFINT_CURRENT_PROVINCE_SHARE' as objid, 'RPT_SEFINT_CURRENT_PROVINCE_SHARE' as acctid, 'rpt_sefint_current' as tag
union 
select  'RPT_SEF_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_SEF_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_sef_previous' as tag
union 
select  'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE' as objid, 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE' as acctid, 'rpt_sefint_previous' as tag
union 
select  'RPT_SEF_PRIOR_PROVINCE_SHARE' as objid, 'RPT_SEF_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_sef_prior' as tag
union 
select  'RPT_SEFINT_PRIOR_PROVINCE_SHARE' as objid, 'RPT_SEFINT_PRIOR_PROVINCE_SHARE' as acctid, 'rpt_sefint_prior' as tag;




/*===============================================================
*
* SET PARENT OF MUNICIPAL ACCOUNTS
*
===============================================================*/


-- advance account 
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASIC_ADVANCE', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.basicadvacct_objid = i.objid 
and m.lguid = o.objid
;


-- current account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASIC_CURRENT', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.basiccurracct_objid = i.objid 
and m.lguid = o.objid
;

-- current int account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASICINT_CURRENT', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.basiccurrintacct_objid = i.objid 
and m.lguid = o.objid
;



-- previous account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASIC_PREVIOUS', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.basicprevacct_objid = i.objid 
and m.lguid = o.objid
;



-- prevint account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASICINT_PREVIOUS', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.basicprevintacct_objid = i.objid 
and m.lguid = o.objid
;


-- prior account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASIC_PRIOR', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.basicprioracct_objid = i.objid 
and m.lguid = o.objid
;

-- priorint account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASICINT_PRIOR', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.basicpriorintacct_objid = i.objid 
and m.lguid = o.objid
;




-- advance account 
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_SEF_ADVANCE', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.sefadvacct_objid = i.objid 
and m.lguid = o.objid
;


-- current account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_SEF_CURRENT', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.sefcurracct_objid = i.objid 
and m.lguid = o.objid
;

-- current int account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_SEFINT_CURRENT', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.sefcurrintacct_objid = i.objid 
and m.lguid = o.objid
;



-- previous account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_SEF_PREVIOUS', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.sefprevacct_objid = i.objid 
and m.lguid = o.objid
;



-- prevint account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_SEFINT_PREVIOUS', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.sefprevintacct_objid = i.objid 
and m.lguid = o.objid
;


-- prior account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_SEF_PRIOR', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.sefprioracct_objid = i.objid 
and m.lguid = o.objid
;

-- priorint account
update itemaccount i, municipality_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_SEFINT_PRIOR', 
	i.org_objid = m.lguid,
	i.org_name = o.name 
where m.sefpriorintacct_objid = i.objid 
and m.lguid = o.objid
;




/*===============================================================
*
* SET PARENT OF PROVINCE ACCOUNTS
*
===============================================================*/
-- advance account 
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_BASIC_ADVANCE_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.basicadvacct_objid = i.objid 
and p.objid = o.objid
;


-- current account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_BASIC_CURRENT_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.basiccurracct_objid = i.objid 
and p.objid = o.objid
;

-- current int account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_BASICINT_CURRENT_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.basiccurrintacct_objid = i.objid 
and p.objid = o.objid
;



-- previous account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.basicprevacct_objid = i.objid 
and p.objid = o.objid
;



-- prevint account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.basicprevintacct_objid = i.objid 
and p.objid = o.objid
;


-- prior account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_BASIC_PRIOR_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.basicprioracct_objid = i.objid 
and p.objid = o.objid
;

-- priorint account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_BASICINT_PRIOR_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.basicpriorintacct_objid = i.objid 
and p.objid = o.objid
;




-- advance account 
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_SEF_ADVANCE_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.sefadvacct_objid = i.objid 
and p.objid = o.objid
;


-- current account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_SEF_CURRENT_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.sefcurracct_objid = i.objid 
and p.objid = o.objid
;

-- current int account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_SEFINT_CURRENT_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.sefcurrintacct_objid = i.objid 
and p.objid = o.objid
;



-- previous account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_SEF_PREVIOUS_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.sefprevacct_objid = i.objid 
and p.objid = o.objid
;



-- prevint account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.sefprevintacct_objid = i.objid 
and p.objid = o.objid
;


-- prior account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_SEF_PRIOR_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.sefprioracct_objid = i.objid 
and p.objid = o.objid
;

-- priorint account
update itemaccount i, province_taxaccount_mapping p, sys_org o set 
	i.parentid = 'RPT_SEFINT_PRIOR_PROVINCE_SHARE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
where p.sefpriorintacct_objid = i.objid 
and p.objid = o.objid
;






/*===============================================================
*
* SET PARENT OF BARANGAY ACCOUNTS
*
===============================================================*/

-- advance account 
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASIC_ADVANCE_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basicadvacct_objid = i.objid 
and m.barangayid = o.objid
;


-- current account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASIC_CURRENT_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basiccurracct_objid = i.objid 
and m.barangayid = o.objid
;

-- current int account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASICINT_CURRENT_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basiccurrintacct_objid = i.objid 
and m.barangayid = o.objid
;



-- previous account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASIC_PREVIOUS_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basicprevacct_objid = i.objid 
and m.barangayid = o.objid
;



-- prevint account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basicprevintacct_objid = i.objid 
and m.barangayid = o.objid
;


-- prior account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASIC_PRIOR_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basicprioracct_objid = i.objid 
and m.barangayid = o.objid
;

-- priorint account
update itemaccount i, brgy_taxaccount_mapping m, sys_org o set 
	i.parentid = 'RPT_BASICINT_PRIOR_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
where m.basicpriorintacct_objid = i.objid 
and m.barangayid = o.objid
;




/*============================================================
*
* 254032-03020
*
=============================================================*/
update cashreceiptitem_rpt_account set discount= 0 where discount is null;

alter table rptledger add lguid varchar(50);

update rptledger rl, barangay b, sys_org m set 
  rl.lguid = m.objid 
where rl.barangayid = b.objid 
and b.parentid = m.objid 
and m.orgclass = 'municipality';


update rptledger rl, barangay b, sys_org d, sys_org c set 
  rl.lguid = c.objid
where rl.barangayid = b.objid 
and b.parentid = d.objid 
and d.parent_objid = c.objid 
and d.orgclass = 'district';



create table `rptpayment` (
  `objid` varchar(100) not null,
  `type` varchar(50) default null,
  `refid` varchar(50) not null,
  `reftype` varchar(50) not null,
  `receiptid` varchar(50) default null,
  `receiptno` varchar(50) not null,
  `receiptdate` date not null,
  `paidby_name` longtext not null,
  `paidby_address` varchar(150) not null,
  `postedby` varchar(100) not null,
  `postedbytitle` varchar(50) not null,
  `dtposted` datetime not null,
  `fromyear` int(11) not null,
  `fromqtr` int(11) not null,
  `toyear` int(11) not null,
  `toqtr` int(11) not null,
  `amount` decimal(12,2) not null,
  `collectingagency` varchar(50) default null,
  `voided` int(11) not null,
  primary key(objid)
) engine=innodb default charset=utf8;

create index `fk_rptpayment_cashreceipt` on rptpayment(`receiptid`);
create index `ix_refid` on rptpayment(`refid`);
create index `ix_receiptno` on rptpayment(`receiptno`);

alter table rptpayment 
  add constraint `fk_rptpayment_cashreceipt` 
  foreign key (`receiptid`) references `cashreceipt` (`objid`);



create table `rptpayment_item` (
  `objid` varchar(50) not null,
  `parentid` varchar(100) not null,
  `rptledgerfaasid` varchar(50) default null,
  `year` int(11) not null,
  `qtr` int(11) default null,
  `revtype` varchar(50) not null,
  `revperiod` varchar(25) default null,
  `amount` decimal(16,2) not null,
  `interest` decimal(16,2) not null,
  `discount` decimal(16,2) not null,
  `partialled` int(11) not null,
  `priority` int(11) not null,
  primary key (`objid`)
) engine=innodb default charset=utf8;

create index `fk_rptpayment_item_parentid` on rptpayment_item (`parentid`);
create index `fk_rptpayment_item_rptledgerfaasid` on rptpayment_item (`rptledgerfaasid`);

alter table rptpayment_item
  add constraint `rptpayment_item_rptledgerfaas` foreign key (`rptledgerfaasid`) 
  references `rptledgerfaas` (`objid`);

alter table rptpayment_item
  add constraint `rptpayment_item_rptpayment` foreign key (`parentid`) 
  references `rptpayment` (`objid`);




create table `rptpayment_share` (
  `objid` varchar(50) not null,
  `parentid` varchar(100) default null,
  `revperiod` varchar(25) not null,
  `revtype` varchar(25) not null,
  `sharetype` varchar(25) not null,
  `item_objid` varchar(50) not null,
  `amount` decimal(16,4) not null,
  `discount` decimal(16,4) default null,
  primary key (`objid`)
) engine=innodb default charset=utf8;

create index `fk_rptpayment_share_parentid` on rptpayment_share(`parentid`);
create index `fk_rptpayment_share_item_objid` on  rptpayment_share(`item_objid`);

alter table rptpayment_share add constraint `rptpayment_share_itemaccount` 
  foreign key (`item_objid`) references `itemaccount` (`objid`);

alter table rptpayment_share add constraint `rptpayment_share_rptpayment` 
  foreign key (`parentid`) references `rptpayment` (`objid`);



insert into rptpayment(
  objid,
  type,
  refid,
  reftype,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided
)
select
  objid,
  type, 
  rptledgerid as refid,
  'rptledger' as reftype,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided
from rptledger_payment;


insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-basic') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'basic' as revtype,
  revperiod,
  basic as amount,
  basicint as interest,
  basicdisc as discount,
  partialled,
  10000 as priority
from rptledger_payment_item;





insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-sef') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'sef' as revtype,
  revperiod,
  sef as amount,
  sefint as interest,
  sefdisc as discount,
  partialled,
  10000 as priority
from rptledger_payment_item;


insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-sh') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'sh' as revtype,
  revperiod,
  sh as amount,
  shint as interest,
  shdisc as discount,
  partialled,
  100 as priority
from rptledger_payment_item
where sh > 0;




insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-firecode') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'firecode' as revtype,
  revperiod,
  firecode as amount,
  0 as interest,
  0 as discount,
  partialled,
  50 as priority
from rptledger_payment_item
where firecode > 0
;



insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-basicidle') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'basicidle' as revtype,
  revperiod,
  basicidle as amount,
  basicidleint as interest,
  basicidledisc as discount,
  partialled,
  200 as priority
from rptledger_payment_item
where basicidle > 0
;



update cashreceipt_rpt set txntype = 'online' where txntype = 'rptonline'
;
update cashreceipt_rpt set txntype = 'manual' where txntype = 'rptmanual'
;
update cashreceipt_rpt set txntype = 'compromise' where txntype = 'rptcompromise'
;

update rptpayment set type = 'online' where type = 'rptonline'
;
update rptpayment set type = 'manual' where type = 'rptmanual'
;
update rptpayment set type = 'compromise' where type = 'rptcompromise'
;






  
create table landtax_report_rptdelinquency (
  objid varchar(50) not null,
  rptledgerid varchar(50) not null,
  barangayid varchar(50) not null,
  year int not null,
  qtr int null,
  revtype varchar(50) not null,
  amount decimal(16,2) not null,
  interest decimal(16,2) not null,
  discount decimal(16,2) not null,
  dtgenerated datetime not null, 
  generatedby_name varchar(255) not null,
  generatedby_title varchar(100) not null,
  primary key (objid)
)engine=innodb default charset=utf8
;




create view vw_rptpayment_item_detail as
select
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revperiod, 
  case when rpi.revtype = 'basic' then rpi.amount else 0 end as basic,
  case when rpi.revtype = 'basic' then rpi.interest else 0 end as basicint,
  case when rpi.revtype = 'basic' then rpi.discount else 0 end as basicdisc,
  case when rpi.revtype = 'basic' then rpi.interest - rpi.discount else 0 end as basicdp,
  case when rpi.revtype = 'basic' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicnet,
  case when rpi.revtype = 'basicidle' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicidle,
  case when rpi.revtype = 'basicidle' then rpi.interest else 0 end as basicidleint,
  case when rpi.revtype = 'basicidle' then rpi.discount else 0 end as basicidledisc,
  case when rpi.revtype = 'basicidle' then rpi.interest - rpi.discount else 0 end as basicidledp,
  case when rpi.revtype = 'sef' then rpi.amount else 0 end as sef,
  case when rpi.revtype = 'sef' then rpi.interest else 0 end as sefint,
  case when rpi.revtype = 'sef' then rpi.discount else 0 end as sefdisc,
  case when rpi.revtype = 'sef' then rpi.interest - rpi.discount else 0 end as sefdp,
  case when rpi.revtype = 'sef' then rpi.amount + rpi.interest - rpi.discount else 0 end as sefnet,
  case when rpi.revtype = 'firecode' then rpi.amount + rpi.interest - rpi.discount else 0 end as firecode,
  case when rpi.revtype = 'sh' then rpi.amount + rpi.interest - rpi.discount else 0 end as sh,
  case when rpi.revtype = 'sh' then rpi.interest else 0 end as shint,
  case when rpi.revtype = 'sh' then rpi.discount else 0 end as shdisc,
  case when rpi.revtype = 'sh' then rpi.interest - rpi.discount else 0 end as shdp,
  rpi.amount + rpi.interest - rpi.discount as amount,
  rpi.partialled as partialled 
from rptpayment_item rpi
;




create view vw_rptpayment_item as
select 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    sum(x.basic) as basic,
    sum(x.basicint) as basicint,
    sum(x.basicdisc) as basicdisc,
    sum(x.basicdp) as basicdp,
    sum(x.basicnet) as basicnet,
    sum(x.basicidle) as basicidle,
    sum(x.basicidleint) as basicidleint,
    sum(x.basicidledisc) as basicidledisc,
    sum(x.basicidledp) as basicidledp,
    sum(x.sef) as sef,
    sum(x.sefint) as sefint,
    sum(x.sefdisc) as sefdisc,
    sum(x.sefdp) as sefdp,
    sum(x.sefnet) as sefnet,
    sum(x.firecode) as firecode,
    sum(x.sh) as sh,
    sum(x.shint) as shint,
    sum(x.shdisc) as shdisc,
    sum(x.shdp) as shdp,
    sum(x.amount) as amount,
    max(x.partialled) as partialled
from vw_rptpayment_item_detail x
group by 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod
;


create view vw_landtax_report_rptdelinquency_detail 
as
select
  objid,
  rptledgerid,
  barangayid,
  year,
  qtr,
  dtgenerated,
  generatedby_name,
  generatedby_title,
  case when revtype = 'basic' then amount else 0 end as basic,
  case when revtype = 'basic' then interest else 0 end as basicint,
  case when revtype = 'basic' then discount else 0 end as basicdisc,
  case when revtype = 'basic' then interest - discount else 0 end as basicdp,
  case when revtype = 'basic' then amount + interest - discount else 0 end as basicnet,
  case when revtype = 'basicidle' then amount else 0 end as basicidle,
  case when revtype = 'basicidle' then interest else 0 end as basicidleint,
  case when revtype = 'basicidle' then discount else 0 end as basicidledisc,
  case when revtype = 'basicidle' then interest - discount else 0 end as basicidledp,
  case when revtype = 'basicidle' then amount + interest - discount else 0 end as basicidlenet,
  case when revtype = 'sef' then amount else 0 end as sef,
  case when revtype = 'sef' then interest else 0 end as sefint,
  case when revtype = 'sef' then discount else 0 end as sefdisc,
  case when revtype = 'sef' then interest - discount else 0 end as sefdp,
  case when revtype = 'sef' then amount + interest - discount else 0 end as sefnet,
  case when revtype = 'firecode' then amount else 0 end as firecode,
  case when revtype = 'firecode' then interest else 0 end as firecodeint,
  case when revtype = 'firecode' then discount else 0 end as firecodedisc,
  case when revtype = 'firecode' then interest - discount else 0 end as firecodedp,
  case when revtype = 'firecode' then amount + interest - discount else 0 end as firecodenet,
  case when revtype = 'sh' then amount else 0 end as sh,
  case when revtype = 'sh' then interest else 0 end as shint,
  case when revtype = 'sh' then discount else 0 end as shdisc,
  case when revtype = 'sh' then interest - discount else 0 end as shdp,
  case when revtype = 'sh' then amount + interest - discount else 0 end as shnet,
  amount + interest - discount as total
from landtax_report_rptdelinquency
;



create view vw_landtax_report_rptdelinquency
as
select
  rptledgerid,
  barangayid,
  year,
  qtr,
  dtgenerated,
  generatedby_name,
  generatedby_title,
  sum(basic) as basic,
  sum(basicint) as basicint,
  sum(basicdisc) as basicdisc,
  sum(basicdp) as basicdp,
  sum(basicnet) as basicnet,
  sum(basicidle) as basicidle,
  sum(basicidleint) as basicidleint,
  sum(basicidledisc) as basicidledisc,
  sum(basicidledp) as basicidledp,
  sum(basicidlenet) as basicidlenet,
  sum(sef) as sef,
  sum(sefint) as sefint,
  sum(sefdisc) as sefdisc,
  sum(sefdp) as sefdp,
  sum(sefnet) as sefnet,
  sum(firecode) as firecode,
  sum(firecodeint) as firecodeint,
  sum(firecodedisc) as firecodedisc,
  sum(firecodedp) as firecodedp,
  sum(firecodenet) as firecodenet,
  sum(sh) as sh,
  sum(shint) as shint,
  sum(shdisc) as shdisc,
  sum(shdp) as shdp,
  sum(shnet) as shnet,
  sum(total) as total
from vw_landtax_report_rptdelinquency_detail
group by 
  rptledgerid,
  barangayid,
  year,
  qtr,
  dtgenerated,
  generatedby_name,
  generatedby_title
;






create table `rptledger_item` (
  `objid` varchar(50) not null,
  `parentid` varchar(50) not null,
  `rptledgerfaasid` varchar(50) default null,
  `remarks` varchar(100) default null,
  `basicav` decimal(16,2) not null,
  `sefav` decimal(16,2) not null,
  `av` decimal(16,2) not null,
  `revtype` varchar(50) not null,
  `year` int(11) not null,
  `amount` decimal(16,2) not null,
  `amtpaid` decimal(16,2) not null,
  `priority` int(11) not null,
  `taxdifference` int(11) not null,
  `system` int(11) not null,
  primary key (`objid`)
) engine=innodb default charset=utf8
;

create index `fk_rptledger_item_rptledger` on rptledger_item (`parentid`)
; 

alter table rptledger_item 
  add constraint `fk_rptledger_item_rptledger` foreign key (`parentid`) 
  references `rptledger` (`objid`)
;



insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-basic') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'basic' as revtype,
  rli.year,
  rli.basic as amount,
  rli.basicpaid as amtpaid,
  10000 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.basic > 0 
and rli.basicpaid < rli.basic
;




insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-sef') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'sef' as revtype,
  rli.year,
  rli.sef as amount,
  rli.sefpaid as amtpaid,
  10000 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.sef > 0 
and rli.sefpaid < rli.sef
;




insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-firecode') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'firecode' as revtype,
  rli.year,
  rli.firecode as amount,
  rli.firecodepaid as amtpaid,
  1 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.firecode > 0 
and rli.firecodepaid < rli.firecode
;



insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-basicidle') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'basicidle' as revtype,
  rli.year,
  rli.basicidle as amount,
  rli.basicidlepaid as amtpaid,
  5 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.basicidle > 0 
and rli.basicidlepaid < rli.basicidle
;


insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-sh') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  ifnull(rli.basicav, rli.av),
  ifnull(rli.sefav, rli.av),
  rli.av,
  'sh' as revtype,
  rli.year,
  rli.sh as amount,
  rli.shpaid as amtpaid,
  10 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.sh > 0 
and rli.shpaid < rli.sh
;









/*====================================================================================
*
* RPTLEDGER AND RPTBILLING RULE SUPPORT 
*
======================================================================================*/


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






INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('rptbilling', 'RPT Billing Rules', 'rptbilling', 'LANDTAX', 'RULE_AUTHOR', NULL);
INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('rptledger', 'Ledger Billing Rules', 'rptledger', 'LANDTAX', 'RULE_AUTHOR', NULL);


INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('LEDGER_ITEM', 'rptledger', 'Ledger Item Posting', '1');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('TAX', 'rptledger', 'Tax Computation', '2');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_TAX', 'rptledger', 'Post Tax Computation', '3');


INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('INIT', 'rptbilling', 'Init', '0');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('DISCOUNT', 'rptbilling', 'Discount Computation', '9');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_DISCOUNT', 'rptbilling', 'After Discount Computation', '10');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('PENALTY', 'rptbilling', 'Penalty Computation', '7');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_PENALTY', 'rptbilling', 'After Penalty Computation', '8');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE_SUMMARY', 'rptbilling', 'Before Summary ', '19');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('SUMMARY', 'rptbilling', 'Summary', '20');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_SUMMARY', 'rptbilling', 'After Summary', '21');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BRGY_SHARE', 'rptbilling', 'Barangay Share Computation', '25');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('PROV_SHARE', 'rptbilling', 'Province Share Computation', '27');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('LGU_SHARE', 'rptbilling', 'LGU Share Computation', '26');






drop view if exists vw_landtax_lgu_account_mapping
; 

create view vw_landtax_lgu_account_mapping
as 
select 
  ia.org_objid as org_objid,
  ia.org_name as org_name, 
  o.orgclass as org_class, 
  p.objid as parent_objid,
  p.code as parent_code,
  p.title as parent_title,
  ia.objid as item_objid,
  ia.code as item_code,
  ia.title as item_title,
  ia.fund_objid as item_fund_objid, 
  ia.fund_code as item_fund_code,
  ia.fund_title as item_fund_title,
  ia.type as item_type,
  pt.tag as item_tag
from itemaccount ia
inner join itemaccount p on ia.parentid = p.objid 
inner join itemaccount_tag pt on p.objid = pt.acctid
inner join sys_org o on ia.org_objid = o.objid 
where p.state = 'APPROVED'
; 









/*=============================================================
*
* COMPROMISE UPDATE 
*
==============================================================*/


CREATE TABLE `rptcompromise` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` date NOT NULL,
  `faasid` varchar(50) DEFAULT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `lastyearpaid` int(11) NOT NULL,
  `lastqtrpaid` int(11) NOT NULL,
  `startyear` int(11) NOT NULL,
  `startqtr` int(11) NOT NULL,
  `endyear` int(11) NOT NULL,
  `endqtr` int(11) NOT NULL,
  `enddate` date NOT NULL,
  `cypaymentrequired` int(11) DEFAULT NULL,
  `cypaymentorno` varchar(10) DEFAULT NULL,
  `cypaymentordate` date DEFAULT NULL,
  `cypaymentoramount` decimal(10,2) DEFAULT NULL,
  `downpaymentrequired` int(11) NOT NULL,
  `downpaymentrate` decimal(10,0) NOT NULL,
  `downpayment` decimal(10,2) NOT NULL,
  `downpaymentorno` varchar(50) DEFAULT NULL,
  `downpaymentordate` date DEFAULT NULL,
  `term` int(11) NOT NULL,
  `numofinstallment` int(11) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtforinstallment` decimal(16,2) NOT NULL,
  `amtpaid` decimal(16,2) NOT NULL,
  `firstpartyname` varchar(100) NOT NULL,
  `firstpartytitle` varchar(50) NOT NULL,
  `firstpartyaddress` varchar(100) NOT NULL,
  `firstpartyctcno` varchar(15) NOT NULL,
  `firstpartyctcissued` varchar(100) NOT NULL,
  `firstpartyctcdate` date NOT NULL,
  `firstpartynationality` varchar(50) NOT NULL,
  `firstpartystatus` varchar(50) NOT NULL,
  `firstpartygender` varchar(10) NOT NULL,
  `secondpartyrepresentative` varchar(100) NOT NULL,
  `secondpartyname` varchar(100) NOT NULL,
  `secondpartyaddress` varchar(100) NOT NULL,
  `secondpartyctcno` varchar(15) NOT NULL,
  `secondpartyctcissued` varchar(100) NOT NULL,
  `secondpartyctcdate` date NOT NULL,
  `secondpartynationality` varchar(50) NOT NULL,
  `secondpartystatus` varchar(50) NOT NULL,
  `secondpartygender` varchar(10) NOT NULL,
  `dtsigned` date DEFAULT NULL,
  `notarizeddate` date DEFAULT NULL,
  `notarizedby` varchar(100) DEFAULT NULL,
  `notarizedbytitle` varchar(50) DEFAULT NULL,
  `signatories` varchar(1000) NOT NULL,
  `manualdiff` decimal(16,2) NOT NULL DEFAULT '0.00',
  `cypaymentreceiptid` varchar(50) DEFAULT NULL,
  `downpaymentreceiptid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `ix_rptcompromise_faasid` on rptcompromise(`faasid`);
create index `ix_rptcompromise_ledgerid` on rptcompromise(`rptledgerid`);
alter table rptcompromise add CONSTRAINT `fk_rptcompromise_faas` 
  FOREIGN KEY (`faasid`) REFERENCES `faas` (`objid`);
alter table rptcompromise add CONSTRAINT `fk_rptcompromise_rptledger` 
  FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`);



CREATE TABLE `rptcompromise_installment` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `installmentno` int(11) NOT NULL,
  `duedate` date NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtpaid` decimal(16,2) NOT NULL,
  `fullypaid` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `ix_rptcompromise_installment_rptcompromiseid` on rptcompromise_installment(`parentid`);

alter table rptcompromise_installment 
  add CONSTRAINT `fk_rptcompromise_installment_rptcompromise` 
  FOREIGN KEY (`parentid`) REFERENCES `rptcompromise` (`objid`);



  CREATE TABLE `rptcompromise_credit` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `receiptid` varchar(50) DEFAULT NULL,
  `installmentid` varchar(50) DEFAULT NULL,
  `collector_name` varchar(100) NOT NULL,
  `collector_title` varchar(50) NOT NULL,
  `orno` varchar(10) NOT NULL,
  `ordate` date NOT NULL,
  `oramount` decimal(16,2) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `mode` varchar(50) NOT NULL,
  `paidby` varchar(150) NOT NULL,
  `paidbyaddress` varchar(100) NOT NULL,
  `partial` int(11) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `ix_rptcompromise_credit_parentid` on rptcompromise_credit(`parentid`);
create index `ix_rptcompromise_credit_receiptid` on rptcompromise_credit(`receiptid`);
create index `ix_rptcompromise_credit_installmentid` on rptcompromise_credit(`installmentid`);

alter table rptcompromise_credit 
  add CONSTRAINT `fk_rptcompromise_credit_rptcompromise_installment` 
  FOREIGN KEY (`installmentid`) REFERENCES `rptcompromise_installment` (`objid`);

alter table rptcompromise_credit 
  add CONSTRAINT `fk_rptcompromise_credit_cashreceipt` 
  FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`);

alter table rptcompromise_credit 
  add CONSTRAINT `fk_rptcompromise_credit_rptcompromise` 
  FOREIGN KEY (`parentid`) REFERENCES `rptcompromise` (`objid`);



CREATE TABLE `rptcompromise_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `rptledgerfaasid` varchar(50) NOT NULL,
  `revtype` varchar(50) NOT NULL,
  `revperiod` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `amtpaid` decimal(16,2) NOT NULL,
  `interest` decimal(16,2) NOT NULL,
  `interestpaid` decimal(16,2) NOT NULL,
  `priority` int(11) DEFAULT NULL,
  `taxdifference` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `ix_rptcompromise_item_rptcompromise` on rptcompromise_item (`parentid`);
create index `ix_rptcompromise_item_rptledgerfaas` on rptcompromise_item (`rptledgerfaasid`);

alter table rptcompromise_item 
  add CONSTRAINT `fk_rptcompromise_item_rptcompromise` 
  FOREIGN KEY (`parentid`) REFERENCES `rptcompromise` (`objid`);

alter table rptcompromise_item 
  add CONSTRAINT `fk_rptcompromise_item_rptledgerfaas` 
  FOREIGN KEY (`rptledgerfaasid`) REFERENCES `rptledgerfaas` (`objid`);


/*=============================================================
*
* MIGRATE COMPROMISE RECORDS 
*
==============================================================*/
insert into rptcompromise(
    objid,
    state,
    txnno,
    txndate,
    faasid,
    rptledgerid,
    lastyearpaid,
    lastqtrpaid,
    startyear,
    startqtr,
    endyear,
    endqtr,
    enddate,
    cypaymentrequired,
    cypaymentorno,
    cypaymentordate,
    cypaymentoramount,
    downpaymentrequired,
    downpaymentrate,
    downpayment,
    downpaymentorno,
    downpaymentordate,
    term,
    numofinstallment,
    amount,
    amtforinstallment,
    amtpaid,
    firstpartyname,
    firstpartytitle,
    firstpartyaddress,
    firstpartyctcno,
    firstpartyctcissued,
    firstpartyctcdate,
    firstpartynationality,
    firstpartystatus,
    firstpartygender,
    secondpartyrepresentative,
    secondpartyname,
    secondpartyaddress,
    secondpartyctcno,
    secondpartyctcissued,
    secondpartyctcdate,
    secondpartynationality,
    secondpartystatus,
    secondpartygender,
    dtsigned,
    notarizeddate,
    notarizedby,
    notarizedbytitle,
    signatories,
    manualdiff,
    cypaymentreceiptid,
    downpaymentreceiptid
)
select 
    objid,
    state,
    txnno,
    txndate,
    faasid,
    rptledgerid,
    lastyearpaid,
    lastqtrpaid,
    startyear,
    startqtr,
    endyear,
    endqtr,
    enddate,
    cypaymentrequired,
    cypaymentorno,
    cypaymentordate,
    cypaymentoramount,
    downpaymentrequired,
    downpaymentrate,
    downpayment,
    downpaymentorno,
    downpaymentordate,
    term,
    numofinstallment,
    amount,
    amtforinstallment,
    amtpaid,
    firstpartyname,
    firstpartytitle,
    firstpartyaddress,
    firstpartyctcno,
    firstpartyctcissued,
    firstpartyctcdate,
    firstpartynationality,
    firstpartystatus,
    firstpartygender,
    secondpartyrepresentative,
    secondpartyname,
    secondpartyaddress,
    secondpartyctcno,
    secondpartyctcissued,
    secondpartyctcdate,
    secondpartynationality,
    secondpartystatus,
    secondpartygender,
    dtsigned,
    notarizeddate,
    notarizedby,
    notarizedbytitle,
    signatories,
    manualdiff,
    cypaymentreceiptid,
    downpaymentreceiptid
from rptledger_compromise
;


insert into rptcompromise_installment(
    objid,
    parentid,
    installmentno,
    duedate,
    amount,
    amtpaid,
    fullypaid
)
select 
    objid,
    rptcompromiseid,
    installmentno,
    duedate,
    amount,
    amtpaid,
    fullypaid
from rptledger_compromise_installment    
;


insert into rptcompromise_credit(
    objid,
    parentid,
    receiptid,
    installmentid,
    collector_name,
    collector_title,
    orno,
    ordate,
    oramount,
    amount, 
    mode,
    paidby,
    paidbyaddress,
    partial,
    remarks
)
select 
    objid,
    rptcompromiseid as parentid,
    rptreceiptid,
    installmentid,
    collector_name,
    collector_title,
    orno,
    ordate,
    oramount,
    oramount,
    mode,
    paidby,
    paidbyaddress,
    partial,
    remarks
from rptledger_compromise_credit    
;



insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-basic') as objid,
    rci.rptcompromiseid as parentid,
    (select objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled' limit 1) as rptledgerfaasid,
    'basic' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.basic) as amount,
    sum(rci.basicpaid) as amtpaid,
    sum(rci.basicint) as interest,
    sum(rci.basicintpaid) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.basic > 0 
group by rc.rptledgerid, year, rptcompromiseid
;






insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-sef') as objid,
    rci.rptcompromiseid as parentid,
    (select objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled' limit 1) as rptledgerfaasid,
    'sef' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.sef) as amount,
    sum(rci.sefpaid) as amtpaid,
    sum(rci.sefint) as interest,
    sum(rci.sefintpaid) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.sef > 0
group by rc.rptledgerid, year, rptcompromiseid
;


insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-basicidle') as objid,
    rci.rptcompromiseid as parentid,
    (select objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled' limit 1) as rptledgerfaasid,
    'basicidle' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.basicidle) as amount,
    sum(rci.basicidlepaid) as amtpaid,
    sum(rci.basicidleint) as interest,
    sum(rci.basicidleintpaid) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.basicidle > 0
group by rc.rptledgerid, year, rptcompromiseid
;




insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-firecode') as objid,
    rci.rptcompromiseid as parentid,
    (select objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled' limit 1) as rptledgerfaasid,
    'firecode' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.firecode) as amount,
    sum(rci.firecodepaid) as amtpaid,
    sum(0) as interest,
    sum(0) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.basicidle > 0
group by rc.rptledgerid, year, rptcompromiseid
;






/*====================================================================
*
* LANDTAX RPT DELINQUENCY UPDATE 
*
====================================================================*/

drop table if exists report_rptdelinquency_error
;
drop table if exists report_rptdelinquency_forprocess
;
drop table if exists report_rptdelinquency_item
;
drop table if exists report_rptdelinquency_barangay
;
drop table if exists report_rptdelinquency
;



CREATE TABLE `report_rptdelinquency` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `dtgenerated` datetime NOT NULL,
  `dtcomputed` datetime NOT NULL,
  `generatedby_name` varchar(255) NOT NULL,
  `generatedby_title` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `report_rptdelinquency_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) DEFAULT NULL,
  `revtype` varchar(50) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `interest` decimal(16,2) NOT NULL,
  `discount` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
;

create index ix_parentid on report_rptdelinquency_item(parentid)  
;


alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptledger foreign key(rptledgerid)
  references rptledger(objid)
;

create index ix_rptledger on report_rptdelinquency_item(rptledgerid)  
;

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_barangay foreign key(barangayid)
  references barangay(objid)
;

create index ix_barangayid on report_rptdelinquency_item(barangayid)  
;




CREATE TABLE `report_rptdelinquency_barangay` (
  objid varchar(50) not null, 
  parentid varchar(50) not null, 
  `barangayid` varchar(50) NOT NULL,
  count int not null,
  processed int not null, 
  errors int not null, 
  ignored int not null, 
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
;

create index fk_rptdelinquency_barangay_rptdelinquency on report_rptdelinquency_item(parentid)  
;


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_barangay foreign key(barangayid)
  references barangay(objid)
;

create index ix_barangayid on report_rptdelinquency_barangay(barangayid)  
;


CREATE TABLE `report_rptdelinquency_forprocess` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index ix_barangayid on report_rptdelinquency_forprocess(barangayid);
  


CREATE TABLE `report_rptdelinquency_error` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `error` text NULL,
  `ignored` int,
  PRIMARY KEY (`objid`),
  KEY `ix_barangayid` (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;  




drop view vw_landtax_report_rptdelinquency_detail
;

create view vw_landtax_report_rptdelinquency_detail 
as
select
  parentid, 
  rptledgerid,
  barangayid,
  year,
  qtr,
  case when revtype = 'basic' then amount else 0 end as basic,
  case when revtype = 'basic' then interest else 0 end as basicint,
  case when revtype = 'basic' then discount else 0 end as basicdisc,
  case when revtype = 'basic' then interest - discount else 0 end as basicdp,
  case when revtype = 'basic' then amount + interest - discount else 0 end as basicnet,
  case when revtype = 'basicidle' then amount else 0 end as basicidle,
  case when revtype = 'basicidle' then interest else 0 end as basicidleint,
  case when revtype = 'basicidle' then discount else 0 end as basicidledisc,
  case when revtype = 'basicidle' then interest - discount else 0 end as basicidledp,
  case when revtype = 'basicidle' then amount + interest - discount else 0 end as basicidlenet,
  case when revtype = 'sef' then amount else 0 end as sef,
  case when revtype = 'sef' then interest else 0 end as sefint,
  case when revtype = 'sef' then discount else 0 end as sefdisc,
  case when revtype = 'sef' then interest - discount else 0 end as sefdp,
  case when revtype = 'sef' then amount + interest - discount else 0 end as sefnet,
  case when revtype = 'firecode' then amount else 0 end as firecode,
  case when revtype = 'firecode' then interest else 0 end as firecodeint,
  case when revtype = 'firecode' then discount else 0 end as firecodedisc,
  case when revtype = 'firecode' then interest - discount else 0 end as firecodedp,
  case when revtype = 'firecode' then amount + interest - discount else 0 end as firecodenet,
  case when revtype = 'sh' then amount else 0 end as sh,
  case when revtype = 'sh' then interest else 0 end as shint,
  case when revtype = 'sh' then discount else 0 end as shdisc,
  case when revtype = 'sh' then interest - discount else 0 end as shdp,
  case when revtype = 'sh' then amount + interest - discount else 0 end as shnet,
  amount + interest - discount as total
from report_rptdelinquency_item 
;



/*====================================================================
*
* LANDTAX RPT DELINQUENCY UPDATE 
*
====================================================================*/

drop table if exists report_rptdelinquency_error
;
drop table if exists report_rptdelinquency_forprocess
;
drop table if exists report_rptdelinquency_item
;
drop table if exists report_rptdelinquency_barangay
;
drop table if exists report_rptdelinquency
;



CREATE TABLE `report_rptdelinquency` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `dtgenerated` datetime NOT NULL,
  `dtcomputed` datetime NOT NULL,
  `generatedby_name` varchar(255) NOT NULL,
  `generatedby_title` varchar(100) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `report_rptdelinquency_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `qtr` int(11) DEFAULT NULL,
  `revtype` varchar(50) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `interest` decimal(16,2) NOT NULL,
  `discount` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
;

create index ix_parentid on report_rptdelinquency_item(parentid)  
;


alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptledger foreign key(rptledgerid)
  references rptledger(objid)
;

create index ix_rptledgerid on report_rptdelinquency_item(rptledgerid)  
;

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_barangay foreign key(barangayid)
  references barangay(objid)
;

create index ix_barangayid on report_rptdelinquency_item(barangayid)  
;




CREATE TABLE `report_rptdelinquency_barangay` (
  objid varchar(50) not null, 
  parentid varchar(50) not null, 
  `barangayid` varchar(50) NOT NULL,
  count int not null,
  processed int not null, 
  errors int not null, 
  ignored int not null, 
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
;

create index fk_rptdelinquency_barangay_rptdelinquency on report_rptdelinquency_item(parentid)  
;


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_barangay foreign key(barangayid)
  references barangay(objid)
;

create index ix_barangayid on report_rptdelinquency_barangay(barangayid)  
;


CREATE TABLE `report_rptdelinquency_forprocess` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index ix_barangayid on report_rptdelinquency_forprocess(barangayid);
  


CREATE TABLE `report_rptdelinquency_error` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `error` text NULL,
  `ignored` int,
  PRIMARY KEY (`objid`),
  KEY `ix_barangayid` (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;  




drop view vw_landtax_report_rptdelinquency_detail
;

create view vw_landtax_report_rptdelinquency_detail 
as
select
  parentid, 
  rptledgerid,
  barangayid,
  year,
  qtr,
  case when revtype = 'basic' then amount else 0 end as basic,
  case when revtype = 'basic' then interest else 0 end as basicint,
  case when revtype = 'basic' then discount else 0 end as basicdisc,
  case when revtype = 'basic' then interest - discount else 0 end as basicdp,
  case when revtype = 'basic' then amount + interest - discount else 0 end as basicnet,
  case when revtype = 'basicidle' then amount else 0 end as basicidle,
  case when revtype = 'basicidle' then interest else 0 end as basicidleint,
  case when revtype = 'basicidle' then discount else 0 end as basicidledisc,
  case when revtype = 'basicidle' then interest - discount else 0 end as basicidledp,
  case when revtype = 'basicidle' then amount + interest - discount else 0 end as basicidlenet,
  case when revtype = 'sef' then amount else 0 end as sef,
  case when revtype = 'sef' then interest else 0 end as sefint,
  case when revtype = 'sef' then discount else 0 end as sefdisc,
  case when revtype = 'sef' then interest - discount else 0 end as sefdp,
  case when revtype = 'sef' then amount + interest - discount else 0 end as sefnet,
  case when revtype = 'firecode' then amount else 0 end as firecode,
  case when revtype = 'firecode' then interest else 0 end as firecodeint,
  case when revtype = 'firecode' then discount else 0 end as firecodedisc,
  case when revtype = 'firecode' then interest - discount else 0 end as firecodedp,
  case when revtype = 'firecode' then amount + interest - discount else 0 end as firecodenet,
  case when revtype = 'sh' then amount else 0 end as sh,
  case when revtype = 'sh' then interest else 0 end as shint,
  case when revtype = 'sh' then discount else 0 end as shdisc,
  case when revtype = 'sh' then interest - discount else 0 end as shdp,
  case when revtype = 'sh' then amount + interest - discount else 0 end as shnet,
  amount + interest - discount as total
from report_rptdelinquency_item 
;




drop  view vw_landtax_report_rptdelinquency
;

create view vw_landtax_report_rptdelinquency
as
select
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title,
  sum(v.basic) as basic,
  sum(v.basicint) as basicint,
  sum(v.basicdisc) as basicdisc,
  sum(v.basicdp) as basicdp,
  sum(v.basicnet) as basicnet,
  sum(v.basicidle) as basicidle,
  sum(v.basicidleint) as basicidleint,
  sum(v.basicidledisc) as basicidledisc,
  sum(v.basicidledp) as basicidledp,
  sum(v.basicidlenet) as basicidlenet,
  sum(v.sef) as sef,
  sum(v.sefint) as sefint,
  sum(v.sefdisc) as sefdisc,
  sum(v.sefdp) as sefdp,
  sum(v.sefnet) as sefnet,
  sum(v.firecode) as firecode,
  sum(v.firecodeint) as firecodeint,
  sum(v.firecodedisc) as firecodedisc,
  sum(v.firecodedp) as firecodedp,
  sum(v.firecodenet) as firecodenet,
  sum(v.sh) as sh,
  sum(v.shint) as shint,
  sum(v.shdisc) as shdisc,
  sum(v.shdp) as shdp,
  sum(v.shnet) as shnet,
  sum(v.total) as total
from report_rptdelinquency rr 
inner join vw_landtax_report_rptdelinquency_detail v on rr.objid = v.parentid 
group by 
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title
;



drop  view vw_landtax_report_rptdelinquency
;

create view vw_landtax_report_rptdelinquency
as
select
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title,
  sum(v.basic) as basic,
  sum(v.basicint) as basicint,
  sum(v.basicdisc) as basicdisc,
  sum(v.basicdp) as basicdp,
  sum(v.basicnet) as basicnet,
  sum(v.basicidle) as basicidle,
  sum(v.basicidleint) as basicidleint,
  sum(v.basicidledisc) as basicidledisc,
  sum(v.basicidledp) as basicidledp,
  sum(v.basicidlenet) as basicidlenet,
  sum(v.sef) as sef,
  sum(v.sefint) as sefint,
  sum(v.sefdisc) as sefdisc,
  sum(v.sefdp) as sefdp,
  sum(v.sefnet) as sefnet,
  sum(v.firecode) as firecode,
  sum(v.firecodeint) as firecodeint,
  sum(v.firecodedisc) as firecodedisc,
  sum(v.firecodedp) as firecodedp,
  sum(v.firecodenet) as firecodenet,
  sum(v.sh) as sh,
  sum(v.shint) as shint,
  sum(v.shdisc) as shdisc,
  sum(v.shdp) as shdp,
  sum(v.shnet) as shnet,
  sum(v.total) as total
from report_rptdelinquency rr 
inner join vw_landtax_report_rptdelinquency_detail v on rr.objid = v.parentid 
group by 
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title
;

/* 03021 */

/*============================================
*
* TAX DIFFERENCE
*
*============================================*/

CREATE TABLE `rptledger_avdifference` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `rptledgerfaas_objid` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `av` decimal(16,2) NOT NULL,
  `paid` int(11) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index `fk_rptledger` on rptledger_avdifference (`parent_objid`)
;

create index `fk_rptledgerfaas` on rptledger_avdifference (`rptledgerfaas_objid`)
;
 
alter table rptledger_avdifference 
	add CONSTRAINT `fk_rptledgerfaas` FOREIGN KEY (`rptledgerfaas_objid`) 
	REFERENCES `rptledgerfaas` (`objid`)
;

alter table rptledger_avdifference 
	add CONSTRAINT `fk_rptledger` FOREIGN KEY (`parent_objid`) 
	REFERENCES `rptledger` (`objid`)
;



create view vw_rptledger_avdifference
as 
select 
  rlf.objid,
  'APPROVED' as state,
  d.parent_objid as rptledgerid,
  rl.faasid,
  rl.tdno,
  rlf.txntype_objid,
  rlf.classification_objid,
  rlf.actualuse_objid,
  rlf.taxable,
  rlf.backtax,
  d.year as fromyear,
  1 as fromqtr,
  d.year as toyear,
  4 as toqtr,
  d.av as assessedvalue,
  1 as systemcreated,
  rlf.reclassed,
  rlf.idleland,
  1 as taxdifference
from rptledger_avdifference d 
inner join rptledgerfaas rlf on d.rptledgerfaas_objid = rlf.objid 
inner join rptledger rl on d.parent_objid = rl.objid 
; 

/* 03022 */

/*============================================
*
* SYNC PROVINCE AND REMOTE LEGERS
*
*============================================*/
drop table if exists `rptledger_remote`;

CREATE TABLE `remote_mapping` (
  `objid` varchar(50) NOT NULL,
  `doctype` varchar(50) NOT NULL,
  `remote_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `createdby_title` varchar(100) DEFAULT NULL,
  `dtcreated` datetime NOT NULL,
  `orgcode` varchar(10) DEFAULT NULL,
  `remote_orgcode` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index ix_doctype on remote_mapping(doctype);
create index ix_orgcode on remote_mapping(orgcode);
create index ix_remote_orgcode on remote_mapping(remote_orgcode);
create index ix_remote_objid on remote_mapping(remote_objid);




drop table if exists sync_data_forprocess;
drop table if exists sync_data_pending;
drop table if exists sync_data;


create table `sync_data` (
  `objid` varchar(50) not null,
  `parentid` varchar(50) not null,
  `refid` varchar(50) not null,
  `reftype` varchar(50) not null,
  `action` varchar(50) not null,
  `orgid` varchar(50) null,
  `remote_orgid` varchar(50) null,
  `remote_orgcode` varchar(20) null,
  `remote_orgclass` varchar(20) null,
  `dtfiled` datetime not null,
  `idx` int not null,
  `sender_objid` varchar(50) null,
  `sender_name` varchar(150) null,
  primary key (`objid`)
) engine=innodb default charset=utf8
;


create index ix_sync_data_refid on sync_data(refid)
;

create index ix_sync_data_reftype on sync_data(reftype)
;

create index ix_sync_data_orgid on sync_data(orgid)
;

create index ix_sync_data_dtfiled on sync_data(dtfiled)
;



CREATE TABLE `sync_data_forprocess` (
  `objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table sync_data_forprocess add constraint `fk_sync_data_forprocess_sync_data` 
  foreign key (`objid`) references `sync_data` (`objid`)
;

CREATE TABLE `sync_data_pending` (
  `objid` varchar(50) NOT NULL,
  `error` text,
  `expirydate` datetime,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table sync_data_pending add constraint `fk_sync_data_pending_sync_data` 
  foreign key (`objid`) references `sync_data` (`objid`)
;

create index ix_expirydate on sync_data_pending(expirydate)
;







/*==================================================
*
*  BATCH GR UPDATES
*
=====================================================*/
drop view if exists vw_batchgr_error;
drop view if exists batchgr_item;
drop table if exists batchgr_log;
drop table if exists batchgr_error;
drop table if exists batchgr_items_forrevision;
drop table if exists batchgr_forprocess;
drop table if exists batchgr_item;
drop table if exists batchgr;


CREATE TABLE `batchgr` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `ry` int(255) NOT NULL,
  `lgu_objid` varchar(50) NOT NULL,
  `barangay_objid` varchar(50) NOT NULL,
  `rputype` varchar(15) DEFAULT NULL,
  `classification_objid` varchar(50) DEFAULT NULL,
  `section` varchar(10) DEFAULT NULL,
  `memoranda` varchar(100) DEFAULT NULL,
  `appraiser_name` varchar(150) DEFAULT NULL,
  `appraiser_dtsigned` date DEFAULT NULL,
  `taxmapper_name` varchar(150) DEFAULT NULL,
  `taxmapper_dtsigned` date DEFAULT NULL,
  `recommender_name` varchar(150) DEFAULT NULL,
  `recommender_dtsigned` date DEFAULT NULL,
  `approver_name` varchar(150) DEFAULT NULL,
  `approver_dtsigned` date DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create index `ix_barangay_objid` on batchgr(`barangay_objid`);
create index `ix_state` on batchgr(`state`);
create index `fk_lgu_objid` on batchgr(`lgu_objid`);

alter table batchgr add constraint `fk_barangay_objid` 
  foreign key (`barangay_objid`) references `barangay` (`objid`);
  
alter table batchgr add constraint `fk_lgu_objid` 
  foreign key (`lgu_objid`) references `sys_org` (`objid`);



CREATE TABLE `batchgr_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `rputype` varchar(15) NOT NULL,
  `tdno` varchar(50) NOT NULL,
  `fullpin` varchar(50) NOT NULL,
  `pin` varchar(50) NOT NULL,
  `suffix` int(255) NOT NULL,
  `newfaasid` varchar(50) DEFAULT NULL,
  `error` text,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create index `fk_batchgr_item_batchgr` on batchgr_item (`parent_objid`);
create index `fk_batchgr_item_newfaasid` on batchgr_item (`newfaasid`);
create index `fk_batchgr_item_tdno` on batchgr_item (`tdno`);
create index `fk_batchgr_item_pin` on batchgr_item (`pin`);


alter table batchgr_item add constraint `fk_batchgr_item_objid` 
  foreign key (`objid`) references `faas` (`objid`);

alter table batchgr_item add constraint `fk_batchgr_item_batchgr` 
  foreign key (`parent_objid`) references `batchgr` (`objid`);

alter table batchgr_item add constraint `fk_batchgr_item_newfaasid` 
  foreign key (`newfaasid`) references `faas` (`objid`);




alter table faas modify column prevtdno varchar(1000);

create index ix_prevtdno on faas(prevtdno);






create view vw_txn_log 
as 
select 
  distinct
  u.objid as userid, 
  u.name as username, 
  txndate, 
  ref,
  action, 
  1 as cnt 
from txnlog t
inner join sys_user u on t.userid = u.objid 

union 

select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'faas' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from faas_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%assign%'

union 

select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'subdivision' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from subdivision_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%assign%'

union 

select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'consolidation' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from subdivision_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%consolidation%'

union 


select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'cancelledfaas' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from subdivision_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%cancelledfaas%'
;



/*===================================================
* DELINQUENCY UPDATE 
====================================================*/


alter table report_rptdelinquency_barangay add idx int
;

update report_rptdelinquency_barangay set idx = 0 where idx is null
;


create view vw_faas_lookup
as 
SELECT 
f.*,
e.name as taxpayer_name, 
e.address_text as taxpayer_address,
pc.code AS classification_code, 
pc.code AS classcode, 
pc.name AS classification_name, 
pc.name AS classname, 
r.ry, r.rputype, r.totalmv, r.totalav,
r.totalareasqm, r.totalareaha, r.suffix, r.rpumasterid, 
rp.barangayid, rp.cadastrallotno, rp.blockno, rp.surveyno, rp.pintype, 
rp.section, rp.parcel, rp.stewardshipno, rp.pin, 
b.name AS barangay_name 
FROM faas f 
INNER JOIN faas_list fl on f.objid = fl.objid 
INNER JOIN rpu r ON f.rpuid = r.objid 
INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
INNER JOIN barangay b ON rp.barangayid = b.objid 
INNER JOIN entity e on f.taxpayer_objid = e.objid
;

drop  view if exists vw_rptpayment_item_detail
;

create view vw_rptpayment_item_detail
as 
select
  rpi.objid,
  rpi.parentid,
  rp.refid as rptledgerid, 
  rpi.rptledgerfaasid,
  rpi.year,
  rpi.qtr,
  rpi.revperiod, 
  case when rpi.revtype = 'basic' then rpi.amount else 0 end as basic,
  case when rpi.revtype = 'basic' then rpi.interest else 0 end as basicint,
  case when rpi.revtype = 'basic' then rpi.discount else 0 end as basicdisc,
  case when rpi.revtype = 'basic' then rpi.interest - rpi.discount else 0 end as basicdp,
  case when rpi.revtype = 'basic' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicnet,
  case when rpi.revtype = 'basicidle' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicidle,
  case when rpi.revtype = 'basicidle' then rpi.interest else 0 end as basicidleint,
  case when rpi.revtype = 'basicidle' then rpi.discount else 0 end as basicidledisc,
  case when rpi.revtype = 'basicidle' then rpi.interest - rpi.discount else 0 end as basicidledp,
  case when rpi.revtype = 'sef' then rpi.amount else 0 end as sef,
  case when rpi.revtype = 'sef' then rpi.interest else 0 end as sefint,
  case when rpi.revtype = 'sef' then rpi.discount else 0 end as sefdisc,
  case when rpi.revtype = 'sef' then rpi.interest - rpi.discount else 0 end as sefdp,
  case when rpi.revtype = 'sef' then rpi.amount + rpi.interest - rpi.discount else 0 end as sefnet,
  case when rpi.revtype = 'firecode' then rpi.amount + rpi.interest - rpi.discount else 0 end as firecode,
  case when rpi.revtype = 'sh' then rpi.amount + rpi.interest - rpi.discount else 0 end as sh,
  case when rpi.revtype = 'sh' then rpi.interest else 0 end as shint,
  case when rpi.revtype = 'sh' then rpi.discount else 0 end as shdisc,
  case when rpi.revtype = 'sh' then rpi.interest - rpi.discount else 0 end as shdp,
  rpi.amount + rpi.interest - rpi.discount as amount,
  rpi.partialled as partialled,
  rp.voided 
from rptpayment_item rpi
inner join rptpayment rp on rpi.parentid = rp.objid
;

drop view if exists vw_rptpayment_item 
;

create view vw_rptpayment_item 
as 
select 
    x.rptledgerid, 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    sum(x.basic) as basic,
    sum(x.basicint) as basicint,
    sum(x.basicdisc) as basicdisc,
    sum(x.basicdp) as basicdp,
    sum(x.basicnet) as basicnet,
    sum(x.basicidle) as basicidle,
    sum(x.basicidleint) as basicidleint,
    sum(x.basicidledisc) as basicidledisc,
    sum(x.basicidledp) as basicidledp,
    sum(x.sef) as sef,
    sum(x.sefint) as sefint,
    sum(x.sefdisc) as sefdisc,
    sum(x.sefdp) as sefdp,
    sum(x.sefnet) as sefnet,
    sum(x.firecode) as firecode,
    sum(x.sh) as sh,
    sum(x.shint) as shint,
    sum(x.shdisc) as shdisc,
    sum(x.shdp) as shdp,
    sum(x.amount) as amount,
    max(x.partialled) as partialled,
    x.voided 
from vw_rptpayment_item_detail x
group by 
  x.rptledgerid, 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    x.voided
;



alter table faas drop key ix_canceldate
;


alter table faas modify column canceldate date 
;

create index ix_faas_canceldate on faas(canceldate)
;




alter table machdetail modify column depreciation decimal(16,6)
;

/* 255-03001 */

-- create tables: resection and resection_item

drop table if exists resectionaffectedrpu;
drop table if exists resectionitem;
drop table if exists resection_item;
drop table if exists resection;

CREATE TABLE `resection` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `txnno` varchar(25) NOT NULL,
  `txndate` datetime NOT NULL,
  `lgu_objid` varchar(50) NOT NULL,
  `barangay_objid` varchar(50) NOT NULL,
  `pintype` varchar(3) NOT NULL,
  `section` varchar(3) NOT NULL,
  `originlgu_objid` varchar(50) NOT NULL,
  `memoranda` varchar(255) DEFAULT NULL,
  `taskid` varchar(50) DEFAULT NULL,
  `taskstate` varchar(50) DEFAULT NULL,
  `assignee_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_resection_txnno` (`txnno`),
  KEY `FK_resection_lgu_org` (`lgu_objid`),
  KEY `FK_resection_barangay_org` (`barangay_objid`),
  KEY `FK_resection_originlgu_org` (`originlgu_objid`),
  KEY `ix_resection_state` (`state`),
  CONSTRAINT `FK_resection_barangay_org` FOREIGN KEY (`barangay_objid`) REFERENCES `sys_org` (`objid`),
  CONSTRAINT `FK_resection_lgu_org` FOREIGN KEY (`lgu_objid`) REFERENCES `sys_org` (`objid`),
  CONSTRAINT `FK_resection_originlgu_org` FOREIGN KEY (`originlgu_objid`) REFERENCES `sys_org` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `resection_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `faas_objid` varchar(50) NOT NULL,
  `faas_rputype` varchar(15) NOT NULL,
  `faas_pin` varchar(25) NOT NULL,
  `faas_suffix` int(255) NOT NULL,
  `newfaas_objid` varchar(50) DEFAULT NULL,
  `newfaas_rpuid` varchar(50) DEFAULT NULL,
  `newfaas_rpid` varchar(50) DEFAULT NULL,
  `newfaas_section` varchar(3) DEFAULT NULL,
  `newfaas_parcel` varchar(3) DEFAULT NULL,
  `newfaas_suffix` int(255) DEFAULT NULL,
  `newfaas_tdno` varchar(25) DEFAULT NULL,
  `newfaas_fullpin` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_resection_item_tdno` (`newfaas_tdno`) USING BTREE,
  KEY `FK_resection_item_item` (`parent_objid`),
  KEY `FK_resection_item_faas` (`faas_objid`),
  KEY `FK_resection_item_newfaas` (`newfaas_objid`),
  KEY `ix_resection_item_fullpin` (`newfaas_fullpin`),
  CONSTRAINT `FK_resection_item_faas` FOREIGN KEY (`faas_objid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `FK_resection_item_item` FOREIGN KEY (`parent_objid`) REFERENCES `resection` (`objid`),
  CONSTRAINT `FK_resection_item_newfaas` FOREIGN KEY (`newfaas_objid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `resection_task` (
  `objid` varchar(50) NOT NULL,
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
  PRIMARY KEY (`objid`),
  KEY `ix_assignee_objid` (`assignee_objid`),
  KEY `ix_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

delete from sys_wf_transition where processname ='resection';
delete from sys_wf_node where processname ='resection';

INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('appraiser', 'resection', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('appraiser_chief', 'resection', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('approver', 'resection', 'Province Approval', 'state', '90', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('assign-appraisal-chief', 'resection', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('assign-appraiser', 'resection', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('assign-examiner', 'resection', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('assign-recommender', 'resection', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('assign-taxmapper', 'resection', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('assign-taxmapping-approval', 'resection', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('end', 'resection', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('examiner', 'resection', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('forapproval', 'resection', 'For Province Approval', 'state', '85', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('forprovapproval', 'resection', 'For Province Approval', 'state', '81', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('forprovsubmission', 'resection', 'For Province Submission', 'state', '80', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('provapprover', 'resection', 'Approved By Province', 'state', '96', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('receiver', 'resection', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('recommender', 'resection', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('start', 'resection', 'Start', 'start', '1', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('taxmapper', 'resection', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `ui`, `properties`, `tracktime`) VALUES ('taxmapper_chief', 'resection', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);


INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('appraiser', 'resection', 'returnexaminer', 'examiner', '46', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('appraiser', 'resection', 'returntaxmapper', 'taxmapper', '45', NULL, '[caption:\'Return to Taxmapper\', confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('appraiser', 'resection', 'submit', 'assign-recommender', '47', NULL, '[caption:\'Submit for Recommending Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'resection', '', 'processing-approval', '90', NULL, '[caption:\'Manually Approve\', confirm:\'Approve?\', messagehandler:\'rptmessage:approval\']', '', NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-appraiser', 'resection', '', 'appraiser', '40', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-examiner', 'resection', '', 'examiner', '10', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-recommender', 'resection', '', 'recommender', '70', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-taxmapper', 'resection', '', 'taxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'resection', 'returnreceiver', 'receiver', '15', NULL, '[caption:\'Return to Receiver\', confirm:\'Return to receiver?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'resection', 'submit', 'assign-taxmapper', '16', NULL, '[caption:\'Submit for Taxmapping\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('forprovsubmission', 'resection', 'completed', 'approver', '81', NULL, '[caption:\'Completed\', visible:false]', '', NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('forprovsubmission', 'resection', 'returnapprover', 'recommender', '80', NULL, '[caption:\'Cancel Posting\', confirm:\'Cancel posting record?\']', '', NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'resection', 'backforprovapproval', 'approver', '95', '#{data != null && data.state != \'APROVED\'}', '[caption:\'Cancel Posting\', confirm:\'Cancel posting record?\', visibleWhen=\"#{entity.state != \'APPROVED\'}\"]', '', NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'resection', 'completed', 'end', '100', NULL, '[caption:\'Approved\', visible:false]', '', NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'resection', 'delete', 'end', '6', NULL, '[caption:\'Delete\', confirm:\'Delete?\', closeonend:true]', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'resection', 'submit', 'assign-examiner', '5', NULL, '[caption:\'Submit For Examination\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('recommender', 'resection', 'returnappraiser', 'appraiser', '77', NULL, '[caption:\'Return to Appraiser\', confirm:\'Return to appraiser?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('recommender', 'resection', 'returnexaminer', 'examiner', '75', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('recommender', 'resection', 'returntaxmapper', 'taxmapper', '76', NULL, '[caption:\'Return to Taxmapper\', confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('recommender', 'resection', 'submit', 'forprovsubmission', '78', NULL, '[caption:\'Submit to Province\', confirm:\'Submit to Province?\', messagehandler:\'rptmessage:create\']', '', NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'resection', '', 'receiver', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('taxmapper', 'resection', 'returnexaminer', 'examiner', '26', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('taxmapper', 'resection', 'returnreceiver', 'receiver', '25', NULL, '[caption:\'Return to Receiver\', confirm:\'Return to receiver?\', messagehandler:\'default\']', '', NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('taxmapper', 'resection', 'submit', 'assign-appraiser', '26', NULL, '[caption:\'Submit for Appraisal\', confirm:\'Submit?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);

/* 255-03001 */
alter table rptcertification add properties text;

	
alter table faas_signatory 
    add reviewer_objid varchar(50),
    add reviewer_name varchar(100),
    add reviewer_title varchar(75),
    add reviewer_dtsigned datetime,
    add reviewer_taskid varchar(50),
    add assessor_name varchar(100),
    add assessor_title varchar(100);

alter table cancelledfaas_signatory 
    add reviewer_objid varchar(50),
    add reviewer_name varchar(100),
    add reviewer_title varchar(75),
    add reviewer_dtsigned datetime,
    add reviewer_taskid varchar(50),
    add assessor_name varchar(100),
    add assessor_title varchar(100);



    
drop table if exists rptacknowledgement_item
;
drop table if exists rptacknowledgement
;


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
  `createdby_objid` varchar(25) DEFAULT NULL,
  `createdby_name` varchar(25) DEFAULT NULL,
  `createdby_title` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_rptacknowledgement_txnno` (`txnno`),
  KEY `ix_rptacknowledgement_pin` (`pin`),
  KEY `ix_rptacknowledgement_taxpayerid` (`taxpayer_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `rptacknowledgement_item` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `trackingno` varchar(25) NULL,
  `faas_objid` varchar(50) DEFAULT NULL,
  `newfaas_objid` varchar(50) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table rptacknowledgement_item 
  add constraint fk_rptacknowledgement_item_rptacknowledgement
  foreign key (parent_objid) references rptacknowledgement(objid)
;

create index ix_rptacknowledgement_parentid on rptacknowledgement_item(parent_objid)
;

create unique index ux_rptacknowledgement_itemno on rptacknowledgement_item(trackingno)
;

create index ix_rptacknowledgement_item_faasid  on rptacknowledgement_item(faas_objid)
;

create index ix_rptacknowledgement_item_newfaasid on rptacknowledgement_item(newfaas_objid)
;

drop view if exists vw_faas_lookup 
;


CREATE view vw_faas_lookup AS 
select 
  fl.objid AS objid,
  fl.state AS state,
  fl.rpuid AS rpuid,
  fl.utdno AS utdno,
  fl.tdno AS tdno,
  fl.txntype_objid AS txntype_objid,
  fl.effectivityyear AS effectivityyear,
  fl.effectivityqtr AS effectivityqtr,
  fl.taxpayer_objid AS taxpayer_objid,
  fl.owner_name AS owner_name,
  fl.owner_address AS owner_address,
  fl.prevtdno AS prevtdno,
  fl.cancelreason AS cancelreason,
  fl.cancelledbytdnos AS cancelledbytdnos,
  fl.lguid AS lguid,
  fl.realpropertyid AS realpropertyid,
  fl.displaypin AS fullpin,
  fl.originlguid AS originlguid,
  e.name AS taxpayer_name,
  e.address_text AS taxpayer_address,
  pc.code AS classification_code,
  pc.code AS classcode,
  pc.name AS classification_name,
  pc.name AS classname,
  fl.ry AS ry,
  fl.rputype AS rputype,
  fl.totalmv AS totalmv,
  fl.totalav AS totalav,
  fl.totalareasqm AS totalareasqm,
  fl.totalareaha AS totalareaha,
  fl.barangayid AS barangayid,
  fl.cadastrallotno AS cadastrallotno,
  fl.blockno AS blockno,
  fl.surveyno AS surveyno,
  fl.pin AS pin,
  fl.barangay AS barangay_name,
  fl.trackingno
from faas_list fl
left join propertyclassification pc on fl.classification_objid = pc.objid
left join entity e on fl.taxpayer_objid = e.objid
;


alter table faas modify column prevtdno varchar(800);
alter table faas_list  
  modify column prevtdno varchar(800),
  modify column owner_name varchar(5000),
  modify column cadastrallotno varchar(900);


create index ix_faaslist_txntype_objid on faas_list(txntype_objid);



alter table rptledger modify column prevtdno varchar(800);
create index ix_rptledger_prevtdno on rptledger(prevtdno);
create index ix_rptledgerfaas_tdno on rptledgerfaas(tdno);

  
alter table rptledger modify column owner_name varchar(1500) not null;
create index ix_rptledger_owner_name on rptledger(owner_name);
  
  /* SUBLEDGER : add beneficiary info */

alter table rptledger add beneficiary_objid varchar(50);
create index ix_beneficiary_objid on rptledger(beneficiary_objid);


/* COMPROMISE UPDATE */
alter table rptcompromise_item add qtr int;

/* 255-03012 */

/*=====================================
* LEDGER TAG
=====================================*/
CREATE TABLE `rptledger_tag` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `tag` varchar(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `FK_rptledgertag_rptledger` (`parent_objid`),
  UNIQUE KEY `ux_rptledger_tag` (`parent_objid`,`tag`),
  CONSTRAINT `FK_rptledgertag_rptledger` FOREIGN KEY (`parent_objid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


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

DROP TABLE IF EXISTS `rptledger_redflag`
; 

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





/* 255-03016 */

/*================================================================
*
* RPTLEDGER REDFLAG
*
================================================================*/

DROP TABLE IF EXISTS `rptledger_redflag` 
; 

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




delete from sys_wf_transition where processname = 'batchgr';
delete from sys_wf_node where processname = 'batchgr';

INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'batchgr', 'Start', 'start', '1', NULL, 'RPT', NULL, NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'batchgr', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-examiner', 'batchgr', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('examiner', 'batchgr', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-taxmapping-approval', 'batchgr', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('taxmapper_chief', 'batchgr', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-appraisal-chief', 'batchgr', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('appraiser_chief', 'batchgr', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-recommender', 'batchgr', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('recommender', 'batchgr', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovsubmission', 'batchgr', 'For Province Submission', 'state', '80', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forprovapproval', 'batchgr', 'For Province Approval', 'state', '81', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('forapproval', 'batchgr', 'For Province Approval', 'state', '85', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'batchgr', 'Province Approval', 'state', '90', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('cityapprover', 'batchgr', 'Assessor Approval', 'state', '95', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('provapprover', 'batchgr', 'Approved By Province', 'state', '96', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL);
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('end', 'batchgr', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL);

INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('start', 'batchgr', '', 'receiver', '1', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'batchgr', 'submit', 'assign-taxmapper', '5', NULL, '[caption:\'Submit For Taxmapping\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('receiver', 'batchgr', 'delete', 'end', '6', NULL, '[caption:\'Delete\', confirm:\'Delete?\', closeonend:true]', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-examiner', 'batchgr', '', 'examiner', '10', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'batchgr', 'returnreceiver', 'receiver', '15', NULL, '[caption:\'Return to Receiver\', confirm:\'Return to receiver?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('examiner', 'batchgr', 'submit', 'assign-taxmapper', '16', NULL, '[caption:\'Submit for Taxmapping\', confirm:\'Submit?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-taxmapper', 'batchgr', '', 'taxmapper', '20', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('taxmapper', 'batchgr', 'returnreceiver', 'receiver', '25', NULL, '[caption:\'Return to Receiver\', confirm:\'Return to receiver?\', messagehandler:\'default\']', '', NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('taxmapper', 'batchgr', 'returnexaminer', 'examiner', '26', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('taxmapper', 'batchgr', 'submit', 'assign-appraiser', '26', NULL, '[caption:\'Submit for Appraisal\', confirm:\'Submit?\', messagehandler:\'rptmessage:sign\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-appraiser', 'batchgr', '', 'appraiser', '40', NULL, '[caption:\'Assign To Me\', confirm:\'Assign task to you?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('appraiser', 'batchgr', 'returntaxmapper', 'taxmapper', '45', NULL, '[caption:\'Return to Taxmapper\', confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('appraiser', 'batchgr', 'returnexaminer', 'examiner', '46', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('appraiser', 'batchgr', 'submit', 'assign-recommender', '47', NULL, '[caption:\'Submit for Recommending Approval\', confirm:\'Submit?\', messagehandler:\'rptmessage:sign\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('recommender', 'batchgr', 'returnexaminer', 'examiner', '75', NULL, '[caption:\'Return to Examiner\', confirm:\'Return to examiner?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('recommender', 'batchgr', 'returntaxmapper', 'taxmapper', '76', NULL, '[caption:\'Return to Taxmapper\', confirm:\'Return to taxmapper?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('recommender', 'batchgr', 'returnappraiser', 'appraiser', '77', NULL, '[caption:\'Return to Appraiser\', confirm:\'Return to appraiser?\', messagehandler:\'default\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('recommender', 'batchgr', 'submit', 'forprovsubmission', '78', NULL, '[caption:\'Submit to Province\', confirm:\'Submit to Province?\', messagehandler:\'rptmessage:create\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('forprovsubmission', 'batchgr', 'returnapprover', 'recommender', '80', NULL, '[caption:\'Cancel Posting\', confirm:\'Cancel posting record?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('forprovsubmission', 'batchgr', 'completed', 'approver', '81', NULL, '[caption:\'Completed\', visible:false]', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'batchgr', '', 'provapprover', '90', NULL, '[caption:\'Manually Approve Consolidation\', confirm:\'Approve?\', messagehandler:\'rptmessage:approval\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'batchgr', 'backforprovapproval', 'approver', '95', NULL, '[caption:\'Cancel Posting\', confirm:\'Cancel posting record?\']', NULL, NULL, NULL);
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('provapprover', 'batchgr', 'completed', 'end', '100', NULL, '[caption:\'Approved\', visible:false]', NULL, NULL, NULL);




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
	add toqtr int
;

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

DROP TABLE IF EXISTS `cashreceipt_rpt_share_forposting_repost` 
; 
CREATE TABLE `cashreceipt_rpt_share_forposting_repost` (
  `objid` varchar(100) NOT NULL,
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



DROP TABLE IF EXISTS `rpt_syncdata_fordownload` 
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


drop view if exists vw_newly_assessed_property 
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

drop view if exists vw_real_property_payment
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



drop view if exists vw_landtax_collection_share_detail
;

create view vw_landtax_collection_share_detail
as 
select 
  cv.objid as liquidationid,
  cv.controlno as liquidationno,
    cv.controldate as liquidationdate,
    rem.objid as remittanceid,
    rem.controlno as remittanceno,
    rem.controldate as remittancedate,
    cr.objid as receiptid,
    cr.receiptno,
    cr.receiptdate,
    cr.txndate,
    o.name as lgu,
    b.objid as barangayid,
    b.name as barangay, 
    cra.revtype,
    cra.revperiod,
    cra.sharetype,
    (case when cra.revperiod = 'current' and cra.revtype = 'basic' then cra.amount else 0 end) as brgycurr,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' then cra.amount else 0 end) as brgyprev,
    (case when cra.revtype = 'basicint' then cra.amount else 0 end) as brgypenalty,
    
    (case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgycurrshare,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgyprevshare,
    (case when cra.revtype = 'basicint' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgypenaltyshare,

    (case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype in ('city') then cra.amount else 0 end) as citycurrshare,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype in ('city') then cra.amount else 0 end) as cityprevshare,
    (case when cra.revtype = 'basicint' and cra.sharetype in ('city') then cra.amount else 0 end) as citypenaltyshare,

    (case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmunicurrshare,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmuniprevshare,
    (case when cra.revtype = 'basicint' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmunipenaltyshare,
    cra.amount,
    cra.discount
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share cra on rp.objid = cra.parentid
    left join rptledger rl on rp.refid = rl.objid
    left join sys_org o on rl.lguid = o.objid 
    left join barangay b on rl.barangayid = b.objid 
    left join cashreceipt_void crv on cr.objid = crv.receiptid 
;



drop view if exists vw_landtax_collection_share_detail_eor
;

create view vw_landtax_collection_share_detail_eor
as 
select 
rem.objid as liquidationid,
  rem.controlno as liquidationno,
    rem.controldate as liquidationdate,
    rem.objid as remittanceid,
    rem.controlno as remittanceno,
    rem.controldate as remittancedate,
    eor.objid as receiptid,
    eor.receiptno,
    eor.receiptdate,
    eor.txndate,
    o.name as lgu,
    b.objid as barangayid,
    b.name as barangay, 
    cra.revtype,
    cra.revperiod,
    cra.sharetype,
    (case when cra.revperiod = 'current' and cra.revtype = 'basic' then cra.amount else 0 end) as brgycurr,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' then cra.amount else 0 end) as brgyprev,
    (case when cra.revtype = 'basicint' then cra.amount else 0 end) as brgypenalty,
    
    (case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgycurrshare,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgyprevshare,
    (case when cra.revtype = 'basicint' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgypenaltyshare,

    (case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype in ('city') then cra.amount else 0 end) as citycurrshare,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype in ('city') then cra.amount else 0 end) as cityprevshare,
    (case when cra.revtype = 'basicint' and cra.sharetype in ('city') then cra.amount else 0 end) as citypenaltyshare,

    (case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmunicurrshare,
    (case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmuniprevshare,
    (case when cra.revtype = 'basicint' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmunipenaltyshare,
    cra.amount,
    cra.discount
from  vw_landtax_eor_remittance rem 
  inner join vw_landtax_eor eor on rem.objid = eor.remittanceid 
  inner join rptpayment rp on eor.objid = rp.receiptid 
  inner join rptpayment_share cra on rp.objid = cra.parentid
  left join rptledger rl on rp.refid = rl.objid
  left join sys_org o on rl.lguid = o.objid 
  left join barangay b on rl.barangayid = b.objid 
  left join cashreceipt_void crv on eor.objid = crv.receiptid 
;

INSERT IGNORE INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_APPROVER', 'CERTIFICATION_APPROVER', 'RPT', NULL, NULL, 'CERTIFICATION_APPROVER')
;
INSERT IGNORE INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_ISSUER', 'CERTIFICATION_ISSUER', 'RPT', 'usergroup', NULL, 'CERTIFICATION_ISSUER')
;
INSERT IGNORE INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_VERIFIER', 'RPT CERTIFICATION_VERIFIER', 'RPT', NULL, NULL, 'CERTIFICATION_VERIFIER')
;
INSERT IGNORE INTO `sys_usergroup` (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RPT.CERTIFICATION_RELEASER', 'RPT CERTIFICATION_RELEASER', 'RPT', NULL, NULL, 'CERTIFICATION_RELEASER')
;


delete from sys_wf_transition where processname ='rptcertification'
;
delete from sys_wf_node where processname ='rptcertification'
;

INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('start', 'rptcertification', 'Start', 'start', '1', NULL, NULL, NULL, '[:]', '[fillColor:\"#00ff00\",size:[32,32],pos:[102,127],type:\"start\"]', NULL)
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('receiver', 'rptcertification', 'Received', 'state', '2', NULL, 'RPT', 'CERTIFICATION_ISSUER', '[:]', '[fillColor:\"#c0c0c0\",size:[114,40],pos:[206,127],type:\"state\"]', '1')
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('verifier', 'rptcertification', 'For Verification', 'state', '3', NULL, 'RPT', 'CERTIFICATION_VERIFIER', '[:]', '[fillColor:\"#c0c0c0\",size:[129,44],pos:[412,127],type:\"state\"]', '1')
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('approver', 'rptcertification', 'For Approval', 'state', '4', NULL, 'RPT', 'CERTIFICATION_APPROVER', '[:]', '[fillColor:\"#c0c0c0\",size:[118,42],pos:[604,141],type:\"state\"]', '1')
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('assign-releaser', 'rptcertification', 'Releasing', 'state', '6', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:\"#c0c0c0\",size:[118,42],pos:[604,141],type:\"state\"]', '1')
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('releaser', 'rptcertification', 'For Release', 'state', '7', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:\"#c0c0c0\",size:[118,42],pos:[604,141],type:\"state\"]', '1')
;
INSERT INTO `sys_wf_node` (`name`, `processname`, `title`, `nodetype`, `idx`, `salience`, `domain`, `role`, `properties`, `ui`, `tracktime`) VALUES ('released', 'rptcertification', 'Released', 'end', '8', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:\"#ff0000\",size:[32,32],pos:[797,148],type:\"end\"]', '1')
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
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('approver', 'rptcertification', 'submit', 'assign-releaser', '16', NULL, '[caption:\'Approve\', confirm:\'Approve?\', messagehandler:\'rptmessage:sign\']', NULL, 'Approve', '[size:[75,0],pos:[722,162],type:\"arrow\",points:[722,162,797,162]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('assign-releaser', 'rptcertification', 'assign', 'releaser', '20', NULL, '[caption:\'Assign to Me\', confirm:\'Assign task to you?\']', NULL, 'Assign To Me', '[size:[63,4],pos:[541,152],type:\"arrow\",points:[541,152,604,156]]')
;
INSERT INTO `sys_wf_transition` (`parentid`, `processname`, `action`, `to`, `idx`, `eval`, `properties`, `permission`, `caption`, `ui`) VALUES ('releaser', 'rptcertification', 'submit', 'released', '100', '', '[caption:\'Release Certification\', confirm:\'Release certifications?\', closeonend:false, messagehandler:\'rptmessage:info\']', '', 'Release Certification', '[:]')
;



drop view if exists vw_building
; 

create view vw_building as 
select 
	f.objid,
	f.state,
	f.rpuid,
	f.realpropertyid,
	f.tdno, 
	f.fullpin, 
	f.taxpayer_objid, 
	f.owner_name, 
	f.owner_address,
	f.administrator_name,
	f.administrator_address,
	f.lguid as lgu_objid,
	o.name as lgu_name,
	b.objid as barangay_objid,
	b.name as barangay_name,
	r.classification_objid,
	pc.name as classification_name,
	rp.pin,
	rp.section,
	rp.ry, 
	rp.cadastrallotno, 
	rp.blockno, 
	rp.surveyno,
	bt.objid as bldgtype_objid,
	bt.name as bldgtype_name,
	bk.objid as bldgkind_objid,
	bk.name as bldgkind_name,
	bu.basemarketvalue,
	bu.adjustment,
	bu.depreciationvalue,
	bu.marketvalue,
	bu.assessedvalue,
	al.objid as actualuse_objid,
	al.name as actualuse_name,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv, 
	r.totalav
from faas f
	inner join rpu r on f.rpuid = r.objid 
	inner join propertyclassification pc on r.classification_objid = pc.objid
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join barangay b on rp.barangayid = b.objid 
	inner join sys_org o on f.lguid = o.objid 
	inner join bldgrpu_structuraltype bst on r.objid = bst.bldgrpuid 
	inner join bldgtype bt on bst.bldgtype_objid = bt.objid 
	inner join bldgkindbucc bucc on bst.bldgkindbucc_objid = bucc.objid 
	inner join bldgkind bk on bucc.bldgkind_objid = bk.objid 
	inner join bldguse bu on bst.objid = bu.structuraltype_objid
	inner join bldgassesslevel al on bu.actualuse_objid = al.objid 
;


drop view if exists vw_machinery
; 

create view vw_machinery as 
select 
	f.objid,
	f.state,
	f.rpuid,
	f.realpropertyid,
	f.tdno, 
	f.fullpin, 
	f.taxpayer_objid, 
	f.owner_name, 
	f.owner_address,
	f.administrator_name,
	f.administrator_address,
	f.lguid as lgu_objid,
	o.name as lgu_name,
	b.objid as barangay_objid,
	b.name as barangay_name,
	r.classification_objid,
	pc.name as classification_name,
	rp.pin,
	rp.section,
	rp.ry, 
	rp.cadastrallotno, 
	rp.blockno, 
	rp.surveyno,
	m.objid as machine_objid,
	m.name as machine_name,
	mu.basemarketvalue,
	mu.marketvalue,
	mu.assessedvalue,
	al.objid as actualuse_objid,
	al.name as actualuse_name,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv, 
	r.totalav
from faas f
	inner join rpu r on f.rpuid = r.objid 
	inner join propertyclassification pc on r.classification_objid = pc.objid
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join barangay b on rp.barangayid = b.objid 
	inner join sys_org o on f.lguid = o.objid 
	inner join machuse mu on r.objid = mu.machrpuid
	inner join machdetail md on mu.objid = md.machuseid
	inner join machine m on md.machine_objid = m.objid 
	inner join machassesslevel al on mu.actualuse_objid = al.objid 
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
  `signature` text,
  `returnedby` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`) USING BTREE,
  KEY `ix_assignee_objid` (`assignee_objid`) USING BTREE,
  CONSTRAINT `rptcertification_task_ibfk_1` FOREIGN KEY (`refid`) REFERENCES `rptcertification` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table rptcertification add taskid varchar(50)
;

DROP VIEW IF EXISTS `vw_online_rptcertification`
;
CREATE VIEW `vw_online_rptcertification` AS select `c`.`objid` AS `objid`,`c`.`txnno` AS `txnno`,`c`.`txndate` AS `txndate`,`c`.`opener` AS `opener`,`c`.`taxpayer_objid` AS `taxpayer_objid`,`c`.`taxpayer_name` AS `taxpayer_name`,`c`.`taxpayer_address` AS `taxpayer_address`,`c`.`requestedby` AS `requestedby`,`c`.`requestedbyaddress` AS `requestedbyaddress`,`c`.`certifiedby` AS `certifiedby`,`c`.`certifiedbytitle` AS `certifiedbytitle`,`c`.`official` AS `official`,`c`.`purpose` AS `purpose`,`c`.`orno` AS `orno`,`c`.`ordate` AS `ordate`,`c`.`oramount` AS `oramount`,`c`.`taskid` AS `taskid`,`t`.`state` AS `task_state`,`t`.`startdate` AS `task_startdate`,`t`.`enddate` AS `task_enddate`,`t`.`assignee_objid` AS `task_assignee_objid`,`t`.`assignee_name` AS `task_assignee_name`,`t`.`actor_objid` AS `task_actor_objid`,`t`.`actor_name` AS `task_actor_name` from (`rptcertification` `c` join `rptcertification_task` `t` on((`c`.`taskid` = `t`.`objid`)))
;



update sys_sequence set objid = CONCAT('TDNO-', objid ) where objid REGEXP('^[0-9][0-9]') = 1
;

drop TABLE if exists `faas_requested_series` 
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




drop TABLE if exists `cashreceipt_rpt_share_forposting_repost` 
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

drop TABLE if exists `faas_requested_series` 
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


/* EXAMINATION FINDING */
alter table examiner_finding add txnno varchar(25)
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

create unique index ix_txnno on examiner_finding ( txnno) 
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


alter table bldgrpu add occpermitno varchar(25)
;

alter table rpu add isonline int
;

update rpu set isonline = 0 where isonline is null 
;


drop table if exists rpt_syncdata_fordownload;
drop table if exists rpt_syncdata_forsync;
drop table if exists rpt_syncdata_error;
drop table if exists rpt_syncdata_downloaded;
drop table if exists rpt_syncdata_item;
drop table if exists rpt_syncdata;


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

CREATE TABLE `rpt_syncdata_downloaded` (
  `objid` varchar(255) NOT NULL,
  `etag` varchar(64) NOT NULL,
  `error` int(255) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_error` (`error`) USING BTREE
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


DROP TABLE if exists `rpttracking` 
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

DROP TABLE IF EXISTS `cashreceipt_rpt_share_forposting_repost`
;


CREATE TABLE `cashreceipt_rpt_share_forposting_repost` (
  `objid` varchar(50) NOT NULL,
  `rptpaymentid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `receiptdate` date NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `error` int(11) DEFAULT '0',
  `msg` text,
  `receipttype` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_receiptid_rptledgerid` (`receiptid`,`rptledgerid`) USING BTREE,
  KEY `fk_rptshare_repost_rptledgerid` (`rptledgerid`) USING BTREE,
  KEY `fk_rptshare_repost_cashreceiptid` (`receiptid`) USING BTREE,
  CONSTRAINT `cashreceipt_rpt_share_forposting_repost_ibfk_1` FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`),
  CONSTRAINT `cashreceipt_rpt_share_forposting_repost_ibfk_2` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table cancelledfaas_task add returnedby varchar(255)
;

alter table consolidation_task add returnedby varchar(255)
;

alter table faas_task add returnedby varchar(255)
;

alter table subdivision_task add returnedby varchar(255)
;

DELETE FROM itemaccount_tag where acctid like 'RPT_%';
DELETE FROM itemaccount where objid like 'RPT_%';

INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT', 'ACTIVE', '588-004', 'RPT BASIC PENALTY CURRENT', 'RPT BASIC PENALTY CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT:038-17', 'ACTIVE', '-', 'TANGALAN RPT BASIC PENALTY CURRENT', 'TANGALAN RPT BASIC PENALTY CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_BASICINT_CURRENT', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-001', 'ACTIVE', '-', 'POBLACION RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'POBLACION RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-001', 'POBLACION', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-002', 'ACTIVE', '-', 'AFGA RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'AFGA RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-002', 'AFGA', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-003', 'ACTIVE', '-', 'BAYBAY RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'BAYBAY RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-003', 'BAYBAY', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-004', 'ACTIVE', '-', 'DAPDAP RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'DAPDAP RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-004', 'DAPDAP', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-005', 'ACTIVE', '-', 'DUMATAD RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'DUMATAD RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-005', 'DUMATAD', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-006', 'ACTIVE', '-', 'JAWILI RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'JAWILI RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-006', 'JAWILI', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-007', 'ACTIVE', '-', 'LANIPGA RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'LANIPGA RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-007', 'LANIPGA', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-008', 'ACTIVE', '-', 'NAPATAG RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'NAPATAG RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-008', 'NAPATAG', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-009', 'ACTIVE', '-', 'PANAYAKAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PANAYAKAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-009', 'PANAYAKAN', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-010', 'ACTIVE', '-', 'PUDIOT RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PUDIOT RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-010', 'PUDIOT', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-011', 'ACTIVE', '-', 'TAGAS RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'TAGAS RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-011', 'TAGAS', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-012', 'ACTIVE', '-', 'TAMALAGON RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'TAMALAGON RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-012', 'TAMALAGON', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-013', 'ACTIVE', '-', 'TAMOKOE RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'TAMOKOE RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-013', 'TAMOKOE', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-014', 'ACTIVE', '-', 'TONDOG RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'TONDOG RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-014', 'TONDOG', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:038-17-015', 'ACTIVE', '-', 'VIVO RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'VIVO RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-015', 'VIVO', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'AKLAN RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038', 'AKLAN', 'RPT_BASICINT_CURRENT_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS', 'ACTIVE', '588-005', 'RPT BASIC PENALTY PREVIOUS', 'RPT BASIC PENALTY PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS:038-17', 'ACTIVE', '-', 'TANGALAN RPT BASIC PENALTY PREVIOUS', 'TANGALAN RPT BASIC PENALTY PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_BASICINT_PREVIOUS', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-001', 'ACTIVE', '-', 'POBLACION RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'POBLACION RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-001', 'POBLACION', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-002', 'ACTIVE', '-', 'AFGA RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'AFGA RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-002', 'AFGA', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-003', 'ACTIVE', '-', 'BAYBAY RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'BAYBAY RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-003', 'BAYBAY', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-004', 'ACTIVE', '-', 'DAPDAP RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'DAPDAP RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-004', 'DAPDAP', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-005', 'ACTIVE', '-', 'DUMATAD RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'DUMATAD RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-005', 'DUMATAD', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-006', 'ACTIVE', '-', 'JAWILI RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'JAWILI RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-006', 'JAWILI', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-007', 'ACTIVE', '-', 'LANIPGA RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'LANIPGA RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-007', 'LANIPGA', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-008', 'ACTIVE', '-', 'NAPATAG RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'NAPATAG RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-008', 'NAPATAG', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-009', 'ACTIVE', '-', 'PANAYAKAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PANAYAKAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-009', 'PANAYAKAN', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-010', 'ACTIVE', '-', 'PUDIOT RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PUDIOT RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-010', 'PUDIOT', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-011', 'ACTIVE', '-', 'TAGAS RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'TAGAS RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-011', 'TAGAS', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-012', 'ACTIVE', '-', 'TAMALAGON RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'TAMALAGON RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-012', 'TAMALAGON', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-013', 'ACTIVE', '-', 'TAMOKOE RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'TAMOKOE RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-013', 'TAMOKOE', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-014', 'ACTIVE', '-', 'TONDOG RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'TONDOG RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-014', 'TONDOG', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:038-17-015', 'ACTIVE', '-', 'VIVO RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'VIVO RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-015', 'VIVO', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'AKLAN RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038', 'AKLAN', 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR', 'ACTIVE', '588-006', 'RPT BASIC PENALTY PRIOR', 'RPT BASIC PENALTY PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR:038-17', 'ACTIVE', '-', 'TANGALAN RPT BASIC PENALTY PRIOR', 'TANGALAN RPT BASIC PENALTY PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_BASICINT_PRIOR', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-001', 'ACTIVE', '-', 'POBLACION RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'POBLACION RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-001', 'POBLACION', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-002', 'ACTIVE', '-', 'AFGA RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'AFGA RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-002', 'AFGA', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-003', 'ACTIVE', '-', 'BAYBAY RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'BAYBAY RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-003', 'BAYBAY', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-004', 'ACTIVE', '-', 'DAPDAP RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'DAPDAP RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-004', 'DAPDAP', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-005', 'ACTIVE', '-', 'DUMATAD RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'DUMATAD RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-005', 'DUMATAD', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-006', 'ACTIVE', '-', 'JAWILI RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'JAWILI RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-006', 'JAWILI', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-007', 'ACTIVE', '-', 'LANIPGA RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'LANIPGA RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-007', 'LANIPGA', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-008', 'ACTIVE', '-', 'NAPATAG RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'NAPATAG RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-008', 'NAPATAG', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-009', 'ACTIVE', '-', 'PANAYAKAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PANAYAKAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-009', 'PANAYAKAN', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-010', 'ACTIVE', '-', 'PUDIOT RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PUDIOT RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-010', 'PUDIOT', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-011', 'ACTIVE', '-', 'TAGAS RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'TAGAS RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-011', 'TAGAS', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-012', 'ACTIVE', '-', 'TAMALAGON RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'TAMALAGON RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-012', 'TAMALAGON', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-013', 'ACTIVE', '-', 'TAMOKOE RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'TAMOKOE RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-013', 'TAMOKOE', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-014', 'ACTIVE', '-', 'TONDOG RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'TONDOG RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-014', 'TONDOG', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:038-17-015', 'ACTIVE', '-', 'VIVO RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'VIVO RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-015', 'VIVO', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'AKLAN RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038', 'AKLAN', 'RPT_BASICINT_PRIOR_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE', 'ACTIVE', '588-007', 'RPT BASIC ADVANCE', 'RPT BASIC ADVANCE', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE:038-17', 'ACTIVE', '-', 'TANGALAN RPT BASIC ADVANCE', 'TANGALAN RPT BASIC ADVANCE', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_BASIC_ADVANCE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE BARANGAY SHARE', 'RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-001', 'ACTIVE', '-', 'POBLACION RPT BASIC ADVANCE BARANGAY SHARE', 'POBLACION RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-001', 'POBLACION', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-002', 'ACTIVE', '-', 'AFGA RPT BASIC ADVANCE BARANGAY SHARE', 'AFGA RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-002', 'AFGA', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-003', 'ACTIVE', '-', 'BAYBAY RPT BASIC ADVANCE BARANGAY SHARE', 'BAYBAY RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-003', 'BAYBAY', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-004', 'ACTIVE', '-', 'DAPDAP RPT BASIC ADVANCE BARANGAY SHARE', 'DAPDAP RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-004', 'DAPDAP', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-005', 'ACTIVE', '-', 'DUMATAD RPT BASIC ADVANCE BARANGAY SHARE', 'DUMATAD RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-005', 'DUMATAD', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-006', 'ACTIVE', '-', 'JAWILI RPT BASIC ADVANCE BARANGAY SHARE', 'JAWILI RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-006', 'JAWILI', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-007', 'ACTIVE', '-', 'LANIPGA RPT BASIC ADVANCE BARANGAY SHARE', 'LANIPGA RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-007', 'LANIPGA', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-008', 'ACTIVE', '-', 'NAPATAG RPT BASIC ADVANCE BARANGAY SHARE', 'NAPATAG RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-008', 'NAPATAG', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-009', 'ACTIVE', '-', 'PANAYAKAN RPT BASIC ADVANCE BARANGAY SHARE', 'PANAYAKAN RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-009', 'PANAYAKAN', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-010', 'ACTIVE', '-', 'PUDIOT RPT BASIC ADVANCE BARANGAY SHARE', 'PUDIOT RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-010', 'PUDIOT', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-011', 'ACTIVE', '-', 'TAGAS RPT BASIC ADVANCE BARANGAY SHARE', 'TAGAS RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-011', 'TAGAS', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-012', 'ACTIVE', '-', 'TAMALAGON RPT BASIC ADVANCE BARANGAY SHARE', 'TAMALAGON RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-012', 'TAMALAGON', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-013', 'ACTIVE', '-', 'TAMOKOE RPT BASIC ADVANCE BARANGAY SHARE', 'TAMOKOE RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-013', 'TAMOKOE', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-014', 'ACTIVE', '-', 'TONDOG RPT BASIC ADVANCE BARANGAY SHARE', 'TONDOG RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-014', 'TONDOG', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:038-17-015', 'ACTIVE', '-', 'VIVO RPT BASIC ADVANCE BARANGAY SHARE', 'VIVO RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-015', 'VIVO', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE PROVINCE SHARE', 'RPT BASIC ADVANCE PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT BASIC ADVANCE PROVINCE SHARE', 'AKLAN RPT BASIC ADVANCE PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038', 'AKLAN', 'RPT_BASIC_ADVANCE_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT', 'ACTIVE', '588-001', 'RPT BASIC CURRENT', 'RPT BASIC CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT:038-17', 'ACTIVE', '-', 'TANGALAN RPT BASIC CURRENT', 'TANGALAN RPT BASIC CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_BASIC_CURRENT', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT BARANGAY SHARE', 'RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-001', 'ACTIVE', '-', 'POBLACION RPT BASIC CURRENT BARANGAY SHARE', 'POBLACION RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-001', 'POBLACION', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-002', 'ACTIVE', '-', 'AFGA RPT BASIC CURRENT BARANGAY SHARE', 'AFGA RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-002', 'AFGA', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-003', 'ACTIVE', '-', 'BAYBAY RPT BASIC CURRENT BARANGAY SHARE', 'BAYBAY RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-003', 'BAYBAY', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-004', 'ACTIVE', '-', 'DAPDAP RPT BASIC CURRENT BARANGAY SHARE', 'DAPDAP RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-004', 'DAPDAP', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-005', 'ACTIVE', '-', 'DUMATAD RPT BASIC CURRENT BARANGAY SHARE', 'DUMATAD RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-005', 'DUMATAD', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-006', 'ACTIVE', '-', 'JAWILI RPT BASIC CURRENT BARANGAY SHARE', 'JAWILI RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-006', 'JAWILI', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-007', 'ACTIVE', '-', 'LANIPGA RPT BASIC CURRENT BARANGAY SHARE', 'LANIPGA RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-007', 'LANIPGA', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-008', 'ACTIVE', '-', 'NAPATAG RPT BASIC CURRENT BARANGAY SHARE', 'NAPATAG RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-008', 'NAPATAG', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-009', 'ACTIVE', '-', 'PANAYAKAN RPT BASIC CURRENT BARANGAY SHARE', 'PANAYAKAN RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-009', 'PANAYAKAN', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-010', 'ACTIVE', '-', 'PUDIOT RPT BASIC CURRENT BARANGAY SHARE', 'PUDIOT RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-010', 'PUDIOT', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-011', 'ACTIVE', '-', 'TAGAS RPT BASIC CURRENT BARANGAY SHARE', 'TAGAS RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-011', 'TAGAS', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-012', 'ACTIVE', '-', 'TAMALAGON RPT BASIC CURRENT BARANGAY SHARE', 'TAMALAGON RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-012', 'TAMALAGON', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-013', 'ACTIVE', '-', 'TAMOKOE RPT BASIC CURRENT BARANGAY SHARE', 'TAMOKOE RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-013', 'TAMOKOE', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-014', 'ACTIVE', '-', 'TONDOG RPT BASIC CURRENT BARANGAY SHARE', 'TONDOG RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-014', 'TONDOG', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:038-17-015', 'ACTIVE', '-', 'VIVO RPT BASIC CURRENT BARANGAY SHARE', 'VIVO RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-015', 'VIVO', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT PROVINCE SHARE', 'RPT BASIC CURRENT PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT BASIC CURRENT PROVINCE SHARE', 'AKLAN RPT BASIC CURRENT PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038', 'AKLAN', 'RPT_BASIC_CURRENT_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS', 'ACTIVE', '588-002', 'RPT BASIC PREVIOUS', 'RPT BASIC PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS:038-17', 'ACTIVE', '-', 'TANGALAN RPT BASIC PREVIOUS', 'TANGALAN RPT BASIC PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_BASIC_PREVIOUS', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-001', 'ACTIVE', '-', 'POBLACION RPT BASIC PREVIOUS BARANGAY SHARE', 'POBLACION RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-001', 'POBLACION', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-002', 'ACTIVE', '-', 'AFGA RPT BASIC PREVIOUS BARANGAY SHARE', 'AFGA RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-002', 'AFGA', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-003', 'ACTIVE', '-', 'BAYBAY RPT BASIC PREVIOUS BARANGAY SHARE', 'BAYBAY RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-003', 'BAYBAY', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-004', 'ACTIVE', '-', 'DAPDAP RPT BASIC PREVIOUS BARANGAY SHARE', 'DAPDAP RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-004', 'DAPDAP', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-005', 'ACTIVE', '-', 'DUMATAD RPT BASIC PREVIOUS BARANGAY SHARE', 'DUMATAD RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-005', 'DUMATAD', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-006', 'ACTIVE', '-', 'JAWILI RPT BASIC PREVIOUS BARANGAY SHARE', 'JAWILI RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-006', 'JAWILI', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-007', 'ACTIVE', '-', 'LANIPGA RPT BASIC PREVIOUS BARANGAY SHARE', 'LANIPGA RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-007', 'LANIPGA', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-008', 'ACTIVE', '-', 'NAPATAG RPT BASIC PREVIOUS BARANGAY SHARE', 'NAPATAG RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-008', 'NAPATAG', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-009', 'ACTIVE', '-', 'PANAYAKAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PANAYAKAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-009', 'PANAYAKAN', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-010', 'ACTIVE', '-', 'PUDIOT RPT BASIC PREVIOUS BARANGAY SHARE', 'PUDIOT RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-010', 'PUDIOT', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-011', 'ACTIVE', '-', 'TAGAS RPT BASIC PREVIOUS BARANGAY SHARE', 'TAGAS RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-011', 'TAGAS', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-012', 'ACTIVE', '-', 'TAMALAGON RPT BASIC PREVIOUS BARANGAY SHARE', 'TAMALAGON RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-012', 'TAMALAGON', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-013', 'ACTIVE', '-', 'TAMOKOE RPT BASIC PREVIOUS BARANGAY SHARE', 'TAMOKOE RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-013', 'TAMOKOE', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-014', 'ACTIVE', '-', 'TONDOG RPT BASIC PREVIOUS BARANGAY SHARE', 'TONDOG RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-014', 'TONDOG', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:038-17-015', 'ACTIVE', '-', 'VIVO RPT BASIC PREVIOUS BARANGAY SHARE', 'VIVO RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-015', 'VIVO', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'RPT BASIC PREVIOUS PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT BASIC PREVIOUS PROVINCE SHARE', 'AKLAN RPT BASIC PREVIOUS PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038', 'AKLAN', 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR', 'ACTIVE', '588-003', 'RPT BASIC PRIOR', 'RPT BASIC PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR:038-17', 'ACTIVE', '-', 'TANGALAN RPT BASIC PRIOR', 'TANGALAN RPT BASIC PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_BASIC_PRIOR', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR BARANGAY SHARE', 'RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-001', 'ACTIVE', '-', 'POBLACION RPT BASIC PRIOR BARANGAY SHARE', 'POBLACION RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-001', 'POBLACION', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-002', 'ACTIVE', '-', 'AFGA RPT BASIC PRIOR BARANGAY SHARE', 'AFGA RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-002', 'AFGA', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-003', 'ACTIVE', '-', 'BAYBAY RPT BASIC PRIOR BARANGAY SHARE', 'BAYBAY RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-003', 'BAYBAY', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-004', 'ACTIVE', '-', 'DAPDAP RPT BASIC PRIOR BARANGAY SHARE', 'DAPDAP RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-004', 'DAPDAP', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-005', 'ACTIVE', '-', 'DUMATAD RPT BASIC PRIOR BARANGAY SHARE', 'DUMATAD RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-005', 'DUMATAD', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-006', 'ACTIVE', '-', 'JAWILI RPT BASIC PRIOR BARANGAY SHARE', 'JAWILI RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-006', 'JAWILI', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-007', 'ACTIVE', '-', 'LANIPGA RPT BASIC PRIOR BARANGAY SHARE', 'LANIPGA RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-007', 'LANIPGA', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-008', 'ACTIVE', '-', 'NAPATAG RPT BASIC PRIOR BARANGAY SHARE', 'NAPATAG RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-008', 'NAPATAG', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-009', 'ACTIVE', '-', 'PANAYAKAN RPT BASIC PRIOR BARANGAY SHARE', 'PANAYAKAN RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-009', 'PANAYAKAN', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-010', 'ACTIVE', '-', 'PUDIOT RPT BASIC PRIOR BARANGAY SHARE', 'PUDIOT RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-010', 'PUDIOT', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-011', 'ACTIVE', '-', 'TAGAS RPT BASIC PRIOR BARANGAY SHARE', 'TAGAS RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-011', 'TAGAS', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-012', 'ACTIVE', '-', 'TAMALAGON RPT BASIC PRIOR BARANGAY SHARE', 'TAMALAGON RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-012', 'TAMALAGON', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-013', 'ACTIVE', '-', 'TAMOKOE RPT BASIC PRIOR BARANGAY SHARE', 'TAMOKOE RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-013', 'TAMOKOE', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-014', 'ACTIVE', '-', 'TONDOG RPT BASIC PRIOR BARANGAY SHARE', 'TONDOG RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-014', 'TONDOG', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:038-17-015', 'ACTIVE', '-', 'VIVO RPT BASIC PRIOR BARANGAY SHARE', 'VIVO RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038-17-015', 'VIVO', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR PROVINCE SHARE', 'RPT BASIC PRIOR PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT BASIC PRIOR PROVINCE SHARE', 'AKLAN RPT BASIC PRIOR PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '038', 'AKLAN', 'RPT_BASIC_PRIOR_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_CURRENT', 'ACTIVE', '455-050', 'RPT SEF PENALTY CURRENT', 'RPT SEF PENALTY CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_CURRENT:038-17', 'ACTIVE', '-', 'TANGALAN RPT SEF PENALTY CURRENT', 'TANGALAN RPT SEF PENALTY CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_SEFINT_CURRENT', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'RPT SEF CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_CURRENT_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT SEF CURRENT PENALTY PROVINCE SHARE', 'AKLAN RPT SEF CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038', 'AKLAN', 'RPT_SEFINT_CURRENT_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PENALTY PREVIOUS', 'RPT SEF PENALTY PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PREVIOUS:038-17', 'ACTIVE', '-', 'TANGALAN RPT SEF PENALTY PREVIOUS', 'TANGALAN RPT SEF PENALTY PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_SEFINT_PREVIOUS', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PREVIOUS_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'AKLAN RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038', 'AKLAN', 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PENALTY PRIOR', 'RPT SEF PENALTY PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PRIOR:038-17', 'ACTIVE', '-', 'TANGALAN RPT SEF PENALTY PRIOR', 'TANGALAN RPT SEF PENALTY PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_SEFINT_PRIOR', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'RPT SEF PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PRIOR_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT SEF PRIOR PENALTY PROVINCE SHARE', 'AKLAN RPT SEF PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038', 'AKLAN', 'RPT_SEFINT_PRIOR_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_ADVANCE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE', 'RPT SEF ADVANCE', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_ADVANCE:038-17', 'ACTIVE', '-', 'TANGALAN RPT SEF ADVANCE', 'TANGALAN RPT SEF ADVANCE', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_SEF_ADVANCE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_ADVANCE_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE PROVINCE SHARE', 'RPT SEF ADVANCE PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_ADVANCE_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT SEF ADVANCE PROVINCE SHARE', 'AKLAN RPT SEF ADVANCE PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038', 'AKLAN', 'RPT_SEF_ADVANCE_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_CURRENT', 'ACTIVE', '455-050', 'RPT SEF CURRENT', 'RPT SEF CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_CURRENT:038-17', 'ACTIVE', '-', 'TANGALAN RPT SEF CURRENT', 'TANGALAN RPT SEF CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_SEF_CURRENT', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_CURRENT_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT PROVINCE SHARE', 'RPT SEF CURRENT PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_CURRENT_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT SEF CURRENT PROVINCE SHARE', 'AKLAN RPT SEF CURRENT PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038', 'AKLAN', 'RPT_SEF_CURRENT_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS', 'RPT SEF PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PREVIOUS:038-17', 'ACTIVE', '-', 'TANGALAN RPT SEF PREVIOUS', 'TANGALAN RPT SEF PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_SEF_PREVIOUS', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PREVIOUS_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS PROVINCE SHARE', 'RPT SEF PREVIOUS PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PREVIOUS_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT SEF PREVIOUS PROVINCE SHARE', 'AKLAN RPT SEF PREVIOUS PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038', 'AKLAN', 'RPT_SEF_PREVIOUS_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PRIOR', 'RPT SEF PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PRIOR:038-17', 'ACTIVE', '-', 'TANGALAN RPT SEF PRIOR', 'TANGALAN RPT SEF PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038-17', 'TANGALAN', 'RPT_SEF_PRIOR', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PRIOR_PROVINCE_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR PROVINCE SHARE', 'RPT SEF PRIOR PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL, '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PRIOR_PROVINCE_SHARE:038', 'ACTIVE', '-', 'AKLAN RPT SEF PRIOR PROVINCE SHARE', 'AKLAN RPT SEF PRIOR PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '038', 'AKLAN', 'RPT_SEF_PRIOR_PROVINCE_SHARE', '0', '0', '0');


set foreign_key_checks = 0;
delete from sys_rule_action_param where parentid in ( 
  select ra.objid 
  from sys_rule r, sys_rule_action ra 
  where r.ruleset in (
        select name  from sys_ruleset where domain in ('landtax')
    ) and ra.parentid=r.objid 
)
;

delete from sys_rule_actiondef_param where parentid in ( 
  select ra.objid from sys_ruleset_actiondef rsa 
    inner join sys_rule_actiondef ra on ra.objid=rsa.actiondef 
  where rsa.ruleset in (
        select name  from sys_ruleset where domain in ('landtax')
    )
);

delete from sys_rule_actiondef where objid in ( 
  select actiondef from sys_ruleset_actiondef where ruleset in (
        select name  from sys_ruleset where domain in ('landtax')
    )
);

delete from sys_rule_action where parentid in ( 
  select objid from sys_rule 
  where ruleset in (
        select name  from sys_ruleset where domain in ('landtax')
    )
)
;

delete from sys_rule_condition_constraint where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset in (
        select name  from sys_ruleset where domain in ('landtax')
    ) and rc.parentid=r.objid 
)
;

delete from sys_rule_condition_var where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset in (
        select name  from sys_ruleset where domain in ('landtax')
    ) and rc.parentid=r.objid 
)
;

delete from sys_rule_condition where parentid in ( 
  select objid from sys_rule where ruleset in (
        select name  from sys_ruleset where domain in ('landtax')
    )
)
;


delete from sys_rule_fact_field where parentid in (
	select objid from sys_rule_fact where domain in ('landtax')
)
;

delete  from sys_rule_fact where domain in ('landtax')
;

delete from sys_rule_deployed where objid in ( 
  select objid from sys_rule where ruleset in (
        select name  from sys_ruleset where domain in ('landtax')
    )
    
)
;

delete from sys_rule where ruleset in (
    select name  from sys_ruleset where domain in ('landtax')
)
;

delete from sys_ruleset_fact where ruleset in (
    select name  from sys_ruleset where domain in ('landtax')
)
;


delete from sys_ruleset_actiondef where ruleset in (
    select name  from sys_ruleset where domain in ('landtax')
)
;

delete from sys_rulegroup where ruleset in (
    select name  from sys_ruleset where domain in ('landtax')
)
;

delete from sys_ruleset where domain in ('landtax')
;






INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('rptbilling', 'RPT Billing Rules', 'rptbilling', 'LANDTAX', 'RULE_AUTHOR', NULL);
INSERT INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('rptledger', 'Ledger Billing Rules', 'rptledger', 'LANDTAX', 'RULE_AUTHOR', NULL);
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_DISCOUNT', 'rptbilling', 'After Discount Computation', '10');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_PENALTY', 'rptbilling', 'After Penalty Computation', '8');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_SUMMARY', 'rptbilling', 'After Summary', '21');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('AFTER_TAX', 'rptledger', 'Post Tax Computation', '3');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BEFORE_SUMMARY', 'rptbilling', 'Before Summary ', '19');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('BRGY_SHARE', 'rptbilling', 'Barangay Share Computation', '25');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('DISCOUNT', 'rptbilling', 'Discount Computation', '9');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('INIT', 'rptbilling', 'Init', '0');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('INIT', 'rptledger', 'Init', '0');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('LEDGER_ITEM', 'rptledger', 'Ledger Item Posting', '1');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('LGU_SHARE', 'rptbilling', 'LGU Share Computation', '26');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('PENALTY', 'rptbilling', 'Penalty Computation', '7');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('PROV_SHARE', 'rptbilling', 'Province Share Computation', '27');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('SUMMARY', 'rptbilling', 'Summary', '20');
INSERT INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('TAX', 'rptledger', 'Tax Computation', '2');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddBasic');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.AddBillItem');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddFireCode');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddIdleLand');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddSef');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.AddShare');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.AddSocialHousing');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.AggregateLedgerItem');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.CalcDiscount');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.CalcInterest');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.CalcTax');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.CreateTaxSummary');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.RemoveLedgerItem');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.SetBillExpiryDate');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.SplitByQtr');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptbilling', 'rptis.landtax.actions.SplitLedgerItem');
INSERT INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('rptledger', 'rptis.landtax.actions.UpdateAV');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'CurrentDate');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.AssessedValue');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.Bill');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.Classification');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTBillItem');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTIncentive');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTLedgerFaasFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.RPTLedgerFaasFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTLedgerFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.RPTLedgerFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTLedgerItemFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptledger', 'rptis.landtax.facts.RPTLedgerItemFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTLedgerTag');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact');
INSERT INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('rptbilling', 'rptis.landtax.facts.ShareFact');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL-1a2d6e9b:1692d429304:-7779', 'DEPLOYED', 'BASIC_AND_SEF', 'rptledger', 'LEDGER_ITEM', 'BASIC_AND_SEF', NULL, '50000', NULL, NULL, '2019-02-27 12:48:06', 'USR-12b70fa0:16929d068ad:-7e8e', 'LANDTAX', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL-202aff7b:17c72f23ba6:-7d96', 'DEPLOYED', 'BACKTAX_ADJ', 'rptbilling', 'AFTER_DISCOUNT', 'BACKTAX ADJ', NULL, '50000', NULL, NULL, '2021-10-12 13:22:52', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL-2ede6703:16642adb9ce:-7ba0', 'DEPLOYED', 'EXPIRY_ADVANCE_BILLING', 'rptbilling', 'BEFORE_SUMMARY', 'EXPIRY ADVANCE BILLING', NULL, '5000', NULL, NULL, '2018-10-05 01:28:47', 'USR6bd70b1f:1662cdef89a:-7e3e', 'RAMESES', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL-33da6907:174edfc7b14:-7bf9', 'DEPLOYED', 'PENALTY_1991_AND_BELOW', 'rptbilling', 'PENALTY', 'PENALTY 1991 AND BELOW', NULL, '50000', NULL, NULL, '2020-10-03 18:29:36', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL-7e4e8460:17d364033db:-7031', 'DEPLOYED', 'SPLIT_QTR2', 'rptbilling', 'INIT', 'SPLIT_QTR', NULL, '50000', NULL, NULL, '2021-11-19 11:33:37', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL-7eb5c285:1795f11dd49:-3b2d', 'DRAFT', 'ADJUST_AGR_AV_FOR_2018_AND_ABOVE', 'rptledger', 'INIT', 'ADJUST AGR AV FOR 2018 AND ABOVE', NULL, '50000', NULL, NULL, '2021-05-12 13:54:47', 'USR6ebf7e79:156baa1135d:-7f9b', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL-81eaa11:1795f0e54a0:-7e70', 'DRAFT', 'ADJUST_RES_AV_FOR_2018_AND_ABOVE', 'rptledger', 'INIT', 'ADJUST RES AV FOR 2018 AND ABOVE', NULL, '50000', NULL, NULL, '2021-05-12 13:32:11', 'USR6ebf7e79:156baa1135d:-7f9b', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL-8fbba9f:18007eb90b8:-72fb', 'DEPLOYED', 'NO_DISCOUNT_MISSED_PAYMENT', 'rptbilling', 'AFTER_DISCOUNT', 'NO DISCOUNT MISSED PAYMENT', NULL, '50000', NULL, NULL, '2022-04-08 16:42:53', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL1262ad19:166ae41b1fb:-7c88', 'DEPLOYED', 'TOTAL_PREVIOUS', 'rptbilling', 'SUMMARY', 'TOTAL PREVIOUS', NULL, '50000', NULL, NULL, '2018-10-25 22:55:00', 'USR6de55768:158e0e57805:-74f2', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL1a44b27e:16955ccf41e:e9f', 'DEPLOYED', 'DISCOUNT_CURRENT_QTRLY', 'rptbilling', 'DISCOUNT', 'DISCOUNT_CURRENT_QTRLY', NULL, '45000', NULL, NULL, '2019-03-07 10:28:05', 'USR-12b70fa0:16929d068ad:-7e8e', 'LANDTAX', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL2d3df8d1:17d2c8f0d4d:-7a00', 'DEPLOYED', 'IDLE_LAND_TAX', 'rptledger', 'TAX', 'IDLE LAND TAX', NULL, '50000', NULL, NULL, '2021-11-17 14:28:16', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL2d3df8d1:17d2c8f0d4d:-7e00', 'DEPLOYED', 'IDLE_LAND', 'rptledger', 'LEDGER_ITEM', 'IDLE LAND', NULL, '50000', NULL, NULL, '2021-11-17 14:25:34', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL34b884c7:17ff889c416:-7bf9', 'DEPLOYED', 'UNDER_CARP_ADJUSTMENT', 'rptbilling', 'AFTER_PENALTY', 'UNDER CARP ADJUSTMENT', NULL, '50000', NULL, NULL, '2022-04-05 15:22:22', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL3e7cce43:16b25a6ae3b:-2657', 'DEPLOYED', 'PENALTY_1992_TO_LESS_CY', 'rptbilling', 'PENALTY', 'PENALTY_1992_TO_LESS_CY', NULL, '50000', NULL, NULL, '2019-06-05 03:46:36', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL483027b0:16be9375c61:-77e6', 'DEPLOYED', 'BASIC_AND_SEF_TAX', 'rptledger', 'TAX', 'BASIC AND SEF TAX', NULL, '50000', NULL, NULL, '2019-07-13 10:51:37', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL49c6281:17b4dac24e2:-7e37', 'DEPLOYED', 'TOTAL_PRIOR', 'rptbilling', 'SUMMARY', 'TOTAL PRIOR', NULL, '50000', NULL, NULL, '2021-08-16 14:58:10', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RUL7e02b404:166ae687f42:-5511', 'DEPLOYED', 'PENALTY_CURRENT_YEAR', 'rptbilling', 'PENALTY', 'PENALTY_CURRENT_YEAR', NULL, '50000', NULL, NULL, '2018-10-25 23:53:42', 'USR6de55768:158e0e57805:-74f2', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RULec9d7ab:166235c2e16:-255e', 'DEPLOYED', 'BUILD_BILL_ITEMS', 'rptbilling', 'AFTER_SUMMARY', 'BUILD BILL ITEMS', NULL, '50000', NULL, NULL, '2018-09-29 00:27:14', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RULec9d7ab:166235c2e16:-26bf', 'DEPLOYED', 'TOTAL_ADVANCE', 'rptbilling', 'SUMMARY', 'TOTAL ADVANCE', NULL, '50000', NULL, NULL, '2018-09-29 00:26:00', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RULec9d7ab:166235c2e16:-26d0', 'DEPLOYED', 'TOTAL_CURRENT', 'rptbilling', 'SUMMARY', 'TOTAL_CURRENT', NULL, '50000', NULL, NULL, '2018-09-29 00:25:49', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RULec9d7ab:166235c2e16:-2f1f', 'DEPLOYED', 'EXPIRY_DATE_DEFAULT', 'rptbilling', 'BEFORE_SUMMARY', 'EXPIRY DATE DEFAULT', NULL, '10000', NULL, NULL, '2018-09-29 00:17:38', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RULec9d7ab:166235c2e16:-319f', 'DEPLOYED', 'EXPIRY_DATE_ADVANCE_YEAR', 'rptbilling', 'BEFORE_SUMMARY', 'EXPIRY_DATE_ADVANCE_YEAR', NULL, '5000', NULL, NULL, '2018-09-29 00:14:01', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RULec9d7ab:166235c2e16:-3811', 'DEPLOYED', 'SPLIT_QUARTERLY_BILLED_ITEMS', 'rptbilling', 'BEFORE_SUMMARY', 'SPLIT QUARTERLY BILLED ITEMS', NULL, '50000', NULL, NULL, '2018-09-29 00:07:10', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RULec9d7ab:166235c2e16:-3c17', 'DEPLOYED', 'AGGREGATE_PREVIOUS_ITEMS', 'rptbilling', 'BEFORE_SUMMARY', 'AGGREGATE PREVIOUS ITEMS', NULL, '60000', NULL, NULL, '2018-09-29 00:05:33', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RULec9d7ab:166235c2e16:-4197', 'DEPLOYED', 'DISCOUNT_ADVANCE', 'rptbilling', 'DISCOUNT', 'DISCOUNT_ADVANCE', NULL, '40000', NULL, NULL, '2018-09-29 00:02:22', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule` (`objid`, `state`, `name`, `ruleset`, `rulegroup`, `title`, `description`, `salience`, `effectivefrom`, `effectiveto`, `dtfiled`, `user_objid`, `user_name`, `noloop`) VALUES ('RULec9d7ab:166235c2e16:-5fcb', 'APPROVED', 'SPLIT_QTR', 'rptbilling', 'INIT', 'SPLIT_QTR', NULL, '50000', NULL, NULL, '2018-09-28 23:48:57', 'USR-ADMIN', 'ADMIN', '1');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-1a2d6e9b:1692d429304:-7779', '\npackage rptledger.BASIC_AND_SEF;\nimport rptledger.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BASIC_AND_SEF\"\n	agenda-group \"LEDGER_ITEM\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		AVINFO: rptis.landtax.facts.AssessedValue (  YR:year,AV:av ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"AVINFO\", AVINFO );\n		\n		bindings.put(\"YR\", YR );\n		\n		bindings.put(\"AV\", AV );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"avfact\", AVINFO );\r\n_p0.put( \"year\", YR );\r\n_p0.put( \"av\", (new ActionExpression(\"AV\", bindings)) );\r\naction.execute( \"add-sef\",_p0,drools);\r\nMap _p1 = new HashMap();\r\n_p1.put( \"avfact\", AVINFO );\r\n_p1.put( \"year\", YR );\r\n_p1.put( \"av\", (new ActionExpression(\"AV\", bindings)) );\r\naction.execute( \"add-basic\",_p1,drools);\r\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-202aff7b:17c72f23ba6:-7d96', '\npackage rptbilling.BACKTAX_ADJ;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BACKTAX_ADJ\"\n	agenda-group \"AFTER_DISCOUNT\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  backtax == true  ) \n		\n		RLF: rptis.landtax.facts.RPTLedgerFaasFact (  fromyear >= CY,txntype matches \"ND\" ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLF\", RLF );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"0\", bindings)) );\r\naction.execute( \"calc-interest\",_p0,drools);\r\nMap _p1 = new HashMap();\r\n_p1.put( \"rptledgeritem\", RLI );\r\n_p1.put( \"expr\", (new ActionExpression(\"0\", bindings)) );\r\naction.execute( \"calc-discount\",_p1,drools);\r\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-2ede6703:16642adb9ce:-7ba0', '\npackage rptbilling.EXPIRY_ADVANCE_BILLING;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"EXPIRY_ADVANCE_BILLING\"\n	agenda-group \"BEFORE_SUMMARY\"\n	salience 5000\n	no-loop\n	when\n		\n		\n		BILL: rptis.landtax.facts.Bill (  advancebill == true ,BILLDATE:billdate ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"BILL\", BILL );\n		\n		bindings.put(\"BILLDATE\", BILLDATE );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"bill\", BILL );\n_p0.put( \"expr\", (new ActionExpression(\"@MONTHEND( BILLDATE )\", bindings)) );\naction.execute( \"set-bill-expiry\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-33da6907:174edfc7b14:-7bf9', '\npackage rptbilling.PENALTY_1991_AND_BELOW;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"PENALTY_1991_AND_BELOW\"\n	agenda-group \"PENALTY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year <= 1991,NMON:monthsfromjan,TAX:amtdue ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"NMON\", NMON );\n		\n		bindings.put(\"TAX\", TAX );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND(TAX * 0.24)\", bindings)) );\naction.execute( \"calc-interest\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-7e4e8460:17d364033db:-7031', '\npackage rptbilling.SPLIT_QTR2;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"SPLIT_QTR2\"\n	agenda-group \"INIT\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CY ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\naction.execute( \"split-by-qtr\",_p0,drools);\r\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL-8fbba9f:18007eb90b8:-72fb', '\npackage rptbilling.NO_DISCOUNT_MISSED_PAYMENT;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"NO_DISCOUNT_MISSED_PAYMENT\"\n	agenda-group \"AFTER_DISCOUNT\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RL: rptis.landtax.facts.RPTLedgerFact (  missedpayment == true  ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CY ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RL\", RL );\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"0\", bindings)) );\r\naction.execute( \"calc-discount\",_p0,drools);\r\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL1262ad19:166ae41b1fb:-7c88', '\npackage rptbilling.TOTAL_PREVIOUS;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOTAL_PREVIOUS\"\n	agenda-group \"SUMMARY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year < CY,year > 1992 ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"revperiod\", \"previous\" );\r\naction.execute( \"create-tax-summary\",_p0,drools);\r\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL1a44b27e:16955ccf41e:e9f', '\npackage rptbilling.DISCOUNT_CURRENT_QTRLY;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"DISCOUNT_CURRENT_QTRLY\"\n	agenda-group \"DISCOUNT\"\n	salience 45000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CQTR:qtr,CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CY,TAX:amtdue,qtr >= CQTR ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CQTR\", CQTR );\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"TAX\", TAX );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND(TAX * 0.10)\", bindings)) );\naction.execute( \"calc-discount\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL2d3df8d1:17d2c8f0d4d:-7a00', '\npackage rptledger.IDLE_LAND_TAX;\nimport rptledger.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"IDLE_LAND_TAX\"\n	agenda-group \"TAX\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  AV:av,revtype matches \"basicidle\" ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"AV\", AV );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"AV * 0.05\", bindings)) );\r\naction.execute( \"calc-tax\",_p0,drools);\r\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL2d3df8d1:17d2c8f0d4d:-7e00', '\npackage rptledger.IDLE_LAND;\nimport rptledger.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"IDLE_LAND\"\n	agenda-group \"LEDGER_ITEM\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		AVINFO: rptis.landtax.facts.AssessedValue (  YR:year,AV:av,idleland == true  ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"AVINFO\", AVINFO );\n		\n		bindings.put(\"YR\", YR );\n		\n		bindings.put(\"AV\", AV );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"avfact\", AVINFO );\r\n_p0.put( \"year\", YR );\r\n_p0.put( \"av\", (new ActionExpression(\"AV\", bindings)) );\r\naction.execute( \"add-basicidle\",_p0,drools);\r\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL34b884c7:17ff889c416:-7bf9', '\npackage rptbilling.UNDER_CARP_ADJUSTMENT;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"UNDER_CARP_ADJUSTMENT\"\n	agenda-group \"AFTER_PENALTY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 rptis.landtax.facts.RPTLedgerTag (  tag matches \"UNDER_CARP\" ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year < 2021 ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLI\", RLI );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"expr\", (new ActionExpression(\"0\", bindings)) );\r\naction.execute( \"calc-interest\",_p0,drools);\r\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL3e7cce43:16b25a6ae3b:-2657', '\npackage rptbilling.PENALTY_1992_TO_LESS_CY;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"PENALTY_1992_TO_LESS_CY\"\n	agenda-group \"PENALTY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year < CY,NMON:monthsfromjan,year >= 1992,TAX:amtdue ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"NMON\", NMON );\n		\n		bindings.put(\"TAX\", TAX );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND(@IIF( NMON * 0.02 > 0.72, TAX * 0.72, TAX * NMON * 0.02))\", bindings)) );\naction.execute( \"calc-interest\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL483027b0:16be9375c61:-77e6', '\npackage rptledger.BASIC_AND_SEF_TAX;\nimport rptledger.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BASIC_AND_SEF_TAX\"\n	agenda-group \"TAX\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  AV:av,revtype matches \"basic|sef\" ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"AV\", AV );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\n_p0.put( \"expr\", (new ActionExpression(\"AV * 0.01\", bindings)) );\naction.execute( \"calc-tax\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL49c6281:17b4dac24e2:-7e37', '\npackage rptbilling.TOTAL_PRIOR;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOTAL_PRIOR\"\n	agenda-group \"SUMMARY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year <= 1991 ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n	Map _p0 = new HashMap();\r\n_p0.put( \"rptledgeritem\", RLI );\r\n_p0.put( \"revperiod\", \"prior\" );\r\naction.execute( \"create-tax-summary\",_p0,drools);\r\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RUL7e02b404:166ae687f42:-5511', '\npackage rptbilling.PENALTY_CURRENT_YEAR;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"PENALTY_CURRENT_YEAR\"\n	agenda-group \"PENALTY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year,CQTR:qtr > 1 ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  revtype matches \"basic|sef\",year == CY,qtr < CQTR,TAX:amtdue,NMON:monthsfromjan ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"CQTR\", CQTR );\n		\n		bindings.put(\"NMON\", NMON );\n		\n		bindings.put(\"TAX\", TAX );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\n_p0.put( \"expr\", (new ActionExpression(\"TAX * NMON * 0.02\", bindings)) );\naction.execute( \"calc-interest\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-255e', '\npackage rptbilling.BUILD_BILL_ITEMS;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"BUILD_BILL_ITEMS\"\n	agenda-group \"AFTER_SUMMARY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		RLTS: rptis.landtax.facts.RPTLedgerTaxSummaryFact (   ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLTS\", RLTS );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"taxsummary\", RLTS );\naction.execute( \"add-billitem\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-26bf', '\npackage rptbilling.TOTAL_ADVANCE;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOTAL_ADVANCE\"\n	agenda-group \"SUMMARY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year > CY ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\n_p0.put( \"revperiod\", \"advance\" );\naction.execute( \"create-tax-summary\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-26d0', '\npackage rptbilling.TOTAL_CURRENT;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOTAL_CURRENT\"\n	agenda-group \"SUMMARY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year == CY ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\n_p0.put( \"revperiod\", \"current\" );\naction.execute( \"create-tax-summary\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-2f1f', '\npackage rptbilling.EXPIRY_DATE_DEFAULT;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"EXPIRY_DATE_DEFAULT\"\n	agenda-group \"BEFORE_SUMMARY\"\n	salience 10000\n	no-loop\n	when\n		\n		\n		BILL: rptis.landtax.facts.Bill (  CDATE:currentdate ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"BILL\", BILL );\n		\n		bindings.put(\"CDATE\", CDATE );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"bill\", BILL );\n_p0.put( \"expr\", (new ActionExpression(\"@MONTHEND( CDATE )\", bindings)) );\naction.execute( \"set-bill-expiry\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-319f', '\npackage rptbilling.EXPIRY_DATE_ADVANCE_YEAR;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"EXPIRY_DATE_ADVANCE_YEAR\"\n	agenda-group \"BEFORE_SUMMARY\"\n	salience 5000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RL: rptis.landtax.facts.RPTLedgerFact (  lastyearpaid == CY,lastqtrpaid == 4 ) \n		\n		BILL: rptis.landtax.facts.Bill (  billtoyear > CY ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RL\", RL );\n		\n		bindings.put(\"BILL\", BILL );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"bill\", BILL );\n_p0.put( \"expr\", (new ActionExpression(\"@MONTHEND(@DATE(CY, 12, 1));\", bindings)) );\naction.execute( \"set-bill-expiry\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-3811', '\npackage rptbilling.SPLIT_QUARTERLY_BILLED_ITEMS;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"SPLIT_QUARTERLY_BILLED_ITEMS\"\n	agenda-group \"BEFORE_SUMMARY\"\n	salience 50000\n	no-loop\n	when\n		\n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  qtrly == false ,revtype matches \"basic|sef\" ) \n		\n		BILL: rptis.landtax.facts.Bill (  forpayment == true  ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"BILL\", BILL );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\naction.execute( \"split-bill-item\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-3c17', '\npackage rptbilling.AGGREGATE_PREVIOUS_ITEMS;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"AGGREGATE_PREVIOUS_ITEMS\"\n	agenda-group \"BEFORE_SUMMARY\"\n	salience 60000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year < CY,qtrly == true  ) \n		\n		BILL: rptis.landtax.facts.Bill (  forpayment == false  ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"BILL\", BILL );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\naction.execute( \"aggregate-bill-item\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_deployed` (`objid`, `ruletext`) VALUES ('RULec9d7ab:166235c2e16:-4197', '\npackage rptbilling.DISCOUNT_ADVANCE;\nimport rptbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"DISCOUNT_ADVANCE\"\n	agenda-group \"DISCOUNT\"\n	salience 40000\n	no-loop\n	when\n		\n		\n		 CurrentDate (  CY:year ) \n		\n		RLI: rptis.landtax.facts.RPTLedgerItemFact (  year > CY,TAX:amtdue ) \n		\n	then\n		Map bindings = new HashMap();\n		\n		bindings.put(\"CY\", CY );\n		\n		bindings.put(\"RLI\", RLI );\n		\n		bindings.put(\"TAX\", TAX );\n		\n	Map _p0 = new HashMap();\n_p0.put( \"rptledgeritem\", RLI );\n_p0.put( \"expr\", (new ActionExpression(\"@ROUND(TAX * 0.20)\", bindings)) );\naction.execute( \"calc-discount\",_p0,drools);\n\nend\n\n\n	');
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('CurrentDate', 'CurrentDate', 'Current Date', 'CurrentDate', '1', '', '', NULL, '', '', '', '', '', '', 'LANDTAX', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.AssessedValue', 'rptis.landtax.facts.AssessedValue', 'Assessed Value', 'rptis.landtax.facts.AssessedValue', '2', NULL, 'AVINFO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'Bill', 'rptis.landtax.facts.Bill', '2', NULL, 'BILL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.Classification', 'rptis.landtax.facts.Classification', 'Classification', 'rptis.landtax.facts.Classification', '0', NULL, 'CLASS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTBillItem', 'rptis.landtax.facts.RPTBillItem', 'Bill Item', 'rptis.landtax.facts.RPTBillItem', '3', NULL, 'BILLITEM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTIncentive', 'rptis.landtax.facts.RPTIncentive', 'Incentive', 'rptis.landtax.facts.RPTIncentive', '10', NULL, 'INCENTIVE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTLedgerFaasFact', 'rptis.landtax.facts.RPTLedgerFaasFact', 'Ledger FAAS', 'rptis.landtax.facts.RPTLedgerFaasFact', '10', NULL, 'RLF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'LANDTAX', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTLedgerFact', 'rptis.landtax.facts.RPTLedgerFact', 'Ledger', 'rptis.landtax.facts.RPTLedgerFact', '5', NULL, 'RL', '0', '', '', '', '', '', NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'Ledger Item', 'rptis.landtax.facts.RPTLedgerItemFact', '6', NULL, 'RLI', NULL, '', '', '', '', '', NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTLedgerTag', 'rptis.landtax.facts.RPTLedgerTag', 'Ledger Tag', 'rptis.landtax.facts.RPTLedgerTag', '100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'LANDTAX', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'Tax Summary', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', '21', NULL, 'RLTS', NULL, '', '', '', '', '', NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('rptis.landtax.facts.ShareFact', 'rptis.landtax.facts.ShareFact', 'Share', 'rptis.landtax.facts.ShareFact', '50', NULL, 'LSH', NULL, '', '', '', '', '', NULL, 'landtax', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT17d6e7ce:141df4b60c2:-7c21', 'assessedvalue', 'Assessed Value Data', 'rptis.landtax.facts.AssessedValueFact', '20', NULL, NULL, NULL, '', '', '', '', '', NULL, 'LANDTAX', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT357018a9:1452a5dcbf7:-793b', 'ShareInfoFact', 'LGU Share Info', 'rptis.landtax.facts.ShareInfoFact', '50', NULL, 'LSH', NULL, '', '', '', '', '', NULL, 'LANDTAX', NULL);
INSERT INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('RULFACT547c5381:1451ae1cd9c:-75e0', 'paymentoption', 'Payment Option', 'rptis.landtax.facts.PaymentOptionFact', '2', NULL, NULL, NULL, '', '', '', '', '', NULL, 'LANDTAX', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('CurrentDate.day', 'CurrentDate', 'day', 'Day', 'integer', '4', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('CurrentDate.month', 'CurrentDate', 'month', 'Month', 'integer', '3', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('CurrentDate.qtr', 'CurrentDate', 'qtr', 'Quarter', 'integer', '2', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('CurrentDate.year', 'CurrentDate', 'year', 'Year', 'integer', '1', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD-20603cf4:146f0c708c1:-7a25', 'RULFACT357018a9:1452a5dcbf7:-793b', 'lguid', 'LGU', 'string', '4', 'lookup', 'municipality:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD17d6e7ce:141df4b60c2:-7c0c', 'RULFACT17d6e7ce:141df4b60c2:-7c21', 'assessedvalue', 'Assessed Value', 'decimal', '2', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD17d6e7ce:141df4b60c2:-7c13', 'RULFACT17d6e7ce:141df4b60c2:-7c21', 'year', 'Year', 'integer', '1', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-332b', 'RULFACT357018a9:1452a5dcbf7:-793b', 'lgutype', 'LGU Type', 'string', '1', 'lov', '', '', '', '', NULL, '1', 'string', 'RPT_BILLING_LGU_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3ee8', 'RULFACT357018a9:1452a5dcbf7:-793b', 'sefint', 'SEF Interest', 'decimal', '11', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f01', 'RULFACT357018a9:1452a5dcbf7:-793b', 'sefdisc', 'SEF Discount', 'decimal', '10', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f1a', 'RULFACT357018a9:1452a5dcbf7:-793b', 'sef', 'SEF', 'decimal', '9', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f33', 'RULFACT357018a9:1452a5dcbf7:-793b', 'basicint', 'Basic Interest', 'decimal', '8', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f4c', 'RULFACT357018a9:1452a5dcbf7:-793b', 'basicdisc', 'Basic Discount', 'decimal', '7', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-3f65', 'RULFACT357018a9:1452a5dcbf7:-793b', 'basic', 'Basic', 'decimal', '6', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-45b2', 'RULFACT357018a9:1452a5dcbf7:-793b', 'revperiod', 'Revenue Period', 'string', '3', 'lov', '', '', '', '', NULL, '0', 'string', 'RPT_REVENUE_PERIODS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD1be07afa:1452a9809e9:-608c', 'RULFACT357018a9:1452a5dcbf7:-793b', 'barangay', 'Barangay', 'string', '5', 'lookup', 'barangay:lookup', 'objid', 'name', '', NULL, NULL, 'string', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD2701c487:141e346f838:-7f2e', 'RULFACT17d6e7ce:141df4b60c2:-7c21', 'rptledger', 'RPT Ledger', 'string', '3', 'var', '', '', '', '', NULL, NULL, 'rptis.landtax.facts.RPTLedgerFact', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD357018a9:1452a5dcbf7:-7765', 'RULFACT357018a9:1452a5dcbf7:-793b', 'sharetype', 'Share Type', 'string', '2', 'lov', '', '', '', '', NULL, '0', 'string', 'RPT_BILLING_SHARE_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD441bb08f:1436c079bff:-7fc1', 'RULFACT17d6e7ce:141df4b60c2:-7c21', 'qtrlyav', 'Quarterly Assessed Value', 'decimal', '4', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('FACTFLD547c5381:1451ae1cd9c:-75c6', 'RULFACT547c5381:1451ae1cd9c:-75e0', 'type', 'Type', 'string', '1', 'lov', '', '', '', '', NULL, NULL, 'string', 'RPT_BILLING_PAYMENT_OPTIONS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.actualuse', 'rptis.landtax.facts.AssessedValue', 'actualuse', 'Actual Use', 'string', '4', 'var', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, '0', 'rptis.landtax.facts.Classification', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.av', 'rptis.landtax.facts.AssessedValue', 'av', 'Assessed Value', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, '1', 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.basicav', 'rptis.landtax.facts.AssessedValue', 'basicav', 'Basic Assessed Value', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.classification', 'rptis.landtax.facts.AssessedValue', 'classification', 'Classification', 'string', '3', 'var', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'rptis.landtax.facts.Classification', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.idleland', 'rptis.landtax.facts.AssessedValue', 'idleland', 'Is Idle Land?', 'boolean', '10', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.mv', 'rptis.landtax.facts.AssessedValue', 'mv', 'Market Value', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.rputype', 'rptis.landtax.facts.AssessedValue', 'rputype', 'Property Type', 'string', '1', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_RPUTYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.sefav', 'rptis.landtax.facts.AssessedValue', 'sefav', 'SEF Assessed Value', 'decimal', '9', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.txntype', 'rptis.landtax.facts.AssessedValue', 'txntype', 'Transaction Type', 'string', '2', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_TXN_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.AssessedValue.year', 'rptis.landtax.facts.AssessedValue', 'year', 'Year', 'integer', '5', 'integer', NULL, NULL, NULL, NULL, NULL, '1', 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.advancebill', 'rptis.landtax.facts.Bill', 'advancebill', 'Is Advance Billing?', 'boolean', '6', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.billdate', 'rptis.landtax.facts.Bill', 'billdate', 'Bill Date', 'date', '5', 'date', NULL, NULL, NULL, NULL, NULL, NULL, 'date', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.billtoqtr', 'rptis.landtax.facts.Bill', 'billtoqtr', 'Quarter', 'integer', '2', 'integer', NULL, NULL, NULL, NULL, NULL, '0', 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.billtoyear', 'rptis.landtax.facts.Bill', 'billtoyear', 'Year', 'integer', '1', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.currentdate', 'rptis.landtax.facts.Bill', 'currentdate', 'Current Date', 'date', '3', 'date', NULL, NULL, NULL, NULL, NULL, NULL, 'date', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Bill.forpayment', 'rptis.landtax.facts.Bill', 'forpayment', 'Is for Payment?', 'boolean', '4', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.Classification.objid', 'rptis.landtax.facts.Classification', 'objid', 'Classification', 'string', '1', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.amount', 'rptis.landtax.facts.RPTBillItem', 'amount', 'Amount', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.parentacctid', 'rptis.landtax.facts.RPTBillItem', 'parentacctid', 'Account', 'string', '1', 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.revperiod', 'rptis.landtax.facts.RPTBillItem', 'revperiod', 'Revenue Period', 'string', '3', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_REVENUE_PERIODS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.revtype', 'rptis.landtax.facts.RPTBillItem', 'revtype', 'Revenue Type', 'string', '2', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BILLING_REVENUE_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTBillItem.sharetype', 'rptis.landtax.facts.RPTBillItem', 'sharetype', 'Share Type', 'string', '4', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BILLING_LGU_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.basicrate', 'rptis.landtax.facts.RPTIncentive', 'basicrate', 'Basic Rate', 'decimal', '2', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.fromyear', 'rptis.landtax.facts.RPTIncentive', 'fromyear', 'From Year', 'integer', '4', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.rptledger', 'rptis.landtax.facts.RPTIncentive', 'rptledger', 'Ledger', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerFact', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.sefrate', 'rptis.landtax.facts.RPTIncentive', 'sefrate', 'SEF Rate', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTIncentive.toyear', 'rptis.landtax.facts.RPTIncentive', 'toyear', 'To Year', 'integer', '5', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFaasFact.actualuseid', 'rptis.landtax.facts.RPTLedgerFaasFact', 'actualuseid', 'Actual Use', 'string', '2', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFaasFact.assessedvalue', 'rptis.landtax.facts.RPTLedgerFaasFact', 'assessedvalue', 'Assessed Value', 'decimal', '7', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFaasFact.classificationid', 'rptis.landtax.facts.RPTLedgerFaasFact', 'classificationid', 'Classification', 'string', '1', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFaasFact.fromqtr', 'rptis.landtax.facts.RPTLedgerFaasFact', 'fromqtr', 'From Qtr', 'integer', '4', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFaasFact.fromyear', 'rptis.landtax.facts.RPTLedgerFaasFact', 'fromyear', 'From Year', 'integer', '3', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFaasFact.tdno', 'rptis.landtax.facts.RPTLedgerFaasFact', 'tdno', 'TD No.', 'string', '8', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFaasFact.toqtr', 'rptis.landtax.facts.RPTLedgerFaasFact', 'toqtr', 'To Qtr', 'integer', '6', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFaasFact.toyear', 'rptis.landtax.facts.RPTLedgerFaasFact', 'toyear', 'To Year', 'integer', '5', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFaasFact.txntype', 'rptis.landtax.facts.RPTLedgerFaasFact', 'txntype', 'Transaction Type', 'string', '9', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_TXN_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.barangay', 'rptis.landtax.facts.RPTLedgerFact', 'barangay', 'Barangay', 'string', '8', 'lookup', 'barangay:lookup', 'objid', 'name', '', NULL, NULL, 'string', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.barangayid', 'rptis.landtax.facts.RPTLedgerFact', 'barangayid', 'Barangay ID', 'string', '12', 'lookup', 'barangay:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.firstqtrpaidontime', 'rptis.landtax.facts.RPTLedgerFact', 'firstqtrpaidontime', '1st Qtr is Paid On-Time', 'boolean', '4', 'boolean', '', '', '', '', NULL, NULL, 'boolean', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.lastqtrpaid', 'rptis.landtax.facts.RPTLedgerFact', 'lastqtrpaid', 'Last Qtr Paid', 'integer', '3', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.lastyearpaid', 'rptis.landtax.facts.RPTLedgerFact', 'lastyearpaid', 'Last Year Paid', 'integer', '2', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.lguid', 'rptis.landtax.facts.RPTLedgerFact', 'lguid', 'LGU ID', 'string', '11', 'lookup', 'municipality:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.missedpayment', 'rptis.landtax.facts.RPTLedgerFact', 'missedpayment', 'Has missed current year Quarterly Payment?', 'boolean', '7', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.objid', 'rptis.landtax.facts.RPTLedgerFact', 'objid', 'Objid', 'string', '1', 'lookup', 'rptledger:lookup', 'objid', 'tdno', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.parentlguid', 'rptis.landtax.facts.RPTLedgerFact', 'parentlguid', 'Parent LGU', 'string', '10', 'lookup', 'province:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.qtrlypaymentpaidontime', 'rptis.landtax.facts.RPTLedgerFact', 'qtrlypaymentpaidontime', 'Quarterly Payment is Paid On-Time', 'boolean', '5', 'boolean', '', '', '', '', NULL, NULL, 'boolean', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.rputype', 'rptis.landtax.facts.RPTLedgerFact', 'rputype', 'Property Type', 'string', '9', 'lov', '', '', '', '', NULL, NULL, 'string', 'RPT_RPUTYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerFact.undercompromise', 'rptis.landtax.facts.RPTLedgerFact', 'undercompromise', 'Is under Compromise?', 'boolean', '6', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.actualuse', 'rptis.landtax.facts.RPTLedgerItemFact', 'actualuse', 'Actual Use', 'string', '9', 'lookup', 'propertyclassification:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'rptis.landtax.facts.RPTLedgerItemFact', 'amtdue', 'Tax', 'decimal', '21', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.av', 'rptis.landtax.facts.RPTLedgerItemFact', 'av', 'Assessed Value', 'decimal', '4', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.backtax', 'rptis.landtax.facts.RPTLedgerItemFact', 'backtax', 'Is Back Tax?', 'boolean', '18', 'boolean', '', '', '', '', NULL, NULL, 'boolean', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.basicav', 'rptis.landtax.facts.RPTLedgerItemFact', 'basicav', 'AV for Basic', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.classification', 'rptis.landtax.facts.RPTLedgerItemFact', 'classification', 'Classification', 'string', '8', 'lookup', 'propertyclassification:lookup', 'objid', 'name', '', '0', NULL, 'string', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.discount', 'rptis.landtax.facts.RPTLedgerItemFact', 'discount', 'Discount', 'decimal', '23', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.fullypaid', 'rptis.landtax.facts.RPTLedgerItemFact', 'fullypaid', 'Is Fully Paid?', 'boolean', '13', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.idleland', 'rptis.landtax.facts.RPTLedgerItemFact', 'idleland', 'Is Idle Land?', 'boolean', '12', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.interest', 'rptis.landtax.facts.RPTLedgerItemFact', 'interest', 'Interest', 'decimal', '22', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.monthsfromjan', 'rptis.landtax.facts.RPTLedgerItemFact', 'monthsfromjan', 'Number of Months from January', 'integer', '17', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.monthsfromqtr', 'rptis.landtax.facts.RPTLedgerItemFact', 'monthsfromqtr', 'Number of Months From Quarter', 'integer', '16', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.originalav', 'rptis.landtax.facts.RPTLedgerItemFact', 'originalav', 'Original AV', 'decimal', '10', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.qtr', 'rptis.landtax.facts.RPTLedgerItemFact', 'qtr', 'Qtr', 'integer', '2', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.qtrly', 'rptis.landtax.facts.RPTLedgerItemFact', 'qtrly', 'Is quarterly computed?', 'boolean', '24', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.qtrlypaymentavailed', 'rptis.landtax.facts.RPTLedgerItemFact', 'qtrlypaymentavailed', 'Is Quarterly Payment?', 'boolean', '14', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.reclassed', 'rptis.landtax.facts.RPTLedgerItemFact', 'reclassed', 'Is Reclassed?', 'boolean', '11', 'boolean', '', '', '', '', NULL, NULL, 'boolean', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.revperiod', 'rptis.landtax.facts.RPTLedgerItemFact', 'revperiod', 'Revenue Period', 'string', '20', 'lov', '', '', '', '', NULL, NULL, 'string', 'RPT_REVENUE_PERIODS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.revtype', 'rptis.landtax.facts.RPTLedgerItemFact', 'revtype', 'Revenue Type', 'string', '19', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BILLING_REVENUE_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.rptledger', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptledger', 'RPT Ledger', 'string', '3', 'var', '', '', '', '', NULL, '0', 'rptis.landtax.facts.RPTLedgerFact', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.sefav', 'rptis.landtax.facts.RPTLedgerItemFact', 'sefav', 'AV for SEF', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.taxdifference', 'rptis.landtax.facts.RPTLedgerItemFact', 'taxdifference', 'Is Tax Difference?', 'boolean', '15', 'boolean', NULL, NULL, NULL, NULL, NULL, NULL, 'boolean', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.txntype', 'rptis.landtax.facts.RPTLedgerItemFact', 'txntype', 'Txn Type', 'string', '7', 'lov', '', '', '', '', NULL, NULL, 'string', 'RPT_TXN_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerItemFact.year', 'rptis.landtax.facts.RPTLedgerItemFact', 'year', 'Year', 'integer', '1', 'integer', '', '', '', '', NULL, NULL, 'integer', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTag.tag', 'rptis.landtax.facts.RPTLedgerTag', 'tag', 'Tag', 'string', '1', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.amount', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'amount', 'Amount', 'decimal', '6', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.discount', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'discount', 'Discount', 'decimal', '7', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.firecode', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'firecode', 'Fire Code', 'decimal', '10', 'decimal', '', '', '', '', NULL, NULL, 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.interest', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'interest', 'Interest', 'decimal', '8', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.ledger', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'ledger', 'Ledger', 'string', '1', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerFact', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.objid', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'objid', 'Variable Name', 'string', '2', 'lookup', 'rptparameter:lookup', 'name', 'name', '', NULL, '0', 'string', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.revperiod', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'revperiod', 'Revenue Period', 'string', '5', 'lov', NULL, NULL, NULL, NULL, NULL, '0', 'string', 'RPT_REVENUE_PERIODS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.revtype', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'revtype', 'Revenue Type', 'string', '4', 'lov', NULL, NULL, NULL, NULL, NULL, NULL, 'string', 'RPT_BILLING_REVENUE_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.rptledger', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'rptledger', 'RPT Ledger', 'string', '3', 'var', '', '', '', '', NULL, NULL, 'rptis.landtax.facts.RPTLedgerFact', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.sef', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'sef', 'SEF', 'decimal', '7', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.sefdisc', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'sefdisc', 'SEF Discount', 'decimal', '8', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.sefint', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'sefint', 'SEF Interest', 'decimal', '9', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.sh', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'sh', 'Socialized Housing Tax', 'decimal', '11', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.shdisc', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'shdisc', 'Socialized Housing Discount', 'decimal', '13', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.RPTLedgerTaxSummaryFact.shint', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'shint', 'Socialized Housing Interest', 'decimal', '12', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.amount', 'rptis.landtax.facts.ShareFact', 'amount', 'Amount', 'decimal', '6', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.barangay', 'rptis.landtax.facts.ShareFact', 'barangay', 'Barangay', 'string', '7', 'lookup', 'barangay:lookup', 'objid', 'name', '', NULL, NULL, 'string', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.basic', 'rptis.landtax.facts.ShareFact', 'basic', 'Basic', 'decimal', '6', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.basicdisc', 'rptis.landtax.facts.ShareFact', 'basicdisc', 'Basic Discount', 'decimal', '7', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.basicint', 'rptis.landtax.facts.ShareFact', 'basicint', 'Basic Interest', 'decimal', '8', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.discount', 'rptis.landtax.facts.ShareFact', 'discount', 'Discount', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.lguid', 'rptis.landtax.facts.ShareFact', 'lguid', 'LGU', 'string', '5', 'lookup', 'municipality:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.lgutype', 'rptis.landtax.facts.ShareFact', 'lgutype', 'LGU Type', 'string', '1', 'lov', '', '', '', '', NULL, '1', 'string', 'RPT_BILLING_LGU_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.revperiod', 'rptis.landtax.facts.ShareFact', 'revperiod', 'Revenue Period', 'string', '4', 'lov', '', '', '', '', NULL, '1', 'string', 'RPT_REVENUE_PERIODS');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.revtype', 'rptis.landtax.facts.ShareFact', 'revtype', 'Revenue Type', 'string', '3', 'lov', NULL, NULL, NULL, NULL, NULL, '1', 'string', 'RPT_BILLING_REVENUE_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sef', 'rptis.landtax.facts.ShareFact', 'sef', 'SEF', 'decimal', '9', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sefdisc', 'rptis.landtax.facts.ShareFact', 'sefdisc', 'SEF Discount', 'decimal', '10', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sefint', 'rptis.landtax.facts.ShareFact', 'sefint', 'SEF Interest', 'decimal', '11', 'decimal', '', '', '', '', NULL, '0', 'decimal', '');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sh', 'rptis.landtax.facts.ShareFact', 'sh', 'Socialized Housing Tax', 'decimal', '12', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.sharetype', 'rptis.landtax.facts.ShareFact', 'sharetype', 'Share Type', 'string', '2', 'lov', '', '', '', '', NULL, '1', 'string', 'RPT_BILLING_SHARE_TYPES');
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.shdisc', 'rptis.landtax.facts.ShareFact', 'shdisc', 'Socialized Housing Discount', 'decimal', '14', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.facts.ShareFact.shint', 'rptis.landtax.facts.ShareFact', 'shint', 'Socialized Housing Interest', 'decimal', '13', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC-17442746:16be936f033:-7e86', 'RUL483027b0:16be9375c61:-77e6', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC-54d69547:1795f1fd4a7:-7fb8', 'RUL-7eb5c285:1795f11dd49:-3b2d', 'rptis.landtax.facts.RPTLedgerFaasFact', 'rptis.landtax.facts.RPTLedgerFaasFact', 'RLF', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC-54d69547:1795f1fd4a7:-7fbb', 'RUL-7eb5c285:1795f11dd49:-3b2d', 'rptis.landtax.facts.AssessedValue', 'rptis.landtax.facts.AssessedValue', 'AVINFO', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC-723fa88f:16955ccdab3:-742d', 'RUL1a44b27e:16955ccf41e:e9f', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC-723fa88f:16955ccdab3:-7430', 'RUL1a44b27e:16955ccf41e:e9f', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC122cd182:16b250d7a42:-8f9', 'RUL3e7cce43:16b25a6ae3b:-2657', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC122cd182:16b250d7a42:-8fe', 'RUL3e7cce43:16b25a6ae3b:-2657', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC37a59caa:17b4d4dd897:-7d96', 'RUL49c6281:17b4dac24e2:-7e37', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC37a59caa:17b4d4dd897:-7d98', 'RUL49c6281:17b4dac24e2:-7e37', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC440e47f4:166ae4152f1:-7fbe', 'RUL1262ad19:166ae41b1fb:-7c88', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC440e47f4:166ae4152f1:-7fc0', 'RUL1262ad19:166ae41b1fb:-7c88', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC4de45266:17d362025ea:-7f29', 'RUL-7e4e8460:17d364033db:-7031', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC4de45266:17d362025ea:-7f2b', 'RUL-7e4e8460:17d364033db:-7031', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC5e852405:174ee003e4e:-7fe4', 'RUL-33da6907:174edfc7b14:-7bf9', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC70978a15:166ae6875d1:-7f22', 'RUL7e02b404:166ae687f42:-5511', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC70978a15:166ae6875d1:-7f24', 'RUL7e02b404:166ae687f42:-5511', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fad', 'RULec9d7ab:166235c2e16:-26bf', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7faf', 'RULec9d7ab:166235c2e16:-26bf', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fb4', 'RULec9d7ab:166235c2e16:-26d0', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fb6', 'RULec9d7ab:166235c2e16:-26d0', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fbb', 'RULec9d7ab:166235c2e16:-319f', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fbd', 'RULec9d7ab:166235c2e16:-319f', 'rptis.landtax.facts.RPTLedgerFact', 'rptis.landtax.facts.RPTLedgerFact', 'RL', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fc0', 'RULec9d7ab:166235c2e16:-319f', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '2', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fc7', 'RULec9d7ab:166235c2e16:-3811', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fc9', 'RULec9d7ab:166235c2e16:-3811', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '2', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fcf', 'RULec9d7ab:166235c2e16:-4197', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RC7280357:166235c1be7:-7fd4', 'RULec9d7ab:166235c2e16:-4197', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-1a2d6e9b:1692d429304:-7748', 'RUL-1a2d6e9b:1692d429304:-7779', 'rptis.landtax.facts.AssessedValue', 'rptis.landtax.facts.AssessedValue', 'AVINFO', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-202aff7b:17c72f23ba6:-589a', 'RUL-202aff7b:17c72f23ba6:-7d96', 'rptis.landtax.facts.RPTLedgerFaasFact', 'rptis.landtax.facts.RPTLedgerFaasFact', 'RLF', '2', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-202aff7b:17c72f23ba6:-595d', 'RUL-202aff7b:17c72f23ba6:-7d96', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-202aff7b:17c72f23ba6:-7d15', 'RUL-202aff7b:17c72f23ba6:-7d96', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-2ede6703:16642adb9ce:-7a39', 'RUL-2ede6703:16642adb9ce:-7ba0', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-7eb5c285:1795f11dd49:-5632', 'RUL-81eaa11:1795f0e54a0:-7e70', 'rptis.landtax.facts.AssessedValue', 'rptis.landtax.facts.AssessedValue', 'AVINFO', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-7eb5c285:1795f11dd49:-594c', 'RUL-81eaa11:1795f0e54a0:-7e70', 'rptis.landtax.facts.RPTLedgerFaasFact', 'rptis.landtax.facts.RPTLedgerFaasFact', 'RLF', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-8fbba9f:18007eb90b8:-6fdf', 'RUL-8fbba9f:18007eb90b8:-72fb', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-8fbba9f:18007eb90b8:-7172', 'RUL-8fbba9f:18007eb90b8:-72fb', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND-8fbba9f:18007eb90b8:-7295', 'RUL-8fbba9f:18007eb90b8:-72fb', 'rptis.landtax.facts.RPTLedgerFact', 'rptis.landtax.facts.RPTLedgerFact', 'RL', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND2d3df8d1:17d2c8f0d4d:-79c1', 'RUL2d3df8d1:17d2c8f0d4d:-7a00', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND2d3df8d1:17d2c8f0d4d:-7db0', 'RUL2d3df8d1:17d2c8f0d4d:-7e00', 'rptis.landtax.facts.AssessedValue', 'rptis.landtax.facts.AssessedValue', 'AVINFO', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND34b884c7:17ff889c416:-7adf', 'RUL34b884c7:17ff889c416:-7bf9', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCOND34b884c7:17ff889c416:-7b87', 'RUL34b884c7:17ff889c416:-7bf9', 'rptis.landtax.facts.RPTLedgerTag', 'rptis.landtax.facts.RPTLedgerTag', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-24fc', 'RULec9d7ab:166235c2e16:-255e', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', 'RLTS', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-2ec7', 'RULec9d7ab:166235c2e16:-2f1f', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-3905', 'RULec9d7ab:166235c2e16:-3c17', 'rptis.landtax.facts.Bill', 'rptis.landtax.facts.Bill', 'BILL', '2', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-3b0b', 'RULec9d7ab:166235c2e16:-3c17', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-3baa', 'RULec9d7ab:166235c2e16:-3c17', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-5e7c', 'RULec9d7ab:166235c2e16:-5fcb', 'rptis.landtax.facts.RPTLedgerItemFact', 'rptis.landtax.facts.RPTLedgerItemFact', 'RLI', '1', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition` (`objid`, `parentid`, `fact_name`, `fact_objid`, `varname`, `pos`, `ruletext`, `displaytext`, `dynamic_datatype`, `dynamic_key`, `dynamic_value`, `notexist`) VALUES ('RCONDec9d7ab:166235c2e16:-5f7f', 'RULec9d7ab:166235c2e16:-5fcb', 'CurrentDate', 'CurrentDate', NULL, '0', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC-17442746:16be936f033:-7e86', 'RC-17442746:16be936f033:-7e86', 'RUL483027b0:16be9375c61:-77e6', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC-54d69547:1795f1fd4a7:-7fb8', 'RC-54d69547:1795f1fd4a7:-7fb8', 'RUL-7eb5c285:1795f11dd49:-3b2d', 'RLF', 'rptis.landtax.facts.RPTLedgerFaasFact', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC-54d69547:1795f1fd4a7:-7fbb', 'RC-54d69547:1795f1fd4a7:-7fbb', 'RUL-7eb5c285:1795f11dd49:-3b2d', 'AVINFO', 'rptis.landtax.facts.AssessedValue', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC-723fa88f:16955ccdab3:-742d', 'RC-723fa88f:16955ccdab3:-742d', 'RUL1a44b27e:16955ccf41e:e9f', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC122cd182:16b250d7a42:-8fe', 'RC122cd182:16b250d7a42:-8fe', 'RUL3e7cce43:16b25a6ae3b:-2657', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC37a59caa:17b4d4dd897:-7d96', 'RC37a59caa:17b4d4dd897:-7d96', 'RUL49c6281:17b4dac24e2:-7e37', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC440e47f4:166ae4152f1:-7fc0', 'RC440e47f4:166ae4152f1:-7fc0', 'RUL1262ad19:166ae41b1fb:-7c88', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC4de45266:17d362025ea:-7f2b', 'RC4de45266:17d362025ea:-7f2b', 'RUL-7e4e8460:17d364033db:-7031', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC5e852405:174ee003e4e:-7fe4', 'RC5e852405:174ee003e4e:-7fe4', 'RUL-33da6907:174edfc7b14:-7bf9', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC70978a15:166ae6875d1:-7f22', 'RC70978a15:166ae6875d1:-7f22', 'RUL7e02b404:166ae687f42:-5511', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7faf', 'RC7280357:166235c1be7:-7faf', 'RULec9d7ab:166235c2e16:-26bf', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fb6', 'RC7280357:166235c1be7:-7fb6', 'RULec9d7ab:166235c2e16:-26d0', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fbd', 'RC7280357:166235c1be7:-7fbd', 'RULec9d7ab:166235c2e16:-319f', 'RL', 'rptis.landtax.facts.RPTLedgerFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fc0', 'RC7280357:166235c1be7:-7fc0', 'RULec9d7ab:166235c2e16:-319f', 'BILL', 'rptis.landtax.facts.Bill', '2');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fc7', 'RC7280357:166235c1be7:-7fc7', 'RULec9d7ab:166235c2e16:-3811', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fc9', 'RC7280357:166235c1be7:-7fc9', 'RULec9d7ab:166235c2e16:-3811', 'BILL', 'rptis.landtax.facts.Bill', '2');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RC7280357:166235c1be7:-7fd4', 'RC7280357:166235c1be7:-7fd4', 'RULec9d7ab:166235c2e16:-4197', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC-17442746:16be936f033:-7e83', 'RC-17442746:16be936f033:-7e86', 'RUL483027b0:16be9375c61:-77e6', 'AV', 'decimal', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC-54d69547:1795f1fd4a7:-7fb7', 'RC-54d69547:1795f1fd4a7:-7fb8', 'RUL-7eb5c285:1795f11dd49:-3b2d', 'AV2017', 'decimal', '3');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC-54d69547:1795f1fd4a7:-7fba', 'RC-54d69547:1795f1fd4a7:-7fbb', 'RUL-7eb5c285:1795f11dd49:-3b2d', 'AV', 'decimal', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC-723fa88f:16955ccdab3:-742a', 'RC-723fa88f:16955ccdab3:-742d', 'RUL1a44b27e:16955ccf41e:e9f', 'TAX', 'decimal', '3');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC-723fa88f:16955ccdab3:-742e', 'RC-723fa88f:16955ccdab3:-7430', 'RUL1a44b27e:16955ccf41e:e9f', 'CQTR', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC-723fa88f:16955ccdab3:-742f', 'RC-723fa88f:16955ccdab3:-7430', 'RUL1a44b27e:16955ccf41e:e9f', 'CY', 'integer', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8f8', 'RC122cd182:16b250d7a42:-8f9', 'RUL3e7cce43:16b25a6ae3b:-2657', 'CY', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8fc', 'RC122cd182:16b250d7a42:-8fe', 'RUL3e7cce43:16b25a6ae3b:-2657', 'NMON', 'integer', '2');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8fd', 'RC122cd182:16b250d7a42:-8fe', 'RUL3e7cce43:16b25a6ae3b:-2657', 'TAX', 'decimal', '3');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC37a59caa:17b4d4dd897:-7d97', 'RC37a59caa:17b4d4dd897:-7d98', 'RUL49c6281:17b4dac24e2:-7e37', 'CY', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC440e47f4:166ae4152f1:-7fbd', 'RC440e47f4:166ae4152f1:-7fbe', 'RUL1262ad19:166ae41b1fb:-7c88', 'CY', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC4de45266:17d362025ea:-7f28', 'RC4de45266:17d362025ea:-7f29', 'RUL-7e4e8460:17d364033db:-7031', 'CY', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC5e852405:174ee003e4e:-7fe1', 'RC5e852405:174ee003e4e:-7fe4', 'RUL-33da6907:174edfc7b14:-7bf9', 'TAX', 'decimal', '3');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC5e852405:174ee003e4e:-7fe2', 'RC5e852405:174ee003e4e:-7fe4', 'RUL-33da6907:174edfc7b14:-7bf9', 'NMON', 'integer', '2');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC70978a15:166ae6875d1:-7f23', 'RC70978a15:166ae6875d1:-7f24', 'RUL7e02b404:166ae687f42:-5511', 'CY', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fac', 'RC7280357:166235c1be7:-7fad', 'RULec9d7ab:166235c2e16:-26bf', 'CY', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fb3', 'RC7280357:166235c1be7:-7fb4', 'RULec9d7ab:166235c2e16:-26d0', 'CY', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fba', 'RC7280357:166235c1be7:-7fbb', 'RULec9d7ab:166235c2e16:-319f', 'CY', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fcd', 'RC7280357:166235c1be7:-7fcf', 'RULec9d7ab:166235c2e16:-4197', 'CY', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fd3', 'RC7280357:166235c1be7:-7fd4', 'RULec9d7ab:166235c2e16:-4197', 'TAX', 'decimal', '3');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-1a2d6e9b:1692d429304:-7748', 'RCOND-1a2d6e9b:1692d429304:-7748', 'RUL-1a2d6e9b:1692d429304:-7779', 'AVINFO', 'rptis.landtax.facts.AssessedValue', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-202aff7b:17c72f23ba6:-589a', 'RCOND-202aff7b:17c72f23ba6:-589a', 'RUL-202aff7b:17c72f23ba6:-7d96', 'RLF', 'rptis.landtax.facts.RPTLedgerFaasFact', '2');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-202aff7b:17c72f23ba6:-7d15', 'RCOND-202aff7b:17c72f23ba6:-7d15', 'RUL-202aff7b:17c72f23ba6:-7d96', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-2ede6703:16642adb9ce:-7a39', 'RCOND-2ede6703:16642adb9ce:-7a39', 'RUL-2ede6703:16642adb9ce:-7ba0', 'BILL', 'rptis.landtax.facts.Bill', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-7eb5c285:1795f11dd49:-5632', 'RCOND-7eb5c285:1795f11dd49:-5632', 'RUL-81eaa11:1795f0e54a0:-7e70', 'AVINFO', 'rptis.landtax.facts.AssessedValue', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-7eb5c285:1795f11dd49:-594c', 'RCOND-7eb5c285:1795f11dd49:-594c', 'RUL-81eaa11:1795f0e54a0:-7e70', 'RLF', 'rptis.landtax.facts.RPTLedgerFaasFact', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-8fbba9f:18007eb90b8:-7172', 'RCOND-8fbba9f:18007eb90b8:-7172', 'RUL-8fbba9f:18007eb90b8:-72fb', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND-8fbba9f:18007eb90b8:-7295', 'RCOND-8fbba9f:18007eb90b8:-7295', 'RUL-8fbba9f:18007eb90b8:-72fb', 'RL', 'rptis.landtax.facts.RPTLedgerFact', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND2d3df8d1:17d2c8f0d4d:-79c1', 'RCOND2d3df8d1:17d2c8f0d4d:-79c1', 'RUL2d3df8d1:17d2c8f0d4d:-7a00', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND2d3df8d1:17d2c8f0d4d:-7db0', 'RCOND2d3df8d1:17d2c8f0d4d:-7db0', 'RUL2d3df8d1:17d2c8f0d4d:-7e00', 'AVINFO', 'rptis.landtax.facts.AssessedValue', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCOND34b884c7:17ff889c416:-7adf', 'RCOND34b884c7:17ff889c416:-7adf', 'RUL34b884c7:17ff889c416:-7bf9', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-24fc', 'RCONDec9d7ab:166235c2e16:-24fc', 'RULec9d7ab:166235c2e16:-255e', 'RLTS', 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-2ec7', 'RCONDec9d7ab:166235c2e16:-2ec7', 'RULec9d7ab:166235c2e16:-2f1f', 'BILL', 'rptis.landtax.facts.Bill', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-3905', 'RCONDec9d7ab:166235c2e16:-3905', 'RULec9d7ab:166235c2e16:-3c17', 'BILL', 'rptis.landtax.facts.Bill', '2');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-3b0b', 'RCONDec9d7ab:166235c2e16:-3b0b', 'RULec9d7ab:166235c2e16:-3c17', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONDec9d7ab:166235c2e16:-5e7c', 'RCONDec9d7ab:166235c2e16:-5e7c', 'RULec9d7ab:166235c2e16:-5fcb', 'RLI', 'rptis.landtax.facts.RPTLedgerItemFact', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-1a2d6e9b:1692d429304:-7746', 'RCOND-1a2d6e9b:1692d429304:-7748', 'RUL-1a2d6e9b:1692d429304:-7779', 'AV', 'decimal', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-1a2d6e9b:1692d429304:-7747', 'RCOND-1a2d6e9b:1692d429304:-7748', 'RUL-1a2d6e9b:1692d429304:-7779', 'YR', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-202aff7b:17c72f23ba6:-5941', 'RCOND-202aff7b:17c72f23ba6:-595d', 'RUL-202aff7b:17c72f23ba6:-7d96', 'CY', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-24ff7cfb:1675d220a6c:-56ab', 'RC70978a15:166ae6875d1:-7f22', 'RUL7e02b404:166ae687f42:-5511', 'NMON', 'integer', '4');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-2ede6703:16642adb9ce:-79c8', 'RCOND-2ede6703:16642adb9ce:-7a39', 'RUL-2ede6703:16642adb9ce:-7ba0', 'BILLDATE', 'date', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-7eb5c285:1795f11dd49:-5630', 'RCOND-7eb5c285:1795f11dd49:-5632', 'RUL-81eaa11:1795f0e54a0:-7e70', 'AV', 'decimal', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-7eb5c285:1795f11dd49:-57c3', 'RCOND-7eb5c285:1795f11dd49:-594c', 'RUL-81eaa11:1795f0e54a0:-7e70', 'AV2017', 'decimal', '3');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST-8fbba9f:18007eb90b8:-6fc3', 'RCOND-8fbba9f:18007eb90b8:-6fdf', 'RUL-8fbba9f:18007eb90b8:-72fb', 'CY', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST2d3df8d1:17d2c8f0d4d:-78d0', 'RCOND2d3df8d1:17d2c8f0d4d:-79c1', 'RUL2d3df8d1:17d2c8f0d4d:-7a00', 'AV', 'decimal', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST2d3df8d1:17d2c8f0d4d:-7dae', 'RCOND2d3df8d1:17d2c8f0d4d:-7db0', 'RUL2d3df8d1:17d2c8f0d4d:-7e00', 'AV', 'decimal', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST2d3df8d1:17d2c8f0d4d:-7daf', 'RCOND2d3df8d1:17d2c8f0d4d:-7db0', 'RUL2d3df8d1:17d2c8f0d4d:-7e00', 'YR', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST5ffbdc02:166e7b2c367:-641c', 'RC70978a15:166ae6875d1:-7f22', 'RUL7e02b404:166ae687f42:-5511', 'TAX', 'decimal', '4');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONST7e02b404:166ae687f42:-54ad', 'RC70978a15:166ae6875d1:-7f24', 'RUL7e02b404:166ae687f42:-5511', 'CQTR', 'integer', '1');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-2ea1', 'RCONDec9d7ab:166235c2e16:-2ec7', 'RULec9d7ab:166235c2e16:-2f1f', 'CDATE', 'date', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-3b8e', 'RCONDec9d7ab:166235c2e16:-3baa', 'RULec9d7ab:166235c2e16:-3c17', 'CY', 'integer', '0');
INSERT INTO `sys_rule_condition_var` (`objid`, `parentid`, `ruleid`, `varname`, `datatype`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-5f63', 'RCONDec9d7ab:166235c2e16:-5f7f', 'RULec9d7ab:166235c2e16:-5fcb', 'CY', 'integer', '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-17442746:16be936f033:-7e83', 'RC-17442746:16be936f033:-7e86', 'rptis.landtax.facts.RPTLedgerItemFact.av', 'av', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-54d69547:1795f1fd4a7:-7fb4', 'RC-54d69547:1795f1fd4a7:-7fb8', 'rptis.landtax.facts.RPTLedgerFaasFact.classificationid', 'classificationid', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[[key:\"AGRICULTURAL\",value:\"AGRICULTURAL\"]]', NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-54d69547:1795f1fd4a7:-7fb6', 'RC-54d69547:1795f1fd4a7:-7fb8', 'rptis.landtax.facts.RPTLedgerFaasFact.toyear', 'toyear', NULL, 'equal to', '==', NULL, NULL, NULL, NULL, '2017', NULL, NULL, NULL, '2');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-54d69547:1795f1fd4a7:-7fb7', 'RC-54d69547:1795f1fd4a7:-7fb8', 'rptis.landtax.facts.RPTLedgerFaasFact.assessedvalue', 'assessedvalue', 'AV2017', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-54d69547:1795f1fd4a7:-7fb9', 'RC-54d69547:1795f1fd4a7:-7fbb', 'rptis.landtax.facts.AssessedValue.year', 'year', NULL, 'greater than or equal to', '>=', NULL, NULL, NULL, NULL, '2018', NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-54d69547:1795f1fd4a7:-7fba', 'RC-54d69547:1795f1fd4a7:-7fbb', 'rptis.landtax.facts.AssessedValue.av', 'av', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-723fa88f:16955ccdab3:-742a', 'RC-723fa88f:16955ccdab3:-742d', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-723fa88f:16955ccdab3:-742b', 'RC-723fa88f:16955ccdab3:-742d', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCC-723fa88f:16955ccdab3:-742f', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-723fa88f:16955ccdab3:-742c', 'RC-723fa88f:16955ccdab3:-742d', 'rptis.landtax.facts.RPTLedgerItemFact.qtr', 'qtr', NULL, 'greater than or equal to', '>=', '1', 'RCC-723fa88f:16955ccdab3:-742e', 'CQTR', NULL, NULL, NULL, NULL, NULL, '3');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-723fa88f:16955ccdab3:-742e', 'RC-723fa88f:16955ccdab3:-7430', 'CurrentDate.qtr', 'qtr', 'CQTR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC-723fa88f:16955ccdab3:-742f', 'RC-723fa88f:16955ccdab3:-7430', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8f8', 'RC122cd182:16b250d7a42:-8f9', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8fa', 'RC122cd182:16b250d7a42:-8fe', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'greater than or equal to', '>=', NULL, NULL, NULL, NULL, '1992', NULL, NULL, NULL, '3');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8fb', 'RC122cd182:16b250d7a42:-8fe', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than', '<', '1', 'RCC122cd182:16b250d7a42:-8f8', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8fc', 'RC122cd182:16b250d7a42:-8fe', 'rptis.landtax.facts.RPTLedgerItemFact.monthsfromjan', 'monthsfromjan', 'NMON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC122cd182:16b250d7a42:-8fd', 'RC122cd182:16b250d7a42:-8fe', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC37a59caa:17b4d4dd897:-7d95', 'RC37a59caa:17b4d4dd897:-7d96', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than or equal to', '<=', '0', NULL, NULL, NULL, '1991', NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC37a59caa:17b4d4dd897:-7d97', 'RC37a59caa:17b4d4dd897:-7d98', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC440e47f4:166ae4152f1:-7fbd', 'RC440e47f4:166ae4152f1:-7fbe', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC440e47f4:166ae4152f1:-7fbf', 'RC440e47f4:166ae4152f1:-7fc0', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than', '<', '1', 'RCC440e47f4:166ae4152f1:-7fbd', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC4de45266:17d362025ea:-7f28', 'RC4de45266:17d362025ea:-7f29', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC4de45266:17d362025ea:-7f2a', 'RC4de45266:17d362025ea:-7f2b', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCC4de45266:17d362025ea:-7f28', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC5e852405:174ee003e4e:-7fe1', 'RC5e852405:174ee003e4e:-7fe4', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC5e852405:174ee003e4e:-7fe2', 'RC5e852405:174ee003e4e:-7fe4', 'rptis.landtax.facts.RPTLedgerItemFact.monthsfromjan', 'monthsfromjan', 'NMON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC5e852405:174ee003e4e:-7fe3', 'RC5e852405:174ee003e4e:-7fe4', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than or equal to', '<=', '0', NULL, NULL, NULL, '1991', NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC70978a15:166ae6875d1:-7f1d', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.revtype', 'revtype', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[\"basic\",\"sef\"]', NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC70978a15:166ae6875d1:-7f23', 'RC70978a15:166ae6875d1:-7f24', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fac', 'RC7280357:166235c1be7:-7fad', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fae', 'RC7280357:166235c1be7:-7faf', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'greater than', '>', '1', 'RCC7280357:166235c1be7:-7fac', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fb3', 'RC7280357:166235c1be7:-7fb4', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fb5', 'RC7280357:166235c1be7:-7fb6', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCC7280357:166235c1be7:-7fb3', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fba', 'RC7280357:166235c1be7:-7fbb', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fbc', 'RC7280357:166235c1be7:-7fbd', 'rptis.landtax.facts.RPTLedgerFact.lastyearpaid', 'lastyearpaid', NULL, 'equal to', '==', '1', 'RCC7280357:166235c1be7:-7fba', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fbf', 'RC7280357:166235c1be7:-7fc0', 'rptis.landtax.facts.Bill.billtoyear', 'billtoyear', NULL, 'greater than', '>', '1', 'RCC7280357:166235c1be7:-7fba', 'CY', NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fc6', 'RC7280357:166235c1be7:-7fc7', 'rptis.landtax.facts.RPTLedgerItemFact.qtrly', 'qtrly', NULL, 'not true', '== false', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fc8', 'RC7280357:166235c1be7:-7fc9', 'rptis.landtax.facts.Bill.forpayment', 'forpayment', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fcd', 'RC7280357:166235c1be7:-7fcf', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fd0', 'RC7280357:166235c1be7:-7fd4', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'greater than', '>', '1', 'RCC7280357:166235c1be7:-7fcd', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCC7280357:166235c1be7:-7fd3', 'RC7280357:166235c1be7:-7fd4', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-1a2d6e9b:1692d429304:-7746', 'RCOND-1a2d6e9b:1692d429304:-7748', 'rptis.landtax.facts.AssessedValue.av', 'av', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-1a2d6e9b:1692d429304:-7747', 'RCOND-1a2d6e9b:1692d429304:-7748', 'rptis.landtax.facts.AssessedValue.year', 'year', 'YR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-202aff7b:17c72f23ba6:-4cdf', 'RCOND-202aff7b:17c72f23ba6:-589a', 'rptis.landtax.facts.RPTLedgerFaasFact.txntype', 'txntype', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[\"ND\"]', NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-202aff7b:17c72f23ba6:-585e', 'RCOND-202aff7b:17c72f23ba6:-589a', 'rptis.landtax.facts.RPTLedgerFaasFact.fromyear', 'fromyear', NULL, 'greater than or equal to', '>=', '1', 'RCONST-202aff7b:17c72f23ba6:-5941', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-202aff7b:17c72f23ba6:-5941', 'RCOND-202aff7b:17c72f23ba6:-595d', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-202aff7b:17c72f23ba6:-7c8c', 'RCOND-202aff7b:17c72f23ba6:-7d15', 'rptis.landtax.facts.RPTLedgerItemFact.backtax', 'backtax', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-24ff7cfb:1675d220a6c:-56ab', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.monthsfromjan', 'monthsfromjan', 'NMON', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '4');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2ede6703:16642adb9ce:-79c8', 'RCOND-2ede6703:16642adb9ce:-7a39', 'rptis.landtax.facts.Bill.billdate', 'billdate', 'BILLDATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-2ede6703:16642adb9ce:-7a03', 'RCOND-2ede6703:16642adb9ce:-7a39', 'rptis.landtax.facts.Bill.advancebill', 'advancebill', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-7eb5c285:1795f11dd49:-5630', 'RCOND-7eb5c285:1795f11dd49:-5632', 'rptis.landtax.facts.AssessedValue.av', 'av', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-7eb5c285:1795f11dd49:-5631', 'RCOND-7eb5c285:1795f11dd49:-5632', 'rptis.landtax.facts.AssessedValue.year', 'year', NULL, 'greater than or equal to', '>=', NULL, NULL, NULL, NULL, '2018', NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-7eb5c285:1795f11dd49:-57c3', 'RCOND-7eb5c285:1795f11dd49:-594c', 'rptis.landtax.facts.RPTLedgerFaasFact.assessedvalue', 'assessedvalue', 'AV2017', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-7eb5c285:1795f11dd49:-5853', 'RCOND-7eb5c285:1795f11dd49:-594c', 'rptis.landtax.facts.RPTLedgerFaasFact.toyear', 'toyear', NULL, 'equal to', '==', NULL, NULL, NULL, NULL, '2017', NULL, NULL, NULL, '2');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-7eb5c285:1795f11dd49:-5920', 'RCOND-7eb5c285:1795f11dd49:-594c', 'rptis.landtax.facts.RPTLedgerFaasFact.classificationid', 'classificationid', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[[key:\"RESIDENTIAL\",value:\"RESIDENTIAL\"]]', NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-8fbba9f:18007eb90b8:-6fc3', 'RCOND-8fbba9f:18007eb90b8:-6fdf', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-8fbba9f:18007eb90b8:-7083', 'RCOND-8fbba9f:18007eb90b8:-7172', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCONST-8fbba9f:18007eb90b8:-6fc3', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST-8fbba9f:18007eb90b8:-71d8', 'RCOND-8fbba9f:18007eb90b8:-7295', 'rptis.landtax.facts.RPTLedgerFact.missedpayment', 'missedpayment', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST2d3df8d1:17d2c8f0d4d:-7742', 'RCOND2d3df8d1:17d2c8f0d4d:-79c1', 'rptis.landtax.facts.RPTLedgerItemFact.revtype', 'revtype', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[\"basicidle\"]', NULL, '2');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST2d3df8d1:17d2c8f0d4d:-78d0', 'RCOND2d3df8d1:17d2c8f0d4d:-79c1', 'rptis.landtax.facts.RPTLedgerItemFact.av', 'av', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST2d3df8d1:17d2c8f0d4d:-7b66', 'RCOND2d3df8d1:17d2c8f0d4d:-7db0', 'rptis.landtax.facts.AssessedValue.idleland', 'idleland', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST2d3df8d1:17d2c8f0d4d:-7dae', 'RCOND2d3df8d1:17d2c8f0d4d:-7db0', 'rptis.landtax.facts.AssessedValue.av', 'av', 'AV', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST2d3df8d1:17d2c8f0d4d:-7daf', 'RCOND2d3df8d1:17d2c8f0d4d:-7db0', 'rptis.landtax.facts.AssessedValue.year', 'year', 'YR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST34b884c7:17ff889c416:-7a8d', 'RCOND34b884c7:17ff889c416:-7adf', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than', '<', NULL, NULL, NULL, NULL, '2021', NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST34b884c7:17ff889c416:-7b77', 'RCOND34b884c7:17ff889c416:-7b87', 'rptis.landtax.facts.RPTLedgerTag.tag', 'tag', NULL, 'matches', 'matches', NULL, NULL, NULL, NULL, NULL, 'UNDER_CARP', NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST40ac2a42:171728cfca4:-72f6', 'RCONDec9d7ab:166235c2e16:-5e7c', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'greater than or equal to', '>=', '1', 'RCONSTec9d7ab:166235c2e16:-5f63', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST43877190:16db8bfd315:-6faf', 'RC-17442746:16be936f033:-7e86', 'rptis.landtax.facts.RPTLedgerItemFact.revtype', 'revtype', NULL, 'is any of the ff.', 'matches', NULL, NULL, NULL, NULL, NULL, NULL, '[\"basic\",\"sef\"]', NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST49c6281:17b4dac24e2:-7dba', 'RC440e47f4:166ae4152f1:-7fc0', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'greater than', '>', NULL, NULL, NULL, NULL, '1992', NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST5ffbdc02:166e7b2c367:-641c', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.amtdue', 'amtdue', 'TAX', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '4');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST5ffbdc02:166e7b2c367:-65fd', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.qtr', 'qtr', NULL, 'less than', '<', '1', 'RCONST7e02b404:166ae687f42:-54ad', 'CQTR', NULL, NULL, NULL, NULL, NULL, '2');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST5ffbdc02:166e7b2c367:-66a5', 'RC70978a15:166ae6875d1:-7f22', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'equal to', '==', '1', 'RCC70978a15:166ae6875d1:-7f23', 'CY', NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONST7e02b404:166ae687f42:-54ad', 'RC70978a15:166ae6875d1:-7f24', 'CurrentDate.qtr', 'qtr', 'CQTR', 'greater than', '>', NULL, NULL, NULL, NULL, '1', NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-2ea1', 'RCONDec9d7ab:166235c2e16:-2ec7', 'rptis.landtax.facts.Bill.currentdate', 'currentdate', 'CDATE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-311f', 'RC7280357:166235c1be7:-7fbd', 'rptis.landtax.facts.RPTLedgerFact.lastqtrpaid', 'lastqtrpaid', NULL, 'equal to', '==', NULL, NULL, NULL, NULL, '4', NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-36b2', 'RC7280357:166235c1be7:-7fc7', 'rptis.landtax.facts.RPTLedgerItemFact.revtype', 'revtype', NULL, 'is any of the ff.', 'matches', '0', NULL, NULL, NULL, NULL, NULL, '[\"basic\",\"sef\"]', NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-38dd', 'RCONDec9d7ab:166235c2e16:-3905', 'rptis.landtax.facts.Bill.forpayment', 'forpayment', NULL, 'not true', '== false', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-39af', 'RCONDec9d7ab:166235c2e16:-3b0b', 'rptis.landtax.facts.RPTLedgerItemFact.qtrly', 'qtrly', NULL, 'is true', '== true', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-3abb', 'RCONDec9d7ab:166235c2e16:-3b0b', 'rptis.landtax.facts.RPTLedgerItemFact.year', 'year', NULL, 'less than', '<', '1', 'RCONSTec9d7ab:166235c2e16:-3b8e', 'CY', NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-3b8e', 'RCONDec9d7ab:166235c2e16:-3baa', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_condition_constraint` (`objid`, `parentid`, `field_objid`, `fieldname`, `varname`, `operator_caption`, `operator_symbol`, `usevar`, `var_objid`, `var_name`, `decimalvalue`, `intvalue`, `stringvalue`, `listvalue`, `datevalue`, `pos`) VALUES ('RCONSTec9d7ab:166235c2e16:-5f63', 'RCONDec9d7ab:166235c2e16:-5f7f', 'CurrentDate.year', 'year', 'CY', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA-17442746:16be936f033:-7e82', 'RUL483027b0:16be9375c61:-77e6', 'rptis.landtax.actions.CalcTax', 'calc-tax', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA-54d69547:1795f1fd4a7:-7fb3', 'RUL-7eb5c285:1795f11dd49:-3b2d', 'rptis.landtax.actions.UpdateAV', 'update-av', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA-723fa88f:16955ccdab3:-7428', 'RUL1a44b27e:16955ccf41e:e9f', 'rptis.landtax.actions.CalcDiscount', 'calc-discount', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA122cd182:16b250d7a42:-8f7', 'RUL3e7cce43:16b25a6ae3b:-2657', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA37a59caa:17b4d4dd897:-7d94', 'RUL49c6281:17b4dac24e2:-7e37', 'rptis.landtax.actions.CreateTaxSummary', 'create-tax-summary', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA440e47f4:166ae4152f1:-7fbc', 'RUL1262ad19:166ae41b1fb:-7c88', 'rptis.landtax.actions.CreateTaxSummary', 'create-tax-summary', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA4de45266:17d362025ea:-7f27', 'RUL-7e4e8460:17d364033db:-7031', 'rptis.landtax.actions.SplitByQtr', 'split-by-qtr', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA5e852405:174ee003e4e:-7fe0', 'RUL-33da6907:174edfc7b14:-7bf9', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA7280357:166235c1be7:-7fab', 'RULec9d7ab:166235c2e16:-26bf', 'rptis.landtax.actions.CreateTaxSummary', 'create-tax-summary', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA7280357:166235c1be7:-7fb2', 'RULec9d7ab:166235c2e16:-26d0', 'rptis.landtax.actions.CreateTaxSummary', 'create-tax-summary', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA7280357:166235c1be7:-7fb9', 'RULec9d7ab:166235c2e16:-319f', 'rptis.landtax.actions.SetBillExpiryDate', 'set-bill-expiry', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RA7280357:166235c1be7:-7fcc', 'RULec9d7ab:166235c2e16:-4197', 'rptis.landtax.actions.CalcDiscount', 'calc-discount', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-1a2d6e9b:1692d429304:-7649', 'RUL-1a2d6e9b:1692d429304:-7779', 'rptis.landtax.actions.AddSef', 'add-sef', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-1a2d6e9b:1692d429304:-7700', 'RUL-1a2d6e9b:1692d429304:-7779', 'rptis.landtax.actions.AddBasic', 'add-basic', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-202aff7b:17c72f23ba6:-7c30', 'RUL-202aff7b:17c72f23ba6:-7d96', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-259ddd03:17dc1aefe6f:-7a3f', 'RUL-202aff7b:17c72f23ba6:-7d96', 'rptis.landtax.actions.CalcDiscount', 'calc-discount', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-2ede6703:16642adb9ce:-794c', 'RUL-2ede6703:16642adb9ce:-7ba0', 'rptis.landtax.actions.SetBillExpiryDate', 'set-bill-expiry', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-7eb5c285:1795f11dd49:-55ce', 'RUL-81eaa11:1795f0e54a0:-7e70', 'rptis.landtax.actions.UpdateAV', 'update-av', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT-8fbba9f:18007eb90b8:-711a', 'RUL-8fbba9f:18007eb90b8:-72fb', 'rptis.landtax.actions.CalcDiscount', 'calc-discount', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT2d3df8d1:17d2c8f0d4d:-7864', 'RUL2d3df8d1:17d2c8f0d4d:-7a00', 'rptis.landtax.actions.CalcTax', 'calc-tax', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT2d3df8d1:17d2c8f0d4d:-7a9e', 'RUL2d3df8d1:17d2c8f0d4d:-7e00', 'rptis.landtax.actions.AddIdleLand', 'add-basicidle', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT34b884c7:17ff889c416:-7a20', 'RUL34b884c7:17ff889c416:-7bf9', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACT5ffbdc02:166e7b2c367:-6229', 'RUL7e02b404:166ae687f42:-5511', 'rptis.landtax.actions.CalcInterest', 'calc-interest', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-249a', 'RULec9d7ab:166235c2e16:-255e', 'rptis.landtax.actions.AddBillItem', 'add-billitem', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-2e2e', 'RULec9d7ab:166235c2e16:-2f1f', 'rptis.landtax.actions.SetBillExpiryDate', 'set-bill-expiry', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-35b3', 'RULec9d7ab:166235c2e16:-3811', 'rptis.landtax.actions.SplitLedgerItem', 'split-bill-item', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-3879', 'RULec9d7ab:166235c2e16:-3c17', 'rptis.landtax.actions.AggregateLedgerItem', 'aggregate-bill-item', '0');
INSERT INTO `sys_rule_action` (`objid`, `parentid`, `actiondef_objid`, `actiondef_name`, `pos`) VALUES ('RACTec9d7ab:166235c2e16:-5b6f', 'RULec9d7ab:166235c2e16:-5fcb', 'rptis.landtax.actions.SplitByQtr', 'split-by-qtr', '0');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddBasic', 'add-basic', 'Add Basic Entry', '1', 'add-basic', 'landtax', 'rptis.landtax.actions.AddBasic');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddBillItem', 'add-billitem', 'Add Bill Item', '25', 'add-billitem', 'landtax', 'rptis.landtax.actions.AddBillItem');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddFireCode', 'add-firecode', 'Add Fire Code', '10', 'add-firecode', 'landtax', 'rptis.landtax.actions.AddFireCode');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddIdleLand', 'add-basicidle', 'Add Idle Land Entry', '6', 'add-basicidle', 'landtax', 'rptis.landtax.actions.AddIdleLand');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddSef', 'add-sef', 'Add SEF Entry', '5', 'add-sef', 'landtax', 'rptis.landtax.actions.AddSef');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddShare', 'add-share', 'Add Revenue Share', '28', 'add-share', 'landtax', 'rptis.landtax.actions.AddShare');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AddSocialHousing', 'add-sh', 'Add Social Housing Entry', '8', 'add-sh', 'landtax', 'rptis.landtax.actions.AddSocialHousing');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.AggregateLedgerItem', 'aggregate-bill-item', 'Aggregate Ledger Items', '12', 'aggregate-bill-item', 'landtax', 'rptis.landtax.actions.AggregateLedgerItem');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.CalcDiscount', 'calc-discount', 'Calculate Discount', '6', 'calc-discount', 'landtax', 'rptis.landtax.actions.CalcDiscount');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.CalcInterest', 'calc-interest', 'Calculate Interest', '5', 'calc-interest', 'landtax', 'rptis.landtax.actions.CalcInterest');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.CalcTax', 'calc-tax', 'Calculate Tax', '1001', 'calc-tax', 'landtax', 'rptis.landtax.actions.CalcTax');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.CreateTaxSummary', 'create-tax-summary', 'Create Tax Summary', '20', 'create-tax-summary', 'landtax', 'rptis.landtax.actions.CreateTaxSummary');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.RemoveLedgerItem', 'remove-bill-item', 'Remove Ledger Item', '11', 'remove-bill-item', 'landtax', 'rptis.landtax.actions.RemoveLedgerItem');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.SetBillExpiryDate', 'set-bill-expiry', 'Set Bill Expiry Date', '20', 'set-bill-expiry', 'landtax', 'rptis.landtax.actions.SetBillExpiryDate');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.SplitByQtr', 'split-by-qtr', 'Split By Quarter', '0', 'split-by-qtr', 'LANDTAX', 'rptis.landtax.actions.SplitByQtr');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.SplitLedgerItem', 'split-bill-item', 'Split Ledger Item', '10', 'split-bill-item', 'landtax', 'rptis.landtax.actions.SplitLedgerItem');
INSERT INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('rptis.landtax.actions.UpdateAV', 'update-av', 'Update AV', '1000', 'update-av', 'LANDTAX', 'rptis.landtax.actions.UpdateAV');
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddBasic.av', 'rptis.landtax.actions.AddBasic', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddBasic.avfact', 'rptis.landtax.actions.AddBasic', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddBasic.year', 'rptis.landtax.actions.AddBasic', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddBillItem.taxsummary', 'rptis.landtax.actions.AddBillItem', 'taxsummary', '1', 'Tax Summary', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerTaxSummaryFact', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddFireCode.av', 'rptis.landtax.actions.AddFireCode', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddFireCode.avfact', 'rptis.landtax.actions.AddFireCode', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddFireCode.year', 'rptis.landtax.actions.AddFireCode', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddIdleLand.av', 'rptis.landtax.actions.AddIdleLand', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddIdleLand.avfact', 'rptis.landtax.actions.AddIdleLand', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddIdleLand.year', 'rptis.landtax.actions.AddIdleLand', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSef.av', 'rptis.landtax.actions.AddSef', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSef.avfact', 'rptis.landtax.actions.AddSef', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSef.year', 'rptis.landtax.actions.AddSef', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, 'integer', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.amtdue', 'rptis.landtax.actions.AddShare', 'amtdue', '5', 'Amount Due', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.billitem', 'rptis.landtax.actions.AddShare', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTBillItem', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.orgclass', 'rptis.landtax.actions.AddShare', 'orgclass', '2', 'Share Type', NULL, 'lov', NULL, NULL, NULL, NULL, 'RPT_BILLING_LGU_TYPES');
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.orgid', 'rptis.landtax.actions.AddShare', 'orgid', '3', 'Org', NULL, 'var', 'org:lookup', 'objid', 'name', 'String', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.payableparentacct', 'rptis.landtax.actions.AddShare', 'payableparentacct', '4', 'Payable Account', NULL, 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddShare.rate', 'rptis.landtax.actions.AddShare', 'rate', '6', 'Share (decimal)', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSocialHousing.av', 'rptis.landtax.actions.AddSocialHousing', 'av', '3', 'AV', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSocialHousing.avfact', 'rptis.landtax.actions.AddSocialHousing', 'avfact', '1', 'AV Info', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AddSocialHousing.year', 'rptis.landtax.actions.AddSocialHousing', 'year', '2', 'Year', NULL, 'var', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.AggregateLedgerItem.rptledgeritem', 'rptis.landtax.actions.AggregateLedgerItem', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcDiscount.expr', 'rptis.landtax.actions.CalcDiscount', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcDiscount.rptledgeritem', 'rptis.landtax.actions.CalcDiscount', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcInterest.expr', 'rptis.landtax.actions.CalcInterest', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcInterest.rptledgeritem', 'rptis.landtax.actions.CalcInterest', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcTax.expr', 'rptis.landtax.actions.CalcTax', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CalcTax.rptledgeritem', 'rptis.landtax.actions.CalcTax', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CreateTaxSummary.revperiod', 'rptis.landtax.actions.CreateTaxSummary', 'revperiod', '2', 'Revenue Period', NULL, 'lov', NULL, NULL, NULL, NULL, 'RPT_REVENUE_PERIODS');
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CreateTaxSummary.rptledgeritem', 'rptis.landtax.actions.CreateTaxSummary', 'rptledgeritem', '1', 'RPT Ledger Item', '', 'var', '', '', '', 'rptis.landtax.facts.RPTLedgerItemFact', '');
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.CreateTaxSummary.var', 'rptis.landtax.actions.CreateTaxSummary', 'var', '3', 'Variable Name', NULL, 'lookup', 'rptparameter:lookup', 'name', 'name', NULL, '');
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.RemoveLedgerItem.rptledgeritem', 'rptis.landtax.actions.RemoveLedgerItem', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.SetBillExpiryDate.bill', 'rptis.landtax.actions.SetBillExpiryDate', 'bill', '1', 'Bill', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.Bill', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.SetBillExpiryDate.expr', 'rptis.landtax.actions.SetBillExpiryDate', 'expr', '2', 'Expiry Date', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.SplitByQtr.rptledgeritem', 'rptis.landtax.actions.SplitByQtr', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.SplitLedgerItem.rptledgeritem', 'rptis.landtax.actions.SplitLedgerItem', 'rptledgeritem', '1', 'Ledger Item', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.RPTLedgerItemFact', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.UpdateAV.avfact', 'rptis.landtax.actions.UpdateAV', 'avfact', '1', 'Assessed Value', NULL, 'var', NULL, NULL, NULL, 'rptis.landtax.facts.AssessedValue', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('rptis.landtax.actions.UpdateAV.expr', 'rptis.landtax.actions.UpdateAV', 'expr', '2', 'Computation', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP-17442746:16be936f033:-7e80', 'RA-17442746:16be936f033:-7e82', 'rptis.landtax.actions.CalcTax.rptledgeritem', NULL, NULL, 'RC-17442746:16be936f033:-7e86', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP-17442746:16be936f033:-7e81', 'RA-17442746:16be936f033:-7e82', 'rptis.landtax.actions.CalcTax.expr', NULL, NULL, NULL, NULL, 'AV * 0.01', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP-54d69547:1795f1fd4a7:-7fb1', 'RA-54d69547:1795f1fd4a7:-7fb3', 'rptis.landtax.actions.UpdateAV.avfact', NULL, NULL, 'RC-54d69547:1795f1fd4a7:-7fbb', 'AVINFO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP-54d69547:1795f1fd4a7:-7fb2', 'RA-54d69547:1795f1fd4a7:-7fb3', 'rptis.landtax.actions.UpdateAV.expr', NULL, NULL, NULL, NULL, 'AV2017 * 1.1', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP-723fa88f:16955ccdab3:-7426', 'RA-723fa88f:16955ccdab3:-7428', 'rptis.landtax.actions.CalcDiscount.expr', NULL, NULL, NULL, NULL, '@ROUND(TAX * 0.10)', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP-723fa88f:16955ccdab3:-7427', 'RA-723fa88f:16955ccdab3:-7428', 'rptis.landtax.actions.CalcDiscount.rptledgeritem', NULL, NULL, 'RC-723fa88f:16955ccdab3:-742d', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP122cd182:16b250d7a42:-8f5', 'RA122cd182:16b250d7a42:-8f7', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RC122cd182:16b250d7a42:-8fe', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP122cd182:16b250d7a42:-8f6', 'RA122cd182:16b250d7a42:-8f7', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, '@ROUND(@IIF( NMON * 0.02 > 0.72, TAX * 0.72, TAX * NMON * 0.02))', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP37a59caa:17b4d4dd897:-7d92', 'RA37a59caa:17b4d4dd897:-7d94', 'rptis.landtax.actions.CreateTaxSummary.revperiod', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'prior', NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP37a59caa:17b4d4dd897:-7d93', 'RA37a59caa:17b4d4dd897:-7d94', 'rptis.landtax.actions.CreateTaxSummary.rptledgeritem', NULL, NULL, 'RC37a59caa:17b4d4dd897:-7d96', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP440e47f4:166ae4152f1:-7fba', 'RA440e47f4:166ae4152f1:-7fbc', 'rptis.landtax.actions.CreateTaxSummary.rptledgeritem', NULL, NULL, 'RC440e47f4:166ae4152f1:-7fc0', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP440e47f4:166ae4152f1:-7fbb', 'RA440e47f4:166ae4152f1:-7fbc', 'rptis.landtax.actions.CreateTaxSummary.revperiod', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'previous', NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP4de45266:17d362025ea:-7f26', 'RA4de45266:17d362025ea:-7f27', 'rptis.landtax.actions.SplitByQtr.rptledgeritem', NULL, NULL, 'RC4de45266:17d362025ea:-7f2b', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP5e852405:174ee003e4e:-7fde', 'RA5e852405:174ee003e4e:-7fe0', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, '@ROUND(TAX * 0.24)', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP5e852405:174ee003e4e:-7fdf', 'RA5e852405:174ee003e4e:-7fe0', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RC5e852405:174ee003e4e:-7fe4', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fa9', 'RA7280357:166235c1be7:-7fab', 'rptis.landtax.actions.CreateTaxSummary.rptledgeritem', NULL, NULL, 'RC7280357:166235c1be7:-7faf', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7faa', 'RA7280357:166235c1be7:-7fab', 'rptis.landtax.actions.CreateTaxSummary.revperiod', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'advance', NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fb0', 'RA7280357:166235c1be7:-7fb2', 'rptis.landtax.actions.CreateTaxSummary.rptledgeritem', NULL, NULL, 'RC7280357:166235c1be7:-7fb6', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fb1', 'RA7280357:166235c1be7:-7fb2', 'rptis.landtax.actions.CreateTaxSummary.revperiod', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'current', NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fb7', 'RA7280357:166235c1be7:-7fb9', 'rptis.landtax.actions.SetBillExpiryDate.bill', NULL, NULL, 'RC7280357:166235c1be7:-7fc0', 'BILL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fb8', 'RA7280357:166235c1be7:-7fb9', 'rptis.landtax.actions.SetBillExpiryDate.expr', NULL, NULL, NULL, NULL, '@MONTHEND(@DATE(CY, 12, 1));', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fca', 'RA7280357:166235c1be7:-7fcc', 'rptis.landtax.actions.CalcDiscount.rptledgeritem', NULL, NULL, 'RC7280357:166235c1be7:-7fd4', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RAP7280357:166235c1be7:-7fcb', 'RA7280357:166235c1be7:-7fcc', 'rptis.landtax.actions.CalcDiscount.expr', NULL, NULL, NULL, NULL, '@ROUND(TAX * 0.20)', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-7607', 'RACT-1a2d6e9b:1692d429304:-7649', 'rptis.landtax.actions.AddSef.av', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-7622', 'RACT-1a2d6e9b:1692d429304:-7649', 'rptis.landtax.actions.AddSef.year', NULL, NULL, 'RCONST-1a2d6e9b:1692d429304:-7747', 'YR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-7639', 'RACT-1a2d6e9b:1692d429304:-7649', 'rptis.landtax.actions.AddSef.avfact', NULL, NULL, 'RCOND-1a2d6e9b:1692d429304:-7748', 'AVINFO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-76bc', 'RACT-1a2d6e9b:1692d429304:-7700', 'rptis.landtax.actions.AddBasic.av', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-76d7', 'RACT-1a2d6e9b:1692d429304:-7700', 'rptis.landtax.actions.AddBasic.year', NULL, NULL, 'RCONST-1a2d6e9b:1692d429304:-7747', 'YR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-1a2d6e9b:1692d429304:-76ef', 'RACT-1a2d6e9b:1692d429304:-7700', 'rptis.landtax.actions.AddBasic.avfact', NULL, NULL, 'RCOND-1a2d6e9b:1692d429304:-7748', 'AVINFO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-202aff7b:17c72f23ba6:-7c0a', 'RACT-202aff7b:17c72f23ba6:-7c30', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, '0', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-202aff7b:17c72f23ba6:-7c20', 'RACT-202aff7b:17c72f23ba6:-7c30', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RCOND-202aff7b:17c72f23ba6:-7d15', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-259ddd03:17dc1aefe6f:-7a19', 'RACT-259ddd03:17dc1aefe6f:-7a3f', 'rptis.landtax.actions.CalcDiscount.expr', NULL, NULL, NULL, NULL, '0', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-259ddd03:17dc1aefe6f:-7a2f', 'RACT-259ddd03:17dc1aefe6f:-7a3f', 'rptis.landtax.actions.CalcDiscount.rptledgeritem', NULL, NULL, 'RCOND-202aff7b:17c72f23ba6:-7d15', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2ede6703:16642adb9ce:-7926', 'RACT-2ede6703:16642adb9ce:-794c', 'rptis.landtax.actions.SetBillExpiryDate.expr', NULL, NULL, NULL, NULL, '@MONTHEND( BILLDATE )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-2ede6703:16642adb9ce:-793c', 'RACT-2ede6703:16642adb9ce:-794c', 'rptis.landtax.actions.SetBillExpiryDate.bill', NULL, NULL, 'RCOND-2ede6703:16642adb9ce:-7a39', 'BILL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-7eb5c285:1795f11dd49:-55a8', 'RACT-7eb5c285:1795f11dd49:-55ce', 'rptis.landtax.actions.UpdateAV.expr', NULL, NULL, NULL, NULL, 'AV2017 * 1.5', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-7eb5c285:1795f11dd49:-55be', 'RACT-7eb5c285:1795f11dd49:-55ce', 'rptis.landtax.actions.UpdateAV.avfact', NULL, NULL, 'RCOND-7eb5c285:1795f11dd49:-5632', 'AVINFO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-8fbba9f:18007eb90b8:-70f4', 'RACT-8fbba9f:18007eb90b8:-711a', 'rptis.landtax.actions.CalcDiscount.expr', NULL, NULL, NULL, NULL, '0', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT-8fbba9f:18007eb90b8:-710a', 'RACT-8fbba9f:18007eb90b8:-711a', 'rptis.landtax.actions.CalcDiscount.rptledgeritem', NULL, NULL, 'RCOND-8fbba9f:18007eb90b8:-7172', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT2d3df8d1:17d2c8f0d4d:-783e', 'RACT2d3df8d1:17d2c8f0d4d:-7864', 'rptis.landtax.actions.CalcTax.expr', NULL, NULL, NULL, NULL, 'AV * 0.05', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT2d3df8d1:17d2c8f0d4d:-7854', 'RACT2d3df8d1:17d2c8f0d4d:-7864', 'rptis.landtax.actions.CalcTax.rptledgeritem', NULL, NULL, 'RCOND2d3df8d1:17d2c8f0d4d:-79c1', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT2d3df8d1:17d2c8f0d4d:-7a4c', 'RACT2d3df8d1:17d2c8f0d4d:-7a9e', 'rptis.landtax.actions.AddIdleLand.av', NULL, NULL, NULL, NULL, 'AV', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT2d3df8d1:17d2c8f0d4d:-7a6f', 'RACT2d3df8d1:17d2c8f0d4d:-7a9e', 'rptis.landtax.actions.AddIdleLand.year', NULL, NULL, 'RCONST2d3df8d1:17d2c8f0d4d:-7daf', 'YR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT2d3df8d1:17d2c8f0d4d:-7a8a', 'RACT2d3df8d1:17d2c8f0d4d:-7a9e', 'rptis.landtax.actions.AddIdleLand.avfact', NULL, NULL, 'RCOND2d3df8d1:17d2c8f0d4d:-7db0', 'AVINFO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT34b884c7:17ff889c416:-79fa', 'RACT34b884c7:17ff889c416:-7a20', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, '0', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT34b884c7:17ff889c416:-7a10', 'RACT34b884c7:17ff889c416:-7a20', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RCOND34b884c7:17ff889c416:-7adf', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT5ffbdc02:166e7b2c367:-6203', 'RACT5ffbdc02:166e7b2c367:-6229', 'rptis.landtax.actions.CalcInterest.expr', NULL, NULL, NULL, NULL, 'TAX * NMON * 0.02', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACT5ffbdc02:166e7b2c367:-6219', 'RACT5ffbdc02:166e7b2c367:-6229', 'rptis.landtax.actions.CalcInterest.rptledgeritem', NULL, NULL, 'RC70978a15:166ae6875d1:-7f22', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-248e', 'RACTec9d7ab:166235c2e16:-249a', 'rptis.landtax.actions.AddBillItem.taxsummary', NULL, NULL, 'RCONDec9d7ab:166235c2e16:-24fc', 'RLTS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-2e08', 'RACTec9d7ab:166235c2e16:-2e2e', 'rptis.landtax.actions.SetBillExpiryDate.expr', NULL, NULL, NULL, NULL, '@MONTHEND( CDATE )', 'expression', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-2e1e', 'RACTec9d7ab:166235c2e16:-2e2e', 'rptis.landtax.actions.SetBillExpiryDate.bill', NULL, NULL, 'RCONDec9d7ab:166235c2e16:-2ec7', 'BILL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-35a7', 'RACTec9d7ab:166235c2e16:-35b3', 'rptis.landtax.actions.SplitLedgerItem.rptledgeritem', NULL, NULL, 'RC7280357:166235c1be7:-7fc7', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-386d', 'RACTec9d7ab:166235c2e16:-3879', 'rptis.landtax.actions.AggregateLedgerItem.rptledgeritem', NULL, NULL, 'RCONDec9d7ab:166235c2e16:-3b0b', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_action_param` (`objid`, `parentid`, `actiondefparam_objid`, `stringvalue`, `booleanvalue`, `var_objid`, `var_name`, `expr`, `exprtype`, `pos`, `obj_key`, `obj_value`, `listvalue`, `lov`, `rangeoption`) VALUES ('RULACTec9d7ab:166235c2e16:-5b63', 'RACTec9d7ab:166235c2e16:-5b6f', 'rptis.landtax.actions.SplitByQtr.rptledgeritem', NULL, NULL, 'RCONDec9d7ab:166235c2e16:-5e7c', 'RLI', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
set foreign_key_checks = 1;

