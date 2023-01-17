<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_BANK_CREDIT_PAYMENTS" datasource="#dsn3#">
	SELECT 
		CREDIT_CARD_BANK_PAYMENTS_ROWS.BANK_ACTION_ID,
		CREDIT_CARD_BANK_PAYMENTS_ROWS.BANK_ACTION_PERIOD_ID,
		CREDIT_CARD_BANK_PAYMENTS_ROWS.BANK_ACTION_DATE,
		CREDIT_CARD_BANK_PAYMENTS_ROWS.OPERATION_NAME,
		CREDIT_CARD_BANK_PAYMENTS_ROWS.AMOUNT,
		CREDIT_CARD_BANK_PAYMENTS_ROWS.COMMISSION_AMOUNT,
		CREDIT_CARD_BANK_PAYMENTS.*,
		CREDITCARD_PAYMENT_TYPE.BANK_ACCOUNT,
		CREDITCARD_PAYMENT_TYPE.CARD_NO PAYM_NAME
	FROM 
		CREDIT_CARD_BANK_PAYMENTS,
		CREDIT_CARD_BANK_PAYMENTS_ROWS,
		CREDITCARD_PAYMENT_TYPE
	WHERE 
		CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID = CREDIT_CARD_BANK_PAYMENTS_ROWS.CREDITCARD_PAYMENT_ID AND
		CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID = #attributes.id# AND 
		CREDIT_CARD_BANK_PAYMENTS.PAYMENT_TYPE_ID = CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID
