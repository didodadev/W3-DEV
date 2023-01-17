<cfset attendersIds = attributes.training_group_attenders_id.split(",")>
<cfloop array="#attendersIds#" item="item">
    <cfif isdefined("attributes.training_group_attenders_id") and len(attributes.training_group_attenders_id)>
        <cfquery name="add_att" datasource="#DSN#">
            INSERT INTO TRAINING_GROUP_ATTENDERS_DELETE
            (
                REASON,
                TRAINING_GROUP_ID,
                DELETED_BY_EMP_ID,
                DELETED_ATTENDER_ID,
                DELETED_DATE,
                RECORD_EMP,
                RECORD_IP,
                RECORD_DATE
            )
            VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.reason#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.deleted_by_emp_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#item#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.deleted_date#">,
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#',
                #now()#
            )
        </cfquery>
        <cfquery name="upd_attenders_status" datasource="#dsn#">
            UPDATE TRAINING_GROUP_ATTENDERS
            SET
                <cfif attributes.reqType eq 3>
                    TRAINING_GROUP_ATTENDERS.STATUS = 0,
                    TRAINING_GROUP_ATTENDERS.JOIN_STATU = 3
                <cfelseif attributes.reqType eq 2>
                    TRAINING_GROUP_ATTENDERS.STATUS = 0,
                    TRAINING_GROUP_ATTENDERS.JOIN_STATU = 2
                <cfelseif attributes.reqType eq 1>
                    TRAINING_GROUP_ATTENDERS.STATUS = 1,
                    TRAINING_GROUP_ATTENDERS.JOIN_STATU = 1
                </cfif>
            WHERE
                TRAINING_GROUP_ATTENDERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#item#">
        </cfquery>
        <cfquery name="GET_TRAININGS" datasource="#DSN#">
            SELECT
                TC.CLASS_ID,
                TC.CLASS_NAME,
                TC.START_DATE,
                TC.FINISH_DATE,
                TCG.CLASS_GROUP_ID,
                TCG.TRAIN_GROUP_ID
            FROM
                TRAINING_CLASS_GROUP_CLASSES TCG,
                TRAINING_CLASS TC
            WHERE
                TC.CLASS_ID=TCG.CLASS_ID
            AND
                TCG.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
        </cfquery>
        <cfquery name="upd_attenders_status" datasource="#dsn#">
            UPDATE TRAINING_GROUP_CLASS_ATTENDANCE
            SET
                TRAINING_GROUP_CLASS_ATTENDANCE.STATUS = <cfif attributes.reqType eq 3>0<cfelseif attributes.reqType eq 2>0<cfelseif attributes.reqType eq 1>1</cfif>,
                CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_TRAININGS.CLASS_ID#">
            WHERE
                TRAINING_GROUP_ATTENDERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#item#">
        </cfquery>
    </cfif>
</cfloop>