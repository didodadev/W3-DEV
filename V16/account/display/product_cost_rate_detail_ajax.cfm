<!--- 
	Sayfa 3 şekilde çağırlır..
	1 prod.product_cost_rate_paper sayfasında merfiven ikonuna benzeyen işarete tıklanarak açılan istasyonlara göre üretim sonuç detayları...
	2 Açılan bu sayfadaki el işaretine tıklayarak belirtilen üretim sonucu için üretim maliyetleri yansıtma
	3 Yine Açılan bu sayfada aşağıdaki Üretim Maliyetlerini Yansıt butonuna tıklarak..
	Yani sayfa bir nevi kendi kendini çağırıyor,kafanız karışmasın!!
	M.ER 22122008
 --->
<cfsetting showdebugoutput="no">
<cfif (isdefined('attributes.pr_order_id') and isdefined('attributes.station_reflection_cost')) or (isdefined('attributes.all_results'))><!--- Bu bloğa girerse hesaplanmış olan yansımat maliyetlerinin update işlemi yapılıyor demektir,eğerki alt taraftaki else bloğuna girerse,tüm sonuçları detaylı olarak gösteriyor.. --->
	<cfif isdefined('attributes.all_results')><!--- Eğer al_result tanımlı ise detayda açılmış olan tüm üretim sonuçlarının hepsi için yansıtma yapılıyor demektir. --->
		<cfset product_list = 1>		
		<cfset amount_counter = 1>	
		<cfquery name="del_product_ext_cost" datasource="#dsn3#">
			DELETE FROM PRODUCT_EXTRA_COST_DETAIL WHERE P_ORDER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id_list#" list="yes">)
		</cfquery>
		<cfloop list="#attributes.pr_order_id_list#" index="p_order_id" delimiters=",">
            <cfquery name="upd_production_result_ref_all" datasource="#dsn3#">
                UPDATE 
                    PRODUCTION_ORDER_RESULTS_ROW 
                SET 
					<cfif attributes.labor_cost eq 1 or attributes.cost_type eq 2>
						LABOR_COST_SYSTEM = #Evaluate('yansiyan_br_maliyet_sys_money_#p_order_id#')#
					<cfelse>
						STATION_REFLECTION_COST_SYSTEM = #Evaluate('yansiyan_br_maliyet_sys_money_#p_order_id#')#
					</cfif>
                WHERE 
                    TYPE = 1 AND 
					STOCK_ID IN(SELECT S.STOCK_ID FROM STOCKS S WHERE S.IS_COST = 1) AND
                    PR_ORDER_ID = #p_order_id# AND
                    STOCK_ID = (SELECT 
                    				PO.STOCK_ID 
                                FROM 
                                	PRODUCTION_ORDERS PO,
                                    PRODUCTION_ORDER_RESULTS POR
                                WHERE 
                                	PO.P_ORDER_ID = POR.P_ORDER_ID AND
                                    POR.PR_ORDER_ID = #p_order_id#
                               )
			</cfquery>
			<cfquery name="get_Related_prods" datasource="#dsn3#">
			SELECT 
					PO.PO_RELATED_ID
				FROM 
					PRODUCTION_ORDERS PO,
					PRODUCTION_ORDER_RESULTS POR
				WHERE 
					PO.P_ORDER_ID = POR.P_ORDER_ID AND
					POR.PR_ORDER_ID = #p_order_id#
			</cfquery>
			<cfif get_Related_prods.recordcount and len(get_Related_prods.PO_RELATED_ID)>
			<cfquery name="upd_rels" datasource="#dsn3#">
				UPDATE 
					PRODUCTION_ORDER_RESULTS_ROW
					SET
					<cfif attributes.labor_cost eq 1 or attributes.cost_type eq 2>
							LABOR_COST_SYSTEM = #Evaluate('yansiyan_br_maliyet_sys_money_#p_order_id#')#
						<cfelse>
							STATION_REFLECTION_COST_SYSTEM = #Evaluate('yansiyan_br_maliyet_sys_money_#p_order_id#')#
						</cfif>
				WHERE
					PR_ORDER_ROW_ID IN
						(
							SELECT 
								PRR.PR_ORDER_ROW_ID
							FROM
								PRODUCTION_ORDER_RESULTS PR JOIN 
								PRODUCTION_ORDER_RESULTS_ROW PRR ON PR.PR_ORDER_ID = PRR.PR_ORDER_ID
							WHERE
								PR.P_ORDER_ID = #get_Related_prods.PO_RELATED_ID#
								AND PRR.TYPE IN (2,3)
								AND PRR.STOCK_ID IN(SELECT S.STOCK_ID FROM STOCKS S WHERE S.IS_COST = 1)
								AND PRR.SPEC_MAIN_ID IS NOT NULL
								AND PRR.STOCK_ID IN (SELECT STOCK_ID FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = #p_order_id# AND TYPE = 1)
						)
				</cfquery>
			</cfif>
			<cfif isdefined("attributes.act_type") and attributes.act_type eq 2>
				<cfset cost_det_list = attributes.account_id_list>
			<cfelse>
				<cfset cost_det_list = attributes.expence_row_list>
			</cfif>
			<cfset index_shift = 1>
			<cfloop list="#cost_det_list#" index="acc_id" delimiters=",">
				<cfquery name="add_product_ext_cost" datasource="#dsn3#">
					INSERT INTO
						PRODUCT_EXTRA_COST_DETAIL
						(
							ACCOUNT_ID,
							EXPENSE_ID,
							EXPENSE_SHIFT,
							AMOUNT,
							STATION_ID,
							PRODUCT_ID,
							MONEY,
							P_ORDER_ID
						)
						VALUES
						(
							<cfif attributes.act_type eq 2><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#acc_id#"><cfelse>NULL</cfif>,
							<cfif attributes.act_type eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="#acc_id#"><cfelse>NULL</cfif>,
							<cfif len(attributes.EXPENSE_SHIFT)><cfqueryparam cfsqltype="cf_sql_float" value="#ListGetAt(attributes.expence_shift_list,index_shift)#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_float" value="#ListGetAt(attributes.product_cost_list,amount_counter)#">,
							<cfif len(attributes.STATION_ID)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.STATION_ID#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.pr_id_list,product_list)#">,
							<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session.ep.money#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#p_order_id#">					
						)		
				</cfquery>
				<cfset amount_counter = amount_counter + 1>	
				<cfset index_shift = index_shift + 1>
			</cfloop>
			<cfset product_list = product_list + 1>
		</cfloop>
        <script language="javascript">
			alert("<cf_get_lang dictionary_id='64331.Üretim Sonuçlarına Maliyetler Yansıtıldı'> !");
			window.location.href="<cfoutput>#request.self#?fuseaction=account.product_labor_cost_paper</cfoutput>"
		</script>
		<!--- Belirtilen İstasyon için Açılan Ajax Sayfasındaki üretim sonuçlarının hepsine birden üretim maliyetlerinni yansıtmış olduk.. --->
    <cfelse>
        <cfquery name="upd_production_result_ref" datasource="#dsn3#">
            UPDATE 
				PRODUCTION_ORDER_RESULTS_ROW 
			SET 
				<cfif attributes.labor_cost eq 1 or attributes.cost_type eq 2>
					LABOR_COST_SYSTEM = #attributes.station_reflection_cost# 
				<cfelse>
					STATION_REFLECTION_COST_SYSTEM = #attributes.station_reflection_cost# 
				</cfif>
			WHERE 
				TYPE =1 
				AND PR_ORDER_ID = #attributes.pr_order_id# 
                AND STOCK_ID = (SELECT 
                    				PO.STOCK_ID 
                                FROM 
                                	PRODUCTION_ORDERS PO,
                                    PRODUCTION_ORDER_RESULTS POR
                                WHERE 
                                	PO.P_ORDER_ID = POR.P_ORDER_ID AND
                                    POR.PR_ORDER_ID = #attributes.pr_order_id#
                               )
		</cfquery>
		<cfquery name="get_Related_prods" datasource="#dsn3#">
			SELECT 
				PO.PO_RELATED_ID
			FROM 
				PRODUCTION_ORDERS PO,
				PRODUCTION_ORDER_RESULTS POR
			WHERE 
				PO.P_ORDER_ID = POR.P_ORDER_ID AND
				POR.PR_ORDER_ID = #attributes.pr_order_id#
		</cfquery>
		<cfif get_Related_prods.recordcount and len(get_Related_prods.PO_RELATED_ID)>
			<cfquery name="upd_rels" datasource="#dsn3#">
				UPDATE 
					PRODUCTION_ORDER_RESULTS_ROW
				SET
					<cfif attributes.labor_cost eq 1 or attributes.cost_type eq 2>
						LABOR_COST_SYSTEM = #attributes.station_reflection_cost# 
					<cfelse>
						STATION_REFLECTION_COST_SYSTEM = #attributes.station_reflection_cost# 
					</cfif>
				WHERE
					PR_ORDER_ROW_ID IN
					(
						SELECT 
							PRR.PR_ORDER_ROW_ID
						FROM
							PRODUCTION_ORDER_RESULTS PR JOIN 
							PRODUCTION_ORDER_RESULTS_ROW PRR ON PR.PR_ORDER_ID = PRR.PR_ORDER_ID
						WHERE
							PR.P_ORDER_ID = #get_Related_prods.PO_RELATED_ID#
							AND PRR.TYPE IN (2,3)
							AND PRR.STOCK_ID IN(SELECT S.STOCK_ID FROM STOCKS S WHERE S.IS_COST = 1)
							AND PRR.SPEC_MAIN_ID IS NOT NULL
							AND PRR.STOCK_ID IN (SELECT STOCK_ID FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = #attributes.pr_order_id# AND TYPE = 1)
					)
			</cfquery>
		</cfif>
		<cfquery name="del_product_ext_cost" datasource="#dsn3#">
			DELETE FROM PRODUCT_EXTRA_COST_DETAIL WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PR_ORDER_ID#">
		</cfquery>
		<cfif attributes.act_type eq 2>
			<cfset cost_det_list = attributes.account_id_list>
		<cfelse>
			<cfset cost_det_list = attributes.expence_row_list>
		</cfif>
		<cfset index_shift = 1>
		<cfloop list="#cost_det_list#" index="acc_id" delimiters=",">
			<cfquery name="add_product_ext_cost" datasource="#dsn3#">
				INSERT INTO
					PRODUCT_EXTRA_COST_DETAIL
					(
						ACCOUNT_ID,
						EXPENSE_ID,
						EXPENSE_SHIFT,
						AMOUNT,
						STATION_ID,
						PRODUCT_ID,
						MONEY,
						P_ORDER_ID
					)
					VALUES
					(
						<cfif attributes.act_type eq 2><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#acc_id#"><cfelse>NULL</cfif>,
						<cfif attributes.act_type eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="#acc_id#"><cfelse>NULL</cfif>,
						<cfif len(attributes.EXPENSE_SHIFT)><cfqueryparam cfsqltype="cf_sql_float" value="#ListGetAt(attributes.expence_shift_list,index_shift)#"><cfelse>NULL</cfif>,
						<cfif len(attributes.product_cost_row_list)><cfqueryparam cfsqltype="cf_sql_float" value="#listGetAt(attributes.product_cost_row_list,index_shift)#"><cfelse>NULL</cfif>,							
						<cfif len(attributes.STATION_ID)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.STATION_ID#"><cfelse>NULL</cfif>,
						<cfif len(attributes.PRODUCT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_ID#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session.ep.money#">,	
						<cfif len(attributes.PR_ORDER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"><cfelse>NULL</cfif>										
					)		
			</cfquery>
			<cfset index_shift = index_shift + 1>
		</cfloop>
        <b><cfoutput><font color="red">#attributes.result_no#</font></cfoutput> <cf_get_lang dictionary_id="47556.İçin Ek Maliyet Yansıtıldı">!</b>
    </cfif>
<cfelse>
	<cfif attributes.station_id neq 0>
		<cfquery name="get_workstations_name" datasource="#dsn3#">
			SELECT STATION_ID,STATION_NAME,ISNULL(REFLECTION_TYPE,1) REFLECTION_TYPE,UNIT2 FROM WORKSTATIONS WHERE STATION_ID IN (#attributes.station_id#)
		</cfquery>
	</cfif>
	<cfset attributes.start_dates = dateformat(attributes.start_dates,dateformat_style)>
	<cfset attributes.finish_dates = dateformat(attributes.finish_dates,dateformat_style)>
	<cfquery name="get_s" datasource="#dsn3#">
		SELECT STATION_ID FROM WORKSTATION_PERIOD WHERE ACCOUNT_ID = '#attributes.account_id#'
	</cfquery> 
	<cfset s_list = valuelist(get_s.station_id)>
    <cfquery name="GET_PRODUCT_PAPER_DETAIL" datasource="#DSN3#">
        SELECT
        	STATION_REFLECTION_COST_SYSTEM,
			(SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID=T1.STATION_ID) STATION_NAME,
			(SELECT ISNULL(REFLECTION_TYPE,1) FROM WORKSTATIONS WHERE STATION_ID=T1.STATION_ID) REFLECTION_TYPE,
			(SELECT UNIT2 FROM WORKSTATIONS WHERE STATION_ID=T1.STATION_ID) UNIT2,
        	START_DATE,
            FINISH_DATE,
			P_ORDER_NO,
			P_ORDER_ID,
        	IS_STOCK_FIS,
            PR_ORDER_ID, 
			STOCK_CODE,
            PRODUCT_NAME,
            RESULT_NO,
            STOCK_ID,
            SPEC_MAIN_ID,
            AMOUNT,
			PRODUCT_ID,
          	CALISMA_DAKIKA,
			<cfif attributes.labor_cost eq 1>
				SUM(EXPENSED_MONEY) EXPENSED_MONEY,
				SUM(NORMAL) NORMAL,
				SUM(MESAI_NORMAL) MESAI_NORMAL,
				SUM(MESAI_HSONU) MESAI_HSONU,
				SUM(MESAI_TATIL) MESAI_TATIL,
            </cfif>
            RECORD_DATE	,
			ISNULL((SELECT TOP 1 PRICE*ISNULL((SELECT 
										TOP 1 RATE2
									FROM 
										#dsn_alias#.MONEY_HISTORY
									WHERE
										VALIDATE_DATE <= #createodbcdatetime(attributes.finish_dates)# AND
										MONEY = PS.MONEY
									ORDER BY 
										VALIDATE_DATE DESC),1) FROM PRICE_STANDART PS WHERE PS.PRODUCT_ID = T1.PRODUCT_ID AND PRICESTANDART_STATUS = 1 AND PURCHASESALES = 0),0) PRICE_PUR
		FROM
		(
		SELECT
        	PORR.STATION_REFLECTION_COST_SYSTEM,
        	POR.START_DATE,
            POR.FINISH_DATE,
			PO.P_ORDER_NO,
			PO.P_ORDER_ID,
        	POR.IS_STOCK_FIS,
            PORR.PR_ORDER_ID, 
			S.STOCK_CODE,
            S.PRODUCT_NAME,
            POR.RESULT_NO,
            PORR.STOCK_ID,
            PORR.SPEC_MAIN_ID,
            PORR.AMOUNT,
			S.PRODUCT_ID,
			POR.STATION_ID,
            ISNULL(datediff(minute,POR.START_DATE,POR.FINISH_DATE),0) CALISMA_DAKIKA,
			<cfif attributes.labor_cost eq 1>
				<cfif attributes.x_cost_type eq 0>
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
            PO.RECORD_DATE
        FROM 
            PRODUCTION_ORDERS PO,
            PRODUCTION_ORDER_RESULTS POR,
            PRODUCTION_ORDER_RESULTS_ROW PORR,
            STOCKS S
			<cfif attributes.labor_cost eq 1>
				,#dsn_alias#.TIME_COST TC
				<cfif attributes.x_cost_type eq 1>
					,#dsn_alias#.EMPLOYEES_PUANTAJ_COST EPC
				</cfif>
			</cfif>
        WHERE
            PO.P_ORDER_ID = POR.P_ORDER_ID 
            AND S.STOCK_ID = PORR.STOCK_ID AND
            POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND 
            PORR.TYPE = 1 AND
            PO.STOCK_ID = PORR.STOCK_ID AND
			ISNULL(PO.IS_DEMONTAJ,0) = 0 AND
			S.IS_COST = 1
			<cfif attributes.station_id neq 0>
				AND POR.STATION_ID IN ( #attributes.station_id#)
			</cfif>
			<cfif len(attributes.account_id) and attributes.account_id neq 0>
				AND POR.STATION_ID IN( #PreserveSingleQuotes(s_list)#)
			</cfif>
			<cfif attributes.labor_cost eq 1>
				AND POR.PR_ORDER_ID = TC.P_ORDER_RESULT_ID 
				AND TC.OUR_COMPANY_ID = #session.ep.company_id# 
				<cfif attributes.x_cost_type eq 1>
					AND TC.EMPLOYEE_ID = EPC.EMPLOYEE_ID 
					AND EPC.SAL_YEAR = YEAR(TC.EVENT_DATE)
					AND EPC.SAL_MON = MONTH(TC.EVENT_DATE)
				</cfif>
			</cfif>
			<cfif len(attributes.start_dates)>AND POR.FINISH_DATE >= #createodbcdatetime(attributes.start_dates)# </cfif>
            <cfif len(attributes.finish_dates)>AND POR.FINISH_DATE < #date_add('d',1,createodbcdatetime(attributes.finish_dates))#</cfif>
		<cfif attributes.labor_cost eq 1>
			UNION ALL
			SELECT 
            	PORR.STATION_REFLECTION_COST_SYSTEM,
				POR.START_DATE,
				POR.FINISH_DATE,
				PO.P_ORDER_NO,
				PO.P_ORDER_ID,
				POR.IS_STOCK_FIS,
				PORR.PR_ORDER_ID, 
				S.STOCK_CODE,
				S.PRODUCT_NAME,
				POR.RESULT_NO,
				PORR.STOCK_ID,
				PORR.SPEC_MAIN_ID,
				PORR.AMOUNT,
				S.PRODUCT_ID,
				POR.STATION_ID,
				ISNULL(datediff(minute,POR.START_DATE,POR.FINISH_DATE),0) CALISMA_DAKIKA,
				0 EXPENSED_MONEY,
				0 NORMAL,
				0 MESAI_NORMAL,
				0 MESAI_HSONU,
				0 MESAI_TATIL,
				PO.RECORD_DATE
			FROM 
				PRODUCTION_ORDERS PO,
				PRODUCTION_ORDER_RESULTS POR,
				PRODUCTION_ORDER_RESULTS_ROW PORR,
            	STOCKS S
			WHERE
            	S.STOCK_ID = PORR.STOCK_ID AND
				PO.P_ORDER_ID = POR.P_ORDER_ID AND
				POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND 
				PORR.TYPE = 1 AND
                PO.STOCK_ID = PORR.STOCK_ID AND
				ISNULL(PO.IS_DEMONTAJ,0) = 0 AND
				S.IS_COST = 1 AND
				POR.PR_ORDER_ID NOT IN(SELECT TC.P_ORDER_RESULT_ID FROM #dsn_alias#.TIME_COST TC WHERE TC.P_ORDER_RESULT_ID IS NOT NULL AND TC.OUR_COMPANY_ID =#session.ep.company_id#)
				<cfif len(attributes.start_dates)>AND POR.FINISH_DATE >= #createodbcdatetime(attributes.start_dates)# </cfif>
				<cfif len(attributes.finish_dates)>AND POR.FINISH_DATE < #date_add('d',1,createodbcdatetime(attributes.finish_dates))# </cfif>
				<cfif attributes.station_id neq 0>
					AND POR.STATION_ID IN ( #attributes.station_id# )
				</cfif>
				<cfif len(attributes.account_id) and attributes.account_id neq 0>
					AND POR.STATION_ID IN( #PreserveSingleQuotes(s_list)#)
				</cfif>
		</cfif>
		)T1
		GROUP BY
        	STATION_REFLECTION_COST_SYSTEM,
			START_DATE,
            FINISH_DATE,
			P_ORDER_NO,
			P_ORDER_ID,
        	IS_STOCK_FIS,
            PR_ORDER_ID, 
			STOCK_CODE,
            PRODUCT_NAME,
            RESULT_NO,
            STOCK_ID,
            SPEC_MAIN_ID,
            AMOUNT,
			PRODUCT_ID,
          	CALISMA_DAKIKA,
            RECORD_DATE,
			STATION_ID
        ORDER BY STOCK_ID,RECORD_DATE
    </cfquery>
	<cfif isdefined("get_workstations_name") and get_workstations_name.reflection_type eq 3>
		<cfquery name="get_prod_unit" datasource="#dsn3#">
			SELECT MULTIPLIER,PRODUCT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID IN(#valuelist(GET_PRODUCT_PAPER_DETAIL.PRODUCT_ID)#) AND ADD_UNIT = '#get_workstations_name.unit2#'
		</cfquery>
		<cfoutput query="get_prod_unit">
			<cfset "add_unit_mult_#get_prod_unit.PRODUCT_ID#" = MULTIPLIER>
		</cfoutput>
	</cfif>
	<cfset pr_order_id_list = listdeleteduplicates(ValueList(GET_PRODUCT_PAPER_DETAIL.PR_ORDER_ID,','))>
	<cfset pr_id_list = ValueList(GET_PRODUCT_PAPER_DETAIL.PRODUCT_ID,',')>	
	<cfset p_id_list = ValueList(GET_PRODUCT_PAPER_DETAIL.P_ORDER_ID,',')><!---Üretim emri sonucu ID--->		 
	<cfif GET_PRODUCT_PAPER_DETAIL.recordcount>
        <div id="product_cost_reflection_div_<cfoutput>#attributes.station_id#</cfoutput>" style="height:19px;"></div>
		<cfform name="upd_prod_cost_ref#replace(attributes.station_id,',','_','all')#" action="#request.self#?fuseaction=account.emptypopup_product_cost_rate_detail_ajax&all_results=1&labor_cost=#attributes.labor_cost#" method="post">
        	<cf_grid_list>
				<cfinput type="hidden" name="pr_order_id_list" value="#pr_order_id_list#"> 
				<cfinput type="hidden" name="pr_id_list" value="#pr_id_list#">
				<cfinput type="hidden" name="p_id_list" value="#p_id_list#">
                <cfinput type="hidden" name="station_id" value="#attributes.station_id#"> 
				<cfinput type="hidden" name="cost_type" value="#attributes.cost_type#">
				<cfinput type="hidden" name="product_cost_sys_money_list" value="#attributes.product_cost_sys_money_list#">
				<cfif isdefined('attributes.act_type') and len(attributes.act_type)>
					<cfinput type="hidden" name="act_type" value="#attributes.act_type#">	
				</cfif>
				<cfif isdefined('attributes.expense_shift') and len(attributes.expense_shift)>
					<cfinput type="hidden" name="expense_shift" value="#attributes.expense_shift#">
					<cfinput type="hidden" name="expence_shift_list" value="#attributes.expence_shift_list#">
				</cfif>
				<cfif isdefined('attributes.act_type') and attributes.act_type eq 2>
					<cfinput type="hidden" name="account_id" value="#attributes.account_id#">
					<cfinput type="hidden" name="account_id_list" value="#attributes.account_id_list#">
				<cfelse>
					<cfinput type="hidden" name="expense_id" value="#attributes.expense_id#">
					<cfinput type="hidden" name="expence_row_list" value="#attributes.expence_row_list#">
				</cfif>										 
               <thead>
                <tr>
                    <th <cfif isdefined("get_workstations_name") and get_workstations_name.reflection_type eq 3>colspan="16"<cfelse>colspan="16"</cfif>>
					<cfif attributes.labor_cost eq 1>
						<cf_get_lang dictionary_id="47557.Üretim İşçilik Maliyetleri">
					<cfelse>
						<cf_get_lang dictionary_id="47558.İstasyon Maliyetlerine Göre Ürün Ek Maliyetleri">
					</cfif>
					</th>
                </tr>
				<cfoutput>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id="58577.Sıra"></th>
                    <th><cf_get_lang dictionary_id="47559.Emir-Sonuc"></th>
                    <th><cf_get_lang dictionary_id="57742.Tarih"></th>
                    <th><cf_get_lang dictionary_id="57657.Ürün"></th>
                    <th><cf_get_lang dictionary_id="57518.Stok Kodu"></th>
                    <th><cf_get_lang dictionary_id="57647.Spec"></th>
					<th id="amount_#attributes.station_id#"><cf_get_lang dictionary_id="57635.Miktar"></th>
					<cfif isdefined("get_workstations_name") and get_workstations_name.reflection_type eq 4>
                    	<th>Fiyat</th>
					</cfif>
					<cfif attributes.labor_cost eq 0>
						<cfif isdefined("get_workstations_name") and get_workstations_name.reflection_type eq 3>
							<th  nowrap id="amount_2_#attributes.station_id#">#get_workstations_name.unit2#</th>
						</cfif>
						<th nowrap><cf_get_lang dictionary_id="29513.Süre"> (<cf_get_lang dictionary_id="58827.dk">)</th>
						<th width="100"  title="<cf_get_lang dictionary_id="29513.Süre">/<cf_get_lang dictionary_id="64330.İstasyon Çalışma Saati">"><cf_get_lang dictionary_id="58456.Oran"></th>
					<cfelse>
						<th><cf_get_lang dictionary_id="54048.Çalışma Saati"></th>
						<th><cf_get_lang dictionary_id="36973.Fazla Mesai(Normal)"></th>
						<th><cf_get_lang dictionary_id="36971.Fazla Mesai(HTatili)"></th>
						<th><cf_get_lang dictionary_id="47542.Fazla Mesai(Tatil)"></th>
					</cfif>
                    <th id="sys_procuct_cost_#attributes.station_id#">
						<cfif attributes.labor_cost eq 1 or attributes.cost_type eq 2>
							<cf_get_lang dictionary_id="47560.İşçilik Maliyeti"> #session.ep.money#
						<cfelse>
							<cf_get_lang dictionary_id="47561.Yansıyan Maliyet"> #session.ep.money#
						</cfif>
					</th>
					<cfif attributes.labor_cost eq 0 and attributes.cost_type eq 1>
                    	<th id="sys2_procuct_cost_#attributes.station_id#"><cf_get_lang dictionary_id="47561.Yansıyan Maliyet"> #session.ep.money2#</th>
					</cfif>
					<th>
						<cfif attributes.labor_cost eq 1 or attributes.cost_type eq 2>
							<cf_get_lang dictionary_id="57784.İşçilik"> <cf_get_lang dictionary_id="57636.Birim"><cf_get_lang dictionary_id="58258.Maliyet"> #session.ep.money#
						<cfelse>
							<cf_get_lang dictionary_id="29916.Yansıyan"> <cf_get_lang dictionary_id="57636.Birim"><cf_get_lang dictionary_id="58258.Maliyet"> #session.ep.money#
						</cfif>
					</th>
					<cfif attributes.labor_cost eq 0 and attributes.cost_type eq 1>
                    	<th ><cf_get_lang dictionary_id="29916.Yansıyan"> <cf_get_lang dictionary_id="57636.Birim"><cf_get_lang dictionary_id="58258.Maliyet"> #session.ep.money2#</th>
                    </cfif>
					<th title="<cf_get_lang dictionary_id='57210.Stok Fişi'>"><cf_get_lang dictionary_id="57210.Stok Fişi"></th>
                    <th></th>
                </tr>
				</cfoutput>
			  </thead>
				<cfset toplam =0>
				<cfset product_cost_list = ''><!--- Form submit edildiğinde tüm kalemlerin yansıyan maliyetleri----->
				<cfset product_cost_row_list = ''><!--- tüm kalemlerin satırdaki yansıyan maliyetleri----->				
				<cfoutput query="GET_PRODUCT_PAPER_DETAIL">					
                <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td>#currentrow#</td>
                    <td>#P_ORDER_NO#&nbsp;&nbsp;#RESULT_NO#</td>
                    <td>#DateFormat(START_DATE,dateformat_style)# #TimeFormat(START_DATE,timeformat_style)# -#DateFormat(FINISH_DATE,dateformat_style)# #TimeFormat(FINISH_DATE,timeformat_style)#</td>
                    <td>#PRODUCT_NAME#</td>
                    <td>#STOCK_CODE#</td>
                    <td>#SPEC_MAIN_ID#</td>
                    <td style="text-align:right;">#AMOUNT#</td>
					<cfif isdefined("get_workstations_name") and get_workstations_name.reflection_type eq 4>
                   	 <td style="text-align:right;">#tlformat(PRICE_PUR)#</td>
					</cfif>
					<cfset kontrol_unit = 1>
					<cfif attributes.labor_cost eq 0>
						<cfif isdefined("get_workstations_name") and get_workstations_name.reflection_type eq 3>
							<cfif isdefined("add_unit_mult_#PRODUCT_ID#")>
								<td style="text-align:right;">#AMOUNT/evaluate("add_unit_mult_#PRODUCT_ID#")#</td>
							<cfelse>
								<cfset kontrol_unit = 0>
								<td></td>	
							</cfif>
						</cfif>
						<td style="text-align:right;">#CALISMA_DAKIKA#</td>
						<cfif reflection_type eq 1>
							<cfset oran =CALISMA_DAKIKA/attributes.sum_minute>
						<cfelseif reflection_type eq 2 and attributes.prod_amount neq 0>
							<cfset oran =AMOUNT/attributes.prod_amount>
						<cfelseif reflection_type eq 3 and isdefined("add_unit_mult_#PRODUCT_ID#")>
							<cfset oran =(AMOUNT/evaluate("add_unit_mult_#PRODUCT_ID#"))/attributes.prod_amount2>
						<cfelseif reflection_type eq 4 and attributes.prod_price neq 0>
							<cfset oran =(PRICE_PUR*AMOUNT)/attributes.prod_price>
						<cfelse>
							<cfset oran = 0>
						</cfif>
						<cfset yansiyan_maliyet_sys_money =(attributes.sys_money_cost*oran)>
						<cfloop list="#attributes.product_cost_sys_money_list#" index="money_list" delimiters=",">
							<cfset product_cost_list = listappend(product_cost_list, money_list*oran)>
							<cfset product_cost_row_list = listappend(product_cost_row_list, money_list*oran)><!--- tüm kalemlerin satırdaki yansıyan maliyetleri----->
						</cfloop>			 
						<cfset toplam = toplam+yansiyan_maliyet_sys_money>						
						<cfset yansiyan_maliyet_sys2_money =(attributes.sys2_money_cost*oran)>
						<cfset yansiyan_br_maliyet_sys_money = yansiyan_maliyet_sys_money/AMOUNT>						
						<cfset yansiyan_br_maliyet_sys2_money = yansiyan_maliyet_sys2_money/AMOUNT>
                    	<td style="text-align:right;"><cfif x_reflection_type>#CALISMA_DAKIKA#/#attributes.sum_minute#<cfelse>#tlformat(oran,8)#</cfif></td>
                    <cfelse>
						<td style="text-align:right;">#TLFORMAT(NORMAL/60)#</td>
						<td style="text-align:right;">#TLFORMAT(MESAI_NORMAL/60)#</td>
						<td style="text-align:right;">#TLFORMAT(MESAI_HSONU/60)#</td>
						<td style="text-align:right;">#TLFORMAT(MESAI_TATIL/60)#</td>
						<cfset yansiyan_maliyet_sys_money = expensed_money>
						<cfset yansiyan_br_maliyet_sys_money = yansiyan_maliyet_sys_money/AMOUNT>
						<cfset toplam = toplam+yansiyan_maliyet_sys_money>
					</cfif>
					<td style="text-align:right;">#tlformat(yansiyan_maliyet_sys_money)#</td>
                    <cfif attributes.labor_cost eq 0 and attributes.cost_type eq 1>
						<td style="text-align:right;">#tlformat(yansiyan_maliyet_sys2_money)#</td>
                    </cfif>
					<td style="text-align:right;">
                        <input type="hidden" class="monebox" name="yansiyan_br_maliyet_sys_money_#pr_order_id#" id="yansiyan_br_maliyet_sys_money_#pr_order_id#" value="#yansiyan_br_maliyet_sys_money#">
                        <cfif yansiyan_maliyet_sys_money eq 0><font color="FF0000"></cfif>#tlformat(yansiyan_br_maliyet_sys_money)# <cfif yansiyan_maliyet_sys_money eq 0></font></cfif>
                    </td>
					<cfif attributes.labor_cost eq 0 and attributes.cost_type eq 1>
						<td style="text-align:right;">
							<cfquery name="get_money_rate" datasource="#dsn#">
                                SELECT MONEY,RATE1,RATE2 FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(finish_date)#"> GROUP BY MONEY)
                            </cfquery>
                            <cfif get_money_rate.recordcount eq 0>
                                <cfquery name="get_money_rate" datasource="#dsn2#">
                                    SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                                </cfquery>
							</cfif>							
                            #tlformat(yansiyan_br_maliyet_sys_money/get_money_rate.RATE2)#
						</td>
                    </cfif>
					<td>
						<cfif IS_STOCK_FIS>
                            <a href="javascript://"><i class="icon-check" title="<cf_get_lang dictionary_id='59184.Oluşturuldu'>"></i></a>
                        <cfelse>
                            <a href="javascript://"><i class="catalyst-close bold" title="<cf_get_lang dictionary_id='59185.Oluşturulmadı'>" ></i></a>
                        </cfif>
                    </td>
                    <td style="text-align:center">
						<cfif kontrol_unit eq 0>
							<font color="FF0000"><cf_get_lang dictionary_id="47562.Ürün Ek Birim Tanımlarını Kontrol Ediniz"></font>
						<cfelse>
							<a href="javascript://" onClick="product_cost_deliver('#attributes.station_id#','#yansiyan_br_maliyet_sys_money#','#RESULT_NO#','','reflection','product_cost_reflection_div_#attributes.station_id#','','',#attributes.cost_type#,'','<cfoutput><cfif isdefined("attributes.act_type") and attributes.act_type eq 2>#attributes.account_id#</cfif></cfoutput>','','#PR_ORDER_ID#','#attributes.expense_shift#','#attributes.act_type#','<cfif isdefined("attributes.act_type") and attributes.act_type eq 1>#attributes.expense_id#</cfif>','#PRODUCT_ID#','#attributes.account_id_list#','#attributes.expence_row_list#','#attributes.expence_shift_list#','','#product_cost_row_list#');"><i class="fa fa-hand-o-up" title="<cf_get_lang dictionary_id='64329.Üretim Sonucuna Yansıt'>!"></i></a>
						</cfif>
					</td>
				</tr>
				<cfset product_cost_row_list = ''>
                </cfoutput>
               </tbody>
			</cf_grid_list>
			<div class="ui-info-bottom flex-end">
					<cfoutput>
						<cfset colspan = 15>
						<cfif isdefined("get_workstations_name") and get_workstations_name.reflection_type eq 3>
							<cfset colspan = colspan+1>
						<cfelseif isdefined("get_workstations_name") and get_workstations_name.reflection_type eq 4>
							<cfset colspan = colspan+1>
						</cfif>
						<div><input type="button" class="ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='47563.Üretim Maliyetlerini Yansıt'>" onClick="upd_prod_cost_ref#replace(attributes.station_id,',','_','all')#.submit();"></div>
					</cfoutput>
				   <cfinput type="hidden" name="product_cost_list" value="#product_cost_list#">
			</div>
		</cfform>
    </cfif>
</cfif>
<script type="text/javascript">
	function border_active(html_obj,type,station_id)
	{
		for(hi=1;hi<=list_len(html_obj,',');hi++){
			new_html_obj = list_getat(html_obj,hi);
			if(type==1)
				document.getElementById(new_html_obj+station_id).style.backgroundColor = 'FFFF33';//system_cost_
			else if(type==0)	
				document.getElementById(new_html_obj+station_id).style.backgroundColor = '';
		}	
	}
</script>
<cfabort>
