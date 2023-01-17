<!--- bu sayfanin aynisi myhome include icindede var orayi da lutfen update ediniz...  --->
<cfif not isdefined("attributes.TO_DAY")>
	<cfset attributes.TO_DAY=date_add('h',session.ep.time_zone,now())>
</cfif>
<cfif isdefined("session.agenda_userid")>
	<!--- baskasinda --->
	<cfif session.agenda_user_type is "p">
		<!--- par --->
		<cfquery name="GET_GRPS" datasource="#DSN#">
			SELECT GROUP_ID FROM USERS WHERE PARTNERS LIKE '%,#session.agenda_userid#,%'
		</cfquery>
	<cfelseif session.agenda_user_type is "e">
		<!--- emp --->
		<cfquery name="GET_GRPS" datasource="#DSN#">
			SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE '%,#session.agenda_position_code#,%'
		</cfquery>
	</cfif>
<cfelse>
	<!--- kendinde --->
	<cfquery name="GET_GRPS" datasource="#DSN#">
		SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE '%,#session.ep.position_code#,%'
	</cfquery>
</cfif>

<cfset grps = valuelist(get_grps.group_id)>
<cfquery name="GET_DAILY_WARNINGS" datasource="#DSN#">
	SELECT 
		1 TYPE,
		EVENT_ID,
		EVENT_ID PARENT_EVENT_ID,
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
		WARNING_START <= #attributes.TO_DAY# AND
		STARTDATE > #attributes.TO_DAY# AND
		EVENT_CAT.EVENTCAT_ID = EVENT.EVENTCAT_ID AND
		(
		<cfif isDefined("session.agenda_userid")>
			<!--- baskasinda --->
			<cfif session.agenda_user_type is "p">
				<!--- par --->
				(
					EVENT_CAT.EVENTCAT_ID <> 1 AND
					( RECORD_PAR = #session.agenda_userid# OR UPDATE_PAR = #session.agenda_userid# )
				)
				OR EVENT_TO_PAR LIKE '%,#session.agenda_userid#,%'
				OR EVENT_CC_PAR LIKE '%,#session.agenda_userid#,%'
				<cfloop list="#GRPS#" index="GRP_I">
					OR EVENT_TO_GRP LIKE '%,#GRP_I#,%'
				</cfloop>
				<cfloop list="#GRPS#" index="GRP_I">
					OR EVENT_CC_GRP LIKE '%,#GRP_I#,%'
				</cfloop>
			<cfelseif session.agenda_user_type is "e">
				<!--- emp --->
				(
					EVENT_CAT.EVENTCAT_ID <> 1 AND
					( EVENT.RECORD_EMP = #session.agenda_userid# OR EVENT.UPDATE_EMP = #session.agenda_userid# )
				)
				OR EVENT_TO_POS LIKE '%,#session.agenda_userid#,%'
				OR EVENT_CC_POS LIKE '%,#session.agenda_userid#,%'
				OR VALID_EMP = #session.agenda_userid#
				<cfloop list="#GRPS#" index="GRP_I">
					OR EVENT_TO_GRP LIKE '%,#GRP_I#,%'
				</cfloop>
				<cfloop list="#GRPS#" index="GRP_I">
					OR EVENT_CC_GRP LIKE '%,#GRP_I#,%'
				</cfloop>
			</cfif>
		<cfelse>
			<!--- kendinde --->
			EVENT.RECORD_EMP = #session.ep.userid# OR
			EVENT.UPDATE_EMP = #session.ep.userid# OR
			EVENT_TO_POS LIKE '%,#session.ep.userid#,%' OR
			EVENT_CC_POS LIKE '%,#session.ep.userid#,%' OR
			VALID_EMP = #session.ep.userid#
			<cfloop list="#GRPS#" index="GRP_I">
				OR EVENT_TO_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			<cfloop list="#GRPS#" index="GRP_I">
				OR EVENT_CC_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
		</cfif>
		OR VIEW_TO_ALL=1
		)
		
	UNION ALL
	<!--- FBS 20110127 Popup Uyarilarin Da Ajandada Goster Secenegi ile Gosterilmesi Saglandi --->
	SELECT 
		2 TYPE,
		W_ID EVENT_ID,
		PARENT_ID PARENT_EVENT_ID,
		RECORD_DATE STARTDATE,
		LAST_RESPONSE_DATE WARNING_START,
		'' EVENTCAT,
		'' VALID,
		'' VALID_EMP,
		RECORD_EMP,
		'' UPDATE_EMP,
		RECORD_PAR,
		'' UPDATE_PAR,
		WARNING_HEAD EVENT_HEAD,
		'' EVENT_PLACE_ID
	FROM 
		PAGE_WARNINGS
	WHERE
		IS_AGENDA = 1 AND
		IS_ACTIVE = 1 AND
		LAST_RESPONSE_DATE >= #attributes.TO_DAY# AND
		LAST_RESPONSE_DATE < #DateAdd('d',1,attributes.TO_DAY)# AND
		RECORD_DATE > #attributes.TO_DAY# AND
		(
		<cfif isDefined("session.agenda_userid") and session.agenda_user_type is "e">
			POSITION_CODE IN (SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.agenda_userid#)
		<cfelse>
			POSITION_CODE IN (SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#)
		</cfif>
		)
</cfquery>
