<cfquery name="GET_SERVICE" datasource="#DSN3#" maxrows="1">
	SELECT
		S.SERVICE_NO,
		S.SERVICE_BRANCH_ID,
		S.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		S.LOCATION_ID,
		S.SERVICE_PARTNER_ID,
		S.SERVICE_COMPANY_ID,
		S.SERVICE_CONSUMER_ID,
		S.SERVICE_ADDRESS
	FROM
		SERVICE S,
		#dsn_alias#.DEPARTMENT D
	WHERE
		S.SERVICE_ID IN (#attributes.service_ids#) AND
		S.DEPARTMENT_ID = D.DEPARTMENT_ID
</cfquery>
<cfif not GET_SERVICE.recordcount>
	<script type="text/javascript">
		alert('Servis Bulunamadı veya Servis Lokasyonu Hatalı!Lütfen Düzenleyiniz!');
		history.back();
	</script>
	<cfabort>
</cfif>
	
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
<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<table class="dph">
  <tr>
     <td class="dpht"><a href="javascript:gizle_goster_basket(sale_ship);">&raquo;</a><cf_get_lang no='206.Satış İrsaliyesi Ekle'></td>
  </tr>
</table>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=service.emptypopup_add_sale_ship" onsubmit="return (pre_submit());">
    <input type="hidden" name="paper_number" id="paper_number" value="<cfif isdefined("paper_number")><cfoutput>#paper_number#</cfoutput></cfif>">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <cfif fusebox.fuseaction contains 'popup'>
        <input type="hidden" name="is_popup" id="is_popup" value="1">
    </cfif>
    <cfif listlen(attributes.service_ids) eq 1>
        <input type="hidden" name="service_id" id="service_id" value="<cfoutput>#attributes.service_ids#</cfoutput>">
    <cfelse>
        <input type="hidden" name="service_id_list" id="service_id_list" value="<cfoutput>#attributes.service_ids#</cfoutput>">
    </cfif>
    <input type="hidden" name="sale" id="sale" value="1">
    <cf_basket_form id="sale_ship">
        <table>
              <tr>
                <td><cf_get_lang_main no='388.İşlem Tipi'></td>
                <td width="200">
                  <cfif isdefined("attributes.process_cat")>
                    <cfoutput><cf_workcube_process_cat  process_cat="#attributes.process_cat#"></cfoutput>
                  <cfelse>
                    <cf_workcube_process_cat> 
                  </cfif>				</td>
                <td><cf_get_lang_main no='726.İrsaliye No'> *</td>
                <td width="100">
                  <cfset txt_paper=get_service.service_no>
                  <cfsavecontent variable="message"><cf_get_lang no='193.İrsaliye No Girmelisiniz'></cfsavecontent>
                  <cfinput type="text" name="ship_number"  value="#txt_paper#" required="Yes" maxlength="50" message="#message#" style="width:75px;">				</td>
                <td><cf_get_lang no='194.Sevk Metodu'></td>
                <td>
                  <input type="hidden" name="ship_method" id="ship_method" value="">
                  <input type="text" name="ship_method_name" id="ship_method_name" value="" readonly style="width:150px;">
                  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>				</td>
              </tr>
              <tr>
                <td><cf_get_lang_main no='107.Cari Hesap'> *</td>
                <td>
                  <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#company_id#</cfoutput>">
                  <input type="text" name="comp_name" id="comp_name" style="width:150px;" readonly="" value="<cfoutput>#company_name#</cfoutput>">
                  <!--- <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&come=stock&field_address=form_basket.adres&field_city_id=form_basket.city_id&field_county_id=form_basket.county_id</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a> --->				</td>
                <td><cf_get_lang no='195.İrsaliye Tarihi'> *</td>
                <td>
                  <input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
                  <cfsavecontent variable="message"><cf_get_lang no='196.İrsaliye Tarihi Girmelisiniz'></cfsavecontent>
                  <cfif isdefined("attributes.ship_date")>
                    <cfinput name="ship_date" type="text" value="#attributes.ship_date#" required="Yes" message="#message#" validate="#validate_style#" style="width:75px;">	
                  <cfelse>
                  	<cfinput name="ship_date" type="text" value="#dateformat(now(),dateformat_style)#" required="Yes" message="#message#" validate="#validate_style#" style="width:75px;">
                  </cfif>
                  <cf_wrk_date_image date_field="ship_date" call_function="change_money_info"></td>
                <td><cf_get_lang_main no='1351.Depo'> *</td>
                <td>
                  <input type="hidden" name="location_id" id="location_id" value="<cfoutput>#get_service.location_id#</cfoutput>">				
                  <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_service.service_branch_id#</cfoutput>">
                  <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_service.department_id#</cfoutput>">
                  <cfif get_service.recordcount>
                    <cfset attributes.txt_departman_ = '#get_service.department_head#'>
                  </cfif>
                  <cfsavecontent variable="message"><cf_get_lang no='197.Depo Girmelisiniz'>!</cfsavecontent>
                  <cfif isdefined("attributes.txt_departman_")>
                    <input type="text" name="txt_departman_" id="txt_departman_" value="<cfoutput>#attributes.txt_departman_#</cfoutput>" readonly style="width:150px;">
                  <cfelse>
                    <input type="text" style="width:150px;" name="txt_departman_" id="txt_departman_" value="" readonly="">
                  </cfif>
                  <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=txt_departman_&field_id=department_id&field_location_id=location_id&branch_id=branch_id&is_delivery=1','medium')" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></cfoutput></a>				</td>
              </tr>
              <tr>
                <td><cf_get_lang_main no='166.Yetkili'></td>
                <td>
                  <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#partner_id#</cfoutput>">
                  <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#consumer_id#</cfoutput>">
                  <input type="text" name="partner_name" id="partner_name" value="<cfoutput>#partner_name#</cfoutput>" readonly style="width:150px;">				</td>
                <td><cf_get_lang no='198.Fiili Sevk'></td>
                <td>
                  <cfif isdefined("attributes.ship_date")>
                    <cfinput name="deliver_date_frm" type="text" value="#attributes.ship_date#" required="Yes" message="#message#" validate="#validate_style#" style="width:75px;">	
                  <cfelse>
                  <cfinput name="deliver_date_frm" type="text" value="#dateformat(now(),dateformat_style)#" required="Yes" message="#message#" validate="#validate_style#" style="width:75px;">
                  </cfif>
                      <cf_wrk_date_image date_field="deliver_date_frm"></td>
                <td><cf_get_lang_main no='363.Teslim Alan'></td>
                <td nowrap>
                  <input type="hidden" name="deliver_get_id" id="deliver_get_id" value="">
                  <input type="hidden" name="deliver_get_id_consumer" id="deliver_get_id_consumer"  value="">
                  <input type="text" name="deliver_get" id="deliver_get" style="width:150px;" >
                  <a href="javascript://" name="del_get_id" id="del_get_id" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3,4,5,6&field_name=form_basket.deliver_get&field_partner=form_basket.deliver_get_id&field_consumer=form_basket.deliver_get_id_consumer&come=stock</cfoutput>','list');">
                  <img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>			   </td>
              </tr>
              <tr>
                <td><cf_get_lang no='207.Sevk Adresi'> *</td>
                <td colspan="3">
                  <input type="hidden" name="city_id" id="city_id" value="">
                  <input type="hidden" name="county_id" id="county_id" value="">
                  <cfsavecontent variable="message"><cf_get_lang no='208.sevk adresi girmelisiniz'>!</cfsavecontent>
                  <cfinput type="text" name="adres" value="#get_service.SERVICE_ADDRESS#" required="yes" message="#message#" style="width:180px;">
                  <a href="javascript://" onClick="add_adress();"><img border="0" name="imageField2" src="/images/plus_thin.gif"></a>
                </td>
              </tr>
        </table>
        <cf_basket_form_button><cf_workcube_buttons is_upd='0' add_function='kontrol_firma()'></cf_basket_form_button>
    </cf_basket_form>
    <cfset attributes.basket_id = 48>
    <cfinclude template="../../objects/display/basket.cfm">
</cfform>
<script type="text/javascript">
function add_irsaliye()
{	
	if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!=""))
	{	
	str_irslink = '&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase=0&dept_id='+form_basket.department_id.value +'&company_id='+form_basket.company_id.value; 
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list');
		return true;
	}
	else (form_basket.company_id.value =="")
	{
		alert("<cf_get_lang no='131.Cari Hesap Seçmelisiniz'> !");
		return false;
	}
}

function kontrol_firma()
{
	if(!chk_period(form_basket.ship_date,"İşlem")) return false;
	if(!chk_process_cat('form_basket')) return false;
	if(form_basket.partner_id.value =="" && form_basket.consumer_id.value =="")
	{
		alert("<cf_get_lang no='203.Cari Hesap Seçmelisiniz'> !");
		return false;
	}
	if(document.form_basket.txt_departman_.value=="")
	{
		alert("<cf_get_lang no='202.Depo Girmelisiniz'>");
		return false;
	}
	return true;
}

<cfif not isdefined("attributes.process_cat")>
function toptan_satis_sec()
{
	max_sel = form_basket.process_cat.options.length;
	for(my_i=0;my_i<=max_sel;my_i++)
	{
		deger = form_basket.process_cat.options[my_i].value;
		if(deger!="")
		{
			var fis_no = eval("form_basket.ct_process_type_" + deger );
			if(fis_no.value == 141)
			{
				form_basket.process_cat.options[my_i].selected = true;
				my_i = max_sel + 1;
			}
		}
	}
}
toptan_satis_sec();
</cfif>

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
		alert("<cf_get_lang no='203.Cari Hesap Seçmelisiniz'>!");
		return false;
	}
}
</script>
