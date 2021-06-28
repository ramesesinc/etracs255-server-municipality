package rptis.propertyauction.actions;

import com.rameses.rules.common.*;
import rptis.propertyauction.facts.*;

public class AddBidItemAccount implements RuleActionHandler {
	def request;
	def NS;
	def IA;

	public void execute(def params, def drools) {
		def acct = params.account; 
		def amt = params.expr.getDecimalValue()

		if(acct.key==null)
			throw new Exception("Charge account must be specified");
		if( amt == null )
			throw new Exception("Amount to collect must not be null");
		
		def account = IA.find([objid:acct.key]).first()
		if(account==null) 
			throw new Exception("Charge account not found");

		def item  = [:]
		item.amount = NS.round(amt);
		item.item = account 

		def c = request.items.find{it.item.objid == item.item.objid}
		if (c){
			c.putAll(item)
		}
		else {
			request.items << item
		}
	}
}
