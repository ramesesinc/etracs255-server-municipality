[getReceiptsWithUnpostedShares]
select 
    o.*, a.amount as shareamt
from (
    select 
        cr.objid,
        rl.objid as rptledgerid, 
        b.parentid as lguid,
        rl.barangayid,
        cr.receiptno,
        rlp.objid as paymentid,
        sum(ri.amount + ri.interest - ri.discount) as amount
    from remittance rem 
        inner join collectionvoucher liq on liq.objid = rem.collectionvoucherid 
        inner join cashreceipt cr on cr.remittanceid = rem.objid 
        inner join rptpayment rlp on cr.objid = rlp.receiptid
        inner join rptpayment_item ri on rlp.objid = ri.parentid
        left join rptledger rl ON rlp.refid = rl.objid  
        left join barangay b on rl.barangayid = b.objid 
        left join propertyclassification pc ON rl.classification_objid = pc.objid 
    where rem.remittancedate >= $P{remfromdate} and rem.remittancedate < $P{remtodate}
        and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
    group by cr.objid,
        rl.objid,
        b.parentid,
        rl.barangayid,
        cr.receiptno,
        rlp.objid
)o
left join 
(
    select 
        cr.objid,
        rl.objid as rptledgerid, 
        b.parentid as lguid,
        rl.barangayid,
        cr.receiptno, 
        rlp.objid as paymentid,
        sum(ri.amount)  as amount
    from remittance rem 
        inner join collectionvoucher liq on liq.objid = rem.collectionvoucherid 
        inner join cashreceipt cr on cr.remittanceid = rem.objid 
        inner join rptpayment rlp on cr.objid = rlp.receiptid
        inner join rptpayment_share ri on rlp.objid = ri.parentid
        left join rptledger rl ON rlp.refid = rl.objid  
        left join barangay b on rl.barangayid = b.objid 
        left join propertyclassification pc ON rl.classification_objid = pc.objid 
    where rem.remittancedate >= $P{remfromdate} and rem.remittancedate < $P{remtodate}
        and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
  group by
  		cr.objid,
        rl.objid, 
        b.parentid,
        rl.barangayid,
        cr.receiptno, 
        rlp.objid
) a on o.receiptno = a.receiptno
where (a.receiptno is null  or o.amount <> a.amount)



[findShareAccount]
select 
	x.*
