@IsTest
private class ProgramSetupServiceTest {

    @IsTest
    static void testCreateProgram() {
        Test.startTest();
        CareProgram prog = ProgramSetupService.createProgram('OncoCare', 'Oncology', Date.today());
        Test.stopTest();

        CareProgram result = [SELECT Id, Name, Therapeutic_Area__c, Program_Status__c FROM CareProgram WHERE Id = :prog.Id];
        Assert.areEqual('OncoCare', result.Name);
        Assert.areEqual('Oncology', result.Therapeutic_Area__c);
        Assert.areEqual('Active', result.Program_Status__c);

        List<Program_Service_Config__c> cfgs = [SELECT Id FROM Program_Service_Config__c WHERE CareProgram__c = :prog.Id];
        Assert.areEqual(1, cfgs.size(), 'Service config should be auto-created');
    }

    @IsTest
    static void testToggleService() {
        CareProgram prog = ProgramSetupService.createProgram('TestProg', 'Diabetes', Date.today());
        Test.startTest();
        ProgramSetupService.toggleService(prog.Id, 'BV', true);
        Test.stopTest();

        Program_Service_Config__c cfg = [SELECT BV_Enabled__c FROM Program_Service_Config__c WHERE CareProgram__c = :prog.Id];
        Assert.isTrue(cfg.BV_Enabled__c, 'BV should be enabled');
    }
}
