<cfif isdefined("attributes.start_date1") and len(attributes.start_date1)>
	<cf_date tarih="attributes.start_date1">
	<cfset attributes.s_date_1 = attributes.start_date1>
</cfif>
<cfif isdefined("attributes.finish_date1") and len(attributes.finish_date1)>
	<cf_date tarih="attributes.finish_date1">
	<cfset attributes.f_date_1 = dateadd('d',1,attributes.finish_date1)>
</cfif>
<cfif session.ep.our_company_info.sales_zone_followup eq 1>
	<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
		SELECT DISTINCT SZ_HIERARCHY FROM SALES_ZONES_ALL_1 WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	</cfquery>
	<cfset row_block = 500>
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
	<cfset fin_date = dateadd('d',1,attributes.finish_date)>
</cfif>
<cfif isDefined('attributes.workgroup_id') And len(attributes.workgroup_id)>
	<cfquery name="get_workgroup" datasource="#dsn#">
		SELECT EMPLOYEE_ID, PARTNER_ID, CONSUMER_ID FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = #attributes.workgroup_id#
	</cfquery>
</cfif>
<cfquery name="GET_SERVICE" datasource="#dsn#">
	WITH CTE1 AS (
    SELECT
		SERVICE.SERVICE_ID,
		SERVICE.ISREAD,
		SERVICE.SERVICE_COMPANY_ID,
		SERVICE.APPLICATOR_NAME,
		SERVICE.SERVICE_PARTNER_ID,
		SERVICE.SERVICE_CONSUMER_ID,
		SERVICE.SERVICE_EMPLOYEE_ID,
		SERVICE.SERVICE_STATUS_ID,
		SERVICE.SERVICE_NO,
		SERVICE.APPLY_DATE,
		SERVICE.RESP_EMP_ID,
		SERVICE.RESP_PAR_ID,
		SERVICE.RESP_CONS_ID,
		SERVICE.SERVICE_HEAD,
		SERVICE.SERVICE_DETAIL,
		SERVICE.RECORD_MEMBER,
		SERVICE.RECORD_PAR,
		SERVICE.RECORD_CONS,
		SERVICE.SERVICE_BRANCH_ID,
		SERVICE.COMMETHOD_ID,
		SERVICE_APPCAT.SERVICECAT,
        SERVICE.SUBSCRIPTION_ID,
        SP.PRIORITY,
        SERVICE.RECORD_DATE,
		SP.COLOR,
			ISNULL(ISNULL(E.DIRECT_TELCODE+' '+E.DIRECT_TEL,CP.COMPANY_PARTNER_TELCODE+' '+CP.COMPANY_PARTNER_TEL),C.CONSUMER_HOMETELCODE+' '+C.CONSUMER_HOMETEL) TELNO,
			ISNULL(ISNULL(E.MOBILCODE+' '+E.MOBILTEL, CP.MOBIL_CODE+' '+CP.MOBILTEL),C.MOBIL_CODE+' '+C.MOBILTEL) MOBIL_TEL,
        	PP.PROJECT_HEAD,
		PROCESS_TYPE_ROWS.STAGE
	FROM
		<cfif (isdefined("attributes.city") and len(attributes.city) and isdefined("attributes.city_id") and len(attributes.city_id)) or (isdefined("attributes.county") and isdefined("attributes.county_id") and len(attributes.county_id))>
			SETUP_CITY SETUP_CITY,
		</cfif>
		<cfif (isdefined("attributes.county") and len(attributes.county) and isdefined("attributes.county_id") AND len(attributes.county_id))>
			SETUP_COUNTY SETUP_COUNTY,
		</cfif>
		<cfif (isdefined("attributes.city") and len(attributes.city) and isdefined("attributes.city_id") and len(attributes.city_id)) or (isdefined("attributes.county") and len(attributes.county) and isdefined("attributes.county_id") AND len(attributes.county_id)) or (isdefined("attributes.vergi_no") and len(attributes.vergi_no))>
			COMPANY COMPANY,
		</cfif>	
		G_SERVICE SERVICE WITH (NOLOCK)
        <!--- xml bağlı olarak kişinin sahşi telefonları için konulmuştur. ---->
            LEFT JOIN EMPLOYEES E ON SERVICE.SERVICE_EMPLOYEE_ID=E.EMPLOYEE_ID
            LEFT JOIN CONSUMER C ON SERVICE.SERVICE_CONSUMER_ID=C.CONSUMER_ID
            LEFT JOIN COMPANY_PARTNER CP ON SERVICE.SERVICE_PARTNER_ID=CP.PARTNER_ID
        	LEFT JOIN #dsn_alias#.PRO_PROJECTS PP  ON PP.PROJECT_ID=SERVICE.PROJECT_ID,
 		G_SERVICE_APPCAT SERVICE_APPCAT,
		SETUP_PRIORITY SP,
		PROCESS_TYPE_ROWS PROCESS_TYPE_ROWS
	WHERE
    	<cfif xml_is_our_company eq 1>
        	(SERVICE.OUR_COMPANY_ID = #session.ep.company_id# OR SERVICE.OUR_COMPANY_ID IS NULL) AND
        </cfif>
		(
		SERVICE_BRANCH_ID IS NULL
		<cfif listlen(branch_id_list)>
			OR SERVICE_BRANCH_ID IN (#branch_id_list#)
		</cfif>
		) AND
		<cfif isdefined("attributes.commethod_id") and len(attributes.commethod_id)>
			SERVICE.COMMETHOD_ID = #attributes.commethod_id# AND
		</cfif>
		<cfif isdefined("attributes.service_product_id") and len(attributes.service_product_id) and isdefined("attributes.service_product") and len(attributes.service_product)>
			SERVICE.SERVICE_PRODUCT_ID = #attributes.service_product_id# AND
		</cfif>
        <cfif len(attributes.project_id) and len(attributes.project_head)>
        	SERVICE.PROJECT_ID=#attributes.project_id# AND
        </cfif>
		<cfif isDefined("attributes.category") and len(attributes.category)>
			SERVICE.SERVICECAT_ID = #attributes.category# AND
		</cfif>
		<cfif isDefined("attributes.priority_cat") and len(attributes.priority_cat)>
			SERVICE.PRIORITY_ID = #attributes.priority_cat# AND
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			SERVICE.APPLY_DATE >= #attributes.start_date# AND
		</cfif>
		<cfif isdefined("fin_date") and len(fin_date)>
			SERVICE.APPLY_DATE <= #fin_date# AND
		</cfif>
		<cfif isdefined("attributes.s_date_1") and len(attributes.s_date_1)>
			SERVICE.START_DATE >= #attributes.s_date_1# AND
		</cfif>
		<cfif isdefined("attributes.f_date_1") and len(attributes.f_date_1)>
			SERVICE.START_DATE < #attributes.f_date_1# AND
		</cfif>
		<cfif isdefined("attributes.service_code") and len(attributes.service_code)>
			SERVICE.SERVICE_DEFECT_CODE = #attributes.service_code# AND
		</cfif>
		
		<cfif len(attributes.keyword_detail) >
             SERVICE.SERVICE_DETAIL LIKE '%#attributes.keyword_detail#%' COLLATE SQL_Latin1_General_CP1_CI_AI AND
        </cfif>
        <cfif len(attributes.keyword_subject)>
            	SERVICE.SERVICE_HEAD LIKE '%#attributes.keyword_subject#%' COLLATE SQL_Latin1_General_CP1_CI_AI AND
        </cfif>
        <cfif len(attributes.keyword)>
            	SERVICE.SERVICE_NO LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI AND
        </cfif>
        
		<cfif isdefined("attributes.product") and len(attributes.product) and len(attributes.product_id)>
			SERVICE.SERVICE_PRODUCT_ID = #attributes.product_id# AND
		</cfif>
		<cfif isdefined("attributes.service_branch_id") and len(attributes.service_branch_id)>
			SERVICE_BRANCH_ID = #attributes.service_branch_id# AND
		</cfif>
		<cfif isdefined("attributes.made_application") and len(attributes.made_application)>
			(
				APPLICATOR_NAME LIKE '%#attributes.made_application#%'
				<cfif isdefined("attributes.partner_id_") and len(attributes.partner_id_)>
					OR SERVICE.SERVICE_PARTNER_ID = #attributes.partner_id_#
				</cfif>
				<cfif isdefined("attributes.consumer_id_") and len(attributes.consumer_id_)>
					OR SERVICE.SERVICE_CONSUMER_ID = #attributes.consumer_id_#
				</cfif>
			) AND
		</cfif>
		<cfif isdefined("attributes.notify_app_name") and len(attributes.notify_app_name)>
			<cfif isdefined("attributes.notify_emp_id") and len(attributes.notify_emp_id)>
				SERVICE.NOTIFY_EMPLOYEE_ID =#attributes.notify_emp_id# AND
			<cfelseif isdefined("attributes.notify_par_id") and len(attributes.notify_par_id)>
				SERVICE.NOTIFY_PARTNER_ID = #attributes.notify_par_id# AND
			<cfelseif isdefined("attributes.notify_con_id") and len(attributes.notify_con_id)>
				SERVICE.NOTIFY_CONSUMER_ID = #attributes.notify_con_id# AND
			</cfif>
		</cfif>
		<cfif isdefined("attributes.task_person_name") and len(attributes.task_person_name)>
			<cfif len(attributes.task_emp_id)>
				SERVICE.SERVICE_ID IN (SELECT G_SERVICE_ID FROM PRO_WORKS WHERE PROJECT_EMP_ID = #attributes.task_emp_id# AND G_SERVICE_ID = SERVICE.SERVICE_ID) AND
			<cfelseif len(attributes.task_par_id)>
				SERVICE.SERVICE_ID IN (SELECT G_SERVICE_ID FROM PRO_WORKS WHERE OUTSRC_PARTNER_ID = #attributes.task_par_id# AND G_SERVICE_ID = SERVICE.SERVICE_ID) AND
			</cfif>
		</cfif>
		<cfif isdefined("attributes.service_status") and len(attributes.service_status)>
			SERVICE.SERVICE_ACTIVE = #attributes.service_status# AND
		</cfif>
		<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
			SERVICE.SERVICE_STATUS_ID = #attributes.process_stage# AND
		</cfif>
		<!--- BU BÖLÜM MYHOME DAN VE ÜYEDEN DİREK ULAŞIM İÇİN KONULMUŞTUR --->
		<cfif isDefined("attributes.ismyhome") and isdefined("attributes.company_id") and len(attributes.company_id)>
			SERVICE_PARTNER_ID IN (SELECT PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID = #attributes.company_id#)  AND
		</cfif>
		<cfif isDefined("attributes.ismyhome") and isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			SERVICE_CONSUMER_ID = #attributes.consumer_id# AND
		</cfif>
		<!--- //BU BÖLÜM MYHOME DAN VE ÜYEDEN DİREK ULAŞIM İÇİN KONULMUŞTUR --->		
		
		<!--- Bu bölüm service update sayfasından başvuru yapanın diğer servis başvurularına direk erişim için konulmuştur--->
		<cfif isdefined('other_service_app') and isdefined("attributes.service_id") and len(attributes.service_id)>
			SERVICE_ID <> #attributes.service_id# AND
			<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
				SERVICE_PARTNER_ID = #attributes.partner_id# AND
			<cfelseif isdefined('attributes.employee_id') and len(attributes.employee_id)>
				SERVICE_EMPLOYEE_ID = #attributes.employee_id# AND
			<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
				SERVICE_CONSUMER_ID = #attributes.consumer_id# AND
			</cfif>
		</cfif>
		<cfif isdefined("attributes.service_id") and len(attributes.service_id)>
			SERVICE_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#" list="yes">) AND
		</cfif>
		<!--- Kategori tanımlysa o kategorideki service_id leri buluyor ona göre filtreliyor --->
		<cfif isdefined("attributes.service_cat") and len(attributes.service_cat) and (len(attributes.service_cat_id) or len(attributes.service_sub_cat_id) or len(attributes.service_sub_status_id))>
			SERVICE.SERVICE_ID IN (SELECT 
										SERVICE_ID 
									FROM 
										G_SERVICE_APP_ROWS 
									WHERE 
										SERVICE_ID IS NOT NULL 
										<cfif isdefined("attributes.service_cat_id") and len(attributes.service_cat_id)>
											AND SERVICECAT_ID = #attributes.service_cat_id#
										</cfif>
										<cfif isdefined("attributes.service_sub_cat_id") and len(attributes.service_sub_cat_id)>
											AND SERVICE_SUB_CAT_ID = #attributes.service_sub_cat_id#
										</cfif>
										<cfif isdefined("attributes.service_sub_status_id") and len(attributes.service_sub_status_id)>
											AND SERVICE_SUB_STATUS_ID = #attributes.service_sub_status_id#
										</cfif>
									) AND
		</cfif>
		<!--- Başvurunun kategorisine göre filtreliyor --->
		<cfif isdefined("attributes.appcat_id") and len(attributes.appcat_id)>
			SERVICE.SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.appcat_id#"> AND			
		</cfif>
		<cfif (isdefined("attributes.city") and len(attributes.city) and isdefined("attributes.city_id") and len(attributes.city_id)) or (isdefined("attributes.county") and len(attributes.county) and isdefined("attributes.county_id") and len(attributes.county_id))>
			COMPANY.COMPANY_ID = SERVICE.SERVICE_COMPANY_ID AND 
			<cfif isdefined("attributes.city") and len(attributes.city) and isdefined("attributes.city_id") and len(attributes.city_id)>
				SETUP_CITY.CITY_ID = #attributes.city_id# AND
				SETUP_CITY.CITY_ID = COMPANY.CITY AND
			</cfif>
			<cfif isdefined("attributes.county") and len(attributes.county) and isdefined("attributes.county_id") and len(attributes.county_id)>
				SETUP_COUNTY.COUNTY_ID = #attributes.county_id# AND
				SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY AND
			</cfif>
		</cfif>
		<cfif isdefined("attributes.vergi_no") and len(attributes.vergi_no)>
			COMPANY.COMPANY_ID = SERVICE.SERVICE_COMPANY_ID AND
			COMPANY.TAXNO ='#attributes.vergi_no#' AND
		</cfif>
		SERVICE.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID AND
		SP.PRIORITY_ID = SERVICE.PRIORITY_ID AND
		SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
        <cfif isDefined('get_process_types') and get_process_types.recordcount>
			AND PROCESS_TYPE_ROWS.PROCESS_ROW_ID IN (#ValueList(get_process_types.process_row_id)#)
		<cfelseif isDefined('x_show_authorized_stage') and x_show_authorized_stage eq 1>
			AND 1 = 0
		</cfif>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)> 
			AND SERVICE.SERVICE_COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif isdefined("attributes.resp_emp_id") and len(attributes.resp_emp_id) and isdefined("attributes.resp_emp_name") and len(attributes.resp_emp_name)> 
			AND SERVICE.RESP_EMP_ID = #attributes.resp_emp_id#
		</cfif>
		<cfif isDefined('attributes.workgroup_id') And len(attributes.workgroup_id) And get_workgroup.recordCount And (ListLen(valueList(get_workgroup.EMPLOYEE_ID)) OR ListLen(valueList(get_workgroup.PARTNER_ID)) OR valueList(get_workgroup.CONSUMER_ID))>
			<cfif ListLen(valueList(get_workgroup.EMPLOYEE_ID))>AND RESP_EMP_ID IN(#listRemoveDuplicates(valueList(get_workgroup.EMPLOYEE_ID))#)</cfif>
			<cfif ListLen(valueList(get_workgroup.PARTNER_ID))>AND RESP_PAR_ID IN(#listRemoveDuplicates(valueList(get_workgroup.PARTNER_ID))#)</cfif>
			<cfif ListLen(valueList(get_workgroup.CONSUMER_ID))>AND RESP_CONS_ID IN(#listRemoveDuplicates(valueList(get_workgroup.CONSUMER_ID))#)</cfif>
		</cfif>
        <cfif isdefined("attributes.resp_par_id") and len(attributes.resp_par_id) and isdefined("attributes.resp_emp_name") and len(attributes.resp_emp_name)> 
			AND (SERVICE.RESP_PAR_ID = #attributes.resp_par_id# OR
            	SERVICE.RESP_COMP_ID = #attributes.resp_comp_id#
            )
		</cfif>
        <cfif isdefined("attributes.resp_cons_id") and len(attributes.resp_cons_id) and isdefined("attributes.resp_emp_name") and len(attributes.resp_emp_name)> 
			AND SERVICE.RESP_CONS_ID = #attributes.resp_cons_id#
		</cfif>
		<cfif isDefined('attributes.recorder_name') and len(attributes.recorder_name) and isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)>
			AND SERVICE.RECORD_MEMBER = #attributes.record_emp_id#
		<cfelseif isDefined('attributes.recorder_name') and len(attributes.recorder_name) and isdefined("attributes.record_par_id") and len(attributes.record_par_id)>
			AND SERVICE.RECORD_PAR = #attributes.record_par_id#
		<cfelseif isDefined('attributes.recorder_name') and len(attributes.recorder_name) and isdefined("attributes.record_cons_id") and len(attributes.record_cons_id)>
			AND SERVICE.RECORD_CONS = #attributes.record_cons_id#
		</cfif>
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>
        	AND SERVICE.OUR_COMPANY_ID = #session.ep.company_id#
			AND SERVICE.SUBSCRIPTION_ID = #attributes.subscription_id#
		</cfif>
        <cfif isdefined("attributes.sales_zones") and len(attributes.sales_zones)>
			AND (
				 SERVICE.SERVICE_COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY WHERE SALES_COUNTY=#attributes.sales_zones#)
          	     OR 
				 SERVICE.SERVICE_CONSUMER_ID IN (SELECT CONSUMER_ID FROM CONSUMER WHERE SALES_COUNTY=#attributes.sales_zones#)
				 )
		</cfif>
       
		<cfif session.ep.our_company_info.sales_zone_followup eq 1>
			<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
			AND
			((	
				SERVICE_COMPANY_ID IS NULL OR
				(
					SERVICE_COMPANY_ID IS NOT NULL AND
					SERVICE_COMPANY_ID IN
					(
						SELECT 
							C.COMPANY_ID
						FROM
							COMPANY C
						WHERE
							C.IMS_CODE_ID IN 
                            (
                            SELECT
                                IMS_ID
                            FROM
                                SALES_ZONES_ALL_2
                            WHERE
                                POSITION_CODE = #session.ep.position_code#
                            )
							<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
							<cfif get_hierarchies.recordcount>
                            OR C.IMS_CODE_ID IN 
                            (
                                SELECT
                                    IMS_ID
                                FROM
                                    SALES_ZONES_ALL_1
                                WHERE											
                                <cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
                                    <cfset start_row=(page_stock*row_block)+1>	
                                    <cfset end_row=start_row+(row_block-1)>
                                    <cfif (end_row) gte get_hierarchies.recordcount>
                                        <cfset end_row=get_hierarchies.recordcount>
                                    </cfif>
                                        (
                                        <cfloop index="add_stock" from="#start_row#" to="#end_row#">
                                            <cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_hierarchies.sz_hierarchy[add_stock]#%">
                                        </cfloop>
                                        
                                        )<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
                                </cfloop>											
                                )
                            </cfif>						
					)
				)
			)
			AND
			(	
				SERVICE_CONSUMER_ID IS NULL OR
				(
					SERVICE_CONSUMER_ID IS NOT NULL AND
					SERVICE_CONSUMER_ID IN
					(
						SELECT 
							C.CONSUMER_ID
						FROM
							CONSUMER C
						WHERE
							C.IMS_CODE_ID IN (
                                                SELECT
                                                    IMS_ID
                                                FROM
                                                    SALES_ZONES_ALL_2
                                                WHERE
                                                    POSITION_CODE = #session.ep.position_code#
												)
							<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
							<cfif get_hierarchies.recordcount>
								OR C.IMS_CODE_ID IN 
                                    (
                                    SELECT
                                        IMS_ID
                                    FROM
                                        SALES_ZONES_ALL_1
                                    WHERE											
                                        <cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
                                            <cfset start_row=(page_stock*row_block)+1>	
                                            <cfset end_row=start_row+(row_block-1)>
                                            <cfif (end_row) gte get_hierarchies.recordcount>
                                                <cfset end_row=get_hierarchies.recordcount>
                                            </cfif>
                                                (
                                                <cfloop index="add_stock" from="#start_row#" to="#end_row#">
                                                    <cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
                                                </cfloop>
                                                
                                                )<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
                                        </cfloop>											
                                    )
                          </cfif>						
					)
				)
			))
		</cfif>
        
        ),
        
        CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (	ORDER BY
											RECORD_DATE DESC
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