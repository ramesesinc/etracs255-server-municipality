[insertForProcess]
insert into report_rptdelinquency_forprocess(
	objid, barangayid
)
select rl.objid, rl.barangayid 
from rptledger rl 
where rl.state = 'APPROVED' 
and rl.taxable = 1
and rl.barangayid = $P{barangayid}
and (rl.lastyearpaid < $P{cy} or (rl.lastyearpaid = $P{cy} and rl.lastqtrpaid < 4))
and exists(select * from rptledgerfaas where state = 'APPROVED' and taxable = 1 and assessedvalue > 0)


[rescheduleError]
insert into report_rptdelinquency_forprocess(
	objid, barangayid
)
select objid, barangayid 
from report_rptdelinquency_error
where objid = $P{objid}


[findCount]
select count(*) as count from report_rptdelinquency_forprocess where barangayid = $P{barangayid}


[deleteErrors]
delete from report_rptdelinquency_error

[deleteForProcess]
delete from report_rptdelinquency_forprocess

[deleteItems]
delete from report_rptdelinquency_item

[deleteBarangays]
delete from report_rptdelinquency_barangay

[deleteDelinquency]
delete from report_rptdelinquency

