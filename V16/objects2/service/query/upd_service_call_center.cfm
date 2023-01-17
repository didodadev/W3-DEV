<cflock timeout="20">
	<cftransaction>
        <cfquery name="UPD_CALL_RECORD" datasource="#DSN#">
            UPDATE
                G_SERVICE 
            SET
                SERVICE_HEAD = <cfif len(service_head)>'#service_head#'<cfelse>NULL</cfif>,
                SERVICE_DETAIL = <cfif len(service_detail)>'#service_detail#'<cfelse>NULL</cfif>,
                UPDATE_DATE = #now()#,
                UPDATE_MEMBER = NULL
            WHERE
                SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        </cfquery>
        
        <cfquery name="GET_SERVICE1" datasource="#DSN#">
            SELECT 
                RECORD_DATE,
                APPLY_DATE,
                RECORD_PAR,
                START_DATE,
                FINISH_DATE,
                UPDATE_DATE,
                UPDATE_PAR,
                SERVICECAT_ID,
                SERVICE_STATUS_ID,
                PRIORITY_ID,
                COMMETHOD_ID,
                SERVICE_HEAD,
                SERVICE_DETAIL,
                SERVICE_CONSUMER_ID,
                APPLICATOR_NAME,
                RECORD_DATE,
                RECORD_MEMBER,
                APPLY_DATE
            FROM 
                G_SERVICE 
            WHERE 
                SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        </cfquery>
        <cfif len(get_service1.record_date)>
            <cfset attributes.record_date=createodbcdatetime(get_service1.record_date)>
        </cfif>
        <cfif len(get_service1.apply_date)>
            <cfset attributes.apply_date1=createodbcdatetime(get_service1.apply_date)>
        </cfif>
        <cfif len(get_service1.start_date)>
           <cfset attributes.start_date=createodbcdatetime(get_service1.start_date)>
        </cfif>
        <cfif len(get_service1.finish_date)>
            <cfset attributes.finish_date=createodbcdatetime(get_service1.finish_date)>
        </cfif>
        <cfif len(get_service1.update_date)>
            <cfset attributes.update_date=createodbcdatetime(get_service1.update_date)>
        </cfif>
        <cfquery name="ADD_HISTORY" datasource="#DSN#">
            INSERT INTO
                G_SERVICE_HISTORY
            (
                SERVICE_ACTIVE,
                <!--- <cfif len(get_service1.SALES_CONSUMER_ID)>SALES_CONSUMER_ID,</cfif> --->
                <cfif len(get_service1.servicecat_id)>SERVICECAT_ID,</cfif>
                <!--- <cfif len(get_service1.PRO_SERIAL_NO)>PRO_SERIAL_NO,</cfif> --->
                <!--- <cfif len(get_service1.STOCK_ID)>STOCK_ID,</cfif> --->
                <!--- <cfif len(get_service1.PRODUCT_NAME)>PRODUCT_NAME,</cfif> --->
                <cfif len(get_service1.service_status_id)>SERVICE_STATUS_ID,</cfif>
                <!--- <cfif len(get_service1.GUARANTY_ID)>GUARANTY_ID,</cfif> --->
                <!--- <cfif len(get_service1.GUARANTY_PAGE_NO)>GUARANTY_PAGE_NO,</cfif> --->
                <cfif len(get_service1.priority_id)>PRIORITY_ID,</cfif>
                <cfif len(get_service1.commethod_id)>COMMETHOD_ID,</cfif>
                <cfif len(get_service1.service_head)>SERVICE_HEAD,</cfif>
                <cfif len(get_service1.service_detail)>SERVICE_DETAIL,</cfif>
                <!--- <cfif len(get_service1.SERVICE_ADDRESS)>SERVICE_ADDRESS,</cfif> --->
                <!--- <cfif len(get_service1.SERVICE_COUNTY)>SERVICE_COUNTY,</cfif>
                <cfif len(get_service1.SERVICE_CITY)>SERVICE_CITY,</cfif> --->
                <cfif len(get_service1.service_consumer_id)>SERVICE_CONSUMER_ID,</cfif>
                <!--- <cfif len(get_service1.SALES_PARTNER_ID)>SALES_PARTNER_ID,</cfif>
                <cfif len(get_service1.SALES_EMPLOYEE_ID)>SALES_EMPLOYEE_ID,</cfif> --->
                <!--- <cfif len(get_service1.NOTES)>NOTES,</cfif> --->
                <cfif len(get_service1.record_date)>RECORD_DATE,</cfif>
                <cfif len(get_service1.record_member)>RECORD_MEMBER,</cfif>
                <cfif len(get_service1.apply_date)>APPLY_DATE,</cfif>
                <cfif len(get_service1.finish_date)>FINISH_DATE,</cfif>
                <cfif len(get_service1.start_date)>START_DATE,</cfif>
                <cfif len(get_service1.update_date)>UPDATE_DATE,</cfif>
                <cfif len(get_service1.update_member)>UPDATE_MEMBER,</cfif>
                <cfif len(get_service1.record_par)>RECORD_PAR,</cfif>
                <cfif len(get_service1.update_par)>UPDATE_PAR,</cfif>
                <!--- <cfif len(get_service1.SERVICE_PRODUCT_ID)>SERVICE_PRODUCT_ID,</cfif> --->
                <!--- <cfif len(get_service1.SERVICE_DEFECT_CODE)>SERVICE_DEFECT_CODE,</cfif> --->
                <!--- GUARANTY_INSIDE, --->
                <cfif len(get_service1.applicator_name)>APPLICATOR_NAME,</cfif>
                <!--- DEPARTMENT_ID,
                LOCATION_ID, --->
                SERVICE_ID
            )
            VALUES
            (
                #get_service1.service_active#,
                <!--- <cfif len(get_service1.sales_consumer_id)>#get_service1.sales_consumer_id#,</cfif> --->
                <cfif len(get_service1.servicecat_id)>#get_service1.servicecat_id#,</cfif>
                <!--- <cfif len(get_service1.pro_serial_no)>'#get_service1.pro_serial_no#',</cfif> --->
                <!--- <cfif len(get_service1.stock_id)>#get_service1.stock_id#,</cfif> --->
                <!--- <cfif len(get_service1.product_name)>'#get_service1.product_name#',</cfif> --->
                <cfif len(get_service1.service_status_id)>#get_service1.service_status_id#,</cfif>
                <!--- <cfif len(get_service1.guaranty_id)>#get_service1.guaranty_id#,</cfif> --->
                <!--- <cfif len(get_service1.guaranty_page_no)>#get_service1.guaranty_page_no#,</cfif> --->
                <cfif len(get_service1.priority_id)>#get_service1.priority_id#,</cfif>
                <cfif len(get_service1.commethod_id)>#get_service1.commethod_id#,</cfif>
                <cfif len(get_service1.service_head)>'#get_service1.service_head#',</cfif>
                <cfif len(get_service1.service_detail)>'#get_service1.service_detail#',</cfif>
                <!--- <cfif len(get_service1.service_address)>'#get_service1.service_address#',</cfif> --->
                <!--- <cfif len(get_service1.service_county)>'#get_service1.service_county#',</cfif>
                <cfif len(get_service1.service_city)>'#get_service1.service_city#',</cfif> --->
                <cfif len(get_service1.service_consumer_id)>#get_service1.service_consumer_id#,</cfif>
                <!--- <cfif len(get_service1.sales_partner_id)>#get_service1.sales_partner_id#,</cfif>
                <cfif len(get_service1.sales_employee_id)>#get_service1.sales_employee_id#,</cfif> --->
                <!--- <cfif len(get_service1.notes)>'#get_service1.notes#',</cfif> --->
                <cfif len(get_service1.record_date)>#attributes.record_date#,</cfif>
                <cfif len(get_service1.record_member)>#get_service1.record_member#,</cfif>
                <cfif len(get_service1.apply_date)>#attributes.apply_date1#,</cfif>
                <cfif len(get_service1.finish_date)>#attributes.finish_date#,</cfif>
                <cfif len(get_service1.start_date)>#attributes.start_date#,</cfif>
                <cfif len(get_service1.update_date)>#attributes.update_date#,</cfif>
                <cfif len(get_service1.update_member)>#get_service1.update_member#,</cfif>
                <cfif len(get_service1.record_par)>#get_service1.record_par#,</cfif>
                <cfif len(get_service1.update_par)>#get_service1.update_par#,</cfif>
                <!--- <cfif len(get_service1.service_product_id)>#get_service1.service_product_id#,</cfif> --->
                <!--- <cfif len(get_service1.service_defect_code)>'#service_defect_code#',</cfif> --->
                <!--- <cfif get_service1.guaranty_inside eq 1>1,<cfelse>0,</cfif> --->
                '#get_service1.applicator_name#',
                <!--- <cfif len(get_service1.department_id)>#get_service1.department_id#,<cfelse>null,</cfif>
                <cfif len(get_service1.location_id)>#get_service1.location_id#,<cfelse>null,</cfif>		 --->	
                #attributes.service_id#
            )
        </cfquery>
        
        <cfquery name="DEL_" datasource="#DSN#">
            DELETE FROM G_SERVICE_APP_ROWS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service1.service_id#">
        </cfquery>
        
        <cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#DSN#">
            SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM G_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.appcat_id#">
        </cfquery>
        <cfset my_counter = 0>
        <cfoutput query="get_service_appcat_sub">		
            <cfset deger = evaluate("attributes.service_sub_cat_id_#service_sub_cat_id#")>
            <cfif len(deger)>
                <cfset my_counter = 1>
                <cfquery name="ADD_SERVICE_STATUS_ROW" datasource="#DSN#">
                    INSERT INTO 
                        G_SERVICE_APP_ROWS
                        (
                            SERVICE_ID,
                            SERVICECAT_ID,
                            SERVICE_SUB_CAT_ID,
                            SERVICE_SUB_STATUS_ID
                        )
                    VALUES
                        (
                            #get_service1.service_id#,
                            #attributes.appcat_id#,
                            #get_service_appcat_sub.service_sub_cat_id#,
                            #deger#
                        )
                </cfquery>
            </cfif>		
        </cfoutput>
        <cfif my_counter eq 0>
            <cfquery name="ADD_SERVICE_STATUS_ROW" datasource="#DSN#">
                INSERT INTO 
                    G_SERVICE_APP_ROWS
                    (
                        SERVICE_ID,
                        SERVICECAT_ID
                    )
                VALUES
                    (
                        #get_service1.service_id#,
                        #ATTRIBUTES.APPCAT_ID#
                    )
            </cfquery>
        </cfif>
	</cftransaction>
</cflock>        
<cflocation url="#request.self#?fuseaction=objects2.upd_service_call_center&service_id=#attributes.service_id#" addtoken="no">
