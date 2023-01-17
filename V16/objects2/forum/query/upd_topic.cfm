<cfif isdefined("attributes.attach_topic_file") and len(attributes.attach_topic_file)>
    <cfif len(attributes.topic_attach)>
	   <cfif fileexists("#upload_folder#forum#dir_seperator##attributes.topic_attach#")>
			 <cf_del_server_file output_file="forum/#attributes.topic_attach#" output_server="#attributes.topic_attach_server_id#">
	   </cfif>
	</cfif>
	<cftry>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="attach_topic_file" destination="#upload_folder#forum#dir_seperator#">
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

<cfquery name="CONTROL" datasource="#dsn#">
	SELECT 
		TOPICID 
	FROM 
		FORUM_TOPIC
	WHERE 
		TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.title#">
</cfquery>

<cfif control.recordcount gt 1>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1497.Bu Başlık Kullanılıyor Lütfen geri dönüp kontrol ediniz'>..");
		history.back();
	</script>
</cfif>

<cfif not isdefined("locked")>
	<cfset locked = 0>
</cfif>

<cfif not isDefined("email_emp")>
	<cfset email_emp = 0>
</cfif>

<cfquery name="EMAIL_EMPS" datasource="#dsn#">
	SELECT
		EMAIL_EMPS
	FROM
		FORUM_TOPIC
	WHERE
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
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
	<cfif len(new_emails) and listfindnocase(new_emails,session.ww.userid) neq 0>
		<cfset new_emails = listdeleteat(new_emails,listfindnocase(new_emails,session.ww.userid))>
	</cfif>
</cfif>

<cfinclude template="get_badwords.cfm">
<cfif len(badword_list)>
	<cfset topic = replacenocase(topic, badword_list, star_list)>
</cfif>

<cfif isdefined("attributes.delete")>
       <cfif fileexists("#upload_folder#forum#dir_seperator##attributes.topic_attach#")>
			  <cf_del_server_file output_file="forum/#attributes.topic_attach#" output_server="#attributes.topic_attach_server_id#">
	   </cfif>
	   <cfset file_name = "">
</cfif>

<cfif isdefined("attributes.attach_topic_file") and len(attributes.attach_topic_file)>
    <cfif len(attributes.topic_attach)>
	   <cfif fileexists("#upload_folder#forum#dir_seperator##attributes.topic_attach#")>
			  <cf_del_server_file output_file="forum/#attributes.topic_attach#" output_server="#attributes.topic_attach_server_id#">
	   </cfif>
	</cfif>
	<cftry>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="attach_topic_file" destination="#upload_folder#forum#dir_seperator#">
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

<cfquery name="UPD_TOPIC" datasource="#dsn#">
	UPDATE 
		FORUM_TOPIC 
	SET
		FORUMID = #FORUMID#,
		IMAGEID = #IMAGEID#,
		TITLE = '#TITLE#',
		TOPIC = '#TOPIC#',
		VERIFIED = 1,
		LOCKED = #LOCKED#,
		EMAIL_EMPS = '#NEW_EMAILS#',
		UPDATE_DATE = #now()#,
		<cfif isdefined("SESSION.PP.USERID")>
			UPDATE_PAR = #SESSION.PP.USERID#,
		<cfelseif isdefined("SESSION.WW.USERID")>
			UPDATE_CON = #SESSION.WW.USERID#,
		</cfif>		
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
		<cfif (isdefined("attributes.attach_topic_file") and len(attributes.attach_topic_file)) or isdefined("attributes.delete")>		
		,FORUM_TOPIC_FILE = '#file_name#'
		,FORUM_TOPIC_FILE_SERVER_ID = #fusebox.server_machine#
        </cfif>	
	WHERE
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.view_reply&topicid=#topicid#" addtoken="No">
