<cfquery name="GET_GRPS" datasource="#DSN#">
	SELECT
		GROUP_ID
	FROM
		USERS
	WHERE
		POSITIONS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pda.position_code#,%">
</cfquery>
<cfquery name="GET_WRKGROUPS" datasource="#DSN#">
	 SELECT
	 	WORKGROUP_ID
	 FROM
		WORKGROUP_EMP_PAR
	 WHERE
		POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">		  
</cfquery>

<cfset grps = valuelist(get_grps.group_id)>
<cfset wrkgroups = valuelist(get_wrkgroups.workgroup_id)>

<cfquery name="GET_MONTHLY_EVENTS" datasource="#DSN#">
	SELECT 
		EVENT.EVENT_ID,
		EVENT.STARTDATE,
		EVENT.FINISHDATE,
		EVENT_CAT.EVENTCAT,
		EVENT.VALID,
		EVENT.VALIDATOR_POSITION_CODE,
		EVENT.RECORD_EMP,
		EVENT.UPDATE_EMP,
		EVENT.RECORD_PAR,
		EVENT.UPDATE_PAR,
		EVENT.EVENT_HEAD
	FROM 
		EVENT,
		EVENT_CAT
	WHERE
		EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID AND
		(
			(
				(EVENT.STARTDATE >= #tarih1#)
				AND
				(EVENT.STARTDATE < #tarih2#)
			)
			OR
			(
				(EVENT.FINISHDATE >= #tarih1#)
				AND
				(EVENT.FINISHDATE < #tarih2#)
			)
		) 
		AND 
		(
			EVENT.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#"> OR
			EVENT.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#"> OR
			EVENT.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pda.position_code#,%"> OR
			EVENT.EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pda.position_code#,%"> OR
			EVENT.VALIDATOR_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">
			<cfloop list="#grps#" index="GRP_I">
				OR EVENT.EVENT_TO_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
			</cfloop>
			<cfloop list="#grps#" index="GRP_I">
				OR EVENT.EVENT_CC_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
			</cfloop>
			<cfloop list="#wrkgroups#" index="WRK">
			   	OR EVENT.EVENT_TO_WRKGROUP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#WRK#,%">
			</cfloop>
			<cfloop list="#wrkgroups#" index="WRK">
				OR EVENT.EVENT_CC_WRKGROUP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#WRK#,%">
			</cfloop>	
			OR EVENT.VIEW_TO_ALL=1
		)
		<cfif isdefined('session.pda.agenda_event_cat_id') and len(session.pda.agenda_event_cat_id)>
			AND	EVENT_CAT.EVENTCAT_ID IN (#session.pda.agenda_event_cat_id#)
		</cfif>
		<cfif isdefined('session.pda.agenda_view_only_owned_agenda')>
			AND EVENT.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pda.userid#,%">
		</cfif>
  	ORDER BY 
  		EVENT.STARTDATE
</cfquery>
