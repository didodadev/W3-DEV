<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
  <cf_date tarih = "attributes.start_date">
</cfif>

<cfquery name="get_invoice_rows" datasource="#dsn2#">
 SELECT
   I.INVOICE_NUMBER,
   I.INVOICE_DATE,
   I.PARTNER_ID,
   I.CONSUMER_ID,
   I.COMPANY_ID,
   IR.INVOICE_ID,
   IR.PURCHASE_SALES,
   IR.STOCK_ID,
   IR.AMOUNT,
   P.PRODUCT_NAME,
   S.PRODUCT_ID,
   S.STOCK_CODE
 FROM
   INVOICE I,
   INVOICE_ROW IR,
   #dsn3_alias#.STOCKS S,
   #dsn3_alias#.PRODUCT P
 WHERE
   I.INVOICE_ID = IR.INVOICE_ID
     AND
   IR.STOCK_ID = S.STOCK_ID
     AND
   <cfif isdefined("stock_ids") and len(stock_ids)>
    IR.STOCK_ID NOT IN (#stock_ids#)
	 AND
   </cfif>
   S.PRODUCT_ID = P.PRODUCT_ID 
 <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
     AND
   I.INVOICE_DATE >= #attributes.start_date#
<!--- <cfelse>
      AND
   I.INVOICE_DATE >= #NOW()# --->
 </cfif> 
 <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
   AND
   (
	   P.PRODUCT_NAME LIKE '%#attributes.keyword#%'
		 OR
	   I.INVOICE_NUMBER  LIKE '%#attributes.keyword#%'
   )
 </cfif> 
 <cfif isDefined("attributes.take")>
   AND
	 IR.PURCHASE_SALES = 0 
 <cfelseif isDefined("attributes.sale")>
   AND
	 IR.PURCHASE_SALES = 1
 </cfif>
 ORDER BY I.INVOICE_DATE DESC
</cfquery>



