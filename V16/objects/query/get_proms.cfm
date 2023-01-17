<cfif isdate(attributes.start_date) >
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfif isdefined("attributes.branch_id")>
	<cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
		SELECT
			PRICE_CATID
		FROM
			PRICE_CAT
		WHERE
			BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.branch_id#,%">
	</cfquery>
	<cfset price_cat_list = valuelist(get_price_cats.price_catid)>
</cfif>
<cfif isdefined("session.pp.userid")>
	<cfquery name="GET_PRICE_CATS_COMP" datasource="#DSN3#">
		SELECT
			PRICE_CATID
		FROM
			PRICE_CAT
		WHERE
			',' + COMPANY_CAT + ',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%">
	</cfquery>
	<cfset price_cat_list_comp = valuelist(get_price_cats_comp.price_catid)>
</cfif>
<cfquery name="PROMS" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
	(
		SELECT
			PROMOTIONS.PROM_ID,
			PROMOTIONS.PROM_NO,
			PROMOTIONS.PROM_HEAD AS PROM_HEAD,
			PROMOTIONS.RECORD_DATE,
			PROMOTIONS.VALID_EMP,
			PROMOTIONS.VALID,
			PROMOTIONS.STOCK_ID,
			PROMOTIONS.VALIDATOR_POSITION_CODE,
			CAMPAIGNS.CAMP_HEAD AS CAMP_HEAD,
			STOCKS.PRODUCT_NAME,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			PROMOTIONS.STARTDATE AS STARTDATE,
			PROMOTIONS.FINISHDATE AS FINISHDATE
		FROM
			PROMOTIONS,
			CAMPAIGNS,
			STOCKS
		WHERE
			PROMOTIONS.CAMP_ID = CAMPAIGNS.CAMP_ID
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
                PROMOTIONS.PROM_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
                PROMOTIONS.PROM_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
                PROMOTIONS.GIFT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
			)
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(price_cat_list)>
			AND PROMOTIONS.PRICE_CATID IN (#price_cat_list#)
		</cfif>
		<cfif isdefined("session.pp.userid")>
			<cfif len(price_cat_list_comp)>
				AND PROMOTIONS.PRICE_CATID IN (#price_cat_list_comp#)
			<cfelse>
				AND PROMOTIONS.PRICE_CATID = -2
			</cfif>
			AND STARTDATE <= #now()# AND FINISHDATE >= #now()#
		<cfelseif isdefined("attributes.price_catid") and len(attributes.price_catid)>
			AND PROMOTIONS.PRICE_CATID = #attributes.price_catid#
		</cfif>
		<!--- BK 180 gune silinsin 2013072 <cfif isdefined('attributes.discount_type_id_2') and len(attributes.discount_type_id_2)>
			AND PROMOTIONS.DISCOUNT_TYPE_ID_2 = #attributes.discount_type_id_2#
		</cfif> --->
		<cfif  isdefined('attributes.product_catid') and len(attributes.product_catid) and isdefined('attributes.product_cat') and len(attributes.product_cat)>
			AND PROMOTIONS.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
		</cfif>
		<cfif isdefined('attributes.product_id') and len(attributes.product_id) and isdefined('attributes.product_name') and len(attributes.product_name)>
			AND STOCKS.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
		</cfif>
		<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
			AND PROMOTIONS.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
		</cfif>
		<cfif isdefined('attributes.company_id') and len("attributes.company_id") and isdefined('attributes.company') and len(attributes.company)>
			AND PROMOTIONS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif isDefined('attributes.start_date')>
			<cfif len(attributes.start_date) and not len(attributes.finish_date)>
				AND FINISHDATE >= #attributes.start_date#
			<cfelseif len(attributes.finish_date)and not len(attributes.start_date)>
				AND STARTDATE <= #attributes.finish_date#
			<cfelseif len(attributes.start_date) and len(attributes.finish_date)>
				AND STARTDATE <= #attributes.finish_date# AND FINISHDATE >= #attributes.start_date#
			</cfif>
		</cfif>
		AND
		STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID
	)
	UNION
	(
		SELECT
			PROMOTIONS.PROM_ID,
			PROMOTIONS.PROM_NO,
			PROMOTIONS.PROM_HEAD AS PROM_HEAD,
			PROMOTIONS.RECORD_DATE,
			PROMOTIONS.VALID_EMP,
			PROMOTIONS.VALID,
			PROMOTIONS.STOCK_ID,
			PROMOTIONS.VALIDATOR_POSITION_CODE,
			'KAMPANYA HARİCİ ÜRÜNLÜ' AS CAMP_HEAD,
			STOCKS.PRODUCT_NAME,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			PROMOTIONS.STARTDATE AS STARTDATE,
			PROMOTIONS.FINISHDATE AS FINISHDATE
		FROM
			PROMOTIONS,
			STOCKS
		WHERE
			PROMOTIONS.CAMP_ID IS NULL
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
                PROMOTIONS.PROM_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                PROMOTIONS.PROM_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                PROMOTIONS.GIFT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(price_cat_list)>
			AND PROMOTIONS.PRICE_CATID IN (#price_cat_list#)
		</cfif>
		<cfif isdefined("session.pp.userid")>
			<cfif len(price_cat_list_comp)>
				AND PROMOTIONS.PRICE_CATID IN (#price_cat_list_comp#)
			<cfelse>
				AND PROMOTIONS.PRICE_CATID = -2
			</cfif>
			AND STARTDATE <= #now()# AND FINISHDATE >= #now()#
		<cfelseif isdefined("attributes.price_catid") and len(attributes.price_catid)>
			AND PROMOTIONS.PRICE_CATID = #attributes.price_catid#
		</cfif>
		<!--- BK 180 gune silinsin 20130724 <cfif isdefined('attributes.discount_type_id_2') and len(attributes.discount_type_id_2)>
			AND PROMOTIONS.DISCOUNT_TYPE_ID_2 = #attributes.discount_type_id_2#
		</cfif> --->
		<cfif  isdefined('attributes.product_catid') and len(attributes.product_catid) and isdefined('attributes.product_cat') and len(attributes.product_cat)>
			AND PROMOTIONS.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
		</cfif>
		<cfif isdefined('attributes.product_id') and len(attributes.product_id) and isdefined('attributes.product_name') and len(attributes.product_name)>
			AND STOCKS.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
		</cfif>
		<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
			AND PROMOTIONS.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
		</cfif>
		<cfif isdefined('attributes.company_id') and len("attributes.company_id") and isdefined('attributes.company') and len(attributes.company)>
			AND PROMOTIONS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif isDefined('attributes.start_date')>
			<cfif len(attributes.start_date) and not len(attributes.finish_date)>
				AND FINISHDATE >= #attributes.start_date#
			<cfelseif len(attributes.finish_date)and not len(attributes.start_date)>
				AND STARTDATE <= #attributes.finish_date#
			<cfelseif len(attributes.start_date) and len(attributes.finish_date)>
				AND STARTDATE <= #attributes.finish_date# AND FINISHDATE >= #attributes.start_date#
			</cfif>
		</cfif>
		AND
		STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID
	)
	UNION
	(
		SELECT
			PROMOTIONS.PROM_ID,
			PROMOTIONS.PROM_NO,
			PROMOTIONS.PROM_HEAD AS PROM_HEAD,
			PROMOTIONS.RECORD_DATE,
			PROMOTIONS.VALID_EMP,
			PROMOTIONS.VALID,
			PROMOTIONS.STOCK_ID,
			PROMOTIONS.VALIDATOR_POSITION_CODE,
			'KAMPANYA HARİCİ ÜRÜNSÜZ' AS CAMP_HEAD,
			'' AS PRODUCT_NAME,
			'' AS PRODUCT_ID,
			'' AS STOCK_CODE,
			PROMOTIONS.STARTDATE AS STARTDATE,
			PROMOTIONS.FINISHDATE AS FINISHDATE
		FROM
			PROMOTIONS
		WHERE
			PROMOTIONS.CAMP_ID IS NULL AND
			PROMOTIONS.STOCK_ID IS NULL
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
                PROMOTIONS.PROM_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                PROMOTIONS.PROM_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                PROMOTIONS.GIFT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(price_cat_list)>
			AND PROMOTIONS.PRICE_CATID IN (#price_cat_list#)
		</cfif>
		<cfif isdefined("session.pp.userid")>
			<cfif len(price_cat_list_comp)>
				AND PROMOTIONS.PRICE_CATID IN (#price_cat_list_comp#)
			<cfelse>
				AND PROMOTIONS.PRICE_CATID = -2
			</cfif>
			AND STARTDATE <= #now()# AND FINISHDATE >= #now()#
		<cfelseif isdefined("attributes.price_catid") and len(attributes.price_catid)>
			AND PROMOTIONS.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">
		</cfif>
		<!--- BK 180 gune silinsin 2013072 <cfif isdefined('attributes.discount_type_id_2') and len(attributes.discount_type_id_2)>
			AND PROMOTIONS.DISCOUNT_TYPE_ID_2 = #attributes.discount_type_id_2#
		</cfif> --->
		<cfif  isdefined('attributes.product_catid') and len(attributes.product_catid) and isdefined('attributes.product_cat') and len(attributes.product_cat)>
			AND PROMOTIONS.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
		</cfif>
		<cfif isdefined('attributes.product_id') and len(attributes.product_id) and isdefined('attributes.product_name') and len(attributes.product_name)>
			AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
		</cfif>
		<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
			AND PROMOTIONS.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
		</cfif>
		<cfif isdefined('attributes.company_id') and len("attributes.company_id") and isdefined('attributes.company') and len(attributes.company)>
			AND PROMOTIONS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif isDefined('attributes.start_date')>
			<cfif len(attributes.start_date) and not len(attributes.finish_date)>
                AND FINISHDATE >= #attributes.start_date#
			<cfelseif len(attributes.finish_date)and not len(attributes.start_date)>
                AND STARTDATE <= #attributes.finish_date#
			<cfelseif len(attributes.start_date) and len(attributes.finish_date)>
                AND STARTDATE <= #attributes.finish_date# AND FINISHDATE >= #attributes.start_date#
			</cfif>
		</cfif>
	)
	UNION
	(
		SELECT
			PROMOTIONS.PROM_ID,
			PROMOTIONS.PROM_NO,
			PROMOTIONS.PROM_HEAD AS PROM_HEAD,
			PROMOTIONS.RECORD_DATE,
			PROMOTIONS.VALID_EMP,
			PROMOTIONS.VALID,
			PROMOTIONS.STOCK_ID,
			PROMOTIONS.VALIDATOR_POSITION_CODE,
			CAMPAIGNS.CAMP_HEAD AS CAMP_HEAD,
			'' AS PRODUCT_NAME,
			'' AS PRODUCT_ID,
			'' AS STOCK_CODE,
			PROMOTIONS.STARTDATE AS STARTDATE,
			PROMOTIONS.FINISHDATE AS FINISHDATE
		FROM
			PROMOTIONS,
			CAMPAIGNS
		WHERE
			PROMOTIONS.CAMP_ID = CAMPAIGNS.CAMP_ID AND
			PROMOTIONS.STOCK_ID IS NULL
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
                PROMOTIONS.PROM_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                PROMOTIONS.PROM_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                PROMOTIONS.GIFT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(price_cat_list)>
			AND PROMOTIONS.PRICE_CATID IN (#price_cat_list#)
		</cfif>
		<cfif isdefined("session.pp.userid")>
			<cfif len(price_cat_list_comp)>
				AND PROMOTIONS.PRICE_CATID IN (#price_cat_list_comp#)
			<cfelse>
				AND PROMOTIONS.PRICE_CATID = -2
			</cfif>
			AND STARTDATE <= #now()# AND FINISHDATE >= #now()#
		<cfelseif isdefined("attributes.price_catid") and len(attributes.price_catid)>
			AND PROMOTIONS.PRICE_CATID = #attributes.price_catid#
		</cfif>
		<!--- BK 180 gune silinsin 2013072 <cfif isdefined('attributes.discount_type_id_2') and len(attributes.discount_type_id_2)>
			AND PROMOTIONS.DISCOUNT_TYPE_ID_2 = #attributes.discount_type_id_2#
		</cfif> --->
		<cfif  isdefined('attributes.product_catid') and len(attributes.product_catid) and isdefined('attributes.product_cat') and len(attributes.product_cat)>
			AND PROMOTIONS.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
		</cfif>
		<cfif isdefined('attributes.product_id') and len(attributes.product_id) and isdefined('attributes.product_name') and len(attributes.product_name)>
			AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
		</cfif>
		<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
			AND PROMOTIONS.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
		</cfif>
		<cfif isdefined('attributes.company_id') and len("attributes.company_id") and isdefined('attributes.company') and len(attributes.company)>
			AND PROMOTIONS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif isDefined('attributes.start_date')>
			<cfif len(attributes.start_date) and not len(attributes.finish_date)>
				AND FINISHDATE >= #attributes.start_date#
			<cfelseif len(attributes.finish_date)and not len(attributes.start_date)>
				AND STARTDATE <= #attributes.finish_date#
			<cfelseif len(attributes.start_date) and len(attributes.finish_date)>
				AND STARTDATE <= #attributes.finish_date# AND FINISHDATE >= #attributes.start_date#
			</cfif>
		</cfif>
	)
    ORDER BY 
        FINISHDATE DESC,STARTDATE DESC,PROM_HEAD
</cfquery>
