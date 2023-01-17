<cf_xml_page_edit fuseact="objects.form_assetp_reserve">
<cfinclude template="../query/get_assetp_reserve.cfm">
<script type="text/javascript">
function check()
{
	if ( (upd_assetp_reserve.startdate.value != "") && (upd_assetp_reserve.finishdate.value != "") )
		return time_check(upd_assetp_reserve.startdate, upd_assetp_reserve.event_start_clock, upd_assetp_reserve.event_start_minute, upd_assetp_reserve.finishdate,  upd_assetp_reserve.event_finish_clock, upd_assetp_reserve.event_finish_minute, "<cf_get_lang no='52.Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır !'>");
}
</script>
<cfset startdate_temp = date_add('h',session.ep.time_zone,get_assetp_reserve.startdate)>
<cfset finishdate_temp = date_add('h',session.ep.time_zone,get_assetp_reserve.finishdate)>
<cfset startdate = dateformat(startdate_temp,dateformat_style)>
<cfset starthour = timeformat(startdate_temp,"HH")>
<cfset startmin = timeformat(startdate_temp,"MM")>
<cfset finishdate = dateformat(finishdate_temp,dateformat_style)>
<cfset finishhour = timeformat(finishdate_temp,"HH")>
<cfset finishmin = timeformat(finishdate_temp,"MM")>
<cfsavecontent variable="right">
    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=assetcare.popup_asset_reserve_history&asset_id=#get_assetp_reserve.assetp_id#</cfoutput>','list','popup_asset_reserve_history');"><img src="/images/table.gif" alt="Rezervasyonlar" title="Rezervasyonlar" border="0"></a>
    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_form_assetp_reserve&assetp_id=#attributes.assetp_id#"><img src="/images/plus1.gif"  align="absbottom"  alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a>
</cfsavecontent>
<cfform name="upd_assetp_reserve" method="post" action="#request.self#?fuseaction=assetcare.upd_assetp_reserve">
<cf_popup_box title="#getLang('assetcare',28)#" right_images='#right#'>
	<input type="hidden" name="assetp_resid" id="assetp_resid" value="<cfoutput>#attributes.assetp_resid#</cfoutput>">
	<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_assetp_reserve.assetp_id#</cfoutput>">
		<table>
	        <tr>
            	<td><cf_get_lang_main no="1447.Süreç"></td>
            	<td><cf_workcube_process is_upd='0' process_cat_width='100' is_detail='1' select_value="#get_assetp_reserve.STAGE_ID#"></td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='89.Başlangıç'></td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='641.Başlangıç Tarihi !'></cfsavecontent>
                    <cfinput type="text" name="startdate" style="width:80px;" required="Yes" validate="#validate_style#" message="#message#" value="#startdate#">
                    <cf_wrk_date_image date_field="startdate">
                    <select name="event_start_clock" id="event_start_clock" style="width:50px;">
                        <option value="00" selected><cf_get_lang_main no='79.Saat'></option>
                        <cfloop from="1" to="23" index="i">
                            <cfoutput>
                                <option value="#i#" <cfif starthour eq i>selected</cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                    <select name="event_start_minute" id="event_start_minute" style="width:50px;">
                        <option value="00" selected><cf_get_lang_main no='1415.dk'></option>
                        <cfloop from="05" to="55" index="i" step="5">
                            <cfoutput>
                                <option value="#i#" <cfif startmin eq i>selected</cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='90.Bitiş'> </td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.Bitiş Tarihi !'></cfsavecontent>
                    <cfinput type="text" name="finishdate" style="width:80px;" required="Yes" validate="#validate_style#" message="#message#" value="#finishdate#">
                    <cf_wrk_date_image date_field="finishdate">
                    <select name="event_finish_clock" id="event_finish_clock" style="width:50px;">
                        <option value="00" selected><cf_get_lang_main no='79.Saat'></option>
                        <cfloop from="1" to="23" index="i">
                            <cfoutput>
                                <option value="#i#" <cfif finishhour eq i>selected</cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                    <select name="event_finish_minute" id="event_finish_minute" style="width:50px;">
                        <option value="00" selected><cf_get_lang_main no='1415.dk'></option>
                        <cfloop from="05" to="55" index="i" step="5">
                            <cfoutput>
                                <option value="#i#" <cfif finishmin eq i>selected</cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                </td>
            </tr>
            <tr>
				<td><cf_get_lang_main no='157.Görevli'> *</td>
                <td>
                    <cfinput type="hidden" name="employee_id" id="employee_id" value="#get_assetp_reserve.EMPLOYEE_ID#">
                    <cfsavecontent variable="message1"><cf_get_lang no='81.Gorevli Seçmelisiniz'> !</cfsavecontent>
                    <cfinput type="text" name="employee_name" required="yes" message="#message1#" value="#get_emp_info(get_assetp_reserve.EMPLOYEE_ID,0,0)#" style="width:208px;" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0,0','EMPLOYEE_ID','employee_id','list_works','3','250');"> 
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_assetp_reserve.employee_id&field_name=upd_assetp_reserve.employee_name&select_list=1</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" style="vertical-align:bottom" title="<cf_get_lang no='75.Lider Seç'>"></a>
				</td>
            </tr>
		</table>
		<cf_popup_box_footer><cf_workcube_buttons type_format='1' is_upd='1' delete_page_url='#request.self#?fuseaction=assetcare.del_assetp_reserve&assetp_resid=#attributes.assetp_resid#' add_function='check()'></cf_popup_box_footer>
</cf_popup_box>
</cfform>
