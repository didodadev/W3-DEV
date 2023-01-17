<cfif isdefined("attributes.train_group_id") and len(attributes.train_group_id)>
	<cfquery name="kont" datasource="#DSN#">
		SELECT
				*
		FROM
			TRAINING_CLASS_GROUP_CLASSES
		WHERE
			CLASS_ID=#attributes.CLASS_ID# AND
			TRAIN_GROUP_ID=#attributes.TRAIN_GROUP_ID#
	</cfquery>
	<cfif not kont.RECORDCOUNT>
		<cfquery name="add_cls" datasource="#DSN#">
			INSERT INTO 
				TRAINING_CLASS_GROUP_CLASSES
				(
					CLASS_ID,
					TRAIN_GROUP_ID,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE
				)
			VALUES
				(
					#attributes.CLASS_ID#,
					#attributes.TRAIN_GROUP_ID#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_USER#',
					#NOW()#
				)
		</cfquery>
	</cfif>

	<cfquery name="attendance_check" datasource="#DSN#">
		SELECT
            *
		FROM
			TRAINING_GROUP_CLASS_ATTENDANCE
		WHERE
			CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND
			TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#"> AND
            STATUS = 1
	</cfquery>
	<cfif not attendance_check.RECORDCOUNT>
        <cfquery name="get_attender" datasource="#DSN#">
            SELECT
                *
            FROM
                TRAINING_GROUP_ATTENDERS
            WHERE
                TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
        </cfquery>
        <cfloop query="get_attender">
            <cfquery name="add_att" datasource="#DSN#">
                INSERT INTO 
                    TRAINING_GROUP_CLASS_ATTENDANCE
                    (
                        CLASS_ID,
                        TRAINING_GROUP_ID,
                        TRAINING_GROUP_ATTENDERS_ID,
                        STATUS,
                        JOINED,
                        NOTE,
                        PROCESS_STAGE
                        <cfif get_attender.EMP_ID gt 0>
                            ,EMP_ID
                        <cfelseif get_attender.PAR_ID gt 0>
                            ,PAR_ID
                        <cfelseif get_attender.COMP_ID gt 0>
                            ,COMP_ID
                        </cfif>
                    )
                VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_attender.TRAINING_GROUP_ATTENDERS_ID#">,
                        1,
                        0,
                        0,
                        298
                        <cfif get_attender.EMP_ID gt 0>
                            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_attender.EMP_ID#">
                        <cfelseif get_attender.PAR_ID gt 0>
                            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_attender.PAR_ID#">
                        <cfelseif get_attender.COMP_ID gt 0>
                            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_attender.COMP_ID#">
                        </cfif>
                    )
            </cfquery>
        </cfloop>
	</cfif>
    
<cfelseif isdefined("attributes.announce_id") and len(attributes.announce_id)>
	<cfquery name="control" datasource="#DSN#">
		SELECT
				*
		FROM
			TRAINING_CLASS_ANNOUNCE_CLASSES
		WHERE
			CLASS_ID = #attributes.CLASS_ID# AND
			ANNOUNCE_ID = #attributes.announce_id#
	</cfquery>
	<cfif not control.RECORDCOUNT>
		<cfquery name="add_cls" datasource="#DSN#">
			INSERT INTO 
				TRAINING_CLASS_ANNOUNCE_CLASSES
				(
					CLASS_ID,
					ANNOUNCE_ID,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE
				)
			VALUES
				(
					#attributes.CLASS_ID#,
					#attributes.announce_id#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_USER#',
					#NOW()#
				)
		</cfquery>
	</cfif>
</cfif>
<script type="text/javascript">
	window.onbeforeunload = function (e) {
		window.opener.refresh_box('train_group','index.cfm?fuseaction=training_management.train_group_ajax&train_group_id=<cfoutput>#attributes.TRAIN_GROUP_ID#</cfoutput>','0');
	};
    window.close();
</script>