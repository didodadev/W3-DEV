<cfquery name="get_finished_in_class_no" datasource="#dsn#">
	SELECT
		COUNT(DISTINCT CLASS_ID) AS IN_CLASS_NO
	FROM
		TRAINING_CLASS_ATTENDANCE
</cfquery>

<cfquery name="get_finished_ex_class_no" datasource="#dsn#">
	SELECT
		COUNT(DISTINCT EX_CLASS_ID) AS EX_CLASS_NO
	FROM
		TRAINING_EX_CLASS
</cfquery>

<cfset finished_class_no = get_finished_in_class_no.IN_CLASS_NO + get_finished_ex_class_no.EX_CLASS_NO>
