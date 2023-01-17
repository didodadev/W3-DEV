<cfquery name="UPD_SALE" datasource="#DSN2#">
	UPDATE
		STOCK_FIS
	SET
		FIS_TYPE = #attributes.process_type#,
		PROCESS_CAT = #attributes.PROCESS_CAT#,
		FIS_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FIS_NO#">,
		DEPARTMENT_OUT = <cfif len(attributes.department_id_2)>#attributes.department_id_2#<cfelse>NULL</cfif>,
		LOCATION_OUT = <cfif len(attributes.location_id_2)>#attributes.location_id_2#<cfelse>NULL</cfif>,
		DEPARTMENT_IN = <cfif len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
		LOCATION_IN = <cfif len(attributes.location_id)>#attributes.location_id#<cfelse>NULL</cfif>,
		EMPLOYEE_ID = #DELIVER_GET_ID#,
		FIS_DATE = #attributes.start_date#,
		REF_NO = <cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
		PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		FIS_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
		SUBSCRIPTION_ID = <cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
		IS_RELATED_PROJECT = <cfif isDefined("attributes.is_related_project") and attributes.is_related_project eq 1>1<cfelse>0</cfif>,
		RELATED_INVOICE_ID = <cfif isDefined("attributes.related_invoice_id") and len(attributes.related_invoice_id)>#attributes.related_invoice_id#<cfelse>NULL</cfif>
	WHERE
		FIS_ID = #attributes.fis_id#
</cfquery>	
<cfquery name="DEL_STOCKS_ROW" datasource="#DSN2#">
	DELETE FROM STOCK_FIS_ROW WHERE FIS_ID = #attributes.fis_id#
</cfquery>
<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
	DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=#attributes.process_type# AND UPD_ID=#attributes.fis_id#
</cfquery>
<cfquery name="DEL_SHIP_ROW_MONEY" datasource="#dsn2#">
	DELETE FROM STOCK_FIS_MONEY WHERE ACTION_ID = #attributes.fis_id#
</cfquery>			
<cfquery name="DEL_INVENTORY_ROW" datasource="#dsn2#">
	DELETE FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #attributes.fis_id# AND PERIOD_ID = #session.ep.period_id# AND PROCESS_TYPE = #attributes.process_type#
</cfquery>
<!--- inventory history kayitlari silinip tekrar olusturulur --->
<cfquery name="DEL_INVENTORY_HISTORY" datasource="#dsn2#">
	DELETE FROM #dsn3_alias#.INVENTORY_HISTORY WHERE ACTION_ID = #attributes.fis_id# AND ACTION_TYPE = #attributes.process_type#
