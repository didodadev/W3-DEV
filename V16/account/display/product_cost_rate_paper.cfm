<cf_xml_page_edit fuseact="prod.product_labor_cost_paper">
<cfif fuseaction eq "account.product_labor_cost_paper" or fuseaction eq "account.autoexcelpopuppage_product_labor_cost_paper">
	<cfset labor_cost = 1>
	<cfset more = 0>
<cfelse>
	<cfset labor_cost = 0>
	<cfset more = 1>
</cfif>
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.start_dates" default="">
<cfparam name="attributes.finish_dates" default="">
<cfparam name="attributes.start_dates_m" default="">
<cfparam name="attributes.finish_dates_m" default="">
<cfparam name="attributes.act_type" default="">
<cfparam name="expense_id" default="">
<cfparam name="yansıma" default="">
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
            W.STATION_ID,
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
            PRODUCTION_ORDERS PO,
            PRODUCTION_ORDER_RESULTS POR,
            PRODUCTION_ORDER_RESULTS_ROW PORR,
            <cfif labor_cost eq 0>
				WORKSTATION_PERIOD WP,
			<cfelse>
				#dsn_alias#.TIME_COST TC,
				<cfif x_cost_type eq 1>
					#dsn_alias#.EMPLOYEES_PUANTAJ_COST EPC,
				</cfif>
			</cfif>
            WORKSTATIONS W
        WHERE
			<cfif labor_cost eq 0>
				CONCAT(',',WP.STATION_ID,',') LIKE  CONCAT('%,',POR.STATION_ID,',%') AND
				--WP.STATION_ID = POR.STATION_ID AND
			<cfelse>
				POR.PR_ORDER_ID = TC.P_ORDER_RESULT_ID AND
				TC.OUR_COMPANY_ID = #session.ep.company_id# AND
				<cfif x_cost_type eq 1>
					TC.EMPLOYEE_ID = EPC.EMPLOYEE_ID AND
					EPC.SAL_YEAR = YEAR(TC.EVENT_DATE) AND
					EPC.SAL_MON = MONTH(TC.EVENT_DATE) AND
				</cfif>
			</cfif>
			PORR.STOCK_ID IN(SELECT S.STOCK_ID FROM STOCKS S WHERE S.IS_COST = 1) AND
            POR.STATION_ID = W.STATION_ID AND
            PO.P_ORDER_ID = POR.P_ORDER_ID AND
            POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND 
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
            PRODUCTION_ORDERS PO,
            PRODUCTION_ORDER_RESULTS POR,
            PRODUCTION_ORDER_RESULTS_ROW PORR,
            WORKSTATIONS W
        WHERE
            POR.STATION_ID = W.STATION_ID AND
            PO.P_ORDER_ID = POR.P_ORDER_ID AND
            POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND 
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
	<!---
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
				PRODUCTION_ORDERS PO,
				PRODUCTION_ORDER_RESULTS POR,
				PRODUCTION_ORDER_RESULTS_ROW PORR,
				WORKSTATIONS W
			WHERE
				POR.STATION_ID = W.STATION_ID AND
				PO.P_ORDER_ID = POR.P_ORDER_ID AND
				POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND 
                PO.STOCK_ID = PORR.STOCK_ID AND
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
	<cfif get_prod_amount.recordcount>
		<cfloop query="get_prod_amount">
			<cfset 'uretim_miktarı_#station_id#' = URETIM_MIKTARI>
			<cfset 'uretim_miktarı2_#station_id#' = URETIM_MIKTARI2>
		</cfloop>
	</cfif>	
	--->
	<cfif labor_cost eq 0>
		<cfif isdefined("attributes.act_type") and attributes.act_type eq 2>
			<cfset account_list=''>
			<cfoutput query="GET_PRODUCT_COST_PAPER">
				<cfif len(account_id) and not listfind(account_list,account_id)>
					<cfset account_list=listappend(account_list,"'#account_id#'")>
				</cfif>
			</cfoutput>
			<cfset account_list=listsort(listdeleteduplicates(account_list,','),'text','ASC',',')>
			<cfif len(account_list)>
				<cfquery name="get_acc_name" datasource="#dsn2#">
					SELECT ACCOUNT_CODE,ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE IN (#PreserveSingleQuotes(account_list)#)
				</cfquery>
				<cfquery name="GET_ACCOUNT_CODE_M" datasource="#DSN2#">
					SELECT
						SUM(SYSTEM_MONEY_PRICE) SYSTEM_MONEY_PRICE,
						SUM(SYSTEM_OTHER_MONEY_PRICE) SYSTEM_OTHER_MONEY_PRICE,
						ACCOUNT_CODE
					FROM
					(
						SELECT
							SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS SYSTEM_MONEY_PRICE, 
							SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2 - ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS SYSTEM_OTHER_MONEY_PRICE, 
							ACCOUNT_PLAN.ACCOUNT_CODE
						FROM
							ACCOUNT_PLAN
							LEFT JOIN ACCOUNT_ACCOUNT_REMAINDER ON 
							(
								((ACCOUNT_PLAN.SUB_ACCOUNT=1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'.%') OR
								(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE))
								<cfif len(attributes.start_dates_m)>AND ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE >=#attributes.start_dates_m#</cfif>
								<cfif len(attributes.finish_dates_m)>AND ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE <= #attributes.finish_dates_m#</cfif>
								AND CARD_TYPE <> 19
							)
						WHERE
							ACCOUNT_PLAN.ACCOUNT_CODE IN (#PreserveSingleQuotes(account_list)#)								
						GROUP BY
							ACCOUNT_PLAN.ACCOUNT_CODE
					)T1
					GROUP BY
						ACCOUNT_CODE
				</cfquery>
				<cfloop query="get_acc_name"><cfset 'account_name_#replace(ACCOUNT_CODE,'.','_','all')#' = "#ACCOUNT_CODE# - #ACCOUNT_NAME#"></cfloop>
				<cfloop query="GET_ACCOUNT_CODE_M">
					<cfset 'account_code_money_vall#replace(ACCOUNT_CODE,'.','_','all')#' = '#SYSTEM_MONEY_PRICE#█#SYSTEM_OTHER_MONEY_PRICE#'>
                </cfloop>
			</cfif>
		<cfelse>	
			<cfset expense_id_list = listdeleteduplicates(ValueList(GET_PRODUCT_COST_PAPER.EXPENSE_ID,','))>
			<cfif len(expense_id_list)>
				<cfquery name="get_expense_name" datasource="#dsn2#">
					SELECT EXPENSE_ID,EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_id_list#)
				</cfquery>
				<cfquery name="GET_EXPENSE_CENTER_M" datasource="#DSN2#">
					SELECT
						SUM(SYSTEM_MONEY_PRICE) SYSTEM_MONEY_PRICE,
						SUM(SYSTEM_OTHER_MONEY_PRICE) SYSTEM_OTHER_MONEY_PRICE,
						EXPENSE_ID
					FROM
					(
						SELECT 
							SUM(EIR.QUANTITY*EIR.AMOUNT)AS SYSTEM_MONEY_PRICE,
							SUM(EIR.OTHER_MONEY_VALUE_2) AS SYSTEM_OTHER_MONEY_PRICE,
							EC.EXPENSE_ID
						FROM 
							EXPENSE_ITEMS_ROWS EIR,
							EXPENSE_CENTER EC
						WHERE 
							EIR.IS_INCOME = 0 AND
							EC.EXPENSE_ID = EIR.EXPENSE_CENTER_ID
							AND EIR.EXPENSE_CENTER_ID IN (#expense_id_list#)
							<cfif len(attributes.start_dates_m)>AND EIR.EXPENSE_DATE >=#attributes.start_dates_m#</cfif>
							<cfif len(attributes.finish_dates_m)>AND EIR.EXPENSE_DATE <= #attributes.finish_dates_m#</cfif>
						GROUP BY EC.EXPENSE_ID
						<cfif x_income_cost eq 1>
							UNION ALL
							SELECT 
								SUM(-1*EIR.QUANTITY*EIR.AMOUNT)AS SYSTEM_MONEY_PRICE,
								SUM(-1*EIR.OTHER_MONEY_VALUE_2) AS SYSTEM_OTHER_MONEY_PRICE,
								EC.EXPENSE_ID
							FROM 
								EXPENSE_ITEMS_ROWS EIR,
								EXPENSE_CENTER EC
							WHERE 
								EIR.IS_INCOME = 1 AND
								EC.EXPENSE_ID = EIR.EXPENSE_CENTER_ID
								AND EIR.EXPENSE_CENTER_ID IN (#expense_id_list#)
								<cfif len(attributes.start_dates_m)>AND EIR.EXPENSE_DATE >=#attributes.start_dates_m#</cfif>
								<cfif len(attributes.finish_dates_m)>AND EIR.EXPENSE_DATE <= #attributes.finish_dates_m#</cfif>
							GROUP BY EC.EXPENSE_ID
						</cfif>
					)T1
					GROUP BY
						EXPENSE_ID
				</cfquery>
				<cfloop query="get_expense_name"><cfset 'expense_name_#EXPENSE_ID#' = EXPENSE></cfloop>
				<cfloop query="GET_EXPENSE_CENTER_M"><cfset 'expense_center_money_vall#EXPENSE_ID#' = '#SYSTEM_MONEY_PRICE#█#SYSTEM_OTHER_MONEY_PRICE#'></cfloop>
			</cfif>
		</cfif>
	</cfif>
<cfelse>
	<cfset GET_PRODUCT_COST_PAPER.recordcount = 0>
</cfif>
<cfsavecontent variable="title_">
	<cfif labor_cost eq 1>
        <cf_get_lang dictionary_id="47550.Üretim İşçilik Maliyetleri Yansıtma">
    <cfelse>
       <cf_get_lang dictionary_id="47549.Üretim Maliyetleri Yansıtma">
    </cfif>
</cfsavecontent>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_product_cost_rate" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
			<input type="hidden" name="form_submit" id="form_submit" value="1">
			<input type="hidden" name="maxrows" id="maxrows" value="<cfoutput>#session.ep.maxrows#</cfoutput>">
			<cf_box_search more="#more#">
				<div class="form-group large">
					<cf_multiselect_check 
						table_name="WORKSTATIONS"  
						name="STATION_ID"
						data_source="#dsn3#"
						width="150" 
						option_name="STATION_NAME" 
						option_value="STATION_ID" 
						value="#attributes.STATION_ID#" 
						option_text="#getLang(1676,'İstasyonlar',29473)#">
				</div>
				<cfif labor_cost eq 0>
					<div class="form-group">
						<select name="act_type" id="act_type">
							<option value="1" <cfif isdefined("attributes.act_type") and attributes.act_type eq 1>selected</cfif>><cf_get_lang dictionary_id="58460.Masraf Merkezi"></option>
							<option value="2" <cfif isdefined("attributes.act_type") and attributes.act_type eq 2>selected</cfif>><cf_get_lang dictionary_id="58811.Muhasebe Kodu"></option>
						</select>
					</div>
					<div class="form-group">
						<select name="act_type_row" id="act_type_row">
							<option value="1" <cfif isdefined("attributes.act_type_row") and attributes.act_type_row eq 1>selected</cfif>><cf_get_lang dictionary_id="34149.Genel Üretim"></option>
							<option value="2" <cfif isdefined("attributes.act_type_row") and attributes.act_type_row eq 2>selected</cfif>><cf_get_lang dictionary_id="57784.İşçilik"></option>
						</select>
					</div>
				</cfif>
				<cfoutput>
					<cfset attributes.start_dates =#dateformat(attributes.start_dates,dateformat_style)#>
					<cfset attributes.finish_dates =#dateformat(attributes.finish_dates,dateformat_style)#>
					<cfset attributes.start_dates_m =#dateformat(attributes.start_dates_m,dateformat_style)#>
					<cfset attributes.finish_dates_m =#dateformat(attributes.finish_dates_m,dateformat_style)#>
					<cfif labor_cost eq 1>
						<div class="form-group">
							<div class="input-group">
								<cfinput type="text" name="start_dates" id="start_dates" maxlength="10" value="#attributes.start_dates#" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_dates"></span>
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<cfinput type="text" name="finish_dates" id="finish_dates" maxlength="10" value="#attributes.finish_dates#" style="width:65px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_dates"></span>
							</div>
						</div>
					</cfif>
				</cfoutput>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel='1'>
				</div>
			</cf_box_search>
			<cfif labor_cost eq 0>
				<cf_box_search_detail>
					<cfoutput>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-dates">
								<label class="col col-12"><cf_get_lang dictionary_id="47535.Üretim Tarih Aralığı"></label>
								<div class="col col-12">
									<div class="input-group">
										<cfinput type="text" name="start_dates" id="start_dates" maxlength="10" value="#attributes.start_dates#" style="width:65px;">
										<span class="input-group-addon"><cf_wrk_date_image date_field="start_dates"></span>
										<span class="input-group-addon no-bg"></span>
										<cfinput type="text" name="finish_dates" id="finish_dates" maxlength="10" value="#attributes.finish_dates#" style="width:65px;">
										<span class="input-group-addon"><cf_wrk_date_image date_field="finish_dates"></span>
									</div>
								</div>
							</div>						
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-m_dates">
								<label class="col col-12"><cf_get_lang dictionary_id="47536.Masraf Merkezi Tarih Aralığı"></label>
								<div class="col col-12">
									<div class="input-group">
										<cfinput type="text" name="start_dates_m" id="start_dates_m" maxlength="10" value="#attributes.start_dates_m#" style="width:65px;">																				
										<span class="input-group-addon"><cf_wrk_date_image date_field="start_dates_m"></span>
										<span class="input-group-addon no-bg"></span>	
										<cfinput type="text" name="finish_dates_m" id="finish_dates_m" maxlength="10" value="#attributes.finish_dates_m#" style="width:65px;">
										<span class="input-group-addon"><cf_wrk_date_image date_field="finish_dates_m"></span>										
									</div>
								</div>
							</div>						
						</div>
					</cfoutput>
				</cf_box_search_detail>
			</cfif>
		</cfform>
	</cf_box>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id="47537.Üretim İşçiliklere Göre İş İstasyonu Maliyetleri"></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_grid_list> 
			<thead>
				<tr>
					<th width="20"></th>
					<th><cf_get_lang dictionary_id='58834.İstasyon'></th>
					<cfif labor_cost eq 0>
						<th><cf_get_lang dictionary_id="47538.Dağıtım Anahtarı"></th>
					</cfif>
					<th><cf_get_lang dictionary_id="47539.Çalisma Saati"></th>
					<cfif labor_cost eq 1>
						<th><cf_get_lang dictionary_id="47540.Fazla Mesai(Normal)"></th>
						<th><cf_get_lang dictionary_id="47541.Fazla Mesai(H.Tatili)"></th>
						<th><cf_get_lang dictionary_id="47542.Fazla Mesai (G.Tatil)"></th>
					</cfif>
					<th><cf_get_lang dictionary_id="29651.Üretim Sonucu"></th>
					<th><cf_get_lang dictionary_id="47543.Üretim Miktari"></th>
					<cfif labor_cost eq 0>
						<cfif isdefined("attributes.act_type") and attributes.act_type eq 2>
							<th><cf_get_lang dictionary_id="58811.Muhasebe Kodu"></th>
						<cfelse>	
							<th><cf_get_lang dictionary_id="58460.Masraf Merkezi"></th>
						</cfif>
						<th><cf_get_lang dictionary_id="47544.Harcama"><cfoutput>#session.ep.money#</cfoutput></th>
						<th><cf_get_lang dictionary_id="47544.Harcama"><cfoutput>#session.ep.money2#</cfoutput></th>
						<th><cf_get_lang dictionary_id="47545.Yansima"></th>
					</cfif>
					<th><cf_get_lang dictionary_id="58258.Maliyet"> <cfoutput>#session.ep.money#</cfoutput></th>
					<cfif labor_cost eq 0>
						<th><cf_get_lang dictionary_id="58258.Maliyet"> <cfoutput>#session.ep.money2#</cfoutput></th>
					</cfif>
					<!--- <!-- sil -->
					<th width="20" class="header_icn_none"><a href="javascript://"><i class="icon-detail" alt="<cf_get_lang dictionary_id='57771.Detay'>" title="<cf_get_lang dictionary_id='57771.Detay'>"></a></th>
					<!-- sil --> --->
				</tr>
			</thead>
			<tbody>
				<cfset account_id_list = ''>
				<cfset expence_shift_list = ''>
				<cfset expence_row_list = ''>
				<cfset product_cost_sys_money_list = ''>
				<cfif GET_PRODUCT_COST_PAPER.recordcount>
					<cfset exp_cen_sys_money_sum =0>
					<cfset exp_cen_sys2_money_sum =0>
					<cfset product_cost_sys_money_sum = 0>
					<cfset product_cost_sys2_money_sum = 0>			
					<cfoutput query="GET_PRODUCT_COST_PAPER">
						<cfset exp_cen_sys_money =0> 
						<cfset exp_cen_sys2_money =0> 
						<cfset product_cost_sys_money = 0>
						<cfset product_cost_sys2_money = 0>
						<cfif isdefined("EXPENSE_ID") and isdefined('expense_center_money_vall#EXPENSE_ID#')>
							<cfset exp_cen_sys_money =ListGetAt(Evaluate('expense_center_money_vall#EXPENSE_ID#'),1,'█')> 
							<cfset exp_cen_sys2_money =ListGetAt(Evaluate('expense_center_money_vall#EXPENSE_ID#'),2,'█')> 
							<cfif x_reflection_type eq 0>
								<cfset product_cost_sys_money = (YANSIMA*exp_cen_sys_money)/100>
								<cfset product_cost_sys2_money = (YANSIMA*exp_cen_sys2_money)/100>
							<cfelse>
								<cfquery name="GET_TOTAL_MIN" dbtype="query">
									SELECT SUM(CALISMA_DAKIKA) CALISMA_DAKIKA FROM GET_PRODUCT_COST_PAPER WHERE EXPENSE_ID IN(#EXPENSE_ID#)
								</cfquery>
								<cfset yansima_ = CALISMA_DAKIKA/GET_TOTAL_MIN.CALISMA_DAKIKA>
								<cfset product_cost_sys_money = yansima_*exp_cen_sys_money>
								<cfset product_cost_sys2_money = yansima_*exp_cen_sys2_money>
							</cfif>
							<cfset exp_id = EXPENSE_ID>
					<cfelseif isdefined("ACCOUNT_ID") and isdefined('account_code_money_vall#replace(ACCOUNT_ID,'.','_','all')#') and listlen(Evaluate('account_code_money_vall#replace(ACCOUNT_ID,'.','_','all')#'),'█')>
							<cfset exp_cen_sys_money =ListGetAt(Evaluate('account_code_money_vall#replace(ACCOUNT_ID,'.','_','all')#'),1,'█')> 
							<cfset exp_cen_sys2_money =ListGetAt(Evaluate('account_code_money_vall#replace(ACCOUNT_ID,'.','_','all')#'),2,'█')> 
							<cfif x_reflection_type eq 0>
								<cfset product_cost_sys_money = (YANSIMA*exp_cen_sys_money)/100>
								<cfset product_cost_sys2_money = (YANSIMA*exp_cen_sys2_money)/100>
							<cfelse>
								<cfquery name="GET_TOTAL_MIN" dbtype="query">
									SELECT SUM(CALISMA_DAKIKA) CALISMA_DAKIKA FROM GET_PRODUCT_COST_PAPER WHERE EXPENSE_ID IN(#EXPENSE_ID#)
								</cfquery>
								<cfset yansima_ = CALISMA_DAKIKA/GET_TOTAL_MIN.CALISMA_DAKIKA>
								<cfset product_cost_sys_money = yansima_*exp_cen_sys_money>
								<cfset product_cost_sys2_money = yansima_*exp_cen_sys2_money>
							</cfif>
							<cfset acc_id = ACCOUNT_ID>
						<cfelseif isdefined("EXPENSED_MONEY")>
							<cfset product_cost_sys_money = EXPENSED_MONEY>
						</cfif>
						<tr>
							<cfset product_cost_sys_money_sum = product_cost_sys_money_sum+product_cost_sys_money>
							<cfif attributes.act_type eq 2 >
								<cfset account_id_list = listappend(account_id_list,"#account_id#")>
							<cfelse>
								<cfset expence_row_list = listappend(expence_row_list,"#expense_id#")>
							</cfif>
							<cfset product_cost_sys_money_list = listappend(product_cost_sys_money_list, product_cost_sys_money)>
							<cfset expence_shift_list = listappend(expence_shift_list,"#YANSIMA#")>
							<cfif (STATION_ID[currentrow+1] neq STATION_ID) or (currentrow eq recordcount) or COST_TYPE[currentrow+1] neq COST_TYPE>
	
								
								<cfset station_id_ = STATION_ID>
								<cfset s_ids = replace(station_id_,',','_','all')>
								<cfif isdefined("attributes.act_type") and attributes.act_type eq 2>
									<cfset name_extra_ = '#COST_TYPE#_#replace(ACCOUNT_ID,'.','_','all')#'>
								<cfelse>
									<cfset name_extra_ = '#COST_TYPE#'>
								</cfif>
									<!-- sil -->
									
									<cfset uretim_miktarı_ = URETIM_MIKTARI>
									<cfset uretim_miktarı2_ = URETIM_MIKTARI2>
								
								<td class="iconL"><a href="javascript://" id="row#currentrow#" onclick="gizle_goster(product_cost_deliver_tr_#s_ids#_#name_extra_#);product_cost_deliver('#s_ids#','#CALISMA_DAKIKA#','#product_cost_sys_money_sum#','#product_cost_sys2_money_sum#','deliver','','#uretim_miktarı_#','#uretim_miktarı2_#','#COST_TYPE#','#name_extra_#'<cfif isdefined("attributes.act_type") and attributes.act_type eq 2>,'#account_id#'<cfelse>,''</cfif>,'#PRICE_PUR#','','#YANSIMA#','#attributes.act_type#','<cfif isdefined("attributes.act_type") and attributes.act_type eq 1>#EXPENSE_ID#</cfif>','','#account_id_list#','#expence_row_list#','#expence_shift_list#','#product_cost_sys_money_list#');"><i class="fa fa-caret-right" alt="<cf_get_lang dictionary_id='57771.Detay'>" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a></td>
	
								<!-- sil -->
							<cfquery name="get_workstations_name" datasource="#dsn3#">
								SELECT STATION_ID,STATION_NAME,ISNULL(REFLECTION_TYPE,1) REFLECTION_TYPE,UNIT2 FROM WORKSTATIONS WHERE STATION_ID IN (#station_id#)
							</cfquery>
							<td>#valuelist(get_workstations_name.station_name)#</td>
							<cfif labor_cost eq 0>
								<td>
									<cfif get_workstations_name.REFLECTION_TYPE eq 1><cf_get_lang dictionary_id="29513.Süre">
									<cfelseif get_workstations_name.REFLECTION_TYPE eq 2><cf_get_lang dictionary_id="47546.Ana Birim">
									<cfelseif get_workstations_name.REFLECTION_TYPE eq 3>#Evaluate('unit_2_#STATION_ID#')#
									<cfelseif get_workstations_name.REFLECTION_TYPE eq 4><cf_get_lang dictionary_id='40230.Standart Alış Fiyatı'>
									</cfif>
								</td>
							</cfif>
							<cfif labor_cost eq 1>
								<td style="text-align:right;">#TLFORMAT(NORMAL/60)#</td>
								<td style="text-align:right;">#TLFORMAT(MESAI_NORMAL/60)#</td>
								<td style="text-align:right;">#TLFORMAT(MESAI_HSONU/60)#</td>
								<td style="text-align:right;">#TLFORMAT(MESAI_TATIL/60)#</td>
							<cfelse>
								<td style="text-align:right;">#TLFORMAT(CALISMA_DAKIKA/60)#</td>
							</cfif>
							<td style="text-align:right;">#tlformat(URETIM_SONUCU)#</td>
							<td style="text-align:right;">
								
									#tlformat(URETIM_MIKTARI)#
								
							</td>
							<cfif labor_cost eq 0>
								<cfif isdefined("attributes.act_type") and attributes.act_type eq 2>
									<td>#Evaluate('account_name_#replace(ACCOUNT_ID,'.','_','all')#')#</td>
								<cfelse>
									<td>#Evaluate('expense_name_#EXPENSE_ID#')#</td>
								</cfif>
								<td style="text-align:right;">#tlformat(exp_cen_sys_money)#</td><!--- sistem p.bir --->
								<td style="text-align:right;">#tlformat(exp_cen_sys2_money)#</td><!--- sistem 2.döviz --->
								<td style="text-align:right;">
								<cfif x_reflection_type eq 0>
									%#YANSIMA#
								<cfelse>
									<cfquery name="GET_TOTAL_MIN" dbtype="query">
										SELECT SUM(CALISMA_DAKIKA) CALISMA_DAKIKA FROM GET_PRODUCT_COST_PAPER WHERE EXPENSE_ID IN(#EXPENSE_ID#)
									</cfquery>
									#CALISMA_DAKIKA#/#GET_TOTAL_MIN.CALISMA_DAKIKA#
								</cfif>
								</td>
								<td style="text-align:right;">#tlformat(product_cost_sys_money)#</td>
								<td style="text-align:right;">#tlformat(product_cost_sys2_money)#</td>
								<cfset exp_cen_sys_money_sum = exp_cen_sys_money_sum+exp_cen_sys_money>
								<cfset exp_cen_sys2_money_sum = exp_cen_sys2_money_sum+exp_cen_sys2_money>
								<cfset product_cost_sys2_money_sum = product_cost_sys2_money_sum+product_cost_sys2_money>
							<cfelse>
								<td style="text-align:right;">#tlformat(product_cost_sys_money)#</td>
							</cfif>
							<!-- sil -->
							<cfif isdefined("attributes.act_type") and attributes.act_type eq 1 and labor_cost eq 0><td><a href="#request.self#?fuseaction=account.product_cost_rate_paper&event=report&expense_id=#EXPENSE_ID#" target="_blank"><img src="\images\report.gif" alt="<cf_get_lang dictionary_id='57434.Rapor'>" title="<cf_get_lang dictionary_id='57434.Rapor'>"></a></td></cfif>
							<!-- sil -->
						</tr>
						<tr>
								<td <cfif labor_cost eq 1>colspan="8"<cfelse>colspan="7"</cfif> style="text-align:right;" class="txtbold" ><cf_get_lang dictionary_id="57492.Toplam"></td>
								<cfif labor_cost eq 0>
									<td style="text-align:right;" class="txtbold" >#tlformat(exp_cen_sys_money_sum)#</td>
									<td style="text-align:right;" class="txtbold" >#tlformat(exp_cen_sys2_money_sum)#</td>
									<td style="text-align:right;" ></td>
								</cfif>
								<td style="text-align:right;" class="txtbold" id="system_cost_#s_ids#" >#tlformat(product_cost_sys_money_sum)#</td>
								<cfif labor_cost eq 0>
									<td style="text-align:right;" class="txtbold" id="system2_cost_#s_ids#" >#tlformat(product_cost_sys2_money_sum)#</td>
								</cfif>
								
								
							</tr>
							<tr id="product_cost_deliver_tr_#s_ids#_#name_extra_#" style="display:none;"  class="nohover">
								<td colspan="15" valign="top"><div  id="product_cost_deliver_div_#s_ids#_#name_extra_#"></div></td>
							</tr>
							<cfset exp_cen_sys_money_sum =0>
							<cfset exp_cen_sys2_money_sum =0>
							<cfset product_cost_sys_money_sum = 0>
							<cfset product_cost_sys2_money_sum = 0>
							<cfset account_id_list= ''>	
							<cfset expence_shift_list = ''>		
							<cfset expence_row_list = ''>	
							<cfset product_cost_sys_money_list = ''>	
						</cfif>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="13"><cfif isdefined("attributes.form_submit")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>			
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
<script type="text/javascript">
	//document.getElementById("STATION_NAME").focus();
	function product_cost_deliver(station_id,sum_minute,sys_money_cost,sys2_money_cost,type,div_id,prod_amount,prod_amount2,cost_type,name_extra_,account_id,price_pur,pr_order_id,expense_shift,act_type,expense_id,product_id,account_id_list,expence_row_list,expence_shift_list,product_cost_sys_money_list,product_cost_row_list)
	{
		if(account_id == undefined) account_id = 0;
		if(expense_id == undefined) expense_id = 0;
		if(prod_amount == undefined) prod_amount = 0;
		if(prod_amount2 == undefined) prod_amount2 = 0;
		s_id = ReplaceAll(station_id,"_", ",");
		if(pr_order_id) p_id = ReplaceAll(pr_order_id,"_", ",");
		var start_dates = "<cfoutput>#attributes.start_dates#</cfoutput>";
		var finish_dates = "<cfoutput>#attributes.finish_dates#</cfoutput>";
		var date_str = '&start_dates='+start_dates+'&finish_dates='+finish_dates+'';		
		//div_id sadece güncelleme işlemi yapılacağı zaman kullanılıyor,kafanız karışmasın...
		if(type == 'deliver')//dağıt denilmiş ise üretim sonuçlarının detaylarını gösteriyor. 
		{
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=account.emptypopup_product_cost_rate_detail_ajax'+date_str+'&x_reflection_type=#x_reflection_type#&x_cost_type=#x_cost_type#&labor_cost=#labor_cost#</cfoutput>&cost_type='+cost_type+'&prod_amount2='+prod_amount2+'&prod_amount='+prod_amount+'&sys_money_cost='+sys_money_cost+'&sys2_money_cost='+sys2_money_cost+'&sum_minute='+sum_minute+'&station_id='+s_id+'&account_id='+account_id+'&prod_price='+price_pur+'&expense_shift='+expense_shift+'&act_type='+act_type+'&expense_id='+expense_id+'&account_id_list='+account_id_list+'&expence_row_list='+expence_row_list+'&expence_shift_list='+expence_shift_list+'&product_cost_sys_money_list='+product_cost_sys_money_list,'product_cost_deliver_div_'+station_id+'_'+name_extra_+'',1);
		}
		else //eğer type deliver değilse dağıtılmış olan üretim sonucuna ait bir yansıtma yapılacağını gösteriyor..
		{
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=account.emptypopup_product_cost_rate_detail_ajax'+date_str+'&x_reflection_type=#x_reflection_type#&x_cost_type=#x_cost_type#&labor_cost=#labor_cost#</cfoutput>&cost_type='+cost_type+'&prod_amount2='+prod_amount2+'&prod_amount='+prod_amount+'&result_no='+sys_money_cost+'&pr_order_id='+p_id+'&station_reflection_cost='+sum_minute+'&prod_price='+price_pur+'&station_id='+s_id+'&expense_id='+expense_id+'&account_id='+account_id+'&expense_shift='+expense_shift+'&product_id='+product_id+'&act_type='+act_type+'&expense_id='+expense_id+'&account_id_list='+account_id_list+'&expence_row_list='+expence_row_list+'&expence_shift_list='+expence_shift_list+'&product_cost_sys_money_list='+product_cost_sys_money_list+'&product_cost_row_list='+product_cost_row_list,div_id,1);//burdaki station_id değeri pr_order_id'yi ve sum_minute değeride  station_reflection_cost'i ifade eder...			
		}
	}
</script>
<cfsetting showdebugoutput="yes">
