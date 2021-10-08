[findCompromiseByTxnno]
select * from rptledger_compromise where txnno = $P{txnno}


[resetPayment]
update rptledger_compromise_item set 
	basicpaid = 0,
	basicintpaid = 0,
	basicidlepaid = 0,
	sefpaid = 0,
	sefintpaid = 0,
	firecodepaid = 0,
	basicidleintpaid = 0,
	fullypaid = 0
where rptcompromiseid = $P{objid}	


[findPayment]
select (amtpaid + downpayment) as amtpaid from rptledger_compromise where objid = $P{objid}


[getItems]
select 
	objid, year, qtr,
	basic, basicint, basicidle, sef, sefint, firecode, basicidleint,
	(basic + basicint + basicidle + sef + sefint + firecode + basicidleint) as total
from rptledger_compromise_item 
where rptcompromiseid = $P{objid}
order by year, qtr 


[updateFullyPaidItem]
update rptledger_compromise_item set 
	basicpaid = basic,
	basicintpaid = basicint,
	basicidlepaid = basicidle,
	sefpaid = sef,
	sefintpaid = sefint,
	firecodepaid = firecode,
	basicidleintpaid = basicidleint,
	fullypaid = 1
where objid = $P{objid}	

[updatePartialledItem]
update rptledger_compromise_item set 
	basicpaid = $P{basicpaid},
	basicintpaid = $P{basicintpaid},
	basicidlepaid = $P{basicidlepaid},
	sefpaid = $P{sefpaid},
	sefintpaid = $P{sefintpaid},
	firecodepaid = $P{firecodepaid},
	basicidleintpaid = $P{basicidleintpaid},
	fullypaid = 0
where objid = $P{objid}	

