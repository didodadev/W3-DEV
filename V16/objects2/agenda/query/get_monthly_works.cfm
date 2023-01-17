<cfquery name="MONTHLY_WORKS" datasource="#DSN#">
	SELECT 
		WORK_ID,
		TARGET_START,
		TARGET_FINISH,
		WORK_HEAD,
		PROJECT_ID
	FROM 
		PRO_WORKS
	WHERE
		WORK_CURRENCY_ID <> 3
		AND
		(
			<cfif isDefined("session.agenda_position_code")>
                POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="%,#session.agenda_position_code#,%">
            <cfelse>
                OUTSRC_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
            </cfif> OR
			<cfif isDefined("session.agenda_user_id")>
                RECORD_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#"> OR
                UPDATE_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#">
            <cfelse>
                RECORD_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
                UPDATE_AUTHOR =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
            </cfif>
		)
		AND
		(
		 	(
		 		TARGET_START >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#"> AND
		 		TARGET_START < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd("M",1,attributes.to_day)#">
		 	) OR
		 	(
		 		TARGET_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#"> AND
				TARGET_FINISH < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd("M",1,attributes.to_day)#">
		 	)
		)
</cfquery>
