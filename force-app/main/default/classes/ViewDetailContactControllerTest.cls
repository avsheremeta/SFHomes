@isTest
public class ViewDetailContactControllerTest {
    @testSetup
    static void setup()
    {
        //create one Contact
        Contact con = new Contact(FirstName='Test',LastName = 'Contact', Email='email@test.com', Password__c='123');
        insert con;
        
        //Create ten Houses
       	List<House__c> houses = new List<House__c>();
        for(Integer i=0;i<10;i++) {
            if(i<5){
                houses.add(new House__c(Name='TestHouse'+i, Type__c = 'Villa', Status__c = 'Available', Rooms__c = 1+i, Price__c = 250+i));
            }else{
                houses.add(new House__c(Name='TestHouse'+i,  Type__c = 'Cottage', Status__c = 'Booked', Rooms__c = 5+i, Price__c = 500+i));
            }
        }     	           
        insert houses; 
        
        //create one LinkedIn record
        LinkedinInfo__c li = new LinkedinInfo__c(Name = 'Auth_v2', AccessToken__c = 'rmv99943msfd;m42',
                                                 DateCreatedAccessToken__c = Date.newInstance(2021, 2, 25), URN_Person__c = 'dsar543');
        insert li;
    }
    
    @isTest
    static void getContactTest(){     
        ViewDetailContactController vdc = new ViewDetailContactController();
   		Contact con = [SELECT Id, FirstName, LastName, Email, Password__c FROM Contact];
        
        PageReference pageRef = Page.VFSecondPageContact;   
        pageRef.getParameters().put('id', con.Id); 
        		
        Test.startTest(); 
        Test.setCurrentPage(pageRef);
        vdc.getContact();
        Test.stopTest();
        
		Contact c = [SELECT Id, FirstName, LastName, Email, Password__c FROM Contact];  
        System.assertEquals(c.LastName, 'Contact');  
        System.assertEquals(c.Email, 'email@test.com');  
    }
    
    @isTest
    static void getHousesAllTest()
    {
        ViewDetailContactController vdc = new ViewDetailContactController();
        vdc.selectedHouseStatus = 'All';
        vdc.selectedHouseType = 'All';
        
        Test.startTest();
        vdc.getHouses();
        Test.stopTest();

        System.assertEquals(10, vdc.allHouses.size(), 'Was expecting to find ten houses');        
    }
    
    @isTest
    static void getHousesWithStatusTest()
    {
        ViewDetailContactController vdc = new ViewDetailContactController();
        vdc.selectedHouseStatus = 'Booked';
        vdc.selectedHouseType = 'All';
        
        Test.startTest();
        vdc.getHouses();
        Test.stopTest();

        System.assertEquals(5, vdc.allHouses.size(), 'Was expecting to find five houses');        
    }
    
    @isTest
    static void getHousesWithTypeTest()
    {
        ViewDetailContactController vdc = new ViewDetailContactController();
        vdc.selectedHouseStatus = 'All';
        vdc.selectedHouseType = 'Villa';
        
        Test.startTest();
        vdc.getHouses();
        Test.stopTest();

        System.assertEquals(5, vdc.allHouses.size(), 'Was expecting to find five houses');        
    }
    
    @isTest
    static void getHousesWithStatusAndTypeTest()
    {
        ViewDetailContactController vdc = new ViewDetailContactController();
        vdc.selectedHouseStatus = 'Booked';
        vdc.selectedHouseType = 'Cottage';
        
        Test.startTest();
        vdc.getHouses();
        Test.stopTest();

        System.assertEquals(5, vdc.allHouses.size(), 'Was expecting to find five houses');        
    }
    
    
    @isTest
    static void getHousesWithSortDESCTest()
    {
        ViewDetailContactController vdc = new ViewDetailContactController();
        vdc.selectedHouseStatus = 'All';
        vdc.selectedHouseType = 'All';
        vdc.sortOrder = 'Order by Name ASC';
        
        Test.startTest();
        vdc.sortMethod();
        vdc.getHouses();
        Test.stopTest();     
    }
    
    @isTest
    static void getHousesWithSortASCTest()
    {
        ViewDetailContactController vdc = new ViewDetailContactController();
        vdc.selectedHouseStatus = 'All';
        vdc.selectedHouseType = 'All';
        vdc.sortOrder = 'Order by Name DESC';
        
        Test.startTest();
        vdc.sortMethod();
        vdc.getHouses();
        Test.stopTest();     
    }
    
    @isTest
    static void assignToContactSeletedFalseTest()
    {
        ViewDetailContactController vdc = new ViewDetailContactController();
        vdc.selectedHouseStatus = 'All';
        vdc.selectedHouseType = 'All';
        House__c house = [select Name, Contact__c, Type__c, Status__c, Rooms__c, Price__c from House__c limit 1]; 
        
        Test.startTest();
        ViewDetailContactController.WrapperHouses wraphouse = new ViewDetailContactController.WrapperHouses(house);
        wraphouse.selected = false;
        vdc.assignToContact();
        Test.stopTest();  

        System.assert(wraphouse.house.Contact__c == null); 
    }
    
