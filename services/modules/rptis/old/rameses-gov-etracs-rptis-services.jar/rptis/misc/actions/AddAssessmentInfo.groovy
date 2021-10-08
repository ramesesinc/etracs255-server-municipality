package rptis.misc.actions;

import com.rameses.rules.common.*;
import rptis.misc.facts.*;
import rptis.facts.*;


public class AddAssessmentInfo implements RuleActionHandler {
	def request
	def NS

	/*-----------------------------------------------------
	* create a assessment fact summarized based 
	* on the actualuseid
	*
	-----------------------------------------------------*/
	public void execute(def params, def drools) {
		def miscrpu = params.miscrpu 
		def entity = miscrpu.entity 

		def rputype = 'misc';

		if (entity.assessments == null) 
			entity.assessments = []
		
		def assessment = [
			objid  :  'BA' + new java.rmi.server.UID(),
			rpuid  : entity.objid, 
			rputype : rputype,
			classificationid : miscrpu.classificationid,
			classification   : entity.classification,
			actualuseid  : miscrpu.actualuseid,
			actualuse    : entity.actualuse,
			areasqm      : 0.0, 
			areaha       : 0.0,
			marketvalue  : miscrpu.marketvalue,
			assesslevel  : miscrpu.assesslevel,
			assessedvalue  : miscrpu.assessedvalue,
			taxable 		: true, 
		]
		
		def a = new RPUAssessment(assessment)
		a.assesslevel = miscrpu.assesslevel
		a.assessedvalue = miscrpu.assessedvalue
		entity.assessments << assessment
		request.assessments << a
		request.facts << a 
		drools.insert(a)
	}
}