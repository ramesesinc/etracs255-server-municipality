package rptis.landtax.facts;

public class Classification 
{
    String objid
    String code 
    String name  

    public Classification(){}

    public Classification(classification){
        this.objid = classification?.objid
        this.code = classification?.code
        this.name = classification?.name
    }

    public def toMap(){
        return [
            objid: objid,
            code: code,
            name: name,
        ]
    }
}
