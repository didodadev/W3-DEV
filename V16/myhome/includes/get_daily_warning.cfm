<!--- bu sayfanin aynisi myhome include icindede var orayi da lutfen update ediniz...  --->
<cfif not isdefined("attributes.TO_DAY")>
	<cfset attributes.TO_DAY=date_add('h',session.ep.time_zone,now())>
</cfif>
<cfif isdefined("session.agenda_userid")>
<!--- başkasında --->
	<cfif session.agenda_user_type is "p">
	<!--- par --->
		<cfquery name="GET_GRPS" datasource="#dsn#">
			SELECT GROUP_ID FROM USERS WHERE PARTNERS LIKE '%,#SESSION.AGENDA_USERID#,%'
		</cfquery>
	<cfelseif session.agenda_user_type is "e">
	<!--- emp --->
		<cfquery name="GET_GRPS" datasource="#dsn#">
			SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE '%,#SESSION.AGENDA_POSITION_CODE#,%'
		</cfquery>
	</cfif>
<cfelse>
<!--- kendinde --->
	<cfquery name="GET_GRPS" datasource="#dsn#">
		SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE '%,#SESSION.EP.POSITION_CODE#,%'
	</cfquery>
</cfif>

<cfset grps = valuelist(get_grps.group_id)>
<cfquery name="GET_DAILY_WARNINGS" datasource="#dsn#">
	SELECT 
		EVENT_ID,
		STARTDATE,
		WARNING_START,
		EVENTCAT,
		VALID,
		VALIDATOR_POSITION_CODE,
		EVENT.RECORD_EMP,
		EVENT.UPDATE_EMP,
		RECORD_PAR,
		UPDATE_PAR,
		EVENT_HEAD
	FROM 
		EVENT,
		EVENT_CAT
	WHERE
		EVENT_CAT.EVENTCAT_ID = EVENT.EVENTCAT_ID AND
		WARNING_START <= #attributes.TO_DAY# AND
		STARTDATE > #attributes.TO_DAY# AND
		(
		<cfif isDefined("SESSION.AGENDA_USERID")>
		<!--- BAŞKASİNDA --->
			<cfif SESSION.AGENDA_USER_TYPE IS "P">
			<!--- PAR --->
			(
				(RECORD_PAR = #SESSION.AGENDA_USERID# OR UPDATE_PAR = #SESSION.AGENDA_USERID#)
				AND EVENT_CAT.EVENTCAT_ID <> 1
			)
			OR EVENT_TO_PAR LIKE '%,#SESSION.AGENDA_USERID#,%'
			OR EVENT_CC_PAR LIKE '%,#SESSION.AGENDA_USERID#,%'
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR EVENT_TO_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR EVENT_CC_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			<cfelseif SESSION.AGENDA_USER_TYPE IS "E">
			<!--- EMP --->
			(
				(EVENT.RECORD_EMP = #SESSION.AGENDA_USERID# OR EVENT.UPDATE_EMP = #SESSION.AGENDA_USERID#) AND
				EVENT_CAT.EVENTCAT_ID <> 1
			)
			OR EVENT_TO_POS LIKE '%,#SESSION.AGENDA_POSITION_CODE#,%'
			OR EVENT_CC_POS LIKE '%,#SESSION.AGENDA_POSITION_CODE#,%'
			OR VALIDATOR_POSITION_CODE = #SESSION.AGENDA_POSITION_CODE#
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR
				EVENT_TO_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR
				EVENT_CC_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			</cfif>
		<cfelse>
		<!--- KENDINDE --->
			EVENT.RECORD_EMP = #SESSION.EP.USERID# OR
			EVENT.UPDATE_EMP = #SESSION.EP.USERID# OR
			EVENT_TO_POS LIKE '%,#SESSION.EP.POSITION_CODE#,%' OR
			EVENT_CC_POS LIKE '%,#SESSION.EP.POSITION_CODE#,%' OR
			VALIDATOR_POSITION_CODE = #SESSION.EP.POSITION_CODE#
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR EVENT_TO_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR EVENT_CC_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
		</cfif>
		OR
		VIEW_TO_ALL=1
		)
</cfquery>
