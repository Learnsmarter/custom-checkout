# Custom Checkout Page for Learnsmarter Engage
Following this guide to include a custom page into the checkout process of Learnsmarter Engage. Adding custom pages to your checkout process can allow for extra data collection from your registrants.

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
