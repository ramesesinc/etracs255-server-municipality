[dropXFaasTable]
drop table xfaas 


[createXFaasTable]
create table xfaas(
	objid varchar(50),
	rputype varchar(25), 
	ry int, 
	tdno varchar(50),
	primary key(objid)
)

[createXFaasRpuTypeIndex]
create index xfaas_rputype on xfaas(rputype)

[createXFaasRyIndex]	
create index xfaas_ry on xfaas(ry)

[insertXFaasData]
insert into xfaas 
	(objid, rputype, ry, tdno)
select objid, rputype, ry, tdno 
from faaslist fl 
where not exists(select * from etracs25_migrate_faas where objid = fl.objid)


[deleteXFaasMigratedData]
delete from xfaas 
where objid in (select objid from etracs25_migrate_faas)






[getFaasesForMigration]
SELECT * FROM xfaas  
WHERE rputype=$P{rputype} 
order by ry, tdno 

[deleteMigratedXFaas]
delete from xfaas where objid = $P{objid}


[getPrevFaasesForMigration]
SELECT * FROM faaslist 
where objid NOT IN (SELECT objid FROM etracs25_migrate_prevfaas) 
AND objid NOT IN (SELECT objid FROM etracs25_migrate_prevfaas_log) 


[findFaasByTdno]
select objid from faaslist where tdno = $P{tdno}

[findFaasByid]
select * from faas where objid = $P{objid}

[findFaasLogById]
select * from etracs25_migrate_faas where objid = $P{objid}

[findFaasPrevInfoById]
select objid, previousfaases from faas where objid = $P{objid}

[logFaasError]
INSERT INTO etracs25_migrate_log (objid,log) VALUES ($P{objid},$P{log})

[logPrevFaasError]
INSERT INTO etracs25_migrate_prevfaas_log (objid,log) VALUES ($P{objid},$P{log})

[logMigratedFaas]
INSERT INTO etracs25_migrate_faas (objid) VALUES ($P{objid})

[logMigratedPreviousFaas]
INSERT INTO etracs25_migrate_prevfaas (objid) VALUES ($P{objid})


[logMigratedEntity]
INSERT INTO etracs25_migrate_entity (objid) VALUES ($P{objid})

[logMigratedProperty]
INSERT INTO etracs25_migrate_realproperty (objid) VALUES ($P{objid})


[findFaasListById]
select * from faaslist where objid =$P{objid}


[findLandFaasById]
select landfaasid as objid from faaslist where objid =$P{objid}


[findSignatoryFromFaasList]
select 
	appraisedby as appraiser_name,
	appraisedbytitle as appraiser_title,
	issuedate as appraiser_dtsigned,
	recommendedby as recommender_name,
	recommendedbytitle as recommender_title,
	issuedate as recommender_dtsigned,
	approvedby as approver_name,
	approvedbytitle as approver_title,
	issuedate as approver_dtsigned
from faaslist 
where objid = $P{objid}



[getStructures]
SELECT * FROM structures;

[getLandAdjustment]
SELECT * FROM landadjustment;

[getBldgAssessLevel]
SELECT * FROM bldgassesslevel;

[getBldgTypeDepreciation]
SELECT * FROM bldgtype;

[getPlantTreeAssessLevel]
SELECT * FROM planttreerysetting;

[getMiscAssessLevel]
SELECT * FROM miscassesslevel;

[getFaasList]
SELECT 
	objid, docstate, ry, tdno, fullpin, rputype, txntype, 
	taxpayerid, taxpayername, taxpayeraddress, ownername, owneraddress, 
	cadastrallotno, surveyno, effectivityyear, effectivityqtr, classcode, taxable, 
	totalareasqm, totalmv, totalav, barangay, totalareasqm, totalareaha, munidistrict, annotated 
FROM faaslist i 
WHERE i.docstate IN ('CURRENT', 'CANCELLED')
${filter} 
ORDER BY i.tdno, i.fullpin 



[deleteLogById]
delete from etracs25_migrate_log where objid = $P{objid}



[getEntitiesForMigration]	
select TOP ${count} *
from entity e 
where not exists(select * from etracs25_migrate_entity where objid = e.objid )
and not exists(select * from etracs254_sannicolas..entityindividual where objid = e.objid collate latin1_general_ci_as)
and not exists(select * from etracs254_sannicolas..entityjuridical where objid = e.objid collate latin1_general_ci_as)
and not exists(select * from etracs254_sannicolas..entitymultiple where objid = e.objid collate latin1_general_ci_as)



[getPropertiesForMigration]
select TOP ${count}  xf.* 
from xfaas_no_realproperty xf  
where not exists(select * from etracs25_migrate_realproperty where objid = xf.objid )


[findEntityById]
select 
  objid,
  entityno,
  entityname as name,
  entityaddress as address_text,
  entitytype as type,
  substring(entityname, 1, 30) as entityname,
  objid as address_objid,
  info 
from entity e 
where objid = $P{objid}







[dropFaasAnnotationMigrateTable]
drop table etracs25_migrate_faasannotation  

[dropFaasAnnotationMigrateLogTable]
drop table etracs25_migrate_faasannotation_log

[dropXFaasAnnotationTable]
drop table xfaas_annotation


[createFaasAnnotationMigrateTable]
create table etracs25_migrate_faasannotation(
	objid varchar(50),
	primary key(objid)
)

[createFaasAnnotationMigrateLogTable]
create table etracs25_migrate_faasannotation_log(
	objid varchar(50),
	log text, 
	primary key(objid)
)

[createXFaasAnnotationTable]
create table xfaas_annotation(
	objid varchar(50),
	primary key(objid)
)

[insertXFaasAnnotation]
insert into xfaas_annotation
select objid from faasannotation

[getAnnotationsForMigration]
select * from xfaas_annotation

[findAnnotationById]
select
  f.objid, 
  f.docstate as state, 
  ft.objid as annotationtype_objid, 
  ft.annotationtype as annotationtype_type,
  f.faasid, 
  f.docno as txnno, 
  f.dtsubmitted as txndate, 
  f.fileno, 
  f.orno, 
  f.ordate, 
  f.oramount, 
  f.memoranda 
from faasannotation f
  inner join faasannotationtype ft on f.doctype = ft.annotationtype 
where f.objid = $P{objid}



[logAnnotationError]
insert into etracs25_migrate_faasannotation_log
	(objid, log)
values 
	($P{objid}, $P{log})

[deleteXFaasAnnotation]
delete from xfaas_annotation where objid = $P{objid}



[findPreviousFaas]
select 
	objid as prevfaasid,
	null as prevrpuid,
	tdno as prevtdno,
	fullpin as prevpin,
	taxpayername as  prevowner,
	administratorname as prevadministrator,
	totalav as prevav,
	totalmv as prevmv,
	totalareasqm as prevareasqm,
	totalareaha as  prevareaha,
	effectivityyear as preveffectivity
from faaslist 
where objid = $P{objid}