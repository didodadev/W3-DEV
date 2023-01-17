<!--- 
    Fatura Basketteki Ürünlerin QR Code Baskı Şablonudur.
    Esma R. Uysal <esmauysal@workcube.com>
 --->
<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="Get_Invoice" datasource="#dsn2#">
	SELECT 
    	COMPANY_ID,
        CONSUMER_ID,
        DEPARTMENT_ID,
        SHIP_METHOD,
        INVOICE_DATE,
        INVOICE_NUMBER,
        INVOICE_CAT,
        NOTE,
        INVOICE_ID,
        SHIP_ADDRESS,
        NETTOTAL,
        GROSSTOTAL,
        TAXTOTAL,
        SA_DISCOUNT,
        TEVKIFAT_ORAN,
        OTHER_MONEY,
        TEVKIFAT,
        TEVKIFAT_ID
    FROM 
    	INVOICE 
    WHERE 
	<cfif not isDefined("attributes.ID")>
        INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
    <cfelse>
        INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfif>
</cfquery>
<cfquery name="Get_Invoice_Row" datasource="#dsn2#">
    SELECT 
        IR.*,
        S.PROPERTY,
        IR.NAME_PRODUCT AS PRODUCT_NAME,
        S.STOCK_CODE
    FROM 
        INVOICE_ROW IR, 
        #dsn3_alias#.STOCKS S
    WHERE 
        IR.STOCK_ID = S.STOCK_ID AND
        <cfif not isDefined("attributes.ID")>
        	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#"> <!--- _sil neden integer i liste gibi kullaniyor? --->
        <cfelse>
        	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfif>
    ORDER BY
        IR.INVOICE_ROW_ID 
</cfquery>

<cfoutput query="Get_Invoice_Row">
	<cf_medium_list><!---medium_list olmasının sebebi sayfa, bilanço kaydedilirken textara içerisine yazıdırılmasıdır. layout alanında fonksiyonların çakışmasını engellemek için yapılmışdır. OS290414--->
		<thead>
            <tr>
                <th></th>
                <th>Stok Kodu - <cf_get_lang dictionary_id="58221.Ürün Adı"></th>
                <th>LOT NO</th>
                <th>Birim 2</th>
                <th>Miktar 2</th>
                <th>Birim</th>
                <th>Miktar</th>
                <th>Belge No</th>
                <th>Belge Tarihi</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><cf_workcube_barcode show="1" type="qrcode" width="150" height="150" value="STOK KODU:#STOCK_CODE#;URUN ADI:#NAME_PRODUCT#;LOT NO:#lot_no#;BIRIM 2:#unit2#;MIKTAR 2:#amount2#;BIRIM:#unit#;MIKTAR:#amount#;BELGE NO:#Get_Invoice.Invoice_Number#;BELGE TARIHI:#dateformat(Get_Invoice.Invoice_Date,dateformat_style)#"></td>
                <td>#STOCK_CODE# - #NAME_PRODUCT#</td>
                <td>#LOT_NO#</td>
                <td>#UNIT2#</td>
                <td>#AMOUNT2#</td>
                <td>#UNIT#</td>
                <td>#AMOUNT#</td>
                <td>#Get_Invoice.Invoice_Number#</td>
                <td>#dateformat(Get_Invoice.Invoice_Date,dateformat_style)#</td>
            </tr>
         </tbody>
    </cf_medium_list>
</cfoutput>