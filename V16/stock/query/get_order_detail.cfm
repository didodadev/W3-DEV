<cfquery name="GET_ZONE_TYPE" datasource="#DSN3#">
	SELECT ORDER_ZONE FROM ORDERS WHERE ORDER_ID = #attributes.order_id#
</cfquery>
<cfif GET_ZONE_TYPE.ORDER_ZONE eq 1>
	<cfquery name="GET_ORDER_DETAIL" DATASOURCE="#DSN3#" BLOCKFACTOR="1">
		SELECT * FROM ORDERS WHERE ORDERS.ORDER_ID = #attributes.order_id#
	</cfquery>
<cfelse>
	<cfquery name="GET_ORDER_DETAIL" DATASOURCE="#DSN3#" BLOCKFACTOR="1">
		SELECT 
			ORDERS.*, 
			EMP.EMPLOYEE_NAME, 
			EMP.EMPLOYEE_SURNAME
		FROM 
			ORDERS, 
			#dsn_alias#.EMPLOYEES EMP
		WHERE 
			ORDERS.ORDER_ID = #attributes.order_id# AND
			EMP.EMPLOYEE_ID = ORDERS.RECORD_EMP 
	</cfquery>
</cfif>	
