<cfcomponent>
    <cfset dsn = application.SystemParam.SystemParam().dsn>
    <cfset request.self = application.systemParam.systemParam().request.self />

    <cffunction name="get_train_id" returntype="query">
        <cfargument name="content_id" default="">
        <cfquery name="get_train_id" datasource="#dsn#">
            SELECT ACTION_TYPE_ID FROM CONTENT_RELATION WHERE ACTION_TYPE = <cfqueryparam value="train_id" cfsqltype="cf_sql_varchar"> AND CONTENT_ID = <cfqueryparam value="#arguments.content_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn get_train_id>
    </cffunction>
    <cffunction name="save_feedback" returntype="any" access="remote">
        <cfargument name="content_id" default="">
        <cfargument name="train_id" default="">
        <cfargument name="is_studying" default="">
        <cfargument name="is_readed" default="">
        <cfquery name="rec_control" datasource="#dsn#">
            SELECT * FROM TRAINING_IN_SUBJECT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND CONTENT_ID = <cfqueryparam value="#arguments.content_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif rec_control.recordcount>
            <cfquery name="upd_feedback" datasource="#dsn#">
                UPDATE
                    TRAINING_IN_SUBJECT
                SET
                    ACCESS_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    IS_READED =  <cfif len(arguments.is_readed)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_readed#"><cfelse>NULL</cfif>,
                    IS_STUDY = <cfif len(arguments.is_studying)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_studying#"><cfelse>NULL</cfif>,
                    READING_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                WHERE
                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    AND CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_id#">
            </cfquery>
        <cfelse>
            <cfset train_id_n = "#this.get_train_id(content_id:arguments.content_id).ACTION_TYPE_ID#">
            <cfquery name="save_feedback" datasource="#dsn#" result="MAX_ID">
                INSERT INTO 
                    TRAINING_IN_SUBJECT
                (
                    EMPLOYEE_ID,
                    TRAIN_ID,
                    ACCESS_DATE,
                    IS_READED,
                    IS_STUDY,
                    READING_DATE,
                    CONTENT_ID
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfif len(train_id_n)><cfqueryparam cfsqltype="cf_sql_integer" value="#train_id_n#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfif len(arguments.is_readed)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_readed#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.is_studying)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_studying#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_id#">
                )
            </cfquery>
        </cfif>
        
        <script>
			closeBoxDraggable('quality_box');
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.content&event=feedBack&cntid=#arguments.content_id#</cfoutput>', 'training_feedback');
        </script>
    </cffunction>
    <cffunction name="get_feedback" returntype="query">
        <cfargument name="content_id" default="">
        <cfset train_id_n = "#this.get_train_id(content_id:arguments.content_id).ACTION_TYPE_ID#">
        <cfquery name="get_feedback" datasource="#dsn#">
            SELECT
                IS_READED,
                IS_STUDY,
                IS_REPEAT
            FROM
                TRAINING_IN_SUBJECT
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                AND CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.content_id#">
                <cfif len(train_id_n)>
                    AND TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#train_id_n#">
                </cfif>
        </cfquery>
        <cfreturn get_feedback>
    </cffunction>
</cfcomponent>
    