<cfif len(GET_SALE_DET.DEPARTMENT_ID)>
	<cfquery name="GET_STORE" datasource="#dsn#">
		SELECT 
			DEPARTMENT_ID,
			DEPARTMENT_HEAD 
		FROM 
			DEPARTMENT 
		WHERE 
			DEPARTMENT_ID=#GET_SALE_DET.DEPARTMENT_ID#
	</cfquery>
</cfif>
<cfif len(GET_SALE_DET.SHIP_METHOD)>
	<cfquery name="GET_METHOD" datasource="#dsn#">
		SELECT 
			SHIP_METHOD_ID,
			SHIP_METHOD 
		FROM 
			SHIP_METHOD 
		WHERE 
			SHIP_METHOD_ID=#GET_SALE_DET.SHIP_METHOD#
	</cfquery>
</cfif>
