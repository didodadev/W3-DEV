<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT 
		PRODUCT_CAT.PRODUCT_CATID, 
		PRODUCT_CAT.HIERARCHY, 
		PRODUCT_CAT.PRODUCT_CAT
	FROM 
		PRODUCT_CAT,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
        (
        	','+PRODUCT_CAT.PRODUCT_CAT+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
			','+PRODUCT_CAT.HIERARCHY+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		) AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		HIERARCHY
</cfquery>
<select name="cat" id="cat" style="width:250px;height:150px;" multiple="multiple">
	<cfoutput query="get_product_cat">
        <option value="#hierarchy#"><cfloop from="1" to="#listlen(hierarchy,'.')-1#" index="ccc">&nbsp;&nbsp;</cfloop>#hierarchy#-#product_cat#</option>
    </cfoutput>
</select>
