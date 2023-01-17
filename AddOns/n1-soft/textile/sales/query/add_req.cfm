
<cf_papers_tex paper_type="REQ">
<cfset system_paper_no = paper_code & '-' & paper_number>
<cfset system_paper_no_add = paper_number>
<cfif len(attributes.opp_date)><cf_date tarih="attributes.opp_date"></cfif>
<cfif isdefined("attributes.opp_invoice_date") and  len(attributes.opp_invoice_date)><cf_date tarih="attributes.opp_invoice_date"></cfif>
<cfif isdefined("attributes.action_date") and  len(attributes.action_date)><cf_date tarih="attributes.action_date"></cfif>
<cfset attributes.sales_team_id = ''>
<cf_xml_page_edit fuseact="textile.list_sample_request">
<cfquery name="get_country" datasource="#dsn#">
    <cfif isdefined("attributes.member_type") and attributes.member_type is 'partner'>
        SELECT 
            COUNTRY COUNTRY_ID,
            SALES_COUNTY SALES_ID
        FROM 
            COMPANY 
        WHERE 
            COMPANY_ID = #attributes.company_id#
    <cfelseif isdefined("attributes.member_type") and attributes.member_type is 'consumer'>
        SELECT 
            SALES_COUNTY SALES_ID,
            TAX_COUNTRY_ID COUNTRY_ID
        FROM 
            CONSUMER 
        WHERE 
            CONSUMER_ID=#attributes.member_id#
    </cfif>
