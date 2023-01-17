<cfquery name="GET_LIST_INTERNALDEMAND" datasource="#DSN3#">
	WITH CTE1 AS (
        SELECT
            S.STOCK_ID,
            S.PRODUCT_ID,
            S.STOCK_CODE,
            S.COMPANY_ID,
            PM.WORK_ID,
            PM.PROJECT_ID,
            PM.PRO_MATERIAL_ID,
            PM.PRO_MATERIAL_ID AS ACTION_ID,
            PM.PRO_MATERIAL_NO,
            PM.ACTION_DATE,
            PM.PLANNER_EMP_ID,
            PM.RECORD_DATE,
            PM.RECORD_IP,
            PM.RECORD_EMP,
            PMR.PRO_MATERIAL_ROW_ID AS ACTION_ROW_ID,
            ISNULL(PMR.SPECT_VAR_ID,0) AS SPECT_VAR_ID,
            PMR.AMOUNT AS QUANTITY, 
            PMR.PRODUCT_NAME,
            ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = PMR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID,
            PMR.UNIT,
            '' PRODUCT_ID_EXCEPTIONS
        FROM
            #dsn_alias#.PRO_MATERIAL PM,
            #dsn_alias#.PRO_MATERIAL_ROW PMR,
            STOCKS S
        WHERE 
            PM.PRO_MATERIAL_ID=PMR.PRO_MATERIAL_ID
            AND PMR.STOCK_ID=S.STOCK_ID
            <!--- Tamami Donusenler Gelmesin / 0 Kalanlar --->
            AND WRK_ROW_ID NOT IN 
            (
                SELECT
                    WRK_ROW_RELATION_ID
                FROM
                    INTERNALDEMAND_ROW
                WHERE
                    PRO_MATERIAL_ID = PMR.PRO_MATERIAL_ID AND
                    WRK_ROW_RELATION_ID = PMR.WRK_ROW_ID AND
                    (PMR.AMOUNT - INTERNALDEMAND_ROW.QUANTITY) = 0
            )
            <cfif len(attributes.internaldemand_stage)>
                AND MATERIAL_STAGE IN (#attributes.internaldemand_stage#)
            </cfif>
            <cfif isDefined('attributes.startdate') and len(attributes.startdate)>
                 AND PM.ACTION_DATE >= #attributes.startdate#
            </cfif>
            <cfif isdefined('attributes.product_id') and len(attributes.product_id) and isdefined('attributes.product_name') and len(attributes.product_name)>
                AND S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
            </cfif>
             <cfif isdefined('attributes.company_id') and len(attributes.company_id) and isdefined('attributes.company') and len(attributes.company)>
                AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
            </cfif>
            <cfif isDefined('attributes.finishdate') and len(attributes.finishdate)>
                AND PM.ACTION_DATE <= #attributes.finishdate#
            </cfif>
            <cfif isDefined("attributes.keyword") AND len(attributes.keyword)>
                AND PM.PRO_MATERIAL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
            </cfif>
            <cfif isdefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
                AND PM.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
            </cfif>
            <cfif isdefined('attributes.work_id') and len(attributes.work_id) and isdefined('attributes.work_head') and len(attributes.work_head)>
                AND PM.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">	
            </cfif>
     ),
         CTE2 AS (
                SELECT
                    CTE1.*,
                    ROW_NUMBER() OVER (ORDER BY
										<cfif isdefined("attributes.order_by_date") and attributes.order_by_date eq 1>
                                            RECORD_DATE DESC,
                                        <cfelseif isdefined("attributes.order_by_date") and attributes.order_by_date eq 2>
                                            RECORD_DATE,
                                        <cfelseif isdefined("attributes.order_by_date") and attributes.order_by_date eq 3>
                                            PRODUCT_NAME DESC,
                                        <cfelseif isdefined("attributes.order_by_date") and attributes.order_by_date eq 4>
                                            PRODUCT_NAME,
                                        </cfif>
                                        PRO_MATERIAL_ID,
                                        ACTION_ROW_ID
                     ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
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
