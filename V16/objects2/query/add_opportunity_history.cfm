<cfquery name="get_opportunity" datasource="#dsn3#">
	SELECT * FROM OPPORTUNITIES WHERE OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#opp_id#">
</cfquery>
<cfquery name="add_opportunity_history" datasource="#dsn3#">
	INSERT INTO
		OPPORTUNITY_HISTORY
		(
		OPP_ID,
		OPP_HEAD,
		OPP_STATUS,
		OPP_CURRENCY_ID,
		COMPANY_ID,
		PARTNER_ID,
		CONSUMER_ID,
		OPP_DETAIL,
		COMMETHOD_ID,
		ACTIVITY_TIME,
		INCOME,
		MONEY,
		PROBABILITY,
		OPP_DATE,
		APPLICATION_LEVEL,
		SALES_EMP_ID,
		SALES_PARTNER_ID,
		OPP_NO,
		RECORD_PAR,
		RECORD_DATE,
		RECORD_IP,
		OPP_ZONE,
		PROJECT_ID,
		IS_PROCESSED
		
		)
		VALUES
		(
		#get_opportunity.OPP_ID#,
		'#get_opportunity.OPP_HEAD#',
		<cfif len(get_opportunity.OPP_STATUS)>#get_opportunity.OPP_STATUS#,<cfelse>NULL,</cfif>	
		<cfif len(get_opportunity.OPP_CURRENCY_ID)>#get_opportunity.OPP_CURRENCY_ID#,<cfelse>NULL,</cfif>	
		<cfif len(get_opportunity.COMPANY_ID)>#get_opportunity.COMPANY_ID#,<cfelse>NULL,</cfif>	
		<cfif len(get_opportunity.PARTNER_ID)>#get_opportunity.PARTNER_ID#,<cfelse>NULL,</cfif>	
		<cfif len(get_opportunity.CONSUMER_ID)>#get_opportunity.CONSUMER_ID#,<cfelse>NULL,</cfif>	
		<cfif len(get_opportunity.OPP_DETAIL)>'#get_opportunity.OPP_DETAIL#',<cfelse>NULL,</cfif>	
		<cfif len(get_opportunity.COMMETHOD_ID)>#get_opportunity.COMMETHOD_ID#,<cfelse>NULL,</cfif>
		<cfif len(get_opportunity.ACTIVITY_TIME)>#get_opportunity.ACTIVITY_TIME#,<cfelse>NULL,</cfif>	
		<cfif len(get_opportunity.INCOME)>#get_opportunity.INCOME#,<cfelse>NULL,</cfif>	
		<cfif len(get_opportunity.MONEY)>'#get_opportunity.MONEY#',<cfelse>NULL,</cfif>	
		<cfif len(get_opportunity.PROBABILITY)>#get_opportunity.PROBABILITY#,<cfelse>NULL,</cfif>	
		<cfif len(get_opportunity.OPP_DATE)>
			<cfset attributes.OPP_DATE_HISTORY = dateformat(get_opportunity.OPP_DATE,"dd/mm/yyyy")>
			<cf_date tarih="attributes.OPP_DATE_HISTORY">
			#attributes.OPP_DATE_HISTORY#,
		<cfelse>
		    NULL,
		</cfif>	
		<cfif len(get_opportunity.APPLICATION_LEVEL)>'#get_opportunity.APPLICATION_LEVEL#',<cfelse>NULL,</cfif>
		<cfif len(get_opportunity.sales_emp_id)>#get_opportunity.sales_emp_id#<cfelse>NULL</cfif>,
		<cfif len(get_opportunity.sales_partner_id)>#get_opportunity.sales_partner_id#<cfelse>NULL</cfif>,
		<cfif len(get_opportunity.OPP_NO)>'#get_opportunity.OPP_NO#'<cfelse>NULL</cfif>,
		#SESSION.PP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#',
		<cfif len(get_opportunity.OPP_ZONE)>#get_opportunity.OPP_ZONE#,<cfelse>NULL,</cfif>	
		<cfif len(get_opportunity.PROJECT_ID)>#get_opportunity.PROJECT_ID#,<cfelse>NULL,</cfif>	
		<cfif len(get_opportunity.IS_PROCESSED)>#get_opportunity.IS_PROCESSED#<cfelse>NULL</cfif>	
		)
</cfquery>
