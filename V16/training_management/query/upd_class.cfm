<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfparam name="attributes.MONTH_ID" default="">
<cfparam name="attributes.is_wiew_branch" default="">
<cfparam name="attributes.is_view_department" default="">
<cfparam name="attributes.is_wiew_branch_" default="0">
<cfparam name="attributes.is_view_comp" default="">
<cfparam name="attributes.is_active" default="0">
<cfparam name="attributes.is_net_display" default="0">
<cfparam name="attributes.modules" default="">
<cfif len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
	<cfset attributes.finish_date = date_add('h', form.event_finish_clock - session.ep.time_zone, attributes.finish_date)>
	<cfset attributes.finish_date = date_add('n', form.event_finish_minute, attributes.finish_date)>
</cfif>
<cfif len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
	<cfset attributes.start_date = date_add('h', form.event_start_clock - session.ep.time_zone, attributes.start_date)>
	<cfset attributes.start_date = date_add('n', form.event_start_minute, attributes.start_date)>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfset UPD_CLASS = cmp.UPD_CLASS_F(
			max_participation:attributes.max_participation,
			max_self_service:attributes.max_self_service,
			training_sec_id:training_sec_id,
			training_cat_id:training_cat_id,
			CLASS_NAME:attributes.class_name,
			CLASS_OBJECTIVE: '#iif(isdefined("attributes.CLASS_OBJECTIVE"),"attributes.CLASS_OBJECTIVE",DE(""))#',
			CLASS_TARGET:attributes.CLASS_TARGET,
			class_announcement:attributes.class_announcement,
			CLASS_PLACE:CLASS_PLACE,
			CLASS_PLACE_ADDRESS:CLASS_PLACE_ADDRESS,
			CLASS_PLACE_TEL:CLASS_PLACE_TEL,
			CLASS_PLACE_MANAGER:attributes.class_place_manager,
			START_DATE:attributes.START_DATE,
			FINISH_DATE:attributes.FINISH_DATE,
			DATE_NO:attributes.DATE_NO,
			HOUR_NO:attributes.HOUR_NO,
			online:iif(isDefined("form.online"),1,""),
			int_or_ext:iif(isDefined("attributes.int_or_ext"),1,""),
			class_tools:CLASS_TOOLS,
			MONTH_ID:iif(isdefined("attributes.MONTH_ID") and len(attributes.MONTH_ID),attributes.MONTH_ID,""),
			training_style:attributes.training_style,
			VIEW_TO_ALL:iif(isDefined("FORM.VIEW_TO_ALL"),1,""),
			is_wiew_branch:iif(isDefined("FORM.is_wiew_branch"),attributes.is_wiew_branch,""),
			is_wiew_department:iif(isDefined("FORM.is_view_department"),attributes.is_view_department,""),
			is_wiew_branch_:iif(isDefined("FORM.is_view_department"),attributes.is_wiew_branch_,""),
			is_view_comp:iif(isDefined("FORM.is_view_comp"),attributes.is_view_comp,""),
			modules:iif(isDefined('attributes.modules') and len(attributes.modules),attributes.modules,""),
			<!--- project_id:attributes.project_id, --->
			<!--- project_head:attributes.project_head, --->
			is_net_display:iif(isDefined("attributes.is_net_display"),attributes.is_net_display,""),
			process_stage:attributes.process_stage,
			is_active:iif(isDefined("attributes.is_active"),attributes.is_active,""),
			language_id:attributes.language_id,
			stock_id:attributes.stock_id,
			product_name:attributes.product_name,
			train_id:attributes.train_id,
			train_head:attributes.train_head,
			class_id:form.class_id,
			url_training:attributes.url_training
		)>
		<!--- <cfquery name="UPD_CLASS" datasource="#DSN#">
			UPDATE
				TRAINING_CLASS
			SET
				MAX_PARTICIPATION = <cfif len(attributes.max_participation)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.max_participation#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				MAX_SELF_SERVICE = <cfif len(attributes.max_self_service)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.max_self_service#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				TRAINING_SEC_ID = <cfif isdefined("training_sec_id") and len(training_sec_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#training_sec_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				TRAINING_CAT_ID = <cfif isdefined("training_cat_id") and len(training_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#training_cat_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				CLASS_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#class_name#">,
				CLASS_OBJECTIVE = <cfif isdefined("class_objective") and len(class_objective)><cfqueryparam cfsqltype="cf_sql_varchar" value="#class_objective#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				CLASS_PLACE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#class_place#">,
				CLASS_PLACE_ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#class_place_address#">,
				CLASS_PLACE_TEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#class_place_tel#">,
				CLASS_PLACE_MANAGER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.class_place_manager#">,
				START_DATE = <cfif len(attributes.start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="" null="yes"></cfif>,
				FINISH_DATE = <cfif len(attributes.finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="" null="yes"></cfif>,			
				DATE_NO = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.date_no#">,
				HOUR_NO = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.hour_no#">,
				ONLINE = <cfif isdefined("form.online")>1<cfelse>0</cfif>,
				INT_OR_EXT = <cfif isdefined("attributes.int_or_ext")>1<cfelse>0</cfif>,
				CLASS_TOOLS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#class_tools#">,
				CLASS_TARGET = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.class_target#">,
				CLASS_ANNOUNCEMENT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.class_announcement#">,
				<!--- PROJECT_ID = <cfif isDefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>, --->
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				MONTH_ID=<cfif isdefined("attributes.month_id") and len(attributes.month_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.month_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
				TRAINING_STYLE =<cfif isDefined("attributes.training_style") and len(attributes.training_style)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_style#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfif isDefined("form.view_to_all")>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
					IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
                    IS_VIEW_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
				<cfelseif isDefined("form.is_wiew_branch")>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_wiew_branch#">,
					IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
                    IS_VIEW_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
				<cfelseif isDefined("form.is_wiew_department")>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_wiew_branch_#">,
					IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_wiew_department#">,
                    IS_VIEW_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
				<cfelseif isDefined("form.is_view_comp")>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
					IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
                    IS_VIEW_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_view_comp#">,
				<cfelse>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
					IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
					IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
                    IS_VIEW_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
				</cfif>
                MODULE_IDS = <cfif isDefined('attributes.modules') and len(attributes.modules)>'#attributes.modules#'<cfelse>NULL</cfif>,
                IS_ACTIVE = <cfif isdefined("attributes.is_active") and attributes.is_active>1<cfelse>0</cfif>,
				IS_INTERNET = <cfif isdefined("attributes.is_net_display") and attributes.is_net_display eq 1>1<cfelse>0</cfif>,
				PROCESS_STAGE =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#" >,
				LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.language_id#">,
				<cfif len(attributes.stock_id) and len(attributes.product_name)>
					STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">,
				<cfelse>
					STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
				</cfif>
				<cfif len(attributes.train_id) and len(attributes.train_head)>
					TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
				<cfelse>
					TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">
				</cfif>
			WHERE
				CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.class_id#">
		</cfquery> --->
		<cfset DEL_SITE_DOMAIN = cmp.DEL_SITE_DOMAIN_F(class_id:form.class_id)>
        <!--- <cfquery name="DEL_SITE_DOMAIN" datasource="#DSN#">
            DELETE FROM TRAINING_CLASS_SITE_DOMAIN WHERE TRAINING_CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.class_id#">
        </cfquery> --->
		<cfif isdefined("attributes.is_net_display") and attributes.is_net_display eq 1>
			<cfset GET_COMPANY = cmp.GET_COMPANY_F(is_upd:1)>
            <!--- <cfquery name="GET_COMPANY" datasource="#DSN#">
                SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS 
            </cfquery> --->
            <cfoutput query="get_company">
				<cfif isdefined("attributes.menu_#menu_id#")>
					<cfset TRAINING_SITE_DOMAIN = cmp.training_site_domain_f(
						t_class_id:form.class_id,
						menu_id:attributes["menu_#menu_id#"]
					)>
                    <!--- <cfquery name="TRAINING_SITE_DOMAIN" datasource="#DSN#">
                        INSERT INTO
                            TRAINING_CLASS_SITE_DOMAIN
                            (
                                TRAINING_CLASS_ID,		
                                MENU_ID
                            )
                        VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.class_id#">,
                                '#attributes["menu_#menu_id#"]#'
                            )	
                    </cfquery> --->
                </cfif>
            </cfoutput>
		</cfif>
		<cfset DEL_COMP = cmp.DEL_COMP_F(class_id:form.class_id)>
        <!--- <cfquery name="DEL_COMP" datasource="#DSN#">
        	DELETE FROM TRAINING_CLASS_COMPANY WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.class_id#">
        </cfquery> --->
        <cfif isdefined("attributes.agenda_company") and isdefined("attributes.is_view_comp")>
			<cfloop list="#attributes.agenda_company#" index="cc">
				<cfset ADD_COMP = cmp.ADD_COMP_F(
					class_id:form.class_id,
					company_id:cc
				)>
                <!--- <cfquery name="ADD_COMP" datasource="#DSN#">
                    INSERT INTO TRAINING_CLASS_COMPANY
                    (
                        CLASS_ID,
                        COMPANY_ID
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.class_id#">,
                        #cc#
                    )
                </cfquery>  --->
            </cfloop>
        </cfif>
        <cf_workcube_process 
            is_upd='1' 
            old_process_line='#attributes.old_process_line#' 
            process_stage='#attributes.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#' 
            action_table='TRAINING_CLASS'
            action_column='CLASS_ID'
            action_id='#form.class_id#'
            action_page='#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#form.class_id#' 
            warning_description = 'Eğitim : #form.class_id#'>
	</cftransaction>
</cflock>
<script>
	window.location.href ="<cfoutput>#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#form.class_id#</cfoutput>";
</script>

