<!--- Bu sayfa Arkides icin add_options da calismaktadir. İlgili degisikliklikler oraya da aktarılmalı. BK 20070407 --->
<cfinclude template="/objects2/login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfquery name="GET_OFFER" datasource="#DSN3#">
	SELECT
		OFFER_ID,
		OFFER_HEAD,
		OFFER_DETAIL,
		OFFER_STAGE,
		PAYMETHOD,
		CARD_PAYMETHOD_ID,
		CITY_ID,
		COUNTY_ID,
		SHIP_ADDRESS,
		DELIVERDATE,
		UPDATE_MEMBER
	FROM 
		OFFER
	WHERE
		OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_id#">
</cfquery>

<cfif not get_offer.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='159.Teklif No Bulunamadı! Kayıtları Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="GET_OFFER_ROWS" datasource="#DSN3#">
	SELECT
		OFFER_ROW_ID,
        QUANTITY,
        UNIT,
        PRODUCT_ID,
        STOCK_ID,
        PRODUCT_NAME,
        OTHER_MONEY_VALUE,
        OTHER_MONEY,
        TAX
	FROM 
		OFFER_ROW
	WHERE
		OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer.offer_id#">
	ORDER BY 
		OFFER_ROW_ID
</cfquery>
<table cellpadding="0" cellspacing="0" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold"><cf_get_lang_main no='133.Teklif'> : <cfoutput>#get_offer.offer_head#</cfoutput></td>
		<td align="right" class="headbold" style="text-align:right;">
			<cfquery name="GET_OUR_MAIL" datasource="#DSN#">
				SELECT EMAIL FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
			</cfquery>
			<cfoutput><a href="mailto:#get_our_mail.email#" class="offer_file"><img src="#file_web_path#objects2/image/file_upload.gif" align="absmiddle" border="0"> <cf_get_lang no='1455.Dosya Gönder'></a></cfoutput>
		</td>
	</tr>
	<cfform name="offer_form" method="post" action="#request.self#?fuseaction=objects2.emptypopup_upd_offer">
	<cfif isdefined("session.pp.userid")>
		<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#session.pp.company_id#</cfoutput>">
		<input type="hidden" name="company_name" id="company_name" value="<cfoutput>#session.pp.company#</cfoutput>">
	<cfelse>
		<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#session.ww.userid#</cfoutput>">
	</cfif>
	<input type="hidden" name="offer_id" id="offer_id" value="<cfoutput>#attributes.offer_id#</cfoutput>">
	<tr>
		<td colspan="2">
			<table cellpadding="2" cellspacing="2">
				<tr bgcolor="f5f5f5" style="height:25px;">
					<td class="formbold">(-)</td>
					<td class="formbold" style="width:50px;"><cf_get_lang_main no='670.Adet'></td>
					<td class="formbold" style="width:50px;"><cf_get_lang_main no='224.Birim'></td>
					<td class="formbold" style="width:250px;"><cf_get_lang_main no='245.Ürün'></td>
					<td align="right" class="formbold" style="width:150px;text-align:right;"><cf_get_lang_main no='672.Fiyat'></td>
					<td align="right" class="formbold" style="width:30px;text-align:right;"><cf_get_lang_main no='227.KDV'></td>
				</tr>
				<cfoutput query="get_offer_rows">
					<tr bgcolor="f5f5f5" style="height:20px;">
						<td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.emptypopup_del_offer_row&offer_row_id=#offer_row_id#','small');"><img src="/images/delete_list.gif" border="0" title="<cf_get_lang no ='1456.Satır Sil'>"></a></td>
						<td><cfsavecontent variable="message"><cf_get_lang no='160.Adet Sayısal Olmalıdır'></cfsavecontent>
							<cfinput type="text" name="quantity_#offer_row_id#" validate="integer" message="#message#" required="yes" value="#quantity#" style="width:45px;"></td>
						<td>#unit#</td>
						<td><a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">#PRODUCT_NAME#</a></td>
						<td align="right" style="text-align:right;">#TLFormat(other_money_value)# #other_money#</td>
						<td align="center">#tax#</td>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table>
				<tr>
					<td style="width:80px;"><cf_get_lang_main no='133.Teklif'></td>
					<td colspan="3"><cfinput type="text" name="offer_head" id="offer_head" value="#get_offer.offer_head#" style="width:500px;"></td>
				</tr>
				<tr>
					<td style="vertical-align:top;"><cf_get_lang_main no='217.Açıklama'></td>
					<td colspan="3"><textarea name="offer_detail" id="offer_detail" style="width:500px;height:150px;"><cfoutput>#get_offer.offer_detail#</cfoutput></textarea></td>
				</tr>
				<tr>
					<td style="vertical-align:top;"><cf_get_lang_main no='1037.Teslim Yeri'></td>
					<td style="vertical-align:top;" colspan="3">
						<input type="hidden" name="city_id" id="city_id" value="<cfoutput>#get_offer.city_id#</cfoutput>">
						<input type="hidden" name="county_id" id="county_id" value="<cfoutput>#get_offer.county_id#</cfoutput>">
						<table cellpadding="1" cellspacing="0">
					  		<tr>
					   			<td><textarea name="ship_address" id="ship_address" style="width:500px;height:50px;" onChange="kontrol(this,200)"><cfoutput>#get_offer.ship_address#</cfoutput></textarea></td>
								<td style="vertical-align:top;"><a href="javascript://" onClick="add_adress();"><img border="0" name="imageField2" src="/images/plus_list.gif" align="absmiddle"></a></td>
					  		</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no="1447.Süreç"></td>
					<td><cf_workcube_process is_upd='0' select_value='#get_offer.offer_stage#' process_cat_width='180' is_detail='1'></td>
					<td style="width:100px;"><cf_get_lang_main no='1104.Ödeme Yöntemi'></td>
					<td>
						<cfif len(get_offer.paymethod)>
							<cfset attributes.paymethod_id = get_offer.paymethod>
							<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
								SELECT PAYMENT_VEHICLE, PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#">
							</cfquery>
							<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
							<input type="hidden" name="commission_rate" id="commission_rate" value="">
							<cfoutput>
							<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="#get_paymethod.payment_vehicle#"> <!--- sadece taksitli fiatı hesaplarken kullanılıyor, order_row'da tutulmuyor --->
							<input type="hidden" name="paymethod_id" id="paymethod_id" value="#get_offer.paymethod#">
							<input type="hidden" name="basket_due_value" id="basket_due_value" value="">
							<input type="text" name="paymethod" id="paymethod" value="#get_paymethod.paymethod#" readonly style="width:175px;">
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
								<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="-1"><!--- kredi kartı icin set edilen bu deger dsp_basket_js_scripts.cfm sayfasındaki taksit_hesapla() fonskiyonunda kullanılıyor. burda bi degisiklik yapılırsa orası da degistirilmelidir. 	OZDEN20071218 --->
								<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_offer.card_paymethod_id#">
								<input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
								<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
								<input type="hidden" name="basket_due_value" id="basket_due_value" value="">
								<input type="text" name="paymethod" id="paymethod" value="#get_card_paymethod.card_no#" readonly style="width:175px;">
							</cfoutput>
						<cfelse>
							<input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
							<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
							<input type="hidden" name="commission_rate" id="commission_rate" value="">
							<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
							<input type="hidden" name="basket_due_value" id="basket_due_value" value="">
							<input type="text" name="paymethod" id="paymethod" value="" readonly style="width:200px;">
						</cfif>
					 	<cfset card_link="&field_card_payment_id=offer_form.card_paymethod_id&field_card_payment_name=offer_form.paymethod&field_commission_rate=offer_form.commission_rate&field_paymethod_vehicle=offer_form.paymethod_vehicle">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_paymethods&field_id=offer_form.paymethod_id&field_name=offer_form.paymethod&field_dueday=offer_form.basket_due_value#card_link#</cfoutput>','list');"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no='233.Teslimat Tarihi'></td>
					<td><cfinput type="text" name="deliverdate" id="deliverdate" value="#dateformat(get_offer.deliverdate,'dd/mm/yyyy')#" validate="eurodate" readonly style="width:80px;"></td>
				</tr>
				<tr>
					<td></td>
					<td colspan="3">
						<cfsavecontent variable="message"><cf_get_lang_main no='1331.Gonder'></cfsavecontent>
						<cf_workcube_buttons is_upd='1' insert_info='#message#' delete_page_url='#request.self#?fuseaction=objects2.emptypopup_del_offer&offer_id=#attributes.offer_id#'><!--- add_function='kontrolggg()' --->
					</td>
				</tr>
			</table>		
		</td>
	</tr>
	</cfform>
