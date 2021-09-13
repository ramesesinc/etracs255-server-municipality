[clearOrgParentId]
update sys_org set parent_objid = null 

[deleteProvince]
delete from province 

[deleteMunicipality]
delete from municipality 

[deleteCity]
delete from city 

[deleteDistrict]
delete from district 

[deleteBarangay]
delete from barangay 


[deleteSysOrg]	
delete from sys_org 


[findLandRpuById]
select objid from landrpu where objid = $P{objid}

[findLandDetailById]
select objid from landdetail where objid = $P{objid}

[findLandAdjustmentById]
select objid from landadjustment where objid = $P{objid}

[findPlantTreeDetailById]
select objid from planttreedetail where objid = $P{objid}

[findRpuAssessmentById]
select objid from rpu_assessment where objid = $P{objid}


[findBldgRpuById]
select objid from bldgrpu where objid = $P{objid}

[findBldgStructureById]
select objid from bldgstructure where objid = $P{objid}

[findBldgStructuralTypeById]
select objid from bldgrpu_structuraltype where objid = $P{objid}

[findBldgUseById]
select objid from bldguse where objid = $P{objid}

[findFloorById]
select objid from bldgfloor where objid = $P{objid}

[findBldgFloorAdditionalById]
select objid from bldgflooradditional where objid = $P{objid}

[findBldgFloorAdditionalParamById]
select objid from bldgflooradditionalparam where objid = $P{objid}

[findLandFaasById]
select objid, rpuid, realpropertyid  
from faas 
where objid = $P{objid}


[findMachRpuById]
select objid from machrpu where objid = $P{objid}

[findMachUseById]
select objid from machuse where objid = $P{objid}

[findMachDetailById]
select objid from machdetail where objid = $P{objid}


[getLandRpuAssessments]
select distinct 
	min(ld.objid) as objid, 
	ld.landrpuid as rpuid, 
	lal.classification_objid, 
	ld.actualuse_objid, 
	sum(ld.areasqm) as areasqm, 
	sum(ld.areaha) as areaha, 
	sum(ld.marketvalue) as marketvalue, 
	ld.assesslevel, 
	sum(ld.assessedvalue) as assessedvalue, 
	'land' as rputype
from landdetail ld 	
	inner join landassesslevel lal on ld.actualuse_objid = lal.objid 
where ld.landrpuid = $P{objid}	 
group by 
	ld.landrpuid, 
	lal.classification_objid, 
	ld.actualuse_objid,
	ld.assesslevel

[getPlantTreeDetailAssessments]
select distinct 
	min(ld.objid) as objid, 
	ld.landrpuid as rpuid, 
	lal.classification_objid, 
	ld.actualuse_objid, 
	sum(0) as areasqm, 
	sum(0) as areaha, 
	sum(ld.marketvalue) as marketvalue, 
	ld.assesslevel, 
	sum(ld.assessedvalue) as assessedvalue, 
	'planttree' as rputype
from planttreedetail ld 	
	inner join planttreeassesslevel lal on ld.actualuse_objid = lal.objid 
where ld.landrpuid = $P{objid}	 
group by 
	ld.landrpuid, 
	lal.classification_objid, 
	ld.actualuse_objid,
	ld.assesslevel


[insertLandRpuAssessment]
INSERT INTO rpu_assessment (objid, rpuid, classification_objid, actualuse_objid, areasqm, areaha, marketvalue, assesslevel, assessedvalue, rputype, taxable) 
values($P{objid}, $P{rpuid}, $P{classification_objid}, $P{actualuse_objid}, $P{areasqm}, $P{areaha}, $P{marketvalue}, $P{assesslevel}, $P{assessedvalue}, $P{rputype}, $P{taxable} )


[findPropertyClassificationByCode]
select objid from propertyclassification where code = $P{code}


[insertBldgRpuAssessment]
INSERT INTO rpu_assessment (objid, rpuid, classification_objid, actualuse_objid, areasqm, areaha, marketvalue, assesslevel, assessedvalue, rputype) 
select
	min(bu.objid) as objid, 
	bu.bldgrpuid as rpuid, 
	au.classification_objid, 
	bu.actualuse_objid as actualuse_objid, 
	sum(bu.area) as areasqm, 
	sum(bu.area / 10000) as areaha, 
	sum(bu.marketvalue) as marketvalue, 
	bu.assesslevel,
	sum(bu.assessedvalue) as assessedvalue, 
	'bldg' as rputype
from bldgrpu r
	inner join bldguse bu on r.objid  = bu.bldgrpuid
	inner join bldgassesslevel au on bu.actualuse_objid = au.objid 
where r.objid = $P{objid}
group by 
	bu.bldgrpuid,
	au.classification_objid, 
	bu.actualuse_objid,
	bu.assesslevel


[findRptParameterById]
select * from rptparameter where objid = $P{objid}

[findRptParameterByName]
select * from rptparameter where name = $P{name}

[updateBldgRpuFloorCount]
update bldgrpu set 
	floorcount = (select max(floorcount) from bldgrpu_structuraltype where bldgrpuid = $P{objid})
where objid = $P{objid}

[updateStructuralTypeBaseArea]
update bldgrpu_structuraltype set 
	basefloorarea = ifnull((select sum(area) from bldgfloor where  bldgrpuid = $P{objid} and floorno = 1),0)
where bldgrpuid = $P{objid}	


