[getBilledItems]
SELECT
	t.totalav,
	t.fromyear, 
	t.fromqtr,
	t.toyear,
	t.toqtr, 
	t.tdno,
	rl.rputype,
	rl.fullpin,
	rl.cadastrallotno, 
	rl.totalareaha,
	rl.totalareaha * 10000.0 AS totalareasqm,
	rl.classcode, 
	b.name AS barangay,
	SUM(t.basic) as basic, 
	SUM(t.basicdisc) as basicdisc, 
	SUM(t.basicint) as basicint, 
	SUM(t.basicidle) as basicidle, 
	SUM(t.basicidledisc) as basicidledisc, 
	SUM(t.basicidleint) as basicidleint, 
	SUM(t.sef) as sef, 
	SUM(t.sefdisc) as sefdisc, 
	SUM(t.sefint) as sefint, 
	SUM(t.firecode) as firecode, 
	SUM(t.amtdue) AS amtdue
FROM rptledger rl
	inner join barangay b on rl.barangayid = b.objid,
	(
		SELECT 
			x.*,
			(SELECT MIN(qtr) FROM rptledgeritem_qtrly WHERE rptledgerid = x.objid AND year = x.fromyear) AS fromqtr,
			(SELECT MAX(qtr) FROM rptledgeritem_qtrly WHERE rptledgerid = x.objid AND year = x.fromyear) AS toqtr
		FROM (
			SELECT
				rl.objid,
				rlf.assessedvalue as totalav, 
				rlf.tdno,
				MIN(bi.year) AS  fromyear,
				MAX(bi.year) AS toyear,
				SUM(bi.basic - bi.basicpaid) as basic, 
				SUM(bi.basicdisc) as basicdisc, 
				SUM(bi.basicint) as basicint, 
				SUM(bi.basicidle - bi.basicidlepaid) as basicidle, 
				SUM(bi.basicidledisc) as basicidledisc, 
				SUM(bi.basicidleint) as basicidleint, 
				SUM(bi.sef - bi.sefpaid) as sef, 
				SUM(bi.sefdisc) as sefdisc, 
				SUM(bi.sefint) as sefint, 
				SUM(bi.firecode - bi.firecodepaid) as firecode, 
				SUM(bi.basic - bi.basicpaid + bi.basicint - bi.basicdisc + 
					bi.sef - bi.sefpaid + bi.sefint - bi.sefdisc + 
					bi.firecode - bi.firecodepaid + 
					bi.basicidle - bi.basicidlepaid - bi.basicidledisc + bi.basicidleint ) AS amtdue
			FROM rptbill b 
				inner join rptbill_ledger bl on b.objid = bl.billid
				inner join rptledger rl on bl.rptledgerid = rl.objid 
				INNER JOIN rptledgeritem rli ON rl.objid = rli.rptledgerid
				INNER JOIN rptledgeritem_qtrly bi ON rli.objid = bi.parentid 
				INNER JOIN rptledgerfaas rlf ON rli.rptledgerfaasid = rlf.objid 
		WHERE b.objid = $P{billid}
			  AND rl.state = 'APPROVED'
			 ${cyfilter}
			GROUP BY 
				rl.objid, 
				rlf.assessedvalue,
				rlf.tdno
		)x	
	) t
WHERE rl.objid = t.objid
GROUP BY 
	t.totalav,
	t.fromyear, 
	t.fromqtr,
	t.toyear,
	t.toqtr, 
	t.tdno,
	rl.rputype,
	rl.fullpin,
	rl.cadastrallotno, 
	rl.totalareaha,
	rl.classcode, 
	b.name
ORDER BY t.fromyear, t.toyear 
