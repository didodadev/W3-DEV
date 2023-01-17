<cfquery name="get_class_requests" datasource="#dsn#">
	SELECT
		CLASS_NAME,
		START_DATE
	FROM
		TRAINING_CLASS
	WHERE
		CLASS_ID IS NOT NULL
		AND
	<cfif isDefined("attributes.CLASS_ID") AND ListLen(attributes.CLASS_ID)>
		CLASS_ID IN (#attributes.CLASS_ID#)
	</cfif>
	ORDER BY
		START_DATE
</cfquery>
