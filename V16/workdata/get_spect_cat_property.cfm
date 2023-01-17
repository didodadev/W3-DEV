<!---M.ER 20.02.2008
	 ÜRÜN ÖZELLLİKLERİNİ GETİRİR
--->
<cffunction name="get_spect_cat_property" access="public" returnType="query" output="no">
	<cfargument name="property_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="property_id" required="yes" type="string">
		<cfquery name="GET_PROD_CAT_PROPERTY" datasource="#dsn1#">
			SELECT
				PROPERTY_DETAIL_ID,
				PROPERTY_DETAIL
			FROM 
				PRODUCT_PROPERTY_DETAIL 
			 WHERE 
				PRPT_ID = #arguments.property_id# AND
				PROPERTY_DETAIL LIKE '#arguments.property_name#%'
			ORDER BY
				PROPERTY_DETAIL
		</cfquery>
	<cfreturn GET_PROD_CAT_PROPERTY>
</cffunction>
