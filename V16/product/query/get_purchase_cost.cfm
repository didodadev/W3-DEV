<!--- 
	Bu sayfadan objects*query icindede var orayida update ediniz.arzubt 051122003
--->
<cfquery name="GET_PURCHASE_COST" datasource="#DSN2#" maxrows="5">
	SELECT DISTINCT
		IR.PRICE, 
		IR.PRICE_OTHER,
		IR.OTHER_MONEY,
		IR.DISCOUNT1, 
		IR.DISCOUNT2, 
		IR.DISCOUNT3, 
		IR.DISCOUNT4, 
		IR.DISCOUNT5,
		IR.AMOUNT,
		I.INVOICE_DATE,
		I.CONSUMER_ID, 
		I.COMPANY_ID,
		IR.UNIT,
		(IR.DISCOUNT_COST*(INV_M.RATE2/INV_M.RATE1)) AS DISCOUNT_COST <!--- iskonto tutarın sistem para birimi karşılığı alınıyor --->
	FROM	
		INVOICE_ROW AS IR,
		INVOICE AS I,
		INVOICE_MONEY AS INV_M,
		#dsn3_alias#.STOCKS AS ST
	WHERE
		ST.PRODUCT_ID = #attributes.pid#
		AND	ST.STOCK_ID = IR.STOCK_ID
		AND	I.PURCHASE_SALES = 0
		AND ISNULL(I.IS_IPTAL,0)=0 
		AND	I.INVOICE_ID = IR.INVOICE_ID
		AND INV_M.ACTION_ID=I.INVOICE_ID
		AND INV_M.MONEY_TYPE=IR.OTHER_MONEY
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
