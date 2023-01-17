<cfquery name="GET_UPD_PURCHASE" datasource="#dsn3#">
 	SELECT 
		ORDERS.*,ODR.DEPARTMENT_ID AS DELIVER_DEPT,ODR.LOCATION_ID,ODR.ORDER_ROW_ID
	FROM 
		ORDERS,
		ORDER_ROW ,
		ORDER_ROW_DEPARTMENTS ODR
	WHERE 
		ODR.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID  AND 
		ORDERS.ORDER_ID=ORDER_ROW.ORDER_ID 
	<cfif isdefined("order_row_list") and len(order_row_list)>
		AND ODR.ORDER_ROW_ID IN (#order_row_list#)
	</cfif>
	<cfif isdefined("url.deliver_dept") and len(url.deliver_dept)>
		AND ODR.DEPARTMENT_ID = #url.deliver_dept#
	</cfif>
	<cfif isdefined("attributes.deliverdate") and len(attributes.deliverdate)>
		AND ORDERS.DELIVERDATE = #attributes.deliverdate#
	</cfif>				
		AND ORDER_ROW.ORDER_ID = #attributes.order_id#
</cfquery>
