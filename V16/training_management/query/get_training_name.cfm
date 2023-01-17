<cfquery name="GET_TRAINING_NAME" datasource="#dsn#">
	SELECT 
		TRAIN_HEAD,
		TRAIN_ID
	FROM 
		TRAINING
	<cfif isdefined('attributes.training_id') and len(attributes.training_id)>
	WHERE 
		TRAIN_ID = #attributes.TRAINING_ID#
	</cfif>
</cfquery>
