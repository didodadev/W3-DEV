<cfquery name="GET_CONTENT" datasource="#dsn#">
SELECT * FROM CONTENT WHERE PRODUCT_ID = #URL.PID#
</cfquery>
