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

<cfquery name="DEFAULT_MONEY" datasource="#dsn#">
	SELECT
		MONEY,
		RATE1,
		RATE2
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		COMPANY_ID = #int_comp_id# AND
		RATE1=1 AND RATE2=1 AND
		PERIOD_ID = #int_period_id#
</cfquery>
