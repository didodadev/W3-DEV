<cfquery name="GET_CLASS_EVAL" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_CLASS_EVAL
	WHERE
		CLASS_ID IS NOT NULL
	<cfif isDefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>
		AND CLASS_ID = #attributes.CLASS_ID#
	</cfif>
</cfquery>
