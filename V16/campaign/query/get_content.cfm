<cfquery name="get_content" datasource="#dsn3#">
    SELECT
        EMP.EMPLOYEE_NAME,
        EMP.EMPLOYEE_SURNAME,
        CAMPAIGNS.CAMP_HEAD,
        CAMPAIGNS.CAMP_ID,
        CONTENT_RELATION.CONTENT_ID,
        CONTENT_RELATION.RECORD_EMP,
        CONTENT_RELATION.RECORD_DATE,
        CONTENT.CONT_HEAD
    FROM 
        #dsn_alias#.CONTENT_RELATION,
        CAMPAIGNS,
        #dsn_alias#.CONTENT,
        #dsn_alias#.EMPLOYEES EMP
    WHERE 
        CONTENT.CONTENT_ID = CONTENT_RELATION.CONTENT_ID AND
        CONTENT_RELATION.ACTION_TYPE = 'CAMPAIGN_ID' AND
        CONTENT_RELATION.ACTION_TYPE_ID = CAMPAIGNS.CAMP_ID AND 
        CONTENT_RELATION.RECORD_EMP=EMP.EMPLOYEE_ID
        <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
        AND CONTENT.CONT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
        </cfif>
    ORDER BY
        CONTENT_RELATION.RECORD_DATE DESC
</cfquery>