</table>
<script type="text/javascript">
	function kontrol (ship_address,limit)
	{
		StrLen = document.getElementById('ship_address').value.length;
		if (StrLen > limit)
		{
			alert("<cf_get_lang_main no='163.Teslim Yeri En Fazla 200 Karakter Girilebilir'>!");
			return false;
		}
		
	}
	
	function add_adress()
	{
		if(!(document.getElementByIıd('company_id').value=="") || !(document.getElementById('member_id').value==""))
		{
			if(document.getElementByIıd('company_id').value!="")
			{
				str_adrlink = '&field_long_adres=offer_form.ship_address';
				if(document.getElementById('city_id')!=undefined) str_adrlink = str_adrlink+'&field_city=offer_form.city_id';
				if(document.getElementById('county_id')!=undefined) str_adrlink = str_adrlink+'&field_county=offer_form.county_id';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(document.getElementById('company_name').value)+''+ str_adrlink , 'list');
				return true;
			}
			else
			{
				str_adrlink = '&field_long_adres=offer_form.ship_address'; 
				if(document.getElementById('city_id')!=undefined) str_adrlink = str_adrlink+'&field_city=offer_form.city_id';
				if(document.getElementById('county_id')!=undefined) str_adrlink = str_adrlink+'&field_county=offer_form.county_id';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(document.getElementById('consumer').value)+''+ str_adrlink , 'list');
				return true;
			}
		}
	}
</script>
