<cfcomponent>
    <cffunction name="printBodyColumns" access="remote" returntype="string" returnFormat="plain">
        <cfset printBodyList = 'ORDER_ID$SİPARİŞ ID,ORDER_DATE$SİPARİŞ TARIHI,ORDER_NUMBER$SİPARİŞ NO'>
        <cfreturn printBodyList>
    </cffunction>
    <cffunction name="printBodyData" access="remote" returntype="any" returnFormat="json">
        <cfargument name="identityNumber" required="yes" type="numeric">
	    <cfset dsn = application.systemParam.systemParam().dsn>
        <cfset dsn3_alias = '#dsn#_#session.ep.company_id#'>

        <cfquery name="GET_DATA" datasource="#dsn#">
            SELECT
                O.ORDER_ID,
                CONVERT(VARCHAR(10),O.ORDER_DATE,103) AS ORDER_DATE,
                O.ORDER_NUMBER
            FROM
                #dsn3_alias#.ORDERS AS O
            WHERE
                O.ORDER_ID = #arguments.identityNumber#
        </cfquery>
        <cfreturn Replace(SerializeJSON(GET_DATA,1),'//','')>
    </cffunction>
    <cffunction name="printRowColumns" access="remote" returntype="string" returnFormat="plain">        
        <cfset printRowList = 'PRODUCT_NAME$ÜRÜN ADI,PRODUCT_DETAIL$AÇIKLAMA,AMOUNT$MIKTAR,PRICE$FIYAT,TAX$KDV,UNIT$BIRIM,DUE_DATE$VADE TARIHI,NETTOTAL$NET TOPLAM,OTHER_MONEY$DÖVIZ,OTHER_MONEY_VALUE$DÖVIZ TUTAR'>
        <cfreturn printRowList>
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
                OR2.UNIT,
                OR2.QUANTITY AS AMOUNT,
                OR2.TAX,
                OR2.PRICE,
                OR2.NETTOTAL,
                OR2.DUEDATE AS DUE_DATE,
                OR2.OTHER_MONEY,
                OR2.OTHER_MONEY_VALUE
            FROM
                #dsn3_alias#.ORDER_ROW AS OR2
                LEFT JOIN #dsn3_alias#.PRODUCT AS P ON OR2.PRODUCT_ID = P.PRODUCT_ID
            WHERE
                OR2.ORDER_ID = #arguments.identityNumber#
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