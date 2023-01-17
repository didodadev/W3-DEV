
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
	
	<cfscript>
		is_copy=0;
		if(isDefined("attributes.is_copy") and len(attributes.is_copy))
		{
		is_copy=attributes.is_copy;
		}
		is_copy_project=0;
		if (isDefined("attributes.copy_type") and findNoCase("devam", attributes.copy_type) gt 0) {
			is_copy_project=attributes.is_copy;
		}
		is_copy_isler = 0;
		if (is_copy and findNoCase("isli", attributes.copy_type) gt 0) {
			is_copy_isler = 1;
		}
		is_copy_price = 0;
		if (is_copy and attributes.copy_type eq "devam_isli") {
			is_copy_price = 1;
		}
	
	
		CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.project");
		addProjectInfo=CreateCompenent.wrk_add_project(
			company_id=#attributes.company_id#,
			partner_id=#attributes.member_id#,
			consumer_id='',
			project_emp_id=#session.ep.userid#,
			project_head=#system_paper_no#,
			project_detail="numune ilk kayıt proje",
			process_stage=project_process_stage_id,
			main_process_cat=project_main_category_id,
			priority_cat= #attributes.opportunity_type_id#,
			is_copy:is_copy_project
			
	
		);
		attributes.project_id=ListFirst(addProjectInfo);
		attributes.project_head=ListLast(addProjectInfo);
		system_paper_no=attributes.project_head;
		CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.product");
		addProduct=CreateCompenent.addproduct(
			product_cat_id:attributes.product_cat_id,
			sales_emp_id:attributes.sales_emp_id,
			sales_emp:attributes.sales_emp,
			short_code:attributes.short_code,
			short_code_id:attributes.short_code_id,
			ref_no:system_paper_no,
			is_copy:is_copy,
			brand_id : attributes.short_code_id,
			brand_name : attributes.short_code
		);
		attributes.stock_id=addProduct.stock_id;
		attributes.product_id=addProduct.product_id;
		attributes.stock_name=addProduct.product_name;
		attributes.product_name=addProduct.product_name;
	</cfscript>
	
	<cfif is_copy_project eq 0>
		<cfquery name="update_paper" datasource="#dsn3#">
			UPDATE GENERAL_PAPERS SET REQ_NUMBER = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#paper_number#'> WHERE PAPER_TYPE IS NULL
		</cfquery>
	</cfif>
	
	<cfif not len(attributes.product_id) and not len(attributes.stock_id)>
		<script>
			alert("Ürün kaydı başarısız!kontrol ediniz");
		</script>
		<cfabort>
	</cfif>
	
	<cfquery name="query_commission_rate" datasource="#dsn3#">
		SELECT sum(ROW_PREMIUM_PERCENT) AS ROW_PREMIUM_PERCENT FROM SALES_QUOTAS_ROW WHERE SUPPLIER_ID = <cfif isDefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>
	</cfquery>
	
	<cfobject name="product_plan" type="component" component="WBP.Fashion.files.cfc.product_plan">
	<cfset getProcess=product_plan.getProcessType()>
	
	<cfif is_copy_price or is_copy_project>
		<cfobject name="sample_request" type="component" component="WBP.Fashion.files.cfc.get_sample_request">
		<cfset query_sample_request = sample_request.getRequest(attributes.is_copy)>
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
						SALES_EMP_ID,
						COMMISSION
						<cfif is_copy_price>
							,CONFIG_PRICE_OTHER
							,CONFIG_PRICE_MONEY
						</cfif>
						<cfif isDefined("attributes.target_price") and len(attributes.target_price)>,TARGET_PRICE</cfif>
						<cfif isDefined("attributes.target_amount") and len(attributes.target_amount)>,TARGET_AMOUNT</cfif>
						<cfif isDefined("attributes.target_money") and len(attributes.target_money)>,TARGET_MONEY</cfif>
						<cfif is_copy>
							,COPY_PROJECT_ID
						</cfif>
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
						<cfif IsDefined("attributes.sales_emp_id") and len(attributes.sales_emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_emp_id#"><cfelse>NULL</cfif>,
						<cfif query_commission_rate.recordCount gt 0 and len(query_commission_rate.ROW_PREMIUM_PERCENT)><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#query_commission_rate.ROW_PREMIUM_PERCENT#"><cfelse>NULL</cfif>
						<cfif is_copy_price>
							,#query_sample_request.CONFIG_PRICE_OTHER#
							,'#query_sample_request.CONFIG_PRICE_MONEY#'
						</cfif>
						<cfif isDefined("attributes.target_price") and len(attributes.target_price)>,<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#replace(attributes.TARGET_PRICE, ",", ".")#'></cfif>
						<cfif isDefined("attributes.target_amount") and len(attributes.target_amount)>,<cfqueryparam cfsqltype='CF_SQL_BIGINT' value='#attributes.target_amount#'></cfif>
						<cfif isDefined("attributes.target_money") and len(attributes.target_money)>,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.TARGET_MONEY#'></cfif>
						<cfif is_copy>
							,<cfqueryparam cfsqltype="cf_sql_integer" value="#is_copy#">
						</cfif>
				  )
		   </cfquery>
	
		   <cfquery name="query_commission_rate" datasource="#dsn3#">
				SELECT ROW_PREMIUM_PERCENT FROM SALES_QUOTAS_ROW WHERE SUPPLIER_ID = <cfif isDefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>
			</cfquery>
	
		   <cfquery name="add_money" datasource="#dsn3#">
				INSERT INTO TEXTILE_SAMPLE_REQUEST_MONEY
				   (MONEY_TYPE
				   ,ACTION_ID
				   ,RATE2
				   ,RATE1
				   ,IS_SELECTED
				   ,COMMISSION)
				select 
					MONEY,
					#MAX_ID.IDENTITYCOL#,
					RATE2,
					RATE1,
					0,
					#query_commission_rate.recordCount gt 0 ? query_commission_rate.ROW_PREMIUM_PERCENT : 'NULL'#
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
	
			<cfobject name="supplier" component="WBP.Fashion.files.cfc.supplier">
			<cfset supplier.dsn3 = dsn3>
			
			<cfif isDefined("attributes.is_copy") and len(attributes.is_copy)>
				
				<cfset query_asset=supplier.copy_asset(attributes.is_copy,MAX_ID.IDENTITYCOL)>
				
				<cfif is_copy_isler>
					
					<cfset query_supplier = supplier.copy_supplier(attributes.is_copy, MAX_ID.IDENTITYCOL)>
					<cfset query_process = supplier.copy_process(attributes.is_copy, MAX_ID.IDENTITYCOL)>
					
					<cfquery name="query_copy_plan" datasource="#dsn3#">
						SELECT
							#MAX_ID.IDENTITYCOL# AS REQUEST_ID
							,CONVERT(DATE, GETDATE()) AS PLAN_DATE
							,GETDATE() AS START_DATE
							,GETDATE() AS FINISH_DATE
							,ACTIVE
							,PLAN_TYPE_ID
							,PLAN_TYPE
							,177
							,GETDATE()
							,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#session.ep.userid#'>
							,NULL
							,NULL
							,TASK_EMP
							,0
							,WORK_ID
							,0
						FROM TEXTILE_PRODUCT_PLAN
						WHERE ACTIVE = 1 AND REQUEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.is_copy#'>
					</cfquery>
	
					<cfloop query="query_copy_plan">
						<cfset operation_ids = 0>
	
						<cfif query_copy_plan.PLAN_TYPE_ID eq 5 or query_copy_plan.PLAN_TYPE_ID eq 7>
							<cfquery name="query_plan_type" dbtype="query">
								SELECT OPERATION_RELATIONS FROM getProcess WHERE PROCESS_CAT_ID = #query_copy_plan.PLAN_TYPE_ID#
							</cfquery>
							<cfset operation_ids = valueList(query_plan_type.OPERATION_RELATIONS)>
						</cfif>
						
						<cfset product_plan.add_productplan(query_copy_plan.PLAN_TYPE_ID, query_copy_plan.PLAN_TYPE, attributes.project_id, MAX_ID.IDENTITYCOL, dateformat(now(), dateformat_style), dateformat(now(), dateformat_style), dateformat(now(), dateformat_style), 0, session.ep.userid, 1, 1, operation_ids)>
					</cfloop>

					<cfquery name="query_copy_asset" datasource="#dsn3#">
						INSERT INTO #dsn#.ASSET(
							MODULE_NAME
							,MODULE_ID
							,ACTION_SECTION
							,ACTION_ID
							,ACTION_VALUE
							,ASSETCAT_ID
							,ASSET_FILE_NAME
							,ASSET_FILE_SIZE
							,ASSET_FILE_SERVER_ID
							,ASSET_FILE_FORMAT
							,ASSET_NAME
							,ASSET_DESCRIPTION
							,ASSET_DETAIL
							,PROPERTY_ID
							,COMPANY_ID
							,RECORD_DATE
							,RECORD_PAR
							,RECORD_PUB
							,RECORD_EMP
							,RECORD_IP
							,UPDATE_DATE
							,UPDATE_PAR
							,UPDATE_PUB
							,UPDATE_EMP
							,UPDATE_IP
							,IS_INTERNET
							,SERVER_NAME
							,DEPARTMENT_ID
							,BRANCH_ID
							,IS_IMAGE
							,IMAGE_SIZE
							,IS_SPECIAL
							,RESPONSED_ASSET_ID
							,IS_LIVE
							,FEATURED
							,DURATION
							,RATING
							,DOWNLOAD_COUNT
							,COMMENT_COUNT
							,FAVORITE_COUNT
							,RATING_COUNT
							,CONSUMER_ID
							,ASSET_FILE_REAL_NAME
							,ASSET_FILE_PATH_NAME
							,ASSET_STAGE
							,MAIL_RECEIVER_ID
							,MAIL_CC_ID
							,MAIL_RECEIVER_IS_EMP
							,MAIL_CC_IS_EMP
							,ASSET_NO
							,PERIOD_ID
							,PROJECT_ID
							,RECORD_CON
							,REVISION_NO
							,IS_ACTIVE
							,IS_DPL
							,PRODUCT_ID
							,LIVE
							,PROJECT_MULTI_ID
							,RELATED_ASSET_ID
							,RELATED_COMPANY_ID
							,RELATED_CONSUMER_ID
							,VALIDATE_FINISH_DATE
							,VALIDATE_START_DATE
							,EMBEDCODE_URL
							,TV_CAT_ID
							,IS_TV_PUBLISH
							,IS_RADIO
							,PASSWORD
						) SELECT 
							MODULE_NAME
							,MODULE_ID
							,ACTION_SECTION
							,#MAX_ID.IDENTITYCOL#
							,ACTION_VALUE
							,ASSETCAT_ID
							,ASSET_FILE_NAME
							,ASSET_FILE_SIZE
							,ASSET_FILE_SERVER_ID
							,ASSET_FILE_FORMAT
							,ASSET_NAME
							,ASSET_DESCRIPTION
							,ASSET_DETAIL
							,PROPERTY_ID
							,COMPANY_ID
							,RECORD_DATE
							,RECORD_PAR
							,RECORD_PUB
							,RECORD_EMP
							,RECORD_IP
							,UPDATE_DATE
							,UPDATE_PAR
							,UPDATE_PUB
							,UPDATE_EMP
							,UPDATE_IP
							,IS_INTERNET
							,SERVER_NAME
							,DEPARTMENT_ID
							,BRANCH_ID
							,IS_IMAGE
							,IMAGE_SIZE
							,IS_SPECIAL
							,RESPONSED_ASSET_ID
							,IS_LIVE
							,FEATURED
							,DURATION
							,RATING
							,DOWNLOAD_COUNT
							,COMMENT_COUNT
							,FAVORITE_COUNT
							,RATING_COUNT
							,CONSUMER_ID
							,ASSET_FILE_REAL_NAME
							,ASSET_FILE_PATH_NAME
							,ASSET_STAGE
							,MAIL_RECEIVER_ID
							,MAIL_CC_ID
							,MAIL_RECEIVER_IS_EMP
							,MAIL_CC_IS_EMP
							,ASSET_NO
							,PERIOD_ID
							,PROJECT_ID
							,RECORD_CON
							,REVISION_NO
							,IS_ACTIVE
							,IS_DPL
							,PRODUCT_ID
							,LIVE
							,PROJECT_MULTI_ID
							,RELATED_ASSET_ID
							,RELATED_COMPANY_ID
							,RELATED_CONSUMER_ID
							,VALIDATE_FINISH_DATE
							,VALIDATE_START_DATE
							,EMBEDCODE_URL
							,TV_CAT_ID
							,IS_TV_PUBLISH
							,IS_RADIO
							,PASSWORD
						FROM #dsn#.ASSET 
						WHERE MODULE_NAME = 'textile' AND ACTION_SECTION = 'REQUEST_ID' AND ACTION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.is_copy#'>
					</cfquery>
				<cfelse>

					<cfset query_supplier = supplier.copy_supplier_empty(attributes.is_copy, MAX_ID.IDENTITYCOL)>
					<cfset query_process = supplier.copy_process_empty(attributes.is_copy, MAX_ID.IDENTITYCOL)>
						
				</cfif>
	
				<cfif is_copy_project>
					<cfquery name="query_copy_notes" datasource="#dsn3#">
						INSERT INTO #dsn#.NOTES (
							ACTION_SECTION
							,ACTION_ID
							,NOTE_HEAD
							,NOTE_BODY
							,RECORD_DATE
							,RECORD_IP
							,RECORD_CONS
							,RECORD_PAR
							,RECORD_EMP
							,UPDATE_DATE
							,UPDATE_IP
							,UPDATE_EMP
							,UPDATE_PAR
							,UPDATE_CONS
							,COMPANY_ID
							,IS_SPECIAL
							,IS_WARNING
							,ACTION_VALUE
							,PERIOD_ID
							,IS_LINK
						)
						SELECT 
						ACTION_SECTION
							,#MAX_ID.IDENTITYCOL#
							,NOTE_HEAD
							,NOTE_BODY
							,RECORD_DATE
							,RECORD_IP
							,RECORD_CONS
							,RECORD_PAR
							,RECORD_EMP
							,UPDATE_DATE
							,UPDATE_IP
							,UPDATE_EMP
							,UPDATE_PAR
							,UPDATE_CONS
							,COMPANY_ID
							,IS_SPECIAL
							,IS_WARNING
							,ACTION_VALUE
							,PERIOD_ID
							,IS_LINK
						FROM #dsn#.NOTES
						WHERE ACTION_SECTION = 'TEXTILE_SAMPLE_REQUEST'
							AND ACTION_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.is_copy#'>
					</cfquery>
				</cfif>
	
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
	
	<script>
		var adres='<cfoutput>index.cfm?fuseaction=textile.list_sample_request&event=det&req_id=#MAX_ID.IDENTITYCOL#</Cfoutput>';
		<cfif isdefined("attributes.is_copy")>
			adres=adres+'&is_copy=<cfoutput>#attributes.is_copy#</cfoutput>';
		</cfif>
		window.location.href=adres;
	</script>
	
	