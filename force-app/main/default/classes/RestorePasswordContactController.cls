public class RestorePasswordContactController
{
    public string contactEmail{get; set;}
     
    // create and send email to Contact with his password
    public PageReference send()
    {
        string query = 'SELECT Id, FirstName, LastName, Password__c FROM Contact ';
       
        try
        {     
            Contact contact = Database.query(query + 'WHERE Email =: contactEmail'); 
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
            String[] toAddresses = new String[]{contactEmail};
            mail.setToAddresses(toAddresses);      
            mail.setBccSender(false);
            mail.setSubject('We have sent you your password');
            //mail.setPlainTextBody('Your password is:' + contact.Password__c );
			mail.setHtmlBody('Hello, '+ contact.FirstName+' ' + contact.LastName + '!<br/>' + 'Your password is:' + '<strong>' + contact.Password__c + '</strong>');
           
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        
            if ( r[0].isSuccess () )
            {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Email Sent Successfully !')); 
            }
            else
            {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Something wrong! Email was not sent! ')); 
                return null;
            }    
        	return null;
        }
        catch(Exception e){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Email not found!' +e));  
            return null;
        }       
    }
    
	public PageReference cancel()
    {
        return Page.SignInContactVF;
    }
}