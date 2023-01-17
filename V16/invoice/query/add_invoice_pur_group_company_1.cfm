<cfquery name="ADD_INVOICE_SALE" datasource="#new_dsn2#" result="MAX_ID">
	INSERT INTO INVOICE
		(
		IS_CASH,
		KASA_ID,
		<cfif isDefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
			<cfif attributes.EMPO_ID>
				SALE_EMP,
			<cfelse>
				SALE_PARTNER,
			</cfif>
		</cfif>
		SHIP_NUMBER,
		PURCHASE_SALES,
		INVOICE_NUMBER,
		INVOICE_CAT,
		INVOICE_DATE,
		COMPANY_ID,
		NETTOTAL,
		GROSSTOTAL,
		GROSSTOTAL_WITHOUT_ROUND,
		TAXTOTAL,
		SA_DISCOUNT,
		NOTE,
		DELIVER_EMP,
		DEPARTMENT_ID,
		DEPARTMENT_LOCATION,
		SHIP_METHOD,
		PAY_METHOD,
		UPD_STATUS,
		OTHER_MONEY,
		OTHER_MONEY_VALUE,
		PROCESS_CAT,
		IS_WITH_SHIP,
		ROUND_MONEY,
		RECORD_DATE,
		RECORD_EMP
	)
	VALUES
	(
		<cfif isDefined("FORM.CASH")>1,#KASA#,<cfelse>0,NULL,</cfif>
		<cfif isDefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
			<cfif attributes.EMPO_ID>
				#EMPO_ID#,
			<cfelse>
				#PARTO_ID#,
			</cfif>
		</cfif>
		'#get_invoice.SHIP_NUMBER#',
		0,
		'#get_invoice.INVOICE_NUMBER#',
		#INVOICE_CAT#,
		#attributes.invoice_date#,
		#attributes.company_id#,
		#get_invoice.NETTOTAL#,
		#get_invoice.GROSSTOTAL#,
		<cfif len(get_invoice.GROSSTOTAL_WITHOUT_ROUND)>#get_invoice.GROSSTOTAL_WITHOUT_ROUND#,<cfelse>0,</cfif>
		#get_invoice.TAXTOTAL#,
		#get_invoice.SA_DISCOUNT#,
		'#get_invoice.NOTE#',
		'#LEFT(TRIM(DELIVER_GET_ID),50)#',
		#attributes.department_id#,
		#attributes.location_id#,
		<cfif len(get_invoice.SHIP_METHOD)>#get_invoice.SHIP_METHOD#,<cfelse>NULL,</cfif>
		#get_invoice.PAY_METHOD#,
		1,
		'#get_invoice.OTHER_MONEY#',
		#get_invoice.OTHER_MONEY_VALUE#,
		#FORM.PROCESS_CAT#,
		<cfif len(get_invoice.IS_WITH_SHIP)>#get_invoice.IS_WITH_SHIP#,<cfelse>NULL,</cfif>
		<cfif len(get_invoice.ROUND_MONEY)>#get_invoice.ROUND_MONEY#<cfelse>0</cfif>,
		#now()#,
		#SESSION.EP.USERID#
	)
</cfquery>
<cfoutput query="get_invoice_row">
	<cfset attributes.deliver_date = dateformat(DELIVER_DATE,dateformat_style) >
	<cf_date tarih = "attributes.deliver_date">
<!--- 	<cfset attributes.duedate = datediff(DUE_DATE,dateformat_style) >
	<cf_date tarih = "attributes.duedate"> --->
	<cfquery name="ADD_SHIP_ROW" datasource="#new_dsn2#">
		INSERT INTO
			INVOICE_ROW
			(
				PURCHASE_SALES,
				PRODUCT_ID,
				NAME_PRODUCT,
				INVOICE_ID,
				STOCK_ID,
				AMOUNT,
				UNIT,
				UNIT_ID,					
				PRICE,
				GROSSTOTAL,
				NETTOTAL,
				TAXTOTAL,
				DISCOUNTTOTAL,
				TAX,
				DISCOUNT1,
				DISCOUNT2,
				DISCOUNT3,
				DISCOUNT4,
				DISCOUNT5,
				DISCOUNT6,
				DISCOUNT7,
				DISCOUNT8,
				DISCOUNT9,
				DISCOUNT10,				
				DELIVER_DATE,
				DELIVER_DEPT,
				DELIVER_LOC,
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
				SPECT_VAR_ID,
				SPECT_VAR_NAME,
				LOT_NO,
				PRICE_OTHER,
				OTHER_MONEY_GROSS_TOTAL,
				IS_PROMOTION
			)
		VALUES
			(
				0,
				#PRODUCT_ID#,
				'#NAME_PRODUCT#',
				#MAX_ID.IDENTITYCOL#,
				#STOCK_ID#,				
				#AMOUNT#,
				'#UNIT#',
				#UNIT_ID#,
				#PRICE#,
				#GROSSTOTAL#,
				#NETTOTAL#,
				#TAXTOTAL#,
				#DISCOUNTTOTAL#,
				#TAX#,
				#DISCOUNT1#,
				#DISCOUNT2#,
				#DISCOUNT3#,
				#DISCOUNT4#,
				#DISCOUNT5#,
				#DISCOUNT6#,
				#DISCOUNT7#,
				#DISCOUNT8#,
				#DISCOUNT9#,
				#DISCOUNT10#,				
				#attributes.deliver_date#,
				#attributes.department_id#,
				#attributes.location_id#,
				'#OTHER_MONEY#',
				#OTHER_MONEY_VALUE#,
				<cfif len(SPECT_VAR_ID)>#SPECT_VAR_ID#,<cfelse>NULL,</cfif>
				'#SPECT_VAR_NAME#',
				'#LOT_NO#',
				#PRICE_OTHER#,
				#OTHER_MONEY_GROSS_TOTAL#,
				0
			)
	</cfquery>
</cfoutput>
