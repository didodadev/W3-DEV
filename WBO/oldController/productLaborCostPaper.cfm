<cf_xml_page_edit fuseact="prod.product_labor_cost_paper">
<cfif fuseaction eq "account.product_labor_cost_paper" or fuseaction eq "account.autoexcelpopuppage_product_labor_cost_paper">
    <cfset labor_cost = 1>
<cfelse>
    <cfset labor_cost = 0>
</cfif>
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.start_dates" default="">
<cfparam name="attributes.finish_dates" default="">
<cfparam name="attributes.start_dates_m" default="">
<cfparam name="attributes.finish_dates_m" default="">
<cfif isdate(attributes.finish_dates)><cf_date tarih = "attributes.finish_dates"><cfelse><cfset attributes.finish_dates= date_add('d',15,wrk_get_today())></cfif>
<cfif isdate(attributes.start_dates)><cf_date tarih = "attributes.start_dates"><cfelse><cfset attributes.start_dates= date_add('d',-15,wrk_get_today())></cfif>
<cfif isdate(attributes.finish_dates_m)><cf_date tarih = "attributes.finish_dates_m"><cfelse><cfset attributes.finish_dates_m= date_add('d',15,wrk_get_today())></cfif>
<cfif isdate(attributes.start_dates_m)><cf_date tarih = "attributes.start_dates_m"><cfelse><cfset attributes.start_dates_m= date_add('d',-15,wrk_get_today())></cfif>
<cfif isdefined('attributes.form_submit')>
    <cfquery name="GET_PRODUCT_COST_PAPER" datasource="#DSN3#">
        SELECT
			STATION_ID,
			<cfif labor_cost eq 0>
				COST_TYPE,
				<cfif isdefined("attributes.act_type") and attributes.act_type eq 2>
					ACCOUNT_ID,
				<cfelse>	
					EXPENSE_ID,
				</cfif>
                YANSIMA YANSIMA,
			<cfelse>
				0 COST_TYPE,
				SUM(EXPENSED_MONEY) EXPENSED_MONEY,
				SUM(NORMAL) NORMAL,
				SUM(MESAI_NORMAL) MESAI_NORMAL,
				SUM(MESAI_HSONU) MESAI_HSONU,
				SUM(MESAI_TATIL) MESAI_TATIL,
            </cfif>
			SUM(CALISMA_DAKIKA) CALISMA_DAKIKA,
			COUNT(DISTINCT URETIM_SONUCU) URETIM_SONUCU,
			SUM(URETIM_MIKTARI) URETIM_MIKTARI,
			SUM(URETIM_MIKTARI2) URETIM_MIKTARI2,
			SUM(PRICE_PUR) PRICE_PUR
		FROM
		(			
		SELECT 
            POR.STATION_ID,
            <cfif labor_cost eq 0>
				ISNULL(WP.COST_TYPE,1) COST_TYPE,
				<cfif isdefined("attributes.act_type") and attributes.act_type eq 2>
					WP.ACCOUNT_ID,
					WP.ACCOUNT_SHIFT AS YANSIMA,
				<cfelse>
					WP.EXPENSE_ID,
					WP.EXPENSE_SHIFT AS YANSIMA,
				</cfif>
			<cfelse>
				<cfif x_cost_type eq 0>
					EXPENSED_MONEY,
					CASE WHEN (TC.OVERTIME_TYPE = 1) 
					THEN
						EXPENSED_MINUTE
					ELSE
						0
					END AS NORMAL,
					CASE WHEN (TC.OVERTIME_TYPE = 2) 
					THEN
						EXPENSED_MINUTE
					ELSE
						0
					END AS MESAI_NORMAL,
					CASE WHEN (TC.OVERTIME_TYPE = 3) 
					THEN
						EXPENSED_MINUTE
					ELSE
						0
					END AS MESAI_HSONU,
					CASE WHEN (TC.OVERTIME_TYPE = 4) 
					THEN
						EXPENSED_MINUTE
					ELSE
						0
					END AS MESAI_TATIL,
				<cfelse>
					CASE 
						WHEN (TC.OVERTIME_TYPE = 1 AND EPC.NORMAL_COST > 0 AND TOTAL_WORK_HOURS > 0) THEN EPC.NORMAL_COST / TOTAL_WORK_HOURS / 60 * EXPENSED_MINUTE
						WHEN (TC.OVERTIME_TYPE = 2 AND EPC.EXT_SALARY_NORMAL > 0) THEN EPC.EXT_SALARY_NORMAL / EXT_SALARY_NORMAL_HOURS / 60 * EXPENSED_MINUTE
						WHEN (TC.OVERTIME_TYPE = 3 AND EPC.EXT_SALARY_WEEKEND > 0) THEN EPC.EXT_SALARY_WEEKEND / EXT_SALARY_WEEKEND_HOURS / 60 * EXPENSED_MINUTE
						WHEN (TC.OVERTIME_TYPE = 4 AND EPC.EXT_SALARY_OFFDAY > 0) THEN EPC.EXT_SALARY_OFFDAY / EXT_SALARY_OFFDAY_HOURS / 60 * EXPENSED_MINUTE
						ELSE 0
						END AS EXPENSED_MONEY,					
					CASE WHEN (TC.OVERTIME_TYPE = 1) 
					THEN
						EXPENSED_MINUTE
					ELSE
						0
					END AS NORMAL,
					CASE WHEN (TC.OVERTIME_TYPE = 2) 
					THEN
						EXPENSED_MINUTE
					ELSE
						0
					END AS MESAI_NORMAL,
					CASE WHEN (TC.OVERTIME_TYPE = 3) 
					THEN
						EXPENSED_MINUTE
					ELSE
						0
					END AS MESAI_HSONU,
					CASE WHEN (TC.OVERTIME_TYPE = 4) 
					THEN
						EXPENSED_MINUTE
					ELSE
						0
					END AS MESAI_TATIL,
				</cfif>
            </cfif>
            datediff(minute,POR.START_DATE,POR.FINISH_DATE) CALISMA_DAKIKA,
            PORR.PR_ORDER_ID URETIM_SONUCU,
            PORR.AMOUNT URETIM_MIKTARI,
			ISNULL((SELECT TOP 1 PORR.AMOUNT/MULTIPLIER FROM PRODUCT_UNIT PU WHERE PU.PRODUCT_ID = PORR.PRODUCT_ID AND ADD_UNIT = W.UNIT2),0) URETIM_MIKTARI2,
			PORR.AMOUNT*ISNULL((SELECT TOP 1 PRICE*ISNULL((SELECT 
										TOP 1 RATE2
									FROM 
										#dsn_alias#.MONEY_HISTORY
									WHERE
										VALIDATE_DATE <= #attributes.finish_dates_m# AND
										MONEY = PS.MONEY
									ORDER BY 
										VALIDATE_DATE DESC),1) FROM PRICE_STANDART PS WHERE PS.PRODUCT_ID = PORR.PRODUCT_ID AND PRICESTANDART_STATUS = 1 AND PURCHASESALES = 0),0) PRICE_PUR
        FROM 
           PRODUCTION_ORDERS PO
            LEFT JOIN PRODUCTION_ORDER_RESULTS POR ON PO.P_ORDER_ID = POR.P_ORDER_ID 
           	LEFT JOIN  PRODUCTION_ORDER_RESULTS_ROW PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
            LEFT JOIN WORKSTATIONS W ON POR.STATION_ID = W.STATION_ID
            LEFT JOIN #dsn2_alias#.ACCOUNT_PLAN AP ON AP.ACCOUNT_CODE ='ACCOUNT_ID'
            <cfif labor_cost eq 0>
				LEFT JOIN WORKSTATION_PERIOD WP ON WP.STATION_ID = POR.STATION_ID
			<cfelse>
				LEFT JOIN #dsn_alias#.TIME_COST TC ON POR.PR_ORDER_ID = TC.P_ORDER_RESULT_ID
				<cfif x_cost_type eq 1>
					LEFT JOIN #dsn_alias#.EMPLOYEES_PUANTAJ_COST EPC ON TC.EMPLOYEE_ID = EPC.EMPLOYEE_ID
				</cfif>
			</cfif>
        WHERE
			<cfif labor_cost neq 0>
				TC.OUR_COMPANY_ID = #session.ep.company_id# AND
				<cfif x_cost_type eq 1>
					EPC.SAL_YEAR = YEAR(TC.EVENT_DATE) AND
					EPC.SAL_MON = MONTH(TC.EVENT_DATE) AND
				</cfif>
			</cfif>
			PORR.STOCK_ID IN(SELECT S.STOCK_ID FROM STOCKS S WHERE S.IS_COST = 1) AND
           PORR.TYPE = 1 AND
			ISNULL(PO.IS_DEMONTAJ,0) = 0 AND
            POR.STATION_ID IS NOT NULL
            <cfif labor_cost eq 0>
				<cfif isdefined("attributes.act_type") and attributes.act_type eq 1>
					AND WP.EXPENSE_SHIFT IS NOT NULL
				<cfelse>
					AND WP.ACCOUNT_ID IS NOT NULL
				</cfif>
				AND WP.PERIOD_ID = #session.ep.period_id#
			</cfif>
            <cfif len(attributes.station_id)>
            	AND POR.STATION_ID  IN (#attributes.station_id#)
            </cfif>
            <cfif len(attributes.start_dates)>AND POR.FINISH_DATE >= #attributes.start_dates# </cfif>
            <cfif len(attributes.finish_dates)>AND POR.FINISH_DATE < #date_add('d',1,attributes.finish_dates)# </cfif>
		<cfif labor_cost eq 1>
		UNION ALL
		SELECT 
            POR.STATION_ID,
			0 EXPENSED_MONEY,
			0 NORMAL,
			0 MESAI_NORMAL,
			0 MESAI_HSONU,
			0 MESAI_TATIL,
            datediff(minute,POR.START_DATE,POR.FINISH_DATE) CALISMA_DAKIKA,
            PORR.PR_ORDER_ID URETIM_SONUCU,
            PORR.AMOUNT URETIM_MIKTARI,
			ISNULL((SELECT TOP 1 PORR.AMOUNT/MULTIPLIER FROM PRODUCT_UNIT PU WHERE PU.PRODUCT_ID = PORR.PRODUCT_ID AND ADD_UNIT = W.UNIT2),0) URETIM_MIKTARI2,
			PORR.AMOUNT*ISNULL((SELECT TOP 1 PRICE*ISNULL((SELECT 
										TOP 1 RATE2
									FROM 
										#dsn_alias#.MONEY_HISTORY
									WHERE
										VALIDATE_DATE <= #attributes.finish_dates_m# AND
										MONEY = PS.MONEY
									ORDER BY 
										VALIDATE_DATE DESC),1) FROM PRICE_STANDART PS WHERE PS.PRODUCT_ID = PORR.PRODUCT_ID AND PRICESTANDART_STATUS = 1 AND PURCHASESALES = 0),0) PRICE_PUR
        FROM 
           	PRODUCTION_ORDERS PO
            LEFT JOIN PRODUCTION_ORDER_RESULTS POR ON PO.P_ORDER_ID = POR.P_ORDER_ID
            LEFT JOIN PRODUCTION_ORDER_RESULTS_ROW PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
            LEFT JOIN WORKSTATIONS W ON POR.STATION_ID = W.STATION_ID
            LEFT JOIN #dsn2_alias#.ACCOUNT_PLAN AP ON AP.ACCOUNT_CODE = 'ACCOUNT_ID'
        WHERE
           PORR.TYPE = 1 AND
			ISNULL(PO.IS_DEMONTAJ,0) = 0 AND
            POR.STATION_ID IS NOT NULL AND
			PORR.STOCK_ID IN(SELECT S.STOCK_ID FROM STOCKS S WHERE S.IS_COST = 1) AND
			POR.PR_ORDER_ID NOT IN(SELECT TC.P_ORDER_RESULT_ID FROM #dsn_alias#.TIME_COST TC WHERE TC.P_ORDER_RESULT_ID IS NOT NULL AND TC.OUR_COMPANY_ID =#session.ep.company_id#)
            <cfif len(attributes.station_id)>
            	AND POR.STATION_ID  IN (#attributes.station_id#)
            </cfif>
            <cfif len(attributes.start_dates)>AND POR.FINISH_DATE >= #attributes.start_dates# </cfif>
            <cfif len(attributes.finish_dates)>AND POR.FINISH_DATE < #date_add('d',1,attributes.finish_dates)# </cfif>
		</cfif>
		)T1
		<cfif isdefined("attributes.act_type_row")>
			<cfif attributes.act_type_row eq 1>
				WHERE COST_TYPE = 1
			<cfelse>
				WHERE COST_TYPE = 2
			</cfif>
		</cfif>
        GROUP BY 
			<cfif labor_cost eq 0>
				<cfif isdefined("attributes.act_type") and attributes.act_type eq 2>
					ACCOUNT_ID,
				<cfelse>	
					EXPENSE_ID,
				</cfif>
				YANSIMA,
				COST_TYPE,
			</cfif>
			STATION_ID
        ORDER BY 
			STATION_ID
    </cfquery>
	<cfquery name="get_prod_amount" datasource="#dsn3#">
		SELECT
			SUM(URETIM_MIKTARI) URETIM_MIKTARI,
			SUM(URETIM_MIKTARI2) URETIM_MIKTARI2,
			STATION_ID
		FROM
			(
			SELECT
				PORR.AMOUNT URETIM_MIKTARI,
				ISNULL((SELECT TOP 1 PORR.AMOUNT/MULTIPLIER FROM PRODUCT_UNIT PU WHERE PU.PRODUCT_ID = PORR.PRODUCT_ID AND ADD_UNIT = W.UNIT2),0) URETIM_MIKTARI2,
				POR.STATION_ID
			FROM 
				PRODUCTION_ORDERS PO
                LEFT JOIN PRODUCTION_ORDER_RESULTS POR ON PO.P_ORDER_ID = POR.P_ORDER_ID
                LEFT JOIN PRODUCTION_ORDER_RESULTS_ROW PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
                LEFT JOIN WORKSTATIONS W ON POR.STATION_ID = W.STATION_ID
			WHERE
				PORR.TYPE = 1 AND
				ISNULL(PO.IS_DEMONTAJ,0) = 0 AND
				PORR.STOCK_ID IN(SELECT S.STOCK_ID FROM STOCKS S WHERE S.IS_COST = 1) AND
				POR.STATION_ID IS NOT NULL
				<cfif len(attributes.station_id)>
					AND POR.STATION_ID  IN (#attributes.station_id#)
				</cfif>
				<cfif len(attributes.start_dates)>AND POR.FINISH_DATE >= #attributes.start_dates# </cfif>
				<cfif len(attributes.finish_dates)>AND POR.FINISH_DATE < #date_add('d',1,attributes.finish_dates)# </cfif>
			)T1
		GROUP BY
			STATION_ID
	</cfquery>
<cfelse>
	<cfset GET_PRODUCT_COST_PAPER.recordcount = 0>
    <cfset get_prod_amount.recordcount = 0>
</cfif>
<cfif GET_PRODUCT_COST_PAPER.recordcount>
	<cfoutput query="GET_PRODUCT_COST_PAPER">
    	<cfif isdefined("EXPENSE_ID") and isdefined('expense_center_money_vall#EXPENSE_ID#')>
        	<cfif x_reflection_type neq 0>
            	<cfquery name="GET_TOTAL_MIN" dbtype="query">
                    SELECT SUM(CALISMA_DAKIKA) CALISMA_DAKIKA FROM GET_PRODUCT_COST_PAPER WHERE EXPENSE_ID IN(#EXPENSE_ID#)
                </cfquery>
                <cfelseif isdefined("ACCOUNT_ID") and isdefined('account_code_money_vall#replace(ACCOUNT_ID,'.','_','all')#') and listlen(Evaluate('account_code_money_vall#replace(ACCOUNT_ID,'.','_','all')#'),'█')>
            		<cfif x_reflection_type neq 0>
                    	<cfquery name="GET_TOTAL_MIN" dbtype="query">
                        	SELECT SUM(CALISMA_DAKIKA) CALISMA_DAKIKA FROM GET_PRODUCT_COST_PAPER WHERE EXPENSE_ID IN(#EXPENSE_ID#)
                        </cfquery>
                    </cfif>
            </cfif>
        </cfif>
        <cfif labor_cost eq 0>
        	<cfif x_reflection_type neq 0>
            	<cfquery name="GET_TOTAL_MIN" dbtype="query">
                    SELECT SUM(CALISMA_DAKIKA) CALISMA_DAKIKA FROM GET_PRODUCT_COST_PAPER WHERE EXPENSE_ID IN(#EXPENSE_ID#)
                </cfquery>
            </cfif>
        </cfif>
	</cfoutput>
</cfif>
<script type="text/javascript">
	//document.getElementById("STATION_NAME").focus();
	function product_cost_deliver(station_id,sum_minute,sys_money_cost,sys2_money_cost,type,div_id,prod_amount,prod_amount2,cost_type,name_extra_,account_id,price_pur)
	{
		if(account_id == undefined) account_id = 0;
		if(prod_amount == undefined) prod_amount = 0;
		if(prod_amount2 == undefined) prod_amount2 = 0;
		var start_dates = "<cfoutput>#attributes.start_dates#</cfoutput>";
		var finish_dates = "<cfoutput>#attributes.finish_dates#</cfoutput>";
		var date_str = '&start_dates='+start_dates+'&finish_dates='+finish_dates+'';
		//div_id sadece güncelleme işlemi yapılacağı zaman kullanılıyor,kafanız karışmasın...
		if(type == 'deliver')//dağıt denilmiş ise üretim sonuçlarının detaylarını gösteriyor. 
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=account.emptypopup_product_cost_rate_detail_ajax'+date_str+'&x_reflection_type=#x_reflection_type#&x_cost_type=#x_cost_type#&labor_cost=#labor_cost#</cfoutput>&cost_type='+cost_type+'&prod_amount2='+prod_amount2+'&prod_amount='+prod_amount+'&sys_money_cost='+sys_money_cost+'&sys2_money_cost='+sys2_money_cost+'&sum_minute='+sum_minute+'&station_id='+station_id+'&account_id='+account_id+'&prod_price='+price_pur+'','product_cost_deliver_div_'+station_id+'_'+name_extra_+'',1);
		else //eğer type deliver değilse  dağıtılmış olan üretim sonucuna ait bir yansıtma yapılacağını gösteriyor..
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=account.emptypopup_product_cost_rate_detail_ajax'+date_str+'&x_reflection_type=#x_reflection_type#&x_cost_type=#x_cost_type#&labor_cost=#labor_cost#</cfoutput>&cost_type='+cost_type+'&prod_amount2='+prod_amount2+'&prod_amount='+prod_amount+'&result_no='+sys_money_cost+'&pr_order_id='+station_id+'&station_reflection_cost='+sum_minute+'&prod_price='+price_pur+'',div_id,1);//burdaki station_id değeri pr_order_id'yi ve sum_minute değeride  station_reflection_cost'i ifade eder...
	}
</script>
<cfscript>
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.product_labor_cost_paper';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/product_cost_rate_paper.cfm';
</cfscript>
