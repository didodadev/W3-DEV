<cfif not isdefined("int_period_id")>
	<cfscript>
		if (listfindnocase(partner_url,'#cgi.http_host#',';'))
		{
			int_comp_id = session.pp.our_company_id;
			int_period_id = session.pp.period_id;
			attributes.company_id = session.pp.company_id;
		}
		else if (listfindnocase(server_url,'#cgi.http_host#',';') )
		{	
			int_comp_id = session_base.our_company_id;
			int_period_id = session_base.period_id;
			if(isdefined('session.ww.userid'))
				attributes.consumer_id = session.ww.userid;
		}
		else if (listfindnocase(employee_url,'#cgi.http_host#',';') )
		{	
			int_comp_id = session.ep.company_id;
			int_period_id = session.ep.period_id;
		}
	</cfscript>
</cfif>
<cfif not isdefined("get_credit_limit.recordcount")>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
			SELECT 
				PRICE_CAT
			FROM 
				COMPANY_CREDIT
			WHERE 
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
		</cfquery>
		<cfif get_credit_limit.recordcount and len(get_credit_limit.price_cat)>
			<cfset attributes.price_catid = get_credit_limit.price_cat>
		<cfelse>		
			<cfquery name="GET_COMP_CAT" datasource="#DSN#">
				SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfquery>
			<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
				SELECT PRICE_CATID FROM PRICE_CAT WHERE COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.companycat_id#,%">
			</cfquery>
			<cfif get_price_cat.recordcount>
				<cfset attributes.price_catid = get_price_cat.price_catid>
			</cfif>		
		</cfif>
	</cfif>
	<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		<cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
			SELECT 
				PRICE_CAT
			FROM 
				COMPANY_CREDIT
			WHERE 
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
		</cfquery>
		<cfif get_credit_limit.recordcount and len(get_credit_limit.price_cat)>
			<cfset attributes.price_catid = get_credit_limit.price_cat>
		<cfelse>		
			<cfquery name="GET_COMP_CAT" datasource="#DSN#">
				SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfquery>
			<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
				SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.consumer_cat_id#,%">
			</cfquery>
			<cfif get_price_cat.recordcount>
				<cfset attributes.price_catid = get_price_cat.price_catid>
				<cfset attributes.price_catid_2 = get_price_cat.price_catid>
			</cfif>
		</cfif>
	</cfif>
</cfif>
<cfif not isdefined("moneys.recordcount")>
	<cfset MONEYS = product_action.moneys(company_id : int_comp_id, period_id : int_period_id)>
</cfif>
<cfif not isdefined("default_money.recordcount")>
	<cfset DEFAULT_MONEY = product_action.default_money(company_id : int_comp_id, period_id : int_period_id)>
</cfif>
