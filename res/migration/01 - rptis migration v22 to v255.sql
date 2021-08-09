
-- drop unused columns
alter table etracs255_gigmoto.rptledger 
    drop column firstqtrpaidontime,
    drop column qtrlypaymentavailed,
    drop column qtrlypaymentpaidontime,
    drop column lastitemyear,
    drop column lastreceiptid,
    drop column advancebill,
    drop column lastbilledyear,
    drop column lastbilledqtr,
    drop column partialbasic,
    drop column partialbasicint,
    drop column partialbasicdisc,
    drop column partialsef,
    drop column partialsefint,
    drop column partialsefdisc,
    drop column partialledyear,
    drop column partialledqtr,
    drop column updateflag,
    drop column forcerecalcbill
;

-- cleanup 
delete from etracs255_gigmoto.rptledgeritem_qtrly;
delete from etracs255_gigmoto.rptledgeritem;
delete from etracs255_gigmoto.rptledgerfaas;
delete from etracs255_gigmoto.rptledger_item;
delete from etracs255_gigmoto.rptledger;


-- migrate v22 ledgers
insert into etracs255_gigmoto.rptledger (
    objid,
    state,
    faasid,
    nextbilldate,
    lastyearpaid,
    lastqtrpaid,
    barangayid,
    taxpayer_objid,
    fullpin,
    tdno,
    cadastrallotno,
    rputype,
    txntype_objid,
    classcode,
    totalav,
    totalmv,
    totalareaha,
    taxable,
    owner_name,
    prevtdno,
    classification_objid,
    titleno,
    administrator_name,
    blockno,
    lguid,
    beneficiary_objid
)
select distinct 
	rl.objid,
    rl.docstate as state,
    fl.objid as faasid,
    null as nextbilldate,
    rl.lastyearpaid,
    rl.lastqtrpaid,
    case when fl.objid is null 
			then (select concat('027-05-', indexno) from etracs22_gigmoto.lgu where lgutype = 'barangay' and lguname = rl.barangay)
			else fl.barangayid
	end as barangayid,
    fl.taxpayer_objid,
    rl.fullpin,
    rl.tdno,
    rl.cadastrallotno,
    rl.rputype,
    rl.txntype as txntype_objid,
    rl.classcode,
		ifnull(fl.totalav, fl2.totalav) as totalav,
		ifnull(fl.totalmv, fl2.totalmv) as totalmv,
		ifnull(fl.totalareaha, fl2.totalareaha) as totalareaha,
		ifnull(r.taxable, fl2.taxable) as taxable,
    ifnull(fl.owner_name, fl2.ownername) as owner_name,
    rl.prevtdno,
    case when fl.classification_objid is not null 
			then fl.classification_objid
		  else (select objid from etracs255_gigmoto.propertyclassification where code = rl.classcode)
		end as classification_objid,
    fl.titleno,
    ifnull(fl.administrator_name, rl.administratorname) as administrator_name,
    ifnull(fl.blockno, rl.blockno) as blockno,
    '027-05' as lguid,
    null as beneficiary_objid
from etracs22_gigmoto.rptledger rl 
inner join etracs22_gigmoto.faaslist fl2 on rl.faasid = fl2.objid 
left join etracs255_gigmoto.faas_list fl on rl.tdno = fl.tdno 
left join etracs255_gigmoto.rpu r on fl.rpuid = r.objid 
where rl.docstate <> 'CANCELLED' 
;



-- ledgerfaas
insert into etracs255_gigmoto.rptledgerfaas (
    objid,
    state,
    rptledgerid,
    faasid,
    tdno,
    txntype_objid,
    classification_objid,
    actualuse_objid,
    taxable,
    backtax,
    fromyear,
    fromqtr,
    toyear,
    toqtr,
    assessedvalue,
    systemcreated,
    reclassed,
    idleland
)
select 
    rli.objid,
    rli.docstate as state,
    rli.parentid as rptledgerid,
    null as faasid,
    rli.tdno,
    rli.txntype as txntype_objid,
    ifnull(pc.objid, rl.classification_objid) as classification_objid,
    ifnull(pc.objid, rl.classification_objid) as actualuse_objid,
    rli.taxable,
    rli.backtax,
    rli.fromyear,
    1 as fromqtr,
    rli.toyear,
    case when rli.toyear = 0 then 0 else 4 end as toqtr,
    rli.assessedvalue,
    rli.systemcreated,
    0 as reclassed,
    0 as idleland
from etracs22_gigmoto.rptledgeritem rli
inner join etracs255_gigmoto.rptledger rl on rli.parentid = rl.objid 
left join etracs255_gigmoto.propertyclassification pc on rli.classcode = pc.code 
;


-- update missing rptledger.taxpayer_objid based on name (individual)
drop table if exists etracs22_gigmoto.zzz_rptledger_taxpayer
;

create table etracs22_gigmoto.zzz_rptledger_taxpayer
select rl.objid, e.objid as taxpayer_objid 
from etracs255_gigmoto.rptledger rl 
inner join etracs22_gigmoto.rptledger rl2 on rl.objid = rl2.objid 
inner join etracs22_gigmoto.entity e2 on rl2.taxpayerid = e2.objid 
inner join etracs255_gigmoto.entity e on e.name = e2.entityname
where rl.taxpayer_objid is null
and e.type = 'individual'
;

create index ix_objid on etracs22_gigmoto.zzz_rptledger_taxpayer(objid)
;

update etracs255_gigmoto.rptledger rl, etracs22_gigmoto.zzz_rptledger_taxpayer z set 
	rl.taxpayer_objid = z.taxpayer_objid 
where rl.objid = z.objid 
;

drop table etracs22_gigmoto.zzz_rptledger_taxpayer
;


drop table if exists etracs22_gigmoto.zzz_rptledger_taxpayer
;

create table etracs22_gigmoto.zzz_rptledger_taxpayer
select rl.objid, e.objid as taxpayer_objid, e.name 
from etracs255_gigmoto.rptledger rl 
inner join etracs22_gigmoto.rptledger rl2 on rl.objid = rl2.objid 
inner join etracs22_gigmoto.entity e2 on rl2.taxpayerid = e2.objid 
inner join etracs255_gigmoto.entity e on e.name = e2.entityname 
where rl.taxpayer_objid is null
and e.type = 'juridical'
order by e.name
;

create index ix_objid on etracs22_gigmoto.zzz_rptledger_taxpayer(objid)
;

update etracs255_gigmoto.rptledger rl, etracs22_gigmoto.zzz_rptledger_taxpayer z set 
	rl.taxpayer_objid = z.taxpayer_objid 
where rl.objid = z.objid 
;

drop table etracs22_gigmoto.zzz_rptledger_taxpayer
;

drop table if exists etracs22_gigmoto.zzz_rptledger_taxpayer
;

create table etracs22_gigmoto.zzz_rptledger_taxpayer
select rl.objid, e.objid as taxpayer_objid, e.name 
from etracs255_gigmoto.rptledger rl 
inner join etracs22_gigmoto.rptledger rl2 on rl.objid = rl2.objid 
inner join etracs22_gigmoto.entity e2 on rl2.taxpayerid = e2.objid 
inner join etracs255_gigmoto.entity e on e.name = e2.entityname 
where rl.taxpayer_objid is null
and e.type = 'multiple'
;

create index ix_objid on etracs22_gigmoto.zzz_rptledger_taxpayer(objid)
;

update etracs255_gigmoto.rptledger rl, etracs22_gigmoto.zzz_rptledger_taxpayer z set 
	rl.taxpayer_objid = z.taxpayer_objid 
where rl.objid = z.objid 
;

drop table etracs22_gigmoto.zzz_rptledger_taxpayer
;


