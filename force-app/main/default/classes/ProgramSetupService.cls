public with sharing class ProgramSetupService {

    public static CareProgram createProgram(String name, String area, Date startDate) {
        CareProgram prog = new CareProgram(
            Name             = name,
            Therapeutic_Area__c = area,
            StartDate        = startDate,
            Program_Status__c = 'Active'
        );
        insert prog;

        Program_Service_Config__c cfg = new Program_Service_Config__c(
            CareProgram__c     = prog.Id,
            BV_Enabled__c      = false,
            PA_Enabled__c      = false,
            FA_Enabled__c      = false,
            Nursing_Enabled__c = false,
            Adherence_Enabled__c = false,
            Portal_Enabled__c  = false
        );
        insert cfg;
        return prog;
    }

    public static Drug_Program__c linkDrug(Id programId, Id drugId) {
        Drug_Program__c link = new Drug_Program__c(
            CareProgram__c = programId,
            Drug__c        = drugId,
            Status__c      = 'Active',
            Effective_Date__c = Date.today()
        );
        insert link;
        return link;
    }

    public static void toggleService(Id programId, String serviceName, Boolean enabled) {
        Program_Service_Config__c cfg = [
            SELECT Id, BV_Enabled__c, PA_Enabled__c, FA_Enabled__c,
                   Nursing_Enabled__c, Adherence_Enabled__c, Portal_Enabled__c
            FROM Program_Service_Config__c
            WHERE CareProgram__c = :programId
            LIMIT 1
        ];
        switch on serviceName {
            when 'BV'        { cfg.BV_Enabled__c = enabled; }
            when 'PA'        { cfg.PA_Enabled__c = enabled; }
            when 'FA'        { cfg.FA_Enabled__c = enabled; }
            when 'Nursing'   { cfg.Nursing_Enabled__c = enabled; }
            when 'Adherence' { cfg.Adherence_Enabled__c = enabled; }
            when 'Portal'    { cfg.Portal_Enabled__c = enabled; }
        }
        update cfg;
    }
}
