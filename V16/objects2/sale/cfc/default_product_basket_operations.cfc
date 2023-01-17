<cfcomponent extends="V16/objects2/sale/cfc/basketAction">
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    <cfelseif isdefined("session.qq")>
        <cfset session_base = evaluate('session.qq')>
    </cfif>

    <cfset dsn = application.systemParam.systemParam().dsn />
    <cfset dsn1 = "#dsn#_product" />
    <cfset dsn3 = "#dsn#_#session_base.company_id#" />
    <cfset workcube_mode = application.systemParam.systemParam().workcube_mode />

    <cfset siteMethods = createObject("component","catalyst/AddOns/Yazilimsa/Protein/cfc/siteMethods") />

    <cffunction name = "basket_operations" returnType = "any" returnformat = "JSON" access = "remote" description = "Basket Operations">
        <cfargument name="product_id">
        <cfargument name="quantity">
        <cfargument name="widget_id">

        <cfset response = structNew() />
        <cfset products = arrayNew(1) />
        <cfset quantities = arrayNew(1) />

        <cfif isArray( arguments.product_id )><cfset products = arguments.product_id /><cfelse><cfset products[1] = arguments.product_id /></cfif>
        <cfif isArray( arguments.quantity )><cfset quantities = arguments.quantity /><cfelse><cfset quantities[1] = arguments.quantity /></cfif>

        <cftry>

            <cfset getWidget = deserializeJSON(siteMethods.get_widget(id: arguments.widget_id)) />
            <cfset xml_settings = deserializeJSON(getWidget.DATA[1].WIDGET_DATA) >

            <cfset storage = structNew() />
            <cfset storage['product'] = arrayNew(1) />
            
            <cfquery name="del_order_pre_rows" datasource="#dsn3#">
                DELETE FROM ORDER_PRE_ROWS WHERE COOKIE_NAME = <cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
            </cfquery>

            <cfloop array="#products#" item="item" index="i">
                <cfquery name="get_stock" datasource="#dsn3#">
                    SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#products[i]#">
                </cfquery>

                <cfset storage['product'][i] = {
                    stock_id: get_stock.stock_id,
                    product_id: products[i],
                    amount: quantities[i]
                } />
               
                <cfset this.add_product_to_basket(
                    stock_id: get_stock.stock_id,
                    quantity: quantities[i],
                    widget_id: arguments.widget_id,
                    is_discount: arguments.one_year_cash_payment?:0,
                    cookie_name: "#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"
                ) />
            </cfloop>
           
            <cfset session.storage = replace( serializeJSON(storage), '//', '' ) />

            <cfset response = { status: true, success_message: "Ürünler sepete eklendi!" } />

            <cfcatch type = "any">
                <cfset response = { status: false, danger_message: "Ürün sepete eklenirken bir sorun oluştu!" } />
            </cfcatch>
        </cftry>

        <cfreturn replace(SerializeJSON(response),'//','') />
    </cffunction>

    <cffunction name="get_user_basket" returntype = "query" description = "User Basket">
        
        <cfquery name="q_get_user_basket" datasource="#dsn3#">
            SELECT 
                OPR.PRODUCT_ID,
                OPR.STOCK_ID,
                OPR.PRODUCT_NAME,
                OPR.QUANTITY,
                OPR.PRICE,
                OPR.PRICE_KDV,
                OPR.PRICE_MONEY AS MONEY,
                OPR.IS_DISCOUNT,
                P.PRODUCT_DETAIL,
                P.PRODUCT_DETAIL2
            FROM ORDER_PRE_ROWS AS OPR
            JOIN #dsn1#.PRODUCT AS P ON OPR.PRODUCT_ID = P.PRODUCT_ID
            WHERE OPR.COOKIE_NAME = <cfqueryparam cfsqltype = "cf_sql_nvarchar" value = "#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
        </cfquery>

        <cfreturn q_get_user_basket />
    </cffunction>

</cfcomponent>