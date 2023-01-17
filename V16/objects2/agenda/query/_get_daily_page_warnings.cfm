<cfquery name="GET_DAILY_PAGE_WARNINGS" datasource="#dsn#">
	SELECT 
		W_ID,
		SMS_WARNING_DATE,
		EMAIL_WARNING_DATE,
		WARNING_HEAD
	FROM 
		PAGE_WARNINGS
	WHERE
		(
			(
			SMS_WARNING_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.TO_DAY#">
			AND
			SMS_WARNING_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.TO_DAY)#">
			)
			OR
			(
			EMAIL_WARNING_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.TO_DAY#">
			AND
			EMAIL_WARNING_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.TO_DAY)#">
			)
		)
		AND
		(
		<cfif isDefined("SESSION.AGENDA_USERID")>
		<!--- BAŞKASINDA --->
			<cfif SESSION.AGENDA_USER_TYPE IS "E">
			<!--- EMP --->
			<!---RECORD_EMP = #SESSION.AGENDA_USERID#
			OR--->
			POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.AGENDA_POSITION_CODE#">
			<cfelseif SESSION.AGENDA_USER_TYPE IS "P">
			<!---RECORD_PAR = #SESSION.AGENDA_USERID#
			OR--->
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.AGENDA_USERID#">
			</cfif>
		<cfelse>
		<!--- KENDINDE --->
			<!---RECORD_PAR = #SESSION.PP.USERID#
			OR--->
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.PP.USERID#">
		</cfif>
		)
</cfquery>
