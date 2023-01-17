<cfquery name="GET_STKS" datasource="#attributes.DSN2#">
	SELECT 
		P.PRODUCT_NAME,
		S.PROPERTY, 
		S.STOCK_ID,
		S.STOCK_CODE,
		S.BARCOD		
	FROM 
		PRODUCT P,
		STOCKS S
	WHERE  
		S.PRODUCT_ID = P.PRODUCT_ID
</cfquery>

<cfquery name="qry1_1" datasource="#attributes.DSN#">		
	SELECT
		SUM(INVOICE_ROW_POS.NETTOTAL) AS NETTOTAL,
		SUM(INVOICE_ROW_POS.GROSSTOTAL) AS GROSSTOTAL,
		SUM(AMOUNT) AMOUNT,
		SUM(AMOUNT*PRODUCT_UNIT.MULTIPLIER) AMOUNT_MAINUNIT,
		INVOICE.DEPARTMENT_ID,
		INVOICE_ROW_POS.STOCK_ID,
		PRODUCT_UNIT.ADD_UNIT AS UNIT,
		INVOICE_ROW_POS.PRODUCT_ID
	FROM
		INVOICE,
		INVOICE_ROW_POS,
		#attributes.DSN3_alias#.PRODUCT_UNIT PRODUCT_UNIT,
		#attributes.DSN3_alias#.STOCKS S
	WHERE
		S.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND 
        S.STOCK_ID = INVOICE_ROW_POS.STOCK_ID AND 
        INVOICE_ROW_POS.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND 
        INVOICE_ROW_POS.PRICE > 0 AND 
        INVOICE.INVOICE_ID = INVOICE_ROW_POS.INVOICE_ID AND 
        INVOICE_ROW_POS.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #attributes.DSN3_alias#.PRODUCT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.get_company_id#">) 			
	<cfif isdate(attributes.date_start) and isdate(attributes.date_end)>
        AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date_end#">
    </cfif>	
	<cfif isdefined("attributes.dep_id")>
        AND INVOICE.DEPARTMENT_ID IN (#attributes.dep_id#)
    </cfif>		
	GROUP BY 
		INVOICE_ROW_POS.STOCK_ID,
        PRODUCT_UNIT.ADD_UNIT,
        INVOICE.DEPARTMENT_ID,
        INVOICE_ROW_POS.PRODUCT_ID
</cfquery>

<cfquery name="qry1_2" datasource="#attributes.DSN#">
	SELECT
		SUM(INVOICE_ROW.NETTOTAL) AS NETTOTAL,
		SUM(INVOICE_ROW.GROSSTOTAL) AS GROSSTOTAL,
		SUM(AMOUNT) AMOUNT,
		SUM(AMOUNT*PRODUCT_UNIT.MULTIPLIER) AMOUNT_MAINUNIT,
		INVOICE.DEPARTMENT_ID,
		INVOICE_ROW.STOCK_ID,
		INVOICE_ROW.UNIT,
		INVOICE_ROW.PRODUCT_ID
	FROM
		INVOICE,
		INVOICE_ROW,
		#attributes.DSN3_alias#.PRODUCT_UNIT PRODUCT_UNIT
	WHERE
		INVOICE_ROW.UNIT = PRODUCT_UNIT.ADD_UNIT AND 
        INVOICE_ROW.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND 
        INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND 
        INVOICE.INVOICE_CAT IN (#attributes.cat_id#) AND 
        INVOICE.DEPARTMENT_ID IS NOT NULL AND 
        INVOICE_ROW.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #attributes.DSN3_alias#.PRODUCT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.get_company_id#">) 	
	<cfif isdate(attributes.date_start) and isdate(attributes.date_end)>
        AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date_end#">
    </cfif>	
    <cfif isdefined("attributes.dep_id")>
        AND INVOICE.DEPARTMENT_ID IN (#attributes.dep_id#)
    </cfif>		
	GROUP BY 
		INVOICE_ROW.STOCK_ID,
       	INVOICE_ROW.UNIT,
        INVOICE.DEPARTMENT_ID, 
        INVOICE_ROW.PRODUCT_ID
</cfquery>

<cfquery name="qry2" dbtype="query">
	SELECT * FROM  qry1_2
	UNION 
	SELECT * FROM qry1_1	
</cfquery>

<cfquery name="qry1" dbtype="query">
	SELECT 
		SUM(NETTOTAL) AS NETTOTAL,
		SUM(GROSSTOTAL) AS GROSSTOTAL,
		SUM(AMOUNT) AMOUNT,
		AMOUNT_MAINUNIT,
		DEPARTMENT_ID,
		STOCK_ID,
		UNIT,
		PRODUCT_ID	
	 FROM  
	 	QRY2
	 GROUP BY 
 		DEPARTMENT_ID,
		STOCK_ID,
		UNIT,
		PRODUCT_ID,AMOUNT_MAINUNIT
</cfquery>
	<!--- BASLIKLARIN YAZDIRILMASI /start --->
    <tr class="color-header">
        <td class="form-title"><cfoutput>#caller.getLang('main',106)#</cfoutput></td><!---Stok Kodu--->
        <td class="form-title"><cfoutput>#caller.getLang('main',221)#</cfoutput></td><!---Barkod--->
        <td class="form-title"><cfoutput>#caller.getLang('main',809)#</cfoutput></td><!---Ürün Adı--->
        <td class="form-title"><cfoutput>#caller.getLang('main',40)#</cfoutput></td><!---Stok--->
        <td class="form-title"><cfoutput>#caller.getLang('main',2162)#</cfoutput></td><!---Satış Miktar--->
        <td class="form-title"><cfoutput>#caller.getLang('main',224)#</cfoutput></td><!---Birim--->
        <td class="form-title"><cfoutput>#caller.getLang('main',2163)#</cfoutput></td><!---Satış KDVsiz--->
        <td class="form-title"><cfoutput>#caller.getLang('main',2164)#</cfoutput></td><!---Satış KDVli--->
    </tr>
	<!--- BASLIKLARIN YAZDIRILMASI /end --->

<cfoutput query="qry1">
	<cfquery name="get_det" dbtype="query">
		SELECT * FROM GET_STKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
	</cfquery>
	<tr class="color-row" height="20">
		<td width="120">#get_det.stock_code#</td>
		<td width="81">#get_det.barcod#</td>
		<td width="95">#get_det.product_name#</td>
		<td width="90">#get_det.property#</td>
		<td width="60">#caller.TLFormat(Round(amount))#</td>
		<td width="95">
			<cfif not len(UNIT)>
				<cfquery name="get_u" dbtype="query">
					SELECT GET_PRO_UNITS.ADD_UNIT FROM GET_PRO_UNITS,GET_STKS WHERE GET_STKS.PRODUCT_UNIT_ID = GET_PRO_UNITS.PRODUCT_UNIT_ID
				</cfquery>
				#get_u.add_unit#
			<cfelse>
				#unit#
			</cfif>
		</td>
		<td width="206" align="right">#caller.TLFormat(nettotal)#</td>
		<td width="227" align="right">#caller.TLFormat(grosstotal)#</td>
	</tr>
</cfoutput>
