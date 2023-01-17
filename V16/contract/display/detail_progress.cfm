<cf_xml_page_edit fuseact="contract.detail_progress">
<cfquery name="getProgress" datasource="#dsn3#">
	SELECT 
		PP.*,
		RC.CONTRACT_NO,
		RC.CONTRACT_HEAD,
        RC.CONTRACT_TYPE,
		ISNULL(RC.CONTRACT_AMOUNT,0) CONTRACT_AMOUNT,
		ISNULL(RC.GUARANTEE_RATE,0) GUARANTEE_RATE,
		ISNULL(RC.TEVKIFAT_RATE,0) TEVKIFAT_RATE,
        ISNULL(RC.STOPPAGE_RATE,0) STOPPAGE_RATE,
		ISNULL(RC.ADVANCE_RATE,0) ADVANCE_RATE,
		ISNULL(RC.CONTRACT_TAX,0) AS CONTRACT_TAX,
        ISNULL(RC.DISCOUNT_RATE,0) AS DISCOUNT_RATE,
		PRO_PROJECTS.PROJECT_HEAD AS PROJECT_HEAD,
        RC.STOPPAGE_RATE_ID,
		PRO_PROJECTS.DEPARTMENT_ID,
		PRO_PROJECTS.LOCATION_ID,
		STOCKS.STOCK_CODE,
		STOCKS.PRODUCT_NAME
	FROM 
		PROGRESS_PAYMENT PP
		LEFT JOIN RELATED_CONTRACT RC ON PP.CONTRACT_ID = RC.CONTRACT_ID
		LEFT JOIN #dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = PP.PROJECT_ID
		LEFT JOIN STOCKS ON STOCKS.STOCK_ID = PP.STOCK_ID AND STOCKS.PRODUCT_ID = PP.PRODUCT_ID
	WHERE 
		PP.PROGRESS_ID = #attributes.id#
</cfquery>
<cfquery name="get_Progress_Receipt" datasource="#dsn2#">
	SELECT 
		CARI_ACTIONS.ACTION_ID,
		CARI_ACTIONS.ACTION_TYPE_ID,
		CARI_ACTIONS.ACTION_CURRENCY_ID,
		CARI_ACTIONS.ACTION_VALUE,
		CARI_ACTIONS.PAPER_NO,
		CARI_ACTIONS.TO_CMP_ID,
		CARI_ACTIONS.TO_CONSUMER_ID,
		CARI_ACTIONS.FROM_CMP_ID,
		CARI_ACTIONS.FROM_CONSUMER_ID,
		ACTION_DATE,
		CASE WHEN (CARI_ACTIONS.ACTION_CURRENCY_ID = '#session.ep.money#') 
		THEN 
			CARI_ACTIONS.ACTION_VALUE 
		ELSE 
			(CARI_ACTIONS.ACTION_VALUE*(SELECT (RATE2/RATE1) FROM CARI_ACTION_MONEY CM WHERE CM.ACTION_ID = CARI_ACTIONS.ACTION_ID AND CM.MONEY_TYPE = ACTION_CURRENCY_ID))
		END AS ACTION_VALUE2,
		'#session.ep.money#' ACTION_CURRENCY_ID2,
		CARI_ACTIONS.MULTI_ACTION_ID,
		CARI_ACTIONS.PROGRESS_ID,
		COMPANY.FULLNAME AS COMPANY_NAME,
		CONSUMER.CONSUMER_NAME +' '+  CONSUMER.CONSUMER_SURNAME AS CONSUMER_NAME
	FROM
		CARI_ACTIONS
		LEFT JOIN #dsn_alias#.COMPANY ON (COMPANY.COMPANY_ID = CARI_ACTIONS.TO_CMP_ID OR COMPANY.COMPANY_ID = CARI_ACTIONS.FROM_CMP_ID)
		LEFT JOIN #dsn_alias#.CONSUMER ON (CONSUMER.CONSUMER_ID = CARI_ACTIONS.TO_CONSUMER_ID OR CONSUMER.CONSUMER_ID = CARI_ACTIONS.FROM_CONSUMER_ID)
	WHERE
		CARI_ACTIONS.ACTION_VALUE > 0
		AND CARI_ACTIONS.PROGRESS_ID = #getProgress.progress_id#
</cfquery>

<cfquery name="get_Progress_Invoice" datasource="#dsn2#">
	SELECT 
		INVOICE.INVOICE_ID,
		INVOICE.INVOICE_NUMBER,
		INVOICE.INVOICE_DATE,
		INVOICE.COMPANY_ID,
		INVOICE.CONSUMER_ID,
		INVOICE.PROGRESS_ID,
		INVOICE.PURCHASE_SALES,
		INVOICE.INVOICE_CAT,
		INVOICE.GROSSTOTAL ACTION_VALUE,
		'#session.ep.money#' ACTION_CURRENCY_ID,
		COMPANY.FULLNAME AS COMPANY_NAME,
		CONSUMER.CONSUMER_NAME +' '+  CONSUMER.CONSUMER_SURNAME AS CONSUMER_NAME
	FROM 
		INVOICE
		LEFT JOIN #dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = INVOICE.COMPANY_ID
		LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = INVOICE.CONSUMER_ID
	WHERE
		INVOICE.INVOICE_ID > 0
		AND INVOICE.IS_IPTAL = 0 
		AND INVOICE.PROGRESS_ID = #getProgress.progress_id#
