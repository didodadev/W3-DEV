<cf_get_lang_set module_name="ch">
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
	<cfif isdefined("attributes.form_submitted")>
        <cfquery name="get_premium_payment" datasource="#dsn2#">
            SELECT
                *
            FROM
                INVOICE_MULTILEVEL_PAYMENT INV,
                #dsn3_alias#.CAMPAIGNS C
            WHERE
                INV.CAMPAIGN_ID = C.CAMP_ID
            <cfif isdefined("attributes.camp_name") and len(attributes.camp_id) and len(attributes.camp_name)>
                AND INV.CAMPAIGN_ID = #attributes.camp_id#
            </cfif>
            <cfif isdefined("attributes.premium_type") and len(attributes.premium_type)>
                AND INV.PREMIUM_TYPE = #attributes.premium_type#
            </cfif>
            ORDER BY
                INV.ACTION_DATE
        </cfquery>
    <cfelse>
        <cfset get_premium_payment.recordcount = 0>
    </cfif>
    <script type="text/javascript">
	$( document ).ready(function() {
		document.getElementById('camp_name').focus();
		
		$('input.deletable').wrap('<span class="deleteicon" />').after($('<span/>').click(function() {
			$(this).prev('input').val('');
		}));
	});
		
	</script>
</cfif>
<cfif IsDefined("attributes.event") and attributes.event eq 'upd'>
	<cf_xml_page_edit fuseact="ch.form_add_premium_payment">
	<cfset system_money_info = session.ep.money>
    <cfinclude template="../../bank/query/get_accounts.cfm">
    <cfquery name="get_payment" datasource="#dsn2#">
        SELECT 
            *
        FROM 
            INVOICE_MULTILEVEL_PAYMENT,
            #dsn3_alias#.CAMPAIGNS C 
        WHERE 
            C.CAMP_ID = CAMPAIGN_ID
            AND INV_PAYMENT_ID = #attributes.inv_payment_id# 
    </cfquery>
    <cfif len(get_payment.STOPPAGE_RATE_ID)>
        <cfquery name="get_rate" datasource="#dsn2#">
            SELECT STOPPAGE_RATE FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE_ID = #get_payment.STOPPAGE_RATE_ID#
        </cfquery>
    </cfif>
    <cfquery name="get_rows" datasource="#dsn2#">
        SELECT 
            SUM(PAY_AMOUNT) PAY_AMOUNT,
            SUM(STOPPAGE_AMOUNT) STOPPAGE_AMOUNT,
            BANK_ORDER_ID,
            CARI_ACTION_ID,
            CONSUMER_ID 
        FROM 
            INVOICE_MULTILEVEL_PAYMENT_ROWS 
        WHERE 
            INV_PAYMENT_ID = #attributes.inv_payment_id# 
        GROUP BY 
            BANK_ORDER_ID,
            CARI_ACTION_ID,
            CONSUMER_ID 
    </cfquery>
    <cfif get_rows.recordcount>
        <cfset consumer_id_list = valuelist(get_rows.consumer_id)>
        <cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",',')>	
        <cfquery name="get_cons_name" datasource="#dsn#">
            SELECT   
                CH.CONSUMER_ID,
                CH.MEMBER_CODE,
                CH.CONSUMER_NAME,
                CH.CONSUMER_SURNAME,
                CC.CONSCAT,
                ISNULL(CH.IS_TAXPAYER, 0) AS IS_TAXPAYER
            FROM     
                CONSUMER_HISTORY CH, 
                CONSUMER_CAT CC
            WHERE    
                CH.CONSUMER_CAT_ID = CC.CONSCAT_ID AND 
                CH.CONSUMER_ID IN (#consumer_id_list#) AND
                CH.CAMP_ID = #get_payment.camp_id#
            ORDER BY 
                CH.CONSUMER_ID
        </cfquery>
        <cfif not get_cons_name.recordcount>
            <cfquery name="get_cons_name" datasource="#dsn#">
                SELECT   
                    CH.CONSUMER_ID,
                    CH.MEMBER_CODE,
                    CH.CONSUMER_NAME,
                    CH.CONSUMER_SURNAME,
                    CC.CONSCAT,
                    ISNULL(CH.IS_TAXPAYER, 0) AS IS_TAXPAYER
                FROM     
                    CONSUMER CH, 
                    CONSUMER_CAT CC
                WHERE    
                    CH.CONSUMER_CAT_ID = CC.CONSCAT_ID AND 
                    CH.CONSUMER_ID IN (#consumer_id_list#)
                ORDER BY 
                    CH.CONSUMER_ID
            </cfquery>
        </cfif>	
        <cfset main_consumer_id_list = listsort(listdeleteduplicates(valuelist(get_cons_name.CONSUMER_ID,',')),'numeric','ASC',',')>
    </cfif>
	<cfquery name="GET_EXPENSE_A" datasource="#dsn2#">
        SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #get_payment.EXPENSE_CENTER_ID#
    </cfquery>
    <cfquery name="GET_EXPENSE_ITEM_A" datasource="#dsn2#">
        SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_payment.EXPENSE_ITEM_ID#
    </cfquery>
    
    <cfquery name="get_bank_actions" datasource="#dsn2#">
        SELECT DISTINCT BANK_ORDER_ID FROM INVOICE_MULTILEVEL_PAYMENT_ROWS WHERE BANK_ORDER_ID IS NOT NULL AND INV_PAYMENT_ID = #url.inv_payment_id#
    </cfquery>
    <cfif get_bank_actions.recordcount>
        <cfquery name="CONTROL_BANK_ORDER" datasource="#dsn2#">
            SELECT
                BANK_ORDER_ID
            FROM
                BANK_ORDERS
            WHERE
                BANK_ORDER_ID IN(#valuelist(get_bank_actions.bank_order_id)#)
                AND BANK_ORDER_TYPE = 250
                AND ISNULL(IS_PAID,0) = 1
        </cfquery>								
    </cfif>
</cfif>

<cfif IsDefined("attributes.event") and attributes.event eq 'add'>
	<cfset cons_count = 0>
	<cf_xml_page_edit fuseact="ch.form_add_premium_payment">
    <cfparam name="attributes.action_date" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cfquery name="GET_RATE" datasource="#DSN2#">
        SELECT STOPPAGE_RATE_ID,STOPPAGE_RATE,DETAIL FROM SETUP_STOPPAGE_RATES
    </cfquery>
    <cfquery name="GET_BANK_NAMES" datasource="#DSN#">
        SELECT BANK_ID, BANK_CODE, BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
    </cfquery>
    <cfparam name="attributes.account_bank_name" default="">
    <cfparam name="attributes.iban_no" default="">
    <cfset system_money_info = session.ep.money>
    <cfif isdefined("attributes.camp_id") and len(attributes.camp_name)>
	
		<cfset attributes.debt_value = filterNum(attributes.debt_value)>
		<cfquery name="get_startdate" datasource="#dsn3#">
			SELECT CAMP_STARTDATE FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">
		</cfquery>
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
          <cfif get_all_consumers.recordcount>
			<cfoutput query="get_all_consumers">
            	<cfset cons_count = cons_count + 1>
            </cfoutput>
       </cfif>
      </cfif>
      
      <script type="text/javascript">
	  $( document ).ready(function() {
			var control_checked=<cfoutput>#cons_count#</cfoutput>;
		});
	
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
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.list_premium_payment';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'ch/display/list_premium_payment.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.list_premium_payment';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'ch/form/add_premium_payment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'ch/query/add_premium_payment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.list_premium_payment&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ch.list_premium_payment';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'ch/form/upd_premium_payment.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'ch/form/upd_premium_payment.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ch.list_premium_payment&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'inv_payment_id=##attributes.inv_payment_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.inv_payment_id##';
	
	/*
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.list_creditcard';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'finance/form/add_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'finance/query/add_creditcard.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_creditcard&event=upd';
	*/
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1040]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#get_payment.inv_payment_id#&process_cat=#get_payment.process_type#','page','add_process')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ch.list_premium_payment&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} 
</cfscript>

