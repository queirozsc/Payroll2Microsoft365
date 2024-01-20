# Payroll2Microsoft365
Automatically updates Microsoft 365 data from the information updated in the payroll software.

## The context
### Infraestructure
Our IT infrastructure is mostly built on Microsoft solutions.

In the context of this project, it is worth highlighting:
* **Active Directory (AD)**: directory service in the LDAP protocol that stores information about objects on the computer network. Objects such as users, groups, group members, passwords, organizational units, etc. are stored in the AD database.
* **Entra ID**: also known as Azure Active Directory (AAD), is a cloud-based identity and access management (IAM) solution. It is a directory and identity management service that operates in the cloud and offers authentication and authorization services to various Microsoft services such as Microsoft 365, Dynamics 365, and Microsoft Azure.
* **Azure AD Connect**: also know as AAD Sync,  is a tool for connecting on-premises identity infrastructure to Microsoft Azure AD. 
* **Microsoft 365**: is a product family of productivity software, collaboration and cloud-based services, such as Outlook, OneDrive, Teams, SharePoint, and others.

### Payroll system
Our payroll system is [Salar](https://www.salar.com.bo/), from the Bolivian company [Iqus](https://www.iqus.com.bo/).

It's important to note that all communication will be via API, which means that if your HR software supports this technology, this code can easily be adapted to your reality.


## The problem
In the dynamics of the company, employee movements are very common: hiring, dismissals, promotions, departmental changes, job changes, ...

With small IT and HR teams and a flow of information that is not always efficient, information often becomes outdated in identity services such as AD and Entra ID.

And the biggest problems: information security and costs, since delays in sending the list of terminated employees mean that users are still active and/or still have assigned licenses.

## The solution
Create scripts that automate the updating of identity services, based on data from the payroll system.

We will use the following technologies:
* **Powershell**: Microsoft's task automation and configuration management program, consisting of a command line shell and the associated scripting language.
* **Microsoft Graph**: API developer platform that connects various services, including Windows, Microsoft 365 and Azure.
* **Azure App Registration**: is the process of registering your application with AAD. This registration provides your application with the necessary credentials to securely access Azure services and APIs, making your applications and services more secure and accessible. It’s like giving your application a key to securely access resources and user information on Azure.
* **Azure Functions**: Execute event-driven serverless code functions with an end-to-end development experience. In a modern cloud native solutions, it's a better way to execute small and eventually pieces of code than to maintain a server powered up on your infraestructure all-day long.
* **Azure Files:** fully managed file shares in the cloud.

### Estimated costs
* **Entra ID**: we use the free version, included in the Microsoft 365 subscription. 
  
  Find out more at https://www.microsoft.com/en/security/business/microsoft-entra-pricing
* **Azure App Registration**: free for Entra ID free users. 
  
  Find out more at https://learn.microsoft.com/en-us/answers/questions/436510/cost-of-app-registrations-in-azure
* **Azure Functions**: $0.0255/Gib for Hot data storage mode. 
  
  Find out more at https://azure.microsoft.com/en-us/pricing/details/storage/files/

  ## Setting up
Install pre-requisites and set env variables:
```
. .\Install-Prereqs.ps1
. .\Set-EnvVariables.ps1
```
