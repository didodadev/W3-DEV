<cfif isDefined('attributes.order_id')>
	<!--- from_sale_order parametresi satıs siparisinden satınalma siparisi kopyalamak icin kullanılıyor--->
	<cfquery name="GET_ORDER_DETAIL" datasource="#DSN3#">
		SELECT 
			ORDERS.*,
			ORDER_ROW.ROW_INTERNALDEMAND_ID,
			ORDER_ROW.ROW_PRO_MATERIAL_ID
		FROM 
			ORDERS,
			ORDER_ROW
		WHERE 
			ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
			AND ORDERS.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
			AND ORDERS.PURCHASE_SALES = <cfif isdefined('attributes.from_sale_order') and attributes.from_sale_order eq 1>1<cfelse>0</cfif>
			<cfif session.ep.isBranchAuthorization>
				AND ORDERS.DELIVER_DEPT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">)
			</cfif>			
	</cfquery>
</cfif>
