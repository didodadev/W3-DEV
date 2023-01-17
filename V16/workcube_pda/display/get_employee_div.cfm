<cfsetting showdebugoutput="no">
<cfset attributes.project_emp_id = trim(attributes.project_emp_id)>
<cfquery name="GET_EMPS" datasource="#DSN#">
	SELECT 
    	E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EP.POSITION_CODE
	FROM 
		EMPLOYEES E,
		EMPLOYEE_POSITIONS EP
	WHERE 
		E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND 
		E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.project_emp_id#%"> AND
		E.EMPLOYEE_STATUS = 1
</cfquery>
<cf_box title="Çalışanlar" body_style="overflow-y:scroll;height:100px;" call_function="gizle(employee_div);">
	<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%">
		<tr class="color-border">
			<td>
				<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
					<tr class="color-header" style="height:22px;">		
						<td class="form-title" style="width:150px;">Pozisyon Kodu</td>
						<td class="form-title">Görevli Adı Soyadı</td>
					</tr>
					<cfif get_emps.recordcount>
						<cfoutput query="get_emps">		
							<tr class="color-row" style="height:20px;">
								<td>#position_code#</td>
								<td><a href="javascript://" class="tableyazi"  onclick="add_employee_div('#employee_id#','#employee_name# #employee_surname#')">#employee_name#  #employee_surname#</a></td>
							</tr>		
						</cfoutput>
					<cfelse>
						<tr class="color-row" style="height:20px;">
							<td colspan="3">Kayıt Bulunamadı !</td>
						</tr>
					</cfif>
				</table>
			</td>
		</tr>
	</table>
</cf_box>

