<cfinclude template="../query/get_emp_authority_codes.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55374.Pozisyon Yetki Kodları"></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="add_auth_code" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_emp_authority_codes&position_id=#attributes.position_id#">
    <cf_medium_list>
        <thead>
            <tr>
              <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
              <th><cf_get_lang dictionary_id="55452.Modül"></th>
              <th width="300"><cf_get_lang dictionary_id="55458.Yetki Kodu"></th>
            </tr>
        </thead>
        <tbody>
            <cfquery dbtype="query" name="GET_EMP_AUTHORITY_CODES_1">
            SELECT * FROM GET_EMP_AUTHORITY_CODES WHERE MODULE_ID = 3
            </cfquery>
            <!--- BK kapatti 20110322 6 aya silinsin
            <cfquery dbtype="query" name="GET_EMP_AUTHORITY_CODES_2">
            SELECT * FROM GET_EMP_AUTHORITY_CODES WHERE MODULE_ID = 4
            </cfquery>
            <cfquery dbtype="query" name="GET_EMP_AUTHORITY_CODES_3">
            SELECT * FROM GET_EMP_AUTHORITY_CODES WHERE MODULE_ID = 1
            </cfquery>
            <cfquery dbtype="query" name="GET_EMP_AUTHORITY_CODES_4">
            SELECT * FROM GET_EMP_AUTHORITY_CODES WHERE MODULE_ID = 5
            </cfquery> --->
            <cfoutput>
            <tr>
                <td>1</td>
                <td>
                    <cf_get_lang dictionary_id="57444.İnsan Kaynakları">
                    <input type="hidden" name="module_id_1" id="module_id_1" value="3">
                </td>
                <td><input type="text" name="authority_code_1" id="authority_code_1" value="#GET_EMP_AUTHORITY_CODES_1.AUTHORITY_CODE#" maxlength="50"></td>
            </tr>
            <!--- 
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td>2</td>
                <td>
                    Üye Yönetimi
                    <input type="hidden" name="module_id_2" value="4">
                </td>
                <td><input type="text" name="authority_code_2" value="#GET_EMP_AUTHORITY_CODES_2.AUTHORITY_CODE#" maxlength="50"></td>
            </tr>
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td>3</td>
                <td>
                    Projeler
                    <input type="hidden" name="module_id_3" value="1">
                </td>
                <td><input type="text" name="authority_code_3" value="#GET_EMP_AUTHORITY_CODES_3.AUTHORITY_CODE#" maxlength="50"></td>
            </tr>
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                <td>4</td>
                <td>
                    Ürün Yönetimi
                    <input type="hidden" name="module_id_4" value="5">
                </td>
                <td><input type="text" name="authority_code_4" value="#GET_EMP_AUTHORITY_CODES_4.AUTHORITY_CODE#" maxlength="50"></td>
            </tr> --->
            </cfoutput>
        </tbody>
    </cf_medium_list>
    <cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='0'></cf_popup_box_footer>
</cfform>
</cf_popup_box>
