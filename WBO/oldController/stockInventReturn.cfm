<cf_get_lang_set module_name="stock">
<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="stock.add_invent_return">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_name" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<!---<cfif not isdefined("attributes.event") or attributes.event is 'list'>--->
    <cfif isdefined("attributes.form_submitted") and len(attributes.subscription_id)>
        <cfquery name="get_periods" datasource="#dsn#">
            SELECT 
                PERIOD_ID, 
                PERIOD, 
                PERIOD_YEAR, 
                OUR_COMPANY_ID
            FROM 
                SETUP_PERIOD 
            WHERE 
                OUR_COMPANY_ID = #session.ep.company_id# ORDER BY PERIOD_YEAR DESC
        </cfquery>
        <cfquery name="get_system_inventory" datasource="#dsn2#">
            SELECT
                SUM(STOCK_ROW_SPE_TOTAL) AS TOTAL,
                PRODUCT_NAME,
                STOCK_ID
            FROM
                (
                <cfset count_ = 0>
                <cfloop query="get_periods">
                    <cfset count_ = count_ + 1>
                    SELECT
                        S.PRODUCT_NAME,
                        SFR.STOCK_ID,
                        SUM(SFR.AMOUNT) AS STOCK_ROW_SPE_TOTAL
                    FROM
                        #dsn3_alias#.INVENTORY I,
                        #dsn3_alias#.INVENTORY_ROW IR,
                        #dsn3_alias#.STOCKS S,
                        #dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS SF,
                        #dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS_ROW SFR
                    WHERE
                        I.INVENTORY_ID = IR.INVENTORY_ID AND
                        IR.ACTION_ID =  SF.FIS_ID AND
                        SFR.FIS_ID =  SF.FIS_ID AND
                        SFR.STOCK_ID = S.STOCK_ID AND
                        SFR.INVENTORY_ID = I.INVENTORY_ID AND
                        IR.PERIOD_ID = #get_periods.period_id# AND
                        I.SUBSCRIPTION_ID = #attributes.subscription_id# AND
                        SF.FIS_TYPE = 118
                    GROUP BY
                        S.PRODUCT_NAME,
                        SFR.STOCK_ID
                    <cfif get_periods.recordcount neq count_>UNION ALL</cfif>
                </cfloop>
                ) AS SATIRLAR
            GROUP BY
                PRODUCT_NAME,
                STOCK_ID
        </cfquery>
        <cfquery name="get_system_inventory_return" datasource="#dsn2#">
            SELECT
                SUM(STOCK_ROW_SPE_TOTAL) AS TOTAL,
                PRODUCT_NAME,
                STOCK_ID
            FROM
                (
                <cfset count_ = 0>
                <cfloop query="get_periods">
                    <cfset count_ = count_ + 1>
                    SELECT
                        S.PRODUCT_NAME,
                        SFR.STOCK_ID,
                        SUM(SFR.AMOUNT) AS STOCK_ROW_SPE_TOTAL
                    FROM
                        #dsn3_alias#.INVENTORY I,
                        #dsn3_alias#.INVENTORY_ROW IR,
                        #dsn3_alias#.STOCKS S,
                        #dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS SF,
                        #dsn#_#get_periods.period_year#_#session.ep.company_id#.STOCK_FIS_ROW SFR
                    WHERE
                        I.INVENTORY_ID = IR.INVENTORY_ID AND
                        IR.ACTION_ID =  SF.FIS_ID AND
                        SFR.FIS_ID =  SF.FIS_ID AND
                        SFR.STOCK_ID = S.STOCK_ID AND
                        SFR.INVENTORY_ID = I.INVENTORY_ID AND
                        IR.PERIOD_ID = #get_periods.period_id# AND
                        I.SUBSCRIPTION_ID = #attributes.subscription_id# AND
                        SF.FIS_TYPE = 1182
                    GROUP BY
                        S.PRODUCT_NAME,
                        SFR.STOCK_ID
                    <cfif get_periods.recordcount neq count_>UNION ALL</cfif>
                </cfloop>
                ) AS SATIRLAR
            GROUP BY
                PRODUCT_NAME,
                STOCK_ID
        </cfquery>
        <cfquery name="get_system_inventory_sale" datasource="#dsn2#">
            SELECT
                SUM(STOCK_ROW_SPE_TOTAL) AS TOTAL,
                PRODUCT_NAME,
                STOCK_ID
            FROM
                (
                <cfset count_ = 0>
                <cfloop query="get_periods">
                    <cfset count_ = count_ + 1>
                    SELECT
                        S.PRODUCT_NAME,
                        IR2.STOCK_ID,
                        SUM(SFR.AMOUNT) AS STOCK_ROW_SPE_TOTAL
                    FROM
                        #dsn3_alias#.INVENTORY I,
                        #dsn3_alias#.INVENTORY_ROW IR,
                        #dsn3_alias#.INVENTORY_ROW IR2,
                        #dsn3_alias#.STOCKS S,
                        #dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE SF,
                        #dsn#_#get_periods.period_year#_#session.ep.company_id#.INVOICE_ROW SFR
                    WHERE
                        I.INVENTORY_ID = IR.INVENTORY_ID AND
                        I.INVENTORY_ID = IR2.INVENTORY_ID AND
                        IR2.PROCESS_TYPE = 118 AND
                        IR.ACTION_ID =  SF.INVOICE_ID AND
                        SFR.INVOICE_ID =  SF.INVOICE_ID AND
                        IR2.STOCK_ID = S.STOCK_ID AND
                        SFR.INVENTORY_ID = I.INVENTORY_ID AND
                        IR.PERIOD_ID = #get_periods.period_id# AND
                        I.SUBSCRIPTION_ID = #attributes.subscription_id# AND
                        SF.INVOICE_CAT = 66
                    GROUP BY
                        S.PRODUCT_NAME,
                        IR2.STOCK_ID
                    <cfif get_periods.recordcount neq count_>UNION ALL</cfif>
                </cfloop>
                ) AS SATIRLAR
            GROUP BY
                PRODUCT_NAME,
                STOCK_ID
        </cfquery>
        <cfoutput query="get_system_inventory_return">
            <cfset 'return_stock_amount_#STOCK_ID#' = TOTAL>
        </cfoutput>
        <cfoutput query="get_system_inventory_sale">
            <cfset 'sale_stock_aount_#STOCK_ID#' = TOTAL>
        </cfoutput>
    </cfif>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="get_all_periods" datasource="#dsn#">
            SELECT 
                PERIOD_ID, 
                PERIOD, 
                PERIOD_YEAR, 
                OUR_COMPANY_ID
            FROM 
                SETUP_PERIOD 
            WHERE 
                OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR >=#session.ep.period_year-5#
        </cfquery> 
        <cfset list_period_years=valuelist(get_all_periods.PERIOD_YEAR)>
        <!--- konsinye ????k????lar --->
        <cfquery name="get_konsinye_row" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
            SELECT
                PRODUCT_ID,
                STOCK_ID,
                PRODUCT_NAME,
                SUM(TOTAL_KONS_AMOUNT) TOTAL_KONS_AMOUNT,
                SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
                SHIP_ID,
                SHIP_DATE,
                SHIP_PERIOD_ID,
                SHIP_PERIOD_YEAR,
                SHIP_NUMBER,
                PROJECT_ID	
            FROM
            (
            <cfloop query="get_all_periods">
                SELECT
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.PRODUCT_NAME,
                    SUM(SHIP_ROW.AMOUNT) TOTAL_KONS_AMOUNT,
                    0 TOTAL_AMOUNT,
                    SHIP.SHIP_ID,
                    SHIP.SHIP_DATE,
                    #get_all_periods.period_id# SHIP_PERIOD_ID,
                    #get_all_periods.period_year# SHIP_PERIOD_YEAR,
                    SHIP_NUMBER,
                    ISNULL(SHIP.PROJECT_ID,0) PROJECT_ID		
                FROM 
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP SHIP,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SHIP_ROW,
                    #dsn3_alias#.STOCKS S
                WHERE 
                    SHIP_ROW.SHIP_ID = SHIP.SHIP_ID
                    AND SHIP.IS_SHIP_IPTAL = 0 
                    AND SHIP_ROW.STOCK_ID = S.STOCK_ID
                    AND SHIP.IS_WITH_SHIP=0
                    AND SHIP.SHIP_TYPE = 72
                    AND S.IS_INVENTORY = 1
                    <cfif len(attributes.subscription_id)>
                        AND SHIP.SUBSCRIPTION_ID = #attributes.subscription_id#
                    </cfif>
                    <cfif len(attributes.project_id)>
                        AND SHIP.PROJECT_ID = #attributes.project_id#
                    </cfif>
                    <cfif isdefined("attributes.is_project")>
                        AND SHIP.PROJECT_ID IS NULL
                    </cfif>
                GROUP  BY
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.PRODUCT_NAME,
                    SHIP.SHIP_ID,
                    SHIP.SHIP_DATE,
                    SHIP_NUMBER	,
                    ISNULL(SHIP.PROJECT_ID,0)
                UNION ALL
                SELECT
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.PRODUCT_NAME,
                    0 TOTAL_KONS_AMOUNT,
                    SUM(SHIP_ROW.AMOUNT) TOTAL_AMOUNT,
                    SHIP.SHIP_ID,
                    SHIP.SHIP_DATE,
                    #get_all_periods.period_id# SHIP_PERIOD_ID,
                    #get_all_periods.period_year# SHIP_PERIOD_YEAR,
                    SHIP_NUMBER,
                    ISNULL(SHIP.PROJECT_ID,0) PROJECT_ID		
                FROM 
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP SHIP,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SHIP_ROW,
                    #dsn3_alias#.STOCKS S
                WHERE 
                    SHIP_ROW.SHIP_ID = SHIP.SHIP_ID
                    AND SHIP.IS_SHIP_IPTAL = 0 
                    AND SHIP_ROW.STOCK_ID = S.STOCK_ID
                    AND SHIP.SHIP_TYPE IN(70,71,88)
                    AND S.IS_INVENTORY = 1
                    <cfif len(attributes.subscription_id)>
                        AND SHIP.SUBSCRIPTION_ID = #attributes.subscription_id#
                    </cfif>
                    <cfif len(attributes.project_id)>
                        AND SHIP.PROJECT_ID = #attributes.project_id#
                    </cfif>
                    <cfif isdefined("attributes.is_project")>
                        AND SHIP.PROJECT_ID IS NULL
                    </cfif>
                GROUP  BY
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.PRODUCT_NAME,
                    SHIP.SHIP_ID,
                    SHIP.SHIP_DATE,
                    SHIP_NUMBER	,
                    ISNULL(SHIP.PROJECT_ID,0)			
                <cfif currentrow neq get_all_periods.recordcount> UNION ALL </cfif>					
            </cfloop>
            )T1
            GROUP BY
                PRODUCT_ID,
                STOCK_ID,
                PRODUCT_NAME,
                SHIP_ID,
                SHIP_DATE,
                SHIP_PERIOD_ID,
                SHIP_PERIOD_YEAR,
                SHIP_NUMBER	,
                PROJECT_ID			
            ORDER BY
                SHIP_DATE
        </cfquery>
        <cfquery name="get_konsinye" dbtype="query">
            SELECT SUM(TOTAL_KONS_AMOUNT) TOTAL_KONS_AMOUNT,PRODUCT_ID,STOCK_ID,PRODUCT_NAME FROM get_konsinye_row GROUP BY PRODUCT_ID,STOCK_ID,PRODUCT_NAME
        </cfquery>
        <!--- konsinye iadeleri --->
        <cfquery name="get_konsinye_iade" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
            <cfloop query="get_all_periods">
                SELECT
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.PRODUCT_NAME,
                    SUM(SHIP_ROW.AMOUNT) TOTAL_KONS_AMOUNT
                FROM 
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP SHIP,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SHIP_ROW,
                    #dsn3_alias#.STOCKS S
                WHERE 
                    SHIP_ROW.SHIP_ID = SHIP.SHIP_ID
                    AND SHIP.IS_SHIP_IPTAL = 0 
                    AND SHIP_ROW.STOCK_ID = S.STOCK_ID
                    AND SHIP.IS_WITH_SHIP=0
                    AND SHIP.SHIP_TYPE = 75
                    AND S.IS_INVENTORY = 1
                    <cfif len(attributes.subscription_id)>
                        AND SHIP.SUBSCRIPTION_ID = #attributes.subscription_id#
                    </cfif>
                    <cfif len(attributes.project_id)>
                        AND SHIP.PROJECT_ID = #attributes.project_id#
                    </cfif>
                    <cfif isdefined("attributes.is_project")>
                        AND SHIP.PROJECT_ID IS NULL
                    </cfif>
                GROUP  BY
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.PRODUCT_NAME
                <cfif currentrow neq get_all_periods.recordcount> UNION ALL </cfif>					
            </cfloop>
        </cfquery>
        <!--- faturalanm???? konsinye --->
        <cfquery name="get_inv_amount" datasource="#dsn#">
            SELECT
                SUM(AMOUNT) AS INV_AMOUNT,
                PRODUCT_ID,
                STOCK_ID,
                SHIP_ID,
                SHIP_DATE,
                SHIP_PERIOD_ID,
                SHIP_PERIOD_YEAR,
                SHIP_NUMBER,
                PROJECT_ID		
            FROM
            (
            <cfloop query="get_all_periods">
            <cfif currentrow neq 1> UNION ALL </cfif>					
                SELECT
                    SUM(AMOUNT) AS AMOUNT,
                    SRR.PRODUCT_ID,
                    SRR.STOCK_ID,
                    S.SHIP_ID,
                    S.SHIP_DATE,
                    #get_all_periods.period_id# SHIP_PERIOD_ID,
                    #get_all_periods.period_year# SHIP_PERIOD_YEAR	,
                    SHIP_NUMBER,
                    ISNULL(S.PROJECT_ID,0) PROJECT_ID	
                FROM
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE INV,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP S,
                    #dsn3_alias#.STOCKS SS
                WHERE
                    SRR.TO_INVOICE_ID =INV.INVOICE_ID
                    AND SRR.SHIP_ID = S.SHIP_ID
                    AND SRR.STOCK_ID = SS.STOCK_ID
                    AND S.SHIP_TYPE IN (72,75,77,79)
                    AND INV.PURCHASE_SALES = 1
                    AND SRR.TO_INVOICE_CAT = INV.INVOICE_CAT
                    AND SHIP_PERIOD=#get_all_periods.period_id#
                    AND SRR.TO_INVOICE_ID IS NOT NULL
                    AND SS.IS_INVENTORY = 1
                    <cfif len(attributes.subscription_id)>
                        AND S.SUBSCRIPTION_ID = #attributes.subscription_id#
                    </cfif>
                    <cfif len(attributes.project_id)>
                        AND S.PROJECT_ID = #attributes.project_id#
                    </cfif>
                    <cfif isdefined("attributes.is_project")>
                        AND S.PROJECT_ID IS NULL
                    </cfif>
                GROUP BY
                    SRR.PRODUCT_ID,
                    SRR.STOCK_ID,
                    S.SHIP_DATE,
                    S.SHIP_ID,
                    SHIP_NUMBER	,
                    ISNULL(S.PROJECT_ID,0)	
                <cfif isdefined('list_period_years') and listfind(list_period_years,(get_all_periods.PERIOD_YEAR+1))>
                UNION ALL
                    SELECT
                        SUM(AMOUNT) AS AMOUNT,
                        SRR.PRODUCT_ID,
                        SRR.STOCK_ID,
                        S.SHIP_ID,
                        S.SHIP_DATE,
                        #get_all_periods.period_id# SHIP_PERIOD_ID,
                        #get_all_periods.period_year# SHIP_PERIOD_YEAR,
                        SHIP_NUMBER	,
                        ISNULL(S.PROJECT_ID,0) PROJECT_ID
                    FROM
                        #dsn#_#get_all_periods.PERIOD_YEAR+1#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
                        #dsn#_#get_all_periods.PERIOD_YEAR+1#_#get_all_periods.OUR_COMPANY_ID#.INVOICE INV,
                        #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP S,
                        #dsn3_alias#.STOCKS SS
                    WHERE
                        SRR.TO_INVOICE_ID =INV.INVOICE_ID
                        AND SRR.SHIP_ID = S.SHIP_ID
                        AND SRR.STOCK_ID = SS.STOCK_ID
                        AND S.SHIP_TYPE IN (72,75,77,79)
                        AND INV.PURCHASE_SALES = 1
                        AND SRR.TO_INVOICE_CAT = INV.INVOICE_CAT
                        AND SHIP_PERIOD=#get_all_periods.period_id#
                        AND SRR.TO_INVOICE_ID IS NOT NULL
                        AND SS.IS_INVENTORY = 1
                        <cfif len(attributes.subscription_id)>
                            AND S.SUBSCRIPTION_ID = #attributes.subscription_id#
                        </cfif>
                        <cfif len(attributes.project_id)>
                            AND S.PROJECT_ID = #attributes.project_id#
                        </cfif>
                        <cfif isdefined("attributes.is_project")>
                            AND S.PROJECT_ID IS NULL
                        </cfif>
                    GROUP BY
                        SRR.PRODUCT_ID,
                        SRR.STOCK_ID,
                        S.SHIP_DATE,
                        S.SHIP_ID,
                        SHIP_NUMBER	,
                        ISNULL(S.PROJECT_ID,0)
                </cfif>
            </cfloop>
             ) AS A1
            GROUP BY
                PRODUCT_ID,
                STOCK_ID,
                SHIP_ID,
                SHIP_DATE,
                SHIP_PERIOD_ID,
                SHIP_PERIOD_YEAR,
                SHIP_NUMBER	,
                PROJECT_ID	
        </cfquery>
        <!--- Sat???? ????k????lar --->
        <cfquery name="get_sale_row" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
            SELECT
                PRODUCT_ID,
                STOCK_ID,
                PRODUCT_NAME,
                SUM(TOTAL_AMOUNT) TOTAL_AMOUNT,
                SHIP_ID,
                SHIP_DATE,
                SHIP_PERIOD_ID,
                SHIP_PERIOD_YEAR,
                SHIP_NUMBER,
                PROJECT_ID	
            FROM
            (
            <cfloop query="get_all_periods">
                SELECT
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.PRODUCT_NAME,
                    SUM(SHIP_ROW.AMOUNT) TOTAL_AMOUNT,
                    SHIP.SHIP_ID,
                    SHIP.SHIP_DATE,
                    #get_all_periods.period_id# SHIP_PERIOD_ID,
                    #get_all_periods.period_year# SHIP_PERIOD_YEAR,
                    SHIP_NUMBER,
                    ISNULL(SHIP.PROJECT_ID,0) PROJECT_ID		
                FROM 
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP SHIP,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SHIP_ROW,
                    #dsn3_alias#.STOCKS S
                WHERE 
                    SHIP_ROW.SHIP_ID = SHIP.SHIP_ID
                    AND SHIP.IS_SHIP_IPTAL = 0 
                    AND SHIP_ROW.STOCK_ID = S.STOCK_ID
                    AND SHIP.SHIP_TYPE IN(70,71,88)
                    AND S.IS_INVENTORY = 1
                    AND SHIP.SHIP_ID NOT IN(SELECT SF.RELATED_SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.STOCK_FIS SF WHERE SF.RELATED_SHIP_ID IS NOT NULL AND SF.RELATED_SHIP_ID=SHIP.SHIP_ID)
                    <cfif len(attributes.subscription_id)>
                        AND SHIP.SUBSCRIPTION_ID = #attributes.subscription_id#
                    </cfif>
                    <cfif len(attributes.project_id)>
                        AND SHIP.PROJECT_ID = #attributes.project_id#
                    </cfif>
                    <cfif isdefined("attributes.is_project")>
                        AND SHIP.PROJECT_ID IS NULL
                    </cfif>
                GROUP  BY
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.PRODUCT_NAME,
                    SHIP.SHIP_ID,
                    SHIP.SHIP_DATE,
                    SHIP_NUMBER	,
                    ISNULL(SHIP.PROJECT_ID,0)		
                <cfif currentrow neq get_all_periods.recordcount> UNION ALL </cfif>					
            </cfloop>
            )T1
            GROUP BY
                PRODUCT_ID,
                STOCK_ID,
                PRODUCT_NAME,
                SHIP_ID,
                SHIP_DATE,
                SHIP_PERIOD_ID,
                SHIP_PERIOD_YEAR,
                SHIP_NUMBER	,
                PROJECT_ID			
            ORDER BY
                SHIP_DATE
        </cfquery>
        <!--- sat???? iadeleri --->
        <cfquery name="get_sale_iade" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
            <cfloop query="get_all_periods">
                SELECT
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.PRODUCT_NAME,
                    SUM(SHIP_ROW.AMOUNT) TOTAL_AMOUNT
                FROM 
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP SHIP,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SHIP_ROW,
                    #dsn3_alias#.STOCKS S
                WHERE 
                    SHIP_ROW.SHIP_ID = SHIP.SHIP_ID
                    AND SHIP.IS_SHIP_IPTAL = 0 
                    AND SHIP_ROW.STOCK_ID = S.STOCK_ID
                    AND SHIP.SHIP_TYPE IN(73,74)
                    AND S.IS_INVENTORY = 1
                    AND SHIP.SHIP_ID NOT IN(SELECT SF.RELATED_SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.STOCK_FIS SF WHERE SF.RELATED_SHIP_ID IS NOT NULL AND SF.RELATED_SHIP_ID=SHIP.SHIP_ID)
                    <cfif len(attributes.subscription_id)>
                        AND SHIP.SUBSCRIPTION_ID = #attributes.subscription_id#
                    </cfif>
                    <cfif len(attributes.project_id)>
                        AND SHIP.PROJECT_ID = #attributes.project_id#
                    </cfif>
                    <cfif isdefined("attributes.is_project")>
                        AND SHIP.PROJECT_ID IS NULL
                    </cfif>
                GROUP  BY
                    S.PRODUCT_ID,
                    S.STOCK_ID,
                    S.PRODUCT_NAME
                <cfif currentrow neq get_all_periods.recordcount> UNION ALL </cfif>					
            </cfloop>
        </cfquery>
        <!--- faturalanm???? sat???? --->
        <cfquery name="get_inv_sale_amount" datasource="#dsn#">
            SELECT
                SUM(AMOUNT) AS INV_AMOUNT,
                PRODUCT_ID,
                STOCK_ID,
                SHIP_ID,
                SHIP_DATE,
                SHIP_PERIOD_ID,
                SHIP_PERIOD_YEAR,
                SHIP_NUMBER,
                PROJECT_ID		
            FROM
            (
            <cfloop query="get_all_periods">
            <cfif currentrow neq 1> UNION ALL </cfif>					
                SELECT
                    SUM(INV_R.AMOUNT) AS AMOUNT,
                    SR.PRODUCT_ID,
                    SR.STOCK_ID,
                    S.SHIP_ID,
                    S.SHIP_DATE,
                    #get_all_periods.period_id# SHIP_PERIOD_ID,
                    #get_all_periods.period_year# SHIP_PERIOD_YEAR	,
                    S.SHIP_NUMBER,
                    ISNULL(S.PROJECT_ID,0) PROJECT_ID	
                FROM
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_SHIPS SRR,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE INV,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_ROW INV_R,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP S,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SR,
                    #dsn3_alias#.STOCKS SS
    
                WHERE
                    SRR.INVOICE_ID =INV.INVOICE_ID
                    AND INV_R.INVOICE_ID = INV.INVOICE_ID
                    AND ISNULL(INV_R.WRK_ROW_RELATION_ID,0) = ISNULL(SR.WRK_ROW_ID,0)
                    AND ISNULL(S.IS_WITH_SHIP,0) = 0
                    AND SRR.SHIP_ID = S.SHIP_ID
                    AND SR.SHIP_ID = S.SHIP_ID
                    AND SR.STOCK_ID = SS.STOCK_ID
                    AND INV_R.STOCK_ID = SS.STOCK_ID
                    AND S.SHIP_TYPE IN (70,71,88)
                    AND INV.PURCHASE_SALES = 1
                    AND SS.IS_INVENTORY = 1
                    AND S.SHIP_ID NOT IN(SELECT SF.RELATED_SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.STOCK_FIS SF WHERE SF.RELATED_SHIP_ID IS NOT NULL AND SF.RELATED_SHIP_ID=S.SHIP_ID)
                    <cfif len(attributes.subscription_id)>
                        AND S.SUBSCRIPTION_ID = #attributes.subscription_id#
                    </cfif>
                    <cfif len(attributes.project_id)>
                        AND S.PROJECT_ID = #attributes.project_id#
                    </cfif>
                    <cfif isdefined("attributes.is_project")>
                        AND S.PROJECT_ID IS NULL
                    </cfif>
                GROUP BY
                    SR.PRODUCT_ID,
                    SR.STOCK_ID,
                    S.SHIP_DATE,
                    S.SHIP_ID,
                    S.SHIP_NUMBER	,
                    ISNULL(S.PROJECT_ID,0)	
                UNION ALL
                SELECT
                    SUM(INV_R.AMOUNT) AS AMOUNT,
                    SR.PRODUCT_ID,
                    SR.STOCK_ID,
                    S.SHIP_ID,
                    S.SHIP_DATE,
                    #get_all_periods.period_id# SHIP_PERIOD_ID,
                    #get_all_periods.period_year# SHIP_PERIOD_YEAR	,
                    S.SHIP_NUMBER,
                    ISNULL(S.PROJECT_ID,0) PROJECT_ID	
                FROM
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_SHIPS SRR,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE INV,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_ROW INV_R,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP S,
                    #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW SR,
                    #dsn3_alias#.STOCKS SS
                WHERE
                    SRR.INVOICE_ID =INV.INVOICE_ID
                    AND INV_R.INVOICE_ID = INV.INVOICE_ID
                    AND ISNULL(SR.WRK_ROW_RELATION_ID,0) = ISNULL(INV_R.WRK_ROW_ID,0)
                    AND ISNULL(S.IS_WITH_SHIP,0) = 1
                    AND SRR.SHIP_ID = S.SHIP_ID
                    AND SR.SHIP_ID = S.SHIP_ID
                    AND SR.STOCK_ID = SS.STOCK_ID
                    AND INV_R.STOCK_ID = SS.STOCK_ID
                    AND S.SHIP_TYPE IN (70,71,88)
                    AND INV.PURCHASE_SALES = 1
                    AND SS.IS_INVENTORY = 1
                    AND S.SHIP_ID NOT IN(SELECT SF.RELATED_SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.STOCK_FIS SF WHERE SF.RELATED_SHIP_ID IS NOT NULL AND SF.RELATED_SHIP_ID=S.SHIP_ID)
                    <cfif len(attributes.subscription_id)>
                        AND S.SUBSCRIPTION_ID = #attributes.subscription_id#
                    </cfif>
                    <cfif len(attributes.project_id)>
                        AND S.PROJECT_ID = #attributes.project_id#
                    </cfif>
                    <cfif isdefined("attributes.is_project")>
                        AND S.PROJECT_ID IS NULL
                    </cfif>
                GROUP BY
                    SR.PRODUCT_ID,
                    SR.STOCK_ID,
                    S.SHIP_DATE,
                    S.SHIP_ID,
                    S.SHIP_NUMBER,
                    ISNULL(S.PROJECT_ID,0)
            </cfloop>
             ) AS A1
            GROUP BY
                PRODUCT_ID,
                STOCK_ID,
                SHIP_ID,
                SHIP_DATE,
                SHIP_PERIOD_ID,
                SHIP_PERIOD_YEAR,
                SHIP_NUMBER	,
                PROJECT_ID	
        </cfquery>
        <!--- Konsinyeler --->
        <cfoutput query="get_konsinye_row">
            <cfif isdefined("kons_irsaliye_list_#stock_id#") and not listfind(evaluate("kons_irsaliye_list_#stock_id#"),"#ship_id#;#ship_period_id#;#total_kons_amount#;#ship_period_year#;#ship_number#;#project_id#")>
                <cfset "kons_irsaliye_list_#stock_id#" = listappend(evaluate("kons_irsaliye_list_#stock_id#"),"#ship_id#;#ship_period_id#;#total_kons_amount#;#ship_period_year#;#ship_number#;#project_id#")>
            <cfelse>
                <cfset "kons_irsaliye_list_#stock_id#" = "#ship_id#;#ship_period_id#;#total_kons_amount#;#ship_period_year#;#ship_number#;#project_id#">
            </cfif>
        </cfoutput>
        <cfoutput query="get_konsinye_iade">
            <cfif isdefined("kons_iade_#stock_id#")>
                <cfset "kons_iade_#stock_id#" = evaluate("kons_iade_#stock_id#") + total_kons_amount>
            <cfelse>
                <cfset "kons_iade_#stock_id#" = total_kons_amount>
            </cfif>
        </cfoutput>
        <cfoutput query="get_inv_amount">
            <cfif isdefined("inv_irsaliye_list_#stock_id#") and not listfind(evaluate("inv_irsaliye_list_#stock_id#"),"#ship_id#;#ship_period_id#;#inv_amount#;#ship_period_year#;#ship_number#;#project_id#")>
                <cfset "inv_irsaliye_list_#stock_id#" = listappend(evaluate("inv_irsaliye_list_#stock_id#"),"#ship_id#;#ship_period_id#;#inv_amount#;#ship_period_year#;#ship_number#;#project_id#")>
            <cfelse>
                <cfset "inv_irsaliye_list_#stock_id#" = "#ship_id#;#ship_period_id#;#inv_amount#;#ship_period_year#;#ship_number#;#project_id#">
            </cfif>
            <cfif isdefined("inv_amount_#stock_id#")>
                <cfset "inv_amount_#stock_id#" = evaluate("inv_amount_#stock_id#") + inv_amount>
            <cfelse>
                <cfset "inv_amount_#stock_id#" = inv_amount>
            </cfif>
        </cfoutput>
        <!--- Sat????lar --->
        <cfoutput query="get_sale_row">
            <cfif isdefined("sale_irsaliye_list_#stock_id#") and not listfind(evaluate("sale_irsaliye_list_#stock_id#"),"#ship_id#;#ship_period_id#;#total_amount#;#ship_period_year#;#ship_number#;#project_id#")>
                <cfset "sale_irsaliye_list_#stock_id#" = listappend(evaluate("sale_irsaliye_list_#stock_id#"),"#ship_id#;#ship_period_id#;#total_amount#;#ship_period_year#;#ship_number#;#project_id#")>
            <cfelse>
                <cfset "sale_irsaliye_list_#stock_id#" = "#ship_id#;#ship_period_id#;#total_amount#;#ship_period_year#;#ship_number#;#project_id#">
            </cfif>
            <cfif isdefined("sale_amount_#stock_id#")>
                <cfset "sale_amount_#stock_id#" = evaluate("sale_amount_#stock_id#") + total_amount>
            <cfelse>
                <cfset "sale_amount_#stock_id#" = total_amount>
            </cfif>
        </cfoutput>
        <cfoutput query="get_sale_iade">
            <cfif isdefined("sale_iade_#stock_id#")>
                <cfset "sale_iade_#stock_id#" = evaluate("sale_iade_#stock_id#") + total_amount>
            <cfelse>
                <cfset "sale_iade_#stock_id#" = total_amount>
            </cfif>
        </cfoutput>
        <cfoutput query="get_inv_sale_amount">
            <cfif isdefined("inv_sale_amount_#stock_id#")>
                <cfset "inv_sale_amount_#stock_id#" = evaluate("inv_sale_amount_#stock_id#") + inv_amount>
            <cfelse>
                <cfset "inv_sale_amount_#stock_id#" = inv_amount>
            </cfif>
        </cfoutput>
    </cfif>
