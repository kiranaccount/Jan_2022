/**
 * Copyright (c) 2012, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 * Base class aiding in the implemetnation of a Domain Model around SObject collections
 * 
 * Domain (software engineering). “a set of common requirements, terminology, and functionality 
 * for any software program constructed to solve a problem in that field”,
 * http://en.wikipedia.org/wiki/Domain_(software_engineering)
 *
 * Domain Model, “An object model of the domain that incorporates both behavior and data.”, 
 * “At its worst business logic can be very complex. Rules and logic describe many different "
 * "cases and slants of behavior, and it's this complexity that objects were designed to work with...” 
 * Martin Fowler, EAA Patterns
 * http://martinfowler.com/eaaCatalog/domainModel.html
 *
 *
 *
 * Modification Log :
 *-----------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ----------------------------------------------------------------------------                 
 * Muhammad Malik              03/01/2017            Intial Version - Modied version of Published Version
 * Muhammad Malik              03/01/2017            Made modifications to remove test methods
 * Muhammad Malik              03/01/2017            Made modifications for recursion handling
**/

public virtual with sharing class SObjectDomain
{
    public List<SObject> Records { get; private set;}
    
    public Schema.DescribeSObjectResult SObjectDescribe {get; private set;}
            
    public static ErrorFactory Errors  {get; private set;}
    
    public static SObjectUnitOfWork unitOfWork;
   

    public Static Map<String,TriggerProgressStatus> triggersProgressStatusMap = new Map<String,TriggerProgressStatus>();    
        
    //public Static Boolean triggerInProgress = false;
    //public Static Boolean triggerIsBeforeComplete = false;
    //public Static Boolean triggerIsAfterComplete = false;
    
    static
    {
        Errors = new ErrorFactory();
        
    }
    
    public SObjectDomain(List<SObject> sObjectList)
    {
        Records = sObjectList;
        
        SObjectDescribe = Records.getSObjectType().getDescribe();
    }
    
    /**
     * Override this to apply defaults to the records, this is called by the handleBeforeInsert method
     **/
    public virtual void onApplyDefaults() { }
    
    /**
     * Override this to apply general validation to be performed during insert or update, called by the handleAfterInsert and handleAfterUpdate methods
     **/
    public virtual void onValidate() {  }
    
    /**
     * Override this to apply validation to be performed during insert, called by the handleAfterUpdate method
     **/
    public virtual void onValidate(Map<Id,SObject> existingRecords) { }

    /**
     * Override this to perform processing during the before insert phase, this is called by the handleBeforeInsert method
     **/
    public virtual void onBeforeInsert() { }
    
    /**
     * Override this to perform processing during the before update phase, this is called by the handleBeforeUpdate method
     **/
    public virtual void onBeforeUpdate(Map<Id,SObject> existingRecords) { }

    /**
     * Override this to perform processing during the before update phase, this is called by the handleBeforeUpdate method
     **/    
    public virtual void onBeforeUpdateInprogress(Map<Id,SObject> existingRecords) { }
    
    /**
     * Override this to perform processing during the before delete phase, this is called by the handleBeforeDelete method
     **/
    public virtual void onBeforeDelete() { }
    
    /**
     * Override this to perform processing during the after insert phase, this is called by the handleAfterInsert method
     **/
    public virtual void onAfterInsert() { }
    
    /**
     * Override this to perform processing during the after update phase, this is called by the handleAfterUpdate method
     **/    
    public virtual void onAfterUpdate(Map<Id,SObject> existingRecords) { }


    /**
     * Override this to perform processing during the after update phase, this is called by the handleAfterUpdate method
     **/
    public virtual void onAfterUpdateInprogress(Map<Id,SObject> existingRecords) { }
    
    /**
     * Override this to perform processing during the after delete phase, this is called by the handleAfterDelete method
     **/    
    public virtual void onAfterDelete() { } 
    
    /**
     * Base handler for the Apex Trigger event Before Insert, calls the onApplyDefaults method, followed by onBeforeInsert
     **/
    public virtual void handleBeforeInsert() 
    { 
        onApplyDefaults(); 
        onBeforeInsert();
    }
    
    /**
     * Base handler for the Apex Trigger event Before Update, calls the onBeforeUpdate method
     **/
    public void handleBeforeUpdate(Map<Id,SObject> existingRecords, boolean inProgress) 
    {
        if (Inprogress) {
            onBeforeUpdateInprogress(existingRecords);              
        }
        else {
            onBeforeUpdate(existingRecords);            
        }
    }
    
    /**
     * Base handler for the Apex Trigger event Before Delete, calls the onBeforeDelete method
     **/
    public void handleBeforeDelete() 
    {
        onBeforeDelete();
    }
    
    /**
     * Base handler for the Apex Trigger event After Insert, checks object security and calls the onValidate and onAfterInsert methods
     *
     * @throws DomainException if the current user context is not able to create records
     **/
    public void handleAfterInsert()
    {
        //if(!SObjectDescribe.isCreateable())
        //   throw new DomainException('Permission to create an ' + SObjectDescribe.getName() + ' denied.');
           
        onValidate();
        onAfterInsert(); 
    }
    
    /**
     * Base handler for the Apex Trigger event After Update, checks object security and calls the onValidate, onValidate(Map<Id,SObject>) and onAfterUpdate methods
     *
     * @throws DomainException if the current user context is not able to update records
     **/
    public void handleAfterUpdate(Map<Id,SObject> existingRecords, boolean inProgress) 
    {
        //if(!SObjectDescribe.isUpdateable())
        //   throw new DomainException('Permission to udpate an ' + SObjectDescribe.getName() + ' denied.');

        if (Inprogress) {          
            onValidate();
            onValidate(existingRecords);
            onAfterUpdateInprogress(existingRecords);
        }
        else {
            onValidate();
            onValidate(existingRecords);
            onAfterUpdate(existingRecords);
        } 
    }
    
    /**
     * Base handler for the Apex Trigger event After Delete, checks object security and calls the onAfterDelete method
     *
     * @throws DomainException if the current user context is not able to delete records
     **/
    public void handleAfterDelete() 
    {
        //if(!SObjectDescribe.isDeletable())
        //   throw new DomainException('Permission to delete an ' + SObjectDescribe.getName() + ' denied.');
           
        onAfterDelete();
    }   

    public void handleFinally() 
    {
        //if(!SObjectDescribe.isDeletable())
        //   throw new DomainException('Permission to delete an ' + SObjectDescribe.getName() + ' denied.');
           
        onAfterDelete();
    }   
    
    
    
    public interface IConstructable
    {
        SObjectDomain construct(List<SObject> sObjectList);
    }   
    
    /**
     * Method constructs the given Domain class with the current Trigger context 
     * before calling the applicable override methods such as beforeInsert, beforeUpdate etc.
     **/
    public static void triggerHandler(Type domainClass)
    {
    
        System.debug('MM start opp trigger ' + datetime.now().second() + ' ' + datetime.now().millisecond() + '\n');
        

        // Construct the domain class constructor class
        String domainClassName = domainClass.getName().removeEnd('__c').remove('_') + 'Handler';
        Type constructableClass = domainClassName.endsWith('Constructor') ? Type.forName(domainClassName) : Type.forName(domainClassName+'.Constructor');
        IConstructable constructor = (IConstructable) constructableClass.newInstance();
            
        if (!triggersProgressStatusMap.containsKey(domainClassName)) {
            triggersProgressStatusMap.put(domainClassName,new TriggerProgressStatus(false,false,false));
        } 
          
        
        TriggerProgressStatus tgrProgressStatus = triggersProgressStatusMap.get(domainClassName);
        
        System.debug(triggersProgressStatusMap);
        
                    
            
        // Process the runtime Apex Trigger context 
            
        if (trigger.isInsert) {
                triggerHandler(constructor, 
                    Trigger.isBefore, 
                    Trigger.isAfter, 
                    Trigger.isInsert, 
                    Trigger.isUpdate, 
                    Trigger.isDelete, 
                    Trigger.new, 
                    null,
                    tgrProgressStatus);            
            
        }
        else {
                triggerHandler(constructor, 
                    Trigger.isBefore, 
                    Trigger.isAfter, 
                    Trigger.isInsert, 
                    Trigger.isUpdate, 
                    Trigger.isDelete, 
                    Trigger.new, 
                    Trigger.oldMap,
                    tgrProgressStatus);            
            
        }
            
        System.debug('MM End opp trigger' + datetime.now().second() + ' ' + datetime.now().millisecond() + '\n');
            
    }
    
    /**
     * Calls the applicable override methods such as beforeInsert, beforeUpdate etc. based on a Trigger context
     **/
    private static void triggerHandler(IConstructable domainConstructor, Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<SObject> newRecords, Map<Id, SObject> oldRecordsMap,TriggerProgressStatus tgrProgressStatus)
    {  
    
        unitOfWork = new SObjectUnitOfWork();
        
        if(isBefore) {
            if(isInsert) domainConstructor.construct(newRecords).handleBeforeInsert();
            else if(isUpdate) domainConstructor.construct(newRecords).handleBeforeUpdate(oldRecordsMap,tgrProgressStatus.triggerIsBeforeComplete);
            else if(isDelete) domainConstructor.construct(oldRecordsMap.values()).handleBeforeDelete();
        }
        else {
            if(isInsert) domainConstructor.construct(newRecords).handleAfterInsert();
            else if(isUpdate) domainConstructor.construct(newRecords).handleAfterUpdate(oldRecordsMap,tgrProgressStatus.triggerIsAfterComplete);
            else if(isDelete) domainConstructor.construct(oldRecordsMap.values()).handleAfterDelete();
        }
    
        if (!tgrProgressStatus.triggerInProgress) tgrProgressStatus.triggerInProgress = true;        
        if (isBefore && !tgrProgressStatus.triggerIsBeforeComplete) tgrProgressStatus.triggerIsBeforeComplete = true;
        if (isAfter && !tgrProgressStatus.triggerIsAfterComplete) tgrProgressStatus.triggerIsAfterComplete = true;
        
        //Mark trigger in progress to false 
        //triggerInProgress = false;
        
        //Commit after completion of all event execution.
        unitOfWork.commitWork();
                        
    }
    
    public class TriggerProgressStatus {
    
        public Boolean triggerInProgress {get; set;}
        public Boolean triggerIsBeforeComplete {get; set;}
        public Boolean triggerIsAfterComplete {get; set;}    
    
        public TriggerProgressStatus (Boolean tgrInProgress,Boolean tgrIsBeforeComplete, Boolean tgrIsAfterComplete) {
            triggerInProgress = tgrInProgress;
            triggerIsBeforeComplete = tgrIsBeforeComplete;
            triggerIsAfterComplete = tgrIsAfterComplete;
        }
        
                
    }
    
    public class DomainException extends Exception
    {
    }

    public String error(String message, SObject record)
    {
        return Errors.error(this, message, record); 
    }
    
    public String error(String message, SObject record, SObjectField field)
    {
        return Errors.error(this, message, record, field);  
    }
    
    public class ErrorFactory
    {
        private List<Error> errorList = new List<Error>(); 
        
        private ErrorFactory()
        {
            
        }
        
        public String error(String message, SObject record)
        {
            return error(null, message, record);    
        }

        private String error(SObjectDomain domain, String message, SObject record)
        {
            ObjectError objectError = new ObjectError();
            objectError.domain = domain;
            objectError.message = message;
            objectError.record = record;
            errorList.add(objectError);
            return message; 
        }
        
        public String error(String message, SObject record, SObjectField field)
        {
            return error(null, message, record, field); 
        }

        private String error(SObjectDomain domain, String message, SObject record, SObjectField field)
        {
            FieldError fieldError = new FieldError();
            fieldError.domain = domain;
            fieldError.message = message;
            fieldError.record = record;
            fieldError.field = field;
            errorList.add(fieldError);
            return message; 
        }   
            
        public List<Error> getAll()
        { 
            return errorList.clone();
        }
        
        public void clearAll()
        {
            errorList.clear();
        }                   
    }
    
    public class FieldError extends ObjectError
    {
        public SObjectField field;
        
        private FieldError()
        {       
            
        }
    }
    
    public virtual class ObjectError extends Error
    {
        public SObject record;
        
        private ObjectError()
        {
        
        }
    }
    
    public abstract class Error
    {
        public String message;
        public SObjectDomain domain;
    }
    
}