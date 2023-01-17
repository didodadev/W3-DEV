<cfsetting showdebugoutput="no">
<script type="text/javascript">
function specify_delete()
{
	document.update_specify.operation.value='del';
}
</script>
<cfsavecontent variable="Gncelle"><cf_get_lang dictionary_id='57703.Güncelleme'></cfsavecontent>
<cf_box title="#Gncelle#">
<cfform action="#request.self#?fuseaction=objects.emptypopup_upd_specify&stock_id=#attributes.stock_id#&serial_no=#attributes.serial_no#&guaranty_id=#attributes.guaranty_id#" method="post" name="update_specify">
<input type="Hidden" name="stock_id" id="stock_id" value="#attributes.stock_id#">
<input type="Hidden" name="serial_no" id="serial_no" value="#attributes.serial_no#">
<input type="hidden" name="guaranty_id" id="guaranty_id" value="#attributes.guaranty_id#">
<input type="hidden" name="operation" id="operation" value="upd" />
<cfquery name="up_specify" datasource="#dsn3#">
	SELECT * FROM SERVICE_GUARANTY_NEW WHERE GUARANTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guaranty_id#">
</cfquery>
<cf_ajax_list>
	<cfoutput query="up_specify">
        <tr>
            <td><cf_get_lang dictionary_id='57637.Seri No'></td>
            <td><input type="text" value="#SERIAL_NO#" name="name" id="name" readonly="" style="width:140px;"></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57800.Işlem tipi'></td>
            <td>
             <select name="type" id="type" style="width:140px;">
             <option value="1191" <cfif PROCESS_CAT eq 1191>selected</cfif>><cf_get_lang dictionary_id='32858.Özel Giriş'></option>
             <option value="1192" <cfif PROCESS_CAT eq 1192>selected</cfif>><cf_get_lang dictionary_id='32903.Özel çıkış'></option>
             </select></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='57574.Şirket'></td>
            <td><input type="hidden" name="company_id" id="company_id" value="<cfoutput><cfif len(up_specify.purchase_company_id)>#up_specify.purchase_company_id#<cfelse>#up_specify.sale_company_id#</cfif></cfoutput>">
                <input type="text" name="member_name" id="member_name" style="width:125px;" value="<cfoutput><cfif len(up_specify.purchase_company_id)>#get_par_info(up_specify.purchase_company_id,1,1,0)#<cfelseif len(up_specify.sale_company_id)>#get_par_info(up_specify.sale_company_id,1,1,0)#</cfif></cfoutput>">
                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=update_specify.member_name&field_comp_id=update_specify.company_id&field_member_name=update_specify.member_name','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
            </td>
        </tr>
        <tr height="35">
            <td colspan="2" style="text-align:right;"><cf_workcube_buttons is_upd='1' del_function="specify_delete()"></td>
        </tr>	
    </cfoutput>
</cf_ajax_list>
</cfform>
</cf_box>