    @isTest
    static void assignToContactSelectedTrueTest()
    {
        Contact con = [SELECT Id FROM Contact];      
        House__c house = [select Name,Contact__c, Type__c, Status__c, Rooms__c, Price__c from House__c limit 1];  

        ViewDetailContactController vdc = new ViewDetailContactController();
        vdc.selectedHouseStatus = 'All';
        vdc.selectedHouseType = 'All';
                
     	PageReference pageRef = Page.VFSecondPageContact;
        pageRef.getParameters().put('id', con.Id);
               
        Test.startTest(); 
        Test.setCurrentPage(pageRef);
        
        ViewDetailContactController.WrapperHouses wraphouse = new ViewDetailContactController.WrapperHouses(house);
        wraphouse.selected = true;   
        vdc.allHouses.add(wraphouse);
        vdc.assignToContact();       
        Test.stopTest();  
        
        System.assertEquals(wraphouse.house.Contact__c,con.Id); 
    }
    
    @isTest
    static void assignToContactErrorTest()
    {
        ViewDetailContactController vdc = new ViewDetailContactController();
        vdc.selectedHouseStatus = 'All';
        vdc.selectedHouseType = 'All';
        House__c house = [select Name, Contact__c, Type__c, Status__c, Rooms__c, Price__c from House__c limit 1]; 
        delete house;
        
        Test.startTest();
        ViewDetailContactController.WrapperHouses wraphouse = new ViewDetailContactController.WrapperHouses(house);
        wraphouse.selected = false;
        vdc.assignToContact();
        Test.stopTest(); 
        
        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));
    }        
    
    @isTest
    static void getTypeItemsTest()
    {
        List<SelectOption> options;
        ViewDetailContactController vdc = new ViewDetailContactController();
        
        Test.startTest();
        options = vdc.getTypeItems();
        Test.stopTest();

        System.assertNotEquals(null, options );
        System.assertNotEquals(0, options.size());         
    }  
    
    @isTest
    static void getStatusItemsTest()
    {
        List<SelectOption> options;
        ViewDetailContactController vdc = new ViewDetailContactController();
        
        Test.startTest();
        options = vdc.getStatusItems();
        Test.stopTest();

        System.assertNotEquals(null, options );
        System.assertNotEquals(0, options.size());         
    }
    
	@isTest
    static void doExitTest(){
        ViewDetailContactController vdc = new ViewDetailContactController();
         
        Test.startTest();  
        vdc.doExit();        
        Test.stopTest();         
    }
    
    //LinkedIn integration tests
    @isTest
    static void connectLinkedInTest(){     
        ViewDetailContactController vdc = new ViewDetailContactController();
        Contact con = [SELECT Id FROM Contact]; 
        LinkedinInfo__c linkedln = [SELECT AccessToken__c, DateCreatedAccessToken__c, URN_Person__c FROM LinkedinInfo__c];
        String client_Id = '123';
        String linkedln_Scope = 'r_liteprofile%20r_emailaddress%20w_member_social';
        String linkedln_AuthUrl = 'https://www.linkedin.com/oauth/v2/authorization?';
        String redirect_URL = 'https://andriivsheremeta-developer-edition.eu40.force.com/viewdetailcontactvf?id='+con.Id;
                 
   		String request_AuthURL = linkedln_AuthUrl + 'response_type=code&client_id=' + client_Id + '&redirect_uri=' +
                                    redirect_URL + '&state=myState&scope=' + linkedln_Scope;
        
        PageReference pageRef = new PageReference(request_AuthURL);   
          		
        Test.startTest(); 
        Test.setCurrentPage(pageRef);
        vdc.connectLinkedIn();
        Test.stopTest();
    }
    
    @isTest 
	static void getAccessTokenMakeCalloutTest() {
        LinkedinInfo__c linkedln = [SELECT AccessToken__c, DateCreatedAccessToken__c FROM LinkedinInfo__c];
        linkedln.AccessToken__c = '';
        update linkedln;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new getAccessTocenCalloutMock()); 
        ViewDetailContactController vdc = new ViewDetailContactController();
        
        Test.startTest(); 
        vdc.getAccessTocen();
        Test.stopTest();
        
        LinkedinInfo__c linked_ln = [SELECT AccessToken__c, DateCreatedAccessToken__c FROM LinkedinInfo__c];
        System.assert(linked_ln.AccessToken__c !=null);
        System.assert(linked_ln.DateCreatedAccessToken__c == Date.today());      
	}
    
    @isTest 
	static void getAccessTokenNotMakeCalloutTest() {       
        Test.setMock(HttpCalloutMock.class, new getAccessTocenCalloutMock()); 
        ViewDetailContactController vdc = new ViewDetailContactController();
        
        Test.startTest(); 
        vdc.getAccessTocen();
        Test.stopTest();

        System.assert(ApexPages.getMessages().get(0).getDetail() == 'This information is already available');      
	}
    
    @isTest 
	static void getAccessTokenFailCalloutTest() {
        LinkedinInfo__c linkedln = [SELECT AccessToken__c, DateCreatedAccessToken__c FROM LinkedinInfo__c];
        linkedln.AccessToken__c = '';
        update linkedln;
        ViewDetailContactController vdc = new ViewDetailContactController();      
        Test.setMock(HttpCalloutMock.class, new PostFailureCalloutMock()); 
                
        Test.startTest(); 
        vdc.getAccessTocen();
        Test.stopTest(); 
        
        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR)); 
        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.INFO));          
	}
    
    @isTest 
	static void getAccessTokenExceptionTest() { 
        LinkedinInfo__c linkedln = [SELECT AccessToken__c, DateCreatedAccessToken__c FROM LinkedinInfo__c];
        linkedln.AccessToken__c = '';
        update linkedln;
        ViewDetailContactController vdc = new ViewDetailContactController();
        
        Test.startTest(); 
        vdc.getAccessTocen();
        Test.stopTest();

        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));    
	}
    
    @isTest 
	static void getLinkedInProfileInfoMakeCalloutTest() {
        LinkedinInfo__c linkedln = [SELECT DateCreatedAccessToken__c, URN_Person__c FROM LinkedinInfo__c];
        linkedln.URN_Person__c = '';
        update linkedln;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new getLinkedInProfileInfoCalloutMock()); 
        ViewDetailContactController vdc = new ViewDetailContactController();
        
        Test.startTest(); 
        vdc.getLinkedInProfileInfo();
        Test.stopTest();
        
        LinkedinInfo__c linked_ln = [SELECT URN_Person__c FROM LinkedinInfo__c];
        System.assert(linked_ln.URN_Person__c !=null);
        System.assert(linked_ln.URN_Person__c == 'qwert345');         
	}
    
    @isTest 
	static void getLinkedInProfileInfoNotMakeCalloutTest() {       
        Test.setMock(HttpCalloutMock.class, new getLinkedInProfileInfoCalloutMock()); 
        ViewDetailContactController vdc = new ViewDetailContactController();
        
        Test.startTest(); 
        vdc.getLinkedInProfileInfo();
        Test.stopTest();

        System.assert(ApexPages.getMessages().get(0).getDetail() == 'This information is already available');      
	}
    
    @isTest 
	static void getLinkedInProfileInfoFailCalloutTest() {
        LinkedinInfo__c linkedln = [SELECT DateCreatedAccessToken__c, URN_Person__c FROM LinkedinInfo__c];
        linkedln.URN_Person__c = '';
        update linkedln;
        ViewDetailContactController vdc = new ViewDetailContactController();      
        Test.setMock(HttpCalloutMock.class, new PostFailureCalloutMock()); 
                
        Test.startTest(); 
        vdc.getLinkedInProfileInfo();
        Test.stopTest();
        
        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));         
	}
    
    @isTest 
	static void getLinkedInProfileInfoExceptionTest() { 
        LinkedinInfo__c linkedln = [SELECT DateCreatedAccessToken__c, URN_Person__c FROM LinkedinInfo__c];
        linkedln.URN_Person__c = '';
        update linkedln;
        ViewDetailContactController vdc = new ViewDetailContactController();
        
        Test.startTest(); 
        vdc.getLinkedInProfileInfo();
        Test.stopTest();

        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));    
	}
    
    @isTest 
	static void makePostLinkedInMakeCalloutTest() {
        ViewDetailContactController vdc = new ViewDetailContactController();
        Test.setMock(HttpCalloutMock.class, new makePostLinkedInCalloutMock()); 
                
        Test.startTest(); 
        vdc.makePostLinkedIn();
        Test.stopTest();
        
       System.assert(ApexPages.getMessages().get(0).getDetail() == 'Post has been shared successfully!');         
	}
    
    @isTest 
	static void makePostLinkedInFailCalloutTest() {
        ViewDetailContactController vdc = new ViewDetailContactController();        
        Test.setMock(HttpCalloutMock.class, new PostFailureCalloutMock()); 
                
        Test.startTest(); 
        vdc.makePostLinkedIn();
        Test.stopTest();
        
        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));         
	}
    
    @isTest 
	static void makePostLinkedInExceptionCalloutTest() {
        ViewDetailContactController vdc = new ViewDetailContactController();
          
        Test.startTest(); 
        vdc.makePostLinkedIn();
        Test.stopTest();
        
       System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));          
	}
}