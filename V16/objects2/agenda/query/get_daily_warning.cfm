<cfif not isdefined("attributes.to_day")>
	<cfset attributes.to_day=date_add('h',session.pp.time_zone,now())>
</cfif>
<cfquery name="GET_DAILY_WARNINGS" datasource="#DSN#">
	SELECT 
		EVENT_ID,
		STARTDATE,
		WARNING_START,
		EVENTCAT,
		VALID,
		VALID_EMP,
		EVENT.RECORD_EMP,
		EVENT.UPDATE_EMP,
		RECORD_PAR,
		UPDATE_PAR,
		EVENT_HEAD,
		EVENT_PLACE_ID
	FROM 
		EVENT,
		EVENT_CAT
	WHERE
		WARNING_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#"> AND
		STARTDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.to_day#"> AND
		EVENT_CAT.EVENTCAT_ID = EVENT.EVENTCAT_ID AND
		(
			<cfif isDefined("session.agenda_userid")>
            <!--- baskasinda --->
                <cfif session.agenda_user_type is "p">
                    <!--- par --->
                    (
                        EVENT_CAT.EVENTCAT_ID <> 1 AND
                        ( RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#"> OR UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#"> )
                    ) OR
                    EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_userid#,%"> OR
                    EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_userid#,%">
                <cfelseif session.agenda_user_type is "e">
                    (
                        EVENT_CAT.EVENTCAT_ID <> 1 AND
                        ( 
                        	EVENT.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#"> OR 
                            EVENT.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#"> 
                   		)
                    ) OR
                    EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_userid#,%"> OR
                    EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_userid#,%"> OR
                    VALID_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#">
                </cfif>
            <cfelseif isdefined('session.pp.userid')>
                EVENT.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
                EVENT.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
                EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.userid#,%"> OR
                EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.userid#,%"> OR
                VALID_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
			<cfelse>
				1=1
            </cfif>
		)
</cfquery>
