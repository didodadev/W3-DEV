<cfif attributes.is_compare_content eq 1>
	<cfquery name="GET_PRODUCT_PROPERTIES" datasource="#DSN1#">
		SELECT DISTINCT
			PRODUCT_PROPERTY.PROPERTY_ID,
			PRODUCT_PROPERTY.PROPERTY
		FROM
			PRODUCT_DT_PROPERTIES,
			PRODUCT_PROPERTY
		WHERE
			PRODUCT_PROPERTY.IS_ACTIVE = 1 AND
			PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_DT_PROPERTIES.PROPERTY_ID AND
			PRODUCT_DT_PROPERTIES.PRODUCT_ID IN (#attributes.product_id#) AND
			PRODUCT_DT_PROPERTIES.IS_INTERNET = 1
		ORDER BY
			PRODUCT_PROPERTY.PROPERTY_ID		
	</cfquery>
	<cfset property_list = valuelist(get_product_properties.property_id)>
<cfelse>
	<cfquery name="GET_PRODUCT_CONTENT" datasource="#DSN#">
		SELECT DISTINCT
			C.CONTENT_PROPERTY_ID,
			CP.NAME
		FROM 
			CONTENT_RELATION, 
			CONTENT C,
			CONTENT_PROPERTY CP
		WHERE 
			CP.CONTENT_PROPERTY_ID = C.CONTENT_PROPERTY_ID AND
			CONTENT_RELATION.CONTENT_ID = C.CONTENT_ID AND
			CONTENT_RELATION.ACTION_TYPE_ID IN (#attributes.product_id#) AND 
			CONTENT_RELATION.ACTION_TYPE = 'PRODUCT_ID' AND
			C.STAGE_ID = -2 AND
			<cfif isdefined("session.pp.company_category")>
				C.COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%">
			<cfelseif isdefined("session.ww.consumer_category")>
				C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%">
			<cfelseif isdefined("session.cp")>
				C.CAREER_VIEW = 1  
			<cfelse>
				C.INTERNET_VIEW = 1
			</cfif> 
		ORDER BY
			C.CONTENT_PROPERTY_ID
	</cfquery>
</cfif>
