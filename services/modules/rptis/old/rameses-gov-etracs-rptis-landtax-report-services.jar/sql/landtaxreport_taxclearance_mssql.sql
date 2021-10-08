[findInfo]
SELECT * FROM rpttaxclearance WHERE objid = $P{objid}

[insertTaxClearance]
INSERT INTO rpttaxclearance 
    (objid, year, qtr, reporttype)
VALUES 
    ($P{objid}, $P{year}, $P{qtr}, $P{reporttypename})


[getItems]
SELECT 
	rci.*,
	rl.objid as rptledgerid, 
	rl.tdno,
	rl.rputype,
	rl.fullpin ,
	rl.totalareaha,
	rl.totalareaha * 10000 as totalareasqm,
	rl.totalmv,
	rl.totalav,
	rl.cadastrallotno,
	rl.blockno,
	rl.administrator_name,
	f.administrator_address, 
	case when m.objid is not null then m.name else c.name end as lguname, 
	b.name AS barangay,
	rl.classcode,
	pc.name as classification, 
	rl.titleno,
	rp.surveyno,
    f.effectivityyear
FROM rptcertificationitem rci 
	INNER JOIN rptledger rl ON rci.refid = rl.objid 
	INNER JOIN barangay b ON rl.barangayid = b.objid 
	left JOIN propertyclassification pc ON rl.classification_objid = pc.objid 
	LEFT JOIN municipality m on b.parentid = m.objid
	LEFT JOIN district d on b.parentid = d.objid 
	LEFT JOIN city c on d.parentid = c.objid 
	LEFT JOIN faas f on rl.faasid = f.objid 
	LEFT JOIN realproperty rp on f.realpropertyid = rp.objid 
WHERE rci.rptcertificationid = $P{rptcertificationid}



[getClearedLedgers]
SELECT 
	rl.objid AS refid,
	rl.lastyearpaid,
	rl.lastqtrpaid,
	rl.tdno,
	rl.rputype,
	rl.fullpin ,
	rl.taxable,
	rl.totalareaha,
	rl.totalmv,
	rl.totalav,
	rl.cadastrallotno,
	b.name AS barangay,
	rl.classcode,
	rl.titleno
FROM rptledger rl
	INNER JOIN barangay b ON rl.barangayid = b.objid 
WHERE rl.state = 'APPROVED'
  AND rl.taxpayer_objid = $P{taxpayerid}
  AND ( rl.lastyearpaid > $P{year} OR (rl.lastyearpaid = $P{year} AND rl.lastqtrpaid >= $P{qtr}))
  AND not exists(select * from rptledger_subledger where objid = rl.objid)
  AND not exists(select * from rptcompromise where rptledgerid = rl.objid and state = 'APPROVED')



[getPaymentInfo]
select 
    rl.objid as rptledgerid, 
    xr.receiptno as orno,
    xr.txndate as ordate,
    SUM(ri.amount + ri.interest - ri.discount) AS oramount,
    SUM(CASE WHEN ri.revtype = 'basic' THEN ri.amount ELSE 0 END) AS basic,
    SUM(CASE WHEN ri.revtype = 'basic' THEN ri.discount ELSE 0 END) AS basicdisc,
    SUM(CASE WHEN ri.revtype = 'basic' THEN ri.interest ELSE 0 END) AS basicint,
    SUM(CASE WHEN ri.revtype = 'sef' THEN ri.amount ELSE 0 END) AS sef,
    SUM(CASE WHEN ri.revtype = 'sef' THEN ri.discount ELSE 0 END) AS sefdisc,
    SUM(CASE WHEN ri.revtype = 'sef' THEN ri.interest ELSE 0 END) AS sefint,

    case when (min(ri.qtr) = 1 and max(ri.qtr) = 4) or ((min(ri.qtr) = 0 and max(ri.qtr) = 0))
        then  'FULL ' + convert(varchar(4), ri.year)
        else
            convert(varchar(1),min(ri.qtr)) + 'Q,' + convert(varchar(4),ri.year) + ' - ' + 
            convert(varchar(1),max(ri.qtr)) + 'Q,' + convert(varchar(4),ri.year) 
    end as period
from rptcertificationitem rci 
    inner join rptledger rl on rci.refid = rl.objid 
    inner join rptpayment rp on rl.objid  = rp.refid 
    inner join rptpayment_item ri on rp.objid = ri.parentid
    inner join cashreceipt xr on rp.receiptid = xr.objid 
    left join cashreceipt_void cv on xr.objid = cv.receiptid  
where rci.rptcertificationid = $P{rptcertificationid}
    and rl.objid = $P{rptledgerid}
  and (ri.year = $P{year} and ri.qtr <= $P{qtr}) 
  and cv.objid is null 
group by rl.objid, xr.receiptno, xr.txndate, ri.year

union all

select 
    rl.objid as rptledgerid, 
    rc.refno as orno,
    rc.refdate as ordate,
    sum(rc.basic + rc.basicint - rc.basicdisc + rc.sef + rc.sefint - rc.sefdisc ) as oramount,
    sum(rc.basic) as basic,
    sum(rc.basicdisc) as basicdisc,
    sum(rc.basicint) as basicint,
    sum(rc.sef) as sef,
    sum(rc.sefdisc) as sefdisc,
    sum(rc.sefint) as sefint,  
    case when min(rc.fromyear) = max(rc.toyear) and min(rc.fromqtr) = 1 and max(rc.toqtr) = 4
        then  'FULL ' + convert(varchar(4), rc.toyear)
        else
            convert(varchar(1),min(rc.fromqtr)) + 'Q,' + convert(varchar(4),rc.fromyear) + ' - ' + 
            convert(varchar(1),max(rc.toqtr)) + 'Q,' + convert(varchar(4),rc.toyear) 
    end as period
from rptcertificationitem rci 
    inner join rptledger rl on rci.refid = rl.objid 
    inner join rptledger_credit rc on rl.objid = rc.rptledgerid
where rci.rptcertificationid = $P{rptcertificationid}
  and rl.objid = $P{rptledgerid}
  and ( ( $P{year} > rc.fromyear and $P{year} < rc.toyear)  or (($P{year} = rc.fromyear or $P{year} = rc.toyear) and  rc.toqtr <= $P{qtr}))
group by rl.objid, rc.refno, rc.refdate, rc.fromyear, rc.toyear 


[findPaidClearance]
select objid, txnno
from rptcertification 
where orno = $P{orno}
