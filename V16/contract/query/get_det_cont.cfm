<cfquery name="GET_DET_CONT" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
	<!--- CONTRACT --->
		RELATED_CONTRACT 
	WHERE 
		CONTRACT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contract_id#">
</cfquery>
<cfset CAT_ID = GET_DET_CONT.CONTRACT_CAT_ID>
<cfset REC_EMP = GET_DET_CONT.RECORD_EMP>

