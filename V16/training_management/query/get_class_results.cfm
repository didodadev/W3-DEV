<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfset GET_CLASS_RESULTS = cmp.GET_CLASS_RESULTS_F(
   CLASS_ID:iif(isDefined("attributes.class_id") and len(attributes.class_id),attributes.class_id,""),
   keyword:iif(isDefined("attributes.keyword") and len(attributes.keyword),attributes.keyword,"")
)>
<!--- <cfquery name="GET_CLASS_RESULTS" datasource="#DSN#">
	SELECT
		CLASS_ID
	FROM
		TRAINING_CLASS_RESULTS
	WHERE
		CLASS_ID IS NOT NULL
		<cfif isDefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>
            AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
        </cfif>
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            AND
                EMP_ID IN
                (
                    SELECT
                        EMPLOYEE_ID
                    FROM
                        EMPLOYEE_POSITIONS
                    WHERE
                        EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
                        EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                )
        </cfif>
</cfquery> --->