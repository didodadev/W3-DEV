<cfsetting showdebugoutput="no">
<cfset day_1 = date_add('d',7,now())>
<cfset day_2 = date_add('d',-7,now())>
<cfquery name="GET_EMP_CONTRACT" datasource="#DSN#">
	SELECT 
		EIO.START_DATE,
		EIO.FINISH_DATE,
		EIO.IN_OUT_ID,
		EIO.SURELI_IS_FINISHDATE,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID	
	FROM 
		EMPLOYEES_IN_OUT EIO,
		EMPLOYEES E
	WHERE
		E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
		(EIO.SURELI_IS_FINISHDATE >= #day_2# AND EIO.SURELI_IS_FINISHDATE <= #day_1#) AND
		EIO.SURELI_IS_AKDI = 1
		<cfif not session.ep.ehesap>
			AND EIO.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
		</cfif>
</cfquery>
<cf_flat_list>
	<tbody>
		<cfif get_emp_contract.recordcount>
			<cfoutput query="get_emp_contract">
				<tr>
				<cfif get_emp_contract.sureli_is_finishdate eq day_2>
					<td>
					<a href="#request.self#?fuseaction=hr.list_salary&event=det&employee_id=#employee_id#&in_out_id=#in_out_id#"class="tableyazi" style="color:FF0000;">
					#get_emp_contract.employee_name# #get_emp_contract.employee_surname#
					</a></td>
                <cfelse>
					<td>
					<a href="#request.self#?fuseaction=hr.list_salary&event=det&employee_id=#employee_id#&in_out_id=#in_out_id#"  class="tableyazi">
					#get_emp_contract.employee_name# #get_emp_contract.employee_surname#
					</a></td>
                </cfif>
					<td><b><cf_get_lang no='864.İşe Başlama'></b> :#dateformat(get_emp_contract.start_date,dateformat_style)#</td>
					<td><b><cf_get_lang no='1583.İş Akti Sonu'></b> :#dateformat(get_emp_contract.sureli_is_finishdate,dateformat_style)#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>