from (
	select 'barangay' as sharetype, 'basic' as revtype, 'advance' as revperiod, basicadvacct_objid as item_objid from brgy_taxaccount_mapping
	union 
	select 'barangay' as sharetype, 'basic' as revtype, 'previous' as revperiod, basicprevacct_objid as item_objid from brgy_taxaccount_mapping
	union 
	select 'barangay' as sharetype, 'basicint' as revtype, 'previous' as revperiod, basicprevintacct_objid as item_objid from brgy_taxaccount_mapping
	union 
	select 'barangay' as sharetype, 'basic' as revtype, 'prior' as revperiod, basicprioracct_objid as item_objid from brgy_taxaccount_mapping
	union 
	select 'barangay' as sharetype, 'basicint' as revtype, 'prior' as revperiod, basicpriorintacct_objid as item_objid from brgy_taxaccount_mapping
	union 
	select 'barangay' as sharetype, 'basic' as revtype, 'current' as revperiod, basiccurracct_objid as item_objid from brgy_taxaccount_mapping
	union 
	select 'barangay' as sharetype, 'basicint' as revtype, 'current' as revperiod, basiccurrintacct_objid as item_objid from brgy_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'basic' as revtype, 'advance' as revperiod, basicadvacct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'basic' as revtype, 'previous' as revperiod, basicprevacct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'basicint' as revtype, 'previous' as revperiod, basicprevintacct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'basic' as revtype, 'prior' as revperiod, basicprioracct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'basicint' as revtype, 'prior' as revperiod, basicpriorintacct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'basic' as revtype, 'current' as revperiod, basiccurracct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'basicint' as revtype, 'current' as revperiod, basiccurrintacct_objid as item_objid from municipality_taxaccount_mapping
	union
	select 'municipality' as sharetype, 'sef' as revtype, 'advance' as revperiod, sefadvacct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'sef' as revtype, 'previous' as revperiod, sefprevacct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'sefint' as revtype, 'previous' as revperiod, sefprevintacct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'sef' as revtype, 'prior' as revperiod, sefprioracct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'sefint' as revtype, 'prior' as revperiod, sefpriorintacct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'sef' as revtype, 'current' as revperiod, sefcurracct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'sefint' as revtype, 'current' as revperiod, sefcurrintacct_objid as item_objid from municipality_taxaccount_mapping
	union
	select 'municipality' as sharetype, 'basicidle' as revtype, 'advance' as revperiod, basicidleadvacct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'basicidle' as revtype, 'previous' as revperiod, basicidleprevacct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'basicidleint' as revtype, 'previous' as revperiod, basicidleprevintacct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'basicidle' as revtype, 'current' as revperiod, basicidlecurracct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'municipality' as sharetype, 'basicidleint' as revtype, 'current' as revperiod, basicidlecurrintacct_objid as item_objid from municipality_taxaccount_mapping
	union 
	select 'province' as sharetype, 'basic' as revtype, 'advance' as revperiod, basicadvacct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'basic' as revtype, 'previous' as revperiod, basicprevacct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'basicint' as revtype, 'previous' as revperiod, basicprevintacct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'basic' as revtype, 'prior' as revperiod, basicprioracct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'basicint' as revtype, 'prior' as revperiod, basicpriorintacct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'basic' as revtype, 'current' as revperiod, basiccurracct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'basicint' as revtype, 'current' as revperiod, basiccurrintacct_objid as item_objid from province_taxaccount_mapping
	union
	select 'province' as sharetype, 'sef' as revtype, 'advance' as revperiod, sefadvacct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'sef' as revtype, 'previous' as revperiod, sefprevacct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'sefint' as revtype, 'previous' as revperiod, sefprevintacct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'sef' as revtype, 'prior' as revperiod, sefprioracct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'sefint' as revtype, 'prior' as revperiod, sefpriorintacct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'sef' as revtype, 'current' as revperiod, sefcurracct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'sefint' as revtype, 'current' as revperiod, sefcurrintacct_objid as item_objid from province_taxaccount_mapping
	union
	select 'province' as sharetype, 'basicidle' as revtype, 'advance' as revperiod, basicidleadvacct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'basicidle' as revtype, 'previous' as revperiod, basicidleprevacct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'basicidleint' as revtype, 'previous' as revperiod, basicidleprevintacct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'basicidle' as revtype, 'current' as revperiod, basicidlecurracct_objid as item_objid from province_taxaccount_mapping
	union 
	select 'province' as sharetype, 'basicidleint' as revtype, 'current' as revperiod, basicidlecurrintacct_objid as item_objid from province_taxaccount_mapping

	union 
	
	select 'barangay' as sharetype,  m.revtype, m.revperiod, m.item_objid
	from landtax_lgu_account_mapping m, sys_org o 
	where m.lgu_objid = o.objid and o.orgclass = 'barangay'

	union 

	select 'municipality' as sharetype,  m.revtype, m.revperiod, m.item_objid
	from landtax_lgu_account_mapping m, sys_org o 
	where m.lgu_objid = o.objid and o.orgclass = 'municipality'

	union 

	select 'province' as sharetype,  m.revtype, m.revperiod, m.item_objid
	from landtax_lgu_account_mapping m, sys_org o 
	where m.lgu_objid = o.objid and o.orgclass = 'province'

	union 

	select 'city' as sharetype,  m.revtype, m.revperiod, m.item_objid
	from landtax_lgu_account_mapping m, sys_org o 
	where m.lgu_objid = o.objid and o.orgclass = 'city'
) x
where x.item_objid = $P{itemid}

