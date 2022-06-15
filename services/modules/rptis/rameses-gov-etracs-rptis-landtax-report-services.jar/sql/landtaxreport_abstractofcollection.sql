[getAbstractOfRPTCollection] 
select t.*
from (
    select
    cr.objid as receiptid, 
    rl.objid as rptledgerid,
    rl.fullpin,
    1 AS idx,
    MIN(rpi.year) AS minyear,
    min(rp.fromqtr) as minqtr,
    MAX(rpi.year) AS maxyear, 
    max(rp.toqtr) as maxqtr,
    'BASIC' AS type, 
    cr.receiptdate AS ordate, 
    CASE WHEN cv.objid IS NULL THEN cr.paidby ELSE '*** VOIDED ***' END AS taxpayername, 
    CASE WHEN cv.objid IS NULL THEN rl.tdno ELSE '' END AS tdno, 
    cr.receiptno AS orno, 
    CASE WHEN m.name IS NULL THEN c.name ELSE m.name END AS municityname, 
    b.name AS barangay, 
    CASE WHEN cv.objid IS NULL  THEN rl.classcode ELSE '' END AS classification, 
    CASE WHEN cv.objid IS NULL THEN rl.totalav else 0.0 end as assessvalue,
    rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv, 
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('current','advance') THEN rpi.amount ELSE 0.0 END) AS currentyear,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('previous','prior') THEN rpi.amount ELSE 0.0 END) AS previousyear,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' THEN rpi.discount ELSE 0.0 END) AS discount,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('current','advance') THEN rpi.interest ELSE 0.0 END) AS penaltycurrent,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('previous','prior') THEN rpi.interest ELSE 0.0 END) AS penaltyprevious,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end) as basicidlecurrent,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end) as basicidleprevious,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' then rpi.amount else 0.0 end) as basicidlediscount,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end) as basicidlecurrentpenalty,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end) as basicidlepreviouspenalty,

    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end) as shcurrent,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end) as shprevious,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' then rpi.discount else 0.0 end) as shdiscount,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end) as shcurrentpenalty,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end) as shpreviouspenalty,

    sum(case when cv.objid is null AND rpi.revtype = 'firecode' then rpi.amount else 0.0 end) as firecode,
    sum(
        case 
            when cv.objid is null AND rpi.revtype in ('basic', 'basicidle', 'sh', 'firecode') 
            then rpi.amount - rpi.discount + rpi.interest 
            else 0.0 
        end 
    ) as total,

    max(case when cv.objid is null then rpi.partialled else 0 end) as partialled
  from collectionvoucher liq
    inner join remittance rem on rem.collectionvoucherid = liq.objid 
    inner join cashreceipt cr on rem.objid = cr.remittanceid
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
    inner join rptpayment rp on rp.receiptid= cr.objid 
    inner join rptpayment_item rpi on rpi.parentid = rp.objid
    inner join rptledger rl on rl.objid = rp.refid
    inner join barangay b on b.objid  = rl.barangayid
    left join district d on b.parentid = d.objid 
    left join city c on d.parentid = c.objid 
    left join municipality m on b.parentid = m.objid 
  where ${filter} 
    and cr.collector_objid LIKE $P{collectorid} 
  GROUP BY cr.objid, cr.receiptdate, cr.paidby, cr.receiptno, rl.objid, rl.fullpin, rl.tdno, b.name, 
            rl.classcode, cv.objid, m.name, c.name , rl.totalav, rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv
   
  union all  

    select
    cr.objid as receiptid, 
    rl.objid as rptledgerid,
    rl.fullpin,
    2 AS idx,
    MIN(rpi.year) AS minyear,
    min(rp.fromqtr) as minqtr,
    MAX(rpi.year) AS maxyear, 
    max(rp.toqtr) as maxqtr,
    'SEF' AS type, 
    cr.receiptdate AS ordate, 
    CASE WHEN cv.objid IS NULL THEN cr.paidby ELSE '*** VOIDED ***' END AS taxpayername, 
    CASE WHEN cv.objid IS NULL THEN rl.tdno ELSE '' END AS tdno, 
    cr.receiptno AS orno, 
    CASE WHEN m.name IS NULL THEN c.name ELSE m.name END AS municityname, 
    b.name AS barangay, 
    CASE WHEN cv.objid IS NULL  THEN rl.classcode ELSE '' END AS classification, 
    CASE WHEN cv.objid IS NULL THEN rl.totalav else 0.0 end as assessvalue,
    rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv, 
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('current','advance') AND rpi.revtype = 'sef' THEN rpi.amount ELSE 0.0 END) AS currentyear,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('previous','prior') AND rpi.revtype = 'sef'  THEN rpi.amount ELSE 0.0 END) AS previousyear,
    SUM(CASE WHEN cv.objid IS NULL   AND rpi.revtype = 'sef' THEN rpi.discount ELSE 0.0 END) AS discount,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('current','advance')  AND rpi.revtype = 'sef' THEN rpi.interest ELSE 0.0 END) AS penaltycurrent,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('previous','prior')  AND rpi.revtype = 'sef' THEN rpi.interest ELSE 0.0 END) AS penaltyprevious,
    0 as basicidlecurrent,
    0 as basicidleprevious,
    0 as basicidlediscount,
    0 as basicidlecurrentpenalty,
    0 as basicidlepreviouspenalty,

    0 as shcurrent,
    0 as shprevious,
    0 as shdiscount,
    0 as shcurrentpenalty,
    0 as shpreviouspenalty,

    0 as firecode,
    sum(
        case when cv.objid is null and rpi.revtype in ('sef') then rpi.amount - rpi.discount + rpi.interest 
        else 0.0 end 
    ) as total,

    max(case when cv.objid is null then rpi.partialled else 0 end) as partialled
  from collectionvoucher liq
    inner join remittance rem on rem.collectionvoucherid = liq.objid 
    inner join cashreceipt cr on rem.objid = cr.remittanceid
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
    inner join rptpayment rp on rp.receiptid= cr.objid 
    inner join rptpayment_item rpi on rpi.parentid = rp.objid
    inner join rptledger rl on rl.objid = rp.refid
    inner join barangay b on b.objid  = rl.barangayid
    left join district d on b.parentid = d.objid 
    left join city c on d.parentid = c.objid 
    left join municipality m on b.parentid = m.objid 
  where ${filter} 
    and cr.collector_objid LIKE $P{collectorid} 
  GROUP BY cr.objid, cr.receiptdate, cr.paidby, cr.receiptno, rl.objid, rl.fullpin, rl.tdno, b.name, 
            rl.classcode, cv.objid, m.name, c.name , rl.totalav, rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv
   
) t
order by t.municityname, t.idx, t.orno 





