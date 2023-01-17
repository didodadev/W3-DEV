<!--- bu dosya myhome da da var. --->
<cfif isdefined("session.agenda_userid")>
<!--- başkasında --->
	<cfif session.agenda_user_type is "p">
	<!--- par --->
		<cfquery name="GET_GRPS" datasource="#dsn#">
			SELECT
				GROUP_ID
			FROM
				USERS
			WHERE
				PARTNERS LIKE '%,#SESSION.AGENDA_USERID#,%'
		</cfquery>

         <cfquery name="get_wrkgroups" datasource="#DSN#">
		   SELECT
			   WORKGROUP_ID
		   FROM
			   WORKGROUP_EMP_PAR
		   WHERE
			   PARTNER_ID = #SESSION.AGENDA_USERID#	
		</cfquery>
	<cfelseif session.agenda_user_type is "e">
	<!--- emp --->
		<cfquery name="GET_GRPS" datasource="#dsn#">
			SELECT
				GROUP_ID
			FROM
				USERS
			WHERE
				POSITIONS LIKE '%,#SESSION.AGENDA_POSITION_CODE#,%'
		</cfquery>
		<cfquery name="get_wrkgroups" datasource="#dsn#">
             SELECT
			   WORKGROUP_ID
			 FROM
			    WORKGROUP_EMP_PAR
			 WHERE
			    POSITION_CODE = #SESSION.AGENDA_POSITION_CODE#		  
		</cfquery>

	</cfif>
<cfelse>
<!--- kendinde --->
	<cfquery name="GET_GRPS" datasource="#dsn#">
		SELECT
			GROUP_ID
		FROM
			USERS
		WHERE
			POSITIONS LIKE '%,#SESSION.EP.POSITION_CODE#,%'
	</cfquery>
	<cfquery name="get_wrkgroups" datasource="#dsn#">
         SELECT
			WORKGROUP_ID
		 FROM
	        WORKGROUP_EMP_PAR
		 WHERE
		    POSITION_CODE = #SESSION.EP.POSITION_CODE#		  
	</cfquery>

</cfif>

<cfset grps = valuelist(get_grps.group_id)>
<cfset wrkgroups = valuelist(get_wrkgroups.WORKGROUP_ID)>

<cfquery name="GET_DAILY_EVENTS" datasource="#dsn#">
	SELECT 
		EVENT_ID,
		STARTDATE,
		FINISHDATE,
		EVENTCAT,
		VALID,
		VALIDATOR_POSITION_CODE,
		RECORD_EMP,
		UPDATE_EMP,
		RECORD_PAR,
		UPDATE_PAR,
		EVENT_HEAD
	FROM 
		EVENT,
		EVENT_CAT
	WHERE
		EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID
		AND
		(
			(
				STARTDATE >= #attributes.TO_DAY# AND
				STARTDATE < #DATEADD('D',1,attributes.TO_DAY)#
			)
			OR
			(
				FINISHDATE >= #attributes.TO_DAY# AND
				FINISHDATE < #DATEADD('D',1,attributes.TO_DAY)#
			)
		) 
		AND 
		(
		<cfif isDefined("SESSION.AGENDA_USERID")>
		<!--- BAŞKASİNDA --->
			<cfif SESSION.AGENDA_USER_TYPE IS "P">
			<!--- PAR --->
			(
				(
				RECORD_PAR = #SESSION.AGENDA_USERID#
				OR
				UPDATE_PAR = #SESSION.AGENDA_USERID#
				)
				AND
				EVENT_CAT.EVENT_CAT.EVENTCAT_ID <> 1
			)
			OR
			EVENT_TO_PAR LIKE '%,#SESSION.AGENDA_USERID#,%'
			OR
			EVENT_CC_PAR LIKE '%,#SESSION.AGENDA_USERID#,%'
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR
				EVENT_TO_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR
				EVENT_CC_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			<cfloop list="#wrkgroups#" index="WRK">
			   OR
			   EVENT_TO_WRKGROUP LIKE '%,#WRK#,%'
			</cfloop>
			<cfloop list="#wrkgroups#" index="WRK">
			  OR
			   EVENT_CC_WRKGROUP LIKE '%,#WRK#,%'
			</cfloop>

			<cfelseif SESSION.AGENDA_USER_TYPE IS "E">
			<!--- EMP --->
			(
				(
				RECORD_EMP = #SESSION.AGENDA_USERID#
				OR
				UPDATE_EMP = #SESSION.AGENDA_USERID#
				)
				AND
				EVENT_CAT.EVENTCAT_ID <> 1
			)
			OR
			EVENT_TO_POS LIKE '%,#SESSION.AGENDA_POSITION_CODE#,%'
			OR
			EVENT_CC_POS LIKE '%,#SESSION.AGENDA_POSITION_CODE#,%'
			OR
			VALIDATOR_POSITION_CODE = #SESSION.AGENDA_POSITION_CODE#
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR
				EVENT_TO_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR
				EVENT_CC_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			<cfloop list="#wrkgroups#" index="WRK">
			   OR
			   EVENT_TO_WRKGROUP LIKE '%,#WRK#,%'
			</cfloop>
			<cfloop list="#wrkgroups#" index="WRK">
			  OR
			   EVENT_CC_WRKGROUP LIKE '%,#WRK#,%'
			</cfloop>
			</cfif>
		<cfelse>
		<!--- KENDINDE --->
			RECORD_EMP = #SESSION.EP.USERID#
			OR
			UPDATE_EMP = #SESSION.EP.USERID#
			OR
			EVENT_TO_POS LIKE '%,#SESSION.EP.POSITION_CODE#,%'
			OR
			EVENT_CC_POS LIKE '%,#SESSION.EP.POSITION_CODE#,%'
			OR
			VALIDATOR_POSITION_CODE = #SESSION.EP.POSITION_CODE#
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR
				EVENT_TO_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR
				EVENT_CC_GRP LIKE '%,#GRP_I#,%'
			</cfloop>
			<cfloop list="#wrkgroups#" index="WRK">
			   OR
			   EVENT_TO_WRKGROUP LIKE '%,#WRK#,%'
			</cfloop>
			<cfloop list="#wrkgroups#" index="WRK">
			  OR
			   EVENT_CC_WRKGROUP LIKE '%,#WRK#,%'
			</cfloop>
		</cfif>
		OR
		VIEW_TO_ALL=1
		)
</cfquery>

