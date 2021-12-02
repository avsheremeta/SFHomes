public class ViewDetailContactController
{
    Contact contact;
    public string sortOrder;

    public  Id contactId {
        get{contactId = ApexPages.currentPage().getParameters().get('id');
            return contactId;}
        set;}
    
    public string selectedHouseType {get; set;} //Type picklist value from House object 
    public string selectedHouseStatus {get; set;} //Status picklist value from House object 
    public List<WrapperHouses> allHouses {get; set;}

    //for integration with LinkedIn
    public String client_Id = LinkedInTokens__c.getInstance().ClientID__c; //stored in custom settings
    public String client_Secret = LinkedInTokens__c.getInstance().ClientSecret__c; //stored in custom settings
    public String redirect_URL = 'https://andriivsheremeta-developer-edition.eu40.force.com/viewdetailcontactvf?id='+contactId;
    public String linkedln_Scope = 'r_liteprofile%20r_emailaddress%20w_member_social';
    public String linkedln_AuthUrl = 'https://www.linkedin.com/oauth/v2/authorization?';
    public String accessToken_Endpoint = 'https://www.linkedin.com/oauth/v2/accessToken?';
    // custom Object linkedln_info
    LinkedinInfo__c linkedln_info = Database.query('SELECT AccessToken__c, DateCreatedAccessToken__c, URN_Person__c FROM LinkedinInfo__c'); 
       
    public ViewDetailContactController(){      
        selectedHouseType = 'All';
        selectedHouseStatus = 'All';
        sortOrder = 'Order by Name ASC';
        getHouses();         
    }
    
    //wrapper class for Houses
    public class WrapperHouses {
        public House__c house {get; set;}
        public Boolean selected {get; set;} 
        
        public WrapperHouses(House__c h) {
            house = h;
            if(h.Contact__c == null){
               selected = false;
            }else{ selected = true; }           
        }       
    } 
        
   //get list of paticular Contact's homes according to the selected filter
   public void getHouses() {     
        string query = 'select id, Contact__c, Name, Type__c, Status__c, Rooms__c, Price__c from House__c ' +
            			'WHERE (Contact__c = :contactId OR Contact__c = null) ';  
       
        allHouses = new List<WrapperHouses>();
       
        if(selectedHouseType != 'All' && selectedHouseStatus == 'All'){                
            for (House__c h : Database.query(query + 'AND Type__c =:selectedHouseType ' + sortOrder)) {           
                allHouses.add(new WrapperHouses(h));}           
        }else if(selectedHouseType == 'All' && selectedHouseStatus != 'All'){
            for (House__c h : Database.query(query + 'AND Status__c =:selectedHouseStatus ' + sortOrder)) {          
                allHouses.add(new WrapperHouses(h));}   
        }else if(selectedHouseType != 'All' && selectedHouseStatus != 'All'){
            for (House__c h : Database.query(query + 'AND Type__c =:selectedHouseType and Status__c =:selectedHouseStatus ' + sortOrder)) {           
                allHouses.add(new WrapperHouses(h));}
        }else{
            for (House__c h : Database.query(query + sortOrder)) {           
                allHouses.add(new WrapperHouses(h));}
        }           
    }    
    
    //sorting Houses by Name
	public void sortMethod(){
		if(sortOrder == 'Order by Name ASC'){
          sortOrder = 'Order by Name DESC';
      	}else{
          sortOrder = 'Order by Name ASC';
      	}
     	getHouses();
    }
    
    //retrive paticular Contact info
    public Contact getContact(){
        string query = 'SELECT id, FirstName, LastName, Email, Password__c, AccountId, Phone,'+
            		' MailingStreet,Description, MailingCity, MailingCountry FROM Contact WHERE id = :contactId';
        if(contact == null) 
            contact = Database.query(query);         
        return contact; 
    } 
       
    //retrive list types of house
    public List<SelectOption> getTypeItems(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = House__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pe: ple){
            options.add(new SelectOption(pe.getLabel(), pe.getValue()));
        }
        return options;
    }
    
    //retrive list status of house
    public List<SelectOption> getStatusItems(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = House__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pe: ple){
            options.add(new SelectOption(pe.getLabel(), pe.getValue()));
        }
        return options;
    }
              
    //assign house to Contact
    public PageReference assignToContact(){            
        List<House__c> selectedHouses = new List<House__c>();
    	for (WrapperHouses wh : allHouses ){            
   			if(wh.selected == true && wh.house.Contact__c == null){
    			wh.house.Contact__c = contactId;
                selectedHouses.add(wh.house);
            }
            if(wh.selected == false && wh.house.Contact__c == contactId){
    			wh.house.Contact__c = null;
                selectedHouses.add(wh.house); 
            }  		
        }
        
        try{
            update selectedHouses;
        	ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Assign Successfully!'));
        	return null; 
        }
       	catch(Exception e){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Reccord was not assigned' +e));  
            return null;
        } 
	}

    // perform authorization to obtain an authorization code 
    public PageReference connectLinkedIn(){
        String request_AuthURL = linkedln_AuthUrl + 'response_type=code&client_id=' + client_Id + '&redirect_uri=' +
                                    redirect_URL + '&state=myState&scope=' + linkedln_Scope;
        PageReference pageRef = new PageReference(request_AuthURL);
        return pageRef;
    }

    // get acces_tocen
    public void getAccessTocen(){  
        //Access token is valid for 60 days. Check if you need to update it.
        // addDays(58) - February in a leap year (28days) + normal month (30days)
        if (linkedln_info.AccessToken__c == null || linkedln_info.DateCreatedAccessToken__c.addDays(58)== Date.today()){       
            string authCodeFromURL = ApexPages.currentPage().getParameters().get('code');//store the authentication code to get the access token 
            String requestTokenBody = 'grant_type=authorization_code&code='+authCodeFromURL+
                                    '&redirect_uri='+redirect_URL+'&client_id='+client_Id+
                                    '&client_secret='+client_Secret; 

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(accessToken_Endpoint+requestTokenBody);
            request.setMethod('GET');

            try{
                HttpResponse response = http.send(request);
                // If the request is successful, parse the JSON response.
                if(response.getStatusCode() == 200) {
                    // Deserialize the JSON string into collections
                    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                    linkedln_info.AccessToken__c = String.valueOf(results.get('access_token'));
                    linkedln_info.DateCreatedAccessToken__c = Date.today();
                    upsert linkedln_info;
                    ApexPages.Addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Acces Token retrived successfully!!'));
                }else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'access code not received '+response.getBody()));
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please click the button  "Connect LinkedIn" and try again')); 
                }
            }catch(System.Exception e){                 
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Bed response' +e));              
            } 
        }else{
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This information is already available'));  
        }
    }

    // get URN code 
    public void getLinkedInProfileInfo(){        
        if (linkedln_info.URN_Person__c == null){  
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.linkedin.com/v2/me');
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer '+linkedln_info.AccessToken__c);
            try{
                HttpResponse response = http.send(request);
                if(response.getStatusCode() == 200) {
                    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    linkedln_info.URN_Person__c = String.valueOf(results.get('id'));
                    upsert linkedln_info;                 
                    ApexPages.Addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Profile Information retrived successfully!!'));
                }else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Can not retrive profile information '+response.getBody()));
                }
            }catch(System.Exception e){                 
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Bed response' +e));              
            } 
        }else{
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This information is already available'));  
        }
    }

    //share post to LinkedIn
    public void makePostLinkedIn(){          
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.linkedin.com/v2/shares');   
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer '+linkedln_info.AccessToken__c);
        request.setHeader('X-RestLi-Protocol-Version', '2.0.0 ');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        String requestBody ='{ "content": { ' +
                            ' "contentEntities": [ ' +
                                ' {  "entityLocation": "https://andriivsheremeta-developer-edition.eu40.force.com/viewdetailcontactvf?id=' + contactId + ' " }], ' +
                                ' "title": "Click on the link and Learn more " }, ' +
                            ' "distribution": { "linkedInDistributionTarget": {} }, ' +
                            ' "owner": "urn:li:person:'+ linkedln_info.URN_Person__c + '", ' +
                            ' "subject": "Test Share", ' +
                            ' "text": { "text": "See Contact detail" }}';

        request.setBody(requestBody);
        try{
            HttpResponse response = http.send(request);  
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){  
                ApexPages.Addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Post has been shared successfully!'));           
            }else{
                string errorMessage = 'Unexpected Error while communicating with LinkedIn API. ' +
                                    'Status '+response.getStatus()+' and Status Code '+response.getStatuscode();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, errorMessage));
            }
        }catch(System.Exception e){                 
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Bed response' +e));              
        }      
    } 
        
    //back to the SignInContactVF page
    public PageReference doExit(){
        PageReference firstPage = Page.SignInContactVF;
        firstPage.setRedirect(true);
        return firstPage;
    }    
}