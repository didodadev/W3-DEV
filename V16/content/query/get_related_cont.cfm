<!--- get_related_cont.cfm --->
<cfquery name="GET_RELATED_CONT" datasource="#dsn#">
	SELECT
		C.CONT_HEAD,
		C.CONT_SUMMARY,
		C.CONTENT_ID,
		RC.RELATED_ID,
		C.SPOT
	FROM
		RELATED_CONTENT RC,
		CONTENT C
	WHERE
		RC.RELATED_CONTENT_ID = C.CONTENT_ID AND
		RC.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
</cfquery>
