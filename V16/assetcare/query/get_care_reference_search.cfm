<cfif isdefined("attributes.is_submitted")>
<cfquery name="GET_CARE_REFERENCE_SEARCH" datasource="#dsn#">
	SELECT
		ASSET_P_CARE_REFERENCE.*,
		SETUP_BRAND.BRAND_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME
	FROM
		ASSET_P_CARE_REFERENCE,
		SETUP_BRAND,
		SETUP_BRAND_TYPE
	WHERE
		SETUP_BRAND_TYPE.BRAND_TYPE_ID = ASSET_P_CARE_REFERENCE.BRAND_TYPE_ID AND
		SETUP_BRAND.BRAND_ID = SETUP_BRAND_TYPE.BRAND_ID
		<cfif len(attributes.care_type_id)>AND ASSET_P_CARE_REFERENCE.CARE_TYPE_ID = #attributes.care_type_id#</cfif>
		<cfif len(attributes.make_year)>AND ASSET_P_CARE_REFERENCE.MAKE_YEAR = #attributes.make_year#</cfif>
		<cfif len(attributes.brand_type_id) and len(attributes.brand_name)>AND ASSET_P_CARE_REFERENCE.BRAND_TYPE_ID = #attributes.brand_type_id#</cfif>
	ORDER BY
		ASSET_P_CARE_REFERENCE.CARE_REFERENCE_ID
</cfquery>
</cfif>
