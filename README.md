# Custom Checkout Page for Learnsmarter Engage
Following this guide to include a custom page into the checkout process of Learnsmarter Engage. Adding custom pages to your checkout process can allow for extra data collection from your registrants.

This particular example allows you to add dietary and accessibility requirements for every participant of each registration in the order.

![Imgur](https://i.imgur.com/Ku16CKZ.png)

# Requirements
This sample requires the following:

* Some web programming knowledge
* That you are proficient in Salesforce development and admin tools 
* Learnsmarter Core and Engage (2.12+) to be installed and fully configured

# Setup
#### Create new fields
Before you can copy the files in this repository into your Salesforce org, ensure you have created the following fields:

> * lsc__participant__c.Dietary_Requirements__c
> * lsc__participant__c.Accessibility_Requirements__c

#### Copy Files
Copy the files in this repository into your Salesforce organization via the developer console or preferred IDE.

#### Provide Permissions
Open up the Learnsmarter Engage profile and provide read/write permissions to the above fields and permission to the Visualforce page created from this repository.

#### Set Up Checkout Flow
Open up the UX manager and go to Checkout Setup. At the bottom you will find a checkout flow that provides the list of ordered pages to be displayed in the checkout process. Edit this checkout flow and add in the newly created page (CheckoutExample).

#### Test
Run through the checkout process and ensure that the page is displaying and working as expected.


# Checkout Container API
The checkout container API (`lsi.CheckoutContainerController`) is used to retrieve information and push for actions to happen within the checkout UI. The checkout container API must be used as the main controller for the Visualforce page, whereas your custom controller should be the extension.

Here are the properties and methods available in the container API:

Property | Type | Description
---------|------|------------
pageName | String | The name of the current page
nextPage | String | The URL of the next page in the checkout flow
prevPage | String | The URL of the previous page in the checkout flow
OrderRecord | lsi__order__c | The sObject for the order record
OrderBookings | List<lsc__booking__c> | The list of registrations in the order
UserContactRecord | Contact | The contact record for the current user
UserAccountRecord | Account | The account record for the current user
UserRecord | User | The user record for the current user
isIndividualUser | Boolean | True if the user is an individual
currentItemId | Id | ID of the current registration being displayed (based on itemId URL parameter)
nextItemId | Id | ID of the next registration to be displayed

Method | Return Type | Description
-------|-------------|------------
updateTimeout(String orderId) | Integer |  Move the expiration time further back
prev([Boolean evaluateTax]) | PageReference | Redirects to the previous page in the checkout flow (not the next item)
next([Boolean evaluateTax]) | PageReference | Redirects to the next page in the checkout flow (not the next item)
evaluateTax() | void | Evaluate tax conditions and correct tax according to changes
cancelOrder() | PageReference | Delete the order and return to the basket


#### Usage
Make sure to set the container API to a property in your custom apex controller. You can then reference the properties and methods from there. You will need to do this in the constructor method of your class.

```java
private lsi.CheckoutContainerController container;

/**
 * Constructor method (has no return type and same name as controller).
 * Set the container API to the property above.
 */
public ExampleController(lsi.CheckoutContainerController container) {
  this.container = container;
}
```

Once you have done this, you are free to use the properties and methods above as appropriate. For example, if you wanted to move to the next page in the checkout flow (please note that this does not mean the next item), you would do the following:

```java
/**
 * Save the data and return the user to the next page in the
 * the checkout flow.
 */
public PageReference save() {
  // ... DML operations go here
  return container.next();
}
```

And reference your custom save method in the Visualforce page:

```xml
<apex:commandButton value="Save" action="{!save}" />
```

# Unit Tests
We have provided a sample test class in this repository. These unit tests only apply to the example, and it is imperative the unit test your own code for successful deployments.

Worth noting is the setup method for creating test data. This will help create an order with registrations for your unit tests. Use/extend this to work with your code.
