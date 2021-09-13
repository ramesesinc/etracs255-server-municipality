[findLedger]
select * from rptledger where objid = $P{objid}

[findCompromise]
select * from rptledger_compromise where objid = $P{objid}


[updateLedgerCompromiseFlag]
update rptledger set 
  undercompromise = $P{undercompromise}
where objid = $P{objid}
