<cfquery name="GET_ACCOUNT_PLAN" datasource="#DSN2#">
	SELECT
		ACCOUNT_CODE,
		ACCOUNT_NAME
	FROM
		ACCOUNT_PLAN
	<cfif isDefined("attributes.CODE")>
	WHERE
		ACCOUNT_CODE LIKE '#attributes.CODE#%'
	</cfif>
	<cfif isDefined("attributes.keyword") AND len(attributes.keyword)>
	WHERE
		ACCOUNT_NAME LIKE '#attributes.keyword#%'
		OR
		ACCOUNT_CODE LIKE '#attributes.keyword#%'
	</cfif>
	ORDER BY 
		ACCOUNT_CODE
</cfquery>

<cfset AY_BASI = CreateDate(SESSION.EP.PERIOD_YEAR,inflation_month,1) >

<cfquery name="GET_AYLIK_BAKIYE" datasource="#dsn2#">
		SELECT
			SUM(TOPLAM) AS BAKIYE,
			ACCOUNT_CODE
		FROM
			(
				SELECT
					ACCOUNT_ID AS ACCOUNT_CODE,
					SUM(BORC-ALACAK) AS TOPLAM
				FROM
					ACCOUNT_ACCOUNT_REMAINDER
				WHERE
					ACTION_DATE BETWEEN #CreateODBCDateTime(ay_basi)# AND #CreateODBCDateTime(CREATEDATE(SESSION.EP.PERIOD_YEAR,inflation_month,daysinmonth(ay_basi)))#
				GROUP BY
					ACCOUNT_ID
			UNION
				SELECT
					ACCOUNT_CODE,
					0 AS TOPLAM
				FROM
					ACCOUNT_PLAN
				)
				AS TABLE1
		GROUP BY
			ACCOUNT_CODE 
 </cfquery>

<cfquery name="GET_AYLIK_BAKIYE" dbtype="query">
	SELECT
		GET_ACCOUNT_PLAN.ACCOUNT_CODE,
		GET_ACCOUNT_PLAN.ACCOUNT_NAME,
		GET_AYLIK_BAKIYE.BAKIYE
	FROM
		GET_AYLIK_BAKIYE,
		GET_ACCOUNT_PLAN
	WHERE
		GET_ACCOUNT_PLAN.ACCOUNT_CODE = GET_AYLIK_BAKIYE.ACCOUNT_CODE
	ORDER BY
		GET_ACCOUNT_PLAN.ACCOUNT_CODE
</cfquery>

<cfif INFLATION_MONTH GT 1>
<!--- AY OCAK DEĞİLSE --->
	<cfquery name="GET_INFLATION" datasource="#DSN2#">
		SELECT
			INFLATION_ID
		FROM
			INFLATION
		WHERE
			INFLATION_MONTH = #INFLATION_MONTH-1#
	</cfquery>
	
	<cfif NOT GET_INFLATION.RECORDCOUNT>
		<script type="text/javascript">
			alert("<cf_get_lang no ='245.Önce Geçen Ayın Enflasyon Fişini Kesiniz'> !");
			window.close();
		</script>
<!--- 		<cfexit method="exittemplate"> bu calismiyor remarkladim:arzubt 30122003--->
		<cfabort>
	</cfif>
	
	<cfquery name="GET_ACCOUNT_CARD_ID" datasource="#DSN2#">
		SELECT 
			CARD_ID 
		FROM	
			ACCOUNT_CARD 
		WHERE
			ACTION_ID = #GET_INFLATION.INFLATION_ID# AND
			CARD_TYPE = 13 AND
			ACTION_TYPE = 16
	</cfquery>
	
	<cfquery name="get_month_inflation_fis" datasource="#dsn2#">
		SELECT
			AMOUNT,
			ACCOUNT_ID AS ACCOUNT_CODE
		FROM
			ACCOUNT_CARD_ROWS
		WHERE
			CARD_ID = #GET_ACCOUNT_CARD_ID.CARD_ID#	AND
			BA = 0
	</cfquery>
	
	<cfset PAID_INFLATION = get_month_inflation_fis.AMOUNT >
	<cfset PAID_INFLATION_CODE = get_month_inflation_fis.ACCOUNT_CODE >
	
<cfelse>
	<cfset PAID_INFLATION = 0 >
	<cfset PAID_INFLATION_CODE = "" >
</cfif>
