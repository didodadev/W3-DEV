<cfscript>
	if (listfindnocase(employee_url,'#cgi.http_host#',';'))
	{
		int_comp_id = SESSION.EP.COMPANY_ID;
		int_period_id = SESSION.EP.PERIOD_ID;
	}
	else if (listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		int_comp_id = SESSION.PP.OUR_COMPANY_ID;
		int_period_id = SESSION.PP.PERIOD_ID;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		int_comp_id = SESSION.WW.OUR_COMPANY_ID;
		int_period_id = SESSION.WW.PERIOD_ID;
	}
</cfscript>

<cfquery name="MONEYS" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		COMPANY_ID = #int_comp_id# AND
		PERIOD_ID = #int_period_id# AND
		MONEY_STATUS = 1
</cfquery>
