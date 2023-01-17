<cf_xml_page_edit>
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword_subject" default="">
<cfparam name="attributes.keyword_detail" default="">
<cfparam name="attributes.recorder_id" default="">
<cfparam name="attributes.recorder_name" default="">
<cfparam name="attributes.task_person_name" default="">
<cfparam name="attributes.resp_emp_name" default="">
<cfparam name="attributes.resp_emp_id" default="">
<cfparam name="attributes.resp_par_id" default="">
<cfparam name="attributes.resp_comp_id" default="">
<cfparam name="attributes.resp_cons_id" default="">
<cfparam name="attributes.priority_cat" default="">
<cfparam name="attributes.task_emp_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.county" default="">
<cfif isdefined("attributes.service_status")>
	<cfparam name="attributes.service_status" default="">
<cfelse>
	<cfparam name="attributes.service_status" default="1">
</cfif>
<cfparam name="attributes.task_position_code" default="">
<cfparam name="attributes.task_cmp_id" default="">
<cfparam name="attributes.ComMethod_Id" default="">
<cfparam name="attributes.workgroup_id" default="" />
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("session.service_reply")>
	<cfscript>structdelete(session,"service_reply");</cfscript>
</cfif>
<cfif isdefined("session.service_task")>
	<cfscript>structdelete(session,"service_task");</cfscript>
</cfif>

<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isDate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfparam name="attributes.start_date" default="">
	<cfelse>	
		<cfparam name="attributes.start_date" default="#date_add('d',-7,wrk_get_today())#">
	</cfif>
</cfif>

<cfif isdefined("attributes.finish_date") and len(attributes.finish_date) and isDate(attributes.finish_date)>
	<cfparam name="attributes.finish_date" default="#attributes.finish_date#">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfparam name="attributes.finish_date" default="">
	<cfelse>	
		<cfparam name="attributes.finish_date" default="#now()#">
	</cfif>
</cfif>

<cfif isdefined("attributes.start_date1")>
	<cfparam name="attributes.start_date1" default="#attributes.start_date1#">
<cfelse>
	<cfparam name="attributes.start_date1" default="">
</cfif>

<cfif isdefined("attributes.finish_date1")>
	<cfparam name="attributes.finish_date1" default="#attributes.finish_date1#">
<cfelse>
	<cfparam name="attributes.finish_date1" default="">
</cfif>

<cfif isDefined('x_show_authorized_stage') and x_show_authorized_stage eq 1>
	<cf_workcube_process_info>
</cfif>
<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN#">
	SELECT 
		CASE
            WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
			ELSE SERVICECAT
		END AS SERVICECAT,
		SERVICECAT_ID
	FROM 
		G_SERVICE_APPCAT
		LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = G_SERVICE_APPCAT.SERVICECAT_ID
        AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SERVICECAT">
        AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="G_SERVICE_APPCAT">
        AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
	WHERE
    	IS_STATUS = 1 AND
        (
            OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#"> OR
            OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#"> OR
            OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.company_id#,%"> OR
            OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#,%">
        )
	ORDER BY 
		SERVICECAT
