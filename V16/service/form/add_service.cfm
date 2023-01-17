<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact="service.add_service">
<cfinclude template="../query/get_priority.cfm">
<cfinclude template="../query/get_service_substatus.cfm">
<cfinclude template="../query/get_com_method.cfm">
<cfinclude template="../query/get_branch.cfm">
<cfquery name="GET_ACCESSORY" datasource="#DSN3#">
	SELECT ACCESSORY_ID,#dsn#.Get_Dynamic_Language(ACCESSORY_ID,'#session.ep.language#','SERVICE_ACCESSORY','ACCESSORY',NULL,NULL,ACCESSORY) AS ACCESSORY FROM SERVICE_ACCESSORY
</cfquery>
<cfquery name="GET_PHY_DAM" datasource="#DSN3#">
	SELECT PHYSICAL_DAMAGE_ID,#dsn#.Get_Dynamic_Language(PHYSICAL_DAMAGE_ID,'#session.ep.language#','SERVICE_PHYSICAL_DAMAGE','PHYSICAL_DAMAGE',NULL,NULL,PHYSICAL_DAMAGE) AS PHYSICAL_DAMAGE FROM SERVICE_PHYSICAL_DAMAGE
</cfquery>
<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN3#">
	SELECT SERVICECAT_ID,#dsn#.Get_Dynamic_Language(SERVICECAT_ID,'#session.ep.language#','SERVICE_APPCAT','SERVICECAT',NULL,NULL,SERVICECAT) AS SERVICECAT FROM SERVICE_APPCAT ORDER BY SERVICECAT
</cfquery>
<cfquery name="get_sale_zones" datasource="#dsn#">
    SELECT SZ_ID,#dsn#.Get_Dynamic_Language(SZ_ID,'#session.ep.language#','SALES_ZONES','SZ_NAME',NULL,NULL,SZ_NAME) AS SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfif x_is_show_service_workgroups eq 1>
    <cfquery name="GET_WORKGROUPS" datasource="#DSN#">
        SELECT 
            WORKGROUP_ID,
            WORKGROUP_NAME
        FROM 
            WORK_GROUP
        WHERE
            STATUS = 1
            AND HIERARCHY IS NOT NULL  AND
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
	SELECT SERVICE_ADD_OPTION_ID,#dsn#.Get_Dynamic_Language(SERVICE_ADD_OPTION_ID,'#session.ep.language#','SETUP_SERVICE_ADD_OPTIONS','SERVICE_ADD_OPTION_NAME',NULL,NULL,SERVICE_ADD_OPTION_NAME) AS SERVICE_ADD_OPTION_NAME FROM SETUP_SERVICE_ADD_OPTIONS
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
<cfif IsDefined("attributes.service_id") and len(attributes.service_id)>
    <cfquery name="Get_Service_Using_Code" datasource="#dsn3#">
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
    <cfset our_get_service_using_code=valuelist(Get_Service_Using_Code.Service_Code_Id)>
<cfelse>
	<cfset our_get_service_using_code = "">
</cfif>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID,PLATE_CODE FROM SETUP_CITY ORDER BY PRIORITY,CITY_NAME
</cfquery>
<cfif isdefined("attributes.service_id")>
	<cfquery name="GET_SERVICE_DETAIL" datasource="#DSN3#">
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
            BRING_SHIP_METHOD_ID,
            SPEC_MAIN_ID
		FROM 
			SERVICE 
		WHERE 
			SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
	</cfquery>
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
		<cfset attributes.appcat_sub_id = get_service_detail.SERVICECAT_SUB_ID>
        <cfset attributes.appcat_sub_status_id = get_service_detail.SERVICECAT_SUB_STATUS_ID>
	<cfset attributes.service_head = ''>
	<cfset attributes.service_detail = get_service_detail.service_detail>
	<cfset attributes.service_address = get_service_detail.service_address>
    <cfset attributes.service_code = our_get_service_using_code>
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
		<cfquery name="get_company_" datasource="#dsn#">
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
				CP.PARTNER_ID = #attributes.member_id# AND
				C.COMPANY_ID = #attributes.company_id#
		</cfquery>
		<cfif len(get_company_.city)>
			<cfquery name="get_city_" datasource="#dsn#">
				SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_company_.city#
			</cfquery>
		<cfelse>
			<cfset get_city_.CITY_NAME=''>
		</cfif>
		<cfif len(get_company_.county)>
			<cfquery name="get_county_" datasource="#dsn#">
				SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_company_.county#
			</cfquery>
		<cfelse>
			<cfset get_county_.COUNTY_NAME=''>
		</cfif>
		<cfif len(get_company_.country)>
			<cfquery name="get_country_" datasource="#dsn#">
				SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_company_.country#
			</cfquery>
		<cfelse>
			<cfset get_country_.COUNTRY_NAME=''>
		</cfif>
		<cfset attributes.service_city_id = get_company_.city>
		<cfset attributes.service_county_id = get_company_.county>
		<cfset attributes.bring_tel_no = get_company_.COMPANY_TELCODE&''&get_company_.COMPANY_TEL1>
		<cfset attributes.bring_mobile_no = get_company_.MOBIL_CODE&''&get_company_.MOBILTEL>
		<cfset attributes.service_address = get_company_.COMPANY_ADDRESS&' '&get_company_.COMPANY_POSTCODE&' '&get_company_.SEMT&' '&get_county_.COUNTY_NAME&' '&get_city_.city_name&' '&get_country_.COUNTRY_NAME>
		<cfset attributes.bring_email = get_company_.COMPANY_PARTNER_EMAIL>
		<cfset attributes.applicator_comp_name = get_company_.FULLNAME>
        <cfset attributes.service_code = our_get_service_using_code>
	<cfelseif len(get_help_.consumer_id)>
		<cfquery name="get_consumer_" datasource="#dsn#">
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
				C.CONSUMER_ID = #attributes.member_id#
		</cfquery>
		<cfif len(get_consumer_.WORK_CITY_ID)>
			<cfquery name="get_city_" datasource="#dsn#">
				SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_consumer_.WORK_CITY_ID#
			</cfquery>
		<cfelse>
			<cfset get_city_.CITY_NAME = ''>
		</cfif>
		<cfif len(get_consumer_.WORK_COUNTY_ID)>
			<cfquery name="get_county_" datasource="#dsn#">
				SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_consumer_.WORK_COUNTY_ID#
			</cfquery>
		<cfelse>
			<cfset get_county_.COUNTY_NAME = ''>
		</cfif>
		<cfif len(get_consumer_.WORK_COUNTRY_ID)>
			<cfquery name="get_country_" datasource="#dsn#">
				SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_consumer_.WORK_COUNTRY_ID#
			</cfquery>
		<cfelse>
			<cfset get_country_.COUNTRY_NAME = ''>
		</cfif>
		<cfset attributes.service_city_id = get_consumer_.WORK_CITY_ID>
		<cfset attributes.service_county_id = get_consumer_.WORK_COUNTY_ID>
		<cfset attributes.bring_tel_no = get_consumer_.CONSUMER_WORKTELCODE&''&get_consumer_.CONSUMER_WORKTEL>
		<cfset attributes.bring_mobile_no = get_consumer_.MOBIL_CODE&''&get_consumer_.MOBILTEL>
		<cfset attributes.service_address = get_consumer_.WORKADDRESS&' '&get_consumer_.WORKPOSTCODE&' '&get_consumer_.WORKSEMT&' '&get_county_.COUNTY_NAME&' '&get_city_.city_name&' '&get_country_.COUNTRY_NAME>
		<cfset attributes.bring_email = get_consumer_.CONSUMER_EMAIL>
        <cfset attributes.service_code = our_get_service_using_code>
		<cfset attributes.applicator_comp_name = get_consumer_.FULLNAME>
	</cfif>
    <cfif len(attributes.subscription_id)>
		<cfquery name="GET_SUB_NO" datasource="#dsn3#">
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
			<cfquery name="get_company_" datasource="#dsn#">
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
					CP.PARTNER_ID = #attributes.member_id# AND
					C.COMPANY_ID = #attributes.company_id#
			</cfquery>
			<cfif len(get_company_.city)>
				<cfquery name="get_city_" datasource="#dsn#">
					SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_company_.city#
				</cfquery>
			<cfelse>
				<cfset get_city_.city_name = ''>
			</cfif>
			<cfif len(get_company_.county)>
				<cfquery name="get_county_" datasource="#dsn#">
					SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_company_.county#
				</cfquery>
			<cfelse>
				<cfset get_county_.county_name = ''>
			</cfif>
			<cfif len(get_company_.country)>
				<cfquery name="get_country_" datasource="#dsn#">
					SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_company_.country#
				</cfquery>
			<cfelse>
				<cfset get_country_.country_name = ''>
			</cfif>
			<cfset attributes.service_city_id = get_company_.city>
			<cfset attributes.service_county_id = get_company_.county>
			<cfset attributes.bring_tel_no = get_company_.COMPANY_TELCODE&''&get_company_.COMPANY_TEL1>
			<cfset attributes.bring_mobile_no = get_company_.MOBIL_CODE&''&get_company_.MOBILTEL>
			<cfset attributes.service_address = get_company_.COMPANY_ADDRESS&' '&get_company_.COMPANY_POSTCODE&' '&get_company_.SEMT&' '&get_county_.COUNTY_NAME&' '&get_city_.city_name&' '&get_country_.COUNTRY_NAME>
			<cfset attributes.bring_email = get_company_.COMPANY_PARTNER_EMAIL>
            <cfset attributes.service_code = our_get_service_using_code>
			<cfset attributes.applicator_comp_name = get_company_.FULLNAME>
		<cfelseif len(get_project_info.consumer_id)>
			<cfset attributes.member_id = get_project_info.consumer_id>
			<cfset attributes.member_type = 'consumer'>
			<cfquery name="get_consumer_" datasource="#dsn#">
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
					C.CONSUMER_ID = #attributes.member_id#
			</cfquery>
			<cfif len(get_consumer_.WORK_CITY_ID)>
				<cfquery name="get_city_" datasource="#dsn#">
					SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_consumer_.WORK_CITY_ID#
				</cfquery>
			<cfelse>
				<cfset get_city_.CITY_NAME = ''>
			</cfif>
			<cfif len(get_consumer_.WORK_COUNTY_ID)>
				<cfquery name="get_county_" datasource="#dsn#">
					SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_consumer_.WORK_COUNTY_ID#
				</cfquery>
			<cfelse>
				<cfset get_county_.COUNTY_NAME = ''>
			</cfif>
			<cfif len(get_consumer_.WORK_COUNTRY_ID)>
				<cfquery name="get_country_" datasource="#dsn#">
					SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_consumer_.WORK_COUNTRY_ID#
				</cfquery>
			<cfelse>
				<cfset get_country_.COUNTRY_NAME = ''>
			</cfif>
			<cfset attributes.service_city_id = get_consumer_.WORK_CITY_ID>
			<cfset attributes.service_county_id = get_consumer_.WORK_COUNTY_ID>
			<cfset attributes.bring_tel_no = get_consumer_.CONSUMER_WORKTELCODE&''&get_consumer_.CONSUMER_WORKTEL>
			<cfset attributes.bring_mobile_no = get_consumer_.MOBIL_CODE&''&get_consumer_.MOBILTEL>
			<cfset attributes.service_address = get_consumer_.WORKADDRESS&' '&get_consumer_.WORKPOSTCODE&' '&get_consumer_.WORKSEMT&' '&get_county_.COUNTY_NAME&' '&get_city_.city_name&' '&get_country_.COUNTRY_NAME>
			<cfset attributes.bring_email = get_consumer_.CONSUMER_EMAIL>
            <cfset attributes.service_code = our_get_service_using_code>
			<cfset attributes.applicator_comp_name = get_consumer_.FULLNAME>
		</cfif>
	</cfif>
