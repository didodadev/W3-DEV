<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cfquery name="UPD_PREMIUM" datasource="#DSN3#">
	UPDATE
		MULTILEVEL_SALES_PREMIUM
	SET
		MULTILEVEL_PREMIUM_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.multilevel_premium_name#">,
		START_DATE = #attributes.start_date#,
		FINISH_DATE = #attributes.finish_date#,
		MULTILEVEL_PREMIUM_1_RATE = <cfif len(attributes.multilevel_premium_1)>#attributes.multilevel_premium_1#<cfelse>NULL</cfif>,
		MULTILEVEL_PREMIUM_2_RATE = <cfif len(attributes.multilevel_premium_2)>#attributes.multilevel_premium_2#<cfelse>NULL</cfif>,
		MULTILEVEL_PREMIUM_3_RATE = <cfif len(attributes.multilevel_premium_3)>#attributes.multilevel_premium_3#<cfelse>NULL</cfif>,
		MULTILEVEL_PREMIUM_4_RATE = <cfif len(attributes.multilevel_premium_4)>#attributes.multilevel_premium_4#<cfelse>NULL</cfif>,
		MULTILEVEL_PREMIUM_5_RATE = <cfif len(attributes.multilevel_premium_5)>#attributes.multilevel_premium_5#<cfelse>NULL</cfif>,
		MULTILEVEL_PREMIUM_6_RATE = <cfif len(attributes.multilevel_premium_6)>#attributes.multilevel_premium_6#<cfelse>NULL</cfif>,
		MULTILEVEL_PREMIUM_7_RATE = <cfif len(attributes.multilevel_premium_7)>#attributes.multilevel_premium_7#<cfelse>NULL</cfif>,
		MULTILEVEL_PREMIUM_8_RATE = <cfif len(attributes.multilevel_premium_8)>#attributes.multilevel_premium_8#<cfelse>NULL</cfif>,
		MULTILEVEL_PREMIUM_9_RATE = <cfif len(attributes.multilevel_premium_9)>#attributes.multilevel_premium_9#<cfelse>NULL</cfif>,
		MULTILEVEL_PREMIUM_10_RATE = <cfif len(attributes.multilevel_premium_10)>#attributes.multilevel_premium_10#<cfelse>NULL</cfif>,
		SALES_EMPLOYEE_PREMIUM_RATE = <cfif len(attributes.sales_employee_multilevel_premium)>#attributes.sales_employee_multilevel_premium#<cfelse>NULL</cfif>,
		SALES_TEAM_PREMIUM_RATE = <cfif len(attributes.sales_team_multilevel_premium)>#attributes.sales_team_multilevel_premium#<cfelse>NULL</cfif>,
		SALES_ZONE_PREMIUM_RATE = <cfif len(attributes.sales_zone_multilevel_premium)>#attributes.sales_zone_multilevel_premium#<cfelse>NULL</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE
		MULTILEVEL_PREMIUM_ID = #attributes.premium_id#
</cfquery>
<script>
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.add_multilevel_sales_premium&event=upd&premium_id=#attributes.premium_id#</cfoutput>"
</script>

