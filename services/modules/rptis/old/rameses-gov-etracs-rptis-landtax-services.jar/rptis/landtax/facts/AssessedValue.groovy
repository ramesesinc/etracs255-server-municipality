package rptis.landtax.facts;

public class AssessedValue
{
    String objid
    Classification classification 
    Classification actualuse 
    String rputype
    String txntype 
    Integer year
    Double av
    Double basicav
    Double sefav
    Boolean taxdifference 
    Boolean idleland  

    public AssessedValue(){}

    public AssessedValue(item, classification, actualuse){
        this.objid = item.objid
        this.classification = classification
        this.actualuse = actualuse
        this.rputype = item.rputype 
        this.txntype = item.txntype 
        this.year = item.year
        this.av = item.av
        this.basicav = item.basicav
        this.sefav = item.sefav
        this.taxdifference = (item.taxdifference ? item.taxdifference : false)
        this.idleland = (item.idleland ? item.idleland : false)
    }
}
