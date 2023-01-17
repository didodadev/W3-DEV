<!---E.Y 22.08.2012 queryparam ifadeleri eklendi.--->
<cfinclude template="get_badwords.cfm">
<cfif len(badword_list)>
	<cfloop query="GET_BADWORDS">
		<cfif (attributes.topic contains GET_BADWORDS.WORD) or (attributes.TITLE contains GET_BADWORDS.WORD)>
			<script type="text/javascript">
				alert("<cf_get_lang no='20.Yazdığınız Mesaj Sistem Yöneticisi Tarafından Yasaklanan Kelime İçeriyor !'><cf_get_lang no='18.Kelime'>: <cfoutput>#WORD#</cfoutput>");
				window.history.go(-1);
			</script>
			<cfabort>			
		</cfif>
	</cfloop>
</cfif>
<cfquery name="get_forum" datasource="#dsn#">
	SELECT FORUMNAME,FORUMID FROM FORUM_MAIN WHERE FORUMID = #attributes.FORUMID#
</cfquery>
<cfif not get_forum.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='68.Açılmış Bir Forum Yok Konu Ekleyemezsiniz!'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="CONTROL" datasource="#dsn#">
	SELECT 
		TOPICID,
		RECORD_DATE
	FROM 
		FORUM_TOPIC
	WHERE 
		FORUMID = #attributes.FORUMID# AND 
		TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TITLE#">
</cfquery>

<cfif CONTROL.recordcount>
	<cfoutput>
		<script type="text/javascript">
			alert("<cf_get_lang no='6.Bu Başlık Kullanılıyor Lütfen geri dönüp kontrol ediniz !'>");
			history.back();
		</script>
		<cfabort>
	</cfoutput>
</cfif>

<cfif not isDefined("LOCKED")><cfset LOCKED = 0></cfif>
<cfif not isDefined("STATUS")><cfset STATUS = 0></cfif>
<cfif not isDefined("email_emp")><cfset email_emp = ""></cfif>
<cfset from_mail='#session.ep.company#<#session.ep.company_email#>'>
<cfif isdefined("attributes.attach_topic_file") and len(attributes.attach_topic_file)>
	<cftry>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="attach_topic_file" destination="#upload_folder#forum#dir_seperator#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder#forum#dir_seperator##cffile.serverfile#" destination="#upload_folder#forum#dir_seperator##file_name#">
		<!---Script dosyalarını engelle  02092010 ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#forum#dir_seperator##file_name#">
			<script type="text/javascript">
				alert("<cf_get_lang no='1.\php\,\jsp\,\asp\,\cfm\,\cfml\ Formatlarında Dosya Girmeyiniz!!'>");
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfcatch type="any">
	<cfdump var="#cfcatch#" >
	<cfabort>
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyanız upload edilemedi!!Lütfen dosyanızı kontrol ediniz!'>");
			//history.back();
		</script>
	</cfcatch>
	</cftry>
