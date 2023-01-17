<cfif IsDefined("attributes.x_content_id") and len(attributes.x_content_id)>
    <cfquery name="get_content" datasource="#dsn#" maxrows="10">
        SELECT 
            CONTENT_ID,
            CONT_HEAD,
            CONT_SUMMARY,
            CONT_BODY
        FROM 
            CONTENT
        WHERE 	
            CONTENT_STATUS = 1 
            AND INTERNET_VIEW = 1
            AND CONTENT_ID = <cfqueryparam value="#attributes.x_content_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif get_content.recordcount>
        <h3><cfoutput>#get_content.CONT_HEAD#</cfoutput></h3>
        <h4><cfoutput>#get_content.CONT_SUMMARY#</cfoutput></h4>
        <cfoutput>#get_content.CONT_BODY#</cfoutput>
    </cfif>
</cfif>