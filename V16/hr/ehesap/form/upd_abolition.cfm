<cfinclude template="../query/get_abolition.cfm">
<cfsavecontent variable="right_">
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_detail_abolition&abolition_id=<cfoutput>#attributes.abolition_id#</cfoutput>','list');"><img border="0" src="images/print.gif"></a> 
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53404.Fesih Yazısı Güncelle"></cfsavecontent>
<cf_popup_box title="#message#" right_images="#right_#">
	<cfform  name="upd_abolition" action="#request.self#?fuseaction=ehesap.emptypopup_upd_abolition" method="post"> 
		<table>
			<tr>
				<td><cf_get_lang dictionary_id='57480.Konu'></td>
				<td><input type="text" name="ABOLITION_SUBJECT" id="ABOLITION_SUBJECT"  style="width:150px;"  value="<cfoutput>#get_abolition.ABOLITION_SUBJECT#</cfoutput>"></td>
				<td><cf_get_lang dictionary_id='53156.İlgi'></td>
				<td><input type="text" name="INTEREST" id="INTEREST"  style="width:150px;"  value="<cfoutput>#get_abolition.INTEREST#</cfoutput>"></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='53154.Genel Müdür'>*</td>
				<td>
					<cfset EMP_ID=get_abolition.MANAGER_ID>
					<cfif len(EMP_ID)>
						<cfinclude template="../query/get_action_emp.cfm">
						<cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
					<cfelse>
						<cfset emp_name="">
					</cfif>
					<input type="hidden" name="abolition_id" id="abolition_id" value="<cfoutput>#attributes.abolition_id#</cfoutput>">
					<input type="hidden" name="event_id" id="event_id" value="<cfoutput>#get_abolition.EVENT_ID#</cfoutput>">
					<input type="hidden" name="head_quater_id" id="head_quater_id"  value="<cfoutput>#get_abolition.MANAGER_ID#</cfoutput>" >
					<input type="text" name="head_quater" id="head_quater" style="width:150px;"  value="<cfoutput>#emp_name#</cfoutput>">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=upd_abolition.head_quater_id&field_emp_name=upd_abolition.head_quater','list');return false"> <img src="/images/plus_thin.gif" align="absmiddle" border="0"> </a> 
				</td>
				<td><cf_get_lang dictionary_id='53157.Fesih Tarihi'></td>
				<td>
					<cfinput validate="#validate_style#" type="text" name="ABOLITION_DATE" value="#dateformat(get_abolition.ABOLITION_DATE,dateformat_style)#" style="width:150px;">
					<cf_wrk_date_image date_field="ABOLITION_DATE">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='53155.Kimden'></td>
				<td colspan="3"><input type="text" name="FROM_WHO" id="FROM_WHO"  value="<cfoutput>#get_abolition.FROM_WHO#</cfoutput>" style="width:150px;"></td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
				<td colspan="3" valign="top">
					<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarSet="WRKContent"
						basePath="/fckeditor/"
						instanceName="abolition_detail"
						valign="top"
						value="#get_abolition.ABOLITION_DETAIL#"
						width="500"
						height="300">					 
				</td>
			</tr>
		</table>   
		<cf_popup_box_footer>
			<cf_workcube_buttons is_upd='1'  delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_upd_abolition&is_del=1&del_id=#get_abolition.EVENT_ID#'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
