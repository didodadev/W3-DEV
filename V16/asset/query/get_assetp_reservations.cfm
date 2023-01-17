<cfif isDefined("STARTDATE")and len(startdate)>
	<CF_DATE TARIH="STARTDATE">
</cfif>

<cfif isDefined("FINISHDATE")and len(finishdate)>
	<CF_DATE TARIH="FINISHDATE">
</cfif>

<cfquery name="ASSETP_RESERVATIONS" datasource="#dsn#">
	SELECT 
		ASSET_P_RESERVE.EVENT_ID,
		ASSET_P_RESERVE.ASSETP_RESID,
		ASSET_P_RESERVE.STARTDATE,
		ASSET_P_RESERVE.FINISHDATE
	FROM 
		ASSET_P,
		ASSET_P_RESERVE
	WHERE
		ASSET_P.ASSETP_ID = #attributes.ASSETP_ID#
		AND
		ASSET_P.ASSETP_ID = ASSET_P_RESERVE.ASSETP_ID
	<cfif not isDefined("FORM.FIELDNAMES")>
		AND
		(
			ASSET_P_RESERVE.STARTDATE <= #now()#
			AND
			ASSET_P_RESERVE.FINISHDATE >= #now()#
		)
	<cfelse>
		<cfif (STARTDATE IS "") AND len(FINISHDATE)>
		AND
		(
			(
				STARTDATE < #FINISHDATE#
				AND
				FINISHDATE >= #FINISHDATE#
			)
			OR
			FINISHDATE <= #FINISHDATE#
		)
		<cfelseif len(STARTDATE) AND (FINISHDATE IS "")>
		AND
		(
			(
				STARTDATE < #STARTDATE#
				AND
				FINISHDATE >= #STARTDATE#
			)
			OR
			STARTDATE >= #STARTDATE#
		)
		<cfelseif len(STARTDATE) AND len(FINISHDATE)>
		AND
		(
			(
				STARTDATE < #STARTDATE#
				AND
				FINISHDATE >= #STARTDATE#
			)
			OR
			(
				STARTDATE = #STARTDATE#
			)
			OR
			(
				STARTDATE > #STARTDATE#
				AND
				STARTDATE <= #FINISHDATE#
			)
		)
		</cfif>
	</cfif>
</cfquery>