</cfquery>
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
		<cfif isDefined("attributes.invent_id#i#") and len(evaluate("attributes.invent_id#i#"))>
			<cfquery name="get_inv_count" datasource="#dsn2#">
				SELECT ISNULL(AMORTIZATION_COUNT,0) AS INV_COUNT FROM #dsn3_alias#.INVENTORY WHERE INVENTORY_ID = #evaluate("attributes.invent_id#i#")#
			</cfquery>
			<cfquery name="UPD_INVT" datasource="#DSN2#">
				UPDATE
					#dsn3_alias#.INVENTORY
				SET
					INVENTORY_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.invent_no#i#')#">,
					INVENTORY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.invent_name#i#')#">,
					QUANTITY = #evaluate("attributes.quantity#i#")#,
					AMOUNT = #evaluate("attributes.row_total#i#")#,
					AMOUNT_2 = <cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.row_total#i#")/currency_multiplier)#<cfelse>NULL</cfif>,
					AMORTIZATON_ESTIMATE = #evaluate("attributes.amortization_rate#i#")#,
					AMORTIZATON_METHOD = #evaluate("attributes.amortization_method#i#")#,
					ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.account_id#i#')#">,
					ENTRY_DATE = #attributes.start_date#,
					DEBT_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.debt_account_id#i#')#">,
					CLAIM_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.claim_account_id#i#')#">,
					ACCOUNT_PERIOD= <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.period#i#')#">,
					EXPENSE_CENTER_ID = <cfif len(evaluate("attributes.expense_center_name#i#")) and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
					EXPENSE_ITEM_ID = <cfif len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
					INVENTORY_CATID=<cfif isdefined('attributes.inventory_cat_id#i#') and len(evaluate("attributes.inventory_cat_id#i#")) and isdefined('attributes.inventory_cat#i#') and len(evaluate('attributes.inventory_cat#i#'))>#evaluate("attributes.inventory_cat_id#i#")#<cfelse>NULL</cfif>,
					INVENTORY_DURATION=<cfif isdefined('attributes.inventory_duration#i#') and len(evaluate("attributes.inventory_duration#i#"))>#evaluate("attributes.inventory_duration#i#")#<cfelse>NULL</cfif>,
					AMORTIZATION_TYPE=<cfif isdefined('attributes.amortization_type#i#') and len(evaluate("attributes.amortization_type#i#"))>#evaluate("attributes.amortization_type#i#")#<cfelse>NULL</cfif>,
					PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
					<cfif get_inv_count.inv_count eq 0>
						AMORT_LAST_VALUE = #evaluate("attributes.row_total#i#")#,
						LAST_INVENTORY_VALUE = #evaluate("attributes.row_total#i#")#,
						LAST_INVENTORY_VALUE_2 = <cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.row_total#i#")/currency_multiplier)#<cfelse>NULL</cfif>,
					</cfif>
					SUBSCRIPTION_ID = <cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
					UPDATE_DATE = #NOW()#,
					UPDATE_EMP = #SESSION.EP.USERID#,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					INVENTORY_DURATION_IFRS=<cfif isdefined('attributes.ifrs_inventory_duration#i#') and len(evaluate("attributes.ifrs_inventory_duration#i#"))>#evaluate("attributes.ifrs_inventory_duration#i#")#<cfelse>NULL</cfif>,
					ACTIVITY_TYPE_ID = <cfif len(evaluate("attributes.activity_type#i#"))>#evaluate("attributes.activity_type#i#")#<cfelse>NULL</cfif>
				WHERE
					INVENTORY_ID = #evaluate("attributes.invent_id#i#")#
			</cfquery>
			<cfset invent_id_info = evaluate("attributes.invent_id#i#")>
		<cfelse>
			<cfquery name="ADD_INVENT" datasource="#dsn2#">
				INSERT INTO 
					#dsn3_alias#.INVENTORY
					(
						INVENTORY_NUMBER,
						INVENTORY_NAME,
						QUANTITY,
						AMOUNT,
						AMOUNT_2,
						AMORTIZATON_ESTIMATE,
						AMORTIZATON_METHOD,
						ACCOUNT_ID,
						DEBT_ACCOUNT_ID,
						CLAIM_ACCOUNT_ID,
						ACCOUNT_PERIOD,
						EXPENSE_CENTER_ID,
						EXPENSE_ITEM_ID,
						AMORTIZATION_COUNT,
						LAST_INVENTORY_VALUE,
						LAST_INVENTORY_VALUE_2,
						AMORT_LAST_VALUE,
						ENTRY_DATE,
						INVENTORY_CATID,
						INVENTORY_DURATION,
						AMORTIZATION_TYPE,
						SUBSCRIPTION_ID,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						INVENTORY_TYPE,
						INVENTORY_DURATION_IFRS,
						ACTIVITY_TYPE_ID
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.invent_no#i#')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.invent_name#i#')#">,
						#evaluate("attributes.quantity#i#")#,
						#evaluate("attributes.row_total#i#")#,
						<cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.row_total#i#")/currency_multiplier)#<cfelse>NULL</cfif>,
						#evaluate("attributes.amortization_rate#i#")#,
						#evaluate("attributes.amortization_method#i#")#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.account_id#i#')#">,
						<cfif len(evaluate("attributes.debt_account_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.debt_account_id#i#')#"><cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.debt_account_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.claim_account_id#i#')#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.period#i#')#">,
						<cfif isdefined("attributes.expense_center_name#i#") and len(evaluate("attributes.expense_center_name#i#")) and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.expense_item_name#i#") and len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
						0,
						#evaluate("attributes.row_total#i#")#,
						<cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.row_total#i#")/currency_multiplier)#<cfelse>NULL</cfif>,
						#evaluate("attributes.row_total#i#")#,
						#attributes.start_date#,
						<cfif isdefined('attributes.inventory_cat_id#i#') and len(evaluate("attributes.inventory_cat_id#i#")) and isdefined('attributes.inventory_cat#i#') and len(evaluate('attributes.inventory_cat#i#'))>#evaluate("attributes.inventory_cat_id#i#")#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.inventory_duration#i#') and len(evaluate("attributes.inventory_duration#i#"))>#evaluate("attributes.inventory_duration#i#")#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.amortization_type#i#') and len(evaluate("attributes.amortization_type#i#"))>#evaluate("attributes.amortization_type#i#")#<cfelse>NULL</cfif>,
						<cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
						#NOW()#,
						#SESSION.EP.USERID#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
						<cfif isdefined("inventory_type_info")>#inventory_type_info#<cfelse>3</cfif>,
						<cfif isdefined('attributes.ifrs_inventory_duration#i#') and len(evaluate("attributes.ifrs_inventory_duration#i#"))>#evaluate("attributes.ifrs_inventory_duration#i#")#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.activity_type#i#"))>#evaluate("attributes.activity_type#i#")#<cfelse>NULL</cfif>
					)
				</cfquery>
			<cfquery name="GET_INVENTORY_ID" datasource="#dsn2#">
				SELECT MAX(INVENTORY_ID) AS MAX_ID FROM #dsn3_alias#.INVENTORY
			</cfquery>
			<cfset invent_id_info = GET_INVENTORY_ID.MAX_ID>
		</cfif>
		<cfif len(evaluate("attributes.stock_id#i#"))>
			<cfquery name="GET_PRODUCT_INFO_" datasource="#dsn2#">
				SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS WHERE STOCK_ID = #evaluate("attributes.stock_id#i#")#
			</cfquery>
		<cfelse>
			<cfset GET_PRODUCT_INFO_.product_id = ''>
		</cfif>
		<cfquery name="ADD_INVENT_ROW" datasource="#dsn2#">
			INSERT INTO 
			#dsn3_alias#.INVENTORY_ROW
			(
				INVENTORY_ID,
				PERIOD_ID,
				ACTION_ID,
				PAPER_NO,
				PROCESS_TYPE,
				QUANTITY,
				STOCK_IN,
				SUBSCRIPTION_ID,
				ACTION_DATE,
				STOCK_ID,
				PRODUCT_ID
			)
			VALUES
			(
				#invent_id_info#,
				#session.ep.period_id#,
				#attributes.fis_id#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fis_no#">,
				#attributes.process_type#,
				#evaluate("attributes.quantity#i#")#,
				#evaluate("attributes.quantity#i#")#,
				<cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
				#attributes.start_date#,
				<cfif len(evaluate("attributes.stock_id#i#"))>#evaluate("attributes.stock_id#i#")#<cfelse>NULL</cfif>,
				<cfif len(GET_PRODUCT_INFO_.product_id)>#GET_PRODUCT_INFO_.product_id#<cfelse>NULL</cfif>
			)
		</cfquery>
		<!--- demirbasa ait history kaydi --->
		<cfset cmp = createObject("component","V16.inventory.cfc.inventory_history") />
        <cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>,
        	<cfset project_id_ = attributes.project_id>
        <cfelse>
        	<cfset project_id_ = ''>	
        </cfif>
		<cfset cmp.add_inventory_history(
				inventory_id : invent_id_info,
				action_id : attributes.fis_id,
				action_type : attributes.process_type,
				action_date : attributes.start_date,
				project_id : project_id_,
				expense_center_id : evaluate("attributes.expense_center_id#i#"),
				expense_item_id : evaluate("attributes.expense_item_id#i#"),
				claim_account_code : evaluate("attributes.claim_account_id#i#"),
				debt_account_code : evaluate("attributes.debt_account_id#i#"),
				account_code : evaluate("attributes.account_id#i#"),
				inventory_duration : evaluate("attributes.inventory_duration#i#"),
				amortization_rate : evaluate("attributes.amortization_rate#i#"),
				ifrs_inventory_duration : evaluate("attributes.ifrs_inventory_duration#i#"),
				activity_id : evaluate("attributes.activity_type#i#")
		) />
		<cfquery name="ADD_STOCK_FIS_ROW" datasource="#DSN2#">
			INSERT INTO 
				STOCK_FIS_ROW
					(
						FIS_ID,
						FIS_NUMBER,
						STOCK_ID,
						AMOUNT,
						UNIT,
						UNIT_ID,							
						PRICE,
						PRICE_OTHER,
						TAX,
						DISCOUNT1,
						DISCOUNT2,
						DISCOUNT3,
						DISCOUNT4,
						DISCOUNT5,
						TOTAL,
						TOTAL_TAX, 
						NET_TOTAL,
						OTHER_MONEY,
						INVENTORY_ID,
						WRK_ROW_ID,
						EXPENSE_CENTER_ID,
						EXPENSE_ITEM_ID
					)
			VALUES
					(
						#attributes.fis_id#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FIS_NO#">,
						<cfif isdefined('attributes.stock_id#i#') and len(evaluate('attributes.stock_id#i#'))>#evaluate("attributes.stock_id#i#")#<cfelse>NULL</cfif>,
						#evaluate("attributes.quantity#i#")#,
						<cfif isdefined('attributes.stock_unit#i#') and len(evaluate('attributes.stock_unit#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.stock_unit#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.stock_unit_id#i#') and len(evaluate('attributes.stock_unit_id#i#'))>#evaluate("attributes.stock_unit_id#i#")#<cfelse>NULL</cfif>,							
						#evaluate("attributes.row_total#i#")#,
						#(evaluate("attributes.row_other_total#i#")/evaluate("attributes.quantity#i#"))#,
						#evaluate("attributes.tax_rate#i#")#,
						0,
						0,
						0,
						0,
						0,
						#evaluate("attributes.row_total#i#") * evaluate("attributes.quantity#i#")#,
						 #evaluate("attributes.kdv_total#i#")#, 
						#(evaluate("attributes.row_total#i#") * evaluate("attributes.quantity#i#")) + evaluate("attributes.kdv_total#i#")#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(evaluate('attributes.money_id#i#'),1,',')#">,
						#invent_id_info#,
						<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.expense_center_name#i#") and len(evaluate("attributes.expense_center_name#i#")) and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>
					)
		</cfquery>
		<cfif is_stock_act>
			<cfquery name="GET_PRODUCT_INFO" datasource="#dsn2#">
				SELECT PRODUCT_ID FROM #dsn3_alias#.STOCKS WHERE STOCK_ID = #evaluate("attributes.stock_id#i#")#
			</cfquery>
			<cfquery name="GET_UNIT" datasource="#dsn2#">
				SELECT 
					ADD_UNIT,
					MULTIPLIER,
					MAIN_UNIT,
					PRODUCT_UNIT_ID
				FROM
					#dsn3_alias#.PRODUCT_UNIT
				WHERE 
					PRODUCT_ID = #GET_PRODUCT_INFO.PRODUCT_ID# AND
					ADD_UNIT = '#wrk_eval("attributes.stock_unit#i#")#'
			</cfquery>
			<cfif get_unit.recordcount and len(get_unit.multiplier)>
				<cfset multi = get_unit.multiplier*evaluate("attributes.quantity#i#")>
			<cfelse>
				<cfset multi = evaluate("attributes.quantity#i#")>
			</cfif>
			<cfquery name="ADD_STOCK_ROW" datasource="#dsn2#">
				INSERT INTO 
						STOCKS_ROW
						(
							UPD_ID,
							PRODUCT_ID,
							STOCK_ID,
							PROCESS_TYPE,
							STOCK_OUT,
							STORE,
							STORE_LOCATION,
							PROCESS_DATE
						)
						VALUES
						(
							#attributes.fis_id#,
							#GET_PRODUCT_INFO.PRODUCT_ID#,
							#evaluate("attributes.stock_id#i#")#,
							#attributes.process_type#,
							#MULTI#,
							#attributes.department_id_2#,
							#attributes.location_id_2#,				
							#attributes.start_date#
						)
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
<cfset GET_S_ID.max_id = attributes.fis_id>
<cfinclude template="add_invent_stock_fis_1.cfm">
	
<!--- money kayıtları --->
<cfloop from="1" to="#attributes.kur_say#" index="i">
	<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
		INSERT INTO STOCK_FIS_MONEY 
		(
			ACTION_ID,
			MONEY_TYPE,
			RATE2,
			RATE1,
			IS_SELECTED
		)
		VALUES
		(
			#attributes.fis_id#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.hidden_rd_money_#i#')#">,
			#evaluate("attributes.txt_rate2_#i#")#,
			#evaluate("attributes.txt_rate1_#i#")#,
			<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
		)
	</cfquery>
</cfloop>
<cfif len(get_process_type.action_file_name)><!--- secilen islem kategorisine bir action file eklenmisse --->
	<cf_workcube_process_cat 
		process_cat="#form.process_cat#"
		action_id = #attributes.fis_id#
		is_action_file = 1
		action_file_name='#get_process_type.action_file_name#'
		action_db_type = '#dsn2#'
		is_template_action_file='#get_process_type.action_file_from_template#'>
</cfif>
