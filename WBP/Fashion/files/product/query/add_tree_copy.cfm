<cfquery name="add_spec_main" datasource="#dsn3#" result="MAX_ID">
	INSERT INTO [SPECT_MAIN]
		(
		[SPECT_MAIN_NAME]
		,[SPECT_TYPE]
		,[DETAIL]
		,[PRODUCT_ID]
		,[STOCK_ID]
		,[IS_TREE]
		,[SPECT_STATUS]
		,[RECORD_EMP]
		,[RECORD_IP]
		,[RECORD_DATE]
		,[FUSEACTION]
		,[IS_LIMITED_STOCK]
		,[WRK_ID]
		)
		VALUES
		(
		'#get_stock.product_name#'
		,1
		,NULL
		,#get_stock.product_id#
		,#get_stock.stock_id#
		,1
		,1
		,#session.ep.userid#
		,'127.0.0.1'
		,#now()#
		,'#attributes.fuseaction#'
		,0
		,NULL
		)
</cfquery>
<cfset new_spec_main_id=MAX_ID.IDENTITYCOL>
<cfset row_count=Evaluate("attributes.row_count_#j#_#stock_id#")>
<cfloop from="1" to="#row_count#" index="i">
<cfif isdefined("attributes.related_id_#j#_#i#") and len(evaluate("attributes.related_id_#j#_#i#"))>
	<cfset row_status = Evaluate("attributes.row_status_#j#_#i#")>
	<cfif row_status neq "1"><cfcontinue></cfif>
	<cfset amount=filterNum(Evaluate("attributes.amount_#j#_#i#"))>
	<cfset related_id=Evaluate("attributes.related_id_#j#_#i#")>
	<cfset product_id=Evaluate("attributes.product_id_#j#_#i#")>
	<cfset product_name=Evaluate("attributes.product_name_#j#_#i#")>
	<cfset is_tree=Evaluate("attributes.is_tree_#j#_#i#")>
	<cfset unit_id=Evaluate("attributes.unit_id_#j#_#i#")>
	<cfset is_configure=Evaluate("attributes.is_configure_#j#_#i#")>
	<cfset is_sevk=Evaluate("attributes.is_sevk_#j#_#i#")>
	<cfset spect_main_id=Evaluate("attributes.spect_main_id_#j#_#i#")>
	<cfset line_number=Evaluate("attributes.line_number_#j#_#i#")>
	<cfset operation_type_id=Evaluate("attributes.operation_type_id_#j#_#i#")>
	<cfset is_phantom=Evaluate("attributes.is_phantom_#j#_#i#")>
	<cfset process_stage=Evaluate("attributes.process_stage_#j#_#i#")>
	<cfquery name="add_tree" datasource="#dsn3#" result="TREE_MAX_ID">
		INSERT INTO PRODUCT_TREE
			(
				RELATED_ID
				,PRODUCT_ID
				,IS_TREE
				,AMOUNT
				,UNIT_ID
				,STOCK_ID
				,IS_CONFIGURE
				,IS_SEVK
				,SPECT_MAIN_ID
				,LINE_NUMBER
				,OPERATION_TYPE_ID
				,IS_PHANTOM
				,PROCESS_STAGE
				,RECORD_EMP
				,RECORD_DATE
			)
		values (
				<cfif len(related_id)>#related_id#<cfelse>NULL</cfif>,
				<cfif len(product_id)>#product_id#<cfelse>NULL</cfif>,
				<cfif len(is_tree)>#is_tree#<cfelse>NULL</cfif>,
				<cfif len(amount)>#amount#<cfelse>NULL</cfif>,
				<cfif len(unit_id)>#unit_id#<cfelse>NULL</cfif>,
				<cfif len(stock_id)>#stock_id#<cfelse>NULL</cfif>,
				<cfif len(is_configure)>#is_configure#<cfelse>NULL</cfif>,
				<cfif len(is_sevk)>#is_sevk#<cfelse>NULL</cfif>,
				<cfif len(spect_main_id)>#spect_main_id#<cfelse>NULL</cfif>,
				<cfif len(line_number)>#line_number#<cfelse>0</cfif>,
				<cfif len(operation_type_id)>#operation_type_id#<cfelse>NULL</cfif>,
				<cfif len(is_phantom)>#is_phantom#<cfelse>NULL</cfif>,
				<cfif len(process_stage)>#process_stage#<cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#
			)
	</cfquery>
	<cfquery name="ADD_ROW" datasource="#dsn3#">
		INSERT INTO SPECT_MAIN_ROW
		(
			SPECT_MAIN_ID,
			PRODUCT_ID,
			STOCK_ID,
			AMOUNT,
			PRODUCT_NAME,
			IS_PROPERTY,
			IS_CONFIGURE,
			IS_SEVK,
			PROPERTY_ID,
			VARIATION_ID,
			TOTAL_MIN,
			TOTAL_MAX,
			TOLERANCE,
			PRODUCT_SPACE,
			PRODUCT_DISPLAY,
			PRODUCT_RATE,
			PRODUCT_LIST_PRICE,
			CALCULATE_TYPE,
			RELATED_MAIN_SPECT_ID,
			RELATED_MAIN_SPECT_NAME,
			LINE_NUMBER,
			CONFIGURATOR_VARIATION_ID,
			DIMENSION,
			RELATED_TREE_ID,
			OPERATION_TYPE_ID,
			QUESTION_ID
		)
		VALUES
		(
			#new_spec_main_id#,
			<cfif len(product_id)>#product_id#<cfelse>NULL</cfif>,
			<cfif len(related_id)>#related_id#<cfelse>NULL</cfif>,
			<cfif len(amount)>#amount#<cfelse>NULL</cfif>,
			<cfif len(product_name)>'#product_name#'<cfelse>NULL</cfif>,
			0,
			0,
			0,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			<cfif len(line_number)>#line_number#<cfelse>0</cfif>,
			NULL,
			NULL,
			#TREE_MAX_ID.IDENTITYCOL#,
			NULL,
			NULL											
		)
	</cfquery>	
</cfif>
</cfloop>