</cfquery>

<!--- hakedise ait isler --->
<cfquery name="getPreviusProgress" datasource="#dsn3#">
    SELECT TOP 1 PROGRESS_ID,PROGRESS_DATE FROM PROGRESS_PAYMENT WHERE PROGRESS_ID < #getProgress.progress_id# AND CONTRACT_ID = #getProgress.contract_id# ORDER BY PROGRESS_ID DESC
</cfquery>
<cfquery name="getProgressWorks" datasource="#dsn3#">
	SELECT DISTINCT 
    	L.WORK_ID,
        L.WORK_HEAD,
		L.WORK_NO,
        SUM(L.ESTIMATED_TIME) AS ESTIMATED_TIME,
		SUM(L.TO_COMPLETE) AS TO_COMPLETE,
		SUM(L.COMPLETED_AMOUNT) AS COMPLETED_AMOUNT
    FROM (
    SELECT 
        T.*
     FROM 
        (SELECT 
            PWH.UPDATE_DATE,
            PW.WORK_ID,
            PW.WORK_HEAD,
            PW.WORK_NO,
            PWH.ESTIMATED_TIME,
            PWH.TO_COMPLETE,
            PWH.COMPLETED_AMOUNT,
            ISNULL((
            CASE 
                WHEN RC.CONTRACT_CALCULATION = 1 THEN ISNULL(CAST(PWH.TO_COMPLETE AS FLOAT),0)
                WHEN RC.CONTRACT_CALCULATION = 2 THEN ((ISNULL(CAST(PWH.TOTAL_TIME_HOUR AS FLOAT),0)*60) + ISNULL(CAST(PWH.TOTAL_TIME_MINUTE AS FLOAT),0))
                WHEN RC.CONTRACT_CALCULATION = 3 THEN ISNULL(PWH.COMPLETED_AMOUNT,0)
            ELSE 0
            END),0) AS DEGER
        FROM	
            RELATED_CONTRACT RC,
            #dsn_alias#.PRO_WORKS PW,
            #dsn_alias#.PRO_WORKS_HISTORY PWH,
            PROGRESS_PAYMENT PP
        WHERE
            PP.CONTRACT_ID = RC.CONTRACT_ID AND
            PWH.WORK_ID = PW.WORK_ID AND
            PW.PURCHASE_CONTRACT_ID = RC.CONTRACT_ID AND
            PWH.UPDATE_DATE <= PP.PROGRESS_DATE AND
            RC.CONTRACT_ID = #getProgress.contract_id# AND
            PP.PROGRESS_ID = #getProgress.progress_id#
        ) T
    WHERE
        <cfif getPreviusProgress.recordcount and len(getPreviusProgress.progress_date)>
        	T.UPDATE_DATE > '#getPreviusProgress.progress_date#' AND
        </cfif>
        T.DEGER > 0 
    )L
    GROUP BY
		L.WORK_ID,
        L.WORK_HEAD,
		L.WORK_NO
</cfquery>

