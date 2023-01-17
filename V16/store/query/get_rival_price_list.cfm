<cfquery name="get_rival_prices" datasource="#dsn#">
	SELECT
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		PR.PR_ID,
		PR.PRICE,
		PR.MONEY,
		PR.STARTDATE,
		PR.FINISHDATE,
		SETUP_UNIT.UNIT,
		SETUP_RIVALS.RIVAL_NAME,
		PR.R_ID,
		PR.UNIT_ID
	FROM
		SETUP_RIVALS,
		#dsn3_alias#.PRICE_RIVAL PR,
		#dsn3_alias#.PRODUCT_UNIT PU,
		SETUP_UNIT,
		#dsn3_alias#.PRODUCT P
	WHERE
		P.PRODUCT_ID=PU.PRODUCT_ID
		AND	PU.PRODUCT_UNIT_ID = PR.UNIT_ID
		AND	SETUP_UNIT.UNIT_ID = PU.UNIT_ID
		AND	SETUP_RIVALS.R_ID = PR.R_ID
	<cfif  isDefined("attributes.keyword")  AND len(attributes.keyword)>
		AND 
		(
		P.PRODUCT_NAME LIKE '%#attributes.keyword#%'
		OR 
		SETUP_RIVALS.RIVAL_NAME LIKE '%#attributes.keyword#%'
		)		
	</cfif>	
	<cfif isDefined('attributes.branch_id') and attributes.branch_id>
		AND 
		SETUP_RIVALS.BRANCH_ID=#attributes.branch_id#
	</cfif> 
</cfquery>

<!--- <cfif not isnumeric(SESSION.EP.USER_LOCATION)>
	<cfset LOC=LISTGETAT(#SESSION.EP.USER_LOCATION#,2,"-")>
</cfif>
<cfquery name="get_rival_prices" datasource="#dsn#">
	SELECT
		PRODUCT.PRODUCT_ID,
		PRODUCT.PRODUCT_NAME,
		PRICE_RIVAL.PR_ID,
		PRICE_RIVAL.PRICE,
		PRICE_RIVAL.MONEY,
		PRICE_RIVAL.STARTDATE,
		PRICE_RIVAL.FINISHDATE,
		SETUP_UNIT.UNIT,
		SETUP_RIVALS.RIVAL_NAME,
		PRICE_RIVAL.R_ID,
		'' AS PROPERTY
	FROM
		SETUP_RIVALS,
		#dsn3_alias#.PRICE_RIVAL as PRICE_RIVAL,
		#dsn3_alias#.PRODUCT_UNIT as PRODUCT_UNIT,
		SETUP_UNIT,
		#dsn3_alias#.PRODUCT as PRODUCT
<!--- 		,#dsn3_alias#.STOCKS S --->
	WHERE
		<!--- PRICE_RIVAL.STOCK_ID=S.STOCK_ID
		AND --->
		PRODUCT.PRODUCT_ID=PRODUCT_UNIT.PRODUCT_ID
		AND
		PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_RIVAL.UNIT_ID
		AND
		SETUP_UNIT.UNIT_ID = PRODUCT_UNIT.UNIT_ID
		AND
		SETUP_RIVALS.R_ID = PRICE_RIVAL.R_ID
		AND
		SETUP_RIVALS.BRANCH_ID=#LOC#
	<cfif  isdefined("attributes.keyword")  and len(attributes.keyword)>
		AND 
		(PRODUCT.PRODUCT_NAME LIKE '%#attributes.keyword#%'
		OR 
		SETUP_RIVALS.RIVAL_NAME LIKE '%#attributes.keyword#%'
		)		
	</cfif>	
</cfquery> --->
