<cf_popup_box title="#getLang('sales',568)#">
	<cfform name="pay_plan" method="post" action="#request.self#?fuseaction=sales.emptypopup_del_subs_pay_plan_row">
		<input type="hidden" name="xml_del_ref_rows" id="xml_del_ref_rows" value="<cfif isdefined("attributes.xml_del_ref_rows")><cfoutput>#attributes.xml_del_ref_rows#</cfoutput></cfif>">
		<input type="hidden" name="xml_del_camp_rows" id="xml_del_camp_rows" value="<cfif isdefined("attributes.xml_del_ref_rows")><cfoutput>#attributes.xml_del_camp_rows#</cfoutput></cfif>">
		<table>
			<tr>
				<td width="100"><cf_get_lang_main no ='641.Başlangıç Tarihi'> :</td>
				<td>
					<cfsavecontent variable="alert"><cf_get_lang_main no ='326.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
					<input type="text" name="start_date" id="start_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" required="yes" message=" !"style="width:70px;" validate="#validate_style#">
					 <cf_wrk_date_image date_field="start_date">
					<input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#attributes.subscription_id#</cfoutput>">
					<input type="hidden" name="del_all" id="del_all" value="1">
				</td>
			</tr>
		</table>
		<cf_popup_box_footer><cf_workcube_buttons is_upd='0'></cf_popup_box_footer>
	</cfform>
</cf_popup_box>