<cfset work_h_list = ''>
<cfif getProgressWorks.recordcount>
	<cfset work_h_list = valuelist(getProgressWorks.WORK_ID)>
	<cfquery name="get_harcanan_zaman" datasource="#DSN#">
		SELECT
			SUM(ISNULL(EXPENSED_MINUTE,0)) AS HARCANAN_DAKIKA,
			WORK_ID
		FROM
			TIME_COST
		WHERE
			WORK_ID IN (#work_h_list#)
		GROUP BY
			WORK_ID
	</cfquery>
	<cfset work_h_list = listsort(listdeleteduplicates(valuelist(get_harcanan_zaman.WORK_ID,',')),'numeric','ASC',',')>
	<cfquery name="getToplamAs" dbtype="query">
		SELECT SUM(ESTIMATED_TIME)/60 TOPLAM_AS FROM getProgressWorks
	</cfquery>
</cfif>


		<cfif x_total_amount eq 1>
        	<cfquery name="get_kdv_total" datasource="#dsn2#">
                SELECT 
                    SUM(IR.PRICE_OTHER) TOTAL
                FROM 
                    INVOICE I,
                    INVOICE_ROW IR
                WHERE
                    I.INVOICE_ID=IR.INVOICE_ID AND
                    I.CONTRACT_ID=#getProgress.contract_id# AND
               		I.IS_IPTAL = 0
					<cfif getProgress.progress_type eq 1>
                        AND I.PURCHASE_SALES = 0
                    <cfelse>
                        AND I.PURCHASE_SALES = 1
                    </cfif> 
            </cfquery>
           	<cfif getProgress.gross_progress_value lte get_kdv_total.total>
                <cfset x_display=1>
            </cfif>
        </cfif>
<cf_catalystHeader>
    <div class="row">
        <div class="col col-12 uniqueRow">
        <cfoutput>
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-belge_tipi">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no="1121.Belge Tipi"></label>
                            <label class="col col-8 col-xs-12">
                                <cfif getProgress.progress_type eq 1><cf_get_lang no="58.Alınan Hakediş Belgesi"><cfelse><cf_get_lang no="64.Verilen Hakediş Belgesi"></cfif>
                            </label>
                        </div>
                        <cfif len(getProgress.company_id)>
                            <cfquery name="getMember" datasource="#dsn#">
                                SELECT 
                                    C.FULLNAME,
                                    CP.COMPANY_PARTNER_NAME,
                                    CP.COMPANY_PARTNER_SURNAME
                                FROM 
                                    COMPANY C,
                                    COMPANY_PARTNER CP
                                WHERE 
                                    C.MANAGER_PARTNER_ID = CP.PARTNER_ID AND 
                                    C.COMPANY_ID = #getProgress.company_id#
                            </cfquery>
                            <cfset member_name = getMember.FULLNAME>
                            <cfset member_partner_name = '#getMember.COMPANY_PARTNER_NAME# #getMember.COMPANY_PARTNER_SURNAME#'>
                        <cfelse>
                            <cfquery name="getMember" datasource="#dsn#">
                                SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = #getProgress.consumer_id#
                            </cfquery>
                            <cfset member_name = '#getMember.CONSUMER_NAME# #getMember.CONSUMER_SURNAME#'>
                            <cfset member_partner_name = ''>
                        </cfif>
                        <div class="form-group" id="item-member_name">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no="649.Cari"></label>
                            <label class="col col-8 col-xs-12">#left(member_name,50)#</label>
                        </div>
                        <div class="form-group" id="item-member_partner_name">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no="166.Yetkili"></label>
                            <label class="col col-8 col-xs-12">#member_partner_name#</label>
                        </div>
                        <div class="form-group" id="item-progress_no">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no="468.Belge No"></label>
                            <label class="col col-8 col-xs-12">#getProgress.progress_no#</label>
                        </div>
                        <div class="form-group" id="item-progress_date">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no="330.Tarih"></label>
                            <label class="col col-8 col-xs-12">#dateformat(getProgress.progress_date,dateformat_style)#</label>
                        </div>
                        <div class="form-group" id="item-contract_id">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no="1725.Sözleşme"></label>
                            <label class="col col-8 col-xs-12"><a href="#request.self#?fuseaction=contract.form_upd_contract&contract_id=#getProgress.contract_id#" class="tableyazi" target="_blank">#getProgress.contract_id# / #getProgress.contract_head#</a></label>
                        </div>
                        <div class="form-group" id="item-contract_amount">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang no='285.Sozlesme Tutari'><cf_get_lang_main no='2227.KDVsiz'></label>
                            <label class="col col-8 col-xs-12">#TLFormat(getProgress.contract_amount,2)# #getProgress.PROGRESS_CURRENCY_ID#</label>
                        </div>
                        <div class="form-group" id="item-PROJECT_HEAD">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no="4.Proje"></label>
                            <label class="col col-8 col-xs-12"><a href="#request.self#?fuseaction=project.projects&event=det&id=#getProgress.project_id#" class="tableyazi" target="_blank">#getProgress.PROJECT_HEAD#</a></label>
                        </div>
                        <div class="form-group" id="item-DEPARTMENT_HEAD">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no="1351.Depo"></label>
                            <label class="col col-8 col-xs-12"><cfif len(getProgress.department_id)>
                                <cfquery name="get_department_name" datasource="#DSN#">
                                    SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #getProgress.department_id#
                                    </cfquery>
                                    #get_department_name.DEPARTMENT_HEAD#
                                </cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-invoice_number">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no="29.Fatura"></label>
                            <label class="col col-8 col-xs-12">
                                <cfif get_Progress_Invoice.recordcount>
                                    #valuelist(get_Progress_Invoice.invoice_number,',')#
                                </cfif>
                            </label>
                        </div>
                        <div class="form-group" id="item-record_emp">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no="487.Kaydeden"></label>
                            <label class="col col-8 col-xs-12">
                                #get_emp_info(getProgress.record_emp,0,1)#
                            </label>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-today_progress_value">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang no="75.Bugünkü Kümülatif Hakediş"></label>
                            <label class="col col-8 col-xs-12">
                                <cfset discount_amount = (getProgress.today_progress_value*getProgress.discount_rate)/100><!--- indirim Tutarı --->
                                #TLFormat(getProgress.today_progress_value-discount_amount,2)# #getProgress.PROGRESS_CURRENCY_ID#
                            </label>
                        </div>
                        <div class="form-group" id="item-gross_progress_value">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang no="77.Brüt Hakediş"></label>
                            <label class="col col-8 col-xs-12">#TLFormat(getProgress.gross_progress_value,2)# #getProgress.PROGRESS_CURRENCY_ID#</label>
                        </div>
                        <div class="form-group" id="item-GUARANTEE_RATE">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang no="124.Teminat Oranı"></label>
                            <label class="col col-8 col-xs-12">#getProgress.GUARANTEE_RATE# %</label>
                        </div>
                        <div class="form-group" id="item-guarantee_amount">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang no="151.Teminat Kesinti Tutarı"></label>
                            <label class="col col-8 col-xs-12">
                                <cfset guarantee_amount = (getProgress.gross_progress_value*getProgress.guarantee_rate)/100><!--- Teminat Kesinti Tutarı --->
                                #TLFormat(guarantee_amount,2)# #getProgress.PROGRESS_CURRENCY_ID#
                            </label>
                        </div>
                        <div class="form-group" id="item-ADVANCE_RATE">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang no="158.Avans Oranı"></label>
                            <label class="col col-8 col-xs-12">
                                #getProgress.ADVANCE_RATE# %
                            </label>
                        </div>
                        <div class="form-group" id="item-advance_amount">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang no="181.Avans Kesinti Tutarı"></label>
                            <label class="col col-8 col-xs-12">
                                <cfset advance_amount = (getProgress.gross_progress_value*getProgress.advance_rate)/100><!--- Avans Kesinti Tutarı --->
                                #TLFormat(advance_amount,2)# #getProgress.PROGRESS_CURRENCY_ID#
                            </label>
                        </div>
                        <div class="form-group" id="item-tevkifat_rate">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang no="34.Tevkifat Oranı"></label>
                            <label class="col col-8 col-xs-12">
                                #getProgress.tevkifat_rate# %
                            </label>
                        </div>
                        <div class="form-group" id="item-tevkifat_amount">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang no="197.Tevkifat Kesinti Tutarı"></label>
                            <label class="col col-8 col-xs-12">
                                <!---<cfset tevkifat_amount = (getProgress.gross_progress_value*getProgress.tevkifat_rate)/100>--->
                                <cfset tevkifat_amount = (getProgress.gross_progress_value*getProgress.contract_tax/100)*(1-getProgress.tevkifat_rate)><!--- Tevkifat Kesinti Tutarı --->
                                #TLFormat(tevkifat_amount,2)# #getProgress.PROGRESS_CURRENCY_ID#
                            </label>
                        </div>
                        <div class="form-group" id="item-stoppage_rate">
                            <label class="col col-4 col-xs-12 bold"><cfoutput>#getlang('ch',63)#</cfoutput></label>
                            <label class="col col-8 col-xs-12">
                                #getProgress.stoppage_rate# %
                            </label>
                        </div>
                        <div class="form-group" id="item-stoppage_amount">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id="54746.Stopaj Kesinti Tutarı"></label>
                            <label class="col col-8 col-xs-12">
                                <cfset stoppage_amount = (getProgress.gross_progress_value*getProgress.stoppage_rate)/100><!--- Stopaj Kesinti Tutarı --->
                                #TLFormat(stoppage_amount,2)# #getProgress.PROGRESS_CURRENCY_ID#
                            </label>
                        </div>
                        <div class="form-group" id="item-receipt_total">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang no="202.Dekontlu Dönemsel Kesintiler"></label>
                            <label class="col col-8 col-xs-12">
                                <cfset receipt_total = 0>
                                    <cfloop query="get_Progress_Receipt">
                                    <cfif get_Progress_Receipt.ACTION_CURRENCY_ID2 is getProgress.progress_currency_id>
                                        <cfset receipt_total = receipt_total+get_Progress_Receipt.ACTION_VALUE2>
                                    <cfelse>
                                        <cfquery name="getCariActionMoney" datasource="#dsn2#">
                                            SELECT
                                                (RATE2/RATE1) RATE
                                            FROM
                                            <cfif len(MULTI_ACTION_ID)>
                                                CARI_ACTION_MULTI_MONEY
                                            <cfelse>
                                                CARI_ACTION_MONEY
                                            </cfif>
                                            WHERE
                                                ACTION_ID = <cfif len(MULTI_ACTION_ID)>#get_Progress_Receipt.MULTI_ACTION_ID#<cfelse>#get_Progress_Receipt.action_id#</cfif> AND
                                                MONEY_TYPE = '#getProgress.progress_currency_id#'
                                        </cfquery>
                                        <cfset receipt_total = receipt_total+(get_Progress_Receipt.action_value2/getCariActionMoney.rate)>
                                    </cfif>
                                </cfloop>
                                #TLFormat(receipt_total,2)# #getProgress.PROGRESS_CURRENCY_ID#
                            </label>
                        </div>
                        <div class="form-group" id="item-invoice_total">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang no="204.Faturalı Dönemsel Kesintiler"></label>
                            <label class="col col-8 col-xs-12">
                                <cfset invoice_total = 0>
                                <cfquery dbtype="query" name="get_Progress_Invoice_">
                                    SELECT 
                                        * 
                                    FROM 
                                        get_Progress_Invoice 
                                    WHERE
                                        <cfif getProgress.progress_type eq 1>
                                            PURCHASE_SALES = 1
                                        <cfelse>
                                            PURCHASE_SALES = 0
                                        </cfif>
                                </cfquery>
                                <cfloop query="get_Progress_Invoice_">
                                    <cfif get_Progress_Invoice_.ACTION_CURRENCY_ID is getProgress.progress_currency_id>
                                        <cfset invoice_total = invoice_total+get_Progress_Invoice_.ACTION_VALUE>
                                    <cfelse>
                                        <cfquery name="getInvoiceMoney" datasource="#dsn2#">
                                            SELECT
                                                (RATE2/RATE1) RATE
                                            FROM
                                                INVOICE_MONEY
                                            WHERE
                                                ACTION_ID = #get_Progress_Invoice_.invoice_id#AND
                                                MONEY_TYPE = '#getProgress.progress_currency_id#'
                                        </cfquery>
                                        <cfset invoice_total = invoice_total+(get_Progress_Invoice_.action_value/getInvoiceMoney.rate)>
                                    </cfif>
                                </cfloop>
                                #TLFormat(invoice_total,2)# #getProgress.PROGRESS_CURRENCY_ID#
                            </label>
                        </div>
                        <div class="form-group" id="item-NET_PROGRESS_VALUE">
                            <label class="col col-4 col-xs-12 bold"><cf_get_lang no="104.Net Hakediş"></label>
                            <label class="col col-8 col-xs-12">
                                #TLFormat(getProgress.NET_PROGRESS_VALUE,2)# #getProgress.PROGRESS_CURRENCY_ID#
                            </label>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <div class="col col-12">
                        <cfif get_Progress_Invoice.recordcount>
                            <font color="red"><cf_get_lang no="218.İlişkili Fatura Bulunmaktadır">!</font>
                            <cf_workcube_buttons is_upd='0' is_insert="0">
                        <cfelse>
                            <cfset delete_page_url = "#request.self#?fuseaction=contract.emptypopup_del_progress_payment&progress_id=#getProgress.progress_id#">
                            <cf_workcube_buttons is_upd='1' is_insert="0" delete_page_url='#delete_page_url#'>
                        </cfif>
                    </div>
                </div>
            </div>
            <cfif len(getProgress.product_id)>
            <div class="row">
            	<div class="col col-12">
                    <table cellspacing="1" cellpadding="2" width="100%" border="0" align="center" class="workDevList">
                    <tr class="color-list">
                    <td class="txtboldblue"><cf_get_lang_main no="106.Stok Kodu"></td>
                    <td class="txtboldblue"><cf_get_lang_main no="245.Ürün"></td>
                    <td class="txtboldblue"><cf_get_lang_main no="672.Fiyat"></td>
                    <td class="txtboldblue"><cf_get_lang_main no="77.Para Birimi"></td>
                    <td class="txtboldblue"><cf_get_lang_main no="227.KDV"></td>
                    <td class="txtboldblue"><cf_get_lang_main no="231.KDV Toplam"></td>
                    </tr>
                    <tr class="color-row" height="20">
                    <td>#getProgress.STOCK_CODE#</td>
                    <td>#getProgress.PRODUCT_NAME#</td>
                    <td style="text-align:right;">#TLFormat(getProgress.gross_progress_value,2)#</td>
                    <td style="text-align:right;">#getProgress.PROGRESS_CURRENCY_ID#</td>
                    <td style="text-align:right;">#getProgress.CONTRACT_TAX# %</td>
                    <td style="text-align:right;"><cfif getProgress.CONTRACT_TAX neq 0>#TLFormat((getProgress.gross_progress_value+(getProgress.gross_progress_value*getProgress.CONTRACT_TAX)/100),2)#<cfelse>#TLFormat(getProgress.gross_progress_value,2)#</cfif></td>
                    </tr>
                    </table>
                </div>
            </div>
            </cfif>
            </cfoutput>
            <cfif getProgressWorks.recordcount>
            <div class="row">
            	<div class="col col-12">
                	<!--- iliskili isler --->
                    <table cellspacing="1" cellpadding="2" width="100%" border="0" align="center" class="workDevList">
                        <tr class="color-list" height="25">
                            <td class="txtboldblue" colspan="5">
                                <a href="javascript://" onclick="gizle_goster_img('list_work_img3','list_work_img4','progress_works');"><img src="/images/listele.gif" border="0" align="absmiddle" id="list_work_img4" style="display:;cursor:pointer;"></a>
                                <a href="javascript://" onclick="gizle_goster_img('list_work_img3','list_work_img4','progress_works');"><img src="/images/listele_down.gif" border="0" align="absmiddle" id="list_work_img3" style="display:none;cursor:pointer;"></a>
                                <cfoutput>#getlang('sales',81)#</cfoutput>
                            </td>
                        </tr>
                        <tr class="color-row" height="20" id="progress_works" style="display:none;">
                            <td>
                                <table cellspacing="1" cellpadding="2" width="100%" border="0" align="center">
                                    <tr class="color-row">
                                        <td class="txtboldblue" width="25"><cf_get_lang_main no='75.No'></td>
                                        <td class="txtboldblue" width="70"><cf_get_lang dictionary_id="38472.İş No"></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='1033.İş'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='223.Miktar'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='1716.Süre'></td>
                                        <td class="txtboldblue">%</td>
                                    </tr>
                                    <cfoutput query="getProgressWorks">
                                        <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                                            <td>#currentrow#</td>
                                            <td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=project.works&event=det&id=#work_id#','project')">#work_no#</a></td>
                                            <td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=project.works&event=det&id=#work_id#','project')">#work_head#</a></td>
                                            <td style="text-align:right;">#TLFormat(COMPLETED_AMOUNT,2)#</td>
                                            <td style="text-align:right;"><cfif listfindnocase(work_h_list,work_id)>
                                                    <cfset harcanan_ = get_harcanan_zaman.HARCANAN_DAKIKA[listfind(work_h_list,work_id,',')]>
                                                    <cfset liste=harcanan_/60>
                                                    <cfset saat=listfirst(liste,'.')>
                                                    <cfset dak=harcanan_-saat*60>
                                                    #saat# <cf_get_lang_main no="79.saat"> #dak# <cf_get_lang_main no="1415.dk">
                                                </cfif>
                                            </td>
                                            <td style="text-align:right;">#to_complete# %</td>
                                        </tr>
                                    </cfoutput>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
           	</cfif>
            <cfif get_Progress_Receipt.recordcount>
            <div class="row">
            	<div class="col col-12">
                	 <cfquery name="getProgressCreditReceipt" dbtype="query">
                        SELECT 
                            ACTION_ID,
                            MULTI_ACTION_ID,
                            ACTION_VALUE,
                            ACTION_CURRENCY_ID,
                            PAPER_NO,
                            ACTION_DATE,
                            COMPANY_NAME,
                            CONSUMER_NAME
                        FROM 
                            get_Progress_Receipt 
                        WHERE 
                            PROGRESS_ID = #getProgress.progress_id#
                            AND ACTION_TYPE_ID = 42
                    </cfquery>
       				 <table cellspacing="1" cellpadding="2" width="100%" border="0" align="center" class="workDevList">
                        <tr class="color-list" height="25">
                            <td class="txtboldblue" colspan="5">
                                <a href="javascript://" onclick="gizle_goster_img('list_credit_img3,'list_credit_img4','credit_note');"><img src="/images/listele.gif" border="0" align="absmiddle" id="list_credit_img4" style="display:;cursor:pointer;"></a>
                                <a href="javascript://" onclick="gizle_goster_img('list_credit_img3,'list_credit_img4','credit_note');"><img src="/images/listele_down.gif" border="0" align="absmiddle" id="list_credit_img3" style="display:none;cursor:pointer;"></a>
                                <cf_get_lang no="219.Alacak Dekontları">
                            </td>
                        </tr>
                        <tr class="color-row" height="20" id="credit_note" style="display:none;">
                            <td>
                                <table cellspacing="1" cellpadding="2" width="100%" border="0" align="center">
                                    <tr class="color-row">
                                        <td class="txtboldblue" width="15"><cf_get_lang_main no='75.No'></td>
                                        <td class="txtboldblue" width="60"><cf_get_lang_main no='468.Belge No'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='107.Cari Hesap'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='330.Tarih'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='261.Tutar'></td>
                                    </tr>
                                    <cfif getProgressCreditReceipt.recordcount>
                                        <cfoutput query="getProgressCreditReceipt">
                                            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                                                <td>#currentrow#</td>
                                                <td>
                                                <cfif len(MULTI_ACTION_ID)>
                                                    <a href="#request.self#?fuseaction=ch.upd_collacted_dekont&multi_id=#MULTI_ACTION_ID#" class="tableyazi" target="_blank">#paper_no#</a>
                                                <cfelse>
                                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ch.popup_form_upd_debit_claim_note&id=#action_id#','medium');" class="tableyazi">#paper_no#
                                                </cfif>
                                                </td>
                                                <td><cfif len(company_name)>#company_name#<cfelseif len(consumer_name)>#consumer_name#</cfif>
                                                </td>
                                                <td>#dateformat(action_date,dateformat_style)#</td>
                                                <td style="text-align:right;">#TLFormat(action_value,2)# #action_currency_id#</td>
                                            </tr>
                                        </cfoutput>
                                    <cfelse>
                                        <tr>
                                            <td colspan="5" class="color-row"><cf_get_lang_main no='72.Kayıt Yok'></td>
                                        </tr>
                                    </cfif>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="row">
            	<div class="col col-12">
                	 <cfquery name="getProgressDebitReceipt" dbtype="query">
                        SELECT 
                            ACTION_ID,
                            MULTI_ACTION_ID,
                            ACTION_VALUE,
                            ACTION_CURRENCY_ID,
                            PAPER_NO,
                            ACTION_DATE,
                            COMPANY_NAME,
                            CONSUMER_NAME
                        FROM 
                            get_Progress_Receipt 
                        WHERE 
                            PROGRESS_ID = #getProgress.progress_id#
                            AND ACTION_TYPE_ID = 41
                    </cfquery>
       				 <table cellspacing="1" cellpadding="2" width="100%" border="0" align="center" class="workDevList">
                        <tr class="color-list" height="25">
                            <td class="txtboldblue" colspan="5">
                                <a href="javascript://" onclick="gizle_goster_img('list_debit_img3','list_debit_img4','debit_note');"><img src="/images/listele.gif" border="0" align="absmiddle" id="list_debit_img4" style="display:;cursor:pointer;"></a>
                                <a href="javascript://" onclick="gizle_goster_img('list_debit_img3','list_debit_img4','debit_note');"><img src="/images/listele_down.gif" border="0" align="absmiddle" id="list_debit_img3" style="display:none;cursor:pointer;"></a>
                                <cf_get_lang no="220.Borç Dekontları">
                            </td>
                        </tr>
                        <tr class="color-row" height="20" id="debit_note" style="display:none;">
                            <td>
                                <table cellspacing="1" cellpadding="2" width="100%" border="0" align="center">
                                    <tr class="color-row">
                                        <td class="txtboldblue"><cf_get_lang_main no='75.No'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='468.Belge No'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='107.Cari Hesap'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='330.Tarih'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='261.Tutar'></td>
                                    </tr>
                                    <cfif getProgressDebitReceipt.recordcount>
                                        <cfoutput query="getProgressDebitReceipt">
                                            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                                                <td>#currentrow#</td>
                                                <td>
                                                <cfif len(MULTI_ACTION_ID)>
                                                    <a href="#request.self#?fuseaction=ch.upd_collacted_dekont&multi_id=#MULTI_ACTION_ID#" class="tableyazi" target="_blank">#paper_no#</a>
                                                <cfelse>
                                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ch.popup_form_upd_debit_claim_note&id=#action_id#','medium');" class="tableyazi">#paper_no#
                                                </cfif>
                                                </td>
                                                <td><cfif len(company_name)>
                                                        #company_name#
                                                    <cfelseif len(consumer_name)>
                                                        #consumer_name#
                                                    </cfif>
                                                </td>
                                                <td>#dateformat(action_date,dateformat_style)#</td>
                                                <td style="text-align:right;">#TLFormat(action_value,2)# #action_currency_id#</td>
                                            </tr>
                                        </cfoutput>
                                    <cfelse>
                                        <tr>
                                            <td colspan="5"><cf_get_lang_main no='72.Kayıt Yok'></td>
                                        </tr>
                                    </cfif>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            </cfif>
            <cfif get_Progress_Invoice.recordcount>
            <div class="row">
            	<div class="col col-12">
                	<cfquery name="getProgressSaleInvoice" dbtype="query">
                        SELECT 
                            INVOICE_ID,
                            INVOICE_NUMBER,
                            INVOICE_DATE,
                            COMPANY_ID,
                            CONSUMER_ID,
                            ACTION_VALUE,
                            ACTION_CURRENCY_ID,
                            COMPANY_NAME,
                            CONSUMER_NAME
                        FROM 
                            get_Progress_Invoice 
                        WHERE 
                            PROGRESS_ID = #getProgress.progress_id#
                            AND PURCHASE_SALES = 1 
                            AND INVOICE_CAT NOT IN(67,69)
                    </cfquery>
       				<table cellspacing="1" cellpadding="2" width="100%" border="0" align="center" class="workDevList">
                        <tr class="color-list" height="25">
                            <td class="txtboldblue" colspan="5">
                                <a href="javascript://" onclick="gizle_goster_img('list_sale_img3','list_sale_img4','sale_invoice');"><img src="/images/listele.gif" border="0" align="absmiddle" id="list_sale_img4" style="display:;cursor:pointer;"></a>
                                <a href="javascript://" onclick="gizle_goster_img('list_sale_img3','list_sale_img4','sale_invoice');"><img src="/images/listele_down.gif" border="0" align="absmiddle" id="list_sale_img3" style="display:none;cursor:pointer;"></a>
                                <cf_get_lang no="221.Satış Faturaları">
                            </td>
                        </tr>
                        <tr class="color-row" height="20" id="sale_invoice" style="display:none;">
                            <td>
                                <table cellspacing="1" cellpadding="2" width="100%" border="0" align="center">
                                    <tr>
                                        <td class="txtboldblue"><cf_get_lang_main no='75.No'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='468.Belge No'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='107.Cari Hesap'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='330.Tarih'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='261.Tutar'></td>
                                    </tr>
                                    <cfif getProgressSaleInvoice.recordcount>
                                        <cfoutput query="getProgressSaleInvoice">
                                            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                                                <td>#currentrow#</td>
                                                <td><a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#invoice_id#" class="tableyazi" target="_blank">#invoice_number#</a></td>
                                                <td><cfif len(company_name)>
                                                        #company_name#
                                                    <cfelseif len(consumer_name)>
                                                        #consumer_name#
                                                    </cfif>
                                                </td>
                                                <td>#dateformat(invoice_date,dateformat_style)#</td>
                                                <td style="text-align:right;">#TLFormat(action_value,2)# #action_currency_id#</td>
                                            </tr>
                                        </cfoutput>
                                    <cfelse>
                                        <tr>
                                            <td colspan="5"><cf_get_lang_main no='72.Kayıt Yok'></td>
                                        </tr>
                                    </cfif>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="row">
            	<div class="col col-12">
                	<cfquery name="getProgressPurchaseInvoice" dbtype="query">
                        SELECT 
                            INVOICE_ID,
                            INVOICE_NUMBER,
                            INVOICE_DATE,
                            COMPANY_ID,
                            CONSUMER_ID,
                            ACTION_VALUE,
                            ACTION_CURRENCY_ID,
                            COMPANY_NAME,
                            CONSUMER_NAME
                        FROM 
                            get_Progress_Invoice 
                        WHERE 
                            PROGRESS_ID = #getProgress.progress_id#
                            AND PURCHASE_SALES = 0
                    </cfquery>
        			<table cellspacing="1" cellpadding="2" width="100%" border="0" align="center" class="workDevList">
                        <tr class="color-list" height="25">
                            <td class="txtboldblue" colspan="5">
                                <a href="javascript://" onclick="gizle_goster_img('list_purchase_img3','list_purchase_img4','purchase_invoice');"><img src="/images/listele.gif" border="0" align="absmiddle" id="list_purchase_img4" style="display:;cursor:pointer;"></a>
                                <a href="javascript://" onclick="gizle_goster_img('list_purchase_img3','list_purchase_img4','purchase_invoice');"><img src="/images/listele_down.gif" border="0" align="absmiddle" id="list_purchase_img3" style="display:none;cursor:pointer;"></a>
                                <cf_get_lang no="222.Alış Faturaları">
                            </td>
                        </tr>
                        <tr class="color-row" height="20" id="purchase_invoice" style="display:none;">
                            <td>
                                <table cellspacing="1" cellpadding="2" width="100%" border="0" align="center">
                                    <tr>
                                        <td class="txtboldblue"><cf_get_lang_main no='75.No'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='468.Belge No'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='107.Cari Hesap'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='330.Tarih'></td>
                                        <td class="txtboldblue"><cf_get_lang_main no='261.Tutar'></td>
                                    </tr>
                                    <cfif getProgressPurchaseInvoice.recordcount>
                                        <cfoutput query="getProgressPurchaseInvoice">
                                            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                                                <td>#currentrow#</td>
                                                <td><a href="#request.self#?fuseaction=invoice.form_add_bill_purchas&event=upd&iid=#invoice_id#" class="tableyazi" target="_blank">#invoice_number#</a></td>
                                                <td><cfif len(company_name)>
                                                        #company_name#
                                                    <cfelseif len(consumer_name)>
                                                        #consumer_name#
                                                    </cfif>
                                                </td>
                                                <td>#dateformat(invoice_date,dateformat_style)#</td>
                                                <td style="text-align:right;">#TLFormat(action_value,2)# #action_currency_id#</td>
                                            </tr>
                                        </cfoutput>
                                    <cfelse>
                                    <tr>
                                        <td colspan="5"><cf_get_lang_main no='72.Kayıt Yok'></td>
                                    </tr>
                                    </cfif>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            </cfif>
        </div>
    </div>
   
<form name="add_hakedis_fatura" action="" method="post" target="_blank">
	<cfoutput>
		<input type="hidden" name="net_total_money" id="net_total_money" value="#getProgress.PROGRESS_CURRENCY_ID#" />
		<input type="hidden" name="net_total" id="net_total" value="#getProgress.progress_value#" />
		<input type="hidden" name="company_id" id="company_id" value="#getProgress.company_id#" />
        <input type="hidden" name="consumer_id" id="consumer_id" value="#getProgress.consumer_id#" />
		<input type="hidden" name="project_id" id="project_id" value="#getProgress.project_id#" />
		<input type="hidden" name="stock_id" id="stock_id" value="#getProgress.stock_id#" />
		<input type="hidden" name="department_id" id="department_id" value="#getProgress.department_id#" />
		<input type="hidden" name="location_id" id="location_id" value="#getProgress.location_id#" />
		<input type="hidden" name="invoice_tax" id="invoice_tax" value="#getProgress.contract_tax#" />
		<input type="hidden" name="contract_id" id="contract_id" value="#getProgress.contract_id#" />
		<input type="hidden" name="progress_id" id="progress_id" value="#getProgress.progress_id#" />
        
        <cfset stoppage_amount = (getProgress.progress_value*getProgress.stoppage_rate)/100>
        <input type="hidden" name="stoppage_amount" id="stoppage_amount" value="#stoppage_amount#" />
        <input type="hidden" name="stoppage_rate" id="stoppage_rate" value="#getProgress.stoppage_rate#" />
        <input type="hidden" name="stoppage_rate_id" id="stoppage_rate_id" value="#getProgress.stoppage_rate_id#" />
	</cfoutput>
</form>
<script language="javascript">
	function KontrolEt_Gonder(type)
	{
		if(type == 1)		
			add_hakedis_fatura.action="<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchase</cfoutput>";
		else
			add_hakedis_fatura.action="<cfoutput>#request.self#?fuseaction=invoice.form_add_bill</cfoutput>";
		add_hakedis_fatura.submit();
	}
</script>
