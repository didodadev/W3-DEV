<!--- Standart IK Zimmet Formu --->
<cfset attributes.ID =action_id>
<cfquery name="get_invent" datasource="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEES_INVENT_ZIMMET EIZ,
		EMPLOYEES_INVENT_ZIMMET_ROWS EIZR
	WHERE
		EIZ.ZIMMET_ID = EIZR.ZIMMET_ID AND
		EIZ.ZIMMET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfquery name="get_department_id" datasource="#DSN#">
	SELECT 
		EP.DEPARTMENT_ID,
		EP.EMPLOYEE_ID
	FROM
		EMPLOYEES_INVENT_ZIMMET EIZ,
		EMPLOYEE_POSITIONS EP
	WHERE 
		EP.EMPLOYEE_ID = EIZ.EMPLOYEE_ID
		AND EIZ.ZIMMET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	 	AND EP.IS_MASTER= 1
</cfquery>
<cfset attributes.department_id =  get_department_id.DEPARTMENT_ID>
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
		AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
	<cfelseif isdefined("attributes.branch_id")>
		AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.BRANCH_ID#">
	</cfif>
	<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
	</cfif>
	ORDER BY BRANCH.BRANCH_NAME
</cfquery>
<table>
	<tr>
		<td width="135">&nbsp;</td>
		<td><cfinclude template="/V16/objects/display/view_company_logo.cfm"></td>
	</tr>
</table>
<table width="650" border="0" cellspacing="0" cellpadding="0" height="35" style="text-align:center">
	<tr>
		<td style="text-align:center" class="headbold">DEMİRBAŞ ZİMMET FORMU</td>
	</tr>
</table>
<br/>
<table style="text-align:center" width="650" height="35">
	<tr>
		<td width="65" class="txtbold" height="22"><cf_get_lang_main no='485.Adı'> <cf_get_lang_main no='1138.Soyadı'></td>
		<td width="150"><cfoutput>#GET_EMP_INFO(get_department_id.EMPLOYEE_ID,0,0)#</cfoutput></td>
		<td style="text-align:right" rowspan="3" valign="top"></td>
	</tr>
	<tr>
		<td width="65" class="txtbold" height="22">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td width="65" class="txtbold" height="22"><cf_get_lang_main no='162.Şirket'></td>
		<td><cfoutput query="get_branch">#branch_fullname#</cfoutput></td>
	</tr>
</table>
<br/>
<table width="650" border="1" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" style="text-align:center">
	<tr>
		<td height="30" colspan="3">&nbsp;<cf_get_lang_main no='1190.Demirbaş'></td>
		<td width="65">&nbsp;</td>
		<td style="text-align:center" width="100">Teslim Eden</td>
		<td style="text-align:center" width="100"><cf_get_lang_main no='363.Teslim Alan'></td>
	</tr>
	<tr>
		<td style="text-align:center" width="50" height="30"><cf_get_lang_main no='519.Cins'></td>
		<td style="text-align:center" width="75"><cf_get_lang_main no='1466.Demirbaş No'></td>
		<td style="text-align:center"><cf_get_lang_main no='1498.Özellikleri'></td>
		<td style="text-align:center"><cf_get_lang_main no='330.Tarih'></td>
		<td style="text-align:center" width="100"><cf_get_lang_main no='485.Adı'>,<cf_get_lang_main no='1138.Soyadı'>,<cf_get_lang_main no='1545.İmza'></td>
		<td style="text-align:center"><cf_get_lang_main no='1545.İmza'></td>
	</tr>
	<cfoutput query="get_invent">
	<tr>
		<td height="50">#DEVICE_NAME#</td>
		<td>#INVENTORY_NO#</td>
		<td>#PROPERTY#</td>
		<td>#dateformat(ZIMMET_DATE,dateformat_style)#</td>
		<td>#GET_EMP_INFO(GIVEN_EMP_ID,0,0)#</td>
		<td>&nbsp;</td>
	</tr>
	</cfoutput>
	<tr>
		<td height="50"><cf_get_lang_main no='744.Diğer'></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td height="50"><cf_get_lang_main no='744.Diğer'></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td height="50"><cf_get_lang_main no='744.Diğer'></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
</table>
<br/>
<table width="650" bordercolor="CCCCCC" border="1" cellpadding="0" cellspacing="0" style="text-align:center">
	<tr>
		<td>
		<table border="0" width="600">
		<tr>
			<td colspan="2">Yukarıda belirtilen demirbaş(lar) eksiksiz olarak tarafımdan geri alınmıştır.</td>
		</tr>
		<tr>
			<td colspan="2" class="txtbold">Teslim Alanın</td>
		</tr>
		<tr>
			<td width="75"><cf_get_lang_main no='485.Adı'> <cf_get_lang_main no='1138.Soyadı'></td>
			<td width="520">:</td>
		</tr>
		<tr>
			<td>Görevi</td>
			<td>:</td>
		</tr>
		<tr>
			<td><cf_Get_lang_main no='330.Tarih'></td>
			<td>:</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='1545.İmza'></td>
			<td>:</td>
		</tr>
		</table>
		</td>
	</tr>
</table>
<table width="650" style="text-align:center">
	<tr>
		<td>Demirbaşların Geri Alımında hasar ve eksiklik olması halinde ek bir tutanak düzenlenir.</td>
	</tr>
</table>
<br/>

