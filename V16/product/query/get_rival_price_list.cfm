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
		PR.UNIT_ID,
		PR.PRICE_TYPE
	FROM
		<cfif isDefined('attributes.branch_id') and attributes.branch_id>
		SETUP_RIVALS_BRANCH,
		</cfif>
		SETUP_RIVALS,
		#dsn3_alias#.PRICE_RIVAL PR,
		#dsn3_alias#.PRODUCT_UNIT PU,
		SETUP_UNIT,
		#dsn3_alias#.PRODUCT P,
		#dsn#_retail.RIVAL_PRICE_TYPES RE
	WHERE
		P.PRODUCT_ID=PU.PRODUCT_ID AND
		PU.PRODUCT_UNIT_ID = PR.UNIT_ID AND
		SETUP_UNIT.UNIT_ID = PU.UNIT_ID AND
		SETUP_RIVALS.R_ID = PR.R_ID
	<cfif  isDefined("attributes.keyword")  AND len(attributes.keyword)>
		AND (P.PRODUCT_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR SETUP_RIVALS.RIVAL_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)		
	</cfif>	
	<cfif isDefined('attributes.branch_id') and attributes.branch_id>
		AND 
		SETUP_RIVALS_BRANCH.BRANCH_ID = #attributes.branch_id# AND
		SETUP_RIVALS.R_ID = SETUP_RIVALS_BRANCH.R_ID
	</cfif>
	<cfif isdefined("attributes.pid") and  len(attributes.pid) and isdefined("attributes.txt_product") and len(attributes.txt_product)>
		AND P.PRODUCT_ID = #attributes.pid#
	</cfif> 
	<cfif isdefined("attributes.r_id") and len(attributes.r_id)>
		AND PR.R_ID = #attributes.r_id#
	</cfif>
</cfquery>