[getAbstractOfRPTCollectionAdvance] 
select t.*
from (
    select
    cr.objid as receiptid, 
    rl.objid as rptledgerid,
    rl.fullpin,
    1 AS idx,
    MIN(rpi.year) AS minyear,
    min(rp.fromqtr) as minqtr,
    MAX(rpi.year) AS maxyear, 
    max(rp.toqtr) as maxqtr,
    'BASIC' AS type, 
    cr.receiptdate AS ordate, 
    CASE WHEN cv.objid IS NULL THEN cr.paidby ELSE '*** VOIDED ***' END AS taxpayername, 
    CASE WHEN cv.objid IS NULL THEN rl.tdno ELSE '' END AS tdno, 
    cr.receiptno AS orno, 
    CASE WHEN m.name IS NULL THEN c.name ELSE m.name END AS municityname, 
    b.name AS barangay, 
    CASE WHEN cv.objid IS NULL  THEN rl.classcode ELSE '' END AS classification, 
    CASE WHEN cv.objid IS NULL THEN rl.totalav else 0.0 end as assessvalue,
    rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv, 
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('current','advance') THEN rpi.amount ELSE 0.0 END) AS currentyear,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('previous','prior') THEN rpi.amount ELSE 0.0 END) AS previousyear,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' THEN rpi.discount ELSE 0.0 END) AS discount,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('current','advance') THEN rpi.interest ELSE 0.0 END) AS penaltycurrent,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revtype = 'basic' AND rpi.revperiod IN ('previous','prior') THEN rpi.interest ELSE 0.0 END) AS penaltyprevious,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end) as basicidlecurrent,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end) as basicidleprevious,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' then rpi.amount else 0.0 end) as basicidlediscount,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end) as basicidlecurrentpenalty,
    sum(case when cv.objid is null  AND rpi.revtype = 'basicidle' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end) as basicidlepreviouspenalty,

    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.amount else 0.0 end) as shcurrent,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.amount else 0.0 end) as shprevious,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' then rpi.discount else 0.0 end) as shdiscount,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('current','advance') then rpi.interest else 0.0 end) as shcurrentpenalty,
    sum(case when cv.objid is null  AND rpi.revtype = 'sh' and rpi.revperiod in ('previous','prior') then rpi.interest else 0.0 end) as shpreviouspenalty,

    sum(case when cv.objid is null AND rpi.revtype = 'firecode' then rpi.amount else 0.0 end) as firecode,
    sum(
        case 
            when cv.objid is null AND rpi.revtype in ('basic', 'basicidle', 'sh', 'firecode') 
            then rpi.amount - rpi.discount + rpi.interest 
            else 0.0 
        end 
    ) as total,

    max(case when cv.objid is null then rpi.partialled else 0 end) as partialled
  from remittance rem
    inner join cashreceipt cr on rem.objid = cr.remittanceid
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
    inner join rptpayment rp on rp.receiptid= cr.objid 
    inner join rptpayment_item rpi on rpi.parentid = rp.objid
    inner join rptledger rl on rl.objid = rp.refid
    inner join barangay b on b.objid  = rl.barangayid
    left join collectionvoucher liq on rem.collectionvoucherid = liq.objid 
    left join district d on b.parentid = d.objid 
    left join city c on d.parentid = c.objid 
    left join municipality m on b.parentid = m.objid 
   where ${filter} 
     and cr.collector_objid LIKE $P{collectorid} 
    and rpi.year > $P{year}
  GROUP BY cr.objid, cr.receiptdate, cr.paidby, cr.receiptno, rl.objid, rl.fullpin, rl.tdno, b.name, 
            rl.classcode, cv.objid, m.name, c.name , rl.totalav, rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv
   
  union all  

    select
    cr.objid as receiptid, 
    rl.objid as rptledgerid,
    rl.fullpin,
    2 AS idx,
    MIN(rpi.year) AS minyear,
    min(rp.fromqtr) as minqtr,
    MAX(rpi.year) AS maxyear, 
    max(rp.toqtr) as maxqtr,
    'SEF' AS type, 
    cr.receiptdate AS ordate, 
    CASE WHEN cv.objid IS NULL THEN cr.paidby ELSE '*** VOIDED ***' END AS taxpayername, 
    CASE WHEN cv.objid IS NULL THEN rl.tdno ELSE '' END AS tdno, 
    cr.receiptno AS orno, 
    CASE WHEN m.name IS NULL THEN c.name ELSE m.name END AS municityname, 
    b.name AS barangay, 
    CASE WHEN cv.objid IS NULL  THEN rl.classcode ELSE '' END AS classification, 
    CASE WHEN cv.objid IS NULL THEN rl.totalav else 0.0 end as assessvalue,
    rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv, 
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('current','advance') AND rpi.revtype = 'sef' THEN rpi.amount ELSE 0.0 END) AS currentyear,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('previous','prior') AND rpi.revtype = 'sef'  THEN rpi.amount ELSE 0.0 END) AS previousyear,
    SUM(CASE WHEN cv.objid IS NULL   AND rpi.revtype = 'sef' THEN rpi.discount ELSE 0.0 END) AS discount,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('current','advance')  AND rpi.revtype = 'sef' THEN rpi.interest ELSE 0.0 END) AS penaltycurrent,
    SUM(CASE WHEN cv.objid IS NULL  AND rpi.revperiod IN ('previous','prior')  AND rpi.revtype = 'sef' THEN rpi.interest ELSE 0.0 END) AS penaltyprevious,
    0 as basicidlecurrent,
    0 as basicidleprevious,
    0 as basicidlediscount,
    0 as basicidlecurrentpenalty,
    0 as basicidlepreviouspenalty,

    0 as shcurrent,
    0 as shprevious,
    0 as shdiscount,
    0 as shcurrentpenalty,
    0 as shpreviouspenalty,

    0 as firecode,
    sum(
        case when cv.objid is null and rpi.revtype in ('sef') then rpi.amount - rpi.discount + rpi.interest 
        else 0.0 end 
    ) as total,

    max(case when cv.objid is null then rpi.partialled else 0 end) as partialled
  from remittance rem
    inner join cashreceipt cr on rem.objid = cr.remittanceid
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
    inner join rptpayment rp on rp.receiptid= cr.objid 
    inner join rptpayment_item rpi on rpi.parentid = rp.objid
    inner join rptledger rl on rl.objid = rp.refid
    inner join barangay b on b.objid  = rl.barangayid
    left join collectionvoucher liq on rem.collectionvoucherid = liq.objid 
    left join district d on b.parentid = d.objid 
    left join city c on d.parentid = c.objid 
    left join municipality m on b.parentid = m.objid 
  where ${filter} 
    and cr.collector_objid LIKE $P{collectorid} 
    and rpi.year > $P{year}
  GROUP BY cr.objid, cr.receiptdate, cr.paidby, cr.receiptno, rl.objid, rl.fullpin, rl.tdno, b.name, 
            rl.classcode, cv.objid, m.name, c.name , rl.totalav, rl.titleno, rl.cadastrallotno, rl.rputype, rl.totalmv
   
) t
order by t.municityname, t.idx, t.orno 





