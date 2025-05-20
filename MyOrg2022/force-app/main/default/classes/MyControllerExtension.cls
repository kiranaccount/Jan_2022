public class MyControllerExtension {
    private ApexPages.StandardSetController setcontroller;
    
    public MyControllerExtension(ApexPages.StandardSetController setController){
        this.setController =setController;
        
        Account[] accsts=[select id,name from account limit 30];
        setController.setSelected(accsts);
    }   
}