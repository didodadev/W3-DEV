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
<cfscript>
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
			evaluate("attributes.hidden_rd_money_#kk# =  GET_RATE_INFO.MONEY[kk]");
			evaluate("attributes.txt_rate2_#kk# = GET_RATE_INFO.RATE_INFO[kk]");
			evaluate("attributes.txt_rate1_#kk# = GET_RATE_INFO.RATE1[kk]");

			if(GET_RATE_INFO.MONEY[kk] is session.ep.money2){
				attributes.currency_multiplier = (GET_RATE_INFO.RATE_INFO[kk]/GET_RATE_INFO.RATE1[kk]);
			}
			if(GET_RATE_INFO.MONEY[kk] is invoice_other_money){
				invoice_rate1 = GET_RATE_INFO.RATE1[kk];
				invoice_rate2 = GET_RATE_INFO.RATE_INFO[kk];
				attributes.islem_currency_multiplier = (GET_RATE_INFO.RATE_INFO[kk]/GET_RATE_INFO.RATE1[kk]);
				attributes.islem_currency_multiplier_for_account = GET_RATE_INFO.RATE1[kk]/GET_RATE_INFO.RATE_INFO[kk];
			}
			if(GET_RATE_INFO.MONEY[kk] is GET_BILLED_INFO.MONEY_TYPE){
				attributes.islem_currency_multiplier_2 = (GET_RATE_INFO.RATE_INFO[kk]/GET_RATE_INFO.RATE1[kk]);
			}
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

			if(evaluate("attributes.money_type_#k#") is session.ep.money2){
				attributes.currency_multiplier = evaluate('attributes.money_rate2_#k#/attributes.money_rate1_#k#');
			}
			if(evaluate("attributes.money_type_#k#") is invoice_other_money){
				invoice_rate1 = evaluate('attributes.money_rate2_#1#');
				invoice_rate2 = evaluate('attributes.money_rate2_#k#');
				attributes.islem_currency_multiplier = evaluate('attributes.money_rate2_#k#/attributes.money_rate1_#k#');
				attributes.islem_currency_multiplier_for_account = evaluate('attributes.money_rate1_#k#/attributes.money_rate2_#k#');
			}
			if(evaluate("attributes.money_type_#k#") is GET_BILLED_INFO.MONEY_TYPE){
				evaluate("attributes.currency_rate_#GET_BILLED_INFO.MONEY_TYPE# = attributes.money_rate2_#k#/attributes.money_rate1_#k#");		
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
	/* hesaplamalar revize edildi */
	tutar = wrk_round(GET_BILLED_INFO.AMOUNT * attributes.islem_currency_multiplier_2,round_num);
	miktar = GET_BILLED_INFO.QUANTITY;
	toplam = tutar * miktar;
	disc_amount=GET_BILLED_INFO.DISCOUNT_AMOUNT; 

	toplam_indirilmis_curr = ( (GET_BILLED_INFO.AMOUNT-disc_amount) - ( (GET_BILLED_INFO.AMOUNT-disc_amount) * (GET_BILLED_INFO.DISCOUNT/100) ) );
	toplam_indirilmis = wrk_round(toplam_indirilmis_curr * attributes.islem_currency_multiplier_2,round_num);
	toplam_indirim = wrk_round((GET_BILLED_INFO.AMOUNT - toplam_indirilmis_curr) * attributes.islem_currency_multiplier_2,round_num);
	
	kdv_toplam_curr = toplam_indirilmis_curr * miktar * (GET_BILLED_INFO.TAX/100); 
	kdv_toplam = wrk_round(kdv_toplam_curr * attributes.islem_currency_multiplier_2,round_num);

	if (len(GET_BILLED_INFO.OTV))
	{
		otv_toplam_curr = wrk_round(toplam_indirilmis_curr * miktar * (GET_BILLED_INFO.OTV/100),round_num);
		otv_toplam = wrk_round(otv_toplam_curr * attributes.islem_currency_multiplier_2,round_num); 
	}
	else
	{
		otv_toplam_curr = 0;
		otv_toplam = 0;
	}
	if (len(GET_BILLED_INFO.BSMV_RATE)){
		bsmv_toplam_curr = wrk_round(toplam_indirilmis_curr * miktar * (GET_BILLED_INFO.BSMV_RATE/100),round_num); 
		bsmv_toplam = wrk_round( bsmv_toplam_curr * attributes.islem_currency_multiplier_2,round_num); 
	}else{
		bsmv_toplam_curr = 0;
		bsmv_toplam = 0;
	}
	if (len(GET_BILLED_INFO.OIV_RATE)){
		oiv_toplam_curr = wrk_round(toplam_indirilmis_curr * miktar * (GET_BILLED_INFO.OIV_RATE/100),round_num);
		oiv_toplam = wrk_round(oiv_toplam_curr * attributes.islem_currency_multiplier_2 ,round_num); 
	}else{
		oiv_toplam_curr = 0;
		oiv_toplam = 0;
	}
	other_money_tutar = ( (toplam_indirilmis_curr * miktar) + kdv_toplam_curr + otv_toplam_curr + bsmv_toplam_curr + oiv_toplam_curr);
	kdvli_toplam =  wrk_round( (toplam_indirilmis * miktar) + kdv_toplam + otv_toplam + bsmv_toplam + oiv_toplam,round_num);
	kdvli_toplam_account = kdvli_toplam;
	other_money_tutar_account = other_money_tutar;
	///İşlem tipinde BSMV'yi giderleştir seçiliyse, BSMV tutarı net totalden düşülür
	if( is_expensing_bsmv == 1 and bsmv_toplam neq 0 ){
		kdvli_toplam_account -= bsmv_toplam;
		other_money_tutar_account -= bsmv_toplam_curr;
	}
</cfscript>
<cfset due_date = "">
<cfif len(GET_BILLED_INFO.PAYMETHOD_ID)>
	<!---VADE YÖNTEMİNE GÖRE VADE TARİHİ BULUNUYOR AYNI ÖDEME YÖNTEMLERİ İÇİN FONKSİYON TEKRAR ÇAĞIRILMAYABİLİR--->	
	<cfset paymethod_calc =  paymethod_comp.calc_duedate(action_date:dateformat(attributes.invoice_date,dateformat_style), paymethod_id:GET_BILLED_INFO.PAYMETHOD_ID,transaction_dsn:dsn2)>
	<cfif isdefined("paymethod_calc.due_date") and len(paymethod_calc.due_date)>
		<cf_date tarih="paymethod_calc.due_date">
		<cfset due_date = paymethod_calc.due_date>
	<cfelse>
		<cfset due_date = attributes.invoice_date>
	</cfif>
<cfelse>
	<cfset due_date = attributes.invoice_date>
</cfif> 

<cfif (GET_BILLED_INFO.PAYMENT_DATE neq pre_payment_date) or
		(GET_BILLED_INFO.SUBSCRIPTION_ID neq pre_subs_id and attributes.multi_sale_grup eq 1) or
		(GET_BILLED_INFO.INVOICE_COMPANY_ID neq pre_comp_id) or
        (GET_BILLED_INFO.INVOICE_CONSUMER_ID neq pre_cons_id) or
		(GET_BILLED_INFO.PAYMETHOD_ID neq pre_pay_type) or
		(GET_BILLED_INFO.CARD_PAYMETHOD_ID neq pre_card_type) or
		(invoice_other_money neq pre_money_type)>

	<cfset tutar_main = 0><!--- her sistem,tarih vs değiştiği zaman ana tutarlar sıfırlancaklar --->
	<cfset miktar_main = 0>
	<cfset toplam_main = 0>
	<cfset toplam_indirim_main = 0>
	<cfset kdv_toplam_main = 0>
	<cfset otv_toplam_main = 0>
    <cfset bsmv_toplam_main = 0>
    <cfset oiv_toplam_main = 0>
	<cfset kdvli_toplam_main = 0>
	<cfset kdvli_toplam_main_account = 0>
	<cfset other_money_tutar_main = 0>
	<cfset other_money_tutar_main_account = 0>
	
	<cfquery name="ADD_INVOICE_SALE" datasource="#dsn2#">
		INSERT INTO
			INVOICE
			(
				WRK_ID,
				PURCHASE_SALES,
				SERIAL_NUMBER,
				SERIAL_NO,
				INVOICE_NUMBER,
				INVOICE_CAT,
				INVOICE_DATE,
                SHIP_DATE,
				DUE_DATE,
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
				UPD_STATUS,
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
				IS_WITH_SHIP,
				PROCESS_CAT,
				INVOICE_MULTI_ID,
				SALE_EMP,
				NOTE,
				PROJECT_ID,
				SHIP_ADDRESS,
				SHIP_ADDRESS_ID,
                SUBSCRIPTION_ID,
				PROFILE_ID,
				SALES_CONSUMER_ID,
				SALES_PARTNER_ID,
                BSMV_TOTAL,
				OIV_TOTAL,
				PROCESS_STAGE
			)
		VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
				1,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(attributes.serial_number,'-')#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#replace(attributes.invoice_number,'#listfirst(attributes.serial_number,'-')#-','')#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoice_number#">,
				#INVOICE_CAT#,
				#attributes.invoice_date#,
                #attributes.invoice_date#,
				<cfif len(due_date)>#due_date#,<cfelse>NULL,</cfif>
				<cfif len(GET_BILLED_INFO.INVOICE_COMPANY_ID)>
					#GET_BILLED_INFO.INVOICE_COMPANY_ID#,
					<cfif len(GET_BILLED_INFO.INVOICE_PARTNER_ID)>#GET_BILLED_INFO.INVOICE_PARTNER_ID#,<cfelse>NULL,</cfif>
					NULL,
				<cfelse>
					NULL,
					NULL,
					#GET_BILLED_INFO.INVOICE_CONSUMER_ID#,
				</cfif>
				#kdvli_toplam#,
				#toplam#,
				#kdv_toplam#,
				#otv_toplam#,
				0,
				#attributes.department_id#,
				#attributes.location_id#,
				#NOW()#,
				#SESSION.EP.USERID#,
				<cfif len(GET_BILLED_INFO.PAYMETHOD_ID)>#GET_BILLED_INFO.PAYMETHOD_ID#<cfelse>NULL</cfif>,
				<cfif len(GET_BILLED_INFO.CARD_PAYMETHOD_ID)>#GET_BILLED_INFO.CARD_PAYMETHOD_ID#<cfelse>NULL</cfif>,
				1,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice_other_money#">,
				#other_money_tutar#,
				1,
				#FORM.PROCESS_CAT#,
				#GET_INVOICE_MULTI.MAX_ID#,
				<cfif len(GET_BILLED_INFO.SALES_EMP_ID)>#GET_BILLED_INFO.SALES_EMP_ID#<cfelse>NULL</cfif>,
				<cfif len(GET_BILLED_INFO.SUBSCRIPTION_INVOICE_DETAIL) and attributes.multi_sale_grup eq 1><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_BILLED_INFO.SUBSCRIPTION_INVOICE_DETAIL#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="(#Month(GET_BILLED_INFO.PAYMENT_DATE)#.AY FATURASI)"></cfif>,
				<cfif len(GET_BILLED_INFO.PROJECT_ID)>#GET_BILLED_INFO.PROJECT_ID#<cfelse>NULL</cfif>,
				<cfif len(GET_BILLED_INFO.INVOICE_ADDRESS)>'#GET_BILLED_INFO.INVOICE_ADDRESS# #GET_BILLED_INFO.COUNTY_NAME# #GET_BILLED_INFO.CITY_NAME# #GET_BILLED_INFO.COUNTRY_NAME#'<cfelse>NULL</cfif>,
				<cfif len(GET_BILLED_INFO.INVOICE_ADDRESS_ID)>#GET_BILLED_INFO.INVOICE_ADDRESS_ID#<cfelse>NULL</cfif>,
                <cfif len(GET_BILLED_INFO.SUBSCRIPTION_ID)>#GET_BILLED_INFO.SUBSCRIPTION_ID#<cfelse>NULL</cfif>,
				<cfif len(GET_BILLED_INFO.PROFILE_ID)>'#GET_BILLED_INFO.PROFILE_ID#'<cfelseif len(inv_profile_id)>'#inv_profile_id#'<cfelse>NULL</cfif>,
				<cfif isdefined('GET_BILLED_INFO.SALES_CONSUMER_ID') and len(GET_BILLED_INFO.SALES_CONSUMER_ID)>'#GET_BILLED_INFO.SALES_CONSUMER_ID#'<cfelse>NULL</cfif>,
				<cfif isdefined('GET_BILLED_INFO.SALES_PARTNER_ID') and len(GET_BILLED_INFO.SALES_PARTNER_ID)>'#GET_BILLED_INFO.SALES_PARTNER_ID#'<cfelse>NULL</cfif>,
                #bsmv_toplam#,
				#oiv_toplam#,
				<cfif isdefined("xml_process_stage") and len(xml_process_stage)>#xml_process_stage#<cfelse>NULL</cfif>
			)
	</cfquery>
	<cfquery name="GET_INVOICE_ID" datasource="#dsn2#">
		SELECT MAX(INVOICE_ID) AS MAX_ID FROM INVOICE WHERE WRK_ID = '#wrk_id#'
	</cfquery>
