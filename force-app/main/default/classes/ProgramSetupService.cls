public with sharing class ProgramSetupService {

    public static Drug__c createDrug(String brandName, String ndcCode, String therapeuticArea) {
        Drug__c drug = new Drug__c(
            Brand_Name__c       = brandName,
            NDC_Code__c         = ndcCode,
            Therapeutic_Area__c = therapeuticArea,
            Active__c           = true
        );
        insert drug;
        return drug;
    }

    public static Drug_Program__c linkDrugToProgram(String programId, Id drugId) {
        Drug_Program__c link = new Drug_Program__c(
            CareProgram__c    = programId,
            Drug__c           = drugId,
            Status__c         = 'Active',
            Effective_Date__c = Date.today()
        );
        insert link;
        return link;
    }

    public static Program_Service_Config__c createServiceConfig(String programId) {
        Program_Service_Config__c cfg = new Program_Service_Config__c(
            CareProgram__c       = programId,
            BV_Enabled__c        = false,
            PA_Enabled__c        = false,
            FA_Enabled__c        = false,
            Nursing_Enabled__c   = false,
            Adherence_Enabled__c = false,
            Portal_Enabled__c    = false
        );
        insert cfg;
        return cfg;
    }

    public static void toggleService(Id configId, String serviceName, Boolean enabled) {
        Program_Service_Config__c cfg = [
            SELECT Id, BV_Enabled__c, PA_Enabled__c, FA_Enabled__c,
                   Nursing_Enabled__c, Adherence_Enabled__c, Portal_Enabled__c
            FROM Program_Service_Config__c
            WHERE Id = :configId
            LIMIT 1
        ];
        switch on serviceName {
            when 'BV'        { cfg.BV_Enabled__c        = enabled; }
            when 'PA'        { cfg.PA_Enabled__c        = enabled; }
            when 'FA'        { cfg.FA_Enabled__c        = enabled; }
            when 'Nursing'   { cfg.Nursing_Enabled__c   = enabled; }
            when 'Adherence' { cfg.Adherence_Enabled__c = enabled; }
            when 'Portal'    { cfg.Portal_Enabled__c    = enabled; }
        }
        update cfg;
    }
}
