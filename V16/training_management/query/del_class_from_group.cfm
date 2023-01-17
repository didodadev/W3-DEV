<cfif isdefined("attributes.class_group_id") and len(attributes.class_group_id)>
	<cfquery name="del_cls" datasource="#DSN#">
		DELETE
		FROM
			TRAINING_CLASS_GROUP_CLASSES
		WHERE
			CLASS_GROUP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_group_id#">
	</cfquery>
	<cfquery name="add_cls" datasource="#DSN#">
		INSERT INTO TRAINING_GROUP_CLASS_DELETE
		(
			<cfif isDefined("attributes.reason") and len(attributes.reason)>
				REASON,
			</cfif>
			TRAINING_GROUP_ID,
			DELETED_BY_EMP_ID,
			CLASS_ID,
			DELETED_DATE,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
		VALUES
		(
			<cfif isDefined("attributes.reason") and len(attributes.reason)>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.reason#">,
			<cfelse>
				NULL,
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">,
			<cfif isDefined("attributes.deleted_by_emp_id") and len(attributes.deleted_by_emp_id)>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.deleted_by_emp_id#">,
			<cfelse>
				#session.ep.userid#,
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">,
			<cfif isDefined("attributes.deleted_date") and len(attributes.deleted_date)>
				<cfqueryparam cfsqltype="cf_sql_date" value="#attributes.deleted_date#">,
			<cfelse>
				#now()#,
			</cfif>
			#session.ep.userid#,
            '#cgi.REMOTE_ADDR#',
			#now()#
		)
	</cfquery>
    <cfquery name="upd_training_group_attenders" datasource="#dsn#">
        UPDATE
            TRAINING_GROUP_CLASS_ATTENDANCE
        SET
            STATUS = 0
        WHERE
            TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
            AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
    </cfquery>
<cfelseif isdefined("attributes.announce_class_id") and len(attributes.announce_class_id)>
	<cfquery name="get_req_emp" datasource="#dsn#">
		SELECT
			EMPLOYEE_ID
		FROM
			TRAINING_REQUEST_ROWS
		WHERE
			ANNOUNCE_ID IN (SELECT ANNOUNCE_ID FROM TRAINING_CLASS_ANNOUNCE_CLASSES WHERE ANNOUNCE_CLASS_ID=#attributes.announce_class_id#)
	</cfquery>
	<cfif get_req_emp.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='495.Eğitim Talep Edilmiş Silemezsiniz'>!");
			window.close();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="add_cls" datasource="#DSN#">
		DELETE
		FROM
			TRAINING_CLASS_ANNOUNCE_CLASSES
		WHERE
			ANNOUNCE_CLASS_ID=#attributes.announce_class_id#
	</cfquery>
</cfif>
<script>
	window.opener.document.getElementById("training_groups").click();
	window.close();
</script>