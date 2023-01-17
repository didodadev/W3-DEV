<cfset getComponent = createObject('component','V16.content.cfc.get_content')>
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

<cfif isdefined("form.ana_sayfa")><cfset variables.cnt_pos = "#variables.cnt_pos#1"></cfif>
<cfif isdefined("form.ana_sayfayan")><cfset variables.cnt_pos = "#variables.cnt_pos#2"></cfif>
<cfif isdefined("form.bolum_basi")><cfset variables.cnt_pos = "#variables.cnt_pos#3"></cfif>
<cfif isdefined("form.bolum_yan")><cfset variables.cnt_pos = "#variables.cnt_pos#4"></cfif>
<cfif isdefined("form.ch_bas")><cfset variables.cnt_pos = "#variables.cnt_pos#5"></cfif>
<cfif isdefined("form.ch_yan")><cfset variables.cnt_pos = "#variables.cnt_pos#6"></cfif>
<cfif isdefined("form.normal")><cfset variables.cnt_pos = "#variables.cnt_pos#5"></cfif>
<cfif isdefined("form.comp_cat")><cfset ddcomp_cat = form.comp_cat></cfif>
<cfif isdefined("form.cunc_cat")><cfset dcunc_cat=form.cunc_cat></cfif>
<cfif len(attributes.view_date_start)>
	<cf_date tarih="attributes.view_date_start">
</cfif>
<cfif len(attributes.view_date_finish)>
	<cf_date tarih="attributes.view_date_finish">
</cfif>
<cfif isdate(attributes.writing_date)>
	<cf_date tarih="attributes.writing_date">
</cfif>
<cfif isdate(attributes.version_date)>
	<cf_date tarih="attributes.version_date">
</cfif>
<cfif isdefined("form.outhor_par_id") and len(form.outhor_par_id)>
    <cfset GET_COMPANY_PARTNER = getComponent.GET_COMPANY_PARTNER(outhor_par_id:attributes.outhor_par_id)>
	<!--- <cfquery name="GET_COMPANY_PARTNER" datasource="#DSN#">
		SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.outhor_par_id#">
	</cfquery> --->
</cfif>

