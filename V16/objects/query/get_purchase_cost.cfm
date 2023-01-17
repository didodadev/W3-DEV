<cfquery name="GET_PURCHASE_COST" datasource="#DSN2#" maxrows="5">
	SELECT DISTINCT
		I.INVOICE_ID,
		IR.PRICE, 
		IR.PRICE_OTHER,
		IR.OTHER_MONEY, 
		IR.NAME_PRODUCT, 
		IR.DISCOUNT1,
		IR.DISCOUNT2, 
		IR.DISCOUNT3, 
		IR.DISCOUNT4, 
		IR.DISCOUNT5, 
		I.INVOICE_DATE,
		I.COMPANY_ID,
		I.CONSUMER_ID,
		IR.UNIT,
		IR.STOCK_ID,
        I.INVOICE_CAT,
		PC.PROCESS_TYPE,
		PC.PROCESS_CAT
	FROM	
		INVOICE_ROW AS IR,
		INVOICE AS I,
		#dsn3_alias#.SETUP_PROCESS_CAT PC
	WHERE
	<cfif isdefined("attributes.stock_id")>
		IR.STOCK_ID=#attributes.stock_id# AND
	</cfif>
	<cfif isdefined("attributes.is_store_module")>
		I.DEPARTMENT_ID IN
			(
				SELECT 
					DEPARTMENT_ID
				FROM 
					#dsn_alias#.DEPARTMENT D
				WHERE
					D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
			) AND
	</cfif>
	    I.PURCHASE_SALES = 0 AND
		ISNULL(I.IS_IPTAL,0)=0 AND
		I.INVOICE_ID = IR.INVOICE_ID AND
		I.INVOICE_CAT=PC.PROCESS_TYPE AND
		I.PROCESS_CAT = PC.PROCESS_CAT_ID
	<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
		AND
			(
			(I.CONSUMER_ID IS NULL AND I.COMPANY_ID IS NULL) 
			OR (I.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
			OR (I.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
			)
	</cfif>
	ORDER BY
		I.INVOICE_DATE DESC
</cfquery>