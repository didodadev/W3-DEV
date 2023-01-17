<cfsetting showdebugoutput="no">
<cfquery name="GET_KMS" datasource="#DSN#">
	SELECT 
		ASSET_P_KM_CONTROL.*, 
		ASSET_P.ASSETP,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM
		ASSET_P_KM_CONTROL,
		ASSET_P,
		BRANCH,
		DEPARTMENT,
		EMPLOYEES
	WHERE
		ASSET_P_KM_CONTROL.IS_COUNTER_CHANGE = 1 AND
		ASSET_P_KM_CONTROL.START_DATE IS NOT NULL AND
		ASSET_P_KM_CONTROL.ASSETP_ID = ASSET_P.ASSETP_ID AND
		ASSET_P_KM_CONTROL.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID	AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		ASSET_P_KM_CONTROL.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		ASSET_P_KM_CONTROL.ASSETP_ID = #attributes.assetp_id#
	ORDER BY 
		KM_CONTROL_ID DESC
</cfquery>

<cfquery name="GET_ASSETP" datasource="#DSN#">
	SELECT FIRST_KM FROM ASSET_P WHERE ASSETP_ID = #attributes.assetp_id#
</cfquery>

<cfquery name="GET_KM_END" datasource="#DSN#" maxrows="1">
	SELECT KM_FINISH,IS_COUNTER_CHANGE,KM_CONTROL_ID FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = #attributes.assetp_id# ORDER BY KM_CONTROL_ID DESC
</cfquery>
<div id="km_counter_div">
<cf_medium_list_search title="#getLang('assetcare',700)#">
    <cf_medium_list_search_area><!-- sil --><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' is_ajax="1" tag_module="km_counter_div"><!-- sil --></cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
    <thead>
        <tr>
        	<th><cf_get_lang_main no="1165. Sıra"></th>
            <th width="100"><cf_get_lang_main no='1656.Plaka'></th>
            <th width="100"><cf_get_lang_main no='132.Sorumlu'></th>
            <th width="150"><cf_get_lang no='229.Kullanan Şube'></th>
            <th width="85"><cf_get_lang_main no='243.Baş Tarihi'></th>
            <th width="80"><cf_get_lang_main no='288.Bit Tarihi'></th>
            <th width="80" style="text-align:right;"><cf_get_lang no='218.İlk Km'></th>
            <th width="80" style="text-align:right;"><cf_get_lang no='219.Son Km'></th>
            <th width="10" style="text-align:center;">
                <!--- kayıt var ve son km girilmis ise arac tahsisde degilse --->
                <cfif get_km_end.recordcount and get_km_end.recordcount and len(get_km_end.km_finish) and get_assetp.first_km neq get_km_end.km_finish and get_km_end.is_counter_change neq 1>
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=assetcare.popup_add_km_counter_change&assetp_id=#attributes.assetp_id#</cfoutput>','small');"><img src="/images/plus_list.gif"  border="0" align="absmiddle" alt="<cf_get_lang_main no ='170.Ekle'>" title="<cf_get_lang_main no ='170.Ekle'>"></a>
                </cfif>
            </th>
        </tr>
    </thead>
    <tbody>
        <cfif get_kms.recordcount>
        <cfoutput query="get_kms">
            <tr>
            	<td>#currentrow#</td>
                <td>#assetp#</td>
                <td>#employee_name# #employee_surname#</td>
                <td width="150">#branch_name# - #department_head#</td>
                <td>#dateformat(start_date,dateformat_style)#</td>
                <td>#dateformat(finish_date,dateformat_style)#</td>
                <td style="text-align:right;">#tlformat(km_start,0)#</td>
                <td style="text-align:right;">#tlformat(km_finish,0)#</td>
                <td>
                    <cfif get_kms.km_control_id eq get_km_end.km_control_id>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=assetcare.emptypopup_del_vehicle_km_counter_change&km_control_id=#km_control_id#','small');"><img src="/images/delete_list.gif" border="0" alt="<cf_get_lang_main no='51.Sil'>" title="<cf_get_lang_main no='51.Sil'>">
                    </cfif>
                </td>
            </tr>
          </cfoutput>
          <cfelse>
            <tr>
                <td colspan="9"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
            </tr>
        </cfif>
    </tbody>
</cf_medium_list>
</div>
