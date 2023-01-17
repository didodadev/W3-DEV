<cfquery name="CAMPAIGN" datasource="#DSN3#">
	SELECT DISTINCT
		C.CAMP_NO,
		C.CAMP_ID,
		C.CAMP_STARTDATE,
		C.CAMP_FINISHDATE,
		C.CAMP_HEAD,
		C.LEADER_EMPLOYEE_ID,
		CAMPAIGN_CATS.CAMP_CAT_NAME,
		UFU.USER_FRIENDLY_URL
	FROM
		<cfif (isdefined("attributes.product_catid") and len(attributes.product_catid)) or (isdefined("attributes.brand_id") and len(attributes.brand_id))>
			PROMOTIONS P,
		</cfif>
		CAMPAIGNS C
		LEFT JOIN #dsn_alias#.USER_FRIENDLY_URLS UFU 
		ON UFU.ACTION_TYPE = 'CAMP_ID' 
		AND ACTION_ID = C.CAMP_ID 
		AND UFU.PROTEIN_EVENT = 'det' 
		AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE#
		AND UFU.PROTEIN_PAGE = #GET_PAGE.DET_PAGE#,
		CAMPAIGN_CATS
	WHERE
		C.CAMP_STATUS = 1 AND
		C.CAMP_CAT_ID = CAMPAIGN_CATS.CAMP_CAT_ID AND
		C.CAMP_STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
		C.CAMP_FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND CAMP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
		<cfif isdefined("attributes.camp_cat_id") and len(attributes.camp_cat_id)>
			AND CAMPAIGN_CATS.CAMP_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_cat_id#">
		</cfif>
		<cfif isdefined("session.ww.consumer_category")>
			AND (C.CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.ww.consumer_category#%"> AND C.IS_INTERNET = 1)
		<cfelseif isdefined("session.pp.company_category")>
			AND (C.COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.pp.company_category#%"> AND C.IS_EXTRANET = 1)
		<cfelse>
			AND C.IS_INTERNET = 1
		</cfif>
		<cfif isdefined("attributes.stock_id") and len(attributes.stock_id) and attributes.stock_id gt 0>
			AND P.CAMP_ID = C.CAMP_ID
			AND
				P.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
		<cfelseif isdefined("attributes.product_catid") and len(attributes.product_catid) and attributes.product_catid gt 0>
			AND P.CAMP_ID = C.CAMP_ID
			AND
				(
					P.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#"> OR
					P.STOCK_ID IN (SELECT STOCKS.STOCK_ID FROM STOCKS WHERE STOCKS.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">)
				)
		<cfelseif isdefined("attributes.brand_id") and len(attributes.brand_id)>
			AND P.CAMP_ID = C.CAMP_ID
			AND 
				(
					P.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> OR
					P.STOCK_ID IN (SELECT STOCKS.STOCK_ID FROM STOCKS WHERE STOCKS.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">)
				)
		</cfif>
</cfquery>
