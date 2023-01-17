<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_ASSETP_SPACE" returntype="query">
        <cfquery name="GET_ASSETP_SPACE" datasource="#dsn#">
            SELECT ASSET_P_SPACE_ID, SPACE_CODE, #dsn#.Get_Dynamic_Language(ASSET_P_SPACE_ID,'#session.ep.language#','ASSET_P_SPACE','SPACE_NAME',NULL,NULL,SPACE_NAME) AS SPACE_NAME, #dsn#.Get_Dynamic_Language(ASSET_P_SPACE_ID,'#session.ep.language#','ASSET_P_SPACE','SPACE_DETAIL',NULL,NULL,SPACE_DETAIL) AS SPACE_DETAIL, SPACE_WIDTH, SPACE_LENGTH, SPACE_HEIGHT, SPACE_MEASURE,IS_HORECA,UPDATE_EMP FROM ASSET_P_SPACE
        </cfquery>
        <cfreturn get_assetp_space>
    </cffunction>
    <cffunction name="add_assetp_space" access="remote">
        <cfquery name="add_assetp_space" datasource="#dsn#">
            INSERT INTO
                ASSET_P_SPACE
            (
                SPACE_CODE, 
                SPACE_NAME, 
                SPACE_DETAIL, 
                SPACE_WIDTH, 
                SPACE_LENGTH, 
                SPACE_HEIGHT, 
                SPACE_MEASURE,
                IS_HORECA,
                UPDATE_EMP 
            )
            VALUES
            (
                <cfif isdefined("assetp_code_") and len(assetp_code_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#assetp_code_#"><cfelse>NULL</cfif>,
                <cfif isdefined("assetp_name_") and len(assetp_name_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#assetp_name_#"><cfelse>NULL</cfif>,
                <cfif isdefined("assetp_detail_") and len(assetp_detail_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#assetp_detail_#"><cfelse>NULL</cfif>,
                <cfif isdefined("assetp_width_") and len(assetp_width_)><cfqueryparam cfsqltype="cf_sql_float" value="#assetp_width_#"><cfelse>0</cfif>,
                <cfif isdefined("assetp_length_") and len(assetp_length_)><cfqueryparam cfsqltype="cf_sql_float" value="#assetp_length_#"><cfelse>0</cfif>,
                <cfif isdefined("assetp_height_") and len(assetp_height_)><cfqueryparam cfsqltype="cf_sql_float" value="#assetp_height_#"><cfelse>0</cfif>,
                <cfif isdefined("assetp_unit_") and len(assetp_unit_)><cfqueryparam cfsqltype="cf_sql_integer" value="#assetp_unit_#"><cfelse>0</cfif>,
                <cfif isdefined("is_horeca") and len(is_horeca)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_horeca#"><cfelse>0</cfif>,
               <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            
            )
        </cfquery>
        <script type="text/javascript">
            history.back();
        </script>
    </cffunction>
    <cffunction name="upd_assetp_space"  access="remote">
        <cfargument name="assetp_id" default="">
        <cfquery name="upd_assetp_space" datasource="#dsn#">
            UPDATE
                ASSET_P_SPACE
            SET
                <cfif isdefined("assetp_code") and len(assetp_code)>SPACE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetp_code#"></cfif>
                <cfif isdefined("assetp_name") and len(assetp_name)>,SPACE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetp_name#"></cfif>
                <cfif isdefined("assetp_detail") and len(assetp_detail)>,SPACE_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetp_detail#"></cfif>
                <cfif isdefined("assetp_width") and len(assetp_width)>,SPACE_WIDTH = <cfqueryparam cfsqltype="cf_sql_float" value="#assetp_width#"></cfif>
                <cfif isdefined("assetp_length") and len(assetp_length)>,SPACE_LENGTH = <cfqueryparam cfsqltype="cf_sql_float" value="#assetp_length#"></cfif>
                <cfif isdefined("assetp_height") and len(assetp_height)>,SPACE_HEIGHT = <cfqueryparam cfsqltype="cf_sql_float" value="#assetp_height#"></cfif>
                <cfif isdefined("assetp_unit") and len(assetp_unit)>,SPACE_MEASURE = <cfqueryparam cfsqltype="cf_sql_integer" value="#assetp_unit#"></cfif>
                ,UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                ,IS_HORECA=<cfif isdefined("is_horeca") and len(is_horeca)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_horeca#"><cfelse>0</cfif>

            WHERE
                ASSET_P_SPACE_ID = #arguments.assetp_id#
        </cfquery>
        <script type="text/javascript">
            history.back();
        </script>
    </cffunction>
     <cffunction name="del_assetp_space"  access="remote">
      <cfargument name="assetp_id" default="">
        <cfquery name="del_assetp_space" datasource="#dsn#">
            DELETE FROM 
                ASSET_P_SPACE
            WHERE
                ASSET_P_SPACE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_id#">
        </cfquery>
        
        <script type="text/javascript">
            history.back();
        </script>
    </cffunction>
</cfcomponent>