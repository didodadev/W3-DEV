<cftransaction>
 	<cfquery name="UPD_SERVICE" datasource="#DSN3#">
		UPDATE
			SERVICE
		SET
			COMMETHOD_ID = 6,
			PRIORITY_ID = 1,
			SERVICE_ACTIVE = 1,
			ISREAD = 0,
			SUBSCRIPTION_ID = <cfif len(attributes.subscription_id)>#attributes.subscription_id#,<cfelse>NULL,</cfif>
			SALE_ADD_OPTION_ID = <cfif len(attributes.sale_add_option_id)>#attributes.sale_add_option_id#,<cfelse>NULL,</cfif>
			SERVICE_COMPANY_ID = <cfif isdefined("session.pp.company_id")>#session.pp.company_id#,<cfelse>NULL,</cfif>
			SERVICE_PARTNER_ID = <cfif isdefined("session.pp.userid")>#session.pp.userid#,<cfelse>NULL,</cfif>
			SERVICE_CONSUMER_ID = <cfif isdefined("session.ww.userid")>#session.ww.userid#,<cfelse>NULL,</cfif>
			<cfif len(appcat_id)> SERVICECAT_ID = #appcat_id#,</cfif>
			APPLICATOR_NAME = <cfif isdefined('session.pp.userid')>'#session.pp.name# #session.pp.surname#',<cfelse>'#session.ww.name# #session.ww.surname#',</cfif>
			SERVICE_DETAIL = '#attributes.service_detail#',
			SERVICE_HEAD = '#attributes.service_head#',
			UPDATE_DATE = #now()#,
			UPDATE_PAR = <cfif isdefined("session.pp.userid")>#session.pp.userid#,<cfelse>NULL,</cfif>
			UPDATE_CONS = <cfif isdefined("session.ww.userid")>#session.ww.userid#,<cfelse>NULL,</cfif>
			SERVICE_ADDRESS = <cfif isdefined("attributes.service_address") and len(attributes.service_address)>'#attributes.service_address#'<cfelse>NULL</cfif>
		WHERE
			SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
	</cfquery>
	<cfquery name="GET_SERVICE1" datasource="#DSN3#">
		SELECT 
        	RECORD_DATE,
            APPLY_DATE,
            START_DATE,
            FINISH_DATE,
            UPDATE_DATE,
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
            SALES_PARTNER_ID,
            SALES_EMPLOYEE_ID,
            NOTES,
            RECORD_DATE,
            RECORD_MEMBER,
            APPLY_DATE,
            FINISH_DATE,
            START_DATE,
            UPDATE_DATE,
            UPDATE_MEMBER,
            RECORD_PAR,
            UPDATE_PAR,
            RECORD_CONS,
            RELATED_COMPANY_ID,
            SERVICE_ACTIVE,
            PROJECT_ID,
            UPDATE_CONS,
            SERVICE_PRODUCT_ID,
            SERVICE_DEFECT_CODE,
            APPLICATOR_NAME 
        FROM 
        	SERVICE 
        WHERE 
        	SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
	</cfquery>
</cftransaction>
	
<cfif len(get_service1.record_date)><cfset attributes.record_date = createodbcdatetime(get_service1.record_date)></cfif>
<cfif len(get_service1.apply_date)><cfset attributes.apply_date = createodbcdatetime(get_service1.apply_date)></cfif>
<cfif len(get_service1.start_date)><cfset attributes.start_date = createodbcdatetime(get_service1.start_date)></cfif>
<cfif len(get_service1.finish_date)><cfset attributes.finish_date = createodbcdatetime(get_service1.finish_date)></cfif>
<cfif len(get_service1.update_date)><cfset attributes.update_date = createodbcdatetime(get_service1.update_date)></cfif>

