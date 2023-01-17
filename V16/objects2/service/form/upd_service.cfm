<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="service.add_service">
<cfinclude template="../../../service/query/get_priority.cfm">
<cfinclude template="../query/get_service_substatus.cfm">
<cfinclude template="../query/get_com_method.cfm">
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH_STATUS,
		BRANCH_ID,
		BRANCH_NAME,
		BRANCH_CITY
	FROM
		BRANCH 
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
        IS_INTERNET = 1
	ORDER BY 
		BRANCH_ID
</cfquery>  
<cfquery name="GET_STOCKS_LOCATIONS" datasource="#DSN#">
	SELECT
    	SL.LOCATION_ID,
        SL.COMMENT
    FROM
    	STOCKS_LOCATION SL,
        DEPARTMENT D,
        BRANCH B
    WHERE
    	B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
    	B.IS_INTERNET = 1 AND
    	B.BRANCH_ID = D.BRANCH_ID AND
     	SL.DEPARTMENT_ID = D.DEPARTMENT_ID
</cfquery>
<cfquery name="GET_ACCESSORY" datasource="#DSN3#">
	SELECT ACCESSORY_ID,ACCESSORY FROM SERVICE_ACCESSORY
</cfquery>
<cfquery name="GET_PHY_DAM" datasource="#DSN3#">
	SELECT PHYSICAL_DAMAGE_ID,PHYSICAL_DAMAGE FROM SERVICE_PHYSICAL_DAMAGE
</cfquery>
<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN3#">
	SELECT SERVICECAT_ID,SERVICECAT FROM SERVICE_APPCAT ORDER BY SERVICECAT
</cfquery>
<cfquery name="GET_SALE_ZONES" datasource="#DSN#">
    SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfif x_is_show_service_workgroups eq 1>
    <cfquery name="GET_WORKGROUPS" datasource="#DSN#">
        SELECT 
            WORKGROUP_ID,
            WORKGROUP_NAME
        FROM 
            WORK_GROUP
        WHERE
            STATUS = 1 AND 
            HIERARCHY IS NOT NULL  AND
            ONLINE_HELP = 1
        ORDER BY 
            HIERARCHY
    </cfquery>
</cfif>
<cfif isdefined("attributes.subscrt_id")>
	<cfquery name="GET_SUBSCRIPT_CONRACT" datasource="#DSN3#">
    	SELECT SUBSCRIPTION_ADD_OPTION_ID,PROJECT_ID,PRODUCT_ID,STOCK_ID,SUBSCRIPTION_HEAD,SALES_PARTNER_ID,SALES_COMPANY_ID,SALES_CONSUMER_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscrt_id#">
    </cfquery>
</cfif>
<cfquery name="GET_SERVICE_ADD_OPTION" datasource="#DSN3#">
	SELECT SERVICE_ADD_OPTION_ID,SERVICE_ADD_OPTION_NAME FROM SETUP_SERVICE_ADD_OPTIONS
</cfquery>
<cfquery name="GET_SERVICE_CODE" datasource="#DSN3#">
	SELECT 
		SERVICE_CODE_ID,
		SERVICE_CODE 
	FROM 
		SETUP_SERVICE_CODE
	ORDER BY
		SERVICE_CODE
</cfquery>
<cfquery name="GET_SERVICE_USING_CODE" datasource="#DSN3#">
	SELECT
		SETUP_SERVICE_CODE.SERVICE_CODE_ID,
		SETUP_SERVICE_CODE.SERVICE_CODE
	FROM 
		SERVICE_CODE_ROWS,
		SETUP_SERVICE_CODE
	WHERE 
		SERVICE_CODE_ROWS.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> AND
		SERVICE_CODE_ROWS.SERVICE_CODE_ID = SETUP_SERVICE_CODE.SERVICE_CODE_ID
</cfquery>
<cfset our_get_service_using_code=valuelist(get_service_using_code.service_code_id)>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID,PLATE_CODE FROM SETUP_CITY ORDER BY PRIORITY,CITY_NAME
</cfquery>
<cfif isdefined("attributes.service_id")>
	<!---<cfquery name="GET_SERVICE_DETAIL" datasource="#DSN3#">
		SELECT 
			SERVICE_COMPANY_ID, 
			SERVICE_PARTNER_ID, 
			SERVICECAT_ID, 
			SERVICE_DETAIL, 
			SERVICE_ADDRESS, 
			DOC_NO, 
			PROJECT_ID, 
			COMMETHOD_ID, 
			SERVICE_PRODUCT_ID, 
			PRODUCT_NAME,
			SERVICE_SUBSTATUS_ID,
			PRIORITY_ID,
			SALE_ADD_OPTION_ID,
			ACCESSORY,
			GUARANTY_INSIDE,
			GUARANTY_START_DATE,
			BRING_NAME,
			APPLICATOR_COMP_NAME,
			BRING_TEL_NO,
			BRING_EMAIL,
			SHIP_METHOD,
			STOCK_ID,
			ACCESSORY_DETAIL,
			INSIDE_DETAIL ,
            SERVICECAT_SUB_ID,
            SERVICECAT_SUB_STATUS_ID,
            WORKGROUP_ID,
			SERVICE_CONSUMER_ID,
            BRING_SHIP_METHOD_ID
		FROM 
			SERVICE 
		WHERE 
			SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
	</cfquery>---> 
	<cfif len(get_service_detail.service_company_id)>
		<cfset attributes.company_id = get_service_detail.service_company_id>
		<cfset attributes.member_id = get_service_detail.service_partner_id>
		<cfset attributes.member_type = 'partner'>
	<cfelseif len(get_service_detail.service_consumer_id)>
		<cfset attributes.member_id = get_service_detail.service_consumer_id>
		<cfset attributes.member_type = 'consumer'>
	</cfif>
<!---	<cfset attributes.servicecat_id = get_service_detail.servicecat_id>
--->    <cfset attributes.appcat_id = get_service_detail.servicecat_id>
		<cfset attributes.appcat_sub_id = get_service_detail.servicecat_sub_id>
        <cfset attributes.appcat_sub_status_id = get_service_detail.servicecat_sub_status_id>
	<cfset attributes.service_head = ''>
	<cfset attributes.service_detail = get_service_detail.service_detail>
	<cfset attributes.service_address = get_service_detail.service_address>
	<cfset attributes.kabul_belge_no = get_service_detail.doc_no>
	<cfset attributes.project_id = get_service_detail.project_id>
	<cfset attributes.commethod_id = get_service_detail.commethod_id>
	<!---<cfset get_service_detail.start_date = now()>--->
<cfelseif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
	<cfquery name="GET_HELP_" datasource="#DSN#">
		SELECT
			COMPANY_ID,
			PARTNER_ID,
			CONSUMER_ID,
			SUBJECT,
			SUBSCRIPTION_ID,
			APP_CAT
		FROM
			CUSTOMER_HELP
		WHERE
			CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
	</cfquery>
	<cfif len(get_help_.company_id)>
		<cfset attributes.company_id = get_help_.company_id>
		<cfset attributes.member_id = get_help_.partner_id>
		<cfset attributes.member_type = 'partner'>
	<cfelseif len(get_help_.consumer_id)>
		<cfset attributes.member_id = get_help_.consumer_id>
		<cfset attributes.member_type = 'consumer'>
	</cfif>
	<cfset attributes.subscription_id = get_help_.subscription_id>
	<cfset attributes.service_detail = get_help_.subject>
	<cfset attributes.commethod_id = get_help_.app_cat>
	<cfif len(get_help_.company_id)>
		<cfquery name="GET_COMPANY_" datasource="#DSN#">
			SELECT
				C.FULLNAME,
				C.CITY,
				C.COUNTY,
				C.COUNTRY,
				C.COMPANY_TELCODE,
				C.COMPANY_TEL1,
				C.MOBILTEL,
				C.MOBIL_CODE,
				C.COMPANY_ADDRESS,
				C.COMPANY_POSTCODE,
				C.SEMT,
				CP.COMPANY_PARTNER_EMAIL
			FROM
				COMPANY C,
				COMPANY_PARTNER CP
			WHERE
				C.COMPANY_ID = CP.COMPANY_ID AND
				CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#"> AND
				C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfquery>
		<cfif len(get_company_.city)>
			<cfquery name="GET_CITY_" datasource="#DSN#">
				SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_.city#">
			</cfquery>
		<cfelse>
			<cfset get_city_.city_name=''>
		</cfif>
		<cfif len(get_company_.county)>
			<cfquery name="GET_COUNTY_" datasource="#DSN#">
				SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_.county#">
			</cfquery>
		<cfelse>
			<cfset get_county_.county_name=''>
		</cfif>
		<cfif len(get_company_.country)>
			<cfquery name="GET_COUNTRY_" datasource="#DSN#">
				SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_.country#">
			</cfquery>
		<cfelse>
			<cfset get_country_.country_name=''>
		</cfif>
		<cfset attributes.service_city_id = get_company_.city>
		<cfset attributes.service_county_id = get_company_.county>
		<cfset attributes.bring_tel_no = get_company_.company_telcode&''&get_company_.company_tel1>
		<cfset attributes.bring_mobile_no = get_company_.mobil_code&''&get_company_.mobiltel>
		<cfset attributes.service_address = get_company_.company_address&' '&get_company_.company_postcode&' '&get_company_.semt&' '&get_county_.county_name&' '&get_city_.city_name&' '&get_country_.country_name>
		<cfset attributes.bring_email = get_company_.company_partner_email>
		<cfset attributes.applicator_comp_name = get_company_.fullname>
	<cfelseif len(get_help_.consumer_id)>
		<cfquery name="GET_CONSUMER_" datasource="#DSN#">
			SELECT
				C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FULLNAME,
				C.WORK_CITY_ID,
				C.WORK_COUNTY_ID,
				C.WORK_COUNTRY_ID,
				C.CONSUMER_WORKTELCODE,
				C.CONSUMER_WORKTEL,
				C.MOBIL_CODE,
				C.MOBILTEL,
				C.WORKADDRESS,
				C.WORKPOSTCODE,
				C.WORKSEMT,
				C.CONSUMER_EMAIL
			FROM
				CONSUMER C
			WHERE
				C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
		</cfquery>
		<cfif len(get_consumer_.work_city_id)>
			<cfquery name="GET_CITY_" datasource="#DSN#">
				SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer_.work_city_id#">
			</cfquery>
		<cfelse>
			<cfset get_city_.city_name = ''>
		</cfif>
		<cfif len(get_consumer_.work_county_id)>
			<cfquery name="GET_COUNTY_" datasource="#DSN#">
				SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer_.work_county_id#">
			</cfquery>
		<cfelse>
			<cfset get_county_.county_name = ''>
		</cfif>
		<cfif len(get_consumer_.work_country_id)>
			<cfquery name="get_country_" datasource="#DSN#">
				SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer_.work_country_id#">
			</cfquery>
		<cfelse>
			<cfset get_country_.country_name = ''>
		</cfif>
		<cfset attributes.service_city_id = get_consumer_.work_city_id>
		<cfset attributes.service_county_id = get_consumer_.work_county_id>
		<cfset attributes.bring_tel_no = get_consumer_.consumer_worktelcode&''&get_consumer_.consumer_worktel>
		<cfset attributes.bring_mobile_no = get_consumer_.mobil_code&''&get_consumer_.mobiltel>
		<cfset attributes.service_address = get_consumer_.workaddress&' '&get_consumer_.workpostcode&' '&get_consumer_.worksemt&' '&get_county_.county_name&' '&get_city_.city_name&' '&get_country_.country_name>
		<cfset attributes.bring_email = get_consumer_.consumer_email>
		<cfset attributes.applicator_comp_name = get_consumer_.fullname>
	</cfif>
    <cfif len(attributes.subscription_id)>
		<cfquery name="GET_SUB_NO" datasource="#DSN3#">
			SELECT SUBSCRIPTION_NO,PROJECT_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
		</cfquery>
		<cfset attributes.subscription_no = get_sub_no.subscription_no>
		<cfset attributes.project_id = get_sub_no.project_id>
	</cfif>
