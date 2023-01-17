<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_CARI,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_cat = form.PROCESS_CAT;
	process_type = get_process_type.PROCESS_TYPE;
</cfscript>
<cfif len(session.ep.money2)>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT 
    	    MONEY_ID,
            MONEY, 
            RATE1, 
            RATE2, 
            MONEY_STATUS, 
            PERIOD_ID, 
            COMPANY_ID, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP 
        FROM 
	        SETUP_MONEY 
        WHERE 
        	MONEY = '#session.ep.money2#'
	</cfquery>
	<cfset currency_multiplier = get_money.rate2/get_money.rate1>
<cfelse>
	<cfset currency_multiplier = ''>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
	   <cfloop from="1" to="#attributes.record_num#" index="i">
		 <cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
		 	<cf_date tarih='attributes.entry_date#i#'>
			<cfquery name="ADD_INVENT" datasource="#dsn2#" result="MAX_ID">
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
					LAST_INVENTORY_VALUE,
					LAST_INVENTORY_VALUE_2,
					AMORT_LAST_VALUE,
					ACCOUNT_ID,
					CLAIM_ACCOUNT_ID,
					DEBT_ACCOUNT_ID,
					ACCOUNT_PERIOD,
					EXPENSE_CENTER_ID,
					EXPENSE_ITEM_ID,
					ENTRY_DATE,
					INVENTORY_CATID,
					INVENTORY_DURATION,
					AMORTIZATION_TYPE,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					INVENTORY_TYPE,
                    PARTIAL_AMORTIZATION_VALUE
				)
				VALUES
				(
					'#wrk_eval("attributes.invent_no#i#")#',
					'#wrk_eval("attributes.invent_name#i#")#',
					#evaluate("attributes.quantity#i#")#,
					#evaluate("attributes.period_invent_value#i#")#,
					<cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.period_invent_value#i#")/currency_multiplier)#<cfelse>NULL</cfif>,
					#evaluate("attributes.amortization_rate#i#")#,
					#evaluate("attributes.amortization_method#i#")#,
					#evaluate("attributes.row_total#i#")#,
					<cfif len(currency_multiplier)>#wrk_round(evaluate("attributes.row_total#i#")/currency_multiplier)#<cfelse>NULL</cfif>,
					#evaluate("attributes.row_total#i#")#,
					'#wrk_eval("attributes.account_id#i#")#',
					'#wrk_eval("attributes.claim_account_id#i#")#',
					'#wrk_eval("attributes.debt_account_id#i#")#',
					#evaluate("attributes.period#i#")#,
					<cfif len(evaluate("attributes.expense_center_id#i#"))>#evaluate("attributes.expense_center_id#i#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.expense_item_name#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
					#evaluate("attributes.entry_date#i#")#,
					<cfif isdefined('attributes.inventory_cat_id#i#') and len(evaluate("attributes.inventory_cat_id#i#")) and isdefined('attributes.inventory_cat#i#') and len(evaluate('attributes.inventory_cat#i#'))>#evaluate("attributes.inventory_cat_id#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.inventory_duration#i#') and len(evaluate("attributes.inventory_duration#i#"))>#evaluate("attributes.inventory_duration#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.amortization_type#i#') and len(evaluate("attributes.amortization_type#i#"))>#evaluate("attributes.amortization_type#i#")#<cfelse>NULL</cfif>,
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					1,
                    <cfif len(attributes["partial_amort_value#i#"]) and attributes["partial_amort_value#i#"] gt 0>#wrk_round(attributes["partial_amort_value#i#"])#<cfelse>NULL</cfif>
				)
			</cfquery>
			<cfquery name="ADD_INVENT_ROW" datasource="#dsn2#">
				INSERT INTO 
					#dsn3_alias#.INVENTORY_ROW
				(
					INVENTORY_ID,
					PERIOD_ID,
					PROCESS_TYPE,
					QUANTITY,
					STOCK_IN,
					ACTION_DATE
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					#session.ep.period_id#,
					#process_type#,
					#evaluate("attributes.quantity#i#")#,
					#evaluate("attributes.quantity#i#")#,
					#evaluate("attributes.entry_date#i#")#
				)
			</cfquery>
			<!--- demirbasa ait history kaydi --->
			<cfset cmp = createObject("component","V16.inventory.cfc.inventory_history") />
			<cfset cmp.add_inventory_history(
					inventory_id : MAX_ID.IDENTITYCOL,
					action_type : process_type,
					action_date : evaluate("attributes.entry_date#i#"),
					expense_center_id : evaluate("attributes.expense_center_id#i#"),
					expense_item_id : evaluate("attributes.expense_item_id#i#"),
					claim_account_code : evaluate("attributes.claim_account_id#i#"),
					debt_account_code : evaluate("attributes.debt_account_id#i#"),
					account_code : evaluate("attributes.account_id#i#"),
					inventory_duration : evaluate("attributes.inventory_duration#i#"),
					amortization_rate : evaluate("attributes.amortization_rate#i#")
			) />
		  </cfif>
		</cfloop>
		<!---<cfif len(get_process_type.action_file_name)>---> <!--- secilen islem kategorisine bir action file eklenmisse --->
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #MAX_ID.IDENTITYCOL#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=invent.list_inventory'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		<!---</cfif>--->	
	</cftransaction>
</cflock>
<cfset attributes.actionId=MAX_ID.IDENTITYCOL />
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=invent.list_inventory</cfoutput>";
</script>
