<cfscript>session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);</cfscript>
<cfset attributes.UPD_ID = URL.SHIP_ID>
<cfinclude template="../query/get_upd_purchase.cfm">
<cfset attributes.ship_type = get_upd_purchase.ship_type>
<cfif not get_upd_purchase.recordcount>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfset company_id = get_upd_purchase.company_id>
<cfset attributes.company_id = get_upd_purchase.company_id>
<table class="dph">
  <tr>
    <td class="dpht"><a href="javascript:gizle_goster_basket(sale_ship);">&raquo;</a><cf_get_lang no='209.Satış İrsaliye Güncelle'></td>
    <td class="dphb">
      <cfoutput>
      <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.UPD_ID#&print_type=30','page');"><img src="/images/print.gif" title="<cf_get_lang_main no='62.Yazdır'>" border="0"></a>
      <a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#';self.close();"><img src="/images/barcode.gif" border="0" title="<cf_get_lang_main no='305.Garanti'>-<cf_get_lang_main no='306.Seri Nolar'>"></a>
        <cfif session.ep.our_company_info.workcube_sector eq 'it'>
            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_ship_stock_rows&process_cat_id=#get_upd_purchase.ship_type#&upd_id=#attributes.UPD_ID#&in_or_out=0','list');"><img src="/images/forklift.gif" border="0" title="Stok Hareketler"></a>
        </cfif>
      </cfoutput>
    </td>
  </tr>
