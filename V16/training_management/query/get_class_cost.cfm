<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfset GET_CLASS_COST = cmp.GET_CLASS_COST_F(
   class_id:iif(isDefined("attributes.class_id") and len(attributes.class_id),attributes.class_id,"")
)>
<!--- <cfquery name="GET_CLASS_COST" datasource="#DSN#">
	SELECT
		CLASS_ID
	FROM
		TRAINING_CLASS_COST
	WHERE
		CLASS_ID IS NOT NULL
		<cfif isDefined("attributes.class_id") and len(attributes.class_id)>
            AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
        </cfif>
</cfquery> --->