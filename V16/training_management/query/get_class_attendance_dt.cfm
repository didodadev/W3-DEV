<cfquery name="GET_CLASS_ATTENDANCE_DT" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_CLASS_ATTENDANCE_DT
	WHERE
		CLASS_ATTENDANCE_ID IS NOT NULL
	<cfif isDefined("attributes.CLASS_ATTENDANCE_ID") and len(attributes.CLASS_ATTENDANCE_ID)>
		AND CLASS_ATTENDANCE_ID = #attributes.CLASS_ATTENDANCE_ID#
	</cfif>
</cfquery>
