<!--- 
Kredi kartının borc ödemesinde yazılan banka hareketini görüntüleme sayfasıdır
ve silme sayfasına gidilebilir(banka işlemini,muhasebe işlemini ve masraf satırı silinebilir)
Ayşenur 20060427
 --->
<cfset refmodule="#listgetat(attributes.fuseaction,1,'.')#">
<cfif isDefined("attributes.period_control") and attributes.period_control neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='45701.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
			<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</script>
	<cfabort>
</cfif>
<cfset attributes.TABLE_NAME = "BANK_ACTIONS">
<cfinclude template="../query/get_action_detail.cfm">
<cfif not get_action_detail.recordcount or (isDefined("attributes.action_period_id") and attributes.action_period_id neq session.ep.period_id)>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfquery name="get_process_cat_name" datasource="#dsn3#">
		SELECT PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_detail.process_cat#">
	</cfquery>
	<cfsavecontent variable="right">
		<cfoutput>
		<li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.action_type_id#','page','upd_gelenh');"><i class="icon-fa fa-table" border="0" style="vertical-align:middle" alt="<cf_get_lang dictionary_id='51822.Fiş Çıkar'>" title="<cf_get_lang dictionary_id='51822.Fiş Çıkar'>"></i></a></li></cfoutput>
	</cfsavecontent>
	<cfoutput>
		<cfparam name="attributes.modal_id" default="">
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box title="#getLang('','','48872')#" right_images='#right#'  print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=156&action_type=#get_action_detail.action_type_id#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
				<cfform  name="upd_cc_debit" method="post">
					<input type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#">
					<cf_box_elements>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="false">
							<div class="form-group">
								<label class="col col-3 col-xs-12 "><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
								<div class="col col-9 col-xs-12">
									#get_process_cat_name.process_cat#
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12 "><cf_get_lang dictionary_id='57742.Tarih'></label>
								<div class="col col-9 col-xs-12">
									#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12 "><cf_get_lang dictionary_id='29449.Banka Hesabı'></label>
								<div class="col col-9 col-xs-12">
									<cfif get_process_cat_name.process_type eq 244>
										<cfset account_id=get_action_detail.ACTION_FROM_ACCOUNT_ID>
									<cfelse>	
										<cfset account_id=get_action_detail.ACTION_TO_ACCOUNT_ID>
									</cfif>
									<cfinclude template="../query/get_action_account.cfm">
									#get_action_account.ACCOUNT_NAME#
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12 "><cf_get_lang dictionary_id='58199.Kredi Kartı'></label>
								<div class="col col-9 col-xs-12">
									<cfif get_action_detail.ACTION_TYPE_ID eq 244 and len(get_action_detail.creditcard_id)>
										<cfquery name="get_credit_account_to_name" datasource="#dsn3#">
											SELECT
												CREDITCARD_NUMBER,
												ACCOUNT_NAME
											FROM
												CREDIT_CARD,
												ACCOUNTS
											WHERE
												CREDIT_CARD.ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID
												AND CREDIT_CARD.CREDITCARD_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_detail.creditcard_id#"> 
										</cfquery>
										<cfset key_type = '#session.ep.company_id#'>
										<cfscript>
											getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
											getCCNOKey.dsn = dsn;
											getCCNOKey1 = getCCNOKey.getCCNOKey1();
											getCCNOKey2 = getCCNOKey.getCCNOKey2();
										</cfscript>
										<cfset key_type = '#session.ep.company_id#'>
										<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
										<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
											<!--- anahtarlar decode ediliyor --->
											<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
											<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
											<!--- kart no encode ediliyor --->
												<cfset content = contentEncryptingandDecodingAES(isEncode:0,content:get_credit_account_to_name.creditcard_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
												<cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
										<cfelse>
											<cfset content = '#mid(Decrypt(get_credit_account_to_name.creditcard_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(get_credit_account_to_name.creditcard_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(get_credit_account_to_name.creditcard_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(get_credit_account_to_name.creditcard_number,key_type,"CFMX_COMPAT","Hex")))#'>
										</cfif>
										#get_credit_account_to_name.account_name# / #content#	
									</cfif>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12 "><cf_get_lang dictionary_id='57673.Tutar'></label>
								<div class="col col-9 col-xs-12">
									#TLFormat(get_action_detail.ACTION_VALUE - get_action_detail.MASRAF)# #get_action_detail.ACTION_CURRENCY_ID#
								</div>
							</div>
							<cfif get_action_detail.MASRAF gt 0>
							<div class="form-group">
								<label class="col col-3 col-xs-12 "><cf_get_lang dictionary_id='30060.Masraf Tutarı'></label>
								<div class="col col-9 col-xs-12">
									#TLFormat(get_action_detail.MASRAF)# #get_action_detail.ACTION_CURRENCY_ID#
								</div>
							</div>
							</cfif>
							<div class="form-group">
								<label class="col col-3 col-xs-12 "><cf_get_lang dictionary_id='58056.Dövizli Tutar'></label>
								<div class="col col-9 col-xs-12">
									#TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)# #get_action_detail.OTHER_MONEY#
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12 "><cf_get_lang dictionary_id='57880.Belge No'></label>
								<div class="col col-9 col-xs-12">
									#get_action_detail.PAPER_NO#
								</div>
							</div>
							<div class="form-group">
								<label class="col col-3 col-xs-12 "><cf_get_lang dictionary_id='36199.Açıklama'></label>
								<div class="col col-9 col-xs-12">
									#get_action_detail.ACTION_DETAIL#
								</div>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
							<cf_record_info query_name="get_action_detail">
							<cfsavecontent variable="del_message"><cf_get_lang dictionary_id='49047.Kredi Kartı Borcu Ödeme İşlemini Silmek İstediğinizden Emin Misiniz?'></cfsavecontent>
							<cfif (len(get_action_detail.upd_status) and get_action_detail.upd_status eq 1) or not len(get_action_detail.upd_status)>
								<a href="javascript://" onclick="#isDefined('attributes.draggable') ? 'deleteFunc()' : ''#" class="ui-ripple-btn">#getLang('','işlemi sil','58216')#</a>
							</cfif>
							<a href="javascript://"  class="ui-ripple-btn" onclick="close_();">#getLang('','kapat','57553')#</a>
					</cf_box_footer>
				</cfform>
			</cf_box>
		</div>
	</cfoutput>
</cfif>
<script type="text/javascript">
function close_(){
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>

}
<cfif isDefined('attributes.draggable')>
	function deleteFunc() {
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=bank.emptypopup_del_bank_debit_payment&id=#url.id#&old_process_type=#get_action_detail.action_type_id#<cfif isDefined("attributes.period_control")>&active_period=#attributes.period_control#<cfelse>&active_period=#session.ep.period_id#</cfif></cfoutput>',<cfoutput>#attributes.modal_id#</cfoutput>);
	}
</cfif>
	
</script>