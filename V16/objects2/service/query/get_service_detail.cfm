<cfquery name="GET_SERVICE_DETAIL" datasource="#DSN3#">
	SELECT 
		S.SERVICE_ID,
        S.SERVICE_HEAD,
        S.SERVICE_PARTNER_ID,
        S.SERVICE_CONSUMER_ID,
        S.SERVICE_EMPLOYEE_ID,
        S.SERVICE_COMPANY_ID,
        S.SERVICE_STATUS_ID,
       	S.SERVICE_NO,
        S.SERVICE_SUBSTATUS_ID,
        S.SERVICE_ADDRESS,
        S.SERVICE_CITY_ID,
        S.SERVICE_CITY,
        S.SERVICE_COUNTY_ID,
        S.SERVICE_COUNTY,
        S.SERVICE_DETAIL,     
        S.SERVICECAT_ID,
        S.SERVICECAT_SUB_ID,
        S.SERVICECAT_SUB_STATUS_ID,
        S.GUARANTY_START_DATE,
        S.GUARANTY_PAGE_NO,
        S.APPLICATOR_NAME, 
        S.APPLICATOR_COMP_NAME,
        S.LOCATION_ID,
        S.STOCK_ID,
        S.PRO_SERIAL_NO,
        S.RELATED_COMPANY_ID,
        S.OTHER_COMPANY_BRANCH_ID,
        S.OTHER_COMPANY_ID,
        S.IS_SALARIED,
        S.COMMETHOD_ID,
        S.PRODUCT_NAME,
        S.MAIN_SERIAL_NO,
        S.APPLY_DATE,
        S.START_DATE,
        S.FINISH_DATE,
        S.BRING_NAME,
        S.BRING_TEL_NO,
        S.BRING_MOBILE_NO,
        S.BRING_SHIP_METHOD_ID,
        S.SHIP_METHOD,
        S.BRING_DETAIL,
        S.DOC_NO,
        S.SUBSCRIPTION_ID,
        S.PROJECT_ID,
        S.SERVICE_PRODUCT_ID,
        S.SALE_ADD_OPTION_ID,
        S.PRIORITY_ID,
        S.SERVICE_BRANCH_ID,
        S.ACCESSORY_DETAIL_SELECT,
        S.INSIDE_DETAIL_SELECT,
        S.BRING_NAME,
        S.BRING_EMAIL,
        S.RECORD_MEMBER,
        S.RECORD_PAR,
        S.RECORD_CONS,
        S.RECORD_DATE,
        S.UPDATE_MEMBER,
        S.UPDATE_PAR,
        S.UPDATE_CONS,
        S.UPDATE_DATE,
        SA.SERVICECAT  
	FROM
		#dsn3_alias#.SERVICE S,
		#dsn3_alias#.SERVICE_APPCAT SA
	WHERE 
    	S.SERVICECAT_ID = SA.SERVICECAT_ID AND
		S.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> AND
	    (
            S.SERVICE_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">) OR
            S.RELATED_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
            S.OTHER_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
			<cfif isdefined("session.pp.company_id")>
                S.RELATED_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
                S.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">OR
                S.SERVICE_ID IN (SELECT SERVICE_ID FROM #dsn_alias#.PRO_WORKS WHERE OUTSRC_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND SERVICE_ID IS NOT NULL AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">) OR
                S.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
            <cfelse>
                S.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
            </cfif>
		)
</cfquery>
