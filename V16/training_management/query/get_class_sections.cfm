<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfset GET_CL_SEC = cmp.GET_CL_SEC_F(
   class_id:iif(isDefined("attributes.class_id") and len(attributes.class_id),attributes.class_id,"")
)>
<!--- <cfquery name="GET_CL_SEC" datasource="#DSN#">
	SELECT
		TT.TRAINING_SEC_ID,
		TC.TRAIN_SECTION_ID,
		TT.TRAIN_ID AS TRAINING_ID,
		TRAIN_HEAD
	FROM
		TRAINING_CLASS_SECTIONS TC,
		TRAINING TT
	WHERE
		TT.TRAIN_ID = TC.TRAIN_ID AND
		TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
</cfquery> --->