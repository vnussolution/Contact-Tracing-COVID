# Contact Tracing App

Sample Contact Tracing app built on Salesforce Platform.

![Contact_Tracing_App](https://github.com/choudharymanish8585/contact-tracing/blob/master/screenshots/screenshots.png)

#### https://www.lightningdesignsystem.com/
#### https://developer.salesforce.com/docs/component-library/overview/components



#### "ONE COURSE TO RULE THEM ALL"

##### It's impossible to highlight all offering of this course here, but below are some major modules:

-   Web Application Architecture
-   Programming Fundamentals
-   Apex Development
-   Async Apex
-   Aura Framework Development
-   SOQL - Salesforce Object Query Language
-   SOSL - Salesforce Object Search Language
-   Database Manipulation
-   Object-Oriented Programming System

## Install Object Schema

**Make sure you have "git" and Salesoforce CLI installed in your system. Follow below steps to upload object schema along with permission set in your Salesforce Org.**

-   Clone "schema-metadata" branch from this git repo `git clone --branch schema-metadata https://github.com/choudharymanish8585/contact-tracing.git`
-   Open Terminal/Command Prompt and navigate to above folder
-   Authorize your Salesforce Org `sfdx force:auth:web:login -a TestOrg1`
-   Deploy all metadata to your Salesforce Org `sfdx force:source:deploy -p force-app/main/default/`
-   Assign permission set to current user `sfdx force:user:permset:assign -n Health_Admin`
-   Open Saleforce Org `sfdx force:org:open` and switch to "Contact Tracing" application


## Install Entire Application

**Make sure you have "git" and Salesoforce CLI installed in your system. Follow below steps to upload object schema along with permission set in your Salesforce Org.**

-   Clone "master" branch from this git repo `git clone https://github.com/choudharymanish8585/contact-tracing.git`
-   Open Terminal/Command Prompt and navigate to above folder
-   Authorize your Salesforce Org `sfdx force:auth:web:login -a TestOrg1`
-   Deploy all metadata to your Salesforce Org `sfdx force:source:deploy -p force-app/main/default/`
-   Assign permission set to current user `sfdx force:user:permset:assign -n Health_Admin`
-   Open Saleforce Org `sfdx force:org:open` and switch to "Contact Tracing" application
