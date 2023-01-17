<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cfif isDefined("attributes.subs_inv_id")>
	<cfquery name="GET_PROV_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
		SELECT IS_COLLECTED_PROVISION FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE INVOICE_ID = #attributes.subs_inv_id# AND PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfif GET_PROV_INFO.IS_COLLECTED_PROVISION neq 0>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id ='49078.Aynı Ödeme Planı Satırı İçin Provizyon İşlemi Yapılmıştır'>!");
			window.close();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="GET_PAID_INFO" datasource="#DSN3#"><!--- aynı anda yapılan işlemlerin kontrolu --->
		SELECT IS_PAID FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE INVOICE_ID = #attributes.subs_inv_id# AND PERIOD_ID = #attributes.period_id# AND IS_PAID = 1
	</cfquery>
	<cfif GET_PAID_INFO.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='54534.İlişkili fatura daha önceden tahsil edilmiştir! Tahsilat işlemi gerçekleşmeyecektir.'>");
			window.close();
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfset my_acc_result = "">
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT
		FROM 
			SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfif isdefined("attributes.member_card_id") and len(attributes.member_card_id)>
	<cfquery name="get_card_info" datasource="#dsn#">
		SELECT
			<cfif isdefined("attributes.action_from_company_id") and len(attributes.action_from_company_id)>
				CC.COMPANY_CC_ID MEMBER_CC_ID,
				CC.COMPANY_ID MEMBER_ID,
				CC.COMPANY_CC_TYPE MEMBER_CC_TYPE,
				CC.COMPANY_CC_NUMBER MEMBER_CC_NUMBER,
				CC.COMPANY_EX_MONTH MEMBER_EX_MONTH,
				CC.COMPANY_EX_YEAR MEMBER_EX_YEAR,
				CC.COMPANY_BANK_TYPE MEMBER_BANK_TYPE,
				CC.COMPANY_CARD_OWNER MEMBER_CARD_OWNER,
				CC.COMP_CVS MEMBER_CVS
			<cfelse>
				CC.CONSUMER_CC_ID MEMBER_CC_ID,
				CC.CONSUMER_ID MEMBER_ID,
				CC.CONSUMER_CC_TYPE MEMBER_CC_TYPE,
				CC.CONSUMER_CC_NUMBER MEMBER_CC_NUMBER,
				CC.CONSUMER_EX_MONTH MEMBER_EX_MONTH,
				CC.CONSUMER_EX_YEAR MEMBER_EX_YEAR,
				CC.CONSUMER_BANK_TYPE MEMBER_BANK_TYPE,
				CC.CONSUMER_CARD_OWNER MEMBER_CARD_OWNER,
				CC.CONS_CVS MEMBER_CVS
			</cfif>
		FROM
			<cfif isdefined("attributes.action_from_company_id") and len(attributes.action_from_company_id)>
				COMPANY_CC CC
			<cfelse>
				CONSUMER_CC CC
			</cfif>
		WHERE
			<cfif isdefined("attributes.action_from_company_id") and len(attributes.action_from_company_id)>
				CC.COMPANY_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_card_id#">
			<cfelse>
				CC.CONSUMER_CC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_card_id#">
			</cfif>
	</cfquery>
	<cfif isdefined("attributes.action_from_company_id") and len(attributes.action_from_company_id)>
		<cfset key_type = attributes.action_from_company_id>
	<cfelse>
		<cfset key_type = attributes.cons_id>
	</cfif>
	<cfset attributes.card_no_dec = Decrypt(get_card_info.member_cc_number,key_type,"CFMX_COMPAT","Hex")>
	<cfscript>
		getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
		getCCNOKey.dsn = dsn;
		getCCNOKey1 = getCCNOKey.getCCNOKey1();
		getCCNOKey2 = getCCNOKey.getCCNOKey2();
	</cfscript>
	<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
	<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
		<!--- anahtarlar decode ediliyor --->
		<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
		<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
		<!--- kart no encode ediliyor --->
		<cfset content = contentEncryptingandDecodingAES(isEncode:0,content:get_card_info.member_cc_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />	
		<cfset attributes.card_no_dec = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
		<cfset attributes.card_no = contentEncryptingandDecodingAES(isEncode:0,content:get_card_info.member_cc_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
	<cfelse>
		<cfset attributes.card_no = Decrypt(get_card_info.member_cc_number,key_type,"CFMX_COMPAT","Hex")>
	</cfif>
	<cfset attributes.bank_type = GET_CARD_INFO.MEMBER_BANK_TYPE>
	<cfset attributes.card_owner = GET_CARD_INFO.MEMBER_CARD_OWNER>
	<cfset attributes.exp_month = GET_CARD_INFO.MEMBER_EX_MONTH>
	<cfset attributes.exp_year = GET_CARD_INFO.MEMBER_EX_YEAR>
	<cfset attributes.cvv_no = GET_CARD_INFO.MEMBER_CVS>
	<cfset attributes.cvv_no_dec = "#Left(GET_CARD_INFO.MEMBER_CVS, 1)#*#Right(GET_CARD_INFO.MEMBER_CVS, 1)#">
</cfif>
<cfscript>
	process_type = get_process_type.process_type;
	is_cari = get_process_type.is_cari;
	is_account = get_process_type.is_account;
	expire_month = RepeatString("0",2-Len(attributes.exp_month)) & attributes.exp_month;
	expire_year = Right(attributes.exp_year,2);
</cfscript>
<cfif is_account eq 1>
	<cfif len(attributes.action_from_company_id)>
		<cfset my_acc_result = get_company_period(action_from_company_id)>
	<cfelse>
		<cfset my_acc_result = get_consumer_period(attributes.cons_id)>
	</cfif>
	<cfif not len(my_acc_result)>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='49054.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
			window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_online_pos</cfoutput>';
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfset payment_type_id = trim(ListGetAt(attributes.action_to_account_id,3,";"))>
<cfquery name="GET_TAKS_METHOD" datasource="#DSN3#">
	SELECT NUMBER_OF_INSTALMENT,ACCOUNT_CODE,CARD_NO,VFT_CODE FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #payment_type_id#
</cfquery>
<cfif not len(GET_TAKS_METHOD.ACCOUNT_CODE)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='49056.Seçtiğiniz Ödeme Yönteminin Muhasebe Kodu Secilmemiş'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_online_pos</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif len(GET_TAKS_METHOD.NUMBER_OF_INSTALMENT) and GET_TAKS_METHOD.NUMBER_OF_INSTALMENT neq 0>
	<cfset taksit_sayisi = GET_TAKS_METHOD.NUMBER_OF_INSTALMENT>
<cfelse>
	<cfset taksit_sayisi = 0>
</cfif>
<cfset vft_code = "">
<cfif len(GET_TAKS_METHOD.VFT_CODE)>
	<cfset vft_code = GET_TAKS_METHOD.VFT_CODE>
</cfif>
<cfif use_https>
	<cfset url_link = https_domain>
<cfelse>
	<cfset url_link = "">
</cfif>
<cf_box title="#getLang('bank',44)#"><!--- Tahsilat Detayı --->
	<cfform name="add_online_pos" action="#url_link##request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_online_pos" method="post" onsubmit="return(unformat_fields());">
		<cfoutput>
			<input type="hidden" name="oid" id="oid" value="#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'#session.ep.userid#'&round(rand()*100)#" />
			<input type="hidden" name="amount" id="amount" value="#attributes.sales_credit#" />
			<input type="hidden" name="taksit" id="taksit" value="#taksit_sayisi#" />
			<input type="hidden" name="xid" id="xid" value="" />
			<input type="hidden" name="eci" id="eci" value="" />
			<input type="hidden" name="cavv" id="cavv" value="" />
			<input type="hidden" name="md" id="md" value="" />
			<input type="hidden" name="x_is_add_ins_number" id="x_is_add_ins_number" value="<cfif isdefined("attributes.x_is_add_ins_number")>#attributes.x_is_add_ins_number#</cfif>">
			<input type="hidden" name="x_send_error_mail" id="x_send_error_mail" value="<cfif isdefined("attributes.x_send_error_mail")>#attributes.x_send_error_mail#</cfif>">
			<input type="hidden" name="cons_id" id="cons_id" value="#attributes.cons_id#">
			<input type="hidden" name="par_id" id="par_id" value="#attributes.par_id#">
			<input type="hidden" name="action_from_company_id" id="action_from_company_id" value="#attributes.action_from_company_id#">
			<input type="hidden" name="action_to_account_id" id="action_to_account_id" value="#attributes.action_to_account_id#">
			<cfif len(attributes.cons_id)>
				<input type="hidden" name="comp_name" id="comp_name" value="#get_cons_info(attributes.cons_id,0,0)#">
			<cfelse>
				<input type="hidden" name="comp_name" id="comp_name" value="#get_par_info(attributes.action_from_company_id,1,0,0)#">
			</cfif>
			<cfif isdefined("attributes.member_card_id") and len(attributes.member_card_id)>
				<input type="hidden" name="member_card_id"  id="member_card_id" value="#attributes.member_card_id#" />
			</cfif>
			<input type="hidden" name="process_cat" id="process_cat" value="#attributes.process_cat#">
			<input type="hidden" name="action_date" id="action_date" value="#attributes.action_date#">
			<input type="hidden" name="paper_number" id="paper_number" value="#attributes.paper_number#">
			<input type="hidden" name="sales_credit" id="sales_credit" value="#attributes.sales_credit#">
			<input type="hidden" name="sales_credit_comm" id="sales_credit_comm" value="#attributes.sales_credit_comm#">
			<input type="hidden" name="currency_id" id="currency_id" value="#listGetAt(attributes.action_to_account_id,2,';')#">
			<input type="hidden" name="other_value_sales_credit" id="other_value_sales_credit" value="#attributes.other_value_sales_credit#">
			<input type="hidden" name="money_type" id="money_type" value="#attributes.money_type#">
			<input type="hidden" name="action_detail" id="action_detail" value="#attributes.action_detail#">
			<input type="hidden" name="process_type" id="process_type" value="#process_type#">
			<input type="hidden" name="is_cari" id="is_cari" value="#is_cari#">
			<input type="hidden" name="is_account" id="is_account" value="#is_account#">
			<input type="hidden" name="expire_month" id="expire_month" value="#expire_month#">
			<input type="hidden" name="expire_year" id="expire_year" value="#expire_year#">
			<input type="hidden" name="my_acc_result" id="my_acc_result" value="#my_acc_result#">
			<input type="hidden" name="card_owner" id="card_owner" value="#attributes.card_owner#">
			<input type="hidden" name="kur_say" id="kur_say" value="#attributes.kur_say#">
			<input type="hidden" name="system_amount" id="system_amount" value="#system_amount#">
			<cfif session.ep.our_company_info.project_followup eq 1 and isdefined('attributes.project_id')>
				<input type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
				<input type="hidden" name="project_name" id="project_name" value="#attributes.project_name#">
			</cfif>
			<cfloop from="1" to="#attributes.kur_say#" index="i">
				<input type="hidden" name="txt_rate1_#i#" id="txt_rate1_#i#" value="#evaluate('attributes.txt_rate1_#i#')#">
				<input type="hidden" name="txt_rate2_#i#" id="txt_rate2_#i#" value="#evaluate('attributes.txt_rate2_#i#')#">
				<input type="hidden" name="hidden_rd_money_#i#" id="hidden_rd_money_#i#" value="#evaluate('attributes.hidden_rd_money_#i#')#">
			</cfloop>
			<cfif isDefined("attributes.subs_inv_id")>
				<input type="hidden" name="subs_inv_id" id="subs_inv_id" value="#attributes.subs_inv_id#">
				<input type="hidden" name="period_id" id="period_id" value="#attributes.period_id#">
			</cfif>
			<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
				<input type="hidden" name="branch_id" id="branch_id" value="#attributes.branch_id#">
			</cfif>
			<input type="hidden" name="vft_code" id="vft_code" value="#vft_code#">
			<input type="hidden" name="exp_year" id="exp_year" value="#attributes.exp_year#">
		</cfoutput>
		<cf_box_elements>
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
					<label><cf_get_lang dictionary_id='58607.Firma'></label>
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
					<cfif len(attributes.action_from_company_id)>
						<cfquery name="GET_COMPANY_INFO" datasource="#DSN#">
							SELECT NICKNAME,MEMBER_CODE FROM COMPANY WHERE COMPANY_ID = #attributes.action_from_company_id#
						</cfquery>
						<cfinput type="text" name="firma_info" value="#GET_COMPANY_INFO.NICKNAME#" readonly="yes">
						<cfinput type="hidden" name="member_code" value="#GET_COMPANY_INFO.MEMBER_CODE#" readonly="yes">
					<cfelse>
						<cfquery name="GET_CONSUMER_INFO" datasource="#DSN#">
							SELECT CONSUMER_NAME,CONSUMER_SURNAME,MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID = #attributes.cons_id#
						</cfquery>
						<cfinput type="text" name="firma_info" value="#GET_CONSUMER_INFO.CONSUMER_NAME & ' ' & GET_CONSUMER_INFO.CONSUMER_SURNAME#" readonly="yes">
						<cfinput type="hidden" name="member_code" value="#GET_CONSUMER_INFO.MEMBER_CODE#" readonly="yes">
					</cfif>
				</div>
			</div>
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
					<label><cf_get_lang dictionary_id='30233.Kart No'></label>
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
					<cfif isdefined('attributes.card_no_dec') and len(attributes.card_no_dec)>
						<cfinput type="hidden" name="card_no" value="#attributes.card_no#" readonly="yes">
						<cfinput type="text" name="card_no_dec" value="#attributes.card_no_dec#" readonly="yes">
					<cfelse>
						<cfinput type="text" name="card_no" value="#attributes.card_no#" readonly="yes">
					</cfif>
				</div>
			</div>
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
					<label><cf_get_lang dictionary_id='30541.Kart Hamili'></label>
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
					<cfinput type="text" name="kart_sahibi" value="#attributes.card_owner#" readonly="yes">
				</div>
			</div>
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
					<label><cf_get_lang dictionary_id='30542.CVV No'></label>
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
					<cfif isdefined('attributes.cvv_no_dec') and len(attributes.cvv_no_dec)>
						<cfinput type="hidden" name="cvv_no" value="#attributes.cvv_no#" readonly="yes">
						<cfinput type="text" name="cvv_no_dec" value="#attributes.cvv_no_dec#" readonly="yes">
					<cfelse>
						<cfinput type="text" name="cvv_no" value="#attributes.cvv_no#" readonly="yes">
					</cfif>
				</div>
			</div>
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
					<label><cf_get_lang dictionary_id='57673.Tutar'></label>
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
					<cfinput type="text" name="sales_credit_dsp" class="moneybox" value="#attributes.sales_credit#" readonly="yes">
				</div>
			</div>
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
					<label><cf_get_lang dictionary_id='30132.Taksit Sayısı'></label>
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
					<cfinput type="text" name="taksit_sayisi" class="moneybox" value="#taksit_sayisi#" readonly="yes">
				</div>
			</div>
			<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
					<label><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
					<cfinput type="text" name="odeme_yontemi" value="#GET_TAKS_METHOD.CARD_NO#" readonly="yes">
				</div>
			</div>
			<!-- sil -->
			<cfif isDefined("attributes.joker_vada")><!--- Joker Vada Kullanmak İstiyorum seçeneği seçilmişse --->
				<cfinclude template="../../add_options/query/add_online_pos_jokervada.cfm"><!--- sorgulama yapar --->
				<cfif approved_joker_info eq 1><!--- Joker vada kontrolunden onay almışsa --->
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id="35619.Joker Vada Seçenekleri"></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfoutput>
								<cfset code_sayisi = Arraylen(xml_response_node.posnetResponse.koiInfo.code)>
								<cfset message_sayisi = Arraylen(xml_response_node.posnetResponse.koiInfo.message)>
								<cfloop from="1" to="#code_sayisi#" index="i">
									<cfset vada_code = xml_response_node.posnetResponse.koiInfo.code[i].XmlText>
									<cfset vada_message = xml_response_node.posnetResponse.koiInfo.message[i].XmlText>
									<input type="radio" name="joker_options_value" id="joker_options_value" value="#vada_code#">#vada_message#<br/>
								</cfloop>
							</cfoutput>
						</div>
					</div>
				<cfelse>
					<div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='35620.Joker Vada Sorgusu'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfoutput>#xml_response_node.posnetResponse.respText.XmlText#</cfoutput>
						</div>
					</div>
				</cfif>
			</cfif>
			<!-- sil -->
		</cf_box_elements>
		<cf_box_footer>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id ='35370.Tahsilatı Gerçekleştir'></cfsavecontent>
			<cfsavecontent variable="message2"><cf_get_lang dictionary_id ='35369.Online Tahsilat İşlemi Yapılacaktır,Devam Etmek İstiyormusunuz'></cfsavecontent>
			<cf_workcube_buttons is_upd='0'  insert_info='#message#' insert_alert='#message2#'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script language="javascript1.3">
<cfif use_https>
	window.defaultStatus="<cf_get_lang dictionary_id ='35375.Bu sayfada SSL Kullanılmaktadır'>."
</cfif>
function unformat_fields()
{
	for(var i=1;i<=add_online_pos.kur_say.value;i++)
	{
		eval('add_online_pos.txt_rate1_' + i).value = filterNum(eval('add_online_pos.txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		eval('add_online_pos.txt_rate2_' + i).value = filterNum(eval('add_online_pos.txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
