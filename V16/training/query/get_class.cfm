<cfquery name="get_class" datasource="#dsn#">
	SELECT 
		TC.*
	FROM
		TRAINING_CLASS TC
	WHERE
		TC.CLASS_ID IS NOT NULL AND
		TC.CLASS_ID = #attributes.class_id#
</cfquery>
<!---
<cfquery name="get_class" datasource="#dsn#">
	SELECT 
		TC.*
	FROM
		TRAINING_CLASS TC,
		TRAINING_CLASS_ATTENDER TCA
	WHERE
		TC.CLASS_ID IS NOT NULL
		AND TCA.CLASS_ID = TC.CLASS_ID
		<cfif not isdefined("attributes.class_id") and isdefined('session.ep')>
			AND TCA.EMP_ID = #session.ep.userid#
		<cfelseif not isdefined("attributes.class_id") and isdefined('session.pp')>
			AND TCA.PAR_ID = #session.pp.userid# OR
		</cfif>
		<cfif isdefined("attributes.class_id")>
			AND TC.CLASS_ID = #attributes.class_id#
		</cfif>
</cfquery>
--->

