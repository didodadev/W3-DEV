<!--- Wiki de search yapmak için collection oluşturuldu ve collection update yapmak için buraya eklendi. --->
<!--- <cfcollection  action="list" name="collections">
<cfset collection=[]>
<cfoutput query="collections">
    <cfscript>
        ArrayAppend(collection,  name, "true"); 
    </cfscript> 
</cfoutput>
<cfif not ArrayFind(collection, 'wiki_contents')>
    <cfcollection collection="wiki_contents" action="create" path="gettemplatepath()&\V16\helpdesk\display\list_helpdesk.cfm">
</cfif>
<cfinclude template="../../helpdesk/query/get_help.cfm">
<cfindex
query="GET_HELP"
collection="wiki_contents"
action="Update"
type="Custom"
key="CONTENT_ID"
title="CONT_HEAD"
body="CONT_HEAD,CONT_SUMMARY,CONT_BODY,META_KEYWORDS,META_TITLE,CONTENTCAT,CHAPTER,CONTENT_PROPERTY_ID,LANGUAGE_SHORT"
status="status"
custom1="CONT_SUMMARY"
custom2="META_TITLE,META_KEYWORDS"
custom3="RECORD_DATE,UPDATE_DATE"
custom4="CONTENTCAT,CHAPTER,CONTENT_PROPERTY_ID"
category="CONTENTCAT_ID,CHAPTER,NAME,LANGUAGE_ID,PROCESS_STAGE"
>  --->
<cfset getComponent = createObject('component','V16.content.cfc.get_content')>
<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfif isdefined("form.comp_cat")>
	<cfset comp_cat=1>
<cfelse>
	<cfset comp_cat=0>
</cfif>
<cfif isdefined("form.cunc_cat")>
	<cfset cunc_cat=1>
<cfelse>
	<cfset cunc_cat=0>
</cfif>
<cfif isdefined("form.int_cat")>
	<cfset int_cat=1>
<cfelse>
	<cfset int_cat=0>
</cfif>
<cfparam name="cnt_pos" default="0">
<cfif isdefined("form.ana_sayfa")>
	<cfset variables.cnt_pos = "#variables.cnt_pos#1">
</cfif>
<cfif isdefined("form.ana_sayfayan")>
	<cfset variables.cnt_pos = "#variables.cnt_pos#2">
</cfif>
<cfif isdefined("form.bolum_basi")>
	<cfset variables.cnt_pos = "#variables.cnt_pos#3">
</cfif>
<cfif isdefined("form.bolum_yan")>
	<cfset variables.cnt_pos = "#variables.cnt_pos#4">
</cfif>
<cfif isdefined("form.ch_bas")>
	<cfset variables.cnt_pos = "#variables.cnt_pos#5">
</cfif>
<cfif isdefined("form.ch_yan")>
	<cfset variables.cnt_pos = "#variables.cnt_pos#6">
</cfif>
<cfif len(attributes.view_date_start)>
	<cf_date tarih="attributes.view_date_start">
</cfif>
<cfif len(attributes.view_date_finish)>
	<cf_date tarih="attributes.view_date_finish">
</cfif>
<cfif len(attributes.writing_date)>
	<cf_date tarih="attributes.writing_date">
</cfif>
<cfif len(attributes.version_date)>
	<cf_date tarih="attributes.version_date">
</cfif>
<!--- <cfif len(attributes.user_friendly_url)>
	<cf_workcube_user_friendly user_friendly_url='#attributes.user_friendly_url#' action_type='CONTENT_ID' action_id='#form.cntid#' action_page='objects2.detail_content&cid=#form.cntid#'>
<cfelseif attributes.is_autofill eq 1>
	<cf_workcube_user_friendly user_friendly_url='#left(attributes.subject,250)#' action_type='CONTENT_ID' action_id='#form.cntid#' action_page='objects2.detail_content&cid=#form.cntid#'>
</cfif> --->
<cfif isdefined("attributes.outhor_par_id") and len(FORM.outhor_par_id)>
	<cfset GET_COMPANY_PARTNER = getComponent.GET_COMPANY_PARTNER(
        outhor_par_id:attributes.outhor_par_id)>
</cfif>
<cfset GET_UPD_COUNT = getComponent.GET_UPD_COUNT(
	cntid:attributes.cntid)>
