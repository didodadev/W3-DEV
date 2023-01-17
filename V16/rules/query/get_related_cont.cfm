<cfquery name="GET_RELATED_CONT" datasource="#DSN#">
	SELECT 
		C.CONT_HEAD,
		C.CONT_SUMMARY ,
		C.CONTENT_ID
	FROM 
		CONTENT_RELATION RC, 
		CONTENT C
	WHERE 
		RC.ACTION_TYPE = 'CONTENT_ID' AND
		RC.ACTION_TYPE_ID = C.CONTENT_ID AND
        <cfif listlen(attributes.cntid) eq 1>
	  		RC.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#"> AND
       	<cfelse>
       		RC.CONTENT_ID  IN (#attributes.cntid#) AND
       	</cfif>
		C.STAGE_ID = -2 AND
		C.EMPLOYEE_VIEW = 1	
</cfquery>
