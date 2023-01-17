<cfquery name="get_marching_money" datasource="#dsn#">
	SELECT
		MM.MARCHING_MONEY_MAIN_ID,
		MM.START_DATE,
		MM.FINISH_DATE,
		MM.RECORD_DATE,
		MM.RECORD_EMP
	FROM
		MARCHING_MONEY_MAIN MM
	WHERE
		1=1
		<cfif isdefined('attributes.money_main_id') and len(attributes.money_main_id)>
			AND MM.MARCHING_MONEY_MAIN_ID = #attributes.money_main_id# 
		</cfif>
</cfquery>
