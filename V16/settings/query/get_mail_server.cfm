<cfset get_mail_server = createObject("component","V16.settings.cfc.mail_server_settings")>
<cfset Select =get_mail_server.Select(
server_name_id:attributes.server_name_id
)/>
