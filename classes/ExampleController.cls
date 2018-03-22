public without sharing class ExampleController {
	
    private lsi.CheckoutContainerController container;
        
    /**
     * Get the current registration to be displayed
     */  
    public lsc__booking__c currentBooking {
        get {
        	if ( currentBooking == null ) {
                Id bookingId = container.currentItemId != null ? container.currentItemId : container.OrderBookings[0].Id;
                
                currentBooking = [SELECT Id, lsc__Event__r.lsc__StartDateTime__c, 
                                  	lsc__Event__r.lsc__EndDateTime__c, lsc__Event__r.lsc__Course__r.Name 
                                  FROM lsc__booking__c WHERE Id=:bookingId];
            }
            
            return currentBooking;
    	}
        set;
    }
    
    
    /**
     * Get a list of participants in the current registrations
     */
    public lsc__participant__c[] participants {
        get {
            if ( currentBooking != null && participants == null ) {
                participants = [SELECT Id, lsc__ParticipantName__c, Dietary_Requirements__c, Accessibility_Requirements__c
                                FROM lsc__participant__c
                                WHERE lsc__Booking__c=:currentBooking.Id AND lsc__IsAllocated__c=1];
            }
            
            return participants;
        }
        set;
    }
    
    
    /**
     * Constructor method - sets container to property
     */ 
    public ExampleController(lsi.CheckoutContainerController container) {
        this.container = container;
    }
    
    /**
     * On page load, set the item id to the URL parameter (itemId). This will
     * tell the container which item in the order we are currently viewing.
     * 
     * @return redirect with itemId set (unless already set)
     */ 
    public PageReference init() {
        PageReference pr;
        
        if ( !ApexPages.currentPage().getParameters().containsKey('itemId') ) {
            pr = ApexPages.currentPage();
            pr.getParameters().put('itemId', container.OrderBookings[0].Id);
        	pr.setRedirect(true);
        }
        
        return pr;
    }
    
    
    /**
     * Save the participants and move onto the next registration
     * 
     * @return the next page in the checkout
     */ 
    public PageReference save() {
        try {
        	update participants;
        } catch(DmlException err) {
            // Create error messages
            for ( Integer i=0; i<err.getNumDml(); i++ ) {
                addError(err.getDmlMessage(i));
            }
            
            // Return to page with errors
            return null;
        }
        
        // Go to the next step or page in the checkout process
        if ( container.nextItemId != null ) {
            PageReference pr = ApexPages.currentPage();
            pr.getParameters().put('itemId', container.nextItemId);
            pr.setRedirect(true);
            return pr;
        }
        
        return container.next();  
    }
    
    
    
    /**
     * Add an error to the page
     * 
     * @param string error message
     * @return always null for quick returns
     */ 
    private PageReference addError(String err) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, err));
        return null;
    }
    
    
}