</cfquery>
<cfquery name="GET_PROCESS_TYPES" datasource="#DSN#">
	SELECT
		 CASE
            WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
            ELSE STAGE
        END AS STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR
        LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = ptr.PROCESS_ROW_ID
        AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="STAGE">
        AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROCESS_TYPE_ROWS">
        AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
        ,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.list_service,%">
		<cfif isDefined('x_show_authorized_stage') and x_show_authorized_stage eq 1 and isDefined("process_rowid_list") and ListLen(process_rowid_list)>
            AND PTR.PROCESS_ROW_ID IN (#process_rowid_list#)
        </cfif>
</cfquery>
<cfquery name="GET_WORKGROUPS" datasource="#DSN#">
	SELECT
		#dsn#.Get_Dynamic_Language(WORK_GROUP.WORKGROUP_ID,'#session.ep.language#','WORK_GROUP','WORKGROUP_NAME',NULL,NULL,WORK_GROUP.WORKGROUP_NAME) AS workgroup_name,
		WORKGROUP_ID		
	FROM 
		WORK_GROUP
	WHERE
		STATUS = 1 AND
		HIERARCHY IS NOT NULL
	ORDER BY 
		WORKGROUP_NAME
</cfquery>
<cf_workcube_process_info>
<cfinclude template="../query/get_branch.cfm">
<cfset branch_id_list=listsort(valuelist(get_branch.branch_id),"numeric","ASC",",")>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_service.cfm">
<cfelse>
  	<cfset get_service.recordcount = 0>
    <cfset get_service.query_count = 0>
</cfif>
<cfif isdefined("attributes.form_submitted")>
<cfset list_sub_id=listdeleteduplicates(valuelist(get_service.subscription_id))>
	<cfif len(list_sub_id)>
        <cfquery name="LIST_SUB_NO" datasource="#DSN3#">
            SELECT SUBSCRIPTION_NO,SUBSCRIPTION_HEAD,SUBSCRIPTION_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IS NOT NULL AND SUBSCRIPTION_ID IN(#list_sub_id#)
        </cfquery>
        <cfoutput query="list_sub_no">
            <cfset "sub_no_#subscription_id#"=subscription_no>
            <cfset "sub_head_#subscription_id#"=subscription_head>
        </cfoutput>
    </cfif>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_service.query_count#">
<div class="col col-12 copl-md-12 col-sm-12 col-xs-12">
	<cfform name="list_service" id="list_service" method="post" action="#request.self#?fuseaction=call.list_service">
		<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<cf_box>
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='49302.Başvuru'> <cf_get_lang dictionary_id='57487.no'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#message#">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57480.konu'></cfsavecontent>
					<cfinput type="text" name="keyword_subject" id="keyword_subject" value="#attributes.keyword_subject#" placeholder="#message#">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57629.açıklama'></cfsavecontent>
					<cfinput type="text" name="keyword_detail" id="keyword_detail" value="#attributes.keyword_detail#" placeholder="#message#">
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
						<input name="company" type="text" id="company" placeholder="<cf_get_lang dictionary_id='57457.Müşteri'>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1','COMPANY_ID','company_id','list_service','3','110')" value="<cfif isdefined("attributes.company")><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
						<cfif get_module_user(47)><span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57457.Müşteri'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_period_kontrol=0&field_location=service&field_comp_id=list_service.company_id&field_comp_name=list_service.company&select_list=7&keyword='+encodeURIComponent(document.list_service.company.value),'list');"></span></cfif>
					</div>
				</div>
				<div class="form-group">
					<select name="process_stage" id="process_stage">
						<option value="" selected><cf_get_lang dictionary_id='58859.Süreç'></option>
						<cfoutput query="get_process_types">
							<option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="service_status" id="service_status">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif isdefined("attributes.service_status") and attributes.service_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif isdefined("attributes.service_status") and attributes.service_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>   
				</div>	
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function='kontrol()' button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
						SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
					</cfquery>
					<div class="form-group" id="item-sales_zones">
						<label><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
						<select name="sales_zones" id="sales_zones">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_sales_zones">
									<option value="#sz_id#" <cfif isdefined("attributes.sales_zones") and sz_id eq attributes.sales_zones> selected</cfif>>#sz_name#</option>
								</cfoutput>
						</select>
					</div>
					<div class="form-group" id="item-ComMethod_Id">
						<label><cf_get_lang dictionary_id='58143.İletişim'></label>
						<cf_wrkComMethod width="100" ComMethod_Id="#attributes.ComMethod_Id#">
					</div>
					<div class="form-group" id="item-branch_id">
						<label><cf_get_lang dictionary_id='49274.İlgili Şube'></label>
						<select name="service_branch_id" id="service_branch_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_branch">
								<option value="#branch_id#" <cfif isdefined("attributes.service_branch_id") and attributes.service_branch_id eq branch_id> selected</cfif>>#branch_name#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group" id="item-priority_cat">
						<label><cf_get_lang dictionary_id='57485.Öncelik'></label>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57734.seçiniz'></cfsavecontent>
						<cf_wrk_select name="priority_cat" width="110" table_name="SETUP_PRIORITY" field="PRIORITY" value="PRIORITY_ID" option_text="#message#">
					</div>
					<div class="form-group" id="item-notify_app_name">
						<label><cf_get_lang dictionary_id='38725.Başvuruyu Bildiren'></label>
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="notify_emp_id" id="notify_emp_id" value="<cfif isdefined("attributes.notify_emp_id")>#attributes.notify_emp_id#</cfif>">
								<input type="hidden" name="notify_par_id" id="notify_par_id" value="<cfif isdefined("attributes.notify_par_id")>#attributes.notify_par_id#</cfif>">
								<input type="hidden" name="notify_con_id" id="notify_con_id" value="<cfif isdefined("attributes.notify_con_id")>#attributes.notify_con_id#</cfif>">
								<input name="notify_app_name" type="text" id="notify_app_name" onfocus="AutoComplete_Create('notify_app_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\'','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID','notify_emp_id,notify_par_id,notify_con_id','list_service','3','110');"  value="<cfif isdefined("attributes.notify_app_name")>#attributes.notify_app_name#</cfif>" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='38725.Başvuruyu Bildiren'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_period_kontrol=0&field_location=service&field_emp_id=list_service.notify_emp_id&field_partner=list_service.notify_par_id&field_consumer=list_service.notify_con_id&field_name=list_service.notify_app_name&select_list=1,2,3&keyword='+encodeURIComponent(document.list_service.made_application.value),'list');"></span>
							</cfoutput>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-project_id">
						<label><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
								<input name="project_head" type="text" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" value="#attributes.project_head#" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57416.Proje'>" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_head=list_service.project_head&project_id=list_service.project_id');"></span>
							</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-resp_emp_name">
						<label><cf_get_lang dictionary_id='57544.Sorumlu'></label>
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="resp_emp_id" id="resp_emp_id" value="<cfif len(attributes.resp_emp_id)>#attributes.resp_emp_id#</cfif>">
								<input type="hidden" name="resp_par_id" id="resp_par_id" value="<cfif len(attributes.resp_par_id)>#attributes.resp_par_id#</cfif>">
								<input type="hidden" name="resp_comp_id" id="resp_comp_id" value="<cfif len(attributes.resp_comp_id)>#attributes.resp_comp_id#</cfif>">
								<input type="hidden" name="resp_cons_id" id="resp_cons_id" value="<cfif len(attributes.resp_cons_id)>#attributes.resp_cons_id#</cfif>">
								<cfinput type="text" name="resp_emp_name" id="resp_emp_name" value="#attributes.resp_emp_name#" onFocus="AutoComplete_Create('resp_emp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0','COMPANY_ID,PARTNER_ID,CONSUMER_ID,EMPLOYEE_ID','resp_comp_id,resp_par_id,resp_cons_id,resp_emp_id','','3','160');">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57544.Sorumlu'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_name=list_service.resp_emp_name&field_emp_id=list_service.resp_emp_id&field_consumer=list_service.resp_cons_id&field_partner=list_service.resp_par_id&field_comp_id=list_service.resp_comp_id&select_list=1,7,8&keyword='+encodeURIComponent(document.list_service.resp_emp_name.value),'list');"></span>
							</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-TASK_PERSON_NAME">
						<label><cf_get_lang dictionary_id='57569.Görevli'></label>
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="TASK_EMP_ID" id="TASK_EMP_ID" value="<cfif isdefined("attributes.TASK_EMP_ID")>#attributes.TASK_EMP_ID#</cfif>">
								<input type="hidden" name="TASK_PAR_ID" id="TASK_PAR_ID" value="<cfif isdefined("attributes.TASK_PAR_ID")>#attributes.TASK_PAR_ID#</cfif>" >
								<cfinput type="text" name="TASK_PERSON_NAME" id="TASK_PERSON_NAME" value="#attributes.TASK_PERSON_NAME#" onFocus="AutoComplete_Create('TASK_PERSON_NAME',' MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\'','EMPLOYEE_ID,PARTNER_ID','TASK_EMP_ID,TASK_PAR_ID','','3','110');">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57544.Sorumlu'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_name=list_service.TASK_PERSON_NAME&field_id=list_service.TASK_PAR_ID&field_emp_id=list_service.TASK_EMP_ID&select_list=1,7&keyword='+encodeURIComponent(document.list_service.TASK_PERSON_NAME.value),'list');"></span>
							</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-recorder_name">
						<label><cf_get_lang dictionary_id='47944.Kayıt Yapan'></label>
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="record_par_id" id="record_par_id" value="<cfif isdefined("attributes.record_par_id")>#attributes.record_par_id#</cfif>">
								<input type="hidden" name="record_cons_id" id="record_cons_id" value="<cfif isdefined("attributes.record_cons_id")>#attributes.record_cons_id#</cfif>">
								<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")>#attributes.record_emp_id#</cfif>">
								<input name="recorder_name" type="text" id="recorder_name" onfocus="AutoComplete_Create('recorder_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0,0','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID','record_emp_id,record_par_id,record_cons_id','list_service','3','110');" value="#attributes.recorder_name#" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='47944.Kayıt Yapan'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=list_service.record_emp_id&field_partner=list_service.record_par_id&field_consumer=list_service.record_cons_id&field_name=list_service.recorder_name&select_list=1,2,3&is_form_submitted=1&keyword='+encodeURIComponent(document.list_service.recorder_name.value),'list');"></span>
							</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-made_application">
						<label><cf_get_lang dictionary_id='29514.Başvuru Yapan'></label>
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="employee_id_" id="employee_id_" value="<cfif isdefined("attributes.partner_id_")>#attributes.partner_id_#</cfif>">
								<input type="hidden" name="partner_id_" id="partner_id_" value="<cfif isdefined("attributes.partner_id_")>#attributes.partner_id_#</cfif>">
								<input type="hidden" name="consumer_id_" id="consumer_id_" value="<cfif isdefined("attributes.consumer_id_")>#attributes.consumer_id_#</cfif>">
								<input name="made_application" type="text"  id="made_application" onfocus="AutoComplete_Create('made_application','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\'','PARTNER_ID,CONSUMER_ID','partner_id_,consumer_id_','list_service','3','110');"  value="<cfif isdefined("attributes.made_application")>#attributes.made_application#</cfif>" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='29514.Başvuru Yapan'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_period_kontrol=0&field_location=service&field_emp_id=list_service.employee_id_&field_partner=list_service.partner_id_&field_consumer=list_service.consumer_id_&field_name=list_service.made_application&select_list=7,8&keyword='+encodeURIComponent(document.list_service.made_application.value),'list');"></span>
							</cfoutput>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-vergi_no">
						<label><cf_get_lang dictionary_id='57752.Vergi No'></label>
						<cfoutput>
							<input type="text" name="vergi_no" id="vergi_no" value="<cfif isdefined("attributes.vergi_no") and len(attributes.vergi_no)>#attributes.vergi_no#</cfif>">
						</cfoutput>
					</div>
					<cfif session.ep.our_company_info.subscription_contract eq 1>
						<div class="form-group" id="item-subscription_no">
							<label><cf_get_lang dictionary_id='29502.Sistem No'></label>
							<div class="input-group">
								<cfoutput>
									<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")>#attributes.subscription_id#</cfif>">
									<input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")>#attributes.subscription_no#</cfif>" onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','85');" autocomplete="off" >
									<span class="input-group-addon btnPointer icon-ellipsis"  alt="<cf_get_lang dictionary_id='29502.Sistem No'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_subscription&field_id=list_service.subscription_id&field_no=list_service.subscription_no','list','popup_list_subscription');"></span>
								</cfoutput>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-service_cat">
						<label><cf_get_lang dictionary_id='39313.Servis Kategori'></label>
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="service_cat_id" id="service_cat_id" value="<cfif isdefined("attributes.service_cat_id")>#attributes.service_cat_id#</cfif>">
								<input type="hidden" name="service_sub_cat_id" id="service_sub_cat_id" value="<cfif isdefined("attributes.service_sub_cat_id")>#attributes.service_sub_cat_id#</cfif>">
								<input type="hidden" name="service_sub_status_id" id="service_sub_status_id" value="<cfif isdefined("attributes.service_sub_status_id")>#attributes.service_sub_status_id#</cfif>">
								<input type="text" name="service_cat" id="service_cat" value="<cfif isdefined("attributes.service_cat")>#attributes.service_cat#</cfif>">
								<span class="input-group-addon btnPointer icon-ellipsis"  alt="<cf_get_lang dictionary_id='57486.Kategori'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_service_app_cats&service_cat=list_service.service_cat&service_cat_id=list_service.service_cat_id&service_sub_cat_id=list_service.service_sub_cat_id&service_sub_status_id=list_service.service_sub_status_id','medium');"></span>
							</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-service_appcat">
						<label><cf_get_lang dictionary_id='49302.Başvuru'><cf_get_lang dictionary_id='57486.Kategori'></label>
						<select name="appcat_id" id="appcat_id">
							<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_service_appcat">
								<option value="#servicecat_id#" <cfif isdefined("attributes.appcat_id") and (attributes.appcat_id eq servicecat_id)>selected</cfif>>#servicecat#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group" id="item-workgroup_id">
						<label><cf_get_lang dictionary_id='58140.İş Grubu'></label>
						<select name="workgroup_id" id="workgroup_id" >				  
							<option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>
							<cfoutput query="get_workgroups">
								<option value="#get_workgroups.workgroup_id#"<cfif attributes.workgroup_id eq workgroup_id>selected</cfif>>#get_workgroups.workgroup_name#</option>
							</cfoutput>
						</select>                 
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-city">
						<label><cf_get_lang dictionary_id='58608.İl'></label>
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="city_id" id="city_id" value="<cfif isdefined("attributes.city_id")>#attributes.city_id#</cfif>">
								<input type="text" name="city"  id="city" onchange="c_del('city','city_id')"onfocus="AutoComplete_Create('city','CITY_NAME','CITY_NAME','get_city','','CITY_ID','city_id','list_service','3','105');" value="<cfif isdefined("attributes.city")>#attributes.city#</cfif>" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58608.İl'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_city&field_id=list_service.city_id&field_name=list_service.city','small');"></span>
							</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-county">
						<label><cf_get_lang dictionary_id='58638.İlçe'></label>
						<div class="input-group">
							<cfoutput>
								<input type="hidden" name="county_id" id="county_id" value="<cfif isdefined("attributes.county_id")>#attributes.county_id#</cfif>">
								<input name="county" type="text" id="county" onchange="c_del('county','county_id')"  onfocus="AutoComplete_Create('county','COUNTY_NAME,CITY_NAME','COUNTY_NAME,CITY_NAME','get_county','','COUNTY_ID,CITY_NAME,CITY_ID','county_id,city,city_id','list_service','3','85')" value="<cfif isdefined("attributes.county")>#attributes.county#</cfif>" autocomplete="off" >
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58638.İlçe'>" onclick="pencere_ac2();"></span>
							</cfoutput>
						</div>
					</div>
					<div class="form-group" id="item-start_date1">
						<label><cf_get_lang dictionary_id='49293.Kabul Tarihi'></label>
						<div class="col col-12">
							<div class="col col-6">
								<div class="input-group">
									<cfoutput>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='58053. Başlangıç Tarihi'></cfsavecontent>
										<cfinput type="text" name="start_date1" maxlength="10" value="#dateformat(attributes.start_date1,dateformat_style)#" validate="#validate_style#" message="#message#">
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date1"></span>
									</cfoutput>
								</div>
							</div>
							<div class="col col-6">
								<div class="input-group">
									<cfoutput>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='57700. Bitiş Tarihi'></cfsavecontent>
										<cfinput type="text" name="finish_date1" maxlength="10" value="#dateformat(attributes.finish_date1,dateformat_style)#" validate="#validate_style#" message="#message#">
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date1"></span>
									</cfoutput>
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-start_date1">
						<label><cf_get_lang dictionary_id='49292.Başvuru Tarihi'></label>
						<div class="col col-12">
							<div class="col col-6">
								<div class="input-group">
									<cfoutput>
										<cfif session.ep.our_company_info.unconditional_list>
											<cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
										<cfelse>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='58053. Başlangıç Tarihi'></cfsavecontent>
											<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#message#">
										</cfif>
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
									</cfoutput>
								</div>
							</div>
							<div class="col col-6">
								<div class="input-group">
									<cfoutput>
										<cfif session.ep.our_company_info.unconditional_list>
											<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10">
										<cfelse>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='57700. Bitiş Tarihi'></cfsavecontent>
											<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" message="#message#">
										</cfif>
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
									</cfoutput>
								</div>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cf_box>
	</cfform>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='58186.Başvurular'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_service_id',  print_type : 461 }#">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.sıra'></th>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='57416.Proje'></th>
					<th><cf_get_lang dictionary_id='57480.Konu'></th>
					<th><cf_get_lang dictionary_id='31061.Alt Kategori'></th>
					<th><cf_get_lang dictionary_id='38732.Alt Tree Kategori'></th>
					<th><cf_get_lang dictionary_id='29514.Başvuru Yapan'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='29688.Kişisel'><cf_get_lang dictionary_id='57499.Telefon'></th>
					<th><cf_get_lang dictionary_id='29688.Kişisel'><cf_get_lang dictionary_id='58813.Cep Telefon'></th>
					<th><cf_get_lang dictionary_id='58143.İletişim'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th> 
					<th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
					<th><cf_get_lang dictionary_id ='57569.Görevli'></th> 
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='58608.İl'></th>
					<th><cf_get_lang dictionary_id='58638.İlçe'></th>
					<th><cf_get_lang dictionary_id='57659.Satış Bölgesi'></th>
					<th><cf_get_lang dictionary_id='57499.Telefon'></th>
					<th><cf_get_lang dictionary_id='29502.Sistem No'></th>
					<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>          
					<!-- sil --><th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=call.list_service&event=add"><i class="fa fa-plus" alt="Ekle"></i></a></th><!-- sil -->
					<cfif isdefined("attributes.form_submitted") and get_service.recordcount >
						<th width="20" class="text-center header_icn_none">
						<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_service_id');"></th>	</cfif>

				</tr>
			</thead>
			<tbody>
				<cfif get_service.recordcount>
					<cfset partner_id_list = "">
					<cfset consumer_id_list = "">
					<cfset company_id_list = "">
					<cfset service_branch_id_list = "">
					<cfset service_id_list = "">
					<cfset commethod_id_list = "">
					<cfset servicecat_sub_list = "">
					<cfset employee_list = "">
					<cfset record_consumer_id_list = "">
					<cfset record_par_id_list = "">
					<cfoutput query="get_service"> 
						<cfif len(service_partner_id) and not listfind(partner_id_list,service_partner_id)>
							<cfset partner_id_list=listappend(partner_id_list,service_partner_id)>
						</cfif>
						<cfif len(service_company_id) and not listfind(company_id_list,service_company_id)>
							<cfset company_id_list=listappend(company_id_list,service_company_id)>
						</cfif>
						<cfif len(service_consumer_id) and not listfind(consumer_id_list,service_consumer_id)>
							<cfset consumer_id_list=listappend(consumer_id_list,service_consumer_id)>
						</cfif>
						<cfif len(service_branch_id) and not listfind(service_branch_id_list,service_branch_id)>
							<cfset service_branch_id_list=listappend(service_branch_id_list,service_branch_id)>
						</cfif>
						<cfif len(service_id) and not listfind(service_id_list,service_id)>
							<cfset service_id_list=listappend(service_id_list,service_id)>
						</cfif>
						<cfif len(commethod_id) and not listfind(commethod_id_list,commethod_id)>
							<cfset commethod_id_list=listappend(commethod_id_list,commethod_id)>
						</cfif>
						<cfif len(service_id) and not listfind(servicecat_sub_list,service_id)>
							<cfset servicecat_sub_list=listappend(servicecat_sub_list,service_id)>
						</cfif>
						<cfif len(service_employee_id) and not listfind(employee_list,service_employee_id)>
							<cfset employee_list=listappend(employee_list,service_employee_id)>
						</cfif>
						<cfif len(record_member) and not listfind(employee_list,record_member)>
							<cfset employee_list=listappend(employee_list,record_member)>
						</cfif>
						<cfif len(record_par) and not listfind(record_par_id_list,record_par)>
							<cfset record_par_id_list=listappend(record_par_id_list,record_par)>
						</cfif>
						<cfif len(record_cons) and not listfind(record_consumer_id_list,record_cons)>
							<cfset record_consumer_id_list=listappend(record_consumer_id_list,record_cons)>
						</cfif>
					</cfoutput>
					<cfif len(partner_id_list)>
						<cfset partner_id_list=ListSort(partner_id_list,"numeric","ASC",",")>
						<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
							SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,PARTNER_ID FROM COMPANY_PARTNER WHERE PARTNER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#partner_id_list#">) ORDER BY PARTNER_ID
						</cfquery>
						<cfset partner_id_list = ListSort(ListDeleteDuplicates(ValueList(get_partner_detail.partner_id,',')),"numeric","asc",",")>
					</cfif>
					<cfif len(company_id_list)>
						<cfset company_id_list=ListSort(company_id_list,"numeric","ASC",",")>
						<cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
							SELECT FULLNAME,COMPANY_ID,SALES_COUNTY FROM COMPANY WHERE COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#company_id_list#">) ORDER BY COMPANY_ID
						</cfquery>
						<cfset company_id_list = ListSort(ListDeleteDuplicates(ValueList(get_company_detail.company_id,',')),"numeric","asc",",")>
					<!--- Satış Bölgesi için eklenen kod--->
						<cfset s_county_list=ListSort(listdeleteduplicates(valuelist(get_company_detail.sales_county)),"numeric","ASC",",")>
							<cfif listlen(s_county_list)>
								<cfquery name="get_sales_county" datasource="#dsn#">
									SELECT 
										SZ_ID, 
										SZ_NAME,
										COMPANY_ID 
									FROM 
										SALES_ZONES,
										COMPANY 
									WHERE
										SALES_ZONES.SZ_ID=COMPANY.SALES_COUNTY AND
										SZ_ID IN (#s_county_list#)
									ORDER BY 
										COMPANY_ID 
								</cfquery>
								<cfset s_county_list = ListSort(ListDeleteDuplicates(ValueList(get_sales_county.company_id,',')),"numeric","asc",",")>
							</cfif>
					</cfif>
					<cfif len(consumer_id_list)>
						<cfset consumer_id_list=ListSort(consumer_id_list,"numeric","ASC",",")>
						<cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
							SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID,SALES_COUNTY FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#consumer_id_list#">) ORDER BY CONSUMER_ID
						</cfquery>
						<cfset consumer_id_list = ListSort(ListDeleteDuplicates(ValueList(get_consumer_detail.consumer_id,',')),"numeric","asc",",")>
					<!--- Satış Bölgesi için eklenen kod--->
						<cfset s_county2_list=ListSort(listdeleteduplicates(valuelist(get_consumer_detail.sales_county)),"numeric","ASC",",")>
							<cfif listlen(s_county2_list)>
								<cfquery name="get_sales_county2" datasource="#dsn#">
								SELECT 
										SZ_ID, 
										SZ_NAME,
										CONSUMER_ID 
									FROM 
										SALES_ZONES,
										CONSUMER
									WHERE
										SALES_ZONES.SZ_ID=CONSUMER.SALES_COUNTY AND
										SZ_ID IN (#s_county2_list#)
									ORDER BY 
										CONSUMER_ID 
								</cfquery>
								<cfset s_county2_list = ListSort(ListDeleteDuplicates(ValueList(get_sales_county2.consumer_id,',')),"numeric","asc",",")>
							</cfif>
					</cfif>
					<cfif len(employee_list)>
						<cfset employee_list=ListSort(employee_list,"numeric","ASC",",")>
						<cfquery name="GET_RECORD_EMP" datasource="#DSN#">
							SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#employee_list#">) ORDER BY EMPLOYEE_ID
						</cfquery>
						<cfset employee_list = ListSort(ListDeleteDuplicates(ValueList(GET_RECORD_EMP.EMPLOYEE_ID,',')),"numeric","asc",",")>
					</cfif>

					<cfif len(record_par_id_list)>
						<cfset record_par_id_list=ListSort(record_par_id_list,"numeric","ASC",",")>
						<cfquery name="GET_RECORD_PAR" datasource="#DSN#">
							SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME, PARTNER_ID, COMPANY_ID FROM COMPANY_PARTNER WHERE PARTNER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#record_par_id_list#">) ORDER BY PARTNER_ID
						</cfquery>
						<cfset record_par_id_list = ListSort(ListDeleteDuplicates(ValueList(get_record_par.partner_id,',')),"numeric","asc",",")>
					</cfif>
							
					<cfif len(record_consumer_id_list)>
						<cfset consumer_id_list=ListSort(record_consumer_id_list,"numeric","ASC",",")>
						<cfquery name="GET_RECORD_CONSUMER_DETAIL" datasource="#DSN#">
							SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID,SALES_COUNTY FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#record_consumer_id_list#">) ORDER BY CONSUMER_ID
						</cfquery>
						<cfset record_consumer_id_list = ListSort(ListDeleteDuplicates(ValueList(get_record_consumer_detail.consumer_id,',')),"numeric","asc",",")>
					</cfif>
						<cfif len(service_branch_id_list)>
							<cfset service_branch_id_list=listsort(service_branch_id_list,"numeric","ASC",",")>
							<cfquery name="GET_BRANCH_NAME" datasource="#DSN#">
								SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_branch_id_list#">) ORDER BY BRANCH_ID
							</cfquery>
							<cfset service_branch_id_list = ListSort(ListDeleteDuplicates(ValueList(get_branch_name.branch_id,',')),'numeric','ASC',',')>
						</cfif>
					<cfif len(service_id_list)>
						<cfset service_id_list=ListSort(service_id_list,"numeric","ASC",",")>
						<cfquery name="GET_SERVICE_EMPLOYEE_DETAIL" datasource="#DSN#">
							SELECT 
								PW.G_SERVICE_ID,
								E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS USER_
							FROM 
								EMPLOYEES E,
								PRO_WORKS PW
							WHERE 
								E.EMPLOYEE_ID = PW.PROJECT_EMP_ID AND
								PW.G_SERVICE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_id_list#">)
							ORDER BY 
								PW.G_SERVICE_ID
						</cfquery>
						<cfif GET_SERVICE_EMPLOYEE_DETAIL.recordcount>
							<cfoutput query="GET_SERVICE_EMPLOYEE_DETAIL">
								<cfif isdefined("service_gorevli_employees_#G_SERVICE_ID#")>
									<cfset 'service_gorevli_employees_#G_SERVICE_ID#' = listappend(evaluate("service_gorevli_employees_#G_SERVICE_ID#"),user_)>
								<cfelse>
									<cfset 'service_gorevli_employees_#G_SERVICE_ID#' = user_>
								</cfif>
							</cfoutput>
						</cfif>
						<cfquery name="GET_SERVICE_PARTNER_DETAIL" datasource="#DSN#">
							SELECT 
								PW.G_SERVICE_ID,
								CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS USER_					
							FROM 
								COMPANY_PARTNER CP,
								PRO_WORKS PW
							WHERE 
								CP.PARTNER_ID = PW.OUTSRC_PARTNER_ID AND
								PW.SERVICE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_id_list# ">)
							ORDER BY 
								PW.G_SERVICE_ID
						</cfquery>
						<cfif GET_SERVICE_PARTNER_DETAIL.recordcount>
							<cfoutput query="GET_SERVICE_PARTNER_DETAIL">
								<cfif isdefined("service_gorevli_partners_#G_SERVICE_ID#")>
									<cfset 'service_gorevli_partners_#G_SERVICE_ID#' = listappend(evaluate("service_gorevli_partners_#G_SERVICE_ID#"),user_)>
								<cfelse>
									<cfset 'service_gorevli_partners_#G_SERVICE_ID#' = user_>
								</cfif>
							</cfoutput>
						</cfif>
					</cfif>
					<cfif len(commethod_id_list)>
						<cfset commethod_id_list=listsort(commethod_id_list,"numeric","ASC",",")>
						<cfquery name="get_commethod_det" datasource="#DSN#">
							SELECT COMMETHOD,COMMETHOD_ID FROM SETUP_COMMETHOD WHERE COMMETHOD_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#commethod_id_list#">) ORDER BY COMMETHOD_ID
						</cfquery>
						<cfset commethod_id_list = ListSort(ListDeleteDuplicates(ValueList(get_commethod_det.COMMETHOD_ID,',')),'numeric','ASC',',')>
					</cfif>
						<cfquery name="get_cat" datasource="#dsn#">
							SELECT 
								GAR.SERVICE_ID,
								GAS.SERVICE_SUB_CAT
							FROM 
								G_SERVICE_APP_ROWS GAR,
								G_SERVICE_APPCAT_SUB GAS
						WHERE
								GAR.SERVICE_SUB_CAT_ID = GAS.SERVICE_SUB_CAT_ID AND 
								GAR.SERVICE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_id_list#">)
						ORDER BY
								GAR.SERVICE_ID
						</cfquery>
						<cfoutput query="get_cat">
							<cfset "ser_cat_#SERVICE_ID#"=SERVICE_SUB_CAT>
						</cfoutput>			<cfif len(servicecat_sub_list)>
							<cfquery name="get_sub_status" datasource="#dsn#">
								SELECT
									GAR.SERVICE_ID,
									GAS.SERVICE_SUB_CAT + ' ' + '<font color="999999">' + SERVICE_SUB_STATUS + '</font>' AS INFO_
								FROM
									G_SERVICE_APP_ROWS GAR,
									G_SERVICE_APPCAT_SUB GAS,
									G_SERVICE_APPCAT_SUB_STATUS GAST
								WHERE
									GAR.SERVICE_SUB_CAT_ID = GAS.SERVICE_SUB_CAT_ID AND
									GAR.SERVICE_SUB_STATUS_ID = GAST.SERVICE_SUB_STATUS_ID AND
									GAR.SERVICE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#servicecat_sub_list#">)
								ORDER BY
									GAR.SERVICE_ID
							</cfquery>
							<cfset servicecat_sub_list = listsort(listdeleteduplicates(valuelist(get_sub_status.service_id,',')),"numeric","asc",",")>
							<cfif get_sub_status.recordcount>
							<cfoutput query="get_sub_status">
								<cfif isdefined("service_info_#SERVICE_ID#")>
									<cfset 'service_info_#SERVICE_ID#' = listappend(evaluate("service_info_#SERVICE_ID#"),INFO_)>
								<cfelse>
									<cfset 'service_info_#SERVICE_ID#' = INFO_>
								</cfif>
							</cfoutput>
						</cfif>
						</cfif>
						<cfquery name="get_count_name" datasource="#dsn#">
							SELECT
								SC.COUNTY_NAME,
								S.SERVICE_ID
							FROM 
								SETUP_COUNTY SC,
								G_SERVICE S,
								COMPANY
							WHERE
								COMPANY.COMPANY_ID= S.SERVICE_COMPANY_ID AND 
								SC.COUNTY_ID = COMPANY.COUNTY AND
								S.SERVICE_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_id_list#">)
							ORDER BY
								SERVICE_ID
						</cfquery>
						<cfoutput query="get_count_name">
							<cfset "county_name_#SERVICE_ID#"=COUNTY_NAME>
						</cfoutput>
						<cfquery name="get_city_name" datasource="#dsn#">
							SELECT
								SC.CITY_NAME,
								S.SERVICE_ID
							FROM 
								SETUP_CITY SC,
								G_SERVICE S,
								COMPANY 
							WHERE
								COMPANY.COMPANY_ID= S.SERVICE_COMPANY_ID AND 
								SC.CITY_ID = COMPANY.CITY AND
								S.SERVICE_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_id_list#">)
							ORDER BY
								SERVICE_ID
						</cfquery>
						<cfoutput query="get_city_name">
							<cfset "city_name_#SERVICE_ID#"=CITY_NAME>
						</cfoutput>
						<cfquery name="get_tel" datasource="#dsn#">
							SELECT
								COMPANY_TELCODE+' '+COMPANY_TEL1 TEL_NUMBER,
								S.SERVICE_ID
							FROM 
								G_SERVICE S,
								COMPANY 
							WHERE
								COMPANY.COMPANY_ID= S.SERVICE_COMPANY_ID AND 
								S.SERVICE_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#service_id_list#">)
							ORDER BY
								SERVICE_ID
						</cfquery>
						<cfoutput query="get_tel">
							<cfset "tel_no_#SERVICE_ID#"=TEL_NUMBER>
						</cfoutput>
					<cfoutput query="get_service" >
						<tr>
							<td >#rownum#</td>
							<td width="50"><cfif listlen(process_rowid_list) and listfindnocase(process_rowid_list,SERVICE_STATUS_ID)><a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#get_service.service_id#&service_no=#get_service.service_no#"  target="_blank">#service_no#</a></cfif><cfif attributes.fuseaction contains 'autoexcel'>#service_no#</cfif></td>
							<td>#servicecat#</td>
								<td>#project_head#</td>
							<td><cfif listlen(process_rowid_list) and listfindnocase(process_rowid_list,SERVICE_STATUS_ID)>
									<a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#get_service.service_id#&service_no=#get_service.service_no#">#service_head#</a>
								<cfelse>
									#service_head#
								</cfif>
							</td>
								<td>
									<cfif isdefined("ser_cat_#SERVICE_ID#")>
										#evaluate("ser_cat_#SERVICE_ID#")#
									</cfif>
								</td>					<td>
									<cfif isdefined("service_info_#SERVICE_ID#")>
										#evaluate("service_info_#SERVICE_ID#")#
									</cfif>
								</td>
							<td>
								<cfif len(get_service.service_company_id) and (get_service.service_company_id neq 0)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#service_company_id#','medium');">
										#get_company_detail.fullname[listfind(company_id_list,service_company_id,',')]#
									</a>
									<cfif len(get_service.service_partner_id) and (get_service.service_partner_id neq 0) and not len(get_service.applicator_name)>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#service_partner_id#','medium');">
											#get_partner_detail.company_partner_name[listfind(partner_id_list,service_partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(partner_id_list,service_partner_id,',')]#
										</a>
									<cfelseif len(get_service.applicator_name)>
										- #get_service.applicator_name#
									</cfif>
								<cfelseif len(get_service.service_consumer_id) and  (get_service.service_consumer_id neq 0)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#SERVICE_CONSUMER_ID#','medium');">
										#get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,service_consumer_id,',')]# #get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,service_consumer_id,',')]#
									</a>
								<cfelseif len(get_service.service_employee_id) and (get_service.service_employee_id neq 0)>
										#get_record_emp.EMPLOYEE_NAME[listfind(employee_list,service_employee_id,',')]# #get_record_emp.EMPLOYEE_SURNAME[listfind(employee_list,service_employee_id,',')]#
								</cfif>
							</td>
								<td><cfif len(service_branch_id)>#get_branch_name.branch_name[listfind(service_branch_id_list,service_branch_id,',')]#</cfif></td>
								<td>
									#telno#
								</td>
								<td>
									#MOBIL_TEL#
								</td>
							<td><cfif len(COMMETHOD_ID)>#get_commethod_det.COMMETHOD[listfind(commethod_id_list,COMMETHOD_ID,',')]#</cfif></td>
							<td><font color="#color#">#stage#</font></td>
							<td>
								<cfif len(RESP_EMP_ID)>
									#get_emp_info(RESP_EMP_ID,0,0)#
								<cfelseif len(RESP_PAR_ID)>
									#get_par_info(resp_par_id,0,0,0)#
								<cfelseif len(RESP_CONS_ID)>
									#get_cons_info(resp_cons_id,0,0)#
								</cfif>
							</td>
							<td>
								<cfif isdefined("service_gorevli_employees_#SERVICE_ID#")>
									#evaluate("service_gorevli_employees_#SERVICE_ID#")#<br />
								</cfif>
								<cfif isdefined("service_gorevli_partner_#SERVICE_ID#")>
									#evaluate("service_gorevli_partners_#SERVICE_ID#")#<br />
								</cfif>
							</td>
							<cfset detay = replace(service_detail,'"',"'",'all')>
							<td title="#detay#">#left(service_detail,20)#</td> 
								<td>
									<cfif isdefined("city_name_#service_id#")>
										#evaluate("city_name_#service_id#")#
									</cfif>
								</td>
								<td>
									<cfif isdefined("county_name_#service_id#")>
										#evaluate("county_name_#service_id#")#
									</cfif>
								</td>
								<td>
									<cfif len(service_company_id)>
										<cfif isdefined("get_sales_county")>
											#get_sales_county.sz_name[listfind(s_county_list,service_company_id,',')]#
										</cfif>
									<cfelseif len(service_consumer_id)>
										<cfif isdefined("get_sales_county2")>
											#get_sales_county2.sz_name[listfind(s_county2_list,service_consumer_id,',')]#
										</cfif>
									</cfif>
								</td>
							<td>
								<cfif isdefined("tel_no_#service_id#")> <a href="tel://#evaluate("tel_no_#service_id#")#">
									#evaluate("tel_no_#service_id#")# </a>
								</cfif>	
							</td>
							<td><cfif isdefined("sub_no_#subscription_id#")>#left(evaluate("sub_no_#subscription_id#"),20)# - #evaluate("sub_head_#subscription_id#")#</cfif></td>  
							<td>
								<cfif len(record_member)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_member#','medium');">
									#get_record_emp.employee_name[listfind(employee_list,record_member,',')]# #get_record_emp.employee_surname[listfind(employee_list,record_member,',')]#</a>
								<cfelseif len(record_par)>
									#get_par_info(get_record_par.company_id[listfind(record_par_id_list,record_par,',')],1,1,1)# - 
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#record_par#','medium');">
										#get_record_par.company_partner_name[listfind(record_par_id_list,record_par,',')]# #get_record_par.company_partner_surname[listfind(record_par_id_list,record_par,',')]#
									</a>
								<cfelseif len(record_cons)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#record_cons#','medium');">
										#get_record_consumer_detail.consumer_name[listfind(record_consumer_id_list,record_cons,',')]# #get_record_consumer_detail.consumer_surname[listfind(record_consumer_id_list,record_cons,',')]#
									</a>
								</cfif>
							</td>
							<td><cfif len(apply_date)>
									<cfset apply_date_ = dateformat(date_add("H",session.ep.time_zone,apply_date),dateformat_style)>
									#apply_date_#,#timeformat(date_add('h',session.ep.time_zone,APPLY_DATE),timeformat_style)#
								</cfif>
							</td>   
							<!-- sil --><td><cfif listlen(process_rowid_list) and listfindnocase(process_rowid_list,SERVICE_STATUS_ID)><a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#get_service.service_id#" target="_blank"><i class="fa fa-pencil"  alt="Güncelle"></i></a></cfif></td><!-- sil -->
							<td style="text-align:center"><input type="checkbox" name="print_service_id" id="print_service_id"  value="#get_service.service_id#"></td>
						</tr>
					</cfoutput>
				<cfelse>
					<cfset colcount=24>
					<tr>
						<td colspan="<cfoutput>#colcount#</cfoutput>"><cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>

			<cfset adres="call.list_service">
			<cfif isdefined("form_submitted")>
			  <cfset adres = "#adres#&form_submitted=#form_submitted#">
			</cfif>
            <cfif len(attributes.project_head)>
               <cfset adres = "#adres#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
            </cfif>
			<cfif len(attributes.keyword)>
				<cfset adres = adres&"&keyword="&attributes.keyword>
			</cfif>
            <cfif len(attributes.keyword_subject)>
				<cfset adres = adres&"&keyword_subject="&attributes.keyword_subject>
			</cfif>
            <cfif len(attributes.keyword_detail)>
				<cfset adres = adres&"&keyword_detail="&attributes.keyword_detail>
			</cfif>
			<cfif isdefined("attributes.service_cat")>
			  <cfset adres = "#adres#&service_cat=#attributes.service_cat#">
			</cfif>
            <cfif isdefined("attributes.sales_zones") and len(attributes.sales_zones)>
			  <cfset adres="#adres#&sales_zones=#attributes.sales_zones#">
			</cfif>
			<cfif isdefined("attributes.service_cat_id") and len(attributes.service_cat_id)>
			  <cfset adres = "#adres#&service_cat_id=#attributes.service_cat_id#">
			</cfif>
			<cfif isdefined("attributes.service_sub_cat_id")>
			  <cfset adres = "#adres#&service_sub_cat_id=#attributes.service_sub_cat_id#">
			</cfif>
			<cfif isdefined("attributes.service_sub_status_id")>
			  <cfset adres = "#adres#&service_sub_status_id=#attributes.service_sub_status_id#">
			</cfif>
			<cfif isdefined("attributes.appcat_id") and len(attributes.appcat_id)>
				<cfset adres = "#adres#&appcat_id=#attributes.appcat_id#">
			</cfif>			
            <cfif isdefined("attributes.city_id") and len(attributes.city_id) and isdefined("attributes.city") and len(attributes.city)>
				<cfset adres="#adres#&city_id=#attributes.city_id#&city=#attributes.city#">
			</cfif>
            <cfif isdefined("attributes.county_id") and len(attributes.county_id) and isdefined("attributes.county") and len(attributes.county)>
				<cfset adres="#adres#&county_id=#attributes.county_id#&county=#attributes.county#">
			</cfif>
            <cfif isDefined('attributes.category') and len(attributes.category)>
				<cfset adres = adres&"&category="&attributes.category>
			</cfif>
			<cfif isDefined('attributes.vergi_no') and len(attributes.vergi_no)>
				<cfset adres = adres&"&vergi_no="&attributes.vergi_no>
			</cfif>
			<cfif isDefined('attributes.start_date')>
				<cfset adres = adres&"&start_date="&dateformat(attributes.start_date,dateformat_style)>
			</cfif>
			<cfif isDefined('attributes.finish_date')>
				<cfset adres = adres&"&finish_date="&dateformat(attributes.finish_date,dateformat_style)>
			</cfif>
			<cfif isDefined('attributes.start_date1')>
				<cfset adres = adres&"&start_date1="&dateformat(attributes.start_date1,dateformat_style)>
			</cfif>
			<cfif isDefined('attributes.finish_date1')>
				<cfset adres = adres&"&finish_date1="&dateformat(attributes.finish_date1,dateformat_style)>
			</cfif>
			<cfif isDefined('attributes.ComMethod_Id') and len(attributes.ComMethod_Id)>
				<cfset adres = adres&"&ComMethod_Id="&attributes.ComMethod_Id>
			</cfif>
         	<cfif isDefined('attributes.status') and len(attributes.status)>
				<cfset adres = adres&"&status="&attributes.status>
			</cfif>
           	<cfif isDefined('attributes.service_status')>
				<cfset adres = "#adres#&service_status=#attributes.service_status#">
			</cfif>
          	<cfif isDefined('attributes.priority_cat') and len(attributes.priority_cat)>
				<cfset adres ="#adres#&priority_cat=#attributes.priority_cat#">
			</cfif>
          	<cfif isDefined('attributes.service_branch_id') and len(attributes.service_branch_id)>
				<cfset adres ="#adres#&service_branch_id=#attributes.service_branch_id#">
			</cfif>
			<cfif isDefined('attributes.process_stage') and len(attributes.process_stage)>
				<cfset adres = adres&"&process_stage="&attributes.process_stage>
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
				<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
			</cfif>
			<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_no") and len(attributes.subscription_no)>
				<cfset adres = "#adres#&subscription_id=#attributes.subscription_id#&subscription_no=#attributes.subscription_no#">
			</cfif>
			<cfif isdefined("attributes.process_stage_type") and len(attributes.process_stage_type)>
				<cfset adres = adres&"&process_stage_type="&attributes.process_stage_type>
			</cfif>
			<cfif isdefined("attributes.task_person_name") and len(attributes.task_person_name)>
				<cfset adres = "#adres#&task_person_name=#attributes.task_person_name#">
				<cfif isdefined("attributes.task_emp_id") and len(attributes.task_emp_id)>
					<cfset adres = "#adres#&task_emp_id=#attributes.task_emp_id#">
				<cfelseif isdefined("attributes.task_par_id") and len(attributes.task_par_id)>
					<cfset adres = "#adres#&task_par_id=#attributes.task_par_id#">
				</cfif>
			</cfif>
            <cfif len(attributes.resp_emp_name)>
				<cfset adres = "#adres#&resp_emp_name=#attributes.resp_emp_name#">
			</cfif>
            <cfif len(attributes.resp_emp_name) and len(attributes.resp_emp_id)>
				<cfset adres = "#adres#&resp_emp_id=#attributes.resp_emp_id#">
			</cfif>
            <cfif len(attributes.resp_emp_name) and len(attributes.resp_par_id)>
				<cfset adres = "#adres#&resp_par_id=#attributes.resp_par_id#">
			</cfif>
            <cfif len(attributes.resp_emp_name) and len(attributes.resp_cons_id)>
				<cfset adres = "#adres#&resp_emp_id=#attributes.resp_cons_id#">
			</cfif>
			<cfif isDefined("attributes.recorder_name") and len(attributes.recorder_name)>
				<cfset adres = "#adres#&recorder_name=#attributes.recorder_name#">
				<cfif isDefined("attributes.record_emp_id") and len(attributes.record_emp_id)>
					<cfset adres = "#adres#&record_emp_id=#attributes.record_emp_id#">
				<cfelseif isDefined("attributes.record_par_id") and len(attributes.record_par_id)>
					<cfset adres = "#adres#&record_par_id=#attributes.record_par_id#">
				<cfelseif isDefined("attributes.record_cons_id") and len(attributes.record_cons_id)>
					<cfset adres = "#adres#&record_cons_id=#attributes.record_cons_id#">
				</cfif>
			</cfif>
			<cfif isDefined("attributes.made_application") and len(attributes.made_application)>
				<cfset adres = "#adres#&made_application=#attributes.made_application#">
				<cfif isdefined("attributes.employee_id_") and len(attributes.employee_id_)>
					<cfset adres = "#adres#&employee_id_=#attributes.employee_id_#">
				<cfelseif isdefined("attributes.partner_id_") and len(attributes.partner_id_)>
					<cfset adres = "#adres#&partner_id_=#attributes.partner_id_#">
				<cfelseif isdefined("attributes.consumer_id_") and len(attributes.consumer_id_)>
					<cfset adres = "#adres#&consumer_id_=#attributes.consumer_id_#">
				</cfif>
			</cfif>
			<cfif isDefined("attributes.notify_app_name") and len(attributes.notify_app_name)>
				<cfset adres = "#adres#&notify_app_name=#attributes.notify_app_name#">
				<cfif isdefined("attributes.notify_emp_id") and len(attributes.notify_emp_id)>
					<cfset adres = "#adres#&notify_emp_id=#attributes.notify_emp_id#">
				<cfelseif isdefined("attributes.notify_par_id") and len(attributes.notify_par_id)>
					<cfset adres = "#adres#&notify_par_id=#attributes.notify_par_id#">
				<cfelseif isdefined("attributes.notify_con_id") and len(attributes.notify_con_id)>
					<cfset adres = "#adres#&notify_con_id=#attributes.notify_con_id#">
				</cfif>
			</cfif>
			<cfif isDefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
				<cfset adres = "#adres#&workgroup_id=#attributes.workgroup_id#" />
			</cfif>
            <cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#adres#&is_form_submitted=1"> 

		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function c_del(type,type_2)
{
	if(document.getElementById(type).value=='')
	document.getElementById(type_2).value='';
}
function pencere_ac2(no)
{ 
	if (document.getElementById("city_id").value == "")
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58608.İl'>");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=list_service.county_id&field_name=list_service.county&city_id=' + document.getElementById("city_id").value,'list');
	}
}	
function kontrol()
{
	if (document.getElementById("start_date").value.length != 0 && document.getElementById("finish_date").value.length != 0)
	return date_check(document.getElementById("start_date"),document.getElementById("finish_date"),"<cf_get_lang dictionary_id='49242.Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır'>");
	return true;
}
</script>
