<cfquery name="UPD_BRAND_TYPE_CAT" datasource="#DSN#">
	UPDATE 
		SETUP_BRAND_TYPE_CAT
	SET
		BRAND_TYPE_CAT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.brand_type_cat_name#">,
		BRAND_ID = #attributes.brand_id#,
		BRAND_TYPE_ID = #attributes.brand_type_id#,
        <cfif isdefined('attributes.type_cat_width') and len(attributes.type_cat_width)>BRAND_TYPE_CAT_WIDTH = #filterNum(attributes.type_cat_width)#,</cfif>
        <cfif isdefined('attributes.type_cat_height') and len(attributes.type_cat_height)>BRAND_TYPE_CAT_HEIGHT = #filterNum(attributes.type_cat_height)#,</cfif>
        <cfif isdefined('attributes.type_cat_weight') and len(attributes.type_cat_weight)>BRAND_TYPE_CAT_WEIGHT = #filterNum(attributes.type_cat_weight)#,</cfif>
        <cfif isdefined('attributes.type_cat_depth') and len(attributes.type_cat_depth)>BRAND_TYPE_CAT_DEPTH = #filterNum(attributes.type_cat_depth)#,</cfif>
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE  
		BRAND_TYPE_CAT_ID = #attributes.brand_type_cat_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.upd_brand_type_cat&brand_type_cat_id=#attributes.brand_type_cat_id#" addtoken="no">