</table>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=service.emptypopup_upd_sale_ship" onsubmit="return (pre_submit());">
	<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
	<input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
	<input type="hidden" name="type_id" id="type_id" value="<cfoutput>#get_upd_purchase.ship_type#</cfoutput>">
	<input type="hidden" name="upd_id" id="upd_id" value="<cfoutput>#url.ship_id#</cfoutput>">
	<input type="hidden" name="service_id" id="service_id" value="<cfoutput>#attributes.service_id#</cfoutput>">
	<input type="hidden" name="del_ship" id="del_ship" value="0">
    <cf_basket_form id="sale_ship">
    <table>
        <tr>
            <td width="70"><cf_get_lang_main no='74.Kategori'></td>
            <td width="180"><cf_workcube_process_cat process_cat="#get_upd_purchase.process_cat#" onclick_function="check_process_is_sale();"></td>
            <td width="80"><cf_get_lang_main no='726.İrsaliye No'>*</td>
            <td width="100">
                <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='726.İrsaliye No'></cfsavecontent>
                <cfinput type="text" name="ship_number" value="#get_upd_purchase.ship_number#" required="Yes" maxlength="50" message="#message#" style="width:75px;">
            </td>
            <td width="70"><cf_get_lang no='194.Sevk Metodu'></td>
            <td>
                <input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#get_upd_purchase.ship_method#</cfoutput>">
                <cfif len(get_upd_purchase.ship_method)>
                <cfset attributes.ship_method_id=get_upd_purchase.ship_method>
                <cfinclude template="../query/get_ship_method.cfm">
                </cfif>
                <input type="text" name="ship_method_name" id="ship_method_name" value="<cfif len(get_upd_purchase.ship_method)><cfoutput>#ship_method.ship_method#</cfoutput></cfif>" readonly style="width:150px;">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='107.Cari Hesap'> *</td>
            <td>
                <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_upd_purchase.company_id#</cfoutput>">
                <cfif len(get_upd_purchase.company_id) and get_upd_purchase.company_id neq 0>
                <input type="text" name="comp_name" id="comp_name"  value="<cfoutput>#get_par_info(get_upd_purchase.company_id,1,0,0)#</cfoutput>" readonly style="width:150px;">
                <cfelse>
                <cfquery name="GET_CONS_NAME_UPD" datasource="#dsn#">
                    SELECT
                        CONSUMER_NAME,
                        CONSUMER_SURNAME,
                        COMPANY,
                        CONSUMER_ID
                    FROM
                        CONSUMER
                    WHERE
                        CONSUMER_ID = #get_upd_purchase.consumer_id#
                </cfquery>
                <input type="text" name="comp_name" id="comp_name" value="<cfoutput>#get_cons_name_upd.company#</cfoutput>" readonly style="width:150px;">
                </cfif>
            </td>
            <td><cf_get_lang no='195.İrsaliye Tarihi'> *</td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no='195.İrsaliye Tarihi'></cfsavecontent>
                <cfinput type="text" name="ship_date" required="Yes" message="#message#" validate="#validate_style#" value="#dateformat(get_upd_purchase.ship_date,dateformat_style)#" style="width:75px;">
                <cf_wrk_date_image date_field="ship_date" call_function="change_money_info">
            </td>
            <td><cf_get_lang_main no='1351.Depo'> *</td>
            <td>
				<cfset search_dep_id = get_upd_purchase.deliver_store_id>
                <cfinclude template = "../query/get_dep_names_for_inv.cfm">
                <cfset txt_department_name = get_name_of_dep.department_head>
                <cfset branch_id = get_name_of_dep.branch_id>
                <cfif len(search_dep_id) and len(trim(get_upd_purchase.location))>
                <cfset search_location_id = get_upd_purchase.location>
                <cfinclude template="../query/get_location_for_inv.cfm">
                <cfset txt_department_name = txt_department_name & "-" & get_location.comment>
                <cfset txt_department_id = "#get_location.department_location#">
                <cfelse>
                <cfset txt_department_id = "#search_dep_id#">
                <cfset branch_id="">
                </cfif>
                <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#branch_id#</cfoutput>">
                <input type="hidden" name="location_id" id="location_id" value="<cfoutput>#get_upd_purchase.location#</cfoutput>">							
                <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_upd_purchase.deliver_store_id#</cfoutput>">
                <input type="text" name="txt_departman_" id="txt_departman_" value="<cfoutput>#txt_department_name#</cfoutput>" readonly style="width:150px;">
                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=txt_departman_&field_id=department_id&field_location_id=location_id&is_delivery=1</cfoutput>','medium')" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='166.Yetkili'> *</td>
            <td>
				<cfoutput>
                <input type="hidden" name="partner_id" id="partner_id" value="#get_upd_purchase.partner_id#">
                <input type="hidden" name="consumer_id" id="consumer_id" value="#get_upd_purchase.consumer_id#">
                </cfoutput>
                <cfif len(get_upd_purchase.partner_id) and get_upd_purchase.partner_id neq 0>
                <input type="text" name="partner_name" id="partner_name" value="<cfoutput>#get_par_info(get_upd_purchase.partner_id,0,-1,0)#</cfoutput>" readonly style="width:150px;">
                <cfelse>
                <input type="text" name="partner_name" id="partner_name" value="<cfoutput>#get_cons_info(get_upd_purchase.consumer_id,0,0)#</cfoutput>" readonly style="width:150px;">
                </cfif>
            </td>
            <td width="80"><cf_get_lang no='198.Fiili Sevk'></td>
            <td>
                <cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang no='82.Fiili Sevk Tarihi'></cfsavecontent>
                <cfinput type="text" name="deliver_date_frm" validate="#validate_style#" value="#dateformat(get_upd_purchase.deliver_date,dateformat_style)#" message="#message#" style="width:75px;">
                <cf_wrk_date_image date_field="deliver_date_frm">
            </td>
            <td><cf_get_lang_main no='363.Teslim Alan'></td>
            <td>
                <cfinput type="text" name="deliver_get" value="#get_upd_purchase.deliver_emp#" style="width:150px;">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3,4,5,6&field_name=form_basket.deliver_get&field_partner=form_basket.deliver_get_id&come=stock</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang no='207.Sevk Adresi'> *</td>
            <td colspan="5">
                <input type="hidden" name="city_id" id="city_id" value="<cfoutput>#get_upd_purchase.city_id#</cfoutput>">
                <input type="hidden" name="county_id" id="county_id" value="<cfoutput>#get_upd_purchase.county_id#</cfoutput>">
                <input type="hidden" name="deliver_get_id" id="deliver_get_id" value="<cfif len(get_upd_purchase.deliver_emp)><cfoutput>#get_upd_purchase.deliver_emp#</cfoutput></cfif>">
                <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no='207.Sevk Adresi'></cfsavecontent>
                <cfinput type="text" name="adres" value="#trim(get_upd_purchase.address)#" required="yes" message="#message#" style="width:175px;">
                <a href="javascript://" onClick="add_adress();"><img border="0" src="/images/plus_thin.gif" align="absmiddle"></a><td>
            </td>
            </tr>
            <tr>
                <cfquery name="GET_INV" datasource="#DSN2#">
                SELECT
                INVOICE_NUMBER,
                SHIP_NUMBER,
                IS_WITH_SHIP
                FROM
                INVOICE_SHIPS
                WHERE
                SHIP_ID = #get_upd_purchase.ship_id# AND
                SHIP_PERIOD_ID = #session.ep.period_id#
                </cfquery>
            <td>
				<cfif get_inv.recordcount and get_inv.is_with_ship neq 1>
                <font color="FF0000">İrsaliyenin İlişkili Oldugu Fatura Noları:<cfoutput query="get_inv">#get_inv.invoice_number#<cfif get_inv.recordcount neq currentrow>,</cfif></cfoutput></font>
                </cfif>
            </td>
        </tr>
    </table>
    <cf_basket_form_button>
    	<cf_record_info query_name="get_upd_purchase">
        <input type="hidden" name="del" id="del" value="">
        <cfif len(get_upd_purchase.is_with_ship) and get_upd_purchase.is_with_ship eq 1>
            <font color="FF0000">Bu İrsaliye, ilgili olduğu faturadan güncellenir!<cfif len(get_inv.invoice_number)><b> Fatura No: <cfoutput>#get_inv.invoice_number#</cfoutput></b></cfif></font>
          <cfelse>
            <cf_workcube_buttons 
                is_upd='1'
                is_delete=false
                add_function='kontrol_firma()'>
            <cfif not get_inv.recordcount>
                <cf_workcube_buttons 
                    is_upd='0' 
                    is_delete=false
                    is_cancel=false
                    is_reset=false
                    insert_info='  Sil  '
                    add_function='kontrol2()'
                    insert_alert='Silmek İstediğinizden Emin misiniz?'>
            </cfif>
          </cfif>
    </cf_basket_form_button>
  </cf_basket_form>
  <cfset attributes.basket_id = 48>
  <cfinclude template="../../objects/display/basket.cfm">
