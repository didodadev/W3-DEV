<cfquery name="get_training_names" datasource="#dsn#">
	SELECT 
		TRAIN_ID, 
		TRAIN_HEAD
	FROM 
		TRAINING
	WHERE
	<!--- PARTNER DA UYARLA --->
		TRAIN_DEPARTMENTS IS NOT NULL
		<cfif isDefined("attributes.TRAINING_SEC_ID") and (attributes.TRAINING_SEC_ID NEQ 0)>
			AND TRAINING_SEC_ID = #attributes.TRAINING_SEC_ID#
		</cfif>
	ORDER BY
		TRAIN_HEAD
</cfquery>