<cfelseif isdefined("attributes.call_service_id") and len(attributes.call_service_id)>
	<cfquery name="get_call_service" datasource="#dsn#">
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
            G.SERVICE_ID=#attributes.call_service_id#
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
        <cfset attributes.project_id=get_call_service.PROJECT_ID>
        <cfset attributes.subscription_id=get_call_service.subscription_id>
        <cfset attributes.start_date1=now()>
     </cfif>
	<cfif len(get_call_service.subscription_id)>
        <cfset attributes.subscription_id = get_call_service.subscription_id>					 	
        <cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
            SELECT SUBSCRIPTION_ID,SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IS NOT NULL AND SUBSCRIPTION_ID = #attributes.subscription_id#
        </cfquery>
        <cfset attributes.subscription_no = GET_SUBSCRIPTION.SUBSCRIPTION_NO>
        <cfquery name="GET_SUBSCRIPTION_ADDRES_INFO" datasource="#DSN3#">
        	SELECT
            	INVOICE_ADDRESS,
                INVOICE_COUNTY_ID,
                INVOICE_CITY_ID
            FROM
            	SUBSCRIPTION_CONTRACT
            WHERE
            	SUBSCRIPTION_NO = '#GET_SUBSCRIPTION.SUBSCRIPTION_NO#'
        </cfquery>
        <cfset attributes.service_address = GET_SUBSCRIPTION_ADDRES_INFO.INVOICE_ADDRESS>
        <cfset attributes.service_code = our_get_service_using_code>
        <cfset attributes.service_city_id = GET_SUBSCRIPTION_ADDRES_INFO.INVOICE_CITY_ID>
        <cfset attributes.service_county_id = GET_SUBSCRIPTION_ADDRES_INFO.INVOICE_COUNTY_ID>
    </cfif>
</cfif>
<!---<cfsavecontent variable="txt">
    <cfform name="form_git_basvuru" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_git_basvuru">
        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='302.Başvuru Nosu Eksik'>!</cfsavecontent>
        <cfinput type="text" name="basvuru_no" id="basvuru_no" required="yes" message="#message#" onFocus="AutoComplete_Create('basvuru_no','SERVICE_NO','SERVICE_NO','get_service','','SERVICE_NO','basvuru_no','form_git_basvuru','3','110');">
        <cf_wrk_search_button is_excel="0">
    </cfform>
