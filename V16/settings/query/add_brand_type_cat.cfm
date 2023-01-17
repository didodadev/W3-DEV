<cfquery name="ADD_BRAND_TYPE_CAT" datasource="#dsn#" result="MAX_ID">
	INSERT INTO 
	SETUP_BRAND_TYPE_CAT
	(
		BRAND_TYPE_CAT_NAME,
		BRAND_ID,
		BRAND_TYPE_ID,
        BRAND_TYPE_CAT_WIDTH,
        BRAND_TYPE_CAT_HEIGHT,
        BRAND_TYPE_CAT_WEIGHT,
        BRAND_TYPE_CAT_DEPTH,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
	VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.brand_type_cat_name#">,
		#attributes.brand_id#,
		#attributes.brand_type_id#,
        <cfif isdefined('attributes.type_cat_width') and len(attributes.type_cat_width)>#filterNum(attributes.type_cat_width)#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.type_cat_height') and len(attributes.type_cat_height)>#filterNum(attributes.type_cat_height)#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.type_cat_weight') and len(attributes.type_cat_weight)>#filterNum(attributes.type_cat_weight)#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.type_cat_depth') and len(attributes.type_cat_depth)>#filterNum(attributes.type_cat_depth)#<cfelse>NULL</cfif>,
		#now()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.reöte._addr#">
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.upd_brand_type_cat&brand_type_cat_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
