<cfquery name="GET_UPD_PURCHASE" datasource="#DSN3#">
	SELECT 
		ORDERS.*,ORDER_ROW.DELIVER_DEPT,ORDER_ROW.DELIVER_LOCATION LOCATION_ID,ORDER_ROW.ORDER_ROW_ID
	FROM 
		ORDERS,
		ORDER_ROW
	WHERE 
		ORDERS.ORDER_ID=ORDER_ROW.ORDER_ID 
		<cfif isdefined("order_row_list") and len(order_row_list)>
			AND ORDER_ROW.ORDER_ROW_ID IN (#order_row_list#)
		</cfif>
		<cfif isdefined("url.deliver_dept") and len(url.deliver_dept)>
			AND ORDER_ROW.DELIVER_DEPT = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.deliver_dept#">
		</cfif>
		<cfif isdefined("attributes.deliverdate") and len(attributes.deliverdate)>
			AND ORDERS.DELIVERDATE = #attributes.deliverdate#
		</cfif>				
		AND ORDER_ROW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
