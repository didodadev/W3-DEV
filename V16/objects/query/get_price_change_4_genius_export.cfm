<cfif isDefined("attributes.product_cat") and len(attributes.product_cat) and len(attributes.product_catid)>
	<cfquery name="GET_PRODUCT_CATS" datasource="#DSN3#">
		SELECT 
			HIERARCHY
		FROM 
			PRODUCT_CAT 
		WHERE 
			PRODUCT_CATID = #attributes.product_catid#
		ORDER BY 
			HIERARCHY
	</cfquery>		  
</cfif>  
<cfquery name="GET_PRICE_CHANGE_4_GENIUS_EXPORT" datasource="#DSN3#">
	SELECT
		S.PRODUCT_ID,
		S.PRODUCT_NAME,
		S.STOCK_ID,
		S.BARCOD,
		ST.TAX_ID,
		ST.TAX,
		PR.PRICE,
		PR.PRICE_KDV,
		PR.IS_KDV,
		PR.STARTDATE,
		PR.FINISHDATE,
		PU.ADD_UNIT,
		PU.MULTIPLIER
	FROM
		STOCKS S, 
		PRODUCT_UNIT PU,
		#dsn2_alias#.SETUP_TAX ST,
		PRICE_CAT PC, 
		PRICE PR
	WHERE  
		S.IS_INVENTORY = 1 AND
		S.PRODUCT_STATUS = 1 AND
		PC.PRICE_CAT_STATUS = 1 AND
		PR.PRICE > 0 AND
		S.PRODUCT_ID = PU.PRODUCT_ID AND
		S.PRODUCT_ID = PR.PRODUCT_ID AND
		PR.PRICE_CATID = PC.PRICE_CATID AND
		PR.UNIT = PU.PRODUCT_UNIT_ID AND
		PR.UNIT = S.PRODUCT_UNIT_ID AND
		ST.TAX = S.TAX AND
		PC.BRANCH LIKE '%,#attributes.branch_id#,%'
		<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>AND S.STOCK_CODE LIKE '#attributes.hierarchy#%'</cfif>
	<cfif isDefined("attributes.product_cat") and len(attributes.product_cat) and len(attributes.product_catid)><!--- store.list_label sayfasından geliyor ise  --->
		AND S.STOCK_CODE LIKE '#get_product_cats.hierarchy#.%'
	</cfif>
	<cfif isdefined("attributes.from_store")><!--- store.list_label sayfasından geliyor ise  --->
		AND PR.STARTDATE <= #now()#
		AND (PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL)
		AND PR.RECORD_DATE <= #attributes.finishdate#
		AND PR.RECORD_DATE > #attributes.startdate# 
	<cfelse>
	  <cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdefined("attributes.finishdate") and len(attributes.finishdate)>
		AND
		(
			(PR.STARTDATE <= #attributes.finishdate# AND PR.FINISHDATE >= #attributes.startdate#) OR
			(PR.STARTDATE <= #attributes.finishdate# AND PR.FINISHDATE IS NULL)
		)
	  <cfelseif isdefined("attributes.startdate") and len(attributes.startdate)>
		<cfset finishdate = date_add("d",1,attributes.startdate)>
		<cfset finishdate = date_add("n",-1,finishdate)>
		AND PR.STARTDATE BETWEEN #attributes.startdate# AND #finishdate#
	  <cfelseif isdefined("attributes.finishdate") and len(attributes.finishdate)>
		<cfset finishdate = date_add("s",-1,attributes.finishdate)>
		AND PR.FINISHDATE = #finishdate#
	  </cfif>
	</cfif>
	<cfif isdefined("attributes.recorddate") and len(attributes.recorddate)>AND PR.RECORD_DATE >= #attributes.recorddate#</cfif>
	ORDER BY
		S.PRODUCT_ID,
		S.STOCK_ID		
</cfquery>
