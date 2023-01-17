<link rel="stylesheet" href="/css/assets/template/w3-intranet/intranet.css" type="text/css">
<cfset pagefuseact =#attributes.fuseaction#>
<cf_xml_page_edit fuseact="textile.list_sample_request">
<cfinclude template="../../helpers/stringhelper.cfm">
<cfparam name="attributes.req_id" default="">
<cfparam name="attributes.plan_id" default="">
<cfparam name="attributes.plan_type_id" default="5">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.author_id" default="">
<cfparam name="attributes.date_start" default="">
<cfparam name="attributes.date_end" default="">
<cfparam name="attributes.author_title" default="">
<cfparam name="attributes.project_title" default="">

<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.project_emp_id" default="">
<cfparam name="attributes.emp_name" default="">
<cfparam name="attributes.req_no" default="">
<cfparam name="attributes.order_no" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_revision" default="">




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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#pagefuseact#%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<cfobject name="product_plan" component="WBP.Fashion.files.cfc.product_plan">
<cfset product_plan.dsn3 = dsn3>
<cfscript>
    CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_req_supplier_rival");
    getAuthority=CreateCompenent.getProcessAuthority(process_stage:full_stage_id);
</cfscript>

<cfif getAuthority gt 0>
    <cfset access=0>
<cfelse>
    <cfset access=2>
</cfif>

<cfif isDefined("attributes.not_is_task")>
	<cfset is_task=0>
<cfelse>
	<cfset is_task=1>
</cfif>
<cfset query_product_plan=product_plan.list_productplan(
								plan_id:attributes.plan_id,
								plan_type_id:attributes.plan_type_id,
								req_id:attributes.req_id,
								project_id:attributes.project_id,
								date_start:attributes.date_start,
								date_end:attributes.date_end,
								req_no:attributes.req_no,
								project_emp_id:attributes.project_emp_id,
								task_emp_name:attributes.emp_name,
								process_stage:attributes.process_stage,
								access:access,
								is_task:is_task,
								company_order_no:attributes.order_no,
								is_revision:attributes.is_revision
								)>

                                <cfsavecontent variable ="title">
                                    <cf_get_lang dictionary_id="41264"> <BR/> No
                                </cfsavecontent>
                                <cfsavecontent variable ="header">
									<cf_get_lang dictionary_id="41264">
                                </cfsavecontent>
                                <cfinclude template="all_plan.cfm">
