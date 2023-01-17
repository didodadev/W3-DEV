<cfquery name="ADD_STOCK_FIS" datasource="#DSN2#">
	INSERT INTO
		STOCK_FIS
	(
		FIS_TYPE,
		PROCESS_CAT,
		<cfif isDefined("attributes.department_id_2") and len(attributes.department_id_2)>
			DEPARTMENT_OUT,
			LOCATION_OUT,
		</cfif>
		<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
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
		RELATED_SHIP_ID,
		IS_RELATED_PROJECT,
		RELATED_INVOICE_ID
	)
	VALUES
	(
		#attributes.process_type#,
		#attributes.PROCESS_CAT#,
		<cfif isDefined("attributes.department_id_2") and len(attributes.department_id_2)>
			#attributes.department_id_2#,
			#attributes.location_id_2#,	
		</cfif>
		<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
			#attributes.department_id#,
			#attributes.location_id#,
		</cfif>
		'#attributes.FIS_NO#',
		#DELIVER_GET_ID#,
		#attributes.start_date#,
		<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
		#now()#,
		#session.ep.userid#,
		'#cgi.remote_addr#',
		<cfif isdefined('attributes.detail') and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		<cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
		<cfif isDefined("related_ship_id") and len(related_ship_id)>#related_ship_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_related_project")>1<cfelse>0</cfif>,
		<cfif isDefined("related_invoice_id") and len(related_invoice_id)>#related_invoice_id#<cfelse>NULL</cfif>
	)
</cfquery>
<cfquery name="GET_S_ID" datasource="#DSN2#">
	SELECT MAX(FIS_ID) MAX_ID FROM STOCK_FIS
