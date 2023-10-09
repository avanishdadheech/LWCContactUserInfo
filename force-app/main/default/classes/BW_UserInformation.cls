/*************************************************************************************************
* @File Name            : BW_UserInformation.clx
* @Description          : Apex class to fetch user details based on email of contact recordID
*                         passed as parameter. Incase email of contact is blank or no matching user 
                          record found it will return messages accordingly along with ErrorFlag
* Change History        :
* 
*   DATE            AUTHOR                      Change Description
* ---------    -----------------   -------------------------------------------------------------
* 07-Oct-23    Avanish D           Initial version
* **********************************************************************************************/
public without sharing class BW_UserInformation {
    /* Main wrapper class object to return to calling environment */ 
    public static WrapperClass wc = new WrapperClass();
    
    /* This method get for contact record and check its email (if blank then it assigns 
       error message from Custom Label), if email is not blank then 
       it search for user records matching that email and add all user records to wrapper
       object list. If no user record found it assigns error message from Custom Label*/
    
    @AuraEnabled(cacheable = true)
    public static WrapperClass getUserInfo(Id recordId) {
     
        String ReturnMessage = 'OK';
        wc.Message   = ReturnMessage;
        wc.ErrorFlag = false;
        wc.wcListObj = new List<WrapperClassObject>();
        
        Contact c = [Select Id, email from Contact where Id=:recordId];
        
        if (String.isBlank(c.email)){
            ReturnMessage = 
            wc.Message   = System.Label.bwLabelEmailBlank ;  
            wc.ErrorFlag = true;
        }
        else{
            for (User u: [SELECT ID, Name, Profile.name,UserRole.name, email FROM User WHERE email = :c.email ]){
                WrapperClassObject wco = new WrapperClassObject (u.ID, u.Name, u.Profile.name, u.UserRole.name, u.email);   
                wc.wcListObj.add(wco);
            }

              if (wc.wcListObj.isEmpty()){
                wc.Message   = System.Label.bwLabelUserNotPresentWithEmail+ c.email;
                wc.ErrorFlag = true;
            }           
        }         
     return  wc;
    }
    
     public class WrapperClass {
          @AuraEnabled
          public List<WrapperClassObject> wcListObj;
          @AuraEnabled
          public String Message;
          @AuraEnabled
          public Boolean ErrorFlag;
         
     }
    public class WrapperClassObject {
        @AuraEnabled
        public String UserId;
        @AuraEnabled
        public String UserName;
        @AuraEnabled
        public String UserProfile;
        @AuraEnabled
        public String UserRole;
        @AuraEnabled
        public String UserEmail;
        
        public WrapperClassObject(String UId,String UName,String UProfile,String URole,String UEmail){
            this.UserId      = UId;
            this.UserName    = UName;
            this.UserProfile = UProfile;
            this.UserRole    = URole;
            this.UserEmail   = UEmail;
        }
    }
}