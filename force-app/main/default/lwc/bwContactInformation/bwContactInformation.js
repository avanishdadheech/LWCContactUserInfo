import { LightningElement, wire, api} from 'lwc'; 
import getUserInfo from '@salesforce/apex/BW_UserInformation.getUserInfo';

export default class BwContactInformation extends LightningElement {
    @api recordId;
    records;
    errflag = false;
    message;

   /* Lightning record page sets recordId to the 18-character ID of the record. 
      wire method calls the apex method as soon as component is loaded. It takes 
      recordId as paramete and receives error and data as response. In data we 
      get an object wrapper class which have 3 elements, a list, a message and 
      and errorflag. In htms file conditional rendering display either error
      message or data based on errorflag value true or false */

    @wire(getUserInfo, {recordId: '$recordId'})
    wiredUserInfo({ error, data }) {
        if (data) {
            this.records = data.wcListObj;
            this.message = data.Message;
            this.errflag = data.ErrorFlag;
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    }

}