</cfquery>
<cf_box title="#getLang('main',424)# #getLang('main',359)#">
	<cf_box_elements>
		<cfoutput>
			<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
				<div class="form-group">
					<label class="bold col-4 col-md-6 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'> : </label>
					<label class="col col-8 col-md-6 col-sm-8 col-xs-12">#dateformat(GET_BANK_CREDIT_PAYMENTS.STORE_REPORT_DATE,dateformat_style)#</label>
				</div>
				<div class="form-group">
					<label class="bold col-4 col-md-6 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='57658.Üye'> : </label>
					<label class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfif len(GET_BANK_CREDIT_PAYMENTS.ACTION_FROM_COMPANY_ID)>
							#get_par_info(GET_BANK_CREDIT_PAYMENTS.ACTION_FROM_COMPANY_ID,1,0,1)#
							<cfset key_type = '#GET_BANK_CREDIT_PAYMENTS.ACTION_FROM_COMPANY_ID#'>
						<cfelseif len(GET_BANK_CREDIT_PAYMENTS.CONSUMER_ID)>
							#get_cons_info(GET_BANK_CREDIT_PAYMENTS.CONSUMER_ID,0,1)#
							<cfset key_type = '#GET_BANK_CREDIT_PAYMENTS.CONSUMER_ID#'>
						</cfif>						
					</label>
				</div>
				<div class="form-group">
					<label class="bold col-4 col-md-6 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='57692.İşlem'> : </label>
					<label class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfif GET_BANK_CREDIT_PAYMENTS.ACTION_TYPE_ID eq 52>
							<cf_get_lang dictionary_id='57765.Perakende Satış Faturası'>
						<cfelse>
							#GET_BANK_CREDIT_PAYMENTS.ACTION_TYPE#
						</cfif>
					</label>
				</div>
				<div class="form-group">
					<label class="bold col-4 col-md-6 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'> : </label>
					<label class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfif len(GET_BANK_CREDIT_PAYMENTS.BANK_ACCOUNT)>
							<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
								SELECT 
									ACCOUNT_NAME, 
									<cfif session.ep.period_year lt 2009>
										CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID
									<cfelse>
										ACCOUNTS.ACCOUNT_CURRENCY_ID
									</cfif> 
								FROM 
									ACCOUNTS 
								WHERE 
									ACCOUNT_ID = #GET_BANK_CREDIT_PAYMENTS.BANK_ACCOUNT#
							</cfquery>
							#get_accounts.account_name#/#get_accounts.account_currency_id#
						</cfif>
					</label>
				</div>
			</div>
			<div  class="col col-4 col-md-6 col-sm-6 col-xs-12">
				<div class="form-group">
					<label class="bold col-4 col-md-6 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='48854.Kart No'> : </label>
					<label class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfif len(GET_BANK_CREDIT_PAYMENTS.CARD_NO)>
							<!--- 
								FA-09102013
								kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
								Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
							--->
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
								<cfset content = contentEncryptingandDecodingAES(isEncode:0,content:GET_BANK_CREDIT_PAYMENTS.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
								<cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
							<cfelse>
								<cfset content = '#mid(Decrypt(GET_BANK_CREDIT_PAYMENTS.CARD_NO,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(GET_BANK_CREDIT_PAYMENTS.CARD_NO,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(GET_BANK_CREDIT_PAYMENTS.CARD_NO,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(GET_BANK_CREDIT_PAYMENTS.CARD_NO,key_type,"CFMX_COMPAT","Hex")))#'>
							</cfif>
							#content#
						</cfif>
					</label>
				</div>
				<div class="form-group">
					<label class="bold col-4 col-md-6 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'> : </label>
					<label class="col col-8 col-md-6 col-sm-8 col-xs-12">
						#GET_BANK_CREDIT_PAYMENTS.PAPER_NO#
					</label>
				</div>
				<div class="form-group">
					<label class="bold col-4 col-md-6 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='57882.İşlem Tutarı'> : </label>
					<label class="col col-8 col-md-6 col-sm-8 col-xs-12">
						#TLFormat(GET_BANK_CREDIT_PAYMENTS.SALES_CREDIT)# #GET_BANK_CREDIT_PAYMENTS.ACTION_CURRENCY_ID#
					</label>
				</div>
				<div class="form-group">
					<label class="bold col-4 col-md-6 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='49016.İşlem Döviz Tutarı'> : </label>
					<label class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfif len(GET_BANK_CREDIT_PAYMENTS.OTHER_CASH_ACT_VALUE) and len(GET_BANK_CREDIT_PAYMENTS.OTHER_MONEY)>
							#TLFormat(GET_BANK_CREDIT_PAYMENTS.OTHER_CASH_ACT_VALUE)# #GET_BANK_CREDIT_PAYMENTS.OTHER_MONEY#</cfif>
					</label>
				</div>
			</div>
			
			<cfif GET_BANK_CREDIT_PAYMENTS.action_type_id eq 245 and len(GET_BANK_CREDIT_PAYMENTS.RELATION_CREDITCARD_PAYMENT_ID)>
				<!--- belge ile iliskili tahsilat belgesi --->
				<cfquery name="getRelationCreditCard" datasource="#dsn3#">
					SELECT STORE_REPORT_DATE,PAPER_NO,CREDITCARD_PAYMENT_ID FROM CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID = #GET_BANK_CREDIT_PAYMENTS.RELATION_CREDITCARD_PAYMENT_ID#
				</cfquery>
				<tr height="20"><label>&nbsp;</label></tr>
				<tr>
					<label class="txtboldblue" colspan="2"><cf_get_lang dictionary_id="51295.İlişkili Tahsilat"></label>
				</tr>
				<tr>
					<label colspan="2">&nbsp;&nbsp;<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.popup_list_payment_plans&id=#getRelationCreditCard.creditcard_payment_id#','medium');">
						<cfif len(getRelationCreditCard.PAPER_NO)>#getRelationCreditCard.PAPER_NO#<cfelse>#getRelationCreditCard.CREDITCARD_PAYMENT_ID#</cfif>
						</a> - #dateFormat(getRelationCreditCard.STORE_REPORT_DATE,dateformat_style)#</label>
				</tr>
				<cfelse>
				<!--- belge ile iliskili iptal/iade belgeleri --->
				<cfquery name="getRelationCreditCard" datasource="#dsn3#">
					SELECT STORE_REPORT_DATE,PAPER_NO,CREDITCARD_PAYMENT_ID FROM CREDIT_CARD_BANK_PAYMENTS WHERE RELATION_CREDITCARD_PAYMENT_ID = #attributes.id#
				</cfquery>
				<cfif getRelationCreditCard.recordcount>
					<tr height="20"><label>&nbsp;</label></tr>
					<tr>
						<label class="txtboldblue" colspan="2"><cf_get_lang dictionary_id="
							51303.İlişkili İade/İptal"></label>
					</tr>
					<cfloop query="getRelationCreditCard">
						<tr>
							<label colspan="2">&nbsp;&nbsp;<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.popup_list_payment_plans&id=#getRelationCreditCard.creditcard_payment_id#','medium');">
								<cfif len(getRelationCreditCard.PAPER_NO)>#getRelationCreditCard.PAPER_NO#<cfelse>#getRelationCreditCard.CREDITCARD_PAYMENT_ID#</cfif>
								</a> - #dateFormat(getRelationCreditCard.STORE_REPORT_DATE,dateformat_style)#
							</label>
						</tr>
					</cfloop>
				</cfif>
			</cfif>        
		</cfoutput>
	</cf_box_elements>
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='48897.Hesaba Geçiş Tarihi'></th>
				<th><cf_get_lang dictionary_id='57692.İşlem'></th>
				<th><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th><cf_get_lang dictionary_id='48904.Komisyon Tutarı'></th>
				<th><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='57673.Tutar'></th>
				<th width="20"></th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="GET_BANK_CREDIT_PAYMENTS">
				<tr <cfif len(BANK_ACTION_ID)>class="color-gray"<cfelse>class="color-row"</cfif> height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';">
					<td><cfif len(BANK_ACTION_DATE)>#dateformat(BANK_ACTION_DATE,dateformat_style)#</cfif></td>
					<td>#OPERATION_NAME#</td>
					<td class="moneybox">#TLFormat(AMOUNT-COMMISSION_AMOUNT)#</td>
					<td class="moneybox">#TLFormat(COMMISSION_AMOUNT)#</td>
					<td class="moneybox">#TLFormat(AMOUNT)# #ACTION_CURRENCY_ID#</td>
					<td width="20"><!--- ilişkili hesaba geçiş işlemini gösterir,birebir tutarı yansıtmaz,hesaba geçiş işlemleri çünkü toplu yapılır --->
						<cfif len(BANK_ACTION_ID)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.popup_upd_bank_cc_payment&id=#BANK_ACTION_ID#&action_period_id=#BANK_ACTION_PERIOD_ID#','small');"><img src="images/report_square2.gif" border="0" alt="<cf_get_lang dictionary_id='49017.İlişkili Hesaba Geçiş İşlemi'>" title="<cf_get_lang dictionary_id='49017.İlişkili Hesaba Geçiş İşlemi'>"></a></cfif>
					</td>
				</tr>
			</cfoutput>         
		</tbody>
	</cf_grid_list>
</cf_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
