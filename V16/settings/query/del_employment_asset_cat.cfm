<cfquery name="Up_Hierachy_Control" datasource="#dsn#">
	SELECT * FROM SETUP_EMPLOYMENT_ASSET_CAT WHERE HIERARCHY LIKE '#ATTRIBUTES.ASSET_CAT_ID#.%' OR HIERARCHY LIKE '#ATTRIBUTES.ASSET_CAT_ID#'
</cfquery>
<cfif Up_Hierachy_Control.RecordCount>
	<cfset Del_Asset_List = ValueList(Up_Hierachy_Control.Asset_Cat_Id,',')>
<cfelse>
	<cfset Del_Asset_List = Attributes.Asset_Cat_Id>
</cfif>
<cfquery name="DELDRIVERLICENCE" datasource="#dsn#">
	DELETE FROM SETUP_EMPLOYMENT_ASSET_CAT WHERE ASSET_CAT_ID IN (#Del_Asset_List#)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_employment_asset_cat" addtoken="no">
