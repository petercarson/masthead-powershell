[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll'

$UserName = "admin@itgroovedeveloper.onmicrosoft.com"
$Password = "itgD3v!!!"
$Url = "https://itgroovedeveloper.sharepoint.com/sites/masthead-app-dev/"
$ListTitle = "masthead-app-settings"
$Site = "https://itgroovedeveloper.sharepoint.com/sites/CustomCommunicationSite"

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
$caMasthead.Name = "Masthead"
$caMasthead.Title = "s-masthead-spx"
$caMasthead.Group = ""
$caMasthead.Description = "Masthead for sharepoint"
$caMasthead.Location = "ClientSideExtension.ApplicationCustomizer"
$caMasthead.ClientSideComponentId = "27b0cb87-695b-4405-ae63-9db7d67e1029"
$caMasthead.Update()

$siteContext.ExecuteQuery()
# {
#   Name = caName,
#   Title = caTitle,
#   Group = "",
#   Description = caDescription,
#   Location = caLocation,
#   ClientSideComponentId = caComponentId
# };
# CustomActionEntity caMastheadClassic = new CustomActionEntity
# {
#   Name = caClassicName,
#   Title = caClassicTitle,
#   Group = "",
#   Description = caClassicDescription,
#   Location = caClassicLocation,
#   Sequence = caClassicSequence,
#   ScriptBlock = caClassicScriptpt1 + contexts.BaseContext.Url + caClassicScriptpt2
# };

# var web = context.Web;
# context.Load(web);

# web.AddCustomAction(caMasthead);

# try {
#   web.AddCustomAction(caMastheadClassic);
# }
# catch {
# }

# try {
#   context.ExecuteQueryRetry();
#   return true;
# }
# catch {
#   return false;
# }


# CamlQuery camlQuery = CamlQuery.CreateAllItemsQuery();
# ListItemCollection items = mastheadList.GetItems(camlQuery);
# contexts.BaseContext.Load(items);
# contexts.BaseContext.ExecuteQueryRetry();

# foreach (var site in sites)
# {

# var context = _getContextForSite(url);
# var masthead = _getMastheadActionsFromContext(context);

# if (masthead.Count() == 0)
# {
#     using (context)
#     {

#         CustomActionEntity caMasthead = new CustomActionEntity
#         {
#             Name = caName,
#             Title = caTitle,
#             Group = "",
#             Description = caDescription,
#             Location = caLocation,
#             ClientSideComponentId = caComponentId
#         };
#         CustomActionEntity caMastheadClassic = new CustomActionEntity
#         {
#             Name = caClassicName,
#             Title = caClassicTitle,
#             Group = "",
#             Description = caClassicDescription,
#             Location = caClassicLocation,
#             Sequence = caClassicSequence,
#             ScriptBlock = caClassicScriptpt1 + contexts.BaseContext.Url + caClassicScriptpt2
#         };

#         var web = context.Web;
#         context.Load(web);

#         web.AddCustomAction(caMasthead);

#         try
#         {
#             web.AddCustomAction(caMastheadClassic);
#         } catch
#         {
#         }

#         try
#         {
#             context.ExecuteQueryRetry();
#             return true;
#         } catch
#         {
#             return false;
#         }
#     }
# }


# var existingItem = items.FirstOrDefault(item => item["URL"] as string == URL);

# if (existingItem == null) {
#   ListItemCreationInformation itemCreateInfo = new ListItemCreationInformation();
#   ListItem mastheadURLItem = list.AddItem(itemCreateInfo);
#   mastheadURLItem["URL"] = URL.ToLower();
#   mastheadURLItem["Title"] = title;
#   mastheadURLItem.Update();
#   list.Update();
#   try {
#     context.ExecuteQueryRetry();
#     return true;
#   }
#   catch {
#     return false;
#   }
# }
# return false;
# }