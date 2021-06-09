[createMigrateFaasTable]
CREATE TABLE etracs25_migrate_faas (
  objid VARCHAR(50) primary key NOT NULL
) 

[deleteMigrateFaasTable]
delete from etracs25_migrate_faas

[createMigrateFaasLogTable]
CREATE TABLE etracs25_migrate_log (
  objid VARCHAR(50)  not NULL,
  log TEXT
)

[deleteMigrateFaasLogTable]
delete from etracs25_migrate_log


[createMigratePrevFaasTable]
CREATE TABLE etracs25_migrate_prevfaas (
  objid VARCHAR(50) primary key NOT NULL
) 

[deleteMigratePrevFaasTable]
delete from etracs25_migrate_prevfaas

[createMigratePrevFaasLogTable]
CREATE TABLE etracs25_migrate_prevfaas_log (
  objid VARCHAR(50)  not NULL,
  log TEXT
)

[deleteMigratePrevFaasLogTable]
delete from etracs25_migrate_prevfaas_log


[createMigrateFaasLogIndex]
create index ix_etracs25_migrate_log_objid 
on etracs25_migrate_log(objid)






[getLgusByClass]
select 
	replace(objid, '-','') as objid,
	'DRAFT' as state,
	pin as code,
	pin, 
	indexno,
	lguname as name,
	formalname as fullname,
	lgutype as orgclass,
	replace(parentid, '-','') as parentid,
	0 as root 
from lgu 
where lgutype = $P{orgclass}


[getClassifications]
SELECT 
	objid,
	'APPROVED' as state,
	propertycode as code,
	propertydesc as name,
	special,
	orderno 
FROM propertyclassification


[getExemptionTypes]
SELECT 
	objid,
	'APPROVED' as state,
	exemptcode as code,
	exemptdesc as name,
	orderno 
FROM exemptiontype


[getCancelTdReasons]
SELECT 
	objid,
	'APPROVED' as state,
	cancelcode as code,
	canceltitle as name,
	canceldesc as description
FROM canceltdreason


[getBldgKinds]
SELECT 
	objid,
	'APPROVED' as state,
	bldgcode as code,
	bldgkind as name 
FROM kindofbuilding


[getMaterials]
SELECT 
	objid,
	'APPROVED' as state,
	materialcode as code,
	materialdesc as name
FROM materials


[getStructures]
SELECT 
	objid,
	'APPROVED' as state,
	structurecode as code,
	structuredesc as name,
	indexno,
	materials
FROM structures


[getMachines]
SELECT 
	objid,
	'APPROVED' as state,
	machinecode as code,
	machinedesc as name 
FROM machines


[getPlantTrees]
SELECT 
	objid,
	'APPROVED' as state,
	planttreecode as code,
	planttreedesc as name  
FROM plantsandtrees


[getMiscItems]
SELECT 
	objid,
	'APPROVED' as state,
	misccode as code,
	miscdesc as name 
FROM miscitems


[getRPTParameters]
SELECT 
	objid,
	'DRAFT' as state,
	paramname as name,
	paramcaption as caption,
	paramdesc as description,
	paramtype as paramtype,
	parammin as minvalue,
	parammax as maxvalue 
FROM rptparameters
