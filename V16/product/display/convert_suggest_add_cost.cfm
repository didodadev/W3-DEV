<!--- Bu sayfa maliyet sayfasındaki eklenen önerilerin listelenmesi sırasında ajax ile çağırılır. --->
<cfsetting showdebugoutput="no">
<cfparam name="attributes.FORM_CRNTROW" default="1">
<cfparam name="attributes.surece_yetki" default="0">
<cfparam name="attributes.period_id" default="#session.ep.period_id#">
<cfparam name="attributes.act_id" default="">
<cfparam name="attributes.act_type" default="1">
<cfinclude template="../query/get_money.cfm"><!--- SETUP MNYDEN ALINIYOR AMA ELLE MALİYET GİRİLECEĞİNDE TARİHTEDKİ STOKDA KURLARDA O ZAMANDAN ALINMALI --->
<cfquery name="GET_PRODUCT_COST_SUGGESTION" datasource="#dsn1#">
	SELECT * FROM PRODUCT_COST_SUGGESTION WHERE PRODUCT_COST_SUGGESTION_ID = #attributes.suggest_id#
</cfquery>
<cfscript>
	departmetn_id = GET_PRODUCT_COST_SUGGESTION.DEPARTMENT_ID;
	location_id = GET_PRODUCT_COST_SUGGESTION.LOCATION_ID;
	spec_main_id = GET_PRODUCT_COST_SUGGESTION.SPECT_MAIN_ID;
	if(fusebox.circuit is 'product')
	{
		total_maliyet = GET_PRODUCT_COST_SUGGESTION.PRODUCT_COST;
		total_maliyet_money = GET_PRODUCT_COST_SUGGESTION.MONEY;
		reference_money = GET_PRODUCT_COST_SUGGESTION.MONEY;
		alis_net_fiyat = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET;
		alis_net_fiyat_money = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_MONEY;
		alis_net_fiyat2 = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_SYSTEM;
		alis_net_fiyat2_money = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_SYSTEM_MONEY;
		alis_ek_maliyet = GET_PRODUCT_COST_SUGGESTION.PURCHASE_EXTRA_COST;
		alis_ek_maliyet2 = GET_PRODUCT_COST_SUGGESTION.PURCHASE_EXTRA_COST_SYSTEM;
		alis_net_fiyat2_loc = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_SYSTEM;
		alis_ek_maliyet_money = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_MONEY;
		son_st_maliyet = GET_PRODUCT_COST_SUGGESTION.STANDARD_COST;
		son_st_maliyet_money = GET_PRODUCT_COST_SUGGESTION.STANDARD_COST_MONEY;
		son_st_maliyet_oran = GET_PRODUCT_COST_SUGGESTION.STANDARD_COST_RATE;
		mevcut_stok = GET_PRODUCT_COST_SUGGESTION.AVAILABLE_STOCK;
		partner_stok = GET_PRODUCT_COST_SUGGESTION.PARTNER_STOCK;
		yoldaki_stok = GET_PRODUCT_COST_SUGGESTION.ACTIVE_STOCK;
		fiyat_koruma = GET_PRODUCT_COST_SUGGESTION.PRICE_PROTECTION;
		fiyat_koruma_money = GET_PRODUCT_COST_SUGGESTION.PRICE_PROTECTION_MONEY;
		fiyat_koruma_loc = GET_PRODUCT_COST_SUGGESTION.PRICE_PROTECTION_LOCATION;
		fiyat_koruma_money_loc = GET_PRODUCT_COST_SUGGESTION.PRICE_PROTECTION_MONEY_LOCATION;
		
	}else
	{
		total_maliyet = GET_PRODUCT_COST_SUGGESTION.PRODUCT_COST_LOCATION;
		total_maliyet_money = GET_PRODUCT_COST_SUGGESTION.MONEY_LOCATION;
		reference_money=GET_PRODUCT_COST_SUGGESTION.MONEY_LOCATION;
		alis_net_fiyat = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_LOCATION;
		alis_net_fiyat_money = GET_PRODUCT_COST_SUGGESTION.MONEY_LOCATION;
		alis_net_fiyat2 = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_SYSTEM_LOCATION;
		alis_net_fiyat2_money = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_SYSTEM_MONEY_LOCATION;
		alis_ek_maliyet = GET_PRODUCT_COST_SUGGESTION.PURCHASE_EXTRA_COST_LOCATION;
		alis_ek_maliyet2 = GET_PRODUCT_COST_SUGGESTION.PURCHASE_EXTRA_COST_SYSTEM_LOCATION;
		alis_net_fiyat2_loc = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_SYSTEM_LOCATION;
		alis_ek_maliyet_money = GET_PRODUCT_COST_SUGGESTION.MONEY_LOCATION;
		son_st_maliyet = GET_PRODUCT_COST_SUGGESTION.STANDARD_COST_LOCATION;
		son_st_maliyet_money = GET_PRODUCT_COST_SUGGESTION.STANDARD_COST_MONEY_LOCATION;
		son_st_maliyet_oran = GET_PRODUCT_COST_SUGGESTION.STANDARD_COST_RATE_LOCATION;
		mevcut_stok = GET_PRODUCT_COST_SUGGESTION.AVAILABLE_STOCK_LOCATION;
		partner_stok = GET_PRODUCT_COST_SUGGESTION.PARTNER_STOCK_LOCATION;
		yoldaki_stok = GET_PRODUCT_COST_SUGGESTION.ACTIVE_STOCK_LOCATION;
		fiyat_koruma = GET_PRODUCT_COST_SUGGESTION.PRICE_PROTECTION_LOCATION;
		fiyat_koruma_money = GET_PRODUCT_COST_SUGGESTION.PRICE_PROTECTION_MONEY_LOCATION;
	}
