public class SignInContactController 
{
    public Contact con {get; set;}
    public string contactEmail{get; set;}
    public string contactPassword{get; set;}
    
    // find a contact and go to his detail  page (ViewDetailContactVF)
    public PageReference doEnter()
    {
        string query = 'SELECT Id, FirstName, LastName, Email, Password__c FROM Contact ';
        
        try
        {
            con = Database.query(query + 'WHERE Email =: contactEmail and Password__c =: contactPassword');  
            PageReference secondPage = Page.ViewDetailContactVF;
            secondPage.setRedirect(true);
            secondPage.getParameters().put('id',con.id);
            return secondPage;
        }        
        catch(Exception e)
        { 
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contact not found!'));  
            return null;
        }        
    }   
    
    // redirect to the CreateContactVF page
    public PageReference addContact()
    {
        PageReference createContactPage = Page.CreateContactVF;
        createContactPage.setRedirect(true);
        return createContactPage;
    }
    
    //redirect to the password recovery page
    public PageReference restorePaswword()
    {
        return Page.RestorePasswordContactVF;
    }
}