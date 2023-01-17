<cfscript>
	attributes.employee_name = trim(attributes.employee_name);
	attributes.employee_name = trim(attributes.employee_name);
</cfscript>
<cfquery name="GET_EMPLOYEE" datasource="#dsn#">
	SELECT 
		EMPLOYEE_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		MEMBER_CODE,
		DIRECT_TEL,
		DIRECT_TELCODE,
		MOBILCODE,
		MOBILTEL,
		EMPLOYEE_EMAIL
	FROM
		EMPLOYEES
	WHERE
		EMPLOYEE_NAME = '#attributes.employee_name#' OR
		EMPLOYEE_SURNAME = '#attributes.employee_surname#'
</cfquery>
<cf_popup_box title="#getLang('hr',102)#">
	<cf_medium_list>
		<thead>
			<tr>
				<th width="25"><cf_get_lang dictionary_id="57487.No"></th>
				<th nowrap><cf_get_lang dictionary_id="57570.Ad soyad"></th>
				<th nowrap><cf_get_lang dictionary_id="57499.Telefon"></th>
				<th nowrap width="120"><cf_get_lang dictionary_id="58813.Cep Telefonu"></th>
				<th width="120"><cf_get_lang dictionary_id='57428.E-Posta'></th>
			</tr>
		</thead>
		  <form name="search_" id="search_" method="post" action="">
			  <cfif get_employee.recordcount>
				  <tbody>
				  <cfoutput query="get_employee">
					<tr>
						<td>#member_code#</td>
						<td nowrap><a href="://javascript" onClick="control(1,#employee_id#);" class="tableyazi">#employee_name# #employee_surname#</a></td>
						<td>#direct_tel# #direct_telcode#</td>
						<td>#mobilcode# #mobiltel#</td>
						<td>#employee_email#</td>
					</tr>
				 </cfoutput>
				 </tbody>
				 <tfoot>
					<tr>
						<td colspan="8" style="text-align:right;"><input type="submit" name="Devam" id="Devam" value="<cf_get_lang dictionary_id='55189.Varolan Kayıtları Gözardi Et'>" onClick="control(2,0);"></td>
					</tr>
				</tfoot>
				<cfelse>
					<tbody>
						<tr>
							<td height="20" colspan="8"><cf_get_lang dictionary_id="58486.Kayit Bulunamadi"> !</td>
						</tr>
					</tbody>
				</cfif>
			</form>
    </cf_medium_list>
</cf_popup_box>
<script type="text/javascript">
<cfif not get_employee.recordcount>
	opener.employe_detail.submit();
	window.close();
</cfif>
function control(id,value)
{
	if(id==1)
	{
		opener.location.href='<cfoutput>#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=</cfoutput>' + value;
		window.close();
	}
	if(id==2)
	{
		opener.employe_detail.submit();
		window.close();
	}
}
</script>

