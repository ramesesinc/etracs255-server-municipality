[getBarangays]
SELECT objid FROM barangay

[findBusinessInfo]
SELECT 
	MAX(b.apptype) AS apptype, 
	SUM(bi.decimalvalue) AS totalgross
FROM business b 
	INNER JOIN business_info bi ON b.objid = bi.businessid 
WHERE b.permitee_objid = $P{objid}
  AND bi.attribute_objid = 'GROSS' 