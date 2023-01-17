<cf_xml_page_edit fuseact="bank.list_credit_card_expense">
<!---E.A 23072012 select ifadeleri düzenlendi.--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.date_format" default="1">
<cfparam name="attributes.action" default="">
<cfparam name="attributes.credit_card_info" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.bank_action_type" default="">
<cfparam name="attributes.list_type" default="1">
<cfscript>
	getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
	getCCNOKey.dsn = dsn;
	getCCNOKey1 = getCCNOKey.getCCNOKey1();
	getCCNOKey2 = getCCNOKey.getCCNOKey2();
</cfscript>
<cfif isdefined('attributes.date_1') and len(attributes.date_1)>
	<cf_date tarih='attributes.date_1'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.date_1=''>
	<cfelse>
		<cfparam name="attributes.date_1" default="#dateformat(now(),dateformat_style)#">
	</cfif>
</cfif>
<cfif  isdefined('attributes.date_2') and len(attributes.date_2)>
	<cf_date tarih='attributes.date_2'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.date_2=''>
	<cfelse>
		<cfparam name="attributes.date_2" default="#createodbcdate(date_add('d',1,now()))#">
	</cfif>
</cfif>
<cfif isdefined('attributes.pay_date1') and len(attributes.pay_date1)>
	<cf_date tarih='attributes.pay_date1'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.pay_date1=''>
	<cfelse>
		<cfparam name="attributes.pay_date1" default="#dateformat(now(),dateformat_style)#">
	</cfif>
</cfif>
<cfif  isdefined('attributes.pay_date2') and len(attributes.pay_date2)>
	<cf_date tarih='attributes.pay_date2'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.pay_date2=''>
	<cfelse>
		<cfparam name="attributes.pay_date2" default="#createodbcdate(date_add('d',1,now()))#">
	</cfif>
</cfif>
<cfif isdefined('attributes.installment_date1') and len(attributes.installment_date1)>
	<cf_date tarih='attributes.installment_date1'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.installment_date1=''>
	<cfelse>
		<cfparam name="attributes.installment_date1" default="#dateformat(now(),dateformat_style)#">
	</cfif>
</cfif>
<cfif  isdefined('attributes.installment_date2') and len(attributes.installment_date2)>
	<cf_date tarih='attributes.installment_date2'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.installment_date2=''>
	<cfelse>
		<cfparam name="attributes.installment_date2" default="#createodbcdate(date_add('d',1,now()))#">
	</cfif>
</cfif>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY FROM SETUP_MONEY
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfset arama_yapilmali = 0>
	<cfquery name="GET_CREDIT" datasource="#dsn3#">
		SELECT
			CBE.ACTION_PERIOD_ID,
			CBE.CREDITCARD_EXPENSE_ID,
			CBE.PROCESS_TYPE,
			CBE.ACTION_DATE,
			CBE.ACTION_TO_COMPANY_ID,
			CBE.CONS_ID,
			CBE.ACTION_CURRENCY_ID,
			CBE.TOTAL_COST_VALUE,
			CBE.DETAIL,
			CBE.PAPER_NO,
			CBE.EXPENSE_ID,
			CBE.INVOICE_ID,						
			ACCOUNTS.ACCOUNT_NAME,
			CREDIT_CARD.CREDITCARD_NUMBER,
			ISNULL(CREDIT_CARD.PAYMENT_DAY,0) PAYMENT_DAY
		<cfif len(attributes.credit_card_info) or attributes.list_type eq 2 or isDefined("attributes.check_payment_info")>
			,CC_BANK_EXPENSE_ROWS_ID
			,CC_ACTION_DATE
			,ACC_ACTION_DATE
			,CARD_LIMIT
			,CREDIT_CARD.MONEY_CURRENCY
			,INSTALLMENT_DETAIL
			,INSTALLMENT_AMOUNT
			,CCBEROW.CC_BANK_EXPENSE_ROWS_ID
			,ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CCBEROW.CC_BANK_EXPENSE_ROWS_ID),0) CLOSED_AMOUNT
		</cfif>
		,CONSUMER.CONSUMER_NAME
		,CONSUMER.CONSUMER_SURNAME
		,COMPANY.FULLNAME
		,CBE.INSTALLMENT_NUMBER
		<cfif len(attributes.credit_card_info) or attributes.list_type eq 2 or isDefined("attributes.check_payment_info")>
		,(CASE  WHEN (SELECT TOP 1 CCBER.CC_BANK_EXPENSE_ROWS_ID FROM CREDIT_CARD_BANK_EXPENSE_ROWS AS CCBER where  CCBEROW.INSTALLMENT_AMOUNT > 0 AND CCBER.CREDITCARD_EXPENSE_ID = CBE.CREDITCARD_EXPENSE_ID ORDER BY CCBER.CC_BANK_EXPENSE_ROWS_ID DESC) = CCBEROW.CC_BANK_EXPENSE_ROWS_ID AND CBE.INSTALLMENT_NUMBER IS NOT NULL  THEN 1 ELSE 0  END) AS LR
		</cfif>
		FROM
			CREDIT_CARD_BANK_EXPENSE CBE 
			LEFT JOIN
				#DSN_ALIAS#.CONSUMER
			ON
					CONSUMER.CONSUMER_ID = CBE.CONS_ID
			LEFT JOIN
				#DSN_ALIAS#.COMPANY
			ON
				COMPANY.COMPANY_ID=CBE.ACTION_TO_COMPANY_ID            
			,ACCOUNTS AS ACCOUNTS,
			CREDIT_CARD AS CREDIT_CARD
		<cfif len(attributes.credit_card_info) or attributes.list_type eq 2 or isDefined("attributes.check_payment_info")>
			,CREDIT_CARD_BANK_EXPENSE_ROWS AS CCBEROW
		</cfif>
		WHERE
		<cfif len(attributes.credit_card_info) or attributes.list_type eq 2 or isDefined("attributes.check_payment_info")>
			CCBEROW.CREDITCARD_EXPENSE_ID = CBE.CREDITCARD_EXPENSE_ID AND
			<cfif len(attributes.credit_card_info)>
				CBE.ACCOUNT_ID = #listgetat(attributes.credit_card_info,1,';')# AND
				CBE.CREDITCARD_ID = #listgetat(attributes.credit_card_info,3,';')# AND
			</cfif>
		</cfif>
			ACCOUNTS.ACCOUNT_ID = CBE.ACCOUNT_ID AND
			CREDIT_CARD.CREDITCARD_ID = CBE.CREDITCARD_ID
			<cfif len(attributes.keyword)>
				AND
				(
					CBE.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					CBE.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)
			</cfif>
			<cfif len(attributes.date_1)>AND CBE.ACTION_DATE >= #attributes.date_1#</cfif>
			<cfif len(attributes.date_2)>AND CBE.ACTION_DATE < #DATEADD("d",1,attributes.date_2)#</cfif>
			<cfif len(attributes.credit_card_info) or attributes.list_type eq 2 or isDefined("attributes.check_payment_info")>
				<cfif len(attributes.pay_date1)>AND DATEADD(d,PAYMENT_DAY,ACC_ACTION_DATE) >= #attributes.pay_date1#</cfif>
				<cfif len(attributes.pay_date2)>AND DATEADD(d,PAYMENT_DAY,ACC_ACTION_DATE) < #DATEADD("d",1,attributes.pay_date2)#</cfif>
				<cfif len(attributes.date_1)>AND CC_ACTION_DATE >= #attributes.date_1#</cfif>
				<cfif len(attributes.date_2)>AND CC_ACTION_DATE < #DATEADD("d",1,attributes.date_2)#</cfif>
				<cfif len(attributes.installment_date1)>AND ACC_ACTION_DATE >= #attributes.installment_date1#</cfif>
				<cfif len(attributes.installment_date2)>AND ACC_ACTION_DATE < #DATEADD("d",1,attributes.installment_date2)#</cfif>
			</cfif>
			<cfif len(attributes.company_id) and len(attributes.member_name)>
				AND CBE.ACTION_TO_COMPANY_ID = #attributes.company_id#
			<cfelseif len(attributes.cons_id) and len(attributes.member_name)>
				AND CBE.CONS_ID = #attributes.cons_id#
			</cfif>
			<cfif isDefined("attributes.check_payment_info")>
				AND ROUND((INSTALLMENT_AMOUNT-(ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CCBEROW.CC_BANK_EXPENSE_ROWS_ID),0))),2) > 0
			</cfif>
			<cfif len(attributes.bank_action_type)>
				AND CBE.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_action_type#">
			</cfif>
		ORDER BY
			<cfif len(attributes.date_format) and (attributes.date_format eq 1)>
			CBE.ACTION_DATE DESC
			<cfelse>
			CBE.ACTION_DATE
			</cfif>
	</cfquery>
