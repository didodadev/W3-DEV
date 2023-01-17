<cffile action="read" file="#index_folder#admin_tools#dir_seperator#xml#dir_seperator#reason_codes.xml" variable="xmldosyam" charset = "UTF-8">
<cfset dosyam = XmlParse(xmldosyam)>
<cfset xml_dizi = dosyam.REASON_CODES.XmlChildren>
<cfset d_boyut = ArrayLen(xml_dizi)>
<cfset reason_code_list = "">
<cfloop index="abc" from="1" to="#d_boyut#">    	
    <cfset reason_code_list = listappend(reason_code_list,'#dosyam.REASON_CODES.REASONS[abc].REASONS_CODE.XmlText#--#dosyam.REASON_CODES.REASONS[abc].REASONS_NAME.XmlText#','*')>
</cfloop>
<cfif isdefined("get_expense.process_cat")>
	<cfquery name="get_process_cat" datasource="#dsn2#">
		SELECT ISNULL(IS_EXPENSING_OIV,0) IS_EXPENSING_OIV,ISNULL(IS_EXPENSING_OTV,0) IS_EXPENSING_OTV  FROM #dsn3#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #get_expense.process_cat#
	</cfquery>
</cfif>
<cfinclude template="../../objects/query/tax_type_code.cfm">
<cfif not isDefined("xml_upd_row_expense_center")>
	<cfset xml_upd_row_expense_center = 0>
</cfif>
<input type="hidden" name="control_field_value" id="control_field_value" value="">
<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)><!--- Butceden Donustuyse --->
	<cfquery name="get_rows" datasource="#dsn#">
		SELECT EXP_INC_CENTER_ID '' TAX_CODE,EXPENSE_CENTER_ID, BUDGET_ITEM_ID EXPENSE_ITEM_ID,'' UNIT_ID,'' UNIT,'' WORK_ID,'' OPP_ID,'' EXPENSE_ACCOUNT_CODE FROM BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.budget_plan_row_id#"> AND IS_PAYMENT = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
	</cfquery>
	<cfquery name="get_money_rate" datasource="#dsn#">
		SELECT MONEY_TYPE FROM BUDGET_PLAN_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.budget_plan_id#"> AND IS_SELECTED = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
	</cfquery>
