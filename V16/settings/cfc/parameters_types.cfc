<cfcomponent>
     <cfset dsn = application.systemParam.systemParam().dsn>
     <cfset dateformat_style = session.ep.dateformat_style>
     <cfif dateformat_style is 'dd/mm/yyyy'>
     	<cfset dateformat_style_ = 'dd/MM/yyyy'>
     <cfelse>
     	<cfset dateformat_style_ = 'MM/dd/yyyy'>
     </cfif>
    <cffunction name="GET_PARAMETERS_TYPE" access="remote" returntype="query" hint="Parametre Tipleri List">
        <cfquery name="GET_PARAMETERS_TYPE" datasource="#dsn#">        	
			SELECT
            	PARAM_TYPE_ID,
                PARAM_TYPE_NAME,
                RECORD_EMP
             FROM 
             	SETUP_PARAM_TYPE    
        </cfquery>
        <cfreturn GET_PARAMETERS_TYPE>
    </cffunction>    
    <cffunction name="parameters_type_update" access="remote" returntype="any" returnFormat="json" hint="Parametre Tipleri Güncelle">
    	<cfif len(arguments.primary)>
        	<cfquery name="parameters_type_update" datasource="#dsn#">        	
                UPDATE
                    SETUP_PARAM_TYPE
                SET
                    PARAM_TYPE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.param_type_name#">,
                    RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">                
                WHERE 
                    PARAM_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.param_type_id#"> 
            </cfquery>
        	<cfset returnData =1> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>    
    <cffunction name="parameters_type_add_new" access="remote" returntype="any" returnFormat="json" hint="Parametre Tipleri Ekle">
    	<cfif len(arguments.PARAM_TYPE_NAME)>
        	<cfquery name="parameters_type_add_new" datasource="#dsn#" result="query_result">	
                INSERT INTO
                    SETUP_PARAM_TYPE
                    (
                        PARAM_TYPE_NAME,
                        RECORD_EMP
                    )
                VALUES
                	(
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.param_type_name#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    )
            </cfquery>
        	<cfset returnData = #query_result.identitycol#> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>
    <cffunction name="GET_PARAMETERS_DATA" access="remote" returntype="query" hint="Parametre Dataları List">
        <cfquery name="GET_PARAMETERS_DATA" datasource="#dsn#">        	
			SELECT
            	PARAM_DATA_ID,
                SETUP_PARAM_DATA,
                PARAM_DATA_STATUS,
                PARAM_DATA_DESCRIPTION,
                PARAM_DATA_DETAIL
            FROM 
             	SETUP_PARAM_DATA
            WHERE 
                PARAM_DATA_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.param_type_id#">
        </cfquery>
        <cfreturn GET_PARAMETERS_DATA>
    </cffunction> 
</cfcomponent>