<cfinclude template="../query/get_eski_izinler.cfm">
<!--- bu sayfa include edilen yerde get_in_out_other.cfm de include edilsin ancak bunun icinden direk edilmesin YO17112005--->
<cfsavecontent variable="title"><cf_get_lang dictionary_id ='56122.Giriş Çıkış'></cfsavecontent>
<cfif attributes.xml_in_out eq 1>
	<cfset add_href = "#request.self#?fuseaction=ehesap.popup_form_add_position_in&employee_id=#attributes.employee_id#">
<cfelse>
	<cfset add_href = "">
</cfif>
<cfquery name="getEmpName" datasource="#dsn#">
    SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME AS EMPLOYEE FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
<cf_box id="emp_in_outs" closable="0" title="#title#" add_href="#add_href#" add_href_size="medium">
	<cf_ajax_list>
		<cfif get_in_out_other.recordcount>
        <thead>
			<tr>
				<th><cf_get_lang dictionary_id='57574.Sirket'></th>
				<th><cf_get_lang dictionary_id='29434.Şubeler'></th>
				<th><cf_get_lang dictionary_id='55190.Departmanlar'></th>
				<th><cf_get_lang dictionary_id='57554.Giriş'></th>
				<th><cf_get_lang dictionary_id='57431.Çıkış'></th>
				<th>&nbsp;</th>
			</tr>
        </thead>
        <tbody>
			<cfoutput query="get_in_out_other">
				<tr>
					<td>#nick_name#</td>
					<td>#branch_name#</td>
					<td>#department_head#</td>
					<td>#dateformat(start_date,dateformat_style)#</td>
					<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
					<td width="45">
						<cfif get_module_user(48)>
							<a href="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#in_out_id#&empName=#UrlEncodedFormat('#getEmpName.EMPLOYEE#')#"><img src="/images/money.gif" border="0" align="absmiddle" title="<cf_get_lang no ='38.Ücret'>"></a>
			 				<cfif attributes.xml_in_out eq 1 and not len(finish_date)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_fire&in_out_id=#in_out_id#','list');"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang no ='1031.İşten Çıkarma İşlemi Yap'>"></a></cfif>
						</cfif>
					</td>
				</tr>
			</cfoutput>
        </tbody>
		</cfif>
		<cfif get_eski_izinler.recordcount>
        	<thead>
                <tr>
                    <th colspan="6"><cf_get_lang dictionary_id ='1287.Geçmiş Çalışmalar'></th>
                </tr>
                <tr>
                    <th><cf_get_lang dictionary_id='57574.Sirket'></th>
                    <th><cf_get_lang dictionary_id='29434.Şube'></th>
                    <th><cf_get_lang dictionary_id='55190.Departman'></th>
                    <th width="75"><cf_get_lang dictionary_id='57554.Giriş'></th>
                    <th width="75"><cf_get_lang dictionary_id='57431.Çıkış'></th>
                    <th>&nbsp;</th>
                </tr>
            </thead>
            <tbody>
			<cfoutput query="get_eski_izinler">
				<tr>
					<td>#nick_name#</td>
					<td>#branch_name#</td>
					<td>&nbsp;</td>
					<td>#dateformat(startdate,dateformat_style)#</td>
					<td>#dateformat(finishdate,dateformat_style)#</td>
                    <td>&nbsp;</td>
				</tr>
			</cfoutput>
            </tbody> 
    	</cfif>
		<cfif not get_in_out_other.recordcount and not get_eski_izinler.recordcount>
        <tbody>
			<tr>
				<td colspan="6"><cf_get_lang dictionary_id ='57484.Kayıt Yok '>!</td>
			</tr>
        </tbody>
		</cfif>
	</cf_ajax_list>
</cf_box>
