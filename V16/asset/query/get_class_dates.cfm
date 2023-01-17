<cfquery name="get_class_dates" datasource="#dsn#">
	SELECT
		START_DATE,
		FINISH_DATE
	FROM
		TRAINING_CLASS
	WHERE
		CLASS_ID = #attributes.CLASS_ID#
</cfquery>
