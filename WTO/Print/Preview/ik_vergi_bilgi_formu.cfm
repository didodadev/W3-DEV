<!--- IK vergi bilgi formu --->
<cfset attributes.ID = action_id>
<cfquery name="get_in_out" datasource="#DSN#" maxrows="1">
	SELECT * FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = #attributes.ID# ORDER BY IN_OUT_ID DESC
</cfquery>
<cfset attributes.branch_id = get_in_out.branch_id>
<cfset attributes.EMPLOYEE_ID = get_in_out.EMPLOYEE_ID>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT 
		BRANCH.*,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.T_NO,
		OUR_COMPANY.ADDRESS,
		OUR_COMPANY.TEL_CODE,
		OUR_COMPANY.TEL,
		OUR_COMPANY.TAX_NO,
		OUR_COMPANY.TAX_OFFICE
		<cfif isdefined("attributes.department_id")>
		,DEPARTMENT.DEPARTMENT_HEAD
		</cfif>
	FROM 
		<cfif isdefined("attributes.department_id")>
		DEPARTMENT,
		</cfif>
		BRANCH,
		OUR_COMPANY
	WHERE
		OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID
	<cfif not isdefined("attributes.BRANCH_ID") and (isdefined("attributes.SSK_OFFICE") and len(attributes.SSK_OFFICE))>
		AND
		<cfif database_type is "MSSQL">
			SSK_OFFICE + '-' + SSK_NO = '#attributes.SSK_OFFICE#'
		<cfelseif database_type is "DB2">
			SSK_OFFICE || '-' || SSK_NO = '#attributes.SSK_OFFICE#'
		</cfif>
	<cfelseif isdefined("attributes.department_id")>
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND DEPARTMENT.DEPARTMENT_ID = #attributes.department_id#
	<cfelseif isdefined("attributes.branch_id")>
		AND BRANCH.BRANCH_ID = #attributes.BRANCH_ID#
	</cfif>
	<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
	</cfif>
	ORDER BY BRANCH.BRANCH_NAME
</cfquery>

<cfquery name="GET_KUMULATIVE_TAX" datasource="#DSN#">
SELECT
	SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI) AS GELIR_VERGISI
FROM
	EMPLOYEES_PUANTAJ,
	EMPLOYEES_PUANTAJ_ROWS
WHERE
	EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID AND
	EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
	EMPLOYEES_PUANTAJ.SAL_YEAR = #session.ep.period_year#
</cfquery>
<cfquery name="get_kumulative" datasource="#dsn#" maxrows="1">
	SELECT 
		EMPLOYEES_PUANTAJ_ROWS.KUMULATIF_GELIR_MATRAH
	FROM 
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS
	WHERE 
		EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID AND
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		EMPLOYEES_PUANTAJ.SAL_YEAR = #session.ep.period_year#
	ORDER BY
		EMPLOYEES_PUANTAJ.SAL_MON DESC
</cfquery>
<cfset cumulative_tax_total_= 0>
<cfif get_kumulative.recordcount>
	<cfset cumulative_tax_total_= get_kumulative.KUMULATIF_GELIR_MATRAH> 
</cfif>
<table>
	<tr>
		<td width="135">&nbsp;</td>
		<td><cfinclude template="/V16/objects/display/view_company_logo.cfm"><br/><br/></td>
	</tr>
</table>
<table width="650" border="0" cellspacing="0" cellpadding="0" style="text-align:center">
	<tr>
		<td class="headbold">İLGİLİ MAKAMA</td>
		<td style="text-align:right" valign="bottom"><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput></td>
	</tr>
</table><br/><br/><br/>
<table width="650">
	<tr>
		<td>
		<cfoutput query="get_in_out">
		Kurumumuzdan <strong>#dateformat(FINISH_DATE,dateformat_style)#</strong> tarihinde ayrılan  
			<cfset attributes.employee_id = get_in_out.EMPLOYEE_ID>
			<cfquery name="GET_EMPLOYEE" datasource="#dsn#">
				SELECT 
					EMPLOYEE_NAME,
					EMPLOYEE_SURNAME,
					MEMBER_CODE
				FROM 
					EMPLOYEES 
				WHERE 
					EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
			</cfquery>
			<cfset calisan = "#get_employee.employee_name#  #get_employee.employee_surname#">
			<strong>#calisan#</strong>
				'ın (Sicil No: <strong>#get_employee.member_code#</strong>) <strong>#session.ep.period_year#</strong> yılı Gelir Vergisi matrahı ile kesilen gelir vergisi matrahı aşağıda çıkarılmıştır.
		</cfoutput><br/><br/><br/>
		Saygılarımla,
		<br/><br/>
		<cf_get_lang_main no='219.Ad'> <cf_get_lang_main no='1314.Soyad'>, <cf_get_lang_main no='1545.İmza'>
		</td>
	</tr>
</table><br/><br/><br/>
<table width="650">
	<tr>
		<td>
		<table border="1" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" class="formbold">
			<cfoutput>
			<tr>
				<td width="175" height="30">&nbsp;Birikmiş Vergi Matrahı</td>
				<td width="175">&nbsp;Ödenen Vergi Miktarı</td>
			</tr>
			<tr>
				<td style="text-align:right" height="30">#TLFormat(cumulative_tax_total_)#&nbsp;</td>
				<td style="text-align:right">#TLFormat(GET_KUMULATIVE_TAX.GELIR_VERGISI)#&nbsp;</td>
			</tr>
			</cfoutput>
		</table>
		</td>
	</tr>
</table><br/><br/>
<table width="650" style="text-align:center">
	<tr>
		<td>
		<cfoutput query="get_branch">
			<cfif len(branch_tax_no)>
				(#branch_tax_office# - #branch_tax_no#)
			<cfelseif len(tax_no)>
				(#tax_office# - #tax_no#)
			</cfif>
		</cfoutput>
		</td>
	</tr>
</table>
