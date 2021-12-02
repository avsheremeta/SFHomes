public class CreateContactController
{
    public Contact con {
        get{
            if (con == null)
                con = new Contact();
            return con;}
        set;}

    // crete new Contact and redirect to ViewDetailContactVF page    
   	public PageReference save() {
        try
        {
         	insert con;
        	PageReference secondPage = Page.ViewDetailContactVF;
        	secondPage.setRedirect(true);
        	secondPage.getParameters().put('id',con.id);
        	return secondPage;
        }
        catch(Exception e)
        { 
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Something wrong !'));  
            return null;
        }                 
    }
 
 	public PageReference cancel()
    {
        return Page.SignInContactVF;
    }
}