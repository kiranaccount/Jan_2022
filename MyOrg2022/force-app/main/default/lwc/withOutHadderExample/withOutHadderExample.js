import { LightningElement,api,track ,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import D3 from '@salesforce/resourceUrl/d3';
import { CurrentPageReference } from 'lightning/navigation';
export default class WithOutHadderExample extends LightningElement {
    @api showvalues;
    /*@api invoke() {
    console.log("Hi, I'm an action.");
    this.showvalues = 'wellcome hedderless';
    alert('wellcome hedderless');
  }
*/
  
    svgWidth = 1350;
    svgHeight = 800;
    @api recordId;
    @api error;
    /**
     * Dummy Data Fillers*/     
    

    d3Initialized = false;

     @api invoke(){
        if (this.d3Initialized) {
            return;
        }
        this.d3Initialized = true;

        Promise.all([
            loadScript(this, D3 + '/d3.v5.min.js'),           
        ])
            .then(() => {
                this.initializeD3();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading D3',
                        message: error.message,
                        variant: 'error'
                    })                    
                );
                Console.log('loadScript---->'+error);
            });
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) { 
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;       
            this.agentsPortal =true;
            console.log('wire---->'+this.recordId);
        } 

    }

    initializeD3() {
        // Example adopted from https://bl.ocks.org/mbostock/2675ff61ea5e063ede2b5d63c08020c7

        var data = [{"parent":"","MasterProjectName":"test cockpit view m - Sinking Ship","masterprojectId":"","child":"aHh6t0000004c4YCAQ"},{"parent":"aHh6t0000004c4YCAQ","MasterProjectName":"test cockpit view m - Sinking Ship","masterprojectId":"","child":"0066t000003914dAAA"},{"parent":"0066t000003914dAAA","MasterProjectName":"test cockpit view m child - Sinking Ship","masterprojectId":"","child":"0066t00000391NLAAY"},{"parent":"0066t000003914dAAA","MasterProjectName":"test cockpit view child 1.1 - Sinking Ship","masterprojectId":"","child":"0066t0000039EU9AAM"},{"parent":"0066t00000391NLAAY","MasterProjectName":"cockpit2 - Sinking Ship","masterprojectId":"","child":"0066t0000039EFwAAM"},{"parent":"0066t00000391NLAAY","MasterProjectName":"cockpit2 - Sinking Ship","masterprojectId":"","child":"0066t0000039EFwAAM"}]
       /*

       
        var data = {"name":"1", 
                    "children":[
                        {"name":"1.1", 
                         "children":[{"name":"1.1.1"},
                                     {"name":"1.1.2"},
                                     {"name":"1.1.3"}]},
                        {"name":"1.2",
                        "children":[{"name":"1.2.1"},
                                     {"name":"1.2.2"}
                                     ]}]}; 
									 
	  var data = [
                    {"child":"masterproject","parent":"","MasterProjectName":"Master project"},
                    {"child":"opty 1", "parent":"masterproject","MasterProjectName":"parent opty"},
                    {"child":"opty 2", "parent":"opty 1","MasterProjectName":"opty 1.1"},
                    {"child":"opty 3", "parent":"opty 2","MasterProjectName":"opty 1.2"},
                    {"child":"opty 4", "parent":"opty 2","MasterProjectName":"opty 1.2.1"},
                    {"child":"opty 5", "parent":"opty 3","MasterProjectName":"opty 1.3"},
                    {"child":"opty 6", "parent":"opty 3","MasterProjectName":"opty 1.3"},
                    {"child":"opty 7", "parent":"opty 3","MasterProjectName":"opty 1.3"}
                ]	*/
                                                              
       

const svg = d3.select(this.template.querySelector('svg.d3'))
    .attr("width",900).attr("height",600)
    .append("g").attr("transform", "translate(-120,50)");
    var data = [{"parent":"","MasterProjectName":"test cockpit view m - Sinking Ship","masterprojectId":"","child":"aHh6t0000004c4YCAQ"},{"parent":"aHh6t0000004c4YCAQ","MasterProjectName":"test cockpit view m - Sinking Ship","masterprojectId":"","child":"0066t000003914dAAA"},{"parent":"0066t000003914dAAA","MasterProjectName":"test cockpit view m child - Sinking Ship","masterprojectId":"","child":"0066t00000391NLAAY"},{"parent":"0066t000003914dAAA","MasterProjectName":"test cockpit view child 1.1 - Sinking Ship","masterprojectId":"","child":"0066t0000039EU9AAM"},{"parent":"0066t00000391NLAAY","MasterProjectName":"cockpit2 - Sinking Ship","masterprojectId":"","child":"0066t0000039EFwAAM"},{"parent":"0066t00000391NLAAY","MasterProjectName":"cockpit2 - Sinking Ship","masterprojectId":"","child":"0066t0000039EFwAAM"}]

	// var dataStructure = d3.hierarchy(data3);			   
    var dataStructure = d3.stratify()
                            .id(function(d){return d.child;})
                            .parentId(function(d){return d.parent;})(data);
                            
    //var treeStructure = d3.tree().size([1200,200]);
    var treeStructure = d3.tree().size([800,200]);
    
    var information = treeStructure(dataStructure);
   
         
    var connections1 = svg.append("g").selectAll("path")
                        .data(information.links());	
   // connections1.exit().remove();							
    connections1.enter().append("path")
        .attr("d", function(d){
            return "M" + (d.source.x-20) + "," + d.source.y + "h 20 v 40 H" + d.target.x + " V" + d.target.y;				
    }); 
    
     console.log(information.links());        
    var rectangles = svg.append("g").selectAll("rect")
                    .data(information.descendants());        					
    rectangles.enter().append("rect")
        .attr("x", function(d){return d.x-90;})
        .attr("y", function(d){return d.y-20;}); 		
    
  /*  var names = svg.append("g").selectAll("text")
                    .data(information.descendants());
    names.enter().append("text")
                .text(function(d){return d.data.child;})
                .attr("x", function(d){return d.x-20;})
                .attr("y", function(d){return d.y;})
                .classed("bigger", true); */
                
    
      var names = svg.append("g").selectAll("text")
                    .data(information.descendants());
      names.enter().append("text")
                .text(function(d){return d.data.MasterProjectName;})
                .attr("x", function(d){return d.x-1;})
                .attr("y", function(d){return d.y;})
                .classed("bigger", true); 		
                
                
    
   var spouseNames = svg.append("g").selectAll("text")
                        .data(information.descendants());
   spouseNames.enter().append("text")
                .text(function(d){return d.data.spouse;})
                .attr("x", function(d){return d.x+100;})
                .attr("y", function(d){return d.y})
                .classed("bigger", true);
  


}

}