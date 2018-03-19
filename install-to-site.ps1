[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll'

$UserName = "admin@itgroovedeveloper.onmicrosoft.com"
$Password = "itgD3v!!!"
$Url = "https://itgroovedeveloper.sharepoint.com/sites/masthead-app-dev/"
$ListTitle = "masthead-app-settings"

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

$context = New-Object Microsoft.SharePoint.Client.ClientContext($Url)
$context.Credentials = Get-SPOCredentials -UserName $UserName -Password $Password

$list = Get-List -Context $context -ListTitle $ListTitle

$list.Title

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