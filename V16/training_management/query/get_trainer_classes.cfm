<cfif IsDefined("attributes.START_DATE")>
    <cf_date tarih="attributes.START_DATE">
</cfif>
<cfif isDefined("attributes.employee_id") or  isDefined("attributes.partner_id") or isDefined("attributes.consumer_id")>
	<cfquery name="get_trainer_classes" datasource="#dsn#">
		SELECT
			TC.CLASS_ID,
			TC.CLASS_NAME
		FROM
			TRAINING_CLASS_TRAINERS TCT INNER JOIN TRAINING_CLASS TC 
			ON TCT.CLASS_ID = TC.CLASS_ID
		WHERE
			1 = 1
			<cfif isDefined("attributes.employee_id")>
				AND TCT.EMP_ID = #attributes.employee_id#
			<cfelseif isDefined("attributes.partner_id")>
				AND TCT.PAR_ID = #attributes.partner_id#
			<cfelseif isDefined("attributes.consumer_id")>
				AND TCT.CONS_ID = #attributes.consumer_id#
			</cfif>
			<cfif IsDefined("attributes.START_DATE")>
				AND TC.START_DATE >= #attributes.START_DATE#
			</cfif>
		ORDER BY
			TC.CLASS_NAME
	</cfquery>	
	<!--- <cfquery name="get_trainer_classes" datasource="#dsn#">
		SELECT
			*
		FROM
			TRAINING_CLASS
		WHERE
			1 = 1
			<cfif isDefined("attributes.employee_id")>
		AND
			TRAINER_EMP = #attributes.employee_id#
			<cfelseif isDefined("attributes.partner_id")>
		AND
			TRAINER_PAR = #attributes.partner_id#
			<cfelseif isDefined("attributes.consumer_id")>
		AND
			TRAINER_CONS = #attributes.consumer_id#
			</cfif>
			<cfif IsDefined("attributes.START_DATE")>
		AND
			TRAINING_CLASS.START_DATE >= #attributes.START_DATE#
			</cfif>
		ORDER BY
			CLASS_NAME
	</cfquery> --->
<cfelse>
	<cfset get_trainer_classes.recordcount = 0>
</cfif>
