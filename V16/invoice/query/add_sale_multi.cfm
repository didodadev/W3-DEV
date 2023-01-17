<!--- is_from_webservice parametresi boomboss için kullanılan web servisten gönderiliyor kontrollere vs girmesin diye eklendi silmeyiniz --->
<cfif not isdefined("is_from_webservice") and form.active_period neq session.ep.period_id>
	<!--- 20050302 sadece donem kontrolu gereken yerlerde kullanilacak --->
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='29456.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı.Muhasebe Döneminizi Kontrol Ediniz!'>");
		window.location.href='<cfoutput>#request.self#?fuseaction=invoice.list_bill</cfoutput>';
	</script>
	<cfabort>
</cfif>

<cfif session.ep.add_invoice_multi eq 0>
	<cfscript>
		session.ep.add_invoice_multi = 1;
	</cfscript>
    
	<cfset form.sale_product = 1><!--- satış --->
    <cfinclude template="get_bill_process_cat.cfm">

    <cfif listfind('531,533',get_process_type.PROCESS_TYPE)>
        <cfset kdv_muaf_satis_faturasi = true>
    <cfelse>
        <cfset kdv_muaf_satis_faturasi = false>
    </cfif>
    <cfif len(inv_profile_id) and attributes.form_is_einvoice eq 2>
        <!---  dekont seçilmiş ancak e-faturalaı bir işlem kategorisi seçildi ise--->
        <script type="text/javascript">
            alert("Dekontta e-Faturalı İşlem Kategorisi Seçemezsiniz!");
            location.reload();
        </script>
        <cfabort>   
    </cfif>
    <cfinclude template="check_disc_accs.cfm">
    <cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
    <cflock name="#CreateUUID()#" timeout="60">
        <cftransaction>
            <cfquery name="ADD_INVOICE_MULTI" datasource="#dsn2#">
                INSERT INTO
                    INVOICE_MULTI
                    (
                        WRK_ID,
                        START_DATE,
                        FINISH_DATE,
                        INVOICE_DATE,
                        PROCESS_CAT,
                        DEPARTMENT_ID,
                        PAY_METHOD,
                        CARD_PAYMETHOD,
                        IS_GROUP_INVOICE,
                        IS_EINVOICE,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
                        #attributes.start_date#,
                        #attributes.finish_date#,
                        #attributes.invoice_date#,
                        #form.process_cat#,
                        #attributes.department_id#,
                        <cfif isDefined("is_group_inv") and ((isDefined("attributes.inv_payment_type_id") and len(attributes.inv_payment_type_id)) or (isDefined("attributes.inv_card_paymethod_id") and len(attributes.inv_card_paymethod_id)))>
                            <cfif len(attributes.inv_payment_type_id)>#attributes.inv_payment_type_id#,<cfelse>NULL,</cfif>
                            <cfif len(attributes.inv_card_paymethod_id)>#attributes.inv_card_paymethod_id#,<cfelse>NULL,</cfif>
                        <cfelse>
                            <cfif isDefined("attributes.payment_type_id") and len(attributes.payment_type_id)>#attributes.payment_type_id#,<cfelse>NULL,</cfif>
                            <cfif isDefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>#attributes.card_paymethod_id#,<cfelse>NULL,</cfif>
                        </cfif>
                        <cfif isDefined("is_group_inv")>1,<cfelse>0,</cfif>
                        <cfif isdefined("attributes.form_is_einvoice") and len(attributes.form_is_einvoice) and attributes.form_is_einvoice neq 2>#attributes.form_is_einvoice#<cfelse>NULL</cfif>,
                        #session.ep.userid#,
                        #now()#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    )
            </cfquery>
            <cfquery name="GET_INVOICE_MULTI" datasource="#dsn2#">
                SELECT MAX(INVOICE_MULTI_ID) AS MAX_ID FROM INVOICE_MULTI WHERE WRK_ID = '#wrk_id#'
            </cfquery>
        </cftransaction>
    </cflock>
    <!--- yuvarlama degerleri basketten alinir --->
    <cfquery name="get_round_num" datasource="#dsn2#">
        SELECT PRICE_ROUND_NUMBER,BASKET_TOTAL_ROUND_NUMBER FROM #dsn3_alias#.SETUP_BASKET WHERE BASKET_ID = 2
    </cfquery>
    <cfif get_round_num.recordcount and len(get_round_num.price_round_number)>
        <cfset round_num = get_round_num.price_round_number>
    <cfelse>
        <cfset round_num = 4>
    </cfif>
    <cfif get_round_num.recordcount and len(get_round_num.basket_total_round_number)>
        <cfset round_num_total = get_round_num.basket_total_round_number>
    <cfelse>
        <cfset round_num_total = 4>
    </cfif>
    <cfif isDefined("is_group_inv")><!--- Grup faturalama --->
        <cfinclude template="add_group_invoice.cfm">
    <cfelse><!--- Toplu faturalama --->
        <cfset pre_payment_date = "">
        <cfset pre_subs_id = "">
        <cfset pre_comp_id = "">
        <cfset pre_cons_id = "">
        <cfset pre_pay_type = "">
        <cfset pre_card_type = "">
        <cfset pre_money_type = "">
        <cfif attributes.xml_multi_invoice_row eq 1><!--- satirların gosterildiği durum --->
            <cfloop from="1" to="#attributes.all_records#" index="i">
                <cfset wrk_id = "#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*10000)##i#">
            	<cftry>
                    <cfif isdefined("attributes.payment_row#i#")>
                        <cfquery name="GET_BILLED_INFO" datasource="#dsn2#">
                            SELECT
                                SPR.SUBSCRIPTION_PAYMENT_ROW_ID,
                                SPR.PAYMENT_DATE,
                                SPR.SUBSCRIPTION_ID,
                                SPR.PAYMETHOD_ID,
                                SPR.CARD_PAYMETHOD_ID,
                                SPR.MONEY_TYPE,
                                SPR.STOCK_ID,
                                SPR.PRODUCT_ID,
                                SPR.UNIT_ID,
                                SPR.UNIT,
                                SPR.DETAIL,
                                SPR.DISCOUNT,
                                ISNULL(SPR.DISCOUNT_AMOUNT,0) DISCOUNT_AMOUNT,
                                SPR.BSMV_RATE,
                                SPR.BSMV_AMOUNT,
                                SPR.OIV_RATE,
                                SPR.OIV_AMOUNT,
                                <cfif kdv_muaf_satis_faturasi>0<cfelse>SPR.TEVKIFAT_RATE</cfif> AS TEVKIFAT_RATE,
                                <cfif kdv_muaf_satis_faturasi>0<cfelse>SPR.TEVKIFAT_AMOUNT</cfif> AS TEVKIFAT_AMOUNT,
                                SPR.AMOUNT,
                                SPR.QUANTITY,
                                SPR.ROW_TOTAL,
                                SPR.ROW_NET_TOTAL,
                                SPR.REASON_CODE,
                                SPR.ROW_DESCRIPTION,
                                PRODUCT_PERIOD.EXPENSE_CENTER_ID,
                                PRODUCT_PERIOD.INCOME_ITEM_ID,
                                PRODUCT_PERIOD.INCOME_ACTIVITY_TYPE_ID,
                                SC.CONSUMER_ID,
                                SC.PARTNER_ID,
                                SC.PROJECT_ID,
                                SC.COMPANY_ID,
                                SC.SUBSCRIPTION_NO,
                                SC.INVOICE_COMPANY_ID,
                                SC.INVOICE_PARTNER_ID,
                                SC.INVOICE_CONSUMER_ID,
                                SC.SALES_EMP_ID,
                                SC.SUBSCRIPTION_INVOICE_DETAIL,
                                SC.SALES_COMPANY_ID, 
                                SC.SALES_PARTNER_ID, 
                                SC.SALES_CONSUMER_ID, 
                                <cfif kdv_muaf_satis_faturasi>0<cfelse>S.TAX</cfif> AS TAX,
                                S.OTV,
                                S.PRODUCT_UNIT_ID,
                                S.IS_INVENTORY,
                                <cfif kdv_muaf_satis_faturasi>0<cfelse>ST.TAX</cfif> AS TAX,
                                ST.SALE_CODE,
								SC.INVOICE_ADDRESS,
								SC.INVOICE_ADDRESS_ID,
                                SCCOUNTRY.COUNTRY_NAME,
                                SCCITY.CITY_NAME,
                                SCCOUNTY.COUNTY_NAME,
								COMP.PROFILE_ID PROFILE_ID,
                                <cfif xml_other_money eq 1>
                                    SPR.MONEY_TYPE MONEY_TYPE_
                                <cfelseif xml_other_money eq 2>
                                    '#session.ep.money#' MONEY_TYPE_
                                <cfelseif xml_other_money eq 4>
                                    '#attributes.select_money_type#' MONEY_TYPE_
                                <cfelse>
                                    CASE WHEN SC.INVOICE_COMPANY_ID IS NOT NULL THEN
                                        (SELECT CC.MONEY FROM #dsn_alias#.COMPANY_CREDIT CC WHERE CC.COMPANY_ID = SC.INVOICE_COMPANY_ID AND CC.OUR_COMPANY_ID = #session.ep.company_id#)
                                    ELSE
                                        (SELECT CC.MONEY FROM #dsn_alias#.COMPANY_CREDIT CC WHERE CC.CONSUMER_ID = SC.INVOICE_CONSUMER_ID AND CC.OUR_COMPANY_ID = #session.ep.company_id#)
                                    END AS MONEY_TYPE_
                                </cfif>
                            FROM
                                #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR
                                RIGHT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
								LEFT JOIN #dsn_alias#.COMPANY COMP ON COMP.COMPANY_ID = SC.INVOICE_COMPANY_ID
                                LEFT JOIN #dsn#.SETUP_COUNTRY SCCOUNTRY ON SC.INVOICE_COUNTRY_ID = SCCOUNTRY.COUNTRY_ID
                                LEFT JOIN #dsn#.SETUP_COUNTY SCCOUNTY ON SC.INVOICE_COUNTY_ID = SCCOUNTY.COUNTY_ID
                                LEFT JOIN #dsn#.SETUP_CITY SCCITY ON SC.INVOICE_CITY_ID = SCCITY.CITY_ID
                                RIGHT JOIN #dsn3_alias#.STOCKS S ON SPR.PRODUCT_ID = S.PRODUCT_ID AND SPR.STOCK_ID = S.STOCK_ID
                                RIGHT JOIN SETUP_TAX ST ON ST.TAX = S.TAX
                                LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD ON PRODUCT_PERIOD.PRODUCT_ID = SPR.PRODUCT_ID AND PRODUCT_PERIOD.PERIOD_ID = #session.ep.period_id#
                            WHERE
                                SPR.SUBSCRIPTION_PAYMENT_ROW_ID = #evaluate("attributes.payment_row#i#")# AND
                                SPR.PAYMENT_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date# AND
                                SPR.IS_BILLED = 0 AND <!---faturalanmamıs--->
                                SPR.IS_ACTIVE = 1 AND<!--- aktif satırlar --->
                                SPR.IS_COLLECTED_INVOICE = 1 AND <!---toplu fat. dahil--->
                                SC.IS_ACTIVE = 1<!--- aktif olan abonelikler --->
                            <cfif isDefined("attributes.payment_type_id") and len(attributes.payment_type_id)>
                                AND SPR.PAYMETHOD_ID = #attributes.payment_type_id#
                            <cfelseif isDefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
                                AND SPR.CARD_PAYMETHOD_ID = #attributes.card_paymethod_id#
                            </cfif>
                        </cfquery>
                        <cfset i_2 = i+1>
                        <cfloop from="#i+1#" to="#attributes.all_records#" index="j">
                            <!--- disable arada bazıları seçilmemiş olabilir seçili satırı ve değerini bulmaya çalışıyoruz --->
                            <cfif isDefined("attributes.payment_row#j#")>
                                <cfset i_2 = j>
                                <cfbreak>
                            </cfif>
                        </cfloop>
                        <cfif isDefined("attributes.payment_row#i_2#")>
                            <cfquery name="GET_BILLED_INFO_2" datasource="#dsn2#">
                                SELECT
                                    SPR.SUBSCRIPTION_PAYMENT_ROW_ID,
                                    SPR.PAYMENT_DATE,
                                    SPR.SUBSCRIPTION_ID,
                                    SPR.PAYMETHOD_ID,
                                    SPR.CARD_PAYMETHOD_ID,
                                    SPR.MONEY_TYPE,
                                    SPR.STOCK_ID,
                                    SPR.PRODUCT_ID,
                                    SPR.UNIT_ID,
                                    SPR.UNIT,
                                    SPR.DETAIL,
                                    SPR.DISCOUNT,
                                    ISNULL(SPR.DISCOUNT_AMOUNT,0) DISCOUNT_AMOUNT,
                                    SPR.AMOUNT,
                                    SPR.QUANTITY,
                                    SPR.ROW_TOTAL,
                                    SPR.ROW_NET_TOTAL,
                                    SPR.BSMV_RATE,
                                    SPR.BSMV_AMOUNT,
                                    SPR.REASON_CODE,
                                    SPR.ROW_DESCRIPTION,
                                    PRODUCT_PERIOD.EXPENSE_CENTER_ID,
                                    PRODUCT_PERIOD.INCOME_ITEM_ID,
                                    PRODUCT_PERIOD.INCOME_ACTIVITY_TYPE_ID,
                                    SPR.OIV_RATE,
                                    SPR.OIV_AMOUNT,
                                    SPR.TEVKIFAT_RATE,
                                    SPR.TEVKIFAT_AMOUNT,
                                    SC.CONSUMER_ID,
                                    SC.PARTNER_ID,
                                    SC.PROJECT_ID,
                                    SC.COMPANY_ID,
                                    SC.SUBSCRIPTION_NO,
                                    SC.INVOICE_COMPANY_ID,
                                    SC.INVOICE_PARTNER_ID,
                                    SC.INVOICE_CONSUMER_ID,
                                    SC.SALES_EMP_ID,
                                    SC.SUBSCRIPTION_INVOICE_DETAIL,
									SC.INVOICE_ADDRESS,
									SC.INVOICE_ADDRESS_ID,
                                    SCCOUNTRY.COUNTRY_NAME,
                                    SCCITY.CITY_NAME,
                                    SCCOUNTY.COUNTY_NAME,
									COMP.PROFILE_ID PROFILE_ID,
                                    <cfif xml_other_money eq 1>
                                        SPR.MONEY_TYPE MONEY_TYPE_
                                    <cfelseif xml_other_money eq 2>
                                        '#session.ep.money#' MONEY_TYPE_
                                    <cfelseif xml_other_money eq 4>
                                        '#attributes.select_money_type#' MONEY_TYPE_
                                    <cfelse>
                                        CASE WHEN SC.INVOICE_COMPANY_ID IS NOT NULL THEN
                                            (SELECT CC.MONEY FROM #dsn_alias#.COMPANY_CREDIT CC WHERE CC.COMPANY_ID = SC.INVOICE_COMPANY_ID AND CC.OUR_COMPANY_ID = #session.ep.company_id#)
                                        ELSE
                                            (SELECT CC.MONEY FROM #dsn_alias#.COMPANY_CREDIT CC WHERE CC.CONSUMER_ID = SC.INVOICE_CONSUMER_ID AND CC.OUR_COMPANY_ID = #session.ep.company_id#)
                                        END AS MONEY_TYPE_
                                    </cfif>
                                FROM
                                    #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR
                                    RIGHT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
									LEFT JOIN #dsn_alias#.COMPANY COMP ON COMP.COMPANY_ID = SC.INVOICE_COMPANY_ID
                                    LEFT JOIN #dsn#.SETUP_COUNTRY SCCOUNTRY ON SC.INVOICE_COUNTRY_ID = SCCOUNTRY.COUNTRY_ID
                                    LEFT JOIN #dsn#.SETUP_COUNTY SCCOUNTY ON SC.INVOICE_COUNTY_ID = SCCOUNTY.COUNTY_ID
                                    LEFT JOIN #dsn#.SETUP_CITY SCCITY ON SC.INVOICE_CITY_ID = SCCITY.CITY_ID
                                    LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD ON PRODUCT_PERIOD.PRODUCT_ID = SPR.PRODUCT_ID  AND PRODUCT_PERIOD.PERIOD_ID = #session.ep.period_id#
                                WHERE
                                    SPR.SUBSCRIPTION_PAYMENT_ROW_ID = #evaluate("attributes.payment_row#i_2#")# AND
                                    SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
                            </cfquery>
                        <cfelse>
                            <cfset GET_BILLED_INFO_2.PAYMENT_DATE = "">
                            <cfset GET_BILLED_INFO_2.SUBSCRIPTION_ID = "">
                            <cfset GET_BILLED_INFO_2.PAYMETHOD_ID = "">
                            <cfset GET_BILLED_INFO_2.CARD_PAYMETHOD_ID = "">
                            <cfset GET_BILLED_INFO_2.MONEY_TYPE_ = "">
                            <cfset GET_BILLED_INFO_2.INVOICE_CONSUMER_ID = "">
                            <cfset GET_BILLED_INFO_2.INVOICE_COMPANY_ID = "">
                        </cfif>
                        <cfif GET_BILLED_INFO.recordcount>
                            <cfset kontrol_number = 0>                        
                            <cfif (GET_BILLED_INFO.PAYMENT_DATE neq pre_payment_date) or
                                (GET_BILLED_INFO.SUBSCRIPTION_ID neq pre_subs_id and attributes.multi_sale_grup eq 1) or
                                (GET_BILLED_INFO.INVOICE_COMPANY_ID neq pre_comp_id) or
                                (GET_BILLED_INFO.INVOICE_CONSUMER_ID neq pre_cons_id) or
                                (GET_BILLED_INFO.PAYMETHOD_ID neq pre_pay_type) or
                                (GET_BILLED_INFO.CARD_PAYMETHOD_ID neq pre_card_type) or
                                (GET_BILLED_INFO.MONEY_TYPE_ neq pre_money_type)>
                                                            
                                <cfif attributes.xml_paper_no_info><!--- standart belge numaralarından fatura no oluşturma xmli --->
                                    <cfif isdefined("attributes.form_is_einvoice") and attributes.form_is_einvoice eq 1>
                                        <cfset paper_type = 'E_INVOICE'>
                                    <cfelseif isdefined("attributes.form_is_einvoice") and attributes.form_is_einvoice eq 2>
                                        <cfset paper_type = 'RECEIPT'><!--- Dekont --->
                                    <cfelse>
                                        <cfset paper_type = 'INVOICE'>
                                    </cfif>
                                    <cfif paper_type eq 'RECEIPT'>
                                        <cfquery name="get_paper" datasource="#dsn2#">
                                            SELECT RECEIPT_NO,RECEIPT_NUMBER FROM #dsn3_alias#.GENERAL_PAPERS WHERE PAPER_TYPE IS NULL 
                                        </cfquery>
                                    <cfelse>
                                        <cfquery name="get_paper" datasource="#dsn2#">
                                            SELECT * FROM #dsn3_alias#.PAPERS_NO WHERE EMPLOYEE_ID = #session.ep.userid# ORDER BY PAPER_ID DESC 
                                        </cfquery>
                                        <cfif not len(evaluate('get_paper.#paper_type#_NO')) and not len(evaluate('get_paper.#paper_type#_NUMBER'))>
                                            <!--- irsaliye noları ile de gerekirse bir düzenleme yapılmalıdır.. --->
                                            <cfquery name="get_paper" datasource="#dsn2#">
                                                SELECT
                                                    *
                                                FROM
                                                    #dsn3_alias#.PAPERS_NO PN,
                                                    #dsn_alias#.SETUP_PRINTER_USERS SPU
                                                WHERE
                                                    PN.PRINTER_ID = SPU.PRINTER_ID AND
                                                    SPU.PRINTER_EMP_ID = #session.ep.userid#
                                                ORDER BY
                                                    PAPER_ID DESC 
                                            </cfquery>
                                            <cfset from_printer_info = get_paper.PRINTER_ID>
                                        </cfif>
                                    </cfif>
                                   
                                    <cfif len(evaluate('get_paper.#paper_type#_NO')) and len(evaluate('get_paper.#paper_type#_NUMBER'))>
                                        <cfset attributes.serial_number = "#evaluate('get_paper.#paper_type#_NO')#">
                                        <cfset attributes.serial_no = "#evaluate('get_paper.#paper_type#_NUMBER')+1#">
                                        <cfset attributes.invoice_number = "#evaluate('get_paper.#paper_type#_NO')#-#evaluate('get_paper.#paper_type#_NUMBER')+1#">
                                        <cfset paper_no_info = evaluate('get_paper.#paper_type#_NUMBER')+1>
                                    <cfelse>
                                        <cfset attributes.serial_number = "#GET_BILLED_INFO.SUBSCRIPTION_NO#">
                                        <cfset attributes.serial_no = "#GET_BILLED_INFO.SUBSCRIPTION_PAYMENT_ROW_ID+1#">
                                        <cfset attributes.invoice_number = "#GET_BILLED_INFO.SUBSCRIPTION_NO#-#GET_BILLED_INFO.SUBSCRIPTION_PAYMENT_ROW_ID+1#">
                                       
                                    </cfif>
                                <cfelse>
                                    <cfset attributes.serial_number = "#GET_BILLED_INFO.SUBSCRIPTION_NO#">
                                    <cfset attributes.serial_no = "#GET_BILLED_INFO.SUBSCRIPTION_PAYMENT_ROW_ID#">
                                    <cfset attributes.invoice_number = "#GET_BILLED_INFO.SUBSCRIPTION_NO#-#GET_BILLED_INFO.SUBSCRIPTION_PAYMENT_ROW_ID#">
                                </cfif>
                                <cfset kontrol_number = 1>
                            </cfif>
                            
                            <!--- Kontrolleri yapıyor --->
                            <!--- 20050302 buradaki dosya siralari performans ve oncelik dusunulerek duzenlendi bilgi disinda degistirmeyin --->
                            <cfquery name="GET_SALE" datasource="#dsn2#">
                                SELECT INVOICE_NUMBER,PURCHASE_SALES FROM INVOICE WHERE PURCHASE_SALES = 1 AND INVOICE_NUMBER='#attributes.invoice_number#'
                            </cfquery>
                            <cfif get_sale.recordcount and kontrol_number eq 1>
                                <cfsavecontent  variable="cc">
                                   <cfoutput> <cf_get_lang dictionary_id='57036.Girdiğiniz Fatura Numarası Kullanılıyor !'> : <cfoutput>#attributes.invoice_number# , Abone No : #GET_BILLED_INFO.SUBSCRIPTION_NO#</cfoutput>
                                   </cfoutput>
                                </cfsavecontent>
                                <script>
                                    alert('<cfoutput>#cc#</cfoutput>');
                                </script>
                                <cfabort>
                            <cfelse>
                                
                                <cfset paymethod_comp = createObject("component","cfc.paymethod_calc")>
                                <cflock name="#CreateUUID()#" timeout="20">
                                    <cftransaction>
                                       <cfinclude template="add_sale_multi_1.cfm">
                                        <!--- Fatura kayıt işlemlerini yapıyor --->
                                        <cfinclude template="add_sale_multi_2.cfm">		
                                        <!--- cari islemler ve muhasebe islemleri ekleniyor. --->
                                        <cfinclude template="add_sale_multi_3.cfm">
                                        <!--- ship eger irsaliyeli fatura ise irsaliye guncelleme ve eklemelerini yapiyor.--->
                                        <cfinclude template="add_sale_multi_4.cfm">                                        
                                        <cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
                                            UPDATE
                                                #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
                                            SET
                                                IS_BILLED = 1,
                                                INVOICE_ID = #GET_INVOICE_ID.MAX_ID#,
                                                PERIOD_ID = #session.ep.period_id#,
                                                INVOICE_DATE = #attributes.invoice_date#,
                                                UPDATE_DATE = #now()#,
                                                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                                UPDATE_EMP = #session.ep.userid#
                                            WHERE
                                                SUBSCRIPTION_PAYMENT_ROW_ID = #evaluate("attributes.payment_row#i#")#
                                        </cfquery>
                                        <cfset pre_payment_date = GET_BILLED_INFO.PAYMENT_DATE>
                                        <cfset pre_subs_id = GET_BILLED_INFO.SUBSCRIPTION_ID>
                                        <cfset pre_pay_type = GET_BILLED_INFO.PAYMETHOD_ID>
                                        <cfset pre_card_type = GET_BILLED_INFO.CARD_PAYMETHOD_ID>
                                        <cfset pre_money_type = GET_BILLED_INFO.MONEY_TYPE_>
                                        <cfset pre_comp_id = GET_BILLED_INFO.INVOICE_COMPANY_ID>
                                        <cfset pre_cons_id = GET_BILLED_INFO.INVOICE_CONSUMER_ID>
                                        <cfif attributes.xml_paper_no_info and isDefined("paper_no_info")><!--- standart belge numaralarından fatura no oluşturma xml i --->
                                            <cfif isdefined("attributes.form_is_einvoice") and attributes.form_is_einvoice eq 2>
                                                <!--- dekont ise genel belge numaralarından güncelle --->
                                                <cfquery name="UPD_PAPERS" datasource="#dsn2#">
                                                    UPDATE 
                                                        #dsn3_alias#.GENERAL_PAPERS
                                                    SET 
                                                        #paper_type#_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_no_info#">
                                                    WHERE
                                                        PAPER_TYPE IS NULL
                                                </cfquery>
                                            <cfelse>
                                                <cfquery name="UPD_PAPERS" datasource="#dsn2#">
                                                    UPDATE 
                                                        #dsn3_alias#.PAPERS_NO 
                                                    SET 
                                                        #paper_type#_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_no_info#">
                                                    WHERE
                                                    <cfif isdefined('from_printer_info') and len(from_printer_info)>
                                                        PRINTER_ID = #from_printer_info#
                                                    <cfelse>
                                                        EMPLOYEE_ID = #session.ep.userid#
                                                    </cfif>
                                                </cfquery>
                                            </cfif>
                                        </cfif>
                                        <cfif kontrol_number eq 1>
                                            <cfoutput>#i#-#GET_BILLED_INFO.SUBSCRIPTION_NO# Abone İçin #attributes.invoice_number# Fatura Oluşturulmuştur!</cfoutput><br/>
                                        </cfif>
                                        <!--- action file --->
                                        <cf_workcube_process_cat 
                                            process_cat="#form.process_cat#"
                                            action_id = #GET_INVOICE_ID.MAX_ID#
                                            is_action_file = 1
                                            action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_invoice_sale&iid=#get_invoice_id.max_id#'
                                            action_file_name='#get_process_type.action_file_name#'
                                            action_db_type = '#dsn2#'
                                            is_template_action_file = '#get_process_type.action_file_from_template#'>
                                           
                                    </cftransaction>
                                </cflock>
                            </cfif>
                        </cfif>
                    </cfif>
                   
                 <cfcatch>
                        <cfif isDefined('GET_BILLED_INFO') and isQuery(GET_BILLED_INFO)>
                            <cfoutput>#GET_BILLED_INFO.SUBSCRIPTION_NO# Nolu Abone nin #dateFormat(GET_BILLED_INFO.PAYMENT_DATE,dateformat_style)# Tarihli Ödeme Planına Fatura Oluşturulamamıştır!<br/></cfoutput>
                        </cfif>
                    </cfcatch>
                </cftry> 
            </cfloop>
        <cfelse><!--- satırlar gosterilmeden yapılan kayıtlar --->
            <cfquery name="GET_BILLED_INFO" datasource="#dsn2#" maxrows="10000">
                SELECT
                    SPR.SUBSCRIPTION_PAYMENT_ROW_ID,
                    SPR.PAYMENT_DATE,
                    SPR.SUBSCRIPTION_ID,
                    SPR.PAYMETHOD_ID,
                    SPR.CARD_PAYMETHOD_ID,
                    SPR.MONEY_TYPE,
                    SPR.STOCK_ID,
                    SPR.PRODUCT_ID,
                    SPR.UNIT_ID,
                    SPR.UNIT,
                    SPR.DETAIL,
                    SPR.DISCOUNT,
                    ISNULL(SPR.DISCOUNT_AMOUNT,0) DISCOUNT_AMOUNT,
                    SPR.BSMV_RATE,
                    SPR.BSMV_AMOUNT,
                    SPR.OIV_RATE,
                    SPR.OIV_AMOUNT,
                    <cfif kdv_muaf_satis_faturasi>0<cfelse>SPR.TEVKIFAT_RATE</cfif> AS TEVKIFAT_RATE,
                    <cfif kdv_muaf_satis_faturasi>0<cfelse>SPR.TEVKIFAT_AMOUNT</cfif> AS TEVKIFAT_AMOUNT,
                    SPR.AMOUNT,
                    SPR.QUANTITY,
                    SPR.ROW_TOTAL,
                    SPR.ROW_NET_TOTAL,
                    SPR.REASON_CODE,
                    SPR.ROW_DESCRIPTION,
                    PRODUCT_PERIOD.EXPENSE_CENTER_ID,
                    PRODUCT_PERIOD.INCOME_ITEM_ID,
                    PRODUCT_PERIOD.INCOME_ACTIVITY_TYPE_ID,
                    SC.CONSUMER_ID,
                    SC.PARTNER_ID,
                    SC.PROJECT_ID,
                    SC.COMPANY_ID,
                    SC.SUBSCRIPTION_NO,
                    SC.INVOICE_COMPANY_ID,
                    SC.INVOICE_PARTNER_ID,
                    SC.INVOICE_CONSUMER_ID,
                    SC.SALES_EMP_ID,
                    SC.SUBSCRIPTION_INVOICE_DETAIL,
                    SC.SALES_COMPANY_ID, 
                    SC.SALES_PARTNER_ID, 
                    SC.SALES_CONSUMER_ID, 
                    <cfif kdv_muaf_satis_faturasi>0<cfelse>S.TAX</cfif> AS TAX,
                    S.OTV,
                    S.PRODUCT_UNIT_ID,
                    S.IS_INVENTORY,
                    <cfif kdv_muaf_satis_faturasi>0<cfelse>ST.TAX</cfif> AS TAX,
                    ST.SALE_CODE,
                    SC.INVOICE_ADDRESS,
                    SC.INVOICE_ADDRESS_ID,
                    SCCOUNTRY.COUNTRY_NAME,
                    SCCITY.CITY_NAME,
                    SCCOUNTY.COUNTY_NAME,
                    C.PROFILE_ID PROFILE_ID,
                    CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS PARTNER_NAME,
                    C.FULLNAME,
                    CONS.CONSUMER_NAME +' '+ CONS.CONSUMER_SURNAME AS CONS_NAME,
                    <cfif xml_other_money eq 1>
                        SPR.MONEY_TYPE MONEY_TYPE_
                    <cfelseif xml_other_money eq 2>
                        '#session.ep.money#' MONEY_TYPE_
                    <cfelseif xml_other_money eq 4>
                        '#attributes.select_money_type#' MONEY_TYPE_
                    <cfelse>
                        CASE WHEN SC.INVOICE_COMPANY_ID IS NOT NULL THEN
                            (SELECT CC.MONEY FROM #dsn_alias#.COMPANY_CREDIT CC WHERE CC.COMPANY_ID = SC.INVOICE_COMPANY_ID AND CC.OUR_COMPANY_ID = #session.ep.company_id#)
                        ELSE
                            (SELECT CC.MONEY FROM #dsn_alias#.COMPANY_CREDIT CC WHERE CC.CONSUMER_ID = SC.INVOICE_CONSUMER_ID AND CC.OUR_COMPANY_ID = #session.ep.company_id#)
                        END AS MONEY_TYPE_
                    </cfif>
                FROM
                    #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR
                    RIGHT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON SPR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
                    RIGHT JOIN #dsn3_alias#.STOCKS S ON SPR.PRODUCT_ID = S.PRODUCT_ID AND SPR.STOCK_ID = S.STOCK_ID
                    RIGHT JOIN SETUP_TAX ST ON ST.TAX = S.TAX
                    LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON CP.PARTNER_ID = SC.PARTNER_ID
                    LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = SC.INVOICE_COMPANY_ID
                    LEFT JOIN #dsn_alias#.CONSUMER CONS ON CONS.CONSUMER_ID = SC.INVOICE_CONSUMER_ID
                    LEFT JOIN #dsn#.SETUP_COUNTRY SCCOUNTRY ON SC.INVOICE_COUNTRY_ID = SCCOUNTRY.COUNTRY_ID
                    LEFT JOIN #dsn#.SETUP_COUNTY SCCOUNTY ON SC.INVOICE_COUNTY_ID = SCCOUNTY.COUNTY_ID
                    LEFT JOIN #dsn#.SETUP_CITY SCCITY ON SC.INVOICE_CITY_ID = SCCITY.CITY_ID
                    LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD ON PRODUCT_PERIOD.PRODUCT_ID = SPR.PRODUCT_ID AND PRODUCT_PERIOD.PERIOD_ID = #session.ep.period_id#
                WHERE
                    SPR.PAYMENT_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date# AND
                    SPR.IS_BILLED = 0 AND <!---faturalanmamıs--->
                    SPR.IS_ACTIVE = 1 AND<!--- aktif satırlar --->
                    SPR.IS_COLLECTED_INVOICE = 1 AND <!---toplu fat. dahil--->
                    SC.IS_ACTIVE = 1<!--- aktif olan abonelikler --->
                <cfif isDefined("attributes.member_type") and attributes.member_type eq 1>
                    AND SC.INVOICE_COMPANY_ID IS NOT NULL
                <cfelseif isDefined("attributes.member_type") and attributes.member_type eq 2>
                    AND SC.INVOICE_CONSUMER_ID IS NOT NULL 
                </cfif>
                <cfif isDefined("attributes.payment_type_id") and len(attributes.payment_type_id)>
                    AND SPR.PAYMETHOD_ID = #attributes.payment_type_id#
                <cfelseif isDefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
                    AND SPR.CARD_PAYMETHOD_ID = #attributes.card_paymethod_id#
                </cfif>
				<cfif session.ep.our_company_info.is_efatura>
					<cfif isdefined("attributes.form_is_einvoice") and attributes.form_is_einvoice eq 1>
						AND
						( 
							(C.USE_EFATURA = 1 AND C.EFATURA_DATE <= #attributes.invoice_date#) OR (CONS.USE_EFATURA = 1 AND CONS.EFATURA_DATE <= #attributes.invoice_date#)
						)
					<cfelseif isdefined("attributes.form_is_einvoice") and attributes.form_is_einvoice eq 0>
						AND
						( 
							(C.USE_EFATURA = 0 OR CONS.USE_EFATURA = 0 OR C.EFATURA_DATE > #attributes.invoice_date# OR CONS.EFATURA_DATE > #attributes.invoice_date#)
						)
					</cfif>
				</cfif>
                    AND SPR.AMOUNT > 0
                    AND SPR.QUANTITY > 0
                ORDER BY<!--- order by sırası değişmemeli cunku actionda çok satırlı işlemler buna göre değişiyor AE20060628 --->
                <cfif isDefined("is_group_inv")>
                    SC.INVOICE_CONSUMER_ID,
                    SC.INVOICE_PARTNER_ID,
                    SC.INVOICE_COMPANY_ID,
                    <cfif(isdefined("attributes.multi_sale_grup") and attributes.multi_sale_grup eq 1)>
                    SC.SUBSCRIPTION_ID,
                    </cfif>
                    SPR.STOCK_ID,
                    SPR.UNIT_ID,
                    SPR.DETAIL,
                    SPR.MONEY_TYPE,
                    SPR.DISCOUNT
                    <cfif isDefined("is_avg_price")>
                        ,SPR.AMOUNT
                    </cfif>
                <cfelse>
                    <cfif isdefined("xml_sortby_subscription_no") and xml_sortby_subscription_no>
                        SC.SUBSCRIPTION_NO,
                    </cfif>
                    SC.INVOICE_CONSUMER_ID,
                    SC.INVOICE_PARTNER_ID,
                    SC.INVOICE_COMPANY_ID,
                    <cfif(isdefined("attributes.multi_sale_grup") and attributes.multi_sale_grup eq 1)>
                        SC.SUBSCRIPTION_ID,
                    </cfif>
                    SPR.SUBSCRIPTION_ID,
                    SPR.PAYMENT_DATE,
                    SPR.PAYMETHOD_ID,
                    SPR.CARD_PAYMETHOD_ID,
                    SPR.MONEY_TYPE
                </cfif>
            </cfquery>
			<cfset catch_kontrol = 0>
            <cfloop query="GET_BILLED_INFO">
                <cfset i = currentrow>
                <cfif len(GET_BILLED_INFO.consumer_id)>
                    <cfset "attributes.subs_name#i#" = GET_BILLED_INFO.CONS_NAME[currentrow]>
                <cfelse>
                    <cfset "attributes.subs_name#i#" = GET_BILLED_INFO.FULLNAME[currentrow]>
                </cfif>
                <cfset wrk_id = "#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*10000)##GET_BILLED_INFO.CURRENTROW#">
               <cftry>
                    <cfif len(GET_BILLED_INFO.SUBSCRIPTION_PAYMENT_ROW_ID[currentrow+1])>
                        <cfquery name="GET_BILLED_INFO_2" dbtype="query">
                            SELECT * FROM GET_BILLED_INFO WHERE SUBSCRIPTION_PAYMENT_ROW_ID = #GET_BILLED_INFO.SUBSCRIPTION_PAYMENT_ROW_ID[currentrow+1]#
                        </cfquery>
                    <cfelse>
                        <cfset GET_BILLED_INFO_2.PAYMENT_DATE = "">
                        <cfset GET_BILLED_INFO_2.SUBSCRIPTION_ID = "">
                        <cfset GET_BILLED_INFO_2.PAYMETHOD_ID = "">
                        <cfset GET_BILLED_INFO_2.CARD_PAYMETHOD_ID = "">
                        <cfset GET_BILLED_INFO_2.MONEY_TYPE = "">
                        <cfset GET_BILLED_INFO_2.INVOICE_CONSUMER_ID = "">
                        <cfset GET_BILLED_INFO_2.INVOICE_COMPANY_ID = "">
                    </cfif>

                    <cfif GET_BILLED_INFO.recordcount>
                        <cfset kontrol_number = 0>
                        <cfif (GET_BILLED_INFO.PAYMENT_DATE neq pre_payment_date) or
                            (GET_BILLED_INFO.SUBSCRIPTION_ID neq pre_subs_id and attributes.multi_sale_grup eq 1) or
                            (GET_BILLED_INFO.INVOICE_COMPANY_ID neq pre_comp_id) or
                            (GET_BILLED_INFO.INVOICE_CONSUMER_ID neq pre_cons_id) or
                            (GET_BILLED_INFO.PAYMETHOD_ID neq pre_pay_type) or
                            (GET_BILLED_INFO.CARD_PAYMETHOD_ID neq pre_card_type) or
                            (GET_BILLED_INFO.MONEY_TYPE neq pre_money_type)>
                            
                            <cfif attributes.xml_paper_no_info><!--- standart belge numaralarından fatura no oluşturma xmli --->
                                <cfif isdefined("attributes.form_is_einvoice") and attributes.form_is_einvoice eq 1>
                                    <cfset paper_type = 'E_INVOICE'>
                                <cfelseif isdefined("attributes.form_is_einvoice") and attributes.form_is_einvoice eq 2>
                                    <cfset paper_type = 'RECEIPT'><!--- Dekont --->
                                <cfelse>
                                    <cfset paper_type = 'INVOICE'>
                                </cfif>
                                <cfif paper_type eq 'RECEIPT'>
                                    <cfquery name="get_paper" datasource="#dsn2#">
                                        SELECT RECEIPT_NO,RECEIPT_NUMBER FROM #dsn3_alias#.GENERAL_PAPERS WHERE PAPER_TYPE IS NULL 
                                    </cfquery>
                                <cfelse>
                                    <cfquery name="get_paper" datasource="#dsn2#">
                                        SELECT * FROM #dsn3_alias#.PAPERS_NO WHERE EMPLOYEE_ID = #session.ep.userid# ORDER BY PAPER_ID DESC 
                                    </cfquery>
                                    <cfif not len(evaluate('get_paper.#paper_type#_NO')) and not len(evaluate('get_paper.#paper_type#_NUMBER'))>
                                        <!--- irsaliye noları ile de gerekirse bir düzenleme yapılmalıdır.. --->
                                        <cfquery name="get_paper" datasource="#dsn2#">
                                            SELECT
                                                *
                                            FROM
                                                #dsn3_alias#.PAPERS_NO PN,
                                                #dsn_alias#.SETUP_PRINTER_USERS SPU
                                            WHERE
                                                PN.PRINTER_ID = SPU.PRINTER_ID AND
                                                SPU.PRINTER_EMP_ID = #session.ep.userid#
                                            ORDER BY
                                                PAPER_ID DESC 
                                        </cfquery>
                                        <cfset from_printer_info = get_paper.PRINTER_ID>
                                    </cfif>
                                </cfif>
                                <cfif len(evaluate('get_paper.#paper_type#_NO')) and len(evaluate('get_paper.#paper_type#_NUMBER'))>
                                    <cfset attributes.serial_number = "#evaluate('get_paper.#paper_type#_NO')#">
                                    <cfset attributes.serial_no = "#evaluate('get_paper.#paper_type#_NUMBER')+1#">
                                    <cfset attributes.invoice_number = "#evaluate('get_paper.#paper_type#_NO')#-#evaluate('get_paper.#paper_type#_NUMBER')+1#">
                                    <cfset paper_no_info = evaluate('get_paper.#paper_type#_NUMBER')+1>
                                <cfelse>
                                    <cfset attributes.serial_number = "#GET_BILLED_INFO.SUBSCRIPTION_NO#">
                                    <cfset attributes.serial_no = "#GET_BILLED_INFO.SUBSCRIPTION_PAYMENT_ROW_ID#">
                                    <cfset attributes.invoice_number = "#GET_BILLED_INFO.SUBSCRIPTION_NO#-#GET_BILLED_INFO.SUBSCRIPTION_PAYMENT_ROW_ID#">
                                </cfif>
                            <cfelse>
                                <cfset attributes.serial_number = "#GET_BILLED_INFO.SUBSCRIPTION_NO#">
                                <cfset attributes.serial_no = "#GET_BILLED_INFO.SUBSCRIPTION_PAYMENT_ROW_ID#">
                                <cfset attributes.invoice_number = "#GET_BILLED_INFO.SUBSCRIPTION_NO#-#GET_BILLED_INFO.SUBSCRIPTION_PAYMENT_ROW_ID#">
                            </cfif>
                            
                            <cfset kontrol_number = 1>
                        </cfif>
                        <!--- Kontrolleri yapıyor --->
                        <cfquery name="GET_SALE" datasource="#dsn2#">
                            SELECT INVOICE_NUMBER,PURCHASE_SALES FROM INVOICE WHERE PURCHASE_SALES = 1 AND INVOICE_NUMBER='#attributes.invoice_number#'
                        </cfquery>
                        <cfif get_sale.recordcount and kontrol_number eq 1>
                            <cf_get_lang no='34.Girdiğiniz Fatura Numarası Kullanılıyor !'> : <cfoutput>#attributes.invoice_number# , Abone No : #GET_BILLED_INFO.SUBSCRIPTION_NO#</cfoutput><br/>
                        <cfelse>
                            <cflock name="#CreateUUID()#" timeout="20">
                                <cftransaction>
                                    <cfinclude template="add_sale_multi_1.cfm">
                                    <!--- Fatura kayıt işlemlerini yapıyor --->
                                    <cfinclude template="add_sale_multi_2.cfm">
                                    <!--- cari islemler ve muhasebe islemleri ekleniyor. --->
                                    <cfinclude template="add_sale_multi_3.cfm">
                                    <!--- ship eger irsaliyeli fatura ise irsaliye guncelleme ve eklemelerini yapiyor.--->
                                    <cfinclude template="add_sale_multi_4.cfm">
                                    <cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
                                        UPDATE
                                            #dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
                                        SET
                                            IS_BILLED = 1,
                                            INVOICE_ID = #GET_INVOICE_ID.MAX_ID#,
                                            PERIOD_ID = #session.ep.period_id#,
                                            INVOICE_DATE = #attributes.invoice_date#,
                                            UPDATE_DATE = #now()#,
                                            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                            UPDATE_EMP = #session.ep.userid#
                                        WHERE
                                            SUBSCRIPTION_PAYMENT_ROW_ID = #GET_BILLED_INFO.SUBSCRIPTION_PAYMENT_ROW_ID[currentrow]#
                                    </cfquery>
                                    <cfset pre_payment_date = GET_BILLED_INFO.PAYMENT_DATE>
                                    <cfset pre_subs_id = GET_BILLED_INFO.SUBSCRIPTION_ID>
                                    <cfset pre_pay_type = GET_BILLED_INFO.PAYMETHOD_ID>
                                    <cfset pre_card_type = GET_BILLED_INFO.CARD_PAYMETHOD_ID>
                                    <cfset pre_money_type = GET_BILLED_INFO.MONEY_TYPE>
                                    <cfset pre_comp_id = GET_BILLED_INFO.INVOICE_COMPANY_ID>
                                    <cfset pre_cons_id = GET_BILLED_INFO.INVOICE_CONSUMER_ID>
                                    <cfif attributes.xml_paper_no_info and isDefined("paper_no_info")><!--- standart belge numaralarından fatura no oluşturma xml i --->
                                        <cfquery name="UPD_PAPERS" datasource="#dsn2#">
                                            UPDATE 
                                                #dsn3_alias#.PAPERS_NO 
                                            SET 
                                                #paper_type#_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_no_info#">
                                            WHERE
                                            <cfif isdefined('from_printer_info') and len(from_printer_info)>
                                                PRINTER_ID = #from_printer_info#
                                            <cfelse>
                                                EMPLOYEE_ID = #session.ep.userid#
                                            </cfif>
                                        </cfquery>
                                    </cfif>
                                    <!--- action file --->
                                    <cf_workcube_process_cat 
                                        process_cat="#form.process_cat#"
                                        action_id = #GET_INVOICE_ID.MAX_ID#
                                        is_action_file = 1
                                        action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_invoice_sale&iid=#get_invoice_id.max_id#'
                                        action_file_name='#get_process_type.action_file_name#'
                                        action_db_type = '#dsn2#'
                                        is_template_action_file = '#get_process_type.action_file_from_template#'>
                                </cftransaction>
                            </cflock>
                        </cfif>
                    </cfif>
                    <cfset catch_kontrol = 0>
            <cfcatch>
                    <cfif isDefined('GET_BILLED_INFO') and isQuery(GET_BILLED_INFO)>
                        <cfset catch_kontrol = 1>
                        <cfoutput>#GET_BILLED_INFO.SUBSCRIPTION_NO# <cf_get_lang dictionary_id="41163.Nolu Abonenin Ödeme Planına Fatura Oluşturulamamıştır"> #dateFormat(GET_BILLED_INFO.PAYMENT_DATE,dateformat_style)# <cf_get_lang dictionary_id="37276.Tarihli">!<br/></cfoutput>
                    </cfif>
                </cfcatch>
            </cftry>
        </cfloop>
            <cfif catch_kontrol eq 0>
                <cf_get_lang dictionary_id="41138.Tüm ödeme planına fatura oluşturulmuştur.">
            </cfif>
        </cfif>
    </cfif>
    <cfif not isdefined("is_from_webservice")>
        <script type="text/javascript">
			alert("<cf_get_lang dictionary_id='47470'>");
            //window.close(); // Toplu fatura işleminde popup kapanmaması için kapatıldı.
            location.reload();
            wrk_opener_reload(); 
        </script>	
    </cfif>
<cfelse>
	<script language="javascript">
		alert("<cf_get_lang dictionary_id='41136.Faturalama işlemi başlamıştır'>. <cf_get_lang dictionary_id='41128.Lütfen sayfayı yenilemeyiniz'>.\n <cf_get_lang dictionary_id='41126.Kaydedilen faturaları toplu fatura listesinden takip edebilirsiniz'>!");
		window.close();
	</script>
</cfif>
