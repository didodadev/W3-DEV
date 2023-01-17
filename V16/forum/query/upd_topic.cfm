<cfinclude template="get_badwords.cfm">
<cfif len(badword_list)>
	<cfloop query="GET_BADWORDS">
		<cfif (attributes.topics contains GET_BADWORDS.WORD)>
				<script type="text/javascript">
					alert("<cf_get_lang no='20.Yazdığınız Mesaj Sistem Yöneticisi Tarafından Yasaklanan Kelime İçeriyor'><cf_get_lang no='18.Kelime'>: <cfoutput>#WORD#</cfoutput>");
					window.history.go(-1);
				</script>
				<cfabort>			
		</cfif>
	</cfloop>
</cfif>

<cfif not isdefined("locked")>
	<cfset locked = 0>
</cfif>
<cfif not isDefined("email_emp")>
	<cfset email_emp = 0>
</cfif>
<cfif isdefined("attributes.delete")>
       <cfif fileexists("#upload_folder#forum#dir_seperator##attributes.topic_attach#")>
	        <!---   <cffile action="delete" file="#upload_folder#forum#dir_seperator##attributes.topic_attach#"> --->
			   <cf_del_server_file output_file="forum/#attributes.topic_attach#" output_server="#attributes.topic_attach_server_id#">
	   </cfif>
	   <cfset file_real_name = "">
	   <cfset file_name = "">
</cfif>
<cfif isdefined("attributes.attach_topic_file") and len(attributes.attach_topic_file)>
    <cfif len(attributes.topic_attach)>
	   <cfif fileexists("#upload_folder#forum#dir_seperator##attributes.topic_attach#")>
	          <!--- <cffile action="delete" file="#upload_folder#forum#dir_seperator##attributes.topic_attach#"> --->
			  <cf_del_server_file output_file="forum/#attributes.topic_attach#" output_server="#attributes.topic_attach_server_id#">
	   </cfif>
	</cfif>
	<cftry>
		<cfif not DirectoryExists("#upload_folder#forum")>
			<cfdirectory action="create" directory="#upload_folder#forum">
		</cfif>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="attach_topic_file" destination="#upload_folder#forum#dir_seperator#">
		<cfset file_real_name = "#cffile.SERVERFILENAME#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder#forum#dir_seperator##cffile.serverfile#" destination="#upload_folder#forum#dir_seperator##file_name#">
		<!---Script dosyalarını engelle  02092010 ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#forum#dir_seperator##file_name#">
			<script type="text/javascript">
				alert("<cf_get_lang no ='1.\php\,\jsp\,\asp\,\cfm\,\cfml\ Formatlarında Dosya Girmeyiniz!!'>");
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfcatch type="any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
			history.back();
		</script>
	</cfcatch>
	</cftry>
</cfif>
<cfquery name="EMAIL_EMPS" datasource="#dsn#">
	SELECT
		EMAIL_EMPS
	FROM
		FORUM_TOPIC
	WHERE
		TOPICID = #attributes.TOPICID#
</cfquery>
<!--- istek varsa email listesine ekle --->
<cfset new_emails = valuelist(email_emps.email_emps)>
<cfif email_emp neq 0>
<!--- listede yoksa ekle --->
	<cfif listfindnocase(new_emails,email_emp) eq 0>
		<cfset new_emails = listappend(new_emails,email_emp)>
	</cfif>
<cfelse>
<!--- listede varsa çıkar --->
	<cfif listfindnocase(new_emails,session.ep.userid) neq 0>
		<cfset new_emails = listdeleteat(new_emails,listfindnocase(new_emails,session.ep.userid))>
	</cfif>
</cfif>
<cfquery name="UPD_TOPIC" datasource="#dsn#">
	UPDATE 
		FORUM_TOPIC 
	SET
		<!---IMAGEID = #IMAGEID#,--->
		TOPIC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TOPICS#">,
		TOPIC_STATUS=<cfif isdefined('attributes.topic_status')>1<cfelse>0</cfif>,
		VERIFIED = 1,
		LOCKED = #LOCKED#,
		EMAIL_EMPS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NEW_EMAILS#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
		<cfif (isdefined("attributes.attach_topic_file") and len(attributes.attach_topic_file)) or isdefined("attributes.delete")>		
		,FORUM_TOPIC_REAL_FILE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_real_name#">
		,FORUM_TOPIC_FILE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#">
		,FORUM_TOPIC_FILE_SERVER_ID=#fusebox.server_machine#
		</cfif>		
	WHERE
		TOPICID = #attributes.TOPICID#
</cfquery>
<cflocation url="#request.self#?fuseaction=forum.view_topic&forumid=#attributes.forumid#" addtoken="No">
