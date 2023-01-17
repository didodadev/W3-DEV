

<cfquery name="DEL_PROPERTY" datasource="#DSN1#">
	DELETE FROM
	   PRODUCT_PROPERTY_DETAIL
	WHERE 
	   PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">   
</cfquery>

<cfquery name="DELETE_PROPERTYID_FROM_OUR_COMPANY_TABLE" datasource="#DSN1#">
	DELETE FROM
		PRODUCT_PROPERTY_OUR_COMPANY
	WHERE
		PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">   
</cfquery>

<cfquery name="DEL_PROPERTY_MAIN" datasource="#DSN1#">
	DELETE FROM
	   PRODUCT_PROPERTY
	WHERE 
	   PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">   
</cfquery>

<cflocation url="#request.self#?fuseaction=product.list_property" addtoken="no">



