<!--- ders yoklaması sayfası --->
<cfset train_group_id = attributes.train_group_id.split(",")[1]>
<cfset type = attributes.type.split(",")>
<cfset class_attender_id = attributes.class_attender_id.split(",")>
<cfset joined = attributes.joined.split(",")>
<cfset note = attributes.note.split(",")>
<cfset k_id = attributes.k_id.split(",")>
<cfset count = arrayLen(listToArray(attributes.k_id))>

<cf_box title="#getLang('','Katılımcılar',57590)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfif count neq 0>
        <cfloop from="1" to="#count#" index="i">
            <cfquery name="get_attenders" datasource="#dsn#">
                SELECT
                    *
                FROM
                    TRAINING_GROUP_CLASS_ATTENDANCE
                WHERE
                    TRAINING_GROUP_ATTENDERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_attender_id[i]#">
                    AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
                    AND TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#train_group_id#">
            </cfquery>
            <cfif get_attenders.recordcount>
                <cfquery name="upd_training_group_attenders" datasource="#dsn#">
                    UPDATE
                        TRAINING_GROUP_CLASS_ATTENDANCE
                    SET
                        JOINED = <cfqueryparam cfsqltype="cf_sql_integer" value="#joined[i]#">,
                        NOTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#note[i]#">,
                        PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
                    WHERE
                        TRAINING_GROUP_ATTENDERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_attender_id[i]#">
                        AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
                        AND TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#train_group_id#">
                </cfquery>
            <cfelse>
                <cfquery name="add_training_group_attenders" datasource="#dsn#">
                    INSERT INTO
                        TRAINING_GROUP_CLASS_ATTENDANCE
                    (
                        <cfif type eq 'partner'>
                            PAR_ID,
                        <cfelseif type eq 'consumer'>
                            CON_ID,
                        <cfelseif type eq 'group'>
                            GRP_ID,
                        <cfelse>
                            EMP_ID,
                        </cfif>
                        STATUS,
                        TRAINING_GROUP_ID,
                        CLASS_ID,
                        TRAINING_GROUP_ATTENDERS_ID,
                        NOTE,
                        JOINED,
                        PROCESS_STAGE
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#k_id[i]#">,
                        1,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#train_group_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#class_attender_id[i]#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#note[i]#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#joined[i]#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
                    )
                </cfquery>
            </cfif>
        </cfloop>
    </cfif>
</cf_box>
<cfif isDefined("attributes.draggable")>
    <script>
        closeBoxDraggable('class_attender_box');
    </script>
<cfelse>
    <cflocation url="#request.self#?fuseaction=training_management.popup_list_class_attenders&class_id=#class_id#" addtoken="No">
</cfif>