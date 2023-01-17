<cfquery name="GET_RESPONSIBLES" datasource="#DSN1_alias#">
    SELECT 
        PCP.POSITION_CODE,
        PCP.SEQUENCE_NO,
        EMP.EMPLOYEE_NAME,
        EMP.EMPLOYEE_SURNAME 
    FROM 
        PRODUCT_CAT_POSITIONS PCP
        LEFT JOIN #dsn#.EMPLOYEE_POSITIONS EMP ON PCP.POSITION_CODE = EMP.POSITION_CODE
    WHERE
        PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
</cfquery>

<h2><cf_get_lang dictionary_id='37316.İlişkili Sorumlular'></h2>	
<cfif GET_RESPONSIBLES.recordCount>    
    <cfoutput query="get_responsibles">
        <div>
         #sequence_no#. <cf_get_lang dictionary_id='57544.Sorumlu'> : #employee_name# #employee_surname#   
        </div>
    </cfoutput>   
</cfif>
