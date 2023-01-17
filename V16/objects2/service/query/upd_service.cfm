<cfset list="',""">
<cfset list2=" , ">
<cfif isDefined('attributes.service_head')>
	<cfset attributes.service_head = replacelist(attributes.service_head,list,list2)>
</cfif>
<cfif isdefined("attributes.apply_date") and len(attributes.apply_date)>
	<cf_date tarih="attributes.apply_date">
	<cfset attributes.apply_date=date_add("H", attributes.apply_hour - session.pp.time_zone, attributes.apply_date)>
	<cfset attributes.apply_date=date_add("N", attributes.apply_minute,attributes.apply_date)>
</cfif>
<cfif isdefined("attributes.start_date1") and len(attributes.start_date1)>
	<cf_date tarih="attributes.start_date1">
	<cfset attributes.start_date1=date_add("H", attributes.start_hour - session.pp.time_zone,attributes.start_date1)>
	<cfset attributes.start_date1=date_add("N", attributes.start_minute,attributes.start_date1)>
</cfif>
<cfif isdefined("attributes.guaranty_start_date") and len(attributes.guaranty_start_date)>
	<cf_date tarih="attributes.guaranty_start_date">
</cfif>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>		
        <cfquery name="UPD_SERVICE_STAGE" datasource="#DSN3#">
            UPDATE 
                SERVICE 
            SET 
                <cfif attributes.member_type is 'partner'>
                    SERVICE_CONSUMER_ID = NULL,
                    SERVICE_PARTNER_ID = #attributes.member_id#,
                    SERVICE_COMPANY_ID = #attributes.company_id#,					
                <cfelseif attributes.member_type is 'consumer'>
                    SERVICE_CONSUMER_ID = #attributes.member_id#,
                    SERVICE_PARTNER_ID = NULL,
                    SERVICE_COMPANY_ID = NULL,
                <cfelse>
                    SERVICE_CONSUMER_ID = NULL,
                    SERVICE_PARTNER_ID = NULL,
                    SERVICE_COMPANY_ID = NULL,
                </cfif>
                <cfif isDefined("attributes.main_serial_no")>MAIN_SERIAL_NO = '#attributes.main_serial_no#',</cfif>
                <cfif isDefined('attributes.process_stage')>SERVICE_STATUS_ID = #attributes.process_stage#,</cfif>
                SERVICE_SUBSTATUS_ID = <cfif isDefined('attributes.service_substatus_id') and len(attributes.service_substatus_id)>#attributes.service_substatus_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.sales_add_option")> SALE_ADD_OPTION_ID = <cfif len(attributes.sales_add_option)>#attributes.sales_add_option#<cfelse>NULL</cfif>,</cfif>
                <cfif isDefined('attributes.apply_date')>APPLY_DATE = <cfif len(attributes.apply_date)>#attributes.apply_date#<cfelse>NULL</cfif>,</cfif>
                PRO_SERIAL_NO = <cfif isDefined("attributes.service_product_serial") and len(attributes.service_product_serial)>'#attributes.service_product_serial#'<cfelse>NULL</cfif>,
                SERVICE_BRANCH_ID = <cfif isDefined("attributes.service_branch_id") and len(attributes.service_branch_id)>#attributes.service_branch_id#<cfelse>NULL</cfif>,
                PRODUCT_NAME = <cfif isdefined("attributes.service_product") and len(attributes.service_product) and len(attributes.service_product_id)>'#attributes.service_product#',<cfelseif isdefined("seri_product_name")>'#seri_product_name#',<cfelse>NULL,</cfif>
                SERVICE_PRODUCT_ID = <cfif isDefined("attributes.service_product_id") and len(attributes.service_product_id) and len(attributes.service_product)>#attributes.service_product_id#,<cfelseif isdefined("seri_product_id")>#seri_product_id#,<cfelse>NULL,</cfif>
                <cfif isDefined('attributes.priority_id') and len(attributes.priority_id)>PRIORITY_ID = #attributes.priority_id#,</cfif>
                <cfif isDefined('attributes.appcat_id')>SERVICECAT_ID = #attributes.appcat_id#,</cfif>
                ACCESSORY_DETAIL_SELECT = <cfif isdefined("attributes.accessory_detail_select") and len(attributes.accessory_detail_select)>'#attributes.accessory_detail_select#'<cfelse>NULL</cfif>,
         		INSIDE_DETAIL_SELECT = <cfif isdefined("attributes.inside_detail_select") and len(attributes.inside_detail_select)>'#attributes.inside_detail_select#'<cfelse>NULL</cfif>,
                <cfif isDefined('attributes.start_date1')>START_DATE = <cfif len(attributes.start_date1)>#attributes.start_date1#<cfelse>NULL</cfif>,</cfif>
                <cfif isDefined('attributes.commethod_id') and len(attributes.commethod_id)>COMMETHOD_ID = #attributes.commethod_id#,</cfif>
                <cfif isDefined('attributes.member_name')>APPLICATOR_NAME = '#attributes.member_name#',</cfif>
                BRING_NAME = <cfif isdefined("attributes.bring_name") and len(attributes.bring_name)>'#attributes.bring_name#'<cfelse>NULL</cfif>,
                BRING_SHIP_METHOD_ID = <cfif isdefined("attributes.bring_ship_method_name") and len(attributes.bring_ship_method_name) and len(attributes.bring_ship_method_id)>#attributes.bring_ship_method_id#<cfelse>NULL</cfif>,
                APPLICATOR_COMP_NAME = <cfif isDefined("attributes.applicator_comp_name") and len(attributes.applicator_comp_name)>'#attributes.applicator_comp_name#'<cfelse>NULL</cfif>,
                DOC_NO = <cfif isdefined("attributes.doc_no") and len(attributes.doc_no)>'#attributes.doc_no#'<cfelse>NULL</cfif>,
                SERVICE_ADDRESS = <cfif isdefined("attributes.service_address") and len(attributes.service_address)>'#attributes.service_address#'<cfelse>NULL</cfif>,
               	OTHER_COMPANY_ID = #session.pp.company_id#,
                BRING_EMAIL = <cfif isdefined("attributes.bring_email") and len(attributes.bring_email)>'#attributes.bring_email#'<cfelse>NULL</cfif>,
                BRING_MOBILE_NO = <cfif isdefined("attributes.bring_mobile_no") and len(attributes.bring_mobile_no)>'#attributes.bring_mobile_no#'<cfelse>NULL</cfif>,
                BRING_TEL_NO = <cfif isdefined("attributes.bring_tel_no") and len(attributes.bring_tel_no)>'#attributes.bring_tel_no#'<cfelse>NULL</cfif>,
                SERVICE_COUNTY = <cfif isdefined("attributes.service_county") and len(attributes.service_county)>'#attributes.service_county#'<cfelse>NULL</cfif>,
                SERVICE_COUNTY_ID = <cfif isdefined("attributes.service_county_id") and len(attributes.service_county_id) and len(attributes.service_county_name)>#attributes.service_county_id#<cfelse>NULL</cfif>,
                BRING_DETAIL = <cfif isdefined("attributes.bring_detail") and len(attributes.bring_detail)>'#attributes.bring_detail#'<cfelse>NULL</cfif>,
                SHIP_METHOD = <cfif isdefined("attributes.ship_method") and len(attributes.ship_method) and len(attributes.ship_method_name)>#attributes.ship_method#<cfelse>NULL</cfif>,
                <cfif isDefined('attributes.service_head')>SERVICE_HEAD = '#wrk_eval("attributes.service_head")#',</cfif>
                <cfif isDefined('attributes.service_detail')>SERVICE_DETAIL = <cfif len(attributes.service_detail)>'#attributes.service_detail#'<cfelse>NULL</cfif>,</cfif>
                SERVICE_CITY_ID = <cfif isdefined("attributes.service_city_id") and len(attributes.service_city_id)>#attributes.service_city_id#<cfelse>NULL</cfif>,
                SERVICE_CITY =  <cfif isdefined("attributes.service_city") and len(attributes.service_city)>'#attributes.service_city#'<cfelse>NULL</cfif>,
                GUARANTY_START_DATE = <cfif isDefined("attributes.guaranty_start_date") and len(attributes.guaranty_start_date)>#attributes.guaranty_start_date#<cfelse>NULL</cfif>
            WHERE 
                SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        </cfquery>
        <cfquery name="GET_SERVICE1" datasource="#DSN3#">
            SELECT 
                SERVICE_ID,
                SERVICE_HEAD,
                SERVICE_PARTNER_ID,
                SERVICE_CONSUMER_ID,
                SERVICE_EMPLOYEE_ID,
                SERVICE_COMPANY_ID,
                SERVICE_STATUS_ID,
                SERVICE_NO,
                SERVICE_SUBSTATUS_ID,
                SERVICE_ADDRESS,
                SERVICE_CITY_ID,
                SERVICE_CITY,
                SERVICE_COUNTY_ID,
                SERVICE_COUNTY,
                SERVICE_DETAIL,     
                SERVICECAT_ID,
                SERVICECAT_SUB_ID,
                SERVICECAT_SUB_STATUS_ID,
                GUARANTY_START_DATE,
                GUARANTY_PAGE_NO,
                APPLICATOR_NAME, 
                APPLICATOR_COMP_NAME,
                RELATED_COMPANY_ID,
                SERVICE_ACTIVE,
                GUARANTY_ID,
                NOTES,
                SPEC_MAIN_ID,
                SERVICE_DEFECT_CODE,
                OTHER_COMPANY_ID,
                WORKGROUP_ID,
                CALL_SERVICE_ID, 
                STOCK_ID,
                PRO_SERIAL_NO,
                COMMETHOD_ID,
                PRODUCT_NAME,
                MAIN_SERIAL_NO,
                APPLY_DATE,
                START_DATE,
                FINISH_DATE,
                BRING_NAME,
                BRING_TEL_NO,
                BRING_MOBILE_NO,
                BRING_SHIP_METHOD_ID,
                SHIP_METHOD,
                BRING_DETAIL,
                DOC_NO,
                SUBSCRIPTION_ID,
                PROJECT_ID,
                SERVICE_PRODUCT_ID,
                SALE_ADD_OPTION_ID,
                PRIORITY_ID,
                SERVICE_BRANCH_ID,
                ACCESSORY_DETAIL_SELECT,
                INSIDE_DETAIL_SELECT,
                BRING_NAME,
                BRING_EMAIL,
                RECORD_MEMBER,
                RECORD_PAR,
                RECORD_CONS,
                RECORD_DATE,
                UPDATE_MEMBER,
                UPDATE_PAR,
                UPDATE_CONS,
                UPDATE_DATE    
            FROM 
            	SERVICE 
            WHERE 
            	SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        </cfquery>
        <cfif len(get_service1.record_date)><cfset attributes.record_date = createodbcdatetime(get_service1.record_date)></cfif>
        <cfif len(get_service1.apply_date)><cfset attributes.apply_date = createodbcdatetime(get_service1.apply_date)></cfif>
        <cfif len(get_service1.start_date)><cfset attributes.start_date = createodbcdatetime(get_service1.start_date)></cfif>
        <cfif len(get_service1.finish_date)><cfset attributes.finish_date = createodbcdatetime(get_service1.finish_date)></cfif>
        <cfif len(get_service1.update_date)><cfset attributes.update_date = createodbcdatetime(get_service1.update_date)></cfif>
        <cfquery name="ADD_HISTORY" datasource="#DSN3#">
            INSERT INTO
                SERVICE_HISTORY
                (
                    RELATED_COMPANY_ID,
                    SERVICE_ACTIVE,
                    SERVICECAT_ID,
                    PRO_SERIAL_NO,
                    STOCK_ID,
                    PRODUCT_NAME,
                    SERVICE_SUBSTATUS_ID,
                    SERVICE_STATUS_ID,
                    GUARANTY_ID,
                    GUARANTY_PAGE_NO,
                    PRIORITY_ID,
                    COMMETHOD_ID,				
                    SERVICE_HEAD,
                    SERVICE_DETAIL,
                    SERVICE_ADDRESS,
                    SERVICE_COUNTY,
                    SERVICE_CITY,
                    SERVICE_CONSUMER_ID,
                    NOTES,
                    APPLY_DATE,
                    FINISH_DATE,
                    START_DATE,
                    SERVICE_PRODUCT_ID,
                    SPEC_MAIN_ID,
                    SERVICE_DEFECT_CODE,
                    APPLICATOR_NAME,
                    PROJECT_ID,
                    RECORD_DATE,
                    RECORD_MEMBER,
                    UPDATE_DATE,
                    UPDATE_MEMBER,
                    RECORD_PAR,
                    UPDATE_PAR,
                    SHIP_METHOD,
                    OTHER_COMPANY_ID,
                    SERVICE_COUNTY_ID,
                    SERVICE_CITY_ID,
                    SERVICE_ID,
                    SERVICECAT_SUB_ID,
                    SERVICECAT_SUB_STATUS_ID,
                    WORKGROUP_ID,
                    CALL_SERVICE_ID
                )
                VALUES
                (
                    <cfif len(get_service1.related_company_id)>#get_service1.related_company_id#<cfelse>NULL</cfif>,
                    #get_service1.service_active#,
                    <cfif len(get_service1.servicecat_id)>#get_service1.servicecat_id#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.pro_serial_no)>'#get_service1.pro_serial_no#'<cfelse>NULL</cfif>,
                    <cfif len(get_service1.stock_id)>#get_service1.stock_id#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.product_name)>'#get_service1.product_name#'<cfelse>NULL</cfif>,
                    <cfif len(get_service1.service_substatus_id)>#get_service1.service_substatus_id#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.service_status_id)>#get_service1.service_status_id#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.guaranty_id)>#get_service1.guaranty_id#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.guaranty_page_no)>#get_service1.guaranty_page_no#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.priority_id)>#get_service1.priority_id#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.commethod_id)>#get_service1.commethod_id#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.service_head)>'#wrk_eval("get_service1.service_head")#'<cfelse>NULL</cfif>,
                    <cfif len(get_service1.service_detail)>'#get_service1.service_detail#'<cfelse>NULL</cfif>,
                    <cfif len(get_service1.service_address)>'#get_service1.service_address#'<cfelse>NULL</cfif>,
                    <cfif len(get_service1.service_county)>'#get_service1.service_county#'<cfelse>NULL</cfif>,
                    <cfif len(get_service1.service_city)>'#get_service1.service_city#'<cfelse>NULL</cfif>,
                    <cfif len(get_service1.service_consumer_id)>#get_service1.service_consumer_id#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.notes)>'#get_service1.notes#'<cfelse>NULL</cfif>,
                    <cfif len(get_service1.apply_date)>#createodbcdatetime(get_service1.apply_date)#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.finish_date)>#createodbcdatetime(get_service1.finish_date)#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.start_date)>#createodbcdatetime(get_service1.start_date)#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.service_product_id)>#get_service1.service_product_id#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.spec_main_id)>#get_service1.spec_main_id#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.service_defect_code)>'#get_service1.service_defect_code#'<cfelse>NULL</cfif>,
                    <cfif len(get_service1.applicator_name) and isdefined('get_service1.applicator_name')>'#get_service1.applicator_name#'<cfelse>NULL</cfif>,
                    <cfif len(get_service1.project_id)>#get_service1.project_id#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.record_date)>#createodbcdatetime(get_service1.record_date)#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.record_member)>#get_service1.record_member#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.update_date)>#createodbcdatetime(get_service1.update_date)#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.update_member)>#get_service1.update_member#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.record_par)>#get_service1.record_par#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.update_par)>#get_service1.update_par#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.ship_method)>#get_service1.ship_method#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.other_company_id)>#get_service1.other_company_id#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.service_county_id)>#get_service1.service_county_id#<cfelse>NULL</cfif>,
                    <cfif len(get_service1.service_city_id)>#get_service1.service_city_id#<cfelse>NULL</cfif>,							
                    #get_service1.service_id#,
                    <cfif len(get_service1.servicecat_sub_id)>#get_service1.servicecat_sub_id#<cfelse>null</cfif>,
                    <cfif len(get_service1.servicecat_sub_status_id)>#get_service1.servicecat_sub_status_id#<cfelse>null</cfif>,
                    <cfif len(get_service1.workgroup_id)>#get_service1.workgroup_id#<cfelse>null</cfif>,
                    <cfif len(get_service1.call_service_id)>#get_service1.call_service_id#<cfelse>NULL</cfif>
                )
        </cfquery>
        <cfif isdefined("attributes.failure_code") and listlen(attributes.failure_code)>
            <cfloop list="#attributes.failure_code#" index="m">
                    <cfquery name="ADD_SERVICE_CODE_ROWS" datasource="#dsn3#">
                        INSERT INTO
                            SERVICE_CODE_ROWS
                        (
                            SERVICE_CODE_ID,
                            SERVICE_ID
                        )				
                        VALUES
                        (
                            #m#,
                            #attributes.service_id#
                        )
                    </cfquery>
            </cfloop>
        </cfif>
        <cfif isdefined("attributes.process_stage")>
            <cf_workcube_process is_upd='1' 
                data_source='#dsn3#' 
                old_process_line='#attributes.old_process_line#'
                process_stage='#attributes.process_stage#' 
                record_member='#session.pp.userid#'
                record_date='#now()#' 
                action_table='SERVICE'
                action_column='SERVICE_ID'
                action_id='#attributes.service_id#' 
                action_page='#request.self#?fuseaction=objects2.upd_service&service_id=#attributes.service_id#' 
                warning_description='Servis : #attributes.service_id#'>
        </cfif>
    </cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=objects2.upd_service&service_id=#attributes.service_id#" addtoken="No">
