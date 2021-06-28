package rptis.propertyauction.facts;

public class Auction 
{
    String state 
    Date auctiondate 
    Double minincidental
    Double maxincidental

    //data reference
    def entity    

    public Auction(){}

    public Auction(entity){
        setEntity(entity)
        setState(entity.state)
        setAuctiondate(entity.auctiondate)
        setMinincidental(entity.minincidental)
        setMaxincidental(entity.maxincidental)
    }

}
