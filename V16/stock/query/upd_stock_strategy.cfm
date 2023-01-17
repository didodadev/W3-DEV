<cfif isdefined('attributes.row_count') and len(attributes.row_count)>
	<cfquery name="delete_stk_strategy" datasource="#dsn3#">
		DELETE FROM	STOCK_STRATEGY WHERE PRODUCT_ID = #attributes.product_id# AND DEPARTMENT_ID IS NULL
	</cfquery>
	<cfquery name="delete_stk_strategy_reserved" datasource="#dsn3#">
		DELETE FROM	ORDER_ROW_RESERVED WHERE PRODUCT_ID = #attributes.product_id# AND DEPARTMENT_ID IS NULL AND STOCK_STRATEGY_ID IS NOT NULL
	</cfquery>
	<cfloop  from="1" to="#attributes.row_count#" index="row_i">
		<cfscript>
			if(evaluate('attributes.maximum_stock_#row_i#') neq '')
				'attributes.maximum_stock_#row_i#' = filterNum(evaluate('attributes.maximum_stock_#row_i#'));
			if(evaluate('attributes.rpt_st_val_#row_i#') neq '')
				'attributes.rpt_st_val_#row_i#' = filterNum(evaluate('attributes.rpt_st_val_#row_i#'));
			if(evaluate('attributes.minimum_stock_#row_i#') neq '')
				'attributes.minimum_stock_#row_i#' = filterNum(evaluate('attributes.minimum_stock_#row_i#'));
			if(evaluate('attributes.min_ord_st_val_#row_i#') neq '')
				'attributes.min_ord_st_val_#row_i#' = filterNum(evaluate('attributes.min_ord_st_val_#row_i#'));
			if(evaluate('attributes.max_ord_st_val_#row_i#') neq '')
				'attributes.max_ord_st_val_#row_i#' = filterNum(evaluate('attributes.max_ord_st_val_#row_i#'));
			if(evaluate('attributes.prov_tm_#row_i#') neq '')
				'attributes.prov_tm_#row_i#' = filterNum(evaluate('attributes.prov_tm_#row_i#'));
			if(evaluate('attributes.blk_st_val_#row_i#') neq '')
				'attributes.blk_st_val_#row_i#' = filterNum(evaluate('attributes.blk_st_val_#row_i#'));
		</cfscript>
		<cfquery name="ADD_STK_STRATEGY" datasource="#dsn3#">
			INSERT INTO STOCK_STRATEGY 
			(
				PRODUCT_ID,
				STOCK_ID,
				MAXIMUM_STOCK,
				MINIMUM_STOCK,
				PROVISION_TIME,
				REPEAT_STOCK_VALUE,
				MINIMUM_ORDER_STOCK_VALUE,
				MINIMUM_ORDER_UNIT_ID,
				MAXIMUM_ORDER_STOCK_VALUE,
				MAXIMUM_ORDER_UNIT_ID,
				IS_LIVE_ORDER,
				STRATEGY_TYPE,
				STRATEGY_ORDER_TYPE,
				BLOCK_STOCK_VALUE,
				STOCK_ACTION_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#attributes.PRODUCT_ID#,
				#evaluate("row_stock_id_#row_i#")#,
				<cfif isdefined("attributes.maximum_stock_#row_i#") and len(evaluate("attributes.maximum_stock_#row_i#"))>#evaluate("attributes.maximum_stock_#row_i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.minimum_stock_#row_i#") and len(evaluate("attributes.minimum_stock_#row_i#"))>#evaluate("attributes.minimum_stock_#row_i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.prov_tm_#row_i#") and len(evaluate("attributes.prov_tm_#row_i#"))>#evaluate("attributes.prov_tm_#row_i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.rpt_st_val_#row_i#") and len(evaluate("attributes.rpt_st_val_#row_i#"))>#evaluate("attributes.rpt_st_val_#row_i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.min_ord_st_val_#row_i#") and len(evaluate("attributes.min_ord_st_val_#row_i#"))>#evaluate("attributes.min_ord_st_val_#row_i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.min_ord_unt_id_#row_i#") and len(evaluate("attributes.min_ord_unt_id_#row_i#"))>#evaluate("attributes.min_ord_unt_id_#row_i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.max_ord_st_val_#row_i#") and len(evaluate("attributes.max_ord_st_val_#row_i#"))>#evaluate("attributes.max_ord_st_val_#row_i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.max_ord_unt_id_#row_i#") and len(evaluate("attributes.max_ord_unt_id_#row_i#"))>#evaluate("attributes.max_ord_unt_id_#row_i#")#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.is_live_order_#row_i#") and len(evaluate("attributes.is_live_order_#row_i#"))>#evaluate("attributes.is_live_order_#row_i#")#<cfelse>0</cfif>,
				<cfif isdefined("attributes.strategy_type_#row_i#") and len(evaluate("attributes.strategy_type_#row_i#"))>#evaluate("strategy_type_#row_i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.strgy_ord_typ_#row_i#") and len(evaluate("attributes.strgy_ord_typ_#row_i#"))>#evaluate("attributes.strgy_ord_typ_#row_i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.blk_st_val_#row_i#") and len(evaluate("attributes.blk_st_val_#row_i#"))>#evaluate("attributes.blk_st_val_#row_i#")#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.salable_st_act_id_#row_i#") and len(evaluate("attributes.salable_st_act_id_#row_i#"))>#evaluate("attributes.salable_st_act_id_#row_i#")#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#CGI.REMOTE_ADDR#'        
			)
		</cfquery>
		<cfif isdefined("attributes.blk_st_val_#row_i#") and len(evaluate("attributes.blk_st_val_#row_i#"))>
			<cfquery name="GET_MAX_STRATEGY" datasource="#DSN3#">
				SELECT MAX(STOCK_STRATEGY_ID) MAX_ID FROM STOCK_STRATEGY WHERE STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('row_stock_id_#row_i#')#">
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
					STOCK_OUT
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX_STRATEGY.MAX_ID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('row_stock_id_#row_i#')#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PRODUCT_ID#">,
					0,
					#evaluate("attributes.blk_st_val_#row_i#")#,
					0,
					0
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
