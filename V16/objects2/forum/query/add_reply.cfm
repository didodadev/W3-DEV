<cfif not len(attributes.reply)>
	<script type="text/javascript">
		alert("Lütfen açıklama alanını doldurunuz!");
		history.back(-1);
	</script>	
    <cfabort>	
</cfif>
<cfif isdefined("attributes.attach_reply_file") and len(attributes.attach_reply_file)>
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

<cfinclude template="get_badwords.cfm">
<cfif len(badword_list)>
	<cfset reply = replacenocase(reply,badword_list,star_list)>
</cfif>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
        <cfquery name="ADD_REPLY" datasource="#DSN#">
            INSERT INTO 
                FORUM_REPLYS 
                (
                    TOPICID, 
                    RELATION_REPLYID,
                    REPLY,
                    IMAGEID,
                    USERKEY,
                    VERIFIED,
                    <cfif isdefined("attributes.attach_reply_file") and len(attributes.attach_reply_file)>
                        FORUM_REPLY_FILE,
                        FORUM_REPLY_FILE_SERVER_ID,
                    </cfif>
                    RECORD_DATE,
                    RECORD_IP,
                    UPDATE_DATE,
                    UPDATE_IP,
                    <cfif isdefined("session.pp.userid")>
                        UPDATE_PAR
                    <cfelse>
                        UPDATE_CON
                    </cfif>
                )
            VALUES  
                (
                    #topicid#,
                    <cfif isdefined("attributes.replyid") and len(attributes.replyid)>#replyid#,<cfelse>NULL,</cfif>
                    '#reply#',
                    #imageid#,
                    <cfif isdefined("session.pp.userid")>
                        '#session.pp.userkey#',
                    <cfelseif isdefined("session.ww.userid")>
                        '#session.ww.userkey#',
                    </cfif>
                    1,
                    <cfif isdefined("attributes.attach_reply_file") and len(attributes.attach_reply_file)>
                        '#file_name#',
                        #fusebox.server_machine#,
                    </cfif>
                    #now()#,
                    '#CGI.REMOTE_ADDR#',
                    #now()#,
                    '#CGI.REMOTE_ADDR#',
                    <cfif isdefined("session.pp.userid")>
                        #session.pp.userid#
                    <cfelseif isdefined("session.ww.userid")>
                        #session.ww.userid#
                    </cfif>
                )
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
	<cfif isdefined("session.ww.userid") and listfindnocase(new_emails,session.ww.userid) neq 0>
		<cfset new_emails = listdeleteat(new_emails,listfindnocase(new_emails,session.ww.userid))>
	<cfelseif isdefined("session.pp.userid") and listfindnocase(new_emails,session.pp.userid) neq 0>
		<cfset new_emails = listdeleteat(new_emails,listfindnocase(new_emails,session.pp.userid))>
	</cfif>
</cfif>
<cfif isdefined("session.ep.userid")>
	<cfset sender = "#session.ep.company#<#session.ep.company_email#>">
<cfelseif isdefined("session.ww.userid")>
	<cfset sender = "#session.ww.our_name#<#session.ww.our_company_email#>">
<cfelseif isdefined("session.pp.userid")>
	<cfset sender = "#session.pp.our_name#<#session.pp.our_company_email#>">
</cfif>

<cfquery name="UPD_EMP_EMAIL_ALERTS" datasource="#DSN#">
	UPDATE
		FORUM_TOPIC
	SET
		EMAIL_EMPS = '#new_emails#'
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
		REPLY_COUNT = REPLY_COUNT+1
	WHERE
		FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#forumid.forumid#">
</cfquery>
	
<cfquery name="UPD_TOPIC_LAST_REPLY_DATE" datasource="#DSN#">
	UPDATE
		FORUM_TOPIC
	SET
		LAST_REPLY_DATE = #now()#,
		REPLY_COUNT = REPLY_COUNT+1
	WHERE
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
</cfquery>

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

<cfif len(email_ids.email_emps)>
	<cfquery name="EMP_EMAILS" datasource="#DSN#">
		SELECT 
			EMPLOYEE_EMAIL AS EMAIL
		FROM
			EMPLOYEES
		WHERE
			EMPLOYEE_ID IN (#email_ids.email_emps#) AND
			EMPLOYEE_EMAIL <> ''
	</cfquery>
	
	<cfloop query="emp_emails">
		<cfmail from="#sender#" to="#email#" subject="#email_emps.title# !" type="HTML">
			Forumdaki #email_emps.title# konusuna yeni cevap eklendi !
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
			PARTNER_ID IN (#email_ids.email_pars#) AND
			COMPANY_PARTNER_EMAIL <> ''
	</cfquery>
	
	<cfloop query="par_emails">
		<cfmail from="#sender#" to="#email#" subject="#email_emps.title# !" type="HTML">
			Forumdaki #email_emps.title# konusuna yeni cevap eklendi !
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
		<cfmail from="#sender#" to="#email#" subject="#email_emps.title# !" type="HTML">
			Forumdaki #email_emps.title# konusuna yeni cevap eklendi !
		</cfmail>
	</cfloop>
</cfif>		

<script type="text/javascript">
	<cfoutput>
		alert("<cf_get_lang no ='571.Kaydınız Başarıyla Alınmıştır !'>");
		window.location.href='#request.self#?fuseaction=objects2.view_reply&topicid=#topicid#';
	</cfoutput>
</script>
