<!--- onceki history kaydini guncelliyor.  --->
<cfquery name="GET_OLD_HIST_ROW" datasource="#dsn#">
	SELECT 
		MAX(HISTORY_ID) AS H_ID
	FROM
		EMPLOYEE_POSITIONS_HISTORY
	WHERE
	<cfif attributes.fuseaction contains 'popup'>
		POSITION_ID=#url.ID#
	<cfelse>
		POSITION_ID=#attributes.ID#
	</cfif>
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
<cfif attributes.fuseaction contains 'popup'>
	<script type="text/javascript">
		window.close();
	</script>
</cfif>
