<cfquery name="GET_SPECT_VAR" datasource="#DSN3#">
    WITH CTE1 AS
    (
        SELECT
            SPECTS.SPECT_VAR_ID AS SPECT_VAR_ID,
            SPECTS.SPECT_MAIN_ID,
            SPECTS.SPECT_VAR_NAME,
            SPECTS.RECORD_EMP,
            SPECTS.RECORD_PAR,
            SPECTS.RECORD_CONS,
            SPECTS.RECORD_DATE AS RECORD_DATE,
            SPECTS.IS_MIX_PRODUCT,
            SPECTS.STOCK_ID,
            SPECT_MAIN.SPECT_STATUS,
            (SELECT ORIGIN FROM SETUP_PRODUCT_CONFIGURATOR WHERE SPECTS.PRODUCT_CONFIGURATOR_ID=SETUP_PRODUCT_CONFIGURATOR.PRODUCT_CONFIGURATOR_ID) AS ORIGIN_ID 
        FROM
            SPECTS,
            SPECT_MAIN
        WHERE
            SPECTS.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID
            AND SPECT_MAIN.SPECT_STATUS = 1
            <cfif len(attributes.keyword)>
                AND SPECTS.SPECT_VAR_NAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'
            </cfif>
            <cfif len(attributes.stock_id)>
                AND SPECTS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
            </cfif>
            <cfif len(attributes.start_date)>
                AND SPECTS.RECORD_DATE >= #attributes.start_date#
            </cfif>
            <cfif len(attributes.finish_date)>
                AND SPECTS.RECORD_DATE <= #attributes.finish_date#
            </cfif>
            <cfif IsDefined("attributes.origin") and len(attributes.origin)>
                <cfif attributes.origin eq 1>
                    AND (SPECTS.IS_MIX_PRODUCT IS NULL OR SPECTS.IS_MIX_PRODUCT = 0)
                <cfelseif attributes.origin eq 2>
                    AND SPECTS.IS_MIX_PRODUCT = 1
                </cfif>
            </cfif>
    ),
    CTE2 AS (
        SELECT
            CTE1.*,
                ROW_NUMBER() OVER (ORDER BY RECORD_DATE DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
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