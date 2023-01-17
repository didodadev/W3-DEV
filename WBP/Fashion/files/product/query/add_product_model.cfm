<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfif attributes.model_id eq 0>
			<cfquery name="add_product_model" datasource="#dsn1#" result="MAX_ID">
				INSERT INTO
					PRODUCT_BRANDS_MODEL
				(
					MODEL_CODE,
					MODEL_NAME,
                    BRAND_ID,
					RECORD_IP,
					RECORD_EMP,
					RECORD_DATE,
					REQUEST_ID,
					STAGE_ID,
					EMP_ID,
					PLAN_ID
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.model_code#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.model_name#">,
                    <cfif len(attributes.brand_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"><cfelse>Null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">,
					<cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
					<cfif len(attributes.sales_emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_emp_id#"><cfelse>NULL</cfif>,
					<cfif len(attributes.plan_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.plan_id#"><cfelse>NULL</cfif>
				)
			</cfquery>
			<cfquery name="get_product" datasource="#dsn1#">
				select *from #dsn3#.TEXTILE_SAMPLE_REQUEST WHERE REQ_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.req_id#">
			</cfquery>
			<cfif len(get_product.product_id)>
				<cfquery name="upd_product" datasource="#dsn1#">
					UPDATE PRODUCT
					SET 
						SHORT_CODE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
						SHORT_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.model_name#">
					WHERE
					PRODUCT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.product_id#">
				</cfquery>
				<cfquery name="upd_req" datasource="#dsn1#">
					UPDATE #dsn3#.TEXTILE_SAMPLE_REQUEST
					SET 
						SHORT_CODE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
						SHORT_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.model_name#">
					WHERE 
						REQ_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.req_id#">
				</cfquery>
				<cfquery name="upd_req" datasource="#dsn1#">
					UPDATE #dsn3#.TEXTILE_PRODUCT_PLAN
					SET 
						STAGE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
					WHERE 
						REQUEST_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#"> and
						PLAN_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.plan_id#">
				</cfquery>
			</cfif>
			<cfset attributes.model_id=MAX_ID.IDENTITYCOL>
		<cfelse>
			<cfquery name="ADD_PRODUCT_BRANDS" datasource="#dsn1#">
				UPDATE
					PRODUCT_BRANDS_MODEL
				SET
					MODEL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.model_code#">,
					MODEL_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.model_name#">,
                    BRAND_ID= <cfif len(attributes.brand_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"><cfelse>NULL</cfif>,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					REQUEST_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">,
					STAGE_ID=<cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
					EMP_ID=<cfif len(attributes.sales_emp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_emp_id#"><cfelse>NULL</cfif>
				WHERE
					MODEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.model_id#">
			</cfquery>
			<cfquery name="upd_req" datasource="#dsn1#">
					UPDATE #dsn3#.TEXTILE_PRODUCT_PLAN
					SET 
						STAGE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
					WHERE 
						REQUEST_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#"> and
						PLAN_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.plan_id#">
				</cfquery>
			
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
				<cfset attributes.action_section="PRODUCT_MODEL_ID">
				<cfset form.action_section=attributes.action_section>
				<cfset form.ACTION_TYPE="0">
				<cfset form.ACTION_ID=attributes.model_id>
				<cfset attributes.ACTION_ID=attributes.model_id>
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
				<cfinclude template="../../cfc/add_asset.cfm">
	</cfif>
		<cf_workcube_process 
        is_upd='1' 
        data_source='#dsn3#' 
        old_process_line='0'
        process_stage='#attributes.process_stage#' 
        record_member='#session.ep.userid#'
        record_date='#now()#' 
        action_table='TEXTILE_PRODUCT_PLAN'
        action_column='PLAN_ID'
        action_id='#attributes.plan_id#'
        action_page='#request.self#?fuseaction=textile.list_product_models&event=upd&req_id=#attributes.request_id#&plan_id=#attributes.plan_id#&model_id=#attributes.model_id#' 
        warning_description='Model : #attributes.model_name#'>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
