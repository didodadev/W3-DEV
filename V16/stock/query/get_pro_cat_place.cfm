<!--- bu sayfa 2 farkli yerden cagiriliyor. --->
<cfquery name="get_pro_cat_place" datasource="#DSN3#">
	SELECT
		*
	FROM
		PRODUCT_CAT_PLACE
	<cfif isDefined('attributes.PC_PLACE_ID')>
			WHERE
				PC_PLACE_ID = #attributes.PC_PLACE_ID#
	</cfif>
	<cfif len(attributes.keyword)>
		WHERE
			DETAIL LIKE '%#attributes.keyword#%'	
	</cfif>
</cfquery>

