<cfif isdefined("attributes.is_clear_old_rows")>
    <cfquery name="get_iade_invoices" datasource="#dsn#">
        SELECT
            *
        FROM
            (
            <cfoutput query="get_periods">
            <cfif currentrow neq 1>
                UNION ALL
            </cfif>
            SELECT 
            	#period_id# AS PERIOD_ID,
                I.INVOICE_ID,
                I.COMPANY_ID,
                I.INVOICE_DATE
            FROM 
            	#dsn#_#period_year#_#our_company_id#.INVOICE I 
            WHERE 
            	<cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
                    I.COMPANY_ID IN (#attributes.company_ids#) AND
                </cfif>
                I.INVOICE_CAT = 62 AND
            	I.INVOICE_DATE >= #attributes.startdate# AND
                I.INVOICE_DATE <= #attributes.finishdate# AND
                ISNULL(I.IS_IPTAL,0) = 0
            </cfoutput>
            ) T1
    </cfquery>
    
    <cfoutput query="get_iade_invoices">
        <cfquery name="upd_" datasource="#dsn_dev#">
            DELETE FROM
                INVOICE_ROW_CLOSED
            WHERE
                INVOICE_ID = #INVOICE_ID# AND
                PERIOD_ID = #PERIOD_ID#
        </cfquery>
        
        <cfquery name="upd_" datasource="#dsn_dev#">
            UPDATE
                INVOICE_REVENUE_ROWS
            SET
                REVENUE_PAID = ISNULL((SELECT
                        SUM(IRC.PAID_COST)
                    FROM
                        INVOICE_ROW_CLOSED IRC
                    WHERE
                        IRC.RELATED_ROW_ID = INVOICE_REVENUE_ROWS.C_ROW_ID
                        AND
                        IRC.TYPE = 1),0)
            WHERE
                YEAR(INVOICE_DATE) = #YEAR(createodbcdatetime(invoice_date))# AND
                COMPANY_ID = #COMPANY_ID#
        </cfquery>
    </cfoutput>
    iade fatura satırları silindi <br />
            
    <cfquery name="cont_" datasource="#dsn_dev#">
        DELETE
        FROM
            INVOICE_REVENUE_ROWS
        WHERE
        	<cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
                COMPANY_ID IN (#attributes.company_ids#) AND
            </cfif>
            INVOICE_DATE >= #attributes.startdate# AND
            INVOICE_DATE <= #attributes.finishdate# AND
            ISNULL(REVENUE_PAID,0) = 0
    </cfquery>
    kapama yapılmamış ciro primleri silindi.<br />
</cfif>

<!--- aylik --->
<cfquery name="get_ciro_rows" datasource="#dsn#">
SELECT
	*
FROM
	(
	<cfoutput query="get_periods">
    <cfif currentrow neq 1>
    	UNION ALL
    </cfif>
    SELECT
        #period_id# AS PERIOD_ID,
        IR.INVOICE_ROW_ID,
        IR.WRK_ROW_ID,
        I.INVOICE_CAT,
        I.PROCESS_CAT,
        I.INVOICE_DATE,
        I.INVOICE_ID,
        I.INVOICE_NUMBER,
        IR.AMOUNT,
        IR.NETTOTAL,
        IR.PRODUCT_ID,
        IR.STOCK_ID,
        IR.TAX,
        I.COMPANY_ID,
        I.PROJECT_ID,
        IR.NETTOTAL AS REVENUE_GROSS,
        CAST(I.COMPANY_ID AS NVARCHAR) + '_' + CAST(ISNULL(I.PROJECT_ID,0) AS NVARCHAR) AS COMP_CODE,
        #dsn_dev_alias#.get_product_rate(IR.PRODUCT_ID,I.INVOICE_DATE,I.COMPANY_ID,ISNULL(I.PROJECT_ID,0),1) AS REVENUE_RATE,
        #dsn_dev_alias#.get_product_rate_iade(IR.PRODUCT_ID,I.INVOICE_DATE,I.COMPANY_ID,ISNULL(I.PROJECT_ID,0),1) AS REVENUE_RATE_IADE,
        1 AS REVENUE_PERIOD
    FROM
    	#dsn#_#period_year#_#our_company_id#.INVOICE I,
        #dsn#_#period_year#_#our_company_id#.INVOICE_ROW IR
    WHERE
        <cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
            I.COMPANY_ID IN (#attributes.company_ids#) AND
        </cfif>
        I.INVOICE_DATE >= #attributes.startdate# AND
        I.INVOICE_DATE <= #attributes.finishdate# AND
        I.INVOICE_ID = IR.INVOICE_ID AND
        ISNULL(I.IS_IPTAL,0) = 0 AND
        I.PURCHASE_SALES = 0 AND
        I.PROCESS_CAT NOT IN (#dahil_olmayan_tipler#) AND
        IR.NETTOTAL > 0
        AND 
        	IR.WRK_ROW_ID NOT IN (SELECT IRR.WRK_ROW_ID FROM #dsn_dev#.INVOICE_REVENUE_ROWS IRR WHERE PERIOD_ID = #period_id# AND IRR.REVENUE_PERIOD = 1)
    </cfoutput>
    ) T1
WHERE
	REVENUE_RATE <> '0' AND
    REVENUE_RATE IS NOT NULL AND
    REVENUE_RATE <> '' 
</cfquery>

<cfset kayit_ = 0>
<cfoutput query="get_ciro_rows">
	<cfif len(STOCK_ID)>
        <cfquery name="cont_" datasource="#dsn_dev#">
            SELECT
                *
            FROM
                INVOICE_REVENUE_ROWS
            WHERE
                REVENUE_PERIOD = 1 AND
                INVOICE_ID = #INVOICE_ID# AND
                PERIOD_ID = #PERIOD_ID# AND
                WRK_ROW_ID = '#WRK_ROW_ID#' AND
                STOCK_ID = #STOCK_ID#
        </cfquery>
        <CFSET REVENUE_GROSS_ = REVENUE_GROSS>
    
        <cfif not cont_.recordcount>
            <cfset rev_net_ = 0>
            <cfloop list="#REVENUE_RATE#" index="aaa" delimiters="+">
                <cfif aaa contains '.'>
                	<cfset rev1 = wrk_round((REVENUE_GROSS - rev_net_)  * (aaa  / 100),3)>
                <cfelse>
					<cfset rev1 = wrk_round((REVENUE_GROSS - rev_net_)  * (filternum(aaa)  / 100),3)>
                </cfif>
                <cfset rev_net_ = rev_net_ + rev1>
            </cfloop>
            <cfquery name="add_" datasource="#dsn_dev#">
                INSERT INTO
                    INVOICE_REVENUE_ROWS           
                    (
                    INVOICE_ID,
                    INVOICE_NUMBER,
                    INVOICE_ROW_ID,
                    PRODUCT_ID,
                    STOCK_ID,
                    INVOICE_DATE,
                    AMOUNT,
                    REVENUE_GROSS,
                    PERIOD_ID,
                    WRK_ROW_ID,
                    COMPANY_ID,
                    PROJECT_ID,
                    COMP_CODE,
                    REVENUE_NET,
                    REVENUE_RATE,
                    REVENUE_PAID,
                    REVENUE_PERIOD
                    )
                    VALUES
                    (
                    #INVOICE_ID#,
                    '#INVOICE_NUMBER#',
                    #INVOICE_ROW_ID#,
                    #PRODUCT_ID#,
                    #STOCK_ID#,
                    #CREATEODBCDATETIME(INVOICE_DATE)#,
                    #AMOUNT#,
                    #REVENUE_GROSS#,
                    #PERIOD_ID#,
                    '#WRK_ROW_ID#',
                    #COMPANY_ID#,
                    <cfif len(PROJECT_ID)>#PROJECT_ID#<cfelse>NULL</cfif>,
                    '#COMP_CODE#',
                    #rev_net_#,
                    '#REVENUE_RATE#',
                    0,
                    1
                    )
            </cfquery>
            <cfset kayit_ = kayit_ + 1>
         <cfelseif cont_.recordcount and cont_.REVENUE_GROSS lt REVENUE_GROSS_>
                <cfquery name="upd_" datasource="#dsn_dev#">
                UPDATE
                    INVOICE_REVENUE_ROWS
                SET
                    OLD_VALUE = #cont_.REVENUE_GROSS#,
                    REVENUE_GROSS = #REVENUE_GROSS_#,
                    IS_UPDATE = 1
                WHERE
                    C_ROW_ID = #cont_.C_ROW_ID#
                 </cfquery>
         </cfif>
     </cfif>
</cfoutput>
<br />
<cfoutput>#get_ciro_rows.recordcount# satırdan #kayit_# kayıt oluşturuldu.</cfoutput> Kayıt Aktarıldı.
<!--- aylik --->

<!--- iki aylik --->
<cfquery name="get_ciro_rows" datasource="#dsn#">
SELECT
	*
FROM
	(
	<cfoutput query="get_periods">
    <cfif currentrow neq 1>
    	UNION ALL
    </cfif>
    SELECT
        #period_id# AS PERIOD_ID,
        IR.INVOICE_ROW_ID,
        IR.WRK_ROW_ID,
        I.INVOICE_DATE,
        I.INVOICE_ID,
        I.INVOICE_NUMBER,
        IR.AMOUNT,
        IR.NETTOTAL,
        IR.PRODUCT_ID,
        IR.STOCK_ID,
        IR.TAX,
        I.COMPANY_ID,
        I.PROJECT_ID,
        IR.NETTOTAL AS REVENUE_GROSS,
        CAST(I.COMPANY_ID AS NVARCHAR) + '_' + CAST(ISNULL(I.PROJECT_ID,0) AS NVARCHAR) AS COMP_CODE,
        #dsn_dev_alias#.get_product_rate(IR.PRODUCT_ID,I.INVOICE_DATE,I.COMPANY_ID,ISNULL(I.PROJECT_ID,0),2) AS REVENUE_RATE,
        #dsn_dev_alias#.get_product_rate_iade(IR.PRODUCT_ID,I.INVOICE_DATE,I.COMPANY_ID,ISNULL(I.PROJECT_ID,0),1) AS REVENUE_RATE_IADE,
        2 AS REVENUE_PERIOD
    FROM
    	#dsn#_#period_year#_#our_company_id#.INVOICE I,
        #dsn#_#period_year#_#our_company_id#.INVOICE_ROW IR
    WHERE
        <cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
            I.COMPANY_ID IN (#attributes.company_ids#) AND
        </cfif>
        I.INVOICE_DATE >= #attributes.startdate# AND
        I.INVOICE_DATE <= #attributes.finishdate# AND
        I.INVOICE_ID = IR.INVOICE_ID AND
        ISNULL(I.IS_IPTAL,0) = 0 AND
        I.PURCHASE_SALES = 0 AND
        I.PROCESS_CAT NOT IN (#dahil_olmayan_tipler#) AND
        IR.NETTOTAL > 0
        AND IR.WRK_ROW_ID NOT IN (SELECT IRR.WRK_ROW_ID FROM #dsn_dev#.INVOICE_REVENUE_ROWS IRR WHERE PERIOD_ID = #period_id# AND IRR.REVENUE_PERIOD = 2 AND IRR.WRK_ROW_ID IS NOT NULL)
    </cfoutput>
    ) T1
WHERE
	REVENUE_RATE <> '0' AND
    REVENUE_RATE IS NOT NULL AND
    REVENUE_RATE <> '' 
</cfquery>

<cfset kayit_ = 0>
<cfoutput query="get_ciro_rows">
	<cfif len(STOCK_ID)>
        <cfquery name="cont_" datasource="#dsn_dev#">
            SELECT
                *
            FROM
                INVOICE_REVENUE_ROWS
            WHERE
                REVENUE_PERIOD = 2 AND
                INVOICE_ID = #INVOICE_ID# AND
                PERIOD_ID = #PERIOD_ID# AND
                WRK_ROW_ID = '#WRK_ROW_ID#' AND
                STOCK_ID = #STOCK_ID#
        </cfquery>
        <CFSET REVENUE_GROSS_ = REVENUE_GROSS>
    
        <cfif not cont_.recordcount>
            <cfset rev_net_ = 0>
            <cfloop list="#REVENUE_RATE#" index="aaa" delimiters="+">
                <cfif aaa contains '.'>
                	<cfset rev1 = wrk_round((REVENUE_GROSS - rev_net_)  * (aaa  / 100),3)>
                <cfelse>
					<cfset rev1 = wrk_round((REVENUE_GROSS - rev_net_)  * (filternum(aaa)  / 100),3)>
                </cfif>
                <cfset rev_net_ = rev_net_ + rev1>
            </cfloop>
            <cfquery name="add_" datasource="#dsn_dev#">
                INSERT INTO
                    INVOICE_REVENUE_ROWS           
                    (
                    INVOICE_ID,
                    INVOICE_NUMBER,
                    INVOICE_ROW_ID,
                    PRODUCT_ID,
                    STOCK_ID,
                    INVOICE_DATE,
                    AMOUNT,
                    REVENUE_GROSS,
                    PERIOD_ID,
                    WRK_ROW_ID,
                    COMPANY_ID,
                    PROJECT_ID,
                    COMP_CODE,
                    REVENUE_NET,
                    REVENUE_RATE,
                    REVENUE_PAID,
                    REVENUE_PERIOD
                    )
                    VALUES
                    (
                    #INVOICE_ID#,
                    '#INVOICE_NUMBER#',
                    #INVOICE_ROW_ID#,
                    #PRODUCT_ID#,
                    #STOCK_ID#,
                    #CREATEODBCDATETIME(INVOICE_DATE)#,
                    #AMOUNT#,
                    #REVENUE_GROSS#,
                    #PERIOD_ID#,
                    '#WRK_ROW_ID#',
                    #COMPANY_ID#,
                    <cfif len(PROJECT_ID)>#PROJECT_ID#<cfelse>NULL</cfif>,
                    '#COMP_CODE#',
                    #rev_net_#,
                    '#REVENUE_RATE#',
                    0,
                    2
                    )
            </cfquery>
            <cfset kayit_ = kayit_ + 1>
         <cfelseif cont_.recordcount and cont_.REVENUE_GROSS lt REVENUE_GROSS_>
                <cfquery name="upd_" datasource="#dsn_dev#">
                UPDATE
                    INVOICE_REVENUE_ROWS
                SET
                    OLD_VALUE = #cont_.REVENUE_GROSS#,
                    REVENUE_GROSS = #REVENUE_GROSS_#,
                    IS_UPDATE = 1
                WHERE
                    C_ROW_ID = #cont_.C_ROW_ID#
                 </cfquery>
         </cfif>
     </cfif>
</cfoutput>
<br />
<cfoutput>#get_ciro_rows.recordcount# satırdan #kayit_# kayıt oluşturuldu.</cfoutput> Kayıt Aktarıldı.
<!--- iki aylik --->

<!--- uc aylik --->
<cfquery name="get_ciro_rows" datasource="#dsn#">
SELECT
	*
FROM
	(
	<cfoutput query="get_periods">
    <cfif currentrow neq 1>
    	UNION ALL
    </cfif>
    SELECT
        #period_id# AS PERIOD_ID,
        IR.INVOICE_ROW_ID,
        IR.WRK_ROW_ID,
        I.INVOICE_DATE,
        I.INVOICE_ID,
        I.INVOICE_NUMBER,
        IR.AMOUNT,
        IR.NETTOTAL,
        IR.PRODUCT_ID,
        IR.STOCK_ID,
        IR.TAX,
        I.COMPANY_ID,
        I.PROJECT_ID,
        IR.NETTOTAL AS REVENUE_GROSS,
        CAST(I.COMPANY_ID AS NVARCHAR) + '_' + CAST(ISNULL(I.PROJECT_ID,0) AS NVARCHAR) AS COMP_CODE,
        #dsn_dev_alias#.get_product_rate(IR.PRODUCT_ID,I.INVOICE_DATE,I.COMPANY_ID,ISNULL(I.PROJECT_ID,0),3) AS REVENUE_RATE,
        #dsn_dev_alias#.get_product_rate_iade(IR.PRODUCT_ID,I.INVOICE_DATE,I.COMPANY_ID,ISNULL(I.PROJECT_ID,0),1) AS REVENUE_RATE_IADE,
        3 AS REVENUE_PERIOD
    FROM
    	#dsn#_#period_year#_#our_company_id#.INVOICE I,
        #dsn#_#period_year#_#our_company_id#.INVOICE_ROW IR
    WHERE
        <cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
            I.COMPANY_ID IN (#attributes.company_ids#) AND
        </cfif>
        I.INVOICE_DATE >= #attributes.startdate# AND
        I.INVOICE_DATE <= #attributes.finishdate# AND
        I.INVOICE_ID = IR.INVOICE_ID AND
        ISNULL(I.IS_IPTAL,0) = 0 AND
        I.PURCHASE_SALES = 0 AND
        I.PROCESS_CAT NOT IN (#dahil_olmayan_tipler#) AND
        IR.NETTOTAL > 0
        AND 
        	IR.WRK_ROW_ID NOT IN (SELECT IRR.WRK_ROW_ID FROM #dsn_dev#.INVOICE_REVENUE_ROWS IRR WHERE PERIOD_ID = #period_id# AND IRR.REVENUE_PERIOD = 3)
    </cfoutput>
    ) T1
WHERE
	REVENUE_RATE <> '0' AND
    REVENUE_RATE IS NOT NULL AND
    REVENUE_RATE <> '' 
</cfquery>

<cfset kayit_ = 0>
<cfoutput query="get_ciro_rows">
	<cfif len(STOCK_ID)>
        <cfquery name="cont_" datasource="#dsn_dev#">
            SELECT
                *
            FROM
                INVOICE_REVENUE_ROWS
            WHERE
                REVENUE_PERIOD = 3 AND
                INVOICE_ID = #INVOICE_ID# AND
                PERIOD_ID = #PERIOD_ID# AND
                WRK_ROW_ID = '#WRK_ROW_ID#' AND
                STOCK_ID = #STOCK_ID#
        </cfquery>
        <CFSET REVENUE_GROSS_ = REVENUE_GROSS>
    
        <cfif not cont_.recordcount>
            <cfset rev_net_ = 0>
            <cfloop list="#REVENUE_RATE#" index="aaa" delimiters="+">
                <cfif aaa contains '.'>
                	<cfset rev1 = wrk_round((REVENUE_GROSS - rev_net_)  * (aaa  / 100),3)>
                <cfelse>
					<cfset rev1 = wrk_round((REVENUE_GROSS - rev_net_)  * (filternum(aaa)  / 100),3)>
                </cfif>
                <cfset rev_net_ = rev_net_ + rev1>
            </cfloop>
            <cfquery name="add_" datasource="#dsn_dev#">
                INSERT INTO
                    INVOICE_REVENUE_ROWS           
                    (
                    INVOICE_ID,
                    INVOICE_NUMBER,
                    INVOICE_ROW_ID,
                    PRODUCT_ID,
                    STOCK_ID,
                    INVOICE_DATE,
                    AMOUNT,
                    REVENUE_GROSS,
                    PERIOD_ID,
                    WRK_ROW_ID,
                    COMPANY_ID,
                    PROJECT_ID,
                    COMP_CODE,
                    REVENUE_NET,
                    REVENUE_RATE,
                    REVENUE_PAID,
                    REVENUE_PERIOD
                    )
                    VALUES
                    (
                    #INVOICE_ID#,
                    '#INVOICE_NUMBER#',
                    #INVOICE_ROW_ID#,
                    #PRODUCT_ID#,
                    #STOCK_ID#,
                    #CREATEODBCDATETIME(INVOICE_DATE)#,
                    #AMOUNT#,
                    #REVENUE_GROSS#,
                    #PERIOD_ID#,
                    '#WRK_ROW_ID#',
                    #COMPANY_ID#,
                    <cfif len(PROJECT_ID)>#PROJECT_ID#<cfelse>NULL</cfif>,
                    '#COMP_CODE#',
                    #rev_net_#,
                    '#REVENUE_RATE#',
                    0,
                    3
                    )
            </cfquery>
            <cfset kayit_ = kayit_ + 1>
         <cfelseif cont_.recordcount and cont_.REVENUE_GROSS lt REVENUE_GROSS_>
                <cfquery name="upd_" datasource="#dsn_dev#">
                UPDATE
                    INVOICE_REVENUE_ROWS
                SET
                    OLD_VALUE = #cont_.REVENUE_GROSS#,
                    REVENUE_GROSS = #REVENUE_GROSS_#,
                    IS_UPDATE = 1
                WHERE
                    C_ROW_ID = #cont_.C_ROW_ID#
                 </cfquery>
         </cfif>
     </cfif>
</cfoutput>
<!--- uc aylik --->


<!--- iadeler --->
<cfloop list="1,2,6,12" index="rate_period">
	<cfquery name="get_iade_invoices" datasource="#dsn#">
        SELECT
            *
        FROM
            (
            <cfoutput query="get_periods">
            <cfif currentrow neq 1>
                UNION ALL
            </cfif>
            SELECT 
            	#period_id# AS PERIOD_ID,
                I.INVOICE_ID,
                I.COMPANY_ID,
                I.INVOICE_DATE,
                YEAR(I.INVOICE_DATE) AS YIL
            FROM 
            	#dsn#_#period_year#_#our_company_id#.INVOICE I 
            WHERE 
            	<cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
                    I.COMPANY_ID IN (#attributes.company_ids#) AND
                </cfif>
                I.INVOICE_CAT = 62 AND
            	I.INVOICE_DATE >= #attributes.startdate# AND
                I.INVOICE_DATE <= #attributes.finishdate# AND
                ISNULL(I.IS_IPTAL,0) = 0
            </cfoutput>
            ) T1
    </cfquery>

    <cfloop query="get_iade_invoices">
    	<cfset yil_ = get_iade_invoices.YIL>
        <cfset sirket_ = get_iade_invoices.COMPANY_ID>
        <cfset period_ = get_iade_invoices.PERIOD_ID>
        <cfset invoice_id_ = get_iade_invoices.INVOICE_ID>
        
        <cfquery name="get_invoice" datasource="#dsn#_#yil_#_1">
            SELECT
                ROUND((NETTOTAL / 100 * REVENUE_RATE_PRODUCT) - ODENEN,2) KALAN,
                REVENUE_RATE_PRODUCT,
                REVENUE_RATE_IADE,
                NETTOTAL,
                INVOICE_ID,
                INVOICE_CAT,
                INVOICE_DATE,
                INVOICE_NUMBER,
                NAME_PRODUCT,
                INVOICE_ROW_ID,
                COMPANY_ID,
                PROJECT_ID,
                WRK_ROW_ID
            FROM
                (
                SELECT 
                    ISNULL((SELECT SUM(ISNULL(PAID_COST,0)) FROM #dsn_dev_alias#.INVOICE_ROW_CLOSED IRC WHERE IRC.WRK_ROW_ID = IR.WRK_ROW_ID),0) ODENEN,
                    #dsn_dev_alias#.get_product_rate_iade(IR.PRODUCT_ID,I.INVOICE_DATE,I.COMPANY_ID,ISNULL(I.PROJECT_ID,0),#rate_period#) AS REVENUE_RATE_IADE,
                    CAST(ISNULL(#dsn_dev_alias#.get_product_rate(IR.PRODUCT_ID,I.INVOICE_DATE,I.COMPANY_ID,ISNULL(I.PROJECT_ID,0),#rate_period#),-1) AS FLOAT) AS REVENUE_RATE_PRODUCT,
                    IR.NETTOTAL,
                    I.INVOICE_ID,
                    I.INVOICE_CAT,
                    I.INVOICE_DATE,
                    I.INVOICE_NUMBER,
                    I.COMPANY_ID,
                    I.PROJECT_ID,
                    IR.NAME_PRODUCT,
                    IR.INVOICE_ROW_ID,
                    IR.WRK_ROW_ID
                FROM 
                    INVOICE_ROW IR,
                    INVOICE I
                WHERE
                    I.INVOICE_ID = #invoice_id_# AND
                    I.INVOICE_ID = IR.INVOICE_ID
                ) T1
            WHERE
                REVENUE_RATE_IADE = 1 AND
                REVENUE_RATE_PRODUCT > 0 AND
                ROUND((NETTOTAL / 100 * REVENUE_RATE_PRODUCT) - ODENEN,2) > 0
            ORDER BY
                INVOICE_DATE,
                INVOICE_NUMBER,
                NAME_PRODUCT
        </cfquery>
        
        <cfif get_invoice.recordcount>
            <cfquery name="get_row" datasource="#dsn_dev#">
                SELECT 
                    REVENUE_NET,
                    REVENUE_PAID,
                    (REVENUE_NET - ISNULL(REVENUE_PAID,0)) AS KALAN,
                    COMPANY_ID,
                    PROJECT_ID,
                    C_ROW_ID
               FROM 
                    INVOICE_REVENUE_ROWS 
               WHERE 
                    (REVENUE_NET - ISNULL(REVENUE_PAID,0)) > 0 AND
                    MONTH(INVOICE_DATE) = #month(createodbcdatetime(get_invoice.INVOICE_DATE))# AND
                    YEAR(INVOICE_DATE) = #year(createodbcdatetime(get_invoice.INVOICE_DATE))# AND
                    COMPANY_ID = #get_invoice.COMPANY_ID#
                    <cfif len(get_invoice.PROJECT_ID)>
                        AND PROJECT_ID = #get_invoice.PROJECT_ID#
                    </cfif> 
               ORDER BY
                    INVOICE_DATE ASC,
                    C_ROW_ID ASC
            </cfquery>
            <cfif get_row.recordcount>
                <cfset attributes.type = 1>
                <cfset type = 1>
                <cfset attributes.invoice_row_id_list = valuelist(get_invoice.INVOICE_ROW_ID)>
                <cfset attributes.rate_row_id_list = valuelist(get_invoice.REVENUE_RATE_PRODUCT)>
                <cfset attributes.row_list_id = valuelist(get_row.C_ROW_ID)>
                <cfset row_list_id = valuelist(get_row.C_ROW_ID)>
                <cfinclude template="../query/query/close_action_group_rows_ic.cfm">
            </cfif>
        </cfif>
     </cfloop>
</cfloop>
<!--- iadeler --->
<br />
<cfoutput>#get_ciro_rows.recordcount# satırdan #kayit_# kayıt oluşturuldu.</cfoutput> Kayıt Aktarıldı.
<cf_medium_list_search title="Ciro Primi Eksikleri Aktarma"></cf_medium_list_search>