<cfelseif isdefined("attributes.event_id") and len(attributes.event_id)>
	<cfquery name="GET_EVENT" datasource="#DSN#">
		SELECT
			PROJECT_ID,
			STARTDATE,
			EVENT_HEAD
		FROM
			EVENT
		WHERE
			EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
	</cfquery>
	<cfset attributes.service_head = get_event.event_head>
	<cfif len(get_event.project_id)>
		<cfset attributes.project_id = get_event.project_id>
		<cfquery name="GET_PROJECT_INFO" datasource="#DSN#">
			SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfquery>
		<cfif len(get_project_info.partner_id)>
			<cfset attributes.company_id = get_project_info.company_id>
			<cfset attributes.member_id = get_project_info.partner_id>
			<cfset attributes.member_type = 'partner'>
			<cfquery name="GET_COMPANY_" datasource="#DSN#">
				SELECT
					C.FULLNAME,
					C.CITY,
					C.COUNTY,
					C.COUNTRY,
					C.COMPANY_TELCODE,
					C.COMPANY_TEL1,
					C.MOBILTEL,
					C.MOBIL_CODE,
					C.COMPANY_ADDRESS,
					C.COMPANY_POSTCODE,
					C.SEMT,
					CP.COMPANY_PARTNER_EMAIL
				FROM
					COMPANY C,
					COMPANY_PARTNER CP
				WHERE
					C.COMPANY_ID = CP.COMPANY_ID AND
					CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#"> AND
					C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfquery>
			<cfif len(get_company_.city)>
				<cfquery name="GET_CITY_" datasource="#DSN#">
					SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_.city#">
				</cfquery>
			<cfelse>
				<cfset get_city_.city_name = ''>
			</cfif>
			<cfif len(get_company_.county)>
				<cfquery name="GET_COUNTY_" datasource="#DSN#">
					SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_.county#">
				</cfquery>
			<cfelse>
				<cfset get_county_.county_name = ''>
			</cfif>
			<cfif len(get_company_.country)>
				<cfquery name="GET_COUNTRY_" datasource="#DSN#">
					SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_.country#">
				</cfquery>
			<cfelse>
				<cfset get_country_.country_name = ''>
			</cfif>
			<cfset attributes.service_city_id = get_company_.city>
			<cfset attributes.service_county_id = get_company_.county>
			<cfset attributes.bring_tel_no = get_company_.company_telcode&''&get_company_.company_tel1>
			<cfset attributes.bring_mobile_no = get_company_.mobil_code&''&get_company_.mobiltel>
			<cfset attributes.service_address = get_company_.company_address&' '&get_company_.company_postcode&' '&get_company_.semt&' '&get_county_.county_name&' '&get_city_.city_name&' '&get_country_.country_name>
			<cfset attributes.bring_email = get_company_.company_partner_email>
			<cfset attributes.applicator_comp_name = get_company_.fullname>
		<cfelseif len(get_project_info.consumer_id)>
			<cfset attributes.member_id = get_project_info.consumer_id>
			<cfset attributes.member_type = 'consumer'>
			<cfquery name="GET_CONSUMER_" datasource="#DSN#">
				SELECT
					C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FULLNAME,
					C.WORK_CITY_ID,
					C.WORK_COUNTY_ID,
					C.WORK_COUNTRY_ID,
					C.CONSUMER_WORKTELCODE,
					C.CONSUMER_WORKTEL,
					C.MOBIL_CODE,
					C.MOBILTEL,
					C.WORKADDRESS,
					C.WORKPOSTCODE,
					C.WORKSEMT,
					C.CONSUMER_EMAIL
				FROM
					CONSUMER C
				WHERE
					C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
			</cfquery>
			<cfif len(get_consumer_.work_city_id)>
				<cfquery name="GET_CITY_" datasource="#DSN#">
					SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer_.work_city_id#">
				</cfquery>
			<cfelse>
				<cfset get_city_.city_name = ''>
			</cfif>
			<cfif len(get_consumer_.work_county_id)>
				<cfquery name="GET_COUNTY_" datasource="#DSN#">
					SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer_.work_county_id#">
				</cfquery>
			<cfelse>
				<cfset get_county_.county_name = ''>
			</cfif>
			<cfif len(get_consumer_.work_country_id)>
				<cfquery name="GET_COUNTRY_" datasource="#DSN#">
					SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer_.work_country_id#">
				</cfquery>
			<cfelse>
				<cfset get_country_.country_name = ''>
			</cfif>
			<cfset attributes.service_city_id = get_consumer_.work_city_id>
			<cfset attributes.service_county_id = get_consumer_.work_county_id>
			<cfset attributes.bring_tel_no = get_consumer_.consumer_worktelcode&''&get_consumer_.consumer_worktel>
			<cfset attributes.bring_mobile_no = get_consumer_.mobil_code&''&get_consumer_.mobiltel>
			<cfset attributes.service_address = get_consumer_.workaddress&' '&get_consumer_.workpostcode&' '&get_consumer_.worksemt&' '&get_county_.county_name&' '&get_city_.city_name&' '&get_country_.country_name>
			<cfset attributes.bring_email = get_consumer_.consumer_email>
			<cfset attributes.applicator_comp_name = get_consumer_.fullname>
		</cfif>
	</cfif>
<cfelseif isdefined("attributes.call_service_id") and len(attributes.call_service_id)>
	<cfquery name="GET_CALL_SERVICE" datasource="#DSN#">
        SELECT 
            ISNULL(ISNULL(E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME,C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME),CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME) NAME,
            
            G.SERVICE_COMPANY_ID,
            G.PROJECT_ID,
            G.SUBSCRIPTION_ID,
            CM.FULLNAME,
            G.COMMETHOD_ID,
            G.SERVICE_DETAIL,
            G.APPLY_DATE,
            G.SERVICE_CONSUMER_ID,
            G.SERVICE_PARTNER_ID,
            (SELECT SERVICE_SUB_STATUS FROM G_SERVICE_APPCAT_SUB_STATUS GSA WHERE GS.SERVICE_SUB_STATUS_ID=GSA.SERVICE_SUB_STATUS_ID) SERVICE_SUB_STATUS,
            CASE 
				WHEN   G.SERVICE_PARTNER_ID IS NOT NULL THEN  CM.SALES_COUNTY 
				WHEN  G.SERVICE_CONSUMER_ID IS NOT NULL THEN  CM.SALES_COUNTY
			END  SZ_ID
        FROM 
            G_SERVICE G
            LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID=G.SERVICE_EMPLOYEE_ID
            LEFT JOIN CONSUMER C ON C.CONSUMER_ID=G.SERVICE_CONSUMER_ID
            LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID=G.SERVICE_PARTNER_ID
            LEFT JOIN COMPANY CM ON CM.COMPANY_ID=G.SERVICE_COMPANY_ID
            LEFT JOIN G_SERVICE_APP_ROWS GS ON GS.SERVICE_ID=G.SERVICE_ID
        WHERE 
            G.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.call_service_id#">
     </cfquery>
     
	<cfif get_call_service.recordcount>
    	<cfset attributes.company_id=get_call_service.service_company_id>
        <cfset attributes.company_name=get_call_service.fullname>
        <cfif len(get_call_service.service_consumer_id)>
        	<cfset attributes.member_type='consumer'>
            <cfset attributes.member_id=get_call_service.service_consumer_id>
        <cfelseif len(get_call_service.service_partner_id)>
        	<cfset attributes.member_type='partner'>
            <cfset attributes.member_id=get_call_service.service_partner_id>
		</cfif>
        <cfset attributes.service_detail=get_call_service.service_detail>
        <cfset attributes.commethod_id=get_call_service.commethod_id>
        <cfset attributes.service_head=get_call_service.service_sub_status>
        <cfset attributes.sales_zone_id=get_call_service.sz_id>
        <cfset attributes.project_id=get_call_service.project_id>
        <cfset attributes.subscription_id=get_call_service.subscription_id>
        <cfset attributes.start_date1=now()>
     </cfif>
	<cfif len(get_call_service.subscription_id)>
        <cfset attributes.subscription_id = get_call_service.subscription_id>					 	
        <cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
            SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IS NOT NULL AND SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
        </cfquery>
        <cfset attributes.subscription_no = get_subscription.subscription_no>
        <cfquery name="GET_SUBSCRIPTION_ADDRES_INFO" datasource="#DSN3#">
        	SELECT
            	INVOICE_ADDRESS,
                INVOICE_COUNTY_ID,
                INVOICE_CITY_ID
            FROM
            	SUBSCRIPTION_CONTRACT
            WHERE
            	SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_subscription.subscription_no#">
        </cfquery>
        <cfset attributes.service_address = get_subscription_addres_info.invoice_address>
        <cfset attributes.service_city_id = get_subscription_addres_info.invoice_city_id>
        <cfset attributes.service_county_id = get_subscription_addres_info.invoice_county_id>
    </cfif>
