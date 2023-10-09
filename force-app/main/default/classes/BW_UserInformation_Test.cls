@iSTest
public class BW_UserInformation_Test {
    //below test setup method will be invoked
    // implicitly before every test methods and setup data for Contact and User
    @testsetup
    static void createContactUser(){
        List<Contact> lstContact = new List<Contact>();   
        
        lstContact.add(new Contact(lastName = 'emailblank'      , email = ''));
        lstContact.add(new Contact(lastName = 'emailwithUser'   , email = 'TestwithUser@test.com'));
        lstContact.add(new Contact(lastName = 'emailwithnoUser' , email = 'TestwithNoUser@test.com'));
        
        insert lstContact;
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'emailwithUser', 
                         lastName = 'User', 
                         email = 'TestwithUser@test.com', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'Europe/London', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        insert uu;       
        
    }
    
    
    //This Test method will validate the call for the method BW_UserInformation.getUserInfo with contact
    //having blank email 
    public static testMethod void testUserInfoEmailNull(){
        Contact c = [SELECT Id, email FROM Contact Where lastName = 'emailblank' Limit 1];
        BW_UserInformation.WrapperClass wc = BW_UserInformation.getUserInfo(c.ID);
        System.assertEquals(System.Label.bwLabelEmailBlank,wc.Message );
    }
    
    //This Test method will validate the call for the method BW_UserInformation.getUserInfo with contact
    //having email linked to no user record
    public static testMethod void testUserInfoEmailWithNoUser(){    
        Contact c = [SELECT Id,email FROM Contact Where lastName = 'emailwithnoUser' Limit 1];
        BW_UserInformation.WrapperClass wc = BW_UserInformation.getUserInfo(c.ID);
        System.assertEquals(System.Label.bwLabelUserNotPresentWithEmail+ c.email,wc.Message);
    }
    
    //This Test method will validate the call for the method BW_UserInformation.getUserInfo with contact
    //having email linked to some user record
    public static testMethod void testUserInfoEmailWithUser(){ 
        Contact c = [SELECT Id,email FROM Contact Where lastName = 'emailwithUser' Limit 1];
        BW_UserInformation.WrapperClass wc = BW_UserInformation.getUserInfo(c.ID);
        System.assertEquals(1,wc.wcListObj.size() );
    }
}