<!---</cfif>--->
<script type="text/javascript">
	<!---<cfif not isdefined("attributes.event") or attributes.event is 'list'>--->
		function control()
		{
			if((document.order_form.subscription_id.value == '' || document.order_form.subscription_no.value == '') && (document.order_form.project_id.value == '' || document.order_form.project_name.value == ''))
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1420.Abone'> <cf_get_lang_main no='586.veya'> <cf_get_lang_main no='4.Proje'> !");
				return false;
			}
			return true;
		}	
		<cfif isdefined("attributes.form_submitted")>
			function kontrol_et(type)
			{
				kontrol_ = 0;
				if(type == 0)
				{
					if (document.send_form_.invent_return_row_ids.length != undefined) /* n tane*/
					{
						for (i=0; i < document.send_form_.invent_return_row_ids.length; i++)
						{
							if (document.send_form_.invent_return_row_ids[i].checked)
								kontrol_ = 1;
						}							
					}
					else
					{
						if (document.send_form_.invent_return_row_ids.checked)
							kontrol_ = 1;	
					}
				}
				else
				{
					document.send_form_2.kons_return_type.value = type;
					if (document.send_form_2.kons_row_ids.length != undefined) /* n tane*/
					{
						for (i=0; i < document.send_form_2.kons_row_ids.length; i++)
						{
							if (document.send_form_2.kons_row_ids[i].checked)
								kontrol_ = 1;
						}							
					}
					else
					{
						if (document.send_form_2.kons_row_ids.checked)
							kontrol_ = 1;	
					}
				}
				if(kontrol_ == 0)
				{
					alert("<cf_get_lang no='620.En Az Bir ????lem Se??melisiniz'> !");
					return false;
				}
				return true;
			}
			function kontrol_amount(s_id,type)
			{
				if(type == 0)
				{
					old_amount = eval('document.all.old_invent_return_amount_'+s_id).value;
					new_amount = parseFloat(filterNum(eval('document.all.invent_return_amount_'+s_id).value,0));
					if(new_amount > old_amount)
					{
						alert("<cf_get_lang no='613.Girilebilecek Aral??k'> 1 -"+ old_amount);
						eval('document.all.invent_return_amount_'+s_id).value = commaSplit(old_amount,0);
					}
				}
				else if(type == 1)
				{
					old_amount = eval('document.all.old_kons_iade_'+s_id).value;
					new_amount = parseFloat(filterNum(eval('document.all.kons_iade_'+s_id).value,0));
					if(new_amount > old_amount)
					{
						alert("<cf_get_lang no='613.Girilebilecek Aral??k'> 1 -"+ old_amount);
						eval('document.all.kons_iade_'+s_id).value = commaSplit(old_amount,0);
					}
				}
				else if(type == 2)
				{
					old_amount = eval('document.all.old_sale_iade_'+s_id).value;
					new_amount = parseFloat(filterNum(eval('document.all.sale_iade_'+s_id).value,0));
					if(new_amount > old_amount)
					{
						alert("<cf_get_lang no='613.Girilebilecek Aral??k'> 1 -"+ old_amount);
						eval('document.all.sale_iade_'+s_id).value = commaSplit(old_amount,0);
					}
				}
			}
		</cfif>
		
	<!---</cfif>--->
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.add_invent_return';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'stock/form/add_invent_return.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'stock/form/add_invent_return.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'stock.add_invent_return';
	
	if(isdefined('get_system_inventory') and get_system_inventory.recordcount)
	{
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.add_invent_return';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'controller/stockPurchase.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'controller/stockPurchase.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_purchase&event=upd';	
	}
	
	WOStruct['#attributes.fuseaction#']['addOther'] = structNew();
	WOStruct['#attributes.fuseaction#']['addOther']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addOther']['fuseaction'] = 'stock.add_invent_return';
	WOStruct['#attributes.fuseaction#']['addOther']['filePath'] = 'controller/stockPurchase.cfm';
	WOStruct['#attributes.fuseaction#']['addOther']['queryPath'] = 'controller/stockPurchase.cfm';
	WOStruct['#attributes.fuseaction#']['addOther']['nextEvent'] = 'stock.form_add_purchase&event=upd';	
</cfscript>
