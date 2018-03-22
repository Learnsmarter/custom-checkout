@isTest
private class ExampleControllerTest {
	
    static lsc__booking__c[] createBookings(Integer num) {
        lsc__coursearea__c rsArea = new lsc__coursearea__c(Name='Test');
        insert rsArea;
        
        lsc__course__c rsCourse = new lsc__course__c(Name='Test', lsc__CourseArea__c=rsArea.Id);
        insert rsCourse;
        
        lsc__event__c[] rsEvents = new lsc__event__c[]{};
            
        for ( Integer i=0; i<num; i++ ) {
			rsEvents.add(new lsc__event__c(
                lsc__Course__c=rsCourse.Id,
                lsc__StartDate__c=Date.today().addDays(5+i),
                lsc__EndDate__c=Date.today().addDays(5+i)
            ));
        }
        
        insert rsEvents;
    
        
        Account rsAccount = new Account(Name='Test');
        insert rsAccount;
        
        Contact[] rsContacts = new List<Contact>();
        rsContacts.add(new Contact(FirstName='Test 1', LastName='Contact 1', AccountId=rsAccount.Id, BirthDate=Date.newInstance(1980, 6, 2)));
        rsContacts.add(new Contact(FirstName='Test 2', LastName='Contact 2', AccountId=rsAccount.Id, BirthDate=Date.newInstance(1978, 5, 2)));
        rsContacts.add(new Contact(FirstName='Test 3', LastName='Contact 3', AccountId=rsAccount.Id, BirthDate=Date.newInstance(1978, 5, 2)));
        insert rsContacts;

        lsi__order__c rsOrder = new lsi__order__c(
        	lsi__Contact__c=rsContacts[0].Id,
            lsi__OrderStatusID__c=5
        );
        
        insert rsOrder;
        
        lsc__booking__c[] rsBookings = new lsc__booking__c[]{};
        
    	for ( lsc__event__c rs : rsEvents ) {
            rsBookings.add(new lsc__booking__c(
            	lsc__Event__c=rs.Id,
                lsc__LeadContact__c=rsContacts[0].Id,
                lsc__Account__c=rsContacts[0].AccountId,
                lsc__PlacesRequired__c=2,
                lsi__Order__c=rsOrder.Id,
                lsc__BookingStatusID__c=2
            ));
        }
        
        insert rsBookings;
        
        lsc__participant__c[] rsParticipants = new List<lsc__participant__c>();
        for ( lsc__booking__c rsBooking : rsBookings ) {
            for ( Integer i=0; i<num; i++ ) {
                rsParticipants.add(new lsc__participant__c(lsc__Contact__c=rsContacts[0].Id, lsc__Booking__c=rsBooking.Id));
                rsParticipants.add(new lsc__participant__c(lsc__Contact__c=rsContacts[1].Id, lsc__Booking__c=rsBooking.Id));
                rsParticipants.add(new lsc__participant__c(lsc__Contact__c=rsContacts[2].Id, lsc__Booking__c=rsBooking.Id));
            }
        }
                        
        insert rsParticipants;
        
		return rsBookings;
    }
    
    
    static String getLastApexMessage() {
        if ( !ApexPages.getMessages().isEmpty() ) {
        	return ApexPages.getMessages()[ApexPages.getMessages().size()-1].getSummary();
        }
        
        return '';
    }
    
    static testMethod void test_currentBooking_NoUrlParam() {
    	lsc__booking__c[] rsBookings = createBookings(2);
        
        Test.startTest();
        
        Test.setCurrentPage(new PageReference('/ExampleController'));
        ExampleController cls = new ExampleController(new lsi.CheckoutContainerController());
        cls.container.userContactRecord = new Contact(Id=rsBookings[0].lsc__LeadContact__c);
        System.assertNotEquals(null, cls.currentBooking);
        
        Test.stopTest();
    }
      
