<cfset attributes.UPD_ID = url.ship_id>
<cfscript>session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);</cfscript>
<cfinclude template="../query/get_upd_purchase.cfm">
<cfset attributes.ship_type = get_upd_purchase.ship_type>
<cfif not get_upd_purchase.recordcount>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfset attributes.company_id = get_upd_purchase.company_id>
<cfset company_id = get_upd_purchase.company_id>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=service.emptypopup_upd_purchase_ship" onsubmit="return (pre_submit());">
<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
<input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
<input type="hidden" name="upd_id" id="upd_id" value="<cfoutput>#attributes.upd_id#</cfoutput>">
<input type="hidden" name="service_id" id="service_id" value="<cfoutput>#attributes.service_id#</cfoutput>">  
<table class="dph">
    <tr>
        <td class="dpht"><a href="javascript:gizle_goster_basket(purchase_ship);">&raquo;</a><cf_get_lang no='204.Servis Giriş İrsaliyesi Güncelle'></td>
        <td class="dphb">
			<cfoutput>
                <a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#';self.close();"><img src="/images/barcode.gif" border="0" title="<cf_get_lang_main no='305.Garanti'>-<cf_get_lang_main no='306.Seri Nolar'>"></a>
                <cfif session.ep.our_company_info.workcube_sector eq 'it'>
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_ship_stock_rows&process_cat_id=#get_upd_purchase.ship_type#&upd_id=#attributes.SHIP_ID#&in_or_out=1','list');"><img src="/images/forklift.gif" border="0" title="<cf_get_lang_main no='2267.Stok Hareketler'>"></a>
                </cfif>
            </cfoutput>
        </td>
    </tr>