[getMuniCityByRemittance]
select 
  distinct t.* 
 from (
  select
    case when m.name is null then c.name else m.name end as municityname 
  from remittance rem 
    inner join cashreceipt cr on rem.objid = cr.remittanceid 
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
    inner join rptpayment rp on cr.objid = rp.receiptid
    inner join rptpayment_item cri on rp.objid = cri.parentid
    inner join rptledger rl on rp.refid = rl.objid 
    inner join barangay b on rl.barangayid = b.objid 
    left join district d on b.parentid = d.objid 
    left join city c on d.parentid = c.objid 
    left join municipality m on b.parentid = m.objid 
  where rem.objid =  $P{remittanceid} 
 ) t 


[getAbstractOfRPTCollectionDetail]
select 
  c.objid,
  c.receiptno,
  c.receiptdate as ordate,
  case when cv.objid is null then c.paidby else '*** VOIDED ***' end as taxpayername, 
  case when cv.objid is null then c.amount else 0.0 end AS amount 
from cashreceipt c 
  inner join cashreceipt_rpt crpt on crpt.objid = c.objid
  left join cashreceipt_void cv on cv.receiptid  = c.objid 
where c.remittanceid=$P{remittanceid} 
  and cv.objid is null 
order by c.receiptno  


[getAbstractOfRPTCollectionDetailItem]
select
    b.name as barangay, rl.tdno, rl.cadastrallotno, rl.totalav as assessedavalue,
    rpi.year, rpi.qtr ,
    sum(rpi.basic) as basic, 
    sum(rpi.basicdp) as basicdp, 
    sum(rpi.basicnet) as basicnet,
    sum(rpi.sef) as sef, 
    sum(rpi.sefdp) as sefdp, 
    sum(rpi.sefnet) as sefnet,
    sum(rpi.basicidle + rpi.basicidledp) as idlenet,
    sum(rpi.sh + rpi.shdp) as shnet,
    sum(rpi.firecode) as firecode,
    sum(rpi.amount) as total
