<cfif isdefined("attributes.attach_reply_file") and len(attributes.attach_reply_file)>
    <cfif len(attributes.reply_attach)>
	   <cfif fileexists("#upload_folder#forum#dir_seperator##attributes.reply_attach#")>
	          <!--- <cffile action="delete" file="#upload_folder#forum#dir_seperator##attributes.reply_attach#"> --->
			   <cf_del_server_file output_file="forum/#attributes.reply_attach#" output_server="#attributes.reply_attach_server_id#">
	   </cfif>
	</cfif>
	<cftry>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="attach_reply_file" destination="#upload_folder#forum#dir_seperator#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder#forum#dir_seperator##cffile.serverfile#" destination="#upload_folder#forum#dir_seperator##file_name#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#forum#dir_seperator##file_name#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfcatch type="any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
			history.back();
		</script>
	</cfcatch>
	</cftry>
</cfif>


<cfif isdefined("attributes.delete")>
   <cfif fileexists("#upload_folder#forum#dir_seperator##attributes.reply_attach#")>
	  <!--- <cffile action="delete" file="#upload_folder#forum#dir_seperator##attributes.reply_attach#"> --->
      <cf_del_server_file output_file="forum/#attributes.reply_attach#" output_server="#attributes.reply_attach_server_id#">
   </cfif>
   <cfset file_name = "">
</cfif>

<cfquery name="EMAIL_EMPS" datasource="#DSN#">
	SELECT
		EMAIL_EMPS
	FROM
		FORUM_TOPIC
	WHERE
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
</cfquery>

<cfif not isdefined("email_emp")>
	<cfset email_emp = 0>
</cfif>

<!--- istek varsa email listesine ekle --->
<cfset new_emails = valuelist(email_emps.email_emps)>
<cfif email_emp neq 0>
<!--- listede yoksa ekle --->
	<cfif listfindnocase(new_emails,email_emp) eq 0>
		<cfset new_emails = listappend(new_emails,email_emp)>
	</cfif>
<cfelse>
<!--- listede varsa çıkar --->
	<cfif isdefined("session.ww.userid") and listfindnocase(new_emails,session.ww.userid) neq 0>
		<cfset new_emails = listdeleteat(new_emails,listfindnocase(new_emails,session.ww.userid))>
	<cfelseif isdefined("session.pp.userid") and listfindnocase(new_emails,session.pp.userid) neq 0>
		<cfset new_emails = listdeleteat(new_emails,listfindnocase(new_emails,session.pp.userid))>
	</cfif>
</cfif>

<cfquery name="UPD_EMP_EMAIL_ALERTS" datasource="#DSN#">
	UPDATE
		FORUM_TOPIC
	SET
		EMAIL_EMPS = '#new_emails#'
	WHERE
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
</cfquery>

<cfinclude template="get_badwords.cfm">
<cfif len(badword_list)>
	<cfset reply = replacenocase(reply, badword_list, star_list)>
</cfif>

<cfquery name="UPD_REPLY" datasource="#DSN#">
	UPDATE
		FORUM_REPLYS 
	SET
		REPLY = '#reply#',
		IMAGEID = <cfif isDefined('imageid')>#imageid#<cfelse>NULL</cfif>,
		VERIFIED = 1,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#',
		<cfif isdefined("session.pp.userid")>
			UPDATE_PAR = #session.pp.userid#
		<cfelse>
			UPDATE_CON = #session.ww.userid#
		</cfif>
		<cfif (isdefined("attributes.attach_reply_file") and len(attributes.attach_reply_file)) or isdefined("attributes.delete")>
        	,FORUM_REPLY_FILE = '#file_name#'
			,FORUM_REPLY_FILE_SERVER_ID=#fusebox.server_machine#
        </cfif>
	WHERE
		REPLYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.replyid#">
</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.view_reply&topicid=#topicid#" addtoken="No">