<cflock name="CreateUUID()" timeout="20">
    <cftransaction>
        <cfset MAX_ID = getComponent.CONTENT_INST(
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
			content_property_id : '#iif(isdefined("attributes.content_property_id"),"attributes.content_property_id",DE(""))#' ,
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
            CNT_POS : '#iif(isdefined("VARIABLES.CNT_POS"),"VARIABLES.CNT_POS",DE(""))#',
            DDCOMP_CAT : '#iif(isdefined("VARIABLES.DDCOMP_CAT"),"VARIABLES.DDCOMP_CAT",DE(""))#',
            DCUNC_CAT : '#iif(isdefined("VARIABLES.DCUNC_CAT"),"VARIABLES.DCUNC_CAT",DE(""))#',
            priority : '#iif(isdefined("attributes.priority"),"attributes.priority",DE(""))#'
            )>
            
        <!--- <cfquery name="CONTENT_INST" datasource="#dsn#" result="MAX_ID">
            INSERT INTO 
                CONTENT 
            (
                WRITING_DATE,
                WRITE_VERSION,
                VERSION_DATE,
                CONT_BODY, 
                CONT_SUMMARY, 
                CONT_HEAD, 
                CONT_POSITION,
                CHAPTER_ID, 
                <cfif isDefined("form.content_property_id")>CONTENT_PROPERTY_ID,</cfif>
                <cfif isDefined("form.comp_cat")>COMPANY_CAT,</cfif>
                <cfif isDefined("form.cunc_cat")>CONSUMER_CAT,</cfif>
                <cfif isDefined("form.position_cat_ids")>POSITION_CAT_IDS,</cfif>
                <cfif isDefined("form.user_group_ids")>USER_GROUP_IDS,</cfif>
                <cfif isDefined("form.outhor_emp_id") and len(form.outhor_emp_id)>OUTHOR_EMP_ID,</cfif>
                <cfif isDefined("form.outhor_par_id") and len(form.outhor_par_id)>OUTHOR_PAR_ID,</cfif>
                <cfif isDefined("form.outhor_par_id") and len(form.outhor_par_id)>OUTHOR_COMPANY_PAR_ID,</cfif>
                <cfif isDefined("form.outhor_cons_id") and len(form.outhor_cons_id)>OUTHOR_CONS_ID,</cfif>
                INTERNET_VIEW,
                CAREER_VIEW,
                CONTENT_STATUS,
                NONE_TREE,
                IS_DSP_HEADER,
                IS_DSP_SUMMARY,
                PRIORITY,
                EMPLOYEE_VIEW,
                IS_RULE_POPUP,
                IS_VIEWED,
                VIEW_DATE_START,
                VIEW_DATE_FINISH,
                PROCESS_STAGE,
                STAGE_ID,
                SPOT,
                HIT,
                HIT_EMPLOYEE,
                HIT_PARTNER,
                HIT_GUEST,
                LANGUAGE_ID,
                RECORD_MEMBER, 
                RECORD_IP,
                RECORD_DATE          
            )
            VALUES 
            (    
    
                <cfif isdate(form.writing_date)>#attributes.writing_date#,<cfelse>NULL,</cfif>
                <cfif isDefined("attributes.write_version") and len(attributes.write_version)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.write_version#">,<cfelse>NULL,</cfif>
                <cfif isdate(form.version_date)>#attributes.version_date#,<cfelse>NULL,</cfif>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cont_body#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.summary#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.subject#">, 
                #VARIABLES.CNT_POS#,
                <cfif isDefined("form.chapter") and len(form.chapter)>#form.chapter#,<cfelse>0,</cfif>
                <cfif isDefined("form.content_property_id") and len(form.content_property_id)>#form.content_property_id#<cfelse>NULL</cfif>,
                <cfif isDefined("form.COMP_CAT")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#VARIABLES.DDCOMP_CAT#,">,</cfif>
                <cfif isDefined("form.CUNC_CAT")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#VARIABLES.DCUNC_CAT#,">,</cfif>
                <cfif isDefined("form.position_cat_ids")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#form.position_cat_ids#,">,</cfif>
                <cfif isDefined("form.user_group_ids")><cfqueryparam cfsqltype="cf_sql_varchar" value=",#form.user_group_ids#,">,</cfif>		
                <cfif isDefined("form.outhor_emp_id") and len(form.outhor_emp_id)>#form.outhor_emp_id#,</cfif>
                <cfif isDefined("form.outhor_par_id") and len(form.outhor_par_id)>#form.outhor_par_id#,</cfif>
                <cfif isDefined("form.outhor_par_id") and len(form.outhor_par_id)>#get_company_partner.company_id#,</cfif>
                <cfif isDefined("form.outhor_cons_id") and len(form.outhor_cons_id)>#form.outhor_cons_id#,</cfif>
                <cfif isdefined("attributes.internet_view")>1,<cfelse>0,</cfif> 
                <cfif isdefined("attributes.career_view")>1,<cfelse>0,</cfif> 
                <cfif isDefined("form.status")>1<cfelse>0</cfif>,
                <cfif isDefined("form.none_tree")>1,<cfelse>0,</cfif>
                <cfif isDefined("form.is_dsp_header")>1,<cfelse>0,</cfif>
                <cfif isDefined("form.is_dsp_summary")>1,<cfelse>0,</cfif>
                #form.priority#,
                <cfif isDefined("form.employee_view")>1<cfelse>0</cfif>,
                <cfif isDefined("form.is_rule_popup")>1<cfelse>0</cfif>,
                <cfif isDefined("form.is_viewed")>1<cfelse>0</cfif>, 					
                <cfif len(attributes.view_date_start)>#attributes.view_date_start#<cfelse>NULL</cfif>,
                <cfif len(attributes.view_date_finish)>#attributes.view_date_finish#<cfelse>NULL</cfif>,
                #attributes.process_stage#,
                1,
                <cfif isdefined("attributes.spot")>1<cfelse>0</cfif>,
                0,
                0,
                0,
                0,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.language_id#">,
                #session.ep.userid#, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">, 
                #NOW()#
            )
    	</cfquery> --->
        <cf_workcube_process 
            is_upd='1' 
            old_process_line='0'
            process_stage='#attributes.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#'
            action_table='CONTENT'
            action_column='CONTENT_ID'
            action_id='#MAX_ID.IDENTITYCOL#'
            action_page='#request.self#?fuseaction=content.list_content&event=det&cntid=#MAX_ID.IDENTITYCOL#' 
            warning_description='#getLang('main',241)# : #attributes.subject#'>    
        <!---degerlendirme formlari iliskilendirme--->
	    <cf_add_content_relation action_type="2" action_type_id="#MAX_ID.IDENTITYCOL#">
	
