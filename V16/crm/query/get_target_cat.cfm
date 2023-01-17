<!--- get_target_cat.cfm --->
<cfquery name="GET_TARGET_CAT" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		TARGET_CAT
</cfquery>