</cfif>
<cfsavecontent variable="txt">
    <cfform name="form_git_basvuru" method="post" action="#request.self#?fuseaction=objects2.add_service_act">
        <cfsavecontent variable="message"><cf_get_lang no ='302.Başvuru Nosu Eksik'>!</cfsavecontent>
        <cfinput type="text" name="basvuru_no" id="basvuru_no" required="yes" message="#message#" onFocus="AutoComplete_Create('basvuru_no','SERVICE_NO','SERVICE_NO','get_service','','SERVICE_NO','basvuru_no','form_git_basvuru','3','110');">
        <cf_wrk_search_button is_excel="0">
    </cfform>
</cfsavecontent>

<cfform name="upd_service" method="post" action="#request.self#?fuseaction=objects2.emptypopup_upd_service">
    <input type="hidden" name="service_id" id="service_id" value="<cfoutput>#attributes.service_id#</cfoutput>">
	<input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.pp.our_company_id#</cfoutput>">
	<cfif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
		<input type="hidden" name="cus_help_id" id="cus_help_id" value="<cfoutput>#attributes.cus_help_id#</cfoutput>">
	</cfif>
	<cfif isdefined('attributes.event_id') and len(attributes.event_id)>
		<input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.event_id#</cfoutput>">
	</cfif>
    <cfif isdefined("attributes.call_service_id") and len(attributes.call_service_id)>
    	<input type="hidden" name="call_service_id" id="call_service_id" value="<cfoutput>#attributes.call_service_id#</cfoutput>">
	</cfif>
    <table cellpadding="10" cellspacing="0" style="width:98%;">
    	<tr style="height:15px;">
        	<td align="right">                    	
            	<!-- sil -->
                <cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'>
                <!-- sil -->
            </td>
        </tr>
    	<tr>
        	<td style="vertical-align:top;">
                <table style="width:100%;">
                	<tr>
                    	<td style="width:20%;"></td>
                    	<td><cf_get_lang_main no='1524.Ücretli Servis'><input type="checkbox" name="is_salaried" id="is_salaried"></td>
                    </tr>
                    <tr>
                    	 <cfif len(get_service_detail.subscription_id)>
							<cfset attributes.subscription_id = get_service_detail.subscription_id>					 	
                            <cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
                                SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IS NOT NULL AND SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                            </cfquery>
                        <cfelse>
                            <cfset attributes.subscription_id = "">
                        </cfif>
                    	<td><cf_get_lang_main no='1705.Sistem No'></td>
                        <td><a href="<cfoutput>#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#get_service_detail.subscription_id#</cfoutput>" class="tableyazi"><cfoutput>#get_subscription.subscription_no#</cfoutput></a></td>
                        <td><cf_get_lang no='5.İlgili Bayi'><cf_get_lang_main no='41.Şube'></td>
                        <td>
                        	<input type="hidden" name="other_company_branch_id" id="other_company_branch_id" value="<cfoutput>#get_service_detail.other_company_branch_id#</cfoutput>">	
							<cfif len(get_service_detail.other_company_branch_id) and get_service_detail.other_company_branch_id eq -1>
                                <cfset other_company_branch_name_ = 'Merkez'>
                            <cfelseif len(get_service_detail.other_company_branch_id)>
                                <cfquery name="GET_B_NAME" datasource="#DSN#">
                                    SELECT COMPBRANCH__NAME FROM COMPANY_BRANCH WHERE COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.other_company_branch_id#">
                                </cfquery>
                                <cfset other_company_branch_name_ = '#get_b_name.COMPBRANCH__NAME#'>
                            <cfelse>
                                <cfset other_company_branch_name_ = ''>
                            </cfif>
                            <input type="hidden" name="other_company_branch_company_id" id="other_company_branch_company_id" value="<cfoutput>#get_service_detail.other_company_id#</cfoutput>">
                            <input type="text" name="other_company_branch_name" id="other_company_branch_name" value="<cfoutput>#other_company_branch_name_#</cfoutput>" style="width:167px;" autocomplete="off">
                            <a href="javascript://" onclick="add_adress_other();"><img border="0" src="/images/plus_thin.gif" align="absbottom" id="other_company_branch_name_image"></a>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:20%;"><cf_get_lang_main no='4.Proje'></td>
                        <td>
                           	<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput><cfelseif isdefined("get_subscript_conract.project_id") and len(get_subscript_conract.project_id)><cfoutput>#get_subscript_conract.project_id#</cfoutput></cfif>">
                            <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#get_project_name(attributes.project_id)#</cfoutput><cfelseif isdefined("get_subscript_conract.project_id") and len(get_subscript_conract.project_id)><cfoutput>#get_project_name(get_subscript_conract.project_id)#</cfoutput></cfif>" style="width:150px;" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_projects&project_id=add_service.project_id&project_head=add_service.project_head','list');" title="Proje Seçiniz"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="Proje Seçiniz"></a>
						</td>
                        <td style="width:20%;"><cf_get_lang_main no='245.Ürün'></td>
                        <td>
                            <input type="hidden" name="service_product_id" id="service_product_id" value="<cfif isdefined('attributes.service_id')><cfoutput>#get_service_detail.service_product_id#</cfoutput><cfelseif isdefined("get_subscript_conract.product_id") and len(get_subscript_conract.product_id)><cfoutput>#get_subscript_conract.product_id#</cfoutput></cfif>">
                            <input type="hidden" name="stock_id" id="stock_id" value="<cfif isdefined('attributes.service_id')><cfoutput>#get_service_detail.stock_id#</cfoutput><cfelseif isdefined("get_subscript_conract.stock_id") and len(get_subscript_conract.stock_id)><cfoutput>#get_subscript_conract.stock_id#</cfoutput></cfif>">
                            <input type="hidden" name="is_check_product_serial_number" id="is_check_product_serial_number" value="">
                            <input type="text" name="service_product" id="service_product" value="<cfif isdefined('attributes.service_id') and len(attributes.service_id)><cfoutput>#get_service_detail.product_name#</cfoutput><cfelseif isdefined("get_subscript_conract.product_id") and len(get_subscript_conract.product_id)><cfoutput>#get_product_name(product_id:get_subscript_conract.product_id)#</cfoutput></cfif>" onfocus="AutoComplete_Create('service_product','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID,IS_SERIAL_NO','service_product_id,stock_id,is_check_product_serial_number','','3','200');" autocomplete="off" style="width:164px;">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_products&product_id=upd_service.service_product_id&field_name=upd_service.service_product&field_id=upd_service.stock_id&field_service_serial=upd_service.is_check_product_serial_number','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='45.Müşteri'> *</td>
                        <td>
                            <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">	
                            <input type="text" name="company_name"  id="company_name" style="width:150px;" readonly value="<cfif isdefined("attributes.company_id")><cfoutput>#get_par_info(attributes.company_id,1,1,0)#</cfoutput></cfif>" autocomplete="off">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_list_all_members</cfoutput>&field_city_id=upd_service.service_city_id&field_county_id=upd_service.service_county_id&field_county=upd_service.service_county_name&field_consumer=upd_service.consumer_id&field_comp_id=upd_service.company_id&field_comp_name=upd_service.company_name&field_partner=upd_service.member_id&field_name=upd_service.member_name&field_type=upd_service.member_type&field_member_name=upd_service.applicator_comp_name&field_tel=upd_service.bring_tel_no&field_mail=upd_service.bring_email&field_long_address=upd_service.service_address','list','popup_list_all_pars');"><img src="/images/plus_thin.gif" title="Müşteri Seçiniz" align="absmiddle" border="0"></a>
                        </td>
                        <td><cf_get_lang_main no='225.Seri No'></td>
                        <td>
                            <input type="text" name="service_product_serial" id="service_product_serial" onchange="serino_search();" style="width:164px;">
                            <a href="javascript://" onclick="serino_control();"><img src="/images/serialno.gif" title="<cf_get_lang no='63.Garanti Kapsamı'>" border="0" align="absmiddle"></a>
                        </td>
                    </tr>   
                    <tr>
                        <td><cf_get_lang_main no='166.Yetkili'> *</td>
                        <td>
                            <input type="hidden" name="member_id" id="member_id" value="<cfif isdefined("attributes.member_id")><cfoutput>#attributes.member_id#</cfoutput></cfif>">
                            <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                            <input type="text" name="member_name" id="member_name" value="<cfif isdefined("attributes.member_type") and (attributes.member_type is 'partner')><cfoutput>#get_par_info(attributes.member_id,0,-1,0)#</cfoutput><cfelseif isdefined("attributes.member_type") and (attributes.member_type is 'consumer')><cfoutput>#get_cons_info(attributes.member_id,0,0)#</cfoutput></cfif>" style="width:150px;">
                        </td>
                        <td>Ana Seri No</td>
                        <td>
                            <input type="text" name="main_serial_no" id="main_serial_no" onchange="main_serino_search();" style="width:164px;">
                            <a href="javascript://" onclick="main_serino_control();"><img src="/images/serialno.gif" title="<cf_get_lang no='63.Garanti Kapsamı'>" border="0" align="absmiddle"></a>
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='74.Kategori'> *</td>
                        <td>
                            <select name="appcat_id" id="appcat_id" style="width:150px;" onchange="<cfif x_is_multiple_category_select eq 1>showAltKategori(appcat_id);</cfif>">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_service_appcat">
                                    <option value="#servicecat_id#" <cfif isdefined("get_service_detail") and get_service_detail.servicecat_id eq servicecat_id>selected</cfif>>#servicecat#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td>Başvuru Tarihi</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no='29.Başvuru Tarihi'></cfsavecontent>
                            <!---<cfif isdefined('attributes.service_id') and len(attributes.service_id)>
                                <cfset adate="">
                                <cfset ahour="">
                                <cfset aminute="">
                                <cfinput type="text" name="apply_date" id="apply_date" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" required="yes" message="#message#" style="width:63px;">--->
                            <cfif isdefined("get_service_detail.apply_date") and len(get_service_detail.apply_date)>
                                <cfset adate=date_add("H",session.pp.time_zone,get_service_detail.apply_date)>
                                <cfset ahour=datepart("H",adate)>
                                <cfset aminute=datepart("N",adate)>
                                <cfif aminute mod 5 lt 3 and aminute neq 0>
                                    <cfset aminute = aminute - (aminute mod 5)>
                                <cfelseif aminute mod 5 gte 3 and aminute neq 5>
                                    <cfset aminute = aminute + 5 - (aminute mod 5) >
                                </cfif>
                                <cfinput type="text" name="apply_date" id="apply_date" value="#dateformat(get_service_detail.apply_date,'dd/mm/yyyy')#" validate="eurodate" required="yes" message="#message#" style="width:63px;">
                            <cfelseif isdefined("get_event.startdate") and len(get_event.startdate)>
                                <cfset adate=date_add("H",session.pp.time_zone,get_event.startdate)>
                                <cfset ahour=datepart("H",adate)>
                                <cfset aminute=datepart("N",adate)>
                                <cfif aminute mod 5 lt 3 and aminute neq 0>
                                    <cfset aminute = aminute - (aminute mod 5)>
                                <cfelseif aminute mod 5 gte 3 and aminute neq 5>
                                    <cfset aminute = aminute + 5 - (aminute mod 5) >
                                </cfif>
                                <cfinput type="text" name="apply_date" id="apply_date" value="#dateformat(get_event.startdate,'dd/mm/yyyy')#" validate="eurodate" required="yes" message="#message#" style="width:63px;">
                            <cfelseif isdefined("get_call_service.apply_date") and len(get_call_service.apply_date)>
                                <cfset adate=date_add("H",session.pp.time_zone,get_call_service.apply_date)>
                                <cfset ahour=datepart("H",adate)>
                                <cfset aminute=datepart("N",adate)>
                                <cfif aminute mod 5 lt 3 and aminute neq 0>
                                    <cfset aminute = aminute - (aminute mod 5)>
                                <cfelseif aminute mod 5 gte 3 and aminute neq 5>
                                    <cfset aminute = aminute + 5 - (aminute mod 5) >
                                </cfif>
                                <cfinput type="text" name="apply_date" id="apply_date" value="#dateformat(get_call_service.apply_date,'dd/mm/yyyy')#" validate="eurodate" required="yes" message="#message#" style="width:63px;">
                            <cfelse>
                                <cfset adate=date_add("H",session.pp.time_zone,now())>
                                <cfset ahour=datepart("H",adate)>
                                <cfset aminute=datepart("N",adate)>
                                <cfif aminute mod 5 lt 3 and aminute neq 0>
                                    <cfset aminute = aminute - (aminute mod 5)>
                                <cfelseif aminute mod 5 gte 3 and aminute neq 5>
                                    <cfset aminute = aminute + 5 - (aminute mod 5) >
                                </cfif>
                                <cfinput type="text" name="apply_date" id="apply_date" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" required="yes" message="#message#" style="width:63px;">
                            </cfif>
                            <cf_wrk_date_image date_field="apply_date">
                            <cfoutput>
                            <select name="apply_hour" id="apply_hour" style="width:38px;">
                                <cfloop from="0" to="23" index="app_hour">
                                    <option value="#NumberFormat(app_hour,00)#" <cfif isdefined("ahour") and len(ahour)><cfif app_hour eq ahour>selected</cfif><cfelse><cfif app_hour eq timeformat(date_add("h",session.pp.time_zone,now()),'HH')> selected</cfif></cfif>>#NumberFormat(app_hour,00)#</option>
                                </cfloop>
                            </select>
                            <select name="apply_minute" id="apply_minute" style="width:38px;">
                                <cfloop from="0" to="55" step="5" index="app_min">
                                    <option value="#NumberFormat(app_min,00)#" <cfif isdefined("aminute") and len(aminute)><cfif app_min eq aminute>selected</cfif><cfelse><cfif app_min eq 00>selected</cfif></cfif>>#NumberFormat(app_min,00)#</option>
                                </cfloop>
                            </select>
                            </cfoutput>
                        </td>
                    </tr>                      
                    <cfif (isDefined('attributes.is_servicecat_sub_id') and attributes.is_servicecat_sub_id eq 1) or (isDefined('attributes.is_servicecat_sub_status_id') and attributes.is_servicecat_sub_status_id eq 1)>
                        <cfsavecontent variable="header_"><cf_get_lang no='67.Alt Kategori'></cfsavecontent>
                        <tr>
                        	<cfif isDefined('attributes.is_servicecat_sub_id') and attributes.is_servicecat_sub_id eq 1>
                                <td>Alt Kategori*</td>
                                <td>
                                    <div id="sub_cat_place">
                                    <cfif isdefined("get_service_detail.servicecat_id") and len(get_service_detail.servicecat_id)>
                                        <cfquery name="get_service_sub_appcat" datasource="#dsn3#">
                                             SELECT SERVICECAT_SUB_ID,SERVICECAT_SUB FROM SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = #get_service_detail.servicecat_id# ORDER BY SERVICECAT_SUB ASC
                                        </cfquery>
                                    </cfif>
                                    <select name="appcat_sub_id" id="appcat_sub_id" style="width:150px;" onchange="showAltTreeKategori()">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfif isdefined("get_service_detail.servicecat_id") and len(get_service_detail.servicecat_id)>
                                        <cfoutput query="get_service_sub_appcat">
                                        <option value="#servicecat_sub_id#" <cfif isdefined("get_service_detail") and servicecat_sub_id eq get_service_detail.servicecat_sub_id>selected</cfif>>#servicecat_sub#</option>
                                        </cfoutput>
                                    </cfif>
                                    </select>	
                                    </div>
                                </td>
                            <cfelse>
                                <td colspan="2"></td>
                            </cfif>
                            <cfif isDefined('attributes.is_servicecat_sub_status_id') and attributes.is_servicecat_sub_status_id eq 1>
                                <cfsavecontent variable="header_">Alt Ağaç Kategorisi</cfsavecontent>
                                <td>Alt Ağaç Kategorisi *</td>>
                                <td>
                                    <div id="sub_cat_tree_place">
                                    <cfif isdefined("get_service_detail.SERVICECAT_SUB_ID") and len(get_service_detail.SERVICECAT_SUB_ID)>
                                        <cfquery name="get_service_sub_status_appcat" datasource="#dsn3#">
                                             SELECT SERVICECAT_SUB_STATUS_ID,SERVICECAT_SUB_STATUS FROM SERVICE_APPCAT_SUB_STATUS WHERE SERVICECAT_SUB_ID = #get_service_detail.SERVICECAT_SUB_ID# ORDER BY SERVICECAT_SUB_STATUS ASC
                                        </cfquery>
                                    </cfif>
                                    <select name="appcat_sub_status_id" id="appcat_sub_status_id" style="width:150px;">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfif isdefined("get_service_detail.SERVICECAT_SUB_STATUS_ID") and len(get_service_detail.SERVICECAT_SUB_STATUS_ID)>
                                        <cfoutput query="get_service_sub_status_appcat">
                                        <option value="#servicecat_sub_status_id#" <cfif isdefined("get_service_detail") and servicecat_sub_status_id eq get_service_detail.SERVICECAT_SUB_STATUS_ID>selected</cfif>>#servicecat_sub_status#</option>
                                        </cfoutput>
                                    </cfif>
                                    </select>	
                                    </div>
                                </td>
                            <cfelse>
                                <td colspan="2"></td>
                            </cfif>
                         </tr>
                     </cfif> 
                    <tr>
                        <td><cf_get_lang_main no="1447.Süreç"></td>
                        <td><cf_workcube_process is_upd='0' select_value='#get_service_detail.service_status_id#' process_cat_width='150' is_detail='1'></td>
                        <td></td>
                        <td></td>
						<!---<td>Kabul Tarihi</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang no='142.Kabul Tarihi Hatalı'></cfsavecontent>
                            <!---<cfif isdefined('attributes.service_id') and len(attributes.service_id)>
                                <cfset sdate="">
                                <cfset shour="">
                                <cfset sminute="">
                                <cfinput type="text" name="start_date1" id="start_date1" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" required="yes" message="#message#" style="width:63px;">--->
                            <cfif isdefined("get_service_detail.start_date") and len(get_service_detail.start_date)>
                                <cfset sdate=date_add("H",session.pp.time_zone,get_service_detail.start_date)>
                                <cfset shour=datepart("H",sdate)>
                                <cfset sminute=datepart("N",sdate)>
                                <cfif sminute mod 5 lt 3 and sminute neq 0>
                                    <cfset sminute = sminute - (sminute mod 5)>
                                <cfelseif sminute mod 5 gte 3 and sminute neq 5>
                                    <cfset sminute = sminute + 5 - (sminute mod 5) >
                                </cfif>
                                <cfinput type="text" name="start_date1" id="start_date1" value="#dateformat(get_service_detail.start_date,'dd/mm/yyyy')#" validate="eurodate" required="yes" message="#message#" style="width:63px;">
                            <cfelseif isdefined("get_event.startdate") and len(get_event.startdate)>
                                <cfset sdate=date_add("H",session.pp.time_zone,get_event.startdate)>
                                <cfset shour=datepart("H",sdate)>
                                <cfset sminute=datepart("N",sdate)>
                                <cfif sminute mod 5 lt 3 and sminute neq 0>
                                    <cfset sminute = sminute - (sminute mod 5)>
                                <cfelseif sminute mod 5 gte 3 and sminute neq 5>
                                    <cfset sminute = sminute + 5 - (sminute mod 5) >
                                </cfif>
                                <cfinput type="text" name="start_date1" id="start_date1" value="#dateformat(get_event.startdate,'dd/mm/yyyy')#" validate="eurodate" required="yes" message="#message#" style="width:63px;">
                            <cfelseif isdefined("attributes.call_service_id") and len(attributes.call_service_id)>
                                <cfset sdate=date_add("H",session.pp.time_zone,now())>
                                <cfset shour=datepart("H",sdate)>
                                <cfset sminute=datepart("N",sdate)>
                                <cfif sminute mod 5 lt 3 and sminute neq 0>
                                    <cfset sminute = sminute - (sminute mod 5)>
                                <cfelseif sminute mod 5 gte 3 and sminute neq 5>
                                    <cfset sminute = sminute + 5 - (sminute mod 5) >
                                </cfif>
                                <cfinput type="text" name="start_date1" id="start_date1" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" required="yes" message="#message#" style="width:63px;">
                            <cfelse>
                                <cfset sdate=date_add("H",session.pp.time_zone,now())>
                                <cfset shour=datepart("H",sdate)>
                                <cfset sminute=datepart("N",sdate)>
                                <cfif sminute mod 5 lt 3 and sminute neq 0>
                                    <cfset sminute = sminute - (sminute mod 5)>
                                <cfelseif sminute mod 5 gte 3 and sminute neq 5>
                                    <cfset sminute = sminute + 5 - (sminute mod 5) >
                                </cfif>
                                <cfinput type="text" name="start_date1" id="start_date1" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" required="yes" message="#message#" style="width:63px;"> 
                            </cfif>
                           	<cf_wrk_date_image date_field="start_date1">
                            <cfoutput>
                                <select name="start_hour" id="start_hour" style="width:38px;">
                                    <cfloop from="0" to="23" index="sta_hour">
                                        <option value="#NumberFormat(sta_hour,00)#"<cfif isdefined("shour") and len(shour)><cfif sta_hour eq shour>selected</cfif><cfelse><cfif sta_hour eq timeformat(date_add("h",session.pp.time_zone,now()),'HH')>selected</cfif></cfif>>#NumberFormat(sta_hour,00)#</option>
                                    </cfloop>
                                </select>
                                <select name="start_minute" id="start_minute" style="width:38px;">
                                    <cfloop from="0" to="55" step="5" index="sta_min">
                                        <option value="#NumberFormat(sta_min,00)#" <cfif isdefined("sminute") and len(sminute)><cfif sta_min eq sminute>selected</cfif><cfelse><cfif sta_min eq 00>selected</cfif></cfif>>#NumberFormat(sta_min,00)#</option>
                                    </cfloop>
                                </select>
                            </cfoutput>
						</td> --->
                    </tr>  
                    <tr>
                        <td><cf_get_lang_main no='1561.Alt Aşama'></td>
                        <td>
                            <select name="service_substatus_id" id="service_substatus_id"  style="width:150px;">                            
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_service_substatus">
                                    <option value="#service_substatus_id#" <cfif isdefined("attributes.service_id") and get_service_detail.service_substatus_id eq service_substatus_id>selected</cfif>>#service_substatus#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td><cf_get_lang_main no='1522.Arıza Kodu'></td>
                        <td>
                            <!---<select name="failure_code" id="failure_code" style="width:164px;">
                                <option value="">Seçiniz</option>
                                <cfoutput query="get_service_code">
                                    <option value="#service_code_id#">#service_code#</option>
                                </cfoutput>
                            </select>--->
                            <cf_multiselect_check
                                 name="failure_code"
                                 option_name="service_code"
                                 option_value="service_code_id"
                                 table_name="SETUP_SERVICE_CODE"
                                 data_source="#dsn3#"
                                 value="iif(#len(our_get_service_using_code)#,#our_get_service_using_code#,DE(''))"
                                 width="140">
                        </td>
                    </tr> 
                    <tr>
                        <td><cf_get_lang_main no='73.Öncelik'> *</td>
                        <td>
                            <select name="priority_id" id="priority_id" style="width:150px;">
                                <cfoutput query="get_priority">
                                    <option value="#priority_id#" <cfif isdefined("attributes.service_id") and get_service_detail.priority_id eq priority_id>selected</cfif>>#priority#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td><cf_get_lang_main no='41.Şube'></td>
                        <td>
                            <select name="service_branch_id" id="service_branch_id" style="width:164px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_branch">
                                    <option value="#branch_id#"<cfif get_service_detail.service_branch_id eq branch_id> selected</cfif>>#branch_name#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>   
                    <tr>
                        <td><cf_get_lang_main no='731.İletişim'></td>
                        <td>
                            <select name="commethod_id" id="commethod_id" style="width:150px;">
                                <cfoutput query="get_com_method">
                                    <option value="#commethod_id#" <cfif isdefined("attributes.commethod_id") and len(attributes.commethod_id) and attributes.commethod_id eq commethod_id>selected</cfif>>#commethod#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td>Lokasyon</td>
                        <td>
                            <select name="loc_branch_id" id="loc_branch_id" style="width:164px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_stocks_locations">
                                    <option value="#location_id#" <cfif get_service_detail.service_branch_id eq location_id> selected</cfif>>#comment#</option>
                                </cfoutput>
                            </select>
                        </td> 
                    </tr>  
                    <tr>                      
                        <td>Özel Tanım</td>
                        <td colspan="3">
                            <select name="sales_add_option" id="sales_add_option" style="width:150px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_service_add_option">
                                    <option value="#get_service_add_option.service_add_option_id#" <cfif isdefined("attributes.service_id") and get_service_detail.sale_add_option_id eq get_service_add_option.service_add_option_id>selected<cfelseif isdefined("get_subscript_conract.subscription_add_option_id") and get_subscript_conract.subscription_add_option_id eq get_service_add_option.service_add_option_id> selected</cfif>>#get_service_add_option.service_add_option_name#</option>
                                </cfoutput>
                            </select>
                        </td> 
                    </tr>
                    <tr>
                        <td>Satış Bölgesi</td>
                        <td>
                            <select name="sales_zone_id" id="sales_zone_id" style="width:150px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_sale_zones">
                                    <option value="#sz_id#" <cfif isdefined("attributes.sales_zone_id") and len(attributes.sales_zone_id) and attributes.sales_zone_id eq sz_id>selected</cfif>>#sz_name#</option>
                                </cfoutput>
                            </select>
                        </td>
                        <td>İş Ortağı</td>
                        <td>
                        	<input type="hidden" name="related_company_id" id="related_company_id" value="<cfoutput>#get_service_detail.related_company_id#</cfoutput>">
                        	<input type="text" name="related_company" id="related_company" style="width:167px;" value="<cfif len(get_service_detail.related_company_id)><cfoutput>#get_par_info(get_service_detail.related_company_id,1,1,0)#</cfoutput></cfif>"onfocus="AutoComplete_Create('related_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\'','COMPANY_ID','related_company_id','','3','150');" autocomplete="off">
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=upd_service.related_company_id&field_comp_name=upd_service.related_company&select_list=2','list');return false"><img src="/images/plus_thin.gif" border="0" align="absbottom" id="related_company_image"></a>                      
                        </td>
                    </tr>
                    <!---<cf_object_main_table>
                                <cf_object_table column_width_list="100,160">
                                    <!---<cfsavecontent variable="header_"><cf_get_lang_main no='1524.Ücretli Servis'></cfsavecontent>
                                    <cf_object_tr id="form_ul_is_salaried" Title="#header_#">
                                        <cf_object_td type="text"></cf_object_td>
                                        <cf_object_td><input type="checkbox" name="is_salaried" id="is_salaried"> <cf_get_lang_main no='1524.Ücretli Servis'></cf_object_td>
                                    </cf_object_tr>--->
                                    <cfsavecontent variable="header_"><cf_get_lang_main no='4.Proje'></cfsavecontent>
                                    <cf_object_tr id="form_ul_project_head" Title="#header_#">
                                        <cf_object_td type="text"><cf_get_lang_main no='4.Proje'></cf_object_td>
                                        <cf_object_td>
                                            <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput><cfelseif isdefined("get_subscript_conract.project_id") and len(get_subscript_conract.project_id)><cfoutput>#get_subscript_conract.project_id#</cfoutput></cfif>">
                                            <input name="project_head" type="text" id="project_head"  value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#get_project_name(attributes.project_id)#</cfoutput><cfelseif isdefined("get_subscript_conract.project_id") and len(get_subscript_conract.project_id)><cfoutput>#get_project_name(get_subscript_conract.project_id)#</cfoutput></cfif>" style="width:150px;" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_projects&project_id=add_service.project_id&project_head=add_service.project_head','list');" title="Proje Seçiniz"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="Proje Seçiniz"></a>
                                        </cf_object_td>
                                    </cf_object_tr>
                                    <cfsavecontent variable="header_"><cf_get_lang_main no='45.Müşteri'></cfsavecontent>
                                    <cf_object_tr id="form_ul_company_name" Title="#header_#">
                                        <cf_object_td type="text"><cf_get_lang_main no='45.Müşteri'> *</cf_object_td>
                                        <cf_object_td>
                                            <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">	
                                            <input type="text" name="company_name"  id="company_name" style="width:150px;" readonly value="<cfif isdefined("attributes.company_id")><cfoutput>#get_par_info(attributes.company_id,1,1,0)#</cfoutput></cfif>" autocomplete="off">
                                            <cfif isDefined('session.pp.our_company_info.guaranty_followup') and session.pp.our_company_info.guaranty_followup eq 1>
                                                <cfset str_linke_ait="&field_partner=add_service.member_id&field_consumer=add_service.member_id&field_name=add_service.member_name&field_comp_id=add_service.company_id&field_comp_name=add_service.company_name&field_type=add_service.member_type&field_long_address=add_service.service_address&field_member_name=add_service.applicator_comp_name&field_mail=add_service.bring_email&field_tel=add_service.bring_tel_no"> 
                                                <cfset str_linke_ait_2 = "&field_city_id=add_service.service_city_id&field_county_id=add_service.service_county_id&field_county=add_service.service_county_name&field_mobile_tel=add_service.bring_mobile_no">
                                            <cfelse>
                                                <cfset str_linke_ait="&field_partner=add_service.member_id&field_consumer=add_service.member_id&field_name=add_service.member_name&field_comp_id=add_service.company_id&field_comp_name=add_service.company_name&field_type=add_service.member_type"> 
                                                <cfset str_linke_ait_2 = "">
                                            </cfif>
                                            <cfif is_county_related_company>
                                                <cfset str_linke_ait_2 = str_linke_ait_2 & "&is_county_related_company=1&related_company_id=add_service.related_company_id&related_company=add_service.related_company">
                                            </cfif>
                                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars&#str_linke_ait_2##str_linke_ait#&select_list=8,7&function_name=fill_saleszone'</cfoutput>,'list','popup_list_all_pars');"><img src="/images/plus_thin.gif" title="<cf_get_lang no='230.Basvuru Yapan Seç'>" align="absmiddle" border="0"></a>
                                        </cf_object_td>
                                    </cf_object_tr>
                                    <cfsavecontent variable="header_"><cf_get_lang_main no='166.Yetkili'></cfsavecontent>
                                    <cf_object_tr id="form_ul_member_name" Title="#header_#">
                                        <cf_object_td type="text"><cf_get_lang_main no='166.Yetkili'> *</cf_object_td>
                                        <cf_object_td>
                                            <input type="hidden" name="member_id" id="member_id" value="<cfif isdefined("attributes.member_id")><cfoutput>#attributes.member_id#</cfoutput></cfif>">
                                            <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                            <input type="text" name="member_name" id="member_name" value="<cfif isdefined("attributes.member_type") and (attributes.member_type is 'partner')><cfoutput>#get_par_info(attributes.member_id,0,-1,0)#</cfoutput><cfelseif isdefined("attributes.member_type") and (attributes.member_type is 'consumer')><cfoutput>#get_cons_info(attributes.member_id,0,0)#</cfoutput></cfif>" style="width:150px;"><!--- <cfelseif isdefined("attributes.basvuru_yapan")><cfoutput>#attributes.basvuru_yapan#</cfoutput> --->
                                        </cf_object_td>
                                    </cf_object_tr>
                                    <cfsavecontent variable="header_"><cf_get_lang_main no='74.Kategori'></cfsavecontent>
                                    <cf_object_tr id="form_ul_appcat_id" Title="#header_#">
                                        <cf_object_td type="text"><cf_get_lang_main no='74.Kategori'>*</cf_object_td>
                                        <cf_object_td>
                                            <select name="appcat_id" id="appcat_id" style="width:150px;" onChange="<cfif x_is_multiple_category_select eq 1>showAltKategori(appcat_id);</cfif>">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_service_appcat">
                                                <option value="#servicecat_id#" <cfif isdefined("get_service_detail") and get_service_detail.servicecat_id eq servicecat_id>selected</cfif>>#servicecat#</option>
                                            </cfoutput>
                                            </select>
                                        </cf_object_td>
                                    </cf_object_tr>
                                    <!---<!---<cfif x_is_multiple_category_select eq 1>--->
                                        <cfsavecontent variable="header_"><cf_get_lang no='67.Alt Kategori'></cfsavecontent>
                                        <cf_object_tr id="form_ul_appcat_sub_id" Title="#header_#">
                                            <cf_object_td type="text">Alt Kategori*</cf_object_td>
                                            <cf_object_td>
                                                <div id="sub_cat_place">
                                                <cfif isdefined("get_service_detail.servicecat_id") and len(get_service_detail.servicecat_id)>
                                                    <cfquery name="get_service_sub_appcat" datasource="#dsn3#">
                                                         SELECT SERVICECAT_SUB_ID,SERVICECAT_SUB FROM SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = #get_service_detail.servicecat_id# ORDER BY SERVICECAT_SUB ASC
                                                    </cfquery>
                                                </cfif>
                                                <select name="appcat_sub_id" id="appcat_sub_id" style="width:150px;" onchange="showAltTreeKategori()">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfif isdefined("get_service_detail.servicecat_id") and len(get_service_detail.servicecat_id)>
                                                    <cfoutput query="get_service_sub_appcat">
                                                    <option value="#servicecat_sub_id#" <cfif isdefined("get_service_detail") and servicecat_sub_id eq get_service_detail.servicecat_sub_id>selected</cfif>>#servicecat_sub#</option>
                                                    </cfoutput>
                                                </cfif>
                                                </select>	
                                                </div>
                                            </cf_object_td>
                                        </cf_object_tr>
                                        <cfsavecontent variable="header_"><cf_get_lang no='66.Alt Tree Kategori'></cfsavecontent>
                                        <cf_object_tr id="form_ul_appcat_sub_status_id" Title="#header_#">
                                            <cf_object_td type="text"><cf_get_lang no='66.Alt Tree Kategori'>*</cf_object_td>
                                            <cf_object_td>
                                                <div id="sub_cat_tree_place">
                                                <cfif isdefined("get_service_detail.SERVICECAT_SUB_ID") and len(get_service_detail.SERVICECAT_SUB_ID)>
                                                    <cfquery name="get_service_sub_status_appcat" datasource="#dsn3#">
                                                         SELECT SERVICECAT_SUB_STATUS_ID,SERVICECAT_SUB_STATUS FROM SERVICE_APPCAT_SUB_STATUS WHERE SERVICECAT_SUB_ID = #get_service_detail.SERVICECAT_SUB_ID# ORDER BY SERVICECAT_SUB_STATUS ASC
                                                    </cfquery>
                                                </cfif>
                                                <select name="appcat_sub_status_id" id="appcat_sub_status_id" style="width:150px;">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfif isdefined("get_service_detail.SERVICECAT_SUB_STATUS_ID") and len(get_service_detail.SERVICECAT_SUB_STATUS_ID)>
                                                    <cfoutput query="get_service_sub_status_appcat">
                                                    <option value="#servicecat_sub_status_id#" <cfif isdefined("get_service_detail") and servicecat_sub_status_id eq get_service_detail.SERVICECAT_SUB_STATUS_ID>selected</cfif>>#servicecat_sub_status#</option>
                                                    </cfoutput>
                                                </cfif>
                                                </select>	
                                                </div>
                                            </cf_object_td>
                                        </cf_object_tr>
                                   <!--- </cfif>--->
                                    <cfif x_is_show_service_workgroups eq 1>
                                        <cfsavecontent variable="header_"><cf_get_lang_main no='2021.İş Grupları'></cfsavecontent>
                                        <cf_object_tr id="form_ul_service_work_groups" Title="#header_#">
                                            <cf_object_td type="text"><cf_get_lang_main no='2021.İş Grupları'></cf_object_td>
                                            <cf_object_td>
                                                <select name="service_work_groups" id="service_work_groups" style="width:150px;">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfoutput query="GET_WORKGROUPS">
                                                        <option value="#WORKGROUP_ID#">#WORKGROUP_NAME#</option>
                                                    </cfoutput>
                                                </select>	
                                            </cf_object_td>
                                        </cf_object_tr>
                                    </cfif>--->
                                    <cfsavecontent variable="header_"><cf_get_lang_main no='70.Aşama'></cfsavecontent>
                                    <cf_object_tr id="form_ul_process_stage" Title="#header_#">
                                        <cf_object_td type="text"><cf_get_lang_main no='70.Aşama'>*</cf_object_td>
                                        <cf_object_td><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></cf_object_td>
                                    </cf_object_tr>
                                    <cfsavecontent variable="header_"><cf_get_lang_main no='1561.Alt Aşama'></cfsavecontent>
                                    <cf_object_tr id="form_ul_service_substatus_id" Title="#header_#">
                                        <cf_object_td type="text"><cf_get_lang_main no='1561.Alt Aşama'></cf_object_td>
                                        <cf_object_td>
                                            <select name="service_substatus_id" id="service_substatus_id"  style="width:150px;">                            
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="get_service_substatus">
                                                    <option value="#service_substatus_id#" <cfif isdefined("attributes.service_id") and get_service_detail.service_substatus_id eq service_substatus_id>selected</cfif>>#service_substatus#</option>
                                                </cfoutput>
                                            </select>
                                        </cf_object_td>
                                    </cf_object_tr>
                                    <cfsavecontent variable="header_"><cf_get_lang_main no='73.Öncelik'></cfsavecontent>
                                    <cf_object_tr id="form_ul_priority_id" Title="#header_#">
                                        <cf_object_td type="text"><cf_get_lang_main no='73.Öncelik'> *</cf_object_td>
                                        <cf_object_td>
                                            <select name="priority_id" id="priority_id" style="width:150px;">
                                            <cfoutput query="get_priority">
                                                <option value="#priority_id#" <cfif isdefined("attributes.service_id") and get_service_detail.priority_id eq priority_id>selected</cfif>>#priority#</option>
                                            </cfoutput>
                                            </select>
                                        </cf_object_td>
                                    </cf_object_tr>
                                    <cfsavecontent variable="header_"><cf_get_lang_main no='731.İletişim'></cfsavecontent>
                                    <cf_object_tr id="form_ul_commethod_id" Title="#header_#">
                                        <cf_object_td type="text"><cf_get_lang_main no='731.İletişim'></cf_object_td>
                                        <cf_object_td>
                                            <select name="commethod_id" id="commethod_id" style="width:150px;">
                                            <cfoutput query="get_com_method">
                                                <option value="#commethod_id#" <cfif isdefined("attributes.commethod_id") and len(attributes.commethod_id) and attributes.commethod_id eq commethod_id>selected</cfif>>#commethod#</option>
                                            </cfoutput>
                                            </select>
                                        </cf_object_td>
                                    </cf_object_tr>
                                    <!---<cfif isDefined('session.ep.our_company_info.subscription_contract') and session.ep.our_company_info.subscription_contract eq 1>--->
                                        <cfsavecontent variable="header_">Özel Tanım</cfsavecontent>
                                        <cf_object_tr id="form_ul_sales_add_option" Title="#header_#">
                                            <cf_object_td type="text">Özel Tanım</cf_object_td>
                                            <cf_object_td>
                                                <select name="sales_add_option" id="sales_add_option" style="width:150px;">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfoutput query="get_service_add_option">
                                                        <option value="#get_service_add_option.service_add_option_id#" <cfif isdefined("attributes.service_id") and get_service_detail.SALE_ADD_OPTION_ID eq get_service_add_option.service_add_option_id>selected<cfelseif isdefined("get_subscript_conract.subscription_add_option_id") and get_subscript_conract.subscription_add_option_id eq get_service_add_option.service_add_option_id> selected</cfif>>#get_service_add_option.service_add_option_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </cf_object_td>
                                        </cf_object_tr>
                                    <!---</cfif>--->
                                    <!---<cfif x_is_sales_region eq 1>
                                        <cfsavecontent variable="header_"><cf_get_lang_main no ='247.Satis bolgesi'></cfsavecontent>
                                        <cf_object_tr id="form_ul_sales_zone_id" Title="#header_#">
                                            <cf_object_td type="text"><cf_get_lang_main no ='247.Satis bolgesi'></cf_object_td>
                                            <cf_object_td>
                                                <select name="sales_zone_id" id="sales_zone_id" style="width:150px;">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfoutput query="get_sale_zones">
                                                        <option value="#sz_id#" <cfif isdefined("attributes.sales_zone_id") and len(attributes.sales_zone_id) and attributes.sales_zone_id eq sz_id>selected</cfif>>#sz_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </cf_object_td>
                                        </cf_object_tr>
                                    </cfif>--->
                                </cf_object_table>
                            </cf_object_main_table> --->
                    <tr>
                        <td><cf_get_lang_main no='68.Konu'></td>
                        <td colspan="3">
                            <cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='68.Konu'></cfsavecontent>
                            <cfif isdefined("get_service_detail.service_head")>
                                <cfinput type="text" name="service_head" id="service_head" value="#get_service_detail.service_head#" required="yes" maxlength="100" message="#message#" style="width:447px;">
                            <cfelseif isdefined("get_subscript_conract.subscription_head") and len(get_subscript_conract.subscription_head)>
                                <cfinput type="text" name="service_head" id="service_head" value="#get_subscript_conract.subscription_head#" required="yes" maxlength="100" message="#message#" style="width:447px;">
                            <cfelseif isdefined("get_call_service.service_sub_status") and len(get_call_service.service_sub_status)>
                                <cfinput type="text" name="service_head" id="service_head" value="#get_call_service.service_sub_status#" required="yes" maxlength="100" message="#message#" style="width:447px;">
                            <cfelse>
                                <cfif isdefined("attributes.service_head")>
                                    <cfinput type="text" name="service_head" id="service_head" value="#attributes.service_head#" maxlength="100" style="width:447px;">
                                <cfelseif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
                                    <cfsavecontent variable="service_head_">Etkileşim: <cfoutput>#attributes.cus_help_id#</cfoutput></cfsavecontent>
                                    <cfinput type="text" name="service_head" id="service_head" value="#Left(service_head_,100)#" maxlength="100" style="width:447px;">  
                                <cfelse>
                                    <cfinput type="text" name="service_head" id="service_head" value="" maxlength="100" style="width:447px;">  
                                </cfif>
                            </cfif>
                        </td>
                    </tr>            
                    <tr>
                        <td><cf_get_lang_main no='217.Açıklama'></td>
                        <td colspan="3">
                            <textarea name="service_detail" id="service_detail" style="width:447px;height:90px;"><cfif isdefined("attributes.service_detail")><cfoutput>#attributes.service_detail#</cfoutput></cfif></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td>Aksesuar</td>
                        <td>
                            <cfif x_inventory_select eq 1>
                                <select name="accessory_detail_select" id="accessory_detail_select" multiple="multiple" style="width:150px;">
                                    <cfoutput query="get_accessory">
                                        <option value="#accessory_id#" <cfif listfind(get_service_detail.accessory_detail_select,accessory_id)>selected="selected"</cfif>>#accessory#</option>
                                    </cfoutput>
                                </select>
                            <cfelse>
                                <textarea name="accessory_detail" id="accessory_detail" rows="3" cols="50" style="width:150px;"><cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.accessory_detail#</cfoutput></cfif></textarea>
                            </cfif>
                        </td>
                        <td>Fiziki Hasar</td>
                        <td>
                            <cfif x_physical_damage_select eq 1>
                                <select name="inside_detail_select" id="inside_detail_select" multiple="multiple" style="width:150px;">
                                    <cfoutput query="get_phy_dam">
                                        <option value="#physical_damage_id#" <cfif listfind(get_service_detail.inside_detail_select,physical_damage_id)>selected="selected"</cfif>>#physical_damage#</option>
                                    </cfoutput>
                                </select>
                            <cfelse>
                                <textarea name="inside_detail" id="inside_detail" rows="3" cols="50" style="width:150px;"><cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.inside_detail#</cfoutput></cfif></textarea>
                            </cfif>
                        </td>
                    </tr>
                </table>
            </td>
            <td style="vertical-align:top; width:25%;">
            	<cf_seperator title="Kabul Bilgisi" id="kabul_bilgisi">
            	<table id="kabul_bilgisi">
                    <tr>
                    	<td>Garanti Tarih</td>
                        <td>
                        	<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no='29.Başvuru Tarihi'></cfsavecontent>
                            <cfif isdefined('attributes.service_id') and len(attributes.service_id)>
                                <cfinput type="text" name="guaranty_start_date" id="guaranty_start_date" value="#dateformat(get_service_detail.guaranty_start_date,'dd/mm/yyyy')#" validate="eurodate" message="#message#" style="width:65px;">
                            <cfelse>
                                <cfinput type="text" name="guaranty_start_date" id="guaranty_start_date" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" message="#message#" style="width:65px;">
                            </cfif>
                            <cf_wrk_date_image date_field="guaranty_start_date">
                        </td>
                    </tr>
                    <tr>
                    	<td>Getiren</td>
                        <td><input type="text" name="bring_name" id="bring_name" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.bring_name#</cfoutput></cfif>" maxlength="150" style="width:140px;"></td>
                    </tr>
                    <tr>
                    	<td><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
                        <td>
                        	<cfif isdefined("get_service_detail.bring_ship_method_id") and len(get_service_detail.bring_ship_method_id)>
                                <cfset attributes.ship_method_id=get_service_detail.bring_ship_method_id>
                                <cfinclude template="../../../service/query/get_ship_method.cfm">
                                <input type="hidden" name="bring_ship_method_id" id="bring_ship_method_id" value="<cfoutput>#get_service_detail.bring_ship_method_id#</cfoutput>">
                                <input type="text" name="bring_ship_method_name" id="bring_ship_method_name" value="<cfoutput>#SHIP_METHOD.SHIP_METHOD#</cfoutput>" style="width:140px;" onfocus="AutoComplete_Create('bring_ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','bring_ship_method_id','','3','125');" autocomplete="off">
                            <cfelse>
                            	<input type="hidden" name="bring_ship_method_id" id="bring_ship_method_id" value="">
	                            <input type="text" name="bring_ship_method_name" id="bring_ship_method_name" value="" style="width:140px;" onfocus="AutoComplete_Create('bring_ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','bring_ship_method_id','','3','125');" autocomplete="off">
                            </cfif>
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_ship_methods&field_name=upd_service.bring_ship_method_name&field_id=upd_service.bring_ship_method_id','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                        </td>
                    </tr>
                    <tr>
                    	<td><cf_get_lang_main no='1195.Firma'></td>
                        <td>
                        	<input type="text" name="applicator_comp_name" id="applicator_comp_name" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.applicator_comp_name#</cfoutput><cfelseif isdefined("attributes.applicator_comp_name")><cfoutput>#attributes.applicator_comp_name#</cfoutput></cfif>" maxlength="150" style="width:140px;">
							<cfset str_linke_ait="field_name=upd_service.bring_name&field_comp_name=upd_service.applicator_comp_name&field_tel=upd_service.bring_tel_no&field_mobile_tel=upd_service.bring_mobile_no&field_address=upd_service.service_address&field_city_id=upd_service.service_city_id&field_county_id=upd_service.service_county_id&field_county=upd_service.service_county_name"><!--- &field_long_address --->
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_list_all_members&#str_linke_ait#&select_list=7,8&is_form_submitted=1&keyword='+encodeURIComponent(document.upd_service.applicator_comp_name.value)</cfoutput>,'list','popup_list_all_pars');"><img src="/images/plus_thin.gif" title="<cf_get_lang no ='275.Basvuru Yapan Seç'>" align="absmiddle" border="0"></a>
                        </td>
                    </tr>
                    <tr>
                    	<td><cf_get_lang_main no='87.Telefon'></td>
                        <td>
                        	<input type="text" name="bring_tel_no" id="bring_tel_no" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.bring_tel_no#</cfoutput><cfelseif isdefined("attributes.bring_tel_no")><cfoutput>#attributes.bring_tel_no#</cfoutput></cfif>" maxlength="15" onkeyup="isNumber(this);" style="width:140px;">
                        </td>
                    </tr>
                    <tr>
                    	<td><cf_get_lang_main no='1401.Mobil Telefonu'></td>
                    	<td>
                        	<input type="text" name="bring_mobile_no"  id="bring_mobile_no" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.bring_mobile_no#</cfoutput><cfelseif isdefined("attributes.bring_mobile_no")><cfoutput>#attributes.bring_mobile_no#</cfoutput></cfif>" maxlength="15" onkeyup="isNumber(this);" style="width:140px;">
                        </td>
                    </tr>
                    <tr>
                    	<td><cf_get_lang_main no='16.E-Mail'></td>
                    	<td>
                        	<input type="text" name="bring_email" id="bring_email" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.bring_email#</cfoutput><cfelseif isdefined("attributes.bring_email")><cfoutput>#attributes.bring_email#</cfoutput></cfif>" maxlength="150" style="width:140px;">
                        </td>
                    </tr>
                    <tr>
                    	<td>Servis Adresi</td>
                        <td>
                        	<textarea name="service_address" id="service_address" style="width:140px;height:70px;"><cfif isdefined("attributes.service_address")><cfoutput>#attributes.service_address#</cfoutput></cfif></textarea>
                            <a href="javascript://" onclick="add_adress('1');"><img border="0" src="/images/plus_thin.gif" align="absmiddle"></a>
                        </td>
                    </tr>
                    <tr>
                    	<td><cf_get_lang_main no='1196.İl'></td>
                        <td>
                        	<select name="service_city_id" id="service_city_id" style="width:140px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_city">
                                    <cfif isdefined("get_service_detail.service_city_id")>
                                        <option value="#city_id#" <cfif city_id eq get_service_detail.service_city_id>selected</cfif>>#city_name#</option>
                                    <cfelseif isdefined("attributes.service_city_id")>
                                        <option value="#city_id#" <cfif city_id eq attributes.service_city_id>selected</cfif>>#city_name#</option>
                                    <cfelse>
                                        <option value="#city_id#">#city_name#</option>
                                    </cfif>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr>
                    	<td><cf_get_lang_main no='1226.İlçe'></td>
                        <td>
                   			<cfif (isdefined("get_service_detail.service_county_id") and len(get_service_detail.service_county_id)) or (isdefined("attributes.service_county_id") and len(attributes.service_county_id))>
                                <cfif isdefined("get_service_detail.service_county_id") and len(get_service_detail.service_county_id)>
                                    <cfset county_id_ = get_service_detail.service_county_id>
                                <cfelseif isdefined("attributes.service_county_id") and len(attributes.service_county_id)>
                                    <cfset county_id_ = attributes.service_county_id>
                                </cfif>
                                <cfquery name="GET_COUNTY" datasource="#DSN#">
                                    SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#county_id_#">
                                </cfquery>
                                <cfset county_ = get_county.county_name>
                                <input type="text" name="service_county_name" id="service_county_name" value="<cfoutput>#county_#</cfoutput>" style="width:140px;">
                                <input type="hidden" name="service_county_id" id="service_county_id" value="<cfoutput>#county_id_#</cfoutput>">
                            <cfelse>
                                <input type="text" name="service_county_name" id="service_county_name" value="" style="width:140px;">
                                <input type="hidden" name="service_county_id" id="service_county_id" value="">
                            </cfif>
							<a href="javascript://" onclick="pencere_ac();"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no ='322.Seçiniz'>" border="0" align="absmiddle"></a>
                        </td>
                    </tr>
                    <tr>
                    	<td>Kabul Belge No</td>
                        <td>
                        	<input type="text" name="doc_no" id="doc_no" value="<cfif isdefined('attributes.kabul_belge_no')><cfoutput>#attributes.kabul_belge_no#</cfoutput></cfif>" maxlength="150" style="width:140px;">
                        </td>
                    </tr>
                </table>
                <cf_seperator title="Teslim Bilgisi" id="teslim_bilgisi">
                <table id="teslim_bilgisi">
                	<tr>
                    	<td>Teslim Alacak</td>
                    	<td><input type="text" name="service_county" id="service_county" value="<cfoutput>#get_service_detail.service_county#</cfoutput>" style="width:140px;" maxlength="100"></td>
                    </tr>
                    <tr>
                    	<td>Teslim Belge No</td>
                    	<td><input type="text" name="service_city" id="service_city" value="<cfoutput>#get_service_detail.service_city#</cfoutput>" style="width:140px;"></td>
                    </tr>
                    <tr>
                    	<td>Teslim Adresi</td>
                        <td>
							<cfif isdefined("attributes.bring_detail")>
                                <textarea name="bring_detail" id="bring_detail" style="width:140px;height:70px;"><cfoutput>#attributes.bring_detail#</cfoutput></textarea>
                            <cfelse>
                                <textarea name="bring_detail" id="bring_detail" style="width:140px;height:70px;"></textarea>
                            </cfif>
                            <a href="javascript://" onclick="add_adress('2');" style="vertical-align:top;"><img border="0" src="/images/plus_list.gif" align="top" style="vertical-align:top;"></a>
                        </td>
                    </tr>
                    <tr>
                    	<td><cf_get_lang_main no='1703.Sevk Yöntemi'></td>
                        <td>
                            <input type="hidden" name="ship_method" id="ship_method" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.ship_method#</cfoutput></cfif>">
                            <cfif isdefined("attributes.service_id") and len(get_service_detail.ship_method)>
                                <cfset attributes.ship_method_id=get_service_detail.ship_method>
                                <cfinclude template="../../../service/query/get_ship_method.cfm">
                            </cfif>
                            <input type="text" name="ship_method_name" id="ship_method_name" value="<cfif isdefined("attributes.service_id") and len(get_service_detail.ship_method)><cfoutput>#ship_method.ship_method#</cfoutput></cfif>" style="width:140px;">
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_list_ship_methods&field_name=upd_service.ship_method_name&field_id=upd_service.ship_method','list');" title="Sevk Yöntemi Seçiniz"><img src="/images/plus_thin.gif" align="absmiddle" border="0" alt="Sevk Yöntemi Seçiniz"></a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
        	<td colspan="2"><cf_workcube_buttons is_upd='1' add_function='chk_form()' is_delete='0'></td>
        </tr>
    </table>
