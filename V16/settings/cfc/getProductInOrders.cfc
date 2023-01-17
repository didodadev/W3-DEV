<!--- 
    File: getProductInOrders.cfc
    Author: Botan KAYĞAN <botankaygan@workcube.com>
    Date: 05.09.2019
    Controller: -
    Description: Sipariş listesinde bulunan ürünlerin listesini veren servis.
--->

<cfcomponent extends="cfc.queryJSONConverter">
    <cfproperty name="dsn">
    <cfproperty name="dsn3">
    <cfproperty name="dsn_product">

    <cffunction name="init" access="public">
        <cfscript>
            this.dsn = application.SystemParam.SystemParam().dsn;
            this.dsn3 = "#this.dsn#_1";
            this.dsn_product = "#this.dsn#_product";
        </cfscript>
    </cffunction>
    
    <!--- Sipariş listesinde bulunan ürünlerin listesi döndürür.
          Parametre olarak sipariş numarasını alır. Zorunlu değildir. Gelmediği takdirde siparişte olan ürünleri getirir.
    --->
   
    <cffunction name="getProducts" access="public" returntype="any">
        <cfquery name="getProductInOrders" datasource="#this.dsn3#">
            SELECT 
                P.*,
                O.ORDER_NUMBER
            FROM 
                ORDERS AS O INNER JOIN ORDER_ROW AS ORR ON O.ORDER_ID = ORR.ORDER_ID INNER JOIN #this.dsn_product#.PRODUCT AS P ON ORR.PRODUCT_ID = P.PRODUCT_ID
            WHERE
                1=1
                <cfif len(arguments.orderNumber)>
                    AND O.ORDER_NUMBER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.orderNumber#">
                </cfif>
        </cfquery>
        <cfreturn replace(serializeJSON(super.returnData(replace(serializeJSON(getProductInOrders), "//", ""))), "//", "")>
    </cffunction>
</cfcomponent>