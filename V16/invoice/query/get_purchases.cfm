<!---irsaliyelerin aktif donemde faturaya cekilmesine bağlı olarak faturalanma durumları kontrol edilir.
Emirler listesine daha önce irsaliyeye çekilmemiş, sevk veya eksik teslimat aşamasında satırları bulunan siparişler de getiriliyor--->
<cfquery name="GET_PERIOD_DSN" datasource="#DSN#">
	SELECT 
		PERIOD_ID,
		PERIOD_YEAR 
	FROM 
		SETUP_PERIOD 
	WHERE 
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
	ORDER BY 
		PERIOD_YEAR
</cfquery>
<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type)>
	<cfset kurumsal = ''>
	<cfset bireysel = ''>
	<cfset uzunluk=listlen(attributes.member_cat_type)>
	<cfloop from="1" to="#uzunluk#" index="catyp">
		<cfset eleman = listgetat(attributes.member_cat_type,catyp,',')>
		<cfif listlen(eleman) and listfirst(eleman,'-') eq 1>
			<cfset kurumsal = listappend(kurumsal,eleman)>
		<cfelseif listlen(eleman) and listfirst(eleman,'-') eq 2>
			<cfset bireysel = listappend(bireysel,eleman)>
		</cfif>
	</cfloop>
</cfif>
<cfquery name="PURCHASES" datasource="#dsn2#">
	WITH CTE1 AS(
	<cfif isdefined("attributes.order_type") and (attributes.order_type neq 2) and not (attributes.cat eq 0)>
        SELECT
            SHIP.PURCHASE_SALES,
            SHIP.SHIP_ID ACTION_ID,
            SHIP.SHIP_NUMBER ACTION_NUMBER,
            INVOICE_SHIPS.INVOICE_NUMBER,
            INVOICE_SHIPS.INVOICE_ID, 
            SHIP.SHIP_TYPE ACTION_TYPE,
            SHIP.PROCESS_CAT PROCESS_CAT,
            (SELECT STAGE FROM #dsn_alias#.PROCESS_TYPE_ROWS PTR WHERE PROCESS_ROW_ID = SHIP.PROCESS_STAGE ) as STAGE,
            SHIP.PROCESS_STAGE,
            SHIP.SHIP_DATE ACTION_DATE,
            SHIP.COMPANY_ID,
            SHIP.CONSUMER_ID,
            SHIP.EMPLOYEE_ID,
            SHIP.PARTNER_ID,
            SHIP.DELIVER_STORE_ID,
            SHIP.DEPARTMENT_IN,
            ISNULL(SHIP.NETTOTAL,0) NETTOTAL,
            SHIP.SHIP_DETAIL,
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name") or 
            (len(attributes.product_id) and isdefined("attributes.product_id") and len(attributes.product_name) and isdefined("attributes.product_name")) >
              SHIP_ROW.PRODUCT_ID,
            </cfif>
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
               PRODUCT.PRODUCT_CATID,
            </cfif>
            2 ORDER_ZONE,
            '' ORDER_HEAD,
            1 AS KONTROL_SHIP
        FROM
            SHIP,
            INVOICE_SHIPS
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name") or 
            (len(attributes.product_id) and isdefined("attributes.product_id") and len(attributes.product_name) and isdefined("attributes.product_name")) >
               ,SHIP_ROW
            </cfif>
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
                ,#dsn3#.PRODUCT
            </cfif>
           
        WHERE
            SHIP.SHIP_ID = INVOICE_SHIPS.SHIP_ID
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
                AND SHIP_ROW.PRODUCT_ID=#dsn3#.PRODUCT.PRODUCT_ID
            </cfif>
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name") or (len(attributes.product_id) and isdefined("attributes.product_id") and len(attributes.product_name) and isdefined("attributes.product_name")) >
                AND SHIP_ROW.SHIP_ID=SHIP.SHIP_ID
            </cfif>
            AND INVOICE_SHIPS.SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
            <cfif attributes.xml_is_salaried eq 0><!--- ucretlendirilmemis servis irsaliyelerinin gelmemesini engeller --->
                AND ISNULL((SELECT TOP 1 SERVICE.IS_SALARIED FROM SHIP_ROW,#dsn3_alias#.SERVICE WHERE SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND SERVICE.SERVICE_ID = SHIP_ROW.SERVICE_ID),1) = 1
            </cfif>
            <cfif isdefined("x_consignment_delivery") and x_consignment_delivery eq 0>
                AND SHIP_TYPE NOT IN (75,79)
            </cfif>
            AND SHIP.IS_SHIP_IPTAL = 0
            AND SHIP.IS_WITH_SHIP = 0  <!--- faturaların kendi olusturdugu irsaliyeler gelmesin --->
            AND SHIP_TYPE NOT IN (81,82,83,811,761)<!--- demirbas alıs-satıs,dep. arası sevk,ithal mal girişi,hal irsalyesi(bunlardan emir oluşturulmaz) --->
			<cfif len(attributes.cat) and listlen(attributes.cat,'-') eq 1>
                AND SHIP.SHIP_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat#">
            <cfelseif len(attributes.cat) and listlen(attributes.cat,'-') gt 1>
                AND SHIP.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.cat,'-')#">
            </cfif>
            <cfif isDefined("attributes.department_id") and attributes.department_id neq "-1">
                AND 
                (
                    DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> OR 
                    DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> 	
                )
            </cfif>
            <cfif len(attributes.product_id) and isdefined("attributes.product_id") and len(attributes.product_name) and isdefined("attributes.product_name")>
                AND SHIP_ROW.PRODUCT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
            </cfif>
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
                AND PRODUCT.PRODUCT_CATID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">
            </cfif>
            <cfif len(attributes.keyword)>
                AND	(SHIP.SHIP_NUMBER LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
            </cfif>
            <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
                AND	SHIP.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
            </cfif>
            <cfif isdefined('attributes.free_type') and attributes.free_type eq 1>
                AND SHIP.NETTOTAL > 0
            <cfelseif isdefined('attributes.free_type') and attributes.free_type eq 2>
                AND SHIP.NETTOTAL <= 0
            </cfif>
            <cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
                AND SHIP.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND #attributes.finish_date#
            <cfelseif not len(attributes.start_date) and isdate(attributes.finish_date)>  
            	AND SHIP.SHIP_DATE <= #attributes.finish_date# 
            <cfelseif not len(attributes.finish_date) and isdate(attributes.start_date)>  
            	AND SHIP.SHIP_DATE >= #attributes.start_date#   
            </cfif>
            <cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>
                AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
            </cfif>
            <cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>
                AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
            </cfif>
            <cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>
                AND SHIP.DEPARTMENT_IN IN 
                (
                	SELECT 
                        D.DEPARTMENT_ID 
                    FROM 
                        #dsn_alias#.DEPARTMENT D,
                        #dsn_alias#.BRANCH B
                    WHERE 
                        D.BRANCH_ID = B.BRANCH_ID AND
                        B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
            	)
            </cfif>
            <cfif isdefined("kurumsal") and listlen(kurumsal)>
                AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>SHIP.COMPANY_ID IN
                (
                    SELECT 
                        C.COMPANY_ID 
                    FROM 
                        #dsn_alias#.COMPANY C
                    WHERE 
                        (
                            <cfloop list="#kurumsal#" delimiters="," index="cat_i">
                                (C.COMPANYCAT_ID = #listlast(cat_i,'-')#)
                                <cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
                            </cfloop>  
                        )
                )
            </cfif>
            <cfif isdefined("bireysel") and listlen(bireysel)>
                <cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> SHIP.CONSUMER_ID IN
                    (
                        SELECT 
                            C.CONSUMER_ID 
                        FROM 
                            #dsn_alias#.CONSUMER C
                        WHERE 
                            (
                                <cfloop list="#bireysel#" delimiters="," index="cat_i">
                                    (C.CONSUMER_CAT_ID = #listlast(cat_i,'-')#)
                                    <cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
                                </cfloop>  
                            )
                    )
                <cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
            </cfif>
	</cfif>	
	<cfif isdefined("attributes.order_type") and not len(attributes.order_type) and not (attributes.cat eq 0)>
		UNION ALL
	</cfif>
	<cfif isdefined("attributes.order_type") and (attributes.order_type neq 1) and not (attributes.cat eq 0)>
        SELECT
            SHIP.PURCHASE_SALES,
            SHIP.SHIP_ID ACTION_ID,
            SHIP.SHIP_NUMBER ACTION_NUMBER,
            '' INVOICE_NUMBER,
            0 INVOICE_ID, 
            SHIP.SHIP_TYPE ACTION_TYPE,
            SHIP.PROCESS_CAT PROCESS_CAT,
            (SELECT STAGE FROM #dsn_alias#.PROCESS_TYPE_ROWS PTR WHERE PROCESS_ROW_ID = SHIP.PROCESS_STAGE ) as STAGE,
            SHIP.PROCESS_STAGE,
            SHIP.SHIP_DATE ACTION_DATE,
            SHIP.COMPANY_ID,
            SHIP.CONSUMER_ID,
            SHIP.EMPLOYEE_ID,
            SHIP.PARTNER_ID,
            SHIP.DELIVER_STORE_ID,
            SHIP.DEPARTMENT_IN,
            ISNULL(SHIP.NETTOTAL,0) NETTOTAL,
            SHIP.SHIP_DETAIL,
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name") or (len(attributes.product_id) and isdefined("attributes.product_id") and len(attributes.product_name) and isdefined("attributes.product_name")) >
               SHIP_ROW.PRODUCT_ID,
            </cfif>
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
               PRODUCT.PRODUCT_CATID,
            </cfif>
            2 ORDER_ZONE,
            '' ORDER_HEAD,
            0 AS KONTROL_SHIP
        FROM
            SHIP 
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name") or (len(attributes.product_id) and isdefined("attributes.product_id") and len(attributes.product_name) and isdefined("attributes.product_name")) >
               ,SHIP_ROW
            </cfif>
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
                ,#dsn3#.PRODUCT
            </cfif>
        WHERE
            SHIP.SHIP_TYPE NOT IN (81,82,83,811,761)<!---demirbas alıs-satıs, dep. arası sevk,ithal mal girişi,hal irsalyesi(bunlardan emir oluşturulmaz) --->
            AND SHIP.IS_WITH_SHIP = 0  <!--- faturaların kendi olusturdugu irsaliyeler gelmesin --->
            <cfif attributes.xml_is_salaried eq 0><!--- ucretlendirilmemis servis irsaliyelerinin gelmemesini engeller --->
                AND ISNULL((SELECT TOP 1 SERVICE.IS_SALARIED FROM SHIP_ROW,#dsn3_alias#.SERVICE WHERE SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND SERVICE.SERVICE_ID = SHIP_ROW.SERVICE_ID),1) = 1
            </cfif>
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")  or (len(attributes.product_id) and isdefined("attributes.product_id")and len(attributes.product_name) and isdefined("attributes.product_name")) >
               AND SHIP_ROW.SHIP_ID=SHIP.SHIP_ID
            </cfif>
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
               AND SHIP_ROW.PRODUCT_ID=#dsn3#.PRODUCT.PRODUCT_ID
            </cfif>
            <cfif isdefined("x_consignment_delivery") and x_consignment_delivery eq 0>
                AND SHIP_TYPE NOT IN (75,79)
            </cfif>
            <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
                AND PRODUCT.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#product_cat_code#.%"> 
            </cfif>
            <cfif len(attributes.product_id) and isdefined("attributes.product_id") and len(attributes.product_name) and isdefined("attributes.product_name")>
                AND SHIP_ROW.PRODUCT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
            </cfif>
            <cfif len(attributes.cat) and listlen(attributes.cat,'-') eq 1>
                AND SHIP.SHIP_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat#">
            <cfelseif len(attributes.cat) and listlen(attributes.cat,'-') gt 1>
                AND SHIP.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.cat,'-')#">
            </cfif>	
            AND SHIP.IS_SHIP_IPTAL = 0
            AND
            (
	            NOT EXISTS (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND SHIP_ID = SHIP.SHIP_ID )
                <!---SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = #session.ep.period_id#)--->
                <cfif isdefined('xml_dsp_all_ship_') and xml_dsp_all_ship_ eq 1><!--- tum satırı faturaya çekilerek kapatılmamış irsaliyelerde kesilmemiş  filtresiyle listelenecekse--->
                    OR						
                    (
                        SHIP.SHIP_ID IN ( SELECT
                                        DISTINCT SHIP_ROW.SHIP_ID
                                    FROM
                                        SHIP_ROW
                                    WHERE
                                        AMOUNT > ISNULL((SELECT
                                                            SUM(A1.AMOUNT)
                                                        FROM
                                                        (
                                                            <cfset count_index = 0>
                                                            <cfloop query="get_period_dsn">
                                                                <cfset count_index = count_index+1>
                                                                SELECT 
                                                                    IR.AMOUNT
                                                                FROM
                                                                    #dsn#_#get_period_dsn.period_year#_#session.ep.company_id#.INVOICE_ROW IR
                                                                WHERE
                                                                    IR.WRK_ROW_RELATION_ID=SHIP_ROW.WRK_ROW_ID AND 
                                                                    IR.SHIP_ID=SHIP_ROW.SHIP_ID
                                                                <cfif count_index neq get_period_dsn.recordcount>
                                                                    UNION ALL
                                                                </cfif>
                                                            </cfloop>
                                                        ) AS A1),0)																										
                                            AND SHIP_ROW.SHIP_ID=SHIP.SHIP_ID )
                     )
                </cfif>	
        )
        <cfif isDefined("attributes.department_id") AND  attributes.department_id neq "-1">
            AND 
            (
                DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> OR 
                DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">	
            )
        </cfif>
        <cfif len(attributes.keyword)>
            AND	(SHIP.SHIP_NUMBER LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
        </cfif>
        <cfif isDefined("attributes.process_stage") and len(attributes.process_stage)>
            AND	SHIP.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
        </cfif>
        <cfif isdefined('attributes.free_type') and attributes.free_type eq 1>
            AND SHIP.NETTOTAL > 0
        <cfelseif isdefined('attributes.free_type') and attributes.free_type eq 2>
            AND SHIP.NETTOTAL <= 0
        </cfif>
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
            AND SHIP.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND #attributes.finish_date#
        <cfelseif not len(attributes.start_date) and isdate(attributes.finish_date)>  
            AND SHIP.SHIP_DATE <= #attributes.finish_date# 
        <cfelseif not len(attributes.finish_date) and isdate(attributes.start_date)>  
            AND SHIP.SHIP_DATE >= #attributes.start_date#   
        </cfif>
        <cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>
            AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        </cfif>
        <cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>
            AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
        </cfif>
        <cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>
            AND SHIP.DEPARTMENT_IN IN 
                (SELECT 
                    D.DEPARTMENT_ID 
                FROM 
                    #dsn_alias#.DEPARTMENT D,
                    #dsn_alias#.BRANCH B
                WHERE 
                    D.BRANCH_ID = B.BRANCH_ID AND
                    B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
                )
        </cfif>
        <cfif isdefined("kurumsal") and listlen(kurumsal)>
            AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>SHIP.COMPANY_ID IN
                (
                SELECT 
                    C.COMPANY_ID 
                FROM 
                    #dsn_alias#.COMPANY C
                WHERE 
                    (
                        <cfloop list="#kurumsal#" delimiters="," index="cat_i">
                            (C.COMPANYCAT_ID = #listlast(cat_i,'-')#)
                            <cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
                        </cfloop>  
                    )
                )
        </cfif>
        <cfif isdefined("bireysel") and listlen(bireysel)>
            <cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> SHIP.CONSUMER_ID IN
                (
                SELECT 
                    C.CONSUMER_ID 
                FROM 
                    #dsn_alias#.CONSUMER C
                WHERE 
                    (
                        <cfloop list="#bireysel#" delimiters="," index="cat_i">
                            (C.CONSUMER_CAT_ID = #listlast(cat_i,'-')#)
                            <cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
                        </cfloop>  
                    )
                )
            <cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
        </cfif>
	</cfif>	
	<cfif attributes.cat eq 0>
		<cfif IsDefined("attributes.order_type") and attributes.order_type eq 2 or attributes.order_type eq "">
            SELECT DISTINCT
                O.PURCHASE_SALES,
                O.ORDER_ID ACTION_ID,
                O.ORDER_NUMBER ACTION_NUMBER,
                '' INVOICE_NUMBER,
                0 INVOICE_ID, 
                0 ACTION_TYPE,
                0 PROCESS_CAT,
                O.ORDER_DATE ACTION_DATE,
                O.COMPANY_ID,
                O.CONSUMER_ID,
                O.EMPLOYEE_ID,
                O.PARTNER_ID,
                O.DELIVER_DEPT_ID DELIVER_STORE_ID,
                '' DEPARTMENT_IN,
                ISNULL(O.NETTOTAL,0) NETTOTAL,
                '' SHIP_DETAIL,
                O.ORDER_ZONE,
                ORR.PRODUCT_ID,
                <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
                    PRODUCT.PRODUCT_CATID,
                </cfif>
                O.ORDER_HEAD,
                0 AS KONTROL_SHIP
                
            FROM 
                #dsn3_alias#.ORDERS O,
                #dsn3_alias#.ORDER_ROW ORR
                <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
                    ,#dsn3#.PRODUCT
                </cfif>
            WHERE 
                ORR.ORDER_ID = O.ORDER_ID
                AND O.ORDER_STATUS = 1
                <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
                    AND ORR.PRODUCT_ID=#dsn3#.PRODUCT.PRODUCT_ID
                </cfif>
                AND ORR.ORDER_ROW_CURRENCY IN (-6,-7)
                AND O.ORDER_ID NOT IN (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP)
                <cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>
                    AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                </cfif>
                <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
                    AND PRODUCT.PRODUCT_CATID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">
                </cfif>
                <cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>
                    AND O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                </cfif>
                <cfif len(attributes.product_id) and isdefined("attributes.product_id") and len(attributes.product_name) and isdefined("attributes.product_name")>
                    AND ORR.PRODUCT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
                </cfif>
                <cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
                    AND O.ORDER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                <cfelseif not isdate(attributes.start_date) and isdate(attributes.finish_date)>
                	AND O.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                 <cfelseif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
                	AND O.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
                </cfif>
                <cfif len(attributes.keyword)>
                    AND
                    (
                        (O.ORDER_NUMBER LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%') OR
                        (O.ORDER_HEAD LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
                    )
                </cfif>
                <cfif isDefined("attributes.department_id") AND  attributes.department_id neq "-1">
                    AND DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                </cfif>
                <cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>
                    AND O.DELIVER_DEPT_ID IN 
                        (SELECT 
                            D.DEPARTMENT_ID 
                        FROM 
                            #dsn_alias#.DEPARTMENT D,
                            #dsn_alias#.BRANCH B
                        WHERE 
                            D.BRANCH_ID = B.BRANCH_ID AND
                            B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
                        )
                </cfif>
                <cfif isdefined("kurumsal") and listlen(kurumsal)>
                    AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>O.COMPANY_ID IN
                        (
                        SELECT 
                            C.COMPANY_ID 
                        FROM 
                            #dsn_alias#.COMPANY C
                        WHERE 
                            (
                                <cfloop list="#kurumsal#" delimiters="," index="cat_i">
                                    (C.COMPANYCAT_ID = #listlast(cat_i,'-')#)
                                    <cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
                                </cfloop>  
                            )
                        )
                </cfif>
                <cfif isdefined("bireysel") and listlen(bireysel)>
                    <cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> O.CONSUMER_ID IN
                        (
                        SELECT 
                            C.CONSUMER_ID 
                        FROM 
                            #dsn_alias#.CONSUMER C
                        WHERE 
                            (
                                <cfloop list="#bireysel#" delimiters="," index="cat_i">
                                    (C.CONSUMER_CAT_ID = #listlast(cat_i,'-')#)
                                    <cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
                                </cfloop>  
                            )
                        )
                    <cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
                </cfif>
            </cfif>
            <cfif  IsDefined("attributes.order_type") and attributes.order_type eq "">
            	UNION ALL
            </cfif>       
			<cfif IsDefined("attributes.order_type") and attributes.order_type eq 1 or attributes.order_type eq "">    
                SELECT DISTINCT
                O.PURCHASE_SALES,
                O.ORDER_ID ACTION_ID,
                O.ORDER_NUMBER ACTION_NUMBER,
                II.INVOICE_NUMBER AS INVOICE_NUMBER,
                OI.INVOICE_ID AS INVOICE_ID,
                0 ACTION_TYPE,
                0 PROCESS_CAT,
                O.ORDER_DATE ACTION_DATE,
                O.COMPANY_ID,
                O.CONSUMER_ID,
                O.EMPLOYEE_ID,
                O.PARTNER_ID,
                O.DELIVER_DEPT_ID DELIVER_STORE_ID,
                '' DEPARTMENT_IN,
                ISNULL(O.NETTOTAL,0) NETTOTAL,
                '' SHIP_DETAIL,
                O.ORDER_ZONE,
                ORR.PRODUCT_ID,
                <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
                    PRODUCT.PRODUCT_CATID,
                </cfif>
                O.ORDER_HEAD,
                0 AS KONTROL_SHIP
            FROM 
                #dsn3_alias#.ORDERS O,
                <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
                    #dsn3#.PRODUCT,
                </cfif>
                #dsn3_alias#.ORDER_ROW ORR,
                #dsn3_alias#.ORDERS_INVOICE OI
                LEFT JOIN INVOICE II ON II.INVOICE_ID = OI.INVOICE_ID
            WHERE 
                ORR.ORDER_ID = O.ORDER_ID
                <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
                     AND ORR.PRODUCT_ID=#dsn3#.PRODUCT.PRODUCT_ID
                </cfif>
                AND OI.ORDER_ID = O.ORDER_ID
                AND OI.INVOICE_ID = II.INVOICE_ID
                AND O.ORDER_STATUS = 1
                AND ORR.ORDER_ROW_CURRENCY IN (-6,-7)
                AND O.ORDER_ID NOT IN (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP)
                <cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>
                    AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                </cfif>
                <cfif len(attributes.cat_id) and isdefined("attributes.cat_id") and len(attributes.category_name) and isdefined("attributes.category_name")>
                    AND PRODUCT.PRODUCT_CATID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">
                </cfif>
                <cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>
                    AND O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                </cfif>
                <cfif len(attributes.product_id) and isdefined("attributes.product_id") and len(attributes.product_name) and isdefined("attributes.product_name")>
                    AND ORR.PRODUCT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
                </cfif>
                <cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
                    AND O.ORDER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                <cfelseif not isdate(attributes.start_date) and isdate(attributes.finish_date)>
                	AND O.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                 <cfelseif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
                	AND O.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
                </cfif>
                <cfif len(attributes.keyword)>
                    AND
                    (
                        (O.ORDER_NUMBER LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%') OR
                        (O.ORDER_HEAD LIKE '<cfif len(attributes.keyword) gt 3>%</cfif>#attributes.keyword#%')
                    )
                </cfif>
                <cfif isDefined("attributes.department_id") AND  attributes.department_id neq "-1">
                    AND DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                </cfif>
                <cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>
                    AND O.DELIVER_DEPT_ID IN 
                        (SELECT 
                            D.DEPARTMENT_ID 
                        FROM 
                            #dsn_alias#.DEPARTMENT D,
                            #dsn_alias#.BRANCH B
                        WHERE 
                            D.BRANCH_ID = B.BRANCH_ID AND
                            B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
                        )
                </cfif>
                <cfif isdefined("kurumsal") and listlen(kurumsal)>
                    AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>O.COMPANY_ID IN
                        (
                        SELECT 
                            C.COMPANY_ID 
                        FROM 
                            #dsn_alias#.COMPANY C
                        WHERE 
                            (
                                <cfloop list="#kurumsal#" delimiters="," index="cat_i">
                                    (C.COMPANYCAT_ID = #listlast(cat_i,'-')#)
                                    <cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
                                </cfloop>  
                            )
                        )
                </cfif>
                <cfif isdefined("bireysel") and listlen(bireysel)>
                    <cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> O.CONSUMER_ID IN
                        (
                        SELECT 
                            C.CONSUMER_ID 
                        FROM 
                            #dsn_alias#.CONSUMER C
                        WHERE 
                            (
                                <cfloop list="#bireysel#" delimiters="," index="cat_i">
                                    (C.CONSUMER_CAT_ID = #listlast(cat_i,'-')#)
                                    <cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
                                </cfloop>  
                            )
                        )
                    <cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
                </cfif>
            </cfif>            
	</cfif>
		),
	
		CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY ACTION_DATE DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
</cfquery>
