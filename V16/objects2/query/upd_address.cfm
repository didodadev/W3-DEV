<cfquery name="CHECK_BRANCH" datasource="#DSN#">
	SELECT
		*
	FROM
		COMPANY_BRANCH
	WHERE 
		COMPBRANCH__NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.compbranch_name)#"> AND 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		COMPBRANCH_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_branch_id#">
</cfquery>
<cfif check_branch.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1393.Aynı Adlı Adres/Şube Kaydı Var ! Adres/Şube Adını Değişiniz'> !");
		window.history.go(-1);
	</script>
<cfelse>
<cfscript>
	if (listfindnocase(partner_url,'#cgi.http_host#',';'))
	{
		attributes.company_id = session.pp.company_id;
	}
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		if(isdefined('session.ww.company_id'))
			attributes.company_id = session.ww.company_id;
		else if(isdefined('session.ww.userid'))
			attributes.consumer_id = session.ww.userid;
	}
</cfscript>
	<cfquery name="UPD_COMPANY_BRANCH" datasource="#DSN#">
		UPDATE
			COMPANY_BRANCH
		SET
			COMPBRANCH__NAME='#attributes.compbranch_name#',
			COMPBRANCH_TELCODE='#attributes.compbranch_telcode#',
			COMPBRANCH_TEL1='#attributes.compbranch_tel1#',
			COMPBRANCH_ADDRESS=<cfif isdefined("attributes.compbranch_address") and len(attributes.compbranch_address)>'#attributes.compbranch_address#'<cfelse>NULL</cfif>,
			SEMT=<cfif len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
			COMPBRANCH_POSTCODE=<cfif len(attributes.postcode)>'#attributes.postcode#'<cfelse>NULL</cfif>,
			COUNTY_ID=<cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
			CITY_ID=<cfif len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
			COUNTRY_ID=<cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
			UPDATE_DATE=#now()#,
			<cfif isdefined("attributes.company_id")>
				UPDATE_PAR=#attributes.company_id#,
			</cfif>
			UPDATE_IP='#cgi.remote_addr#'
		WHERE
			COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_branch_id#">
	</cfquery>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>
