<cfquery name="GET_SERVICE" datasource="#DSN3#">
	WITH CTE1 AS(
        SELECT
            S.SERVICE_ID,
            S.SERVICE_NO,
            S.ISREAD,
            S.APPLY_DATE,
            S.PRIORITY_ID,
            S.SERVICECAT_SUB_ID,
            S.SERVICECAT_SUB_STATUS_ID,
            S.RECORD_DATE RECORD_DATE,
            S.SERVICE_PARTNER_ID,
            S.SERVICE_COMPANY_ID,
            S.SERVICE_CONSUMER_ID,
            S.SERVICE_EMPLOYEE_ID,
            S.SERVICE_SUBSTATUS_ID,
            S.PRODUCT_NAME,
            S.DOC_NO,
            S.APPLICATOR_COMP_NAME,
            S.APPLICATOR_NAME,
            S.PRO_SERIAL_NO,
            S.SERVICE_HEAD,
            S.RECORD_PAR,
            S.RECORD_MEMBER,
            SA.SERVICECAT,
            S.SUBSCRIPTION_ID,
            PTR.STAGE
        FROM
            SERVICE S,
            SERVICE_APPCAT SA,
            <cfif (isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)) or (isdefined("attributes.product_cat_id") and len(attributes.product_cat_id) and len(attributes.product_cat))>
                PRODUCT WITH (NOLOCK),
            </cfif>
            #dsn_alias#.PROCESS_TYPE_ROWS AS PTR
        WHERE
            S.SERVICE_STATUS_ID = PTR.PROCESS_ROW_ID
            <cfif isDefined("attributes.status") and attributes.status eq 0>
                AND S.SERVICE_ACTIVE = 0
            <cfelseif isDefined("attributes.status") and attributes.status eq 1>
                AND S.SERVICE_ACTIVE = 1
            </cfif>
            <cfif isdefined("session.pp.company_id")>
                <cfif isdefined('attributes.is_service_hier')>
                AND
                (
                    <cfif isdefined('attributes.is_service_hier') and (attributes.is_service_hier eq 0 or attributes.is_service_hier eq 4)>
                        S.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
                        S.SERVICE_ID IN (SELECT SERVICE_ID FROM #dsn_alias#.PRO_WORKS WHERE OUTSRC_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND SERVICE_ID IS NOT NULL AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">) OR
                        S.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
                        <cfif isdefined('attributes.is_service_hier') and attributes.is_service_hier eq 4>OR</cfif>
                    </cfif>
                    <cfif isdefined('attributes.is_service_hier') and (attributes.is_service_hier eq 2 or attributes.is_service_hier eq 4)>
                        S.RELATED_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                    </cfif>
                    <cfif isdefined('attributes.is_service_hier') and attributes.is_service_hier eq 4>OR</cfif>
                    <cfif isdefined('attributes.is_service_hier') and (attributes.is_service_hier eq 3 or attributes.is_service_hier eq 4)>
                        S.OTHER_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                    </cfif>
                    <cfif isdefined('attributes.is_service_hier') and attributes.is_service_hier eq 4>OR</cfif>
                    <cfif isdefined('attributes.is_service_hier') and (attributes.is_service_hier eq 1 or attributes.is_service_hier eq 4)>
                        S.SERVICE_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
                    </cfif>
                )
                </cfif>
            <cfelseif isDefined('session.ww.userid')>
                AND S.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
            </cfif>
            <cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
                AND S.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
            </cfif>  
            <cfif isdefined("attributes.serial_no") and len(attributes.serial_no)>
                AND SERVICE.PRO_SERIAL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.serial_no#%">
            </cfif>
            <cfif isdefined("attributes.service_code") and len(attributes.service_code) and isdefined("attributes.service_code_id") and len(attributes.service_code_id)>
                AND S.SERVICE_ID IN (SELECT SERVICE_ID FROM SERVICE_CODE_ROWS WHERE SERVICE_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_code_id#">)
            </cfif>
            <cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and isDefined("attributes.brand_name") and len(attributes.brand_name)> 
                AND S.SERVICE_PRODUCT_ID = PRODUCT.PRODUCT_ID 
                AND PRODUCT.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
            </cfif>
            <cfif isdefined("attributes.product_cat_id") and len(attributes.product_cat_id) and isDefined("attributes.product_cat") and len(attributes.product_cat)> 
                AND S.SERVICE_PRODUCT_ID = PRODUCT.PRODUCT_ID 
                AND PRODUCT.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_cat_id#">
            </cfif>
            <cfif isdefined("attributes.product") and len(attributes.product) and isDefined("attributes.product_id") and len(attributes.product_id)>
                AND S.SERVICE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
            </cfif>
            AND SA.SERVICECAT_ID = S.SERVICECAT_ID
            <cfif isDefined("attributes.category") and len(attributes.category)>
                AND S.SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.category#">
            </cfif>
            <cfif isDefined("attributes.appcat_sub_id") and len(attributes.appcat_sub_id)>
                AND S.SERVICECAT_SUB_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.appcat_sub_id#">
            </cfif>
            <cfif isDefined("attributes.appcat_sub_status_id") and len(attributes.appcat_sub_status_id)>
                AND S.SERVICECAT_SUB_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.appcat_sub_status_id#">
            </cfif>
			<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id) and len(attributes.record_emp_name)>
                AND S.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#">
            </cfif>
            <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                AND
                (
                    S.SERVICE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                    S.SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                    S.SERVICE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                )
            </cfif>
            <cfif isdefined('attributes.company_id') and len(attributes.company_id) and isdefined('attributes.company_name') and len(attributes.company_name)>
                 AND S.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
            </cfif>
            <cfif isDefined("attributes.sub_status") and len(attributes.sub_status)>
                AND S.SERVICE_SUBSTATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sub_status#">
            </cfif>
            <cfif isDefined("attributes.subscription_id") and len(attributes.subscription_id) and isDefined("attributes.subscription_no") and len(attributes.subscription_no)>
                AND S.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
            </cfif>
            <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
                AND S.SERVICE_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
            </cfif>
 		),
        CTE2 AS 
            (
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
