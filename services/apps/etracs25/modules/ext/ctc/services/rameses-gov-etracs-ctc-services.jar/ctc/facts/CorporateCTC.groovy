package ctc.facts;

public class CorporateCTC {
    
    String orgtype;    
    double realpropertyav;    
    double businessgross;   
    boolean newbusiness;  
    boolean additional;    
    double basictax = 0;       
    double businessgrosstax = 0;      
    double propertyavtax = 0;     
    double additionaltax = 0;    
    double interest = 0;

    public CorporateCTC( def m ) {
        if(m.orgtype!=null) orgtype = m.orgtype;
        if(m.realpropertyav!=null) realpropertyav = m.realpropertyav;
        if(m.businessgross!=null) businessgross = m.businessgross;
        if(m.newbusiness!=null) newbusiness = m.newbusiness;
        if(m.additional!=null) additional = m.additional;
    }

    public double getTotaltax() {
        return basictax + businessgrosstax + propertyavtax + additionaltax; 
    }

    public double getAmountdue() {
        return getTotaltax();
    }

    public double getAmount() {
        return amountdue + interest;
    }

    public def toMap() {
        def m = [:];
        m.basictax = basictax;
        m.businessgrosstax = businessgrosstax;
        m.propertyavtax = propertyavtax;
        m.additionaltax = additionaltax;
        m.totaltax = totaltax;
        m.interest = interest;
        m.amountdue = amountdue;
        m.amount = amount;
        return m;
    }

} 
