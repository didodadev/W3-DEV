<cfscript>
	to_emps = "";
	to_pars = "";
	to_cons = "";
	to_grps = "";
	to_adrs = "";
	to_comp = "";
	cc_emps = "";
	cc_pars = "";
	cc_cons = "";
	cc_grps = "";
	cc_adrs = "";
	cc_comp = "";
</cfscript>
<cfloop list="#attributes.emp_id#" index="i">
	<cfif i contains "emp">
		<cfset to_emps = listappend(to_emps,listgetat(i,2,"-"))>
	<cfelseif i contains "par">
		<cfset to_pars = listappend(to_pars,listgetat(i,2,"-"))>
	<cfelseif i contains "con">
		<cfset to_cons = listappend(to_cons,listgetat(i,2,"-"))>
	<cfelseif i contains "grp">
		<cfset to_grps = listappend(to_grps,listgetat(i,2,"-"))>
	<cfelseif i contains "adr">
		<cfset to_adrs = listappend(to_adrs,listgetat(i,2,"-"))>
	<cfelseif i contains "comp">
		<cfset to_comp = listappend(to_comp,listgetat(i,2,"-"))>    
    </cfif>
</cfloop> 
<cfloop list="#attributes.emp_id_cc#" index="I">
	<cfif i contains "emp">
		<cfset cc_emps = listappend(cc_emps,listgetat(i,2,"-"))>
	<cfelseif i contains "par">
		<cfset cc_pars = listappend(cc_pars,listgetat(i,2,"-"))>
	<cfelseif i contains "con">
		<cfset cc_cons = listappend(cc_cons,listgetat(i,2,"-"))>
	<cfelseif i contains "grp">
		<cfset cc_grps = listappend(cc_grps,listgetat(i,2,"-"))>
	<cfelseif i contains "adr">
		<cfset cc_adrs = listappend(cc_adrs,listgetat(i,2,"-"))>
	<cfelseif i contains "comp">
		<cfset cc_comp = listappend(cc_comp,listgetat(i,2,"-"))>    
	</cfif>
</cfloop>
<cfscript>
	mailfrom = "";
	mailto = "";
	mailcc = "";
</cfscript>

<cfset new_list_emp = attributes.emp_name>
<cfset new_list_emp = listsort(new_list_emp,'text')>
<cfset new_list_cc = attributes.emp_name_cc>
<cfset new_list_cc = listsort(new_list_cc,'text')>

<cfif DirectoryExists("#emp_mail_path##session.ep.userid#")>
<cfelse>
    <cfdirectory action="create" name="as" directory="#emp_mail_path##session.ep.userid#">
    <cfdirectory action="create" name="as_in" directory="#emp_mail_path##session.ep.userid#\inbox">
    <cfdirectory action="create" name="as_out" directory="#emp_mail_path##session.ep.userid#\sendbox">
    <cfdirectory action="create" name="as_draft" directory="#emp_mail_path##session.ep.userid#\draft">
    <cfdirectory action="create" name="as_delete" directory="#emp_mail_path##session.ep.userid#\deleted">
    <cfdirectory action="create" name="as_ina" directory="#emp_mail_path##session.ep.userid#\inbox\attachments">
    <cfdirectory action="create" name="as_outa" directory="#emp_mail_path##session.ep.userid#\sendbox\attachments">
    <cfdirectory action="create" name="as_drafta" directory="#emp_mail_path##session.ep.userid#\draft\attachments">
    <cfdirectory action="create" name="as_deletea" directory="#emp_mail_path##session.ep.userid#\deleted\attachments">
