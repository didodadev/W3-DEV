<cf_xml_page_edit fuseact="textile.list_sample_request">
<cfif isDefined("attributes.asset_add")>
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
	<cfset form.ACTION_ID=attributes.req_id>
	<cfset attributes.ACTION_ID=attributes.req_id>
	<cfset attributes.is_stream="">
	<cfset attributes.is_image=1>
	<!---<cfset attributes.STREAM_NAME="">--->
	<cfset attributes.module_id="99">
	<cfset attributes.module="textile">
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
<cfelseif isdefined("attributes.olcu_tablo")>
	<cfinclude template="add_measure_table.cfm">
<cfelse>
<cfif not len(attributes.stock_id) and not isDefined(attributes.stock_id)>
	<cfscript>
		CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.product");
		addProduct=CreateCompenent.addproduct(
			product_cat_id:attributes.product_cat_id,
			product_name:attributes.stock_name,
			brand_id:attributes.short_code_id,
			brand_name:attributes.short_code,
			sales_emp_id=attributes.sales_emp_id,
			sales_emp=attributes.sales_emp,
			short_code=attributes.short_code,
			short_code_id=attributes.short_code_id
			
		);
		attributes.stock_id=addProduct.stock_id;
		attributes.product_id=addProduct.product_id;
		attributes.stock_name=addProduct.product_name;
		attributes.product_name=addProduct.product_name;
	</cfscript>
