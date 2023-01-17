<cfparam name="attributes.email_emp" default="">
<cfparam name="attributes.locked" default="">
<cfparam name="attributes.email" default="">

<cfset response = StructNew()>
<cfset response.status = true>
<cfset response.message = "#getLang('forum',74)#">

<cfset topicCFC = CreateObject("component","V16.forum.cfc.topic").init(dsn = application.systemParam.systemParam().dsn)>

<cfinclude template="get_badwords.cfm">
<cfif len(badword_list)>
	<cfloop query="GET_BADWORDS">
		<cfif (attributes.topic contains GET_BADWORDS.WORD)>
			<cfset response.message = "#getLang('forum',37)# #getLang('forum',18)# : #WORD#">			
			<cfset response.status = false />
		</cfif>
	</cfloop>
</cfif>
<cfquery name="get_forum" datasource="#dsn#">
	SELECT FORUMNAME,FORUMID FROM FORUM_MAIN WHERE FORUMID = #attributes.FORUMID#
</cfquery>
<cfif not get_forum.recordcount>
	<cfset response.message = "#getLang('forum',68)#!">
	<cfset response.status = false />
</cfif>

<cfset from_mail='#session.ep.company#<#session.ep.company_email#>'>
<cfset fileFullName = ''>
<cfset file_real_name = ''>
<cfset file_name = ''>

<cfif isdefined("attributes.attach_topic_file1") and len(attributes.attach_topic_file1)>
	<cftry>
		<cfif not DirectoryExists("#upload_folder#forum")>
			<cfdirectory action="create" directory="#upload_folder#forum">
		</cfif>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="attach_topic_file1" destination="#upload_folder#forum#dir_seperator#">
		<cfset file_real_name = "#cffile.SERVERFILENAME#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder#forum#dir_seperator##cffile.serverfile#" destination="#upload_folder#forum#dir_seperator##file_name#">
		<!---Script dosyalarını engelle  02092010 ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#forum#dir_seperator##file_name#">
			<cfset response.message = "<cf_get_lang no='1.\php\,\jsp\,\asp\,\cfm\,\cfml\ Formatlarında Dosya Girmeyiniz!!'>">
			<cfset response.status = false />
		</cfif>
		<cfset fileFullName = "#upload_folder#forum#dir_seperator##file_name#">
	<cfcatch type="any">
		<cfset response.message = "<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !">
		<cfset response.status = false>
	</cfcatch>
	</cftry>
</cfif>

<cfif response.status>
	<cfset result = topicCFC.insert(
						forumid:attributes.forumid,
						forumname:'#get_forum.forumname#',
						topic:attributes.topic,
						locked:	"#iif(isDefined('locked'),1,DE('0'))#",
						fileFullName:	"#fileFullName#",
						file_real_name:	"#file_real_name#",
						file_name:	"#file_name#",
						server_machine: "#fusebox.server_machine#",
						topic_status: "#iif(isDefined('topic_status'),1,DE('0'))#",
						email:"#iif(isdefined("attributes.email") and len(attributes.email),attributes.email,DE(''))#",
						email_emp:	"#iif(isDefined('email_emp'),1,DE('0'))#",
						from_mail:from_mail,
						user_domain:"#application.systemParam.systemParam().fusebox.server_machine_list#/"
						)>
	<cfif result eq false>
		<cfset response.message = "#getLang('forum',55)#">
		<cfset response.status = false />	
	</cfif>				
</cfif>
<cfquery name="control_formid" datasource="#dsn#">
	SELECT FORUMID FROM FORUM_TOPIC WHERE FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.forumid#">
</cfquery>
<cfif control_formid.recordcount neq 1>
	<script>
		location.href=document.referrer;
	</script> 
</cfif>
<cfoutput>#Replace(SerializeJSON(response),'//','')#</cfoutput>