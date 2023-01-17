<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
	<cfinclude template="/member/query/get_ims_control.cfm">
</cfif>

<cfquery name="GET_SERVICE" datasource="#DSN3#">
	WITH CTE1 AS (
    SELECT
		SERVICE.SERVICE_ID,
		SERVICE.SERVICE_COMPANY_ID,
		SERVICE.SERVICE_PARTNER_ID,
		SERVICE.SERVICE_CONSUMER_ID,
		SERVICE.SERVICE_EMPLOYEE_ID,
		SERVICE.SERVICE_NO,
		SERVICE.DOC_NO,
		SERVICE.APPLY_DATE,
		SERVICE.SERVICE_HEAD,
		SERVICE.APPLICATOR_NAME,
		SERVICE.APPLICATOR_COMP_NAME,
		SERVICE.SERVICE_PRODUCT_ID,
		SERVICE.PRODUCT_NAME,
		SERVICE.PRO_SERIAL_NO,
		SERVICE.RECORD_MEMBER,
		SERVICE.RECORD_PAR,
		SERVICE.SERVICE_BRANCH_ID,
		SERVICE.SUBSCRIPTION_ID,
		SERVICE.SERVICE_SUBSTATUS_ID,
		SERVICE.SERVICE_CITY_ID,
		SERVICE.SERVICE_COUNTY_ID,
		SERVICE_APPCAT.SERVICECAT,
        SERVICE.INTERVENTION_DATE,
		SP.PRIORITY,
		SP.COLOR,
		PROCESS_TYPE_ROWS.STAGE,
        SERVICE.PROJECT_ID,
		SERVICE.START_DATE,
		SERVICE.FINISH_DATE
        ,BRANCH.BRANCH_NAME
        ,EMPLOYEES.EMPLOYEE_NAME
        ,EMPLOYEES.EMPLOYEE_SURNAME
        ,COMPANY_PARTNER.COMPANY_PARTNER_NAME
        ,COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
        ,SERVICE_SUBSTATUS.SERVICE_SUBSTATUS
        ,PRO_PROJECTS.PROJECT_HEAD
        ,SETUP_CITY.CITY_NAME
        ,SETUP_COUNTY.COUNTY_NAME
        ,SUBSCRIPTION_CONTRACT.SUBSCRIPTION_NO
        ,SERVICE.RECORD_DATE
	FROM
		<cfif (isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)) or (isdefined("attributes.product_cat_id") and len(attributes.product_cat_id) and len(attributes.product_cat))>
			PRODUCT WITH (NOLOCK),
		</cfif>
		SERVICE WITH (NOLOCK)
	LEFT JOIN
    	#DSN_ALIAS#.BRANCH
	ON
    	BRANCH.BRANCH_ID  =SERVICE.SERVICE_BRANCH_ID      
    LEFT JOIN
    	#DSN_ALIAS#.EMPLOYEES
    ON
    	EMPLOYEES.EMPLOYEE_ID = SERVICE.RECORD_MEMBER
    LEFT JOIN
    	#DSN_ALIAS#.COMPANY_PARTNER
    ON
    	COMPANY_PARTNER.PARTNER_ID = SERVICE.RECORD_PAR   
    LEFT JOIN
    	#DSN3_ALIAS#.SERVICE_SUBSTATUS
    ON
    	SERVICE_SUBSTATUS.SERVICE_SUBSTATUS_ID = SERVICE.SERVICE_SUBSTATUS_ID        
    LEFT JOIN
    	#DSN_ALIAS#.PRO_PROJECTS 
    ON
    	PRO_PROJECTS.PROJECT_ID = SERVICE.PROJECT_ID
    LEFT JOIN
    	#DSN_ALIAS#.SETUP_CITY
    ON
    	SETUP_CITY.CITY_ID  =  SERVICE.SERVICE_CITY_ID
    LEFT JOIN
    	#DSN_ALIAS#.SETUP_COUNTY
    ON
    	SETUP_COUNTY.COUNTY_ID = SERVICE.SERVICE_COUNTY_ID         	                   
		
	LEFT JOIN SUBSCRIPTION_CONTRACT ON SUBSCRIPTION_CONTRACT.SUBSCRIPTION_ID = SERVICE.SUBSCRIPTION_ID  
        <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
           AND SUBSCRIPTION_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>
        , 
		SERVICE_APPCAT WITH (NOLOCK),
		#dsn_alias#.SETUP_PRIORITY AS SP WITH (NOLOCK),
		#dsn_alias#.PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS WITH (NOLOCK)
	WHERE 		
		SERVICE.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID
		AND SP.PRIORITY_ID = SERVICE.PRIORITY_ID
		AND SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
			AND
			(	SERVICE_BRANCH_ID IS NULL
				<cfif len(branch_list)>
					OR SERVICE_BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#valuelist(get_branch.branch_id)#">)
				</cfif>
			)
		<cfif isdefined("attributes.service_branch_id") and len(attributes.service_branch_id)>
			AND SERVICE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_branch_id#">
		</cfif>
		<cfif isdefined('x_related_company_team') and x_related_company_team eq 1>
			AND SERVICE.RELATED_COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND COMPANY_ID IS NOT NULL)
		</cfif>				
		<cfif len(attributes.task_employee_id) and len(attributes.task_person_name)>
			AND SERVICE.SERVICE_ID IN (	SELECT
											PW.SERVICE_ID
										FROM
											#dsn_alias#.PRO_WORKS PW
										WHERE
											PW.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_employee_id#"> AND
											PW.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
									 )
		</cfif>
		<cfif isdefined("attributes.service_product_id") and len(attributes.service_product_id)>
			AND SERVICE.SERVICE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_product_id#">
		</cfif>
		<cfif isDefined("attributes.servicecat_id") and len(attributes.servicecat_id)>
			AND SERVICE.SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.servicecat_id#">
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			AND SERVICE.APPLY_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEDIFF("d",1,attributes.start_date)#">
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			AND SERVICE.APPLY_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.finish_date)#">
		</cfif>
		<cfif isdefined("attributes.start_date1") and len(attributes.start_date1)>
			AND SERVICE.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date1#">
		</cfif>
		<cfif isdefined("attributes.finish_date1") and len(attributes.finish_date1)>
			AND SERVICE.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.finish_date1)#">
		</cfif>
		<cfif isdefined("attributes.start_date2") and len(attributes.start_date2)>
			AND SERVICE.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date2#">
		</cfif>
		<cfif isdefined("attributes.finish_date2") and len(attributes.finish_date2)>
			AND SERVICE.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.finish_date2)#">
		</cfif>
		<cfif isdefined("attributes.service_code") and len(attributes.service_code) and isdefined("attributes.service_code_id") and len(attributes.service_code_id)>
			AND SERVICE.SERVICE_ID IN (SELECT SERVICE_ID FROM SERVICE_CODE_ROWS WHERE SERVICE_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_code_id#">)
		</cfif>
        
		<cfif isdefined("attributes.keyword_detail") and len(attributes.keyword_detail)>
            AND  SERVICE.SERVICE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_detail#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
        </cfif>
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
             AND SERVICE.SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
        </cfif>
        <cfif isdefined("attributes.keyword_no") and len(attributes.keyword_no)>
         	AND   SERVICE.SERVICE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword_no#%"> 
        </cfif> 
        
		<cfif isdefined("attributes.serial_no") and len(attributes.serial_no)>
			AND SERVICE.PRO_SERIAL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.serial_no#%">
		</cfif>
		<cfif isdefined("attributes.doc_number") and len(attributes.doc_number)>
			AND SERVICE.DOC_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.doc_number#%">
		</cfif>
		<cfif isdefined("attributes.product") and len(attributes.product) and isDefined("attributes.product_id") and len(attributes.product_id)>
			AND SERVICE.SERVICE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
		</cfif>
		<cfif isdefined("attributes.made_application") and len(attributes.made_application)>
			AND (
					<cfif isdefined("attributes.partner_id_") and len(attributes.partner_id_)>
						SERVICE.SERVICE_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id_#">
					<cfelseif isdefined("attributes.consumer_id_") and len(attributes.consumer_id_)>
						SERVICE.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id_#">
					<cfelse>
						(APPLICATOR_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.made_application#%">
						OR APPLICATOR_COMP_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.made_application#%">)
					</cfif>
				)
		</cfif>	
		<cfif isdefined("attributes.service_status") and ListFind("0,1",attributes.service_status)>
			AND SERVICE.SERVICE_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.service_status#">
		</cfif>
		<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
			AND SERVICE.SERVICE_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
		</cfif>
		<cfif isdefined("attributes.priority") and len(attributes.priority)>
			AND SERVICE.PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.priority#">
		</cfif>
		<cfif isdefined("attributes.adress_keyword") and len(attributes.adress_keyword)>
			AND SERVICE_ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.adress_keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>
		<!--- BU BOLUM MYHOME DAN VE UYEDEN DIREK ULASIM ICIN KONULMUSTUR --->
		<cfif isDefined("attributes.ismyhome") and isdefined("attributes.company_id") and len(attributes.company_id)>
			AND SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif isDefined("attributes.ismyhome") and isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			AND SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfif>
		<!--- //BU BOLUM MYHOME DAN VE UYEDEN DIREK ULASIM ICIN KONULMUSTUR --->		
			
		<!--- Bu bölüm service update sayfasindan basvuru yapanin diger servis basvurularina direk erisim için konulmustur--->
		<cfif isdefined('other_service_app') and isdefined('attributes.partner_id') and len(attributes.partner_id)>
			AND SERVICE_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
			AND SERVICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
		</cfif>
		<cfif isdefined("attributes.service_id") and len(attributes.service_id)>
			AND SERVICE_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#" list="yes">)
		</cfif>
		<cfif isdefined('other_service_app') and isdefined('attributes.employee_id') and len(attributes.employee_id)>
			AND SERVICE_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
			AND SERVICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
		</cfif>
		<cfif isdefined('other_service_app') and isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
			AND SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			AND SERVICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
		</cfif>
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isDefined("attributes.subscription_no") and len(attributes.subscription_no)>
			AND SERVICE.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
		</cfif>
		<cfif isdefined("attributes.service_add_option") and len(attributes.service_add_option)> 
			AND SERVICE.SALE_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_add_option#">
		</cfif>
		<cfif isdefined("attributes.related_company_id") and len(attributes.related_company_id) and isDefined("attributes.related_company") and len(attributes.related_company)> 
			AND SERVICE.RELATED_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_company_id#">
		</cfif>
		<cfif isdefined("attributes.other_company_id") and Len(attributes.other_company_id) and isDefined("attributes.other_company_name") and len(attributes.other_company_name)> 
			AND SERVICE.OTHER_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.other_company_id#">
		</cfif>
		<!--- //Bu bölüm service update sayfasindan basvuru yapanin diger servis basvurularina direk erisim için konulmustur--->
		
		<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.member_name") and len(attributes.member_name)> 
			AND SERVICE.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.member_name") and len(attributes.member_name)> 
			AND SERVICE.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfif>
		<cfif isdefined("attributes.service_substatus_id") and len(attributes.service_substatus_id)> 
			AND SERVICE.SERVICE_SUBSTATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_substatus_id#">
		</cfif>
		<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and isDefined("attributes.brand_name") and len(attributes.brand_name)> 
			AND SERVICE.SERVICE_PRODUCT_ID = PRODUCT.PRODUCT_ID 
			AND PRODUCT.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
		</cfif>
		<cfif isdefined("attributes.product_cat_id") and len(attributes.product_cat_id) and isDefined("attributes.product_cat") and len(attributes.product_cat)> 
			AND SERVICE.SERVICE_PRODUCT_ID = PRODUCT.PRODUCT_ID 
			AND PRODUCT.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.product_code#%">
		<!---	AND PRODUCT.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_cat_id#"> --->
		</cfif>
		<cfif isdefined("attributes.service_county_id") and len(attributes.service_county_id) and isDefined("attributes.service_county_name") and len(attributes.service_county_name)>
			AND SERVICE.SERVICE_COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_county_id#">
		</cfif>
		<cfif isdefined("attributes.service_city_id") and len(attributes.service_city_id)>
			AND SERVICE.SERVICE_CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_city_id#">
		</cfif>
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
			AND SERVICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>  
		<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id) and len(attributes.record_emp_name)>
			AND SERVICE.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#">
		</cfif>
		<cfif isdefined("attributes.accessory") and len(attributes.accessory)>
			AND SERVICE.ACCESSORY_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.accessory#%">
		</cfif>
		<cfif isdefined("attributes.accessory_select") and len(attributes.accessory_select)>
			AND SERVICE.ACCESSORY_DETAIL_SELECT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.accessory_select#" list="yes">)
		</cfif>        
		<cfif isdefined("attributes.physical") and len(attributes.physical)>
			AND SERVICE.INSIDE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.physical#%">
		</cfif> 
        <cfif isdefined("attributes.physical_select") and len(attributes.physical_select)>
			AND SERVICE.INSIDE_DETAIL_SELECT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.physical_select#" list="yes">)
		</cfif>
		<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
			AND
				(
					( SERVICE.SERVICE_CONSUMER_ID IS NULL AND SERVICE.SERVICE_COMPANY_ID IS NULL ) OR
					( SERVICE.SERVICE_COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#) ) OR
					( SERVICE.SERVICE_CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#) )
				)
		</cfif>
       ),
       
       CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (	ORDER BY RECORD_DATE DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
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
