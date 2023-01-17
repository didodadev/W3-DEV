<cfset invoice_bill_upd=arraynew(2)>
<cfquery name="GET_INVOICE_ROW" datasource="#db_adres#">
	SELECT 
		INVOICE_ROW.NETTOTAL,
		INVOICE_ROW.AMOUNT,      
		INVOICE_ROW.PAY_METHOD,      
		INVOICE_ROW.PRICE,      
		INVOICE_ROW.TAXTOTAL,      
		INVOICE_ROW.GROSSTOTAL,
		INVOICE_ROW.DISCOUNT1,  
		INVOICE_ROW.DISCOUNT2,  
		INVOICE_ROW.DISCOUNT3,  
		INVOICE_ROW.DISCOUNT4,  
		INVOICE_ROW.DISCOUNT5, 
		INVOICE_ROW.DISCOUNT6,    
		INVOICE_ROW.DISCOUNT7,  
		INVOICE_ROW.DISCOUNT8, 
		INVOICE_ROW.DISCOUNT9,   
		INVOICE_ROW.DISCOUNT10, 
		INVOICE_ROW.OTHER_MONEY_VALUE,  
		INVOICE_ROW.OTHER_MONEY, 
		INVOICE_ROW.SPECT_VAR_NAME,   
		INVOICE_ROW.TAX,
		INVOICE_ROW.UNIT,      
        INVOICE_ROW.DESCRIPTION,   
		INVOICE_ROW.DISCOUNTTOTAL      
		<cfif not listfind("65,66",get_sale_det.invoice_cat,',')><!--- Demirbaş faturalarında stok olmadığı düşünülerek stocks tablosuna bağlanmasın diye koyduk --->
			,STOCKS.STOCK_ID
			,STOCKS.PRODUCT_ID
			,STOCKS.PROPERTY
			,PRODUCT.PRODUCT_ID
			,INVOICE_ROW.NAME_PRODUCT AS PRODUCT_NAME
			,PRODUCT.IS_PROTOTYPE
		</cfif>
	FROM 
		INVOICE_ROW
		<cfif not listfind("65,66",get_sale_det.invoice_cat,',')>
			,#dsn3_alias#.STOCKS AS STOCKS
			,#dsn3_alias#.PRODUCT AS PRODUCT
		</cfif>
	WHERE 
		<cfif not listfind("65,66",get_sale_det.invoice_cat,',')>
            INVOICE_ROW.STOCK_ID = STOCKS.STOCK_ID AND 
            STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND 
        </cfif>
        <cfif not isDefined("attributes.ID")>
            INVOICE_ROW.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
        <cfelse>
            INVOICE_ROW.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfif> 
</cfquery>
<cfset list_kdv = "" >
<cfset sepet.kdv_array = ArrayNew(2)>
<cfoutput query="get_invoice_row">
	<cfif not listfind("65,66",get_sale_det.invoice_cat,',')>
        <cfscript>
            invoice_bill_upd[currentrow][1] = product_id;
            invoice_bill_upd[currentrow][2] = "#product_name#-#property#";
            invoice_bill_upd[currentrow][10] = stock_id;
            invoice_bill_upd[currentrow][15]=  nettotal+discounttotal; //amount*price;
            invoice_bill_upd[currentrow][32]=  IS_PROTOTYPE;
        </cfscript>
    <cfelse>
        <cfscript>
            invoice_bill_upd[currentrow][2] = description;
            invoice_bill_upd[currentrow][15]=  nettotal; 
            invoice_bill_upd[currentrow][32]=  0;
        </cfscript>
    </cfif>
    <cfscript>
        invoice_bill_upd[currentrow][4] = amount;
        invoice_bill_upd[currentrow][5] = unit;
        invoice_bill_upd[currentrow][6] = price;
        invoice_bill_upd[currentrow][8] = discounttotal;
        invoice_bill_upd[currentrow][14] = pay_method;
        invoice_bill_upd[currentrow][16] = nettotal;
        invoice_bill_upd[currentrow][17] = taxtotal;
        invoice_bill_upd[currentrow][18] = grosstotal;
        invoice_bill_upd[currentrow][19] = 0;
        invoice_bill_upd[currentrow][20] = discount1; 
        invoice_bill_upd[currentrow][21] = discount2;
        invoice_bill_upd[currentrow][22] = discount3;
        invoice_bill_upd[currentrow][23]=  discount4;
        invoice_bill_upd[currentrow][24]=  discount5;
        invoice_bill_upd[currentrow][25]=  discount6;
        invoice_bill_upd[currentrow][26] = discount7;
        invoice_bill_upd[currentrow][27] = discount8;
        invoice_bill_upd[currentrow][28] = discount9;
        invoice_bill_upd[currentrow][29] = discount10;
        invoice_bill_upd[currentrow][30] = other_money_value;
        invoice_bill_upd[currentrow][31] = other_money;
        invoice_bill_upd[currentrow][33] = spect_var_name;
    </cfscript>
    <cfif len(tax)>
        <cfset invoice_bill_upd[currentrow][7] = tax>
        <!--- <cfset invoice_bill_upd[currentrow][17] = satir_tax_tutar> --->
    <cfelse>
        <cfif nettotal neq 0>
            <cfset invoice_bill_upd[currentrow][7] = (taxtotal/nettotal)*100 > 
        <cfelse>	
            <cfset invoice_bill_upd[currentrow][7] = 0>
        </cfif>
    </cfif>		
    <cfscript>
        kdv_flag = 0;
        for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		{
			if (sepet.kdv_array[k][1] eq invoice_bill_upd[currentrow][7])
			{
				kdv_flag = 1;
				sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + invoice_bill_upd[currentrow][17];
			}
		}
        if (not kdv_flag)
        {
            sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = invoice_bill_upd[currentrow][7];
            sepet.kdv_array[arraylen(sepet.kdv_array)][2] = invoice_bill_upd[currentrow][17];
        }	
    </cfscript>
</cfoutput>
