<cfif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)><!---etkilesim detayindan geliyorsa --->
	<cfset instance_name = 'content'>
	<cfset height = 300>
<cfelse>
	<cfset instance_name = 'subject'><!--- ekleme sayfasindan geliyorsa --->
	<cfset height = 180>
</cfif>
<cfif isDefined("attributes.width") and Len(attributes.width)>
	<cfset width = attributes.width>
<cfelse>
	<cfset width = 540>
</cfif>
<cfif len(attributes.template_id)>
	<cfquery name="get_temp" datasource="#dsn#">
		SELECT TEMPLATE_CONTENT FROM TEMPLATE_FORMS WHERE TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.template_id#">
	</cfquery>
</cfif>
<cfif isdefined('get_temp.template_content') and len(get_temp.template_content)>
	<cfmodule
		template="/fckeditor/fckeditor.cfm"
		toolbarSet="Basic"
		basePath="/fckeditor/"
		instanceName="#instance_name#"
		valign="top"
		value="#get_temp.template_content#"
		width="#width#"
		height="#height#">
<cfelse>
	<cfmodule
		template="/fckeditor/fckeditor.cfm"
		toolbarSet="Basic"
		basePath="/fckeditor/"
		instanceName="#instance_name#"
		valign="top"
		value=""
		width="#width#"
		height="#height#">
</cfif>