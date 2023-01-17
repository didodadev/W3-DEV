<cfset tutar_main = 0>
<cfset miktar_main = 0>
<cfset toplam_main = 0>
<cfset toplam_indirim_main = 0>
<cfset kdv_toplam_main = 0>
<cfset otv_toplam_main = 0>
<cfset bsmv_toplam_main = 0>
<cfset oiv_toplam_main = 0>
<cfset kdvli_toplam_main = 0>
<cfset other_money_tutar_main = 0>
<cfset rate_count = "">
<cfif isDefined("xml_money_type") and xml_money_type eq 5><!--- xml deki kuru risk bilgilerinden alsın parametresi --->
	<cfquery name="GET_MEMBER_RATE_INFO" datasource="#dsn2#">
		SELECT
			PAYMENT_RATE_TYPE
		FROM
			#dsn_alias#.COMPANY_CREDIT
		WHERE
		<cfif len(GET_BILLED_INFO.INVOICE_COMPANY_ID)>
			COMPANY_ID = #GET_BILLED_INFO.INVOICE_COMPANY_ID# AND
		<cfelse>
			CONSUMER_ID = #GET_BILLED_INFO.INVOICE_CONSUMER_ID# AND
		</cfif>
			OUR_COMPANY_ID = #session.ep.company_id#
	</cfquery>
	<cfif GET_MEMBER_RATE_INFO.recordcount and len(GET_MEMBER_RATE_INFO.PAYMENT_RATE_TYPE)>
		<cfquery name="GET_RATE_INFO" datasource="#dsn2#">
			SELECT 
			<cfif GET_MEMBER_RATE_INFO.PAYMENT_RATE_TYPE eq 1><!--- Alış --->
				ISNULL(RATE3,RATE2) RATE_INFO,
			<cfelseif GET_MEMBER_RATE_INFO.PAYMENT_RATE_TYPE eq 2><!--- Satış --->
				RATE2 RATE_INFO,
			<cfelseif GET_MEMBER_RATE_INFO.PAYMENT_RATE_TYPE eq 3><!--- Efektif Alış --->
				ISNULL(EFFECTIVE_PUR,RATE2) RATE_INFO,
			<cfelseif GET_MEMBER_RATE_INFO.PAYMENT_RATE_TYPE eq 4><!--- Efektif Satış --->
				ISNULL(EFFECTIVE_SALE,RATE2) RATE_INFO,
			</cfif>
				MONEY,
				RATE1
			FROM
				#dsn_alias#.MONEY_HISTORY
			WHERE
				MONEY_HISTORY_ID IN 
							(
								SELECT
									MAX(MONEY_HISTORY_ID)
								FROM 
									#dsn_alias#.MONEY_HISTORY MNY_H
								WHERE 
									MNY_H.PERIOD_ID= #session.ep.period_id#
									AND MNY_H.MONEY=MONEY_HISTORY.MONEY
									AND MNY_H.VALIDATE_DATE <= #attributes.invoice_date#
								GROUP BY
									MNY_H.MONEY
							)
		</cfquery>
		<cfif not GET_RATE_INFO.recordcount>
			<cfquery name="GET_RATE_INFO" datasource="#dsn2#">
				SELECT
				<cfif GET_MEMBER_RATE_INFO.PAYMENT_RATE_TYPE eq 1><!--- Alış --->
					ISNULL(RATE3,RATE2) RATE_INFO,
				<cfelseif GET_MEMBER_RATE_INFO.PAYMENT_RATE_TYPE eq 2><!--- Satış --->
					RATE2 RATE_INFO,
				<cfelseif GET_MEMBER_RATE_INFO.PAYMENT_RATE_TYPE eq 3><!--- Efektif Alış --->
					ISNULL(EFFECTIVE_PUR,RATE2) RATE_INFO,
				<cfelseif GET_MEMBER_RATE_INFO.PAYMENT_RATE_TYPE eq 4><!--- Efektif Satış --->
					ISNULL(EFFECTIVE_SALE,RATE2) RATE_INFO,
				</cfif>
					MONEY,
					RATE1
				FROM
					SETUP_MONEY
			</cfquery>
		</cfif>
		<cfif GET_RATE_INFO.recordcount><cfset rate_count = GET_RATE_INFO.recordcount></cfif>
	</cfif>
</cfif>

