<cfparam name="attributes.req_id" default="">
<cfif not len(attributes.req_id)>
    <div>Numune ID eksik!</div>
    <cfexit>
</cfif>

<cfset attributes.iid = attributes.req_id>
<cfquery name="query_get_report" datasource="#dsn3#">
    SELECT TEMPLATE_FILE, IS_STANDART FROM SETUP_PRINT_FILES WHERE FORM_ID = 69
</cfquery>
<cfif query_get_report.recordCount eq 0>
    <div>Numune Şablonu Bulunamadı!</div>
    <cfexit>
</cfif>
<cfset file_web_path = application.systemParam.systemParam().file_web_path />
<cfset fileDir =  query_get_report.is_standart ? "/#query_get_report.template_file#" : "#file_web_path#settings/#query_get_report.template_file#" />
<cf_box title="Numune Bilgileri">
    <cfinclude template="#fileDir#">
</cf_box>
<cftry>
    
    <cfcatch>
    <div>Şablon dosyası bulunamadı! <cfoutput><i>#cfcatch#</i></cfoutput></div>
    <cfexit>
    </cfcatch>
</cftry>
<cfinclude template="../query/get_req.cfm">
<cf_get_textile_labor_critics company_id='#get_opportunity.company_id#' action_section='TEXTILE_SAMPLE_REQUEST' action_id='#attributes.req_id#'>