</cfquery>
<cfloop from="1" to="#attributes.record_num#" index="i">
  <cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
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
				CLAIM_ACCOUNT_ID,
				DEBT_ACCOUNT_ID,
				ACCOUNT_PERIOD,
				EXPENSE_CENTER_ID,
				EXPENSE_ITEM_ID,
				AMORTIZATION_COUNT,
				AMORT_LAST_VALUE,
				LAST_INVENTORY_VALUE,
				LAST_INVENTORY_VALUE_2,
				ENTRY_DATE,
				INVENTORY_CATID,
				INVENTORY_DURATION,
				AMORTIZATION_TYPE,
				SUBSCRIPTION_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				INVENTORY_TYPE,
				PROJECT_ID,
				INVENTORY_DURATION_IFRS,
				ACTIVITY_TYPE_ID
			)
			VALUES
			(
				'#wrk_eval("attributes.invent_no#i#")#',
				'#wrk_eval("attributes.invent_name#i#")#',
				#evaluate("attributes.quantity#i#")#,
				#evaluate("attributes.row_total#i#")#,
				<cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.row_total#i#")/currency_multiplier)#<cfelse>NULL</cfif>,
				#evaluate("attributes.amortization_rate#i#")#,
				#evaluate("attributes.amortization_method#i#")#,
				'#wrk_eval("attributes.account_id#i#")#',
				'#wrk_eval("attributes.claim_account_id#i#")#',
				'#wrk_eval("attributes.debt_account_id#i#")#',
				'#wrk_eval("attributes.period#i#")#',
				<cfif isdefined("attributes.expense_center_name#i#") and len(evaluate("attributes.expense_center_name#i#")) and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
				0,
				#evaluate("attributes.row_total#i#")#,
				#evaluate("attributes.row_total#i#")#,
				<cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.row_total#i#")/currency_multiplier)#<cfelse>NULL</cfif>,
				#attributes.start_date#,
				<cfif isdefined('attributes.inventory_cat_id#i#') and len(evaluate("attributes.inventory_cat_id#i#")) and isdefined('attributes.inventory_cat#i#') and len(evaluate('attributes.inventory_cat#i#'))>#evaluate("attributes.inventory_cat_id#i#")#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.inventory_duration#i#') and len(evaluate("attributes.inventory_duration#i#"))>#evaluate("attributes.inventory_duration#i#")#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.amortization_type#i#') and len(evaluate("attributes.amortization_type#i#"))>#evaluate("attributes.amortization_type#i#")#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
				#NOW()#,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#',
				<cfif isdefined("inventory_type_info")>#inventory_type_info#<cfelse>3</cfif>,
				<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ifrs_inventory_duration#i#') and len(evaluate("attributes.ifrs_inventory_duration#i#"))>#evaluate("attributes.ifrs_inventory_duration#i#")#<cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.activity_type#i#"))>#evaluate("attributes.activity_type#i#")#<cfelse>NULL</cfif>
			)
		</cfquery>
		<cfquery name="GET_INVENTORY_ID" datasource="#dsn2#">
			SELECT MAX(INVENTORY_ID) AS MAX_ID FROM #dsn3_alias#.INVENTORY INVENTORY
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
				STOCK_IN,
				SUBSCRIPTION_ID,
				ACTION_DATE,
				STOCK_ID,
				PRODUCT_ID
			)
			VALUES
			(
				#GET_INVENTORY_ID.MAX_ID#,
				#session.ep.period_id#,
				#GET_S_ID.max_id#,
				'#attributes.fis_no#',
				#attributes.process_type#,
				#evaluate("attributes.quantity#i#")#,
				#evaluate("attributes.quantity#i#")#,
				<cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
				#attributes.start_date#,
				<cfif isdefined("attributes.stock_id#i#") and len(evaluate("attributes.stock_id#i#"))>#evaluate("attributes.stock_id#i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.product_id#i#") and len(evaluate("attributes.product_id#i#"))>#evaluate("attributes.product_id#i#")#<cfelse>NULL</cfif>
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
				inventory_id : get_inventory_id.max_id,
				action_id : GET_S_ID.max_id,
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
					<cfif isdefined("attributes.stock_id#i#") and len(evaluate("attributes.stock_id#i#"))>
						STOCK_ID,
						UNIT,
						UNIT_ID,
					</cfif>
					AMOUNT,							
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
					WRK_ROW_RELATION_ID,
					EXPENSE_CENTER_ID,
					EXPENSE_ITEM_ID
				)
			VALUES
				(
					#GET_S_ID.MAX_ID#,
					'#attributes.FIS_NO#',	
					<cfif isdefined("attributes.stock_id#i#") and len(evaluate("attributes.stock_id#i#"))>						
						#evaluate("attributes.stock_id#i#")#,
						'#wrk_eval("attributes.stock_unit#i#")#',
						#evaluate("attributes.stock_unit_id#i#")#,	
					</cfif>	
					#evaluate("attributes.quantity#i#")#,					
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
					'#listgetat(evaluate("attributes.money_id#i#"),1,',')#',
					'#GET_INVENTORY_ID.MAX_ID#',
					<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#wrk_eval('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.expense_center_name#i#") and len(evaluate("attributes.expense_center_name#i#")) and len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>
				)
		</cfquery>
		<cfif is_stock_act and isdefined("attributes.stock_id#i#") and len(evaluate("attributes.stock_id#i#"))>
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
						STOCK_OUT,
						STORE,
						STORE_LOCATION,
						PROCESS_DATE
					)
					VALUES
					(
						#GET_S_ID.MAX_ID#,
						#evaluate("attributes.product_id#i#")#,
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
<!--- muhasebe kayıtları --->
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
			#GET_S_ID.MAX_ID#,
			'#wrk_eval("attributes.hidden_rd_money_#i#")#',
			#evaluate("attributes.txt_rate2_#i#")#,
			#evaluate("attributes.txt_rate1_#i#")#,
			<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
		)
	</cfquery>
</cfloop>
<cfif len(get_process_type.action_file_name)> <!--- secilen islem kategorisine bir action file eklenmisse --->
	<cf_workcube_process_cat 
		process_cat="#form.process_cat#"
		action_id = #GET_S_ID.MAX_ID#
		is_action_file = 1
		action_file_name='#get_process_type.action_file_name#'
		action_db_type = '#dsn2#'
		is_template_action_file = '#get_process_type.action_file_from_template#'>
</cfif>
