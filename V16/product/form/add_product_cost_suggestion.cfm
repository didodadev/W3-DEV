<cf_get_lang_set module_name="product"><!--- sayfanin en altinda kapanisi var ---> 
<cfparam name="attributes.period_id" default="#session.ep.period_id#">
<cfparam name="attributes.act_id" default="">
<cfparam name="attributes.act_type" default="1">
<cfparam name="attributes.cost_date" default="#dateformat(now(),dateformat_style)#">
<cf_date tarih = 'attributes.cost_date'>
<cfquery name="GET_SETUP_PERIOD" datasource="#DSN#">
	SELECT PERIOD_ID,INVENTORY_CALC_TYPE FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.COMPANY_ID#
</cfquery>
<cfset period_id_list = ValueList(GET_SETUP_PERIOD.PERIOD_ID,',')>
<cfinclude template="../query/get_product_cost_param.cfm">
<cfinclude template="../query/get_money.cfm"><!--- SETUP MNYDEN ALINIYOR AMA ELLE MALİYET GİRİLECEĞİNDE TARİHTEDKİ STOKDA KURLARDA O ZAMANDAN ALINMALI --->
<cfif not len(GET_SETUP_PERIOD.inventory_calc_type)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='37740.Bu sayfayı kullanabilmek için önce ilgili ürünün detayında envanter yöntemi seçmelisiniz'> !");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfscript>
	if(session.ep.isBranchAuthorization and listlen(session.ep.user_location,"-") eq 3)
	{
		departmetn_id = ListGetAt(session.ep.user_location,1,"-");
		location_id = ListGetAt(session.ep.user_location,3,"-");
	}else
	{
		departmetn_id = '';//GET_PRODUCT_COST.DEPARTMENT_ID;
		location_id = '';//GET_PRODUCT_COST.LOCATION_ID;
	}
	spec_main_id = GET_PRODUCT_COST.SPECT_MAIN_ID;
	if(fusebox.circuit is 'product')
	{
		reference_money=GET_PRODUCT_COST.PURCHASE_NET_MONEY;
		alis_net_fiyat = GET_PRODUCT_COST.PURCHASE_NET;
		alis_net_fiyat2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
		alis_net_fiyat_money = "#reference_money#";
		alis_ek_maliyet = GET_PRODUCT_COST.PURCHASE_EXTRA_COST;
		alis_ek_maliyet2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM;
		alis_ek_maliyet_money = "#reference_money#";
		son_st_maliyet = get_product_cost.STANDARD_COST;
		son_st_maliyet_money = get_product_cost.STANDARD_COST_MONEY;
		son_st_maliyet_oran = get_product_cost.STANDARD_COST_RATE;
	}else
	{
		reference_money=GET_PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION;
		alis_net_fiyat = GET_PRODUCT_COST.PURCHASE_NET_LOCATION;
		alis_net_fiyat2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION;
		alis_net_fiyat_money = "#reference_money#";
		alis_ek_maliyet = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_LOCATION;
		alis_ek_maliyet2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_LOCATION;
		alis_ek_maliyet_money = "#reference_money#";
		son_st_maliyet = get_product_cost.STANDARD_COST_LOCATION;
		son_st_maliyet_money = get_product_cost.STANDARD_COST_MONEY_LOCATION;
		son_st_maliyet_oran = get_product_cost.STANDARD_COST_RATE_LOCATION;
	}
</cfscript>
<cfquery name="GET_STOCK" datasource="#DSN3#">
	SELECT
		STOCK_ID,
		STOCK_CODE
	FROM
		STOCKS
	WHERE
		PRODUCT_ID=#attributes.pid#
