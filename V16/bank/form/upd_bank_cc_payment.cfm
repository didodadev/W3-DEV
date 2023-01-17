<!---
Kredi kartı tahsilatları sonrası hesaba geçişlerden kaydedilen banka işleminin detay sayfasıdır, sadece hesap ve tutar bilgisi vardır
ve silme sayfasına gidilebilir(banka işlemini ve muhasebe işlemi silinerek ,hesaba geçiş satırları tekrar elde edilebilir)
Ayşenur 20060427
 --->
<cf_xml_page_edit fuseact="bank.popup_upd_bank_cc_payment">
<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cfset attributes.TABLE_NAME = "BANK_ACTIONS">
<cfinclude template="../query/get_action_detail.cfm">
<cfif not get_action_detail.recordcount or (isDefined("attributes.action_period_id") and attributes.action_period_id neq session.ep.period_id)>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cfquery name="get_cards" datasource="#dsn2#">
	SELECT CARD_ID FROM ACCOUNT_CARD WHERE ACTION_ID = #get_action_detail.action_id# AND ACTION_TYPE = #get_action_detail.action_type_id#
</cfquery>
<cfsavecontent variable="head_">
	<cfif get_action_detail.action_type_id eq 243><cf_get_lang dictionary_id='49595.Kredi Kartı Hesaba Geçiş'><cfelse><cf_get_lang dictionary_id='49596.Kredi Kartı Hesaba Geçiş İptal'></cfif>
</cfsavecontent>
<cfsavecontent variable="right_">
	<li><cfif len(get_cards.CARD_ID)><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&card_id=#get_cards.CARD_ID#</cfoutput>','page');"><i class="icon-fa fa-table"  alt="<<cf_get_lang dictionary_id='57447.Muhasebe'>" title="<cf_get_lang dictionary_id='57447.Muhasebe'>"></i></a></cfif></li>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#head_#" right_images="#right_#"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cfoutput>
					<div classs="form-group">
						<input type="hidden" name="draggable" id="draggable" value="#attributes.draggable#">
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12">#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</label>
					</div>
					<div classs="form-group">
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='57652.Hesap'></label>
						
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<cfif get_action_detail.action_type_id eq 243>
								<cfset account_id=get_action_detail.ACTION_TO_ACCOUNT_ID>
							<cfelse>
								<cfset account_id=get_action_detail.ACTION_FROM_ACCOUNT_ID>
							</cfif>
							<cfinclude template="../query/get_action_account.cfm">
							#get_action_account.ACCOUNT_NAME#
						</label>
					</div>
					<div classs="form-group">
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'></label>
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12">#TLFormat(get_action_detail.ACTION_VALUE)# #get_action_account.ACCOUNT_CURRENCY_ID#</label>
					</div>
					<div classs="form-group">
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='30060.Masraf Tutarı'></label>
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfif len(get_action_detail.MASRAF)>#TLFormat(get_action_detail.MASRAF)# #get_action_account.ACCOUNT_CURRENCY_ID#</cfif></label>
					</div>
					<div classs="form-group">
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='29534.Toplam Tutar'></label>
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12">#TLFormat(get_action_detail.ACTION_VALUE+get_action_detail.MASRAF)# #get_action_account.ACCOUNT_CURRENCY_ID#</label>
					</div>
					<div classs="form-group">
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></label>
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfif len(get_action_detail.OTHER_CASH_ACT_VALUE)>#TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)# #get_action_detail.OTHER_MONEY#</cfif></label>
					</div>
					<div classs="form-group">
						<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12">#get_action_detail.ACTION_DETAIL#</label>
					</div>
				</cfoutput>
				<cfif xml_show_tahsilat_id eq 1>
					<cfif session.ep.admin><!--- belge no zorunlu olmadgndan idler verildi  oyüzden admine baglandı --->
						<cfquery name="GET_CC_ROWS" datasource="#dsn3#">
							SELECT CREDITCARD_PAYMENT_ID FROM CREDIT_CARD_BANK_PAYMENTS_ROWS WHERE BANK_ACTION_ID = #URL.ID# AND BANK_ACTION_PERIOD_ID = #session.ep.period_id# ORDER BY CREDITCARD_PAYMENT_ID
						</cfquery>
						<div classs="form-group">
							<label class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='57836.Kredi Kartı Tahsilat'>ID</label>
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfoutput query="GET_CC_ROWS">#CREDITCARD_PAYMENT_ID#</cfoutput></label>
						</div>
					</cfif>
				</cfif>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_action_detail">
			<cfsavecontent variable="del_message"><cf_get_lang dictionary_id='65112.Hesaba Geçiş İşlemini Silmek İstediğinizden Emin Misiniz'>?</cfsavecontent>
				<cf_workcube_buttons is_upd='1' is_insert='0' is_cancel='0'
				delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_bank_payment&id=#url.id#&old_process_type=#get_action_detail.action_type_id#&draggable=#iif(isdefined("attributes.draggable"),1,0)#'
				delete_alert='#del_message#'>
		</cf_box_footer>
	</cf_box>
</div>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
