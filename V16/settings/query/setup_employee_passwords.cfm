<cf_xml_page_edit fuseact="settings.setup_employee_passwords">
<cfquery name="get_emp_branch" datasource="#DSN#">
	SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.POSITION_CODE#">
</cfquery>
<cfset emp_branch_list=valuelist(get_emp_branch.BRANCH_ID)>

<cfquery name="get_mails" datasource="#dsn#">
	SELECT 
		E.* 
	FROM 
		EMPLOYEES E,
		EMPLOYEE_POSITIONS  EP,
		DEPARTMENT D
	WHERE 
		E.EMPLOYEE_EMAIL IS NOT NULL AND
		EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		IS_MASTER = 1
		<cfif (attributes.branch_id is not '0') and len(trim(attributes.branch_id))>
			AND D.BRANCH_ID = #attributes.branch_id#
		<cfelse>
			AND D.BRANCH_ID IN (#emp_branch_list#) 
		</cfif>
		<cfif len(attributes.keyword)>
			AND
				(
				E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
				OR
				E.EMPLOYEE_EMAIL LIKE '%#attributes.keyword#%'
				OR
				E.EMPLOYEE_USERNAME LIKE '%#attributes.keyword#%'
				)
		</cfif>
		<cfif len(attributes.department)>
			AND D.DEPARTMENT_ID = #attributes.department#
		</cfif>
	ORDER BY 
		E.EMPLOYEE_USERNAME DESC,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
</cfquery>

<cfsavecontent variable="message"><cfoutput>#session.ep.company_nick#</cfoutput><cf_get_lang no ='2538.Çalışan Portal Şifre Bilgileriniz'> </cfsavecontent>
<cfoutput query="get_mails">
	<cfif len(EMPLOYEE_EMAIL)>
		<cfif isdefined("attributes.new_username_#employee_id#") and isdefined("attributes.new_password_#employee_id#") and isdefined("attributes.control_#employee_id#")>
			<cfmail
				to="#EMPLOYEE_EMAIL#"
				from="#session.ep.company#<#session.ep.company_email#>"
				subject="#message#" 
				type="HTML">

		<style type="text/css">
			.label {font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
			.css1 {font-size:12px;font-family:arial,verdana;color:000000; background-color:white;}
			.css2 {font-size:9px;font-family:arial,verdana;color:999999; background-color:white;}
		</style>
		<cfinclude template="../../objects/display/view_company_logo.cfm">	
			<table class="css1">
				<tr>
					<td colspan="2">
					<cf_get_lang_main no ='1368.Sayın'> #employee_name# #employee_surname#,<br/>
					<!---<cf_get_lang no ='2539.Şifre Bilgileriniz Düzenlenmiştir'>.---> <cf_get_lang no ='2540.Yeni Kullanıcı Adı ve Şifreniz Aşağıdaki Gibidir'>.
						<br/><br/><br/>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no ='139.Kullanıcı Adı'></td>
					<td align="left"><strong><cfif is_change_username eq 1>#evaluate("attributes.new_username_#employee_id#")#<cfelse>#evaluate("attributes.username_#employee_id#")#</cfif></strong></td>
				</tr>
				<tr>
					<td><cf_get_lang_main no ='140.Şifre'></td>
					<td align="left"><strong>#evaluate("attributes.new_password_#employee_id#")#</strong></td>
				</tr>
				<tr>
					<td colspan="2"><a href="#employee_domain##request.self#?fuseaction=myhome.mysettings&page_type=9" class="tableyazi"><cf_get_lang_main no = '1916.şifrenizi değiştirmek için tıklayınız'></a></td>
				</tr>
			</table>
			<br/>
			<table width="100%">
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
			<cfinclude template="../../objects/display/view_company_info.cfm">
			</cfmail>
			<cfquery name="upd_" datasource="#dsn#">
				UPDATE EMPLOYEES SET <cfif is_change_username eq 1>EMPLOYEE_USERNAME = #sql_unicode()#'#wrk_eval("attributes.new_username_#employee_id#")#', </cfif>EMPLOYEE_PASSWORD = #sql_unicode()#'#wrk_eval("attributes.new_crp_password_#employee_id#")#' WHERE EMPLOYEE_ID = #EMPLOYEE_ID#
			</cfquery>
            <cf_add_log  log_type="0" action_id="#EMPLOYEE_ID#" action_name="Kullanıcı Adı Şifre Güncelle :#get_emp_info(employee_id,0,0)#(#EMPLOYEE_ID#)">
		</cfif>
	</cfif>
</cfoutput>
<script type="text/javascript">
	alert("<cf_get_lang no ='2537.Gönderim Tamamlandı'>!");
	window.location.href='<cfoutput>#request.self#?fuseaction=settings.setup_employee_passwords</cfoutput>';
</script>
