<cfif len(get_product_place.location_id)>
	<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
		SELECT  
			D.DEPARTMENT_HEAD,
			SL.COMMENT
		FROM 
			DEPARTMENT D,
			STOCKS_LOCATION SL
		WHERE 
			D.IS_STORE <> 2 AND 
			D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND 
			SL.LOCATION_ID = #get_product_place.location_id# AND 
			SL.DEPARTMENT_ID = #get_product_place.store_id#
	</cfquery>
<cfelse>
	<cfquery name="GET_STORE_LOCATION" datasource="#DSN#">
		SELECT  
			D.DEPARTMENT_HEAD AS STORE_NAME,
			D.DEPARTMENT_HEAD,
			'' AS COMMENT
		FROM 
			DEPARTMENT D
		WHERE 
			D.IS_STORE <> 2 AND 
			D.DEPARTMENT_ID = #get_product_place.store_id#
	</cfquery>
</cfif>
