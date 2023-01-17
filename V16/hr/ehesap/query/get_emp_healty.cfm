<cfquery name="get_healty" datasource="#DSN#" >
	SELECT
		EH.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		EMPLOYEE_HEALTY EH,
		EMPLOYEES E
	WHERE
		EH.EMPLOYEE_ID=E.EMPLOYEE_ID AND
		EH.INSPECTION_DATE IS NOT NULL
	<cfif isdefined("attributes.healty_id") and len(attributes.healty_id)>
		AND HEALTY_ID=#attributes.healty_id#
	</cfif>
	<cfif isdefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>
		AND E.EMPLOYEE_ID=#attributes.EMPLOYEE_ID#
	</cfif>
	ORDER BY
		INSPECTION_DATE DESC
</cfquery>
