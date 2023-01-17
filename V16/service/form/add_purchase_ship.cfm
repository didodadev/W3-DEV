<cfset get_date_bugun = dateformat(now(),dateformat_style)>
<cfset attributes.purchase_sale = 0>
<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfparam name="attributes.ship_date" default="#get_date_bugun#">
<cfquery name="GET_SERVICE" datasource="#DSN3#">
	SELECT
		SERVICE_PARTNER_ID,
		SERVICE_COMPANY_ID,
		SERVICE_CONSUMER_ID,
		PRO_SERIAL_NO,
		SERVICE_NO,
		STOCK_ID
	FROM
		SERVICE
	WHERE
		SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>
<cfscript>
	if(len(get_service.service_company_id))
	{
		company_id = get_service.service_company_id;
		company_name = '#get_par_info(company_id,1,1,0)#';
		consumer_id = '';
		if(len(get_service.service_partner_id))
		{
			partner_id = get_service.service_partner_id;
			partner_name = '#get_par_info(partner_id,0,-1,0)#';
		}
		else 
		{
			partner_id = '';
			partner_name = '';
		}
	}
	else if(len(get_service.service_consumer_id))
	{
		company_id = '';
		consumer_id = get_service.service_consumer_id;
		partner_id = '';
		company_name = '';
		partner_name = '#get_cons_info(consumer_id,0,0)#';
	}
</cfscript>
    <table class="dph">
        <tr>
            <td class="dpht"><a href="javascript:gizle_goster_basket(purchase_ship);">&raquo;</a><cf_get_lang no='191.Alış İrsaliyesi Ekle'></td>
        </tr>
    </table>
	<cfform name="form_basket" method="post" action="#request.self#?fuseaction=service.emptypopup_add_purchase_ship" onsubmit="return (pre_submit());">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="service_id" id="service_id" value="<cfoutput>#attributes.service_id#</cfoutput>">
    <input type="hidden" name="service_serial_no" id="service_serial_no" value="<cfoutput>#get_service.pro_serial_no#</cfoutput>">
    <input type="hidden" name="service_stock_id" id="service_stock_id" value="<cfoutput>#get_service.stock_id#</cfoutput>">
    <input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
    <input type="hidden" value="store" name="is_store" id="is_store">
    <cf_basket_form id="purchase_ship">
        <table>
          <tr>
            <td><cf_get_lang_main no='74.Kategori'> </td>
            <td width="180"><cf_workcube_process_cat></td>
            <td><cf_get_lang_main no='726.İrsaliye No'> *</td>
            <td width="135">
              <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='726.İrsaliye No'></cfsavecontent>
              <cfinput type="text" name="ship_number" required="Yes" maxlength="50" message="#message#" style="width:100px;" value="#get_service.service_no#">
            </td>
            <td><cf_get_lang no='194.Sevk Metodu'></td>
            <td>
              <input type="hidden" name="ship_method" id="ship_method" value="">
              <cfinput type="text" name="ship_method_name" value="" passthrough="readonly" style="width:150px;">
              <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','small');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
            </td>
          </tr>
          <tr>
            <td><cf_get_lang_main no='107.Cari Hesap'> *</td>
            <td>
              <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#company_id#</cfoutput>">
              <input type="text" name="comp_name" id="comp_name" value="<cfoutput>#company_name#</cfoutput>" readonly style="width:150px;">
              <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&come=store&var_new=form_basket</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
            </td>
            <td><cf_get_lang no='195.İrsaliye Tarihi'> *</td>
            <td>
              <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no='195.İrsaliye Tarihi'></cfsavecontent>
              <cfinput type="text" name="ship_date" value="#attributes.ship_date#" validate="#validate_style#" message="#message#" required="yes" style="width:100px;">
              <cf_wrk_date_image date_field="ship_date" call_function="change_money_info">
            </td>
            <td><cf_get_lang_main no='1351.Depo'> *</td>
            <td>
              <input type="hidden" name="branch_id" id="branch_id" value="">					  
              <input type="hidden" name="location_id" id="location_id" value="">
              <input type="hidden" name="department_id" id="department_id" value="">
              <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='1351.Depo'></cfsavecontent>
              <cfif isdefined("attributes.txt_departman_")>
                <cfinput type="text" name="txt_departman_" value="#attributes.txt_departman_#" required="yes" message="#message#" passthrough="readonly" style="width:150px;">
              <cfelse>
                <cfinput type="text" name="txt_departman_" value="" required="yes" message="#message#" passthrough="readonly" style="width:150px;">
              </cfif>
              <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=txt_departman_&field_id=department_id&field_location_id=location_id&branch_id=branch_id&is_delivery=1</cfoutput>','medium');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
            </td>
          </tr>
          <tr>
            <td><cf_get_lang_main no='166.Yetkili'> *</td>
            <td>
              <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#partner_id#</cfoutput>">
              <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#consumer_id#</cfoutput>">
              <input type="text" name="partner_name" id="partner_name" value="<cfoutput>#partner_name#</cfoutput>" readonly style="width:150px;">
            </td>
            <td><cf_get_lang no='198.Fiili Sevk'> *</td>
            <td>
              <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no='198.Fiili Sevk'></cfsavecontent>
              <cfinput type="text" name="deliver_date_frm" value="#get_date_bugun#" required="yes" message="#message#" validate="#validate_style#" style="width:100px;">
              <cf_wrk_date_image date_field="deliver_date_frm">
            </td>
            <td><cf_get_lang_main no='363.Teslim Alan'> *</td>
            <td>
              <input type="hidden" name="deliver_get_id" id="deliver_get_id" value="<cfoutput>#session.ep.userid#</cfoutput>">			  
              <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='363.Teslim Alan'></cfsavecontent>
              <cfinput type="text" name="deliver_get" value="#session.ep.name# #session.ep.surname#" required="yes" message="#message#" passThrough="readonly" style="width:150px;">
              <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
            </td>
          </tr>
        </table>
        <cf_basket_form_button><cf_workcube_buttons is_upd='0' add_function='kontrol_firma()'></cf_basket_form_button>
    </cf_basket_form>
    <cfset attributes.basket_id = 47>
    <cfinclude template="../../objects/display/basket.cfm">
</cfform>
<script type="text/javascript">
function kontrol_firma()
{
	if (!chk_process_cat('form_basket')) return false;
	if(!check_display_files('form_basket')) return false;
	if(!chk_period(form_basket.ship_date,"İşlem")) return false;
	if(form_basket.partner_id.value =="" && form_basket.consumer_id.value =="")
	{
		alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='107.Cari Hesap'>");
		return false;
	}
	return true;
}

function mal_alimi_sec()
{
	max_sel = form_basket.process_cat.options.length;
	for(my_i=0;my_i<=max_sel;my_i++)
	{
		deger = form_basket.process_cat.options[my_i].value;
		if(deger!="")
		{
			var fis_no = eval("form_basket.ct_process_type_" + deger );
			if(fis_no.value == 140)
			{
				form_basket.process_cat.options[my_i].selected = true;
				my_i = max_sel + 1;
			}
		}
	}
}
mal_alimi_sec();
</script>
