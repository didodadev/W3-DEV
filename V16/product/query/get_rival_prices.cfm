<!--- 
	Bu sayfadan objects*query icindede var orayida update ediniz.arzubt 051122003
--->
<cfquery name="get_rival_prices" datasource="#dsn#">
	SELECT
		PR.PR_ID,
		PR.PRICE,
		PR.MONEY,
		PR.STARTDATE,
		PR.FINISHDATE,
		SETUP_UNIT.UNIT,
		SETUP_RIVALS.RIVAL_NAME
	FROM
		SETUP_RIVALS,
		#dsn3_alias#.PRICE_RIVAL PR,
		#dsn3_alias#.PRODUCT_UNIT PU,
		SETUP_UNIT
	WHERE
		PR.PRODUCT_ID = #attributes.PID#
		AND
		PU.PRODUCT_UNIT_ID = PR.UNIT_ID	
		AND
		SETUP_UNIT.UNIT_ID = PU.UNIT_ID
		AND
		SETUP_RIVALS.R_ID = PR.R_ID
</cfquery>
