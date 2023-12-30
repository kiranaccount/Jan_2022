import { LightningElement,api } from 'lwc';
export default class JsCertificationCmp extends LightningElement {
    stickyMargin;
    siteURL;
    @api recordId;
   // contentPadding = 'padding-top:30px';
     contentPadding = 'padding-top:80px';
  renderedCallback() {
      // this.siteURL = '/apex/Example?recId=' + this.recordId;
        this.siteURL = '/apex/FamilyTreeExample2?';
        try {
            window.onscroll = () => {
                let stickysection = this.template.querySelector('.myStickyHeader');
                let sticky2 = stickysection.offsetTop;
 
                if (window.pageYOffset > sticky2) {
                  //  stickysection.classList.add("slds-is-fixed");
                   // this.stickyMargin = 'margin-top:90px';
                   // this.contentPadding = 'padding-top:102px'
                   // this.stickyMargin = 'margin-top:50px';
                   // this.contentPadding = 'padding-top:50px'


                   // style="overflow: auto; position: fixed; top: 0; left: 0; right: 0; bottom: 0;

                } else {
                    //stickysection.classList.remove("slds-is-fixed");
                    //this.stickyMargin = '';
                   // this.contentPadding = 'padding-top:10px'
                    //this.stickyMargin = 'margin-top:50px';
                    // this.contentPadding = 'padding-top:50px'
                }
            }
        } catch (error) {
            console.log('error =>', error);
        }
    }

}