<cfset UPD_COUNT=#GET_UPD_COUNT.UPD_COUNT# +1>
<cf_wrk_get_history  datasource='#dsn#' source_table='CONTENT' target_table='CONTENT_HISTORY' record_id='#attributes.cntid#' record_name='CONTENT_ID'>
	
		<cfset cntid = getComponent.CONTENT_INST_UPD(
		    	user_friendly_url : '#iif(isdefined("attributes.user_friendly_url"),"attributes.user_friendly_url",DE(""))#',
		 		content_property_id : '#iif(isdefined("attributes.content_property_id"),"attributes.content_property_id",DE(""))#',
				comp_cat : '#iif(isdefined("attributes.comp_cat"),"attributes.comp_cat",DE(""))#', 
				cunc_cat : '#iif(isdefined("attributes.cunc_cat"),"attributes.cunc_cat",DE(""))#',
				position_cat_ids : '#iif(isdefined("attributes.position_cat_ids"),"attributes.position_cat_ids",DE(""))#', 
				user_group_ids : '#iif(isdefined("attributes.user_group_ids"),"attributes.user_group_ids",DE(""))#',
				outhor_emp_id : '#iif(isdefined("attributes.outhor_emp_id"),"attributes.outhor_emp_id",DE(""))#',
				outhor_par_id : '#iif(isdefined("attributes.outhor_par_id"),"attributes.outhor_par_id",DE(""))#',
				outhor_cons_id : '#iif(isdefined("attributes.outhor_cons_id"),"attributes.outhor_cons_id",DE(""))#',
				writing_date : '#iif(isdefined("attributes.writing_date"),"attributes.writing_date",DE(""))#',
				write_version : '#iif(isdefined("attributes.write_version"),"attributes.write_version",DE(""))#',
				version_date : '#iif(isdefined("attributes.version_date"),"attributes.version_date",DE(""))#',
				cont_body : '#iif(isdefined("attributes.cont_body"),"DecodeForHTML(attributes.cont_body)",DE(""))#',
				summary : '#iif(isdefined("attributes.summary"),"attributes.summary",DE(""))#',
				subject : '#iif(isdefined("attributes.subject"),"attributes.subject",DE(""))#',
				chapter : '#iif(isdefined("attributes.chapter"),"attributes.chapter",DE(""))#',
				company_id : '#iif(isdefined("attributes.company_id"),"attributes.company_id",DE(""))#',
				internet_view : '#iif(isdefined("attributes.internet_view"),"attributes.internet_view",DE(""))#',
				career_view : '#iif(isdefined("attributes.career_view"),"attributes.career_view",DE(""))#' ,
				status : '#iif(isdefined("attributes.status"),"attributes.status",DE(""))#',
				none_tree : '#iif(isdefined("attributes.none_tree"),"attributes.none_tree",DE(""))#' ,
				is_dsp_header: '#iif(isdefined("attributes.is_dsp_header"),"attributes.is_dsp_header",DE(""))#',
				is_dsp_summary : '#iif(isdefined("attributes.is_dsp_summary"),"attributes.is_dsp_summary",DE(""))#',
				employee_view : '#iif(isdefined("attributes.employee_view"),"attributes.employee_view",DE(""))#',
				is_rule_popup : '#iif(isdefined("attributes.is_rule_popup"),"attributes.is_rule_popup",DE(""))#' ,
				is_viewed : '#iif(isdefined("attributes.is_viewed"),"attributes.is_viewed",DE(""))#' ,
				view_date_start : '#iif(isdefined("attributes.view_date_start"),"attributes.view_date_start",DE(""))#',
				view_date_finish : '#iif(isdefined("attributes.view_date_finish"),"attributes.view_date_finish",DE(""))#', 
				process_stage : '#iif(isdefined("attributes.process_stage"),"attributes.process_stage",DE(""))#',
				spot : '#iif(isdefined("attributes.spot"),"attributes.spot",DE(""))#',
				language_id : '#iif(isdefined("attributes.language_id"),"attributes.language_id",DE(""))#',
				cnt_pos : '#iif(isdefined("VARIABLES.CNT_POS"),"VARIABLES.CNT_POS",DE(""))#',
				ddcomp_cat : '#iif(isdefined("VARIABLES.DDCOMP_CAT"),"VARIABLES.DDCOMP_CAT",DE(""))#',
				dcunc_cat : '#iif(isdefined("VARIABLES.DCUNC_CAT"),"VARIABLES.DCUNC_CAT",DE(""))#',
				priority : '#iif(isdefined("attributes.priority"),"attributes.priority",DE(""))#',
				cntid:'#iif(isdefined("attributes.cntid"),"attributes.cntid",DE(""))#',
				upd_count:'#iif(isdefined("upd_count"),"upd_count",DE(""))#'
				)>

<cf_workcube_process 
	is_upd="1" 
	old_process_line="#attributes.old_process_line#"
	process_stage="#attributes.process_stage#" 
	record_member="#session.ep.userid#"
	record_date="#now()#" 
	action_table='CONTENT'
	action_column='CONTENT_ID'
	action_id="#attributes.cntid#" 
	action_page="#request.self#?fuseaction=content.list_content&event=det&cntid=#attributes.cntid#" 
	warning_description="İçerik : #attributes.subject#">

		<script>
            window.location.href = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_content&event=det&cntid=#attributes.cntid#</cfoutput>";
        </script>
   