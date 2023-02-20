({
    getCitiesHelper : function(component, event, helper){
        var params = {
            "input": component.get('v.location')
        }
        this.callServer(component, "c.getSuggestions", function(response) {
            var resp = JSON.parse(response);
            component.set('v.predictions', resp.predictions);
        }, params);
        
    },
    
    getCityDetailsHelper : function (component, event, helper) {
        debugger;
        var selectedItem = event.currentTarget;
        var placeid = selectedItem.dataset.placeid;
        
        var params = {
            "placeId": placeid
        }
        
        this.callServer(component, "c.getPlaceDetails", function(response) {
            debugger;
            var placeDetails = JSON.parse(response);
            console.log('placeDetails : ' +placeDetails);
            
            var streetConcatinate = '';
            
            for (var i = 0; i < placeDetails.result.address_components.length; i++) {
                console.log('JSON Response****');
                console.log(placeDetails.result.address_components[i].types[0]);
                
                if (placeDetails.result.address_components[i].types[0] == "street_number") {
                    streetConcatinate += ' ' + placeDetails.result.address_components[i].long_name;
                    console.log(streetConcatinate);
                }
                if (placeDetails.result.address_components[i].types[0] == "route") {
                    streetConcatinate += ' ' + placeDetails.result.address_components[i].long_name;
                    console.log(streetConcatinate);
                }
                
                if (placeDetails.result.address_components[i].types[0] == "locality") {
                    component.set("v.city", placeDetails.result.address_components[i].long_name);
                }
                if (placeDetails.result.address_components[i].types[0] == "administrative_area_level_1") {
                    component.set("v.state", placeDetails.result.address_components[i].long_name);
                }
                if (placeDetails.result.address_components[i].types[0] == "country") {
                    component.set("v.country", placeDetails.result.address_components[i].long_name);
                }
                if (placeDetails.result.address_components[i].types[0] == "postal_code") {
                    component.set("v.postalCode", placeDetails.result.address_components[i].long_name);
                }
            }
            console.log('*********streetConcatinate***');
            console.log(streetConcatinate);
            component.set('v.area', placeDetails.result.name + ', ' + streetConcatinate);
            if (streetConcatinate != null) {
                component.set("v.street", streetConcatinate);
            }
            
            var selectedAddress = component.get('v.area') + ' ' + 
                component.get('v.city') + ' '  + 
                component.get('v.state') + ' ' + 
                component.get('v.country') + ' ' + 
                component.get('v.postalCode');
            console.log('selectedAddress : ' + selectedAddress);
            component.set('v.location' , selectedAddress);          
            component.set('v.predictions', []);
            
        }, params);
    },
    
    callServer: function(component, method, callback, params) {
        var action = component.get(method);
        if (params) {
            action.setParams(params);
        }
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // pass returned value to callback function
                callback.call(this, response.getReturnValue());
            } else if (state === "ERROR") {
                // generic error handler
                var errors = response.getError();
                if (errors) {
                    console.log("Errors", errors);
                    if (errors[0] && errors[0].message) {
                        throw new Error("Error" + errors[0].message);
                    }
                } else {
                    throw new Error("Unknown Error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
})