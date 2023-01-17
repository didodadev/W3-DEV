<!--- pozisyonu boşalt --->
<cfquery name="UPD_EMP_OLD_POS" datasource="#dsn#">
	UPDATE
		EMPLOYEE_POSITIONS
	SET
		EMPLOYEE_ID=0,
		EMPLOYEE_NAME=NULL,
		EMPLOYEE_SURNAME=NULL,
		EMPLOYEE_EMAIL=NULL,
		POSITION_STATUS=1,
		VALID=NULL,
		VALID_DATE=NULL,
		VALID_MEMBER=NULL,
		HIERARCHY=NULL,
		UPDATE_EMP=#SESSION.EP.USERID#,
		UPDATE_IP='#CGI.REMOTE_ADDR#',
		UPDATE_DATE=#now()#,
		EHESAP=<cfif isdefined("attributes.ehesap")>1<cfelse>0</cfif>		
	WHERE
		POSITION_ID=#free_position_id#
</cfquery>

<cfquery name="GET_OLD_HIST_ROW" datasource="#dsn#">
	SELECT 
		MAX(HISTORY_ID) AS H_ID
	FROM
		EMPLOYEE_POSITIONS_HISTORY
	WHERE
		POSITION_ID=#free_position_id#
</cfquery>

<cfif IsNumeric(GET_OLD_HIST_ROW.H_ID)>
	<cfquery name="UPD_OLD_HIST_ROW" datasource="#dsn#">
		UPDATE
			EMPLOYEE_POSITIONS_HISTORY
		SET
			FINISH_DATE=#NOW()#
		WHERE
			HISTORY_ID=#GET_OLD_HIST_ROW.H_ID#
	</cfquery>
</cfif>

<cfset history_position_id = free_position_id>
<cfinclude template="add_position_history.cfm">