</cfform>
<script type="text/javascript">
function add_irsaliye()
{
	if((form_basket.company_id.value.length!="" && form_basket.company_id.value!=""))
	{	
	str_irslink = '&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase=0&dept_id='+form_basket.department_id.value +'&company_id='+form_basket.company_id.value;//&id=purchase&sale_product=0
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list');
		return true;
	}
	else (form_basket.company_id.value =="")
	{
		alert("<cf_get_lang_main no='73.Öncelik'> : <cf_get_lang_main no='246.Üye'>");
		return false;
	}
}

function kontrol_firma()
{
	if(!chk_period(form_basket.ship_date,"İşlem")) return false;
	if(!chk_process_cat('form_basket')) return false;
	if(document.form_basket.txt_departman_.value=="")
		{
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1351.Depo'>");
			return false;
		}
	return true;
}

function kontrol2()
{	
	form_basket.del_ship.value =1;
	return true;
}

function check_process_is_sale()/*alım iadeleri satis karakterli oldugu halde alış fiyatları ile çalışması için*/
{
<cfif get_basket.basket_id is 10>
	var selected_ptype = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
	if(selected_ptype!='')
	{
		eval('var proc_control = document.form_basket.ct_process_type_'+selected_ptype+'.value');
		if(proc_control==78||proc_control==79)
			sale_product= 0;
		else
			sale_product = 1;
	}
	else
		return true;
<cfelse>
	return true;
</cfif>
}
function add_adress()
{
	if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value==""))
	{
		if(form_basket.company_id.value!="")
			{
				str_adrlink = '&field_long_adres=form_basket.adres';
				if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
				if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
				return true;
			}
		else
			{
				str_adrlink = '&field_long_adres=form_basket.adres'; 
				if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
				if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
				return true;
			}
	}
	else
	{
		alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1420.Abone'>");
		return false;
	}
}
check_process_is_sale();
</script>
