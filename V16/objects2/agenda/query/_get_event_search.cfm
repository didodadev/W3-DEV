<cfif isDefined("SESSION.AGENDA_USERID")>
<!--- BAŞKASıNDA --->
	<cfif SESSION.AGENDA_USER_TYPE IS "P">
	<!--- PAR --->
		<cfquery name="GET_GRPS" datasource="#dsn#">
			SELECT
				GROUP_ID
			FROM
				USERS
			WHERE
				PARTNERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#SESSION.AGENDA_USERID#,%">
		</cfquery>
	<cfelseif SESSION.AGENDA_USER_TYPE IS "E">
	<!--- EMP --->
		<cfquery name="GET_GRPS" datasource="#dsn#">
			SELECT
				GROUP_ID
			FROM
				USERS
			WHERE
				POSITIONS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#SESSION.AGENDA_POSITION_CODE#,%">
		</cfquery>

	</cfif>
<cfelse>
<!--- KENDINDE --->
	<cfquery name="GET_GRPS" datasource="#dsn#">
		SELECT
			GROUP_ID
		FROM
			USERS
		WHERE
			PARTNERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#SESSION.PP.USERID#,%">
	</cfquery>

</cfif>

<cfset GRPS = VALUELIST(GET_GRPS.GROUP_ID)>

<cfif isdefined("STARTDATE") and len(STARTDATE)>
	<CF_DATE TARIH="STARTDATE">
</cfif>

<cfif isdefined("FINISHDATE") and len(FINISHDATE)>
	<CF_DATE TARIH="FINISHDATE">
</cfif>

<cfquery name="GET_EVENT_SEARCH" datasource="#dsn#">
	SELECT 
		EVENT_ID,
		STARTDATE,
		FINISHDATE,
		EVENTCAT,
		EVENT_HEAD
	FROM 
		EVENT,
		EVENT_CAT
	WHERE
		EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		EVENT.EVENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
		<cfif isdefined("EVENTCAT_ID") and EVENTCAT_ID neq 0>
		AND
		EVENT.EVENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EVENTCAT_ID#">
		</cfif>
		<cfif isdefined("STARTDATE") and len(STARTDATE) and isdefined("FINISHDATE") and len(FINISHDATE)>
		AND
		(
			(
			STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#STARTDATE#">
			AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#STARTDATE#">
			)
			OR
			(
			STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#STARTDATE#">
			AND STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FINISHDATE#">
			)
		)
		</cfif>
		
		<cfif isdefined("STARTDATE") and (STARTDATE is "") and isdefined("FINISHDATE") and len(FINISHDATE)>
			AND STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FINISHDATE#">
		</cfif>
		<cfif isdefined("STARTDATE") and  len(STARTDATE) and isdefined("FINISHDATE") and (FINISHDATE is "")>
			AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#STARTDATE#">
		</cfif>
		AND 
		(
		<cfif isDefined("SESSION.AGENDA_USERID")>
		<!--- BAŞKASİNDA --->
			<cfif SESSION.AGENDA_USER_TYPE is "P">
			<!--- PAR --->
			(
				(
				RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.AGENDA_USERID#">
				OR UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.AGENDA_USERID#">
				)
				AND EVENT_CAT.EVENT_CAT.EVENTCAT_ID <> 1
			)
			OR EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#SESSION.AGENDA_USERID#,%">
			OR EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#SESSION.AGENDA_USERID#,%">
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR EVENT_TO_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
			</cfloop>
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR EVENT_CC_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
			</cfloop>

			<cfelseif SESSION.AGENDA_USER_TYPE is "E">
			<!--- EMP --->
			(
				(
				RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.AGENDA_USERID#">
				OR UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.AGENDA_USERID#">
				)
				AND EVENT_CAT.EVENTCAT_ID <> 1
			)
			OR EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#SESSION.AGENDA_POSITION_CODE#,%">
			OR EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#SESSION.AGENDA_POSITION_CODE#,%">
			OR VALIDATOR_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.AGENDA_POSITION_CODE#">
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR EVENT_TO_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
			</cfloop>
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR EVENT_CC_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
			</cfloop>
			</cfif>
		<cfelse>
		<!--- KENDINDE --->
			RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.PP.USERID#">
			OR UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.PP.USERID#">
			OR EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#SESSION.PP.USERID#,%">
			OR EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#SESSION.PP.USERID#,%">
			OR VALIDATOR_PAR = #SESSION.PP.USERID#
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR EVENT_TO_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
			</cfloop>
			<cfloop LIST="#GRPS#" INDEX="GRP_I">
				OR EVENT_CC_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
			</cfloop>
		</cfif>
		OR VIEW_TO_ALL=1
		)
</cfquery>
