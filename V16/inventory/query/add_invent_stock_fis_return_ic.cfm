<cfquery name="ADD_STOCK_FIS" datasource="#DSN2#" result="MAX_ID">
	INSERT INTO
		STOCK_FIS
	(
		FIS_TYPE,
		PROCESS_CAT,
		<cfif isDefined("attributes.department_name_2") and len(attributes.department_name_2) and isDefined("attributes.department_id_2") and len(attributes.department_id_2)>
            DEPARTMENT_OUT,
            LOCATION_OUT,
		</cfif>
		<cfif isDefined("attributes.department_name") and len(attributes.department_name) and isDefined("attributes.department_id") and len(attributes.department_id)>
            DEPARTMENT_IN,
            LOCATION_IN,
		</cfif>
		FIS_NUMBER,
		EMPLOYEE_ID,
		FIS_DATE,
		REF_NO,
		PROJECT_ID,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		FIS_DETAIL,
		SUBSCRIPTION_ID,
		RELATED_SHIP_ID
	)
	VALUES
	(
		#attributes.process_type#,
		#attributes.PROCESS_CAT#,
		<cfif isDefined("attributes.department_name_2") and len(attributes.department_name_2) and isDefined("attributes.department_id_2") and len(attributes.department_id_2)>
            #attributes.department_id_2#,
            #attributes.location_id_2#,	
		</cfif>
		<cfif isDefined("attributes.department_name") and len(attributes.department_name) and isDefined("attributes.department_id") and len(attributes.department_id)>
            #attributes.department_id#,
            #attributes.location_id#,
		</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FIS_NO#">,
		#DELIVER_GET_ID#,
		#attributes.start_date#,
		<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfif isdefined('attributes.detail') and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
		<cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
		<cfif isDefined("related_ship_id") and len(related_ship_id)>#related_ship_id#<cfelse>NULL</cfif>
	)
</cfquery>
<cfif len(attributes.department_id) and len(attributes.location_id)>
	<cfquery name="GET_LOCATION_TYPE" datasource="#dsn2#">
		SELECT LOCATION_TYPE,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID=#attributes.department_id# AND LOCATION_ID=#attributes.location_id#
	</cfquery>
	<cfset location_type=GET_LOCATION_TYPE.LOCATION_TYPE>
	<cfset is_scrap=GET_LOCATION_TYPE.IS_SCRAP>
<cfelse>
	<cfset location_type = "">
	<cfset is_scrap = "">
</cfif>
<cfquery name="GET_S_ID" datasource="#DSN2#">
	SELECT MAX(FIS_ID) MAX_ID FROM STOCK_FIS
</cfquery>
<cfloop from="1" to="#attributes.record_num#" index="i">
  <cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
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
					WRK_ROW_RELATION_ID
				)
			VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FIS_NO#">,							
					<cfif len(evaluate("attributes.stock_id#i#"))>#evaluate("attributes.stock_id#i#")#<cfelse>NULL</cfif>,
					#evaluate("attributes.quantity#i#")#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.stock_unit#i#')#">,
					<cfif len(evaluate("attributes.stock_unit_id#i#"))>#evaluate("attributes.stock_unit_id#i#")#<cfelse>NULL</cfif>,							
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
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.invent_id#i#')#">,
					<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>
				)
		</cfquery>
		<cfquery name="upd_inventory" datasource="#dsn2#">
			UPDATE
				#dsn3_alias#.INVENTORY
			SET
				SALE_DIFF_ACCOUNT_ID = <cfif isdefined('attributes.budget_account_id#i#') and len(evaluate("attributes.budget_account_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.budget_account_id#i#')#"><cfelse>NULL</cfif>,
				AMORT_DIFF_ACCOUNT_ID = <cfif isdefined('attributes.amort_account_id#i#') and len(evaluate("attributes.amort_account_id#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.amort_account_id#i#')#"><cfelse>NULL</cfif>,
				SALE_EXPENSE_CENTER_ID = <cfif isdefined('attributes.expense_center_name#i#') and len(evaluate("attributes.expense_center_name#i#")) and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
				SALE_EXPENSE_ITEM_ID = <cfif isdefined('attributes.budget_item_name#i#') and len(evaluate("attributes.budget_item_name#i#")) and len(evaluate("attributes.budget_item_id#i#"))>#evaluate("attributes.budget_item_id#i#")#<cfelse>NULL</cfif>
			WHERE
				INVENTORY_ID = #evaluate("attributes.invent_id#i#")#
		</cfquery>
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
				STOCK_OUT,
				SUBSCRIPTION_ID,
				ACTION_DATE,
				STOCK_ID,
				PRODUCT_ID
			)
			VALUES
			(
				#evaluate("attributes.invent_id#i#")#,
				#session.ep.period_id#,
				#MAX_ID.IDENTITYCOL#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FIS_NO#">,
				#attributes.process_type#,
				#evaluate("attributes.quantity#i#")#,
				#evaluate("attributes.quantity#i#")#,
				<cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
				#attributes.start_date#,
				<cfif len(evaluate("attributes.stock_id#i#"))>#evaluate("attributes.stock_id#i#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.product_id#i#"))>#evaluate("attributes.product_id#i#")#<cfelse>NULL</cfif>
			)
		</cfquery>
		<cfif is_stock_act>
			<cfquery name="GET_UNIT" datasource="#dsn2#">
				SELECT 
					ADD_UNIT,
					MULTIPLIER,
					MAIN_UNIT,
					PRODUCT_UNIT_ID
				FROM
					#dsn3_alias#.PRODUCT_UNIT PRODUCT_UNIT
				WHERE 
					PRODUCT_ID = #evaluate("attributes.product_id#i#")# AND
					ADD_UNIT = '#evaluate("attributes.stock_unit#i#")#'
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
						STOCK_IN,
						STORE,
						STORE_LOCATION,
						PROCESS_DATE
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						#evaluate("attributes.product_id#i#")#,
						#evaluate("attributes.stock_id#i#")#,
						#attributes.process_type#,
						#MULTI#,
						#attributes.department_id#,
						#attributes.location_id#,				
						#attributes.start_date#
					)
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
<!--- muhasebe kayıtları --->
<cfinclude template="add_invent_stock_fis_return_1.cfm">

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
			#MAX_ID.IDENTITYCOL#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.hidden_rd_money_#i#')#">,
			#evaluate("attributes.txt_rate2_#i#")#,
			#evaluate("attributes.txt_rate1_#i#")#,
			<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
		)
	</cfquery>
</cfloop>
<cfif isdefined("get_process_type.action_file_name") and len(get_process_type.action_file_name) and not (isDefined("related_ship_id") and len(related_ship_id))> <!--- secilen islem kategorisine bir action file eklenmisse --->
    <cf_workcube_process_cat 
        process_cat="#form.process_cat#"
        action_id = #MAX_ID.IDENTITYCOL#
        is_action_file = 1
        action_file_name='#get_process_type.action_file_name#'
        action_db_type = '#dsn2#'
        is_template_action_file = '#get_process_type.action_file_from_template#'>
</cfif>

