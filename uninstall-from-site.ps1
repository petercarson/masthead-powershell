[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll'

$UserName = "admin@itgroovedeveloper.onmicrosoft.com"
$Password = "itgD3v!!!"
$Url = "https://itgroovedeveloper.sharepoint.com/sites/masthead-app-dev/"
$Site = "https://itgroovedeveloper.sharepoint.com/sites/CustomCommunicationSite"

$ListTitle = "masthead-app-settings"
$caClassicSequence = 4884
$caComponentId = "27b0cb87-695b-4405-ae63-9db7d67e1029"

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

Function Get-Masthead-Actions-From-Context([Microsoft.SharePoint.Client.ClientContext]$Context) {

  $siteActions = $Context.Site.UserCustomActions
  $webActions = $Context.Web.UserCustomActions

  $Context.Load($siteActions)
  $Context.Load($webActions)
  $Context.ExecuteQuery()

  $mastheadWeb = $webActions | Where-Object {$_.ClientSideComponentId -eq $caComponentId -or $_.Sequence -eq $caClassicSequence}
  $mastheadSite = $siteActions | Where-Object {$_.ClientSideComponentId -eq $caComponentId -or $_.Sequence -eq $caClassicSequence}

  if ($mastheadWeb -ne $null -And $mastheadSite -ne $null) {
    $mastheadWeb + $mastheadSite
  }
  if ($mastheadWeb -ne $null){
    $mastheadWeb
  }
  if ($mastheadSite -ne $null) {
    $mastheadSite
  }

}

$adminContext = Get-Context-For-Site -siteURL $url -UserName $UserName -Password $Password
$siteContext = Get-Context-For-Site -siteURL $Site -UserName $UserName -Password $Password

$actions = Get-Masthead-Actions-From-Context -Context $siteContext

$actions.Count

Foreach($action in $actions) {
  $action.DeleteObject()
}
$siteContext.Web.Update()
$siteContext.ExecuteQuery()

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

Foreach($item in $instance) {
  $item["URL"]
  $item.DeleteObject()
}

$adminContext.Web.Update()
$adminContext.ExecuteQuery()