<cfinclude template="../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfset attributes.offer_id = attributes.param_2>
<cfset offer = createObject("component","V16.objects2.sale.cfc.offer")>
<cfset GET_OFFER = offer.GET_OFFER(offer_id : attributes.offer_id)>
<cfset GET_OFFER_LIST = offer.GET_OFFER_LIST(offer_id : attributes.offer_id)>
<cfset GET_PARTNER = offer.GET_PARTNER(partner_id_list : GET_OFFER_LIST.PARTNER_ID)>

<cfif not get_offer.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='159.Teklif No Bulunamadi! Kayitlari Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfset get_offer_rows = offer.get_offer_rows(offer_id : get_offer.offer_id)>
<cfform name="offer_form" id="offer_form" method="post" action="">
	<div class="form-row">
		<div class="form-group col-md-5">
			<label><cf_get_lang dictionary_id='58820.Başlık'></label>
			<cfinput type="text" class="form-control" name="offer_head" value="#get_offer.offer_head#">
		</div>				
		<div class="form-group col-md-1">
			<label><cf_get_lang dictionary_id='57493.Aktif'></label><br>
			<label class="checkbox-container-lg">
				<input type="checkbox"/>
				<span class="checkmark-lg"></span>
			</label>  
		</div>
	</div>

	<cfset session_company_category = session_base.company_category>
	<cfset xml_company_cat_member_id = attributes.company_cat_member_id>

	<cfset session_company_category = listSort(session_company_category, 'numeric')>
	<cfset xml_company_cat_member_id = listSort(xml_company_cat_member_id, 'numeric')>
	
	<cfif len(xml_company_cat_member_id) and ((compareNoCase(session_company_category,xml_company_cat_member_id) eq 0) or (compareNoCase(session_company_category,xml_company_cat_member_id) eq 1) or (compareNoCase(session_company_category,xml_company_cat_member_id) eq -1))>
		<div class="form-row">
			<div class="form-group col-md-3">
				<label><cf_get_lang dictionary_id='33008.Satış Yapan'> İş Ortağı</label>
				<input type="text" class="form-control" value="<cfoutput>#get_par_info(get_offer.company_id,1,0,0)#</cfoutput>" readonly>
			</div>
			<div class="form-group col-md-3">
				<label><cf_get_lang dictionary_id='33008.Satış Yapan'> İş Ortağı Yetkili</label>
				<input type="text" class="form-control"  value="<cfoutput>#get_partner.company_partner_name# #GET_PARTNER.company_partner_surname#</cfoutput>" readonly>
			</div>
			<div class="form-group col-md-3">
				<label><cf_get_lang dictionary_id='57457.Müşteri'></label>
				<cfinclude template="../query/get_emps_pars_cons.cfm">					
				<select class="form-control" name="member" id="member">
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_emps_pars_cons">
					<cfif (type eq 2) or (type eq 4) or (type eq 5)>
						<option value="#uye_id#,#comp_id#,#type#" <cfif comp_id eq get_offer.company_id>selected</cfif>><cfif len(get_emps_pars_cons.nickname)>#nickname# - </cfif>#uye_name# #uye_surname#</option>
					</cfif>
					</cfoutput>
				</select>			
			</div>
			<cfif isDefined("attributes.is_consumer") and attributes.is_consumer eq 1>
				<div class="form-group col-md-3">
					<label><cf_get_lang dictionary_id='58832.Abone'></label>
					<cfinclude template="../query/get_emps_pars_cons.cfm">					
					<select class="form-control" name="member" id="member">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_emps_pars_cons">
						<cfif (type eq 1) or (type eq 3)>
							<option value="#uye_id#,#comp_id#,#type#" <cfif comp_id eq get_offer.company_id>selected</cfif>><cfif len(get_emps_pars_cons.nickname)>#nickname# - </cfif>#uye_name# #uye_surname#</option>
						</cfif>
						</cfoutput>
					</select>
				</div>
			</cfif>	
		</div>
	</cfif>

	<div class="form-row">
		<div class="form-group col-md-2">
			<label><cf_get_lang dictionary_id='32818.Teklif Tarihi'></label>
			<input type="text" class="form-control">
		</div>
		<div class="form-group col-md-2">
			<label><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
			<cfinput type="text" class="form-control" name="deliverdate" value="#dateformat(get_offer.deliverdate,'dd/mm/yyyy')#" validate="eurodate" readonly>
		</div>
		<div class="form-group col-md-2">
			<label><cf_get_lang dictionary_id='58449.Teslim Yeri'></label>
			<input type="hidden" name="city_id" id="city_id" value="<cfoutput>#get_offer.city_id#</cfoutput>">
			<input type="hidden" name="county_id" id="county_id" value="<cfoutput>#get_offer.county_id#</cfoutput>">				
			<input type="text" class="form-control" name="ship_address" id="ship_address" onChange="kontrol(this,200)" value="<cfoutput>#get_offer.ship_address#</cfoutput>">
			<!--- <a href="javascript://" onClick="add_adress();"><img border="0" name="imageField2" src="/images/plus_list.gif" align="absmiddle"></a> --->			
		</div>
		<div class="form-group col-md-2">
			<label><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></label>
			<input type="text" class="form-control">
		</div>
	</div>

	<div class="form-row">
		<div class="form-group col-md-3">
			<label><cf_get_lang dictionary_id='57416.Proje'></label>
			<input type="text" class="form-control">
		</div>
		<div class="form-group col-md-3">
			<label><cf_get_lang dictionary_id='58445.İş'></label>
			<input type="text" class="form-control">
		</div>
		<div class="form-group col-md-3">
			<label><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
			<input type="text" class="form-control">
		</div>
		<div class="form-group col-md-3">
			<label><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>			
			<cfif len(get_offer.paymethod)>
				<cfset attributes.paymethod_id = get_offer.paymethod>
				<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
					SELECT * FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#">
				</cfquery>
				<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
				<input type="hidden" name="commission_rate" id="commission_rate" value="">
				<cfoutput>
				<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="#get_paymethod.payment_vehicle#"> <!--- sadece taksitli fiati hesaplarken kullaniliyor, order_row'da tutulmuyor --->
				<input type="hidden" name="paymethod_id" id="paymethod_id" value="#get_offer.paymethod#">
				<input name="basket_due_value" id="basket_due_value" type="hidden" value="">
				<input type="text" class="form-control" name="paymethod" id="paymethod" value="#get_paymethod.paymethod#" readonly>
				</cfoutput>
			<cfelseif len(get_offer.card_paymethod_id)>
				<cfquery name="get_card_paymethod" datasource="#DSN3#">
					SELECT 
						CARD_NO
						<cfif get_offer.commethod_id eq 6>
						,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
						<cfelse>
						,COMMISSION_MULTIPLIER 
						</cfif>
					FROM 
						CREDITCARD_PAYMENT_TYPE 
					WHERE 
						PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer.card_paymethod_id#">
				</cfquery>
				<cfoutput>
					<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="-1"><!--- kredi karti icin set edilen bu deger dsp_basket_js_scripts.cfm sayfasindaki taksit_hesapla() fonskiyonunda kullaniliyor. burda bi degisiklik yapilirsa orasi da degistirilmelidir. 	OZDEN20071218 --->
					<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_offer.card_paymethod_id#">
					<input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
					<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
					<input name="basket_due_value" id="basket_due_value" type="hidden" value="">
					<input type="text" class="form-control" name="paymethod" id="paymethod" value="#get_card_paymethod.card_no#" readonly>
				</cfoutput>
			<cfelse>
				<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
				<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
				<input type="hidden" name="commission_rate" id="commission_rate" value="">
				<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
				<input name="basket_due_value" id="basket_due_value" type="hidden" value="">
				<input type="text" class="form-control" name="paymethod" id="paymethod" value="" readonly>
			</cfif>
			<cfset card_link="&field_card_payment_id=offer_form.card_paymethod_id&field_card_payment_name=offer_form.paymethod&field_commission_rate=offer_form.commission_rate&field_paymethod_vehicle=offer_form.paymethod_vehicle">
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_paymethods&field_id=offer_form.paymethod_id&field_name=offer_form.paymethod&field_dueday=offer_form.basket_due_value#card_link#</cfoutput>','list');"></a>			
		</div>
	</div>	

	<div class="form-row">
		<div class="form-group col-md-6">
			<label><cf_get_lang dictionary_id='36199.Açıklama'></label>
			<input type="text" class="form-control" name="offer_detail" id="offer_detail" value="<cfoutput>#get_offer.offer_detail#</cfoutput>">
		</div>
		<div class="form-group col-md-3">
			<label><cf_get_lang dictionary_id='58054.Süreç - Aşama'></label>
			<cf_workcube_process is_upd='0' select_value='#get_offer.offer_stage#' is_detail='1'>
		</div>				
	</div>

	<div style="color:#e38283;font-size:22px;font-family: 'PoppinsR'; padding:10px 0 20px 0"><cf_get_lang dictionary_id='57564.Ürünler'> - <cf_get_lang dictionary_id='37090.Hizmetler'></div>

	<div class="table-responsive">
		<table class="table table-bordered basket_table">		
			<!--- <td height="35" class="headbold"><cf_get_lang_main no='133.Teklif'> : <cfoutput>#get_offer.offer_head#</cfoutput></td> --->			
			<cfquery name="GET_OUR_MAIL" datasource="#DSN#">
				SELECT EMAIL FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
			</cfquery>
				
			<cfif isdefined("session.pp.userid")>
				<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#session.pp.company_id#</cfoutput>">
				<input type="hidden" name="company_name" id="company_name" value="<cfoutput>#session.pp.company#</cfoutput>">
			<cfelse>
				<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#session.ww.userid#</cfoutput>">
			</cfif>
				<input type="hidden" name="offer_id" id="offer_id" value="<cfoutput>#attributes.offer_id#</cfoutput>">		
				
			<thead>	
				<tr>
					<td><cf_get_lang dictionary_id='44019.Ürün'></td>
					<!--- <td class="formbold">(-)</td> --->
					<td><cf_get_lang dictionary_id='58082.Adet'></td>
					<td><cf_get_lang dictionary_id='57636.Birim'></td>			
					<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></td>
					<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></td>
				</tr>
			</thead>	
			<cfoutput query="get_offer_rows">
				<tr>
					<td><a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">#PRODUCT_NAME#</a></td>
					<!--- <td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.emptypopup_del_offer_row&offer_row_id=#offer_row_id#','small');"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang no ='1456.Satir Sil'>"></a></td> --->
					<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='34481.Adet Sayısal Olmalıdır'></cfsavecontent>
						<cfinput type="text" class="form-control" name="quantity_#offer_row_id#" validate="integer" message="#message#" required="yes" value="#quantity#" style="width:45px;"></td>
					<td>#unit#</td>				
					<td align="right" style="text-align:right;">#TLFormat(other_money_value)# #other_money#</td>
					<td align="center">#tax#</td>
				</tr>
			</cfoutput>
		</table>
	</div>
	<div class="form-row">
		<div class="col-md-12 mt-3">
			<cf_workcube_buttons 
			is_upd = "1" 
			data_action = "/V16/objects2/sale/cfc/offer:upd_offer" 
			del_action = "/V16/objects2/sale/cfc/offer:del_offer" 
			next_page="/#get_page.friendly_url#/#attributes.offer_id#"
			>
		</div>
	</div>	
</cfform>

<script type="text/javascript">
function kontrol (ship_address,limit)
{
	StrLen = ship_address.value.length;
	if (StrLen > limit)
	{
		alert("<cf_get_lang_main no='163.Teslim Yeri En Fazla 200 Karakter Girilebilir'>!");
		return false;
	}
	
}

function add_adress()
{
	if(!(offer_form.company_id.value=="") || !(offer_form.member_id.value==""))
	{
		if(offer_form.company_id.value!="")
		{
			str_adrlink = '&field_long_adres=offer_form.ship_address';
			if(offer_form.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=offer_form.city_id';
			if(offer_form.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=offer_form.county_id';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(offer_form.company_name.value)+''+ str_adrlink , 'list');
			return true;
		}
		else
		{
			str_adrlink = '&field_long_adres=offer_form.ship_address'; 
			if(offer_form.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=offer_form.city_id';
			if(offer_form.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=offer_form.county_id';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(offer_form.consumer.value)+''+ str_adrlink , 'list');
			return true;
		}
	}
}
</script>
