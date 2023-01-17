<cfquery name="GET_SALES_ZONE_NAME" datasource="#DSN#">
	SELECT
		SZ_ID,
		SZ_NAME,
		SZ_HIERARCHY
	FROM
		SALES_ZONES
	WHERE
	  <cfif isdefined("attributes.sales_zone_id")>
		SZ_ID = #attributes.sales_zone_id#
	  <cfelse>
	  	SZ_ID = #attributes.SZ_ID#
	  </cfif>
</cfquery>
