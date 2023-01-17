<cfquery name="GET_SITE_LAYOUTS" datasource="#DSN#">
	SELECT 
		MSL.MENU_ID,
        MSL.FACTION,
		MSL.HEADER
	FROM 
		MAIN_SITE_LAYOUTS MSL
	WHERE 
		MSL.MENU_ID IS NOT NULL
		<cfif isdefined("attributes.selected_link") and len(attributes.selected_link)>
			AND MSL.FACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.selected_link#">
		</cfif>
		<cfif isdefined("attributes.menu_id") and len(attributes.menu_id)>AND MSL.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#"></cfif>
		<cfif len(attributes.keyword)>
			AND MSL.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
	ORDER BY
		MSL.FACTION,
		(SELECT MENU_NAME FROM MAIN_MENU_SETTINGS WHERE MENU_ID = MSL.MENU_ID)
</cfquery>
