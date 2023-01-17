<cfsetting showdebugoutput="NO">
<cfquery name="delete_stk_strategy" datasource="#dsn3#">
	DELETE FROM	STOCK_STRATEGY WHERE STOCK_ID=#attributes.stock_id# AND DEPARTMENT_ID IS NOT NULL
</cfquery>
<cfquery name="delete_stk_strategy_reserved" datasource="#dsn3#">
	DELETE FROM	ORDER_ROW_RESERVED WHERE STOCK_ID=#attributes.stock_id# AND DEPARTMENT_ID IS NOT NULL AND STOCK_STRATEGY_ID IS NOT NULL
</cfquery>
<cfloop  from="1" to="#attributes.record_num#" index="i">
	<cfif isdefined('add_strategy#i#') eq 1 >
		<cfquery name="ADD_STK_STRATEGY" datasource="#dsn3#">
			INSERT INTO 
				STOCK_STRATEGY 
				(
					PRODUCT_ID,
					STOCK_ID,
					DEPARTMENT_ID,
					MINIMUM_STOCK,
					MAXIMUM_STOCK,
					MINIMUM_ORDER_STOCK_VALUE,
					PROVISION_TIME,
					REPEAT_STOCK_VALUE,
					IS_LIVE_ORDER,
					STRATEGY_TYPE,
					STRATEGY_ORDER_TYPE,
					MINIMUM_ORDER_UNIT_ID,
					BLOCK_STOCK_VALUE,
					STOCK_ACTION_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES 
				(
					#attributes.product_id#,
					#attributes.stock_id#,
					<cfif isdefined('attributes.department_id#i#') and len(evaluate('attributes.department_id#i#'))>#evaluate('attributes.department_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.minimum_stock#i#') and len(evaluate('attributes.minimum_stock#i#'))>#evaluate('attributes.minimum_stock#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.maximum_stock#i#') and len(evaluate('attributes.maximum_stock#i#'))>#evaluate('attributes.maximum_stock#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.minimum_order_stock_value#i#') and len(evaluate('attributes.minimum_order_stock_value#i#'))>#evaluate('attributes.minimum_order_stock_value#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.provision_time#i#') and len(evaluate('attributes.provision_time#i#'))>#evaluate('attributes.provision_time#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.repeat_stock_value#i#')and len(evaluate('attributes.repeat_stock_value#i#'))>#evaluate('attributes.repeat_stock_value#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.is_live_order#i#') and len(evaluate('attributes.is_live_order#i#'))>#evaluate('attributes.is_live_order#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.strategy_type#i#') and len(evaluate('attributes.strategy_type#i#'))>#evaluate('attributes.strategy_type#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.strategy_order_type#i#') and len(evaluate('attributes.strategy_order_type#i#'))>#evaluate('attributes.strategy_order_type#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.minimum_order_unit_id#i#') and len(evaluate('attributes.minimum_order_unit_id#i#'))>#evaluate('attributes.minimum_order_unit_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.block_stock_value#i#") and len(evaluate("attributes.block_stock_value#i#"))>#evaluate("attributes.block_stock_value#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.saleable_stock_action_id#i#") and len(evaluate("attributes.saleable_stock_action_id#i#"))>#evaluate("attributes.saleable_stock_action_id#i#")#<cfelse>NULL</cfif>,
					#now()#,
					#session.ep.userid#,
					'#CGI.REMOTE_ADDR#'
				)
		</cfquery>
		<cfif isdefined("attributes.block_stock_value#i#") and len(evaluate("attributes.block_stock_value#i#"))>
			<cfquery name="GET_MAX_STRATEGY" datasource="#DSN3#">
				SELECT MAX(STOCK_STRATEGY_ID) MAX_ID FROM STOCK_STRATEGY WHERE STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
			</cfquery>
			<cfquery name="ADD_STK_STRATEGY" datasource="#DSN3#">
				INSERT INTO
					ORDER_ROW_RESERVED 
				(
					STOCK_STRATEGY_ID,
					STOCK_ID,
					PRODUCT_ID,
					RESERVE_STOCK_IN,
					RESERVE_STOCK_OUT,
					STOCK_IN,
					STOCK_OUT,
					DEPARTMENT_ID
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STRATEGY.MAX_ID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">,
					0,
					#evaluate("attributes.block_stock_value#i#")#,
					0,
					0,
					<cfif isdefined('attributes.department_id#i#') and len(evaluate('attributes.department_id#i#'))>#evaluate('attributes.department_id#i#')#<cfelse>NULL</cfif>
				)
			</cfquery>
		</cfif>
	</cfif>
</cfloop>
<script>
	location.href = document.referrer;
</script>