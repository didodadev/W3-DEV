<cfcomponent extends="V16/sales/cfc/subscription_contract">
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    </cfif>

    <cfset queryJSONConverter = createObject('component','catalyst/AddOns/Yazilimsa/Protein/reactor/cfc/queryJSONConverter') />
    <cfset basketAction = createObject("component","V16/objects2/sale/cfc/basketAction") />
    
    <cffunction name = "get_subscription_contract" access = "public">
        <cfargument name="company_id" type="numeric">
        <cfargument name="startrow" type="numeric" default="1">
        <cfargument name="maxrows" type="numeric" default="20">

        <cfreturn this.GET_SUBSCRIPTIONS(company_id: arguments.company_id, startrow: arguments.startrow, maxrows: arguments.maxrows) />

    </cffunction>

    <cffunction name = "add_subscription_contract_all" returnType = "any" returnformat = "JSON" access = "public" description = "add subscriptin contract - product plan">
        <cfargument name="wrk_id" type="string" default="#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#userid_#_'&round(rand()*100)#">
        <cfargument name="paper_code" type="string" default="">
        <cfargument name="paper_number" type="string" default="">
        <cfargument name="subscription_no" type="string" default="">
        <cfargument name="subscription_key" type="string" default="">
        
        <cftry>

            <cfif IsDefined("arguments.create_subscription_no") and len(arguments.create_subscription_no) and arguments.create_subscription_no eq 1>
                <cfset arguments.subscription_no = this.create_subscription_code() />
            <cfelse>
                <cfset Get_Paper_Number_Code = this.Get_Paper_Number_Code() />
                <cfif Get_Paper_Number_Code.recordcount>
                    <cfset arguments.paper_code = Get_Paper_Number_Code.SUBSCRIPTION_NO />
                    <cfset arguments.paper_number = Get_Paper_Number_Code.SUBSCRIPTION_NUMBER />
                </cfif>
            </cfif>

            <cfif IsDefined("arguments.create_subscription_key") and len(arguments.create_subscription_key) and arguments.create_subscription_key eq 1>
                <cfset arguments.subscription_key = randRange(1000000, 9999999, 'CFMX_COMPAT') />
            </cfif>

            <cfset this.add_subscription_contract( argumentCollection = arguments ) />

            <cfset response = { status: true } />
            <cfcatch type = "any">
                <cfset response = { status: false } />
            </cfcatch>
        </cftry>

        <cfreturn replace(SerializeJSON(response),'//','') />
    </cffunction>

    <cffunction name="get_company_risk" access="remote" returnformat="JSON" hint="company risk limit bilgilerini döner">
        <cfargument name="company_id" type="numeric" required="true">
        <cfset response = structNew()>

        <cfquery name="check_company_risk_type" datasource="#dsn#"><!--- şirkette detaylı risk takibi yapılıyor mu kontrol ediliyor --->
            SELECT ISNULL(IS_DETAILED_RISK_INFO,0) IS_DETAILED_RISK_INFO FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>

        <cfquery name="get_comp_risk" datasource="#dsn2#">
            SELECT 
                ISNULL(TOTAL_RISK_LIMIT,0) TOTAL_RISK_LIMIT,
                ISNULL(BAKIYE,0) BAKIYE,
                ISNULL(SENET_KARSILIKSIZ,0) AS SENET_KARSILIKSIZ,
                ISNULL(CEK_KARSILIKSIZ,0) CEK_KARSILIKSIZ,
                ISNULL(CEK_ODENMEDI,0) CEK_ODENMEDI,
                ISNULL(SENET_ODENMEDI,0) SENET_ODENMEDI,
                ( ISNULL(TOTAL_RISK_LIMIT,0) - (ISNULL(BAKIYE,0) + ISNULL(SENET_KARSILIKSIZ,0) + ISNULL(CEK_KARSILIKSIZ,0) + ISNULL(CEK_ODENMEDI,0) + ISNULL(SENET_ODENMEDI,0) )) AS NETTOTAL
            FROM 
                COMPANY_RISK 
            WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>

        <cfif get_comp_risk.recordcount>
            <cfset toplam_risk = get_comp_risk.NETTOTAL>
            <cfset bakiye = get_comp_risk.BAKIYE>
        <cfelse>
            <cfset toplam_risk = 0>
            <cfset bakiye = 0>
        </cfif>

        <cfif check_company_risk_type.recordcount neq 0 and check_company_risk_type.IS_DETAILED_RISK_INFO eq 1>
            <cfquery name="get_company_orders" datasource="#dsn2#">
                SELECT 
                    ISNULL(SUM(NETTOTAL),0) NETTOTAL 
                FROM 
                    ( 
                        SELECT 
                            ((ORD_ROW.QUANTITY-ISNULL(ORD_ROW.CANCEL_AMOUNT,0)-ISNULL(ORD_ROW.DELIVER_AMOUNT,0))*(((1-(ORDERS.SA_DISCOUNT)/((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)-(-(((((1-(ORDERS.SA_DISCOUNT)/(ORDERS.NETTOTAL-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)))*(ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100)))))/ORD_ROW.QUANTITY)) AS NETTOTAL 
                        FROM 
                            ORDERS,ORDER_ROW ORD_ROW 
                        WHERE 
                            ORDERS.ORDER_ID = ORD_ROW.ORDER_ID AND 
                            ISNULL(IS_MEMBER_RISK,1) = 1 AND 
                            ORDER_STATUS = 1 AND 
                            ((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1)) AND 
                            IS_PAID <> 1 AND 
                            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
                            ORDERS.ORDER_ID <> 0 AND 
                            ((ORDERS.NETTOTAL)-(ORDERS.TAXTOTAL-ORDERS.SA_DISCOUNT)) > 0 AND 
                            ORD_ROW.ORDER_ROW_CURRENCY NOT IN (-8,-9,-10,-3)
                    ) AS A1
            </cfquery>
            <cfset order_amount = get_company_orders.NETTOTAL >

            <cfquery name="get_company_ship" datasource="#dsn2#">
                SELECT 
                    ISNULL(SUM(NETTOTAL),0) NETTOTAL 
                FROM 
                    (
                        SELECT 
                            ( (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0)
                        FROM 
                            INVOICE_ROW IR,
                            INVOICE I 
                        WHERE 
                            I.INVOICE_ID = IR.INVOICE_ID AND 
                            I.IS_IPTAL = 0 AND 
                            I.PURCHASE_SALES = S.PURCHASE_SALES AND 
                            IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))
                            ) * (SR.GROSSTOTAL/SR.AMOUNT) AS NETTOTAL FROM SHIP S,SHIP_ROW SR 
                                                                      WHERE S.SHIP_ID=SR.SHIP_ID AND 
                                                                            S.PURCHASE_SALES=1 AND 
                                                                            S.IS_WITH_SHIP=0 AND 
                                                                            ISNULL(S.IS_SHIP_IPTAL,0)=0 AND 
                                                                            S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND 
                                                                            (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM INVOICE_ROW IR, INVOICE I 
                                                                                WHERE 
                                                                                    I.INVOICE_ID = IR.INVOICE_ID AND 
                                                                                    I.PURCHASE_SALES = S.PURCHASE_SALES AND 
                                                                                    I.IS_IPTAL = 0 AND 
                                                                                    IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0
                    ) A1
            </cfquery>

            <cfif get_company_ship.recordcount gt 0>
                <cfset ship_amount = get_company_ship.NETTOTAL >
            <cfelse>
                <cfset ship_amount = 0 >
            </cfif>
        <cfelse>
            <cfquery name="get_company_orders" datasource="#dsn3#">
                SELECT 
                    ISNULL(SUM(NETTOTAL),0) NETTOTAL 
                FROM 
                    ORDERS 
                WHERE 
                    ISNULL(IS_MEMBER_RISK,1) = 1 AND 
                    ORDER_ID NOT IN(SELECT ORDER_ID FROM ORDERS_INVOICE) AND 
                    ORDER_ID NOT IN(SELECT ORDER_ID FROM ORDERS_SHIP) AND 
                    ORDER_STATUS = 1 AND 
                    ((ORDERS.PURCHASE_SALES = 1 AND ORDERS.ORDER_ZONE = 0) OR (ORDERS.PURCHASE_SALES = 0 AND ORDERS.ORDER_ZONE = 1)) AND 
                    IS_PAID <> 1 AND 
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND 
                    ORDER_ID <> 0
            </cfquery>
            <cfset order_amount = get_company_orders.NETTOTAL >
            <cfset ship_amount = 0 >
        </cfif>
        <cfset response.member_use_limit = toplam_risk - order_amount - ship_amount>
        <cfset response.member_bakiye = bakiye >
        <cfset response.member_order_value = order_amount>

        <cfset total_member_limit = toplam_risk - order_amount - ship_amount>

        <cfset basket = basketAction.get_product_to_basket( partner_id: session.pp.userid )>
        <cfquery name="get_total" dbtype="query">
            SELECT SUM(PRICE_KDV_TL) AS T_TL_PRICE FROM basket
        </cfquery>
        
        <cfset sepet_toplam = ( get_total.recordCount ? get_total.T_TL_PRICE : 0 ) >

        <cfset response.member_limit_asimi = sepet_toplam - total_member_limit >

        <cfreturn replace(SerializeJSON(response),'//','') />
    </cffunction>   
    
</cfcomponent>