</cfquery>
<cfif session.ep.period_year gt 2008 and alis_net_fiyat_money  is 'YTL'><cfset alis_net_fiyat_money = 'TL'></cfif>
<cfif session.ep.period_year gt 2008 and son_st_maliyet_money  is 'YTL'><cfset son_st_maliyet_money = 'TL'></cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37664.Maliyet Önerisi Ekle'></cfsavecontent>
<cfsavecontent variable="message2"><cf_get_lang dictionary_id='58601.Bazında'></cfsavecontent>
<cf_popup_box title="#message#  #get_stock.stock_code# - #get_product.product_name# / #product_unit_name# #message2#">
    <cfform action="#request.self#?fuseaction=product.emptypopup_add_product_cost_suggestion" method="post" name="product_cost_y">
        <input type="hidden" name="cost_control" id="cost_control" value="0">
        <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#pid#</cfoutput>">
        <input type="hidden" name="unit_id" id="unit_id" value="<cfoutput>#product_unit#</cfoutput>">
        <input type="hidden" name="action_amount" id="action_amount" value="">
        <input type="hidden" name="action_row_id" id="action_row_id" value="">
        <input type="hidden" name="action_id" id="action_id" value="<!--- <cfoutput>#attributes.act_id#</cfoutput> --->">
        <input type="hidden" name="action_type" id="action_type" value="<!--- <cfoutput>#attributes.act_type#</cfoutput> --->"><!--- 1: FATURA, 2: SİPARİŞ 3:ÜRETİM TİPİ 4:stok virman--->
        <input type="hidden" name="action_period_id" id="action_period_id" value="<cfoutput>#session.ep.period_id#</cfoutput>">
        <input type="hidden" name="action_ids" id="action_ids" value="">
        <cfoutput query="GET_MONEY">
        <input type="hidden" name="money_#money#" id="money_#money#" value="#wrk_round(rate2/rate1,4)#">
        </cfoutput>
        <input type="hidden" name="reference_money" id="reference_money" value="<cfoutput>#reference_money#</cfoutput>">
       <table>
        <tr>
            <td width="130"><cf_get_lang dictionary_id='37510.Envanter Yöntemi'></td>
            <td width="170">
                <select name="inventory_calc_type" id="inventory_calc_type" style="width:140px;" disabled="disabled">
                    <option value="1"<cfif GET_SETUP_PERIOD.inventory_calc_type eq 1> selected</cfif>><cf_get_lang dictionary_id='37080.İlk Giren İlk Çıkar'></option><!--- 1:fifo --->
                    <option value="3"<cfif GET_SETUP_PERIOD.inventory_calc_type eq 3> selected</cfif>><cf_get_lang dictionary_id='37082.Ağırlıklı Ortalama'></option><!--- 3:gpa --->
                </select>	
                <cfinput type="hidden" name="inventory_calc_type" value="#GET_SETUP_PERIOD.inventory_calc_type#">
            </td>
            <td width="130"><cf_get_lang dictionary_id='57742.Tarih'></td>							
            <td>
                <input type="hidden" name="old_start_date" id="old_start_date" value="<cfoutput>#dateformat(attributes.cost_date,dateformat_style)#</cfoutput>">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
                <cfinput type="text" name="start_date" value="#dateformat(attributes.cost_date,dateformat_style)#" readonly required="Yes" validate="#validate_style#" message="#message#" style="width:65px;" onBlur="return(get_stock());">
                <cf_wrk_date_image date_field="start_date" call_function="get_stock">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='37511.Sabit Maliyet'></td>
            <td>
                <input name="standard_cost" id="standard_cost" style="width:91px;" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));' onBlur="hesapla();" value="<cfoutput>#tlformat(son_st_maliyet,4)#</cfoutput>"> 
                <select name="standard_cost_money" id="standard_cost_money" onBlur="hesapla();">
                <cfloop query="get_money">
                <option value="<cfoutput>#money#</cfoutput>" <cfif son_st_maliyet_money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>								
                </cfloop>
                </select>
            </td>
            <td><cf_get_lang dictionary_id='57647.Spec'></td>
            <td>
            <cfif len(spec_main_id)>
                <cfquery name="GET_SPECT_MAIN_NAME" datasource="#DSN3#">
                    SELECT
                        SPECT_MAIN_ID,
                        SPECT_MAIN_NAME
                    FROM
                        SPECT_MAIN
                    WHERE
                        SPECT_MAIN_ID = #spec_main_id#
                </cfquery>
            </cfif>
                <input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput>#spec_main_id#</cfoutput>">
                <input type="text" name="spect_name" id="spect_name" value="<cfif isdefined("GET_SPECT_MAIN_NAME")><cfoutput>#GET_SPECT_MAIN_NAME.SPECT_MAIN_NAME#</cfoutput></cfif>" style="width:150px;">
                <a href="javascript://" onClick="open_spec_popup();"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
            </td>
        </tr>
        <tr>
            <td nowrap="nowrap"><cf_get_lang dictionary_id='37513.Sabit Maliyet Oran'> % </td>
            <td><input style="width:91px" class="moneybox" name="standard_cost_rate" id="standard_cost_rate" onkeyup='return(FormatCurrency(this,event));' onBlur="hesapla();" value="<cfoutput>#tlformat(son_st_maliyet_oran)#</cfoutput>"></td>
            <cfif len(departmetn_id)>
                <cfquery name="GET_DEPARTMENT" datasource="#DSN#">
                    SELECT
                        DEPARTMENT_HEAD
                    FROM 
                        DEPARTMENT
                    WHERE
                        DEPARTMENT_ID = #departmetn_id#
                </cfquery>
                <cfif len(location_id)>
                    <cfquery name="GET_LOCATION" datasource="#DSN#">
                        SELECT
                            COMMENT
                        FROM
                            STOCKS_LOCATION
                        WHERE
                            LOCATION_ID = #location_id# AND
                            DEPARTMENT_ID = #departmetn_id#
                    </cfquery>
                </cfif>
            </cfif>
            <td><cf_get_lang dictionary_id='58763.Depo'></td>
            <td>
                <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("GET_LOCATION")><cfoutput>#departmetn_id#</cfoutput></cfif>">
                <input type="hidden" name="location_id" id="location_id" value="<cfif isdefined("GET_LOCATION")><cfoutput>#location_id#</cfoutput></cfif>">
                <input type="text" name="department" id="department" <cfif fusebox.Circuit eq 'product'>onchange="location_price_protec_suggestion();"</cfif> value="<cfif isdefined("GET_LOCATION")><cfoutput>#GET_DEPARTMENT.DEPARTMENT_HEAD# - #GET_LOCATION.COMMENT#</cfoutput></cfif>" style="width:150px;">
                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=product_cost_y&field_name=department&field_location_id=location_id&field_id=department_id<cfif session.ep.isBranchAuthorization>&function_name=get_stock<cfelse>&function_name=location_price_protec</cfif>','medium');"><img src="/images/plus_thin.gif"  border="0" align="absmiddle"></a>
            </td>
        </tr>
        <tr>
       		<td><cf_get_lang dictionary_id='37515.Alışlardan Net Maliyet'> </td>
            <td>
                <input type="hidden" name="old_purchase_net" id="old_purchase_net" value="<cfoutput>#tlformat(alis_net_fiyat,4)#</cfoutput>">
                <input type="hidden" name="old_purchase_net_money" id="old_purchase_net_money" value="<cfoutput>#alis_net_fiyat_money#</cfoutput>">
                <input name="purchase_net" id="purchase_net" style="width:91px" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));' onBlur="hesapla();" value="<cfoutput>#tlformat(alis_net_fiyat,4)#</cfoutput>">
                <select name="purchase_net_money" id="purchase_net_money" onBlur="hesapla();">
                    <cfloop query="get_money">
                        <option value="<cfoutput>#money#</cfoutput>" <cfif alis_net_fiyat_money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>								
                    </cfloop>
                </select>
            </td>
            <td><cf_get_lang dictionary_id='37512.Mevcut Stok'></td>
            <td><input style="width:150px" class="moneybox" name="available_stock" id="available_stock" onkeyup='return(FormatCurrency(this,event));'></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='37517.Alışlardan Ek Maliyet'></td>
            <td>
                <input type="hidden" name="old_purchase_extra_cost" id="old_purchase_extra_cost" value="<cfoutput>#alis_ek_maliyet#</cfoutput>">
                <input name="purchase_extra_cost" id="purchase_extra_cost" style="width:91px" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));' onBlur="hesapla();" value="<cfoutput>#tlformat(alis_ek_maliyet,4)#</cfoutput>">
            </td>
            <td nowrap="nowrap"><cf_get_lang dictionary_id='37514.İş Ortakları Stoğu'></td>
            <td><input style="width:150px" class="moneybox" name="partner_stock" id="partner_stock" onkeyup='return(FormatCurrency(this,event));' value="<cfoutput>#TLFormat(0)#</cfoutput>"></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='37518.Fiyat Koruma'> / <cf_get_lang dictionary_id='37547.Düzenleme'></td>
            <td>
                <input name="price_protection" id="price_protection" style="width:91px" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));' onBlur="hesapla();"> 
                <select name="price_protection_money" id="price_protection_money" onBlur="hesapla();">
                <cfloop query="get_money">
                <option value="<cfoutput>#money#</cfoutput>" <cfif session.ep.money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>								
                </cfloop>
                </select>
            </td>
            <td valign="top"><cf_get_lang dictionary_id='58047.Yoldaki Stok'> </td>
            <td valign="top"><input style="width:150px" name="active_stock" id="active_stock" class="moneybox" onkeyup='return(FormatCurrency(this,event));'></td>
        </tr>
        <tr>
            <td width="90"><cf_get_lang dictionary_id='29533.Tedarikçi'></td>
            <td>
                <input type="hidden" name="td_company_id" id="td_company_id" value="">
                <input type="text" name="td_company" id="td_company" style="width:130px;" value="">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=product_cost_y.td_company&field_comp_id=product_cost_y.td_company_id&select_list=2&keyword='+encodeURIComponent(document.product_cost_y.td_company.value),'list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
            </td>
            <td><cf_get_lang dictionary_id='37648.Maliyet Tipi'></td>
            <td><select name="cost_type" id="cost_type" style="width:150px;">
                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfquery name="GET_COST_TYPE" datasource="#DSN#">
                        SELECT COST_TYPE_ID,COST_TYPE_NAME FROM SETUP_COST_TYPE 
                    </cfquery>
                    <cfoutput query="GET_COST_TYPE"><option value="#COST_TYPE_ID#">#COST_TYPE_NAME#</option></cfoutput>
                </select>
            </td>
        </tr>
        <tr id="tr_1" style="display:none">
            <td><cf_get_lang dictionary_id='37497.Toplam Maliyet'></td>
            <td>
                <input name="product_cost" id="product_cost" style="width:91px" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));' readonly="yes" value="">
                <select name="product_cost_money" id="product_cost_money" disabled>
                    <cfloop query="get_money">
                    <option value="<cfoutput>#money#</cfoutput>" <cfif alis_net_fiyat_money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>								
                    </cfloop>
                </select>
            </td>
            <cfif session.ep.isBranchAuthorization eq 0>
            <td width="130" id="price_protec_td1"><cf_get_lang dictionary_id='37649.Lokasyon Fiyat Koruma'></td>
            <td id="price_protec_td2">
                <input name="price_protection_location" id="price_protection_location" style="width:91px" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));' onBlur="hesapla();" value="<cfoutput>#tlformat(0)#</cfoutput>"> 
                <select name="price_protection_money_location" id="price_protection_money_location" onBlur="hesapla();">
                <cfloop query="get_money">
                    <option value="<cfoutput>#money#</cfoutput>" <cfif session.ep.money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>
                </cfloop>
                </select>
            </td>
            </cfif>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='37572.Sistem Maliyet'></td>
            <td>
                <input type="text" name="purchase_net_system" id="purchase_net_system" value="<cfoutput>#tlformat(alis_net_fiyat2,4)#</cfoutput>" onkeyup='return(FormatCurrency(this,event,4));' class="moneybox" style="width:91px">
                <select name="purchase_net_system_money" id="purchase_net_system_money" disabled="disabled">
                    <cfloop query="get_money">
                        <option value="<cfoutput>#money#</cfoutput>" <cfif session.ep.money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>								
                    </cfloop>
                </select>
                <input type="hidden" name="purchase_net_system_location" id="purchase_net_system_location" value="<cfoutput>#tlformat(alis_net_fiyat2,4)#</cfoutput>">
            </td>
            <td><cf_get_lang dictionary_id='37573.Sistem Ekstra Maliyet'></td>
            <td><input type="text" name="purchase_extra_cost_system" id="purchase_extra_cost_system" value="<cfoutput>#tlformat(alis_ek_maliyet2,4)#</cfoutput>" class="moneybox" style="width:150px;" readonly="yes"></td
        ></tr>
        <tr>
        	<td colspan="2">&nbsp;</td>
            <td valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
            <td valign="top"><textarea style="width:150px; height:70px" name="cost_description" id="cost_description"></textarea></td>
		</tr>
    </table>
    <cf_popup_box_footer>
   	   <cfsavecontent variable="add_cost"><cf_get_lang dictionary_id ='37522.Maliyet Ekle'></cfsavecontent>
       <cf_workcube_buttons is_upd='0' add_function='temizle_virgul()' insert_info='#add_cost#'>
    </cf_popup_box_footer>
  </cfform>
