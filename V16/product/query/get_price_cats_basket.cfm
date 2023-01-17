<cfquery name="PRICE_CATS" datasource="#dsn3#">
	SELECT
		PRICE_CATID,
		PRICE_CAT
	FROM
		PRICE_CAT
	WHERE
		PRICE_CAT_STATUS = 1
	<cfif session.ep.isBranchAuthorization>
		AND
			PRICE_CAT.BRANCH LIKE '%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%'
	</cfif>
	ORDER BY
		PRICE_CAT
</cfquery>
