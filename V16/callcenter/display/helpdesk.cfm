<cf_xml_page_edit fuseact="call.helpdesk">
<cfif session.ep.our_company_info.sales_zone_followup eq 1>
	<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
		SELECT DISTINCT SZ_HIERARCHY FROM SALES_ZONES_ALL_1 WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	</cfquery>
	<cfset row_block = 500>
</cfif>
<cfparam name="attributes.record_emp" default="">
<cfparam name="attributes.record_name" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.app_cat" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.applicant_name" default="">
<cfparam name="attributes.is_reply" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.site_domain" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.interactioncat_id" default="">
<cfparam name="attributes.interaction_cat" default="">
<cfparam name="attributes.special_definition" default="">
<cfparam name="attributes.subscriber_stage" default="">
<cfparam name="attributes.project_id" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelseif isdefined("attributes.start_date") and not len(attributes.start_date)>
		<cfset attributes.start_date = "">
<cfelse>
	<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelseif isdefined("attributes.finish_date") and not len(attributes.finish_date)>
	<cfset attributes.finish_date = "">
<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cfset attributes.finish_date = date_add('h',23,attributes.finish_date)>
	<cfset attributes.finish_date = date_add('n',59,attributes.finish_date)>
</cfif>
<cfquery name="GET_MAIN_MENU" datasource="#DSN#">
	SELECT SITE_DOMAIN FROM MAIN_MENU_SETTINGS WHERE SITE_DOMAIN IS NOT NULL
</cfquery>
<cfquery name="GET_INTERACTION_CAT" datasource="#DSN#">
	SELECT
         CASE
            WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
            ELSE INTERACTIONCAT
        END AS INTERACTIONCAT,
        INTERACTIONCAT_ID
    FROM
    	SETUP_INTERACTION_CAT
        LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_INTERACTION_CAT.INTERACTIONCAT_ID
        AND SLI.COLUMN_NAME =  <cfqueryparam cfsqltype="cf_sql_varchar" value="INTERACTIONCAT">
        AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_INTERACTION_CAT">
        AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	WHERE INTERACTIONCAT IS NOT NULL
    ORDER BY INTERACTIONCAT
</cfquery>
<cfif isDefined('x_show_authorized_stage') and x_show_authorized_stage eq 1>
	<cf_workcube_process_info>