    static testMethod void test_currentBooking_WithUrlParam() {
    	lsc__booking__c[] rsBookings = createBookings(2);
        
        Test.startTest();
        
        ExampleController cls;
        
        Test.setCurrentPage(new PageReference('/ExampleController?itemId='+rsBookings[0].Id));
        cls = new ExampleController(new lsi.CheckoutContainerController());
        cls.container.userContactRecord = new Contact(Id=rsBookings[0].lsc__LeadContact__c);
        System.assertNotEquals(null, cls.currentBooking);
        System.assertEquals(rsBookings[0].Id, cls.currentBooking.Id);
        
        Test.setCurrentPage(new PageReference('/ExampleController?itemId='+rsBookings[1].Id));
        cls = new ExampleController(new lsi.CheckoutContainerController());
        cls.container.userContactRecord = new Contact(Id=rsBookings[0].lsc__LeadContact__c);
        System.assertNotEquals(null, cls.currentBooking);
        System.assertEquals(rsBookings[1].Id, cls.currentBooking.Id);
        
        Test.stopTest();
    }  
    
    
    static testMethod void test_participants() {
        lsc__booking__c[] rsBookings = createBookings(2);
        
        Test.startTest();
        
        ExampleController cls;
        
        Test.setCurrentPage(new PageReference('/ExampleController?itemId='+rsBookings[0].Id));
        cls = new ExampleController(new lsi.CheckoutContainerController());
        cls.container.userContactRecord = new Contact(Id=rsBookings[0].lsc__LeadContact__c);
        System.assertNotEquals(3, cls.participants.size());
        
        Test.setCurrentPage(new PageReference('/ExampleController?itemId='+rsBookings[1].Id));
        cls = new ExampleController(new lsi.CheckoutContainerController());
        cls.container.userContactRecord = new Contact(Id=rsBookings[0].lsc__LeadContact__c);
        System.assertNotEquals(3, cls.participants.size());
        
        Test.stopTest();
    }
    
    
    static testMethod void test_init() {
        lsc__booking__c[] rsBookings = createBookings(1);
        
        ExampleController cls;
        PageReference pr;
        
        Test.setCurrentPage(new PageReference('/CheckoutExample'));
        cls = new ExampleController(new lsi.CheckoutContainerController());
        cls.container.userContactRecord = new Contact(Id=rsBookings[0].lsc__LeadContact__c);
        pr = cls.init();
        System.assertNotEquals(null, pr, 'PAGE_REFERNCE_NULL');
    	System.assertNotEquals(null, pr.getParameters().get('itemId'), 'ITEM_ID_NULL');
        
        Test.setCurrentPage(pr);
        cls = new ExampleController(new lsi.CheckoutContainerController());
        pr = cls.init();
        System.assertEquals(null, pr);
    }
    
    
    static testMethod void test_save() {
        lsc__booking__c[] rsBookings = createBookings(3);

		Test.startTest();
        
        ExampleController cls;
        PageReference pr;
        
        Test.setCurrentPage(new PageReference('/CheckoutExample?itemId=' + rsBookings[0].Id));
        cls = new ExampleController(new lsi.CheckoutContainerController());
        cls.container.userContactRecord = new Contact(Id=rsBookings[0].lsc__LeadContact__c);
		cls.participants[0].Dietary_Requirements__c = 'I like Apples';
        cls.participants[1].Accessibility_Requirements__c = 'Wheelchair access';
        cls.save();
        
        Test.stopTest();
        
        lsc__participant__c[] rsParticipants = [SELECT Id, Dietary_Requirements__c, Accessibility_Requirements__c 
                                                FROM lsc__participant__c WHERE Id IN:cls.participants];
        
        Map<Id, lsc__participant__c> participantMap = new Map<Id, lsc__participant__c>(rsParticipants);
        System.assertEquals('I like Apples', cls.participants[0].Dietary_Requirements__c);
        System.assertEquals(null, cls.participants[0].Accessibility_Requirements__c);
        System.assertEquals(null, cls.participants[1].Dietary_Requirements__c);
        System.assertEquals('Wheelchair access', cls.participants[1].Accessibility_Requirements__c);
    }
    
    
    static testMethod void test_addError() {
        ExampleController cls = new ExampleController(new lsi.CheckoutContainerController());
        System.assertEquals(null, cls.addError('I am an error!'));
    }
    
}
