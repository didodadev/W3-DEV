<cflock name="#CREATEUUID()#" timeout="30">
	<cftransaction>
		<cfquery name="DEL_TRAINING_REQUESTS" datasource="#dsn#">
			DELETE FROM TRAINING_REQUEST_ROWS WHERE TRAIN_REQUEST_ID=#attributes.train_req_id#
		</cfquery>
		<cfquery name="DEL_TRAINING_REQUESTS" datasource="#dsn#">
			DELETE FROM	TRAINING_REQUEST WHERE TRAIN_REQUEST_ID=#attributes.train_req_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=training.list_class_request" addtoken="no">