</cfscript>
<cf_popup_box>	
		<cfform id="product_cost_suggest#attributes.form_crntrow#" name="product_cost_suggest#attributes.form_crntrow#" action="#request.self#?fuseaction=#fusebox.Circuit#.emptypopup_add_product_cost" method="post">        
			<input type="hidden" name="is_suggest" id="is_suggest" value="<cfoutput>#attributes.suggest_id#</cfoutput>">
			<input type="hidden" name="cost_control" id="cost_control" value="0">
            <input type="hidden" name="inventory_calc_type" id="inventory_calc_type" value="<cfoutput>#GET_PRODUCT_COST_SUGGESTION.INVENTORY_CALC_TYPE#</cfoutput>" />
			<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#GET_PRODUCT_COST_SUGGESTION.PRODUCT_ID#</cfoutput>">
			<input type="hidden" name="unit_id" id="unit_id" value="<cfoutput>#GET_PRODUCT_COST_SUGGESTION.UNIT_ID#</cfoutput>">
			<input type="hidden" name="action_id" id="action_id" value="">
			<input type="hidden" name="action_type" id="action_type" value=""><!--- 1: FATURA, 2: SİPARİŞ 3:ÜRETİM TİPİ 4:stok virman--->
			<input type="hidden" name="action_period_id" id="action_period_id" value="<cfoutput>#session.ep.period_id#</cfoutput>">
			<input type="hidden" name="action_ids" id="action_ids" value="">           
			<cfoutput query="GET_MONEY">
				<input type="hidden" name="money_#money#" id="money_#money#" value="#wrk_round(rate2/rate1,session.ep.our_company_info.rate_round_num)#">
			</cfoutput>
			<cfoutput><input type="hidden" name="reference_money" id="reference_money" value="#reference_money#"></cfoutput>
     <table width="100%">
		<tr>
			<td width="130"><cf_get_lang dictionary_id='57742.Tarih'></td>					
			<td>
				<input type="hidden" name="old_start_date" id="old_start_date" value="<cfoutput>#dateformat(GET_PRODUCT_COST_SUGGESTION.START_DATE,dateformat_style)#</cfoutput>">
				<input type="text" name="start_date" id="start_date" value="<cfoutput>#dateformat(GET_PRODUCT_COST_SUGGESTION.START_DATE,dateformat_style)#</cfoutput>" readonlystyle="width:90px;" onBlur="return(get_stock('<cfoutput>product_cost_suggest#attributes.form_crntrow#</cfoutput>'));">
				<cf_wrk_date_image date_field="start_date" date_form="product_cost_suggest#attributes.form_crntrow#" call_function="yeniyukle()">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id="58859.Süreç"></td>
			<td><cf_workcube_process is_upd='0' process_cat_width='139' is_detail='0'></td>
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
				<a href="javascript://" onClick="open_spec_popup(<cfoutput>'product_cost_suggest#attributes.form_crntrow#'</cfoutput>);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>						
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='37511.Sabit Maliyet'></td>
			<td>
				<input name="standard_cost" id="standard_cost" style="width:91px;" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));' onBlur="hesapla('<cfoutput>product_cost_suggest#attributes.form_crntrow#</cfoutput>');" value="<cfoutput>#tlformat(son_st_maliyet,4)#</cfoutput>"> 
				<select name="standard_cost_money" id="standard_cost_money" onBlur="hesapla('<cfoutput>product_cost_suggest#attributes.form_crntrow#</cfoutput>');">
				<cfloop query="get_money">
				<option value="<cfoutput>#money#</cfoutput>" <cfif son_st_maliyet_money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>								
				</cfloop>
				</select>
			</td>
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
				<input type="text" name="department" id="department" value="<cfif isdefined("GET_LOCATION")><cfoutput>#GET_DEPARTMENT.DEPARTMENT_HEAD# - #GET_LOCATION.COMMENT#</cfoutput></cfif>" style="width:150px;">
				<cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=product_cost_suggest#attributes.form_crntrow#&field_name=department&field_location_id=location_id&field_id=department_id<cfif session.ep.isBranchAuthorization>&function_name=get_stock&function_form_name=product_cost_suggest#attributes.form_crntrow#</cfif>','medium');"><img src="/images/plus_thin.gif"  border="0" align="absmiddle"></a></cfoutput>
			</td>          
       
        </tr>
		<tr>
			<td nowrap="nowrap"><cf_get_lang dictionary_id='37513.Sabit Maliyet Oran'> % </td>
			<td><input style="width:91px" class="moneybox" name="standard_cost_rate" id="standard_cost_rate" onkeyup='return(FormatCurrency(this,event));' onBlur="hesapla('<cfoutput>product_cost_suggest#attributes.form_crntrow#</cfoutput>');" value="<cfoutput>#tlformat(son_st_maliyet_oran)#</cfoutput>"></td>
			<td><cf_get_lang dictionary_id='37512.Mevcut Stok'></td>
			<td><input style="width:150px" class="moneybox" name="available_stock" id="available_stock" onkeyup='return(FormatCurrency(this,event));' value="<cfoutput>#tlformat(mevcut_stok)#</cfoutput>"></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='37515.Alışlardan Net Maliyet'> </td>
			<td>
				<input type="hidden" name="old_purchase_net" id="old_purchase_net" value="<cfoutput>#tlformat(alis_net_fiyat,4)#</cfoutput>">
				<input type="hidden" name="old_purchase_net_money" id="old_purchase_net_money" value="<cfoutput>#alis_net_fiyat_money#</cfoutput>">
				<input name="purchase_net" id="purchase_net" style="width:91px" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));' onBlur="hesapla('<cfoutput>product_cost_suggest#attributes.form_crntrow#</cfoutput>');" value="<cfoutput>#tlformat(alis_net_fiyat,4)#</cfoutput>">
				<select name="purchase_net_money" id="purchase_net_money" onBlur="hesapla('<cfoutput>product_cost_suggest#attributes.form_crntrow#</cfoutput>');">
					<cfloop query="get_money">
						<cfoutput><option value="#money#" <cfif alis_net_fiyat_money eq money>selected</cfif>>#money#</option></cfoutput>
					</cfloop>
				</select>
			</td>
			<td nowrap="nowrap"><cf_get_lang dictionary_id='37514.İş Ortakları Stoğu'></td>
			<td><input style="width:150px" class="moneybox" name="partner_stock" id="partner_stock" onkeyup='return(FormatCurrency(this,event));' value="<cfoutput>#tlformat(partner_stok)#</cfoutput>"></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='37517.Alışlardan Ek Maliyet'></td>
			<td>
			<input type="hidden" name="old_purchase_extra_cost" id="old_purchase_extra_cost" value="<cfoutput>#alis_ek_maliyet#</cfoutput>">
			<input name="purchase_extra_cost" id="purchase_extra_cost" style="width:91px" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));' onBlur="hesapla('<cfoutput>product_cost_suggest#attributes.form_crntrow#</cfoutput>');" value="<cfoutput>#tlformat(alis_ek_maliyet,4)#</cfoutput>">
			</td>
			<td valign="top"><cf_get_lang dictionary_id='58047.Yoldaki Stok'> </td>
			<td valign="top"><input style="width:150px" name="active_stock" id="active_stock" value="<cfoutput>#tlformat(yoldaki_stok)#</cfoutput>" class="moneybox" onkeyup='return(FormatCurrency(this,event));'></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='37518.Fiyat Koruma'> /<cf_get_lang dictionary_id='37547.Düzenleme'> </td>
			<td>
				<input name="price_protection" id="price_protection" value="<cfoutput>#tlformat(fiyat_koruma,4)#</cfoutput>" style="width:91px" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));' onBlur="hesapla('<cfoutput>product_cost_suggest#attributes.form_crntrow#</cfoutput>');"> 
				<select name="price_protection_money" id="price_protection_money" onBlur="hesapla('<cfoutput>product_cost_suggest#attributes.form_crntrow#</cfoutput>');">
				<cfloop query="get_money">
				<option value="<cfoutput>#money#</cfoutput>" <cfif fiyat_koruma_money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>								
				</cfloop>
				</select>
			</td>
			<td><cf_get_lang dictionary_id='37648.Maliyet Tipi'></td>
			<td><select name="cost_type" id="cost_type" style="width:150px;">
					<option value=""><cf_get_lang dictionary_id='322.Seçiniz'></option>
					<cfquery name="GET_COST_TYPE" datasource="#DSN#">
						SELECT COST_TYPE_ID,COST_TYPE_NAME FROM SETUP_COST_TYPE 
					</cfquery>
					<cfoutput query="GET_COST_TYPE"><option value="#COST_TYPE_ID#" <cfif COST_TYPE_ID eq GET_PRODUCT_COST_SUGGESTION.COST_TYPE_ID>selected</cfif>>#COST_TYPE_NAME#</option></cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<!---<td width="90"><cf_get_lang_main no='1736.Tedarikçi'></td>
			<td>
				<input type="hidden" name="td_company_id1" id="td_company_id1" value="">
				<input type="text" name="td_company1" id="td_company1" style="width:140px;" value="">
				<cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=product_cost_suggest.td_company1&field_comp_id=product_cost_suggest.td_company_id1&select_list=2','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></cfoutput>
			</td>--->
            <td width="90"><cf_get_lang dictionary_id='29533.Tedarikçi'></td>
                <td>
                <input type="hidden" name="td_company_id" id="td_company_id" value="<cfif len(GET_PRODUCT_COST_SUGGESTION.COMPANY_ID)><cfoutput>#GET_PRODUCT_COST_SUGGESTION.COMPANY_ID#</cfoutput></cfif>">
                <input type="text" name="td_company" id="td_company" style="width:140px;" value="<cfif len(GET_PRODUCT_COST_SUGGESTION.COMPANY_ID)><cfoutput>#get_par_info(GET_PRODUCT_COST_SUGGESTION.COMPANY_ID,1,1,0)#</cfoutput></cfif>">
                <cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=product_cost_suggest#attributes.form_crntrow#.td_company&field_comp_id=product_cost_suggest#attributes.form_crntrow#.td_company_id&select_list=2&keyword='+encodeURIComponent(document.product_cost_suggest#attributes.form_crntrow#.td_company.value),'list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></cfoutput>
                </td>
			<cfif session.ep.isBranchAuthorization eq 0>
			<td width="130" id="<cfoutput>price_protec_td1_#attributes.form_crntrow#</cfoutput>"> <cf_get_lang dictionary_id='30031.Lokasyon'> <cf_get_lang dictionary_id='37518.Fiyat Koruma'></td>
			<td id="<cfoutput>price_protec_td2_#attributes.form_crntrow#</cfoutput>">
				<input name="price_protection_location" id="price_protection_location" value="<cfoutput>#tlformat(fiyat_koruma_loc,4)#</cfoutput>" style="width:101px" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));' onBlur="hesapla('<cfoutput>product_cost_suggest#attributes.form_crntrow#</cfoutput>');"> 
				<select name="price_protection_money_location" id="price_protection_money_location" onBlur="hesapla('<cfoutput>product_cost_suggest#attributes.form_crntrow#</cfoutput>');">
					<cfloop query="get_money">
						<option value="<cfoutput>#money#</cfoutput>" <cfif fiyat_koruma_money_loc eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>
					</cfloop>
				</select>
			</td>
			</cfif>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='37497.Toplam Maliyet'></td>
			<td>
				<!--- Bu alan maliyet hesaplarken ürünün purchase money'ini tutuyor o yüzden kesinlikle silinmesin, form_add_product tablosunda hesaplamaya katılıyor. --->
				<input type="hidden" name="_total_maliyet_money_" id="_total_maliyet_money_" value="<cfoutput>#total_maliyet_money#</cfoutput>">
				<!--- Bu alan maliyet hesaplarken ürünün purchase money'ini tutuyor o yüzden kesinlikle silinmesin, form_add_product tablosunda hesaplamaya katılıyor. --->
				<input name="product_cost" id="product_cost" style="width:91px" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));' readonly="yes" value="<cfoutput>#tlformat(total_maliyet,4)#</cfoutput>">
				<select name="product_cost_money" id="product_cost_money" disabled>
						<option value="<cfoutput>#total_maliyet_money#</cfoutput>"><cfoutput>#total_maliyet_money#</cfoutput></option>
				</select>
			</td>
			<td><cf_get_lang dictionary_id='57629.Açıklama'></td>
			<td rowspan="3" valign="top"><textarea style="width:150px; height:70px" name="cost_description" id="cost_description"><cfoutput>#GET_PRODUCT_COST_SUGGESTION.cost_description#</cfoutput></textarea></td>
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
			<td></td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='37573.Sistem Ekstra Maliyet'></td>
			<td><input type="text" name="purchase_extra_cost_system" id="purchase_extra_cost_system" value="<cfoutput>#tlformat(alis_ek_maliyet2,4)#</cfoutput>" class="moneybox" style="width:91px" readonly="yes"></td>
			<td></td>
		</tr>
		<tr>
			<td colspan="3"></td>
			<td>
			<cfsavecontent variable="del_alert"><cf_get_lang dictionary_id='57533.Silmek İstediğinizden Eminmisiniz'> ?</cfsavecontent>
            
			<cfif attributes.surece_yetki gt 0>            
				<input type="button" onClick="if(confirm('<cfoutput>#del_alert#</cfoutput>')){<cfoutput>AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_del_suggest&suggest_id=#attributes.suggest_id#</cfoutput>','DEL_SUGGESTION');gizle_goster(suggestion#attributes.form_crntrow#);gizle_goster(row_suggestion#attributes.form_crntrow#);</cfoutput>}else return false;" value="<cf_get_lang dictionary_id='57463.Sil'>">
				<input type="submit" onClick="<cfoutput>temizle_virgul1('product_cost_suggest#attributes.form_crntrow#');</cfoutput>" value="<cf_get_lang dictionary_id='37602.Maliyet e Dönüştür'>">
          	<!---	<cfoutput>	<cf_workcube_buttons is_upd='0' add_function='temizle_virgul1("product_cost_suggest#attributes.form_crntrow#")' insert_info='Maliyete Dönüştür'></cfoutput>--->
		
			<cfelse>
				<font color="FFF0000"><b><cf_get_lang dictionary_id='37601.Sürece Yetkiniz Olmadığı İçin Öneriyi Maliyete  Çeviremezsiniz'>.</b></font>
			</cfif>
		</tr>
		<!---</cfform>--->
	</table>
