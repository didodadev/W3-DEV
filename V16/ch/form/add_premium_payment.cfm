<cf_xml_page_edit fuseact="ch.form_add_premium_payment">
<cfparam name="attributes.action_date" default="#dateformat(now(),dateformat_style)#">
<cfquery name="GET_RATE" datasource="#DSN2#">
	SELECT STOPPAGE_RATE_ID,STOPPAGE_RATE,DETAIL FROM SETUP_STOPPAGE_RATES
</cfquery>
<cfquery name="GET_BANK_NAMES" datasource="#DSN#">
	SELECT BANK_ID, BANK_CODE, BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfparam name="attributes.account_bank_name" default="">
<cfparam name="attributes.iban_no" default="">
<cfset system_money_info = session.ep.money>
<cfinclude template="../../bank/query/get_accounts.cfm">
<cfset cons_count = 0>
<cf_catalystHeader>
<cfform name="add_premium_payment" method="post" action="#request.self#?fuseaction=ch.list_premium_payment&event=add">
	<input type="hidden" name="is_checked_value_by_single" id="is_checked_value_by_single" value="<cfoutput>#is_checked_value_by_single#</cfoutput>">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="dekont_process_id" id="dekont_process_id" value="<cfif isdefined("dekont_process_id")><cfoutput>#dekont_process_id#</cfoutput></cfif>">
    <input type="hidden" name="bank_order_process_id" id="bank_order_process_id" value="<cfif isdefined("bank_order_process_id")><cfoutput>#bank_order_process_id#</cfoutput></cfif>">
	<cf_basket_form id="add_law">
    	<div class="row">
        	<div class="col col-12 uniqueRow">
        		<div class="row formContent">
        			<div class="row" type="row">
        				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                        	<div class="form-group" id="item-camp_id">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='34.Kampanya'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                        <input type="hidden" name="camp_id" id="camp_id" value="<cfif isdefined("attributes.camp_id")><cfoutput>#attributes.camp_id#</cfoutput></cfif>">
                                        <input type="text" name="camp_name" id="camp_name" value="<cfif isdefined("attributes.camp_name")><cfoutput>#attributes.camp_name#</cfoutput></cfif>" readonly style="width:120px;">
                                    	<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns</cfoutput>&field_id=add_premium_payment.camp_id&field_name=add_premium_payment.camp_name','list');" title="<cf_get_lang_main no='34.Kampanya'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-action_date">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='467.İşlem Tarihi'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang_main no='494.İşlem Tarihi Giriniz'></cfsavecontent>
                                        <cfinput type="text" name="action_date" validate="#validate_style#" required="yes" message="#message#" value="#attributes.action_date#" maxlength="10" style="width:120px;">
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="action_date"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                        	<div class="form-group" id="item-stoppage_rate">
                            	<label class="col col-4 col-xs-12"><cf_get_lang no='63.Stopaj Oranı'></label>
                                <div class="col col-8 col-xs-12">
                                	<select name="stoppage_rate" id="stoppage_rate" style="width:200px;">
                                        <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfoutput query="get_rate">
                                            <option value="#stoppage_rate#;#stoppage_rate_id#" <cfif isdefined("attributes.stoppage_rate") and listlast(attributes.stoppage_rate,';') eq stoppage_rate_id>selected</cfif>>#stoppage_rate#-#detail#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-premium_type">
                            	<label class="col col-4 col-xs-12"><cf_get_lang no="205.Prim Tipi"></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="premium_type" id="premium_type" style="width:200px;">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <option value="1" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 1> selected</cfif>><cf_get_lang no="207.Teşvik Primi"></option>
                                        <option value="2" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 2> selected</cfif>><cf_get_lang no="208.Seviye Atlama Primi"></option>							
                                        <option value="3" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 3> selected</cfif>><cf_get_lang no="209.Nakit Ödül Programı Primi"></option>							
                                        <option value="4" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 4> selected</cfif>><cf_get_lang no="210.Direktör Geliştirme Programı Primi"></option>							
                                        <option value="5" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 5> selected</cfif>><cf_get_lang no="211.Yıldız Bonus Programı Primi"></option>							
                                        <option value="6" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 6> selected</cfif>><cf_get_lang no="212.Ünvan Bonus Programı Primi"></option>							
                                        <option value="7" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 7> selected</cfif>><cf_get_lang no="213.Direktör Bonus Programı Primi"></option>							
                                        <option value="8" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 8> selected</cfif>><cf_get_lang_main no="744.Diger"> <cf_get_lang no="209.Nakit Ödül Programı Primi"></option>							
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
                        	<div class="form-group" id="item-debt_value">
                            	<label class="col col-4 col-xs-12"><cf_get_lang no="206.Borç Limiti"></label>
                                <div class="col col-8 col-xs-12">
                                	<input type="text" name="debt_value" id="debt_value" style="width:60px;" class="moneybox" value="<cfif isdefined("attributes.debt_value")><cfoutput>#attributes.debt_value#</cfoutput><cfelse>0</cfif>" onkeyup="return(FormatCurrency(this,event));">
                                </div>
                            </div>
                            <div class="form-group" id="item-pay_value">
                            	<label class="col col-4 col-xs-12"><cf_get_lang no="214.Ödenecek Tutar Limiti"></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="pay_value" id="pay_value" style="width:60px;" class="moneybox" value="<cfif isdefined("attributes.pay_value")><cfoutput>#attributes.pay_value#</cfoutput><cfelse>0</cfif>" onkeyup="return(FormatCurrency(this,event));">
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="4">
                        	<div class="form-group" id="item-account_bank_name">
                            	<label class="col col-4 col-xs-12"><cf_get_lang_main no='109.Banka'></label>
                                <div class="col col-8 col-xs-12">
                                	<select name="account_bank_name" id="account_bank_name" style="width:120px;">
                                        <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                        <cfoutput query="get_bank_names">
                                            <option value="#bank_name#" <cfif attributes.account_bank_name eq bank_name>selected</cfif>>#bank_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-iban_no">
                            	<label class="col col-4 col-xs-12"><cf_get_lang no="222.Iban No"></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="iban_no" id="iban_no" style="width:120px;">
                                        <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                        <option value="0" <cfif attributes.iban_no eq 0>selected</cfif>><cf_get_lang_main no="2258.Olanlar"></option>
                                        <option value="1" <cfif attributes.iban_no eq 1>selected</cfif>><cf_get_lang_main no="2259.Olmayanlar"></option>
                                    </select>
                                </div>
                            </div>
                        </div>
        			</div>
                    <div class="row formContentFooter">
                    	<div class="col col-12 text-right">
                        	<label><input type="checkbox" name="is_control_invoice" id="is_control_invoice" value="" <cfif isdefined("attributes.is_control_invoice")> checked</cfif>><cf_get_lang no="202.Ödenmemiş Faturaları Kontrol Etme"></label>
							<cf_wrk_search_button button_type='1' search_function='kontrol1()' is_excel="0">
                        </div>
                    </div>
        		</div>
        	</div>
        </div>
	</cf_basket_form>
	<cfif isdefined("attributes.camp_id") and len(attributes.camp_name)>
		<cf_basket id="add_law_row">
		<cfset attributes.debt_value = filterNum(attributes.debt_value)>
		<cfquery name="get_startdate" datasource="#dsn3#">
			SELECT CAMP_STARTDATE FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">
		</cfquery>
		<cf_date tarih='attributes.action_date'>
		<cfquery name="GET_ALL_PREMIUM" datasource="#DSN2#">
			SELECT
				INV.INVOICE_MULTILEVEL_PREMIUM_ID,
				(INV.PREMIUM_SYSTEM_TOTAL - ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0)) AS PREMIUM_SYSTEM_TOTAL,
				INV.PREMIUM_DATE,
				INV.CAMPAIGN_ID,
				INV.CONSUMER_ID,
				INV.PREMIUM_LINE,
				INV.PREMIUM_RATE,
				INV.INVOICE_TOTAL,
				I.NETTOTAL,
				INV.INVOICE_ID,
				INV.PREMIUM_SYSTEM_MONEY,
				INV.CONSUMER_REFERENCE_CODE,
				INV.REF_CONSUMER_ID,
				I.INVOICE_CAT,
				1 AS KONTROL,
				(SELECT C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_ID = INV.CONSUMER_ID) CONS_NAME,
				ISNULL((SELECT SUM(IR.GROSSTOTAL) FROM INVOICE_ROW IR,#dsn3_alias#.PRODUCT P WHERE IR.INVOICE_ID = I.INVOICE_ID AND P.PRODUCT_ID = IR.PRODUCT_ID AND P.IS_INVENTORY = 0),0) INVENT_TOTAL,
				(SELECT SUM(IR.GROSSTOTAL) FROM INVOICE_ROW IR,#dsn3_alias#.PRODUCT P WHERE IR.INVOICE_ID = I.INVOICE_ID AND P.PRODUCT_ID = IR.PRODUCT_ID AND P.IS_INVENTORY = 1) OTHER_TOTAL,
				ISNULL((SELECT TOP 1 BG.BLOCK_GROUP_PERMISSIONS FROM #dsn_alias#.COMPANY_BLOCK_REQUEST CBL,#dsn_alias#.BLOCK_GROUP BG WHERE CBL.CONSUMER_ID= INV.CONSUMER_ID AND CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND CBL.BLOCK_START_DATE <= #now()# AND (CBL.BLOCK_FINISH_DATE IS NULL OR CBL.BLOCK_FINISH_DATE >= #now()#) ORDER BY CBL.BLOCK_START_DATE DESC),0) AS BLOCK_STATUS
			FROM
				INVOICE_MULTILEVEL_PREMIUM INV LEFT JOIN #dsn_alias#.CONSUMER_BANK CB ON CB.CONSUMER_ID = INV.CONSUMER_ID AND CB.CONSUMER_ACCOUNT_DEFAULT = 1,
				INVOICE I,
				CARI_ROWS CR
			WHERE
				INV.CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
				ROUND(PREMIUM_SYSTEM_TOTAL,2) <> ROUND(ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0),2) AND
				INV.INVOICE_ID = I.INVOICE_ID AND
				I.INVOICE_ID = CR.ACTION_ID AND
				I.INVOICE_CAT = CR.ACTION_TYPE_ID AND
				INV.PREMIUM_STATUS = 1 AND
				INV.REF_CONSUMER_ID IS NOT NULL AND
				INV.PREMIUM_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.premium_type#"> AND
				INV.CONSUMER_ID <> 1
				<cfif attributes.iban_no eq 0>
				AND CB.CONSUMER_IBAN_CODE IS NOT NULL
				<cfelseif attributes.iban_no eq 1>
				AND CB.CONSUMER_IBAN_CODE IS NULL
				</cfif>
				<cfif len(attributes.account_bank_name)>
				AND CB.CONSUMER_BANK = '#attributes.account_bank_name#'
				</cfif>
			
			UNION ALL
			
			SELECT
				INV.INVOICE_MULTILEVEL_PREMIUM_ID,
				ROUND((INV.PREMIUM_SYSTEM_TOTAL - ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0)),2) AS PREMIUM_SYSTEM_TOTAL,
				INV.PREMIUM_DATE,
				INV.CAMPAIGN_ID,
				INV.CONSUMER_ID,
				INV.PREMIUM_LINE,
				INV.PREMIUM_RATE,
				INV.INVOICE_TOTAL,
				I.NETTOTAL,
				INV.INVOICE_ID,
				INV.PREMIUM_SYSTEM_MONEY,
				INV.CONSUMER_REFERENCE_CODE,
				INV.REF_CONSUMER_ID,
				I.INVOICE_CAT,
				0 AS KONTROL,
				(SELECT C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_ID = INV.CONSUMER_ID) CONS_NAME,
				ISNULL((SELECT SUM(IR.GROSSTOTAL) FROM INVOICE_ROW IR,#dsn3_alias#.PRODUCT P WHERE IR.INVOICE_ID = I.INVOICE_ID AND P.PRODUCT_ID = IR.PRODUCT_ID AND P.IS_INVENTORY = 0),0) INVENT_TOTAL,
				(SELECT SUM(IR.GROSSTOTAL) FROM INVOICE_ROW IR,#dsn3_alias#.PRODUCT P WHERE IR.INVOICE_ID = I.INVOICE_ID AND P.PRODUCT_ID = IR.PRODUCT_ID AND P.IS_INVENTORY = 1) OTHER_TOTAL,
				ISNULL((SELECT TOP 1 BG.BLOCK_GROUP_PERMISSIONS FROM #dsn_alias#.COMPANY_BLOCK_REQUEST CBL,#dsn_alias#.BLOCK_GROUP BG WHERE CBL.CONSUMER_ID= INV.CONSUMER_ID AND CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND CBL.BLOCK_START_DATE <= #now()# AND (CBL.BLOCK_FINISH_DATE IS NULL OR CBL.BLOCK_FINISH_DATE >= #now()#) ORDER BY CBL.BLOCK_START_DATE DESC),0) AS BLOCK_STATUS
			FROM
				INVOICE_MULTILEVEL_PREMIUM INV LEFT JOIN #dsn_alias#.CONSUMER_BANK CB ON CB.CONSUMER_ID = INV.CONSUMER_ID AND CB.CONSUMER_ACCOUNT_DEFAULT = 1,
				INVOICE I,
				CARI_ROWS CR
			WHERE
				INV.CAMPAIGN_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
				INV.CAMPAIGN_ID IN(SELECT C.CAMP_ID FROM #dsn3_alias#.CAMPAIGNS C WHERE C.CAMP_STARTDATE < #createodbcdatetime(get_startdate.camp_startdate)#) AND
				ROUND(PREMIUM_SYSTEM_TOTAL,2) <> ROUND(ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0),2) AND INV.INVOICE_ID = I.INVOICE_ID AND
				I.INVOICE_ID = CR.ACTION_ID AND
				I.INVOICE_CAT = CR.ACTION_TYPE_ID AND
				INV.PREMIUM_STATUS = 1 AND
				INV.REF_CONSUMER_ID IS NOT NULL AND
				INV.PREMIUM_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.premium_type#"> AND
				INV.CONSUMER_ID <> 1
				<cfif attributes.iban_no eq 0>
				AND CB.CONSUMER_IBAN_CODE IS NOT NULL
				<cfelseif attributes.iban_no eq 1>
				AND CB.CONSUMER_IBAN_CODE IS NULL
				</cfif>
				<cfif len(attributes.account_bank_name)>
				AND CB.CONSUMER_BANK = '#attributes.account_bank_name#'
				</cfif>
			
			UNION ALL
			
			SELECT
				INV.INVOICE_MULTILEVEL_PREMIUM_ID,
				(INV.PREMIUM_SYSTEM_TOTAL - ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0)) AS PREMIUM_SYSTEM_TOTAL,
				INV.PREMIUM_DATE,
				INV.CAMPAIGN_ID,
				INV.CONSUMER_ID,
				INV.PREMIUM_LINE,
				INV.PREMIUM_RATE,
				INV.INVOICE_TOTAL,
				INV.INVOICE_TOTAL NETTOTAL,
				INV.INVOICE_ID,
				INV.PREMIUM_SYSTEM_MONEY,
				INV.CONSUMER_REFERENCE_CODE,
				INV.REF_CONSUMER_ID,
				0 INVOICE_CAT,
				1 AS KONTROL,
				(SELECT C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_ID = INV.CONSUMER_ID) CONS_NAME,
				0 INVENT_TOTAL,
				INV.INVOICE_TOTAL OTHER_TOTAL,
				ISNULL((SELECT TOP 1 BG.BLOCK_GROUP_PERMISSIONS FROM #dsn_alias#.COMPANY_BLOCK_REQUEST CBL,#dsn_alias#.BLOCK_GROUP BG WHERE CBL.CONSUMER_ID= INV.CONSUMER_ID AND CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND CBL.BLOCK_START_DATE <= #now()# AND (CBL.BLOCK_FINISH_DATE IS NULL OR CBL.BLOCK_FINISH_DATE >= #now()#) ORDER BY CBL.BLOCK_START_DATE DESC),0) AS BLOCK_STATUS
			FROM
				INVOICE_MULTILEVEL_PREMIUM INV LEFT JOIN #dsn_alias#.CONSUMER_BANK CB ON CB.CONSUMER_ID = INV.CONSUMER_ID AND CB.CONSUMER_ACCOUNT_DEFAULT = 1
			WHERE
				INV.CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
				INV.INVOICE_ID = 0 AND
				ROUND(PREMIUM_SYSTEM_TOTAL,2) <> ROUND(ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0),2) AND
				INV.PREMIUM_STATUS = 1 AND
				INV.PREMIUM_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.premium_type#"> AND
				INV.CONSUMER_ID <> 1
				<cfif attributes.iban_no eq 0>
				AND CB.CONSUMER_IBAN_CODE IS NOT NULL
				<cfelseif attributes.iban_no eq 1>
				AND CB.CONSUMER_IBAN_CODE IS NULL
				</cfif>
				<cfif len(attributes.account_bank_name)>
				AND CB.CONSUMER_BANK = '#attributes.account_bank_name#'
				</cfif>
				<cfif not isdefined("attributes.is_control_invoice")>
					AND INV.REF_CONSUMER_ID IS NOT NULL
				</cfif>
			
			UNION ALL
			
			SELECT
				INV.INVOICE_MULTILEVEL_PREMIUM_ID,
				ROUND((INV.PREMIUM_SYSTEM_TOTAL - ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0)),2) AS PREMIUM_SYSTEM_TOTAL,
				INV.PREMIUM_DATE,
				INV.CAMPAIGN_ID,
				INV.CONSUMER_ID,
				INV.PREMIUM_LINE,
				INV.PREMIUM_RATE,
				INV.INVOICE_TOTAL,
				INV.INVOICE_TOTAL NETTOTAL,
				INV.INVOICE_ID,
				INV.PREMIUM_SYSTEM_MONEY,
				INV.CONSUMER_REFERENCE_CODE,
				INV.REF_CONSUMER_ID,
				0 INVOICE_CAT,
				0 AS KONTROL,
				(SELECT C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER C WHERE C.CONSUMER_ID = INV.CONSUMER_ID) CONS_NAME,
				0 INVENT_TOTAL,
				INV.INVOICE_TOTAL OTHER_TOTAL,
				ISNULL((SELECT TOP 1 BG.BLOCK_GROUP_PERMISSIONS FROM #dsn_alias#.COMPANY_BLOCK_REQUEST CBL,#dsn_alias#.BLOCK_GROUP BG WHERE CBL.CONSUMER_ID= INV.CONSUMER_ID AND CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND CBL.BLOCK_START_DATE <= #now()# AND (CBL.BLOCK_FINISH_DATE IS NULL OR CBL.BLOCK_FINISH_DATE >= #now()#) ORDER BY CBL.BLOCK_START_DATE DESC),0) AS BLOCK_STATUS
			FROM
				INVOICE_MULTILEVEL_PREMIUM INV LEFT JOIN #dsn_alias#.CONSUMER_BANK CB ON CB.CONSUMER_ID = INV.CONSUMER_ID AND CB.CONSUMER_ACCOUNT_DEFAULT = 1
			WHERE
				INV.CAMPAIGN_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
				INV.INVOICE_ID = 0 AND
				INV.CAMPAIGN_ID IN(SELECT C.CAMP_ID FROM #dsn3_alias#.CAMPAIGNS C WHERE C.CAMP_STARTDATE < #createodbcdatetime(get_startdate.camp_startdate)#) AND
				ROUND(PREMIUM_SYSTEM_TOTAL,2) <> ROUND(ISNULL((SELECT SUM(IMP.PAY_AMOUNT+IMP.STOPPAGE_AMOUNT) FROM INVOICE_MULTILEVEL_PAYMENT_ROWS IMP WHERE IMP.INV_PREMIUM_ID = INV.INVOICE_MULTILEVEL_PREMIUM_ID),0),2) AND
				INV.PREMIUM_STATUS = 1 AND
				INV.REF_CONSUMER_ID IS NOT NULL AND
				INV.PREMIUM_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.premium_type#"> AND
				INV.CONSUMER_ID <> 1
				<cfif attributes.iban_no eq 0>
				AND CB.CONSUMER_IBAN_CODE IS NOT NULL
				<cfelseif attributes.iban_no eq 1>
				AND CB.CONSUMER_IBAN_CODE IS NULL
				</cfif>
				<cfif len(attributes.account_bank_name)>
				AND CB.CONSUMER_BANK = '#attributes.account_bank_name#'
				</cfif>
		</cfquery>
		<cfquery name="GET_ALL_CONSUMERS" dbtype="query">
			SELECT 
				DISTINCT CONSUMER_ID 
			FROM 
				GET_ALL_PREMIUM
			ORDER BY
				CONS_NAME
		</cfquery>
		<cfif get_all_consumers.recordcount>
			<cfset consumer_id_list = valuelist(get_all_consumers.consumer_id)>
			<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",',')>	
			<cfquery name="GET_CONS_NAME" datasource="#DSN#">
				SELECT
					CONSUMER_ID,
					MEMBER_CODE,
					CONSUMER_NAME,
					CONSUMER_SURNAME,
					MOBIL_CODE+''+MOBILTEL CONS_TEL,
					TC_IDENTY_NO,
					(SELECT CB.CONSUMER_IBAN_CODE FROM CONSUMER_BANK CB WHERE CONSUMER.CONSUMER_ID = CB.CONSUMER_ID AND CB.CONSUMER_ACCOUNT_DEFAULT =1) CONS_IBAN,
					CONSCAT,
					ISNULL(IS_TAXPAYER,0) IS_TAXPAYER,
					<!--- BK eski hali 20110113 (SELECT ROUND(SUM(BORC-ALACAK),2) FROM #dsn2_alias#.CARI_ROWS_CONSUMER CRC WHERE ((ACTION_TYPE_ID = 53 AND DUE_DATE < #attributes.action_date#) OR ACTION_TYPE_ID <> 53) AND CRC.CONSUMER_ID = CONSUMER.CONSUMER_ID) BAKIYE --->
					(SELECT ROUND(SUM(BORC-ALACAK),2) FROM #dsn2_alias#.CARI_ROWS_CONSUMER CRC WHERE ((ACTION_TYPE_ID IN(53,40) AND DUE_DATE < #attributes.action_date#) OR ACTION_TYPE_ID NOT IN(53,40)) AND CRC.CONSUMER_ID = CONSUMER.CONSUMER_ID) BAKIYE
				FROM
					CONSUMER,
					CONSUMER_CAT
				WHERE
					CONSUMER_CAT_ID = CONSCAT_ID AND
					CONSUMER_ID IN(#consumer_id_list#)
				ORDER BY
					CONSUMER_ID
			</cfquery>
			<cfset main_consumer_id_list = listsort(listdeleteduplicates(valuelist(get_cons_name.consumer_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfset block_consumer_id_list = ''>
		<cfoutput query="get_all_premium">
			<cfif kontrol eq 1>
				<cfif not isdefined("premium_total_#consumer_id#")>
					<cfset "premium_total_#consumer_id#" = premium_system_total>
				<cfelse>
					<cfset "premium_total_#consumer_id#" = evaluate("premium_total_#consumer_id#") + premium_system_total>
				</cfif>
				<cfif not isdefined("attributes.is_control_invoice")>
					<cfset gross_total = 0>
					<cfif invoice_id gt 0>
						<cfquery name="GET_OPEN_INVOICE" datasource="#DSN2#">
							SELECT 
								(ACTION_VALUE - ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CARI_CLOSED_ROW WHERE ACTION_ID = CARI_ROWS.ACTION_ID AND ACTION_TYPE_ID = CARI_ROWS.ACTION_TYPE_ID),0)) AS OPEN_VALUE
							FROM
								CARI_ROWS
							WHERE
								(CARI_ROWS.FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_consumer_id#"> OR CARI_ROWS.TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_consumer_id#">) AND
								(ACTION_VALUE - ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CARI_CLOSED_ROW WHERE ACTION_ID = CARI_ROWS.ACTION_ID AND ACTION_TYPE_ID = CARI_ROWS.ACTION_TYPE_ID),0) > 0) AND
								ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_id#"> AND
								ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_cat#"> AND
								DUE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date#">
						</cfquery>
					<cfelse>
						<cfquery name="GET_OPEN_INVOICE" datasource="#DSN2#">
							SELECT 
								(ACTION_VALUE - ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CARI_CLOSED_ROW WHERE ACTION_ID = CARI_ROWS.ACTION_ID AND ACTION_TYPE_ID = CARI_ROWS.ACTION_TYPE_ID AND CARI_ACTION_ID = CARI_ROWS.CARI_ACTION_ID),0)) AS OPEN_VALUE
							FROM
								CARI_ROWS
							WHERE
								(CARI_ROWS.FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_consumer_id#"> OR CARI_ROWS.TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_consumer_id#">) AND
								(ACTION_VALUE - ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CARI_CLOSED_ROW WHERE ACTION_ID = CARI_ROWS.ACTION_ID AND ACTION_TYPE_ID = CARI_ROWS.ACTION_TYPE_ID AND CARI_ACTION_ID = CARI_ROWS.CARI_ACTION_ID),0) > 0) AND
								ACTION_ID = -1 AND
								ACTION_TYPE_ID = 40 AND
								DUE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date#">
						</cfquery>
					</cfif>
					<cfif get_open_invoice.recordcount and invoice_total gt 0>
						<cfset gross_total = get_open_invoice.open_value>
					</cfif>
					<cfif invent_total neq 0 and gross_total neq 0 and gross_total eq get_all_premium.nettotal>
						<cfset gross_total = gross_total - invent_total>
					</cfif>
					<cfif get_open_invoice.recordcount>
						<cfif not isdefined("open_premium_total_#consumer_id#")>
							<cfset "open_premium_total_#consumer_id#" = wrk_round(gross_total * premium_rate / 100)>
						<cfelse>
							<cfset "open_premium_total_#consumer_id#" = evaluate("open_premium_total_#consumer_id#") +  wrk_round(gross_total * premium_rate / 100)>
						</cfif>
					</cfif>
				</cfif>
			<cfelse>
				<cfif not isdefined("premium_total_last_#consumer_id#")>
					<cfset "premium_total_last_#consumer_id#" = premium_system_total>
				<cfelse>
					<cfset "premium_total_last_#consumer_id#" = evaluate("premium_total_last_#consumer_id#") + premium_system_total>
				</cfif>
				<cfif not isdefined("attributes.is_control_invoice")>
					<cfset gross_total = 0>
					<cfif invoice_id gt 0>
						<cfquery name="GET_OPEN_INVOICE" datasource="#DSN2#">
							SELECT 
								(ACTION_VALUE - ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CARI_CLOSED_ROW WHERE ACTION_ID = CARI_ROWS.ACTION_ID AND ACTION_TYPE_ID = CARI_ROWS.ACTION_TYPE_ID),0)) AS OPEN_VALUE
							FROM
								CARI_ROWS
							WHERE
								(CARI_ROWS.FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_consumer_id#"> OR CARI_ROWS.TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_consumer_id#">) AND
								(ACTION_VALUE - ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CARI_CLOSED_ROW WHERE ACTION_ID = CARI_ROWS.ACTION_ID AND ACTION_TYPE_ID = CARI_ROWS.ACTION_TYPE_ID),0) > 0) AND
								ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_id#"> AND
								ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_cat#"> AND
								DUE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date#">
						</cfquery>
					<cfelse>
						<cfquery name="GET_OPEN_INVOICE" datasource="#DSN2#">
							SELECT 
								(ACTION_VALUE - ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CARI_CLOSED_ROW WHERE ACTION_ID = CARI_ROWS.ACTION_ID AND ACTION_TYPE_ID = CARI_ROWS.ACTION_TYPE_ID AND CARI_ACTION_ID = CARI_ROWS.CARI_ACTION_ID),0)) AS OPEN_VALUE
							FROM
								CARI_ROWS
							WHERE
								(CARI_ROWS.FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_consumer_id#"> OR CARI_ROWS.TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_consumer_id#">) AND
								(ACTION_VALUE - ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CARI_CLOSED_ROW WHERE ACTION_ID = CARI_ROWS.ACTION_ID AND ACTION_TYPE_ID = CARI_ROWS.ACTION_TYPE_ID AND CARI_ACTION_ID = CARI_ROWS.CARI_ACTION_ID),0) > 0) AND
								ACTION_ID = -1 AND
								ACTION_TYPE_ID = 40 AND 
								DUE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date#">
						</cfquery>
					</cfif>
					<cfif get_open_invoice.recordcount and invoice_total gt 0>
						<cfset gross_total = get_open_invoice.open_value>
					</cfif>
					<cfif invent_total neq 0 and gross_total neq 0 and gross_total eq get_all_premium.nettotal>
						<cfset gross_total = gross_total - invent_total>
					</cfif>
					<cfif get_open_invoice.recordcount>
						<cfif not isdefined("open_premium_total_last_#consumer_id#")>
							<cfset "open_premium_total_last_#consumer_id#" = gross_total * premium_rate / 100>
						<cfelse>
							<cfset "open_premium_total_last_#consumer_id#" = evaluate("open_premium_total_last_#consumer_id#") + gross_total * premium_rate / 100>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
			<cfif len(block_status) and block_status neq 0 and listgetat(block_status,3,',') eq 1>
				<cfif not listfind(block_consumer_id_list,get_all_premium.consumer_id)>
					<cfset block_consumer_id_list = listappend(block_consumer_id_list,get_all_premium.consumer_id)>
				</cfif>
			</cfif>
		</cfoutput>
        <cfset col_span = 4>
        <cfset cols_ = 9>
		<table class="detail_basket_list">
			<thead>
				<tr>
					<th width="20"><cf_get_lang_main no='75.No'></th>
					<th width="65"><cf_get_lang_main no='246.Uye'><cf_get_lang_main no='75.No'></th>
					<th width="120" nowrap="nowrap"><cf_get_lang_main no ='174.Bireysel Üye'></th>
					<cfif is_iban_tel eq 1>
						<cfset col_span=col_span+2>
						<cfset cols_=cols_+2>
						<th><cf_get_lang_main no='1595.IBAN Kodu'></th>
						<th><cf_get_lang_main no='1401.Cep Tel'></th>
					</cfif>
					<cfif is_tc_identity_no eq 1>
						<cfset ++col_span>
						<cfset ++cols_>
						<th><cf_get_lang_main no='613.TC Kimlik No'></th>
					</cfif>
					<th width="100" nowrap="nowrap"><cf_get_lang_main no ='1197.Üye Kategorisi'></th>
					<th style="text-align:right;"><cf_get_lang no='55.Hesaplanan Prim'></th>
					<cfif is_unpaid_sales_premium eq 1>
                    	<cfset ++cols_>
						<th style="text-align:right;"><cf_get_lang no='54.Ödenmemiş Satış Prim'></th>
					</cfif>
					<cfif is_deserved_premium eq 1>
                    	<cfset ++cols_>
						<th style="text-align:right;"><cf_get_lang no='53.Hakedilen Prim'></th>
					</cfif>
					<cfif is_past_unpaid_premium eq 1>
                    	<cfset ++cols_>
						<th style="text-align:right;"><cf_get_lang no='52.Geçmiş Dönem Hakedilen Prim'></th>
					</cfif>
					<cfif is_deserved_total_premium eq 1>
                    	<cfset ++cols_>
						<th style="text-align:right;"><cf_get_lang no='51.Toplam Hakedilen Prim'></th>
					</cfif>
					<th style="text-align:right;"><cf_get_lang_main no ='299.Stopaj'></th>
					<th style="text-align:right;"><cf_get_lang no='50.Net Ödenecek'></th>
					<th style="text-align:right;"><cf_get_lang_main no ='177.Bakiye'></th>
					<th width="1%" align="center"><cf_get_lang_main no="650.Dekont"><br><cfif get_all_consumers.recordcount><input type="checkbox" name="all_view" id="all_view" value="1" onclick="hepsi_view();" checked="checked"></cfif></th>
					<cfif is_checked_value_by_single eq 1>
                    	<cfset ++cols_>
						<th width="1%" align="center"><cf_get_lang_main no="109.Banka"> T.<br><cfif get_all_consumers.recordcount><input type="checkbox" name="all_view2" id="all_view2" value="1" onclick="hepsi_view2();" checked="checked"></cfif></th>
					</cfif>
				</tr>
			</thead>
			<cfscript>
				total_1 = 0;
				total_2 = 0;
				total_3 = 0;
				total_4 = 0;
				total_5 = 0;
				total_6 = 0;
				total_7 = 0;
				cons_count = 0;
			</cfscript>
			<cfif not len(attributes.debt_value)><cfset attributes.debt_value = 0></cfif>
			<cfif not len(attributes.pay_value)><cfset attributes.pay_value = 0></cfif>
			<tbody>
				<cfif get_all_consumers.recordcount>
					<cfoutput query="get_all_consumers">
							<cfset row_premium_total = 0>
							<cfset row_open_premium_total = 0>
							<cfset row_premium_total_last = 0>
							<cfset row_open_premium_total_last = 0>
							<tr>
								<cfif isdefined("premium_total_#consumer_id#")><cfset row_premium_total = evaluate("premium_total_#consumer_id#")></cfif>
								<cfif isdefined("open_premium_total_#consumer_id#")><cfset row_open_premium_total = evaluate("open_premium_total_#consumer_id#")></cfif>
								<cfif isdefined("premium_total_last_#consumer_id#")>
									<cfset row_premium_total_last = evaluate("premium_total_last_#consumer_id#")>
								</cfif>
								<cfif isdefined("open_premium_total_last_#consumer_id#")>
									<cfset row_open_premium_total_last = wrk_round(evaluate("open_premium_total_last_#consumer_id#"),2)>
								</cfif>
								<cfset premium_value_ = (row_premium_total-row_open_premium_total)+(row_premium_total_last-row_open_premium_total_last)>
								<cfif get_cons_name.is_taxpayer[listfind(main_consumer_id_list,consumer_id,',')] eq 0>
									<cfset stopaj_value = wrk_round(premium_value_- (listfirst(attributes.stoppage_rate,';')*premium_value_/100))>
								<cfelse>
									<cfset stopaj_value = premium_value_>
								</cfif>
								<cfif wrk_round(stopaj_value) eq 0 or get_cons_name.bakiye[listfind(main_consumer_id_list,consumer_id,',')] gt attributes.debt_value>
									<cfset color_info = 'FF0000'>
								<cfelseif (len(block_consumer_id_list) and listfind(block_consumer_id_list,consumer_id))>
									<cfset color_info = 'FF0000'>
								<cfelse>
									<cfset color_info = '000000'>
								</cfif>
								<td style=" color:#color_info#">#currentrow#</td>
								<td style=" color:#color_info#;text-align:right;">#get_cons_name.member_code[listfind(main_consumer_id_list,consumer_id,',')]#</td>
								<td style=" color:#color_info#"><a href="javascript:// " onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">#get_cons_name.consumer_name[listfind(main_consumer_id_list,consumer_id,',')]#&nbsp;#get_cons_name.consumer_surname[listfind(main_consumer_id_list,consumer_id,',')]#</a></td>
								<cfif is_iban_tel eq 1>
									<td style="color:#color_info#">#get_cons_name.cons_iban[listfind(main_consumer_id_list,consumer_id,',')]#</td>
									<td style="color:#color_info#">#get_cons_name.cons_tel[listfind(main_consumer_id_list,consumer_id,',')]#</td>
								</cfif>
								<cfif is_tc_identity_no eq 1>
									<td style=" color:#color_info#">#get_cons_name.tc_identy_no[listfind(main_consumer_id_list,consumer_id,',')]#</td>
								</cfif>
								<td style="color:#color_info#">#get_cons_name.conscat[listfind(main_consumer_id_list,consumer_id,',')]#</td>
								<td style="color:#color_info#;text-align:right;"><cfif isdefined("premium_total_#consumer_id#")>#tlformat(evaluate("premium_total_#consumer_id#"))#<cfset row_premium_total = wrk_round(evaluate("premium_total_#consumer_id#"),2)><cfelse>#tlformat(0)#</cfif> #session.ep.money#</td>
								<cfif is_unpaid_sales_premium eq 1>
									<td style="color:#color_info#;text-align:right;"><cfif isdefined("open_premium_total_#consumer_id#")>#tlformat(evaluate("open_premium_total_#consumer_id#"))#<cfset row_open_premium_total =  wrk_round(evaluate("open_premium_total_#consumer_id#"),2)><cfelse>#tlformat(0)#</cfif> #session.ep.money#</td>
								</cfif>
								<cfif is_deserved_premium eq 1>
									<td style="color:#color_info#;text-align:right;">#tlformat(row_premium_total-row_open_premium_total)# #session.ep.money#</td>
								</cfif>
								<cfif is_past_unpaid_premium eq 1>
									<td style="color:#color_info#;text-align:right;">#tlformat(row_premium_total_last-row_open_premium_total_last)# #session.ep.money#</td>
								</cfif>
								<cfif is_deserved_total_premium eq 1>
									<td style="color:#color_info#;text-align:right;">#tlformat((row_premium_total-row_open_premium_total)+(row_premium_total_last-row_open_premium_total_last))# #session.ep.money#</td>
								</cfif>
								<td style="color:#color_info#;text-align:right;">#tlformat(premium_value_-stopaj_value)#</td>
								<td style="color:#color_info#;text-align:right;">#tlformat(stopaj_value)#</td>
								<td style="color:#color_info#;text-align:right;" nowrap="nowrap">
									<cfif len(get_cons_name.bakiye[listfind(main_consumer_id_list,consumer_id,',')])>
										#tlformat(abs(get_cons_name.bakiye[listfind(main_consumer_id_list,consumer_id,',')]))#
										<cfif get_cons_name.bakiye[listfind(main_consumer_id_list,consumer_id,',')] gt 0>(B)<cfelse>(A)</cfif>
									<cfelse>
										#tlformat(0)#
									</cfif>
								</td>
								<td style=" color:#color_info#" align="center">
									<cfif (len(block_consumer_id_list) and listfind(block_consumer_id_list,consumer_id))>
										<cf_get_lang no="215.Bloklu Üye">
									<cfelseif get_cons_name.bakiye[listfind(main_consumer_id_list,consumer_id,',')] gt attributes.debt_value>
										<cf_get_lang no="22.Borçlu Üye">
									<cfelseif wrk_round(stopaj_value) gt attributes.pay_value>
										<cfif get_cons_name.is_taxpayer[listfind(main_consumer_id_list,consumer_id,',')] eq 0>
											<cfset cons_count = cons_count + 1>
											<input type="checkbox" name="checked_value" id="checked_value" value="#consumer_id#" checked onclick="check_kontrol(this);">
											<cfscript>
												total_1 = total_1 + row_premium_total;
												total_2 = total_2 + row_open_premium_total;
												total_3 = total_3 + row_premium_total-row_open_premium_total;
												total_4 = total_4 + row_premium_total_last-row_open_premium_total_last;
												total_5 = total_5 + (row_premium_total-row_open_premium_total)+(row_premium_total_last-row_open_premium_total_last);
												total_6 = total_6 + premium_value_-stopaj_value;
												total_7 = total_7 + stopaj_value;
											</cfscript>
										<cfelse>
											<cf_get_lang no="216.Vergi Mükellefi">
										</cfif>
									</cfif>
								</td>
								<cfif is_checked_value_by_single eq 1>
								<td align="center"><input type="checkbox" name="checked_value2" id="checked_value2" value="#consumer_id#" checked onclick="check_kontrol(this);"></td>
								</cfif>
							</tr>
					</cfoutput>
					<cfoutput>
						<tr class="color-row">
							<td colspan="#col_span#" class="txtbold" style="text-align:right;"><cf_get_lang_main no ='80.Toplam'></td>
							<td nowrap class="txtbold" style="text-align:right;">#tlformat(total_1)# #session.ep.money#</td>
                            <cfif is_unpaid_sales_premium eq 1>
								<td nowrap class="txtbold" style="text-align:right;">#tlformat(total_2)# #session.ep.money#</td>
                            </cfif>
                            <cfif is_deserved_premium eq 1>
								<td nowrap class="txtbold" style="text-align:right;">#tlformat(total_3)# #session.ep.money#</td>
                            </cfif>
                            <cfif is_past_unpaid_premium eq 1>
								<td nowrap class="txtbold" style="text-align:right;">#tlformat(total_4)# #session.ep.money#</td>
                           	</cfif>
                            <cfif is_deserved_total_premium eq 1>
								<td nowrap class="txtbold" style="text-align:right;">#tlformat(total_5)# #session.ep.money#</td>
                            </cfif>
							<td nowrap class="txtbold" style="text-align:right;">#tlformat(total_6)# #session.ep.money#</td>
							<td nowrap class="txtbold" style="text-align:right;">#tlformat(total_7)# #session.ep.money#</td>
							<td></td>
                            <td></td>
							<cfif is_checked_value_by_single eq 1>
								<td colspan="2"></td>
							</cfif>
						</tr>
					</cfoutput>
				<cfelse>
					<tr class="color-row" height="20">
						<td colspan="<cfoutput>#cols_#</cfoutput>"><cf_get_lang no='49.Prim Kaydı Bulunamadı'> !</td>
					</tr>
				</cfif>
			</tbody>
		</table>
		<cfif get_all_consumers.recordcount>
			<cf_basket_footer height="165">
                <div class="row">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12 sepetim_total_table_tutar_td">
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='388.İşlem Tipi'> *</label>
                            <div class="col col-8 col-xs-12"><cf_workcube_process_cat slct_width="220"></div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1652.Banka Hesabı'> *</label>
                            <div class="col col-8 col-xs-12">
                                <select name="form_account_id" id="form_account_id" style="width:220px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfoutput query="get_accounts">
                                        <option value="#account_id#;#account_currency_id#;#ListGetAt(session.ep.user_location,2,"-")#">#account_name#-#account_currency_id#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1048.Masraf Merkezi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input name="expense_center_id_2" id="expense_center_id_2" type="hidden" value="">
                                    <cfinput name="expense_center_2" type="text" value="" style="width:220px;" readonly>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=add_premium_payment.expense_center_2&field_id=add_premium_payment.expense_center_id_2&is_invoice=1</cfoutput>','list');" title="<cf_get_lang_main no='1048.Masraf Merkezi'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1139.Gider Kalemi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="expense_item_id_2" id="expense_item_id_2" value="">
                                    <cfinput type="text" name="expense_item_name_2" value="" style="width:220px;" readonly>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_premium_payment.expense_item_id_2&field_name=add_premium_payment.expense_item_name_2','list');" title="<cf_get_lang_main no='1139.Gider Kalemi'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='1439.Ödeme Tarihi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang no='174.Ödeme Tarihi Giriniz'></cfsavecontent>
                                    <cfinput type="text" name="payment_date" validate="#validate_style#" required="yes" message="#message#" value="#dateformat(now(),dateformat_style)#" maxlength="10" style="width:65px;">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="payment_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <div class="col col-12">
                        <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                    </div>
                </div>
			</cf_basket_footer>
		</cfif>
		</cf_basket>
	</cfif>
</cfform>
<script type="text/javascript">
	var control_checked=<cfoutput>#cons_count#</cfoutput>;
	function hepsi_view()
	{
		if(add_premium_payment.checked_value != undefined)
		{
			if(document.add_premium_payment.all_view.checked)
			{
				if (add_premium_payment.checked_value.length > 1)
					for(i=0; i<add_premium_payment.checked_value.length; i++) add_premium_payment.checked_value[i].checked = true;
				else
				{
					add_premium_payment.checked_value.checked = true;
					control_checked++;
				}
			}
			else
			{
				if (add_premium_payment.checked_value.length > 1)
					for(i=0; i<add_premium_payment.checked_value.length; i++) add_premium_payment.checked_value[i].checked = false;
				else
				{
					add_premium_payment.checked_value.checked = false;
					control_checked--;
				}
			}
		}
	}
	function hepsi_view2()
	{
		<cfif is_checked_value_by_single eq 1>
		if(add_premium_payment.checked_value2 != undefined)
		{
			if(document.add_premium_payment.all_view2.checked)
			{
				if (add_premium_payment.checked_value2.length > 1)
					for(i=0; i<add_premium_payment.checked_value2.length; i++) add_premium_payment.checked_value2[i].checked = true;
				else
				{
					add_premium_payment.checked_value2.checked = true;
					control_checked++;
				}
			}
			else
			{
				if (add_premium_payment.checked_value2.length > 1)
					for(i=0; i<add_premium_payment.checked_value2.length; i++) add_premium_payment.checked_value2[i].checked = false;
				else
				{
					add_premium_payment.checked_value2.checked = false;
					control_checked--;
				}
			}
		}
		</cfif>
	}
	function check_kontrol(nesne)
	{
		if(nesne.checked)
			control_checked++;
		else
			control_checked--;
	}
	function kontrol1()
	{
		if(document.add_premium_payment.camp_name.value == "")
		{
			alert("<cf_get_lang no ='48.Lütfen Kampanya Seçiniz'> !");
			return false;
		}
		if(document.add_premium_payment.premium_type.value == 0)
		{
			alert("<cf_get_lang no='221.Lütfen Prim Tipi Seçiniz'>!");
			return false;
		}
		else
			return true;
	}
	function kontrol()
	{
		if(control_checked > 0)
		{
			if(!chk_process_cat('add_premium_payment')) return false;
			if(!check_display_files('add_premium_payment')) return false;
			if(!chk_period(add_premium_payment.payment_date,'İşlem')) return false;
			if(add_premium_payment.form_account_id.value == '' && add_premium_payment.checked_value != undefined &&  add_premium_payment.checked_value > 1)
			{
				alert("<cf_get_lang no='47.Banka Hesabı Seçiniz'> !");
				return false;
			}
			if(add_premium_payment.expense_center_2.value == '')
			{
				alert("<cf_get_lang no='46.Masraf Merkezi Seçiniz'> !");
				return false;
			}
			if(add_premium_payment.expense_item_name_2.value == '')
			{
				alert("<cf_get_lang no='45.Gider Kalemi Seçiniz'> !");
				return false;
			}
			add_premium_payment.action='<cfoutput>#request.self#?fuseaction=ch.emptypopup_add_premium_payment</cfoutput>';
			add_premium_payment.submit();
			add_premium_payment.action='';
		}
		else
			return false;
	}
</script>
