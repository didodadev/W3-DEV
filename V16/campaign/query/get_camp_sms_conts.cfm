<cfquery name="CAMP_SMS_CONTS" datasource="#DSN3#">
	SELECT
		SMS_CONT_ID,
		SMS_BODY,
		SMS_HEAD,
		IS_SENT,
		SENDED_TARGET_MASS
	FROM
		CAMPAIGN_SMS_CONT
	WHERE
		CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CAMP_ID#">
</cfquery>	
	