from rptpayment rp
  inner join vw_rptpayment_item_detail rpi on rp.objid = rpi.parentid
  inner join rptledger rl on rp.refid = rl.objid 
  inner join barangay b on b.objid = rl.barangayid 
where rp.receiptid = $P{objid}
group by 
    b.name, rl.tdno, rl.cadastrallotno, rl.totalav, rpi.year, rpi.qtr
order by b.name, rl.tdno, rl.cadastrallotno, rpi.year, rpi.qtr


[getAbstractOfRPTCollectionSummary]
select 
	xx.*,
	case 
        when xx.basic > 0 and xx.basicint > 0 then round(xx.basicint / xx.basic, 2)
        when xx.basic > 0 and xx.basicdisc > 0 then round(xx.basicdisc / xx.basic, 2)
        else 0
    end as rate
from (
	select 
			x.receiptno,
			x.receiptdate,
			x.amount,
			x.barangay,
			x.tdno,
			x.assessedvalue,
			x.taxpayername,
			min(x.year) as fromyear,
			max(x.year) as toyear,
			sum(x.basic) as basic,
			sum(x.basicint) as basicint,
			sum(x.basicdisc) as basicdisc,
			sum(x.basicdp) as basicdp,
			sum(x.basicnet) as basicnet,
			sum(x.sef) as sef,
			sum(x.sefdp) as sefdp,
			sum(x.sefnet) as sefnet,
			sum(x.total) as total 
	from (
			select 
					c.receiptno,
					c.receiptdate,
					case when cv.objid is null then c.amount else 0 end as amount, 
					b.name as barangay,
					rl.tdno,
					rlf.assessedvalue,
					case when cv.objid is null then c.paidby else '*** VOIDED ***' end as taxpayername, 
					rpi.year, 
					sum(case when cv.objid is null then rpi.year else null end) as fromyear,
					sum(case when cv.objid is null then rpi.year else null end) as toyear, 
					sum(case when cv.objid is null then rpi.basic else null end) as basic,
					sum(case when cv.objid is null then rpi.basicdisc else null end) as basicdisc,
					sum(case when cv.objid is null then rpi.basicint else null end) as basicint,
					sum(case when cv.objid is null then rpi.basicdp else null end) as basicdp,
					sum(case when cv.objid is null then rpi.basicnet else null end) as basicnet,
					sum(case when cv.objid is null then rpi.sef else null end ) as sef,
					sum(case when cv.objid is null then rpi.sefdisc else null end ) as sefdisc,
					sum(case when cv.objid is null then rpi.sefint else null end ) as sefint,
					sum(case when cv.objid is null then rpi.sefdp else null end) as sefdp,
					sum(case when cv.objid is null then rpi.sefnet else null end) as sefnet, 
					sum(case when cv.objid is null then rpi.basicnet + rpi.sefnet else null end) as total
			from cashreceipt c 
					inner join cashreceipt_rpt crpt on crpt.objid = c.objid
					inner join rptpayment rp on c.objid = rp.receiptid
					inner join vw_rptpayment_item_detail rpi on rp.objid = rpi.parentid
					inner join rptledger rl on rp.refid = rl.objid 
					inner join barangay b on rl.barangayid = b.objid 
					inner join rptledgerfaas rlf on rpi.rptledgerfaasid = rlf.objid 
					left join cashreceipt_void cv on cv.receiptid  = c.objid 
			where c.remittanceid = $P{remittanceid} 
					and cv.objid is null 
			group by 
					c.receiptno,
					c.receiptdate,
					case when cv.objid is null then c.amount else 0 end, 
					b.name,
					rl.tdno,
					rlf.assessedvalue,
					case when cv.objid is null then c.paidby else '*** VOIDED ***' end,
					rpi.year 
	) x 
	group by 
			x.receiptno,
			x.receiptdate,
			x.amount,
			x.barangay,
			x.tdno,
			x.assessedvalue,
			x.taxpayername    
) xx
order by xx.receiptno, xx.tdno, xx.fromyear

