<cfparam name="attributes.sube_pos_code" default="">
<cfparam name="attributes.sube_pos_name" default="">
<cfparam name="attributes.operasyon_pos_code" default="">
<cfparam name="attributes.operasyon_pos_name" default="">
<cfparam name="attributes.finans_pos_code" default="">
<cfparam name="attributes.finans_pos_name" default="">
<cfparam name="attributes.depo_kod_id" default="">
<cfparam name="attributes.branch_recordcount" default="">
<cfquery name="get_company_boyut_depo_kod" datasource="#dsn#">
	SELECT 
		DEPO_KOD_ID, 
		DEPO_ISMI, 
		SUBE_POS_CODE, 
		OPERASYON_POS_CODE, 
		FINANS_POS_CODE, 
		UPDATE_EMP, 
		UPDATE_DATE, 
		UPDATE_IP
	FROM 
		COMPANY_BOYUT_DEPO_KOD 
	ORDER BY 
		DEPO_ISMI
</cfquery>
<cf_form_box title="#lang_array.item[793]#"><!---Şube ve Operasyon Müdürleri--->
    <cfform name="upd_branch_position" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_branch_managers">
    <input type="hidden" name="branch_recordcount" id="branch_recordcount" value="<cfoutput>#get_company_boyut_depo_kod.recordcount#</cfoutput>">
        <cf_form_list>
        	<thead>
                <tr>
                    <th width="150"><cf_get_lang_main no='1735.Şube Adı'></th>
                    <th  width="140"><cf_get_lang no='440.Şube Müdürü'></th>
                    <th width="140"><cf_get_lang no='441.Operasyon Müdürü'></th>
                    <th width="140"><cf_get_lang no='442.Finans Şefi'></th>
                </tr>
            </thead>
            <cfoutput query="get_company_boyut_depo_kod">
            <tbody>
                <tr>
                    <td>#depo_ismi#
                        <cfinput type="hidden" name="depo_kod_id#currentrow#" value="#depo_kod_id#">
                    </td>
                    <td>
                        <cfinput type="hidden" name="sube_pos_code#currentrow#" value="#sube_pos_code#">
                        <cfinput type="text" name="sube_pos_name#currentrow#" value="#get_emp_info(sube_pos_code,1,0)#" style="width:120px;">
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_code=upd_branch_position.sube_pos_code#currentrow#&field_name=upd_branch_position.sube_pos_name#currentrow#&select_list=1','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </td>
                    <td>
                        <cfinput type="hidden" name="operasyon_pos_code#currentrow#" value="#operasyon_pos_code#">
                        <cfinput type="text" name="operasyon_pos_name#currentrow#" value="#get_emp_info(operasyon_pos_code,1,0)#" style="width:120px;">
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_code=upd_branch_position.operasyon_pos_code#currentrow#&field_name=upd_branch_position.operasyon_pos_name#currentrow#&select_list=1','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </td>
                    <td>
                        <cfinput type="hidden" name="finans_pos_code#currentrow#" value="#finans_pos_code#">
                        <cfinput type="text" name="finans_pos_name#currentrow#" value="#get_emp_info(finans_pos_code,1,0)#" style="width:120px;">
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_code=upd_branch_position.finans_pos_code#currentrow#&field_name=upd_branch_position.finans_pos_name#currentrow#&select_list=1','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </td>
                </tr>
            </tbody>
            </cfoutput>
        </cf_form_list>
        <cf_form_box_footer>
            <cf_workcube_buttons is_upd='1' is_delete='0'>
        </cf_form_box_footer>
    </cfform>
</cf_form_box>

