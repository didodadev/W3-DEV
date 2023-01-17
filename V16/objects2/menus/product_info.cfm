<cfif isdefined('attributes.product_catid') and len(attributes.product_catid)>
	<cfquery name="GET_PRODUCT_CAT" datasource="#dsn1#">
		SELECT 
			PRODUCT_CAT
		FROM 
			PRODUCT_CAT
		WHERE 
			PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
	</cfquery>
</cfif>
	
<cfif isdefined('attributes.product_catid') and len(attributes.product_catid) and get_product_cat.recordcount and len(get_product_cat.product_cat)>
    <table width="100%">
        <tr>
            <td><cfoutput>#get_product_cat.product_cat#</cfoutput></td>
        </tr>
    </table>
</cfif>