<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>

    <cfset ADD_CONTENT_RELATION = getComponent.ADD_CONTENT_RELATION(
        action_type:attributes.action_type,
        action_type_id:attributes.action_type_id)>

    <!---  <cfquery name="ADD_CONTENT_RELATION" datasource="#DSN#">
        INSERT INTO
            CONTENT_RELATION
        (
            ACTION_TYPE,
            ACTION_TYPE_ID,
            CONTENT_ID,
            COMPANY_ID,
            RECORD_EMP,
            RECORD_DATE,
            RECORD_IP
        )
        VALUES 
        (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_type#">,
            #attributes.action_type_id#,
            #MAX_ID.IDENTITYCOL#,
            #session.ep.company_id#,
            #Session.ep.UseriD#,
            #now()#,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
        )
    </cfquery> --->

	<cfif attributes.action_type is 'product_id'>
		<script> window.location.href = "<cfoutput>#request.self#?fuseaction=product.list_product&event=det&pid=#attributes.action_type_id#</cfoutput>"</script>
	<cfelseif attributes.action_type is 'product_catid'>
        <script> window.location.href = "<cfoutput>#request.self#?fuseaction=product.list_product_cat&event=upd&ID=#attributes.action_type_id#</cfoutput>"</script>
    <cfelseif attributes.action_type is 'brand_id'>
        <script> window.location.href = "<cfoutput>#request.self#?fuseaction=product.list_product_brands&event=upd&id=#attributes.action_type_id#</cfoutput>"</script>
    <cfelseif attributes.action_type is 'campaign_id'>
        <script> window.location.href = "<cfoutput>#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#attributes.action_type_id#</cfoutput>"</script>
    <cfelseif attributes.action_type is 'catalog_id'>
        <script> window.location.href = "<cfoutput>#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#attributes.action_type_id#</cfoutput>"</script>
    <cfelseif attributes.action_type is 'company_id'>
        <script> window.location.href = "<cfoutput>#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#attributes.action_type_id#</cfoutput>"</script>
    <cfelseif attributes.action_type is 'stock_id'>
        <script> window.location.href = "<cfoutput>#request.self#?fuseaction=prod.add_product_tree&stock_id=#attributes.action_type_id#</cfoutput>"</script>
    <cfelseif attributes.action_type is 'pro_tree_id'>
        <script> window.location.href = "<cfoutput>#request.self#?fuseaction=prod.add_product_tree&pro_tree_id=#attributes.action_type_id#</cfoutput>"</script>
    <cfelseif attributes.action_type is 'project_id'>
        <script> window.location.href = "<cfoutput>#request.self#?fuseaction=project.projects&event=det&id=#attributes.action_type_id#</cfoutput>"</script>
    <cfelseif attributes.action_type is 'class_id'>
        <script> window.location.href = "<cfoutput>#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#attributes.action_type_id#</cfoutput>"</script>
    <cfelseif attributes.action_type is 'content_id'>
        <script> window.location.href ="<cfoutput>#request.self#?fuseaction=content.list_content&event=det&cntid=#attributes.action_type_id#</cfoutput>"</script>
    <cfelseif attributes.action_type is 'train_id'>
        <script> window.location.href ="<cfoutput>#request.self#?fuseaction=training_management.list_training_subjects&event=upd&train_id=#attributes.action_type_id#</cfoutput>"</script>  
    <cfelseif attributes.action_type is 'service_id'>
        <script> window.location.href ="<cfoutput>#request.self#?fuseaction=call.list_service&event=upd&service_id=#attributes.action_type_id#</cfoutput>"</script>  
    <cfelseif attributes.action_type is 'PROCESS_ID'>
        <script> window.location.href ="<cfoutput>#request.self#?fuseaction=process.list_process&event=upd&process_id=#attributes.action_type_id#</cfoutput>"</script>
    <cfelseif attributes.action_type is 'MAIN_PROCESS_ID'>
        <script> window.location.href ="<cfoutput>#request.self#?fuseaction=process.general_processes&event=upd&process_id=#attributes.action_type_id#</cfoutput>"</script>  
    <cfelseif attributes.action_type is 'DATA_OFFICER_ID'>
        <script>window.location.href = "<cfoutput>#request.self#?fuseaction=gdpr.data_officer&event=det&id=#attributes.action_type_id#</cfoutput>";</script>
    </cfif>
<cfelse>
		<script>window.location.href = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_content&event=det&cntid=#MAX_ID.IDENTITYCOL#</cfoutput>";</script>
   
</cfif>
</cftransaction>
</cflock>
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
