package rptis.propertyauction.facts;

public class AuctionedProperty 
{
    String state 
    Date auctiondate 
    Double amtdue
    Double amtduepaid
    Double bidamt
    Double costofsale 

    //data reference
    def entity    

    public AuctionedProperty(){}

    public AuctionedProperty(entity){
        setEntity(entity)
        setState(entity.state)
        setAuctiondate(entity.parent.auctiondate)
        setAmtdue(entity.amtdue)
        setAmtduepaid(entity.amtduepaid)
        setBidamt(entity.bidamt)
        setCostofsale(entity.notice.costofsale)
    }

}
