<!---E.Y 22.08.2012 queryparam ifadeleri eklendi.--->
<cfset mailfrom_ = "#session.ep.company#<#session.ep.company_email#>">
<cfinclude template="get_badwords.cfm">
<cfif len(badword_list)>
	<cfloop query="get_badwords">
		<cfif attributes.reply contains get_badwords.word>
				<script type="text/javascript">
					alert("<cf_get_lang no='20.Yazdığınız Mesaj Sistem Yöneticisi Tarafından Yasaklanan Kelime İçeriyor !'><cf_get_lang no='18.Kelime'>: <cfoutput>#word#</cfoutput>");
					window.history.go(-1);
				</script>
				<cfabort>			
		</cfif>
	</cfloop>
</cfif>

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
<cflock timeout="20">
<cftransaction>
    <cfquery name="ADD_REPLY" datasource="#DSN#" result="MAX_ID">
        INSERT INTO 
            FORUM_REPLYS 
            (
				TOPICID, 
				USERKEY, 
				REPLY,
				VERIFIED,
				<cfif isdefined("attributes.attach_reply_file") and len(attributes.attach_reply_file)>
					FORUM_REPLY_FILE,
					FORUM_REPLY_FILE_SERVER_ID,
				</cfif>
				IS_ACTIVE,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP,
				UPDATE_DATE,
				UPDATE_IP,
				UPDATE_EMP
            )
       		VALUES  
            (
				#TOPICID#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERKEY#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#REPLY#">,
				1,
				<cfif isdefined("attributes.attach_reply_file") and len(attributes.attach_reply_file)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#">,
					#fusebox.server_machine#,
				</cfif>
				1,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#SESSION.EP.USERID#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#SESSION.EP.USERID#
            )
    </cfquery>
    <cfquery name="UPD_" datasource="#DSN#">
    	UPDATE
        	FORUM_REPLYS
        SET
        	<cfif isdefined("attributes.first_hie") and len(attributes.first_hie)>
				HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.first_hie#.#MAX_ID.IDENTITYCOL#">,
				MAIN_HIERARCHY = #listfirst(attributes.first_hie,'.')#
            <cfelse>
            	HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MAX_ID.IDENTITYCOL#">,
				MAIN_HIERARCHY = #MAX_ID.IDENTITYCOL#
			</cfif>
        WHERE
        	REPLYID = #MAX_ID.IDENTITYCOL#
    </cfquery>
</cftransaction>
</cflock>
<cfquery name="EMAIL_EMPS" datasource="#DSN#">
	SELECT EMAIL_EMPS, TITLE FROM FORUM_TOPIC WHERE TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
</cfquery>
<cfif not isdefined("email_emp")><cfset email_emp = 0></cfif>
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
<cfquery name="UPD_EMP_EMAIL_ALERTS" datasource="#DSN#">
	UPDATE
		FORUM_TOPIC
	SET
		EMAIL_EMPS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NEW_EMAILS#">
	WHERE
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
</cfquery>
<cfquery name="FORUMID" datasource="#DSN#">
	SELECT
		FORUM_MAIN.FORUMID
	FROM
		FORUM_MAIN,
		FORUM_TOPIC
	WHERE
		FORUM_MAIN.FORUMID = FORUM_TOPIC.FORUMID AND
		FORUM_TOPIC.TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
</cfquery>
<cfquery name="UPD_FORUM_LAST_MSG_DATE" datasource="#DSN#">
	UPDATE
		FORUM_MAIN
	SET
		LAST_MSG_DATE = #now()#,
		LAST_MSG_USERKEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERKEY#">,
		REPLY_COUNT = REPLY_COUNT + 1
	WHERE
		FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#forumid.forumid#">
