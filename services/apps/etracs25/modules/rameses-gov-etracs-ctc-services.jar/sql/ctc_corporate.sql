[findRealPropertyAv]
SELECT SUM(r.totalav) AS totalav
FROM faas f 
	INNER JOIN rpu r ON f.rpuid = r.objid 
WHERE f.taxpayer_objid = $P{objid} 
  AND f.state = 'CURRENT' 
  AND r.taxable = 1	


[findBusinessGross]
SELECT 
	MAX(b.apptype) AS apptype, 
	SUM(bi.decimalvalue) AS totalgross
FROM business b 
	INNER JOIN business_info bi ON b.objid = bi.businessid 
WHERE b.permitee_objid = $P{objid}
  AND bi.attribute_objid = 'GROSS' 