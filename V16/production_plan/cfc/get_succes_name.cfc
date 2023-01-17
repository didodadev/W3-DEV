<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3= "#dsn#_#session.ep.company_id#">
    <cfset dsn_alias= '#dsn#'>
    <cffunction name="get_succes_name" access="public" returntype="query">
        <cfargument name="succes_id_list_" type="any">
        <cfargument name="id" type="any">
        <cfquery name="get_succes_name" datasource="#dsn3#">
            SELECT 
                #dsn_alias#.Get_Dynamic_Language(SUCCESS_ID,'#session.ep.language#','QUALITY_SUCCESS','SUCCESS',NULL,NULL,SUCCESS) AS SUCCESS,
                SUCCESS_ID,
                DETAIL, 
                QUALITY_COLOR, 
                CODE,
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP, 
                IS_SUCCESS_TYPE, 
                IS_DEFAULT_TYPE
            FROM 
                QUALITY_SUCCESS 
            WHERE
                1 = 1
                <cfif isdefined("arguments.succes_id_list_")> 
                    AND SUCCESS_ID IN (#arguments.succes_id_list_#) 
                </cfif>
                <cfif isdefined("arguments.ID")> 
                    AND SUCCESS_ID = #arguments.ID# 
                </cfif> 
            ORDER BY SUCCESS
        </cfquery>
        <cfreturn get_succes_name/>
    </cffunction>
</cfcomponent>