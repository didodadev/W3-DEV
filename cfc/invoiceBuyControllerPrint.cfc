<cfcomponent>
	<cffunction name="printBodyColumns" access="remote" returntype="any" returnFormat="json">
        <cfset printBodyList = 'INVOICE_ID$FATURA ID,INVOICE_DATE$FATURA TARIHI,INVOICE_NUMBER$FATURA NO,SERIAL_NO$SERI NO,SERIAL_NUMBER$SERI NO2,NOTE$AÇIKLAMA,DUE_DATE$VADE TARIHI,PAYMETHOD$ÖDEME YÖNTEMI,SHIP_METHOD$SEVK YÖNTEMI,FULLNAME$FIRMA ADI,COMPANY_ADDRESS$FIRMA ADRES,TAXOFFICE$FIRMA VERGI DAIRESI,TAXNO$FIRMA VERGI NO,OZEL_KOD$FIRMA ÖZEL KOD,OZEL_KOD_1$FIRMA ÖZEL KOD2,OZEL_KOD_2$FIRMA ÖZEL KOD3,COMPANY_TELCODE$FIRMA TELEFON KODU,COMPANY_TEL1$FIRMA TELEFON,COMPANY_EMAIL$FIRMA MAIL ADRESI,HOMEPAGE$FIRMA WEB SITESI'>
        <cfreturn Replace(SerializeJSON(printBodyList),'//','')>
    </cffunction>
    <cffunction name="printBodyData" access="remote" returntype="any" returnFormat="json">
        <cfargument name="identityNumber" required="yes" type="numeric">
	    <cfset dsn = application.systemParam.systemParam().dsn>
        <cfset dsn2_alias = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>

        <cfquery name="GET_DATA" datasource="#dsn#">
            SELECT
                I.INVOICE_ID,
                CONVERT(VARCHAR(10),I.INVOICE_DATE,103) AS INVOICE_DATE,
                I.INVOICE_NUMBER,
                I.SERIAL_NO,
                I.SERIAL_NUMBER,
                I.NOTE,
                CONVERT(VARCHAR(10),I.DUE_DATE,103) AS DUE_DATE,
                SP.PAYMETHOD,
                I.SHIP_METHOD,
                C.FULLNAME,
                C.COMPANY_ADDRESS,
                C.TAXOFFICE,
                C.TAXNO,
                C.OZEL_KOD,
                C.OZEL_KOD_1,
                C.OZEL_KOD_2,
                C.COMPANY_TELCODE,
                C.COMPANY_TEL1,
                C.COMPANY_EMAIL,
                C.HOMEPAGE
            FROM
                #dsn2_alias#.INVOICE AS I
                LEFT JOIN COMPANY AS C ON I.COMPANY_ID = C.COMPANY_ID
                LEFT JOIN SETUP_PAYMETHOD AS SP ON SP.PAYMETHOD_ID = I.PAY_METHOD
            WHERE
                I.INVOICE_ID = #arguments.identityNumber#
        </cfquery>
        <cfreturn Replace(SerializeJSON(GET_DATA,1),'//','')>
    </cffunction>
    <cffunction name="printRowColumns" access="remote" returntype="any" returnFormat="json">        
        <cfset printRowList = 'PRODUCT_NAME$ÜRÜN ADI,PRODUCT_DETAIL$AÇIKLAMA,AMOUNT$MIKTAR,PRICE$FIYAT,TAX$KDV,UNIT$BIRIM,DUE_DATE$VADE TARIHI,NETTOTAL$NET TOPLAM,OTHER_MONEY$DÖVIZ,OTHER_MONEY_VALUE$DÖVIZ TUTAR'>
        <cfreturn Replace(SerializeJSON(printRowList),'//','')>
    </cffunction>
    <cffunction name="printRowData" access="remote" returntype="any" returnFormat="json">
        <cfargument name="identityNumber" required="yes" type="numeric">
        
	    <cfset dsn = application.systemParam.systemParam().dsn>
        <cfset dsn2_alias = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
        <cfset dsn3_alias = '#dsn#_#session.ep.company_id#'>
        <cfquery name="GET_DATA" datasource="#dsn#">
            SELECT
                P.PRODUCT_NAME,
                P.PRODUCT_DETAIL,
                IR.UNIT,
                IR.AMOUNT,
                IR.TAX,
                IR.PRICE,
                IR.NETTOTAL,
                IR.DUE_DATE,
                IR.OTHER_MONEY,
                IR.OTHER_MONEY_VALUE
            FROM
                #dsn2_alias#.INVOICE_ROW AS IR
                LEFT JOIN #dsn3_alias#.PRODUCT AS P ON IR.PRODUCT_ID = P.PRODUCT_ID
            WHERE
                IR.INVOICE_ID = #arguments.identityNumber#
        </cfquery>
        <cfreturn Replace(SerializeJSON(GET_DATA,1),'//','')>
    </cffunction>
    <cffunction name="printExtraColumns" access="remote" returntype="string" returnFormat="plain">
        <cfargument name="data" required="yes" type="any">
        <cfargument name="tableName" required="yes" type="string">
        <cfargument name="IDENTITYNAME" required="yes" type="string">
	    <cfset dsn = application.systemParam.systemParam().dsn>
        <cfset workcube_mode = application.systemParam.systemParam().workcube_mode>
        
        <cfreturn getTableInfo>
    </cffunction>
    <cffunction name="printExtraData" access="remote" returntype="string" returnFormat="plain">
        <cfargument name="data" required="yes" type="any">
        <cfargument name="tableName" required="yes" type="string">
        <cfargument name="IDENTITYNAME" required="yes" type="string">
	    <cfset dsn = application.systemParam.systemParam().dsn>
        <cfset workcube_mode = application.systemParam.systemParam().workcube_mode>
        
        <cfreturn getTableInfo>
    </cffunction>
</cfcomponent>