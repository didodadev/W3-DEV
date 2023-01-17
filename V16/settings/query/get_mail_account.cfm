<cfset get_mail_account = createObject("component","V16.settings.cfc.mail_account_settings")>
<cfset Select =get_mail_account.Select(
MAIL_ACCOUNT_ID : attributes.mail_account_id
)/>
<cfset GET_MAIL_SERVER = createObject("component","V16.settings.cfc.mail_account_settings")>
<cfset SelectSN =get_mail_account.SelectSN(
SERVER_NAME_ID : attributes.SERVER_NAME_ID
)/>