</cfif>
<cfparam name="attributes.subject" default="">
<cfif len(attributes.attachment)>
	<cftry>
		<cffile 
			action="upload"
			nameconflict="overwrite"
			filefield="attachment"
			destination="#upload_folder#/emp_mails/#session.ep.userid#/sendbox/attachments#dir_seperator#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
		<cffile 
			action="rename" 
			source="#upload_folder#/emp_mails/#session.ep.userid#/sendbox/attachments#dir_seperator##cffile.serverfile#" 
			destination="#upload_folder#/emp_mails/#session.ep.userid#/sendbox/attachments#dir_seperator##file_name#">	
		<!---Script dosyalarını engelle  02092010 ND --->
        <cfset assetTypeName = listlast(cffile.serverfile,'.')>
        <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
        <cfif listfind(blackList,assetTypeName,',')>
            <cffile action="delete" file="#upload_folder#/emp_mails/#session.ep.userid#/sendbox/attachments#dir_seperator##file_name#">
            <script type="text/javascript">
                alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
                history.back();
            </script>
            <cfabort>
        </cfif>	
		<cfset attributes.attachment = file_name>
		<cfset attributes.attachment_name = cffile.serverfile>
		<cfcatch type="any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>	
	</cftry>
	<cfset attributes.attachment_count = 1>
	<cfset this_dosya_1 = attributes.attachment>
	<cfset attributes.file_name1 = attributes.attachment_name>
<cfelse>
	<cfset attributes.attachment_count = 0>
</cfif>

<cfif isdefined("attributes.email")>
	<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
		<cfquery name="GET_MAILFROM" datasource="#dsn#">
			SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_EMAIL FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		</cfquery>				   		
		<cfset mailfrom = '#get_mailfrom.employee_name# #get_mailfrom.employee_surname#<#get_mailfrom.employee_email#>'>
	<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
		<cfquery name="GET_MAILFROM" datasource="#dsn#">
			SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
		</cfquery>				   	
		<cfset mailfrom = '#get_mailfrom.company_partner_name# #get_mailfrom.company_partner_surname#<#get_mailfrom.company_partner_email#>'>
	</cfif>
	<cfset mailto = attributes.emp_id>
	<cfset mailcc = attributes.emp_id_cc>
	<cftry>
		<cfmail  
			from = "#mailfrom#"
			to = "#attributes.emp_name#"
			subject = "#attributes.subject#"
			cc="#attributes.emp_name_cc#"
			type="HTML">
			<cfif attributes.attachment neq ''>
				<cfmailparam file="#upload_folder#/emp_mails/#session.ep.userid#/sendbox/attachments#dir_seperator##file_name#">
			</cfif>  
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
			</style>		  
			#attributes.message#
		</cfmail>
		<cfsavecontent variable="css">
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
			</style>
		</cfsavecontent>
		<cfset attributes.body="#css##attributes.message#">
		<cfset attributes.from = mailfrom>
		<cfset attributes.to_list = attributes.emp_name>
		<cfset attributes.cc_list = attributes.emp_name_cc>
		<cfset attributes.bcc=''>
		<cfset attributes.type=0>
		<cfset attributes.module="correspondence">
		<cfset attributes.relation_list_emp = new_list_emp>
		<cfset attributes.relation_list_cc = new_list_cc>
		<cfinclude template="../../objects/query/add_mail.cfm">
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
			</style>	  	  	   

			<table height="100%" width="98%" cellspacing="1" cellpadding="2" class="color-border" align="center">
				<tr class="color-list">
					<td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang_main no='100.Workcube E-Mail'></td>
				</tr>
				<tr class="color-row">
					<td align="center" class="headbold"><cf_get_lang no='36.Mail Basariyla Gönderildi'></td>
				</tr>
			</table>
	  	<cfcatch type="any">
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
			</style>	

			<table height="100%" width="100%" cellspacing="1" cellpadding="2" class="color-border" align="center">
				<tr class="color-list">
					<td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang_main no='100.Workcube E-Mail'></td>
				</tr>
				<tr class="color-row">
					<td align="center" class="headbold">
					<cf_get_lang no='35.Yazışma Kaydedildi Fakat Mail Göndermede Bir Hata Oldu'><br/>
					<cf_get_lang no='2.Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz'>
					</td>
				</tr>
			</table>	  
	  </cfcatch>	  
	</cftry>
</cfif>
<cfquery name="get_gen_paper" datasource="#dsn3#">
	SELECT CORRESPONDENCE_NO,CORRESPONDENCE_NUMBER FROM GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