<cfset due_date = "">
<cfif isDefined("attributes.inv_payment_type_id") and len(attributes.inv_payment_type_id)>
	<cfset pay_met_id = attributes.inv_payment_type_id>
<cfelseif isDefined("attributes.payment_type_id") and len(attributes.payment_type_id)>
	<cfset pay_met = attributes.payment_type_id>
<cfelse>
	<cfset pay_met_id = GET_BILLED_INFO.PAYMETHOD_ID>
</cfif>

<cfif len(pay_met_id)>
	<cfset paymethod_calc =  paymethod_comp.calc_duedate(action_date:dateformat(attributes.invoice_date,dateformat_style), paymethod_id:pay_met_id,transaction_dsn:dsn2)>
	<cfif isdefined("paymethod_calc.due_date") and len(paymethod_calc.due_date)>
		<cf_date tarih="paymethod_calc.due_date">
		<cfset due_date = paymethod_calc.due_date>
	<cfelse>
		<cfset due_date = attributes.invoice_date>
	</cfif>
<cfelse>
	<cfset due_date = attributes.invoice_date>
</cfif>

<cfquery name="ADD_INVOICE_SALE" datasource="#dsn2#" result="MAX_ID">
	INSERT INTO INVOICE
		(
			WRK_ID,
			PURCHASE_SALES,
            SERIAL_NUMBER,
			SERIAL_NO,
			INVOICE_NUMBER,
			INVOICE_CAT,
			INVOICE_DATE,
            SHIP_DATE,
			COMPANY_ID,
			PARTNER_ID,
			CONSUMER_ID,
			NETTOTAL,
			GROSSTOTAL,
			TAXTOTAL,
			OTV_TOTAL,
			SA_DISCOUNT,
			DEPARTMENT_ID,
			DEPARTMENT_LOCATION,
			RECORD_DATE,
			RECORD_EMP,
			PAY_METHOD,
			CARD_PAYMETHOD_ID,
            DUE_DATE,
			UPD_STATUS,
			OTHER_MONEY,
			OTHER_MONEY_VALUE,
			IS_WITH_SHIP,
			PROCESS_CAT,
			INVOICE_MULTI_ID,
			NOTE,
			PROFILE_ID,

			SALE_EMP,
			PROJECT_ID,
			SHIP_ADDRESS,
			SHIP_ADDRESS_ID,
			SUBSCRIPTION_ID,
			SALES_CONSUMER_ID,
			SALES_PARTNER_ID,
			BSMV_TOTAL,
			OIV_TOTAL,
			PROCESS_STAGE
		)
	VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
			1,<!--- satış --->
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.serial_number,'-')#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#replace(attributes.invoice_number,'#listfirst(attributes.serial_number,'-')#-','')#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoice_number#">,
			#INVOICE_CAT#,
			#attributes.invoice_date#,
            #attributes.invoice_date#,
			<cfif len(invoice_comp_id)>#invoice_comp_id#<cfelse>NULL</cfif>,
			<cfif len(invoice_part_id)>#invoice_part_id#<cfelse>NULL</cfif>,
			<cfif len(invoice_cons_id)>#invoice_cons_id#<cfelse>NULL</cfif>,
			0,
			0,
			0,
			0,
			0,
			#attributes.department_id#,
			#attributes.location_id#,
			#NOW()#,
			#SESSION.EP.USERID#,
			<cfif (isDefined("attributes.inv_payment_type_id") and len(attributes.inv_payment_type_id)) or (isDefined("attributes.inv_card_paymethod_id") and len(attributes.inv_card_paymethod_id))>
            	<cfif len(pay_met_id)>#pay_met_id#<cfelse>NULL</cfif>,
                <cfif len(attributes.inv_card_paymethod_id)>#attributes.inv_card_paymethod_id#<cfelse>NULL</cfif>,
                <cfif len(due_date)>#due_date#,<cfelse>#attributes.invoice_date#,</cfif>
            <cfelse>
				<cfif len(pay_met_id)>#pay_met_id#<cfelse>NULL</cfif>,
                <cfif isDefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>#attributes.card_paymethod_id#<cfelse>NULL</cfif>,
				<cfif len(due_date)>#due_date#,<cfelse>#attributes.invoice_date#,</cfif>
            </cfif>
			1,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice_other_money#">,
			<!---<cfif len(GET_BILLED_INFO.MONEY_TYPE)>'#GET_BILLED_INFO.MONEY_TYPE#'<cfelse>'#session.ep.money#'</cfif>,--->
			0,
			1,
			#FORM.PROCESS_CAT#,
			#GET_INVOICE_MULTI.MAX_ID#,
			NULL,
			<cfif isdefined("inv_profile_id") and len(inv_profile_id)>'#inv_profile_id#'<cfelse>NULL</cfif>,

			<cfif len(GET_BILLED_INFO.SALES_EMP_ID)>#GET_BILLED_INFO.SALES_EMP_ID#<cfelse>NULL</cfif>,
			<cfif len(GET_BILLED_INFO.PROJECT_ID)>#GET_BILLED_INFO.PROJECT_ID#<cfelse>NULL</cfif>,
			<cfif len(GET_BILLED_INFO.INVOICE_ADDRESS)>'#GET_BILLED_INFO.INVOICE_ADDRESS# #GET_BILLED_INFO.COUNTY_NAME# #GET_BILLED_INFO.CITY_NAME# #GET_BILLED_INFO.COUNTRY_NAME#'<cfelse>NULL</cfif>,
			<cfif len(GET_BILLED_INFO.INVOICE_ADDRESS_ID)>#GET_BILLED_INFO.INVOICE_ADDRESS_ID#<cfelse>NULL</cfif>,
			<cfif len(GET_BILLED_INFO.SUBSCRIPTION_ID)>#GET_BILLED_INFO.SUBSCRIPTION_ID#<cfelse>NULL</cfif>,
			<cfif isdefined('GET_BILLED_INFO.SALES_CONSUMER_ID') and len(GET_BILLED_INFO.SALES_CONSUMER_ID)>'#GET_BILLED_INFO.SALES_CONSUMER_ID#'<cfelse>NULL</cfif>,
			<cfif isdefined('GET_BILLED_INFO.SALES_PARTNER_ID') and len(GET_BILLED_INFO.SALES_PARTNER_ID)>'#GET_BILLED_INFO.SALES_PARTNER_ID#'<cfelse>NULL</cfif>,
			0,
			0,
			<cfif isdefined("xml_process_stage") and len(xml_process_stage)>#xml_process_stage#<cfelse>NULL</cfif>
		)