-- migrate payments
insert into etracs255_gigmoto.rptpayment (
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
    p.objid,
    LOWER(p.mode) as type,
    p.rptledgerid as refid,
    'rptledger' as reftype,
    null as receiptid,
    p.receiptno,
    p.receiptdate,
    ifnull(r.payorname, rl.taxpayername) as paidby_name,
    ifnull(r.payoraddress, rl.taxpayeraddress) as paidby_address,
    ifnull(r.collectorname, p.collectorname) as postedby,
    ifnull(ifnull(r.collectortitle, p.collectortitle), '-') as postedbytitle,
    p.receiptdate as dtposted,
    p.fromyear,
    p.fromqtr,
    p.toyear,
    p.toqtr,
    (p.basic + p.basicint - p.basicdisc + p.sef + p.sefint - p.sefdisc) as amount,
    'MTO' as collectingagency,
    p.voided
from etracs22_gigmoto.rptpayment p
inner join etracs22_gigmoto.rptledger rl on p.rptledgerid = rl.objid 
left join etracs22_gigmoto.receiptlist r on p.receiptid = r.objid  
;

-- basic 
insert into etracs255_gigmoto.rptpayment_item ( 
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
    concat(pd.objid, '-B') as objid,
    pd.rptpaymentid as parentid,
    (select objid from etracs255_gigmoto.rptledgerfaas where objid = pd.rptledgeritemid) as rptledgerfaasid,
    pd.year,
    pd.qtr,
    'basic' as revtype,
    pd.revtype as revperiod,
    pd.basic as amount,
    pd.basicint as interest,
    pd.basicdisc as discount,
    0 as partialled,
    10000 as priority
from etracs22_gigmoto.rptpaymentdetail pd 
;

-- sef 
insert into etracs255_gigmoto.rptpayment_item ( 
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
    concat(pd.objid, '-S') as objid,
    pd.rptpaymentid as parentid,
    (select objid from etracs255_gigmoto.rptledgerfaas where objid = pd.rptledgeritemid) as rptledgerfaasid,
    pd.year,
    pd.qtr,
    'sef' as revtype,
    pd.revtype as revperiod,
    pd.sef as amount,
    pd.sefint as interest,
    pd.sefdisc as discount,
    0 as partialled,
    10000 as priority
from etracs22_gigmoto.rptpaymentdetail pd 
;



use etracs255_gigmoto
;


drop view if exists vw_landtax_lgu_account_mapping
;

CREATE VIEW `vw_landtax_lgu_account_mapping` AS select `ia`.`org_objid` AS `org_objid`,`ia`.`org_name` AS `org_name`,`o`.`orgclass` AS `org_class`,`p`.`objid` AS `parent_objid`,`p`.`code` AS `parent_code`,`p`.`title` AS `parent_title`,`ia`.`objid` AS `item_objid`,`ia`.`code` AS `item_code`,`ia`.`title` AS `item_title`,`ia`.`fund_objid` AS `item_fund_objid`,`ia`.`fund_code` AS `item_fund_code`,`ia`.`fund_title` AS `item_fund_title`,`ia`.`type` AS `item_type`,`pt`.`tag` AS `item_tag` from (((`itemaccount` `ia` join `itemaccount` `p` on((`ia`.`parentid` = `p`.`objid`))) join `itemaccount_tag` `pt` on((`p`.`objid` = `pt`.`acctid`))) join `sys_org` `o` on((`ia`.`org_objid` = `o`.`objid`))) where (`p`.`state` = 'ACTIVE')
;

delete from account_item_mapping
where itemid in (
	select objid from itemaccount where objid like 'RPT_%'
)
;


INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'CATANDUANES RPT BASIC CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASICINT_CURRENT_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'CATANDUANES RPT BASIC PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASICINT_PREVIOUS_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'CATANDUANES RPT BASIC PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASICINT_PRIOR_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC ADVANCE PROVINCE SHARE', 'CATANDUANES RPT BASIC ADVANCE PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASIC_ADVANCE_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC CURRENT PROVINCE SHARE', 'CATANDUANES RPT BASIC CURRENT PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASIC_CURRENT_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC PREVIOUS PROVINCE SHARE', 'CATANDUANES RPT BASIC PREVIOUS PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASIC_PREVIOUS_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT BASIC PRIOR PROVINCE SHARE', 'CATANDUANES RPT BASIC PRIOR PROVINCE SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_BASIC_PRIOR_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_CURRENT_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF CURRENT PENALTY PROVINCE SHARE', 'CATANDUANES RPT SEF CURRENT PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEFINT_CURRENT_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PREVIOUS_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'CATANDUANES RPT SEF PREVIOUS PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEFINT_PREVIOUS_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PRIOR_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF PRIOR PENALTY PROVINCE SHARE', 'CATANDUANES RPT SEF PRIOR PENALTY PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEFINT_PRIOR_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_ADVANCE_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF ADVANCE PROVINCE SHARE', 'CATANDUANES RPT SEF ADVANCE PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEF_ADVANCE_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_CURRENT_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF CURRENT PROVINCE SHARE', 'CATANDUANES RPT SEF CURRENT PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEF_CURRENT_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PREVIOUS_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF PREVIOUS PROVINCE SHARE', 'CATANDUANES RPT SEF PREVIOUS PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEF_PREVIOUS_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PRIOR_PROVINCE_SHARE:027', 'ACTIVE', '-', 'CATANDUANES RPT SEF PRIOR PROVINCE SHARE', 'CATANDUANES RPT SEF PRIOR PROVINCE SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', '027', 'CATANDUANES', 'RPT_SEF_PRIOR_PROVINCE_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-05-0001', 'ACTIVE', '-', 'POBLACION DISTRICT I RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'POBLACION DISTRICT I RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0001', 'POBLACION DISTRICT I', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-05-0001', 'ACTIVE', '-', 'POBLACION DISTRICT I RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'POBLACION DISTRICT I RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0001', 'POBLACION DISTRICT I', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-05-0001', 'ACTIVE', '-', 'POBLACION DISTRICT I RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'POBLACION DISTRICT I RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0001', 'POBLACION DISTRICT I', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-05-0001', 'ACTIVE', '-', 'POBLACION DISTRICT I RPT BASIC ADVANCE BARANGAY SHARE', 'POBLACION DISTRICT I RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0001', 'POBLACION DISTRICT I', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-05-0001', 'ACTIVE', '-', 'POBLACION DISTRICT I RPT BASIC CURRENT BARANGAY SHARE', 'POBLACION DISTRICT I RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0001', 'POBLACION DISTRICT I', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-05-0001', 'ACTIVE', '-', 'POBLACION DISTRICT I RPT BASIC PREVIOUS BARANGAY SHARE', 'POBLACION DISTRICT I RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0001', 'POBLACION DISTRICT I', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-05-0001', 'ACTIVE', '-', 'POBLACION DISTRICT I RPT BASIC PRIOR BARANGAY SHARE', 'POBLACION DISTRICT I RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0001', 'POBLACION DISTRICT I', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-05-0002', 'ACTIVE', '-', 'POBLACION DISTRICT II RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'POBLACION DISTRICT II RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0002', 'POBLACION DISTRICT II', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-05-0002', 'ACTIVE', '-', 'POBLACION DISTRICT II RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'POBLACION DISTRICT II RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0002', 'POBLACION DISTRICT II', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-05-0002', 'ACTIVE', '-', 'POBLACION DISTRICT II RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'POBLACION DISTRICT II RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0002', 'POBLACION DISTRICT II', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-05-0002', 'ACTIVE', '-', 'POBLACION DISTRICT II RPT BASIC ADVANCE BARANGAY SHARE', 'POBLACION DISTRICT II RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0002', 'POBLACION DISTRICT II', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-05-0002', 'ACTIVE', '-', 'POBLACION DISTRICT II RPT BASIC CURRENT BARANGAY SHARE', 'POBLACION DISTRICT II RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0002', 'POBLACION DISTRICT II', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-05-0002', 'ACTIVE', '-', 'POBLACION DISTRICT II RPT BASIC PREVIOUS BARANGAY SHARE', 'POBLACION DISTRICT II RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0002', 'POBLACION DISTRICT II', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-05-0002', 'ACTIVE', '-', 'POBLACION DISTRICT II RPT BASIC PRIOR BARANGAY SHARE', 'POBLACION DISTRICT II RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0002', 'POBLACION DISTRICT II', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-05-0003', 'ACTIVE', '-', 'POBLACION DISTRICT III RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'POBLACION DISTRICT III RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0003', 'POBLACION DISTRICT III', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-05-0003', 'ACTIVE', '-', 'POBLACION DISTRICT III RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'POBLACION DISTRICT III RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0003', 'POBLACION DISTRICT III', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-05-0003', 'ACTIVE', '-', 'POBLACION DISTRICT III RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'POBLACION DISTRICT III RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0003', 'POBLACION DISTRICT III', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-05-0003', 'ACTIVE', '-', 'POBLACION DISTRICT III RPT BASIC ADVANCE BARANGAY SHARE', 'POBLACION DISTRICT III RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0003', 'POBLACION DISTRICT III', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-05-0003', 'ACTIVE', '-', 'POBLACION DISTRICT III RPT BASIC CURRENT BARANGAY SHARE', 'POBLACION DISTRICT III RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0003', 'POBLACION DISTRICT III', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-05-0003', 'ACTIVE', '-', 'POBLACION DISTRICT III RPT BASIC PREVIOUS BARANGAY SHARE', 'POBLACION DISTRICT III RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0003', 'POBLACION DISTRICT III', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-05-0003', 'ACTIVE', '-', 'POBLACION DISTRICT III RPT BASIC PRIOR BARANGAY SHARE', 'POBLACION DISTRICT III RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0003', 'POBLACION DISTRICT III', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-05-0004', 'ACTIVE', '-', 'BIONG RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'BIONG RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0004', 'BIONG', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-05-0004', 'ACTIVE', '-', 'BIONG RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'BIONG RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0004', 'BIONG', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-05-0004', 'ACTIVE', '-', 'BIONG RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'BIONG RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0004', 'BIONG', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-05-0004', 'ACTIVE', '-', 'BIONG RPT BASIC ADVANCE BARANGAY SHARE', 'BIONG RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0004', 'BIONG', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-05-0004', 'ACTIVE', '-', 'BIONG RPT BASIC CURRENT BARANGAY SHARE', 'BIONG RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0004', 'BIONG', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-05-0004', 'ACTIVE', '-', 'BIONG RPT BASIC PREVIOUS BARANGAY SHARE', 'BIONG RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0004', 'BIONG', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-05-0004', 'ACTIVE', '-', 'BIONG RPT BASIC PRIOR BARANGAY SHARE', 'BIONG RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0004', 'BIONG', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-05-0005', 'ACTIVE', '-', 'DORORIAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'DORORIAN RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0005', 'DORORIAN', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-05-0005', 'ACTIVE', '-', 'DORORIAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'DORORIAN RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0005', 'DORORIAN', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-05-0005', 'ACTIVE', '-', 'DORORIAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'DORORIAN RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0005', 'DORORIAN', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-05-0005', 'ACTIVE', '-', 'DORORIAN RPT BASIC ADVANCE BARANGAY SHARE', 'DORORIAN RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0005', 'DORORIAN', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-05-0005', 'ACTIVE', '-', 'DORORIAN RPT BASIC CURRENT BARANGAY SHARE', 'DORORIAN RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0005', 'DORORIAN', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-05-0005', 'ACTIVE', '-', 'DORORIAN RPT BASIC PREVIOUS BARANGAY SHARE', 'DORORIAN RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0005', 'DORORIAN', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-05-0005', 'ACTIVE', '-', 'DORORIAN RPT BASIC PRIOR BARANGAY SHARE', 'DORORIAN RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0005', 'DORORIAN', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-05-0006', 'ACTIVE', '-', 'SAN PEDRO RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'SAN PEDRO RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0006', 'SAN PEDRO', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-05-0006', 'ACTIVE', '-', 'SAN PEDRO RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'SAN PEDRO RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0006', 'SAN PEDRO', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-05-0006', 'ACTIVE', '-', 'SAN PEDRO RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'SAN PEDRO RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0006', 'SAN PEDRO', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-05-0006', 'ACTIVE', '-', 'SAN PEDRO RPT BASIC ADVANCE BARANGAY SHARE', 'SAN PEDRO RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0006', 'SAN PEDRO', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-05-0006', 'ACTIVE', '-', 'SAN PEDRO RPT BASIC CURRENT BARANGAY SHARE', 'SAN PEDRO RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0006', 'SAN PEDRO', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-05-0006', 'ACTIVE', '-', 'SAN PEDRO RPT BASIC PREVIOUS BARANGAY SHARE', 'SAN PEDRO RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0006', 'SAN PEDRO', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-05-0006', 'ACTIVE', '-', 'SAN PEDRO RPT BASIC PRIOR BARANGAY SHARE', 'SAN PEDRO RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0006', 'SAN PEDRO', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-05-0007', 'ACTIVE', '-', 'SAN VICENTE RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'SAN VICENTE RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0007', 'SAN VICENTE', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-05-0007', 'ACTIVE', '-', 'SAN VICENTE RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'SAN VICENTE RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0007', 'SAN VICENTE', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-05-0007', 'ACTIVE', '-', 'SAN VICENTE RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'SAN VICENTE RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0007', 'SAN VICENTE', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-05-0007', 'ACTIVE', '-', 'SAN VICENTE RPT BASIC ADVANCE BARANGAY SHARE', 'SAN VICENTE RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0007', 'SAN VICENTE', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-05-0007', 'ACTIVE', '-', 'SAN VICENTE RPT BASIC CURRENT BARANGAY SHARE', 'SAN VICENTE RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0007', 'SAN VICENTE', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-05-0007', 'ACTIVE', '-', 'SAN VICENTE RPT BASIC PREVIOUS BARANGAY SHARE', 'SAN VICENTE RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0007', 'SAN VICENTE', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-05-0007', 'ACTIVE', '-', 'SAN VICENTE RPT BASIC PRIOR BARANGAY SHARE', 'SAN VICENTE RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0007', 'SAN VICENTE', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-05-0008', 'ACTIVE', '-', 'SICMIL RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'SICMIL RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0008', 'SICMIL', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-05-0008', 'ACTIVE', '-', 'SICMIL RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'SICMIL RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0008', 'SICMIL', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-05-0008', 'ACTIVE', '-', 'SICMIL RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'SICMIL RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0008', 'SICMIL', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-05-0008', 'ACTIVE', '-', 'SICMIL RPT BASIC ADVANCE BARANGAY SHARE', 'SICMIL RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0008', 'SICMIL', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-05-0008', 'ACTIVE', '-', 'SICMIL RPT BASIC CURRENT BARANGAY SHARE', 'SICMIL RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0008', 'SICMIL', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-05-0008', 'ACTIVE', '-', 'SICMIL RPT BASIC PREVIOUS BARANGAY SHARE', 'SICMIL RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0008', 'SICMIL', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-05-0008', 'ACTIVE', '-', 'SICMIL RPT BASIC PRIOR BARANGAY SHARE', 'SICMIL RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0008', 'SICMIL', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE:027-05-0009', 'ACTIVE', '-', 'SIORON RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'SIORON RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0009', 'SIORON', 'RPT_BASICINT_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE:027-05-0009', 'ACTIVE', '-', 'SIORON RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'SIORON RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0009', 'SIORON', 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE:027-05-0009', 'ACTIVE', '-', 'SIORON RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'SIORON RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0009', 'SIORON', 'RPT_BASICINT_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE:027-05-0009', 'ACTIVE', '-', 'SIORON RPT BASIC ADVANCE BARANGAY SHARE', 'SIORON RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0009', 'SIORON', 'RPT_BASIC_ADVANCE_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE:027-05-0009', 'ACTIVE', '-', 'SIORON RPT BASIC CURRENT BARANGAY SHARE', 'SIORON RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0009', 'SIORON', 'RPT_BASIC_CURRENT_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE:027-05-0009', 'ACTIVE', '-', 'SIORON RPT BASIC PREVIOUS BARANGAY SHARE', 'SIORON RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0009', 'SIORON', 'RPT_BASIC_PREVIOUS_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE:027-05-0009', 'ACTIVE', '-', 'SIORON RPT BASIC PRIOR BARANGAY SHARE', 'SIORON RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '027-05-0009', 'SIORON', 'RPT_BASIC_PRIOR_BRGY_SHARE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_CURRENT:02705', 'ACTIVE', '-', 'GIGMOTO RPT BASIC PENALTY CURRENT', 'GIGMOTO RPT BASIC PENALTY CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_BASICINT_CURRENT', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PREVIOUS:02705', 'ACTIVE', '-', 'GIGMOTO RPT BASIC PENALTY PREVIOUS', 'GIGMOTO RPT BASIC PENALTY PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_BASICINT_PREVIOUS', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASICINT_PRIOR:02705', 'ACTIVE', '-', 'GIGMOTO RPT BASIC PENALTY PRIOR', 'GIGMOTO RPT BASIC PENALTY PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_BASICINT_PRIOR', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_ADVANCE:02705', 'ACTIVE', '-', 'GIGMOTO RPT BASIC ADVANCE', 'GIGMOTO RPT BASIC ADVANCE', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_BASIC_ADVANCE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_CURRENT:02705', 'ACTIVE', '-', 'GIGMOTO RPT BASIC CURRENT', 'GIGMOTO RPT BASIC CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_BASIC_CURRENT', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PREVIOUS:02705', 'ACTIVE', '-', 'GIGMOTO RPT BASIC PREVIOUS', 'GIGMOTO RPT BASIC PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_BASIC_PREVIOUS', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_BASIC_PRIOR:02705', 'ACTIVE', '-', 'GIGMOTO RPT BASIC PRIOR', 'GIGMOTO RPT BASIC PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_BASIC_PRIOR', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_CURRENT:02705', 'ACTIVE', '-', 'GIGMOTO RPT SEF PENALTY CURRENT', 'GIGMOTO RPT SEF PENALTY CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_SEFINT_CURRENT', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PREVIOUS:02705', 'ACTIVE', '-', 'GIGMOTO RPT SEF PENALTY PREVIOUS', 'GIGMOTO RPT SEF PENALTY PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_SEFINT_PREVIOUS', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEFINT_PRIOR:02705', 'ACTIVE', '-', 'GIGMOTO RPT SEF PENALTY PRIOR', 'GIGMOTO RPT SEF PENALTY PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_SEFINT_PRIOR', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_ADVANCE:02705', 'ACTIVE', '-', 'GIGMOTO RPT SEF ADVANCE', 'GIGMOTO RPT SEF ADVANCE', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_SEF_ADVANCE', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_CURRENT:02705', 'ACTIVE', '-', 'GIGMOTO RPT SEF CURRENT', 'GIGMOTO RPT SEF CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_SEF_CURRENT', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PREVIOUS:02705', 'ACTIVE', '-', 'GIGMOTO RPT SEF PREVIOUS', 'GIGMOTO RPT SEF PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_SEF_PREVIOUS', '0', '0', '0');
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`, `generic`, `sortorder`, `hidefromlookup`) VALUES ('RPT_SEF_PRIOR:02705', 'ACTIVE', '-', 'GIGMOTO RPT SEF PRIOR', 'GIGMOTO RPT SEF PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', '02705', 'GIGMOTO', 'RPT_SEF_PRIOR', '0', '0', '0');




CREATE TABLE `cashreceipt_rpt_share_forposting` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `rptledgerid` varchar(50) NOT NULL,
  `txndate` datetime NOT NULL,
  `error` int(255) NOT NULL,
  `msg` text,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_receiptid_rptledgerid` (`receiptid`,`rptledgerid`),
  KEY `fk_cashreceipt_rpt_share_forposing_rptledger` (`rptledgerid`),
  KEY `fk_cashreceipt_rpt_share_forposing_cashreceipt` (`receiptid`),
  CONSTRAINT `fk_cashreceipt_rpt_share_forposing_cashreceipt` FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`),
  CONSTRAINT `fk_cashreceipt_rpt_share_forposing_rptledger` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
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

alter table assessmentnotice add deliverytype_objid varchar(50)
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
  `validity` date DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_txnno` (`txnno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `batch_rpttaxcredit_ledger` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `error` varchar(255) DEFAULT NULL,
  `barangayid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_state` (`state`),
  KEY `ix_barangayid` (`barangayid`),
  CONSTRAINT `fk_rpttaxcredit_rptledger_parent` FOREIGN KEY (`parentid`) REFERENCES `batch_rpttaxcredit` (`objid`),
  CONSTRAINT `fk_rpttaxcredit_rptledger_rptledger` FOREIGN KEY (`objid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `batch_rpttaxcredit_ledger_posted` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_barangayid` (`barangayid`),
  CONSTRAINT `fk_rpttaxcredit_rptledger_posted_parent` FOREIGN KEY (`parentid`) REFERENCES `batch_rpttaxcredit` (`objid`),
  CONSTRAINT `fk_rpttaxcredit_rptledger_posted_rptledger` FOREIGN KEY (`objid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

drop table if exists batchgr_error;
drop table if exists batchgr_log;
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
  `txntype_objid` varchar(50) DEFAULT NULL,
  `txnno` varchar(25) DEFAULT NULL,
  `txndate` datetime DEFAULT NULL,
  `effectivityyear` int(11) DEFAULT NULL,
  `effectivityqtr` int(11) DEFAULT NULL,
  `originlgu_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_barangay_objid` (`barangay_objid`) USING BTREE,
  KEY `ix_state` (`state`) USING BTREE,
  KEY `fk_lgu_objid` (`lgu_objid`) USING BTREE,
  KEY `ix_ry` (`ry`) USING BTREE,
  KEY `ix_txnno` (`txnno`) USING BTREE,
  KEY `ix_classificationid` (`classification_objid`) USING BTREE,
  KEY `ix_section` (`section`) USING BTREE,
  CONSTRAINT `batchgr_ibfk_1` FOREIGN KEY (`barangay_objid`) REFERENCES `sys_org` (`objid`),
  CONSTRAINT `batchgr_ibfk_2` FOREIGN KEY (`classification_objid`) REFERENCES `propertyclassification` (`objid`),
  CONSTRAINT `batchgr_ibfk_3` FOREIGN KEY (`lgu_objid`) REFERENCES `sys_org` (`objid`),
  CONSTRAINT `fk_batchgr_barangayid` FOREIGN KEY (`barangay_objid`) REFERENCES `sys_org` (`objid`),
  CONSTRAINT `fk_batchgr_classificationid` FOREIGN KEY (`classification_objid`) REFERENCES `propertyclassification` (`objid`),
  CONSTRAINT `fk_batchgr_lguid` FOREIGN KEY (`lgu_objid`) REFERENCES `sys_org` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `batchgr_task` (
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
  `returnedby` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_assignee_objid` (`assignee_objid`),
  KEY `ix_refid` (`refid`),
  CONSTRAINT `fk_batchgr_task_batchgr` FOREIGN KEY (`refid`) REFERENCES `batchgr` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

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
  `subsuffix` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_batchgr_item_batchgr` (`parent_objid`) USING BTREE,
  KEY `fk_batchgr_item_newfaasid` (`newfaasid`) USING BTREE,
  KEY `fk_batchgr_item_tdno` (`tdno`) USING BTREE,
  KEY `fk_batchgr_item_pin` (`pin`) USING BTREE,
  CONSTRAINT `batchgr_item_ibfk_1` FOREIGN KEY (`parent_objid`) REFERENCES `batchgr` (`objid`),
  CONSTRAINT `batchgr_item_ibfk_2` FOREIGN KEY (`objid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `batchgr_item_ibfk_3` FOREIGN KEY (`newfaasid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `batchgr_item_ibfk_4` FOREIGN KEY (`objid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `fk_batchgr_item_faas` FOREIGN KEY (`objid`) REFERENCES `faas` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



alter table `bldgrpu` add dtconstructed	date, 
	add occpermitno	varchar(25);

alter table faas_task add returnedby	varchar(100);
alter table subdivision_task add returnedby	varchar(100);
alter table consolidation_task add returnedby	varchar(100);
alter table cancelledfaas_task add returnedby	varchar(100);
alter table resection_task add returnedby	varchar(100);

alter table examiner_finding add inspectedby_objid	varchar(50),
	add inspectedby_name	varchar(100),
	add inspectedby_title	varchar(50),
	add doctype	varchar(50)
;

alter table faas_previous  add prevtaxability varchar(25)
;

CREATE TABLE `faasannotation_faas` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `faas_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_parent_faas` (`parent_objid`,`faas_objid`),
  KEY `ix_parent_objid` (`parent_objid`),
  KEY `ix_faas_objid` (`faas_objid`),
  CONSTRAINT `fk_faasannotationfaas_faas` FOREIGN KEY (`faas_objid`) REFERENCES `faas` (`objid`),
  CONSTRAINT `fk_faasannotationfaas_faasannotation` FOREIGN KEY (`parent_objid`) REFERENCES `faasannotation` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table `machdetail` add smvid varchar(50)
;

alter table `machdetail` add params text 
;

update `machdetail` set params = '[]' where params is null
;

CREATE TABLE `machine_smv` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `machine_objid` varchar(50) NOT NULL,
  `expr` varchar(255) NOT NULL,
  `previd` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parent_objid` (`parent_objid`) USING BTREE,
  KEY `ix_machine_objid` (`machine_objid`) USING BTREE,
  KEY `ix_previd` (`previd`) USING BTREE,
  CONSTRAINT `fk_machinesmv_machine` FOREIGN KEY (`machine_objid`) REFERENCES `machine` (`objid`),
  CONSTRAINT `fk_machinesmv_machinesmv` FOREIGN KEY (`previd`) REFERENCES `machine_smv` (`objid`),
  CONSTRAINT `fk_machinesmv_machrysetting` FOREIGN KEY (`parent_objid`) REFERENCES `machrysetting` (`objid`),
  CONSTRAINT `machine_smv_ibfk_1` FOREIGN KEY (`machine_objid`) REFERENCES `machine` (`objid`),
  CONSTRAINT `machine_smv_ibfk_2` FOREIGN KEY (`previd`) REFERENCES `machine_smv` (`objid`),
  CONSTRAINT `machine_smv_ibfk_3` FOREIGN KEY (`parent_objid`) REFERENCES `machrysetting` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


alter table `machrpu` add smvid varchar(50);

alter table `machrpu` add params text 
;

update `machrpu` set params = '[]' where params is null
;

alter table memoranda_template add fields text
;

drop table if exists resectionaffectedrpu;
drop table if exists resection_item;
drop table if exists resection_task;
drop table if exists resectionitem;
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
  `newfaas_claimno` varchar(25) DEFAULT NULL,
  `faas_claimno` varchar(25) DEFAULT NULL,
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

drop table if exists rpt_syncdata_forsync;
drop table if exists rpt_syncdata_error;
drop table if exists rpt_syncdata_completed;
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
  KEY `ix_refno` (`refno`),
  KEY `ix_orgid` (`orgid`),
  KEY `ix_state` (`state`)
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

alter table `rptcompromise_item` add qtr int;


alter table `rptledger_item`  add fromqtr int, 
	add toqtr int;

CREATE TABLE `rptledger_redflag` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `caseno` varchar(25) DEFAULT NULL,
  `dtfiled` datetime DEFAULT NULL,
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
  `dtresolved` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_caseno` (`caseno`),
  KEY `ix_parent_objid` (`parent_objid`),
  KEY `ix_state` (`state`),
  KEY `ix_type` (`type`),
  KEY `ix_filedby_objid` (`filedby_objid`),
  KEY `ix_resolvedby_objid` (`resolvedby_objid`),
  CONSTRAINT `fk_rptledger_redflag_filedby` FOREIGN KEY (`filedby_objid`) REFERENCES `sys_user` (`objid`),
  CONSTRAINT `fk_rptledger_redflag_resolvedby` FOREIGN KEY (`resolvedby_objid`) REFERENCES `sys_user` (`objid`),
  CONSTRAINT `fk_rptledger_redflag_rptledger` FOREIGN KEY (`parent_objid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table rptpayment_share add iscommon	int(11),
	add `year`	int(11)
;


drop table if exists rpttask
;

CREATE TABLE `rpttask` (
  `taskid` varchar(50) NOT NULL,
  `objid` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `filetype` varchar(50) NOT NULL,
  `msg` varchar(100) DEFAULT NULL,
  `startdate` datetime NOT NULL,
  `enddate` datetime DEFAULT NULL,
  `createdby_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(150) NOT NULL,
  `createdby_title` varchar(50) DEFAULT NULL,
  `assignedto_objid` varchar(50) DEFAULT NULL,
  `assignedto_name` varchar(150) DEFAULT NULL,
  `assignedto_title` varchar(50) DEFAULT NULL,
  `workflowid` varchar(50) DEFAULT NULL,
  `signatory` varchar(50) DEFAULT NULL,
  `docname` varchar(50) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`taskid`),
  KEY `ix_rpttask_assignedto_enddate` (`assignedto_objid`,`enddate`),
  KEY `ix_rpttask_assignedto_name` (`assignedto_name`),
  KEY `ix_rpttask_assignedto_objid` (`assignedto_objid`),
  KEY `ix_rpttask_createdby_name` (`createdby_name`),
  KEY `ix_rpttask_createdby_objid` (`createdby_objid`),
  KEY `ix_rpttask_enddate` (`enddate`),
  KEY `ix_rpttask_objid` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table rpttaxclearance add reporttype	varchar(15)
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
  `info` text,
  `discapplied` decimal(16,2) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_txnno` (`txnno`),
  KEY `ix_state` (`state`),
  KEY `ix_type` (`type`),
  KEY `ix_reftype` (`reftype`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_rptledger_objid` (`rptledger_objid`),
  KEY `ix_srcledger_objid` (`srcledger_objid`),
  KEY `fk_rpttaxcredit_sys_user` (`approvedby_objid`),
  CONSTRAINT `fk_rpttaxcredit_rptledger` FOREIGN KEY (`rptledger_objid`) REFERENCES `rptledger` (`objid`),
  CONSTRAINT `fk_rpttaxcredit_srcledger` FOREIGN KEY (`srcledger_objid`) REFERENCES `rptledger` (`objid`),
  CONSTRAINT `fk_rpttaxcredit_sys_user` FOREIGN KEY (`approvedby_objid`) REFERENCES `sys_user` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table rpu add isonline	int(11),
	add stewardparentrpumasterid	varchar(50)
;

CREATE TABLE `subdivision_assist` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) NOT NULL,
  `taskstate` varchar(50) NOT NULL,
  `assignee_objid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_parent_assignee` (`parent_objid`,`taskstate`,`assignee_objid`),
  KEY `ix_parent_objid` (`parent_objid`),
  KEY `ix_assignee_objid` (`assignee_objid`),
  CONSTRAINT `fk_subdivision_assist_subdivision` FOREIGN KEY (`parent_objid`) REFERENCES `subdivision` (`objid`),
  CONSTRAINT `fk_subdivision_assist_user` FOREIGN KEY (`assignee_objid`) REFERENCES `sys_user` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
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
  PRIMARY KEY (`objid`),
  KEY `ix_subdivision_objid` (`subdivision_objid`),
  KEY `ix_parent_objid` (`parent_objid`),
  CONSTRAINT `fk_subdivision_assist_item_subdivision` FOREIGN KEY (`subdivision_objid`) REFERENCES `subdivision` (`objid`),
  CONSTRAINT `fk_subdivision_assist_item_subdivision_assist` FOREIGN KEY (`parent_objid`) REFERENCES `subdivision_assist` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE VIEW `vw_assessment_notice` AS select `a`.`objid` AS `objid`,`a`.`state` AS `state`,`a`.`txnno` AS `txnno`,`a`.`txndate` AS `txndate`,`a`.`taxpayerid` AS `taxpayerid`,`a`.`taxpayername` AS `taxpayername`,`a`.`taxpayeraddress` AS `taxpayeraddress`,`a`.`dtdelivered` AS `dtdelivered`,`a`.`receivedby` AS `receivedby`,`a`.`remarks` AS `remarks`,`a`.`assessmentyear` AS `assessmentyear`,`a`.`administrator_name` AS `administrator_name`,`a`.`administrator_address` AS `administrator_address`,`fl`.`tdno` AS `tdno`,`fl`.`displaypin` AS `fullpin`,`fl`.`cadastrallotno` AS `cadastrallotno`,`fl`.`titleno` AS `titleno` from ((`assessmentnotice` `a` join `assessmentnoticeitem` `i` on((`a`.`objid` = `i`.`assessmentnoticeid`))) join `faas_list` `fl` on((`i`.`faasid` = `fl`.`objid`)))
;
CREATE VIEW `vw_assessment_notice_item` AS select `ni`.`objid` AS `objid`,`ni`.`assessmentnoticeid` AS `assessmentnoticeid`,`f`.`objid` AS `faasid`,`f`.`effectivityyear` AS `effectivityyear`,`f`.`effectivityqtr` AS `effectivityqtr`,`f`.`tdno` AS `tdno`,`f`.`taxpayer_objid` AS `taxpayer_objid`,`e`.`name` AS `taxpayer_name`,`e`.`address_text` AS `taxpayer_address`,`f`.`owner_name` AS `owner_name`,`f`.`owner_address` AS `owner_address`,`f`.`administrator_name` AS `administrator_name`,`f`.`administrator_address` AS `administrator_address`,`f`.`rpuid` AS `rpuid`,`f`.`lguid` AS `lguid`,`f`.`txntype_objid` AS `txntype_objid`,`ft`.`displaycode` AS `txntype_code`,`rpu`.`rputype` AS `rputype`,`rpu`.`ry` AS `ry`,`rpu`.`fullpin` AS `fullpin`,`rpu`.`taxable` AS `taxable`,`rpu`.`totalareaha` AS `totalareaha`,`rpu`.`totalareasqm` AS `totalareasqm`,`rpu`.`totalbmv` AS `totalbmv`,`rpu`.`totalmv` AS `totalmv`,`rpu`.`totalav` AS `totalav`,`rp`.`section` AS `section`,`rp`.`parcel` AS `parcel`,`rp`.`surveyno` AS `surveyno`,`rp`.`cadastrallotno` AS `cadastrallotno`,`rp`.`blockno` AS `blockno`,`rp`.`claimno` AS `claimno`,`rp`.`street` AS `street`,`o`.`name` AS `lguname`,`b`.`name` AS `barangay`,`pc`.`code` AS `classcode`,`pc`.`name` AS `classification` from (((((((((`assessmentnoticeitem` `ni` join `faas` `f` on((`ni`.`faasid` = `f`.`objid`))) left join `txnsignatory` `ts` on(((`ts`.`refid` = `f`.`objid`) and (`ts`.`type` = 'APPROVER')))) join `rpu` on((`f`.`rpuid` = `rpu`.`objid`))) join `propertyclassification` `pc` on((`rpu`.`classification_objid` = `pc`.`objid`))) join `realproperty` `rp` on((`f`.`realpropertyid` = `rp`.`objid`))) join `barangay` `b` on((`rp`.`barangayid` = `b`.`objid`))) join `sys_org` `o` on((`f`.`lguid` = `o`.`objid`))) join `entity` `e` on((`f`.`taxpayer_objid` = `e`.`objid`))) join `faas_txntype` `ft` on((`f`.`txntype_objid` = `ft`.`objid`)))
;

CREATE VIEW `vw_batchgr` AS select `bg`.`objid` AS `objid`,`bg`.`state` AS `state`,`bg`.`ry` AS `ry`,`bg`.`lgu_objid` AS `lgu_objid`,`bg`.`barangay_objid` AS `barangay_objid`,`bg`.`rputype` AS `rputype`,`bg`.`classification_objid` AS `classification_objid`,`bg`.`section` AS `section`,`bg`.`memoranda` AS `memoranda`,`bg`.`txntype_objid` AS `txntype_objid`,`bg`.`txnno` AS `txnno`,`bg`.`txndate` AS `txndate`,`bg`.`effectivityyear` AS `effectivityyear`,`bg`.`effectivityqtr` AS `effectivityqtr`,`bg`.`originlgu_objid` AS `originlgu_objid`,`l`.`name` AS `lgu_name`,`b`.`name` AS `barangay_name`,`b`.`pin` AS `barangay_pin`,`pc`.`name` AS `classification_name`,`t`.`objid` AS `taskid`,`t`.`state` AS `taskstate`,`t`.`assignee_objid` AS `assignee_objid` from ((((`batchgr` `bg` join `sys_org` `l` on((`bg`.`lgu_objid` = `l`.`objid`))) left join `barangay` `b` on((`bg`.`barangay_objid` = `b`.`objid`))) left join `propertyclassification` `pc` on((`bg`.`classification_objid` = `pc`.`objid`))) left join `batchgr_task` `t` on(((`bg`.`objid` = `t`.`refid`) and isnull(`t`.`enddate`))))
;
CREATE VIEW `vw_batch_rpttaxcredit_error` AS select `br`.`objid` AS `objid`,`br`.`parentid` AS `parentid`,`br`.`state` AS `state`,`br`.`error` AS `error`,`br`.`barangayid` AS `barangayid`,`rl`.`tdno` AS `tdno` from (`batch_rpttaxcredit_ledger` `br` join `rptledger` `rl` on((`br`.`objid` = `rl`.`objid`))) where (`br`.`state` = 'ERROR')
;

drop VIEW if exists `vw_faas_lookup` 
;
CREATE VIEW `vw_faas_lookup` AS select `fl`.`objid` AS `objid`,`fl`.`state` AS `state`,`fl`.`rpuid` AS `rpuid`,`fl`.`utdno` AS `utdno`,`fl`.`tdno` AS `tdno`,`fl`.`txntype_objid` AS `txntype_objid`,`fl`.`effectivityyear` AS `effectivityyear`,`fl`.`effectivityqtr` AS `effectivityqtr`,`fl`.`taxpayer_objid` AS `taxpayer_objid`,`fl`.`owner_name` AS `owner_name`,`fl`.`owner_address` AS `owner_address`,`fl`.`prevtdno` AS `prevtdno`,`fl`.`cancelreason` AS `cancelreason`,`fl`.`cancelledbytdnos` AS `cancelledbytdnos`,`fl`.`lguid` AS `lguid`,`fl`.`realpropertyid` AS `realpropertyid`,`fl`.`displaypin` AS `fullpin`,`fl`.`originlguid` AS `originlguid`,`e`.`name` AS `taxpayer_name`,`e`.`address_text` AS `taxpayer_address`,`pc`.`code` AS `classification_code`,`pc`.`code` AS `classcode`,`pc`.`name` AS `classification_name`,`pc`.`name` AS `classname`,`fl`.`ry` AS `ry`,`fl`.`rputype` AS `rputype`,`fl`.`totalmv` AS `totalmv`,`fl`.`totalav` AS `totalav`,`fl`.`totalareasqm` AS `totalareasqm`,`fl`.`totalareaha` AS `totalareaha`,`fl`.`barangayid` AS `barangayid`,`fl`.`cadastrallotno` AS `cadastrallotno`,`fl`.`blockno` AS `blockno`,`fl`.`surveyno` AS `surveyno`,`fl`.`pin` AS `pin`,`fl`.`barangay` AS `barangay_name`,`fl`.`trackingno` AS `trackingno` from ((`faas_list` `fl` left join `propertyclassification` `pc` on((`fl`.`classification_objid` = `pc`.`objid`))) left join `entity` `e` on((`fl`.`taxpayer_objid` = `e`.`objid`)))
;




drop table if exists report_rptdelinquency_forprocess;
drop table if exists report_rptdelinquency_item;
drop table if exists report_rptdelinquency_error;
drop table if exists report_rptdelinquency_barangay;
drop table if exists report_rptdelinquency;


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

CREATE TABLE `report_rptdelinquency_forprocess` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_barangayid` (`barangayid`)
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
  PRIMARY KEY (`objid`),
  KEY `fk_rptdelinquency_item_rptdelinquency` (`parentid`),
  KEY `fk_rptdelinquency_item_rptledger` (`rptledgerid`),
  KEY `fk_rptdelinquency_item_barangay` (`barangayid`),
  KEY `fk_rptdelinquency_barangay_rptdelinquency` (`parentid`),
  CONSTRAINT `fk_rptdelinquency_item_barangay` FOREIGN KEY (`barangayid`) REFERENCES `barangay` (`objid`),
  CONSTRAINT `fk_rptdelinquency_item_rptdelinquency` FOREIGN KEY (`parentid`) REFERENCES `report_rptdelinquency` (`objid`),
  CONSTRAINT `fk_rptdelinquency_item_rptledger` FOREIGN KEY (`rptledgerid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `report_rptdelinquency_error` (
  `objid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `error` text,
  `ignored` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_barangayid` (`barangayid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `report_rptdelinquency_barangay` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `barangayid` varchar(50) NOT NULL,
  `count` int(11) NOT NULL,
  `processed` int(11) NOT NULL,
  `errors` int(11) NOT NULL,
  `ignored` int(11) NOT NULL,
  `idx` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_rptdelinquency_barangay_rptdelinquency` (`parentid`),
  KEY `fk_rptdelinquency_barangay_barangay` (`barangayid`),
  CONSTRAINT `fk_rptdelinquency_barangay_barangay` FOREIGN KEY (`barangayid`) REFERENCES `barangay` (`objid`),
  CONSTRAINT `fk_rptdelinquency_barangay_rptdelinquency` FOREIGN KEY (`parentid`) REFERENCES `report_rptdelinquency` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



drop VIEW if exists `vw_landtax_report_rptdelinquency_detail`
;
drop VIEW if exists `vw_landtax_report_rptdelinquency`
;

CREATE VIEW `vw_landtax_report_rptdelinquency` AS select `ri`.`objid` AS `objid`,`ri`.`rptledgerid` AS `rptledgerid`,`ri`.`barangayid` AS `barangayid`,`ri`.`year` AS `year`,`ri`.`qtr` AS `qtr`,`r`.`dtgenerated` AS `dtgenerated`,`r`.`dtcomputed` AS `dtcomputed`,`r`.`generatedby_name` AS `generatedby_name`,`r`.`generatedby_title` AS `generatedby_title`,(case when (`ri`.`revtype` = 'basic') then `ri`.`amount` else 0 end) AS `basic`,(case when (`ri`.`revtype` = 'basic') then `ri`.`interest` else 0 end) AS `basicint`,(case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0 end) AS `basicdisc`,(case when (`ri`.`revtype` = 'basic') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicdp`,(case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicnet`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`amount` else 0 end) AS `basicidle`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `basicidleint`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0 end) AS `basicidledisc`,(case when (`ri`.`revtype` = 'basicidle') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicidledp`,(case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicidlenet`,(case when (`ri`.`revtype` = 'sef') then `ri`.`amount` else 0 end) AS `sef`,(case when (`ri`.`revtype` = 'sef') then `ri`.`interest` else 0 end) AS `sefint`,(case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0 end) AS `sefdisc`,(case when (`ri`.`revtype` = 'sef') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `sefdp`,(case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `sefnet`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`amount` else 0 end) AS `firecode`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`interest` else 0 end) AS `firecodeint`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`discount` else 0 end) AS `firecodedisc`,(case when (`ri`.`revtype` = 'firecode') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `firecodedp`,(case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `firecodenet`,(case when (`ri`.`revtype` = 'sh') then `ri`.`amount` else 0 end) AS `sh`,(case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,(case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0 end) AS `shdisc`,(case when (`ri`.`revtype` = 'sh') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `shdp`,(case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `shnet`,((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) AS `total` from (`report_rptdelinquency_item` `ri` join `report_rptdelinquency` `r` on((`ri`.`parentid` = `r`.`objid`)))
;
CREATE VIEW `vw_landtax_report_rptdelinquency_detail` AS select `ri`.`objid` AS `objid`,`ri`.`rptledgerid` AS `rptledgerid`,`ri`.`barangayid` AS `barangayid`,`ri`.`year` AS `year`,`ri`.`qtr` AS `qtr`,`r`.`dtgenerated` AS `dtgenerated`,`r`.`dtcomputed` AS `dtcomputed`,`r`.`generatedby_name` AS `generatedby_name`,`r`.`generatedby_title` AS `generatedby_title`,(case when (`ri`.`revtype` = 'basic') then `ri`.`amount` else 0 end) AS `basic`,(case when (`ri`.`revtype` = 'basic') then `ri`.`interest` else 0 end) AS `basicint`,(case when (`ri`.`revtype` = 'basic') then `ri`.`discount` else 0 end) AS `basicdisc`,(case when (`ri`.`revtype` = 'basic') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicdp`,(case when (`ri`.`revtype` = 'basic') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicnet`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`amount` else 0 end) AS `basicidle`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`interest` else 0 end) AS `basicidleint`,(case when (`ri`.`revtype` = 'basicidle') then `ri`.`discount` else 0 end) AS `basicidledisc`,(case when (`ri`.`revtype` = 'basicidle') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `basicidledp`,(case when (`ri`.`revtype` = 'basicidle') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `basicidlenet`,(case when (`ri`.`revtype` = 'sef') then `ri`.`amount` else 0 end) AS `sef`,(case when (`ri`.`revtype` = 'sef') then `ri`.`interest` else 0 end) AS `sefint`,(case when (`ri`.`revtype` = 'sef') then `ri`.`discount` else 0 end) AS `sefdisc`,(case when (`ri`.`revtype` = 'sef') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `sefdp`,(case when (`ri`.`revtype` = 'sef') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `sefnet`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`amount` else 0 end) AS `firecode`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`interest` else 0 end) AS `firecodeint`,(case when (`ri`.`revtype` = 'firecode') then `ri`.`discount` else 0 end) AS `firecodedisc`,(case when (`ri`.`revtype` = 'firecode') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `firecodedp`,(case when (`ri`.`revtype` = 'firecode') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `firecodenet`,(case when (`ri`.`revtype` = 'sh') then `ri`.`amount` else 0 end) AS `sh`,(case when (`ri`.`revtype` = 'sh') then `ri`.`interest` else 0 end) AS `shint`,(case when (`ri`.`revtype` = 'sh') then `ri`.`discount` else 0 end) AS `shdisc`,(case when (`ri`.`revtype` = 'sh') then (`ri`.`interest` - `ri`.`discount`) else 0 end) AS `shdp`,(case when (`ri`.`revtype` = 'sh') then ((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) else 0 end) AS `shnet`,((`ri`.`amount` + `ri`.`interest`) - `ri`.`discount`) AS `total` from (`report_rptdelinquency_item` `ri` join `report_rptdelinquency` `r` on((`ri`.`parentid` = `r`.`objid`)))
;


drop VIEW if exists `vw_machine_smv`
;
CREATE VIEW `vw_machine_smv` AS select `ms`.`objid` AS `objid`,`ms`.`parent_objid` AS `parent_objid`,`ms`.`machine_objid` AS `machine_objid`,`ms`.`expr` AS `expr`,`ms`.`previd` AS `previd`,`m`.`code` AS `code`,`m`.`name` AS `name` from (`machine_smv` `ms` join `machine` `m` on((`ms`.`machine_objid` = `m`.`objid`)))
;

drop VIEW if exists `vw_rptcertification_item`
;
CREATE VIEW `vw_rptcertification_item` AS select `rci`.`rptcertificationid` AS `rptcertificationid`,`f`.`objid` AS `faasid`,`f`.`fullpin` AS `fullpin`,`f`.`tdno` AS `tdno`,`e`.`objid` AS `taxpayerid`,`e`.`name` AS `taxpayer_name`,`f`.`owner_name` AS `owner_name`,`f`.`administrator_name` AS `administrator_name`,`f`.`titleno` AS `titleno`,`f`.`rpuid` AS `rpuid`,`pc`.`code` AS `classcode`,`pc`.`name` AS `classname`,`so`.`name` AS `lguname`,`b`.`name` AS `barangay`,`r`.`rputype` AS `rputype`,`r`.`suffix` AS `suffix`,`r`.`totalareaha` AS `totalareaha`,`r`.`totalareasqm` AS `totalareasqm`,`r`.`totalav` AS `totalav`,`r`.`totalmv` AS `totalmv`,`rp`.`street` AS `street`,`rp`.`blockno` AS `blockno`,`rp`.`cadastrallotno` AS `cadastrallotno`,`rp`.`surveyno` AS `surveyno`,`r`.`taxable` AS `taxable`,`f`.`effectivityyear` AS `effectivityyear`,`f`.`effectivityqtr` AS `effectivityqtr` from (((((((`rptcertificationitem` `rci` join `faas` `f` on((`rci`.`refid` = `f`.`objid`))) join `rpu` `r` on((`f`.`rpuid` = `r`.`objid`))) join `propertyclassification` `pc` on((`r`.`classification_objid` = `pc`.`objid`))) join `realproperty` `rp` on((`f`.`realpropertyid` = `rp`.`objid`))) join `barangay` `b` on((`rp`.`barangayid` = `b`.`objid`))) join `sys_org` `so` on((`f`.`lguid` = `so`.`objid`))) join `entity` `e` on((`f`.`taxpayer_objid` = `e`.`objid`)))
;

drop VIEW if exists `vw_rptledger_avdifference`
;

CREATE VIEW `vw_rptledger_avdifference` AS select `rlf`.`objid` AS `objid`,'APPROVED' AS `state`,`d`.`parent_objid` AS `rptledgerid`,`rl`.`faasid` AS `faasid`,`rl`.`tdno` AS `tdno`,`rlf`.`txntype_objid` AS `txntype_objid`,`rlf`.`classification_objid` AS `classification_objid`,`rlf`.`actualuse_objid` AS `actualuse_objid`,`rlf`.`taxable` AS `taxable`,`rlf`.`backtax` AS `backtax`,`d`.`year` AS `fromyear`,1 AS `fromqtr`,`d`.`year` AS `toyear`,4 AS `toqtr`,`d`.`av` AS `assessedvalue`,1 AS `systemcreated`,`rlf`.`reclassed` AS `reclassed`,`rlf`.`idleland` AS `idleland`,1 AS `taxdifference` from ((`rptledger_avdifference` `d` join `rptledgerfaas` `rlf` on((`d`.`rptledgerfaas_objid` = `rlf`.`objid`))) join `rptledger` `rl` on((`d`.`parent_objid` = `rl`.`objid`)))
;


drop view if exists `vw_rptpayment_item_detail` ;


CREATE VIEW `vw_rptpayment_item_detail` AS 
select 
    `rpi`.`objid` AS `objid`,
    `rpi`.`parentid` AS `parentid`,
    `rpi`.`rptledgerfaasid` AS `rptledgerfaasid`,
    `rpi`.`year` AS `year`,
    `rpi`.`qtr` AS `qtr`,
    `rpi`.`revperiod` AS `revperiod`,
    (case when (`rpi`.`revtype` = 'basic') then `rpi`.`amount` else 0 end) AS `basic`,
    (case when (`rpi`.`revtype` = 'basic') then `rpi`.`interest` else 0 end) AS `basicint`,
    (case when (`rpi`.`revtype` = 'basic') then `rpi`.`discount` else 0 end) AS `basicdisc`,
    (case when (`rpi`.`revtype` = 'basic') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `basicdp`,
    (case when (`rpi`.`revtype` = 'basic') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `basicnet`,
    (case when (`rpi`.`revtype` = 'basicidle') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `basicidle`,
    (case when (`rpi`.`revtype` = 'basicidle') then `rpi`.`interest` else 0 end) AS `basicidleint`,
    (case when (`rpi`.`revtype` = 'basicidle') then `rpi`.`discount` else 0 end) AS `basicidledisc`,
    (case when (`rpi`.`revtype` = 'basicidle') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `basicidledp`,
    (case when (`rpi`.`revtype` = 'sef') then `rpi`.`amount` else 0 end) AS `sef`,
    (case when (`rpi`.`revtype` = 'sef') then `rpi`.`interest` else 0 end) AS `sefint`,
    (case when (`rpi`.`revtype` = 'sef') then `rpi`.`discount` else 0 end) AS `sefdisc`,
    (case when (`rpi`.`revtype` = 'sef') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `sefdp`,
    (case when (`rpi`.`revtype` = 'sef') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `sefnet`,
    (case when (`rpi`.`revtype` = 'firecode') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `firecode`,
    (case when (`rpi`.`revtype` = 'sh') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `sh`,
    (case when (`rpi`.`revtype` = 'sh') then `rpi`.`interest` else 0 end) AS `shint`,
    (case when (`rpi`.`revtype` = 'sh') then `rpi`.`discount` else 0 end) AS `shdisc`,
    (case when (`rpi`.`revtype` = 'sh') then (`rpi`.`interest` - `rpi`.`discount`) else 0 end) AS `shdp`,
    (case when (`rpi`.`revtype` = 'sh') then ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) else 0 end) AS `shnet`,
    ((`rpi`.`amount` + `rpi`.`interest`) - `rpi`.`discount`) AS `amount`,
    `rpi`.`partialled` AS `partialled` 
from `rptpayment_item` `rpi`


drop VIEW if exists `vw_rptpayment_item`
;
CREATE VIEW `vw_rptpayment_item` AS select `x`.`parentid` AS `parentid`,`x`.`rptledgerfaasid` AS `rptledgerfaasid`,`x`.`year` AS `year`,`x`.`qtr` AS `qtr`,`x`.`revperiod` AS `revperiod`,sum(`x`.`basic`) AS `basic`,sum(`x`.`basicint`) AS `basicint`,sum(`x`.`basicdisc`) AS `basicdisc`,sum(`x`.`basicdp`) AS `basicdp`,sum(`x`.`basicnet`) AS `basicnet`,sum(`x`.`basicidle`) AS `basicidle`,sum(`x`.`basicidleint`) AS `basicidleint`,sum(`x`.`basicidledisc`) AS `basicidledisc`,sum(`x`.`basicidledp`) AS `basicidledp`,sum(`x`.`sef`) AS `sef`,sum(`x`.`sefint`) AS `sefint`,sum(`x`.`sefdisc`) AS `sefdisc`,sum(`x`.`sefdp`) AS `sefdp`,sum(`x`.`sefnet`) AS `sefnet`,sum(`x`.`firecode`) AS `firecode`,sum(`x`.`sh`) AS `sh`,sum(`x`.`shint`) AS `shint`,sum(`x`.`shdisc`) AS `shdisc`,sum(`x`.`shdp`) AS `shdp`,sum(`x`.`amount`) AS `amount`,max(`x`.`partialled`) AS `partialled` from `vw_rptpayment_item_detail` `x` group by `x`.`parentid`,`x`.`rptledgerfaasid`,`x`.`year`,`x`.`qtr`,`x`.`revperiod`
;

drop VIEW if exists `vw_rpu_assessment`
;
CREATE VIEW `vw_rpu_assessment` AS select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `landassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`))) union select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `bldgassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`))) union select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `machassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`))) union select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `planttreeassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`))) union select `r`.`objid` AS `objid`,`r`.`rputype` AS `rputype`,`dpc`.`objid` AS `dominantclass_objid`,`dpc`.`code` AS `dominantclass_code`,`dpc`.`name` AS `dominantclass_name`,`dpc`.`orderno` AS `dominantclass_orderno`,`ra`.`areasqm` AS `areasqm`,`ra`.`areaha` AS `areaha`,`ra`.`marketvalue` AS `marketvalue`,`ra`.`assesslevel` AS `assesslevel`,`ra`.`assessedvalue` AS `assessedvalue`,`ra`.`taxable` AS `taxable`,`au`.`code` AS `actualuse_code`,`au`.`name` AS `actualuse_name`,`auc`.`objid` AS `actualuse_objid`,`auc`.`code` AS `actualuse_classcode`,`auc`.`name` AS `actualuse_classname`,`auc`.`orderno` AS `actualuse_orderno` from ((((`rpu` `r` join `propertyclassification` `dpc` on((`r`.`classification_objid` = `dpc`.`objid`))) join `rpu_assessment` `ra` on((`r`.`objid` = `ra`.`rpuid`))) join `miscassesslevel` `au` on((`ra`.`actualuse_objid` = `au`.`objid`))) left join `propertyclassification` `auc` on((`au`.`classification_objid` = `auc`.`objid`)))
;


drop VIEW if exists `vw_txn_log`
;
CREATE VIEW `vw_txn_log` AS select distinct `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`txndate` AS `txndate`,`t`.`ref` AS `ref`,`t`.`action` AS `action`,1 AS `cnt` from (`txnlog` `t` join `sys_user` `u` on((`t`.`userid` = `u`.`objid`))) union select `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`enddate` AS `txndate`,'faas' AS `ref`,(case when (`t`.`state` like '%receiver%') then 'receive' when (`t`.`state` like '%examiner%') then 'examine' when (`t`.`state` like '%taxmapper_chief%') then 'approve taxmap' when (`t`.`state` like '%taxmapper%') then 'taxmap' when (`t`.`state` like '%appraiser%') then 'appraise' when (`t`.`state` like '%appraiser_chief%') then 'approve appraisal' when (`t`.`state` like '%recommender%') then 'recommend' when (`t`.`state` like '%approver%') then 'approve' else `t`.`state` end) AS `action`,1 AS `cnt` from (`faas_task` `t` join `sys_user` `u` on((`t`.`actor_objid` = `u`.`objid`))) where (not((`t`.`state` like '%assign%'))) union select `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`enddate` AS `txndate`,'subdivision' AS `ref`,(case when (`t`.`state` like '%receiver%') then 'receive' when (`t`.`state` like '%examiner%') then 'examine' when (`t`.`state` like '%taxmapper_chief%') then 'approve taxmap' when (`t`.`state` like '%taxmapper%') then 'taxmap' when (`t`.`state` like '%appraiser%') then 'appraise' when (`t`.`state` like '%appraiser_chief%') then 'approve appraisal' when (`t`.`state` like '%recommender%') then 'recommend' when (`t`.`state` like '%approver%') then 'approve' else `t`.`state` end) AS `action`,1 AS `cnt` from (`subdivision_task` `t` join `sys_user` `u` on((`t`.`actor_objid` = `u`.`objid`))) where (not((`t`.`state` like '%assign%'))) union select `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`enddate` AS `txndate`,'consolidation' AS `ref`,(case when (`t`.`state` like '%receiver%') then 'receive' when (`t`.`state` like '%examiner%') then 'examine' when (`t`.`state` like '%taxmapper_chief%') then 'approve taxmap' when (`t`.`state` like '%taxmapper%') then 'taxmap' when (`t`.`state` like '%appraiser%') then 'appraise' when (`t`.`state` like '%appraiser_chief%') then 'approve appraisal' when (`t`.`state` like '%recommender%') then 'recommend' when (`t`.`state` like '%approver%') then 'approve' else `t`.`state` end) AS `action`,1 AS `cnt` from (`subdivision_task` `t` join `sys_user` `u` on((`t`.`actor_objid` = `u`.`objid`))) where (not((`t`.`state` like '%consolidation%'))) union select `u`.`objid` AS `userid`,`u`.`name` AS `username`,`t`.`enddate` AS `txndate`,'cancelledfaas' AS `ref`,(case when (`t`.`state` like '%receiver%') then 'receive' when (`t`.`state` like '%examiner%') then 'examine' when (`t`.`state` like '%taxmapper_chief%') then 'approve taxmap' when (`t`.`state` like '%taxmapper%') then 'taxmap' when (`t`.`state` like '%appraiser%') then 'appraise' when (`t`.`state` like '%appraiser_chief%') then 'approve appraisal' when (`t`.`state` like '%recommender%') then 'recommend' when (`t`.`state` like '%approver%') then 'approve' else `t`.`state` end) AS `action`,1 AS `cnt` from (`subdivision_task` `t` join `sys_user` `u` on((`t`.`actor_objid` = `u`.`objid`))) where (not((`t`.`state` like '%cancelledfaas%')))
;

