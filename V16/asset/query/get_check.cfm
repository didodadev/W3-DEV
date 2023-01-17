<cfquery name="CHECK_1" datasource="#DSN#">
	SELECT
		*
	FROM
		ASSET_P_RESERVE
	WHERE
		ASSETP_ID = #attributes.ASSETP_ID# AND
		RETURN_DATE BETWEEN #FORM.STARTDATE# AND #FORM.FINISHDATE#
</cfquery>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT
		*
	FROM
		ASSET_P_RESERVE
	WHERE
		ASSETP_ID = #attributes.ASSETP_ID#
		AND
		(
			(
				STARTDATE < #FORM.STARTDATE#
				AND
				FINISHDATE >= #FORM.STARTDATE#
			)
			OR
			(
				STARTDATE = #FORM.STARTDATE#
			)
			OR
			(
				STARTDATE > #FORM.STARTDATE#
				AND
				STARTDATE <= #FORM.FINISHDATE#
			)
		)
	<cfif isDefined("ASSETP_RESID")>
		<cfif len(ASSETP_RESID)>
		AND
		ASSETP_RESID <> #ASSETP_RESID#
		</cfif>
	</cfif>
</cfquery>

