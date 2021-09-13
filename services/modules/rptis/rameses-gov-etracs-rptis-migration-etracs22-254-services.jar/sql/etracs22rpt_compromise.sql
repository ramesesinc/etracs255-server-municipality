[findMigrationData]
select count(*) as count from xrptcompromise 


[dropXCompromiseTable]
drop table xrptcompromise


[createXCompromiseTable]
create table xrptcompromise(
  objid varchar(50),
  primary key(objid)
)

[createCompromiseMigrateTable]
create table etracs25_migrate_compromise
(
  objid varchar(50),
  primary key(objid)
)

[createCompromiseMigrateLogTable]
create table etracs25_migrate_compromise_log
(
  objid varchar(50),
  log text, 
  primary key(objid)
)

[deleteCompromiseLog]
delete from etracs25_migrate_compromise_log


[logMigratedCompromise]
insert into etracs25_migrate_compromise
  (objid)
values 
  ($P{objid})


[logMigrateError]
insert into etracs25_migrate_compromise_log
  (objid, log)
values
  ($P{objid}, $P{log})


[deleteXCompromise]
delete from xrptcompromise where objid = $P{objid}


[insertCompromises]
insert into xrptcompromise (objid)
select objid 
from rptcompromise rl 
where not exists(select * from etracs25_migrate_compromise where objid = rl.objid)
  and not exists(select * from etracs25_migrate_compromise_log where objid = rl.objid)


[getCompromisesForMigration]
select * from xrptcompromise


[findCompromise]
select * from rptcompromise where objid = $P{objid}


[getInstallments]
select * 
from rptcompromise_installment 
where rptcompromiseid = $P{objid}


[getItems]
select 
  objid,
  rptcompromiseid,
  iyear as year,
  iqtr as qtr,
  faasid,
  assessedvalue,
  tdno,
  classcode,
  actualusecode,
  basic,
  basicpaid,
  basicint,
  basicintpaid,
  0.0 as basicidle,
  0.0 as basicidlepaid,
  0.0 as basicidleint,
  0.0 as basicidleintpaid,
  sef,
  sefpaid,
  sefint,
  sefintpaid,
  0.0 as firecode,
  0.0 as firecodepaid,
  total,
  fullypaid
from rptcompromise_item
where rptcompromiseid = $P{objid}


[getCredits]
select 
  objid,
  rptcompromiseid,
  receiptid as rptreceiptid,
  installmentid,
  collectorname as collector_name,
  collectortitle as collector_title,
  orno,
  ordate,
  amount as oramount,
  amount as amount,
  mode,
  paidby,
  paidbyaddress,
  0 as partial
from rptcompromise_credit 
where rptcompromiseid = $P{objid}