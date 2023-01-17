<cfif isDefined('attributes.pro_prop_id')>
	<cfquery name="GET_PROPERTIES" datasource="#DSN3#">
		SELECT
			PP.* 
		FROM
			#dsn1_alias#.PRODUCT_PROPERTY PP,
			PRODUCT_CAT PC,
			PRODUCT P
		WHERE
			PP.PRODUCT_CAT_HIER = PC.HIERARCHY AND
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
			P.PRODUCT_ID = #attributes.pid# 
		ORDER BY
			PP.PROPERTY 
	</cfquery>
<cfelse>
	<cfquery name="GET_PROPERTIES" datasource="#DSN1#">
		SELECT 
			* 
		FROM 
			PRODUCT_PROPERTY
		ORDER BY
			PROPERTY
	</cfquery>
</cfif>
