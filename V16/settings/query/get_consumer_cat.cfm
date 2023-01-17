<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT 
		IS_ACTIVE,
        #dsn#.Get_Dynamic_Language(CONSCAT_ID,'#session.ep.language#','CONSUMER_CAT','CONSCAT',NULL,NULL,CONSCAT) AS CONSCAT,
        POSITION_CODE,
        SHORT_NAME,
        HIERARCHY,
        MIN_CONSCAT_ID,
        MAX_CONSCAT_ID,
        IS_INTERNET,
        RISK_LIMIT,
        IS_PREMIUM,
        IS_REF_ORDER,
        IS_REF_RECORD,
        IS_DEFAULT,
        IS_INTERNET_DENIED,
        RECORD_EMP,
        RECORD_DATE,
        UPDATE_EMP,
        UPDATE_DATE   
	FROM 
		CONSUMER_CAT
	WHERE
		CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfquery name="GET_CONS_CATEGORY" datasource="#DSN#" maxrows="1">
	SELECT
		CONSUMER_CAT_ID
	FROM
		CONSUMER
	WHERE	
		CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
