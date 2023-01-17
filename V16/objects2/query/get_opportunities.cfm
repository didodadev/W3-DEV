<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
<cfquery name="GET_OPPORTUNITIES" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		OPPORTUNITIES.OPP_NO,
		OPPORTUNITIES.OPP_CURRENCY_ID,
		OPPORTUNITIES.CONSUMER_ID,
		OPPORTUNITIES.PARTNER_ID,
		OPPORTUNITIES.OPP_HEAD,
		OPPORTUNITIES.OPP_DATE,
		OPPORTUNITIES.PROBABILITY,
		OPPORTUNITIES.INCOME,
		OPPORTUNITIES.SALES_EMP_ID,
		OPPORTUNITIES.SALES_PARTNER_ID,
		OPPORTUNITIES.RECORD_DATE,
		OPPORTUNITIES.OPP_ID,
		OPPORTUNITIES.STOCK_ID,
		OPPORTUNITIES.PRODUCT_CAT_ID,
		OPPORTUNITIES.COMPANY_ID,
		OPPORTUNITIES.OPPORTUNITY_TYPE_ID,
		OPPORTUNITIES.UPDATE_DATE
	FROM
		OPPORTUNITIES
	WHERE
		OPPORTUNITIES.OPP_ID IS NOT NULL AND 
	    OPPORTUNITIES.OPPORTUNITY_TYPE_ID IN (SELECT OPPORTUNITY_TYPE_ID FROM SETUP_OPPORTUNITY_TYPE WHERE IS_INTERNET = 1)
		<cfif isdefined("attributes.is_opp_view") and attributes.is_opp_view eq 1>
			AND OPPORTUNITIES.SALES_PARTNER_ID IN (SELECT PARTNER_ID FROM #dsn#.COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
		</cfif>
		<cfif isdefined("attributes.opp_status") and len(attributes.opp_status)>
			AND OPPORTUNITIES.OPP_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_status#">
		</cfif>
		<cfif len(attributes.opp_keyword)>
			AND 
			(
				OPPORTUNITIES.OPP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.opp_keyword#%"> OR
				OPPORTUNITIES.OPP_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.opp_keyword#%">
			)
		</cfif>
		<cfif isdefined("attributes.opportunity_type_id") and len(attributes.opportunity_type_id)>
			AND OPPORTUNITIES.OPPORTUNITY_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opportunity_type_id#">
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND OPPORTUNITIES.OPP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND OPPORTUNITIES.OPP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>
		<cfif isdefined('attributes.sale_add_option') and len(attributes.sale_add_option)> 
			AND OPPORTUNITIES.SALE_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_add_option#">
		</cfif>
	ORDER BY
		OPP_DATE DESC
</cfquery>
