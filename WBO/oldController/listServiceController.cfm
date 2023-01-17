<!--- tekrarlanan yerler düzenlenmeli detaylı incele smh 07052016--->
<cf_get_lang_set module_name="call">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_xml_page_edit fuseact="call.list_service">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.keyword_subject" default="">
    <cfparam name="attributes.keyword_detail" default="">
    <cfparam name="attributes.recorder_id" default="">
    <cfparam name="attributes.recorder_name" default="">
    <cfparam name="attributes.task_person_name" default="">
    <cfparam name="attributes.resp_emp_name" default="">
    <cfparam name="attributes.resp_emp_id" default="">
    <cfparam name="attributes.resp_par_id" default="">
    <cfparam name="attributes.resp_comp_id" default="">
    <cfparam name="attributes.resp_cons_id" default="">
    <cfparam name="attributes.priority_cat" default="">
    <cfparam name="attributes.task_emp_id" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.city_id" default="">
    <cfparam name="attributes.city" default="">
    <cfparam name="attributes.county_id" default="">
    <cfparam name="attributes.county" default="">
    <cfif isdefined("attributes.service_status")>
        <cfparam name="attributes.service_status" default="">
    <cfelse>
        <cfparam name="attributes.service_status" default="1">
    </cfif>
    <cfparam name="attributes.task_position_code" default="">
    <cfparam name="attributes.task_cmp_id" default="">
    <cfparam name="attributes.ComMethod_Id" default="">
    
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined("session.service_reply")>
        <cfscript>structdelete(session,"service_reply");</cfscript>
    </cfif>
    <cfif isdefined("session.service_task")>
        <cfscript>structdelete(session,"service_task");</cfscript>
    </cfif>
    
    <cfif isdefined("attributes.start_date") and len(attributes.start_date) and isDate(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfparam name="attributes.start_date" default="">
        <cfelse>	
            <cfparam name="attributes.start_date" default="#date_add('d',-7,wrk_get_today())#">
        </cfif>
    </cfif>
    
    <cfif isdefined("attributes.finish_date") and len(attributes.finish_date) and isDate(attributes.finish_date)>
        <cfparam name="attributes.finish_date" default="#attributes.finish_date#">
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfparam name="attributes.finish_date" default="">
        <cfelse>	
            <cfparam name="attributes.finish_date" default="#now()#">
        </cfif>
    </cfif>    
    <cfif isdefined("attributes.start_date1")>
        <cfparam name="attributes.start_date1" default="#attributes.start_date1#">
    <cfelse>
        <cfparam name="attributes.start_date1" default="">
    </cfif>
    
    <cfif isdefined("attributes.finish_date1")>
        <cfparam name="attributes.finish_date1" default="#attributes.finish_date1#">
    <cfelse>
        <cfparam name="attributes.finish_date1" default="">
    </cfif>
    
    <cfif isDefined('x_show_authorized_stage') and x_show_authorized_stage eq 1>
        <cf_workcube_process_info>
    </cfif>
    
    <cfquery name="GET_PROCESS_TYPES" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PTR.PROCESS_ID = PT.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.list_service,%">
            <cfif isDefined('x_show_authorized_stage') and x_show_authorized_stage eq 1 and isDefined("process_rowid_list") and ListLen(process_rowid_list)>
                AND PTR.PROCESS_ROW_ID IN (#process_rowid_list#)
            </cfif>
    </cfquery>
    <cf_workcube_process_info>
    <cfinclude template="../callcenter/query/get_branch.cfm">
    <cfset branch_id_list=listsort(valuelist(get_branch.branch_id),"numeric","ASC",",")>
    <cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../callcenter/query/get_service.cfm">
    <cfelse>
        <cfset get_service.recordcount = 0>
        <cfset get_service.query_count = 0>
    </cfif>
    <cfif isdefined("attributes.form_submitted")>
    <cfset list_sub_id=listdeleteduplicates(valuelist(get_service.subscription_id))>
        <cfif len(list_sub_id)>
            <cfquery name="LIST_SUB_NO" datasource="#DSN3#">
                SELECT SUBSCRIPTION_NO,SUBSCRIPTION_HEAD,SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IS NOT NULL AND SUBSCRIPTION_ID IN(#list_sub_id#)
            </cfquery>
            <cfoutput query="list_sub_no">
                <cfset "sub_no_#subscription_id#"=subscription_no>
                <cfset "sub_head_#subscription_id#"=subscription_head>
            </cfoutput>
        </cfif>
    </cfif>
    <cfif get_service.recordcount>
    	<cfset partner_id_list = "">
		<cfset consumer_id_list = "">
		<cfset company_id_list = "">
		<cfset service_branch_id_list = "">
		<cfset service_id_list = "">
		<cfset commethod_id_list = "">
		<cfset servicecat_sub_list = "">
		<cfset employee_list = "">
		<cfset record_consumer_id_list = "">
      	<cfoutput query="get_service"> 
			<cfif len(service_partner_id) and not listfind(partner_id_list,service_partner_id)>
				<cfset partner_id_list=listappend(partner_id_list,service_partner_id)>
			</cfif>
			<cfif len(service_company_id) and not listfind(company_id_list,service_company_id)>
				<cfset company_id_list=listappend(company_id_list,service_company_id)>
			</cfif>
			<cfif len(service_consumer_id) and not listfind(consumer_id_list,service_consumer_id)>
				<cfset consumer_id_list=listappend(consumer_id_list,service_consumer_id)>
			</cfif>
			<cfif len(service_branch_id) and not listfind(service_branch_id_list,service_branch_id)>
				<cfset service_branch_id_list=listappend(service_branch_id_list,service_branch_id)>
			</cfif>
			<cfif len(service_id) and not listfind(service_id_list,service_id)>
				<cfset service_id_list=listappend(service_id_list,service_id)>
			</cfif>
			<cfif len(commethod_id) and not listfind(commethod_id_list,commethod_id)>
				<cfset commethod_id_list=listappend(commethod_id_list,commethod_id)>
			</cfif>
			<cfif len(service_id) and not listfind(servicecat_sub_list,service_id)>
				<cfset servicecat_sub_list=listappend(servicecat_sub_list,service_id)>
			</cfif>
			<cfif len(service_employee_id) and not listfind(employee_list,service_employee_id)>
				<cfset employee_list=listappend(employee_list,service_employee_id)>
			</cfif>
			<cfif len(record_emp) and not listfind(employee_list,record_emp)>
				<cfset employee_list=listappend(employee_list,record_emp)>
			</cfif>
        </cfoutput>
		<cfif len(partner_id_list)>
			<cfset partner_id_list=ListSort(partner_id_list,"numeric","ASC",",")>
			<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
				SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,PARTNER_ID FROM COMPANY_PARTNER WHERE PARTNER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#partner_id_list#">) ORDER BY PARTNER_ID
			</cfquery>
			<cfset partner_id_list = ListSort(ListDeleteDuplicates(ValueList(get_partner_detail.partner_id,',')),"numeric","asc",",")>
		</cfif>
		<cfif len(company_id_list)>
        	<cfset company_id_list=ListSort(company_id_list,"numeric","ASC",",")>
			<cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
				SELECT FULLNAME,COMPANY_ID,SALES_COUNTY FROM COMPANY WHERE COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#company_id_list#">) ORDER BY COMPANY_ID
			</cfquery>
            <cfset company_id_list = ListSort(ListDeleteDuplicates(ValueList(get_company_detail.company_id,',')),"numeric","asc",",")>
           <!--- Satış Bölgesi için eklenen kod--->
            <cfif isdefined("xml_s_county_in_list") and xml_s_county_in_list eq 1>
             <cfset s_county_list=ListSort(listdeleteduplicates(valuelist(get_company_detail.sales_county)),"numeric","ASC",",")>
            	<cfif listlen(s_county_list)>
                    <cfquery name="get_sales_county" datasource="#dsn#">
                        SELECT 
                            SZ_ID, 
                            SZ_NAME,
                            COMPANY_ID 
                        FROM 
                            SALES_ZONES,
                            COMPANY 
                        WHERE
                            SALES_ZONES.SZ_ID=COMPANY.SALES_COUNTY AND
                            SZ_ID IN (#s_county_list#)
                        ORDER BY 
                            COMPANY_ID 
                    </cfquery>
                    <cfset s_county_list = ListSort(ListDeleteDuplicates(ValueList(get_sales_county.company_id,',')),"numeric","asc",",")>
 				</cfif>
            </cfif>
		</cfif>
		<cfif len(consumer_id_list)>
			<cfset consumer_id_list=ListSort(consumer_id_list,"numeric","ASC",",")>
			<cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
				SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID,SALES_COUNTY FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#consumer_id_list#">) ORDER BY CONSUMER_ID
			</cfquery>
			<cfset consumer_id_list = ListSort(ListDeleteDuplicates(ValueList(get_consumer_detail.consumer_id,',')),"numeric","asc",",")>
           <!--- Satış Bölgesi için eklenen kod--->
            <cfif isdefined("xml_s_county_in_list") and xml_s_county_in_list eq 1>
             <cfset s_county2_list=ListSort(listdeleteduplicates(valuelist(get_consumer_detail.sales_county)),"numeric","ASC",",")>
            	<cfif listlen(s_county2_list)>
                    <cfquery name="get_sales_county2" datasource="#dsn#">
                       SELECT 
                            SZ_ID, 
                            SZ_NAME,
                            CONSUMER_ID 
                        FROM 
                            SALES_ZONES,
                            CONSUMER
                        WHERE
                            SALES_ZONES.SZ_ID=CONSUMER.SALES_COUNTY AND
                            SZ_ID IN (#s_county2_list#)
                        ORDER BY 
                            CONSUMER_ID 
                    </cfquery>
                    <cfset s_county2_list = ListSort(ListDeleteDuplicates(ValueList(get_sales_county2.consumer_id,',')),"numeric","asc",",")>
                </cfif>
           	</cfif>
		</cfif>
		<cfif len(employee_list)>
			<cfset employee_list=ListSort(employee_list,"numeric","ASC",",")>
			<cfquery name="GET_RECORD_EMP" datasource="#DSN#">
				SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#employee_list#">) ORDER BY EMPLOYEE_ID
			</cfquery>
			<cfset employee_list = ListSort(ListDeleteDuplicates(ValueList(GET_RECORD_EMP.EMPLOYEE_ID,',')),"numeric","asc",",")>
		</cfif>
		<cfif len(record_consumer_id_list)>
			<cfset consumer_id_list=ListSort(record_consumer_id_list,"numeric","ASC",",")>
			<cfquery name="GET_RECORD_CONSUMER_DETAIL" datasource="#DSN#">
				SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID,SALES_COUNTY FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#record_consumer_id_list#">) ORDER BY CONSUMER_ID
			</cfquery>
			<cfset record_consumer_id_list = ListSort(ListDeleteDuplicates(ValueList(get_record_consumer_detail.consumer_id,',')),"numeric","asc",",")>
		</cfif>
		<cfif (isdefined("xml_branch_in_list") and xml_branch_in_list eq 1) or not isdefined("xml_branch_in_list")>
			<cfif len(service_branch_id_list)>
				<cfset service_branch_id_list=listsort(service_branch_id_list,"numeric","ASC",",")>
				<cfquery name="GET_BRANCH_NAME" datasource="#DSN#">
					SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_branch_id_list#">) ORDER BY BRANCH_ID
				</cfquery>
				<cfset service_branch_id_list = ListSort(ListDeleteDuplicates(ValueList(get_branch_name.branch_id,',')),'numeric','ASC',',')>
			</cfif>
		</cfif>
		<cfif len(service_id_list)>
			<cfset service_id_list=ListSort(service_id_list,"numeric","ASC",",")>
			<cfquery name="GET_SERVICE_EMPLOYEE_DETAIL" datasource="#DSN#">
				SELECT 
					PW.G_SERVICE_ID,
					E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS USER_
				FROM 
					EMPLOYEES E,
					PRO_WORKS PW
				WHERE 
					E.EMPLOYEE_ID = PW.PROJECT_EMP_ID AND
					PW.G_SERVICE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_id_list#">)
				ORDER BY 
					PW.G_SERVICE_ID
			</cfquery>
			<cfif GET_SERVICE_EMPLOYEE_DETAIL.recordcount>
				<cfoutput query="GET_SERVICE_EMPLOYEE_DETAIL">
					<cfif isdefined("service_gorevli_employees_#G_SERVICE_ID#")>
						<cfset 'service_gorevli_employees_#G_SERVICE_ID#' = listappend(evaluate("service_gorevli_employees_#G_SERVICE_ID#"),user_)>
					<cfelse>
						<cfset 'service_gorevli_employees_#G_SERVICE_ID#' = user_>
					</cfif>
				</cfoutput>
			</cfif>
			<cfquery name="GET_SERVICE_PARTNER_DETAIL" datasource="#DSN#">
				SELECT 
					PW.G_SERVICE_ID,
					CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS USER_					
				FROM 
					COMPANY_PARTNER CP,
					PRO_WORKS PW
				WHERE 
					CP.PARTNER_ID = PW.OUTSRC_PARTNER_ID AND
					PW.SERVICE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_id_list# ">)
				ORDER BY 
					PW.G_SERVICE_ID
			</cfquery>
			<cfif GET_SERVICE_PARTNER_DETAIL.recordcount>
				<cfoutput query="GET_SERVICE_PARTNER_DETAIL">
					<cfif isdefined("service_gorevli_partners_#G_SERVICE_ID#")>
						<cfset 'service_gorevli_partners_#G_SERVICE_ID#' = listappend(evaluate("service_gorevli_partners_#G_SERVICE_ID#"),user_)>
					<cfelse>
						<cfset 'service_gorevli_partners_#G_SERVICE_ID#' = user_>
					</cfif>
				</cfoutput>
			</cfif>
		</cfif>
		<cfif (isdefined("xml_commethod_in_list") and xml_commethod_in_list eq 1) or not isdefined("xml_commethod_in_list")>
			<cfif len(commethod_id_list)>
				<cfset commethod_id_list=listsort(commethod_id_list,"numeric","ASC",",")>
				<cfquery name="get_commethod_det" datasource="#DSN#">
					SELECT COMMETHOD,COMMETHOD_ID FROM SETUP_COMMETHOD WHERE COMMETHOD_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#commethod_id_list#">) ORDER BY COMMETHOD_ID
				</cfquery>
				<cfset commethod_id_list = ListSort(ListDeleteDuplicates(ValueList(get_commethod_det.COMMETHOD_ID,',')),'numeric','ASC',',')>
			</cfif>
		</cfif>
		<cfif isdefined("xml_alt_cat_in_list") and  xml_alt_cat_in_list eq 1>
        	<cfquery name="get_cat" datasource="#dsn#">
            	SELECT 
                    GAR.SERVICE_ID,
                    GAS.SERVICE_SUB_CAT
                FROM 
					G_SERVICE_APP_ROWS GAR,
                    G_SERVICE_APPCAT_SUB GAS
               WHERE
					GAR.SERVICE_SUB_CAT_ID = GAS.SERVICE_SUB_CAT_ID AND 
               		GAR.SERVICE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_id_list#">)
              ORDER BY
					GAR.SERVICE_ID
            </cfquery>
            <cfoutput query="get_cat">
				<cfset "ser_cat_#SERVICE_ID#"=SERVICE_SUB_CAT>
			</cfoutput>
		</cfif>
		<cfif isdefined("xml_alt_tree_cat_in_list") and xml_alt_tree_cat_in_list eq 1>
			<cfif len(servicecat_sub_list)>
				<cfquery name="get_sub_status" datasource="#dsn#">
					SELECT
						GAR.SERVICE_ID,
                        GAS.SERVICE_SUB_CAT + ' ' + '<font color="999999">' + SERVICE_SUB_STATUS + '</font>' AS INFO_
					FROM
						G_SERVICE_APP_ROWS GAR,
						G_SERVICE_APPCAT_SUB GAS,
						G_SERVICE_APPCAT_SUB_STATUS GAST
					WHERE
						GAR.SERVICE_SUB_CAT_ID = GAS.SERVICE_SUB_CAT_ID AND
						GAR.SERVICE_SUB_STATUS_ID = GAST.SERVICE_SUB_STATUS_ID AND
						GAR.SERVICE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#servicecat_sub_list#">)
					ORDER BY
						GAR.SERVICE_ID
				</cfquery>
				<cfset servicecat_sub_list = listsort(listdeleteduplicates(valuelist(get_sub_status.service_id,',')),"numeric","asc",",")>
				<cfif get_sub_status.recordcount>
				<cfoutput query="get_sub_status">
					<cfif isdefined("service_info_#SERVICE_ID#")>
						<cfset 'service_info_#SERVICE_ID#' = listappend(evaluate("service_info_#SERVICE_ID#"),INFO_)>
					<cfelse>
						<cfset 'service_info_#SERVICE_ID#' = INFO_>
					</cfif>
				</cfoutput>
			</cfif>
			</cfif>
		</cfif>
        <cfif isdefined("xml_count_city_in_list") and xml_count_city_in_list eq 1>
			<cfquery name="get_count_name" datasource="#dsn#">
                SELECT
                     SC.COUNTY_NAME,
                     S.SERVICE_ID
                FROM 
                    SETUP_COUNTY SC,
                    G_SERVICE S,
                    COMPANY
                WHERE
                	COMPANY.COMPANY_ID= S.SERVICE_COMPANY_ID AND 
                	SC.COUNTY_ID = COMPANY.COUNTY AND
                    S.SERVICE_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_id_list#">)
                ORDER BY
                	SERVICE_ID
            </cfquery>
            <cfoutput query="get_count_name">
				<cfset "county_name_#SERVICE_ID#"=COUNTY_NAME>
			</cfoutput>
			<cfquery name="get_city_name" datasource="#dsn#">
                SELECT
                     SC.CITY_NAME,
                     S.SERVICE_ID
                FROM 
                    SETUP_CITY SC,
                    G_SERVICE S,
                    COMPANY 
                WHERE
                	COMPANY.COMPANY_ID= S.SERVICE_COMPANY_ID AND 
                	SC.CITY_ID = COMPANY.CITY AND
                    S.SERVICE_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_id_list#">)
                ORDER BY
                	SERVICE_ID
            </cfquery>
			<cfoutput query="get_city_name">
				<cfset "city_name_#SERVICE_ID#"=CITY_NAME>
			</cfoutput>
		</cfif>
        <cfif xml_tel_in_list eq 1>
			<cfquery name="get_tel" datasource="#dsn#">
                SELECT
                	COMPANY_TELCODE+' '+COMPANY_TEL1 TEL_NUMBER,
                    S.SERVICE_ID
                FROM 
                    G_SERVICE S,
                    COMPANY 
                WHERE
                	COMPANY.COMPANY_ID= S.SERVICE_COMPANY_ID AND 
                	S.SERVICE_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_id_list#">)
                ORDER BY
                	SERVICE_ID
            </cfquery>
			<cfoutput query="get_tel">
				<cfset "tel_no_#SERVICE_ID#"=TEL_NUMBER>
			</cfoutput>
		</cfif>
    </cfif>
    <cfparam name="attributes.totalrecords" default="#get_service.query_count#">
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	<cf_xml_page_edit fuseact="call.add_service">
    <cfparam name="attributes.task_person_name" default="">
    <cfparam name="attributes.responsible_person" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.partner_id" default="">
    <cfparam name="attributes.employee_id" default="">
    <cfparam name="get_service_detail.applicator_name" default="">
    <cfparam name="attributes.service_branch_id" default="">
    <cfparam name="attributes.service_status_id" default="">
    <cfparam name="attributes.city_id" default="">
    <cfquery name="GET_SERVICE_NO" datasource="#DSN#">
        SELECT G_SERVICE_APP_NO, G_SERVICE_APP_NUMBER FROM GENERAL_PAPERS_MAIN
    </cfquery>
    <cfif isdefined('attributes.campaign_id') and len(attributes.campaign_id)>
        <cfquery name="GET_CAMP_INFO" datasource="#DSN3#">
            SELECT CAMP_ID,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.campaign_id#">
        </cfquery>
    <cfelse>
        <cfset get_camp_info.camp_head = ''>
    </cfif>
    <cfif not len(get_service_no.g_service_app_no) or not len(get_service_no.g_service_app_number)>
        <font class="txtbold"><cf_get_lang no='58.Call Center Başvurusu Eklemek İçin Öncelikle Şikayet Belge Numaralarını Düzenlemelisiniz'>!</font>
        <cfexit method="exittemplate">
    </cfif>
    <cfinclude template="../callcenter/query/get_priority.cfm">
    <cfquery name="GET_SERVICE_APPCAT" datasource="#DSN#">
        SELECT
            SERVICECAT,
            SERVICECAT_ID
        FROM
            G_SERVICE_APPCAT
        WHERE
            IS_STATUS = 1
            AND(
                OUR_COMPANY_ID LIKE '#session.ep.company_id#'
                OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#'
                OR OUR_COMPANY_ID LIKE '#session.ep.company_id#,%'
                OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#,%'
                )
        ORDER BY SERVICECAT
    </cfquery>
    <cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#DSN#">
        SELECT
            SERVICE_SUB_CAT_ID,
            SERVICE_SUB_CAT,
            SERVICECAT_ID,
            OUR_COMPANY_ID
        FROM
            G_SERVICE_APPCAT_SUB
        WHERE
            IS_STATUS = 1
            AND(
                OUR_COMPANY_ID LIKE '#session.ep.company_id#'
                OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#'
                OR OUR_COMPANY_ID LIKE '#session.ep.company_id#,%'
                OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#,%'
                )    
        ORDER BY
            SERVICE_SUB_CAT
    </cfquery>
    <cfquery name="GET_SERVICE_APPCAT_SUB_STATUS" datasource="#DSN#">
        SELECT
            SERVICE_SUB_CAT_ID,
            SERVICE_SUB_STATUS_ID,
            SERVICE_SUB_STATUS
        FROM
            G_SERVICE_APPCAT_SUB_STATUS
        WHERE
            IS_STATUS = 1
            AND(
                OUR_COMPANY_ID LIKE '#session.ep.company_id#'
                OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#'
                OR OUR_COMPANY_ID LIKE '#session.ep.company_id#,%'
                OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#,%'
                )   
        ORDER BY SERVICE_SUB_STATUS
    </cfquery>
    <cfset app_rows = "">
    <cfif isdefined("attributes.mail_id")>
        <cfquery name="GET_MAIL_INFO" datasource="#DSN#">
            SELECT SUBJECT, CONTENT_FILE, MAIL_FROM FROM MAILS WHERE MAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mail_id#">
        </cfquery>
        <cfquery name="FROM_MAIL_PARTNER" datasource="#DSN#">
            SELECT COMPANY_ID, PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_mail_info.mail_from#">
        </cfquery>
        <cfif FileExists("#upload_folder#mails#dir_seperator#in#dir_seperator##get_mail_info.content_file#")> 
            <cffile action="read" file="#upload_folder#mails#dir_seperator#in#dir_seperator##get_mail_info.content_file#" variable="mail_body" charset ="UTF-8">
        </cfif>
        <cfif from_mail_partner.recordcount>
            <cfset attributes.partner_id = from_mail_partner.partner_id>
            <cfset attributes.company_id = from_mail_partner.company_id>
            <cfset attributes.consumer_id = ''>
        <cfelse>
            <cfquery name="FROM_MAIL_CONSUMER" datasource="#DSN#">
                SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_mail_info.mail_from#">
            </cfquery>
            <cfif from_mail_consumer.recordcount>
                <cfset attributes.company_id = ''>
                <cfset attributes.partner_id = ''>
                <cfset attributes.consumer_id = from_mail_consumer.consumer_id>
            <cfelse>
                <cfset attributes.company_id = ''>
                <cfset attributes.partner_id = ''>
                <cfset attributes.consumer_id = ''>
            </cfif>
        </cfif>
        <cfset get_service_detail.service_head = get_mail_info.subject>
        <cfset attributes.commethod_id = ''>
        <cfset service_detail = ''>
        <cfset task_emp_id = session.ep.userid>
        <cfset task_emp_name = get_emp_info(session.ep.userid,0,0)>
        <cfset resp_emp_id = session.ep.userid>
        <cfset resp_comp_id = "">
        <cfset resp_cons_id = "">
        <cfset resp_par_id = "">
        <cfset resp_emp_name = get_emp_info(session.ep.userid,0,0)>
    <cfelseif isdefined("attributes.service_id")>
        <cfquery name="GET_SERVICE_DETAIL" datasource="#DSN#">
            SELECT 
                SERVICE_EMPLOYEE_ID,
                SERVICE_COMPANY_ID,
                SERVICE_CONSUMER_ID,
                SERVICE_PARTNER_ID,
                SERVICE_BRANCH_ID,
                SERVICE_HEAD,
                SERVICE_DETAIL,
                SERVICECAT_ID,
                APPLICATOR_NAME,
                APPLY_DATE,
                START_DATE,
                PRIORITY_ID,
                COMMETHOD_ID,
                PROJECT_ID,
                SUBSCRIPTION_ID,
                REF_NO,
                SERVICE_STATUS_ID,
                CAMPAIGN_ID,
                RESP_EMP_ID,
                RESP_PAR_ID,
                RESP_COMP_ID,
                RESP_CONS_ID,
                NOTIFY_EMPLOYEE_ID,
                NOTIFY_PARTNER_ID,
                NOTIFY_CONSUMER_ID
            FROM
                G_SERVICE
            WHERE 
                SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        </cfquery>
        <cfset attributes.company_id = get_service_detail.service_company_id>
        <cfset attributes.consumer_id = get_service_detail.service_consumer_id>
        <cfset attributes.partner_id = get_service_detail.service_partner_id>
        <cfset attributes.employee_id = get_service_detail.service_employee_id>
        <cfset attributes.service_head = get_service_detail.service_head>
        <cfset attributes.branch_id = get_service_detail.service_branch_id>
        <cfset attributes.subscription_id = get_service_detail.subscription_id>
        <cfset attributes.commethod_id = get_service_detail.commethod_id>
        <cfset attributes.service_status_id = get_service_detail.service_status_id>
        <cfset attributes.campaign_id = get_service_detail.campaign_id>
        <cfset attributes.notify_employee_id = get_service_detail.notify_employee_id>
        <cfset attributes.notify_partner_id = get_service_detail.notify_partner_id>
        <cfset attributes.notify_consumer_id = get_service_detail.notify_consumer_id>
        <cfif len(attributes.subscription_id)>
            <cfquery name="GET_SUB_NO" datasource="#DSN3#">
                SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
            </cfquery>
            <cfset attributes.subscription_no = get_sub_no.subscription_no>
        </cfif>
        <cfset service_detail = get_service_detail.service_detail>
        <cfset task_emp_id = ''>
        <cfset task_emp_name = ''>
        <cfset resp_comp_id = get_service_detail.resp_comp_id>
        <cfset resp_par_id = get_service_detail.resp_par_id>
        <cfset resp_cons_id = get_service_detail.resp_cons_id>
        <cfset resp_emp_id = get_service_detail.resp_emp_id>
        <cfif len(get_service_detail.resp_emp_id)>
            <cfset resp_emp_name = get_emp_info(get_service_detail.resp_emp_id,0,0)>
        <cfelseif len(get_service_detail.resp_par_id)>
            <cfset resp_emp_name = get_par_info(get_service_detail.resp_par_id,0,0,0)>
        <cfelseif len(get_service_detail.resp_cons_id)>
            <cfset resp_emp_name = get_cons_info(get_service_detail.resp_cons_id,0,0)>
        <cfelse>
            <cfset resp_emp_name = "">
        </cfif>
        <cfset attributes.servicecat_id = get_service_detail.servicecat_id>	
        <cfquery name="GET_SERVICE_APP_ROWS" datasource="#DSN#">
            SELECT SERVICE_SUB_STATUS_ID, SERVICE_SUB_CAT_ID FROM G_SERVICE_APP_ROWS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        </cfquery>
        <cfset app_rows = valuelist(get_service_app_rows.service_sub_status_id,',')>
    <cfelseif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
        <cfquery name="GET_HELP_" datasource="#DSN#">
            SELECT COMPANY_ID, PARTNER_ID, CONSUMER_ID, SUBJECT, SUBSCRIPTION_ID, APP_CAT FROM CUSTOMER_HELP WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
        </cfquery>
        <cfset attributes.consumer_id = get_help_.consumer_id>
        <cfset attributes.partner_id = get_help_.partner_id>
        <cfset attributes.company_id = get_help_.company_id>
        <cfset attributes.subscription_id = get_help_.subscription_id>
        <cfset service_detail = get_help_.subject>
        <cfset attributes.commethod_id = get_help_.app_cat>
        <cfset task_emp_id = ''>
        <cfset task_emp_name = ''>
        <cfset resp_comp_id = ''>
        <cfset resp_par_id = ''>
        <cfset resp_cons_id = ''>
        <cfset resp_emp_id = ''>
        <cfset resp_emp_name = ''>
        <cfif len(attributes.subscription_id)>
            <cfquery name="GET_SUB_NO" datasource="#DSN3#">
                SELECT SUBSCRIPTION_NO,PROJECT_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
            </cfquery>
            <cfset attributes.subscription_no = get_sub_no.subscription_no>
            <cfset get_service_detail.project_id = GET_SUB_NO.project_id>
        </cfif>
    <cfelse>
        <!--- üyeden,sistemden vs gelen kayıtlarda dolu geliyor, kaybetmemesi için.. --->
        <cfif not isDefined("attributes.company_id")><cfset attributes.company_id = ''></cfif>
        <cfif not isDefined("attributes.consumer_id")><cfset attributes.consumer_id = ''></cfif>
        <cfif not isDefined("attributes.partner_id")><cfset attributes.partner_id = ''></cfif>
        <cfif not isdefined("attributes.service_head")><cfset attributes.service_head = ''></cfif>
        <cfset attributes.commethod_id = ''>
        <cfset service_detail = ''>
        <cfset task_emp_id = ''>
        <cfset task_emp_name = ''>
        <cfset resp_emp_id = ''>
        <cfset resp_cons_id = ''>
        <cfset resp_comp_id = ''>
        <cfset resp_par_id = ''>
        <cfset resp_emp_name =''>
    </cfif>
	<cfif len(attributes.consumer_id)>
        <cfquery name="GET_CONS_DETAIL" datasource="#DSN#">
            SELECT MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
        </cfquery>
    </cfif>
    <cfif isdefined("attributes.service_id")>
        <cfquery name="GET_SUB_QUERY" dbtype="query">
            SELECT
                SERVICE_SUB_CAT_ID,
                SERVICE_SUB_CAT,
                SERVICECAT_ID
            FROM
                GET_SERVICE_APPCAT_SUB
            WHERE
                SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.servicecat_id#">
        </cfquery>
        <cfquery name="GET_SUB_TREE_QUERY" dbtype="query">
            SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS_ID,SERVICE_SUB_STATUS FROM GET_SERVICE_APPCAT_SUB_STATUS WHERE SERVICE_SUB_CAT_ID <cfif len(get_service_app_rows.service_sub_cat_id)>= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_app_rows.service_sub_cat_id#"><cfelse>IS NULL</cfif>
        </cfquery>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd' or attributes.event is 'det'>
    <cf_xml_page_edit fuseact="call.add_service">
    <cfset attributes.g_service_id = attributes.service_id>
    <cfinclude template="../callcenter/query/get_service_detail.cfm">
	<cfscript>
        attributes.company_id = get_service_detail.service_company_id;
        attributes.partner_id = get_service_detail.service_partner_id;
        attributes.consumer_id = get_service_detail.service_consumer_id;
        attributes.employee_id = get_service_detail.service_employee_id;
        attributes.brnch_id = get_service_detail.service_branch_id;
    </cfscript>
    <cfif len(get_service_detail.service_employee_id)>
        <cfquery name="GET_EMP_POS" datasource="#DSN#">
            SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_employee_id#">
        </cfquery>
    </cfif>
    <cfinclude template="../callcenter/query/get_priority.cfm">
    <cfinclude template="../callcenter/query/get_com_method.cfm">
    <cfquery name="GET_SERVICE_APPCAT" datasource="#DSN#"><!--- Kategori --->
        SELECT
            SERVICECAT,SERVICECAT_ID
        FROM
            G_SERVICE_APPCAT
        WHERE
            IS_STATUS = 1 AND
            (
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#"> OR
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#"> OR
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#,%"> OR
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#,%">
            )    
        ORDER BY 
            SERVICECAT
    </cfquery>
    <cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#DSN#"><!--- Alt Kategori --->
        SELECT
            SERVICE_SUB_CAT_ID,
            SERVICE_SUB_CAT,
            SERVICECAT_ID
        FROM
            G_SERVICE_APPCAT_SUB
        WHERE
            IS_STATUS = 1 AND
            (
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#"> OR
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#"> OR
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#,%"> OR
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#,%">
            )    	  
        ORDER BY
            SERVICE_SUB_CAT
    </cfquery>
    <cfquery name="GET_SERVICE_APPCAT_SUB_STATUS" datasource="#DSN#"><!--- Alt Tree Kategori --->
        SELECT
            SERVICE_SUB_CAT_ID,
            SERVICE_SUB_STATUS_ID,
            SERVICE_SUB_STATUS
        FROM
            G_SERVICE_APPCAT_SUB_STATUS
        WHERE
            IS_STATUS = 1 AND
            (
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#"> OR
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#"> OR
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#,%"> OR
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#,%">
            )
        UNION ALL
        SELECT
            SERVICE_SUB_CAT_ID,
            SERVICE_SUB_STATUS_ID,
            SERVICE_SUB_STATUS
        FROM
            G_SERVICE_APPCAT_SUB_STATUS
        WHERE
            IS_STATUS = 0 AND
            (
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#"> OR
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#"> OR
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#,%"> OR
                OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#,%">
            ) AND
            SERVICE_SUB_STATUS_ID IN (SELECT SERVICE_SUB_STATUS_ID FROM G_SERVICE_APP_ROWS WITH(NOLOCK) WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">)   
        ORDER BY 
            SERVICE_SUB_STATUS
    </cfquery>
    <cfquery name="GET_SERVICE_APP_ROWS" datasource="#DSN#"><!--- Basvuru Satirlari- Kategori Bilgileri --->
        SELECT 
            SERVICE_SUB_CAT_ID,
            SERVICECAT_ID,
            SERVICE_SUB_STATUS_ID,
            SERVICE_ID
        FROM 
            G_SERVICE_APP_ROWS 
        WHERE 
            SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
    </cfquery>
    <cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
        SELECT OPP_NO,OPP_ID FROM OPPORTUNITIES WHERE SERVICE_ID = #attributes.service_id#
    </cfquery>
    <cfset app_rows = valuelist(get_service_app_rows.service_sub_status_id,',')>
	<cfscript>
        contact_type = "";
        contact_id = "";
        if(len(attributes.company_id))
        {
            contact_type = "comp";
            contact_id = attributes.company_id;
        }
        else if(len(attributes.partner_id))
        {
            contact_type = "p";
            contact_id = attributes.partner_id;
            //par_id = attributes.partner_id;
        }
        else if(len(attributes.consumer_id))
        {
            contact_type = "c";
            contact_id = attributes.consumer_id;
            //con_id = attributes.consumer_id;
        }
        else if(len(attributes.employee_id))
        {
            contact_type = "e";
            contact_id = attributes.employee_id;
            //emp_id = attributes.emp_id;
        }
    </cfscript>
    <cfif len(get_service_detail.campaign_id)>
        <cfquery name="GET_CAMP_INFO" datasource="#DSN3#">
            SELECT CAMP_ID,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.campaign_id#">
        </cfquery>
    <cfelse>
        <cfset get_camp_info.camp_head = ''>
    </cfif>
    
    <cfif len(get_service_detail.apply_date)>
		<cfset adate=date_add("H",session.ep.time_zone,get_service_detail.apply_date)>
        <cfset ahour=datepart("H",adate)>
        <cfset aminute=datepart("N",adate)>
        <cfset apply_date_ = dateformat(date_add("H",session.ep.time_zone,get_service_detail.apply_date),'dd/mm/yyyy')>
    <cfelse>
        <cfset adate="">
        <cfset ahour="">
        <cfset aminute="">
        <cfset apply_date_ = "">
    </cfif>
    <!--- 5 dk aralik verildigi icin BK 20120323 --->
    <cfif aminute gt 55>
        <cfset aminute = 55>
    <cfelseif (aminute mod 5) neq 0>
        <cfset aminute = aminute+(5-(aminute mod 5))>
    </cfif>
    
    <cfif len(get_service_detail.resp_emp_id)>
		<cfset resp_emp_name = get_emp_info(get_service_detail.resp_emp_id,0,0)>
    <cfelseif len(get_service_detail.resp_par_id)>
        <cfset resp_emp_name = get_par_info(get_service_detail.resp_par_id,0,0,0)>
    <cfelseif len(get_service_detail.resp_cons_id)>
        <cfset resp_emp_name = get_cons_info(get_service_detail.resp_cons_id,0,0)>
    <cfelse>
        <cfset resp_emp_name = "">
    </cfif>
    
    <cfif isdefined("get_service_detail.start_date") and len(get_service_detail.start_date)>
		<cfset sdate=date_add("H",session.ep.time_zone,get_service_detail.start_date)>
        <cfset shour=datepart("H",sdate)>
        <cfset sminute=datepart("N",sdate)>
        <cfset start_date_ = dateformat(date_add("H",session.ep.time_zone,get_service_detail.start_date),'dd/mm/yyyy')>
    <cfelse>
        <cfset sdate="">
        <cfset shour="">
        <cfset sminute="">
        <cfset start_date_ = "">
    </cfif>
    
    <cfif len(get_service_detail.finish_date)>
		<cfset fdate=date_add("h",session.ep.time_zone,get_service_detail.finish_date)>
        <cfset fhour=datepart("h",fdate)>
        <cfset fminute=datepart("N",fdate)>
        <cfset finish_date_ = dateformat(fdate,'dd/mm/yyyy')>
    <cfelse>
        <cfset fdate="">
        <cfset fhour="">
        <cfset fminute="">
        <cfset finish_date_ = "">
    </cfif>
    <cfif x_is_sub_tree_single_select eq 1>
        <cfquery name="GET_SUB_QUERY" dbtype="query">
            SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM GET_SERVICE_APPCAT_SUB 
            <cfif x_is_related_upper_cat>WHERE SERVICECAT_ID = <cfif len(get_service_app_rows.servicecat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_app_rows.servicecat_id#"></cfif></cfif>
        </cfquery>
        <cfquery name="GET_SUB_TREE_QUERY" dbtype="query">
            SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS_ID,SERVICE_SUB_STATUS FROM GET_SERVICE_APPCAT_SUB_STATUS 
            <cfif x_is_related_upper_cat>WHERE SERVICE_SUB_CAT_ID <cfif len(get_service_app_rows.service_sub_cat_id)>= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_app_rows.service_sub_cat_id#"><cfelse>IS NULL</cfif></cfif>
        </cfquery>
	</cfif>
    <cfif len(get_service_detail.subscription_id)>
		<cfset attributes.subscription_id = get_service_detail.subscription_id>					 	
        <cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
            SELECT SUBSCRIPTION_NO,SUBSCRIPTION_HEAD FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IS NOT NULL AND SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
        </cfquery>
    </cfif>
    <cfif isdefined('attributes.campaign_id') and len(attributes.campaign_id)>
        <cfquery name="GET_CAMP_INFO" datasource="#DSN3#">
            SELECT CAMP_ID,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.campaign_id#">
        </cfquery>
    <cfelse>
        <cfset get_camp_info.camp_head = ''>
    </cfif>    
	<cfif len(get_service_detail.service_company_id)>
        <cfset attributes.company_id = get_service_detail.service_company_id>
    <cfelse>
        <cfset attributes.consumer_id = get_service_detail.service_consumer_id>
</cfif>     
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(function(){		 	
			document.getElementById('keyword').focus();	 
		 });
		function c_del(type,type_2)
		{
			if(document.getElementById(type).value=='')
			document.getElementById(type_2).value='';
		}
		function pencere_ac2(no)
		{ 
			if (document.getElementById("city_id").value == "")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1196.İl'>");
			}
			else
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=list_service.county_id&field_name=list_service.county&city_id=' + document.getElementById("city_id").value,'list');
			}
		}	
		function kontrol()
		{
			if (document.getElementById("start_date").value.length != 0 && document.getElementById("finish_date").value.length != 0)
			return date_check(document.getElementById("start_date"),document.getElementById("finish_date"),"<cf_get_lang no='109.Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır'>");
			return true;
		}
	</cfif>
	<cfif isdefined("attributes.event") and listfindnocase('add,upd,det',attributes.event)>		
		function info_comp(member_id,type)
			{	
				document.getElementById('resp_emp_id').value='';
				<cfif attributes.event is 'add'>
					document.getElementById('responsible_person').value='';
				<cfelse>
					document.getElementById('resp_emp_name').value='';
				</cfif>
				if(member_id==0)
				{
					if(document.getElementById('partner_id').value!='')
					{
						member_id=document.getElementById('company_id').value;
						type=1;
					}
					else if(document.getElementById('consumer_id').value!='')
					{
						member_id=document.getElementById('consumer_id').value;
						type=2;
					}
				}
				<cfif attributes.event is 'add'>
					document.getElementById("div_city_county_info").innerHTML ="<TABLE><tr><td></td></tr></TABLE>";
				</cfif>
					url_= '/V16/callcenter/cfc/call.cfc?method=get_info_sales_func';
					$.ajax({
						type: "get",
						url: url_,
						data: {member_id_: member_id,type:type},
						cache: false,
						async: false,
						success: function(read_data){
							data_1 = jQuery.parseJSON(read_data.replace('//',''));
							if(data_1.DATA.length != 0)
							{
								$.each(data_1.DATA,function(i){
									responsible_position_code = data_1.DATA[i][1];
									<cfif attributes.event is 'add'>
										document.getElementById("div_city_county_info").innerHTML ="";
										if(data_1.DATA[i][0].length || data_1.DATA[i][1].length || data_1.DATA[i][2].length || data_1.DATA[i][3].length)
										{
											document.getElementById("div_city_county_info").innerHTML = "<table>"
											if(data_1.DATA[i][2].length)
												document.getElementById("div_city_county_info").innerHTML += "<br/><tr><td class='txtbold'>Şehir:</td><td>"+data_1.DATA[i][2]+"</td></tr>"
											if(data_1.DATA[i][3].length)
												document.getElementById("div_city_county_info").innerHTML += "<br/><tr><td>İlçe:</td><td>"+data_1.DATA[i][3]+"</td></tr>"
											if(data_1.DATA[i][0].length)
												document.getElementById("div_city_county_info").innerHTML +="<br/><tr><td>Satış bölgesi:</td><td>"+data_1.DATA[i][0]+"</td></tr>"
											document.getElementById("div_city_county_info").innerHTML += "</table>"	
										}
									</cfif>
								});
							}
						}
					});
					
				if(responsible_position_code.length)
				{	
					url_= '/V16/callcenter/cfc/call.cfc?method=get_info_manager_func';
					$.ajax({
						type: "get",
						url: url_,
						data: {responsible_position_code: responsible_position_code},
						cache: false,
						async: false,
						success: function(read_data){
							data_ = jQuery.parseJSON(read_data.replace('//',''));
							if(data_.DATA.length != 0)
							{
								$.each(data_.DATA,function(i){
									document.getElementById('resp_emp_id').value=data_.DATA[i][0];
									document.getElementById('responsible_person').value=data_.DATA[i][1]+' '+ data_.DATA[i][2];
								});
							}
						}
					});	
				}
			}
		//gorevli alt tree kategoriye bagli olsun secilirse tree_idlerini gondermek icin FS
		function rel_tree_cat(ssci)
		{
			<cfif isdefined('x_is_multiple_select') and x_is_multiple_select eq 0 and isdefined("x_is_sub_tree_single_select") and x_is_sub_tree_single_select eq 0>
				if(document.getElementById('temp_service_sub_cat_id').value != '')
				{
					<cfif attributes.event is 'add'>	
						myval = document.getElementById('service_sub_cat_id_'+ssci).value;
						document.getElementById('service_sub_cat_id_'+ssci).value = myval;		
					</cfif>
					var temp_sel = document.getElementById('temp_service_sub_cat_id').value;
					document.getElementById('service_sub_cat_id_'+temp_sel).value ="";							
				}
				
				if(ssci != undefined)
					document.getElementById('temp_service_sub_cat_id').value = parseInt(ssci);
				else
					document.getElementById('temp_service_sub_cat_id').value = '';							
			</cfif>
			tree_category_list = "";
			<cfif attributes.event is 'add'>	
				if(x_is_related_tree_cat == 1)
				{
			</cfif>
				<cfif x_is_sub_tree_single_select neq 1>
					<cfoutput query="get_service_appcat" group="servicecat_id">
						<cfquery name="get_service_appcat_sub_ord" dbtype="query">
							SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM GET_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = #get_service_appcat.servicecat_id#
						</cfquery>
						<cfoutput>
							<cfloop query="GET_SERVICE_APPCAT_SUB_ORD">
								if(document.getElementById('service_sub_cat_id_#service_sub_cat_id#').value != "")
								{
									tree_category_list = tree_category_list  + (document.getElementById('service_sub_cat_id_#service_sub_cat_id#').value)+ ",";
								}
							</cfloop>
						</cfoutput>
					</cfoutput>
				<cfelse>
					if(document.getElementById('servicecat_sub_tree_id').value != "")
						tree_category_list = tree_category_list  + document.getElementById('servicecat_sub_tree_id').value + ",";
				</cfif>
			<cfif attributes.event is 'add'>		
			}
			</cfif>
		}		
		<cfif x_is_mail_send_tree_list eq 1 and x_is_sub_tree_single_select eq 0>
		//gonderi listesi alt tree kategoriden gelsin secilirse FS
			function send_tree_mail(xx)
				{
					var formName = 'add_service';
					form  = $('form[name="'+ formName +'"]');
					service_sub_status_id_ = list_getat(eval("document.getElementById('service_sub_cat_id_"+xx+"')").value,2,',');
					if(service_sub_status_id_ == "")
					{
						validateMessage('notValid',form.find('select#service_sub_cat_id_'+xx+''));
					}
					else
						windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=call.popup_sub_status_people&service_sub_status_id='+service_sub_status_id_+'&branch_id='+add_service.service_branch_id.value,'medium');
				}		
		</cfif>
		//kategori secimine gore alt kategorileri getirir
		function kategori_getir()
			{
				category_value = document.getElementById('appcat_id').value;
				<cfif x_is_sub_tree_single_select neq 1>
					if(category_value != '')
					{
						<cfoutput query="get_service_appcat">
							gizle(anakategori_#servicecat_id#);
						</cfoutput>
						goster(eval('anakategori_' + category_value));
					}
					else
					{
						<cfoutput query="get_service_appcat">
							gizle(anakategori_#servicecat_id#);
						</cfoutput>		
					}
				<cfelse>
					if(category_value != '')
					{
						<cfif x_is_related_upper_cat>
							var get_sub_category = wrk_safe_query('clcr_get_sub_category','dsn',0,category_value);	
						<cfelse>
							var get_sub_category = wrk_safe_query('clcr_get_sub_category','dsn',0,'');	
						</cfif>			
						var option_count = document.getElementById('servicecat_sub_id').options.length; 
						for(x=option_count;x>=0;x--)
							document.getElementById('servicecat_sub_id').options[x] = null;
						
						document.getElementById('servicecat_sub_id').options[0] = new Option('<cf_get_lang_main no='322.Seçiniz'>','');
						for(sc=0;sc<get_sub_category.recordcount;sc++)
							document.getElementById('servicecat_sub_id').options[sc+1]=new Option(get_sub_category.SERVICE_SUB_CAT[sc],get_sub_category.SERVICE_SUB_CAT_ID[sc]);
						<cfif attributes.event is not 'add'>
							return sub_kategori_getir();
						</cfif>
					}
					<cfif attributes.event is not 'add'>
						else
						{
							var option_count = document.getElementById('servicecat_sub_id').options.length; 
							for(x=option_count;x>=0;x--)
								document.getElementById('servicecat_sub_id').options[x] = null;
							document.getElementById('servicecat_sub_id').options[0] = new Option('<cf_get_lang_main no='322.Seçiniz'>','');
							
							// kategori secilmediginde alt tree kategoriyi de bosaltmasi lazim
							return sub_kategori_getir()
						}
					</cfif>
				</cfif>
				return true;
			}
		<cfif x_is_sub_tree_single_select eq 1>
			function sub_kategori_getir()
			{
				if(document.getElementById('servicecat_sub_id').value!= '')
				{
					<cfif x_is_related_upper_cat>
						var get_sub_tree_category = wrk_safe_query('clcr_get_sub_tree_category','dsn',0,document.getElementById('servicecat_sub_id').value);
					<cfelse>
						var get_sub_tree_category = wrk_safe_query('clcr_get_sub_tree_category','dsn',0,'');
					</cfif>
					var option_count_sub = document.getElementById('servicecat_sub_tree_id').options.length; 
					for(y=option_count_sub;y>=0;y--)
						document.getElementById('servicecat_sub_tree_id').options[y] = null;
							
					document.getElementById('servicecat_sub_tree_id').options[0] = new Option('<cf_get_lang_main no='322.Seçiniz'>','');
					for(stc=0;stc<get_sub_tree_category.recordcount;stc++)
						document.getElementById('servicecat_sub_tree_id').options[stc+1]=new Option(get_sub_tree_category.SERVICE_SUB_STATUS[stc],get_sub_tree_category.SERVICE_SUB_STATUS_ID[stc]);
				}
				<cfif attributes.event is not 'add'>
					else
					{
						var option_count_sub = document.getElementById('servicecat_sub_tree_id').options.length; 
						for(y=option_count_sub;y>=0;y--)
							document.getElementById('servicecat_sub_tree_id').options[y] = null;
						document.getElementById('servicecat_sub_tree_id').options[0] = new Option('<cf_get_lang_main no='322.Seçiniz'>','');
					}
				</cfif>	
			}
		</cfif>
		function return_member_code()
		{
			var consumer_id=document.getElementById('consumer_id').value;
			if(consumer_id!='')
			{
				get_consumer=wrk_safe_query('clcr_get_consumer','dsn',0,consumer_id);
				document.getElementById('member_company').value=get_consumer.MEMBER_CODE;
			}
			else
				return false;
		}
		function chk_form()
			{
				debugger;
				if (document.getElementById('start_date1') !=undefined && document.getElementById('start_date1').value !='' && document.getElementById('apply_date').value !='')
				{
					if (!time_check(document.getElementById('apply_date'),document.getElementById('apply_hour'), document.getElementById('apply_minute'),document.getElementById('start_date1'),document.getElementById('start_hour'),document.getElementById('start_minute')))
						{
							alertObject({message: "<cf_get_lang no='111.Başvuru Tarihi Kabul Tarihinden Önce Olmalıdır'>!"});
							return false;
						}
				}					
				
			return process_cat_control();
			}
	<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>				
			//gorevli linkini ve zorunlulugunu kontrol ediyor yukardaki fonksiyonla baglantili FS 
			function tree_gonder()
			{
				var formName = 'add_service';
					form  = $('form[name="'+ formName +'"]');
				if(x_is_related_tree_cat == 1 && tree_category_list == "")
				{					
					validateMessage('notValid',form.find('input#task_person_name') );					
				}				
				else if(x_is_related_tree_cat == 0)
				{
					windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=add_service.task_person_name&field_emp_id=add_service.task_emp_id&select_list=1</cfoutput>&process_date='+document.add_service.start_date1.value+'&keyword='+encodeURIComponent(document.add_service.task_person_name.value),'list');		
				}
				else if(tree_category_list != "")
				{
					windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=add_service.task_person_name&field_emp_id=add_service.task_emp_id&select_list=1</cfoutput>&process_date='+document.add_service.start_date1.value+'&tree_category_id='+tree_category_list+'&keyword='+encodeURIComponent(document.add_service.task_person_name.value),'list');
				}
				else 	
					{
						validateMessage('valid',form.find('input#task_person_name') );  
					}
			}
			function tree_gonder1()
			{
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=add_service.responsible_person&field_emp_id=add_service.resp_emp_id&field_consumer=add_service.resp_cons_id&field_partner=add_service.resp_par_id&field_comp_id=add_service.resp_comp_id&select_list=1,7,8</cfoutput>&keyword='+encodeURIComponent(document.add_service.responsible_person.value),'list');
			}			
			//alt kategori secimine gore alt tree kategorileri getirir				
			
			$( document ).ready(function() {
				document.getElementById('member_company').focus();
			});	
	</cfif>		
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();	
	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	if(isdefined("attributes.event") and (attributes.event contains 'upd' or attributes.event contains 'det'))
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = get_service_detail.SERVICE_STATUS_ID;
	else
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = '';
	
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn; // Transaction icin yapildi.*/
	

	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,det';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'G_SERVICE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SERVICE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-member_company','item-servicecat_id','item-service_head','item-service_detail']";	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'call.add_service';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'callcenter/form/add_service.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'callcenter/query/add_service.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'call.list_service&event=det&service_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_service';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'chk_form() && validate().check()';


	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'call.upd_service';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'callcenter/form/upd_service.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'callcenter/query/upd_service.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'call.list_service&event=upd&service_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = '##attributes.service_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.service_id##';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'add_service';	
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_service_detail';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryRecordEmp'] = 'RECORD_EMP';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryIsConsumer'] = '1';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'chk_form() && validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['det']['pageParams'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['pageParams']['size'] = '9-3;9';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'call/query/upd_service.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'call.list_service&event=det&service_id=';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##get_service_detail.service_no##';
	
	if(not isdefined('attributes.formSubmittedController'))
	{
		// type'lar include,box,custom tag şekline dönüşecek.
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'member.consumer_list';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'member/display/list_consumer.cfm';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'] = structNew();
		
		if(isdefined("attributes.event") and not (attributes.event is 'add' or attributes.event is 'list'))
		{
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['type'] = 0; // Include
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceController']  = 'listServiceController.cfm';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceEvent']  = 'upd';	
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['file'] = '#request.self#?fuseaction=objects.emptypopup_ajax_list_extra_pages&type=1&company_id=#attributes.company_id#&brnch_id=#attributes.brnch_id#&consumer_id=#attributes.consumer_id#&employee_id=#attributes.employee_id#&g_service_id=#attributes.g_service_id#&partner_id=#attributes.partner_id#&service_id=#attributes.service_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['id'] = 'member_info';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['title'] = '';		
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['type'] = 1;//Custom Tag
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['file'] = '<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-5" module_id="27" action_section="G_SERVICE_ID" action_id="##attributes.service_id##">';
		
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['file'] = '#request.self#?fuseaction=objects.emptypopup_ajax_list_extra_pages&type=2&service_id=#attributes.service_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['id'] = 'get_related_services';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['title'] = '#lang_array.item[127]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['file'] = '#request.self#?fuseaction=call.popup_ajax_service_history&service_id=#attributes.service_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['id'] = 'History_Service';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][0]['title'] = '#lang_array.item[116]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['file'] = '#request.self#?fuseaction=call.popup_ajax_service_related&service_id=#attributes.service_id#&company_id=#get_service_detail.service_company_id#&consumer_id=#get_service_detail.service_consumer_id#&employee_id=#get_service_detail.service_employee_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['id'] = 'service_related';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][1]['title'] = '#lang_array.item[118]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][2]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][2]['file'] = '#request.self#?fuseaction=objects.emptypopup_ajax_project_works&g_service_id=#attributes.service_id#&x_is_related_tree_cat=#x_is_related_tree_cat#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][2]['id'] = 'main_news_menu';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][2][2]['title'] = '#lang_array_main.item[608]#';		
			
		}
	}
	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'call.list_service';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'callcenter/display/list_service.cfm';

	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	// Upd //
	if(isdefined("attributes.event") and not (attributes.event is 'add' or attributes.event is 'list'))
	{
		i = 0;
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
		if (IsDefined("get_service_detail.service_company_id"))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[25]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=call.popup_add_timecost&service_id=#attributes.service_id#&comp_id=#get_service_detail.service_company_id#&partner_id=#get_service_detail.service_partner_id#&subscription_id=#get_service_detail.subscription_id#&is_call_service=1','page_horizantal');";
			i = i + 1;
		}
		else if (IsDefined("get_service_detail.service_consumer_id"))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[25]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=call.popup_add_timecost&service_id=#attributes.service_id#&cons_id=#get_service_detail.service_consumer_id#&subscription_id=#get_service_detail.subscription_id#&is_call_service=1','medium');";
			i = i + 1;
	    }
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=call.popup_service_history&service_id=#attributes.service_id#','list');";
		i = i + 1;
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[123]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=call.popup_list_similar_services&keyword=#URLEncodedFormat(get_service_detail.service_head)#&id=#attributes.service_id#','medium');";
		i = i + 1;
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[59]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=call.popup_add_service_plus&service_id=#attributes.service_id#&plus_type=service','medium');";
		i = i + 1;		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[244]# #lang_array.item[96]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=service.list_service&event=add&call_service_id=#attributes.service_id#";
		i = i + 1;		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[1077]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_opportunity&event=add&service_id=#attributes.service_id#";
		i = i + 1;		
		
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'call.emptypopup_del_service&service_id=#attributes.service_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'callcenter/query/del_service.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'callcenter/query/del_service.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'call.list_service';

		member_type = "";
		member_id = "";
		if (session.ep.our_company_info.sms)
		{
			if (IsDefined("get_service_detail.service_partner_id"))
			{
				 member_type='partner';
				 member_id=get_service_detail.service_partner_id;
			}
			else if (IsDefined("get_service_detail.service_company_id"))
			{
				member_type='company';
				member_id=get_service_detail.service_company_id;
			}
			else if (IsDefined("get_service_detail.service_consumer_id"))
			{
				member_type='consumer';
				member_id=get_service_detail.service_consumer_id;
			}
			else if (IsDefined("get_service_detail.service_employee_id"))
			{
				member_type='employee';
				member_id=get_service_detail.service_employee_id;
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[1178]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=#member_type#&member_id=#member_id#&paper_type=6&paper_id=#attributes.service_id#&sms_action=#fuseaction#','small');";
			i = i + 1;
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = 'eeee#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=call.list_service&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['text'] = 'ffffff#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['href'] = "#request.self#?fuseaction=call.list_service&service_id=#attributes.service_id#&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['target'] = "_blank";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] = 'qqqqqqq#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=call.popup_service_history&service_id=#attributes.service_id#','medium','popup_fuseaction_history')";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}	
</cfscript>