[insertMachRpuAssessment]
INSERT INTO rpu_assessment (objid, rpuid, classification_objid, actualuse_objid, areasqm, areaha, marketvalue, assesslevel, assessedvalue, rputype, taxable) 
select
	min(bu.objid) as objid, 
	bu.machrpuid as rpuid, 
	au.classification_objid, 
	bu.actualuse_objid as actualuse_objid, 
	0 as areasqm, 
	0 as areaha, 
	sum(bu.marketvalue) as marketvalue, 
	bu.assesslevel,
	sum(bu.assessedvalue) as assessedvalue, 
	'mach' as rputype,
	1 as taxable 
from machrpu r
	inner join machuse bu on r.objid  = bu.machrpuid
	inner join machassesslevel au on bu.actualuse_objid = au.objid 
where r.objid = $P{objid}
group by 
	bu.machrpuid,
	au.classification_objid, 
	bu.actualuse_objid,
	bu.assesslevel


[findPreviousFaas]
select * from previousfaas where faasid = $P{faasid} and prevfaasid = $P{prevfaasid}



[findEntityAddressByParentId]
select objid from entity_address where parentid = $P{parentid}


[findIndividualById]
select objid from entityindividual where objid = $P{objid}


[findJuridicalById]
select objid from entityjuridical where objid = $P{objid}

[findMultipleById]
select objid from entitymultiple where objid = $P{objid}



[findLandRySettingByRy]
select * from landrysetting where ry = $P{ry}

[findClassificationById]
select objid from propertyclassification where objid = $P{objid}

[findLandAssessLevelById]
select objid from landassesslevel where objid = $P{objid}


[findSpecificClassById]
select * from lcuvspecificclass where objid = $P{objid}


[findSubClassById]
select objid from lcuvsubclass where objid = $P{objid}

[findLandAdjustmentTypeById]
select objid from landadjustmenttype where objid = $P{objid}

[findStrippingById]
select objid from lcuvstripping where objid = $P{objid}




[findPlantTreeRySettingByRy]
select * from planttreerysetting where ry = $P{ry}

[findPlantTreeById]
select objid from planttree where objid = $P{objid}

[findPlantTreeUnitValueById]
select objid from planttreeunitvalue where objid = $P{objid}

[findPlantTreeAssessLevelById]
select objid from planttreeassesslevel where objid = $P{objid}







[findLandFaasByRealProperty]
select f.objid as landfaasid, r.objid AS rpuid  
from faas f 
inner join rpu r on f.rpuid = r.objid 
where r.realpropertyid = $P{realpropertyid}
and r.ry = $P{ry}
and r.rputype = 'land'


[findLandFaasByFullPin]
select f.objid as landfaasid, r.objid AS rpuid  
from faas f 
inner join rpu r on f.rpuid = r.objid 
where r.fullpin = $P{fullpin}
and r.ry = $P{ry}
and r.rputype = 'land'


[findBldgSettingByRy]
select * from bldgrysetting where ry = $P{ry}

[findBldgAssessLevelById]
select objid from bldgassesslevel where objid = $P{objid}


[findBldgTypeById]
select objid from bldgtype where objid = $P{objid}

[findBldgTypePrevInfo]
select * from bldgtype where objid = $P{previd}


[findBldgKindBuccById]
select objid from bldgkindbucc where objid = $P{objid}

[findBldgAdditionalItemById]
select * from bldgadditionalitem where objid = $P{objid}

[findBldgAdditionalItemByCode]
select * from bldgadditionalitem where code = $P{code}

[findBldgAdditionalItemByName]
select * from bldgadditionalitem where name = $P{name}


[findMachSettingByRy]
select * from machrysetting where ry = $P{ry}



[findAnnotationTypeById]
select * from faasannotationtype where objid = $P{objid}

[insertAnnotationType]
insert into faasannotationtype
	(objid, type)
values	
	($P{objid}, $P{type})


[insertFaasList]
insert into faas_list (
	objid,
	state,
	rpuid,
	realpropertyid,
	datacapture,
	ry,
	txntype_objid,
	tdno,
	utdno,
	prevtdno,
	displaypin,
	pin,
	taxpayer_objid,
	owner_name,
	owner_address,
	administrator_name,
	administrator_address,
	rputype,
	barangayid,
	barangay,
	classification_objid,
	classcode,
	cadastrallotno,
	blockno,
	surveyno,
	titleno,
	totalareaha,
	totalareasqm,
	totalmv,
	totalav,
	effectivityyear,
	effectivityqtr,
	cancelreason,
	cancelledbytdnos,
	lguid,
	originlguid,
	yearissued,
	taskid,
	taskstate,
	assignee_objid,
	trackingno,
	publicland
)
select
	f.objid,
	f.state,
	f.rpuid,
	f.realpropertyid,
	f.datacapture,
	r.ry,
	f.txntype_objid,
	f.tdno,
	f.utdno,
	f.prevtdno,
	f.fullpin as displaypin,
	rp.pin,
	f.taxpayer_objid,
	f.owner_name,
	f.owner_address,
	f.administrator_name,
	f.administrator_address,
	r.rputype,
	rp.barangayid,
	b.name as barangay,
	r.classification_objid,
	pc.code as classcode,
	rp.cadastrallotno,
	rp.blockno,
	rp.surveyno,
	f.titleno,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv,
	r.totalav,
	f.effectivityyear,
	f.effectivityqtr,
	f.cancelreason,
	f.cancelledbytdnos,
	f.lguid,
	f.originlguid,
	f.effectivityyear as yearissued,
	null as taskid,
	null as taskstate,
	null as assignee_objid,
	null as trackingno,
	0 as publicland
from faas f 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join barangay b on rp.barangayid = b.objid 
	inner join propertyclassification pc on r.classification_objid = pc.objid 
where f.objid = $P{objid}		

