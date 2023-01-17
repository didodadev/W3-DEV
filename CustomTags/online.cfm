<cfprocessingdirective suppresswhitespace='yes'><cfsetting enablecfoutputonly='yes'>
<!---
usage : 
	<cf_online id='#some_userid#' zone='ep' info_text='Mesaj Gönder'>
Parameters:
	id : mesaj gönderilecek veya online mi degil mi bakilacak kisi
	zone : pp or ep or ww (bakilacak kisinin portali)
	info_text : msj gönder butonunun yanında gözükecek text
Modifications :
	EK20040429-20040430-20040720
	AE20071017
--->
<cfif isdefined('attributes.id') and isnumeric(attributes.id) and isdefined("attributes.zone")>
	<cfquery name='GET_ONLINE' datasource='#CALLER.DSN#'>
		SELECT
			USERID
		FROM
			WRK_SESSION 
		WHERE
        	USERID = <cfqueryparam cfsqltype='cf_sql_integer' value='#attributes.id#'>
		<cfif attributes.zone is 'ep'>
			AND USER_TYPE = 0
		<cfelseif attributes.zone is 'pp'>
			AND USER_TYPE = 1
		<cfelseif attributes.zone is 'ww'>
			AND USER_TYPE = 2
		</cfif>			
	</cfquery>
	<cfif get_online.recordcount>
		<cfif attributes.zone is "ep">
			<cfoutput><a href='javascript://' onClick="openNav(#attributes.id#,'chat_page','');"><i class="fa fa-smile-o" style="color:##4caf50!important;font-size: 18px;" alt="#caller.getLang('main',1064)#" align="absmiddle"></i><cfif isDefined('attributes.info_text')>#attributes.info_text#</cfif></a></cfoutput>
		<cfelseif attributes.zone is "ww">
			<cfoutput><a href='javascript://' onClick="openNav(#attributes.id#,'chat_page','');"><i class="fa fa-smile-o" style="color:##4caf50!important;font-size: 18px;" alt="#caller.getLang('main',1064)#" align='absmiddle'></i> <cfif isDefined('attributes.info_text')>#attributes.info_text#</cfif></a></cfoutput>
		<cfelseif attributes.zone is "pp">
			<cfoutput><a href='javascript://' onClick="openNav(#attributes.id#,'chat_page','');"><i class="fa fa-smile-o" style="color:##4caf50!important;font-size: 18px;" alt="#caller.getLang('main',1064)#" align='absmiddle'></i> <cfif isDefined('attributes.info_text')>#attributes.info_text#</cfif></a></cfoutput>
		</cfif>
	<cfelse>
		<cfif attributes.zone is "ep">
			<cfoutput><a href='javascript://' onClick='send_online_emp_note(#attributes.id#);'><i class="fa fa-frown-o" style="color:red!important;font-size: 18px;" alt="#caller.getLang('main',1065)#" align='absmiddle'></i> <cfif isDefined('attributes.info_text')>#attributes.info_text#</cfif></a></cfoutput>
		<cfelseif attributes.zone is "ww">
			<cfoutput><a href='javascript://' onClick='windowopen("#request.self#?fuseaction=myportal.popup_add_message&consumer_id=#attributes.id#","small")'><i class="fa fa-frown-o" style="color:red;font-size: 21px;margin: 2px 2px;" alt="#caller.getLang('main',1065)#" align='absmiddle'></i> <cfif isDefined('attributes.info_text')>#attributes.info_text#</cfif></a></cfoutput>
		<cfelseif attributes.zone is "pp">
			<cfoutput><i class="fa fa-frown-o" style="font-size: 18px;" alt="<cf_get_lang dictionary_id='52043.Kullanıcı Online Değil!'>"></i></cfoutput>
		</cfif>
	</cfif>
</cfif>
<cfsetting enablecfoutputonly='no'></cfprocessingdirective>