</cfif>
<cf_xml_page_edit fuseact="sales.form_add_opportunity">
	<cfif form.active_company neq session.ep.company_id>
		<script type="text/javascript">
			alert("İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı. Muhasebe Döneminizi Kontrol Ediniz !");
			window.location.href='<cfoutput>#request.self#?fuseaction=sales.list_order</cfoutput>';
		</script>
		<cfabort>
	</cfif>
	<cfif len(attributes.opp_date)><cf_date tarih="attributes.opp_date"></cfif>
	<cfif isdefined("attributes.opp_invoice_date") and  len(attributes.opp_invoice_date)><cf_date tarih="attributes.opp_invoice_date"></cfif>
	<cfif isdefined("attributes.action_date") and  len(attributes.action_date)><cf_date tarih="attributes.action_date"></cfif>
	<cfset attributes.sales_team_id = ''>
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
				CONSUMER_ID = #attributes.member_id#
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
		if(isdefined("to_par_ids")) CC_PARS = ListSort(to_par_ids,"Numeric", "Desc"); else CC_PARS = "";
		if(isdefined("to_pos_ids")) CC_POS = ListSort(to_pos_ids,"Numeric", "Desc"); else CC_POS = "";
		if(isdefined("to_cons_ids")) CC_CONS = ListSort(to_cons_ids,"Numeric", "Desc"); else CC_CONS ='';
		if(isdefined("to_grp_ids")) CC_GRPS = ListSort(to_grp_ids,"Numeric", "Desc") ; else CC_GRPS ='';
	</cfscript>

	<cflock name="#CREATEUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="UPD_OPPORTUNITY" datasource="#DSN3#">
				UPDATE
					TEXTILE_SAMPLE_REQUEST
				SET
						REQ_TYPE_ID = <cfif len(attributes.opportunity_type_id)>#attributes.opportunity_type_id#<cfelse>NULL</cfif>,
				<cfif attributes.member_type is 'partner'>
					PARTNER_ID = #attributes.member_id#,
					COMPANY_ID = #attributes.company_id#,
					CONSUMER_ID = NULL,
				<cfelseif attributes.member_type is 'consumer'>
					PARTNER_ID = NULL,
					COMPANY_ID = NULL,
					CONSUMER_ID = #attributes.member_id#,
				</cfif>
				<cfif isdefined("attributes.ref_member_type") and attributes.ref_member_type is 'partner' and len(attributes.ref_member)>
					REF_PARTNER_ID = #attributes.ref_partner_id#,
					REF_COMPANY_ID = #attributes.ref_company_id#,
					REF_CONSUMER_ID = NULL,
					REF_EMPLOYEE_ID = NULL,
				<cfelseif isdefined("attributes.ref_member_type") and attributes.ref_member_type is 'consumer' and len(attributes.ref_member)>
					REF_PARTNER_ID = NULL,
					REF_COMPANY_ID = NULL,
					REF_CONSUMER_ID = #attributes.ref_consumer_id#,
					REF_EMPLOYEE_ID = NULL,
				<cfelseif isdefined("attributes.ref_member_type") and attributes.ref_member_type is 'employee' and len(attributes.ref_member)>
					REF_PARTNER_ID = NULL,
					REF_COMPANY_ID = NULL,
					REF_CONSUMER_ID = NULL,
					REF_EMPLOYEE_ID = #attributes.ref_employee_id#,
				<cfelse>
					REF_PARTNER_ID = NULL,
					REF_COMPANY_ID = NULL,
					REF_CONSUMER_ID = NULL,
					REF_EMPLOYEE_ID = NULL,
				</cfif>
					REQ_STAGE = <cfif isdefined("attributes.process_stage")>#attributes.process_stage#,<cfelse>NULL,</cfif>		
					COMMETHOD_ID = <cfif isdefined("attributes.commethod_id") and len(attributes.commethod_id)>#attributes.commethod_id#<cfelse>NULL</cfif>,
					PRODUCT_CAT_ID = <cfif isdefined("attributes.product_cat_id") and  len(attributes.product_cat_id)>#attributes.product_cat_id#<cfelse>NULL</cfif>,
					REQ_DETAIL = <cfif isDefined("attributes.req_detail") and  len(attributes.req_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.req_detail#"><cfelse>NULL</cfif>,
					INCOME = <cfif isDefined("attributes.income") and len(attributes.income)>#attributes.income#<cfelse>NULL</cfif>,
					MONEY = <cfif isDefined("attributes.money") and len(attributes.income)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money#"><cfelse>NULL</cfif>,
					COST = <cfif isDefined("attributes.cost") and len(attributes.cost)>#attributes.cost#<cfelse>NULL</cfif>,
					MONEY2 = <cfif isDefined("attributes.money2")  and len(attributes.cost)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money2#"><cfelse>NULL</cfif>,
				<!---	STOCK_ID = <cfif isdefined("attributes.stock_id") and len(attributes.stock_id) and len(attributes.stock_name)>#attributes.stock_id#<cfelse>NULL</cfif>,
					PRODUCT_ID=<cfif isdefined("attributes.product_id") and len(attributes.product_id) and len(attributes.product_name)>#attributes.product_id#<cfelse>NULL</cfif>,
					--->
					SALES_TEAM_ID = <cfif isdefined("attributes.sales_team_id") and len(attributes.sales_team_id)>#attributes.sales_team_id#<cfelse>NULL</cfif>,
					DESING_EMP_ID = <cfif isdefined("attributes.desing_emp_id") and len(attributes.desing_emp_id) and len(attributes.desing_emp)>#attributes.desing_emp_id#<cfelse>NULL</cfif>,
					SALES_EMP_ID = <cfif isdefined("attributes.sales_emp_id") and len(attributes.sales_emp_id) and len(attributes.sales_emp)>#attributes.sales_emp_id#<cfelse>NULL</cfif>,
					SALES_PARTNER_ID = <cfif isdefined("attributes.sales_member") and len(attributes.sales_member) and len(attributes.sales_member_id) and len(attributes.sales_member_type) and attributes.sales_member_type eq 'partner'>#attributes.sales_member_id#<cfelse>NULL</cfif>,
					SALES_CONSUMER_ID = <cfif isdefined("attributes.sales_member") and len(attributes.sales_member) and len(attributes.sales_member_id) and len(attributes.sales_member_type) and attributes.sales_member_type eq 'consumer'>#attributes.sales_member_id#<cfelse>NULL</cfif>,
					REQ_DATE = <cfif len(attributes.opp_date)>#attributes.opp_date#<cfelse>NULL</cfif>,
					INVOICE_DATE = <cfif isdefined("attributes.opp_invoice_date") and  len(attributes.opp_invoice_date)>#attributes.opp_invoice_date#<cfelse>NULL</cfif>,
					ACTION_DATE = <cfif isdefined("attributes.action_date") and len(attributes.action_date)>#attributes.action_date#<cfelse>NULL</cfif>,
					REQ_CURRENCY_ID = <cfif IsDefined("attributes.opp_currency_id") and len(attributes.opp_currency_id)>#attributes.opp_currency_id#<cfelse>NULL</cfif>,
					REQ_STATUS = <cfif isDefined("attributes.opp_status")>1<cfelse>0</cfif>,
					ACTIVITY_TIME = <cfif isdefined("attributes.activity_time") and len(attributes.activity_time)>#attributes.activity_time#<cfelse>NULL</cfif>,
					PROBABILITY = <cfif isDefined("attributes.probability") and len(attributes.probability)>#attributes.probability#<cfelse>NULL</cfif>,
					REQ_ZONE = 0,
					<!---PROJECT_ID = <cfif isDefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,--->
					REQ_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.req_no#">,
					CC_GRP_IDS = <cfif len(CC_GRPS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CC_GRPS#"><cfelse>NULL</cfif>,
					CC_CON_IDS = <cfif len(CC_CONS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CC_CONS#"><cfelse>NULL</cfif>,
					CC_PAR_IDS = <cfif len(CC_PARS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CC_PARS#"><cfelse>NULL</cfif>,
					CC_POSITIONS = <cfif len(CC_POS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CC_POS#"><cfelse>NULL</cfif>,
					SALE_ADD_OPTION_ID = <cfif isdefined("attributes.sales_add_option") and  len(attributes.sales_add_option)>#attributes.sales_add_option#<cfelse>NULL</cfif>,
					PREFERENCE_REASON_ID = <cfif isdefined("attributes.rival_preference_reason") and len(attributes.rival_preference_reason)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#attributes.rival_preference_reason#,"><cfelse>NULL</cfif>,        
					UPDATE_EMP = #session.ep.userid#,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					UPDATE_DATE = #now()#,
					ADD_RSS = <cfif isdefined('form.add_rss') and len(form.add_rss)>1<cfelse>0</cfif>,
					SHORT_CODE=<cfif len(attributes.short_code)>'#attributes.short_code#'<cfelse>NULL</cfif>,
					SHORT_CODE_ID=<cfif len(attributes.short_code_id)>#attributes.short_code_id#<cfelse>NULL</cfif>,
					COMPANY_ORDER_NO=<cfif len(attributes.order_no)>'#attributes.order_no#'<cfelse>NULL</cfif>,
					COMPANY_MODEL_NO=<cfif isDefined("attributes.musteri_model_no") and len(attributes.musteri_model_no)>'#attributes.musteri_model_no#'<cfelse>NULL</cfif>
					<cfif attributes.process_stage eq revision_work_order_stage_id>,CONFIG_STATUS=0</cfif>
					<cfif isDefined("attributes.gyg_fire") and len(attributes.gyg_fire)>,GYG_FIRE=<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#attributes.gyg_fire#'></cfif>
					<cfif isDefined("attributes.CONFIG_PRICE_OTHER") and len(attributes.CONFIG_PRICE_OTHER)>,CONFIG_PRICE_OTHER=<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#replace(attributes.CONFIG_PRICE_OTHER, ",", ".")#'></cfif>
					<cfif isDefined("attributes.CONFIG_PRICE_MONEY") and len(attributes.CONFIG_PRICE_MONEY)>,CONFIG_PRICE_MONEY = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.CONFIG_PRICE_MONEY#'></cfif>
					<cfif isDefined("attributes.commission") and len(attributes.commission)>,COMMISSION=<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#replace(attributes.commission, ",", ".")#'></cfif>
					<cfif isDefined("attributes.copy_project_id") and len(attributes.copy_project_id)>,COPY_PROJECT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.copy_project_id#'></cfif>
					<cfif isDefined("attributes.target_price") and len(attributes.target_price)>,TARGET_PRICE = <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#replace(attributes.TARGET_PRICE, ",", ".")#'></cfif>
					<cfif isDefined("attributes.target_amount") and len(attributes.target_amount)>,TARGET_AMOUNT = <cfqueryparam cfsqltype='CF_SQL_BIGINT' value='#attributes.target_amount#'></cfif>
					<cfif isDefined("attributes.target_money") and len(attributes.target_money)>,TARGET_MONEY = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.TARGET_MONEY#'></cfif>
				WHERE
					REQ_ID = #attributes.req_id#
			</cfquery>
		</cftransaction>
	</cflock>
	<cfif attributes.process_stage eq work_order_stage_id>		
		<cfobject name="request_" component="WBP.Fashion.files.cfc.get_sample_request">
		<cfobject name="product_plan" component="WBP.Fashion.files.cfc.product_plan">
		<cfobject name="stretching_test" component="WBP.Fashion.files.cfc.stretching_test">
			<cfscript>
				request_.dsn3=dsn3;
				requestResult=request_.getRequest(req_id:attributes.req_id);
				getProcess=product_plan.getProcessType();
				attributes.plan_id="";
					
				for(rows in getProcess)
				{
					attributes.plan_type_id=rows.process_cat_id;
					attributes.plan_type=rows.process_cat;
					attributes.date_start="";
					attributes.date_finish="";
					attributes.plan_date="#now()#";
					attributes.stop_washing = 0;
					attributes.operation_relations = rows.OPERATION_RELATIONS;
					query_product_plan=product_plan.list_productplan
						(
							plan_id:attributes.plan_id,
							plan_type_id:attributes.plan_type_id,
							req_id:attributes.req_id
						);
					if (attributes.plan_type_id eq 7) {
						qsrprocess = product_plan.getSrProcess(attributes.req_id, attributes.operation_relations);
						if (qsrprocess.recordcount eq 0) {
							attributes.stop_washing = 1;
						}
					}
					if(query_product_plan.recordcount eq 0 and attributes.stop_washing eq 0)
					{
						query_product_plan=product_plan.add_productplan(
							plan_type_id:attributes.plan_type_id,
							plan_type:attributes.plan_type,
							project_id:attributes.project_id,
							plan_id:attributes.plan_id,
							req_id:attributes.req_id,
							plan_date:attributes.plan_date,
							start_date:isdefined("attributes.date_start") and len(attributes.date_start) ? attributes.date_start : now(),
							finish_date:attributes.date_finish,
							operation_relations:attributes.operation_relations
							);
					}
					if(ListFind('2,3',attributes.plan_type_id))
					{
						query_revision_product_plan=product_plan.revision_demand
							(plan_id:attributes.plan_id,
								plan_type_id:attributes.plan_type_id,
								req_id:attributes.req_id,
								is_revision:1
							);
						if(query_revision_product_plan.recordcount)
						{
							query_product_plan=product_plan.add_productplan(
								plan_type_id:attributes.plan_type_id,
								plan_type:attributes.plan_type,
								project_id:attributes.project_id,
								plan_id:attributes.plan_id,
								req_id:attributes.req_id,
								plan_date:attributes.plan_date,
								start_date:isdefined("attributes.date_start") and len(attributes.date_start) ? attributes.date_start : now(),
								finish_date:attributes.date_finish,
								is_revision=1
								);
							if(attributes.plan_type_id eq 2)//kumas revizesi ise kaliba is gonder
							{
								query_product_plan=product_plan.add_productplan(
								plan_type_id:4,
								plan_type:'Modelhane İşlemleri',
								project_id:attributes.project_id,
								plan_id:attributes.plan_id,
								req_id:attributes.req_id,
								plan_date:attributes.plan_date,
								start_date:isdefined("attributes.date_start") and len(attributes.date_start) ? attributes.date_start : now(),
								finish_date:attributes.date_finish
								);
							}
						}
					}
					if(attributes.plan_type_id eq 5)//işçilikler
					{
						query_revision_product_plan=product_plan.revision_workmanship //is olusmamıs revizyon varmi?
							(plan_type_id:attributes.plan_type_id,
								req_id:attributes.req_id,
								is_revision:1,
								pcatid:workshipman_pcatid
							);
						if(query_revision_product_plan.recordcount)//is olusmamıs revizyon var ise is olustur
						{
							query_product_plan=product_plan.add_productplan(
							plan_type_id:attributes.plan_type_id,
							plan_type:attributes.plan_type,
							project_id:attributes.project_id,
							plan_id:attributes.plan_id,
							req_id:attributes.req_id,
							plan_date:attributes.plan_date,
							start_date:isdefined("attributes.date_start") and len(attributes.date_start) ? attributes.date_start : now(),
							finish_date:attributes.date_finish,
							is_revision=1,
							operation_relations:attributes.operation_relations
							);
						}
					}													
				}
			</cfscript>
			<cfquery name="get_work_process_stretching" datasource="#DSN#" maxrows="1">
				SELECT TOP 1
					PTR.STAGE,
					PTR.PROCESS_ROW_ID
				FROM 
					PROCESS_TYPE_ROWS  PTR,																								
					PROCESS_TYPE_OUR_COMPANY PTO,
					PROCESS_TYPE PT
				WHERE
					PT.PROCESS_ID = PTR.PROCESS_ID AND
					PT.PROCESS_ID = PTO.PROCESS_ID AND
					PTO.OUR_COMPANY_ID = #session.ep.company_id# AND <!--- company_id gönderilsin --->
					PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%textile.stretching_test%">
					ORDER BY
							PTR.LINE_NUMBER
			</cfquery>
			<cfscript>
				old_stretching_text = stretching_test.list_stretching_test(project_id = attributes.project_id);
				if (not old_stretching_text.recordcount) 
				{
					addResult=stretching_test.add_stretching_test
					(
						test_date:now(),
						author_id:session.ep.userid,
						project_id:attributes.project_id,
						//order_id:order_id,
						employee_id:session.ep.userid,
						//purchasing_id:attributes.req_id,
						fabric_arrival_date:isdefined("attributes.date_start") and len(attributes.date_start) ? attributes.date_start : now(),
						req_id: attributes.req_id,
						stageid: get_work_process_stretching.PROCESS_ROW_ID
					);
				}
			</cfscript>			
	</cfif>	
	<cf_workcube_process 
		is_upd='1' 
		data_source='#dsn3#' 
		process_stage='#attributes.process_stage#' 
		old_process_line='#attributes.old_process_line#'
		record_member='#session.ep.userid#'
		record_date='#now()#'
		action_table='TEXTILE_SAMPLE_REQUEST'
		action_column='REQ_ID'
		action_id='#form.req_id#' 
		action_page='#request.self#?fuseaction=textile.list_sample_request&event=det&req_id=#attributes.req_id#' 
		warning_description='Numune Talep : #attributes.req_no#'>
		<cfset attributes.actionId =attributes.req_id>
</cfif>

<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=textile.list_sample_request&event=det&req_id=#attributes.req_id#</cfoutput>';
</script>