</cfif>
<cfif isdefined('GET_BILLED_INFO.REASON_CODE') and len(GET_BILLED_INFO.REASON_CODE)>
	<cfset reasonCode = Replace(GET_BILLED_INFO.REASON_CODE,'--','*')>
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
			DISCOUNT_COST,
			OTHER_MONEY,
			OTHER_MONEY_VALUE,
			OTHER_MONEY_GROSS_TOTAL,
			PRICE_OTHER,
			DUE_DATE,
			COST_PRICE,
			IS_PROMOTION,
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
			#GET_BILLED_INFO.PRODUCT_ID#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(GET_BILLED_INFO.DETAIL,150)#">,
			#get_invoice_id.max_id#,
			#GET_BILLED_INFO.STOCK_ID#,
			#GET_BILLED_INFO.QUANTITY#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_BILLED_INFO.UNIT#">,
			#GET_BILLED_INFO.PRODUCT_UNIT_ID#,	
			#tutar#,
			#toplam_indirim * miktar#,
			#kdvli_toplam#,
			#(tutar - toplam_indirim) * miktar#,
			#kdv_toplam#,
			#GET_BILLED_INFO.TAX#,
			#otv_toplam#,
			<cfif len(GET_BILLED_INFO.OTV)>#GET_BILLED_INFO.OTV#<cfelse>0</cfif>,
			#GET_BILLED_INFO.DISCOUNT#,
			#disc_amount#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_BILLED_INFO.MONEY_TYPE#">,
			#wrk_round(toplam_indirilmis_curr * miktar,round_num)#,
			#wrk_round(other_money_tutar,round_num)#,
			#GET_BILLED_INFO.AMOUNT#,
			0,
			0,
			0,
			<cfif len(GET_BILLED_INFO.BSMV_RATE)>#GET_BILLED_INFO.BSMV_RATE#<cfelse>NULL</cfif>,
			#bsmv_toplam#,
			<cfif len(GET_BILLED_INFO.OIV_RATE)>#GET_BILLED_INFO.OIV_RATE#<cfelse>NULL</cfif>,
			#oiv_toplam#,
			<cfif len(GET_BILLED_INFO.TEVKIFAT_RATE)>#GET_BILLED_INFO.TEVKIFAT_RATE#<cfelse>NULL</cfif>,
			<cfif len(GET_BILLED_INFO.TEVKIFAT_AMOUNT)>#GET_BILLED_INFO.TEVKIFAT_AMOUNT#<cfelse>NULL</cfif>,
			<cfif len(reasonCode) and reasonCode contains '*'>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(reasonCode,'*')#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(reasonCode,'*')#">,
			<cfelse>
				NULL,
				NULL,
			</cfif>
			<cfif len(GET_BILLED_INFO.EXPENSE_CENTER_ID)>#GET_BILLED_INFO.EXPENSE_CENTER_ID#<cfelse>NULL</cfif>,
			<cfif len(GET_BILLED_INFO.INCOME_ITEM_ID)>#GET_BILLED_INFO.INCOME_ITEM_ID#<cfelse>NULL</cfif>,
			<cfif len(GET_BILLED_INFO.INCOME_ACTIVITY_TYPE_ID)>#GET_BILLED_INFO.INCOME_ACTIVITY_TYPE_ID#<cfelse>NULL</cfif>,
            <cfif len(GET_BILLED_INFO.SUBSCRIPTION_ID)>#GET_BILLED_INFO.SUBSCRIPTION_ID#<cfelse>NULL</cfif>,
			<cfif isdefined('GET_BILLED_INFO.ROW_DESCRIPTION') and len(GET_BILLED_INFO.ROW_DESCRIPTION)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_BILLED_INFO.ROW_DESCRIPTION#"><cfelse>NULL</cfif>,
			<cfif len(GET_BILLED_INFO.PAYMENT_DATE)>#CreateODBCDateTime(GET_BILLED_INFO.PAYMENT_DATE)#<cfelse>NULL</cfif>
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
<cfset kdvli_toplam_main_account = kdvli_toplam_main_account + kdvli_toplam_account>
<!--- <cfset other_money_tutar_main = other_money_tutar_main + other_money_tutar> --->
<cfset other_money_tutar_main = other_money_tutar_main + ((other_money_tutar * attributes.islem_currency_multiplier_2) / attributes.islem_currency_multiplier) >
<cfset other_money_tutar_main_account = other_money_tutar_main_account + ((other_money_tutar_account * attributes.islem_currency_multiplier_2) / attributes.islem_currency_multiplier) >