<cfif get_service1.recordcount>
	<cfquery name="ADD_HISTORY" datasource="#DSN3#">
		INSERT INTO
			SERVICE_HISTORY
		(
			RELATED_COMPANY_ID,
			SERVICE_ACTIVE,
			<cfif len(get_service1.servicecat_id)>SERVICECAT_ID,</cfif>
			<cfif len(get_service1.pro_serial_no)>PRO_SERIAL_NO,</cfif>
			<cfif len(get_service1.stock_id)>STOCK_ID,</cfif>
			<cfif len(get_service1.product_name)>PRODUCT_NAME,</cfif>
			<cfif len(get_service1.service_substatus_id)>SERVICE_SUBSTATUS_ID,</cfif>
			<cfif len(get_service1.service_status_id)>SERVICE_STATUS_ID,</cfif>
			<cfif len(get_service1.guaranty_id)>GUARANTY_ID,</cfif>
			<cfif len(get_service1.guaranty_page_no)>GUARANTY_PAGE_NO,</cfif>
			<cfif len(get_service1.priority_id)>PRIORITY_ID,</cfif>
			<cfif len(get_service1.commethod_id)>COMMETHOD_ID,</cfif>
			<cfif len(get_service1.service_head)>SERVICE_HEAD,</cfif>
			<cfif len(get_service1.service_detail)>SERVICE_DETAIL,</cfif>
			<cfif len(get_service1.service_address)>SERVICE_ADDRESS,</cfif>
			<cfif len(get_service1.service_county)>SERVICE_COUNTY,</cfif>
			<cfif len(get_service1.service_city)>SERVICE_CITY,</cfif>
			<cfif len(get_service1.service_consumer_id)>SERVICE_CONSUMER_ID,</cfif>
			<cfif len(get_service1.sales_partner_id)>SALES_PARTNER_ID,</cfif>
			<cfif len(get_service1.sales_employee_id)>SALES_EMPLOYEE_ID,</cfif>
			<cfif len(get_service1.notes)>NOTES,</cfif>
			<cfif len(get_service1.record_date)>RECORD_DATE,</cfif>
			<cfif len(get_service1.record_member)>RECORD_MEMBER,</cfif>
			<cfif len(get_service1.apply_date)>APPLY_DATE,</cfif>
			<cfif len(get_service1.finish_date)>FINISH_DATE,</cfif>
			<cfif len(get_service1.start_date)>START_DATE,</cfif>
			<cfif len(get_service1.update_date)>UPDATE_DATE,</cfif>
			<cfif len(get_service1.update_member)>UPDATE_MEMBER,</cfif>
			<cfif len(get_service1.record_par)>RECORD_PAR,</cfif>
			<cfif len(get_service1.update_par)>UPDATE_PAR,</cfif>
			<cfif len(get_service1.record_cons)>RECORD_CONS,</cfif>
			<cfif len(get_service1.update_cons)>UPDATE_CONS,</cfif>
			<cfif len(get_service1.service_product_id)>SERVICE_PRODUCT_ID,</cfif>
			<cfif len(get_service1.service_defect_code)>SERVICE_DEFECT_CODE,</cfif>
			PROJECT_ID,
			GUARANTY_INSIDE,
			<cfif len(get_service1.applicator_name)>APPLICATOR_NAME,</cfif>
			SERVICE_ID
		)
		VALUES
		(
			<cfif len(get_service1.related_company_id)>#get_service1.related_company_id#<cfelse>NULL</cfif>,
			#get_service1.service_active#,
			<cfif len(get_service1.servicecat_id)>#get_service1.servicecat_id#,</cfif>
			<cfif len(get_service1.pro_serial_no)>'#get_service1.pro_serial_no#',</cfif>
			<cfif len(get_service1.stock_id)>#get_service1.stock_id#,</cfif>
			<cfif len(get_service1.product_name)>'#get_service1.product_name#',</cfif>
			<cfif len(get_service1.service_substatus_id)>#get_service1.service_substatus_id#,</cfif>
			<cfif len(get_service1.service_status_id)>#get_service1.service_status_id#,</cfif>
			<cfif len(get_service1.guaranty_id)>#get_service1.guaranty_id#,</cfif>
			<cfif len(get_service1.guaranty_page_no)>#get_service1.guaranty_page_no#,</cfif>
			<cfif len(get_service1.priority_id)>#get_service1.priority_id#,</cfif>
			<cfif len(get_service1.commethod_id)>#get_service1.commethod_id#,</cfif>
			<cfif len(get_service1.service_head)>'#get_service1.service_head#',</cfif>
			<cfif len(get_service1.service_detail)>'#get_service1.service_detail#',</cfif>
			<cfif len(get_service1.service_address)>'#get_service1.service_address#',</cfif>
			<cfif len(get_service1.service_county)>'#get_service1.service_county#',</cfif>
			<cfif len(get_service1.service_city)>'#get_service1.service_city#',</cfif>
			<cfif len(get_service1.service_consumer_id)>#get_service1.service_consumer_id#,</cfif>
			<cfif len(get_service1.sales_partner_id)>#get_service1.sales_partner_id#,</cfif>
			<cfif len(get_service1.sales_employee_id)>#get_service1.sales_employee_id#,</cfif>
			<cfif len(get_service1.notes)>'#get_service1.notes#',</cfif>
			<cfif len(get_service1.record_date)>#attributes.record_date#,</cfif>
			<cfif len(get_service1.record_member)>#get_service1.record_member#,</cfif>
			<cfif len(get_service1.apply_date)>#attributes.apply_date#,</cfif>
			<cfif len(get_service1.finish_date)>#attributes.finish_date#,</cfif>
			<cfif len(get_service1.start_date)>#attributes.start_date#,</cfif>
			<cfif len(get_service1.update_date)>#attributes.update_date#,</cfif>
			<cfif len(get_service1.update_member)>#get_service1.update_member#,</cfif>
			<cfif len(get_service1.record_par)>#get_service1.record_par#,</cfif>
			<cfif len(get_service1.update_par)>#get_service1.update_par#,</cfif>
			<cfif len(get_service1.record_cons)>#get_service1.record_cons#,</cfif>
			<cfif len(get_service1.update_cons)>#get_service1.update_cons#,</cfif>
			<cfif len(get_service1.service_product_id)>#get_service1.service_product_id#,</cfif>
			<cfif len(get_service1.service_defect_code)>'#service_defect_code#',</cfif>
			<cfif len(get_service1.project_id)>#get_service1.project_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.guaranty_inside")>1<cfelse>0</cfif>,
			<cfif len(get_service1.applicator_name)>'#get_service1.applicator_name#',</cfif>
			#url.id#
		)
	</cfquery>
</cfif>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=objects2.upd_service&service_id=#url.id#</cfoutput>';
</script>