</cfquery>
<cfquery name="UPD_TOPIC_LAST_REPLY_DATE" datasource="#DSN#">
	UPDATE
		FORUM_TOPIC
	SET
		LAST_REPLY_DATE = #now()#,
		LAST_REPLY_USERKEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERKEY#">,
		REPLY_COUNT = REPLY_COUNT + 1
	WHERE
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
</cfquery>
<!--- alert email at--->
<cfquery name="EMAIL_IDS" datasource="#DSN#">
	SELECT
		EMAIL_EMPS,
		EMAIL_PARS,
		EMAIL_CONS
	FROM
		FORUM_TOPIC
	WHERE
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
</cfquery>
<!--- Objects ten logo ve bilgiler --->
<cfsavecontent variable="ust">
	<cfinclude template="../../objects/display/view_company_logo.cfm"></cfsavecontent>
<cfsavecontent variable="alt">
	<cfinclude template="../../objects/display/view_company_info.cfm"></cfsavecontent>
<cfset alt = ReplaceList(alt,'#chr(39)#','')>
<cfset alt = ReplaceList(alt,'#chr(10)#','')>
<cfset alt = ReplaceList(alt,'#chr(13)#','')>
<cfset ust = ReplaceList(ust,'#chr(39)#','')>
<cfset ust = ReplaceList(ust,'#chr(10)#','')>
<cfset ust = ReplaceList(ust,'#chr(13)#','')>
<!--- Objects ten logo ve bilgiler --->
<cfif len(email_ids.email_emps)>
	<cfquery name="EMP_EMAILS" datasource="#DSN#">
		SELECT 
			EMPLOYEE_EMAIL AS EMAIL
		FROM
			EMPLOYEES
		WHERE
			EMPLOYEE_ID IN (#email_ids.email_emps#)
			AND
			EMPLOYEE_EMAIL <> ''
	</cfquery>
	<cfloop query="emp_emails">
		<cfmail from="#mailfrom_#" to="#email#" subject="#email_emps.title# !" type="HTML">
		<cfinclude template="add_reply_mail.cfm">
			<table width="590" align="center">
				<tr>
					<td>
						<a href="#user_domain##request.self#?fuseaction=forum.view_reply&topicid=#topicid#" class="tableyazi">#email_emps.title#</a><br/><br/>
					</td>
				</tr>
			</table>
			#alt#
		</cfmail>
	</cfloop>
</cfif>
<cfif len(email_ids.email_pars)>
	<cfquery name="PAR_EMAILS" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_EMAIL AS EMAIL
		FROM
			COMPANY_PARTNER
		WHERE
			PARTNER_ID IN (#email_ids.email_pars#)
			AND
			COMPANY_PARTNER_EMAIL <> ''
	</cfquery>
	<cfloop query="par_emails">
		<cfmail from="#mailfrom_#" to="#email#" subject="#email_emps.title# !" type="HTML">
			<cfinclude template="add_reply_mail.cfm">
			<table width="590" align="center">
				<tr>
					<td>
						<a href="#partner_domain##request.self#?fuseaction=forum.view_reply&topicid=#topicid#" class="tableyazi">#email_emps.title#</a><br/><br/>
					</td>
				</tr>
			</table>
			#alt#
		</cfmail>
	</cfloop>
</cfif>
<cfif len(email_ids.email_cons)>
	<cfquery name="CON_EMAILS" datasource="#DSN#">
		SELECT 
			CONSUMER_EMAIL AS EMAIL
		FROM
			CONSUMER
		WHERE
			CONSUMER_ID IN (#email_ids.email_cons#)
			AND
			CONSUMER_EMAIL <> ''
	</cfquery>
	<cfloop query="con_emails">
		<cfmail from="#mailfrom_#" to="#email#" subject="#email_emps.title# !" type="HTML">
			<cfinclude template="add_reply_mail.cfm">
			<table width="590" align="center">
				<tr>
					<td><a href="#public_domain##request.self#?fuseaction=forum.view_reply&topicid=#topicid#" class="tableyazi">#email_emps.title#</a><br/><br/></td>
				</tr>
			</table>
			#alt#
		</cfmail>
	</cfloop>
</cfif>
<cflocation url="#request.self#?fuseaction=forum.view_reply&topicid=#topicid#" addtoken="No">