<cfelse>
		<cfset get_credit.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_credit.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_credit_card_expense" method="post" action="#request.self#?fuseaction=bank.list_credit_card_expense">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search plus="0">
				<div class="form-group">            
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#getLang(48,'Filtre',57460)#" maxlength="255">
				</div>
				<div class="form-group">            
					<div class="input-group">
						<cfif len(attributes.credit_card_info)><cfset cc_info = listgetat(attributes.credit_card_info,3,';')><cfelse><cfset cc_info = ""></cfif>
						<cf_wrk_our_credit_cards slct_width="275" credit_card_info="#cc_info#" onclick_function="show_date_info(1);">
					</div>
				</div>                    
				<div class="form-group small">            
					<!---<cfsavecontent variable="message"><cf_get_lang dictionary_id='125.Sayi_Hatasi_Mesaj'></cfsavecontent>--->
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" maxlength="3">
				</div>                     
				<div class="form-group">                    
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>                
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_credit_card_expense&event=add<cfif len(attributes.credit_card_info)>&credit_card_info=<cfoutput>#cc_info#</cfoutput></cfif>','medium')"><i class="fa fa-plus"></i></a>
				</div>	
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-date_1">	
						<label class="col col-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
						<div class="col col-6 col-xs-12">
							<div class="input-group">
								<!---<cfsavecontent variable="message"><cf_get_lang dictionary_id='1091.Lutfen Tarih Giriniz'>!</cfsavecontent>--->
								<cfinput type="text" name="date_1" value="#dateformat(attributes.date_1,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date_1"></span>
							</div>
						</div>
						<div class="col col-6 col-xs-12">
							<div class="input-group">                            	
								<cfinput type="text" name="date_2" value="#dateformat(attributes.date_2,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date_2"></span>                           
							</div>
						</div>
					</div>
					<div class="form-group" id="pay_date" <cfif attributes.list_type eq 1>style="display:none;"</cfif>>	
						<label class="col col-12"><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></label>
						<div class="col col-6 col-xs-12">
							<div class="input-group">
								<!---<cfsavecontent variable="message"><cf_get_lang dictionary_id='1091.Lutfen Tarih Giriniz'>!</cfsavecontent>--->
								<cfinput type="text" name="pay_date1" value="#dateformat(attributes.pay_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="pay_date1"></span>
							</div>
						</div>
						<div class="col col-6 col-xs-12">
							<div class="input-group">                            	
								<cfinput type="text" name="pay_date2" value="#dateformat(attributes.pay_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="pay_date2"></span>                           
							</div>
						</div>
					</div>
					<div class="form-group" id="installment_date" <cfif attributes.list_type eq 1>style="display:none;"</cfif>>	
						<label class="col col-12"><cf_get_lang dictionary_id='48793.Taksit Tarihi'></label>
						<div class="col col-6 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="installment_date1" value="#dateformat(attributes.installment_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="installment_date1"></span>
							</div>
						</div>
						<div class="col col-6 col-xs-12">
							<div class="input-group">                            	
								<cfinput type="text" name="installment_date2" value="#dateformat(attributes.installment_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="installment_date2"></span>                           
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
					<div class="form-group" id="item-bank_action_type">	
						<label class="col col-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
						<div class="col col-12">
							<select name="bank_action_type" id="bank_action_type">
								<option value=""><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
								<option value="242" <cfif attributes.bank_action_type eq 242>selected</cfif>><cf_get_lang dictionary_id="29550.Kredi Kartı Borcu Ödeme"></option>
								<option value="246" <cfif attributes.bank_action_type eq 246>selected</cfif>><cf_get_lang dictionary_id="29551.Kredi Kartı Borcu Ödeme İptal"></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="type_list" <cfif len(attributes.credit_card_info)>style="display:none;"</cfif>>
						<label class="col col-12"><cf_get_lang dictionary_id='57660.Belge Bazında'>/<cf_get_lang dictionary_id='29539.Satır Bazında'></label>
						<div class="col col-12">
							<select name="list_type" id="list_type" onChange="show_date_info(0);">
								<option value="1" <cfif attributes.list_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
								<option value="2" <cfif attributes.list_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
							</select>           
						</div>
					</div>		
				</div>              
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
					<div class="form-group" id="item-member_name">	
						<label class="col col-12"><cf_get_lang dictionary_id='57519.cari Hesap'></label>
						<div class="col col-12 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
								<input type="hidden" name="cons_id" id="cons_id" value="<cfoutput>#attributes.cons_id#</cfoutput>">
								<input name="member_name" type="text" id="member_name" placeholder="<cf_get_lang dictionary_id='57519.cari Hesap'>" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID,CONSUMER_ID','company_id,cons_id','','3','250');" value="<cfoutput>#attributes.member_name#</cfoutput>" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_name=list_credit_card_expense.member_name&field_consumer=list_credit_card_expense.cons_id&is_cari_action=1&field_comp_id=list_credit_card_expense.company_id&select_list=2,3</cfoutput>','list');" title="<cf_get_lang dictionary_id='57519.cari Hesap'>"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-date_format">
						<label class="col col-12"><cf_get_lang dictionary_id='57925.Artan Tarih'>/<cf_get_lang dictionary_id='57926.Azalan Tarih'></label>
						<div class="col col-12">            
							<select name="date_format" id="date_format">
								<option value="2" <cfif attributes.date_format eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
								<option value="1" <cfif attributes.date_format eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
							</select>
						</div>
					</div>	
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="4">
					<div class="form-group" id="item-check_payment_info">
						<label class="col col-12"><cf_get_lang dictionary_id='48796.Ödenmemişleri Göster'></label>	
						<div class="col col-12">
							<label><cf_get_lang dictionary_id='48796.Ödenmemişleri Göster'><input type="checkbox" name="check_payment_info" id="check_payment_info" <cfif isDefined("attributes.check_payment_info")>checked</cfif>></label>
						</div>
					</div>
				</div> 
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(211,'Kredi Kartıyla Ödemeler',48872)#" uidrop="1" hide_table_column="1"  scroll="1" woc_setting = "#{ checkbox_name : 'print_credicard_id', print_type : 153 }#">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<cfif len(attributes.credit_card_info) or attributes.list_type eq 2 or isDefined("attributes.check_payment_info")>
						<th><cf_get_lang dictionary_id='29449.Banka Hesabı'>- <cf_get_lang dictionary_id='58199.Kredi Kartı'></th>
						<th><cf_get_lang dictionary_id='57630.Tip'></th>
						<th><cf_get_lang dictionary_id='57880.Belge No'></th>
						<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
						<th><cf_get_lang dictionary_id='57692.İşlem'></th>
						<th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
						<th><cf_get_lang dictionary_id='48793.Taksit Tarihi'></th>
						<th><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></th>
						<th><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th><cf_get_lang dictionary_id='48767.Taksit Tutarı'></th>
						<th><cf_get_lang dictionary_id='48768.Ödenen Tutar'></th>
						<th><cf_get_lang dictionary_id='48769.Kalan Tutar'></th>
						<th><cf_get_lang dictionary_id ='57489.Para Br'></th>
						<th width="40" class="header_icn_none"><input type="checkbox" name="all_cc_expense" id="all_cc_expense" onClick="select_all('all_cc_expense','_cc_expense_');"></th>
					<cfelse>
						<th><cf_get_lang dictionary_id='29449.Banka Hesabı'>- <cf_get_lang dictionary_id='58199.Kredi Kartı'></th>
						<th><cf_get_lang dictionary_id='57630.Tip'></th>
						<th><cf_get_lang dictionary_id='57880.Belge No'></th>
						<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
						<th><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th><cf_get_lang dictionary_id='57882.İşlem Tutarı'></th>
						<th><cf_get_lang dictionary_id ='57489.Para Br'></th>
						<!-- sil --><th width="20" class="header_icn_none"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_credit_card_expense&event=add','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
							<cfif   get_credit.recordcount>
								<th width="20" nowrap="nowrap" class="text-center header_icn_none">
									<cfif get_credit.recordcount eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a></cfif>
									<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_credicard_id');">
								</th>
					
							</cfif>
							<!-- sil -->
					</cfif>
				</tr>
			</thead>
			<tbody>
				<cfif get_credit.recordcount>
					<cfoutput query="get_credit" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<cfset key_type = '#session.ep.company_id#'>
							<!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
							<cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
								<!--- anahtarlar decode ediliyor --->
								<cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
								<cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
								<!--- kart no encode ediliyor --->
								<cfset content = contentEncryptingandDecodingAES(isEncode:0,content:creditcard_number,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
								<cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
							<cfelse>
								<cfset content = '#mid(Decrypt(creditcard_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(creditcard_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(creditcard_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(creditcard_number,key_type,"CFMX_COMPAT","Hex")))#'>
							</cfif>
							
							<cfif len(attributes.credit_card_info) or attributes.list_type eq 2 or isDefined("attributes.check_payment_info")>
								<td>#currentrow#</td>
								<td>
									<cfif len(expense_id) and action_period_id eq session.ep.period_id>
										<a class="tableyazi" href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#expense_id#&active_period=#action_period_id#">#account_name# / #content#</a>
									<cfelseif len(invoice_id) and action_period_id eq session.ep.period_id>
										<a class="tableyazi" href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#invoice_id#&active_period=#action_period_id#">#account_name# / #content#</a>
									<cfelseif not len(expense_id)>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.list_credit_card_expense&event=upd&id=#CREDITCARD_EXPENSE_ID#','project');" class="tableyazi">#account_name# / #content#</a>
									<cfelse>
										#account_name# / #content#
									</cfif>
								</td>
								<td>
									<cfif get_credit.PROCESS_TYPE eq 246><font color="red"><cf_get_lang dictionary_id="29554.KREDİ KARTIYLA ÖDEME İPTAL"></font><cfelse><cf_get_lang dictionary_id="48872.KREDİ KARTIYLA ÖDEME"></cfif>
								</td>
								<td>#PAPER_NO#</td>
								<td>
									<cfif len(ACTION_TO_COMPANY_ID)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#ACTION_TO_COMPANY_ID#','medium');" class="tableyazi"> #FULLNAME# </a>
									<cfelseif len(cons_id)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONS_ID#','medium');" class="tableyazi"> #CONSUMER_NAME# #CONSUMER_SURNAME#</a>
									</cfif>
								</td>
								<td>#INSTALLMENT_DETAIL#</td>
								<td>#dateformat(CC_ACTION_DATE,dateformat_style)#</td>
								<td>#dateformat(ACC_ACTION_DATE,dateformat_style)#</td>
								<td>#dateformat(date_add('d',PAYMENT_DAY,ACC_ACTION_DATE),dateformat_style)#</td>
								<cfif get_credit.PROCESS_TYPE eq 246 or get_credit.PROCESS_TYPE eq 249>
									<td style="text-align:right;"><font color="red">#TLFormat(-1*TOTAL_COST_VALUE)#</font></td>
									<td style="text-align:right;"><font color="red">#TLFormat(-1*INSTALLMENT_AMOUNT)#</font></td>
									<td style="text-align:right;"><font color="red">#TLFormat(-1*CLOSED_AMOUNT)#</font></td>
									<td style="text-align:right;"> 
										<cfset remain_amount = wrk_round(-1*(INSTALLMENT_AMOUNT-CLOSED_AMOUNT))>
										<cfif wrk_round(INSTALLMENT_AMOUNT,2)-wrk_round(CLOSED_AMOUNT,2) lte 0 or x_interim_payments eq 1>
											<input type="text" name="_cc_expense_amount_" id="cc_expense_amount_#CLOSED_AMOUNT#" value="#TLFormat(INSTALLMENT_AMOUNT-CLOSED_AMOUNT)#" style="width:70px" onKeyUp="FormatCurrency(this,event);" readonly class="box">
										<cfelse>
											<input type="text" name="_cc_expense_amount_" id="cc_expense_amount_#CLOSED_AMOUNT#" value="#TLFormat(remain_amount)#" style="width:70px" onKeyUp="FormatCurrency(this,event);" class="moneybox">
										</cfif>
									</td>
								<cfelse>
									<td style="text-align:right;">#TLFormat(TOTAL_COST_VALUE)# </td>
									<td style="text-align:right;">
									<cfif LR eq 1> 
										<!--- taksit tutarlari toplaminda olusan farkin son taksit tutarina yansitilmasi saglandi. --->
										<cfset TOTAL_INSTALLMENT = LSParseNumber(replace(replace(replace(TLFormat(INSTALLMENT_AMOUNT),",","*","all"),".",",","all"),"*",".","all")) * INSTALLMENT_NUMBER> <!-- hesaplanan taksitli toplam-->
										<cfset DIFF = LSParseNumber(replace(replace(replace(TLFormat(TOTAL_COST_VALUE),",","*","all"),".",",","all"),"*",".","all"))-TOTAL_INSTALLMENT> <!--- hesaplanan ile gercek toplam arasindaki fark --->
										<cfset INSTALLMENT_AMOUNT_UNF = LSParseNumber(replace(replace(replace(TLFormat(INSTALLMENT_AMOUNT),",","*","all"),".",",","all"),"*",".","all"))> <!--- formatsiz taksit tutari --->
										<cfset INSTALLMENT_AMOUNT_DIFF = INSTALLMENT_AMOUNT_UNF+DIFF> <!--- taksit tutarı +- aradaki fark --->
										#TLFormat(INSTALLMENT_AMOUNT_DIFF)#
									<cfelse>#TLFormat(INSTALLMENT_AMOUNT)#</cfif></td>
									<td style="text-align:right;">#TLFormat(CLOSED_AMOUNT)#</td>
									<td style="text-align:right;"> 
									<cfif LR eq 1>
										<cfset remain_amount = wrk_round(wrk_round(INSTALLMENT_AMOUNT_DIFF,2)-wrk_round(CLOSED_AMOUNT,2))>
										<cfif wrk_round(INSTALLMENT_AMOUNT_DIFF,2)-wrk_round(CLOSED_AMOUNT,2) lte 0 or x_interim_payments eq 1>
										<input type="text" name="_cc_expense_amount_" id="cc_expense_amount_#CLOSED_AMOUNT#" value="#TLFormat(wrk_round(INSTALLMENT_AMOUNT_DIFF,2)-wrk_round(CLOSED_AMOUNT,2))#" style="width:70px" onKeyUp="FormatCurrency(this,event);" readonly class="box">
										<cfelse>
											<input type="text" name="_cc_expense_amount_" id="cc_expense_amount_#CLOSED_AMOUNT#" value="#TLFormat(wrk_round(INSTALLMENT_AMOUNT_DIFF,2)-wrk_round(CLOSED_AMOUNT,2))#" style="width:70px" onKeyUp="FormatCurrency(this,event);" class="moneybox" >
										</cfif>
									<cfelse>
										<cfset remain_amount = wrk_round(wrk_round(INSTALLMENT_AMOUNT,2)-wrk_round(CLOSED_AMOUNT,2))>
										<cfif wrk_round(INSTALLMENT_AMOUNT,2)-wrk_round(CLOSED_AMOUNT,2) lte 0 or x_interim_payments eq 1>
										<input type="text" name="_cc_expense_amount_" id="cc_expense_amount_#CLOSED_AMOUNT#" value="#TLFormat(wrk_round(INSTALLMENT_AMOUNT,2)-wrk_round(CLOSED_AMOUNT,2))#" style="width:70px" onKeyUp="FormatCurrency(this,event);" readonly class="box">
										<cfelse>
											<input type="text" name="_cc_expense_amount_" id="cc_expense_amount_#CLOSED_AMOUNT#" value="#TLFormat(wrk_round(INSTALLMENT_AMOUNT,2)-wrk_round(CLOSED_AMOUNT,2))#" style="width:70px" onKeyUp="FormatCurrency(this,event);" class="moneybox" >
										</cfif>
									</cfif>
									</td>
								</cfif>
								<td>&nbsp;#ACTION_CURRENCY_ID#</td>
								<td nowrap="nowrap" style="text-align:right;">
									<cfif wrk_round(INSTALLMENT_AMOUNT) gt 0>
										<cfquery name="control_return" datasource="#dsn3#">
											SELECT INSTALLMENT_AMOUNT FROM CREDIT_CARD_BANK_EXPENSE_ROWS WHERE CREDITCARD_EXPENSE_ID = #CREDITCARD_EXPENSE_ID# AND CC_BANK_EXPENSE_ROWS_ID = #CC_BANK_EXPENSE_ROWS_ID# AND INSTALLMENT_AMOUNT < 0
										</cfquery>
										<cfif not control_return.recordcount>
											<i class="fa fa-times-circle" onclick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_credit_card_expense&event=addDebit&row_id=#CC_BANK_EXPENSE_ROWS_ID#&x_interim_payments=#x_interim_payments#&amount_val=<cfif isdefined("INSTALLMENT_AMOUNT_DIFF") and LR eq 1>#INSTALLMENT_AMOUNT_DIFF#<cfelse>#INSTALLMENT_AMOUNT#</cfif>&process_type=249<cfif len(attributes.credit_card_info)>&bcc_info=#ListGetAt(attributes.credit_card_info,1,';')#;#ListGetAt(attributes.credit_card_info,2,';')#&cc_info=#ListGetAt(attributes.credit_card_info,3,';')#</cfif>','medium')" style="font-size:18px; color : red" title="#getLang('main',1621,'İade et')#"> </i>
										</cfif>
									</cfif>
									<cfif wrk_round(INSTALLMENT_AMOUNT) lt 0>
										<cfset del_alert_ = getLang('main',121,'Silmek istediğinize emin misiniz')>
										<i class="fa fa-trash-o" href="javascript://" onclick="if(confirm('#del_alert_#')) delete_return(#CC_BANK_EXPENSE_ROWS_ID#); else return false;" style="font-size:18px; color : red" title="#getLang('main',51,'Sil')#"> </i>
									</cfif>
									<input type="checkbox" name="_cc_expense_" id="cc_expense_id_#CLOSED_AMOUNT#" value="#CC_BANK_EXPENSE_ROWS_ID#" <cfif INSTALLMENT_AMOUNT gt 0 and (wrk_round(INSTALLMENT_AMOUNT)-wrk_round(CLOSED_AMOUNT) lte 0)>disabled</cfif>>
								</td>
								
								<cfif get_credit.PROCESS_TYPE eq 246 or get_credit.PROCESS_TYPE eq 249>
									
									<cfif isdefined("inst_amount_#ACTION_CURRENCY_ID#")>
										<cfset "inst_amount_#ACTION_CURRENCY_ID#" = evaluate("inst_amount_#ACTION_CURRENCY_ID#") - INSTALLMENT_AMOUNT>
									<cfelse>
										<cfset "inst_amount_#ACTION_CURRENCY_ID#" = -1*INSTALLMENT_AMOUNT>
									</cfif>
									<cfif isdefined("paym_amount_#ACTION_CURRENCY_ID#")>
										<cfset "paym_amount_#ACTION_CURRENCY_ID#" = evaluate("paym_amount_#ACTION_CURRENCY_ID#") - CLOSED_AMOUNT>
									<cfelse>
										<cfset "paym_amount_#ACTION_CURRENCY_ID#" = -1*CLOSED_AMOUNT>
									</cfif>
								<cfelse>
									<cfif isdefined("inst_amount_#ACTION_CURRENCY_ID#")>
										<cfset "inst_amount_#ACTION_CURRENCY_ID#" = evaluate("inst_amount_#ACTION_CURRENCY_ID#") + INSTALLMENT_AMOUNT>
									<cfelse>
										<cfset "inst_amount_#ACTION_CURRENCY_ID#" = INSTALLMENT_AMOUNT>
									</cfif>
									<cfif isdefined("paym_amount_#ACTION_CURRENCY_ID#")>
										<cfset "paym_amount_#ACTION_CURRENCY_ID#" = evaluate("paym_amount_#ACTION_CURRENCY_ID#") + CLOSED_AMOUNT>
									<cfelse>
										<cfset "paym_amount_#ACTION_CURRENCY_ID#" = CLOSED_AMOUNT>
									</cfif>
								</cfif>
								<cfif isdefined("rest_amount_#ACTION_CURRENCY_ID#")>
									<cfset "rest_amount_#ACTION_CURRENCY_ID#" = evaluate("rest_amount_#ACTION_CURRENCY_ID#") + remain_amount><!--- INSTALLMENT_AMOUNT-CLOSED_AMOUNT --->
								<cfelse>
									<cfset "rest_amount_#ACTION_CURRENCY_ID#" = remain_amount>
								</cfif>
								<input type="hidden" name="process_type_#CC_BANK_EXPENSE_ROWS_ID#" id="process_type_#CC_BANK_EXPENSE_ROWS_ID#"  value="#get_credit.PROCESS_TYPE#">
							<cfelse>
								<td>#currentrow#</td>
								<td>
									<cfif len(expense_id) and action_period_id eq session.ep.period_id>
										<a class="tableyazi" href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#expense_id#&active_period=#action_period_id#">#account_name# / #content#</a>
									<cfelseif len(invoice_id) and action_period_id eq session.ep.period_id>
										<a class="tableyazi" href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#invoice_id#&active_period=#action_period_id#">#account_name# / #content#</a>
									<cfelseif not len(expense_id)>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.list_credit_card_expense&event=upd&id=#CREDITCARD_EXPENSE_ID#','project');" class="tableyazi">#account_name# / #content#</a>
									<cfelse>
										#account_name# / #content#
									</cfif>
								</td>
								<td>
									<cfif get_credit.PROCESS_TYPE eq 246><font color="red"><cf_get_lang dictionary_id="29554.KREDİ KARTIYLA ÖDEME İPTAL"></font><cfelse><cf_get_lang dictionary_id="48872.KREDİ KARTIYLA ÖDEME"></cfif>
								</td>
								<td>#PAPER_NO#</td>
								<td><cfif len(ACTION_TO_COMPANY_ID)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#ACTION_TO_COMPANY_ID#','medium');" class="tableyazi"> #FULLNAME# </a>
									<cfelseif len(cons_id)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONS_ID#','medium');" class="tableyazi"> #CONSUMER_NAME# #CONSUMER_SURNAME#</a>
									</cfif>
								</td>
								<td>#dateformat(ACTION_DATE,dateformat_style)#</td>
								<td nowrap="nowrap" style="text-align:right;">
									<cfif get_credit.PROCESS_TYPE eq 246 or get_credit.PROCESS_TYPE eq 249><font color="red">#TLFormat(-1*TOTAL_COST_VALUE)#</font><cfelse>#TLFormat(TOTAL_COST_VALUE)#</cfif>
								</td>
								<td>&nbsp;#ACTION_CURRENCY_ID#</td>
								<!-- sil -->
								<td width="1%" nowrap>
									<cfif len(expense_id) and action_period_id eq session.ep.period_id>
										<a class="tableyazi" href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#expense_id#&active_period=#action_period_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
									<cfelseif len(invoice_id) and action_period_id eq session.ep.period_id>
										<a class="tableyazi" href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#invoice_id#&active_period=#action_period_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>	
									<cfelseif not len(expense_id)>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.list_credit_card_expense&event=upd&id=#CREDITCARD_EXPENSE_ID#','project');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
									</cfif>
									<td style="text-align:center"><input type="checkbox" name="print_credicard_id" id="print_credicard_id" value="#CREDITCARD_EXPENSE_ID#"></td>
								</td>
								<!-- sil -->
								<cfif get_credit.PROCESS_TYPE eq 246 or get_credit.PROCESS_TYPE eq 249>
									<cfif isdefined("total_amount_#ACTION_CURRENCY_ID#")>
										<cfset "total_amount_#ACTION_CURRENCY_ID#" = evaluate("total_amount_#ACTION_CURRENCY_ID#") - TOTAL_COST_VALUE>
									<cfelse>
										<cfset "total_amount_#ACTION_CURRENCY_ID#" = -1*TOTAL_COST_VALUE>
									</cfif>
								<cfelse>
									<cfif isdefined("total_amount_#ACTION_CURRENCY_ID#")>
										<cfset "total_amount_#ACTION_CURRENCY_ID#" = evaluate("total_amount_#ACTION_CURRENCY_ID#")+ TOTAL_COST_VALUE>
									<cfelse>
										<cfset "total_amount_#ACTION_CURRENCY_ID#" = TOTAL_COST_VALUE>
									</cfif>
								</cfif>
							</cfif>
						</tr>
					</cfoutput>
					<cfoutput>
						<cfif len(attributes.credit_card_info) or attributes.list_type eq 2 or isDefined("attributes.check_payment_info")>
							<cfif len(attributes.credit_card_info) and x_interim_payments eq 1>
							<!--- varsa ara odeme toplami alinir --->
								<cfquery name="getInterimPayments" datasource="#dsn3#">
									WITH CTE AS(
									SELECT 
										BA.ACTION_ID,
										BA.ACTION_VALUE-ISNULL(BA.MASRAF,0) AS ACTION_VALUE,
										ROUND(ISNULL(SUM(CCB.CLOSED_AMOUNT),0),2) AS CLOSED_AMOUNT
									FROM 
										#dsn2_alias#.BANK_ACTIONS BA
										LEFT JOIN CREDIT_CARD_BANK_EXPENSE_RELATIONS CCB ON BA.ACTION_ID = CCB.BANK_ACTION_ID AND CCB.BANK_ACTION_PERIOD_ID = #session.ep.period_id#
									WHERE 
										BA.CREDITCARD_ID = #listgetat(attributes.credit_card_info,3,';')# 
									GROUP BY
										BA.ACTION_ID,
										BA.ACTION_VALUE,
										BA.MASRAF
									)
									SELECT ISNULL(SUM((ACTION_VALUE - CLOSED_AMOUNT)),0) AS INTERIM_PAYMENTS FROM CTE WHERE (ACTION_VALUE-CLOSED_AMOUNT)>0 
								</cfquery>
							<cfelse>
								<cfset getInterimPayments.INTERIM_PAYMENTS = 0>
							</cfif>
							<tr>
								<td>&nbsp;</td>
								<cfif len(attributes.credit_card_info)><td><font color="red"><cf_get_lang dictionary_id='48773.Kart Limit Bilgisi'> : </font>#TLFormat(GET_CREDIT.CARD_LIMIT)# #GET_CREDIT.MONEY_CURRENCY#</td></cfif>
								<td colspan="<cfif len(attributes.credit_card_info)>8<cfelse>9</cfif>" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'> :</td>
								<td style="text-align:right;">
									<cfloop query="get_money">
										<cfif isdefined("inst_amount_#get_money.money#") and evaluate("inst_amount_#get_money.money#") neq 0>
											#TLFormat(evaluate("inst_amount_#get_money.money#"))#<br/>
										</cfif>
									</cfloop>
								</td>
								<td style="text-align:right;">
									<cfloop query="get_money">
										<cfif isdefined("paym_amount_#get_money.money#") and evaluate("inst_amount_#get_money.money#") neq 0>
											#TLFormat(evaluate("paym_amount_#get_money.money#"))#<br/>
										</cfif>
									</cfloop>
									<cfif getInterimPayments.INTERIM_PAYMENTS gt 0>
									<cf_get_lang dictionary_id='48824.Ara Ödeme'> : #TLFormat(getInterimPayments.INTERIM_PAYMENTS)#
									</cfif>
								</td>
								<td style="text-align:right;">
									<cfloop query="get_money">
										<cfif isdefined("rest_amount_#get_money.money#") and evaluate("rest_amount_#get_money.money#") neq 0>
											#TLFormat(evaluate("rest_amount_#get_money.money#"))#<br/>
										</cfif>
									</cfloop>
								</td>
								<td>
									<cfloop query="get_money">
										<cfif isdefined("rest_amount_#get_money.money#") and evaluate("rest_amount_#get_money.money#") neq 0>
											#get_money.money#<br/>
										</cfif>
									</cfloop>
								</td>
								<td></td>
								
							</tr>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="16">
										<div class="ui-form-list-btn">
											<div>
											<a href="javascsript://" class="ui-btn ui-btn-success" type="button" onclick="add_debit_payment(1);" name="debt_paym_button" id="debt_paym_button"><cf_get_lang dictionary_id='29550.Kredi Kartı Borcu Ödeme'></a>
											</div>
											<div>
												<cfif x_interim_payments eq 1><a href="javascsript://" onclick="add_debit_payment(2);" class="ui-btn ui-btn-success" name="debt_paym_" id="debt_paym_"><cf_get_lang dictionary_id='48824.Ara Ödeme'></a></cfif>
											</div>
										</div>
									</td>
								</tr>
							</tfoot>
						<cfelse>
							<tfoot>
								<tr>
									<td colspan="6" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'> :</td> 
									<td style="text-align:right;">
									<cfloop query="get_money">
										<cfif isdefined("total_amount_#get_money.money#") and evaluate("total_amount_#get_money.money#") neq 0>
											#TLFormat(evaluate("total_amount_#get_money.money#"))#<br/>
										</cfif>
									</cfloop>
									</td> 
									<td>
										<cfloop query="get_money">
											<cfif isdefined("total_amount_#get_money.money#") and evaluate("total_amount_#get_money.money#") neq 0>
												#get_money.money#<br/>
											</cfif>
										</cfloop>
									</td>
									<td></td>
									<td></td>
								</tr>
							</tfoot>
						</cfif>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="15"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
		</cf_grid_list>

		<cfset url_str = "bank.list_credit_card_expense">
		<cfif isdefined("attributes.form_submitted")>
			<cfset url_str = '#url_str#&form_submitted=#attributes.form_submitted#'>
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.list_type)>
			<cfset url_str = "#url_str#&list_type=#attributes.list_type#">
		</cfif>
		<cfif len(attributes.date_format)>
			<cfset url_str = "#url_str#&date_format=#attributes.date_format#">
		</cfif>
		<cfif len(attributes.date_1)>
			<cfset url_str = "#url_str#&date_1=#dateformat(attributes.date_1,dateformat_style)#">
		</cfif>
		<cfif len(attributes.date_2)>
			<cfset url_str = "#url_str#&date_2=#dateformat(attributes.date_2,dateformat_style)#">
		</cfif>
		<cfif len(attributes.pay_date1)>
			<cfset url_str = "#url_str#&pay_date1=#dateformat(attributes.pay_date1,dateformat_style)#">
		</cfif>
		<cfif len(attributes.pay_date2)>
			<cfset url_str = "#url_str#&pay_date2=#dateformat(attributes.pay_date2,dateformat_style)#">
		</cfif>
		<cfif len(attributes.credit_card_info)>
			<cfset url_str = "#url_str#&credit_card_info=#attributes.credit_card_info#">
		</cfif>
		<cfif isDefined("attributes.check_payment_info")>
			<cfset url_str = "#url_str#&check_payment_info=#attributes.check_payment_info#">
		</cfif>
		<cfif len(attributes.company_id)>
			<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
		</cfif>
		<cfif len(attributes.bank_action_type)>
			<cfset url_str = "#url_str#&action_type=#attributes.bank_action_type#">
		</cfif>
		<cfif len(attributes.cons_id)>
			<cfset url_str = "#url_str#&cons_id=#attributes.cons_id#">
		</cfif>
		<cfif len(attributes.member_name)>
			<cfset url_str = "#url_str#&member_name=#attributes.member_name#">
		</cfif>
		<cfif len(attributes.installment_date1)>
			<cfset url_str = "#url_str#&installment_date1=#dateformat(attributes.installment_date1,dateformat_style)#">
		</cfif>
		<cfif len(attributes.installment_date2)>
			<cfset url_str = "#url_str#&installment_date2=#dateformat(attributes.installment_date2,dateformat_style)#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#url_str#">
		<form name="pop_gonder" method="post" action="">
			<div id="exp_info" style="display:none;"></div>
		</form>
	</cf_box>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		<cfif len(attributes.credit_card_info) or attributes.list_type eq 2 or isDefined("attributes.check_payment_info")>
			$("a.icon-pluss").css({"display" : "none"});
		</cfif>
	});

	function add_debit_payment(type)
	{
		document.getElementById('exp_info').innerHTML ='';
		var exp_count = 0;
		var _check_len_ = document.getElementsByName('_cc_expense_').length;
		var cc_expense_url = '&exp_row_count='+_check_len_+'';
		member_id_list_1='';
		member_id_list_2='';
		if(type ==1)
		{
			for(var _cl_ind_=0; _cl_ind_ < _check_len_; _cl_ind_++){
				if(document.getElementsByName('_cc_expense_')[_cl_ind_].checked && document.getElementsByName('_cc_expense_')[_cl_ind_].style.display != 'none')
				{//checkbox seçili ise..
					exp_count++;
					var amount = document.getElementsByName('_cc_expense_amount_')[_cl_ind_].value;
					var expense_row_id = document.getElementsByName('_cc_expense_')[_cl_ind_].value;
					var expense_type = document.getElementById('process_type_'+expense_row_id).value;
					var newInput = document.createElement("input"); newInput.type = 'text';	newInput.name = 'exp_amount'+exp_count+''; newInput.value=filterNum(amount);
					var newInput2 = document.createElement("input"); newInput2.type = 'text';	newInput2.name = 'exp_row_id'+exp_count+''; newInput2.value=expense_row_id;
					document.getElementById('exp_info').appendChild(newInput);
					document.getElementById('exp_info').appendChild(newInput2);
					if(expense_type == 246)
						member_id_list_1+=expense_row_id;
					else
						member_id_list_2+=expense_row_id;
				}
			}
			if(exp_count == 0)
			{
				alert("<cf_get_lang dictionary_id='48965.Seçim Yapmadınız'>!");
				return false;
			}
			if(member_id_list_1 != '' && member_id_list_2 != '')
			{
				alert("<cf_get_lang dictionary_id='48908.Kredi Kartı Ödeme ve İptal İşlemlerini Birlikte Seçemezsiniz !'>");
				return false;
			}
			if(member_id_list_1 != '') process_type = 248; else process_type = 244;
		}
		else
			process_type = 244;
		windowopen('','medium','cc_paym');
		pop_gonder.action='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_credit_card_expense&event=addDebit&x_interim_payments=#x_interim_payments#&process_type='+process_type+'&exp_count='+exp_count+'<cfif len(attributes.credit_card_info)>&cc_info=#ListGetAt(attributes.credit_card_info,3,';')#</cfif></cfoutput>';
		pop_gonder.target='cc_paym';
		pop_gonder.submit();
		//document.getElementById('debt_paym_button').disabled = true;
		return false;
	}
	function show_date_info(type)
	{
		if(type == 0)
		{
			if(document.list_credit_card_expense.list_type.value == 1)
				gizle(pay_date);
			else
				goster(pay_date);

			if(document.list_credit_card_expense.list_type.value == 1)
				gizle(installment_date);
			else
				goster(installment_date);
		}
		else
		{
			if(document.list_credit_card_expense.credit_card_info.value != '')
			{
				document.list_credit_card_expense.list_type.value = 2;
				gizle(type_list);
			}
			else
				goster(type_list);

			if(document.list_credit_card_expense.list_type.value == 1)
				gizle(pay_date);
			else
				goster(pay_date);

			if(document.list_credit_card_expense.list_type.value == 1)
				gizle(installment_date);
			else
				goster(installment_date);
		}
	}
	function select_all(main_checkbox,row_checkbox)
	{
		var check_len = document.getElementsByName(row_checkbox).length;
		for(var zz=0; zz<check_len; zz++)
		{
			if(document.getElementsByName(row_checkbox)[zz].checked == false)
			{
				document.getElementsByName(row_checkbox)[zz].checked = true;
			}
			else
			{
				document.getElementsByName(row_checkbox)[zz].checked = false;
			}
			
		}
	}
	function delete_return(row_id){
		<cfoutput>
		windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_cc_debit_payment&process_type=249&del=1&active_period=#session.ep.period_id#&row_id='+row_id,'medium');
		</cfoutput>
	}
</script>
<cfsetting showdebugoutput="yes"> 