</cf_popup_box>
<script type="text/javascript">
	<cfif fusebox.Circuit eq 'product'>
		function location_price_protec()
		{
			if($('form[name = "product_cost_y"] #department_id').val() != "" && $('form[name = "product_cost_y"] #department').val() != "" && $('form[name = "product_cost_y"] #location_id').val() != "")
			{
				goster(price_protec_td1);
				goster(price_protec_td2);
			}
			else
			{
				gizle(price_protec_td1);
				gizle(price_protec_td2);
			}
		}
	</cfif>
	
	function open_spec_popup()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=product_cost_y.spect_main_id&field_name=product_cost_y.spect_name&is_display=1&stock_id=<cfoutput>#GET_STOCK.STOCK_ID#</cfoutput>&function_name=get_stock','list');
	}

 	function history_money(){
		var h_date=js_date(document.product_cost_y.start_date.value);
		<cfoutput query="GET_MONEY">
			var get_his_rate=wrk_query("SELECT (RATE2/RATE1) RATE,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE <= "+h_date+" AND MONEY = '#money#' AND PERIOD_ID = #session.ep.period_id# ORDER BY VALIDATE_DATE DESC,MONEY_HISTORY_ID DESC","dsn");
			if(get_his_rate.recordcount)
				eval('document.product_cost_y.money_#money#').value=get_his_rate.RATE[0];
			else
				eval('document.product_cost_y.money_#money#').value=#wrk_round(rate2/rate1,4)#;
		</cfoutput>
		hesapla();
		return true;
	}
	function hesapla()
	{
		var t1 = parseFloat(filterNum($('form[name = "product_cost_y"] #purchase_net').val(),4));
		var t2 = parseFloat(filterNum($('form[name = "product_cost_y"] #purchase_extra_cost').val(),4));
		var t3 = parseFloat(filterNum($('form[name = "product_cost_y"] #standard_cost').val(),4));
		var t4 = parseFloat(filterNum($('form[name = "product_cost_y"] #standard_cost_rate').val(),4));
		var t5 = parseFloat(filterNum($('form[name = "product_cost_y"] #price_protection').val(),4));
		
		if($('form[name = "product_cost_y"] #price_protection_type') != undefined)
			t5 = t5*$('form[name = "product_cost_y"] #price_protection_type').val();
		if (isNaN(t1)) {t1 = 0; $('form[name = "product_cost_y"] #purchase_net').val(0);}
		if (isNaN(t2)) {t2 = 0; $('form[name = "product_cost_y"] #purchase_extra_cost').val(0);}
		if (isNaN(t3)) {t3 = 0; $('form[name = "product_cost_y"] #standard_cost').val(0);}
		if (isNaN(t4)) {t4 = 0;	$('form[name = "product_cost_y"] #standard_cost_rate').val(0);}
		if (isNaN(t5)) {t5 = 0; $('form[name = "product_cost_y"] #price_protection').val(0);}
		var q=0;
		if($('form[name = "product_cost_y"] #reference_money').val() != '' && ($('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #reference_money').val())) != undefined)
					q=$('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #reference_money').val()).val();
		if(!q>0)q=1;
		
		t1 = (t1 * $('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #purchase_net_money').val()).val())/ q;
		t2 = (t2 * $('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #purchase_net_money').val()).val()) / q;
		t3 = (t3 * $('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #standard_cost_money').val()).val()) / q;
		t5 = (t5 * $('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #price_protection_money').val()).val()) / q;
		order_total = t1+t2+t3+((t1*t4)/100)-t5;
		
		$('form[name = "product_cost_y"] #product_cost').val(commaSplit(order_total,4));
		$('form[name = "product_cost_y"] #purchase_net_system').val(commaSplit((t1-t5)*q,4));
		$('form[name = "product_cost_y"] #purchase_extra_cost_system').val(commaSplit((t2+t3+(t1*t4)/100)*q,4));
		
		if(parseFloat(filterNum($('form[name = "product_cost_y"] #price_protection').val())) > 0)
			goster(tr_1);
		else
			gizle(tr_1);
		<cfif fusebox.Circuit eq 'product'>
			location_price_protec();			
			var t5_location = parseFloat(filterNum($('form[name = "product_cost_y"] #price_protection_location').val(),4));
			if (isNaN(t5_location)) {t5_location = 0; //product_cost_y.price_protection_location.value = 0;
			}
			t5_location = (t5_location * $('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #price_protection_money_location').val()).val()) / q;
			$('form[name = "product_cost_y"] #purchase_net_system_location').val(commaSplit((t1-t5_location)*q,4));

		</cfif>
	}
	
	function temizle_virgul()
	{
			
		$('form[name = "product_cost_y"] #standard_cost_rate').val(filterNum($('form[name = "product_cost_y"] #standard_cost_rate').val(),4));
		$('form[name = "product_cost_y"] #standard_cost').val(filterNum($('form[name = "product_cost_y"] #standard_cost').val(),4));
		$('form[name = "product_cost_y"] #purchase_extra_cost').val(filterNum($('form[name = "product_cost_y"] #purchase_extra_cost').val(),4));
		$('form[name = "product_cost_y"] #purchase_net').val(filterNum($('form[name = "product_cost_y"] #purchase_net').val(),4));
		$('form[name = "product_cost_y"] #purchase_extra_cost_system').val(filterNum($('form[name = "product_cost_y"] #purchase_extra_cost_system').val(),4));
		$('form[name = "product_cost_y"] #purchase_net_system').val(filterNum($('form[name = "product_cost_y"] #purchase_net_system').val(),4));
		$('form[name = "product_cost_y"] #purchase_net_system_location').val(filterNum($('form[name = "product_cost_y"] #purchase_net_system_location').val(),4));
		$('form[name = "product_cost_y"] #partner_stock').val(filterNum($('form[name = "product_cost_y"] #partner_stock').val(),4));
		$('form[name = "product_cost_y"] #available_stock').val(filterNum($('form[name = "product_cost_y"] #available_stock').val(),4));
		$('form[name = "product_cost_y"] #active_stock').val(filterNum($('form[name = "product_cost_y"] #active_stock').val(),4));
		$('form[name = "product_cost_y"] #price_protection_location').val(filterNum($('form[name = "product_cost_y"] #price_protection_location').val(),4));

$('form[name = "product_cost_y"] #product_cost').val(filterNum($('form[name = "product_cost_y"] #product_cost').val(),4));
	var form_date_year = list_getat($('form[name = "product_cost_y"] #start_date').val(),3,'/');
		if(form_date_year != ses_period_year){
			alert("<cf_get_lang dictionary_id ='37954.Maliyet Tarihi İle Bulunduğunuz Dönem Farklı Maliyet Ekleyemezsiniz'>!");
			return false;
		}
		if (frm_name != undefined)
			var _form_name_ = frm_name;
		else
			var _form_name_ = product_cost_y;
		<cfif session.ep.isBranchAuthorization>
			if($('form[name = "product_cost_y"] #department').val() == '' || $('form[name = "product_cost_y"] #department_id').val() == '' || $('form[name = "product_cost_y"] #location_id').val() == '')
			{
				alert("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>");
				return false;
			}
		</cfif>
		
		if(process_cat_control() == false) return false;
		if(parseFloat(filterNum($('form[name = "product_cost_y"] #price_protection').val())) > 0 && price_protection_control())//fiyat koruma yapilsinmi
		{
			if($('form[name = "product_cost_y"] #td_company').val() == '' || 	$('form[name = "product_cost_y"] #td_company_id').val() == '')
			{
				alert("<cf_get_lang dictionary_id ='37734.Fiyat Koruma Girecekseniz Tedarikçi Seçmelisiniz'>!");
				return false;
			}
			$('form[name = "product_cost_y"] #cost_control').val(1);
		}
		else 
		{
			$('form[name = "product_cost_y"] #cost_control').val(0);
		}


		if($('form[name = "product_cost_y"] #standard_cost').val() == '')
			$('form[name = "product_cost_y"] #standard_cost').val(0);
		if($('form[name = "product_cost_y"] #purchase_net').val() == '')
			$('form[name = "product_cost_y"] #purchase_net').val(0);
		if($('form[name = "product_cost_y"] #standard_cost_rate').val() == '')
			$('form[name = "product_cost_y"] #standard_cost_rate').val(0);
		if($('form[name = "product_cost_y"] #purchase_extra_cost').val() == '')
			$('form[name = "product_cost_y"] #purchase_extra_cost').val(0);
		if($('form[name = "product_cost_y"] #price_protection').val() == '')
			$('form[name = "product_cost_y"] #price_protection').val(0);
		if($('form[name = "product_cost_y"] #purchase_net_system').val() == '')
			$('form[name = "product_cost_y"] #purchase_net_system').val(0);
		if($('form[name = "product_cost_y"] #purchase_extra_cost_system').val() == '')
			$('form[name = "product_cost_y"] #purchase_extra_cost_system').val(0);
		if($('form[name = "product_cost_y"] #purchase_net_system_location').val() == '')
			$('form[name = "product_cost_y"] #purchase_net_system_location').val(0);


		$('form[name = "product_cost_y"] #standard_cost_rate').val(filterNum($('form[name = "product_cost_y"] #standard_cost_rate').val(),4));
		$('form[name = "product_cost_y"] #standard_cost').val(filterNum($('form[name = "product_cost_y"] #standard_cost').val(),4));
		$('form[name = "product_cost_y"] #purchase_extra_cost').val(filterNum($('form[name = "product_cost_y"] #purchase_extra_cost').val(),4));
		$('form[name = "product_cost_y"] #purchase_net').val(filterNum($('form[name = "product_cost_y"] #purchase_net').val(),4));
		$('form[name = "product_cost_y"] #purchase_extra_cost_system').val(filterNum($('form[name = "product_cost_y"] #purchase_extra_cost_system').val(),4));
		$('form[name = "product_cost_y"] #purchase_net_system').val(filterNum($('form[name = "product_cost_y"] #purchase_net_system').val(),4));
		$('form[name = "product_cost_y"] #purchase_net_system_location').val(filterNum($('form[name = "product_cost_y"] #purchase_net_system_location').val(),4));
		$('form[name = "product_cost_y"] #partner_stock').val(filterNum($('form[name = "product_cost_y"] #partner_stock').val(),4));
		$('form[name = "product_cost_y"] #available_stock').val(filterNum($('form[name = "product_cost_y"] #available_stock').val(),4));
		$('form[name = "product_cost_y"] #active_stock').val(filterNum($('form[name = "product_cost_y"] #active_stock').val(),4));
		$('form[name = "product_cost_y"] #price_protection').val(filterNum($('form[name = "product_cost_y"] #price_protection').val(),4));
		$('form[name = "product_cost_y"] #product_cost').val(filterNum($('form[name = "product_cost_y"] #product_cost').val(),4));
		$('form[name = "product_cost_y"] #price_protection_location').val(filterNum($('form[name = "product_cost_y"] #price_protection_location').val(),4));

		$('form[name = "product_cost_y"] #price_prot_amount').val()
		<!---if($('form[name = "product_cost_y"] #price_protection_location') != undefined)
		{
			if($('form[name = "product_cost_y"] #price_protection_location').val() == '')
				$('form[name = "product_cost_y"] #price_protection_location').val(0);
				$('form[name = "product_cost_y"] #price_protection_location').val(filterNum($('form[name = "product_cost_y"] #price_protection_location').val(),4));
		}--->
		if($('form[name = "product_cost_y"] #total_price_prot') != undefined)
		{
			if($('form[name = "product_cost_y"] #total_price_prot').val() == '') $('form[name = "product_cost_y"] #total_price_prot').val(0);
			$('form[name = "product_cost_y"] #total_price_prot').val(filterNum($('form[name = "product_cost_y"] #total_price_prot').val(),4));
			if($('form[name = "product_cost_y"] #price_prot_amount').val() == '') $('form[name = "product_cost_y"] #price_prot_amount').val(0);
			$('form[name = "product_cost_y"] #price_prot_amount').val(filterNum($('form[name = "product_cost_y"] #price_prot_amount').val(),4));
		}
		
		return true;
	}
	function price_protection_control()
	{
		if(confirm("<cf_get_lang dictionary_id ='37735.Fiyat Koruma için Fiyat Farkı Faturası Emri Verilsin mi'>?"))
			return true;
		else
			return false;
	}
	function get_stock()
	{
		<cfif session.ep.isBranchAuthorization>
			var dep_sql='AND STORE ='+ document.product_cost_y.department_id.value +' AND STORE_LOCATION ='+ document.product_cost_y.location_id.value;
		<cfelse>
			var dep_sql='';
		</cfif>
		if(document.product_cost_y.spect_main_id.value!="" && document.product_cost_y.spect_name.value!="")
			var spec_query='AND SPECT_VAR_ID='+document.product_cost_y.spect_main_id.value;
		else
			var spec_query='';
		var gt_stoc=wrk_query('SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK FROM STOCKS_ROW SR WHERE SR.PRODUCT_ID = <cfoutput>#attributes.pid#</cfoutput> AND PROCESS_DATE <='+js_date(document.product_cost_y.start_date.value)+' '+spec_query+' '+dep_sql,'dsn2');
		if(gt_stoc.recordcount)
			product_cost_y.available_stock.value = commaSplit(gt_stoc.PRODUCT_TOTAL_STOCK);
		else
			product_cost_y.available_stock.value = '<cfoutput>#tlformat(0)#</cfoutput>';
		
		var get_sevk=wrk_query('SELECT SUM(STOCK_OUT-STOCK_IN) AS MIKTAR FROM STOCKS_ROW WHERE PRODUCT_ID = <cfoutput>#attributes.pid#</cfoutput> AND PROCESS_TYPE = 81 AND PROCESS_DATE <='+js_date(document.product_cost_y.start_date.value)+' '+spec_query+' '+dep_sql,'dsn2')
		if(get_sevk.recordcount)
			product_cost_y.active_stock.value= commaSplit(get_sevk.MIKTAR);
		else
			product_cost_y.active_stock.value ='<cfoutput>#tlformat(0)#</cfoutput>';
		return history_money();
	}
	hesapla();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
