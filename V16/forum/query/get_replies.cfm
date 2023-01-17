<cfparam name="attributes.startrow" default="1">
<cfset response = structNew()>
<cfset replyCFC = CreateObject("component","V16.forum.cfc.reply").init(dsn = application.systemParam.systemParam().dsn)>
<cfset userinfo = CreateObject("component","V16.forum.cfc.userinfo")>
<cfset REPLIES = replyCFC.select(topicid:attributes.topicid,startrow:attributes.startrow,maxrows:5)><!--- maks. 5 kayıt listele --->
<cfif REPLIES.recordcount>
	<cfset response.count = REPLIES.recordcount>
	<cfset response.status = true>
	<cfoutput query="REPLIES">
		<cfset get_user_info = userinfo.get_user_info(userkey:REPLIES.USERKEY)>

		<cfset response.data[currentRow]["TOPICID"] = REPLIES.TOPICID>
		<cfset response.data[currentRow]["REPLY"] = REPLIES.REPLY>
		<cfset response.data[currentRow]["HIERARCHY"] = REPLIES.HIERARCHY>
		<cfset response.data[currentRow]["UPDATE_DATE"] = REPLIES.UPDATE_DATE>
		<cfset response.data[currentRow]["REPLYID"] = REPLIES.REPLYID>
		<cfset response.data[currentRow]["REPLYDATE"] = "#dateformat(date_add('h',session.ep.time_zone,REPLIES.RECORD_DATE),'dd/mm/yyyy')#  #timeformat(date_add('h',session.ep.time_zone,REPLIES.RECORD_DATE),'HH:MM')#">
		<cfset response.data[currentRow]["REPLYUPDATELINK"] = "index.cfm?fuseaction=forum.popup_form_upd_reply&forumid=#attributes.forumid#&replyid=#REPLIES.REPLYID#">
		<cfset response.data[currentRow]["FORUM_REPLY_FILE"] = REPLIES.FORUM_REPLY_FILE>
		<cfset response.data[currentRow]["FORUM_REPLY_FILE_SERVER_ID"] = REPLIES.FORUM_REPLY_FILE_SERVER_ID>
		<cfset response.data[currentRow]["SPECIAL_DEFINITION_ID"] = REPLIES.SPECIAL_DEFINITION_ID>
		<cfset response.data[currentRow]["IMAGEID"] = REPLIES.IMAGEID>
		<cfset response.data[currentRow]["MAIN_HIERARCHY"] = REPLIES.MAIN_HIERARCHY>
		<cfset response.data[currentRow]["USERINFO"]["NAME"] = get_user_info.name>
		<cfset response.data[currentRow]["USERINFO"]["SURNAME"] = get_user_info.surname>
		<cfif len(get_user_info.photo) and FileExists("./documents/hr/#get_user_info.photo#")>
			<cfset resimurl = "./documents/hr/#get_user_info.photo#">
		<cfelse>
			<cfset resimurl = "#mid(get_user_info.name,1,1)##mid(get_user_info.surname,1,1)#">
		</cfif>
		<cfset response.data[currentRow]["USERINFO"]["PHOTO"] = resimurl>
		<cfif listfirst(REPLIES.USERKEY,"-") is "e">
			<cfset response.data[currentRow]["USERINFO"]["MODAL"]= "#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listlast(REPLIES.USERKEY,"-")#">
		<cfelseif listfirst(REPLIES.USERKEY,"-") is "p">
			<cfset response.data[currentRow]["USERINFO"]["MODAL"] = "#request.self#?fuseaction=objects.popup_par_det&par_id=#listlast(REPLIES.USERKEY,"-")#">
		<cfelseif listfirst(REPLIES.USERKEY,"-") is "c">
			<cfset response.data[currentRow]["USERINFO"]["MODAL"] = "#request.self#?fuseaction=objects.popup_con_det&cons_id=#listlast(REPLIES.USERKEY,"-")#">
		</cfif>

	</cfoutput>
<cfelse>
	<cfset response.status = false>
</cfif>
<cfoutput>#replace(SerializeJson(response),"//","")#</cfoutput>