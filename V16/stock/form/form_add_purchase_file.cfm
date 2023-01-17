<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<table class="dph">
    <tr>
      <td class="dpht"><a href="javascript:gizle_goster_basket(purchase_file);">&raquo;</a><cf_get_lang no='121.Alım İrsaliye Ekle'></td>
    </tr>
</table>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=stock.emptypopup_add_purchase" onsubmit="return ( pre_submit());">
<input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
     <cf_basket_form id="purchase_file">
        <table>
            <tr>
                <td><cf_get_lang_main no='388.işlem tipi'></td>
                <td width="200">
                <cf_workcube_process_cat>
                </td>
                <td><cf_get_lang_main no='726.İrsaliye No'>*</td>
                <td width="165">
                    <cfsavecontent variable="message"><cf_get_lang no='118.irsaliye no girmelisiniz'>!</cfsavecontent>
                    <cfinput type="text" name="ship_number" style="width:115px;"   required="Yes" message="#message#">
                </td>
                <td><cf_get_lang_main no='1703.sevk metod'></td>
                <td>
                    <input type="hidden" name="ship_method" id="ship_method" value="">
                    <cfinput type="text"  readonly name="ship_method_name"STYLE="width:150px;" value="" >
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='107.cari hesap'>*</td>
                <td> 
                    <input type="hidden" name="company_id" id="company_id">
                    <input type="text" name="comp_name" id="comp_name" style="width:150px;" readonly="">
                    <a href="#" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&come=stock&var_new=ship</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
                </td>
                <td><cf_get_lang_main no='330.tarih'>*</td>
                <td>
                    <cfinput type="text" name="ship_date" style="width:115px;" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" message="Tarih!">
                    <cf_wrk_date_image date_field="ship_date">
                </td>
                <td><cf_get_lang_main no='1351.depo'>*</td>
                <td>
                    <input type="hidden" name="location_id" id="location_id">						
                    <input type="hidden" name="department_id" id="department_id">
                    <cfsavecontent variable="message"><cf_get_lang no='109.depo girmelisiniz'>!</cfsavecontent>
                    <cfinput type="Text"  style="width:150px;" name="txt_departman_" required="yes" message="#message#" readonly>
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=txt_departman_&field_id=department_id&field_location_id=location_id','list')" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></cfoutput> 
                </td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='166.yetkili'></td>
                <td>
                    <input type="hidden" name="partner_id" id="partner_id">
                    <input type="hidden" name="consumer_id" id="consumer_id">
                    <input type="text" name="partner_name" id="partner_name" style="width:150px;" readonly="">
                </td>
                <td>
                <cf_get_lang no='127.fiili sevk tarihi'>
                </td>
                    <td>
                    <cfsavecontent variable="message"><cf_get_lang no='110.fiili sevk tarihi girmelisiniz'></cfsavecontent>
                    <cfinput type="text" name="deliver_date_frm" value="#dateformat(now(),dateformat_style)#" style="width:115px;" required="yes" message="#message#" validate="#validate_style#">
                    <cf_wrk_date_image date_field="deliver_date_frm">
                    </td>
                <td><cf_get_lang_main no='363.teslim alan'></td>
                <td>
                    <input type="hidden" name="deliver_get_id" id="deliver_get_id" value="">
                    <cfinput type="text" name="deliver_get" style="width:150px;"  readonly>
                    <a href="#" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id</cfoutput>','list')"><img src="/images/plus_thin.gif"  border="0" align="absmiddle"></a> 
                </td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='199.sipariş'></td>
                <td>
                    <input type="text" name="order_id" id="order_id" style="width:150px;">
                    <a href="#" onClick="windowopen('<cfoutput>#request.self#?fuseaction=stock.list_order_popup_purchase</cfoutput>','list');"><img border="0" name="imageField2" src="/images/plus_thin.gif"  align="absmiddle"></a>
                </td>
            </tr>
        </table>
        <cf_basket_form_button><cf_workcube_buttons is_upd='0' add_function='kontrol_firma()'></cf_basket_form_button>
    </cf_basket_form>
	<cfset attributes.basket_id = 11>
    <cfset attributes.basket_sub_id = 4>
    <cfinclude template="../../objects/display/basket.cfm">
</cfform>
<script type="text/javascript">
	function kontrol_firma()
	{
		if (!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if(form_basket.partner_id.value =="" && form_basket.consumer_id.value =="")
		{
			alert("<cf_get_lang no='131.Cari Hesap Seçmelisiniz'> !");
			return false;
		}
		return true;
	}
</script>
