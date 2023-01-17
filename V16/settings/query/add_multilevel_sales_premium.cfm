<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cfquery name="ADD_PREMIUM" datasource="#DSN3#" result="MAX_ID">
	INSERT INTO
		MULTILEVEL_SALES_PREMIUM
		(	
			MULTILEVEL_PREMIUM_NAME,
			START_DATE,
			FINISH_DATE,
			MULTILEVEL_PREMIUM_1_RATE,
			MULTILEVEL_PREMIUM_2_RATE,
			MULTILEVEL_PREMIUM_3_RATE,
			MULTILEVEL_PREMIUM_4_RATE,
			MULTILEVEL_PREMIUM_5_RATE,
			MULTILEVEL_PREMIUM_6_RATE,
			MULTILEVEL_PREMIUM_7_RATE,
			MULTILEVEL_PREMIUM_8_RATE,
			MULTILEVEL_PREMIUM_9_RATE,
			MULTILEVEL_PREMIUM_10_RATE,
			SALES_EMPLOYEE_PREMIUM_RATE,
			SALES_TEAM_PREMIUM_RATE,
			SALES_ZONE_PREMIUM_RATE,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
	VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.multilevel_premium_name#">,
			#attributes.start_date#,
			#attributes.finish_date#,
			<cfif len(attributes.multilevel_premium_1)>#attributes.multilevel_premium_1#<cfelse>NULL</cfif>,
			<cfif len(attributes.multilevel_premium_2)>#attributes.multilevel_premium_2#<cfelse>NULL</cfif>,
			<cfif len(attributes.multilevel_premium_3)>#attributes.multilevel_premium_3#<cfelse>NULL</cfif>,
			<cfif len(attributes.multilevel_premium_4)>#attributes.multilevel_premium_4#<cfelse>NULL</cfif>,
			<cfif len(attributes.multilevel_premium_5)>#attributes.multilevel_premium_5#<cfelse>NULL</cfif>,
			<cfif len(attributes.multilevel_premium_6)>#attributes.multilevel_premium_6#<cfelse>NULL</cfif>,
			<cfif len(attributes.multilevel_premium_7)>#attributes.multilevel_premium_7#<cfelse>NULL</cfif>,
			<cfif len(attributes.multilevel_premium_8)>#attributes.multilevel_premium_8#<cfelse>NULL</cfif>,
			<cfif len(attributes.multilevel_premium_9)>#attributes.multilevel_premium_9#<cfelse>NULL</cfif>,
			<cfif len(attributes.multilevel_premium_10)>#attributes.multilevel_premium_10#<cfelse>NULL</cfif>,
			<cfif len(attributes.sales_employee_multilevel_premium)>#attributes.sales_employee_multilevel_premium#<cfelse>NULL</cfif>,
			<cfif len(attributes.sales_team_multilevel_premium)>#attributes.sales_team_multilevel_premium#<cfelse>NULL</cfif>,
			<cfif len(attributes.sales_zone_multilevel_premium)>#attributes.sales_zone_multilevel_premium#<cfelse>NULL</cfif>,
			#session.ep.userid#,
			#now()#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		)
</cfquery>
<script>
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.add_multilevel_sales_premium&event=upd&premium_id=#MAX_ID.IDENTITYCOL#</cfoutput>"
</script>

