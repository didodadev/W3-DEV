<cfquery name="get_temp" datasource="#dsn#">
	SELECT 
		DETAIL
	FROM
		SETUP_CORR
	WHERE
		CORRCAT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.template_id#">
</cfquery>
<cfif len(get_temp.detail)>
	<cfmodule
        template="/fckeditor/fckeditor.cfm"
        toolbarSet="WRKContent"
        basePath="/fckeditor/"
        instanceName="content"
        valign="top"
        value="#get_temp.detail#"
        width="575"
        height="200">
<cfelse>
	<cfmodule
        template="/fckeditor/fckeditor.cfm"
        toolbarSet="WRKContent"
        basePath="/fckeditor/"
        instanceName="content"
        valign="top"
        value=""
        width="575"
        height="200">
</cfif>