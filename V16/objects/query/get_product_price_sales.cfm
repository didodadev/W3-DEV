<cfquery name="GET_PRODUCT_PRICE" datasource="#dsn3#">
	SELECT
		DISTINCT
		P.PRICE_ID,
		P.PRICE,
		P.PRICE_KDV,
		P.MONEY,
		P.RECORD_EMP,
		P.STARTDATE,
		P.FINISHDATE,
		PU.ADD_UNIT,
		PU.PRODUCT_UNIT_ID,
		PU.WEIGHT,
	<cfif isdefined("attributes.stock_id")>
		S.PROPERTY,
	</cfif>
		PC.PRICE_CAT,
		PC.PRICE_CATID,
		PC.NUMBER_OF_INSTALLMENT,
		PC.AVG_DUE_DAY
	FROM
		PRICE AS P,
		PRICE_CAT AS PC,
		PRODUCT_UNIT AS PU
	<cfif isdefined("attributes.stock_id")>
		,STOCKS AS S
	</cfif>
	WHERE
	<cfif isdefined("attributes.stock_id")>
		S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID AND
	</cfif>
	<cfif isdefined("attributes.product_id")>
		P.PRODUCT_ID = #attributes.product_id# AND
	</cfif>
		P.PRICE_CATID = PC.PRICE_CATID AND
		P.STARTDATE <= #now()# AND 
		(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
		P.UNIT = PU.PRODUCT_UNIT_ID 
	<cfif isdefined("attributes.stock_id")>
		AND S.STOCK_ID=#attributes.stock_id#
	</cfif>
	<cfif  not (get_module_user(5)) and isdefined("attributes.is_store_module")>
		AND PC.BRANCH LIKE '%,#listgetat(session.ep.user_location,2,'-')#,%'
	</cfif>
	ORDER BY
		<!--- P.STARTDATE DESC, --->
		PC.PRICE_CAT
</cfquery>