</cfsavecontent>
<cf_form_box title="#lang_array.item[3]#" right_images="#txt#"><!---Başvuru Ekle--->--->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box closable="0">
	<cfform name="add_service" method="post" action="#request.self#?fuseaction=service.emptypopup_add_service">
		<input type="hidden" name="service_id" id="service_id" value="">
		<input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.ep.company_id#</cfoutput>">
		<cfif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
			<input type="hidden" name="cus_help_id" id="cus_help_id" value="<cfoutput>#attributes.cus_help_id#</cfoutput>">
		</cfif>
		<cfif isdefined('attributes.event_id') and len(attributes.event_id)>
			<input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.event_id#</cfoutput>">
		</cfif>
		<cfif isdefined("attributes.call_service_id") and len(attributes.call_service_id)>
			<input type="hidden" name="call_service_id" id="call_service_id" value="<cfoutput>#attributes.call_service_id#</cfoutput>">
		</cfif>
		<cf_box_elements>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-is_salaried">
					<label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='58936.Ücretli Servis'></span></label>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58936.Ücretli Servis'></cfsavecontent>
					<label class="col col-8 col-xs-12">
						<input type="checkbox" name="is_salaried" id="is_salaried"> <cf_get_lang dictionary_id='58936.Ücretli Servis'>
					</label>
				</div>
				<cfif session.ep.our_company_info.subscription_contract eq 1>
				<div class="form-group" id="item-subscription_no">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='29502.Sistem No'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Sistem No'><cfif isdefined("is_subscription_no") and is_subscription_no eq 2>*</cfif></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="subscription_id" id="subscription_id"  value="<cfif isdefined("attributes.subscription_id")><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
							<input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")><cfoutput>#attributes.subscription_no#</cfoutput></cfif>" onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,MEMBER_NAME','get_subscription','1','SUBSCRIPTION_ID,COMPANY_ID,FULLNAME,MEMBER_ID,MEMBER_TYPE,MEMBER_NAME,PROJECT_ID,PROJECT_HEAD','subscription_id,company_id,company_name,member_id,member_type,member_name,project_id,project_head','','3','164');" autocomplete="off">
							<cfset str_subscription_link="field_project_id=add_service.project_id&field_project_name=add_service.project_head&field_partner=&field_id=add_service.subscription_id&field_no=add_service.subscription_no&field_member_id=add_service.member_id&field_member_name=add_service.member_name&field_member_type=add_service.member_type&field_company_id=add_service.company_id&field_company_name=add_service.company_name&field_ship_address=add_service.service_address&field_ship_city_id=add_service.service_city_id&field_ship_county_id=add_service.service_county_id&field_ship_county_name=add_service.service_county_name">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&#str_subscription_link#'</cfoutput>);"></span>
						</div>
					</div>
				</div>
				</cfif>
				<div class="form-group" id="item-project_head">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput><cfelseif isdefined("get_subscript_conract.project_id") and len(get_subscript_conract.project_id)><cfoutput>#get_subscript_conract.project_id#</cfoutput></cfif>">
							<input name="project_head" type="text" id="project_head"  value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)><cfoutput>#get_project_name(attributes.project_id)#</cfoutput><cfelseif isdefined("get_subscript_conract.project_id") and len(get_subscript_conract.project_id)><cfoutput>#get_project_name(get_subscript_conract.project_id)#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_service.project_id&project_head=add_service.project_head');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-company_name">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57457.Müşteri'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'> *</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">	
							<input type="text" name="company_name"  id="company_name" readonly value="<cfif isdefined("attributes.company_id")><cfoutput>#get_par_info(attributes.company_id,1,1,0)#</cfoutput></cfif>" autocomplete="off">
							<cfset str_linke_ait="&field_partner=add_service.member_id&field_consumer=add_service.member_id&field_name=add_service.member_name&field_comp_id=add_service.company_id&field_comp_name=add_service.company_name&field_type=add_service.member_type#iif(is_county_related_company,DE("&is_county_related_company=1&related_company_id=add_service.related_company_id&related_company=add_service.related_company"),DE(""))#" >
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0#str_linke_ait#&select_list=8,7&is_cari_action=1&function_name=fill_saleszone'</cfoutput>,'list','popup_list_all_pars');" title="<cf_get_lang dictionary_id='41872.Basvuru Yapan Seç'>"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-member_name">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57578.Yetkili'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
					<div class="col col-8 col-xs-12">
						<input type="hidden" name="member_id" id="member_id" value="<cfif isdefined("attributes.member_id")><cfoutput>#attributes.member_id#</cfoutput></cfif>">
						<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
						<input type="text" name="member_name" id="member_name" value="<cfif isdefined("attributes.member_type") and (attributes.member_type is 'partner')><cfoutput>#get_par_info(attributes.member_id,0,-1,0)#</cfoutput><cfelseif isdefined("attributes.member_type") and (attributes.member_type is 'consumer')><cfoutput>#get_cons_info(attributes.member_id,0,0)#</cfoutput></cfif>"><!--- <cfelseif isdefined("attributes.basvuru_yapan")><cfoutput>#attributes.basvuru_yapan#</cfoutput> --->
					</div>
				</div>
				<div class="form-group" id="item-appcat_id">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57486.Kategori'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
					<div class="col col-8 col-xs-12">
						<select name="appcat_id" id="appcat_id" onChange="<cfif x_is_multiple_category_select eq 1>showAltKategori(appcat_id);</cfif>">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_service_appcat">
								<option value="#servicecat_id#" <cfif isdefined("get_service_detail") and get_service_detail.servicecat_id eq servicecat_id>selected</cfif>>#servicecat#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfif x_is_multiple_category_select eq 1>
				<div class="form-group" id="item-appcat_sub_id">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41709.Alt Kategori'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41709.Alt Kategori'>*</label>
					<div class="col col-8 col-xs-12" id="sub_cat_place">
						<cfif isdefined("get_service_detail.servicecat_id") and len(get_service_detail.servicecat_id)>
								<cfquery name="get_service_sub_appcat" datasource="#dsn3#">
									SELECT SERVICECAT_SUB_ID,#dsn#.Get_Dynamic_Language(SERVICECAT_SUB_ID,'#session.ep.language#','SERVICE_APPCAT_SUB','SERVICECAT_SUB',NULL,NULL,SERVICECAT_SUB) AS SERVICECAT_SUB FROM SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = #get_service_detail.servicecat_id# ORDER BY SERVICECAT_SUB ASC
								</cfquery>
							</cfif>
							<select name="appcat_sub_id" id="appcat_sub_id" onchange="showAltTreeKategori()">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfif isdefined("get_service_detail.servicecat_id") and len(get_service_detail.servicecat_id)>
									<cfoutput query="get_service_sub_appcat">
									<option value="#servicecat_sub_id#" <cfif isdefined("get_service_detail") and servicecat_sub_id eq get_service_detail.servicecat_sub_id>selected</cfif>>#servicecat_sub#</option>
									</cfoutput>
								</cfif>
							</select>	
					</div>
				</div>
				<div class="form-group" id="item-appcat_sub_status_id">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41708.Alt Tree Kategori'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41708.Alt Tree Kategori'>*</label>
					<div class="col col-8 col-xs-12" id="sub_cat_tree_place">
						<cfif isdefined("get_service_detail.SERVICECAT_SUB_ID") and len(get_service_detail.SERVICECAT_SUB_ID)>
									<cfquery name="get_service_sub_status_appcat" datasource="#dsn3#">
										SELECT SERVICECAT_SUB_STATUS_ID,#dsn#.Get_Dynamic_Language(SERVICECAT_SUB_STATUS_ID,'#session.ep.language#','SERVICE_APPCAT_SUB_STATUS','SERVICECAT_SUB_STATUS',NULL,NULL,SERVICECAT_SUB_STATUS) AS SERVICECAT_SUB_STATUS FROM SERVICE_APPCAT_SUB_STATUS WHERE SERVICECAT_SUB_ID = #get_service_detail.SERVICECAT_SUB_ID# ORDER BY SERVICECAT_SUB_STATUS ASC
									</cfquery>
								</cfif>
								<select name="appcat_sub_status_id" id="appcat_sub_status_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfif isdefined("get_service_detail.SERVICECAT_SUB_STATUS_ID") and len(get_service_detail.SERVICECAT_SUB_STATUS_ID)>
									<cfoutput query="get_service_sub_status_appcat">
									<option value="#servicecat_sub_status_id#" <cfif isdefined("get_service_detail") and servicecat_sub_status_id eq get_service_detail.SERVICECAT_SUB_STATUS_ID>selected</cfif>>#servicecat_sub_status#</option>
									</cfoutput>
								</cfif>
								</select>	
					</div>
				</div>
				</cfif>
				<cfif x_is_show_service_workgroups eq 1>
				<div class="form-group" id="item-service_work_groups">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='29818.İş Grupları'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29818.İş Grupları'></label>
					<div class="col col-8 col-xs-12">
						<select name="service_work_groups" id="service_work_groups">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="GET_WORKGROUPS">
								<option value="#WORKGROUP_ID#">#WORKGROUP_NAME#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				</cfif>
				<div class="form-group" id="item-process_cat">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id="58859.Süreç"></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
					<div class="col col-8 col-xs-12">
						<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
					</div>
				</div>
				<div class="form-group" id="item-service_substatus_id">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58973.Alt Aşama'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58973.Alt Aşama'></label>
					<div class="col col-8 col-xs-12">
						<select name="service_substatus_id" id="service_substatus_id" >                            
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_service_substatus">
								<option value="#service_substatus_id#" <cfif isdefined("attributes.service_id") and get_service_detail.service_substatus_id eq service_substatus_id>selected</cfif>>#service_substatus#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-priority_id">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57485.Öncelik'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'>*</label>
					<div class="col col-8 col-xs-12">
						<select name="priority_id" id="priority_id">
							<cfoutput query="get_priority">
								<option value="#priority_id#" <cfif isdefined("attributes.service_id") and get_service_detail.priority_id eq priority_id>selected</cfif>>#priority#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-commethod_id">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58143.İletişim'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58143.İletişim'></label>
					<div class="col col-8 col-xs-12">
						<select name="commethod_id" id="commethod_id">
							<cfoutput query="get_com_method">
								<option value="#commethod_id#" <cfif isdefined("attributes.commethod_id") and len(attributes.commethod_id) and attributes.commethod_id eq commethod_id>selected</cfif>>#commethod#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfif session.ep.our_company_info.subscription_contract eq 1>
				<div class="form-group" id="item-sales_add_option">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41655.Özel Tanım'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41655.Özel Tanım'></label>
					<div class="col col-8 col-xs-12">
						<select name="sales_add_option" id="sales_add_option">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_service_add_option">
								<option value="#get_service_add_option.service_add_option_id#" <cfif isdefined("attributes.service_id") and get_service_detail.SALE_ADD_OPTION_ID eq get_service_add_option.service_add_option_id>selected<cfelseif isdefined("get_subscript_conract.subscription_add_option_id") and get_subscript_conract.subscription_add_option_id eq get_service_add_option.service_add_option_id> selected</cfif>>#get_service_add_option.service_add_option_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				</cfif>
				<div class="form-group" id="item-sales_zone_id">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='57659.Satis bolgesi'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57659.Satis bolgesi'></label>
					<div class="col col-8 col-xs-12">
						<select name="sales_zone_id" id="sales_zone_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_sale_zones">
								<option value="#sz_id#" <cfif isdefined("attributes.sales_zone_id") and len(attributes.sales_zone_id) and attributes.sales_zone_id eq sz_id>selected</cfif>>#sz_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-service_head">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57480.Konu'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57480.Konu'></cfsavecontent>
						<cfif isdefined("get_service_detail.service_head")>
							<cfinput type="text" name="service_head" id="service_head" value="#get_service_detail.service_head#" required="yes" maxlength="100" message="#message#">
						<cfelseif isdefined("get_subscript_conract.subscription_head") and len(get_subscript_conract.subscription_head)>
							<cfinput type="text" name="service_head" id="service_head" value="#get_subscript_conract.subscription_head#" required="yes" maxlength="100" message="#message#">
						<cfelseif isdefined("get_call_service.service_sub_status") and len(get_call_service.service_sub_status)>
							<cfinput type="text" name="service_head" id="service_head" value="#get_call_service.service_sub_status#" required="yes" maxlength="100" message="#message#">
						<cfelse>
							<cfif isdefined("attributes.service_head")>
								<cfinput type="text" name="service_head" id="service_head" value="#attributes.service_head#" maxlength="100">
							<cfelseif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
								<cfsavecontent variable="service_head_"><cf_get_lang dictionary_id='49270.Etkileşim'>: <cfoutput>#attributes.cus_help_id#</cfoutput></cfsavecontent>
								<cfinput type="text" name="service_head" id="service_head" value="#Left(service_head_,100)#" maxlength="100">  
							<cfelse>
								<cfinput type="text" name="service_head" id="service_head" value="" maxlength="100">  
							</cfif>
						</cfif>
					</div>
				</div>
				<div class="form-group" id="item-service_detail">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57629.Açıklama'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-8 col-xs-12">
						<textarea name="service_detail" id="service_detail" style="width:440px;height:90px;"><cfif isdefined("attributes.service_detail")><cfoutput>#attributes.service_detail#</cfoutput></cfif></textarea>
					</div>
				</div>
				<cfif session.ep.our_company_info.guaranty_followup eq 1>
				<div class="form-group" id="item-accessory">
					<label class="col col-4 col-xs-12"><input type="checkbox" name="accessory" id="accessory" <cfif isdefined("attributes.service_id") and get_service_detail.accessory eq 1>checked</cfif>><cf_get_lang dictionary_id='41823.Aksesuar'></label>
					<div class="col col-8 col-xs-12">
						<cfif x_inventory_select eq 1>
							<select name="accessory_detail_select" id="accessory_detail_select" multiple="multiple">
								<cfoutput query="get_accessory">
									<option value="#accessory_id#">#accessory#</option>
								</cfoutput>
							</select>
						<cfelse>
							<textarea readonly name="accessory_detail" id="accessory_detail" rows="3" cols="50" style="width:150px;"><cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.accessory_detail#</cfoutput></cfif></textarea>
						</cfif>
					</div>
				</div>
				</cfif>
				<div class="form-group" id="item-info_type_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
					<div class="col col-8 col-xs-12">
						<cf_wrk_add_info info_type_id="-15" upd_page = "0" colspan="9">
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-other_company_id">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41647.İlgili Bayi'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41647.İlgili Bayi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif isdefined("get_service_detail.other_company_id")>
								<input type="hidden" name="other_company_id" id="other_company_id" value="<cfoutput>#get_service_detail.other_company_id#</cfoutput>">	
								<input type="text" name="other_company_name" id="other_company_name" value="<cfoutput>#get_par_info(get_service_detail.other_company_id,1,1,0)#</cfoutput>" onFocus="AutoComplete_Create('other_company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\'','COMPANY_ID','other_company_id','','3','150');" autocomplete="off">
							<cfelse>
								<input type="hidden" name="other_company_id" id="other_company_id" value="">	
								<input type="text" name="other_company_name" id="other_company_name" value="" onFocus="AutoComplete_Create('other_company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\'','COMPANY_ID','other_company_id','','3','150');" autocomplete="off">
							</cfif>
								<cfset str_linke_ait="&field_comp_id=add_service.other_company_id&field_comp_name=add_service.other_company_name"> 
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars&#str_linke_ait#&select_list=7'</cfoutput>);" title="<cf_get_lang dictionary_id='38955.İlgili Şirket'>"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-other_company_branch_company_id">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41647.İlgili Bayi'><cf_get_lang dictionary_id='57453.Şube'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41647.İlgili Bayi'><cf_get_lang dictionary_id='57453.Şube'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif isdefined("get_service_detail.other_company_branch_id")>
								<input type="hidden" name="other_company_branch_id" id="other_company_branch_id" value="<cfoutput>#get_service_detail.other_company_branch_id#</cfoutput>">	
								<cfif len(get_service_detail.other_company_branch_id) and get_service_detail.other_company_branch_id eq -1>
									<cfset other_company_branch_name_ = 'Merkez'>
								<cfelseif len(get_service_detail.other_company_branch_id)>
									<cfquery name="GET_B_NAME" datasource="#DSN#">
										SELECT COMPBRANCH__NAME FROM COMPANY_BRANCH WHERE COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.other_company_branch_id#">
									</cfquery>
									<cfset other_company_branch_name_ = '#get_b_name.compbranch__name#'>
								<cfelse>
									<cfset other_company_branch_name_ = ''>
								</cfif>
								<input type="hidden" name="other_company_branch_company_id" id="other_company_branch_company_id" value="<cfoutput>#get_service_detail.other_company_id#</cfoutput>">
								<input name="other_company_branch_name" type="text" id="other_company_branch_name" value="<cfoutput>#other_company_branch_name_#</cfoutput>" autocomplete="off">
							<cfelse>
								<input type="hidden" name="other_company_branch_company_id" id="other_company_branch_company_id" value="">
								<input type="hidden" name="other_company_branch_id" id="other_company_branch_id" value="">	
								<input name="other_company_branch_name" type="text" id="other_company_branch_name" value="" autocomplete="off">
							</cfif>
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="add_adress_other();"></span>
						</div>
					</div>
				</div>
				<cfif session.ep.our_company_info.guaranty_followup eq 1>
				<div class="form-group" id="item-service_product">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="service_product_cat" id="service_product_cat" onchange="get_service_defect(this.value);" />
							<input type="hidden" name="service_product_id" id="service_product_id" value="<cfif isdefined('attributes.service_id')><cfoutput>#get_service_detail.service_product_id#</cfoutput><cfelseif isdefined("get_subscript_conract.product_id") and len(get_subscript_conract.product_id)><cfoutput>#get_subscript_conract.product_id#</cfoutput></cfif>">
							<input type="hidden" name="stock_id" id="stock_id" value="<cfif isdefined('attributes.service_id')><cfoutput>#get_service_detail.stock_id#</cfoutput><cfelseif isdefined("get_subscript_conract.stock_id") and len(get_subscript_conract.stock_id)><cfoutput>#get_subscript_conract.stock_id#</cfoutput></cfif>">
							<input type="hidden" name="is_check_product_serial_number" id="is_check_product_serial_number" value="">
							<input type="text" name="service_product" id="service_product"  value="<cfif isdefined('attributes.service_id') and len(attributes.service_id)><cfoutput>#get_service_detail.product_name#</cfoutput><cfelseif isdefined("get_subscript_conract.product_id") and len(get_subscript_conract.product_id)><cfoutput>#get_product_name(product_id:get_subscript_conract.product_id)#</cfoutput></cfif>" onfocus="AutoComplete_Create('service_product','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID,PRODUCT_CATID','service_product_id,stock_id,service_product_cat','','3','200',	'get_service_defect()');"> <!--- stock idsi olmasa bile ürün adını kaydediyor. kendi ürünü olmasa bile servisini yapıyor olaiblir diye. --->
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_service.service_product_id&field_name=add_service.service_product&field_id=add_service.stock_id&service_product_cat=add_service.service_product_cat&field_service_serial=add_service.is_check_product_serial_number','list');"></span>
						</div>
					</div>
				</div>
				</cfif>
				<cfif session.ep.our_company_info.guaranty_followup eq 1>
				<div class="form-group" id="item-spect_name">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41663.Ürün Spec'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41663.Ürün Spec'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif isdefined("get_service_detail.spec_main_id") and len(get_service_detail.spec_main_id)>
								<cfquery name="GET_SPEC_NAME" datasource="#DSN3#">
									SELECT SPECT_MAIN_ID, SPECT_MAIN_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.spec_main_id#">
								</cfquery>
								<cfset spec_name_ = get_spec_name.SPECT_MAIN_NAME>
							<cfelse>
								<cfset spec_name_ = "">
							</cfif>
							<input type="hidden" name="spec_main_id" id="spec_main_id" value="<cfif isdefined('attributes.service_id') and len(attributes.service_id)><cfoutput>#get_service_detail.SPEC_MAIN_ID#</cfoutput></cfif>">
							<input name="spect_name" id="spect_name" type="text" value="<cfoutput>#spec_name_#</cfoutput>">
							<span class="input-group-addon icon-ellipsis btnPointer"  onclick="product_control();"></span>
						</div>
					</div>
				</div>
				</cfif>
				<cfif session.ep.our_company_info.guaranty_followup eq 1>
				<div class="form-group" id="item-service_product_serial">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57637.Seri No'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="service_product_serial"  onchange="serino_search();">
							<!--- windowopen('<cfoutput>#request.self#?</cfoutput>fuseaction=objects.popup_dsp_serial_number_result&product_serial_no='+document.add_service.service_product_serial.value,'list') --->
							<span class="input-group-addon icon-ellipsis btnPointer"  onClick="serino_control();" title="<cf_get_lang dictionary_id='41705.Garanti Kapsamı'>"></span>
						</div>
					</div>
				</div>
				</cfif>
				<cfif session.ep.our_company_info.guaranty_followup eq 1>
				<div class="form-group" id="item-main_serial_no">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41915.Ana Seri No'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41915.Ana Seri No'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="main_serial_no" id="main_serial_no" onchange="main_serino_search();">
							<!--- windowopen('<cfoutput>#request.self#?</cfoutput>fuseaction=objects.popup_dsp_serial_number_result&product_serial_no='+document.add_service.main_serial_no.value,'list') --->
							<span class="input-group-addon icon-ellipsis btnPointer"  onClick="main_serino_control();" title="<cf_get_lang dictionary_id='41705.Garanti Kapsamı'>"></span>
						</div>
					</div>
				</div>
				</cfif>
				<div class="form-group" id="item-apply_date">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41671.Başvuru Tarihi'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41671.Başvuru Tarihi'> *</label>
					<div class="col col-4 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='41671.Başvuru Tarihi'></cfsavecontent>
							<cfif isdefined('attributes.service_id') and len(attributes.service_id)>
								<cfset adate="">
								<cfset ahour="">
								<cfset aminute="">
								<cfinput type="text" name="apply_date" id="apply_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="yes" message="#message#">
							<cfelseif isdefined("get_service_detail.apply_date") and len(get_service_detail.apply_date)>
								<cfset adate=get_service_detail.apply_date>
								<cfset ahour=datepart("H",adate)>
								<cfset aminute=datepart("N",adate)>
								<!---<cfif aminute mod 5 lt 3 and aminute neq 0>
									<cfset aminute = aminute - (aminute mod 5)>
								<cfelseif aminute mod 5 gte 3 and aminute neq 5>
									<cfset aminute = aminute + 5 - (aminute mod 5) >
								</cfif>--->
								<cfinput type="text" name="apply_date" id="apply_date" value="#dateformat(get_service_detail.apply_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#message#">
							<cfelseif isdefined("get_event.startdate") and len(get_event.startdate)>
								<cfset adate=get_event.startdate>
								<cfset ahour=datepart("H",adate)>
								<cfset aminute=datepart("N",adate)>
								<!---<cfif aminute mod 5 lt 3 and aminute neq 0>
									<cfset aminute = aminute - (aminute mod 5)>
								<cfelseif aminute mod 5 gte 3 and aminute neq 5>
									<cfset aminute = aminute + 5 - (aminute mod 5) >
								</cfif>--->
								<cfinput type="text" name="apply_date" id="apply_date" value="#dateformat(get_event.startdate,dateformat_style)#" validate="#validate_style#" required="yes" message="#message#">
							<cfelseif isdefined("get_call_service.apply_date") and len(get_call_service.apply_date)>
								<cfset adate=get_call_service.apply_date>
								<cfset ahour=datepart("H",adate)>
								<cfset aminute=datepart("N",adate)>
								<!---<cfif aminute mod 5 lt 3 and aminute neq 0>
									<cfset aminute = aminute - (aminute mod 5)>
								<cfelseif aminute mod 5 gte 3 and aminute neq 5>
									<cfset aminute = aminute + 5 - (aminute mod 5) >
								</cfif>--->
								<cfinput type="text" name="apply_date" id="apply_date" value="#dateformat(get_call_service.apply_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#message#">
							<cfelse>
								<cfset adate = dateadd('h',session.ep.time_zone,now())>
								<cfset ahour=datepart("H",adate)>
								<cfset aminute=datepart("N",adate)>
								<!---<cfif aminute mod 5 lt 3 and aminute neq 0>
									<cfset aminute = aminute - (aminute mod 5)>
								<cfelseif aminute mod 5 gte 3 and aminute neq 5>
									<cfset aminute = aminute + 5 - (aminute mod 5) >
								</cfif>--->
								<cfinput type="text" name="apply_date" id="apply_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="yes" message="#message#">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="apply_date"></span>
						</div>
					</div>
						<cfoutput>
							<div class="col col-2 col-xs-4">
								<cf_wrkTimeFormat name="apply_hour" value="#ahour#">
							</div>
							<div class="col col-2 col-xs-4">
								<select name="apply_minute" id="apply_minute">
									<cfloop from="0" to="59" index="app_min">
										<option value="#NumberFormat(app_min,00)#" <cfif isdefined("aminute") and len(aminute)><cfif app_min eq aminute>selected</cfif><cfelse><cfif app_min eq 00>selected</cfif></cfif>>#NumberFormat(app_min,00)#</option>
									</cfloop>
								</select>							
							</div>
						</cfoutput>
				</div>
				<div class="form-group" id="item-start_date1">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41672.Kabul Tarihi'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41672.Kabul Tarihi'></label>
					<div class="col col-4 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='41784.Kabul Tarihi Hatalı'></cfsavecontent>
							<cfif isdefined('attributes.service_id') and len(attributes.service_id)>
								<cfset sdate="">
								<cfset shour="">
								<cfset sminute="">
								<cfinput type="text" name="start_date1" id="start_date1" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="yes" message="#message#">
							<cfelseif isdefined("get_service_detail.start_date") and len(get_service_detail.start_date)>
								<cfset sdate=get_service_detail.start_date>
								<cfset shour=datepart("H",sdate)>
								<cfset sminute=datepart("N",sdate)>
								<cfinput type="text" name="start_date1" id="start_date1" value="#dateformat(get_service_detail.start_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#message#">
							<cfelseif isdefined("get_event.startdate") and len(get_event.startdate)>
								<cfset sdate=get_event.startdate>
								<cfset shour=datepart("H",sdate)>
								<cfset sminute=datepart("N",sdate)>
								<cfinput type="text" name="start_date1" id="start_date1" value="#dateformat(get_event.startdate,dateformat_style)#" validate="#validate_style#" required="yes" message="#message#">
							<cfelseif isdefined("attributes.call_service_id") and len(attributes.call_service_id)>
								<cfset sdate= dateadd('h',session.ep.time_zone,now())>
								<cfset shour=datepart("H",sdate)>
								<cfset sminute=datepart("N",sdate)>
								<cfinput type="text" name="start_date1" id="start_date1" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="yes" message="#message#">
							<cfelse>
								<cfset sdate= dateadd('h',session.ep.time_zone,now())>
								<cfset shour=datepart("H",sdate)>
								<cfset sminute=datepart("N",sdate)>
								<cfinput type="text" name="start_date1" id="start_date1" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="yes" message="#message#">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date1"></span>
						</div>
					</div>
					<cfoutput>
						<div class="col col-2 col-xs-4">
							<cf_wrkTimeFormat name="start_hour" value="#shour#">
						</div>
						<div class="col col-2 col-xs-4">
							<select name="start_minute" id="start_minute">
								<cfloop from="0" to="59" index="sta_min">
									<option value="#NumberFormat(sta_min,00)#" <cfif isdefined("sminute") and len(sminute)><cfif sta_min eq sminute>selected</cfif><cfelse><cfif sta_min eq 00>selected</cfif></cfif>>#NumberFormat(sta_min,00)#</option>
								</cfloop>
							</select>
						</div>
					</cfoutput>
				</div>
				<div class="form-group" id="item-intervention_date">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41706.Müdahale Tarihi'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41706.Müdahale Tarihi'></label>
					<div class="col col-4 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="intervention_date" id="intervention_date" value="" validate="#validate_style#" message="#message#">
							<cfif get_module_user(47)><span class="input-group-addon"><cf_wrk_date_image date_field="intervention_date"></span></cfif>
						</div>
					</div>
					<cfoutput>
						<div class="col col-2 col-xs-4">
							<cf_wrkTimeFormat name="intervention_start_hour" value="0">
						</div>
						<div class="col col-2 col-xs-4">
							<select name="intervention_start_minute" id="intervention_start_minute">
								<cfloop from="0" to="59" index="sta_min">
									<option value="#NumberFormat(sta_min,00)#">#NumberFormat(sta_min,00)#</option>
								</cfloop>
							</select>
						</div>
					</cfoutput>
				</div>
				<div class="form-group" id="item-finish_date1">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
					<div class="col col-4 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="finish_date1" id="finish_date1" value="" validate="#validate_style#" message="#message#">
							<cfif get_module_user(47)><span class="input-group-addon"><cf_wrk_date_image date_field="finish_date1"></span></cfif>
						</div>
					</div>
					<cfoutput>
						<div class="col col-2 col-xs-4">
							<cf_wrkTimeFormat name="finish_hour1" value="0">
						</div>
						<div class="col col-2 col-xs-4">
							<select name="finish_minute1" id="finish_minute1">
								<cfloop from="0" to="59" index="sta_min">
									<option value="#NumberFormat(sta_min,00)#">#NumberFormat(sta_min,00)#</option>
								</cfloop>
							</select>
						</div>
					</cfoutput>
				</div>
				<div class="form-group" id="item-task_person_name">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57569.Görevli'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57569.Görevli'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="task_emp_id" id="task_emp_id" value="">
							<cfinput type="text" name="task_person_name" id="task_person_name" value="" onfocus="AutoComplete_Create('task_person_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','task_emp_id','','3','125');" autocomplete="on">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_service.task_emp_id&field_name=add_service.task_person_name&select_list=1');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-related_company">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41664.İş Ortağı'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41664.İş Ortağı'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif isdefined("get_service_detail.related_company_id")>
								<input type="hidden" name="related_company_id" id="related_company_id" value="<cfoutput>#get_service_detail.related_company_id#</cfoutput>">
								<input type="text" name="related_company" id="related_company" value="<cfoutput>#get_par_info(get_service_detail.related_company_id,1,1,0)#</cfoutput>">
							<cfelseif isdefined("get_subscript_conract.sales_company_id") and len(get_subscript_conract.sales_company_id)>
								<input type="hidden" name="related_company_id" id="related_company_id" value="<cfoutput>#get_subscript_conract.sales_company_id#</cfoutput>">
								<input type="text" name="related_company" id="related_company" value="<cfoutput>#get_par_info(get_subscript_conract.sales_company_id,1,1,0)#</cfoutput>">
							<cfelse>
								<input type="hidden" name="related_company_id" id="related_company_id" value="">
								<input name="related_company" type="text" id="related_company" onFocus="AutoComplete_Create('related_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1\',0,0','COMPANY_ID','related_company_id','','3','250');" autocomplete="off">
							</cfif>                                    
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_service.related_company_id&field_comp_name=add_service.related_company&select_list=2');return false"></span>
						</div>
					</div>
				</div>
				<cfif session.ep.our_company_info.guaranty_followup eq 1>
				<div class="form-group" id="item-failure_code">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58934.Arıza Kodu'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58934.Arıza Kodu'></label>
					<div class="col col-8 col-xs-12">
						<cf_multiselect_check
						name="failure_code"
						option_name="service_code"
						option_value="service_code_id"
						table_name="SETUP_SERVICE_CODE"
						data_source="#dsn3#"
						value="iif(#len(our_get_service_using_code)#,#our_get_service_using_code#,DE(''))"
						width="164">
					</div>
				</div>
				</cfif>
				<div class="form-group" id="item-service_branch_id">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57453.Şube'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
					<div class="col col-8 col-xs-12">
						<cfset my_branch = listgetat(session.ep.user_location,2,'-')>							
						<select name="service_branch_id" id="service_branch_id">
							<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
							<cfoutput query="get_branch">
								<option value="#branch_id#" <cfif my_branch eq branch_id>selected</cfif>>#branch_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-loc_branch_id">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id ='30031.Lokasyon'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='30031.Lokasyon'></label>
					<div class="col col-8 col-xs-12">
						<cf_wrkdepartmentlocation 
						returnInputValue="location_id,department,department_id,branch_id"
						returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
						fieldName="department"
						branch_fldId="loc_branch_id"
						width="164">
					</div>
				</div>
				<cfif x_activity_time eq 1>
				<div class="form-group" id="item-activity_id">
					<!--- MT:aktivite tipi ve süre alanları eklenmiştir.Bu alanlarda dahil olmak üzere başvuru kaydedildiğinde zaman harcamasına kayıt atılıyor.--->
					<cfquery name="get_activity" datasource="#dsn#">
						SELECT ACTIVITY_ID,#dsn#.Get_Dynamic_Language(ACTIVITY_ID,'#session.ep.language#','SETUP_ACTIVITY','ACTIVITY_NAME',NULL,NULL,ACTIVITY_NAME) AS ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
					</cfquery>
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='31087.Aktivite'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31087.Aktivite'></label>
					<div class="col col-8 col-xs-12">
						<select name="activity_id" id="activity_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_activity">
								<option value="#activity_id#">#activity_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				</cfif>
				<div class="form-group" id="item-time_clock_hour">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id="29513.Süre"></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29513.Süre"></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cf_wrkTimeFormat name="time_clock_hour" value="0">
							<span class="input-group-addon no-bg"></span>
							<cfset time_list = '0,05,10,15,20,25,30,35,40,45,50,55'>
							<select name="time_clock_minute" id="time_clock_minute">
								<option value="0" selected><cf_get_lang dictionary_id='58127.Dakika'></option>
								<cfoutput>
									<cfloop index="aaa" from="1" to="#listlen(time_list)#">
										<option value="#listgetAt(time_list,aaa,',')#">#listgetAt(time_list,aaa,',')#</option>
									</cfloop>
								</cfoutput>
							</select>
							<!--- MT:aktivite tipi ve süre alanları eklenmiştir.Bu alanlarda dahil olmak üzere başvuru kaydedildiğinde zaman harcamasına kayıt atılıyor.--->
						</div>
					</div>
				</div>
				<div class="form-group" id="item-guaranty_inside">
					<label class="col col-4 col-xs-12"><input type="checkbox" name="guaranty_inside" id="guaranty_inside" <cfif isdefined("attributes.service_id") and get_service_detail.guaranty_inside eq 1>checked</cfif>><cf_get_lang dictionary_id='41870.Fiziki Hasar'></label>
					<div class="col col-8 col-xs-12">
							<select name="inside_detail_select" id="inside_detail_select" multiple="multiple">
								<cfoutput query="get_phy_dam">
									<option value="#physical_damage_id#">#physical_damage#</option>
								</cfoutput>
							</select>
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<cfif session.ep.our_company_info.guaranty_followup>
				<div class="form-group" id="item-guaranty_start_date">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41912.Garanti Tarihi'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41912.Garanti Tarihi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='41671.Başvuru Tarihi'></cfsavecontent>
							<cfif isdefined('attributes.service_id') and len(attributes.service_id)>
								<cfinput type="text" name="guaranty_start_date" id="guaranty_start_date" value="#dateformat(get_service_detail.guaranty_start_date,dateformat_style)#" validate="#validate_style#" message="#message#">
							<cfelse>
								<cfinput type="text" name="guaranty_start_date" id="guaranty_start_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" message="#message#">
							</cfif>                                    
							<span class="input-group-addon"><cf_wrk_date_image date_field="guaranty_start_date"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-bring_name">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41813.Getiren'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41813.Getiren'></label>
					<div class="col col-8 col-xs-12">
						<input type="text" name="bring_name" id="bring_name" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.bring_name#</cfoutput></cfif>" maxlength="150">
					</div>
				</div>
				<div class="form-group" id="item-bring_ship_method_name">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif isdefined("get_service_detail.BRING_SHIP_METHOD_ID") and len(get_service_detail.BRING_SHIP_METHOD_ID)>
								<cfset attributes.ship_method_id=get_service_detail.BRING_SHIP_METHOD_ID>
								<cfinclude template="../query/get_ship_method.cfm">
							<input type="hidden" name="bring_ship_method_id" id="bring_ship_method_id" value="<cfoutput>#get_service_detail.BRING_SHIP_METHOD_ID#</cfoutput>">
							<input type="text" name="bring_ship_method_name" id="bring_ship_method_name" value="<cfoutput>#SHIP_METHOD.SHIP_METHOD#</cfoutput>" onFocus="AutoComplete_Create('bring_ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','bring_ship_method_id','','3','125');" autocomplete="off">
							<cfelse>
								<input type="hidden" name="bring_ship_method_id" id="bring_ship_method_id" value="">
								<input type="text" name="bring_ship_method_name" id="bring_ship_method_name" value="" onFocus="AutoComplete_Create('bring_ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','bring_ship_method_id','','3','125');" autocomplete="off">
							</cfif>									
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=bring_ship_method_name&field_id=bring_ship_method_id');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-applicator_comp_name">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58607.Firma'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58607.Firma'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="text" name="applicator_comp_name" id="applicator_comp_name" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.applicator_comp_name#</cfoutput><cfelseif isdefined("attributes.applicator_comp_name")><cfoutput>#attributes.applicator_comp_name#</cfoutput></cfif>" maxlength="150">
							<cfset str_linke_ait="field_name=add_service.bring_name&field_comp_name=add_service.applicator_comp_name&field_tel=add_service.bring_tel_no&field_mobile_tel=add_service.bring_mobile_no&field_address=add_service.service_address&field_city_id=add_service.service_city_id&field_county_id=add_service.service_county_id&field_county=add_service.service_county_name"><!--- &field_long_address --->
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars&#str_linke_ait#&select_list=7,8&is_form_submitted=1&keyword='+encodeURIComponent(document.add_service.applicator_comp_name.value)</cfoutput>);" title="<cf_get_lang dictionary_id ='41917.Basvuru Yapan Seç'>"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-bring_tel_no">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57499.Telefon'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'></label>
					<div class="col col-8 col-xs-12">
						<input type="text" name="bring_tel_no" id="bring_tel_no" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.bring_tel_no#</cfoutput><cfelseif isdefined("attributes.bring_tel_no")><cfoutput>#attributes.bring_tel_no#</cfoutput></cfif>" maxlength="15" onKeyUp="isNumber(this);">
					</div>
				</div>
				<div class="form-group" id="item-bring_mobile_no">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58813.Cep Telefonu'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58813.Cep Telefonu'></label>
					<div class="col col-8 col-xs-12">
						<input type="text" name="bring_mobile_no"  id="bring_mobile_no" value="<cfif isdefined("attributes.bring_mobile_no")><cfoutput>#attributes.bring_mobile_no#</cfoutput><cfelseif isdefined("attributes.bring_mobile_no")><cfoutput>#attributes.bring_mobile_no#</cfoutput></cfif>" maxlength="15" onKeyUp="isNumber(this);">
					</div>
				</div>
				<div class="form-group" id="item-bring_email">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57428.E-Mail'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-Mail'></label>
					<div class="col col-8 col-xs-12">
						<input type="text" name="bring_email" id="bring_email" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.bring_email#</cfoutput><cfelseif isdefined("attributes.bring_email")><cfoutput>#attributes.bring_email#</cfoutput></cfif>" maxlength="150">
					</div>
				</div>
				<div class="form-group" id="item-service_address">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41729.Servis Adresi'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41729.Servis Adresi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<textarea name="service_address" id="service_address" ><cfif isdefined("attributes.service_address")><cfoutput>#attributes.service_address#</cfoutput></cfif></textarea>
							<span  class="input-group-addon icon-ellipsis btnPointer" onClick="add_adress('1');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-service_city_id">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58608.İl'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
					<div class="col col-8 col-xs-12">
						<select name="service_city_id" id="service_city_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
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
					</div>
				</div>
				<div class="form-group" id="item-service_county_name">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58638.İlçe'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41729.Servis Adresi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
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
								<input type="text" name="service_county_name" id="service_county_name" value="<cfoutput>#county_#</cfoutput>">
								<input type="hidden" name="service_county_id" id="service_county_id" value="<cfoutput>#county_id_#</cfoutput>">
							<cfelse>
								<input type="text" name="service_county_name" id="service_county_name" value="">
								<input type="hidden" name="service_county_id" id="service_county_id" value="">
							</cfif>
							<span  class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac();" title="<cf_get_lang dictionary_id ='57734.Seçiniz'>"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-doc_no">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41821.Kabul Belge No'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41821.Kabul Belge No'></label>
					<div class="col col-8 col-xs-12">
						<input type="text" name="doc_no" id="doc_no" value="<cfif isdefined('attributes.kabul_belge_no')><cfoutput>#attributes.kabul_belge_no#</cfoutput></cfif>" maxlength="150">
					</div>
				</div>
				<div class="form-group" id="item-service_county">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41737.Teslim Alacak'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41737.Teslim Alacak'></label>
					<div class="col col-8 col-xs-12">
						<input type="text" name="service_county" id="service_county" value="" maxlength="100">
					</div>
				</div>
				<div class="form-group" id="item-service_city">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41822.Teslim Belge No'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41822.Teslim Belge No'></label>
					<div class="col col-8 col-xs-12">
						<input type="text" name="service_city" id="service_city" value="">
					</div>
				</div>
				<div class="form-group" id="item-bring_detail">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='41807.Teslim Adresi'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41807.Teslim Adresi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif isdefined("attributes.bring_detail")>
								<textarea name="bring_detail" id="bring_detail" style="width:140px;height:70px;"><cfoutput>#attributes.bring_detail#</cfoutput></textarea>
							<cfelse>
								<textarea name="bring_detail" id="bring_detail" style="width:140px;height:70px;"></textarea>
							</cfif>
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="add_adress('2');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-ship_method_name">
					<cfsavecontent variable="header_"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></cfsavecontent>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="ship_method" id="ship_method" value="<cfif isdefined("attributes.service_id")><cfoutput>#get_service_detail.ship_method#</cfoutput></cfif>">
							<cfif isdefined("attributes.service_id") and len(get_service_detail.ship_method)>
								<cfset attributes.ship_method_id=get_service_detail.ship_method>
								<cfinclude template="../query/get_ship_method.cfm">
							</cfif>
							<input type="text" name="ship_method_name" id="ship_method_name" value="<cfif isdefined("attributes.service_id") and len(get_service_detail.ship_method)><cfoutput>#ship_method.ship_method#</cfoutput></cfif>">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method');"></span>
						</div>
					</div>
				</div>
				</cfif>
				<cfif x_subscription_products and (session.ep.our_company_info.subscription_contract eq 1) and isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
					<cf_area>
						<!---<cfinclude template="../display/list_subscription_products.cfm">--->
						<cfsavecontent variable="text"><cf_get_lang dictionary_id ='41918.Sistem Yazma Plani'></cfsavecontent>
						<cf_box 
							title="#text#" 
							id="system_plan_" 
							closable="0"
							box_page="#request.self#?fuseaction=service.list_subscription_products&SUBSCRIPTION_ID=#attributes.SUBSCRIPTION_ID#">
						</cf_box>
					</cf_area>
				</cfif>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons 
								is_upd='0' 
								add_function='chk_form()'
								data_action = '/V16/service/cfc/ServiceAction:add_service'
								next_page = '#request.self#?fuseaction=#attributes.fuseaction#&event=upd&service_id='>
		</cf_box_footer>
	</cfform>  
