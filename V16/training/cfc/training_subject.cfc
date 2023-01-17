<cfcomponent>
<cffunction name="get_training_fnc" returntype="query">
	<cfargument name="train_id" default="">
    <cfquery name="get_training_subject" datasource="#this.dsn#">
		SELECT 
			T.TRAIN_HEAD,
			T.TRAIN_DETAIL,
			T.TRAIN_OBJECTIVE,
			TC.TRAINING_CAT,
			TS.SECTION_NAME,
			T.RECORD_DATE,
			T.RECORD_EMP,
			T.UPDATE_DATE,
			T.UPDATE_EMP
		FROM 
			TRAINING T LEFT JOIN TRAINING_CAT TC
			ON T.TRAINING_CAT_ID = TC.TRAINING_CAT_ID
			LEFT JOIN TRAINING_SEC TS 
			ON T.TRAINING_SEC_ID = TS.TRAINING_SEC_ID  	
		WHERE	
			T.TRAIN_ID IS NOT NULL
			<cfif isdefined("arguments.train_id") and len (arguments.train_id)>
			AND T.TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_id#">
			</cfif>
    </cfquery>
    <cfreturn get_training_subject>
</cffunction>
</cfcomponent>
