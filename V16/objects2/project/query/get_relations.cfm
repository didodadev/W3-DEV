<cfquery name="get_relations" datasource="#dsn#">
	SELECT
		*
	FROM
		PRO_WORK_RELATIONS
	WHERE
		WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_work_id#">
		AND
		PRE_ID <> 0
</cfquery>
