<cf_get_lang_set module_name="sales">
<cfset action_date = ''>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_xml_page_edit fuseact ="sales.list_opportunity" default_value="1">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.keyword_oppno" default="">
    <cfparam name="attributes.keyword_detail" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfif not isdefined("attributes.opp_status") and not isDefined('attributes.is_filtre')><cfset attributes.opp_status = 1></cfif>
    <cfparam name="attributes.ordertype" default="1">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.member_type" default="">
    <cfparam name="attributes.member_name" default="">
    <cfif not isdefined("attributes.sales_emp_id") and isdefined("attributes.is_filtre") neq 1 and is_show_sales_emp eq 1>
        <cfset attributes.sales_emp_id = "#session.ep.userid#">
    <cfelse>
        <cfparam name="attributes.sales_emp_id" default="">
    </cfif>
    <cfif not isdefined("attributes.sales_emp") and isdefined("attributes.is_filtre") neq 1 and is_show_sales_emp eq 1>
        <cfset attributes.sales_emp = "#session.ep.name# #session.ep.surname#">
    <cfelse>
        <cfparam name="attributes.sales_emp" default="">
    </cfif>
    <cfparam name="attributes.sales_member_id" default="">
    <cfparam name="attributes.sales_member_type" default="">
    <cfparam name="attributes.sales_member_name" default="">
    <cfparam name="attributes.record_employee_id" default="">
    <cfparam name="attributes.record_employee" default="">
    <cfparam name="attributes.process_stage" default="">
    <cfparam name="attributes.opportunity_type_id" default="">
    <cfparam name="attributes.product_cat_id" default="">
    <cfparam name="attributes.product_cat" default="">
    <cfparam name="attributes.stock_id" default="">
    <cfparam name="attributes.stock_name" default="">
    <cfparam name="attributes.sale_add_option" default="">
    <cfparam name="attributes.probability" default="">
    <cfparam name="attributes.opp_currency_id" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfinclude template="../sales/query/get_probability_rate.cfm">
    <cfinclude template="../sales/query/get_sale_add_option.cfm">
    <cfif isdefined("attributes.is_filtre")>
      <cfinclude template="../sales/query/get_opportunities.cfm">	
    <cfelse>
      <cfset get_opportunities.recordcount = 0>
    </cfif>
    <cfquery name="get_process_type" datasource="#dsn#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.form_add_opportunity%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_opportunities.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif get_opportunities.recordcount>
		<cfset partner_id_list = "">
        <cfset consumer_id_list = "">
        <cfset sales_pcode_list = "">
        <cfset opportunity_type_list = "">
        <cfset sales_add_options_list = "">
        <cfset sales_partner_id_list = "">
        <cfset sales_consumer_id_list = "">
        <cfset probability_list = "">
        <cfset project_name_list = ''>
        <cfset opp_stage_list = "">
        <cfoutput query="get_opportunities" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfif len(partner_id) and not listfind(partner_id_list,partner_id)>
                <cfset partner_id_list=listappend(partner_id_list,partner_id)>
            </cfif>
            <cfif len(project_id) and not listfind(project_name_list,project_id)>
                <cfset project_name_list = Listappend(project_name_list,project_id)>
            </cfif> 
            <cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
                <cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
            </cfif>
            <cfif len(sales_emp_id) and not listfind(sales_pcode_list,sales_emp_id)>
                <cfset sales_pcode_list=listappend(sales_pcode_list,sales_emp_id)>
            </cfif>
            <cfif len(sales_partner_id) and not listFindnocase(sales_partner_id_list,sales_partner_id,',')>
                <cfset sales_partner_id_list = listAppend(sales_partner_id_list,sales_partner_id)>
            </cfif>
            <cfif len(sales_consumer_id) and not listFindnocase(sales_consumer_id_list,sales_consumer_id,',')>
                <cfset sales_consumer_id_list = listAppend(sales_consumer_id_list,sales_consumer_id)>
            </cfif>
            <cfif len(opportunity_type_id) and not listFindnocase(opportunity_type_list,opportunity_type_id,',')>
                <cfset opportunity_type_list = listAppend(opportunity_type_list,opportunity_type_id)>
            </cfif>
            <cfif len(sale_add_option_id) and not listFindnocase(sales_add_options_list,sale_add_option_id,',')>
                <cfset sales_add_options_list = listAppend(sales_add_options_list,sale_add_option_id)>
            </cfif>
            <cfif len(probability) and not listfind(probability_list,probability)>
                <cfset probability_list = listappend(probability_list,probability)>
            </cfif>    
            <cfif len(opp_stage) and not listfind(opp_stage_list,opp_stage)>
                <cfset opp_stage_list = listappend(opp_stage_list,opp_stage)>
            </cfif>
        </cfoutput>
        <cfif listlen(partner_id_list)>
            <cfset partner_id_list = listsort(partner_id_list,"numeric","ASC",",")>	
            <cfquery name="get_partner_detail" datasource="#dsn#">
                SELECT
                    CP.PARTNER_ID,						
                    <cfif (database_type is 'MSSQL')>
                        CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME PARTNER_NAME_SURNAME,
                    <cfelseif (database_type is 'DB2')>
                        CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME PARTNER_NAME_SURNAME,
                    </cfif>
                    CP.TITLE,
                    C.FULLNAME
                FROM 
                    COMPANY_PARTNER CP,
                    COMPANY C
                WHERE 
                    CP.PARTNER_ID IN (#partner_id_list#) AND
                    CP.COMPANY_ID = C.COMPANY_ID
                ORDER BY
                    CP.PARTNER_ID				
            </cfquery>
            <cfset partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner_detail.partner_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif listlen(consumer_id_list)>
            <cfset consumer_id_list = listsort(consumer_id_list,"numeric","ASC",",")>
            <cfquery name="get_consumer_detail" datasource="#dsn#">
                SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
            </cfquery>
            <cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif listlen(sales_pcode_list)>
            <cfset sales_pcode_list = listsort(sales_pcode_list,"numeric","ASC",",")>
            <cfquery name="get_position_detail" datasource="#dsn#">
                SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#sales_pcode_list#) ORDER BY EMPLOYEE_ID
            </cfquery>
            <cfset sales_pcode_list = listsort(listdeleteduplicates(valuelist(get_position_detail.employee_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(project_name_list)>
            <cfquery name="opp_pro" datasource="#dsn#">
                SELECT PROJECT_HEAD, PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_name_list#) ORDER BY PROJECT_ID
            </cfquery>
            <cfset project_name_list = listsort(listdeleteduplicates(valuelist(opp_pro.project_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif listlen(sales_partner_id_list)>
            <cfset sales_partner_id_list = listsort(sales_partner_id_list,"numeric","ASC",",")>
            <cfquery name="get_sales_partner" datasource="#dsn#">
                SELECT
                    CP.PARTNER_ID,						
                    <cfif (database_type is 'MSSQL')>
                        CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME PARTNER_NAME_SURNAME,
                    <cfelseif (database_type is 'DB2')>
                        CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME PARTNER_NAME_SURNAME,
                    </cfif>
                    CP.TITLE,
                    C.NICKNAME
                FROM 
                    COMPANY_PARTNER CP,
                    COMPANY C
                WHERE 
                    CP.PARTNER_ID IN (#sales_partner_id_list#) AND
                    CP.COMPANY_ID = C.COMPANY_ID
                ORDER BY
                    CP.PARTNER_ID
            </cfquery>
            <cfset sales_partner_id_list = listsort(listdeleteduplicates(valuelist(get_sales_partner.partner_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif listlen(sales_consumer_id_list)>
            <cfset sales_consumer_id_list = listsort(sales_consumer_id_list,"numeric","ASC",",")>
            <cfquery name="get_sales_consumer_detail" datasource="#dsn#">
                SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#sales_consumer_id_list#) ORDER BY CONSUMER_ID
            </cfquery>
            <cfset sales_consumer_id_list = listsort(listdeleteduplicates(valuelist(get_sales_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif listlen(opportunity_type_list)>
            <cfset opportunity_type_list = listsort(opportunity_type_list,"numeric","ASC",",")>
            <cfquery name="get_opportunity_types" datasource="#dsn3#">
                SELECT OPPORTUNITY_TYPE_ID, OPPORTUNITY_TYPE FROM SETUP_OPPORTUNITY_TYPE WHERE OPPORTUNITY_TYPE_ID IN (#opportunity_type_list#) ORDER BY OPPORTUNITY_TYPE_ID
            </cfquery>
            <cfset opportunity_type_list = listsort(listdeleteduplicates(valuelist(get_opportunity_types.opportunity_type_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif listlen(sales_add_options_list)>
            <cfset sales_add_options_list = listsort(sales_add_options_list,"numeric","ASC",",")>
            <cfquery name="get_sales_add_option" datasource="#dsn3#">
                SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS WHERE SALES_ADD_OPTION_ID IN (#sales_add_options_list#) ORDER BY SALES_ADD_OPTION_ID
            </cfquery>
            <cfset sales_add_options_list = listsort(listdeleteduplicates(valuelist(get_sales_add_option.sales_add_option_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(probability_list)>
            <cfset probability_list = listsort(probability_list,"numeric","ASC",",")>
            <cfquery name="get_probability" datasource="#dsn3#">
                SELECT PROBABILITY_RATE_ID,PROBABILITY_NAME FROM SETUP_PROBABILITY_RATE  WHERE PROBABILITY_RATE_ID IN (#probability_list#) ORDER BY PROBABILITY_RATE_ID
            </cfquery>
            <cfset probability_list = listsort(listdeleteduplicates(valuelist(get_probability.probability_rate_id,',')),"numeric","ASC",",")>
        </cfif>      
        <cfif len(opp_stage_list)>
            <cfset opp_stage_list = listsort(opp_stage_list,"numeric","ASC",",")>
            <cfquery name="process_type_all" datasource="#DSN#">
                SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#opp_stage_list#) ORDER BY PROCESS_ROW_ID
            </cfquery>
            <cfset opp_stage_list = listsort(listdeleteduplicates(valuelist(process_type_all.process_row_id,',')),"numeric","ASC",",")>
        </cfif>
    </cfif>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
    <cf_xml_page_edit fuseact="sales.form_add_opportunity">
    <cfset action_date = now()>
    <cfinclude template="../sales/query/get_commethod_cats.cfm">
    <cfinclude template="../sales/query/get_probability_rate.cfm">
    <cfinclude template="../sales/query/get_moneys.cfm">
    <cfinclude template="../sales/query/get_opportunity_type.cfm">
    <cfquery name="get_probability" datasource="#dsn3#">
        SELECT * FROM SETUP_PROBABILITY_RATE
    </cfquery>
    <cfquery name="get_sale_add_option" datasource="#dsn3#">
        SELECT SALES_ADD_OPTION_ID, SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS
    </cfquery>
    <cfset cmp = createObject("component","settings.cfc.setupCountry") />
    <cfset GET_COUNTRY = cmp.getCountry()>
    <cfquery name="GET_SALE_ZONES" datasource="#DSN#">
        SELECT 
            SZ_ID,
            SZ_NAME 
        FROM 
            SALES_ZONES
    </cfquery>
    <cfif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
        <cfquery name="get_help_" datasource="#dsn#">
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
                CUS_HELP_ID = #attributes.cus_help_id#
        </cfquery>
        <cfif len(get_help_.company_id)>
            <cfset attributes.cpid = get_help_.company_id>
            <cfset attributes.member_id = get_help_.partner_id>
            <cfset attributes.member_type = "partner">
        <cfelseif len(get_help_.consumer_id)>
            <cfset attributes.cpid = "">
            <cfset attributes.member_id = get_help_.consumer_id>
            <cfset attributes.member_type = "consumer">
        </cfif>
        <cfif len(get_help_.subscription_id)>
            <cfquery name="GET_SUB_NO" datasource="#dsn3#">
                SELECT SUBSCRIPTION_NO,PROJECT_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_help_.subscription_id#">
            </cfquery>
            <cfset attributes.project_id = get_sub_no.project_id>
        </cfif>
        <cfset attributes.opp_detail = get_help_.subject>
        <cfset attributes.commethod_id = get_help_.app_cat>
    <cfelseif isdefined('attributes.service_id') and len(attributes.service_id)>
         <cfquery name="GET_SERVICE" datasource="#DSN#">
            SELECT
                SERVICE_HEAD,
                PROJECT_ID,
                SERVICE_CONSUMER_ID,
                SERVICE_COMPANY_ID,
                SERVICE_PARTNER_ID
            FROM 
                G_SERVICE	 
            WHERE 
                SERVICE_ID = #attributes.service_id#	
        </cfquery>
        <cfset attributes.project_id = get_service.project_id>
    <cfelseif isdefined("attributes.project_id") and len(attributes.project_id)>
        <cfquery name="get_project_info" datasource="#dsn#">
            SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.project_id#
        </cfquery>
        <cfif len(get_project_info.company_id)>
            <cfset attributes.cpid = get_project_info.company_id>
            <cfset attributes.member_id = get_project_info.partner_id>
            <cfset attributes.member_type = "partner">
        <cfelseif len(get_project_info.consumer_id)>
            <cfset attributes.cpid = "">
            <cfset attributes.member_id = get_project_info.consumer_id>
            <cfset attributes.member_type = "consumer">
        </cfif>
    </cfif>
    <cfparam name="attibutes.cpid" default="">
    <cfparam name="attributes.probability_rate_id" default="">
<cfelseif (isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'det'))>
    <cf_xml_page_edit fuseact="sales.form_add_opportunity">
    <cfinclude template="../sales/query/get_opportunity.cfm">
	<cfset action_date = get_opportunity.action_date>
    <cfif not get_opportunity.recordcount>
        <br />
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> Şirketinizde Böyle Bir Fırsat Bulunamadı !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../../dsp_hata.cfm">
        <cfexit method="exittemplate">
    </cfif>
    <cfset cmp = createObject("component","settings.cfc.setupCountry") />
    <cfset GET_COUNTRY_1 = cmp.getCountry()>
    <cfquery name="GET_SALE_ZONES" datasource="#DSN#">
        SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
    </cfquery>
    <cfinclude template="../sales/query/get_probability_rate.cfm">
    <cfinclude template="../sales/query/get_moneys.cfm">
    <cfinclude template="../sales/query/get_opportunity_type.cfm">
    <cfinclude template="../sales/query/get_opportunity_offers.cfm">
    <cfinclude template="../sales/query/get_opp_pluses.cfm">
    <cfinclude template="../sales/query/get_rival_preference_reasons.cfm">
    <cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
        SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS
    </cfquery>
    <cfset contact_flag = 0>
    <cfif len(get_opportunity.partner_id)>
        <cfscript>
            member_id = '#get_opportunity.partner_id#';
            contact_type = "p" ;
            contact_id = '#get_opportunity.partner_id#';
            dsp_account =0;
            contact_flag = 1;
        </cfscript>
    <cfelseif len(get_opportunity.consumer_id)>
        <cfscript>
            member_id = '#get_opportunity.consumer_id#';
            contact_id = '#get_opportunity.consumer_id#';
            contact_type = "c";
            dsp_account = 0;
            contact_flag = 1;
        </cfscript>	
    </cfif>
    <cfif contact_flag>
        <cfinclude template="../objects/query/get_contact_simple.cfm">
        <cfset sector_cat_id = get_contact_simple.sector_cat_id>
        <cfset company_size_cat_id = get_contact_simple.company_size_cat_id>
    <cfelse>
        <cfset sector_cat_id = "">
        <cfset company_size_cat_id = "">
    </cfif>
    <cfif Len(get_opportunity.sales_emp_id)>
	<cfquery name="GET_EMP" datasource="#DSN#">
		SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND EMPLOYEE_ID = #get_opportunity.sales_emp_id#
	</cfquery>
    </cfif>
	<cfif len(get_opportunity.company_id)>
        <cfquery name="GET_PARTNER" datasource="#DSN#" maxrows="1">
            SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME, PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = #get_opportunity.company_id# ORDER BY PARTNER_ID
        </cfquery>
        <cfquery name="GET_COMP_ADDRESS" datasource="#DSN#">
            SELECT COMPANY_ADDRESS,COMPANY_POSTCODE,SEMT,COUNTY,CITY,COUNTRY FROM COMPANY WHERE COMPANY_ID = #get_opportunity.company_id#
        </cfquery>
        <cfif len(get_comp_address.county)>
        <cfquery name="GET_COUNTY" datasource="#DSN#">
            SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_comp_address.county#
        </cfquery>
    </cfif>
    <cfif len(get_comp_address.city)>
        <cfquery name="GET_CITY" datasource="#DSN#">
            SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_comp_address.city#		
        </cfquery>
    </cfif>
    <cfif len(get_comp_address.country)>
        <cfquery name="GET_COUNTRY" datasource="#DSN#">
            SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_comp_address.country#
        </cfquery>
    </cfif>
    <cfelseif len(get_opportunity.consumer_id)>
        <cfquery name="GET_CON_ADDRESS" datasource="#DSN#">
            SELECT WORKADDRESS, WORKPOSTCODE,WORKSEMT,WORK_COUNTY_ID,WORK_CITY_ID,WORK_COUNTRY_ID FROM CONSUMER WHERE CONSUMER_ID = #get_opportunity.consumer_id#
        </cfquery>
    <cfif len(get_con_address.work_county_id)>
        <cfquery name="GET_COUNTY" datasource="#DSN#">
            SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_con_address.work_county_id#
        </cfquery>
    </cfif>
    <cfif len(get_con_address.work_city_id)>
        <cfquery name="GET_CITY" datasource="#DSN#">
            SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_con_address.work_city_id#		
        </cfquery>
    </cfif>
    <cfif len(get_con_address.work_city_id)>
        <cfquery name="GET_CITY" datasource="#DSN#">
            SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_con_address.work_city_id#		
        </cfquery>
    </cfif>
    <cfif len(get_con_address.work_country_id)>
        <cfquery name="GET_COUNTRY" datasource="#DSN#">
            SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_con_address.work_country_id#	
        </cfquery>
    </cfif>
<cfelse>
	<cfset get_service.recordcount = 0>
</cfif>
	<cfset member_name_ = "">
    <cfif len(get_opportunity.ref_partner_id)>
        <cfset member_name_= get_par_info(get_opportunity.ref_partner_id,0,-1,0)>
    <cfelseif len(get_opportunity.ref_consumer_id)>
        <cfset member_name_= get_cons_info(get_opportunity.ref_consumer_id,0,0)>
    <cfelseif len(get_opportunity.ref_employee_id)>
        <cfset member_name_= get_emp_info(get_opportunity.ref_employee_id,0,0)>
    </cfif>

	<cfif len(attributes.opp_id)>
        <cfquery name="get_systems_opp" datasource="#dsn3#">
            SELECT SUBSCRIPTION_ID,SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE OPP_ID=#attributes.opp_id#
        </cfquery>
    <cfelse>
        <cfset get_systems_opp.recordcount=0>
    </cfif>
</cfif>

<script type="text/javascript">
	$(function(){
		$("#workcube_button").prepend($(".buttonMessage"));
	});
	//Event : list
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});	
		function connectAjax(crtrow,opp_id)
		{
			var load_url_ = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_opp_plus_info</cfoutput>&opp_id='+opp_id;
			AjaxPageLoad(load_url_,'DISPLAY_OPP_PLUS_INFO'+crtrow,1);
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function fill_country(member_id,type)
		{
				document.getElementById('country_id').value='';
				document.getElementById('sales_zone_id').value='';
				if(type==1)
				{
			url_= '/V16/sales/cfc/get_offer_list.cfc?method=getcountry';
			
			$.ajax({
				type: "get",
				url: url_,
				data: {member_id_: member_id},
				cache: false,
				async: false,
				success: function(read_data){
					data_ = jQuery.parseJSON(read_data.replace('//',''));
					if(data_.DATA.length != 0)
					{
						$.each(data_.DATA,function(i){
							if(data_.DATA[i][0]!='' && data_.DATA[i][0]!='undefined')
								document.getElementById('country_id').value=data_.DATA[i][0];
							if(data_.DATA[i][1]!='' && data_.DATA[i][1]!='undefined')
								document.getElementById('sales_zone_id').value=data_.DATA[i][1];						
							});
					}
				}
			});
				}
				else if(type==2)
				{
					url_= '/sales/cfc/get_offer_list.cfc?method=getconsumer';
					
					$.ajax({
						type: "get",
						url: url_,
						data: {member_id_: member_id},
						cache: false,
						async: false,
						success: function(read_data){
							data_ = jQuery.parseJSON(read_data.replace('//',''));
							if(data_.DATA.length != 0)
							{
								$.each(data_.DATA,function(i){
									if(data_.DATA[i][0]!='' && data_.DATA[i][0]!='undefined')
										document.getElementById('country_id').value=data_.DATA[i][0];
									if(data_.DATA[i][1]!='' && data_.DATA[i][1]!='undefined')
										document.getElementById('sales_zone_id').value=data_.DATA[i][1];						
									});
							}
						}
					});					
			}
		}
		function unformat_fields()
		{
			upd_opp.income.value = filterNum(upd_opp.income.value);
			upd_opp.cost.value = filterNum(upd_opp.cost.value);
		}
		function return_company()
		{	
			if(document.getElementById('ref_member_type').value=='employee')
			{	
				var emp_id=document.getElementById('ref_employee_id').value;
				var GET_COMPANY=wrk_safe_query('sls_get_cmpny','dsn',0,emp_id);
				document.getElementById('ref_company_id').value=GET_COMPANY.COMP_ID;
			}
			else
				return false;
		}
		function auto_sales_zone()
		{
			url_= '/V16/sales/cfc/get_offer_list.cfc?method=SalesZone';
			$.ajax({
				type: "get",
				url: url_,
				data: {country_id_: document.getElementById('country_id').value},
				cache: false,
				async: false,
				success: function(read_data){
					data_ = jQuery.parseJSON(read_data.replace('//',''));
					if(data_.DATA.length != 0)
					{
							if(data_.DATA.length == 1)
							{
								$.each(data_.DATA,function(i){
									if(data_.DATA[i][0]!='' && data_.DATA[i][0]!='undefined')
									document.getElementById('sales_zone_id').value = data_.DATA[i][0];
									});
							}
										}
							else if(data_.DATA.length == 0)
							{
								alertObject({message: '<cf_get_lang_main no ='2634.Ülke ile İlişkili Satış Bölgesi Bulunamadı'>'});
								return false;
							}
							else if(data_.DATA.length > 1)
							{
								alertObject({message: '<cf_get_lang_main no='2635.Ülke ile İlişkili Birden Fazla Satış Bölgesi Bulunmaktadır'>'});
								return false;
							}

					}
					});					
			return false;
		}
	</cfif>
	<cfif (isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'det' or attributes.event is 'add'))>
	function upd_kontrol()
	{
		var formName = 'upd_opp',  
		form  = $('form[name="'+ formName +'"]');
		if (form.find('input#acquisition_date').val() != '' && form.find('input#action_date').val() != ''){ 
			if(datediff(form.find('input#action_date').val(),form.find('input#acquisition_date').val() ,0)<0){
					validateMessage('notValid',form.find('input#acquisition_date')); 
					return false;
			}else    {
					  validateMessage('valid',form.find('input#acquisition_date') ); 
					 } 
		}
		var formName = 'upd_opp',  
		form  = $('form[name="'+ formName +'"]');
		if (form.find('input#opp_invoice_date').val() != '' && form.find('input#action_date').val() != ''){ 
			if(datediff(form.find('input#action_date').val(),form.find('input#opp_invoice_date').val() ,0)<0){
					validateMessage('notValid',form.find('input#opp_invoice_date')); 
					return false;
			}else    {
					  validateMessage('valid',form.find('input#opp_invoice_date') ); 
					 } 
		}
		return process_cat_control();
	}
</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	if(isdefined('attributes.event') and attributes.event contains 'upd')
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = get_opportunity.opp_stage;
	else
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = '';
	
	WOStruct['#attributes.fuseaction#']['systemObject']['paperNumber'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperType'] = 'OPPORTUNITY';
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn3; // Transaction icin yapildi.
	
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDateCallFunction'] = 'change_money_info';
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'OPPORTUNITIES';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'OPP_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_stage','item-opportunity_type_id','item-opp_head','item-company']";

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.form_add_opportunity';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'sales/form/add_opportunity.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'sales/query/add_opportunity.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_opportunity&event=det&opp_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'upd_opp';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'upd_kontrol() && validate().check()';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.list_opportunity&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'sales/form/upd_opportunity.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'sales/query/upd_opportunity.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_opportunity&event=det&opp_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'opp_id=##attributes.opp_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.opp_id##';	
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'GET_OPPORTUNITY';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'upd_opp';

	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'upd_kontrol()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	
	WOStruct['#attributes.fuseaction#']['det']['pageParams'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['pageParams']['size'] = '9-3';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'sales/query/upd_opportunity.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'sales.list_opportunity&event=det&opp_id=';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.opp_id##';
	WOStruct['#attributes.fuseaction#']['det']['pageObjects'] = structNew();
	
	if(not isdefined('attributes.formSubmittedController'))
	{
		// type'lar include,box,custom tag şekline dönüşecek.
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'sales.list_opportunity&event=det&opp_id=';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'sales/display/list_opportunity.cfm';
		
		if(isdefined("attributes.event") and not (attributes.event is 'add' or attributes.event is 'list'))
		{
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['type'] = 0; // Include
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceController']  = 'opportunity.cfm';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceEvent']  = 'upd';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['file'] = '#request.self#?fuseaction=sales.list_opportunity_plus&opp_id=#attributes.opp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['addFile'] = '#request.self#?fuseaction=sales.popup_form_add_opp_plus&opp_id=#get_opportunity.opp_id#&header=upd_opp.opp_head&contact_mail=#get_contact_simple.email#&contact_person=#get_contact_simple.name# #get_contact_simple.surname#&contact_id=#get_contact_simple.id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['id'] = 'project';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['title'] = '#lang_array.item[62]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][2]['type'] = 2;
			adres_ = "#request.self#?fuseaction=project.emptypopup_ajax_project_works&opp_id=#opp_id#";
			if(xml_is_opportunity_actions eq 1)
				adres_ = "#adres_#&action_project_id=#get_opportunity.project_id#";
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][2]['file'] = '#adres_#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][2]['id'] = 'worksOpportunities';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][2]['title'] = '#lang_array_main.item[608]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][3]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][3]['file'] = '#request.self#?fuseaction=sales.emptypopup_ajax_opp_supplier&opp_id=#attributes.opp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][3]['id'] = 'list_supplier';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][3]['title'] = '#lang_array_main.item[1731]#';

			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][4]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][4]['file'] = '#request.self#?fuseaction=sales.emptypopup_ajax_opp_rival&opp_id=#attributes.opp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][4]['id'] = 'list_rival';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][4]['title'] = '#lang_array.item[16]#';
			
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['type'] = 1; // Custom Tag
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['file'] = '<cf_display_member action_id="#member_id#" action_type_id="#contact_type#" dsp_account="#dsp_account#">';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['file'] = '#request.self#?fuseaction=sales.list_systems_opp&opp_id=#attributes.opp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['id'] = 'get_related_system';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][1]['title'] = '#lang_array.item[21]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['file'] = '#request.self#?fuseaction=sales.opportunity_offer&opp_id=#attributes.opp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['id'] = 'opportunity_';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][2]['title'] = '#lang_array_main.item[133]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['file'] = '#request.self#?fuseaction=sales.list_related_services&opp_id=#attributes.opp_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['id'] = 'get_related_services';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][3]['title'] = '#lang_array.item[29]#';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['type'] = 1; // Custom Tag
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][4]['file'] = '<cf_get_workcube_asset asset_cat_id="-13" module_id="11" action_section="OPP_ID" action_id="##attributes.opp_id##">';
			controlParam = 5;																			
			if(xml_is_opportunity_actions eq 1)
			{
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1; // Custom Tag
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_related_events company_id="#session.ep.company_id#" action_section="OPPORTUNITY_ID" action_id="#attributes.opp_id#" action_project_id="#get_opportunity.project_id#">';
				controlParam = controlParam + 1;
			}
			else
			{
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1; // Custom Tag
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_related_events company_id="#session.ep.company_id#" action_section="OPPORTUNITY_ID" action_id="#attributes.opp_id#">';
				controlParam = controlParam + 1;
			}
			
			if(xml_is_opportunity_analysis eq 1)
			{
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1; // Custom Tag
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_member_analysis action_type="OPPORTUNITY" action_type_id="#attributes.opp_id#" company_id="#get_opportunity.company_id#" partner_id="#get_opportunity.partner_id#" consumer_id="#get_opportunity.consumer_id#">';
				controlParam = controlParam + 1;
			}


		}
	}
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_opportunity';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'sales/display/list_opportunities.cfm';
	
	
	if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is 'det' or attributes.event is "del"))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'sales.emptypopup_del_opportunity&opp_id=#attributes.opp_id#&opportunity_no=#get_opportunity.opp_no#&head=#get_opportunity.opp_head#&cat=#get_opportunity_type.opportunity_type_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'sales/query/del_opp.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'sales/query/del_opp.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.list_opportunity';//

	}
	
	// Upd //
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		// Tab Menus //
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#lang_array_main.item[1575]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=myhome.list_my_expense_requests&event=add&opp_id=#opp_id#";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=sales.form_upd_opportunity&action_name=opp_id&action_id=#attributes.opp_id#&relation_papers_type=OPP_ID','list');";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=sales.popup_list_opportunity_history&opp_id=#opp_id#','medium')";
		
		i=3;
		if (IsDefined("get_opportunity.company_id"))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[163]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.my_company_details&cpid=#get_opportunity.company_id#";
			i = i+ 1;
		}
		else if (IsDefined("get_opportunity.consumer_id"))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[163]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.my_consumer_details&cid=#get_opportunity.consumer_id#";
			i = i+ 1;
	    }
		
		if (IsDefined("get_opportunity.project_id") and len(get_opportunity.project_id) and get_opportunity.recordcount)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[4]# #lang_array_main.item[359]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.prodetail&id=#get_opportunity.project_id#";
			i = i+ 1;
		}
		else 
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[4]# #lang_array_main.item[359]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.addpro&opp_id=#get_opportunity.opp_id#";
			i = i+ 1;
	    }
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[5]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_offer&event=add&opp_id=#opp_id#";
		i = i+ 1;
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] =  '#lang_array_main.item[521]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.addwork&work_fuse=#attributes.fuseaction#&opp_id=#opp_id#&company_id=#get_opportunity.company_id#&partner_id=#get_opportunity.partner_id#";
		i = i+ 1;

		if((get_module_user(11)) and session.ep.our_company_info.subscription_contract eq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[1727]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_subscription_contract&event=add&opp_id=#attributes.opp_id#";
			i = i+ 1;
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] =  '#lang_array.item[636]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=sales.popup_add_workgroup&opp_id=#attributes.opp_id#','list');";
		i = i+ 1;
		if(session.ep.our_company_info.workcube_sector is 'tersane')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[2580]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=sales.form_add_relation_pbs&opp_id=#get_opportunity.opp_id#";
			i = i+ 1;
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=sales.list_opportunity&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#opp_id#&print_type=#72#','page');";
		
		//tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['extra']['text'] = 'Oklar';
		//tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['extra']['customTag'] = '<cf_np tablename="opportunities" primary_key="opp_id" pointer="opp_id=#opp_id#,event=upd" dsn_var="DSN3">';
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>