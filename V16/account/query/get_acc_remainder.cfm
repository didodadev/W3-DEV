<cfquery name="GET_ACC_REMAINDER" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE, 
		SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC) AS BORC,
		SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS ALACAK, 
		SUM(ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_BORC - ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_ALACAK) AS OTHER_BAKIYE, 
		SUM(ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_BORC) AS OTHER_BORC,
		SUM(ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_ALACAK) AS OTHER_ALACAK, 
		ACCOUNT_ACCOUNT_REMAINDER.OTHER_CURRENCY,
		ACCOUNT_PLAN.ACCOUNT_CODE, 
		ACCOUNT_PLAN.ACCOUNT_NAME,
		ACCOUNT_PLAN.ACCOUNT_ID,
		ACCOUNT_PLAN.SUB_ACCOUNT
	FROM
		(
		SELECT
			0 AS ALACAK,
			SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,
			0 AS OTHER_AMOUNT_ALACAK,
			SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0)) AS OTHER_AMOUNT_BORC,
			ISNULL(ACCOUNT_CARD_ROWS.OTHER_CURRENCY,'#session.ep.money#') AS OTHER_CURRENCY,
			ACCOUNT_CARD_ROWS.ACCOUNT_ID		
		FROM
			ACCOUNT_CARD_ROWS,ACCOUNT_CARD
		WHERE
			BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
		<cfif isDefined("attributes.code1") and len(attributes.code1)>
			AND ACCOUNT_CARD_ROWS.ACCOUNT_ID >= '#attributes.code1#'
		</cfif>
		<cfif isDefined("attributes.code2") and len(attributes.code2)>
			AND ACCOUNT_CARD_ROWS.ACCOUNT_ID <= '#attributes.code2#'
		</cfif>
		<cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
			AND  (
				ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#'
				OR ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#.%'
				)
		</cfif>
		<cfif isDefined("attributes.date1") and isdate(attributes.date1) and isDefined("attributes.date2") and isdate(attributes.date2)>
			AND ACTION_DATE BETWEEN #attributes.DATE1# AND #attributes.DATE2#
		</cfif>
			<!--- AND ACTION_DATE > ISNULL(
								(SELECT 
									MAX(ACTION_DATE) ACTION_DATE
								FROM 
									ACCOUNT_CARD_ROWS ACR,
									ACCOUNT_CARD AC 
								WHERE 
									AC.CARD_ID=ACR.CARD_ID
									AND AC.IS_RATE_DIFF=1
									AND ACR.ACCOUNT_ID=ACCOUNT_CARD_ROWS.ACCOUNT_ID),#DATEADD('d',-1,attributes.DATE1)#) --->
		GROUP BY
			ACCOUNT_CARD_ROWS.ACCOUNT_ID,
			ACCOUNT_CARD_ROWS.OTHER_CURRENCY
	UNION
		SELECT
			SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS ALACAK,
			0 AS BORC,
			SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0)) AS OTHER_AMOUNT_ALACAK,
			0 AS OTHER_AMOUNT_BORC,
			ISNULL(ACCOUNT_CARD_ROWS.OTHER_CURRENCY,'#session.ep.money#') AS OTHER_CURRENCY,
			ACCOUNT_CARD_ROWS.ACCOUNT_ID		
		FROM
			ACCOUNT_CARD_ROWS,ACCOUNT_CARD
		WHERE
			BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
		<cfif isDefined("attributes.code1") and len(attributes.code1)>
			AND ACCOUNT_CARD_ROWS.ACCOUNT_ID >= '#attributes.code1#'
		</cfif>
		<cfif isDefined("attributes.code2") and len(attributes.code2)>
			AND ACCOUNT_CARD_ROWS.ACCOUNT_ID <= '#attributes.code2#'
		</cfif>
		<cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
			AND  (
				ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#'
				OR ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#.%'
				)
		</cfif>
		<cfif isDefined("attributes.date1") and isdate(attributes.date1) and isDefined("attributes.date2") and isdate(attributes.date2)>
			AND ACTION_DATE BETWEEN #attributes.DATE1# AND #attributes.DATE2#
		</cfif>
			<!--- AND ACTION_DATE > ISNULL(
								(SELECT 
									MAX(ACTION_DATE) ACTION_DATE
								FROM 
									ACCOUNT_CARD_ROWS ACR,
									ACCOUNT_CARD AC 
								WHERE 
									AC.CARD_ID=ACR.CARD_ID
									AND AC.IS_RATE_DIFF=1
									AND ACR.ACCOUNT_ID=ACCOUNT_CARD_ROWS.ACCOUNT_ID),#DATEADD('d',-1,attributes.DATE1)#) --->
		GROUP BY
			ACCOUNT_CARD_ROWS.ACCOUNT_ID,
			ACCOUNT_CARD_ROWS.OTHER_CURRENCY
		)
		AS ACCOUNT_ACCOUNT_REMAINDER,
		ACCOUNT_PLAN
	WHERE
			1=1
		<cfif isDefined("attributes.money_type") and len(attributes.money_type)>
			AND ACCOUNT_ACCOUNT_REMAINDER.OTHER_CURRENCY = '#attributes.money_type#'
		</cfif>
		<cfif isDefined("attributes.code1") and len(attributes.code1)>
			AND ACCOUNT_PLAN.ACCOUNT_CODE >= '#attributes.code1#'
		</cfif>
		<cfif isDefined("attributes.code2") and len(attributes.code2)>
			AND ACCOUNT_PLAN.ACCOUNT_CODE <= '#attributes.code2#'
		</cfif>
		<cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
			AND (
				ACCOUNT_PLAN.ACCOUNT_CODE LIKE '#attributes.str_account_code#'
				OR ACCOUNT_PLAN.ACCOUNT_CODE LIKE '#attributes.str_account_code#.%'
				)
		</cfif>
		AND (
				(
				<cfif database_type is 'MSSQL'>
					ACCOUNT_PLAN.ACCOUNT_CODE = LEFT(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID,LEN(ACCOUNT_PLAN.ACCOUNT_CODE))
					AND substring(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID,(LEN(ACCOUNT_PLAN.ACCOUNT_CODE)+1),1)='.'
				<cfelseif database_type is 'DB2'>
					AND ACCOUNT_PLAN.ACCOUNT_CODE = LEFT(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID,LENGTH(ACCOUNT_PLAN.ACCOUNT_CODE))
					AND substring(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID,(LENGTH(ACCOUNT_PLAN.ACCOUNT_CODE)+1),1)='.'
				</cfif>
				)
				OR ACCOUNT_PLAN.ACCOUNT_CODE = ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID
			)
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
				(ACCOUNT_PLAN.ACCOUNT_NAME LIKE '#attributes.keyword#%'
				OR
				ACCOUNT_PLAN.ACCOUNT_CODE LIKE '#attributes.keyword#%')
		</cfif>
	GROUP BY
		ACCOUNT_PLAN.ACCOUNT_CODE, 
		ACCOUNT_PLAN.ACCOUNT_NAME,
		ACCOUNT_PLAN.ACCOUNT_ID,
		ACCOUNT_PLAN.SUB_ACCOUNT,
		ACCOUNT_ACCOUNT_REMAINDER.OTHER_CURRENCY
	<cfif isdefined('attributes.duty_claim') and attributes.duty_claim eq 1>
		HAVING SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) > 0
	<cfelseif isdefined('attributes.duty_claim') and attributes.duty_claim eq 2>
		HAVING SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) < 0
	</cfif>
	ORDER BY 
		ACCOUNT_PLAN.ACCOUNT_CODE
</cfquery>
