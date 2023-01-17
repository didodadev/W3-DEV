<cfquery name="GET_PRICE_OFFER" datasource="#DSN#">
	SELECT 
		PPO.*,
		C.NICKNAME, 
		CP.COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME
	FROM 
		COMPANY C,
		COMPANY_PARTNER CP,
		#dsn3_alias#.PRICE_PARTNER_OFFER PPO
	WHERE
		PPO.PRODUCT_ID = #attributes.pid# AND
		C.COMPANY_ID = PPO.RECORD_COMP_ID AND
		CP.PARTNER_ID = PPO.RECORD_PAR AND
		PPO.STATUS = 1
</cfquery>