</cfquery>
<cfset get_invoice_id.max_id = MAX_ID.IDENTITYCOL>
<cfif attributes.xml_paper_no_info eq 0>
	<cfquery name="updInvoiceNo" datasource="#dsn2#">
    	UPDATE INVOICE SET SERIAL_NUMBER = NULL, SERIAL_NO = '#get_invoice_id.max_id#' WHERE INVOICE_ID = #get_invoice_id.max_id#
    </cfquery>
</cfif>
<cfquery name="GET_PAYM_PLAN_ROWS" datasource="#dsn2#">
	SELECT
		SPR.STOCK_ID,
		SPR.PRODUCT_ID,
		SPR.DETAIL,
		SPR.UNIT,
		SPR.UNIT_ID,
		SPR.DISCOUNT,
        SPR.DISCOUNT_AMOUNT,
		<cfif kdv_muaf_satis_faturasi>0<cfelse>ST.TAX</cfif> AS TAX,
		S.OTV,
		SPR.OIV_RATE,
		SPR.BSMV_RATE,
		SPR.REASON_CODE,
		ISNULL(SPR.ROW_DESCRIPTION,'') AS ROW_DESCRIPTION,
		PRODUCT_PERIOD.EXPENSE_CENTER_ID,
		PRODUCT_PERIOD.INCOME_ITEM_ID,
		PRODUCT_PERIOD.INCOME_ACTIVITY_TYPE_ID,
		SUM(QUANTITY) MIKTAR,
		SUM(AMOUNT * QUANTITY) TOPLAM_TUTAR,
		SPR.MONEY_TYPE,
		MAX(SPR.PAYMENT_DATE) as PAYMENT_DATE,
		<cfif attributes.multi_sale_grup eq 1>SPR.SUBSCRIPTION_ID<cfelse>NULL</cfif> AS SUBSCRIPTION_ID
	FROM 
		#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW SPR
		LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD ON PRODUCT_PERIOD.PRODUCT_ID = SPR.PRODUCT_ID AND PRODUCT_PERIOD.PERIOD_ID = #session.ep.period_id#
		INNER JOIN #dsn3_alias#.STOCKS S ON SPR.STOCK_ID = S.STOCK_ID
		INNER JOIN SETUP_TAX ST ON ST.TAX = S.TAX
	WHERE
		ST.TAX = S.TAX AND
		SPR.PRODUCT_ID = S.PRODUCT_ID AND
		SPR.STOCK_ID = S.STOCK_ID AND
		SUBSCRIPTION_PAYMENT_ROW_ID IN (#row_list#)
	GROUP BY
		SPR.STOCK_ID,
		SPR.PRODUCT_ID,
		SPR.DETAIL,
		SPR.UNIT,
		SPR.UNIT_ID,
		SPR.DISCOUNT,
        SPR.DISCOUNT_AMOUNT,
		<cfif kdv_muaf_satis_faturasi><cfelse>ST.TAX,</cfif>
		S.OTV,
		SPR.OIV_RATE,
		SPR.BSMV_RATE,
		SPR.REASON_CODE,
		ISNULL(SPR.ROW_DESCRIPTION,''),
		PRODUCT_PERIOD.EXPENSE_CENTER_ID,
		PRODUCT_PERIOD.INCOME_ITEM_ID,
		PRODUCT_PERIOD.INCOME_ACTIVITY_TYPE_ID,
		SPR.MONEY_TYPE,
		SUBSCRIPTION_ID
		<cfif isDefined("is_avg_price")>
			,SPR.AMOUNT
		</cfif>
</cfquery>
<cfoutput query="GET_PAYM_PLAN_ROWS">
	<cfscript>
		/* hesaplamalar revize edildi */
		attributes.currency_multiplier = 1;
		attributes.islem_currency_multiplier = 1;
		attributes.islem_currency_multiplier_for_account = 1;
		attributes.islem_currency_multiplier_2 = 1;
		rate_1 = 1;
		rate_2 = 1;

		if(isDefined("xml_money_type") and xml_money_type eq 5 and len(rate_count))
		{
			for(kk=1; kk lte rate_count; kk=kk+1)
			{
				evaluate("attributes.hidden_rd_money_#kk# = attributes.money_type_#kk#");
				evaluate("attributes.txt_rate2_#kk# = attributes.money_rate2_#kk#");
				evaluate("attributes.txt_rate1_#kk# = attributes.money_rate1_#kk#");

				if(GET_RATE_INFO.MONEY[kk] is session.ep.money2)
					attributes.currency_multiplier = (GET_RATE_INFO.RATE_INFO[kk]/GET_RATE_INFO.RATE1[kk]);
				if(GET_RATE_INFO.MONEY[kk] is invoice_other_money){
					invoice_rate1 = GET_RATE_INFO.RATE1[kk];
					invoice_rate2 = GET_RATE_INFO.RATE_INFO[kk];
					attributes.islem_currency_multiplier = (GET_RATE_INFO.RATE_INFO[kk]/GET_RATE_INFO.RATE1[kk]);
					attributes.islem_currency_multiplier_for_account = GET_RATE_INFO.RATE1[kk]/GET_RATE_INFO.RATE_INFO[kk];
				}
				if(GET_RATE_INFO.MONEY[kk] is GET_PAYM_PLAN_ROWS.MONEY_TYPE)
					attributes.islem_currency_multiplier_2 = (GET_RATE_INFO.RATE_INFO[kk]/GET_RATE_INFO.RATE1[kk]);
				
				evaluate("attributes.currency_rate_#GET_RATE_INFO.MONEY[kk]# = GET_RATE_INFO.RATE_INFO[kk]/GET_RATE_INFO.RATE1[kk]");	
			}
			for(jj=1; jj lte rate_count; jj=jj+1)
			{
				if ((GET_RATE_INFO.MONEY[jj] neq session.ep.money) and (GET_RATE_INFO.MONEY[jj] eq invoice_other_money))
				{
					rate1 = GET_RATE_INFO.RATE1[jj];
					rate2 = GET_RATE_INFO.RATE_INFO[jj];
					break;
				}
				else if((GET_RATE_INFO.MONEY[jj] eq session.ep.money2) and (invoice_other_money eq session.ep.money)) 
				{
					rate1 = GET_RATE_INFO.RATE1[jj];
					rate2 = GET_RATE_INFO.RATE_INFO[jj];
					break;
				}
			}
		}
		else
		{
			for(k=1; k lte attributes.kur_say; k=k+1)
			{
				evaluate("attributes.hidden_rd_money_#k# = attributes.money_type_#k#");
				evaluate("attributes.txt_rate2_#k# = attributes.money_rate2_#k#");
				evaluate("attributes.txt_rate1_#k# = attributes.money_rate1_#k#");

				if(evaluate("attributes.money_type_#k#") is session.ep.money2)
					attributes.currency_multiplier = evaluate('attributes.money_rate2_#k#/attributes.money_rate1_#k#');
				if(evaluate("attributes.money_type_#k#") is invoice_other_money){
					invoice_rate1 = evaluate('attributes.money_rate1_#k#');
					invoice_rate2 = evaluate('attributes.money_rate2_#k#');
					attributes.islem_currency_multiplier = evaluate('attributes.money_rate2_#k#/attributes.money_rate1_#k#');
					attributes.islem_currency_multiplier_for_account = evaluate('attributes.money_rate1_#k#/attributes.money_rate2_#k#');
				}
				if(evaluate("attributes.money_type_#k#") is GET_PAYM_PLAN_ROWS.MONEY_TYPE){
					evaluate("attributes.currency_rate_#GET_PAYM_PLAN_ROWS.MONEY_TYPE# = attributes.money_rate2_#k#/attributes.money_rate1_#k#");
					attributes.islem_currency_multiplier_2 = evaluate('attributes.money_rate2_#k#/attributes.money_rate1_#k#');
				}
					
			}
			for(k=1; k lte attributes.kur_say; k=k+1)
			{
				if ((evaluate("attributes.money_type_#k#") neq session.ep.money) and (evaluate("attributes.money_type_#k#") eq invoice_other_money))
				{
					rate1 = evaluate("attributes.money_rate1_#k#");
					rate2 = evaluate("attributes.money_rate2_#k#");
					break;
				}
				else if((evaluate("attributes.money_type_#k#") eq session.ep.money2) and (invoice_other_money eq session.ep.money)) 
				{
					rate1 = evaluate("attributes.money_rate1_#k#");
					rate2 = evaluate("attributes.money_rate2_#k#");
					break;
				}
			}
		}

		tutar_curr = wrk_round(GET_PAYM_PLAN_ROWS.TOPLAM_TUTAR / GET_PAYM_PLAN_ROWS.MIKTAR,round_num);
		tutar = wrk_round(GET_PAYM_PLAN_ROWS.TOPLAM_TUTAR / GET_PAYM_PLAN_ROWS.MIKTAR * attributes.islem_currency_multiplier_2,round_num);
		miktar = GET_PAYM_PLAN_ROWS.MIKTAR;
		toplam = tutar * miktar;
	
		if(len(GET_PAYM_PLAN_ROWS.DISCOUNT_AMOUNT)) 
			disc_amount=GET_PAYM_PLAN_ROWS.DISCOUNT_AMOUNT; 
		else 
			disc_amount = 0;
	
		toplam_indirilmis_curr = ( (tutar_curr-disc_amount) - ( (tutar_curr-disc_amount) * (GET_PAYM_PLAN_ROWS.DISCOUNT/100) ) );
		toplam_indirilmis = wrk_round(toplam_indirilmis_curr * attributes.islem_currency_multiplier_2,round_num);
		toplam_indirim = wrk_round((tutar_curr - toplam_indirilmis_curr) * attributes.islem_currency_multiplier_2,round_num);
		
		kdv_toplam_curr = toplam_indirilmis_curr * miktar * (GET_PAYM_PLAN_ROWS.TAX/100); 
		kdv_toplam = wrk_round(kdv_toplam_curr * attributes.islem_currency_multiplier_2,round_num);
	
		if (len(GET_PAYM_PLAN_ROWS.OTV))
		{
			otv_toplam_curr = wrk_round(toplam_indirilmis_curr * miktar * (GET_PAYM_PLAN_ROWS.OTV/100),round_num); 
			otv_toplam = wrk_round(otv_toplam_curr * attributes.islem_currency_multiplier_2,round_num); 
		}
		else
		{
			otv_toplam_curr = 0;
			otv_toplam = 0;
		}

		if(len(GET_PAYM_PLAN_ROWS.BSMV_RATE)){
			bsmv_toplam_curr = wrk_round(toplam_indirilmis_curr * miktar * (GET_PAYM_PLAN_ROWS.BSMV_RATE/100),round_num); 
			bsmv_toplam = wrk_round( bsmv_toplam_curr * attributes.islem_currency_multiplier_2,round_num); 
		}else{
			bsmv_toplam_curr = 0;
			bsmv_toplam = 0;
		}
		if (len(GET_PAYM_PLAN_ROWS.OIV_RATE)){
			oiv_toplam_curr = wrk_round(toplam_indirilmis_curr * miktar * (GET_PAYM_PLAN_ROWS.OIV_RATE/100),round_num); 
			oiv_toplam = wrk_round(oiv_toplam_curr * attributes.islem_currency_multiplier_2 ,round_num); 
		}else{
			oiv_toplam_curr = 0;
			oiv_toplam = 0;
		}

		other_money_tutar = ( (toplam_indirilmis_curr * miktar) + kdv_toplam_curr + otv_toplam_curr+ bsmv_toplam_curr + oiv_toplam_curr);
		kdvli_toplam = wrk_round( (toplam_indirilmis * miktar) + kdv_toplam + otv_toplam + bsmv_toplam + oiv_toplam,round_num);

	</cfscript>
	<cfif isdefined('GET_PAYM_PLAN_ROWS.REASON_CODE') and len(GET_PAYM_PLAN_ROWS.REASON_CODE)>
		<cfset reasonCode = Replace(GET_PAYM_PLAN_ROWS.REASON_CODE,'--','*')>
	<cfelse>
		<cfset reasonCode = ''>
	</cfif>
	<cfquery name="ADD_INVOICE_ROW" datasource="#dsn2#">
		INSERT INTO
			INVOICE_ROW
			(
				PURCHASE_SALES,
				PRODUCT_ID,
				NAME_PRODUCT,
				INVOICE_ID,
				STOCK_ID,
				AMOUNT,
				UNIT,
				UNIT_ID,			
				PRICE,
				DISCOUNTTOTAL,
				GROSSTOTAL,
				NETTOTAL,
				TAXTOTAL,
				TAX,
				OTVTOTAL,
				OTV_ORAN,
				DISCOUNT1,
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
				OTHER_MONEY_GROSS_TOTAL,

				PRICE_OTHER,
				COST_PRICE,
				IS_PROMOTION,
                DISCOUNT_COST,

				DUE_DATE,
				BSMV_RATE,
				BSMV_AMOUNT,
				OIV_RATE,
				OIV_AMOUNT,
				TEVKIFAT_RATE,
				TEVKIFAT_AMOUNT,
				REASON_CODE,
				REASON_NAME,
				ROW_EXP_CENTER_ID,
				ROW_EXP_ITEM_ID,
				ACTIVITY_TYPE_ID,
				SUBSCRIPTION_ID,
				PRODUCT_NAME2,
				DELIVER_DATE
			
			)
		VALUES
			(
				1,
				#GET_PAYM_PLAN_ROWS.PRODUCT_ID#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(GET_PAYM_PLAN_ROWS.DETAIL,75)#">,
				#MAX_ID.IDENTITYCOL#,
				#GET_PAYM_PLAN_ROWS.STOCK_ID#,
				#GET_PAYM_PLAN_ROWS.MIKTAR#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_PAYM_PLAN_ROWS.UNIT#">,
				#GET_PAYM_PLAN_ROWS.UNIT_ID#,	
				#tutar#,
				#toplam_indirim * miktar#,
				#kdvli_toplam#,
				#(tutar - toplam_indirim) * miktar#,
				#kdv_toplam#,
				#GET_PAYM_PLAN_ROWS.TAX#,
				#otv_toplam#,
				<cfif len(GET_PAYM_PLAN_ROWS.OTV)>#GET_PAYM_PLAN_ROWS.OTV#<cfelse>0</cfif>,
				#GET_PAYM_PLAN_ROWS.DISCOUNT#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_PAYM_PLAN_ROWS.MONEY_TYPE#">,
                #wrk_round(toplam_indirilmis_curr*miktar,round_num)#,
				#wrk_round(other_money_tutar,round_num)#,
				#wrk_round(tutar_curr,round_num)#,
				#tutar#,
				0,
                #disc_amount#,
				0,
				<cfif len(GET_PAYM_PLAN_ROWS.BSMV_RATE)>#GET_PAYM_PLAN_ROWS.BSMV_RATE#<cfelse>NULL</cfif>,
				#bsmv_toplam#,
				<cfif len(GET_PAYM_PLAN_ROWS.OIV_RATE)>#GET_PAYM_PLAN_ROWS.OIV_RATE#<cfelse>NULL</cfif>,
				#oiv_toplam#,
				NULL,
				NULL,
				<cfif len(reasonCode) and reasonCode contains '*'>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(reasonCode,'*')#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(reasonCode,'*')#">,
				<cfelse>
					NULL,
					NULL,
				</cfif>
				<cfif len(GET_PAYM_PLAN_ROWS.EXPENSE_CENTER_ID)>#GET_PAYM_PLAN_ROWS.EXPENSE_CENTER_ID#<cfelse>NULL</cfif>,
				<cfif len(GET_PAYM_PLAN_ROWS.INCOME_ITEM_ID)>#GET_PAYM_PLAN_ROWS.INCOME_ITEM_ID#<cfelse>NULL</cfif>,
				<cfif len(GET_PAYM_PLAN_ROWS.INCOME_ACTIVITY_TYPE_ID)>#GET_PAYM_PLAN_ROWS.INCOME_ACTIVITY_TYPE_ID#<cfelse>NULL</cfif>,
				<cfif len(GET_PAYM_PLAN_ROWS.SUBSCRIPTION_ID)>#GET_PAYM_PLAN_ROWS.SUBSCRIPTION_ID#<cfelse>NULL</cfif>,
				<cfif isdefined('GET_PAYM_PLAN_ROWS.ROW_DESCRIPTION') and len(GET_PAYM_PLAN_ROWS.ROW_DESCRIPTION)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_PAYM_PLAN_ROWS.ROW_DESCRIPTION#"><cfelse>NULL</cfif>,
				<cfif len(GET_PAYM_PLAN_ROWS.PAYMENT_DATE)>#CreateODBCDateTime(GET_PAYM_PLAN_ROWS.PAYMENT_DATE)#<cfelse>NULL</cfif>
			)
	</cfquery>

	<cfset tutar_main = tutar_main + tutar>
	<cfset miktar_main = miktar_main + tutar>
	<cfset toplam_main = toplam_main + toplam>
	<cfset toplam_indirim_main = toplam_indirim_main + toplam_indirim>
	<cfset kdv_toplam_main = kdv_toplam_main + kdv_toplam>
	<cfset otv_toplam_main = otv_toplam_main + otv_toplam>
	<cfset bsmv_toplam_main = bsmv_toplam_main + bsmv_toplam>
	<cfset oiv_toplam_main = oiv_toplam_main + oiv_toplam>
	<cfset kdvli_toplam_main = kdvli_toplam_main + kdvli_toplam>
	<!---<cfset other_money_tutar_main = other_money_tutar_main + other_money_tutar> --->
	<cfset other_money_tutar_main = other_money_tutar_main + ((other_money_tutar * attributes.islem_currency_multiplier_2) / attributes.islem_currency_multiplier) >
</cfoutput>

<cfquery name="UPD_INVOICE" datasource="#DSN2#">
	UPDATE INVOICE
		SET 
			GROSSTOTAL = #wrk_round(toplam_main,round_num_total)#,
			NETTOTAL = #wrk_round(kdvli_toplam_main,round_num_total)#,
			TAXTOTAL = #wrk_round(kdv_toplam_main,round_num_total)#,
			OTV_TOTAL = #wrk_round(otv_toplam_main,round_num_total)#,
			BSMV_TOTAL = #wrk_round(bsmv_toplam_main,round_num_total)#,
			OIV_TOTAL = #wrk_round(oiv_toplam_main,round_num_total)#,
			OTHER_MONEY_VALUE = #wrk_round(other_money_tutar_main,round_num_total)#,
			IS_PROCESSED = #is_account#,
			IS_ACCOUNTED = 0
		WHERE
			INVOICE_ID = #MAX_ID.IDENTITYCOL#
</cfquery>
<cfloop from="1" to="#attributes.kur_say#" index="j">
	<cfquery name="ADD_INVOICE_MONEY" datasource="#dsn2#">
		INSERT INTO
			INVOICE_MONEY
			(
				ACTION_ID,
				MONEY_TYPE,
				RATE2,
				RATE1,
				IS_SELECTED
			)
			VALUES
			(
				#MAX_ID.IDENTITYCOL#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.money_type_#j#')#">,
				#evaluate("attributes.money_rate2_#j#")#,
				#evaluate("attributes.money_rate1_#j#")#,
				<cfif (evaluate("attributes.money_type_#j#") eq invoice_other_money)>
				1
				<cfelse>
				0
				</cfif>
			)
	</cfquery>
</cfloop>
