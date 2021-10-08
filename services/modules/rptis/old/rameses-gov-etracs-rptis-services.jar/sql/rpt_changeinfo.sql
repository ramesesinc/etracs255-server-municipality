[updatePropertyInfo]
update realproperty set
	cadastrallotno = $P{cadastrallotno},
	blockno = $P{blockno},
	surveyno = $P{surveyno},
	street = $P{street},
	purok = $P{purok},
	north = $P{north},
	south = $P{south},
	east = $P{east},
	west = $P{west}
where objid = $P{rpid}


[updateLedgerPropertyInfo]
update rptledger set
	cadastrallotno = $P{cadastrallotno}
where faasid = $P{faasid}	


[updateFaasInfo]
update faas set 
	tdno 		= $P{tdno},
	utdno 		= $P{utdno},
	titleno 	= $P{titleno},
	titledate 	= $P{titledate},
	restrictionid 	= $P{restrictionid},
	effectivityyear = $P{effectivityyear},
	effectivityqtr 	= $P{effectivityqtr},
	memoranda 		= $P{memoranda},
	txntype_objid 	= $P{txntypeid}
where objid = $P{faasid}	

[updateFaasPreviousInfo]
update faas set 
	prevtdno  = $P{prevtdno},
	prevpin  = $P{prevpin},
	prevowner  = $P{prevowner},
	prevav  = $P{prevav},
	prevmv  = $P{prevmv},
	prevadministrator  = $P{prevadministrator},
	prevareaha  = $P{prevareaha},
	prevareasqm  = $P{prevareasqm},
	preveffectivity  = $P{preveffectivity}
where objid = $P{faasid}	


[updateLedgerInfo]
update rptledger set 
	tdno = $P{tdno},
	taxable = case when $P{taxable} is null then taxable else $P{taxable} end,
	titleno = $P{titleno}
where faasid = $P{faasid}

[updateLedgerFaasInfo]
update rptledgerfaas set 
	tdno = $P{tdno},
	taxable = case when $P{taxable} is null then taxable else $P{taxable} end,
	fromyear = $P{effectivityyear},
	fromqtr = $P{effectivityqtr}
where faasid = $P{faasid}

[updateRpuInfo]
update rpu set 
	classification_objid  = $P{classificationid},
	taxable = case when $P{taxable} is null then taxable else $P{taxable} end,
	exemptiontype_objid = $P{exemptiontypeid}
where objid = $P{rpuid}

[updateLandRpuInfo]
update landrpu set 
	publicland = $P{publicland}
where objid = $P{rpuid}


[updateFaasOwnerInfo]
update faas set 
	taxpayer_objid = $P{taxpayer_objid},
	owner_name = $P{owner_name},
	owner_address = $P{owner_address},
	administrator_objid = $P{administrator_objid},
	administrator_name = $P{administrator_name},
	administrator_address = $P{administrator_address}
where objid = $P{faasid}

[updateLedgerOwnerInfo]
update rptledger set 
	taxpayer_objid = $P{taxpayer_objid},
	owner_name = $P{owner_name}
where faasid = $P{faasid}


[getImageIds]

select rq.objid
from rpt_redflag rr 
	inner join rpt_requirement rq on rr.refid = rq.refid 
where rr.objid = $P{objid}
and rq.requirementtypeid = $P{requirementtypeid};

