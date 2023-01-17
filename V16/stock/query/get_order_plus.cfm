<cfquery name="GET_ORDER_PLUS" datasource="#dsn#">
	SELECT
		*
	FROM
		#dsn3_alias#.ORDER_PLUS OP, 
		EMPLOYEES E, 
		SETUP_COMMETHOD SC
	WHERE
		OP.ORDER_ID = #attributes.order_id# AND
		E.EMPLOYEE_ID = OP.EMPLOYEE_ID AND
		SC.COMMETHOD_ID = OP.COMMETHOD_ID
	ORDER BY
		ORDER_PLUS_ID DESC			
</cfquery>
