[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll'

$UserName = "admin@itgroovedeveloper.onmicrosoft.com"
$Password = "itgD3v!!!"
$Url = "https://itgroovedeveloper.sharepoint.com/sites/masthead-app-dev/"
$Site = "https://itgroovedeveloper.sharepoint.com/sites/mastheadclassictest/"

$ListTitle = "masthead-app-settings"
$caName = "Masthead";
$caTitle = "s-masthead-spx";
$caDescription = "Masthead for sharepoint";
$caLocation = "ClientSideExtension.ApplicationCustomizer";
$caComponentId = "27b0cb87-695b-4405-ae63-9db7d67e1029"

$caClassicName = "Masthead Classic";
$caClassicTitle = "masthead-classic";
$caClassicDescription = "Masthead classic action";
$caClassicLocation = "ScriptLink";
$caClassicSequence = 4884;
$caClassicScriptpt1 = 'function masthedClassicRetrieve() {var request = new XMLHttpRequest();request.open("GET","';
$caClassicScriptpt2 = '/_api/lists/getbytitle(''masthead-app-settings'')/items?$filter=Title eq ''classicScript''",true);request.onreadystatechange = function(){if (request.readyState === 4 && request.status === 200){var json = JSON.parse(request.response);var script = document.createElement("script");script.type = "text/javascript";script.src = json.value[0].URL + "masthead-classic.js";document.getElementsByTagName("body")[0].appendChild(script);var link = document.createElement("link");link.type = "text/css";link.rel = "stylesheet"; link.href= json.value[0].URL + "styles.css";document.getElementsByTagName("head")[0].appendChild(link);}}; request.withCredentials = true;request.setRequestHeader("Accept", "application/json");request.send();}masthedClassicRetrieve();masthedClassicRetrieve = null;'

Function Get-SPOCredentials([string]$UserName, [string]$Password) {
  $SecurePassword = $Password | ConvertTo-SecureString -AsPlainText -Force
  return New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName, $SecurePassword)
}

Function Get-List([Microsoft.SharePoint.Client.ClientContext]$Context, [String]$ListTitle) {
  $list = $context.Web.Lists.GetByTitle($ListTitle)
  $context.Load($list)
  $context.ExecuteQuery()
  $list
}

Function Get-Context-For-Site([string]$siteURL, [string]$UserName, [string]$Password) {
  $context = New-Object Microsoft.SharePoint.Client.ClientContext($siteURL)
  $context.Credentials = Get-SPOCredentials -UserName $UserName -Password $Password
  return $context
}

$adminContext = Get-Context-For-Site -siteURL $url -UserName $UserName -Password $Password

$siteContext = Get-Context-For-Site -siteURL $Site -UserName $UserName -Password $Password
$siteWeb = $siteContext.Web
$siteContext.Load($siteWeb)
$siteContext.ExecuteQuery()
$existingActions = $siteWeb.UserCustomActions
$siteContext.Load($existingActions)
$siteContext.ExecuteQuery()

$caMasthead = $existingActions.Add()
$caMasthead.Name = $caName
$caMasthead.Title = $caTitle
$caMasthead.Group = ""
$caMasthead.Description = $caDescription
$caMasthead.Location = $caLocation
$caMasthead.ClientSideComponentId = $caComponentId
$caMasthead.Update()

$siteContext.ExecuteQuery()

Try {
  $caClassic = $existingActions.Add()
  $caClassic.Name = $caClassicName
  $caClassic.Title = $caClassicTitle
  $caClassic.Group = ""
  $caClassic.Description = $caClassicDescription
  $caClassic.Location = $caClassicLocation
  $caClassic.Sequence = $caClassicSequence
  $caClassic.ScriptBlock = $caClassicScriptpt1 + $adminContext.Url + $caClassicScriptpt2
  $caClassic.Update()
  $siteContext.ExecuteQuery()
}
Catch {
  "Error adding classic version of masthead. If you are on a modern site, this is expected."
}

$settingsList = Get-List -Context $adminContext -ListTitle $ListTitle
$adminContext.Load($settingsList)
$adminContext.ExecuteQuery();

$query = New-Object Microsoft.SharePoint.Client.CamlQuery
$query.ViewXml = "<View>
    <RowLimit></RowLimit>
</View>"
$listItems = $settingsList.GetItems($query)
$adminContext.Load($listItems)
$adminContext.ExecuteQuery();

$instance = $listItems | Where-Object {$_["URL"] -eq $Site.ToLower()}

if ($instance -eq $null) {
  $listItemInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
  $mastheadURLItem = $settingsList.AddItem($listItemInfo)
  $mastheadURLItem["URL"] = $Site.ToLower()
  $mastheadURLItem["Title"] = "masthead-url";
  $mastheadURLItem.Update()
  $settingsList.Update()
  try {
    $adminContext.ExecuteQuery()
  }
  catch {
    "Error adding to list"
  }
} else {
  "Already on list, exiting..."
}