</table>
<cf_basket_form id="purchase_ship">
    <table>
    <cfoutput>
      <tr>
        <td width="70"><cf_get_lang_main no='388.İşlem Tipi'></td>
        <td width="170"><cf_workcube_process_cat process_cat="#get_upd_purchase.process_cat#"></td>
        <td width="60"><cf_get_lang_main no='726.İrsaliye No'> *</td>
        <td width="105">
          <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='726.İrsaliye No'></cfsavecontent>
          <cfinput type="text" name="ship_number" value="#get_upd_purchase.ship_number#" required="Yes" maxlength="50" message="#message#" style="width:80px;">
        </td>
        <td><cf_get_lang no='194.Sevk Metodu'></td>
        <td>
          <input type="hidden" name="ship_method" id="ship_method" value="#get_upd_purchase.ship_method#">
          <cfif len(get_upd_purchase.ship_method)>
            <cfset attributes.ship_method_id = get_upd_purchase.ship_method>
            <cfinclude template="../../stock/query/get_ship_method.cfm">
          </cfif>
          <input type="text" name="ship_method_name" id="ship_method_name" value="<cfif len(get_upd_purchase.ship_method)>#get_ship_method.ship_method#</cfif>" readonly style="width:150px;">
          <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
        </td>
    </tr>
    </cfoutput>
    <tr>
        <td><cf_get_lang_main no='107.Cari Hesap'> *</td>
        <td>
          <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_upd_purchase.company_id#</cfoutput>">
          <cfif len(get_upd_purchase.company_id) and get_upd_purchase.company_id neq 0>
            <cfinput type="text" name="comp_name" value="#get_par_info(get_upd_purchase.company_id,1,0,0)#" style="width:150px;">
          <cfelse>
            <cfquery name="GET_CONS_NAME_UPD" datasource="#DSN#">
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
            <cfinput type="text" name="comp_name" value="#get_cons_name_upd.company#" style="width:150px;">
          </cfif>
          <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&come=stock&var_new=form_basket</cfoutput>','list')"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a> 
        </td>
        <td><cf_get_lang no='195.İrsaliye Tarihi'> *</td>
        <td> 
          <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no='195.İrsaliye Tarihi'></cfsavecontent>
          <cfinput type="text" name="ship_date" validate="#validate_style#" value="#dateformat(get_upd_purchase.ship_date,dateformat_style)#" message="#message#" required="yes"  style="width:80px;">
          <cf_wrk_date_image date_field="ship_date" call_function="change_money_info">
        </td>
        <td><cf_get_lang_main no='1351.Depo'> *</td>
        <td>
        <!---Asagidaki Kod Degismeli (Arzu)--->
         <cfset search_dep_id = get_upd_purchase.department_in>
         <cfinclude template = "../../stock/query/get_dep_names_for_inv.cfm">
         <cfset txt_department_name = get_name_of_dep.department_head>
         <cfset branch_id = get_name_of_dep.branch_id>
         <cfif len(search_dep_id) and len(trim(get_upd_purchase.location_in))>
            <cfset search_location_id = get_upd_purchase.location_in>
            <cfinclude template="../../stock/query/get_location_for_inv.cfm">
            <cfset txt_department_name = txt_department_name & "-" & get_location.comment>
            <cfset txt_department_id = "#get_location.department_location#">
         <cfelse>
            <cfset txt_department_id = "#search_dep_id#">
            <cfset branch_id="">
          </cfif>
          <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#branch_id#</cfoutput>">
          <input type="hidden" name="location_id" id="location_id" value="<cfoutput>#get_upd_purchase.location_in#</cfoutput>">							
          <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_upd_purchase.department_in#</cfoutput>">
          <input type="text" name="department_name" id="department_name" value="<cfoutput>#txt_department_name#</cfoutput>" style="width:150px;">
          <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=department_name&field_id=department_id&field_location_id=location_id&branch_id=branch_id&is_delivery=1</cfoutput>','medium')" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
        </td>
     </tr>
     <tr>
        <td><cf_get_lang_main no='166.Yetkili'> *</td>
        <td>
			 <cfoutput>
             <input type="hidden" name="partner_id" id="partner_id" value="#get_upd_purchase.partner_id#">
             <input type="hidden" name="consumer_id" id="consumer_id" value="#get_upd_purchase.consumer_id#">
             </cfoutput>
             <cfif len(get_upd_purchase.company_id) and  get_upd_purchase.company_id neq 0>
                <input type="text" name="partner_name" id="partner_name" value="<cfoutput>#get_par_info(get_upd_purchase.partner_id,0,-1,0)#</cfoutput>" style="width:150px;">
             <cfelse>
                <input type="text" name="partner_name" id="partner_name" value="<cfoutput>#get_cons_name_upd.consumer_name# #get_cons_name_upd.consumer_surname#</cfoutput>" style="width:150px;">
              </cfif>
        </td>
        <td><cf_get_lang no='198.Fiili Sevk'> *</td>
        <td>
              <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no='82.Fiili Sevk Tarihi'></cfsavecontent>
              <cfinput type="text" name="deliver_date_frm" value="#dateformat(get_upd_purchase.deliver_date,dateformat_style)#" validate="#validate_style#" message="#message#" required="yes" style="width:80px;">
              <cf_wrk_date_image date_field="deliver_date_frm">
        </td>
        <td><cf_get_lang_main no='363.Teslim Alan'></td>
        <td> 
              <input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="<cfoutput>#get_upd_purchase.deliver_emp#</cfoutput>">
              <input type="text" name="deliver_get" id="deliver_get" value="<cfif isnumeric(get_upd_purchase.deliver_emp)><cfoutput>#get_emp_info(get_upd_purchase.deliver_emp,0,0)#</cfoutput></cfif>" readonly style="width:150px;">
              <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
        </td>
      </tr>
      <tr>
        <td colspan="5">
          <cfif get_inv.recordcount and get_inv.is_with_ship neq 1>
            <font color="FF0000"><cf_get_lang no='246.İrsaliyenin İlişkili Oldugu Faturalar'>:<cfoutput query="get_inv">#get_inv.invoice_number#<cfif get_inv.recordcount neq currentrow>,</cfif></cfoutput></font> 
          </cfif>
        </td>
      </tr>
    </table>
    <cf_basket_form_button>
        <cf_record_info query_name="get_upd_purchase">
        <input type="hidden" name="del" id="del" value="">
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
          <cfif len(get_upd_purchase.is_with_ship) and  get_upd_purchase.is_with_ship eq 1>
            <font color="FF0000"><cf_get_lang no='245.Bu İrsaliye, ilgili olduğu faturadan güncellenir'>!<cfif len(get_inv.invoice_number)><b> <cf_get_lang_main no='721.Fatura No'>: <cfoutput>#get_inv.invoice_number#</cfoutput></b></cfif></font>
          <cfelse>
            <cf_workcube_buttons is_upd='1' is_delete=false add_function='upd_form_function()' >
            <cfif not get_inv.recordcount>
                <cf_workcube_buttons
                        is_upd = '0'
                        is_reset=false
                        insert_info = '  Sil  '
                        is_cancel=false
                        add_function = 'cagir()'
                        insert_alert = 'Silmek İstediğinizden Emin misiniz?'>
            </cfif>
         </cfif>
    </cf_basket_form_button>
</cf_basket_form>
<cfset attributes.basket_id = 47>
<cfinclude template="../../objects/display/basket.cfm">
</cfform>  
<script type="text/javascript">
function add_irsaliye()
{
	if((form_basket.company_id.value.length && form_basket.company_id.value!="") &&(form_basket.department_id.value.length && form_basket.department_id.value!=""))
	{	
		str_irslink = '&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase=1&dept_id='+form_basket.department_id.value +'&company_id='+form_basket.company_id.value; //&id=purchase&sale_product=0
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list');
		return true;
	}
	else if (form_basket.company_id.value =="")
	{
		alert("<cf_get_lang_main no='73.Öncelik'> : <cf_get_lang_main no='246.Üye'>");
		return false;
	}
	else if (form_basket.department_id.value =="")
	{
		alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1351.Depo'>");
		return false;
	}
}

function upd_form_function()
{
	if(!chk_period(form_basket.ship_date,"İşlem")) return false;
	if(!chk_process_cat('form_basket')) return false;
	if(form_basket.ship_date.value.length)
	{
		if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",form_basket.ship_date.value, "<cf_get_lang no='247.İşlem Tarihi döneminize uygun değil'>!"))
			return false;
	}
	return true;
}
function cagir()
{
	if(!chk_process_cat('form_basket')) return false;
	<cfif len(get_inv.INVOICE_NUMBER)>
		if(!confirm("<cf_get_lang no='248.Bu irsaliye fatura ile ilişkilendirilmiş silmek istediğinizden emin misiniz'>?")) return false;
	</cfif>
	form_basket.del.value=1;
	return true;
}
</script>
