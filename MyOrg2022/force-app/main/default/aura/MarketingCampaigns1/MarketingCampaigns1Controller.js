({
	myAction : function(component, event, helper) {
		var action = event.getParams().changeType;
        
	},    
    /*doCancel: function(component, event) {
        var retValue = component.get('v.OpportunityID');
        if(window.opener == null){
           href = "https://ap1.salesforce.com/006/o"
        }else{
            window.close();
        }
    } */
    
     handleNavigationComplete : function(component, event, helper) {
        var canGoBack = event.getParam("canGoBack");
        // take any other action based on if back navigation is possible or not
    }
  
})