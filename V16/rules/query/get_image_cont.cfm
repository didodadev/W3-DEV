<cfquery name="GET_IMAGE_CONT" datasource="#DSN#">
    SELECT 
        CONTIMAGE_SMALL,
        DETAIL 
    FROM 
        CONTENT_IMAGE
    WHERE 
        <cfif listlen(attributes.cntid) eq 1>
        	CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
        <cfelse>
        	CONTENT_ID IN (#attributes.cntid#)
        </cfif>
</cfquery>
