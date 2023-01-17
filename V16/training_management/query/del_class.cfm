<cflock timeout="60">
	<cftransaction>
	<cfquery name="get_process" datasource="#dsn#">
		SELECT PROCESS_STAGE FROM TRAINING_CLASS WHERE CLASS_ID = #attributes.CLASS_ID#
	</cfquery>
	<cfquery name="DEL_CLASS" datasource="#DSN#">
		DELETE FROM
			TRAINING_CLASS
		WHERE
			CLASS_ID = #attributes.CLASS_ID#
	</cfquery>
	<cfquery name="DEL_CLASS_ATTENDERS" datasource="#DSN#">
		DELETE FROM
			TRAINING_CLASS_ATTENDER
		WHERE
			CLASS_ID = #attributes.CLASS_ID#
	</cfquery>
	<cfquery name="del_class_from_group" datasource="#dsn#">
		DELETE FROM
			TRAINING_CLASS_GROUP_CLASSES
		WHERE
			CLASS_ID=#attributes.CLASS_ID#
	</cfquery>
	<cf_add_log  log_type="-1" action_id="#attributes.class_id#" action_name="#attributes.class_name#" process_stage="#get_process.process_stage#">
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=training_management.list_class" addtoken="no">
