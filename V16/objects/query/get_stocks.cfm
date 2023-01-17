<cfquery name="GET_STOCKS_ALL" datasource="#dsn2#">
	SELECT
		SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK, 
		S.PRODUCT_ID, 
		S.STOCK_ID, 
		S.STOCK_CODE, 
		S.PROPERTY, 
		S.BARCOD,
		SR.STORE AS DEPARTMENT_ID,
		D.DEPARTMENT_HEAD
	FROM
		#dsn1_alias#.STOCKS S,
		STOCKS_ROW SR,
		#dsn_alias#.DEPARTMENT D
	WHERE
		S.STOCK_ID = SR.STOCK_ID AND
        <cfif isdefined("attributes.PID") and len(attributes.PID)>
        	S.PRODUCT_ID = #attributes.PID# AND
		</cfif>
		<cfif isdefined("attributes.sid") and len(attributes.sid)>
			S.STOCK_ID=#attributes.sid# AND
		</cfif>
		SR.STORE = D.DEPARTMENT_ID
		<cfif isdefined("attributes.is_store_module")>
			AND D.BRANCH_ID IN(SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		</cfif>
	GROUP BY
		S.PRODUCT_ID, 
		S.STOCK_ID, 
		S.STOCK_CODE, 
		S.PROPERTY, 
		S.BARCOD, 
		SR.STORE,
		D.DEPARTMENT_HEAD
	ORDER BY
		D.DEPARTMENT_HEAD
</cfquery>
