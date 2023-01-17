<cfscript>
	if (listfindnocase(employee_url,'#cgi.http_host#',';'))
	{
		int_period_id = session.ep.period_id;
	}
	else if (listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		int_period_id = session.pp.period_id;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		int_period_id = session.ww.period_id;
	}
</cfscript>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_MONEY 
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_period_id#"> AND
		MONEY_STATUS = 1 AND 
		MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money#">
</cfquery>