</cfif>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="ADD_TOPIC" datasource="#dsn#" result="MAX_ID">
			INSERT INTO 
				FORUM_TOPIC 
				(
				USERKEY,
				
				TITLE,
				TOPIC,
				VERIFIED,
				LOCKED,
				FORUMID,
				<cfif isdefined("attributes.attach_topic_file") and len(attributes.attach_topic_file)>
				FORUM_TOPIC_FILE,
				FORUM_TOPIC_FILE_SERVER_ID,
				</cfif>
				TOPIC_STATUS,
				EMAIL_EMPS,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				UPDATE_DATE,
				UPDATE_EMP,
				UPDATE_IP
				
				)
			VALUES
				(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERKEY#">,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#TITLE#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.topic#">,
				1,
				#LOCKED#,
				#attributes.FORUMID#,
				<cfif isdefined("attributes.attach_topic_file") and len(attributes.attach_topic_file)>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#">,
				#fusebox.server_machine#,
				</cfif>
				<cfif isdefined('attributes.topic_status')>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#EMAIL_EMP#">,
				#now()#,
				#SESSION.EP.USERID#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#now()#,
				#SESSION.EP.USERID#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
				)						
		</cfquery>
		<cfquery name="UPD_FORUM_LAST_MSG_DATE" datasource="#dsn#">
			UPDATE
				FORUM_MAIN
			SET
				LAST_MSG_DATE = #now()#,
				LAST_MSG_USERKEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.EP.USERKEY#">,
				TOPIC_COUNT = TOPIC_COUNT+1
			WHERE
				FORUMID = #attributes.FORUMID#
		</cfquery>
		<!--- forum yöneticileri için mail gönderimi --->
		<cfquery name="get_main" datasource="#DSN#">
			SELECT 
				ADMIN_POS,
				ADMIN_PARS,
				ADMIN_CONS
			FROM 
				FORUM_MAIN 
			WHERE 
				FORUMID = #attributes.forumid#
		</cfquery>
		<cfset admin_cons_list=''>
		<cfset admin_pars_list=''>
		<cfset admin_pos_list = ''><!--- admin_pos listeye virgül ile atıyor admin_pos direk cagrıldıgında sayfada sorun olusuyor o nedenle liste yapıldı. MA20081027--->
		<cfif len(get_main.admin_pars) and not listfind(admin_pars_list,get_main.admin_pars)>
			<cfloop from="1" to="#listlen(get_main.admin_cons,',')#" index="c_list">			
				<cfset admin_cons_list = listappend(admin_cons_list,listgetat(get_main.admin_cons,c_list))>
			</cfloop>
			<cfset admin_cons_list= listsort(listdeleteduplicates(admin_cons_list),'numeric','ASC',',')>															
			<cfquery name="send_consumer" datasource="#dsn#">
				SELECT
					CONSUMER_ID,
					CONSUMER_NAME,
					CONSUMER_USERNAME,
					CONSUMER_SURNAME,
					CONSUMER_EMAIL
				FROM
					CONSUMER
				WHERE
					CONSUMER_EMAIL IS NOT NULL AND
					CONSUMER_STATUS = 1 AND
					CONSUMER_ID IN (#admin_cons_list#)
				ORDER BY 
					CONSUMER_ID
			</cfquery>
			<cfset admin_cons_list = listsort(listdeleteduplicates(valuelist(send_consumer.CONSUMER_ID,',')),'numeric','ASC',',')>			
		</cfif>			
		<cfif len(get_main.admin_pars) and not listfind(admin_pars_list,get_main.admin_pars)>
			<cfloop from="1" to="#listlen(get_main.admin_pars,',')#" index="p_list">			
				<cfset admin_pars_list = listappend(admin_pars_list,listgetat(get_main.admin_pars,p_list))>
			</cfloop>
			<cfset admin_pars_list= listsort(listdeleteduplicates(admin_pars_list),'numeric','ASC',',')>															
			<cfquery name="send_partner" datasource="#dsn#">
				SELECT
					PARTNER_ID,
					COMPANY_PARTNER_NAME,
					COMPANY_PARTNER_USERNAME,
					COMPANY_PARTNER_SURNAME,
					COMPANY_PARTNER_EMAIL
				FROM
					COMPANY_PARTNER
				WHERE
					COMPANY_PARTNER_EMAIL IS NOT NULL AND
					PARTNER_ID IS NOT NULL AND
					COMPANY_PARTNER_STATUS = 1 AND
					PARTNER_ID IN (#admin_pars_list#)
				ORDER BY
					PARTNER_ID
			</cfquery>
			<cfset admin_pars_list = listsort(listdeleteduplicates(valuelist(send_partner.PARTNER_ID,',')),'numeric','ASC',',')>			
		</cfif>	
		<cfif len(get_main.admin_pos) and not listfind(admin_pos_list,get_main.admin_pos)>
			<cfloop from="1" to="#listlen(get_main.admin_pos,',')#" index="i_list">			
				<cfset admin_pos_list = listappend(admin_pos_list,listgetat(get_main.admin_pos,i_list))>
			</cfloop>
			<cfset admin_pos_list= listsort(listdeleteduplicates(admin_pos_list),'numeric','ASC',',')>							
			<cfquery name="send_mail" datasource="#DSN#">
				SELECT 
					EP.POSITION_ID,
					EP.EMPLOYEE_ID,
					EP.EMPLOYEE_NAME,
					EP.EMPLOYEE_SURNAME,
					E.EMPLOYEE_EMAIL	
				FROM
					EMPLOYEES E,
					EMPLOYEE_POSITIONS EP
				WHERE
					E.EMPLOYEE_EMAIL IS NOT NULL AND
					EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
					POSITION_ID IN (#admin_pos_list#) AND
					POSITION_STATUS = 1
				ORDER BY
					POSITION_ID
			</cfquery>
			<cfset admin_pos_list = listsort(listdeleteduplicates(valuelist(send_mail.POSITION_ID,',')),'numeric','ASC',',')>
		</cfif>
	</cftransaction>
</cflock>
<cfif listlen(admin_cons_list)>
	<cfoutput query="send_consumer">
		<cfmail from="#from_mail#" to="#CONSUMER_EMAIL#" subject="Yeni Konu Açıldı" type="HTML" charset="utf-8">
			<p><strong><cf_get_lang_main no='1368.Sayın'> #CONSUMER_NAME# #CONSUMER_NAME# ;</strong><br/></p>
				<p><a href="#user_domain##request.self#?fuseaction=forum.view_topic&forumid=#attributes.FORUMID#">#get_forum.forumname#</a> <cf_get_lang no='76.İsimli Forumunuzda'> <cf_get_lang no='74.Yeni Konu Açıldı'>...<br/></p>
				<p><cf_get_lang no='75.Konu detayına erişmek için aşağıdaki linki tıklayınız.'></p>
			<p><a href="#user_domain##request.self#?fuseaction=forum.view_reply&topicid=#MAX_ID.IDENTITYCOL#">#attributes.TITLE#</a></p>
		</cfmail>
	</cfoutput>
</cfif>
<cfif listlen(admin_pars_list)>
	<cfoutput query="send_partner">
		<cfmail from="#from_mail#" to="#COMPANY_PARTNER_EMAIL#" subject="Yeni Konu Açıldı" type="HTML" charset="utf-8">
			<p><strong><cf_get_lang_main no='1368.Sayın'> #COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME# ;</strong><br/></p>
				<p><a href="#user_domain##request.self#?fuseaction=forum.view_topic&forumid=#attributes.FORUMID#">#get_forum.forumname#</a> <cf_get_lang no='76.İsimli Forumunuzda'> <cf_get_lang no='74.Yeni Konu Açıldı'>...<br/></p>
				<p><cf_get_lang no='75.Konu detayına erişmek için aşağıdaki linki tıklayınız.'></p>
			<p><a href="#user_domain##request.self#?fuseaction=forum.view_reply&topicid=#MAX_ID.IDENTITYCOL#">#attributes.TITLE#</a></p>
		</cfmail>
	</cfoutput>
</cfif>
<cfif listlen(admin_pos_list)>
	<cfoutput query="send_mail">
		<cfmail from="#from_mail#" to="#EMPLOYEE_EMAIL#" subject="Yeni Konu Açıldı" type="HTML" charset="utf-8">
			<p><strong><cf_get_lang_main no='1368.Sayın'> #EMPLOYEE_NAME# #EMPLOYEE_SURNAME# ;</strong><br/></p>
				<p><a href="#user_domain##request.self#?fuseaction=forum.view_topic&forumid=#attributes.FORUMID#">#get_forum.forumname#</a> <cf_get_lang no='76.İsimli Forumunuzda'> <cf_get_lang no='74.Yeni Konu Açıldı'>...<br/></p>
				<p><cf_get_lang no='75.Konu detayına erişmek için aşağıdaki linki tıklayınız.'></p>
			<p><a href="#user_domain##request.self#?fuseaction=forum.view_reply&topicid=#MAX_ID.IDENTITYCOL#">#attributes.TITLE#</a></p>
		</cfmail>
	</cfoutput>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