<cfelseif isdefined("attributes.credit_contract_id") and len(attributes.credit_contract_id)><!--- Kredi Fon Yonetiminden Donustuyse --->
	<cfquery name="get_rows" datasource="#dsn3#">
		SELECT '' AS REASON_CODE, '' AS REASON_NAME,'' TAX_CODE,TOTAL_EXPENSE_ITEM_ID EXPENSE_ITEM_ID,'' UNIT_ID,'' UNIT,1 QUANTITY,TOTAL_ACCOUNT_ID EXPENSE_ACCOUNT_CODE,1 AS TYPE,'' WORK_ID,'' OPP_ID,*,(SELECT RATE2 FROM CREDIT_CONTRACT_MONEY WHERE MONEY_TYPE = CREDIT_CONTRACT_ROW.OTHER_MONEY AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_id#">) RATE2 FROM CREDIT_CONTRACT_ROW WHERE CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_id#"> AND  CREDIT_CONTRACT_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_row_id#"> AND CAPITAL_PRICE > 0
		UNION ALL
		SELECT '' AS REASON_CODE, '' AS REASON_NAME,'' TAX_CODE,EXPENSE_ITEM_ID,'' UNIT_ID,'' UNIT,1 QUANTITY,INTEREST_ACCOUNT_ID EXPENSE_ACCOUNT_CODE,0 AS TYPE,'' WORK_ID,'' OPP_ID,*,(SELECT RATE2 FROM CREDIT_CONTRACT_MONEY WHERE MONEY_TYPE = CREDIT_CONTRACT_ROW.OTHER_MONEY AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_id#">) RATE2 FROM CREDIT_CONTRACT_ROW WHERE CREDIT_CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_id#"> AND CREDIT_CONTRACT_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_row_id#"> AND INTEREST_PRICE > 0
	</cfquery>
    <cfquery name="get_project" datasource="#dsn3#">
    	SELECT PROJECT_ID FROM CREDIT_CONTRACT WHERE CREDIT_CONTRACT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.credit_contract_id#">
    </cfquery>
<cfelseif isdefined("attributes.request_id") and len(attributes.request_id)><!--- Harcama Talebinden Donustuyse --->
	<cfquery name="get_rows" datasource="#dsn2#">
		SELECT  
			EI.ACCOUNT_CODE EXPENSE_ACCOUNT_CODE,
			EI.TAX_CODE,
			'' AS REASON_CODE,
	        '' AS REASON_NAME,
			EIPR.*
		FROM 
			EXPENSE_ITEM_PLAN_REQUESTS_ROWS EIPR 
			LEFT JOIN EXPENSE_ITEMS EI ON EIPR.EXPENSE_ITEM_ID = EI.EXPENSE_ITEM_ID
		WHERE 
			EXPENSE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">
	</cfquery>
<cfelseif isdefined("attributes.expense_id") and len(attributes.expense_id)><!--- Masraf Kopyalama Ise --->
	<cfquery name="get_rows" datasource="#dsn2#">
		SELECT * FROM EXPENSE_ITEMS_ROWS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#"> ORDER BY EXP_ITEM_ROWS_ID
	</cfquery>
<cfelseif isdefined("attributes.is_from_report")><!--- ilk inşaat özel rapor için eklendi PY 0115--->
	<cfif isdefined("attributes.record_number") and len(attributes.record_number)>
        <cfquery name="get_rows" datasource="#dsn2#">
        <cfloop from="1" to="#listlast(attributes.record_number)#" index="cc">
		<cfif isdefined("attributes.money_currency_id#cc#")>
        	<cfquery name="get_mny" datasource="#dsn#">
            	SELECT RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY = '#session.ep.money#' AND PERIOD_ID = #session.ep.period_id#
            </cfquery>
        </cfif>
             SELECT 
                #now()# as EXPENSE_DATE,
             	<cfif isdefined("attributes.expense_center_id#cc#")>
                    #evaluate('attributes.expense_center_id#cc#')# as EXPENSE_CENTER_ID,
                <cfelse>
                	'' as EXPENSE_CENTER_ID,
                </cfif>
                <cfif isdefined("attributes.expense_item_id#cc#")>
                    #evaluate('attributes.expense_item_id#cc#')# as EXPENSE_ITEM_ID,
                <cfelse>
                	'' as EXPENSE_ITEM_ID,
                </cfif>
                <cfif isdefined("attributes.EXPENSE_EMPLOYEE_ID")>
                	#attributes.EXPENSE_EMPLOYEE_ID# as  EXPENSE_EMPLOYEE,
                <cfelse>
                	'' AS EXPENSE_EMPLOYEE,
                </cfif>
                '' AS PYSCHICAL_ASSET_ID,
                <cfif isdefined("attributes.project_id#cc#")>
                    #evaluate('attributes.project_id#cc#')# as PROJECT_ID,
                <cfelse>
                	'' AS PROJECT_ID,
                </cfif>
                '' PAPER_TYPE,
				<cfif isdefined("attributes.other_money_value#cc#")>
                    #get_mny.rate2/get_mny.rate1*evaluate('attributes.other_money_value#cc#')# as AMOUNT,
                <cfelse>
                	'' AMOUNT,
                </cfif>
				<cfif isdefined("attributes.other_money_value#cc#")>
                    #get_mny.rate2/get_mny.rate1*(evaluate('attributes.other_money_value#cc#')+evaluate('attributes.kdv_rate#cc#')*evaluate('attributes.other_money_value#cc#')/100)#  AS TOTAL_AMOUNT,
                <cfelse>
                	'' AS TOTAL_AMOUNT,
                </cfif>
				<cfif isdefined("attributes.kdv_rate#cc#")>
                    #evaluate('attributes.kdv_rate#cc#')# as AMOUNT_KDV,
                <cfelse>
                	'' AS AMOUNT_KDV,
                </cfif>
                <cfif isdefined("attributes.money_currency_id#cc#")>
                    '#evaluate("attributes.money_currency_id#cc#")#' as MONEY_CURRENCY_ID,
                <cfelse>
                	'' AS MONEY_CURRENCY_ID,
                </cfif>
                '' SYSTEM_RELATION,
                '' COMPANY_ID,
                '' COMPANY_PARTNER_ID,
                '' ACTIVITY_TYPE,
                <cfif isdefined("attributes.expense_item_name#cc#")>
                    '#evaluate("attributes.expense_item_name#cc#")#' as DETAIL,
                <cfelse>
                	'' AS DETAIL,
                </cfif>
                '' RATE,
                0 ACTION_ID,
                '' STOCK_ID,
                0 IS_INCOME,
                '' MEMBER_TYPE,
                <cfif isdefined("attributes.kdv_rate#cc#")>
                    #evaluate('attributes.kdv_rate#cc#')# as KDV_RATE,
                <cfelse>
                	'' AS KDV_RATE,
                </cfif>
                <cfif isdefined("attributes.other_money_value#cc#")>
                   <!--- #evaluate('attributes.other_money_value#cc#')# as OTHER_MONEY_VALUE,--->
					#evaluate('attributes.other_money_value#cc#')# as OTHER_MONEY_VALUE,
                <cfelse>
                	'' AS OTHER_MONEY_VALUE,
                </cfif>
                '' INVOICE_ID,
                0 IS_DETAILED,
                0 OTHER_MONEY_VALUE_2,
                '' MONEY_CURRENCY_ID_2,
                '' BUDGET_PLAN_ROW_ID,
                '' STOCK_FIS_ID,
                1 QUANTITY,
                '' PRODUCT_ID,
                '' SPECT_VAR_ID,
                '' STOCK_ID_2,
                '' PRODUCT_NAME,
                '' UNIT,
                '' UNIT_ID,
                0 OTV_RATE,
				0 AMOUNT_OTV,
				0 BSMV_RATE,
				0 AMOUNT_BSMV,
				0 BSMV_CURRENCY,
				0 OIV_RATE,
				0 AMOUNT_OIV,
				0 AMOUNT_TEVKIFAT,
				0 TEVKIFAT_RATE,
                '' SUBSCRIPTION_ID,
                <cfif isdefined("attributes.other_money_value#cc#")>
                    #evaluate('attributes.other_money_value#cc#')+evaluate('attributes.kdv_rate#cc#')*evaluate('attributes.other_money_value#cc#')/100#  as OTHER_MONEY_GROSS_TOTAL,
                <cfelse>
                	'' AS OTHER_MONEY_GROSS_TOTAL,
                </cfif>
                '' WORKGROUP_ID,
                <cfif isdefined("attributes.ACCOUNT_CODE#cc#")>
                    '#evaluate("attributes.ACCOUNT_CODE#cc#")#' as EXPENSE_ACCOUNT_CODE,
                <cfelse>
                	'' AS EXPENSE_ACCOUNT_CODE,
                </cfif>
                '' BRANCH_ID,
                '' WORK_ID,
                '' OPP_ID,
                '' TAX_CODE,
    		    '' AS REASON_CODE,
	         	'' AS REASON_NAME
		<cfif cc neq listlast(attributes.record_number)>
			UNION ALL
		</cfif>
            </cfloop>
        </cfquery>
    </cfif>
<cfelseif isdefined("attributes.receiving_detail_id")><!--- gelen e-fatura --->

	<cfset kontrol_row = 0>
	<cfloop from="1" to="#attributes.line_count#" index="x">
		<cfif isdefined("attributes.stock_id_#x#") and len(evaluate("attributes.stock_id_#x#"))>
			<cfset kontrol_row = kontrol_row+1>
		</cfif>
	</cfloop>
    
    <cfif kontrol_row neq 0>
		<cfquery name="GET_ROWS" datasource="#dsn3#">
        <cfset count_row = 0>
			<cfloop from="1" to="#attributes.line_count#" index="x">
			<cfif len(evaluate("attributes.stock_id_#x#"))>
                <cfset count_row = count_row + 1>
                SELECT 
                    PRODUCT_UNIT.MAIN_UNIT_ID AS UNIT_ID,
                    PRODUCT_UNIT.MAIN_UNIT AS UNIT,
                    '' UNIT2,
                    STOCKS.PRODUCT_NAME NAME_PRODUCT,
                    STOCKS.PRODUCT_NAME PRODUCT_NAME2,
                    STOCKS.IS_SERIAL_NO,
                    STOCKS.STOCK_ID,
                    STOCKS.PRODUCT_ID,
                    STOCKS.STOCK_CODE,
                    STOCKS.STOCK_CODE_2,
                    STOCKS.BARCOD,
                    STOCKS.PROPERTY,
                    STOCKS.IS_INVENTORY,
                    STOCKS.IS_PRODUCTION,
                    #evaluate("attributes.tax_#x#")# TAX,
                    '' TAX_CODE,
                    '' WRK_ROW_RELATION_ID,
                    '' RELATED_ACTION_ID,
                    '' RELATED_ACTION_TABLE,
                    '' UNIQUE_RELATION_ID,
                    '' PROM_RELATION_ID,
                    '' SHIP_ID,
                    '' EXTRA_COST,
                    '' DUE_DATE,
                    '' DELIVER_LOC,
                    '' DELIVER_DEPT,
                    '' PROM_COMISSION,
                    '' PROM_COST,
                    '' PROM_ID,
                    '' IS_COMMISSION,
                    '' BASKET_EXTRA_INFO_ID,
					'' SELECT_INFO_EXTRA,
					'' DETAIL_INFO_EXTRA,
                    '' BASKET_EMPLOYEE_ID,
                    #wrk_round(evaluate("attributes.price_#x#"))# LIST_PRICE,
                    '' PRICE_CAT,
                    '' KARMA_PRODUCT_ID,
                    '' CATALOG_ID,
                    0 NUMBER_OF_INSTALLMENT,			
                    '' AS WRK_ROW_ID,
                    '' AS WRK_ROW_RELATION_ID,
                    '' AS ROW_PAYMETHOD_ID,
                    #wrk_round(evaluate("attributes.price_#x#"))# PRICE,
                    #evaluate("attributes.quantity_#x#")# AS AMOUNT,
                    #evaluate("attributes.quantity_#x#")# AS AMOUNT2,
                    #evaluate("attributes.price_#x#")# AS PRICE_OTHER,
                    #wrk_round(evaluate("attributes.net_total_#x#"))# AS NETTOTAL,
                    0 AS PRICE_KDV,
                    '#session.ep.other_money#' AS MONEY,
                    '#session.ep.other_money#' AS OTHER_MONEY,
                    '' AS OTHER_MONEY_GROSS_TOTAL,
                    (#wrk_round(evaluate("attributes.net_total_#x#"))#*#evaluate("attributes.tax_#x#")#/100) AS TAXTOTAL,
                    #wrk_round(evaluate("attributes.net_total_#x#"))*wrk_round(evaluate("attributes.discount_#x#"))/100#  AS DISCOUNTTOTAL,
                    #wrk_round(evaluate("attributes.discount_#x#"))# AS DISCOUNT1,
                    0 AS DISCOUNT2,
                    0 AS DISCOUNT3,
                    0 AS DISCOUNT4,
                    0 AS DISCOUNT5,
                    0 AS DISCOUNT6,
                    0 AS DISCOUNT7,
                    0 AS DISCOUNT8,
                    0 AS DISCOUNT9,
                    0 AS DISCOUNT10,
                    0 AS DISCOUNT_COST,
					0 OTV_RATE,
					0 AMOUNT_OTV,
					0 BSMV_RATE,
					0 AMOUNT_BSMV,
					0 BSMV_CURRENCY,
					0 OIV_RATE,
					0 AMOUNT_OIV,
					0 AMOUNT_TEVKIFAT,
					0 TEVKIFAT_RATE,
                    '' AS MARGIN,
                    #NOW()# AS DELIVER_DATE,
                    '' AS WIDTH_VALUE,
                    '' AS DEPTH_VALUE,
                    '' AS HEIGHT_VALUE,
                    '' AS ROW_PROJECT_ID,
                    '' AS ROW_WORK_ID,
                    '' COST_PRICE,
                    '' EXTRA_PRICE,
                    '' EK_TUTAR_PRICE,
                    '' EXTRA_PRICE_TOTAL,
                    '' EXTRA_PRICE_OTHER_TOTAL,
                    '' DETAIL,
                    '' SHELF_NUMBER,
                    '' PRODUCT_MANUFACT_CODE,
                    '' OTVTOTAL,
                    0 OTV_ORAN,
                    0 OTHER_MONEY_VALUE,
                    '' SPECT_VAR_ID,
                    '' SPECT_VAR_NAME,
                    '' LOT_NO,
                    '' IS_PROMOTION,
                    '' PROM_STOCK_ID,
                    '' WORK_ID,
                    '' workgroup_id_,
                    '' OPP_ID,
                    PP.COST_EXPENSE_CENTER_ID EXPENSE_CENTER_ID,
                    PP.EXPENSE_ITEM_ID,
                    PP.ACCOUNT_CODE_PUR,
                    '' AS REASON_CODE,
		         	'' AS REASON_NAME
                FROM 
                    STOCKS AS STOCKS,
                    PRODUCT_UNIT
                        LEFT JOIN PRODUCT_PERIOD PP ON PP.PRODUCT_ID=PRODUCT_UNIT.PRODUCT_ID AND PERIOD_ID=#session.ep.period_id#
                WHERE
                    PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                    PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
                    STOCKS.STOCK_ID = #evaluate("attributes.stock_id_#x#")#
				<cfif count_row neq kontrol_row>
                 UNION ALL
                </cfif>
        	</cfif>
			</cfloop>
    	</cfquery>
    <cfelse>
    	<cfset get_rows.recordcount = 0>
    </cfif>
<cfelse>
	<cfset get_rows.recordcount = 0>
</cfif>

<cfquery name="get_activity_types" datasource="#dsn#">
	SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
</cfquery>
<cfquery name="get_workgroups" datasource="#dsn#">
	SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 ORDER BY WORKGROUP_NAME
</cfquery>
<cfif fusebox.use_period eq true>
	<cfquery name="get_tax" datasource="#dsn2#">
		SELECT * FROM SETUP_TAX ORDER BY TAX
	</cfquery>
</cfif>
<cfquery name="get_otv" datasource="#dsn3#">
	SELECT * FROM SETUP_OTV WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#">
</cfquery>
<cfquery name="get_bsmv" datasource="#dsn3#">
	SELECT * FROM SETUP_BSMV WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#">
</cfquery>
<cfquery name="get_oiv" datasource="#dsn3#">
	SELECT * FROM SETUP_OIV WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#">
</cfquery>
<cfif fusebox.use_period eq true>
	<cfquery name="get_expense_item" datasource="#dsn2#">
		SELECT IS_ACTIVE,EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE  IS_ACTIVE=1 AND IS_EXPENSE = 1  ORDER BY EXPENSE_ITEM_NAME
	</cfquery>
</cfif>
<cfif fusebox.use_period eq true>
	<cfquery name="get_expense_center" datasource="#dsn2#">
		SELECT
			EXPENSE_ID,
			EXPENSE_CODE,
			EXPENSE
		FROM
			EXPENSE_CENTER
		WHERE
			EXPENSE_ID IS NOT NULL
		<cfif session.ep.isBranchAuthorization>
			AND EXPENSE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
		</cfif>
		<cfif not (isdefined("attributes.budget_plan_id") or isdefined("attributes.credit_contract_id") or isdefined("attributes.expense_id") or isdefined("attributes.request_id"))>
			AND EXPENSE_ACTIVE = 1<!--- kopyalamadan,talepten vs dışında gelen kayıtlarda sadece aktifler gelir--->
		</cfif>
		ORDER BY
			EXPENSE
	</cfquery>
</cfif>
<cfquery name="GET_BRANCH_DET" datasource="#dsn#">
    SELECT 
        BRANCH_ID,
        BRANCH_NAME
    FROM 
        BRANCH
    WHERE
        BRANCH_STATUS = 1
        AND COMPANY_ID = #session.ep.company_id#
        AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
    ORDER BY 
        BRANCH_NAME
</cfquery>
<div class="ui-cfmodal" id="open_process"></div>
<cf_grid_list sort="1">
	<thead>
		<tr>
			<th width="20">
				<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_rows.recordcount#</cfoutput>">
				<a href="javascript://" title="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
			</th>
			<th width="20">
				<a href="javascript://" onClick="open_process_row();"><i class="fa fa-tasks" title="<cf_get_lang dictionary_id='34266.Masraf Dağılımı Yap'>" alt="<cf_get_lang dictionary_id='34266.Masraf Dağılımı Yap'>"></i></a>
			</th>
			<!--- Satirlardaki Veriler Degisken Olarak Geliyor --->
			<cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
				<cfswitch expression="#xlr#">
					<cfcase value="1"> 
						<th style="min-width:130px"><cf_get_lang dictionary_id='57742.Tarih'>*<cfinput type="text" name="temp_date" id="temp_date" value="#dateformat(now(),dateformat_style)#" class="box" style="width:80px;" onBlur="change_date_info();" validate="#validate_style#" message="#message#"></th>
					</cfcase>
					<cfcase value="2"> 
						<th style="min-width:200px"><cf_get_lang dictionary_id='57629.Açıklama'>*</th>
					</cfcase>
					<cfcase value="40">
						<th style="min-width:300px" nowrap="nowrap"><cf_get_lang dictionary_id='57453.Şube'>*</th>
					</cfcase>
					<cfcase value="3"> 
						<cfif x_is_project_priority eq 0><th style="min-width:170px"><cfif isDefined("is_income") and is_income eq 1><cf_get_lang dictionary_id='58172.Gelir Merkezi'><cfelse><cf_get_lang dictionary_id='58460.Masraf Merkezi'></cfif>*</th></cfif>
					</cfcase>
					<cfcase value="4"> 
						<cfif x_is_project_priority eq 0><th style="min-width:170px"><cfif isDefined("is_income") and is_income eq 1><cf_get_lang dictionary_id='58173.Gelir Kalemi'><cfelse><cf_get_lang dictionary_id='58551.Gider Kalemi'></cfif>*</th></cfif>
					</cfcase>
					<cfcase value="5"> 
						<cfif x_is_project_priority eq 0><th style="min-width:170px"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>*</th></cfif>
					</cfcase>
					<cfcase value="26"> 
                        <cfif not(fuseaction contains "assetcare")><th style="min-width:170px"><cf_get_lang dictionary_id='30006.Vergi Kodu'></th></cfif>
					</cfcase>
					<cfcase value="6"> 
						<th style="min-width:180px"><cf_get_lang dictionary_id='57657.Ürün'></th>
					</cfcase>
					<cfcase value="25"> 
						<cfif fuseaction contains "assetcare">
							<th style="min-width:170px"><cf_get_lang dictionary_id='57647.Spec'></th>
						</cfif>
					</cfcase>
					<cfcase value="7"> 
						<th style="min-width:75px"><cf_get_lang dictionary_id='57636.Birim'></th>
					</cfcase>
					<cfcase value="8"> 
						<th style="min-width:150px"><cf_get_lang dictionary_id='57635.Miktar'></th>
					</cfcase>
					<cfcase value="9"> 
						<th style="min-width:150px;text-align:right;"><cfif isdefined("xml_discount") and xml_discount eq 1><cf_get_lang dictionary_id='54271.İndirimli'>  <cf_get_lang dictionary_id ='57638.Birim Fiyat'> <cfelse> <cf_get_lang dictionary_id='57673.Tutar'> </cfif></th>
					</cfcase>
					<cfcase value="10"> 
						<th style="min-width:80px;text-align:right;"><cf_get_lang dictionary_id='57639.KDV'>%</th>
					</cfcase>
					<cfcase value="11"> 
						<th style="min-width:80px;text-align:right;"><cf_get_lang dictionary_id='58021.ÖTV'>%</th>
					</cfcase>
					<cfcase value="29"> 
						<cfif isdefined("xml_discount") and xml_discount eq 1>
							<th style="min-width:150px;text-align:right;"><cf_get_lang dictionary_id='57641.İskonto'>%</th>
						</cfif>
					</cfcase>
					<cfcase value="12"> 
						<th style="min-width:150px;text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></th>
					</cfcase>
					<cfcase value="13"> 
						<th style="min-width:150px;text-align:right;"><cf_get_lang dictionary_id='58021.ÖTV'></th>
					</cfcase>
					<cfcase value="31"> 
						<cfif isdefined("xml_discount") and xml_discount eq 1>
							<th style="min-width:50px;text-align:right;"><cf_get_lang dictionary_id='57641.İskonto'></th>
						</cfif>
					</cfcase>
					<cfcase value="32">
						<th style="min-width:70px;text-align:right;"><cf_get_lang dictionary_id='50999. bsmv Oran'></th>
					</cfcase>
					<cfcase value="33"> 
						<th style="min-width:150px;text-align:right;"><cf_get_lang dictionary_id='61963.bsmv Tutar'></th>
					</cfcase>
					<cfcase value="34">
						<th style="min-width:150px;text-align:right;"><cf_get_lang dictionary_id='61964.bsmv Döviz'></th>
					</cfcase>
					<cfcase value="35"> 
						<th style="min-width:50px;text-align:right;"><cf_get_lang dictionary_id='64355.OIV'> <cf_get_lang dictionary_id='58456.Oran'></th>
					</cfcase>
					<cfcase value="36"> 
						<th style="min-width:150px;text-align:right;"><cf_get_lang dictionary_id='64355.OIV'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					</cfcase>
					<cfcase value="37"> 
						<th style="min-width:150px;text-align:right;"><cf_get_lang dictionary_id='57391.Tevkifat Oranı	'></th>
					</cfcase>
					<cfcase value="38"> 
						<th style="min-width:150px;text-align:right;"><cf_get_lang dictionary_id='58022.Tevkifat'> <cf_get_lang dictionary_id='57673.Tutar'></th>
					</cfcase>
					<cfcase value="30"> 
						<cfif isdefined("xml_discount") and xml_discount eq 1>
							<th style="min-width:150px;text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						</cfif>
					</cfcase>
					<cfcase value="14"> 
						<th style="min-width:150px;text-align:right;"><cf_get_lang dictionary_id='39488.KDV li Toplam'></th>
					</cfcase>
					<cfcase value="15"> 
						<th style="min-width:90px"><cf_get_lang dictionary_id='57489.Para Br'></th>
					</cfcase>
                    <cfcase value="27"> 
						<th style="min-width:150px;text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'><cf_get_lang dictionary_id='57673.Tutar'></th>
					</cfcase>
					<cfcase value="16"> 
						<th style="min-width:150px;text-align:right;"><cf_get_lang dictionary_id='29954.Genel'><cf_get_lang dictionary_id='58124.Dövizli Toplam'></th>
					</cfcase>
					<cfcase value="17"> 
						<th style="min-width:130px"><cf_get_lang dictionary_id='33167.Akitivite Tipi'></th>
					</cfcase>
					<cfcase value="18"> 
						<th style="min-width:130px"><cf_get_lang dictionary_id='58140.İş Grubu'></th>
					</cfcase>
					<cfcase value="19"> 
						<th style="min-width:170px"><cf_get_lang dictionary_id='58445.İş'></th>
					</cfcase>
					<cfcase value="20"> 
						<th style="min-width:170px"><cf_get_lang dictionary_id='57612.Fırsat'></th>
					</cfcase>
					<cfcase value="21"> 
						<th style="min-width:170px"><cf_get_lang dictionary_id='57416.Proje'><cfif isDefined('xml_row_project_is_required') And xml_row_project_is_required Eq 1> *</cfif></th>
					</cfcase>
					<cfcase value="22"> 
						<th style="min-width:170px"><cf_get_lang dictionary_id='58832.Abone'></th>
					</cfcase>
					<cfcase value="23">
						<th style="min-width:170px"><cf_get_lang dictionary_id='33257.Harcama Yapan'></th>
					</cfcase>
					<cfcase value="24">
						<cfif ListFind("assetcare,cost,store",fusebox.circuit,',')><th style="min-width:170px"><cf_get_lang dictionary_id='58833.Fiziki Varlık'><cfif isdefined('x_is_required_physical_asset') and x_is_required_physical_asset eq 1>*</cfif></th></cfif>
					</cfcase>
                    
                    <!--- istisna --->
					<cfcase value="39">
						<th style="min-width:600px"><cf_get_lang dictionary_id='39939.İstisna'></th>
					</cfcase>
				</cfswitch>
			</cfloop>
		</tr>
	</thead>
	<tbody  name="table1" id="table1">
	<cfset expense_center_list = "">
	<cfset expense_item_list = "">
	<cfset subscription_list = "">
	<cfset pyschical_asset_list = "">
	<cfset work_head_list = "">
	<cfset opp_head_list = "">
	<cfset spect_id_list = "">
	<cfif get_rows.recordcount>
		<cfoutput query="get_rows">
			<cfif len(expense_center_id) and not listfind(expense_center_list,expense_center_id)>
				<cfset expense_center_list=listappend(expense_center_list,expense_center_id)>
			</cfif>
			<cfif len(expense_item_id) and not listfind(expense_item_list,expense_item_id)>
				<cfset expense_item_list=listappend(expense_item_list,expense_item_id)>
			</cfif>
			<cfif isdefined("subscription_id") and len(subscription_id) and not listfind(subscription_list,subscription_id)>
				<cfset subscription_list=listappend(subscription_list,subscription_id)>
			</cfif>
			<cfif isdefined("pyschical_asset_id") and len(pyschical_asset_id) and not listfind(pyschical_asset_list,pyschical_asset_id)>
				<cfset pyschical_asset_list=listappend(pyschical_asset_list,pyschical_asset_id)>
			</cfif>
			<cfif len(work_id) and not listfind(work_head_list,work_id)>
				<cfset work_head_list=listappend(work_head_list,work_id)>
			</cfif>
			<cfif len(opp_id) and not listfind(opp_head_list,opp_id)>
				<cfset opp_head_list=listappend(opp_head_list,opp_id)>
			</cfif>
			<cfif isdefined("spect_var_id") and len(spect_var_id) and not listfind(spect_id_list,spect_var_id)>
				<cfset spect_id_list=listappend(spect_id_list,spect_var_id)>
			</cfif>
		</cfoutput>
		<cfif ListLen(expense_center_list)>
			<cfquery name="get_expense_center" datasource="#dsn2#">
				SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_center_list#) ORDER BY EXPENSE_ID
			</cfquery>
			<cfset expense_center_list = ListSort(ListDeleteDuplicates(ValueList(get_expense_center.expense_id)),'numeric','ASC',',')>
		</cfif>
		<cfif ListLen(expense_item_list)>
			<cfquery name="get_expense_item" datasource="#dsn2#">
				SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#expense_item_list#) ORDER BY EXPENSE_ITEM_ID
			</cfquery>
			<cfset expense_item_list = ListSort(ListDeleteDuplicates(ValueList(get_expense_item.expense_item_id)),'numeric','ASC',',')>
		</cfif>
		<cfif ListLen(subscription_list)>
			<cfquery name="get_subscription" datasource="#dsn3#">
				SELECT SUBSCRIPTION_ID, SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IN (#subscription_list#) ORDER BY SUBSCRIPTION_ID
			</cfquery>
			<cfset subscription_list = ListSort(ListDeleteDuplicates(ValueList(get_subscription.subscription_id)),'numeric','ASC',',')>
		</cfif>
		<cfif ListLen(pyschical_asset_list)>
			<cfquery name="get_pyschical_asset" datasource="#dsn#">
				SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE ASSETP_ID IN (#pyschical_asset_list#) ORDER BY ASSETP_ID
			</cfquery>
			<cfset pyschical_asset_list = ListSort(ListDeleteDuplicates(ValueList(get_pyschical_asset.assetp_id)),'numeric','ASC',',')>
		</cfif>
		<cfif len(work_head_list)>
			<cfquery name="get_work" datasource="#dsn#">
				SELECT WORK_ID,WORK_HEAD FROM PRO_WORKS WHERE WORK_ID IN (#work_head_list#) ORDER BY WORK_ID
			</cfquery>
			<cfset work_head_list = ListSort(ListDeleteDuplicates(ValueList(get_work.work_id)),'numeric','ASC',',')>
		</cfif>
		<cfif len(opp_head_list)>
			<cfquery name="get_opportunities" datasource="#DSN3#">
				SELECT OPP_ID,OPP_HEAD FROM OPPORTUNITIES WHERE OPP_ID IN (#opp_head_list#) ORDER BY OPP_ID
			</cfquery>
			<cfset opp_head_list = ListSort(ListDeleteDuplicates(ValueList(get_opportunities.opp_id)),'numeric','ASC',',')>
		</cfif>
		<cfif len(spect_id_list)>
			<cfquery name="get_spect_name" datasource="#DSN3#">
				SELECT SPECT_VAR_NAME,SPECT_VAR_ID FROM SPECTS WHERE SPECT_VAR_ID IN (#spect_id_list#) ORDER BY SPECT_VAR_ID
			</cfquery>
			<cfset spect_id_list = ListSort(ListDeleteDuplicates(ValueList(get_spect_name.spect_var_id)),'numeric','ASC',',')>
		</cfif>
		<cfset sepet = StructNew()>
		<cfset sepet.kdv_array["rate"] = StructNew()>
		<cfset sepet.kdv_array["kdv_total"] = StructNew()>
		<cfset sepet.otv_array["otv_rate"] = StructNew()>
		<cfset sepet.otv_array["otv_total"] = StructNew()>
		<cfset sepet.bsmv_array["bsmv_rate"] = StructNew()>
		<cfset sepet.bsmv_array["bsmv_total"] = StructNew()>
		<cfset sepet.oiv_array["oiv_rate"] = StructNew()>
		<cfset sepet.oiv_array["oiv_total"] = StructNew()>
		<cfset kdv_total = 0.0>
		<cfset otv_total = 0.0>
		<cfset bsmv_total = 0.0>
		<cfset oiv_total = 0.0>
		<cfset kdv_rate_counter = 0>
		<cfset otv_rate_counter = 0>
		<cfset bsmv_rate_counter = 0>
		<cfset oiv_rate_counter = 0>
		<cfoutput query="get_rows">
			<cfset total_value_ = 0>
			<cfset net_total_value_ = 0>
			<cfset other_net_total_value_ = 0>			<!--- genel doviz toplam (kdv dahil) --->
			<cfset other_net_total_value_kdvsiz_ = 0>	<!--- doviz tutar --->
			<cfset deger_money = "">
			<cfset activity_type_ = "">
			<cfset workgroup_id_ = "">
            
			<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)><!--- Butceden Donustuyse --->
				<cfset total_value_ = row_total_expense>
				<cfset net_total_value_ = row_total_expense>
				<cfset other_net_total_value_ = other_row_total_expense>
				<cfset deger_money = get_money_rate.money_type>
				<cfset activity_type_ = activity_type_id>
				<cfset workgroup_id_ = workgroup_id>
			<cfelseif isdefined("attributes.credit_contract_id") and len(attributes.credit_contract_id)><!--- Kredi Fon Yonetiminden Donustuyse --->
				<cfif type eq 0>
					<cfset other_net_total_value_ = interest_price>
					<cfset total_value_ = interest_price*rate2>
					<cfset net_total_value_ = interest_price*rate2>
				<cfelse>
					<cfset other_net_total_value_ = capital_price>
					<cfset total_value_ = capital_price*rate2>
					<cfset net_total_value_ = capital_price*rate2>
				</cfif>
				<cfset discount_total = 0>
				<cfset discount_rate = 0>
				<cfset discount_price = 0.0>
				<cfset AMOUNT_BSMV = 0.0>
				<cfset BSMV_CURRENCY = 0.0>
				<cfset AMOUNT_OIV = 0.0>
				<cfset TEVKIFAT_RATE = 0>
				<cfset AMOUNT_TEVKIFAT = 0.0>
				<cfset deger_money = other_money>
				<cfset activity_type_ = "">
				<cfset workgroup_id_ = "">
                <cfif len(get_project.project_id)>
                	<cfset project_id = get_project.project_id>
                </cfif>
			<cfelseif isdefined("attributes.expense_id") and len(attributes.expense_id)><!--- Masraf Kopyalama Ise --->
				<cfset total_value_ = amount>
				<cfset net_total_value_ = total_amount>
				<cfset other_net_total_value_ = other_money_gross_total>
                <cfset other_net_total_value_kdvsiz_ = other_money_value>	
				<cfset deger_money = money_currency_id>
				<cfset activity_type_ = activity_type>
				<cfset workgroup_id_ = workgroup_id>
				<cfif isdefined("get_process_cat.is_expensing_oiv") and get_process_cat.is_expensing_oiv eq 1>
					<cfif not len(amount_oiv)><cfset get_rows.amount_oiv = 0.0></cfif>
					<cfset total_value_ = amount-amount_oiv>
					<cfset net_total_value_ = total_amount-amount_oiv>
					<!---<cfset other_net_total_value_ = other_net_total_value_-amount_oiv>
                	<cfset other_net_total_value_kdvsiz_ = other_net_total_value_kdvsiz_-amount_oiv>	--->
				</cfif>
				<cfif isdefined("get_process_cat.is_expensing_otv") and get_process_cat.is_expensing_otv eq 1>
					<cfif not (len(amount_otv))><cfset get_rows.amount_otv = 0.0></cfif>
					<cfset total_value_ = amount-amount_otv>
					<cfset net_total_value_ = total_amount-amount_otv>
				<!---	<cfset other_net_total_value_ = other_net_total_value_-amount_otv>
                	<cfset other_net_total_value_kdvsiz_ = other_net_total_value_kdvsiz_-amount_otv>	 --->
				</cfif>
			<cfelseif isdefined("attributes.request_id") and len(attributes.request_id)><!--- Harcama Talebinden Donustuyse --->
				<cfset total_value_ = amount>
				<cfset net_total_value_ = total_amount>
				<cfset other_net_total_value_ = other_money_value>
				<cfset deger_money = money_currency_id>
				<cfset activity_type_ = activity_type>
				<cfset workgroup_id_ = "">
				<cfset discount_total = amount>
				<cfset discount_rate = 0>
				<cfset discount_price = 0.0>
				<cfset AMOUNT_BSMV = 0.0>
				<cfset BSMV_CURRENCY = 0.0>
				<cfset AMOUNT_OIV = 0.0>
				<cfset TEVKIFAT_RATE = 0>
				<cfset AMOUNT_TEVKIFAT = 0.0>
            <cfelseif isdefined("attributes.is_from_report")>
            	<cfset total_value_ = amount>
				<cfset net_total_value_ = total_amount>
				<cfset other_net_total_value_ = other_money_gross_total>
                <cfset other_net_total_value_kdvsiz_ = other_money_value>
				<cfset deger_money = money_currency_id>
				<cfset activity_type_ = activity_type>
				<cfset workgroup_id_ = "">
            <cfelseif isdefined("attributes.receiving_detail_id")>
            	<cfset total_value_ = price>
				<cfset net_total_value_ = taxtotal>
                <cfset other_net_total_value_= taxtotal+nettotal >
				<cfset deger_money = money>
                <cfset expense_account_code = account_code_pur>
                <cfset quantity = amount>
                <cfset kdv_rate = tax>
			</cfif>
			<!--- Satirlardaki Veriler Degisken Olarak Geliyor --->
			<tr id="frm_row#currentrow#" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td><cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id) or (isdefined("attributes.expense_id") and len(attributes.expense_id) and len(budget_plan_row_id))>
						<input type="hidden" name="budget_plan_row_id#currentrow#" id="budget_plan_row_id#currentrow#" value="#budget_plan_row_id#">
					</cfif>
					<cfif isDefined("attributes.expense_id") and Len(attributes.expense_id) and fusebox.fuseaction contains 'upd_' and len(wrk_row_id)>
						<cfset WrkRowID = wrk_row_id>
					<cfelse>
						<cfset WrkRowID = "WRK#currentrow##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##currentrow#">
					</cfif>
					<cfif isdefined("attributes.credit_contract_id") and isdefined("attributes.credit_contract_row_id")>
						<cfif isDefined('get_rows.type') and get_rows.type EQ 1>
							<cfset is_interest_ = 0>
						<cfelse>
							<cfset is_interest_ = 1>
						</cfif>
					<cfelseif isdefined("get_rows.is_interest")>
						<cfset is_interest_ = get_rows.is_interest>
					<cfelse>
						<cfset is_interest_ = 0>
					</cfif>
					<input type="hidden" name="wrk_row_id#currentrow#" id="wrk_row_id#currentrow#" value="#WrkRowID#">
					<input type="hidden" name="credit_type#currentrow#" id="credit_type#currentrow#" value="<cfif is_interest_ eq 1>0<cfelse>1</cfif>">
					<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1" title="#detail#">
					<a href="javascript://" onClick="sil('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
				</td>
				<td>
					<a href="javascript://" onClick="copy_row('#currentrow#');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='57476.Kopyala'>" alt="<cf_get_lang dictionary_id='57476.Kopyala'>"></i></a>
				</td>
				<!--- Proje Oncelikli Islem Icin, Listede Kolonlar Gosterilmiyorsa Degerler Hidden Olarak Gonderilir, Bilgiler Projeden Atilir --->
				<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),3) or x_is_project_priority eq 1>
					<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#expense_center_id#">
					<input type="hidden" name="expense_center_name#currentrow#" id="expense_center_name#currentrow#" value="<cfif len(expense_center_id)>#get_expense_center.expense[listfind(expense_center_list,expense_center_id,',')]#</cfif>">
				</cfif>
				<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),4) or x_is_project_priority eq 1>
					<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#expense_item_id#">
					<input type="hidden" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#" value="<cfif len(expense_item_id)>#get_expense_item.expense_item_name[listfind(expense_item_list,expense_item_id,',')]#</cfif>">
				</cfif>
				<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),5) or x_is_project_priority eq 1>
					<input type="hidden" name="account_code#currentrow#" id="account_code#currentrow#" value="<cfif len(expense_account_code)>#expense_account_code#<cfelseif len(expense_item_id)>#get_expense_item.account_code[listfind(expense_item_list,expense_item_id,',')]#</cfif>"  class="boxtext" readonly="yes" title="#detail#">
				</cfif>
				<cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
					<cfswitch expression="#xlr#">
						<cfcase value="1"><!--- 1.Tarih --->
							<td nowrap="nowrap">
							<cfif isdefined("GET_EXPENSE.REQUEST_ID") and len(GET_EXPENSE.REQUEST_ID)>
									<cfquery name="get_request_rel" datasource="#dsn2#">
										SELECT 
											EXPENSE_DATE
										FROM
											EXPENSE_ITEM_PLAN_REQUESTS_ROWS
										WHERE EXPENSE_ID = #get_expense.request_id#
									</cfquery>
								<cfelse>
										<cfset get_request_rel.recordcount = 0>
								</cfif>
								<cfif isdefined("xml_budget_row_date") and xml_budget_row_date eq 1>
									<div class="form-group"><div class="input-group"><input type="text" name="expense_date#currentrow#" id="expense_date#currentrow#" value="<cfif isdefined("get_rows.expense_date") and len(get_rows.expense_date)>#dateformat(get_rows.expense_date,dateformat_style)#<cfelseif isdefined("get_expense.expense_date") and len(get_expense.expense_date)>#dateformat(get_expense.expense_date,dateformat_style)#</cfif>" title="#detail#"><span class="input-group-addon"><cf_wrk_date_image date_field="expense_date#currentrow#"></span></div></div>
								<cfelse>
									<div class="form-group"><div class="input-group"><input type="text" name="receipt_date#currentrow#" id="receipt_date#currentrow#" value="<cfif isdefined("get_rows.receipt_date") and len(get_rows.receipt_date)>#dateformat(get_rows.receipt_date,dateformat_style)#<cfelseif  (isdefined("attributes.request_id") and len(attributes.request_id)) or get_request_rel.recordcount>#dateformat(get_rows.expense_date,dateformat_style)#<cfelseif isdefined("get_expense.expense_date") and len(get_expense.expense_date)>#dateformat(get_expense.expense_date,dateformat_style)#</cfif>" title="#detail#"><span class="input-group-addon"><cf_wrk_date_image date_field="expense_date#currentrow#"></span></div></div>
								</cfif>
							</td>
						</cfcase>
						<cfcase value="2"><!--- 2.Açıklama --->
							<td><div class="form-group"><input type="text" name="row_detail#currentrow#" id="row_detail#currentrow#" value="#detail#" class="boxtext"  title="#detail#"></div></td>
						</cfcase>
						<cfcase value="40">
							<td nowrap>
								<div class="form-group">
                                	<cf_wrkdepartmentbranch fieldid='row_branch#currentrow#' is_branch='1' width='135' is_deny_control='1' selected_value='#isdefined('get_rows.BRANCH_ID') ? get_rows.BRANCH_ID : GET_BRANCH_DET.branch_ID#'>
								</div>
                            </td>
						</cfcase>
						<cfcase value="3"><!--- 3.Masraf Merkezi --->
							<cfif x_is_project_priority eq 0>
								<td>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#expense_center_id#">
											<input type="text" name="expense_center_name#currentrow#" id="expense_center_name#currentrow#" value="<cfif len(expense_center_id)>#get_expense_center.expense[listfind(expense_center_list,expense_center_id,',')]#</cfif>" class="boxtext"  onFocus="AutoComplete_Create('expense_center_name#currentrow#','EXPENSE','EXPENSE','get_expense_center','0,<cfif isDefined("x_authorized_branch_department") and x_authorized_branch_department eq 1>1<cfelse>0</cfif>','EXPENSE_ID','expense_center_id#currentrow#','add_costplan',1);" autocomplete="off">
											<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_exp('#currentrow#');"></span>
										</div>
									</div>	
								</td>
							</cfif>
						</cfcase>
						<cfcase value="4"><!--- 4.Gider/Gelir Kalemi --->
							<cfif x_is_project_priority eq 0>
								<td>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#expense_item_id#">
											<input type="text" name="expense_item_name#currentrow#" id="expense_item_name#currentrow#" value="<cfif len(expense_item_id)>#get_expense_item.expense_item_name[listfind(expense_item_list,expense_item_id,',')]#</cfif>" class="boxtext" onFocus="AutoComplete_Create('expense_item_name#currentrow#','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>','EXPENSE_ITEM_ID,ACCOUNT_CODE,TAX_CODE','expense_item_id#currentrow#,account_code#currentrow#,tax_code#currentrow#','add_costplan',1);" autocomplete="off">
											<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_item('#currentrow#',<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>);"></span>
										</div>
									</div>
								</td>
							</cfif>
						</cfcase>
						<cfcase value="5"><!--- 5.Muhasebe Kodu --->
							<cfif x_is_project_priority eq 0>
								<td>
									<div class="form-group">
										<div class="input-group">
											<input type="text" name="account_code#currentrow#" id="account_code#currentrow#" onFocus="AutoComplete_Create('account_code#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" value="#expense_account_code#" class="boxtext" title="#detail#">
											<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_acc('#currentrow#');"></a>
										</div>
									</div>
								</td>
							</cfif>
						</cfcase>
						<cfcase value="26"><!--- 26.Vergi Kodu --->
							<cfif not(fuseaction contains "assetcare")>
								<td>
									<div class="form-group">
										<select name="tax_code#currentrow#" id="tax_code#currentrow#"  class="boxtext">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop query="TAX_CODES">
												<option value="#TAX_CODE_ID#" title="#detail#" <cfif get_rows.tax_code eq tax_codes.tax_code_id>selected="selected"</cfif>>#TAX_CODE_NAME#</option>
											</cfloop>
										</select>
									</div>
								</td>				
							</cfif>
						</cfcase>
						<cfcase value="6"><!--- 6.Ürün --->
							<td style="text-align:right;">
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>#stock_id_2#<cfelseif isdefined("attributes.request_id") and len(attributes.request_id)>#stock_id#</cfif>">
										<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="<cfif isdefined("product_id") and len(product_id)>#product_id#</cfif>">
										<cfif isdefined("is_product_cost_default") and is_product_cost_default eq 1>
											<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="<cfif isdefined("product_id") and len(product_id)>#get_product_name(product_id)#</cfif>" class="boxtext" onFocus="AutoComplete_Create('product_name#currentrow#','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID,PRODUCT_COST,MAIN_UNIT,PRODUCT_UNIT_ID','product_id#currentrow#,stock_id#currentrow#,total#currentrow#,stock_unit#currentrow#,stock_unit_id#currentrow#','add_costplan',1,'','format_total_value(#currentrow#);');" >
										<cfelse>
											<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="<cfif isdefined("product_id") and len(product_id)>#get_product_name(product_id)#</cfif>" class="boxtext" onFocus="AutoComplete_Create('product_name#currentrow#','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID,MAIN_UNIT,PRODUCT_UNIT_ID','product_id#currentrow#,stock_id#currentrow#,stock_unit#currentrow#,stock_unit_id#currentrow#','add_costplan',1,'','format_total_value(#currentrow#);');">
										</cfif>
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid='+document.getElementById('product_id#currentrow#').value+'&sid='+document.getElementById('stock_id#currentrow#').value+'','list');"></span>
										<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_product('#currentrow#');"></span>
									</div>
								</div>
							</td>
						</cfcase>
						<cfcase value="25"><!--- 25. Spec --->
							<cfif fuseaction contains "assetcare">
								<td>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="spect_var_id#currentrow#" id="spect_var_id#currentrow#" value="<cfif isdefined("spect_var_id") and len(spect_var_id)>#spect_var_id#</cfif>">
											<input type="text" name="spect_name#currentrow#" id="spect_name#currentrow#" value="<cfif isdefined("spect_var_id") and len(spect_var_id)>#get_spect_name.spect_var_name[ListFind(spect_id_list,spect_var_id,',')]#</cfif>" class="boxtext" >
											<span class="input-group-addon icon-ellipsis" onClick="product_control('#currentrow#');"></span>								
										</div>
									</div>
								</td>
							</cfif>
						</cfcase>
						<cfcase value="7"><!--- 7.Birim --->
							<td>
								<div class="form-group">
									<input type="hidden" name="stock_unit_id#currentrow#" id="stock_unit_id#currentrow#" value="#unit_id#">
									<input type="text" name="stock_unit#currentrow#" id="stock_unit#currentrow#" class="boxtext" value="#unit#" readonly="yes">
								</div>
							</td>
						</cfcase>
						<cfcase value="8"><!--- 8.Miktar --->
							<td>
								<div class="form-group">
									<input type="text" name="quantity#currentrow#" id="quantity#currentrow#" onkeypress="return NumberControl(event)" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" class="box" value="#TLFormat(quantity,xml_satir_number)#" onkeydown="enterControl(event,'quantity','#currentrow#');" onBlur="<cfif isdefined("xml_discount") and xml_discount eq 1>disc_hesapla('#currentrow#');</cfif>hesapla('quantity','#currentrow#');" onkeyup="return(FormatCurrency(this,event,#xml_satir_number#));">
								</div>
							</td>
						</cfcase>
						<cfcase value="9"><!--- 9.Tutar --->
							<td>
								<div class="form-group">
									<input type="text" name="total#currentrow#" id="total#currentrow#" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" value="#TLFormat(total_value_,xml_satir_number)#" onKeyUp="return(FormatCurrency(this,event,#xml_satir_number#));" onkeypress="return NumberControl(event)" onkeydown="enterControl(event,'total','#currentrow#');"  onBlur="<cfif isdefined("xml_discount") and xml_discount eq 1>disc_total_hesapla('#currentrow#')</cfif>;hesapla('total','#currentrow#');" class="box" title="#detail#">
								</div>
							</td>
						</cfcase>
						<cfcase value="10"><!--- 10.Kdv % --->
							<td>
								<div class="form-group">
									<select name="tax_rate#currentrow#" id="tax_rate#currentrow#" onChange="hesapla('tax_rate','#currentrow#');">
										<cfif isdefined("kdv_rate")><cfset kdvdeger = kdv_rate><cfelse><cfset kdvdeger = ""></cfif>
										<cfloop query="get_tax">
											<option value="#tax#" <cfif kdvdeger eq tax>selected</cfif>>#tax#</option>
										</cfloop>
									</select>
								</div>
							</td>
							<cfif ArrayLen(StructFindValue(sepet.kdv_array["rate"],kdvdeger,'all')) eq 0>
								<cfset kdv_total = 0.0>
								<cfset kdv_rate_counter++>
								<cfset sepet.kdv_array["rate"][kdv_rate_counter] = kdvdeger>
							</cfif>
						</cfcase>
						<cfcase value="11"><!--- 11.Ötv % --->
							<td>
								<div class="form-group">
									<select name="otv_rate#currentrow#" id="otv_rate#currentrow#" onChange="hesapla('otv_rate','#currentrow#');">
										<option value="0"><cf_get_lang dictionary_id="58021.ÖTV"></option>																		
										<cfif isdefined("otv_rate")><cfset otvdeger = otv_rate><cfelse><cfset otvdeger = ""></cfif>
										<cfloop query="get_otv">
											<option value="#tax#" <cfif otvdeger eq tax>selected</cfif>>#tlformat(tax)#</option>
										</cfloop>
									</select>
								</div>
							</td>
							<cfif ArrayLen(StructFindValue(sepet.otv_array["otv_rate"],otvdeger,'all')) eq 0>
								<cfset otv_total = 0.0>
								<cfset otv_rate_counter++>
								<cfset sepet.otv_array["otv_rate"][otv_rate_counter] = otvdeger>
							</cfif>
						</cfcase>
						<cfcase value="29">
							<cfif isdefined("xml_discount") and xml_discount eq 1>
								<td>
									<div class="form-group">
										<input type="text" name="discount_rate#currentrow#" id="discount_rate#currentrow#" onkeypress="return NumberControl(event)" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" class="box" value="<cfif isDefined('discount_rate') and len(discount_rate)>#TLFormat(discount_rate)#</cfif>" onkeydown="enterControl(event,'total','#currentrow#');" onBlur="<cfif isdefined("xml_discount") and xml_discount eq 1> disc_hesapla('#currentrow#');</cfif>hesapla('total','#currentrow#');" onkeyup="return(FormatCurrency(this,event,#xml_satir_number#));">
									</div>
								</td>
							</cfif>
						</cfcase>
						<cfcase value="12"><!--- 12.Kdv --->
							<td>
								<div class="form-group">
									<input type="text" name="kdv_total#currentrow#" id="kdv_total#currentrow#" onkeypress="return NumberControl(event)" value="<cfif (isdefined("attributes.expense_id") and len(attributes.expense_id)) or (isdefined("attributes.request_id") and len(attributes.request_id))>#TLFormat(amount_kdv,xml_satir_number)#<cfelse>#TLFormat(0,xml_satir_number)#</cfif>" onKeyUp="return(FormatCurrency(this,event,#xml_satir_number#));" onkeydown="enterControl(event,'kdv_total','#currentrow#',1);" onBlur="hesapla('kdv_total','#currentrow#',1);" class="box" title="#detail#">
								</div>
							</td>
							<cfif isdefined("kdvdeger")>
								<cfif (isdefined("attributes.expense_id") and len(attributes.expense_id)) or (isdefined("attributes.request_id") and len(attributes.request_id))>
									<cfset kdv_total = kdv_total + amount_kdv>
									<cfset sepet.kdv_array["kdv_total"][kdv_rate_counter] = kdv_total>
								
								<cfelse>
									<cfset sepet.kdv_array["kdv_total"][kdv_rate_counter] = 0>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="13"><!--- 13.Ötv --->
							<td>
								<div class="form-group">
									<input type="text" name="otv_total#currentrow#" id="otv_total#currentrow#" onkeypress="return NumberControl(event)" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" value="<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>#TLFormat(amount_otv,xml_satir_number)#<cfelse>#TLFormat(0,xml_satir_number)#</cfif>" onKeyUp="return(FormatCurrency(this,event,#xml_satir_number#));" onkeydown="enterControl(event,'otv_total','#currentrow#',1);" onBlur="hesapla('otv_total','#currentrow#',1);" class="box" title="#detail#">
								</div>
							</td>
							<cfif isdefined("kdvdeger")>
								<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>
									<cfset otv_total = otv_total + amount_otv>
									<cfset sepet.otv_array["otv_total"][otv_rate_counter] = otv_total>
								<cfelse>
									<cfset sepet.otv_array["otv_total"][otv_rate_counter] = 0>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="31">
							<cfif isdefined("xml_discount") and xml_discount eq 1>
								<td>
									<div class="form-group">
										<input type="text" name="discount_price#currentrow#" id="discount_price#currentrow#" onkeypress="return NumberControl(event)" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" value="#TLFormat(discount_price,xml_satir_number)#" onKeyUp="return(FormatCurrency(this,event,#xml_satir_number#));"  onkeydown="enterControl(event,'total','#currentrow#');" onBlur="<cfif isdefined("xml_discount") and xml_discount eq 1>disc_hesapla(#currentrow#);</cfif> hesapla('total',#currentrow#);" class="box">
									</div>
								</td>
							</cfif>
						</cfcase>
						<cfcase value="32"> <!--- Bsmv Oran --->
							<td>
								<div class="form-group">
									<select name="row_bsmv_rate#currentrow#" id="row_bsmv_rate#currentrow#" onChange="hesapla('row_bsmv_rate','#currentrow#');">
										<option value="0">BSMV</option>																
										<cfif isdefined("bsmv_rate")><cfset bsmvdeger = bsmv_rate><cfelse><cfset bsmvdeger = ""></cfif>
										<cfloop query="get_bsmv">
											<option value="#tax#" <cfif bsmvdeger eq tax>selected</cfif>>#tlformat(tax)#</option>
										</cfloop>	
									</select>
								</div>
							</td>
							<cfif ArrayLen(StructFindValue(sepet.bsmv_array["bsmv_rate"],bsmvdeger,'all')) eq 0>
								<cfset bsmv_total = 0.0>
								<cfset bsmv_rate_counter++>
								<cfset sepet.bsmv_array["bsmv_rate"][bsmv_rate_counter] = bsmvdeger>
							</cfif>
						</cfcase>
						<cfcase value="33"> <!--- Bsmv Tutar --->
							<td>
								<div class="form-group">
									<input type="text" name="row_bsmv_amount#currentrow#" id="row_bsmv_amount#currentrow#" onkeypress="return NumberControl(event)" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" value="<cfif len(AMOUNT_BSMV)> #TLFormat(AMOUNT_BSMV,xml_satir_number)# <cfelse> #TLFormat(0,xml_satir_number)# </cfif>" onKeyUp="return(FormatCurrency(this,event,#xml_satir_number#));"  onkeydown="enterControl(event,'total','#currentrow#');"  onBlur="hesapla('row_bsmv_amount',#currentrow#);" class="box">
								</div>
							</td>
							<cfif isdefined("bsmvdeger") and len(bsmvdeger)>
								<cfset bsmv_total = bsmv_total + AMOUNT_BSMV>
								<cfset sepet.bsmv_array["bsmv_total"][bsmv_rate_counter] = bsmv_total>
							<cfelse>
								<cfset sepet.bsmv_array["bsmv_total"][bsmv_rate_counter] = 0>
							</cfif>
						</cfcase>
						<cfcase value="34"> <!--- Bsmv Döviz --->
							<td>
								<div class="form-group">
									<input type="text" name="row_bsmv_currency#currentrow#" id="row_bsmv_currency#currentrow#" onkeypress="return NumberControl(event)" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" value="<cfif len(BSMV_CURRENCY)> #TLFormat(BSMV_CURRENCY,xml_satir_number)#<cfelse>#TLFormat(0,xml_satir_number)#</cfif>" onKeyUp="return(FormatCurrency(this,event,#xml_satir_number#));"  onkeydown="enterControl(event,'total','#currentrow#');" onBlur="hesapla('row_bsmv_currency',#currentrow#);" class="box">
								</div>
							</td>
						</cfcase>
						<cfcase value="35"> <!--- Oiv Oran --->
							<cfif isdefined("oiv_rate")><cfset oivdeger = oiv_rate><cfelse><cfset oivdeger = ""></cfif>
							<td>
								<div class="form-group">
									<select name="row_oiv_rate#currentrow#" id="row_oiv_rate#currentrow#" onChange="hesapla('row_oiv_rate','#currentrow#');">
										<option value="0">OIV</option>																		
										<cfloop query="get_oiv">
											<option value="#tax#" <cfif oivdeger eq tax>selected</cfif>>#tlformat(tax)#</option>
										</cfloop>
									</select>
								</div>
							</td>
							<cfif ArrayLen(StructFindValue(sepet.oiv_array["oiv_rate"],oivdeger,'all')) eq 0>
								<cfset oiv_total = 0.0>
								<cfset oiv_rate_counter++>
								<cfset sepet.oiv_array["oiv_rate"][oiv_rate_counter] = oivdeger>
							</cfif>
						</cfcase>
						<cfcase value="36"> <!--- Oiv Tutar --->
							<td>
								<div class="form-group">
									<input type="text" name="row_oiv_amount#currentrow#" id="row_oiv_amount#currentrow#" onkeypress="return NumberControl(event)" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" value="<cfif len(AMOUNT_OIV)>#TLFormat(AMOUNT_OIV,xml_satir_number)#<cfelse>#TLFormat(0,xml_satir_number)#</cfif>" onKeyUp="return(FormatCurrency(this,event,#xml_satir_number#));"  onkeydown="enterControl(event,'total','#currentrow#');" onBlur="hesapla('row_oiv_amount',#currentrow#);" class="box">
								</div>
							</td>
							<cfif isdefined("oivdeger") and len(oivdeger)>
								<cfset oiv_total = oiv_total + AMOUNT_OIV>
								<cfset sepet.oiv_array["oiv_total"][oiv_rate_counter] = oiv_total>
							<cfelse>
								<cfset sepet.oiv_array["oiv_total"][oiv_rate_counter] = 0>
							</cfif>
						</cfcase>
						<cfcase value="37"> <!--- Tevkifat Oran --->
							<td>
								<div class="form-group">
									<input type="text" name="row_tevkifat_rate#currentrow#" id="row_tevkifat_rate#currentrow#" onkeypress="return NumberControl(event)" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" value="<cfif len(TEVKIFAT_RATE)>#TLFormat(TEVKIFAT_RATE,xml_satir_number)#<cfelse>#TLFormat(0,xml_satir_number)#</cfif>" onKeyUp="return(FormatCurrency(this,event,#xml_satir_number#));"  onkeydown="enterControl(event,'total','#currentrow#');" onBlur="hesapla('row_tevkifat_rate',#currentrow#);" class="box">
								</div>
							</td>
						</cfcase>
						<cfcase value="38"> <!--- Tevkifat Tutar --->
							<td>
								<div class="form-group">
									<input type="text" name="row_tevkifat_amount#currentrow#" id="row_tevkifat_amount#currentrow#" onkeypress="return NumberControl(event)" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" value="<cfif len(AMOUNT_TEVKIFAT)>#TLFormat(AMOUNT_TEVKIFAT,xml_satir_number)#<cfelse>#TLFormat(0,xml_satir_number)#</cfif>" onKeyUp="return(FormatCurrency(this,event,#xml_satir_number#));"  onkeydown="enterControl(event,'total','#currentrow#');" onBlur="hesapla('row_tevkifat_amount',#currentrow#);" class="box">
								</div>
							</td>
						</cfcase>
						<cfcase value="30">
							<cfif isdefined("xml_discount") and xml_discount eq 1>
								<td>
									<div class="form-group">
										<input type="text" name="discount_total#currentrow#" id="discount_total#currentrow#" onkeypress="return NumberControl(event)" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" value="#TLFormat(discount_total,xml_satir_number)#" onKeyUp="return(FormatCurrency(this,event,#xml_satir_number#));"  onkeydown="enterControl(event,'total','#currentrow#');" onBlur="<cfif isdefined("xml_discount") and xml_discount eq 1>disc_hesapla(#currentrow#);</cfif>hesapla('total',#currentrow#);" class="box">
									</div>
								</td>
							</cfif>
						</cfcase>
						<cfcase value="14"><!--- 14.Genel Toplam --->	
							<td>
								<div class="form-group">
									<input type="text" name="net_total#currentrow#" id="net_total#currentrow#" onkeypress="return NumberControl(event)" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" value="#TLFormat(net_total_value_,xml_satir_number)#" onKeyUp="return(FormatCurrency(this,event,#xml_satir_number#));"  onkeydown="enterControl(event,'net_total','#currentrow#',2);" onBlur="hesapla('net_total','#currentrow#',2);<cfif isdefined("xml_discount") and xml_discount eq 1>disc_total_hesapla(#currentrow#);</cfif>" class="box" title="#detail#">
								</div>
							</td>
						</cfcase>
						<cfcase value="15"><!--- 15.Para Br --->
							<td>
								<div class="form-group">
									<select name="money_id#currentrow#" id="money_id#currentrow#"  class="boxtext" onChange="other_calc('#currentrow#');" title="#detail#">
										<cfloop query="get_money">
											<cfif isdefined("money")><cfset money_ = money><cfelse><cfset money_ = money_type></cfif>
											<option value="#money_#,#rate1#,#rate2#" <cfif deger_money eq money_>selected</cfif>>#money_#</option>
										</cfloop>
									</select>
								</div>
							</td>
						</cfcase>
                        <cfcase value="27"><!--- 27.Döviz Tutar --->
							<td>
								<div class="form-group">
									<input type="text" name="other_net_total_kdvsiz#currentrow#" id="other_net_total_kdvsiz#currentrow#" onkeypress="return NumberControl(event)" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" value="#TLFormat(other_net_total_value_kdvsiz_,xml_satir_number)#" onkeyup="return(FormatCurrency(this,event,#xml_satir_number#));" onBlur="other_calc_kdvsiz('#currentrow#',2);" class="box" title="#detail#">
								</div>
							</td>
						</cfcase>
						<cfcase value="16"><!--- 16.Genel Doviz Toplam --->
							<td>
								<div class="form-group">
									<input type="text" name="other_net_total#currentrow#" id="other_net_total#currentrow#" onkeypress="return NumberControl(event)" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#xml_satir_number#);this.select();" value="#TLFormat(other_net_total_value_,xml_satir_number)#" onkeyup="return(FormatCurrency(this,event,#xml_satir_number#));" onBlur="other_calc('#currentrow#',2);" class="box" title="#detail#">
								</div>
							</td>
						</cfcase>
						<cfcase value="17"><!--- 17.Aktivite Tipi --->
							<td>
								<div class="form-group">
									<select name="activity_type#currentrow#" id="activity_type#currentrow#" class="boxtext">
										<option value=""><cf_get_lang dictionary_id='33167.Akitivite Tipi'></option>
										<cfloop query="get_activity_types">
											<option value="#activity_id#" <cfif activity_type_ eq activity_id>selected</cfif>>#activity_name#</option>
										</cfloop>
									</select>
								</div>
							</td>
						</cfcase>
						<cfcase value="18"><!--- 18.İş Grubu --->
							<td>
								<div class="form-group">
									<select name="workgroup_id#currentrow#" id="workgroup_id#currentrow#" class="boxtext">
										<option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>
										<cfloop query="get_workgroups">
											<option value="#workgroup_id#" <cfif workgroup_id_ eq workgroup_id>selected</cfif>>#workgroup_name#</option>
										</cfloop>
									</select>
								</div>
							</td>
						</cfcase>
						<cfcase value="19"><!--- 19.İş --->
							<td>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="work_id#currentrow#" id="work_id#currentrow#" value="#work_id#" class="boxtext">
										<input type="text" name="work_head#currentrow#" id="work_head#currentrow#" class="boxtext" onFocus="AutoComplete_Create('work_head#currentrow#','WORK_HEAD','WORK_HEAD','get_work','','WORK_ID','work_id#currentrow#','',3,124);" value="<cfif len(work_id)>#get_work.work_head[listfind(work_head_list,work_id,',')]#</cfif>">
										<cfif len(work_id)><span class="input-group-addon icon-ellipsis ellipsis-red" onclick="pencere_detail_work(#currentrow#);"></span><cfelse></cfif>
										<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_work('#currentrow#');"></span>
									</div>
								</div>
							</td>
						</cfcase>
						<cfcase value="20"><!--- 20.Fırsat --->
							<td>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="opp_id#currentrow#" id="opp_id#currentrow#" value="#opp_id#" class="boxtext">
										<input type="text" name="opp_head#currentrow#" id="opp_head#currentrow#" class="boxtext" onFocus="AutoComplete_Create('opp_head#currentrow#','OPP_HEAD','OPP_HEAD','get_opportunity','3','OPP_ID','opp_id#currentrow#','',3,135);" value="<cfif len(opp_id)>#get_opportunities.opp_head[listfind(opp_head_list,opp_id,',')]#</cfif>">
										<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_oppotunity('#currentrow#');"></span>
									</div>
								</div>
							</td>
						</cfcase>
						<cfcase value="21"><!--- 21.Proje --->
							<td>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="<cfif isdefined("project_id") and len(project_id)>#project_id#</cfif>">
										<input type="text" name="project#currentrow#" id="project#currentrow#" onFocus="auto_project('#currentrow#');" value="<cfif isdefined("project_id") and len(project_id)>#get_project_name(project_id)#</cfif>" autocomplete="off" class="boxtext" title="#detail#">
										<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_project('#currentrow#');"></span>
									</div>
								</div>
							</td>
						</cfcase>
						<cfcase value="22"><!--- 22.Sistem --->
							<td>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="subscription_id#currentrow#" id="subscription_id#currentrow#" value="<cfif isdefined("subscription_id") and len(subscription_id)>#subscription_id#</cfif>">
										<input type="text" name="subscription_name#currentrow#" id="subscription_name#currentrow#" onFocus="AutoComplete_Create('subscription_name#currentrow#','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id#currentrow#','','3','150');" value="<cfif isdefined("subscription_id") and len(subscription_id)>#get_subscription.subscription_no[ListFind(subscription_list,subscription_id,',')]#</cfif>" class="boxtext" title="#detail#">
										<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_subs('#currentrow#');"></span>
									</div>
								</div>
							</td>
						</cfcase>
						<cfcase value="23"><!--- 23.Harcama Yapan --->
							<td>
								<cfif isdefined("member_type") and member_type eq 'partner'>
									<cfset member_type_ = "partner">
									<cfset member_id_ = company_partner_id>
									<cfset company_id_= company_id>
									<cfset authorized_ = get_par_info(company_partner_id,0,-1,0)>
									<cfset company_ = get_par_info(company_id,1,0,0)>
								<cfelseif isdefined("member_type") and member_type eq 'consumer'>
									<cfset member_type_ = "consumer">
									<cfset member_id_ = company_partner_id>
									<cfset company_id_= "">
									<cfset authorized_ = get_cons_info(company_partner_id,0,0)>
									<cfset company_ = get_cons_info(company_partner_id,2,0)>
								<cfelseif isdefined("member_type") and member_type eq 'employee'>
									<cfset member_type_ = "employee">
									<cfset member_id_ = company_partner_id>
									<cfset company_id_= "">
									<cfset authorized_ = get_emp_info(company_partner_id,0,0)>
									<cfset company_ = "">
								<cfelse>
									<cfset member_type_ = "">
									<cfset member_id_ = "">
									<cfset company_id_= "">
									<cfset authorized_ = "">
									<cfset company_ = "">
								</cfif>
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="#member_type_#">
										<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#member_id_#">
										<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id_#">
										<input type="text" name="authorized#currentrow#" id="authorized#currentrow#" value="#authorized_#" class="boxtext" title="#detail#">
										<input type="hidden" name="company#currentrow#" id="company#currentrow#" onFocus="AutoComplete_Create('authorized#currentrow#','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2,3\'','MEMBER_TYPE,PARTNER_ID2,COMPANY_ID,MEMBER_PARTNER_NAME2','member_type#currentrow#,member_id#currentrow#,company_id#currentrow#,authorized#currentrow#','','3','115');" value="#company_#"class="boxtext" title="#detail#">
										<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_company('#currentrow#');"></span>
									</div>
								</div>
								
							</td>
						</cfcase>
						<cfcase value="24"><!--- 24.Fiziki Varlık --->
							<cfif ListFind("assetcare,cost,store",fusebox.circuit,',')>
								<td>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="asset_id#currentrow#" id="asset_id#currentrow#" value="<cfif isdefined("pyschical_asset_id") and len(pyschical_asset_id)>#pyschical_asset_id#</cfif>">
											<input type="text" name="asset#currentrow#" id="asset#currentrow#" value="<cfif isdefined("pyschical_asset_id") and len(pyschical_asset_id)>#get_pyschical_asset.assetp[ListFind(pyschical_asset_list,pyschical_asset_id,',')]#</cfif>"  class="boxtext" onFocus="autocomp_assetp('#currentrow#');" autocomplete="off" title="#detail#">
											<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_asset('#currentrow#');"></span>
										</div>
									</div>
								</td>
							</cfif>
						</cfcase>
                        
                        <!--- istisna --->
						<cfcase value="39">
							<td>
								<div class="form-group">
									<select name="reason_code#currentrow#" id="reason_code#currentrow#" style="width:175px;" class="boxtext">
										<option value=""><cf_get_lang dictionary_id='39939.İstisna'></option>
										<cfset reason_code_info_ = '#reason_code#--#reason_name#'>
										<cfloop list="#reason_code_list#" index="info_list" delimiters="*">
											<option value='#listfirst(info_list,'*')#' <cfif listfirst(info_list,'*') is reason_code_info_>selected</cfif>>#listlast(info_list,'*')#</option>
										</cfloop>
									</select>
								</div>
							</td>
						</cfcase>
					</cfswitch>
				</cfloop>
			</tr>
		</cfoutput>
	</cfif>
	</tbody> 
