<cfparam name="attributes.topicid" default="">
<cfparam name="attributes.reply" default="">
<cfparam name="attributes.special_definition" default="">
<cfparam name="attributes.attach_topic_file" default="">
<cfparam name="attributes.first_hie" default="">

<cfset response = structNew()>
<cfset response.status = true>
<cfset response.message = "<cf_get_lang dictionary_id='55040'>">
<cfset replys = CreateObject("component","V16.forum.cfc.reply").init(dsn = application.systemParam.systemParam().dsn)>
<cfset domain = structNew()>
<cfset domain.user_domain = "#application.systemParam.systemParam().fusebox.server_machine_list#/">
<cfset domain.partner_domain = partner_domain>
<cfset domain.public_domain = public_domain>
<cfset file_name = "">
<cfinclude template="get_badwords.cfm">
<cfif len(badword_list)>
	<cfloop query="get_badwords">
		<cfif attributes.reply contains get_badwords.word>
			<cfset response.message = "#getLang('forum',37)# #getLang('forum',18)# : #WORD#">			
			<cfset response.status = false />		
		</cfif>
	</cfloop>
</cfif>

<cfset fileFullName = ''>
<cfset file_name = ''>
<!---
<cfif isdefined("attributes.attach_reply_file") and len(attributes.attach_reply_file)>
	<cftry>
			<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="attach_reply_file" destination="#upload_folder#forum#dir_seperator#">
			<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
			<cffile action="rename" source="#upload_folder#forum#dir_seperator##cffile.serverfile#" destination="#upload_folder#forum#dir_seperator##file_name#">
			<!---Script dosyalarını engelle  02092010 ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#upload_folder#forum#dir_seperator##file_name#">
				<cfset response.message ="<cf_get_lang no ='1.\php\,\jsp\,\asp\,\cfm\,\cfml\ Formatlarında Dosya Girmeyiniz!!'>">
				<cfset response.status = false />
			</cfif>
			<cfset fileFullName = "#upload_folder#forum#dir_seperator##file_name#">
		<cfcatch type="any">	
			<cfset response.message = "<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !">
			<cfset response.status = false>
		</cfcatch>
	</cftry>
</cfif>--->

<cfif response.status>

	<cfset addReply =  replys.insert(
								forumid				:	attributes.forumid,
								topicid				:	attributes.topicid,
								reply				:	attributes["reply" & "_" & attributes.topicid],
								<!---special_definition	:	attributes.special_definition,--->
								fileFullName		:	"#fileFullName#",
								file_name			:	"#file_name#",
								server_machine		: 	"#fusebox.server_machine#",
								domain				:	domain
								) >

	<!--- <cfif addReply>
		<cfset response.status = true>
	<cfelse>
		<cfset response.status = false>
		<cfset response.message = "#getLang('main','24')#">
	</cfif> --->

</cfif>
<cfoutput>#replace(serializeJson(response),"//","")#</cfoutput>
<cfquery name="control" datasource="#dsn#">
	SELECT TOPICID FROM FORUM_TOPIC WHERE FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.forumid#">
</cfquery>
<cfif control.recordcount gt 1>
	<cfquery name="control2" datasource="#dsn#">
		SELECT TOPICID FROM FORUM_REPLYS WHERE TOPICID =(SELECT MIN(TOPICID) FROM FORUM_TOPIC WHERE FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.forumid#">)
	</cfquery>
	<cfif control2.topicid neq attributes.topicid>
		<script>
			location.href=document.referrer;
		</script>
	</cfif>
</cfif>