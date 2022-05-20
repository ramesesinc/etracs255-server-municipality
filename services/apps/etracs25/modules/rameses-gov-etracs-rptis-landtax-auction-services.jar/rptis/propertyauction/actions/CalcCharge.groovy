package rptis.propertyauction.actions;

import com.rameses.rules.common.*;
import rptis.propertyauction.facts.*;

public class CalcCharge implements RuleActionHandler {
	def request;
	def NS;
	def IA;

	public void execute(def params, def drools) {
		def acct = params.account; 
		def amt = params.expr.getDecimalValue()
		def charge = [:]

		if( amt == null )
			throw new Exception("Amount in CalcCharge must not be null");
		if(acct.key==null)
			throw new Exception("Charge account must be specified");

		def account = IA.select('objid,code,title,fund_objid,fund_code,fund_title').find([objid:acct.key]).first()
		if(account==null) throw new Exception("Charge account not found");

		charge.amount = NS.round(amt);
		charge.item = account 

		def c = request.charges.find{it.item.objid == charge.item.objid}
		if (c){
			c.putAll(charge)
		}
		else {
			request.charges << charge 
		}
	}
}
