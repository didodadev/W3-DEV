<cfquery name="GET_TRAINING_SEC_NAMES" datasource="#DSN#">/* cfc'ye taşındı file_name:TrainingTest:cfc */
	SELECT
		TRAINING_CAT.TRAINING_CAT_ID,
		TRAINING_SEC.TRAINING_SEC_ID,
		TRAINING_SEC.SECTION_NAME,
		TRAINING_CAT.TRAINING_CAT
	FROM
		TRAINING_SEC,
		TRAINING_CAT
	WHERE
		TRAINING_SEC.TRAINING_CAT_ID = TRAINING_CAT.TRAINING_CAT_ID
		<cfif isdefined("attributes.sec_id") and len(attributes.sec_id)>
            AND TRAINING_SEC.TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sec_id#">
        </cfif>
	ORDER BY
		TRAINING_CAT.TRAINING_CAT,
		TRAINING_SEC.SECTION_NAME
</cfquery>

