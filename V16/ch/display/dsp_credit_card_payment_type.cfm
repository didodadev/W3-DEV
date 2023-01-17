<cf_get_lang_set module_name="ch"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_CREDIT" datasource="#dsn3#">
	SELECT 
		STORE_REPORT_DATE,
		ACTION_FROM_COMPANY_ID,
		CONSUMER_ID,
		ACTION_TO_ACCOUNT_ID,
		CARD_NO,
		SALES_CREDIT,
		OTHER_CASH_ACT_VALUE,
		OTHER_MONEY,
		ACTION_DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_PAR,
        UPDATE_EMP,
		UPDATE_DATE,
		UPDATE_EMP,
		ACTION_TYPE_ID,
        ISNULL(IS_VOID,0) AS IS_VOID,
        RELATION_CREDITCARD_PAYMENT_ID
	FROM 
		CREDIT_CARD_BANK_PAYMENTS 
	WHERE 
		CREDITCARD_PAYMENT_ID = #attributes.id#
</cfquery>
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID
	FROM
		ACCOUNT_CARD ACS
	WHERE
    	ACS.ACTION_TYPE = #GET_CREDIT.action_type_id#
		AND ACS.ACTION_ID = #attributes.id#
</cfquery>
<cfsavecontent variable="right_">
	<cfif GET_CREDIT.action_type_id eq 245><cf_get_lang dictionary_id='29552.Kredi Karti Tahsilat İptal'><cfelse><cf_get_lang dictionary_id='57836.Kredi Karti Tahsilat'></cfif>
</cfsavecontent>
<cfsavecontent variable="right_images">
	<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
        <li><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#GET_CREDIT.ACTION_TYPE_ID#</cfoutput>');"><i class="icon-fa fa-table" title="<cf_get_lang dictionary_id='59032.Muhasebe Hareketleri'>"></i></a></li>
    </cfif>
	<cfif GET_CREDIT.ACTION_TYPE_ID neq 245 and GET_CREDIT.is_void eq 0>
        <li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=bank.list_creditcard_revenue&event=add&is_list_company_extre=1&payment_id=#attributes.id#</cfoutput>','project');"><i class="icon-fa fa-minus" title="<cf_get_lang dictionary_id='58506.İptal'>"></i></a></li>
    </cfif>
</cfsavecontent>
<div class="col col-12 col-xs-12">
    <cf_box title="#right_#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" right_images="#right_images#">
        <cf_box_elements>
            <cfoutput>
                <div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57742.Tarih'></b></label>
                    <label class="col col-8 col-xs-12">: #dateformat(get_credit.store_report_date,dateformat_style)#</label>
                </div>
            </div>
                <div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57658.Üye'></b></label>
                    <label class="col col-8 col-xs-12">: 
                        <cfif len(get_credit.ACTION_FROM_COMPANY_ID)>
                            #get_par_info(get_credit.ACTION_FROM_COMPANY_ID,1,1,0)#
                            <cfset key_type = get_credit.ACTION_FROM_COMPANY_ID>
                        <cfelse>
                            #get_cons_info(get_credit.CONSUMER_ID,0,0)#
                            <cfset key_type = get_credit.CONSUMER_ID>
                        </cfif>
                    </label>
                </div>
            </div>
                <div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id="57652.Hesap"></b></label>
                    <label class="col col-8 col-xs-12">: 
                        <cfset account_id=get_credit.ACTION_TO_ACCOUNT_ID>
                        <cfinclude template="../query/get_action_account.cfm">
                        #get_action_account.ACCOUNT_NAME#
                    </label>
            	</div>
            </div>
                <div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id="58199.Kredi Kartı"></b></label>
                    <label class="col col-8 col-xs-12">: <cfif len(GET_CREDIT.CARD_NO)>
                            <!--- 
                                FA-09102013 kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
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
                                <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:GET_CREDIT.CARD_NO,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                                <cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
                            <cfelse>
                                <cfset content = '#mid(Decrypt(GET_CREDIT.CARD_NO,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(GET_CREDIT.CARD_NO,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(GET_CREDIT.CARD_NO,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(GET_CREDIT.CARD_NO,key_type,"CFMX_COMPAT","Hex")))#'>
                            </cfif>
                            #content#
                        </cfif>
                    </label>
                </div>
            </div>
                <div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57673.Tutar'></b></label>
                    <label class="col col-8 col-xs-12">: #TLFormat(get_credit.sales_credit)# #get_action_account.ACCOUNT_CURRENCY_ID#</label>
                </div>
            </div>
                <div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='58056.Dövizli Tutar'></b></label>
                    <label class="col col-8 col-xs-12">: #TLFormat(get_credit.other_cash_act_value)# #get_credit.other_money#</label>
                </div>
            </div>
                <div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57629.Açıklama'></b></label>
                    <label class="col col-8 col-xs-12">: #get_credit.ACTION_DETAIL#</label>
                </div>
            </div>
                <cfif GET_CREDIT.action_type_id eq 245 and len(get_credit.RELATION_CREDITCARD_PAYMENT_ID)>
                    <!--- belge ile iliskili tahsilat belgesi --->
                    <cfquery name="getRelationCreditCard" datasource="#dsn3#">
                        SELECT STORE_REPORT_DATE,PAPER_NO,CREDITCARD_PAYMENT_ID FROM CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID = #get_credit.RELATION_CREDITCARD_PAYMENT_ID#
                    </cfquery>
                   	<div class="col col-4 col-md-8 col-xs-12">
                        <div class="form-group">
                            <label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id="51295.İlişkili Tahsilat"></b></label>
                            <label class="col col-8 col-xs-12"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_credit_card_payment_type&id=#getRelationCreditCard.creditcard_payment_id#','small');" class="tableyazi"><cfif len(getRelationCreditCard.PAPER_NO)>#getRelationCreditCard.PAPER_NO#<cfelse>#getRelationCreditCard.CREDITCARD_PAYMENT_ID#</cfif></a> - #dateFormat(getRelationCreditCard.STORE_REPORT_DATE,dateformat_style)#</label>
                        </div>
                    </div>
                <cfelse>
                    <!--- belge ile iliskili iptal/iade belgeleri --->
                    <cfquery name="getRelationCreditCard" datasource="#dsn3#">
                        SELECT STORE_REPORT_DATE,PAPER_NO,CREDITCARD_PAYMENT_ID FROM CREDIT_CARD_BANK_PAYMENTS WHERE RELATION_CREDITCARD_PAYMENT_ID = #attributes.id#
                    </cfquery>
                    <cfif getRelationCreditCard.recordcount>
                        <div class="col col-4 col-md-8 col-xs-12">
                            <div class="form-group">
                                <label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id="51303.İlişkili İade/İptal"></b></label>                            
                                <cfloop query="getRelationCreditCard">
                                        <label class="col col-8 col-xs-12"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_credit_card_payment_type&id=#getRelationCreditCard.creditcard_payment_id#','small');" class="tableyazi"><cfif len(getRelationCreditCard.PAPER_NO)>#getRelationCreditCard.PAPER_NO#<cfelse>#getRelationCreditCard.CREDITCARD_PAYMENT_ID#</cfif></a> - #dateFormat(getRelationCreditCard.STORE_REPORT_DATE,dateformat_style)#</label>
                                </cfloop>
                            </div>
                        </div>
                    </cfif>
                </cfif>
            </cfoutput>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6 col-xs-12">
                <cf_record_info query_name="GET_CREDIT">                
            </div>
            <div class="col col-6 col-xs-12">
            </div>
        </cf_box_footer>
    </cf_box>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
