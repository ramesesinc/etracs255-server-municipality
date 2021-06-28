package rptis.propertyauction.facts;

public class Notice 
{
    String step
    Integer fromyear
    Integer toyear
    Double amtdue
    Double totalav
    Double totalmv
    Double costofsale
    
    //data reference
    def entity    

    public Notice(){}

    public Notice(entity){
        setEntity(entity)
        setStep(entity.step.objid)
        setFromyear(entity.fromyear)
        setToyear(entity.toyear)
        setAmtdue(entity.amtdue)
        setTotalav(entity.rptledger.totalav)
        setTotalmv(entity.rptledger.totalmv)
        setCostofsale(0.0)
    }

    public void setCostofsale(costofsale) {
        this.costofsale = costofsale
        entity.costofsale = costofsale
    }
}