</cfform>  

<script type="text/javascript">
	function showAltKategori()	
	{
		var appcat_id_ = document.getElementById('appcat_id').value;
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=service.get_app_sub_cat_ajax&appcat_id="+appcat_id_;
		AjaxPageLoad(send_address,'sub_cat_place',1,'İlişkili Kategoriler');
	}
	
	function showAltTreeKategori()	
	{
		var appcat_sub_id_ = document.getElementById('appcat_sub_id').value;
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=service.get_app_sub_cat_ajax&appcat_sub_id="+appcat_sub_id_;
		AjaxPageLoad(send_address,'sub_cat_tree_place',1,'İlişkili Kategoriler');
	}

	
	function pencere_ac(no)
	{
		if (document.upd_service.service_city_id[document.upd_service.service_city_id.selectedIndex].value == "")
			alert("<cf_get_lang no='14.İlk Olarak İl Seçiniz'>!");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=upd_service.service_county_id&field_name=upd_service.service_county_name&city_id=' + document.getElementById('service_city_id').value,'small');
	}
	
	function serino_control()
	{	
		if(document.upd_service.service_product_serial.value.length==0)
		{
			alert('<cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="225.Seri No">');
		}
		else
		{serino_search();}
	}
	function main_serino_control()
	{	
		if(document.upd_service.main_serial_no.value.length==0)
		{
			alert('<cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no="273.Ana Seri No">');
		}
		else
		{main_serino_search();}
	}
	function serino_search()
	{
		if(document.upd_service.service_product_serial.value.length>0)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_serial_number_result&company_send_form=upd_service&product_serial_no='+upd_service.service_product_serial.value,'list');
		}
	}
	function main_serino_search()
	{
		if(document.upd_service.main_serial_no.value.length>0)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_dsp_serial_number_result&product_serial_no='+upd_service.main_serial_no.value,'list');
		}
	}
	
	function chk_form()
	{
		<cfif isdefined("is_subscription_no") and is_subscription_no eq 2>
			if(document.getElementById('subscription_id').value=="" || document.getElementById('subscription_no').value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1705.Sistem No'>");
				return false;
			}
		</cfif>
		<!---<cfif x_is_multiple_category_select eq 1>
			if(document.add_service.appcat_sub_id.value=="")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='244.Servis'> <cf_get_lang no='67.Alt Kategorisi'>");
				return false;
			}
			if(document.add_service.appcat_sub_status_id.value=="")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='244.Servis'> <cf_get_lang no='66.Alt Tree Kategori'>");
				return false;
			}
		</cfif> --->

		<cfif isDefined('session.ep.our_company_info.guaranty_followup') and session.ep.our_company_info.guaranty_followup eq 1>
			if ((document.upd_service.service_product_id.value != "") && (document.upd_service.is_check_product_serial_number.value == 1) && (document.upd_service.service_product_serial.value == ""))
			{
				alert("<cf_get_lang no='232.Ürün İçin Seri No Takibi Yapılıyor'>! \r <cf_get_lang no='233.Lütfen Seri No Giriniz'>!");
				return false;
			}
		</cfif>
		if((document.getElementById('member_id').value=="" || document.getElementById('member_name').value==""))
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1717.Başvuru Yapan'>");
			document.getElementById('member_name').focus();
			return false;
		}
		
		if(document.getElementById('appcat_id').value=="")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : Servis Kategorisi");
			document.getElementById('appcat_id').focus();
			return false;
		}
		if(document.getElementById('priority_id').value=="")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : Öncelik Kategorisi");
			document.getElementById('priority_id').focus();
			return false;
		}
		if(document.getElementById('start_date1').value !='' && document.getElementById('apply_date').value != '')
		{
			<cfif isdefined("x_apply_start_date") and x_apply_start_date eq 1>
				if (!time_check(upd_service.apply_date, upd_service.apply_hour, upd_service.apply_minute, upd_service.start_date1, upd_service.start_hour, upd_service.start_minute, "Başvuru Kabul Tarihi Başlangıç Tarihinden Önce Olamaz!",1))
				return false;
			<cfelse>
				if (!time_check(upd_service.apply_date, upd_service.apply_hour, upd_service.apply_minute, upd_service.start_date1, upd_service.start_hour, upd_service.start_minute, "Başvuru Kabul Tarihi Başlangıç Tarihinden Önce Olamaz!",0))
				return false;
			</cfif>
		}
		<!---<cfif is_show_other_company eq 1>
			if(document.add_service.other_company_id.value!="" && document.add_service.other_company_name.value!="")
				{
				if(document.add_service.other_company_branch_company_id.value!="" && document.add_service.other_company_branch_id.value!="" && document.add_service.other_company_branch_name.value!="")
					{
					if(document.add_service.other_company_id.value != document.add_service.other_company_branch_company_id.value)
						{
						alert("<cf_get_lang no='15.İlgili Bayi İle İlgili Bayi Şubesi Uyuşmuyor'>!");
						return false;
						}
					}
				}
		</cfif> --->
		//select_add('inside_detail_select');
		//select_add('accessory_detail_select');
		return process_cat_control();
	}
	
	function add_adress(type)
	{
		if(!(upd_service.company_id.value=="") || !(upd_service.member_id.value==""))
		{
			if(type == 1)
				{
				str_adrlink = '&field_long_adres=upd_service.service_address';
				str_adrlink = str_adrlink+'&field_city=upd_service.service_city_id';
				str_adrlink = str_adrlink+'&field_county=upd_service.service_county_id';
				str_adrlink = str_adrlink+'&field_county_name=upd_service.service_county_name';
				<cfif is_county_related_company>
					str_adrlink = str_adrlink+'&is_county_related_company=1';
					str_adrlink = str_adrlink+'&related_company_id=upd_service.related_company_id';
					str_adrlink = str_adrlink+'&related_company=upd_service.related_company';
				</cfif>
				}
			else
				str_adrlink = '&field_long_adres=upd_service.bring_detail';
			
			if(upd_service.company_id.value!="")
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(upd_service.company_name.value)+''+ str_adrlink , 'list');
				return true;
			}
			else
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(upd_service.member_name.value)+''+ str_adrlink , 'list');
				return true;
			}
		}
		else
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no ='45.Müşteri'>");
			return false;
		}
	}
	
	function add_adress_other()
	{
		if(!(upd_service.other_company_id.value==""))
		{
			str_adrlink = '&field_id=upd_service.other_company_branch_company_id';
			str_adrlink = str_adrlink + '&company_branch_id=upd_service.other_company_branch_id';
			str_adrlink = str_adrlink + '&company_branch_name=upd_service.other_company_branch_name';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(upd_service.other_company_name.value)+''+ str_adrlink , 'list');
		}
		else
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no ='5.İlgili Bayi'>");
			return false;
		}
	}
	
	function return_company()
	{
		
		 var emp_id=document.getElementById('task_emp_id').value;
		 if(emp_id!='')
		 {
			 var GET_COMPANY=wrk_safe_query('srv_get_cmpny','dsn',0,emp_id);
			 document.getElementById('task_company_id').value=GET_COMPANY.COMP_ID;
		 }
		else
		return false;
	}
	function select_all(selected_field)
	{
		var m = document.getElementById(selected_field).options.length;
		for(i=0;i<m;i++)
		{
			document.getElementById(selected_field)[i].selected=true
		}
	}	
	<cfif isDefined('session.ep.our_company_info.guaranty_followup') and session.ep.our_company_info.guaranty_followup eq 1><!--- silinmesin musterilerde hizli kayitta seri no alani focus isteniyor --->
		document.getElementById('service_product_serial').focus();
	</cfif>
</script>
