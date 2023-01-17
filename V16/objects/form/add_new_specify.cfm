<cfsetting showdebugoutput="no">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='34312.İlişki Ekle'></cfsavecontent>
<cf_box title="#message#">
        
        <cfform action="#request.self#?fuseaction=objects.emptypopup_add_specify" method="post" name="specifies">
        <cf_ajax_list>
        <cfinput type="Hidden" name="serial_no" value="#attributes.serial_no#">
        <cfinput type="Hidden" name="stock_id" value="#attributes.stock_id#">
        <tr class="color-row">
            <td><cf_get_lang dictionary_id='57637.Seri No'></td><cfoutput>
            <td><input type="text" value="#attributes.serial_no#" name="name" id="name" readonly="" style="width:140px;">
            </td></cfoutput>
        </tr>
        <tr class="color-row">
            <td><cf_get_lang dictionary_id='57800.Işlem tipi'></td>
            <td>
                <select name="type" id="type" style="width:140px;">
                     <option value="1191"><cf_get_lang dictionary_id='32858.Özel Giriş'></option>
                     <option value="1192"><cf_get_lang dictionary_id='32903.Özel çıkış'></option>
                 </select>
            </td>
        </tr>
        <tr class="color-row">
            <td><cf_get_lang dictionary_id='57574.Şirket'></td>
            <td><input type="hidden" name="company_id_1" id="company_id_1" value="">
                <input type="text" name="member_name_1" id="member_name_1" style="width:125px;" value="" onFocus="AutoComplete_Create('member_name_1','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0,0','PARTNER_ID,EMPLOYEE_ID,POSITION_CODE,COMPANY_ID','company_id_1','list_works','3','250');">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=specifies.member_name_1&field_comp_id=specifies.company_id_1','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
            </td>
        </tr>
        <tr height="35" class="color-row">
             <td colspan="2" style="text-align:right;"><cf_workcube_buttons is_upd='0'>
             </td>
        </tr>	
        </cf_ajax_list>
        </cfform>
</cf_box>
