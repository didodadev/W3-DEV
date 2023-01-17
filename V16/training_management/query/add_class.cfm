<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfparam name="attributes.MONTH_ID" default="">
<cfparam name="attributes.is_wiew_branch" default="">
<cfparam name="attributes.is_wiew_department" default="">
<cfparam name="attributes.is_wiew_branch_" default="">
<cfparam name="attributes.is_active" default="0">
<cfparam name="attributes.is_net_display" default="0">
<cfif len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
	<cfset attributes.finish_date = date_add('h', FORM.EVENT_finish_CLOCK - session.ep.TIME_ZONE, attributes.finish_date)>
	<cfset attributes.finish_date = date_add('n', FORM.EVENT_finish_minute, attributes.finish_date)>
</cfif>
<cfif len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
	<cfset attributes.start_date = date_add('h', FORM.EVENT_START_CLOCK - session.ep.TIME_ZONE, attributes.start_date)>
	<cfset attributes.start_date = date_add('n', FORM.EVENT_START_minute, attributes.start_date)>
</cfif>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfset response = cmp.ADD_CLASS_F(
			class_tools:CLASS_TOOLS,
			max_participation:attributes.max_participation,
			max_self_service:attributes.max_self_service,
			training_sec_id:attributes.training_sec_id,
			training_cat_id:attributes.training_cat_id,
			CLASS_NAME:CLASS_NAME,
			CLASS_OBJECTIVE:CLASS_OBJECTIVE,
			CLASS_TARGET:attributes.CLASS_TARGET,
			class_announcement:attributes.class_announcement,
			CLASS_PLACE:CLASS_PLACE,
			CLASS_PLACE_ADDRESS:CLASS_PLACE_ADDRESS,
			CLASS_PLACE_TEL:CLASS_PLACE_TEL,
			CLASS_PLACE_MANAGER:CLASS_PLACE_MANAGER,
			START_DATE:attributes.START_DATE,
			FINISH_DATE:attributes.FINISH_DATE,
			DATE_NO:attributes.DATE_NO,
			HOUR_NO:attributes.HOUR_NO,
			online:iif(isDefined("form.online"),1,""),
			int_or_ext:iif(isDefined("attributes.int_or_ext"),1,""),
			MONTH_ID:iif(isdefined("attributes.MONTH_ID") and len(attributes.MONTH_ID),attributes.MONTH_ID,""),
			training_style:attributes.training_style,
			VIEW_TO_ALL:iif(isDefined("FORM.VIEW_TO_ALL"),1,""),
			is_wiew_branch:iif(isDefined("FORM.is_wiew_branch"),attributes.is_wiew_branch,""),
			is_wiew_department:iif(isDefined("FORM.is_wiew_department"),attributes.is_wiew_department,""),
			is_wiew_branch_:iif(isDefined("FORM.is_wiew_department"),attributes.is_wiew_branch_,""),
			is_view_comp:iif(isDefined("FORM.is_view_comp"),1,""),
			project_id:attributes.project_id,
			project_head:attributes.project_head,
			is_net_display:iif(isDefined("attributes.is_net_display"),attributes.is_net_display,""),
			process_stage:attributes.process_stage,
			is_active:iif(isDefined("attributes.is_active"),attributes.is_active,""),
			language_id:attributes.language_id,
			stock_id:attributes.stock_id,
			product_name:attributes.product_name,
			train_id:attributes.train_id,
			train_head:attributes.train_head,
			url_training:attributes.url_training
			)>
		<!--- <cfquery name="ADD_CLASS" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				TRAINING_CLASS
				(
					MAX_PARTICIPATION,
					MAX_SELF_SERVICE,
					TRAINING_SEC_ID,
					TRAINING_CAT_ID,
					CLASS_NAME,
					CLASS_OBJECTIVE,
					CLASS_TARGET,
					CLASS_ANNOUNCEMENT_DETAIL,
					CLASS_PLACE,
					CLASS_PLACE_ADDRESS,
					CLASS_PLACE_TEL,
					CLASS_PLACE_MANAGER,
					START_DATE,
					FINISH_DATE,
					DATE_NO,
					HOUR_NO,
					ONLINE,
					INT_OR_EXT,
					MONTH_ID,
					TRAINING_STYLE,
					<cfif len(class_tools)>CLASS_TOOLS,</cfif>
					VIEW_TO_ALL,
					IS_WIEW_BRANCH,
					IS_WIEW_DEPARTMENT,
                    IS_VIEW_COMPANY,
					PROJECT_ID,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP,
					IS_INTERNET,
					PROCESS_STAGE,
                    IS_ACTIVE,
					LANGUAGE,
					<!---RELATED_CLASS_ID, --->
					STOCK_ID,
					TRAINING_ID
				)
			VALUES
				(
					<cfif len(attributes.max_participation)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.max_participation#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
					<cfif len(attributes.max_self_service)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.max_self_service#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
					<cfif isdefined("attributes.training_sec_id") and len(attributes.training_sec_id) and attributes.training_sec_id NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_sec_id#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">
					</cfif>,
					<cfif isdefined("attributes.training_cat_id") and len(attributes.training_cat_id) and attributes.training_cat_id NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_cat_id#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CLASS_NAME#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CLASS_OBJECTIVE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CLASS_TARGET#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.class_announcement#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CLASS_PLACE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CLASS_PLACE_ADDRESS#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CLASS_PLACE_TEL#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CLASS_PLACE_MANAGER#">,
					<cfif len(attributes.START_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.START_DATE#">,<cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" null="yes" value="">,</cfif>
					<cfif len(attributes.FINISH_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.FINISH_DATE#">,<cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" null="yes" value="">,</cfif>
					<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.DATE_NO#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.HOUR_NO#">,
					<cfif isdefined("form.online")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.int_or_ext")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.MONTH_ID") and len(attributes.MONTH_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.MONTH_ID#">,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,</cfif>
					<cfif isDefined("attributes.training_style") and len(attributes.training_style)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_style#">,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,</cfif>
					<cfif len(class_tools)><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#CLASS_TOOLS#">,</cfif>
					<cfif isDefined("FORM.VIEW_TO_ALL")>
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                        <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
					<cfelseif isDefined("FORM.is_wiew_branch")>
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_wiew_branch#">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                        <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
					<cfelseif isDefined("FORM.is_wiew_department")>
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_wiew_branch_#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_wiew_department#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                    <cfelseif isDefined("FORM.is_view_comp")>
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="1">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                        <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
					</cfif>
					<cfif isDefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
					<cfif isdefined('attributes.is_net_display') and attributes.is_net_display eq 1>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
                    <cfif isdefined('attributes.is_active') and attributes.is_active eq 1>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.language_id#">,
					<!---<cfif len(attributes.related_class_id) and len(attributes.related_class_name)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_class_id#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
					</cfif>--->
					<cfif len(attributes.stock_id) and len(attributes.product_name)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
					</cfif>
					<cfif len(attributes.train_id) and len(attributes.train_head)>	
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">
					</cfif>
				)
		</cfquery> --->
        <cfif isdefined("attributes.agenda_company")>
			<cfloop list="#attributes.agenda_company#" index="cc">
				<cfset add_comp = cmp.ADD_COMP_F(
					class_id:response.MAX_ID.IDENTITYCOL,
					company_id:cc
				)>
                <!--- <cfquery name="add_comp" datasource="#dsn#">
                    INSERT INTO TRAINING_CLASS_COMPANY
                    (
                        CLASS_ID,
                        COMPANY_ID
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#response.MAX_ID.IDENTITYCOL#">,
                        #cc#
                    )
                </cfquery> --->
            </cfloop>
        </cfif>
		<cfif isdefined("attributes.is_net_display")>
			<cfset get_company = cmp.GET_COMPANY_F()>
			<!--- <cfquery name="get_company" datasource="#dsn#">
				SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL AND IS_ACTIVE = 1
			</cfquery> --->
			<cfoutput query="get_company">
				<cfif isdefined("attributes.menu_#menu_id#")>
					<cfset training_site_domain = cmp.training_site_domain_f(
						t_class_id:response.MAX_ID.IDENTITYCOL,
						menu_id:attributes["menu_#menu_id#"]
					)>
					<!--- <cfquery name="training_site_domain" datasource="#dsn#">
						INSERT INTO
							TRAINING_CLASS_SITE_DOMAIN
							(
								TRAINING_CLASS_ID,		
								MENU_ID
							)
						VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#response.MAX_ID.IDENTITYCOL#">,
								'#attributes["menu_#menu_id#"]#'
							)	
					</cfquery> --->
				</cfif>
			</cfoutput>
		</cfif>
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='TRAINING_CLASS'
			action_column='CLASS_ID'
			action_id='#response.MAX_ID.IDENTITYCOL#'
			action_page='#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#response.MAX_ID.IDENTITYCOL#' 
			warning_description = 'Eğitim : #response.MAX_ID.IDENTITYCOL#'>
	
		<cf_add_content_relation action_type="9" action_type_id="#response.MAX_ID.IDENTITYCOL#">
	</cftransaction>
</cflock>
<script>
	window.location.href ="<cfoutput>#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#response.MAX_ID.IDENTITYCOL#</cfoutput>";
</script>