</cfif>
<cfquery name="GET_CALLCENTER_STAGE" datasource="#DSN#">
	SELECT
		CASE
		WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
		ELSE PTR.STAGE
		END AS STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT,
		PROCESS_TYPE_ROWS PTR
		LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PTR.PROCESS_ROW_ID
		AND SLI.COLUMN_NAME =  <cfqueryparam cfsqltype="cf_sql_varchar" value="STAGE">
		AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROCESS_TYPE_ROWS">
		AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.helpdesk%">
		<cfif isDefined('x_show_authorized_stage') and x_show_authorized_stage eq 1 and isDefined("process_rowid_list") and ListLen(process_rowid_list)>
            AND PTR.PROCESS_ROW_ID IN (#process_rowid_list#)
        </cfif>
</cfquery>
<cfquery name="GET_SUBSCRIBER_STAGE" datasource="#DSN#">
	SELECT
		CASE
		WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
		ELSE PTR.STAGE
		END AS STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT,
		PROCESS_TYPE_ROWS PTR
		LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PTR.PROCESS_ROW_ID
		AND SLI.COLUMN_NAME =  <cfqueryparam cfsqltype="cf_sql_varchar" value="STAGE">
		AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROCESS_TYPE_ROWS">
		AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_subscription_contract%">
		<cfif isDefined('x_show_authorized_stage') and x_show_authorized_stage eq 1 and isDefined("process_rowid_list") and ListLen(process_rowid_list)>
            AND PTR.PROCESS_ROW_ID IN (#process_rowid_list#)
        </cfif>
</cfquery>
<cfquery name="GET_COMMETHOD" datasource="#DSN#">
	SELECT
        CASE
            WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
            ELSE COMMETHOD
        END AS COMMETHOD,
        COMMETHOD_ID,
        IS_DEFAULT
    FROM
    	SETUP_COMMETHOD
        LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_COMMETHOD.COMMETHOD_ID
        AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COMMETHOD">
        AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_COMMETHOD">
        AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	ORDER BY COMMETHOD
</cfquery>
<cfquery name="get_special_definition" datasource="#DSN#"><!--- 5: Etkilesim Kategorisindeki Ozel Tanimlar --->
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 5 ORDER BY SPECIAL_DEFINITION
</cfquery>
<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
	<cfinclude template="../../member/query/get_ims_control.cfm">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_HELP" datasource="#DSN#">
		SELECT
			C.CUS_HELP_ID,
			C.COMPANY_ID,
			C.PARTNER_ID,
			C.CONSUMER_ID,
			C.PROCESS_STAGE,
			C.SUBJECT,
			C.SUBSCRIPTION_ID,
			C.APPLICANT_NAME,
			C.APP_CAT,
			C.IS_REPLY,
			C.IS_REPLY_MAIL,
			C.OUR_COMPANY_ID,
			C.SITE_DOMAIN,
			C.INTERACTION_CAT,
            C.RECORD_EMP,
            C.RECORD_DATE,
            C.UPDATE_EMP,
			C.DETAIL,
			RECEIVED_DURATION DURATION,
			C.INTERACTION_DATE,
			EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME NAME
       FROM
			CUSTOMER_HELP C
				LEFT JOIN EMPLOYEES ON C.UPDATE_EMP = EMPLOYEES.EMPLOYEE_ID
			<cfif isdefined('attributes.comp_cat') and len(attributes.comp_cat)>
				,COMPANY
			</cfif>
      	WHERE
			1 = 1 AND
          	<cfif isdefined('attributes.comp_cat') and len(attributes.comp_cat)>
				COMPANY.COMPANY_ID = C.COMPANY_ID AND
			</cfif>
			(
				C.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> OR
				C.OUR_COMPANY_ID IS NULL
			)
			<cfif len(attributes.keyword)>
				AND
				(
					C.SUBJECT LIKE #sql_unicode()#'%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
                    OR C.DETAIL LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
					<cfif IsNumeric(attributes.keyword) and attributes.keyword lte 1000000000000>
						OR C.CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#attributes.keyword#">
					</cfif>
				)
			</cfif>
			<cfif len(attributes.app_cat)>
				AND C.APP_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.app_cat#">
			</cfif>
			<cfif len(attributes.company_id) and len(attributes.member_name) and attributes.member_type eq 'partner'>
				AND C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.company_id#">
			<cfelseif len(attributes.consumer_id) and len(attributes.member_name) and attributes.member_type eq 'consumer'>
				AND C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfif>
			<cfif len(attributes.record_emp) and len(attributes.record_name)>
				AND C.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp#">
			</cfif>
			<cfif len(attributes.subscription_id) and len(subscription_no)>
				AND C.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
			</cfif>
			<cfif len(attributes.applicant_name)>
				AND C.APPLICANT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.applicant_name#%">
			</cfif>
			<cfif len(attributes.site_domain)>
				AND C.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.site_domain#">
			</cfif>
			<cfif isdefined('attributes.interaction_cat') and len(attributes.interaction_cat)>
				AND C.INTERACTION_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.interaction_cat#">
			</cfif>
			<cfif isdefined('attributes.comp_cat') and len(attributes.comp_cat)>
				AND COMPANY.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.comp_cat#">
			</cfif>
			<cfif attributes.is_reply eq 2>
				AND	C.IS_REPLY_MAIL  IN (0,1)
			</cfif>
			<cfif attributes.is_reply eq 0>
				AND	C.IS_REPLY_MAIL  = 0
			</cfif>
			<cfif attributes.is_reply eq 1>
				AND	C.IS_REPLY_MAIL  = 1
			</cfif>
			<cfif len(attributes.process_stage_type)>
				AND C.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_type#">
			</cfif>
			<cfif len(attributes.start_date)>
				AND C.INTERACTION_DATE >= #attributes.start_date#
			</cfif>
			<cfif len(attributes.finish_date)>
				AND C.INTERACTION_DATE <= #attributes.finish_date#
			</cfif>
			<cfif len(attributes.special_definition)>
				AND C.SPECIAL_DEFINITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition#">
			</cfif>
			<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
				AND
					(
					(C.CONSUMER_ID IS NULL AND C.COMPANY_ID IS NULL )
					OR ( C.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#) )
					OR ( C.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#) )
					)
			</cfif>
            <cfif isDefined('GET_CALLCENTER_STAGE') and GET_CALLCENTER_STAGE.recordcount>
                AND C.PROCESS_STAGE IN (#ValueList(GET_CALLCENTER_STAGE.process_row_id)#)
            <cfelseif isDefined('x_show_authorized_stage') and x_show_authorized_stage eq 1>
                AND 1 = 0
            </cfif>
            <cfif len(attributes.subscriber_stage)>
				AND C.SUBSCRIPTION_ID IN (SELECT SC.SUBSCRIPTION_ID FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT SC, PROCESS_TYPE_ROWS PTR WHERE PTR.PROCESS_ROW_ID = SC.SUBSCRIPTION_STAGE AND PTR.PROCESS_ROW_ID = #attributes.subscriber_stage#)
			</cfif>
            <cfif len(attributes.project_id)>
				AND C.SUBSCRIPTION_ID IN (SELECT SC.SUBSCRIPTION_ID FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT SC WHERE SC.PROJECT_ID = #attributes.project_id#)
			</cfif>
		ORDER BY
			<cfif isdefined("attributes.ordertype") and attributes.ordertype eq 2>
                ISNULL(C.UPDATE_DATE,C.RECORD_DATE) DESC
            <cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 3>
                RECORD_DATE DESC
            <cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 4>
                RECORD_DATE
            <cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 5>
                INTERACTION_DATE DESC
            <cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 6>
                INTERACTION_DATE
            <cfelseif isdefined("attributes.ordertype") and attributes.ordertype eq 7>
                 C.DETAIL
            <cfelse>
                CUS_HELP_ID DESC
            </cfif>
	</cfquery>
<cfelse>
	<cfset get_help.recordcount = 0>
</cfif>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default = "#get_help.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_help" id="list_help" method="post" action="#request.self#?fuseaction=call.helpdesk">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#getLang(48,'Filtre',57460)#" >
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
						<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
						<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#attributes.partner_id#</cfoutput>">
						<input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
						<input type="text" name="member_name" id="member_name"  onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'\',\'\',\'2\',\'1\'','COMPANY_ID,CONSUMER_ID,PARTNER_ID,MEMBER_TYPE','company_id,consumer_id,partner_id,member_type','list_help','3','250')" value="<cfoutput>#attributes.member_name#</cfoutput>" autocomplete="off" placeholder="<cfoutput>#getLang('main',45)#</cfoutput>">
						<cfset str_linke_ait="field_partner=list_help.partner_id&field_consumer=list_help.consumer_id&field_comp_id=list_help.company_id&field_comp_name=list_help.member_name&field_name=list_help.member_name&field_type=list_help.member_type">
						<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8');"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="ordertype" id="ordertype" >
						<option value="1"><cf_get_lang dictionary_id ='49204.No ya Göre Azalan'></option>
						<option value="2" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 2>selected</cfif>><cf_get_lang dictionary_id ='49199.Güncellemeye Göre Azalan'></option>
						<option value="3" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 3>selected</cfif>><cf_get_lang dictionary_id='49230.Başlangıç Tarihine Göre Azalan'></option>
						<option value="4" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 4>selected</cfif>><cf_get_lang dictionary_id='49200.Başlangıç Tarihine Göre Artan'></option>
						<option value="5" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 5>selected</cfif>><cf_get_lang dictionary_id='49201.Bitiş Tarihine Göre Azalan'></option>
						<option value="6" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 6>selected</cfif>><cf_get_lang dictionary_id='49202.Bitiş Tarihine Göre Artan'></option>
						<option value="7" <cfif isdefined("attributes.ordertype") and attributes.ordertype eq 7>selected</cfif>><cf_get_lang dictionary_id='49203.Konu Başlığına Göre Alfabetik'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" >
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function=''>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage_type">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58859.Surec'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<select name="process_stage_type" id="process_stage_type" >
								<option value=""><cf_get_lang dictionary_id='58859.Surec'></option>
								<cfoutput query="get_callcenter_stage">
									<option value="#process_row_id#" <cfif attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-interaction_cat">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<select name="interaction_cat" id="interaction_cat" >
								<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
								<cfoutput query="get_interaction_cat">
									<option value="#interactioncat_id#" <cfif attributes.interaction_cat eq interactioncat_id >selected</cfif>>#interactioncat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-is_reply">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='49270.Etkileşim'> <cf_get_lang dictionary_id='30111.Durumu'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<select name="is_reply" id="is_reply">
								<option value="2" <cfif attributes.is_reply eq 2>selected</cfif>><cf_get_lang dictionary_id='49270.Etkileşim'> <cf_get_lang dictionary_id='30111.Durumu'></option>
								<option value="0" <cfif attributes.is_reply eq 0>selected</cfif>><cf_get_lang dictionary_id='49268.Cevapsız'></option>
								<option value="1" <cfif attributes.is_reply eq 1>selected</cfif>><cf_get_lang dictionary_id='49267.Cevaplı'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-record_name">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="record_emp" id="record_emp" value="<cfoutput>#attributes.record_emp#</cfoutput>">
								<cfinput type="text" name="record_name" id="record_name"  value="#attributes.record_name#" maxlength="255" onFocus="AutoComplete_Create('record_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp','list_help','3','135');">
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_help.record_emp&field_name=list_help.record_name&select_list=1');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group " id="item-project_head">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="input-group" >
								<cfoutput>
								<input type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
								<input type="text" name="project_head" id="project_head" value="<cfif len(attributes.project_id)>#GET_PROJECT_NAME(attributes.project_id)#</cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135')"  autocomplete="off">
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=list_help.project_id&project_head=list_help.project_head');"></span>
								</cfoutput>
							</div>
						</div>
					</div>
					<cfif session.ep.our_company_info.subscription_contract eq 1>
						<div class="form-group" id="item-subscription_no">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#attributes.subscription_id#</cfoutput>">
									<input type="text" name="subscription_no" id="subscription_no" value="<cfoutput>#attributes.subscription_no#</cfoutput>"  onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&field_id=list_help.subscription_id&field_no=list_help.subscription_no'</cfoutput>);"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-subscriber_stage">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='29441.Sistem No'></label>
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<select name="subscriber_stage" id="subscriber_stage" >
									<option value=""><cfoutput>#getLang(1404,"Abone Aşaması",40125)#</cfoutput></option>
									<cfoutput query="get_subscriber_stage">
										<option value="#process_row_id#" <cfif attributes.subscriber_stage eq process_row_id>selected</cfif>>#stage#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-app_cat">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58090.İletişim Yöntemi'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<select name="app_cat" id="app_cat" >
								<option value=""><cf_get_lang dictionary_id='58090.İletişim Yöntemi'></option>
								<cfoutput query="get_commethod">
									<option value="#commethod_id#" <cfif isdefined("attributes.app_cat") and attributes.app_cat eq commethod_id>selected</cfif>>#commethod#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-special_definition">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='49214.Özel Tanım'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<select name="special_definition" id="special_definition" >
								<option value=""><cf_get_lang dictionary_id='49214.Özel Tanım'></option>
								<cfoutput query="get_special_definition">
									<option value="#special_definition_id#" <cfif attributes.special_definition eq special_definition_id>selected</cfif>>#special_definition#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-applicant_name">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='29514.Başvuruyu Yapan'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<cfinput type="text" name="applicant_name"  value="#attributes.applicant_name#" maxlength="255">
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-comp_cat">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
								SELECT DISTINCT
									COMPANYCAT_ID,
									COMPANYCAT
								FROM
									GET_MY_COMPANYCAT
								WHERE
									EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
									OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
								ORDER BY
									COMPANYCAT
							</cfquery>
							<select name="comp_cat" id="comp_cat" >
								<option value=""><cf_get_lang dictionary_id='58609.Üye Kategorisi'>
								<cfoutput query="get_companycat">
									<option value="#companycat_id#" <cfif isdefined("attributes.comp_cat") and attributes.comp_cat eq companycat_id> selected</cfif>>#companycat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-start_date">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
								<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#"  validate="#validate_style#" message="#message#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-finish_date">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
									<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
					<div class="form-group" id="item-site_domain">
						<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57892.Domain'> <cf_get_lang dictionary_id='49318.Adresi'></label>
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
							<select name="site_domain" id="site_domain" >
								<option value=""><cf_get_lang dictionary_id='57892.Domain'> <cf_get_lang dictionary_id='49318.Adresi'></option>
								<cfoutput query="get_main_menu">
									<option value="#site_domain#" <cfif attributes.site_domain eq site_domain>selected</cfif>>#site_domain#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(1317,'Etkileşimler',58729)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<cfif session.ep.our_company_info.subscription_contract eq 1>
					<th><cf_get_lang dictionary_id='29502.Sistem No'></th>
					<th><cfoutput>#getLang(1404,"Abone Aşaması",40125)#</cfoutput></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57658.Üye'></th>
					<th><cf_get_lang dictionary_id='58859.Süreç'></th>
					<th><cf_get_lang dictionary_id='58090.İletişim Yöntemi'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='57480.Konu'></th>
					<th><cf_get_lang dictionary_id='29514.Başvuru Yapan'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='49259.Site Adı'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th> <!--- Basvuru Durumu --->
					<th><cf_get_lang dictionary_id='29513.Süre'></th>
					<th class="form-title"><cf_get_lang dictionary_id='57891.Güncelleyen Kişi'></th>
					<!-- sil --><th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=call.helpdesk&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_help.recordcount>
					<cfset partner_id_list =''>
					<cfset consumer_id_list =''>
					<cfset stage_list =''>
					<cfset cat_id_list =''>
					<cfset subscription_id_list =''>
					<cfset interaction_cat_id_list =''>
					<cfoutput query="get_help" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(partner_id) and not listFindnocase(partner_id_list,partner_id)>
							<cfset partner_id_list = listappend(partner_id_list,partner_id)>
						</cfif>
						<cfif len(consumer_id) and not listFindnocase(consumer_id_list,consumer_id)>
							<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
						</cfif>
						<cfif len(process_stage) and not listfind(stage_list,process_stage)>
							<cfset stage_list=listappend(stage_list,process_stage)>
						</cfif>
						<cfif len(app_cat) and not listfind(cat_id_list,app_cat)>
							<cfset cat_id_list=listappend(cat_id_list,app_cat)>
						</cfif>
						<cfif len(subscription_id) and not listfind(subscription_id_list,subscription_id)>
							<cfset subscription_id_list=listappend(subscription_id_list,subscription_id)>
						</cfif>
						<cfif len(interaction_cat) and not listfind(interaction_cat_id_list,interaction_cat)>
							<cfset interaction_cat_id_list=listappend(interaction_cat_id_list,interaction_cat)>
						</cfif>
					</cfoutput>

					<cfif listlen(partner_id_list)>
						<cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
						<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
							SELECT
								CP.COMPANY_PARTNER_NAME,
								CP.COMPANY_PARTNER_SURNAME,
								CP.PARTNER_ID,
								C.FULLNAME,
								C.NICKNAME,
								C.COMPANY_ID
							FROM
								COMPANY_PARTNER CP,
								COMPANY C
							WHERE
								CP.PARTNER_ID IN (#partner_id_list#) AND
								CP.COMPANY_ID = C.COMPANY_ID
							ORDER BY
								CP.PARTNER_ID
						</cfquery>
						<cfset partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner_detail.partner_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif listlen(consumer_id_list)>
						<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
						<cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
							SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#consumer_id_list#"> ) ORDER BY CONSUMER_ID
						</cfquery>
						<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(stage_list)>
						<cfset stage_list=listsort(stage_list,"numeric","ASC",",")>
						<cfquery name="PROCESS_TYPE" datasource="#DSN#">
							SELECT 
								CASE
									WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
									ELSE STAGE
								END AS STAGE,
								PROCESS_ROW_ID 
							FROM 
								PROCESS_TYPE_ROWS
								LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
								AND SLI.COLUMN_NAME =  <cfqueryparam cfsqltype="cf_sql_varchar" value="STAGE">
								AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROCESS_TYPE_ROWS">
								AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
							WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stage_list#">) ORDER BY PROCESS_ROW_ID
						</cfquery>
						<cfset stage_list = listsort(listdeleteduplicates(valuelist(process_type.process_row_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(cat_id_list)>
						<cfset cat_id_list=listsort(cat_id_list,"numeric","ASC",",")>
						<cfquery name="GET_COMMETHOD_" dbtype="query">
							SELECT COMMETHOD_ID, COMMETHOD FROM GET_COMMETHOD WHERE COMMETHOD_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#cat_id_list#">) ORDER BY COMMETHOD_ID
						</cfquery>
						<cfset cat_id_list = listsort(listdeleteduplicates(valuelist(get_commethod_.commethod_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif session.ep.our_company_info.subscription_contract eq 1>
						<cfif len(subscription_id_list)>
							<cfset subscription_id_list=listsort(subscription_id_list,"numeric","ASC",",")>
							<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
								SELECT
									CASE
									WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
									ELSE PTR.STAGE
									END AS STAGE,
									SC.SUBSCRIPTION_ID,
									SC.SUBSCRIPTION_NO,
									SC.SUBSCRIPTION_STAGE
									
								FROM
									SUBSCRIPTION_CONTRACT  SC,
									#dsn_alias#.PROCESS_TYPE_ROWS PTR
									LEFT JOIN #dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PTR.PROCESS_ROW_ID
									AND SLI.COLUMN_NAME =  <cfqueryparam cfsqltype="cf_sql_varchar" value="STAGE">
									AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROCESS_TYPE_ROWS">
									AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
								WHERE
									PTR.PROCESS_ROW_ID = SC.SUBSCRIPTION_STAGE AND
									SUBSCRIPTION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#subscription_id_list#">)  ORDER BY SUBSCRIPTION_ID
							</cfquery>
							<cfset subscription_id_list = listsort(listdeleteduplicates(valuelist(get_subscription.subscription_id,',')),'numeric','ASC',',')>
						</cfif>
					</cfif>
					<cfif len(interaction_cat_id_list)>
						<cfset interaction_cat_id_list=listsort(interaction_cat_id_list,"numeric","ASC",",")>
						<cfquery name="GET_INTERACTIONCAT" datasource="#DSN#">
							SELECT 
								CASE
								WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
								ELSE INTERACTIONCAT
								END AS INTERACTIONCAT,
								INTERACTIONCAT_ID
							FROM 
								SETUP_INTERACTION_CAT 
								LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_INTERACTION_CAT.INTERACTIONCAT_ID
								AND SLI.COLUMN_NAME =  <cfqueryparam cfsqltype="cf_sql_varchar" value="INTERACTIONCAT">
								AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_INTERACTION_CAT">
								AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
							WHERE 
								INTERACTIONCAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#interaction_cat_id_list#">)  
							ORDER BY 
								INTERACTIONCAT_ID
						</cfquery>
						<cfset interaction_cat_id_list = listsort(listdeleteduplicates(valuelist(get_interactioncat.interactioncat_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_help" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=call.helpdesk&event=upd&cus_help_id=#cus_help_id#" class="tableyazi">#cus_help_id#</a></td>
						<cfif session.ep.our_company_info.subscription_contract eq 1>
							<td><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#subscription_id#" class="tableyazi"><cfif len(subscription_id)>#get_subscription.subscription_no[listfind(subscription_id_list,subscription_id,',')]#</cfif></a></td>
							<td><cfif len(subscription_id)>#get_subscription.stage[listfind(subscription_id_list,subscription_id,',')]#</cfif></td>
						</cfif>
							<td>
								<cfif len(get_help.partner_id)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');" class="tableyazi">#get_partner_detail.nickname[listfind(partner_id_list,partner_id,',')]#</a> - <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#','medium');">#get_partner_detail.company_partner_name[listfind(partner_id_list,partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(partner_id_list,partner_id,',')]#</a>
								<cfelseif len(get_help.consumer_id)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi"> #get_consumer_detail.consumer_name[listfind(consumer_id_list,consumer_id,',')]#&nbsp; #get_consumer_detail.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#</a>
								</cfif>
							</td>
							<td>#process_type.stage[listfind(stage_list,process_stage,',')]#</td>
							<td>#get_commethod_.commethod[listfind(cat_id_list,app_cat,',')]#</td>
							<td><cfif len(interaction_cat)>#get_interactioncat.interactioncat[listfind(interaction_cat_id_list,interaction_cat,',')]#</cfif></td>
							<td>#left(detail,50)#</td>
							<td>#applicant_name#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<td>#site_domain#</td>
							<td>
								<cfif is_reply_mail neq 1>
									<font color="FFF0000"><cf_get_lang dictionary_id='49254.Cevaplandırılmadı'>!</font>
									<cfparam name="cevap_verilmedi" default="">
								</cfif>
								<cfif (is_reply_mail eq 1)>
									<cf_get_lang dictionary_id='49255.Cevaplandırıldı'>
								<cfelseif not isdefined('cevap_verilmedi')>
									<cf_get_lang dictionary_id='49254.Cevaplandirilmadi'>
								</cfif>
							</td>
							<td>
							<cfif len(duration)>
									<cfsavecontent variable="sure_#cus_help_id#">
										#(duration\1440)#<cf_get_lang dictionary_id='57490.Gün'>#((duration%1440) \ 60)#<cf_get_lang dictionary_id='57491.Saat'>#((duration%1440)%60)#<cf_get_lang dictionary_id='58127.Dakika'>
									</cfsavecontent>
									#evaluate("sure_#cus_help_id#")#
							</cfif>
							</td>
							<td><cfif len(update_emp)>#name#</cfif></td>
							<!---<!-- sil --><td><a href="#request.self#?fuseaction=call.upd_helpdesk&cus_help_id=#cus_help_id#"><img src="/images/update_list.gif" alt="<cf_get_lang dictionary_id='52.Güncelle'>" title="<cf_get_lang dictionary_id='52.Güncelle'>"></a></td><!-- sil -->--->
							<!-- sil --><td><a href="#request.self#?fuseaction=call.helpdesk&event=upd&cus_help_id=#cus_help_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="17"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.filtre ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset adres = "call.helpdesk">
		<cfif len(attributes.keyword)><cfset adres ="#adres#&keyword=#attributes.keyword#"></cfif>
		<cfif isdefined("attributes.service_cat") and len(attributes.service_cat)>
			<cfset adres ="#adres#&service_cat=#attributes.service_cat#">
		</cfif>
		<cfif len(attributes.is_reply)><cfset adres ="#adres#&is_reply=#attributes.is_reply#"></cfif>
		<cfif len(attributes.member_name) and len(attributes.member_type)>
			<cfif attributes.member_type eq 'partner'>
				<cfset adres ="#adres#&company_id=#attributes.company_id#&partner_id=#attributes.partner_id#">
			<cfelseif attributes.member_type eq 'consumer'>
				<cfset adres ="#adres#&consumer_id=#attributes.consumer_id#">
			</cfif>
			<cfset adres ="#adres#&member_type=#attributes.member_type#&member_name=#attributes.member_name#">
		</cfif>
		<cfif len(attributes.start_date)>
			<cfset adres ="#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.finish_date)>
			<cfset adres ="#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.app_cat)>
			<cfset adres ="#adres#&app_cat=#attributes.app_cat#">
		</cfif>
		<cfif len(attributes.applicant_name)>
			<cfset adres ="#adres#&applicant_name=#attributes.applicant_name#">
		</cfif>
		<cfif len(attributes.process_stage_type)>
			<cfset adres ="#adres#&process_stage_type=#attributes.process_stage_type#">
		</cfif>
		<cfif len(attributes.record_emp) and len(attributes.record_name)>
			<cfset adres ="#adres#&record_emp=#attributes.record_emp#&record_name=#attributes.record_name#">
		</cfif>
		<cfif len(attributes.subscription_id) and len(subscription_no)>
			<cfset adres ="#adres#&subscription_id=#attributes.subscription_id#&subscription_no=#attributes.subscription_no#">
		</cfif>
		<cfif len(attributes.interaction_cat)>
			<cfset adres ="#adres#&interaction_cat=#interaction_cat#">
		</cfif>
		<cfif isDefined("attributes.comp_cat") and len(attributes.comp_cat)>
			<cfset adres ="#adres#&comp_cat=#comp_cat#">
		</cfif>
		<cfif isdefined("attributes.ordertype") and len(attributes.ordertype)>
			<cfset adres = "#adres#&ordertype=#attributes.ordertype#">
		</cfif>
		<cfif len(attributes.subscriber_stage)>
			<cfset adres = "#adres#&subscriber_stage=#attributes.subscriber_stage#">
		</cfif>
		<cfif len(attributes.project_id)>
			<cfset adres = "#adres#&project_id=#attributes.project_id#">
		</cfif>
		<cfif Len(attributes.special_definition)><cfset adres = "#adres#&special_definition=#attributes.special_definition#"></cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#&form_submitted=1">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function kontrol()
	{
		if (document.getElementById('project_head').value == '')
			document.getElementById('project_id').value = '';
		if(!date_check(document.getElementById("start_date"), document.getElementById("finish_date"), "<cf_get_lang dictionary_id='49299.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
			return false;
		else
			return true;
	}
</script>