</cfquery>
<cfset paper_code = evaluate('get_gen_paper.CORRESPONDENCE_NO')>
<cfset paper_number = evaluate(val(get_gen_paper.CORRESPONDENCE_NUMBER)) +1>
<cfset paper_full = '#paper_code#-#paper_number#'>
<cfquery name="SET_MAX_PAPER" datasource="#DSN3#">
	UPDATE GENERAL_PAPERS SET CORRESPONDENCE_NUMBER = CORRESPONDENCE_NUMBER+1 WHERE PAPER_TYPE IS NULL
</cfquery>
<cfif len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfquery name="ADD_CORRESPONDENCE" datasource="#DSN#" result="MAX_ID">
	INSERT INTO
		CORRESPONDENCE
	(
		TO_EMP,	
		TO_PARS,
		TO_CONS,
		CC_EMP,
		CC_PARS,
		CC_CONS,
		TO_ADR,
		CC_ADR,
		CATEGORY,
		SUBJECT,
		MESSAGE,
		RECORD_EMP,
		RECORD_DATE,	
		ATTACHMENT_FILE,
		ATTACHMENT_SERVER_ID,
		MAIL_FROM,
		MAIL_TO,
		MAIL_CC,
		IS_READ,
		COR_STAGE,
        SPECIAL_DEFINITION_ID,
        COR_STARTDATE,
		CORRESPONDENCE_NUMBER,
        TO_COMP,
        CC_COMP
	)
	VALUES
	(
		<cfif len(to_emps)>',#to_emps#,'<cfelse>NULL</cfif>,
		<cfif len(to_pars)>',#to_pars#,'<cfelse>NULL</cfif>,
		<cfif len(to_cons)>',#to_cons#,'<cfelse>NULL</cfif>,
		<cfif len(cc_emps)>',#cc_emps#,'<cfelse>NULL</cfif>,
		<cfif len(cc_pars)>',#cc_pars#,'<cfelse>NULL</cfif>,
		<cfif len(cc_cons)>',#cc_cons#,'<cfelse>NULL</cfif>,
		<cfif len(to_adrs)>',#to_adrs#,'<cfelse>NULL</cfif>,
		<cfif len(cc_adrs)>',#cc_adrs#,'<cfelse>NULL</cfif>,
		<cfif len(attributes.corrcat_id)>#attributes.corrcat_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.subject)>'#attributes.subject#'<cfelse>NULL</cfif>,
		<cfif len(attributes.message)>'#attributes.message#'<cfelse>NULL</cfif>,
		#session.ep.userid#,
		#NOW()#,
		<cfif len(attributes.attachment)>'#attributes.attachment#'<cfelse>NULL</cfif>,
		<cfif len(attributes.attachment)>#fusebox.server_machine#<cfelse>NULL</cfif>,
		<cfif len(mailfrom)>'#mailfrom#'<cfelse>NULL</cfif>,
		<cfif len(attributes.emp_name)>'#attributes.emp_name#'<cfelse>NULL</cfif>,
		<cfif len(attributes.emp_name_cc)>'#attributes.emp_name_cc#',<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.is_read")>0<cfelse>1</cfif>,
		#attributes.process_stage#,
		<cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
        <cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.correspondence_number)>'#attributes.correspondence_number#'<cfelse>'#paper_full#'</cfif>,
        <cfif len(to_comp)>',#to_comp#,'<cfelse>NULL</cfif>,
        <cfif len(cc_comp)>',#cc_comp#,'<cfelse>NULL</cfif>
        
	)
</cfquery>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='CORRESPONDENCE'
	action_column='ID'
	action_id='#MAX_ID.IDENTITYCOL#'
	action_page='#request.self#?fuseaction=list_correspondence&event=upd&id=#MAX_ID.IDENTITYCOL#' 
	warning_description='Yazışmalar :#paper_full#'>
<script type="text/javascript">
  window.location.href = '<cfoutput>#request.self#?fuseaction=correspondence.list_correspondence&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>';
</script>
