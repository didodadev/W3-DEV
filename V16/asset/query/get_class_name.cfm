<cfquery name="get_class_names" datasource="#dsn#">
	SELECT
		CLASS_NAME
	FROM
		TRAINING_CLASS
	WHERE
		CLASS_ID = #attributes.CLASS_ID#
</cfquery>