</cf_box>
</div>
<script type="text/javascript">
 	$(window).load(function(){
        $('#accessory_detail').attr('readonly', true);
		$('#accessory_detail_select').prop('disabled', true);
        $('#inside_detail_select').prop('disabled', true);
    });
	$('#accessory').change(function() { 
		if (this.checked) {
			$('#accessory_detail').attr('readonly', false);
			$('#accessory_detail_select').prop('disabled', false);
		} else {
			$('#accessory_detail').attr('readonly', true);
			$('#accessory_detail_select').prop('disabled', true);
		}
	});
	$('#guaranty_inside').change(function() { 
		if (this.checked) {
			$('#inside_detail_select').prop('disabled', false);
		} else {
			$('#inside_detail_select').prop('disabled', true);
		}
	});
	function fill_saleszone(member_id,type)
	{
		if(member_id==0)
		{
			if(document.getElementById('member_type').value=='partner')
			{
				member_id=document.getElementById('company_id').value;
				type=1;
			}
			else if(document.getElementById('member_type').value=='consumer')
			{
				member_id=document.getElementById('member_id').value;
				type=2;
			}
		}
		document.getElementById('sales_zone_id').value='';
		if(type == 1)
		{
			var sql = "SELECT SALES_COUNTY FROM COMPANY WHERE COMPANY_ID = " + member_id;
			get_country = wrk_query(sql,'dsn');
			if(get_country.SALES_COUNTY!='' && get_country.SALES_COUNTY!='undefined')
				document.getElementById('sales_zone_id').value=get_country.SALES_COUNTY;
		}
		else if(type == 2)
		{
			var sql = "select SALES_COUNTY from CONSUMER WHERE CONSUMER_ID = " + member_id;
			get_country= wrk_query(sql,'dsn');
			if(get_country.SALES_COUNTY!='' && get_country.TAX_COUNTRY_ID!='undefined')
				document.getElementById('sales_zone_id').value=get_country.SALES_COUNTY;
		}
	}
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
			if (document.add_service.service_city_id[document.add_service.service_city_id.selectedIndex].value == "")
				alert("<cf_get_lang dictionary_id='41656.İlk Olarak İl Seçiniz'>!");
			else
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=add_service.service_county_id&field_name=add_service.service_county_name&city_id=' + document.add_service.service_city_id.value);
		}
	function serino_control()
	{	
		if(document.add_service.service_product_serial.value.length==0)
		{
			alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="57637.Seri No">');
		}
		else
		{serino_search();}
	}
	function main_serino_control()
	{	
		if(document.add_service.main_serial_no.value.length==0)
		{
			alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="41915.Ana Seri No">');
		}
		else
		{main_serino_search();}
	}
	function serino_search()
	{
		if(document.add_service.service_product_serial.value.length>0)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&event=det&company_send_form=add_service&product_serial_no='+add_service.service_product_serial.value,'list');
		}
	}
	function main_serino_search()
	{
		if(document.add_service.main_serial_no.value.length>0)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&event=det&product_serial_no='+add_service.main_serial_no.value,'list');
		}
	}
	
	function chk_form()
	{
		<cfif isdefined("is_subscription_no") and is_subscription_no eq 2>
			if(document.getElementById('subscription_id').value=="" || document.getElementById('subscription_no').value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='29502.Sistem No'>");
				return false;
			}
		</cfif>
		<cfif x_is_multiple_category_select eq 1>
			if(document.add_service.appcat_sub_id.value=="")
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57656.Servis'> <cf_get_lang dictionary_id='41709.Alt Kategorisi'>");
				return false;
			}
			if(document.add_service.appcat_sub_status_id.value=="")
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57656.Servis'> <cf_get_lang dictionary_id='41708.Alt Tree Kategori'>");
				return false;
				}
		</cfif>

		<cfif session.ep.our_company_info.guaranty_followup eq 1>
			if ((document.add_service.service_product_id.value != "") && (document.add_service.is_check_product_serial_number.value == 1) && (document.add_service.service_product_serial.value == ""))
			{
				alert("<cf_get_lang dictionary_id='41874.Ürün İçin Seri No Takibi Yapılıyor'>! \r <cf_get_lang dictionary_id='41875.Lütfen Seri No Giriniz'>!");
				return false;
			}
		</cfif>
		if((document.add_service.member_id.value=="" || document.add_service.member_name.value==""))
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='29514.Başvuru Yapan'>");
			return false;
		}
		
		if(document.add_service.appcat_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='41722.Servis Kategorisi'>");
			return false;
		}
		if(document.add_service.priority_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='41723.Öncelik Kategorisi'>");
			return false;
		}
		try
		{
			if (!time_check(add_service.start_date1, document.getElementById("start_hour").options[document.getElementById("start_hour").selectedIndex], document.getElementById("start_minute").options[document.getElementById("start_minute").selectedIndex], add_service.finish_date1, document.getElementById("finish_hour1").options[document.getElementById("finish_hour1").selectedIndex], document.getElementById("finish_minute1").options[document.getElementById("finish_minute1").selectedIndex], "Başvuru Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır!"))
				return false;
		}
		catch(e)
		{
			if (!time_check(add_service.start_date1, add_service.start_hour,  add_service.start_minute, add_service.finish_date1, add_service.finish_hour1, add_service.finish_minute1, "Başvuru Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır!"))
				return false;
		}
			if(document.add_service.start_date1.value !='' && document.add_service.apply_date.value != '')
			{
			<cfif isdefined("x_apply_start_date") and x_apply_start_date eq 1>
				try
				{
					if (!time_check(add_service.apply_date, document.getElementById("apply_hour").options[document.getElementById("apply_hour").selectedIndex], document.getElementById("apply_minute").options[document.getElementById("apply_minute").selectedIndex], add_service.start_date1, document.getElementById("start_hour").options[document.getElementById("start_hour").selectedIndex], document.getElementById("start_minute").options[document.getElementById("start_minute").selectedIndex], "Başvuru Kabul Tarihi Başlangıç Tarihinden Önce Olamaz!",1))
						return false;
				}
				catch(e)
				{
					if (!time_check(add_service.apply_date, add_service.apply_hour,  add_service.apply_minute, add_service.start_date1, add_service.start_hour, add_service.start_minute, "Başvuru Kabul Tarihi Başlangıç Tarihinden Önce Olamaz!",1))
						return false;
				}
			<cfelse>
				try
				{
					if (!time_check(add_service.apply_date, document.getElementById("apply_hour").options[document.getElementById("apply_hour").selectedIndex], document.getElementById("apply_minute").options[document.getElementById("apply_minute").selectedIndex], add_service.start_date1, document.getElementById("start_hour").options[document.getElementById("start_hour").selectedIndex], document.getElementById("start_minute").options[document.getElementById("start_minute").selectedIndex], "Başvuru Kabul Tarihi Başlangıç Tarihinden Önce Olamaz!",0))
						return false;
				}
				catch(e)
				{
				if (!time_check(add_service.apply_date, add_service.apply_hour,  add_service.apply_minute, add_service.start_date1, add_service.start_hour, add_service.start_minute, "Başvuru Kabul Tarihi Başlangıç Tarihinden Önce Olamaz!",0))
						return false;
				}
			</cfif>
			}
		if(document.add_service.other_company_id.value!="" && document.add_service.other_company_name.value!="")
			{
			if(document.add_service.other_company_branch_company_id.value!="" && document.add_service.other_company_branch_id.value!="" && document.add_service.other_company_branch_name.value!="")
				{
				if(document.add_service.other_company_id.value != document.add_service.other_company_branch_company_id.value)
					{
					alert("<cf_get_lang dictionary_id='41657.İlgili Bayi İle İlgili Bayi Şubesi Uyuşmuyor'>!");
					return false;
					}
				}
			}
		//select_add('inside_detail_select');
		//select_add('accessory_detail_select');
		return process_cat_control();
	}
	
	function add_adress(type)
	{
		if(!(add_service.company_id.value=="") || !(add_service.member_id.value==""))
		{
			if(type == 1)
				{
				str_adrlink = '&field_long_adres=add_service.service_address';
				str_adrlink = str_adrlink+'&field_city=add_service.service_city_id';
				str_adrlink = str_adrlink+'&field_county=add_service.service_county_id';
				str_adrlink = str_adrlink+'&field_county_name=add_service.service_county_name';
				<cfif is_county_related_company>
					str_adrlink = str_adrlink+'&is_county_related_company=1';
					str_adrlink = str_adrlink+'&related_company_id=add_service.related_company_id';
					str_adrlink = str_adrlink+'&related_company=add_service.related_company';
				</cfif>
				}
			else
				str_adrlink = '&field_long_adres=add_service.bring_detail';
			
			if(add_service.company_id.value!="")
			{
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(add_service.company_name.value)+''+ str_adrlink);
				return true;
			}
			else
			{
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(add_service.member_name.value)+''+ str_adrlink);
				return true;
			}
		}
		else
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='57457.Müşteri'>");
			return false;
		}
	}
	
	function product_control(){/*Ürün seçmeden spec seçemesin.*/
	if(document.getElementById('stock_id').value=="" || document.getElementById('service_product').value == "" )
	{
		alert("<cf_get_lang dictionary_id='41676.Spec Seçmek için öncelikle ürün seçmeniz gerekmektedir'>!");
		return false;
	}
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=add_service.spec_main_id&field_name=add_service.spect_name&is_display=1&stock_id='+document.getElementById('stock_id').value,'list');
	}
	
	function add_adress_other()
	{
		if(!(add_service.other_company_id.value==""))
		{
			str_adrlink = '&field_id=add_service.other_company_branch_company_id';
			str_adrlink = str_adrlink + '&company_branch_id=add_service.other_company_branch_id';
			str_adrlink = str_adrlink + '&company_branch_name=add_service.other_company_branch_name';
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(add_service.other_company_name.value)+''+ str_adrlink);
		}
		else
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='41647.İlgili Bayi'>");
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
	<cfif session.ep.our_company_info.guaranty_followup eq 1><!--- silinmesin musterilerde hizli kayitta seri no alani focus isteniyor --->
		document.getElementById('service_product_serial').focus();
	</cfif>
	function get_service_defect(deger)
	{
		<cfif x_product_cat>
		if(document.getElementById('service_product_cat').value)
		{
			deger = document.getElementById('service_product_cat').value;
			result = wrk_safe_query('srv_get_service_code','dsn3',0,deger);
			mylist = result.SERVICE_CODE_ID;
			$("#failure_code").val(mylist);
			$("#failure_code").multiselect("refresh");
		}
		</cfif>
	}
	
	function find_service_f()
	{
		if($("#find_service_number").val().length)
		{
			var get_service = wrk_safe_query('sls_get_service','dsn3',0,$("#find_service_number").val());
			if(get_service.recordcount)
				window.location.href = '<cfoutput>#request.self#?fuseaction=service.list_service&event=upd&service_id=</cfoutput>'+get_service.SERVICE_ID[0];
			else
			{
				alert("<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!");
				return false;
			}
		}
		else
		{
			alert("<cf_get_lang dictionary_id='60876.Servis no eksik'> !");
			return false;
		}
	}
</script>
