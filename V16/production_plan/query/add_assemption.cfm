<cfquery name="get_all_period" datasource="#dsn#">
	SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfset is_record = 1>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfif len(attributes.stock_id_list)>
			<cfquery name="get_product_main" datasource="#dsn3#">
				SELECT
					STOCK_ID,
					PRODUCT_ID,
					PRODUCT_NAME,
					SUM(SALE_AMOUNT) AMOUNT
				FROM
				(
					SELECT
						S.STOCK_ID,
						S.PRODUCT_ID,
						S.PRODUCT_NAME,
						MS.SALE_AMOUNT
					FROM
						STOCKS S,
						MONTHLY_SALES_AMOUNT MS
					WHERE
						S.STOCK_ID = MS.STOCK_ID
						AND S.STOCK_ID IN(#attributes.stock_id_list#)
					UNION ALL
					SELECT
						S.STOCK_ID,
						S.PRODUCT_ID,
						S.PRODUCT_NAME,
						SR.STOCK_OUT SALE_AMOUNT
					FROM
						STOCKS S,
						#dsn2_alias#.STOCKS_ROW SR
					WHERE
						S.STOCK_ID = SR.STOCK_ID
						AND SR.PROCESS_TYPE = 71
						AND S.STOCK_ID IN(#attributes.stock_id_list#)
					UNION ALL
					SELECT
						S.STOCK_ID,
						S.PRODUCT_ID,
						S.PRODUCT_NAME,
						-1*SR.STOCK_IN SALE_AMOUNT
					FROM
						STOCKS S,
						#dsn2_alias#.STOCKS_ROW SR
					WHERE
						S.STOCK_ID = SR.STOCK_ID
						AND SR.PROCESS_TYPE = 74
						AND S.STOCK_ID IN(#attributes.stock_id_list#)
				)T1
				GROUP BY
					STOCK_ID,
					PRODUCT_ID,
					PRODUCT_NAME	
			</cfquery>
			<cfloop from="1" to="#attributes.row_count#" index="kkk">
				<cfset stock_id_ = evaluate("attributes.stock_id_#kkk#")>
				<cfset method_id_ = listfirst(evaluate("attributes.method_id_#stock_id_#"),'_')>
				<cfset expo_id_ = listlast(evaluate("attributes.method_id_#stock_id_#"),'_')>
				<cfquery name="get_product" dbtype="query">
					SELECT * FROM get_product_main WHERE STOCK_ID = #stock_id_#
				</cfquery>
				<cfset attributes.method_type = method_id_>
				<cfif method_id_ eq 10><!--- trend analizi --->
					<cfinclude template="../form/add_demand_assemption_4.cfm">
				<cfelseif method_id_ eq 11><!--- mevsimsel trend analizi --->
					<cfinclude template="../form/add_demand_assemption_5.cfm">
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=prod.add_demand_assemption" addtoken="No">

