// pageStateChangeExample.js
import { LightningElement, wire, api } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';

export default class PageStateChangeExample extends NavigationMixin(LightningElement) {
    // Declare the currentPageReference variable in order to track it
    currentPageReference;
    @api tabName = 'lightning_components';
    @api label = 'Next';
    // Injects the page reference that describes the current page
    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.currentPageReference = currentPageReference;

        if (this.connected) {
            // We need to have the currentPageReference, and to be connected before
            // we can use NavigationMixin
            this.generateUrls();
        } else {
            // NavigationMixin doesn't work before connectedCallback, so if we have 
            // the currentPageReference, but haven't connected yet, queue it up
            this.generateUrlOnConnected = true;
        }
    }

    showPanelUrl;
    noPanelUrl;

    // Determines the display for the component's panel
    get showPanel() {
        // Derive this property's value from the current page state
        return this.currentPageReference &&
            this.currentPageReference.state.c__showPanel == 'true';
    }

    generateUrls() {
        this[NavigationMixin.GenerateUrl](this.showPanelPageReference)
            .then(url => this.showPanelUrl = url);
        this[NavigationMixin.GenerateUrl](this.noPanelPageReference)
            .then(url => this.noPanelUrl = url);
    }

    // Returns a page reference that matches the current page
    // but sets the 'c__showPanel' page state property to 'true'
    get showPanelPageReference() {
        return this.getUpdatedPageReference({
            c__showPanel: 'true' // Value must be a string
        });
    }

    // Returns a page reference that matches the current page
    // but removes the 'c__showPanel' page state property
    get noPanelPageReference() {
        return this.getUpdatedPageReference({
            // Removes this property from the state
            c__showPanel: undefined
        });
    }

    // Utility function that returns a copy of the current page reference
    // after applying the stateChanges to the state on the new copy
    getUpdatedPageReference(stateChanges) {
        // The currentPageReference property is read-only.
        // To navigate to the same page with a modified state,
        // copy the currentPageReference and modify the copy.
        return Object.assign({}, this.currentPageReference, {
            // Copy the existing page state to preserve other parameters
            // If any property on stateChanges is present but has an undefined
            // value, that property in the page state is removed.
            state: Object.assign({}, this.currentPageReference.state, stateChanges)
        });
    }

    connectedCallback() {
        this.connected = true;
        
        // If the CurrentPageReference returned before this component was connected,
        // we can use NavigationMixin to generate the URLs
        if (this.generateUrlOnConnected) {
            this.generateUrls();
        }
    }

    handleShowPanelClick(evt) {
        evt.preventDefault();
        evt.stopPropagation();
        // This example passes true to the 'replace' argument on the navigate API
        // to change the page state without pushing a new history entry onto the
        // browser history stack. This prevents the user from having to press back
        // twice to return to the previous page.
        this[NavigationMixin.Navigate](this.showPanelPageReference, true);
    }

    handleNoPanelClick(evt) {
        evt.preventDefault();
        evt.stopPropagation();
        this[NavigationMixin.Navigate](this.noPanelPageReference, true);
    }

    navigateNext() {
        /*this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: this.tabName,
            }
        });*/
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'home'
            }
        });
    }

    navigateToListView() {
        // Navigate to the Contact object's Recent list view.
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'list'
            },
            state: {
                // 'filterName' is a property on the page 'state'
                // and identifies the target list view.
                // It may also be an 18 character list view id.
                filterName: 'Recent' // or by 18 char '00BT0000002TONQMA4'
            }
        });
    }

    navigateToNewRecordPage() {
        // Opens the new Account record modal
        // to create an Account.
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'new'
            }
        });
    }

    navigateToRecordViewPage() {
        // View a custom object record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: '5000o00002LLttsAAD',
               // objectApiName: 'namespace__ObjectName', // objectApiName is optional
                actionName: 'view'
            }
        });
    }

    navigateToRecordEditPage() {
        // Opens the Account record modal
        // to view a particular record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: '0010o00002b8ZXPAA2',
                objectApiName: 'Account', // objectApiName is optional
                actionName: 'edit'
            }
        });
    }

    navigateToRelatedList() {
        // Navigate to the CaseComments related list page
        // for a specific Case record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordRelationshipPage',
            attributes: {
                recordId: '500xx000000Ykt4AAC',
                objectApiName: 'Case',
                relationshipApiName: 'CaseComments',
                actionName: 'view'
            }
        });
    }

    navigateToWebPage() {
        // Navigate to a URL
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://mylti.lntinfotech.com'
            }
        },
        true // Replaces the current page in your browser history with the URL
      );
    }

    navigateToTabPage() {
        // Navigate to a specific CustomTab.
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                // CustomTabs from managed packages are identified by their
                // namespace prefix followed by two underscores followed by the
                // developer name. E.g. 'namespace__TabName'
                apiName: 'testapppage'
            }
        });
    }



}