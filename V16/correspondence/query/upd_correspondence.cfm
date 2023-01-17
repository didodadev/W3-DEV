<cfscript>
	to_emps = "";
	to_pars = "";
	to_cons = "";
	to_grps = "";
	to_adrs = "";
	cc_emps = "";
	cc_pars = "";
	cc_cons = "";
	cc_grps = "";
	cc_adrs = "";
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
	</cfif>
</cfloop>
<cfscript>
	mailfrom = "";
	mailto = "";
	mailcc = "";
</cfscript>
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
<cfif len(attributes.attachment)>
	<cftry>
		<cffile action="upload" 
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
			<cfelseif len(attributes.old_attachment)>
				<cfmailparam file="#upload_folder#/emp_mails/#session.ep.userid#/sendbox/attachments#dir_seperator##attributes.old_attachment#">
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
		<cfset attributes.to = mailto>
		<cfset attributes.cc = mailcc>
		<cfset attributes.bcc=''>
		<cfset attributes.type=0>
		<cfset attributes.module="correspondence">
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
					<cf_get_lang no='35.Yazışma Kaydedildi Fakat Mail Göndermede Bir Hata Oldu'>
					<br/>
					<cf_get_lang no='2.Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz'>
					</td>
				</tr>
			</table>
	  </cfcatch>	  
	</cftry>
</cfif>
<cfif len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfquery name="UPD_CORRESPONDENCE" DATASOURCE="#DSN#">
	UPDATE
		CORRESPONDENCE 
	SET 			
		TO_EMP = <cfif len(to_emps)>',#to_emps#,'<cfelse>NULL</cfif>,
		TO_PARS = <cfif len(to_pars)>',#to_pars#,'<cfelse>NULL</cfif>,
		TO_CONS = <cfif len(to_cons)>',#to_cons#,'<cfelse>NULL</cfif>,
		CC_EMP = <cfif len(cc_emps)>',#cc_emps#,'<cfelse>NULL</cfif>,
		CC_PARS = <cfif len(cc_pars)>',#cc_pars#,'<cfelse>NULL</cfif>,
		CC_CONS = <cfif len(cc_cons)>',#cc_cons#,'<cfelse>NULL</cfif>,
		TO_ADR = <cfif len(to_adrs)>',#to_adrs#,'<cfelse>NULL</cfif>,
		CC_ADR = <cfif len(cc_adrs)>',#cc_adrs#,'<cfelse>NULL</cfif>,
		CATEGORY = <cfif len(attributes.corrcat_id)>#attributes.corrcat_id#<cfelse>NULL</cfif>,
		SUBJECT = '#attributes.subject#',
		MESSAGE = '#attributes.message#',
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		<cfif len(attributes.attachment)>ATTACHMENT_FILE = '#attributes.attachment#',</cfif>
		ATTACHMENT_SERVER_ID = <cfif attributes.attachment neq ''>#fusebox.server_machine#<cfelse>NULL</cfif>,
		MAIL_FROM = <cfif len(mailfrom)>'#mailfrom#'<cfelse>NULL</cfif>,
		MAIL_TO = <cfif len(attributes.emp_name)>'#attributes.emp_name#'<cfelse>NULL</cfif>,
		MAIL_CC = <cfif len(attributes.emp_name_cc)>'#attributes.emp_name_cc#'<cfelse>NULL</cfif>,
		IS_READ = <cfif isdefined("attributes.is_read")>0<cfelse>1</cfif>,
        COR_STAGE = #attributes.process_stage#,
		SPECIAL_DEFINITION_ID = <cfif isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)>#attributes.special_definition_id#<cfelse>NULL</cfif>,
        COR_STARTDATE = <cfif len(attributes.start_date)>#attributes.start_date#<cfelse>NULL</cfif>,
 		CORRESPONDENCE_NUMBER = <cfif len(attributes.correspondence_number)>'#attributes.correspondence_number#'<cfelse>'#paper_full#'</cfif>
    WHERE 
		ID = #attributes.id#
</cfquery>
	<cfquery name="GET_CORRESPONDENCE_PAPER" datasource="#DSN#">
		SELECT CORRESPONDENCE_NUMBER FROM CORRESPONDENCE WHERE ID = #attributes.id#
	</cfquery>
	<cf_workcube_process 
		is_upd='1' 
		process_stage='#attributes.process_stage#' 
		old_process_line='#attributes.old_process_line#'
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='CORRESPONDENCE'
		action_column='ID'
		action_id='#attributes.id#'
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_correspondence&event=upd&id=#attributes.id#' 
		warning_description='Yazışmalar: #GET_CORRESPONDENCE_PAPER.CORRESPONDENCE_NUMBER#'>
<script type="text/javascript">
function waitfor()
{
	window.location.href = '<cfoutput>#request.self#?fuseaction=correspondence.list_correspondence&event=upd&id=#attributes.id#</cfoutput>';
}
setTimeout("waitfor()",2000); 		
</script>
