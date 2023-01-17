<cfif len(attributes.id)>
	<cfquery name="GET_PROTESTS" datasource="#DSN#">
		SELECT
			*
		FROM
			EMPLOYEE_DAILY_IN_OUT_PROTESTS
		WHERE 
			PROTEST_ID=#attributes.id#		
	</cfquery>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="55718.İtiraza Cevap"></cfsavecontent>
    <cf_popup_box title="#message#">
	    <cfform name="add_protest" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_protest_answer&id=#attributes.id#" onsubmit="">
	        <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">	
			<table>
                <tr>
					<cfoutput>
                        <td><cf_get_lang dictionary_id='57576.Çalışan'>:</td>
                        <td>#get_emp_info(GET_PROTESTS.EMPLOYEE_ID,0,1)#</td>
                        <td><cf_get_lang dictionary_id='55684.İlgili Tarih'>:</td>
                        <td>#dateformat(GET_PROTESTS.action_date,dateformat_style)#</td>
                    </cfoutput>
				</tr>
                <tr>
                	<td valign="top" colspan="4" width="100"><cf_get_lang dictionary_id='55719.İtiraz'></td>
                </tr>
                <tr>
                	<td class="txtbold" colspan="4"><cfoutput query="GET_PROTESTS">#GET_PROTESTS.PROTEST_DETAIL#</cfoutput></td>
                </tr>
                <tr>
                	<td valign="top" colspan="4" width="100"><cf_get_lang dictionary_id='58654.Cevap'></td>
                </tr>
                <tr>
                    <td colspan="4"><textarea name="detail" id="detail" style="width:250px;height:100px;"><cfoutput query="GET_PROTESTS"><cfif GET_PROTESTS.ANSWER_DETAIL IS NOT "">#GET_PROTESTS.ANSWER_DETAIL#</cfif></cfoutput></textarea></td>
                </tr>
            </table>
			<cf_popup_box_footer><cf_workcube_buttons is_upd='0'></cf_popup_box_footer>
        </cfform>
    </cf_popup_box>
<cfelse>
	<script language="javascript">
		alert("<cf_get_lang dictionary_id='38590.Çalışan Henüz Yapılan Uyarıya Dönüş Yapmamıştır'>!");
		window.close();
	</script>
</cfif>
