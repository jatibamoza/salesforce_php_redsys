@IsTest()
public class ListViewControllerTest{
	
    private static testmethod void ListViewControllerTest(){
        
		HRC_ConsentsLead__c obj = new HRC_ConsentsLead__c(HRC_Nombre__c ='Test', HRC_Email__c = 'test@prueba.com');
		insert obj;

		List<HRC_ConsentsLead__c> selected = new List<HRC_ConsentsLead__c>();
		selected.add(obj);

		PageReference pageRef = Page.ConsentLeadListView;
	
		Test.setCurrentPage(pageRef);

		pageRef.getParameters().put('Id', String.valueOf(obj.Id));
		ApexPages.StandardSetController sc = new ApexPages.StandardSetController(selected);
		ListViewController l = new ListViewController(sc);

	}
}