</cfquery>
<cfif isDefined("attributes.sales_emp_id") and len(attributes.sales_emp_id) and len(attributes.company_id)>
	<cfquery name="get_sales_team" datasource="#dsn#">
		SELECT
			SZT.TEAM_ID
		FROM
			COMPANY C,
			SALES_ZONES_TEAM SZT,
			SALES_ZONES_TEAM_ROLES SZTR
		WHERE
			C.SALES_COUNTY = SZT.SALES_ZONES AND
			SZT.TEAM_ID = SZTR.TEAM_ID AND
			C.COMPANY_ID = #attributes.company_id# AND
			SZTR.POSITION_CODE IN (SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #attributes.sales_emp_id#)
	</cfquery>
	<cfset attributes.sales_team_id = get_sales_team.team_id>
</cfif>
<!---<cfif not (attributes.stock_id)>--->
		<cfscript>
			is_copy=0;
			if(isDefined("attributes.is_copy") and len(attributes.is_copy))
			{
			is_copy=attributes.is_copy;
			}
		
			CreateCompenent = CreateObject("component","AddOns.N1-Soft.textile.cfc.project");
			addProjectInfo=CreateCompenent.wrk_add_project(
				company_id=#attributes.company_id#,
				partner_id=#attributes.member_id#,
				consumer_id='',
				project_emp_id=#session.ep.userid#,
				project_head=#system_paper_no#,
				project_detail="numune ilk kayıt proje",
				process_stage=project_process_stage_id,
				main_process_cat=project_main_category_id,
				is_copy:is_copy
				

			);
			attributes.project_id=ListFirst(addProjectInfo);
			attributes.project_head=ListLast(addProjectInfo);
			system_paper_no=attributes.project_head;
			CreateCompenent = CreateObject("component","AddOns.N1-Soft.textile.cfc.product");
			addProduct=CreateCompenent.addproduct(
				product_cat_id:attributes.product_cat_id,
				sales_emp_id:attributes.sales_emp_id,
				sales_emp:attributes.sales_emp,
				short_code:attributes.short_code,
				short_code_id:attributes.short_code_id,
				ref_no:system_paper_no,
				is_copy:is_copy
			);
			attributes.stock_id=addProduct.stock_id;
			attributes.product_id=addProduct.product_id;
			attributes.stock_name=addProduct.product_name;
			attributes.product_name=addProduct.product_name;
		</cfscript>
<!---</cfif>--->
	<cfif not len(attributes.product_id) and not len(attributes.stock_id)>
		<script>
			alert("Ürün kaydı başarısız!kontrol ediniz");
		</script>
		<cfabort>
	</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_OPPORTUNITY" datasource="#DSN3#" result="MAX_ID">
			INSERT INTO
				TEXTILE_SAMPLE_REQUEST
				(
				REQ_TYPE_ID,
				<cfif attributes.member_type is 'partner'>
					PARTNER_ID,
					COMPANY_ID,	
				<cfelseif attributes.member_type is 'consumer'>
					CONSUMER_ID,
				</cfif>
				<cfif isdefined("attributes.ref_member_type") and attributes.ref_member_type is 'partner'>
					REF_PARTNER_ID,
					REF_COMPANY_ID,				
				<cfelseif isdefined("attributes.ref_member_type") and attributes.ref_member_type is 'consumer'>
					REF_CONSUMER_ID,
				<cfelseif isdefined("attributes.ref_member_type") and attributes.ref_member_type is 'employee'>
					REF_EMPLOYEE_ID,
				<cfelse>
					REF_PARTNER_ID,
					REF_COMPANY_ID,
					REF_CONSUMER_ID,
					REF_EMPLOYEE_ID,
				</cfif>
				REQ_STAGE,
				REQ_DETAIL,
				DESING_EMP_ID,
				COMMETHOD_ID,
				PRODUCT_CAT_ID,
				REQ_DATE,
				INVOICE_DATE,
				ACTION_DATE,
				REQ_CURRENCY_ID,
				REQ_STATUS,
				ACTIVITY_TIME,
				PROBABILITY,
				REQ_ZONE,
				PROJECT_ID,
				REQ_NO,
				SALE_ADD_OPTION_ID,
				SERVICE_ID,
				CUS_HELP_ID,
				CAMPAIGN_ID,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				ADD_RSS,
                COUNTRY_ID,
                SZ_ID,
                EVENT_PLAN_ROW_ID,
				 SHORT_CODE,
				  SHORT_CODE_ID,
				  PRODUCT_ID,
				  STOCK_ID,
				  COMPANY_MODEL_NO,
				  INVOICE_COMPANY_ID,
				  SALES_EMP_ID
				)
			VALUES
				(
				<cfif len(attributes.opportunity_type_id)>#attributes.opportunity_type_id#<cfelse>NULL</cfif>,
				<cfif attributes.member_type is 'partner'>
					#attributes.member_id#,
					#attributes.company_id#,					
				<cfelseif attributes.member_type is 'consumer'>
					#attributes.member_id#,
				</cfif>
				<cfif isdefined("attributes.ref_member_type") and attributes.ref_member_type is 'partner'>
					#attributes.ref_partner_id#,
					#attributes.ref_company_id#,					
				<cfelseif isdefined("attributes.ref_member_type") and attributes.ref_member_type is 'consumer'>
					#attributes.ref_consumer_id#,
				<cfelseif isdefined("attributes.ref_member_type") and attributes.ref_member_type is 'employee'>
					#attributes.ref_employee_id#,
				<cfelse>
					NULL,
					NULL,
					NULL,
					NULL,				
				</cfif>
				#attributes.process_stage#,
				<cfif isDefined("attributes.req_detail") and  len(attributes.req_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.req_detail#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.desing_emp_id") and len(attributes.desing_emp_id) and len(attributes.desing_emp)>#attributes.desing_emp_id#<cfelse>NULL</cfif>,
					<cfif isDefined("attributes.commethod_id") and len(attributes.commethod_id)>#attributes.commethod_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.product_cat_id") and  len(attributes.product_cat_id)>#attributes.product_cat_id#<cfelse>NULL</cfif>,
		
				
				<cfif isDefined("attributes.opp_date") and len(attributes.opp_date)>#attributes.opp_date#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.opp_invoice_date") and  len(attributes.opp_invoice_date)>#attributes.opp_invoice_date#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.action_date") and len(attributes.action_date)>#attributes.action_date#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.opp_currency_id") and len(attributes.opp_currency_id)>#attributes.opp_currency_id#<cfelse>NULL</cfif>,
				1,
				<cfif isdefined("attributes.activity_time") and len(attributes.activity_time)>#attributes.activity_time#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.probability") and len(attributes.probability)>#attributes.probability#<cfelse>NULL</cfif>,
				0,
				<cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#system_paper_no#">,
				<cfif isDefined("attributes.sales_add_option") and len(attributes.sales_add_option)>#attributes.sales_add_option#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.service_id") and  len(attributes.service_id)>#attributes.service_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>#attributes.cus_help_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.camp_name') and len(attributes.camp_name) and isdefined('attributes.camp_id') and Len(attributes.camp_id)>#attributes.camp_id#<cfelse>NULL</cfif>,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				#now()#,
				<cfif isdefined('form.add_rss') and len(form.add_rss)>1<cfelse>0</cfif>,
                <cfif isdefined('attributes.country_id') and len(attributes.country_id)>#attributes.country_id#<cfelseif isdefined("get_country") and len(get_country.country_id)>#get_country.country_id#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.sales_zone_id') and len(attributes.sales_zone_id)>#attributes.sales_zone_id#<cfelseif isdefined("get_country") and len(get_country.sales_id)>#get_country.sales_id#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.event_plan_row_id') and len(attributes.event_plan_row_id)>#event_plan_row_id#<cfelse>NULL</cfif>,
              <cfif len(attributes.short_code)>'#attributes.short_code#'<cfelse>NULL</cfif>,
				<cfif len(attributes.short_code_id)>#attributes.short_code_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product_name)>#attributes.product_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>#attributes.stock_id#<cfelse>NULL</cfif>,
				<cfif IsDefined("attributes.musteri_model_no") and len(attributes.musteri_model_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.musteri_model_no#"><cfelse>NULL</cfif>,
				<cfif IsDefined("attributes.invoice_company_id") and len(attributes.invoice_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_company_id#"><cfelse>NULL</cfif>,
					<cfif IsDefined("attributes.sales_emp_id") and len(attributes.sales_emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_emp_id#"><cfelse>NULL</cfif>
				
			  )
       </cfquery>
	   <cfquery name="add_money" datasource="#dsn3#">
			INSERT INTO TEXTILE_SAMPLE_REQUEST_MONEY
			   ([MONEY_TYPE]
			   ,[ACTION_ID]
			   ,[RATE2]
			   ,[RATE1]
			   ,[IS_SELECTED])
			select 
				MONEY,
				#MAX_ID.IDENTITYCOL#,
				RATE2,
				RATE1,
				0
			from #dsn#.TEXTILE_SETUP_MONEY
			WHERE 
				PERIOD_ID=#session.ep.period_id# AND COMPANY_ID=#session.ep.company_id# AND MONEY_STATUS=1
	   </cfquery>
	   <cfif not (isDefined("attributes.is_copy") and len(attributes.is_copy))>
			   <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
					UPDATE
						GENERAL_PAPERS
					SET
						REQ_NUMBER = #system_paper_no_add#
					WHERE
						REQ_NUMBER IS NOT NULL
				</cfquery>	
		</cfif>
		<cfobject name="supplier" component="addons.n1-soft.textile.cfc.supplier">
		<cfset supplier.dsn3 = dsn3>
		
		<cfif isDefined("attributes.is_copy") and len(attributes.is_copy)>
			<cfscript>
							query_supplier=supplier.copy_supplier(attributes.is_copy,MAX_ID.IDENTITYCOL);
							query_process=supplier.copy_process(attributes.is_copy,MAX_ID.IDENTITYCOL);
							query_asset=supplier.copy_asset(attributes.is_copy,MAX_ID.IDENTITYCOL);
			</cfscript>
			
		</cfif>
		
	</cftransaction>
</cflock>
<cfif isDefined("attributes.asset") and len(attributes.asset)>
	<cfparam name="attributes.stream_name" default=""/>
				<cfset form.ASSET_NAME=attributes.foldername>
				<cfset attributes.ASSETCAT_ID=-3>
				<cfset attributes.ACTION_TYPE="0">
				<cfset attributes.asset_cat_id="">

				<cfset attributes.revision_no="0">
				<cfset attributes.is_active=1>
				<cfset attributes.process_stage=14>
				<cfset attributes.property_id=1>
				<cfset form.ASSET_DESCRIPTION="">
				<cfset form.ASSET_DESCRIPTION="">
				<cfset form.ASSET_DETAIL=""> 
				<cfset attributes.action_section="REQ_ID">
				<cfset form.action_section=attributes.action_section>
				<cfset form.ACTION_TYPE="0">
				<cfset form.ACTION_ID=MAX_ID.IDENTITYCOL>
				<cfset attributes.ACTION_ID=MAX_ID.IDENTITYCOL>
				<cfset attributes.is_stream="">
				<cfset attributes.is_image=0>
				<!---<cfset attributes.STREAM_NAME="">--->
				<cfset attributes.module_id="8">
				<cfset attributes.module="Asset">
				<CFSET attributes.asset="1">

				<cf_papers paper_type="ASSET">
					<cfset system_paper_no=paper_code & '-' & paper_number>
					<cfset system_paper_no_add=paper_number>
					<cfif len(paper_number)>
						<cfset asset_no = system_paper_no>
					<cfelse>
						<cfset asset_no = ''>
					</cfif>
					<cfset attributes.asset_no=system_paper_no>
				<cfinclude template="add_asset.cfm">
	</cfif>

<cf_workcube_process 
        is_upd='1' 
        data_source='#dsn3#' 
        old_process_line='0'
        process_stage='#attributes.process_stage#' 
        record_member='#session.ep.userid#'
        record_date='#now()#' 
        action_table='TEXTILE_SAMPLE_REQUEST'
        action_column='REQ_ID'
        action_id='#MAX_ID.IDENTITYCOL#'
        action_page='#request.self#?fuseaction=textile.list_sample_request&event=upd&req_id=#MAX_ID.IDENTITYCOL#' 
        warning_description='Numune Talep : #system_paper_no#'>

		
		
		
		<!--- 
        company_id='#attributes.company_id#'
        warning_head=' #attributes.opp_head#'
        warning_member=' #attributes.company#'
         --->
<!---
<!---Ek Bilgiler--->
<cfset attributes.info_id = max_id.IDENTITYCOL>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -16>
<cfinclude template="/V16/objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
--->

<script>
		var adres='<cfoutput>index.cfm?fuseaction=textile.list_sample_request&event=det&req_id=#MAX_ID.IDENTITYCOL#</Cfoutput>';
		<cfif isdefined("attributes.is_copy")>
			adres=adres+'&is_copy=<cfoutput>#attributes.is_copy#</cfoutput>';
		</cfif>
	   window.location.href=adres;
</script>

