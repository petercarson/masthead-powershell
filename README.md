# Introduction
_masthead.ps1_ is a collection of PowerShell scripts that make managing your Masthead sites easier. Currently, the library contains:
  1. Install-To-Site
  2. Uninstall-From-Site

# Getting Started
Before you use our library, you'll need to make sure you have the latest version of the [SharePoint Online Client Components SDK](https://www.microsoft.com/en-ca/download/details.aspx?id=42038) installed on your system.

1. Download `masthead.ps1` into a local folder on your system.
2. Open PowerShell, and navigate to the folder containing `masthead.ps1`
3. Load the script into memory with the following command: `. ./masthead.ps1`
4. Follow the prompts to add the necessary credentials for the library to work.

Anytime you start a new session with the library you'll need to go through steps 3 and 4.

# Current Functions

To run these functions, you'll need to make sure that the library is first loaded into memory. Once done, you can call these functions directly from the PowerShell command line.

|Name | Command | Description|
|-----|---------|------------|
|Install-To-Site | `Install-To-Site <ABSOLUTE_SITE_URL>` | Adds the version of Masthead you have installed to the target site. Make sure the URL you're using is a reference to the site without any pages on the end (ex: `https://<your-site>.sharepoint.com/sites/<site-name>`) |
|Uninstall-From-Site | `Uninstall-From-Site <ABSOLUTE_SITE_URL>` | Removes Masthead from the target site. Make sure the URL you're using is a reference to the site without any pages on the end (ex: `https://<your-site>.sharepoint.com/sites/<site-name>`) |
