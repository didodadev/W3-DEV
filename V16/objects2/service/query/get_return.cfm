<cfquery name="GET_RETURNS" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		SPR.RETURN_ID,
        SPR.SERVICE_PARTNER_ID,
        SPR.PERIOD_ID,
        SPR.INVOICE_ID,
        SPR.RECORD_DATE,
		SPRR.IS_SHIP,
		SPRR.AMOUNT,
		SPRR.RETURN_ROW_ID,
		SPRR.RETURN_TYPE,
		SPRR.RETURN_STAGE,
		SPRR.STOCK_ID,
		SPRR.PACKAGE,
		SPRR.ACCESSORIES,
		SPRR.DETAIL,
		S.PRODUCT_NAME,
		S.PRODUCT_ID
	FROM
		SERVICE_PROD_RETURN SPR,
		SERVICE_PROD_RETURN_ROWS SPRR,
		STOCKS S
	WHERE
		SPR.RETURN_ID = SPRR.RETURN_ID AND
		SPR.RETURN_ID IS NOT NULL AND 
		SPRR.STOCK_ID = S.STOCK_ID AND
		<cfif isdefined("session.pp")>
            (
                SPR.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
                SPR.RECORD_PAR IN (SELECT PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
            )
		<cfelse>
			<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			<cfelseif isdefined("session.ww.userid")>
				SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			</cfif>
		</cfif>
		<cfif len(attributes.keyword)>
			AND 
			(
				SPR.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)			
		</cfif>
		<cfif isdefined("attributes.return_stage") and len(attributes.return_stage)>
			AND SPRR.RETURN_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.return_stage#">
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			AND SPR.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		</cfif>
		<cfif  isdefined("attributes.finish_date") and  len(attributes.finish_date)>
			AND SPR.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		</cfif>
</cfquery>