</cf_grid_list>
<script type="text/javascript">
	<cfif isdefined("get_rows") and get_rows.recordcount>
		row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
		row_count_ilk=<cfoutput>#get_rows.recordcount#</cfoutput>;
		//satir_say=row_count;
	<cfelse>
		row_count=0;
		row_count_ilk=0;
		//satir_say=0;
	</cfif>
	function sil(sy)
	{
		document.getElementById("row_kontrol"+sy).value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
		//satir_say--;
	}
	
	function add_row(row_detail,exp_center,exp_center_id,exp_item,exp_item_id,exp_project_id,exp_project,exp_product_id,exp_spect_var_id,exp_spect_name,exp_stock_id,exp_product_name,exp_stock_unit,exp_stock_unit_id,exp_member_type,exp_member_id,exp_company_id,exp_company,exp_authorized,exp_net_total,exp_tax_total,exp_otv_total,exp_tax_rate,exp_money_type,exp_act_id,exp_work_id,exp_subs_id,exp_subs_name,exp_asset_id,exp_asset_name,account_code,expense_date,row_work_id,row_work_head,exp_opp_id,exp_opp_head,otv_rate,exp_quantity,exp_tax_code,row_bsmv_rate,row_bsmv_amount,row_bsmv_currency,row_oiv_rate,row_oiv_amount,row_tevkifat_rate,row_tevkifat_amount,exp_reason_code)
	{
		if (row_detail == undefined) row_detail ="";
		if (exp_center == undefined) exp_center ="";
		if (exp_item == undefined) exp_item ="";
		if (exp_center_id == undefined) exp_center_id ="";
		if (exp_item_id == undefined) exp_item_id ="";
		
		if (exp_project_id == undefined) exp_project_id ="";
		if (exp_project == undefined) exp_project ="";
		if (exp_product_id == undefined) exp_product_id ="";
		if (exp_stock_id == undefined) exp_stock_id ="";
		if (exp_product_name == undefined) exp_product_name ="";
		if (exp_spect_var_id == undefined) exp_spect_var_id ="";
		if (exp_spect_name == undefined) exp_spect_name ="";
		
		if (exp_stock_unit == undefined) exp_stock_unit ="";
		if (exp_stock_unit_id == undefined) exp_stock_unit_id ="";
		
		if (exp_member_id == undefined) exp_member_id ="";
		if (exp_member_type == undefined) exp_member_type ="";
		if (exp_company_id == undefined) exp_company_id ="";
		if (exp_authorized == undefined) exp_authorized ="";
		if (exp_company == undefined) exp_company ="";
		if (exp_money_type == undefined) exp_money_type = "";
		if (exp_act_id == undefined) exp_act_id ="";
		if (exp_work_id == undefined) exp_work_id ="";
		if (exp_subs_id == undefined) exp_subs_id ="";
		if (exp_subs_name == undefined) exp_subs_name ="";
		if (exp_asset_id == undefined) exp_asset_id ="";
		if (exp_asset_name == undefined) exp_asset_name ="";
		if (account_code == undefined) account_code ="";
		if (expense_date == undefined) expense_date ="";
		if (row_work_id == undefined) row_work_id ="";
		if (row_work_head == undefined) row_work_head ="";
		if (exp_opp_id == undefined) exp_opp_id ="";
		if (exp_opp_head == undefined) exp_opp_head ="";
		if (exp_net_total == undefined) exp_net_total ="0";
		if (exp_tax_total == undefined) exp_tax_total ="0";
		if (exp_otv_total == undefined) exp_otv_total ="0";
		if(row_bsmv_rate == undefined) row_bsmv_rate = "0";
		if(row_bsmv_amount == undefined) row_bsmv_amount = "0";
		if(row_bsmv_currency == undefined) row_bsmv_currency = "0";
		if(row_oiv_rate == undefined) row_oiv_rate = "0";
		if(row_oiv_amount == undefined ) row_oiv_amount = "0";
		if(row_tevkifat_rate == undefined) row_tevkifat_rate = "0";
		if(row_tevkifat_amount == undefined ) row_tevkifat_amount = "0";
		if (otv_rate == undefined || otv_rate == '') otv_rate ="0";
		if (exp_quantity == undefined || exp_quantity == '') exp_quantity ="1";
		if (exp_tax_rate == undefined || exp_tax_rate == '')
		{
			exp_tax_rate = "<cfif isdefined("xml_tax_rate") and len(xml_tax_rate)><cfoutput>#xml_tax_rate#</cfoutput><cfelse>0</cfif>";
		}
		// vergi kodu(e-fatura)
		if (exp_tax_code == undefined) exp_tax_code ="";
		<cfif len(session.ep.other_money) and fusebox.use_period eq true>
			if(exp_money_type == '')
			{
				<cfoutput query="get_money">
					if('#money#' == '#session.ep.other_money#')
						exp_money_type = "#money#,#rate1#,#rate2#";
				</cfoutput>			
			}
		</cfif>
		
		if (exp_reason_code == undefined) exp_reason_code ="";
		
		
		rate_round_num_ = "<cfoutput>#xml_satir_number#</cfoutput>";
		if(rate_round_num_ == "") rate_round_num_ = "2";
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		document.getElementById("record_num").value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		
		newCell.innerHTML = '<input type="hidden" value="'+js_create_unique_id()+'" name="wrk_row_id' + row_count +'" id="wrk_row_id' + row_count +'"><input type="hidden" name="credit_type'+row_count+'" id="credit_type'+row_count+'" value="1"><input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Delete'>" alt="<cf_get_lang dictionary_id='57463.Delete'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a href="javascript://" onclick="copy_row('+row_count+');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="fa fa-copy"></i></a>';
		
		//Satirlardaki Veriler Degisken Olarak Geliyor
		<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),3) or x_is_project_priority eq 1>
			newCell.innerHTML += '<input type="hidden" name="expense_center_id' + row_count +'" id="expense_center_id' + row_count +'" value="'+exp_center_id+'"><input type="hidden" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" value="'+exp_center+'">';
		</cfif>
		<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),4) or x_is_project_priority eq 1>
			newCell.innerHTML += '<input type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+exp_item_id+'"><input type="hidden" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item+'">';
		</cfif>
		<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),5) or x_is_project_priority eq 1>
			newCell.innerHTML += '<input type="hidden"  name="account_code' + row_count +'" id="account_code' + row_count +'" class="boxtext"  value="'+account_code+'">';
		</cfif>
		<cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
			<cfswitch expression="#xlr#">
				<cfcase value="1">//1.Tarih
					newCell = newRow.insertCell(newRow.cells.length);
					<cfif isdefined("xml_budget_row_date") and xml_budget_row_date eq 1>
						newCell.setAttribute("id","expense_date" + row_count + "_td");
						newCell.setAttribute("nowrap", "nowrap");
						newCell.innerHTML = '<input type="text" id="expense_date' + row_count +'" name="expense_date' + row_count +'" class="text" maxlength="10"  value="' + expense_date +'">';
						wrk_date_image('expense_date' + row_count);
						<cfelse>
						newCell.setAttribute("id","receipt_date" + row_count + "_td");
						newCell.setAttribute("nowrap", "nowrap");
						newCell.innerHTML = '<input type="text" id="receipt_date' + row_count +'" name="receipt_date' + row_count +'" class="text" maxlength="10"  value="' + expense_date +'">';
						wrk_date_image('receipt_date' + row_count);
					</cfif>
				</cfcase>
				<cfcase value="2">//2.Açıklama
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<div class="form-group"><input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'"  class="boxtext" value="'+row_detail+'"></div>';
				</cfcase>
				<cfcase value="40">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					branch_data = '<div class="form-group"><select name="row_branch' + row_count +'" id="row_branch' + row_count +'" class="boxtext"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
					<cfoutput query="GET_BRANCH_DET">
						branch_data += '<option value="#BRANCH_ID#">#BRANCH_NAME#</option>';
					</cfoutput>
					newCell.innerHTML = branch_data+ '</select></div>';
				</cfcase>
				<cfcase value="3">//3.Masraf Merkezi
					<cfif x_is_project_priority eq 0>
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_center_id' + row_count +'" id="expense_center_id' + row_count +'" value="'+exp_center_id+'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="AutoComplete_Create(\'expense_center_name' + row_count +'\',\'EXPENSE,EXPENSE_CODE\',\'EXPENSE,EXPENSE_CODE\',\'get_expense_center\',\'0,<cfif isDefined("x_authorized_branch_department") and x_authorized_branch_department eq 1>1<cfelse>0</cfif>\',\'EXPENSE_ID\',\'expense_center_id' + row_count +'\',\'add_costplan\',1);" value="'+exp_center+'"  class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_exp('+ row_count +');"></span></div></div>';
					</cfif>
				</cfcase>
				<cfcase value="4">//4.Gider Kalemi
					<cfif x_is_project_priority eq 0>
						newCell = newRow.insertCell(newRow.cells.length);
						
						<cfif isDefined("xml_expense_center_budget_item") and xml_expense_center_budget_item eq 1>
							newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+exp_item_id+'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item+'" " onFocus="autocomp_expense_item('+ row_count +');" class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_item('+ row_count +',<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>);"></span></div></div>';
						<cfelse>
							<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),26)>
								newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+exp_item_id+'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item+'" " onFocus="AutoComplete_Create(\'expense_item_name' + row_count +'\',\'EXPENSE_ITEM_NAME\',\'EXPENSE_ITEM_NAME\',\'get_expense_item\',\'<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>\',\'EXPENSE_ITEM_ID,ACCOUNT_CODE\',\'expense_item_id' + row_count +',account_code' + row_count +'\',\'add_costplan\',1);"  class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_item('+ row_count +',<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>);"></span></div></div>';
							<cfelse>
								newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+exp_item_id+'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item+'" " onFocus="AutoComplete_Create(\'expense_item_name' + row_count +'\',\'EXPENSE_ITEM_NAME\',\'EXPENSE_ITEM_NAME\',\'get_expense_item\',\'<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>\',\'EXPENSE_ITEM_ID,ACCOUNT_CODE,TAX_CODE\',\'expense_item_id' + row_count +',account_code' + row_count +',tax_code' + row_count +'\',\'add_costplan\',1);"  class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_item('+ row_count +',<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>);"></span></div></div>';
							</cfif>
						</cfif>
					</cfif>																							
				</cfcase>
				<cfcase value="5">//5.Muhasebe Kodu
					<cfif x_is_project_priority eq 0>
						newCell = newRow.insertCell(newRow.cells.length);
						
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text"  id="account_code' + row_count +'" name="account_code' + row_count +'" onFocus="AutoComplete_Create(\'account_code' + row_count +'\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'ACCOUNT_CODE,ACCOUNT_NAME\',\'get_account_code\',\'0\',\'\',\'\',\'\',\'3\',\'225\');" class="boxtext"  value="'+account_code+'"><span class="input-group-addon icon-ellipsis" onclick="pencere_ac_acc('+ row_count +');"></span></div></div>';																												
					</cfif>
				</cfcase>
				//vergi kodu
				<cfcase value="26">//26.Vergi Kodu
					<cfif not(fuseaction contains "assetcare")>
						newCell = newRow.insertCell(newRow.cells.length);
						
						xx = '<div class="form-group"><select name="tax_code' + row_count  +'" id="tax_code' + row_count  +'"  class="boxtext"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
						<cfoutput query="TAX_CODES">
							if('#TAX_CODE_ID#' == exp_tax_code)
								xx += '<option value="#TAX_CODE_ID#" selected>#TAX_CODE_NAME#</option>';
							else
								xx += '<option value="#TAX_CODE_ID#">#TAX_CODE_NAME#</option>';
						</cfoutput>
						newCell.innerHTML = xx+ '</select></div>';					
					</cfif>
				</cfcase>
				<cfcase value="6">//6.Ürün
					newCell = newRow.insertCell(newRow.cells.length);
					
					<cfif isdefined("is_product_cost_default") and is_product_cost_default eq 1>
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" class="boxtext"  onFocus="hesapla(\'product_name\',' + row_count +'); AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME,STOCK_CODE\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID,PRODUCT_COST,MAIN_UNIT,PRODUCT_UNIT_ID\',\'product_id' + row_count +',stock_id' + row_count +',total' + row_count  +',stock_unit' + row_count  +',stock_unit_id' + row_count  +'\',\'add_costplan\',1,\'\',\'format_total_value(' + row_count + ');\');" value="'+exp_product_name+'"><input  type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+exp_product_id+'"><input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+exp_stock_id+'"><span class="input-group-addon icon-ellipsis ellipsis-red" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+document.getElementById('product_id"+row_count+"').value+'&sid='+document.getElementById('stock_id"+row_count+"').value+'','list');"+'"></span> <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_product('+row_count+');"></span></div></div>';
					<cfelse>
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" class="boxtext"  onFocus="hesapla(\'product_name\',' + row_count +'); AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME,STOCK_CODE\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID,MAIN_UNIT,PRODUCT_UNIT_ID\',\'product_id' + row_count +',stock_id' + row_count +',stock_unit' + row_count  +',stock_unit_id' + row_count  +'\',\'add_costplan\',1,\'\',\'format_total_value(' + row_count + ');\');" value="'+exp_product_name+'"><input  type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+exp_product_id+'"><input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+exp_stock_id+'"><span class="input-group-addon icon-ellipsis ellipsis-red" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+document.getElementById('product_id"+row_count+"').value+'&sid='+document.getElementById('stock_id"+row_count+"').value+'','list');"+'"></span> <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_product('+row_count+');"></span></div></div>';
					</cfif>
					
				</cfcase>
				<cfcase value="25">//25.Spec
					<cfif fuseaction contains "assetcare">
						newCell = newRow.insertCell(newRow.cells.length);
						
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="spect_var_id' + row_count +'" id="spect_var_id' + row_count +'" class="boxtext" value="'+exp_spect_var_id+'"><input type="text" id="spect_name' + row_count +'" name="spect_name' + row_count +'" class="boxtext" value="'+exp_spect_name+'" ><span class="input-group-addon icon-ellipsis" onClick="product_control('+ row_count +');"></span></div></div>';																												
						
					</cfif>
				</cfcase>
				<cfcase value="7">//7.Birim
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><input type="hidden" name="stock_unit_id' + row_count +'" id="stock_unit_id' + row_count +'" value="'+exp_stock_unit_id+'"><input type="text" name="stock_unit' + row_count +'" id="stock_unit' + row_count +'"  value="'+exp_stock_unit+'" class="boxtext" readonly></div>';
				</cfcase>
				<cfcase value="8">//8.Miktar
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" onkeypress="return NumberControl(event)" class="box" value="'+ commaSplit(exp_quantity,rate_round_num_)+ '" onkeydown="enterControl(event,\'quantity\','+row_count+');" onBlur="<cfif isdefined("xml_discount") and xml_discount eq 1>disc_hesapla(' + row_count +');</cfif> hesapla(\'quantity\',' + row_count +');" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));"></div>';
				</cfcase>
				<cfcase value="9">//9.Tutar
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><input type="text" name="total' + row_count +'" id="total' + row_count +'" value="'+commaSplit(exp_net_total,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onkeydown="enterControl(event,\'total\','+row_count+');" onkeypress="return NumberControl(event)"  onBlur="<cfif isdefined("xml_discount") and xml_discount eq 1>disc_total_hesapla('+row_count+')</cfif>;hesapla(\'total\',' + row_count +');" class="box"></div>';
				</cfcase>
				<cfcase value="10">//10.Kdv %
					newCell = newRow.insertCell(newRow.cells.length);
					
					c = '<div class="form-group"><select name="tax_rate' + row_count  +'" id="tax_rate' + row_count  +'"  onChange="hesapla(\'tax_rate\','+ row_count +');">';
					<cfif fusebox.use_period eq true>
						<cfoutput query="get_tax">
						if('#tax#' == exp_tax_rate)
							c += '<option value="#tax#" selected>#tax#</option>';
						else
							c += '<option value="#tax#">#tax#</option>';
						</cfoutput>
					</cfif>					
					newCell.innerHTML =c+ '</select></div>';
				</cfcase>
				<cfcase value="11">//11.Ötv %
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<input type="text" name="otv_rate'+ row_count +'" id="otv_rate'+ row_count +'" onkeypress="return NumberControl(event)" value="'+otv_rate+'" onkeyup="return(FormatCurrency(this,event,0));" onkeydown="enterControl(event,\'otv_rate\','+row_count+');"  onBlur="hesapla(\'otv_rate\',' + row_count +');">';
					otv_ = '<div class="form-group"><select name="otv_rate'+row_count+'" id="otv_rate'+row_count+'"  onChange="hesapla(\'otv_rate\','+row_count+');">';
					otv_ += '<option value="0"><cf_get_lang dictionary_id="58021.ÖTV"></option>';
						<cfoutput query="get_otv">
							otv_ += '<option value="#tax#">#tax#</option>';
						</cfoutput>
					newCell.innerHTML =otv_+ '</select></div>';
				</cfcase>
				<cfcase value="29">//29.İskonto %
					<cfif isdefined("xml_discount") and xml_discount eq 1>
						newCell = newRow.insertCell(newRow.cells.length);
						
						newCell.innerHTML = '<div class="form-group"><input type="text" name="discount_rate' + row_count +'" id="discount_rate' + row_count +'" onkeypress="return NumberControl(event)" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onkeydown="enterControl(event,\'total\','+row_count+');" onBlur="<cfif isdefined("xml_discount") and xml_discount eq 1>disc_hesapla(' + row_count +');</cfif>hesapla(\'total\',' + row_count +');" class="box"></div>';
					</cfif>
				</cfcase>
				<cfcase value="12">//12.Kdv
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><input type="text" name="kdv_total' + row_count +'" id="kdv_total' + row_count +'" onkeypress="return NumberControl(event)" value="'+commaSplit(exp_tax_total,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onkeydown="enterControl(event,\'kdv_total\','+row_count+',1);" onBlur="hesapla(\'kdv_total\',' + row_count +',1);" class="box"></div>';
				</cfcase>
				<cfcase value="13">//13.Ötv
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><input type="text" name="otv_total' + row_count +'" id="otv_total' + row_count +'" onkeypress="return NumberControl(event)" value="'+commaSplit(exp_otv_total,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onkeydown="enterControl(event,\'otv_total\','+row_count+',1);" onBlur="hesapla(\'otv_total\',' + row_count +',1);" class="box"></div>';
				</cfcase>
				<cfcase value="31">//31.İskonto
					<cfif isdefined("xml_discount") and xml_discount eq 1>
						newCell = newRow.insertCell(newRow.cells.length);
						
						newCell.innerHTML = '<div class="form-group"><input type="text" name="discount_price' + row_count +'" id="discount_price' + row_count +'" onkeypress="return NumberControl(event)" value="'+commaSplit(exp_otv_total,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onkeydown="enterControl(event,\'total\','+row_count+');" onBlur="<cfif isdefined("xml_discount") and xml_discount eq 1>disc_hesapla(' + row_count +');</cfif> hesapla(\'total\',' + row_count +');" class="box"></div>';
					</cfif>
				</cfcase>
				<cfcase value="32">// Bsmv Oran
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<input type="text" name="row_bsmv_rate'+ row_count +'" id="row_bsmv_rate'+ row_count +'" onkeypress="return NumberControl(event)" value="'+row_bsmv_rate+'" onkeyup="return(FormatCurrency(this,event,0));" onkeydown="enterControl(event,\'row_bsmv_rate\','+row_count+');" onBlur="hesapla(\'row_bsmv_rate\',' + row_count +');">';
					bsmv_ = '<div class="form-group"><select name="row_bsmv_rate'+row_count+'" id="row_bsmv_rate'+row_count+'" onChange="hesapla(\'row_bsmv_rate\','+row_count+');">';
					bsmv_ += '<option value="0">BSMV</option>';
						<cfoutput query="get_bsmv">
							bsmv_ += '<option value="#tax#">#TLFormat(tax)#</option>';
						</cfoutput>
					newCell.innerHTML =bsmv_+ '</select></div>';
				</cfcase>
				<cfcase value="33">// Bsmv Tutar
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><input type="text" name="row_bsmv_amount' + row_count +'" id="row_bsmv_amount' + row_count +'" onkeypress="return NumberControl(event)" value="'+commaSplit(row_bsmv_amount,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onkeydown="enterControl(event,\'total\','+row_count+');" onBlur="hesapla(\'row_bsmv_amount\',' + row_count +');" class="box"></div>';
				</cfcase>
				<cfcase value="34">// Bsmv Döviz
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><input type="text" name="row_bsmv_currency' + row_count +'" id="row_bsmv_currency' + row_count +'" onkeypress="return NumberControl(event)" value="'+commaSplit(row_bsmv_currency,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onkeydown="enterControl(event,\'total\','+row_count+');" onBlur="hesapla(\'row_bsmv_currency\',' + row_count +');" class="box"></div>';
				</cfcase>
				<cfcase value="35">// Oiv Oran
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<input type="text" name="row_oiv_rate'+ row_count +'" id="row_oiv_rate'+ row_count +'" onkeypress="return NumberControl(event)" value="'+row_oiv_rate+'" onkeyup="return(FormatCurrency(this,event,0));" onkeydown="enterControl(event,\'row_oiv_rate\','+row_count+');" onBlur="hesapla(\'row_oiv_rate\',' + row_count +');">';
					oiv_ = '<div class="form-group"><select name="row_oiv_rate'+row_count+'" id="row_oiv_rate'+row_count+'" onChange="hesapla(\'row_oiv_rate\','+row_count+');">';
						oiv_ += '<option value="0">OIV</option>';
						<cfoutput query="get_oiv">
							oiv_ += '<option value="#tax#">#TLFormat(tax)#</option>';
						</cfoutput>
					newCell.innerHTML =oiv_+ '</select></div>';
				</cfcase>
				<cfcase value="36">// Oiv Tutar
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><input type="text" name="row_oiv_amount' + row_count +'" id="row_oiv_amount' + row_count +'" onkeypress="return NumberControl(event)" value="'+commaSplit(row_oiv_amount,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onkeydown="enterControl(event,\'total\','+row_count+');" onBlur="hesapla(\'row_oiv_amount\',' + row_count +');" class="box"></div>';
				</cfcase>
				<cfcase value="37">// Tevkifat Oran
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><input type="text" name="row_tevkifat_rate' + row_count +'" id="row_tevkifat_rate' + row_count +'" onkeypress="return NumberControl(event)" value="'+commaSplit(row_tevkifat_rate,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onkeydown="enterControl(event,\'total\','+row_count+');" onBlur="hesapla(\'row_tevkifat_rate\',' + row_count +');" class="box"></div>';
				</cfcase>
				<cfcase value="38">// Tevkifat Tutar
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><input type="text" name="row_tevkifat_amount' + row_count +'" id="row_tevkifat_amount' + row_count +'" onkeypress="return NumberControl(event)" value="'+commaSplit(row_tevkifat_amount,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onkeydown="enterControl(event,\'total\','+row_count+');" onBlur="hesapla(\'row_tevkifat_amount\',' + row_count +');" class="box"></div>';
				</cfcase>
				<cfcase value="30">//30.Genel Toplam
					<cfif isdefined("xml_discount") and xml_discount eq 1>
						newCell = newRow.insertCell(newRow.cells.length);
						
						newCell.innerHTML = '<div class="form-group"><input type="text" name="discount_total' + row_count +'" id="discount_total' + row_count +'" onkeypress="return NumberControl(event)" value="'+commaSplit(exp_otv_total,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onkeydown="enterControl(event,\'total\','+row_count+');" onBlur="<cfif isdefined("xml_discount") and xml_discount eq 1> disc_hesapla(' + row_count +');</cfif> hesapla(\'total\',' + row_count +');" class="box"></div>';
					</cfif>
				</cfcase>
				<cfcase value="14">//14.Genel Toplam -- İndirim varsa birim fiyat 
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><input type="text" name="net_total' + row_count +'" id="net_total' + row_count +'" onkeypress="return NumberControl(event)" value="'+commaSplit(0,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onkeydown="enterControl(event,\'net_total\','+row_count+',2);" onBlur="hesapla(\'net_total\',' + row_count +',2);<cfif isdefined("xml_discount") and xml_discount eq 1>disc_total_hesapla('+row_count+');</cfif>" class="box"></div>';
				</cfcase>
				<cfcase value="15">//15.Para Br
					newCell = newRow.insertCell(newRow.cells.length);					
					a = '<div class="form-group"><select name="money_id' + row_count  +'" id="money_id' + row_count  +'"  class="boxtext" onChange="other_calc('+ row_count +');">';
					<cfif fusebox.use_period eq true>
						<cfoutput query="get_money">
						if('#money#,#rate1#,#rate2#' == exp_money_type)
							a += '<option value="#money#,#rate1#,#rate2#" selected>#money#</option>';
						else
							a += '<option value="#money#,#rate1#,#rate2#">#money#</option>';
						</cfoutput>
					</cfif>					
					newCell.innerHTML =a+ '</select></div>';
				</cfcase>
				<cfcase value="27">//27.Döviz Tutar
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><input type="text" name="other_net_total_kdvsiz' + row_count +'" id="other_net_total_kdvsiz' + row_count +'" value="'+commaSplit(0,rate_round_num_)+'" onkeypress="return NumberControl(event)" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onBlur="other_calc_kdvsiz('+row_count+',2);" class="box"></div>';
				</cfcase>
				<cfcase value="16">//16.Genel Doviz Toplam
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><input type="text" name="other_net_total' + row_count +'" id="other_net_total' + row_count +'" onkeypress="return NumberControl(event)" value="'+commaSplit(0,rate_round_num_)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#xml_satir_number#</cfoutput>));" onBlur="other_calc('+row_count+',2);" class="box"></div>';
				</cfcase>
				<cfcase value="17">//17.Aktivite Tipi
					newCell = newRow.insertCell(newRow.cells.length);
					
					b = '<div class="form-group"><select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" class="boxtext"><option value=""><cf_get_lang dictionary_id='33167.Aktivite Tipi'></option>';
					<cfoutput query="get_activity_types">
					if('#activity_id#' == exp_act_id)
						b += '<option value="#activity_id#" selected>#activity_name#</option>';
					else
						b += '<option value="#activity_id#">#activity_name#</option>';
					</cfoutput>
					newCell.innerHTML =b+ '</select></div>';
				</cfcase>
				<cfcase value="18">//18.İş Grubu
					newCell = newRow.insertCell(newRow.cells.length);
					
					c = '<div class="form-group"><select name="workgroup_id' + row_count  +'" id="workgroup_id' + row_count  +'" class="boxtext"><option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>';
					<cfoutput query="get_workgroups">
					if('#workgroup_id#' == exp_work_id)
						c += '<option value="#workgroup_id#" selected>#workgroup_name#</option>';
					else
						c += '<option value="#workgroup_id#">#workgroup_name#</option>';
					</cfoutput>
					newCell.innerHTML =c+ '</select></div>';
				</cfcase>
				<cfcase value="19">//19.İş
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="work_id' + row_count +'" id="work_id'+ row_count +'" value="'+row_work_id+'"><input type="text" name="work_head' + row_count +'" id="work_head'+ row_count +'" value="'+row_work_head+'" onFocus="AutoComplete_Create(\'work_head'+ row_count +'\',\'WORK_HEAD\',\'WORK_HEAD\',\'get_work\',\'\',\'WORK_ID\',\'work_id'+ row_count +'\',\'\',3,139);"  class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_work('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="20">//20.Fırsat
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="opp_id' + row_count +'" id="opp_id'+ row_count +'" value="'+exp_opp_id+'"><input type="text" name="opp_head' + row_count +'" id="opp_head'+ row_count +'" value="'+exp_opp_head+'" onFocus="AutoComplete_Create(\'opp_head'+ row_count +'\',\'OPP_HEAD\',\'OPP_HEAD\',\'get_opportunity\',\'3\',\'OPP_ID\',\'opp_id'+ row_count +'\',\'\',3,135);"  class="boxtext"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_oppotunity('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="21">//21.Proje
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value="'+exp_project_id+'"><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="'+exp_project+'"  onFocus="auto_project('+ row_count +');" class="boxtext"><span class="input-group-addon icon-ellipsis"  onClick="pencere_ac_project('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="22">//22.Sistem
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="subscription_id'+ row_count +'" id="subscription_id'+ row_count +'" value="'+exp_subs_id+'"><input type="text" name="subscription_name'+ row_count +'" id="subscription_name'+ row_count +'" value="'+exp_subs_name+'"  class="boxtext" onFocus="auto_subscription('+ row_count +');"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_subs('+ row_count +');" ></span></div></div>';
				</cfcase>
				<cfcase value="23">//23.Harcama Yapan
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value="'+exp_member_type+'"><input type="hidden" name="member_id'+ row_count +'" id="member_id'+ row_count +'" value="'+exp_member_id+'"><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value="'+exp_company_id+'"><input type="text"  name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="'+exp_authorized+'" class="boxtext" ><input type="hidden" name="company'+ row_count +'" id="company'+ row_count +'" value="'+exp_company+'" class="boxtext" onFocus="auto_company('+ row_count +');" autocomplete="off"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_company('+ row_count +');"></span></div></div>';
				</cfcase>
				<cfcase value="24">//24.Fiziki Varlık
					<cfif ListFind("assetcare,cost,store",fusebox.circuit,',')>
						newCell = newRow.insertCell(newRow.cells.length);
						
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="asset_id'+ row_count +'" id="asset_id'+ row_count +'" value="'+exp_asset_id+'"><input type="text" name="asset'+ row_count +'" id="asset'+ row_count +'" value="'+exp_asset_name+'"  class="boxtext" onFocus="autocomp_assetp('+ row_count +');"><span class="input-group-addon icon-ellipsis" onClick="pencere_ac_asset('+ row_count +');"></span></div></div>';
					</cfif>
				</cfcase>
				
				<cfcase value="39">//39. istisna
					<cfoutput>
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute("nowrap","nowrap");
						reas = '<div class="form-group"><select name="reason_code' + row_count  +'" id="reason_code' + row_count  +'" class="boxtext"><option value=""><cf_get_lang dictionary_id='39939.İstisna'></option>';
						<cfloop list="#reason_code_list#" index="info_list" delimiters="*">
							if('#listfirst(info_list,'*')#' == exp_reason_code)
								reas += '<option value="#listfirst(info_list,'*')#" selected>#listlast(info_list,'*')#</option>';
							else
								reas += "<option value='#listfirst(info_list,'*')#'>#listlast(info_list,'*')#</option>";
						</cfloop>
						newCell.innerHTML =reas+ '</select></div>';
					</cfoutput>
				</cfcase>
			</cfswitch>
		</cfloop>	
		
	}
	<cfoutput>
	function auto_project(no)
	{
		<cfif x_is_project_select eq 0>
			if(document.getElementById("product_id"+no) != undefined && document.getElementById("product_id"+no).value != '' && document.getElementById("product_name"+no).value != '')	
			{
				alert("<cf_get_lang dictionary_id='60123.Satırda Ürün Seçiliyken Proje Değiştirilemez'>");	
				return false;
			}
		</cfif>
		<cfif xml_upd_row_expense_center eq 1>
			AutoComplete_Create('project'+no,'PROJECT_HEAD','PROJECT_HEAD','get_project','\'1,2\'','EXPENSE,EXPENSE_ID,PROJECT_ID','expense_center_name'+ no +',expense_center_id'+ no +',project_id'+ no +'','','3','200'<cfif x_row_workgroup_project eq 1>,'change_workgroup('+row_count+')'</cfif>);
		<cfelse>
			AutoComplete_Create('project'+no,'PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id'+no,'',3,115<cfif x_row_workgroup_project eq 1>,'change_workgroup('+row_count+')'</cfif>);
		</cfif>
	}
	function autocomp_expense_item(no)
	{
		AutoComplete_Create('expense_item_name' + row_count +'','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','1,1,\'' + GetExpenseId(row_count) +'\'','EXPENSE_ITEM_ID,ACCOUNT_CODE','expense_item_id' + row_count +',account_code' + row_count +'','add_costplan',1);	
	}
	function GetExpenseId(no) {
		return document.getElementById("expense_center_id" + no).value;
	}
	function pencere_ac_oppotunity(no)
	{
		openBoxDraggable('#request.self#?fuseaction=objects.popup_list_opportunities&field_opp_id=all.opp_id' + no +'&field_opp_head=all.opp_head' + no );
	}
	function pencere_ac_work(no)
	{
		p_id_ = document.getElementById("project_id" + no).value;
		p_name_ = document.getElementById("project" + no).value;
		openBoxDraggable('#request.self#?fuseaction=objects.popup_add_work&field_id=all.work_id' + no +'&field_name=all.work_head' + no +'&project_id=' + p_id_ + '&project_head=' + p_name_ +'&field_pro_id=all.project_id' +no + '&field_pro_name=all.project' +no );
	}
	function pencere_detail_work(no)
	{	
		windowopen('#request.self#?fuseaction=project.works&event=det&id='+document.getElementById("work_id"+no).value,'list');
	}
	function pencere_ac_acc(no)
	{
		openBoxDraggable('#request.self#?fuseaction=objects.popup_account_plan&field_id=all.account_code' + no +'');
	}
	function auto_company(no)
	{
		AutoComplete_Create('company'+no,'MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2,3\'','MEMBER_TYPE,PARTNER_ID2,COMPANY_ID,MEMBER_PARTNER_NAME2','member_type'+no+',member_id'+no+',company_id'+no+',authorized'+no+'','','3','250');
	}
	function auto_subscription(no)
	{
		AutoComplete_Create('subscription_name'+no,'SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id'+no,'','3','150');
	}
	function pencere_ac_company(no)
	{
		openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_id=all.member_id' +no+'&field_emp_id=all.member_id' + no +'&field_comp_name=all.company' + no +'&field_name=all.authorized' + no +'&field_comp_id=all.company_id' + no + '&field_type=all.member_type' + no + '&select_list=1,2,3,9');
	}
	function pencere_ac_product(no)
	{	
		project_url_ = "";
		unit_url_ = "";
		tax_purchase_ = "";
		if(document.getElementById("project_id"+no) != undefined)
			project_url_ = '&project_id='+ document.getElementById("project_id"+no).value;
		if(document.getElementById("stock_unit"+ no) != undefined)
			unit_url_ = '&field_unit_name= all.stock_unit' + no+'&field_main_unit=all.stock_unit_id' + no;
		<cfif not(fuseaction contains "assetcare")>
			if(document.getElementById("tax_rate"+ no) != undefined)
				tax_purchase_ = '&field_tax_purchase=all.tax_rate' + no;
		</cfif>
		<cfif x_row_project_priority_from_product eq 1>
			if(document.getElementById("project_id"+no) != undefined && (document.getElementById("project_id"+no).value == "" || document.getElementById("project"+no).value == ""))
			{
				alert("<cf_get_lang dictionary_id='34263.Önce Proje Seçmelisiniz'>!");
				return false;
			}
		</cfif>
		date_value = document.getElementById("expense_date").value;
		satir_info='product_name';
		<cfif isdefined("is_product_cost_default") and is_product_cost_default eq 1>
			openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names'+project_url_+tax_purchase_+'&product_id=all.product_id' + no + '&field_id=all.stock_id' + no + unit_url_ + '&field_product_cost=all.total'+no+'&run_function=hesapla&run_function_param='+no+'&run_function_param1='+satir_info+'&expense_date='+date_value+'&field_name=all.product_name'+no);
		<cfelse>
			openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names'+project_url_+tax_purchase_+'&product_id=all.product_id' + no + '&field_id=all.stock_id' + no + unit_url_ + '&run_function=hesapla&run_function_param='+no+'&run_function_param1='+satir_info+'&expense_date='+date_value+'&field_name=all.product_name'+no);
		</cfif>
	}
	function pencere_ac_asset(no)
	{
		adres = '#request.self#?fuseaction=objects.popup_list_assetps';
		adres += '&field_id=all.asset_id' + no +'&field_name=all.asset' + no +'&event_id=0&motorized_vehicle=0';
		<cfif x_is_add_position_to_asset_list eq 1>
			adres += '&member_type=all.member_type' + no;
			adres += '&employee_id=all.member_id' + no;
			adres += '&position_employee_name=all.authorized' + no;	
		</cfif>
		<cfif isdefined("xml_exp_center_from_assetp") and xml_exp_center_from_assetp eq 1>
			adres += '&exp_center_id=all.expense_center_id' + no;	
			adres += '&exp_center_name=all.expense_center_name' + no;	
		</cfif>
		<cfif isDefined("x_select_branch") and x_select_branch eq 1>
			adres += '&expense_branch_id=all.row_branch' + no;
		</cfif>
		openBoxDraggable(adres);
	}
	function change_workgroup(no)
	{
		<cfif x_row_workgroup_project eq 1>
			if(document.getElementById("project_id" + no).value != ''){
			var get_workgroup = wrk_safe_query('obj_get_workgroup','dsn',0, document.getElementById("project_id" + no).value);		
			if(get_workgroup.WORKGROUP_ID != '' && document.getElementById("workgroup_id" + no) != undefined)
				document.getElementById("workgroup_id" + no).value = get_workgroup.WORKGROUP_ID;
			}
		</cfif>			
	}
	function autocomp_assetp(no)
	{
		<cfif isdefined("xml_exp_center_from_assetp") and xml_exp_center_from_assetp eq 1>
			AutoComplete_Create('asset'+ row_count +'','ASSETP','ASSETP','get_assetp_autocomplete','\'\',1','ASSETP_ID,EMPLOYEE_ID,EMP_NAME,MEMBER_TYPE,EXPENSE_CENTER_ID,EXPENSE_CODE_NAME','asset_id'+no+',member_id'+no+',authorized'+no+',member_type'+no+',expense_center_id'+no+',expense_center_name'+no+'','',3,130);
		<cfelse>
			AutoComplete_Create('asset'+ row_count +'','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID','asset_id'+no+'',3,130);
		</cfif>
	}
	function pencere_ac_project(no)
	{
		<cfif x_is_project_select eq 0>
		if(document.getElementById("product_id"+no) != undefined && document.getElementById("product_id"+no).value != '' && document.getElementById("product_name"+no).value != '')	
		{
			alert("<cf_get_lang dictionary_id='62053.Satırda Ürün Seçiliyken Proje Değiştirilemez'>");	
			return false;
		}
		</cfif>
		openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&<cfif x_row_workgroup_project eq 1>function_name=change_workgroup&function_param='+no+'&</cfif><cfif xml_upd_row_expense_center eq 1>expense_id=add_costplan.expense_center_id'+no+'&expense=add_costplan.expense_center_name'+no+'&</cfif>project_id=add_costplan.project_id' + no +'&project_head=add_costplan.project' + no);
	}
	function pencere_ac_subs(no)
	{
		openBoxDraggable('#request.self#?fuseaction=objects.popup_list_subscription&field_id=all.subscription_id' + no +'&field_no=all.subscription_name' + no);
	}
	function pencere_ac_campaign(no)
	{
		windowopen('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=all.campaign_id' + no +'&field_name=all.campaign' + no,'list');
	}
	function pencere_ac_exp(no)
	{
		<cfif isdefined("x_authorized_branch_department") and x_authorized_branch_department eq 1>
			var xml_deger = 1;
		<cfelse>
			var xml_deger = 0;
		</cfif>
		<cfif isdefined("xml_get_expense_center") and xml_get_expense_center eq 1>
			var xml_deger2 = 1;
		<cfelse>
			var xml_deger2 = 0;
		</cfif>
		pos_code = $("##expense_employee_position").val();
		if(pos_code == undefined) pos_code='';
		openBoxDraggable('#request.self#?fuseaction=objects.popup_expense_center<cfif attributes.fuseaction is 'health.expenses'>&from_health=1</cfif>&is_invoice=1&xml_get_expense_center='+xml_deger2+'&position_code='+pos_code+'&x_authorized_branch_department='+xml_deger+'&field_id=all.expense_center_id' + no +'&field_name=all.expense_center_name' + no + '&field_id_1=' + 'all.activity_type' + no );
		document.getElementById("expense_item_name"+no).value = "";
		document.getElementById("expense_item_id"+no).value = "";
	}
	function pencere_ac_item(no,inc)
	{
		<cfif xml_expense_center_budget_item eq 1><!--- xml'e bağlı olarak masraf/gelir merkezine bağlı bütçe kalemleri ilişkisi kurulsun. MK 011019 --->
			var exp_center_id_ = "";
			var exp_center_name_ = "";
			if (document.getElementById("expense_center_id"+no) != undefined && document.getElementById("expense_center_id"+no).value != ''  && document.getElementById("expense_center_name"+no).value != '')
			{					
				exp_center_id_ = document.getElementById("expense_center_id"+no).value;
				exp_center_name_ = document.getElementById("expense_center_name"+no).value;
			}
			else
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'>!");
					 document.getElementById("expense_center_id"+no).focus();
					return false;
				}
			if(inc == 1) inc_ = "&is_income=1"; else inc_ = "";
			<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),26) or ListFind("assetcare",fusebox.circuit,',')>
				openBoxDraggable('#request.self#?fuseaction=objects.popup_list_exp_item&is_exp=1&field_id=all.expense_item_id' + no +'&field_account_no=all.account_code' + no +'&field_name=all.expense_item_name' + no + inc_ +'&expense_center_id='+exp_center_id_+'&expense_center_name='+exp_center_name_);
			<cfelse>
				openBoxDraggable('#request.self#?fuseaction=objects.popup_list_exp_item&is_exp=1&field_id=all.expense_item_id' + no +'&field_tax_code=all.tax_code' + no +'&field_account_no=all.account_code' + no +'&field_name=all.expense_item_name' + no + inc_+'&expense_center_id='+exp_center_id_+'&expense_center_name='+exp_center_name_);
			</cfif>
		<cfelse>
			if(inc == 1) inc_ = "&is_income=1"; else inc_ = "";
			<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),26) or ListFind("assetcare",fusebox.circuit,',')>
				openBoxDraggable('#request.self#?fuseaction=objects.popup_list_exp_item&field_id=all.expense_item_id' + no +'&field_account_no=all.account_code' + no +'&field_name=all.expense_item_name' + no + inc_);
			<cfelse>
				openBoxDraggable('#request.self#?fuseaction=objects.popup_list_exp_item&field_id=all.expense_item_id' + no +'&field_tax_code=all.tax_code' + no +'&field_account_no=all.account_code' + no +'&field_name=all.expense_item_name' + no + inc_);
			</cfif>
		</cfif>
	}
	</cfoutput>
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
	function return_company()
	{
	if(document.getElementById("ch_member_type").value=='employee')
		{
			var emp_id=document.getElementById("emp_id").value;
			var GET_COMPANY=wrk_safe_query('obj_get_company','dsn',0,emp_id);
			document.getElementById("ch_company_id").value=GET_COMPANY.COMP_ID;
		}
	  else 
		return false;
	}
	function zero_stock_control(dep_id,loc_id,is_update,process_type,stock_type)//orjinal sıfırstok kontrolu functionı,geneldekini kullanamıyoruz,duruma göre değişiklik yapılabilir
	{
		var hata = '';
		var stock_id_list='0';
		var stock_amount_list='0';
		if(row_count>1)
		{
			for (var counter_=1; counter_ <= row_count; counter_++)
			{
				if(document.getElementById("row_kontrol" + counter_).value == 1 && document.getElementById("stock_id" + counter_).value != '')
				{
					my_val = $('#stock_id'+counter_).val();
					var yer=list_find(stock_id_list,my_val,',');
					if(yer)
					{
						
						top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("quantity" + counter_).value));
						stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
					}
					else
					{
							
						stock_id_list=stock_id_list+','+ my_val;
						stock_amount_list=stock_amount_list+','+filterNum(document.getElementById("quantity" + counter_).value);
					}
				}
			}
		}
		else
		{
			if(document.getElementById("stock_id1").value != '')
			{
				stock_id_list=stock_id_list+','+document.getElementById("stock_id1").value;
				stock_amount_list=stock_amount_list+','+filterNum(document.getElementById("quantity1").value);
			}
		}
		var stock_id_count=list_len(stock_id_list,',');
		//stock kontrolleri
		if(stock_id_count >1)
		{
			if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)
			{
				if(stock_type==undefined || stock_type==0)
				{
					if(is_update != 0)
						var new_sql = 'obj_get_total_stock_29';
					else
						var new_sql = 'obj_get_total_stock_30';			
				}
				else
				{
					if(is_update != 0)
						var new_sql= 'obj_get_total_stock_31';						
					else
						var new_sql= 'obj_get_total_stock_32';
				}
			}
			else
			{
				if(is_update != 0)
					var new_sql = 'obj_get_total_stock_33';
				else
					var new_sql = 'obj_get_total_stock_34';
			}
			var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + is_update + "*" + loc_id + "*" + dep_id;
			var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
			if(get_total_stock.recordcount)
			{
				var query_stock_id_list='0';
				for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
				{
					query_stock_id_list=query_stock_id_list+','+get_total_stock.STOCK_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
					var yer=list_find(stock_id_list,get_total_stock.STOCK_ID[cnt],',');
					if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(stock_amount_list,yer,',')))
						hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_total_stock.STOCK_CODE[cnt]+')\n';
				}
			}
			var diff_stock_id='0';
			for(var lst_cnt=1;lst_cnt <= list_len(stock_id_list);lst_cnt++)
			{
				var stk_id=list_getat(stock_id_list,lst_cnt,',')
				if(query_stock_id_list==undefined || query_stock_id_list=='0' || list_find(query_stock_id_list,stk_id,',') == '0')
					diff_stock_id=diff_stock_id+','+stk_id;//kayıt gelmeyen urunler
			}
			if(list_len(diff_stock_id,',')>1)
			{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden yazıldı
				var get_stock = wrk_safe_query('obj_get_stock','dsn3',0,diff_stock_id);
				for(var cnt=0; cnt < get_stock.recordcount; cnt++)
					hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+'(Stok Kodu:'+get_stock.STOCK_CODE[cnt]+')\n';
			}
			get_total_stock='';
		}
		if(hata!='')
		{
			if(stock_type==undefined || stock_type==0)
				alert(hata+"\n\n<cf_get_lang dictionary_id ='33757.Yukarıdaki ürünlerde stok miktarı yeterli değildir Lütfen seçtiğiniz depo lokasyonundaki miktarları kontrol ediniz '>");
			else
				alert(hata+"\n\n<cf_get_lang dictionary_id ='33758.Yukarıdaki ürünlerde satılabilir stok miktarı yeterli değildir Lütfen miktarları kontrol ediniz '>");
			hata='';
			return false;
		}
		else
			return true;
	}
	function ayarla_gizle_goster(id)
	{
		if(id==1)
		{
			if(document.getElementById("cash").checked == true)
			{
				if (document.getElementById("bank")) 
				{
					document.getElementById("bank").checked = false;
					document.getElementById("banka2").style.display='none';
					document.getElementById("bank_code").value = "";
				}
				if (document.getElementById("credit")) 
				{
					document.getElementById("credit").checked = false;
					document.getElementById("credit2").style.display='none';
				}
				document.getElementById("kasa2").style.display='';
			}
			else
			{
				document.getElementById("kasa2").style.display='none';
			}
		}
		else if(id==3)
		{
			if(document.getElementById("credit").checked == true)
			{
				if (document.getElementById("bank")) 
				{
					document.getElementById("bank").checked = false;
					document.getElementById("banka2").style.display='none';
					document.getElementById("bank_code").value = "";
				}
				if (document.getElementById("cash")) 
				{
					document.getElementById("cash").checked = false;
					document.getElementById("kasa2").style.display='none';
				}
				document.getElementById("credit2").style.display='';
			}
			else
			{
				document.getElementById("credit2").style.display='none';
			}
		}
		else
		{
			if(document.getElementById("bank").checked == true)
			{
				if (document.getElementById("cash")) 
				{
					document.getElementById("cash").checked = false;
					document.getElementById("kasa2").style.display='none';
				}
				if (document.getElementById("credit")) 
				{
					document.getElementById("credit").checked = false;
					document.getElementById("credit2").style.display='none';
				}
				document.getElementById("banka2").style.display='';
			}
			else
			{
				document.getElementById("banka2").style.display='none';
				document.getElementById("bank_code").value = "";
			}
		}
	}
	function view_product_info(row_info)//ürün detay popup ının gözükmesi için
	{
		if( document.getElementById("product_info" + row_info) != undefined && document.getElementById("product_info" + row_info) != null ){
			if(document.getElementById("product_name" + row_info) != undefined && document.getElementById("product_name" + row_info).value == '')
				document.getElementById("product_info" + row_info).style.display='none';
			else
				document.getElementById("product_info" + row_info).style.display='';
		}
	}
	function copy_row(no_info)
	{
		if (document.getElementById("row_detail" + no_info) == undefined) row_detail =""; else row_detail = document.getElementById("row_detail" + no_info).value;
		if (document.getElementById("expense_center_id" + no_info) == undefined) exp_center_id =""; else exp_center_id = document.getElementById("expense_center_id" + no_info).value;
		if (document.getElementById("expense_center_name" + no_info) == undefined) exp_center =""; else exp_center = document.getElementById("expense_center_name" + no_info).value;
		if (document.getElementById("expense_item_id" + no_info) == undefined) exp_item_id =""; else exp_item_id = document.getElementById("expense_item_id" + no_info).value;
		if (document.getElementById("expense_item_name" + no_info) == undefined) exp_item =""; else exp_item = document.getElementById("expense_item_name" + no_info).value;
		if (document.getElementById("account_code" + no_info) == undefined) account_code =""; else account_code = document.getElementById("account_code" + no_info).value;
		<cfif isdefined("xml_budget_row_date") and xml_budget_row_date eq 1>
			if (document.getElementById("expense_date" + no_info) == undefined) exp_date =""; else exp_date = document.getElementById("expense_date" + no_info).value;
		<cfelse>
			if (document.getElementById("receipt_date" + no_info) == undefined) exp_date =""; else exp_date = document.getElementById("receipt_date" + no_info).value;
		</cfif>
		if (document.getElementById("project_id" + no_info) == undefined) exp_project_id =""; else exp_project_id = document.getElementById("project_id" + no_info).value;
		if (document.getElementById("project" + no_info) == undefined) exp_project =""; else exp_project =  document.getElementById("project" + no_info).value;
		<cfif x_row_copy_product_info eq 1>//Satir Kopyalanirken Urun Bilgileri Tasinsin
			if (document.getElementById("product_id" + no_info) == undefined) exp_product_id =""; else exp_product_id = document.getElementById("product_id" + no_info).value;
			if (document.getElementById("stock_id" + no_info) == undefined) exp_stock_id =""; else exp_stock_id = document.getElementById("stock_id" + no_info).value;
			if (document.getElementById("product_name" + no_info) == undefined) exp_product_name =""; else exp_product_name = document.getElementById("product_name" + no_info).value;
			if (document.getElementById("stock_unit" + no_info) == undefined) exp_stock_unit =""; else exp_stock_unit = document.getElementById("stock_unit" + no_info).value;
			if (document.getElementById("stock_unit_id" + no_info) == undefined) exp_stock_unit_id =""; else exp_stock_unit_id = document.getElementById("stock_unit_id" + no_info).value;
			if (document.getElementById("spect_var_id" + no_info) == undefined) exp_spect_var_id =""; else exp_spect_var_id = document.getElementById("spect_var_id" + no_info).value;
			if (document.getElementById("spect_name" + no_info) == undefined) exp_spect_name =""; else exp_spect_name =  document.getElementById("spect_name" + no_info).value;
		<cfelse>
			exp_product_id = "";
			exp_stock_id = "";
			exp_product_name = "";
			exp_stock_unit = "";
			exp_stock_unit_id = "";
			exp_spect_var_id = "";
			exp_spect_name = "";
		</cfif>
		if (document.getElementById("member_type" + no_info) == undefined) exp_member_type =""; else exp_member_type = document.getElementById("member_type" + no_info).value;
		if (document.getElementById("member_id" + no_info) == undefined) exp_member_id =""; else exp_member_id = document.getElementById("member_id" + no_info).value;
		if (document.getElementById("company_id" + no_info) == undefined) exp_company_id =""; else exp_company_id = document.getElementById("company_id" + no_info).value;
		if (document.getElementById("company" + no_info) == undefined) exp_company =""; else exp_company = document.getElementById("company" + no_info).value;
		if (document.getElementById("authorized" + no_info) == undefined) exp_authorized =""; else exp_authorized = document.getElementById("authorized" + no_info).value;
		
		if (document.getElementById("money_id" + no_info) == undefined) exp_money_type =""; else exp_money_type = document.getElementById("money_id" + no_info).value;
		if (document.getElementById("activity_type" + no_info) == undefined) exp_act_id =""; else exp_act_id = document.getElementById("activity_type" + no_info).value;
		if (document.getElementById("workgroup_id" + no_info) == undefined) exp_work_id =""; else exp_work_id = document.getElementById("workgroup_id" + no_info).value;
		if (document.getElementById("subscription_id" + no_info) == undefined) exp_subs_id =""; else exp_subs_id = document.getElementById("subscription_id" + no_info).value;
		if (document.getElementById("subscription_name" + no_info) == undefined) exp_subs_name =""; else exp_subs_name = document.getElementById("subscription_name" + no_info).value;
		<cfif x_row_copy_asset_info eq 1>//Satir Kopyalanirken Fiziki Varlik Bilgileri Tasinsin
			if (document.getElementById("asset_id" + no_info) == undefined) exp_asset_id =""; else exp_asset_id = document.getElementById("asset_id" + no_info).value;
			if (document.getElementById("asset" + no_info) == undefined) exp_asset_name =""; else exp_asset_name = document.getElementById("asset" + no_info).value;
		<cfelse>
			exp_asset_id ="";
			exp_asset_name ="";
		</cfif>
		if (document.getElementById("work_id" + no_info) == undefined) row_work_id =""; else row_work_id = document.getElementById("work_id" + no_info).value;
		if (document.getElementById("work_head" + no_info) == undefined) row_work_head =""; else row_work_head = document.getElementById("work_head" + no_info).value;
		if (document.getElementById("opp_id" + no_info) == undefined) exp_opp_id =""; else exp_opp_id = document.getElementById("opp_id" + no_info).value;
		if (document.getElementById("opp_head" + no_info) == undefined) exp_opp_head =""; else exp_opp_head = document.getElementById("opp_head" + no_info).value;
		
		if (document.getElementById("tax_rate" + no_info) == undefined) exp_tax_rate ="0"; else exp_tax_rate = document.getElementById("tax_rate" + no_info).value;
		if (document.getElementById("otv_rate" + no_info) == undefined) otv_rate ="0"; else otv_rate = document.getElementById("otv_rate" + no_info).value;
		if (document.getElementById("quantity" + no_info) == undefined) exp_quantity ="0"; else exp_quantity = document.getElementById("quantity" + no_info).value;
		if (document.getElementById("tax_code" + no_info) == undefined) exp_tax_code ="0"; else exp_tax_code = document.getElementById("tax_code" + no_info).value;
		//Satir Kopyalamada tutarlar tasinmasin
		exp_net_total = "0";
		exp_tax_total = "0";
		exp_otv_total = "0";
		
		if (document.getElementById("reason_code" + no_info) == undefined) exp_reason_code =""; else exp_reason_code = document.getElementById("reason_code" + no_info).value;
		
		add_row(row_detail,exp_center,exp_center_id,exp_item,exp_item_id,exp_project_id,exp_project,exp_product_id,exp_spect_var_id,exp_spect_name,exp_stock_id,exp_product_name,exp_stock_unit,exp_stock_unit_id,exp_member_type,exp_member_id,exp_company_id,exp_company,exp_authorized,exp_net_total,exp_tax_total,exp_otv_total,exp_tax_rate,exp_money_type,exp_act_id,exp_work_id,exp_subs_id,exp_subs_name,exp_asset_id,exp_asset_name,account_code,exp_date,row_work_id,row_work_head,exp_opp_id,exp_opp_head,otv_rate,exp_quantity,exp_tax_code,exp_reason_code);
		hesapla('',row_count);	
	}
	function change_product_cost()//seçilen tarihteki maliyeti atar, fiziki varliklardan, bakimlardan olusan islemler icin
	{
		<cfif ListFind("assetcare",fusebox.circuit,',')>
			if(document.getElementById("expense_date").value != '')
			{
				var expense_date = js_date(document.getElementById("expense_date").value.toString());
				for(tt=1;tt<=document.getElementById("record_num").value;tt++)
				{
					var product_cost_total = 0;
					if(document.getElementById("product_id" + tt)!= undefined && document.getElementById("product_id" + tt).value != '' && document.getElementById("product_name" + tt).value  != '')
					{
						var listParam = expense_date + "*" + document.getElementById("product_id"+tt).value ;
						var PRODUCT_COST_INFO = wrk_safe_query("obj_PRODUCT_COST_INFO",'dsn3',0,listParam);
						if(PRODUCT_COST_INFO.recordcount && PRODUCT_COST_INFO.PURCHASE_NET_SYSTEM != 0)
							product_cost_total = product_cost_total + parseFloat(PRODUCT_COST_INFO.PURCHASE_NET_SYSTEM);
						if(PRODUCT_COST_INFO.recordcount && PRODUCT_COST_INFO.PURCHASE_EXTRA_COST_SYSTEM != 0)
							product_cost_total = product_cost_total + parseFloat(PRODUCT_COST_INFO.PURCHASE_EXTRA_COST_SYSTEM);
						document.getElementById("total" + tt).value = commaSplit(product_cost_total);
						hesapla('',tt);
					}
				}
			}
		</cfif>
	}
	function open_process_row()
	{
		document.getElementById("open_process").style.display ='';
		<cfif isdefined("is_income") and is_income eq 1>type = 2;<cfelse>type=1;</cfif>
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=cost.emptypopup_form_add_cost_rows&type='+type,'open_process',1);
	}
	function change_date_info()
	{
		if(document.getElementById("temp_date").value != '')
			for(tt=1;tt<=document.getElementById("record_num").value;tt++)
				if(document.getElementById("row_kontrol"+tt).value==1){
					<cfif isdefined("xml_budget_row_date") and xml_budget_row_date eq 1>
						document.getElementById("expense_date"+tt).value = document.getElementById("temp_date").value;
					<cfelse>
						document.getElementById("receipt_date"+tt).value = document.getElementById("temp_date").value;
					</cfif>
				}
	}
	function product_control(no_info) /*Satirdaki urunu secmeden spec secimine izin verilmesin.*/
	{ 
		if(document.getElementById("product_id"+ no_info).value=='' || document.getElementById("product_name" + no_info).value=='')
		{
			alert("<cf_get_lang dictionary_id='59595.Spec Seçmek İçin Öncelikle Ürün Seçmeniz Gerekmektedir.'>");
			return false;
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_var_id=all.spect_var_id' + no_info +'&field_name=all.spect_name' + no_info +'&is_display=1&stock_id='+document.getElementById('stock_id'+ no_info).value ,'list');
		}
	}
	function format_total_value(no_info)
	{
		document.getElementById("total"+ no_info).value = document.getElementById("total"+ no_info).value;
		hesapla('',no_info);
	}
	function delete_spec(no_info)
	{
		if(document.getElementById("spect_var_id" + no_info)!= undefined) document.getElementById("spect_var_id"+no_info).value = '';
		if(document.getElementById("spect_name" + no_info)!= undefined) document.getElementById("spect_name"+no_info).value = '';
	}
</script>
<cfsetting showdebugoutput="yes">