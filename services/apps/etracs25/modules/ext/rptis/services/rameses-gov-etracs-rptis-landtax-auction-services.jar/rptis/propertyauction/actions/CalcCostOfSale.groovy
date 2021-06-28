package rptis.propertyauction.actions;

import com.rameses.rules.common.*;
import rptis.propertyauction.facts.*;

public class CalcCostOfSale implements RuleActionHandler {
	def NS;

	public void execute(def params, def drools) {
		def notice = params.notice; 
		def cos = params.expr.getDecimalValue()
		notice.costofsale = NS.round(cos)
	}
}
