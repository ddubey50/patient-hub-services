@IsTest
private class ProgramSetupServiceTest {

    @IsTest
    static void testCreateDrug() {
        Test.startTest();
        Drug__c drug = ProgramSetupService.createDrug('TestBrand', 'NDC-001', 'Oncology');
        Test.stopTest();

        Drug__c result = [SELECT Brand_Name__c, NDC_Code__c, Active__c FROM Drug__c WHERE Id = :drug.Id];
        Assert.areEqual('TestBrand', result.Brand_Name__c);
        Assert.areEqual('NDC-001', result.NDC_Code__c);
        Assert.isTrue(result.Active__c);
    }

    @IsTest
    static void testCreateServiceConfig() {
        Drug__c drug = ProgramSetupService.createDrug('TestDrug', 'NDC-002', 'Diabetes');
        Test.startTest();
        Program_Service_Config__c cfg = ProgramSetupService.createServiceConfig('TEST-PROG-001');
        Test.stopTest();

        Program_Service_Config__c result = [
            SELECT BV_Enabled__c, PA_Enabled__c FROM Program_Service_Config__c WHERE Id = :cfg.Id
        ];
        Assert.isFalse(result.BV_Enabled__c);
        Assert.isFalse(result.PA_Enabled__c);
    }

    @IsTest
    static void testToggleService() {
        Program_Service_Config__c cfg = ProgramSetupService.createServiceConfig('TEST-PROG-002');
        Test.startTest();
        ProgramSetupService.toggleService(cfg.Id, 'BV', true);
        Test.stopTest();

        Program_Service_Config__c result = [SELECT BV_Enabled__c FROM Program_Service_Config__c WHERE Id = :cfg.Id];
        Assert.isTrue(result.BV_Enabled__c);
    }

    @IsTest
    static void testLinkDrugToProgram() {
        Drug__c drug = ProgramSetupService.createDrug('LinkDrug', 'NDC-003', 'Rare Disease');
        Test.startTest();
        Drug_Program__c link = ProgramSetupService.linkDrugToProgram('TEST-PROG-003', drug.Id);
        Test.stopTest();

        Drug_Program__c result = [SELECT Status__c, Drug__c FROM Drug_Program__c WHERE Id = :link.Id];
        Assert.areEqual('Active', result.Status__c);
        Assert.areEqual(drug.Id, result.Drug__c);
    }
}
