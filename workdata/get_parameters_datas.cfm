 <cfset dsn = application.systemParam.systemParam().dsn>
   <cffunction name="get_parameters_datas">
       <cfargument name="other_parameters" type="string" default="">
       <cfargument name="parameter" type="numeric" default="">
       <cfargument name="param_data_type" type="numeric" default="">
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
                PARAM_DATA_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.other_parameters#%">
                AND PARAM_DATA_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#param_data_type#">
       </cfquery>
       <cfreturn GET_PARAMETERS_DATAS>
   </cffunction> 