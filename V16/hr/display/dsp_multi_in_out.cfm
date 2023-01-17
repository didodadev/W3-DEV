<!--- ic 20050827 - burada bu include'da kullanilabilirdi ancak subeyi ve şirket query'de yok eklenmeli...
<cfinclude template="../query/get_position.cfm">
 --->
<cfif isdefined("attributes.employee_id") and len("attributes.employee_id")>
	<cfquery name="get_in_out_other" datasource="#dsn#">
		SELECT 
			EI.EMPLOYEE_ID,
			EI.IN_OUT_ID,
			EI.POSITION_CODE,
			BRANCH.BRANCH_NAME,
			DEPARTMENT.DEPARTMENT_HEAD,
			OUR_COMPANY.NICK_NAME,
            E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE
		FROM
			EMPLOYEES_IN_OUT EI
            LEFT JOIN EMPLOYEES AS E ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID,
			BRANCH,
			DEPARTMENT,
			OUR_COMPANY
		WHERE
			EI.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
			DEPARTMENT.DEPARTMENT_ID = EI.DEPARTMENT_ID
			AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
			AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
	</cfquery>

	<cfif get_in_out_other.recordcount>
	<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center">
	<tr class="color-border">
	  <td>
		<table cellspacing="1" cellpadding="2" width="100%" border="0">
			<tr class="color-header">
				<td height="25" class="form-title" colspan="4"><cf_get_lang dictionary_id="56400.İşe Giriş Çıkışlar"></td>
			</tr>
			<tr class="color-list">
				<td class="txtbold"><cf_get_lang dictionary_id="57574.Şirket"></td>
				<td class="txtbold"><cf_get_lang dictionary_id="57453.Şube"></td>
				<td class="txtbold"><cf_get_lang dictionary_id="57572.Departman"></td>
				<td>&nbsp;</td>
			</tr>
			<cfoutput query="get_in_out_other">
			 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#NICK_NAME#</td>
				<td>#BRANCH_NAME#</td>
				<td>#DEPARTMENT_HEAD#</td>
				<td width="50"><a href="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#IN_OUT_ID#&empName=#UrlEncodedFormat('#EMPLOYEE#')#"><img src="/images/money.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='55123.Ücret'>"></a></td>
			  </tr>
			</cfoutput>
		</table>
	  </td>
	</tr>
	</table>
	</cfif>
</cfif>
