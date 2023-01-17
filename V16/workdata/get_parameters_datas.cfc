<cfcomponent>
     <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfargument name="other_parameters" default="">
        <cfquery name="get_parameters_datas" datasource="#dsn#">        	
			SELECT
            	PARAM_DATA_ID,
                PARAM_DATA_TYPE,
                PARAM_DATA_STATUS,
                PARAM_DATA_DESCRIPTION,
                PARAM_DATA_DETAIL
            FROM 
             	SETUP_PARAM_DATA
            WHERE 
                PARAM_DATA_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.other_parameters#">
        </cfquery>
        <cfreturn GET_PARAMETERS_DATAS>
    </cffunction> 
</cfcomponent>