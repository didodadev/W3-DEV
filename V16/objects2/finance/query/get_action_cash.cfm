<cfquery name="GET_ACTION_CASH" datasource="#db_adres#">
	SELECT
		CASH_NAME
	FROM
		CASH
		<cfif isDefined("cash_id") and len(cash_id)>
            WHERE	
                CASH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cash_id#">
        </cfif>
</cfquery>
