<cfquery name="get_rival_prices" datasource="#dsn#">
	SELECT TOP 50
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		PR.PR_ID,
		PR.PRICE,
        PR.PRICE_2,
		PR.MONEY,
		PR.STARTDATE,
		PR.FINISHDATE,
		SETUP_RIVALS.RIVAL_NAME,
		PR.R_ID,
		PR.UNIT_ID,
        PR.RECORD_DATE,
        PR.PRICE_TYPE,
        (SELECT RPT.TYPE_NAME FROM #dsn_dev_alias#.RIVAL_PRICE_TYPES RPT WHERE RPT.TYPE_ID = PR.PRICE_TYPE) AS PRICE_TYPE_NAME
	FROM
		SETUP_RIVALS,
		#dsn3_alias#.PRICE_RIVAL PR,
		#dsn3_alias#.PRODUCT P
	WHERE
    	PR.PRODUCT_ID = P.PRODUCT_ID AND
		SETUP_RIVALS.R_ID = PR.R_ID
	<cfif isdefined("attributes.pid") and  len(attributes.pid)>
		AND P.PRODUCT_ID = #attributes.pid#
	</cfif> 
    --AND PR.STARTDATE <= #now()# AND (PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL)
   	ORDER BY
    	PR.STARTDATE DESC
</cfquery>

<cfquery name="get_daily_rival_prices" datasource="#dsn#">
	SELECT
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		PR.PR_ID,
		PR.PRICE,
        PR.PRICE_2,
		PR.MONEY,
		PR.STARTDATE,
		PR.FINISHDATE,
		SETUP_RIVALS.RIVAL_NAME,
		PR.R_ID,
		PR.UNIT_ID,
        PR.RECORD_DATE,
        PR.PRICE_TYPE,
        (SELECT RPT.TYPE_NAME FROM #dsn_dev_alias#.RIVAL_PRICE_TYPES RPT WHERE RPT.TYPE_ID = PR.PRICE_TYPE) AS PRICE_TYPE_NAME
	FROM
		SETUP_RIVALS,
		#dsn3_alias#.PRICE_RIVAL PR,
		#dsn3_alias#.PRODUCT P
	WHERE
    	PR.PRODUCT_ID = P.PRODUCT_ID AND
		SETUP_RIVALS.R_ID = PR.R_ID
	<cfif isdefined("attributes.pid") and  len(attributes.pid)>
		AND P.PRODUCT_ID = #attributes.pid#
	</cfif> 
    AND PR.STARTDATE <= #now()# AND (PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL)
   	ORDER BY
    	PR.STARTDATE DESC
</cfquery>

<cfquery name="get_ort" datasource="#DSN3#">
	SELECT
        AVG(P) AS PRICE
   FROM
        (
            SELECT 
                PRICE_RIVAL.PRICE AS P
            FROM 
                PRICE_RIVAL 
            WHERE
                PRICE_RIVAL.PRICE IS NOT NULL AND
                PRICE_RIVAL.PRODUCT_ID = #attributes.pid# AND 
                PRICE_RIVAL.STARTDATE <= #now()# AND PRICE_RIVAL.FINISHDATE >= #now()#
         UNION
            SELECT 
                PRICE_RIVAL.PRICE_2 AS P
            FROM 
                PRICE_RIVAL 
            WHERE
                PRICE_RIVAL.PRICE_2 IS NOT NULL AND
                PRICE_RIVAL.PRODUCT_ID = #attributes.pid# AND 
                PRICE_RIVAL.STARTDATE <= #now()# AND PRICE_RIVAL.FINISHDATE >= #now()#
       ) AS RAKIP_FIYATLAR
</cfquery>

<cfquery name="get_fiy" datasource="#dsn3#">
	SELECT PRICE_KDV FROM PRICE_STANDART WHERE PURCHASESALES = 1 AND PRODUCT_ID = #attributes.pid# AND PRICESTANDART_STATUS = 1
</cfquery>