<div id="DEL_SUGGESTION"></div>
</cfform>
</cf_popup_box>
<script type="text/javascript">

		function temizle_virgul1(frm_name)
			{	
			$('form[name = "'+frm_name+'"] #price_protection_location').val(filterNum($('form[name = "'+frm_name+'"] #price_protection_location').val(),4));		
		var form_date_year = list_getat($('form[name = "'+frm_name+'"] #start_date').val(),3,'/');
		if(form_date_year != ses_period_year){
			alert("<cf_get_lang dictionary_id ='37954.Maliyet Tarihi İle Bulunduğunuz Dönem Farklı Maliyet Ekleyemezsiniz'>!");
			return false;
		}
		if (frm_name != undefined)
			var _form_name_ = frm_name;
		else
			var _form_name_ = product_cost_y;
		<cfif session.ep.isBranchAuthorization>
			if($('form[name = "'+frm_name+'"] #department').val() == '' || $('form[name = "'+frm_name+'"] #department_id').val() == '' || $('form[name = "'+frm_name+'"] #location_id').val() == '')
			{
				alert("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>");
				return false;
			}
		</cfif>
		
		if(process_cat_control() == false) return false;
		if(parseFloat(filterNum($('form[name = "'+frm_name+'"] #price_protection').val())) > 0 && price_protection_control())//fiyat koruma yapilsinmi
		{
			if($('form[name = "'+frm_name+'"] #td_company').val() == '' || 	$('form[name = "'+frm_name+'"] #td_company_id').val() == '')
			{
				alert("<cf_get_lang dictionary_id ='37734.Fiyat Koruma Girecekseniz Tedarikçi Seçmelisiniz'>!");
				return false;
			}
			$('form[name = "'+frm_name+'"] #cost_control').val(1);
		}
		else 
		{
			$('form[name = "'+frm_name+'"] #cost_control').val(0);
		}


		if($('form[name = "'+frm_name+'"] #standard_cost').val() == '')
			$('form[name = "'+frm_name+'"] #standard_cost').val(0);
		if($('form[name = "'+frm_name+'"] #purchase_net').val() == '')
			$('form[name = "'+frm_name+'"] #purchase_net').val(0);
		if($('form[name = "'+frm_name+'"] #standard_cost_rate').val() == '')
			$('form[name = "'+frm_name+'"] #standard_cost_rate').val(0);
		if($('form[name = "'+frm_name+'"] #purchase_extra_cost').val() == '')
			$('form[name = "'+frm_name+'"] #purchase_extra_cost').val(0);
		if($('form[name = "'+frm_name+'"] #price_protection').val() == '')
			$('form[name = "'+frm_name+'"] #price_protection').val(0);
		if($('form[name = "'+frm_name+'"] #purchase_net_system').val() == '')
			$('form[name = "'+frm_name+'"] #purchase_net_system').val(0);
		if($('form[name = "'+frm_name+'"] #purchase_extra_cost_system').val() == '')
			$('form[name = "'+frm_name+'"] #purchase_extra_cost_system').val(0);
		if($('form[name = "'+frm_name+'"] #purchase_net_system_location').val() == '')
			$('form[name = "'+frm_name+'"] #purchase_net_system_location').val(0);

		$('form[name = "'+frm_name+'"] #standard_cost_rate').val(filterNum($('form[name = "'+frm_name+'"] #standard_cost_rate').val(),4));
		$('form[name = "'+frm_name+'"] #standard_cost').val(filterNum($('form[name = "'+frm_name+'"] #standard_cost').val(),4));
		$('form[name = "'+frm_name+'"] #purchase_extra_cost').val(filterNum($('form[name = "'+frm_name+'"] #purchase_extra_cost').val(),4));
		$('form[name = "'+frm_name+'"] #purchase_net').val(filterNum($('form[name = "'+frm_name+'"] #purchase_net').val(),4));
		$('form[name = "'+frm_name+'"] #purchase_extra_cost_system').val(filterNum($('form[name = "'+frm_name+'"] #purchase_extra_cost_system').val(),4));
		$('form[name = "'+frm_name+'"] #purchase_net_system').val(filterNum($('form[name = "'+frm_name+'"] #purchase_net_system').val(),4));
		$('form[name = "'+frm_name+'"] #purchase_net_system_location').val(filterNum($('form[name = "'+frm_name+'"] #purchase_net_system_location').val(),4));
		$('form[name = "'+frm_name+'"] #partner_stock').val(filterNum($('form[name = "'+frm_name+'"] #partner_stock').val(),4));
		$('form[name = "'+frm_name+'"] #available_stock').val(filterNum($('form[name = "'+frm_name+'"] #available_stock').val(),4));
		$('form[name = "'+frm_name+'"] #active_stock').val(filterNum($('form[name = "'+frm_name+'"] #active_stock').val(),4));
		$('form[name = "'+frm_name+'"] #price_protection').val(filterNum($('form[name = "'+frm_name+'"] #price_protection').val(),4));
		$('form[name = "'+frm_name+'"] #product_cost').val(filterNum($('form[name = "'+frm_name+'"] #product_cost').val(),4));
		$('form[name = "'+frm_name+'"] #price_protection_location').val(filterNum($('form[name = "'+frm_name+'"] #price_protection_location').val(),4));

		$('form[name = "'+frm_name+'"] #price_prot_amount').val()
		<!---if($('form[name = "'+frm_name+'"] #price_protection_location') != undefined)
		{
			if($('form[name = "'+frm_name+'"] #price_protection_location').val() == '')
				$('form[name = "'+frm_name+'"] #price_protection_location').val(0);
				$('form[name = "'+frm_name+'"] #price_protection_location').val(filterNum($('form[name = "'+frm_name+'"] #price_protection_location').val(),4));
		}--->
		if($('form[name = "'+frm_name+'"] #total_price_prot') != undefined)
		{
			if($('form[name = "'+frm_name+'"] #total_price_prot').val() == '') $('form[name = "'+frm_name+'"] #total_price_prot').val(0);
			$('form[name = "'+frm_name+'"] #total_price_prot').val(filterNum($('form[name = "'+frm_name+'"] #total_price_prot').val(),4));
			if($('form[name = "'+frm_name+'"] #price_prot_amount').val() == '') $('form[name = "'+frm_name+'"] #price_prot_amount').val(0);
			$('form[name = "'+frm_name+'"] #price_prot_amount').val(filterNum($('form[name = "'+frm_name+'"] #price_prot_amount').val(),4));
		}
		
		return true;
	}
	function price_protection_control(frm_name)
	{
		if(confirm("<cf_get_lang dictionary_id ='37735.Fiyat Koruma için Fiyat Farkı Faturası Emri Verilsin mı'>?"))
			return true;
		else
			return false;
	}
	function hesapla(frm_name)
	{	
		if (frm_name == undefined)
			var _form_name_ = 'product_cost';
		else
			var _form_name_ = frm_name;
			
	var t1 = parseFloat(filterNum($('form[name = "'+frm_name+'"] #purchase_net').val(),4));
		var t2 = parseFloat(filterNum($('form[name = "'+frm_name+'"] #purchase_extra_cost').val(),4));
		var t3 = parseFloat(filterNum($('form[name = "'+frm_name+'"] #standard_cost').val(),4));
		var t4 = parseFloat(filterNum($('form[name = "'+frm_name+'"] #standard_cost_rate').val(),4));
		var t5 = parseFloat(filterNum($('form[name = "'+frm_name+'"] #price_protection').val(),4));
		
		if($('form[name = "'+frm_name+'"] #price_protection_type') != undefined)
			t5 = t5*$('form[name = "'+frm_name+'"] #price_protection_type').val();
		
		if (isNaN(t1)) {t1 = 0; $('form[name = "'+frm_name+'"] #purchase_net').val(0);}
		if (isNaN(t2)) {t2 = 0; $('form[name = "'+frm_name+'"] #purchase_extra_cost').val(0);}
		if (isNaN(t3)) {t3 = 0; $('form[name = "'+frm_name+'"] #standard_cost').val(0);}
		if (isNaN(t4)) {t4 = 0;	$('form[name = "'+frm_name+'"] #standard_cost_rate').val(0);}
		if (isNaN(t5)) {t5 = 0; $('form[name = "'+frm_name+'"] #price_protection').val(0);}
		var q=0;
		if($('form[name = "'+frm_name+'"] #reference_money').val() != '' && ($('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #reference_money').val())) != undefined)
					q=$('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #reference_money').val()).val();
		if(!q>0)q=1;
		
	
		t1 = (t1 * $('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #purchase_net_money').val()).val())/ q;
		t2 = (t2 * $('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #purchase_net_money').val()).val()) / q;
		t3 = (t3 * $('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #standard_cost_money').val()).val()) / q;
		t5 = (t5 * $('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #price_protection_money').val()).val()) / q;
		order_total = t1+t2+t3+((t1*t4)/100)-t5;
		
		$('form[name = "'+frm_name+'"] #product_cost').val(commaSplit(order_total,4));
		$('form[name = "'+frm_name+'"] #purchase_net_system').val(commaSplit((t1-t5)*q,4));
		$('form[name = "'+frm_name+'"] #purchase_extra_cost_system').val(commaSplit((t2+t3+(t1*t4)/100)*q,4));
				
		<cfif fusebox.Circuit eq 'product'>
			var t5_location = parseFloat(filterNum($('form[name = "'+frm_name+'"] #price_protection').val(),4));
			if (isNaN(t5_location)) {t5_location = 0; //product_cost_y.price_protection_location.value = 0;
			}
			t5_location = (t5_location * $('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #price_protection_money_location').val()).val()) / q;
			$('form[name = "'+frm_name+'"] #purchase_net_system_location').val(commaSplit((t1-t5_location)*q,4));

		</cfif>
	}
	</script>
 
