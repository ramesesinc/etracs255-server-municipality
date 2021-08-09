[getList]
SELECT 
    bl.*, 
    lc.name AS classification_name, 
    lc.objid as classification_objid   
FROM business_application_lob bl
INNER JOIN business b ON b.objid=bl.businessid
INNER JOIN lob ON bl.lobid=lob.objid
INNER JOIN lobclassification lc ON lob.classification_objid=lc.objid 
WHERE bl.applicationid = $P{applicationid}

[removeList]
DELETE FROM business_application_lob WHERE applicationid=$P{applicationid}


[getBusinessLOB]
select 
	b.objid, b.businessid, a.appyear as activeyear, 
	a.apptype, b.lobid, b.name, a.txndate, a.dtfiled 
from business_application_lob b 
	inner join business_application a on b.applicationid=a.objid 
where b.businessid = $P{businessid} 
	and a.appyear = $P{appyear} 
	and a.state = 'COMPLETED' 
order by a.txndate 


[getPreviousTaxes]
select 
	alob.lobid as lob_objid, alob.name as lob_name, sum(br.amount) as amount 
from business_application ba 
	inner join business_application_lob alob on alob.applicationid = ba.objid 
	inner join business_receivable br on (br.businessid = ba.business_objid and br.iyear = ba.appyear-1)  
where ba.objid = $P{applicationid} 
	and br.lob_objid = alob.lobid 
	and br.taxfeetype = 'TAX' 
group by alob.lobid, alob.name 
