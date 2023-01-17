<cfquery name="get_or_num" datasource="#DSN3#">
	SELECT ORDER_NUMBER FROM ORDERS WHERE ORDER_ID = #GET_DET_PO.ORDER_ID#
</cfquery>
