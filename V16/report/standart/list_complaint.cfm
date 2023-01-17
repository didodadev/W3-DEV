<cfsetting showdebugoutput="no">
<cfparam name="attributes.module_id_control" default="27">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.Commethod_Id" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_company" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.notify_app_type" default="">
<cfparam name="attributes.appcat_id" default="">
<cfparam name="attributes.servicecat_sub_id" default="">
<cfparam name="attributes.servicecat_sub_tree_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.Commethod_Id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.app_date" default="">
<cfparam name="attributes.resp_emp_id" default="">
<cfparam name="attributes.responsible_person" default="">
<cfparam name="attributes.subject" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.notify_app_name" default="">
<cfparam name="attributes.notify_app_id" default="">
<cfparam name="attributes.notify_company_name" default="">
<cfparam name="attributes.appcat_id" default="">
<cfparam name="attributes.responsible" default="">
<cfparam name="attributes.responsible_id" default="">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.workgroup_id" default="" />
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdate(attributes.app_date)>
	<cf_date tarih="attributes.app_date">
    <cfset attributes.app_date_1=date_add('d',attributes.app_date,1)>
    <cfset attributes.app_date_2=date_add('d',attributes.app_date,-1)>
</cfif>
<cfif  isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
	<cfset attributes.start_date_1=date_add('d',attributes.start_date,1)>
    <cfset attributes.start_date_2=date_add('d',attributes.start_date,-1)>
</cfif>
<cfif  isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
    <cfset attributes.finish_date_1=date_add('d',attributes.finish_date,1)>
    <cfset attributes.finish_date_2=date_add('d',attributes.finish_date,-1)>
</cfif>
<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN#">
	SELECT SERVICECAT,SERVICECAT_ID FROM G_SERVICE_APPCAT ORDER BY SERVICECAT
</cfquery>
<cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#DSN#">
	SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM G_SERVICE_APPCAT_SUB ORDER BY SERVICE_SUB_CAT
</cfquery>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR WITH (NOLOCK),
		PROCESS_TYPE_OUR_COMPANY PTO WITH (NOLOCK),
		PROCESS_TYPE PT WITH (NOLOCK)
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.add_service%">
	ORDER BY 
		PTR.LINE_NUMBER
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
<cfif isdefined('attributes.form_submitted')>
    <cfquery name="get_work" datasource="#dsn#">
        SELECT 
            (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID=PW.PROJECT_EMP_ID) EMPLOYEE_NAME,
             PROJECT_EMP_ID,
             G_SERVICE_ID,
             WORK_NO,
             WORK_ID,
			 EXPECTED_BUDGET,
			 EXPECTED_BUDGET_MONEY,
             (SELECT top 1  WORK_DETAIL  FROM PRO_WORKS_HISTORY WHERE WORK_ID=PW.WORK_ID) WORK_DETAIL_ 
       FROM 
            PRO_WORKS PW
        WHERE
         1=1
		 <cfif len(attributes.responsible_id) and len(attributes.responsible)>
            AND PROJECT_EMP_ID=#attributes.responsible_id#
         </cfif> 
    </cfquery>
	<cfif isDefined('attributes.workgroup_id') And len(attributes.workgroup_id)>
		<cfquery name="get_workgroup" datasource="#dsn#">
			SELECT EMPLOYEE_ID, PARTNER_ID, CONSUMER_ID FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = #attributes.workgroup_id#
		</cfquery>
	</cfif>
    <cfquery name="get_service_detail" datasource="#dsn#">
        SELECT
        	G.SERVICE_ID,
            SERVICE_NO,
            SERVICE_HEAD,
            SERVICE_DETAIL,
            SUBSCRIPTION_ID,
            (SELECT SUBSCRIPTION_NO FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID= G.SUBSCRIPTION_ID)SUBSCRIPTION_NO,
            (SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=G.PROJECT_ID) PROJECT_HEAD,
            (SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID=G.SERVICE_COMPANY_ID)CMP_NAME,
            (SELECT COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID=G.SERVICE_PARTNER_ID)PARTNER_NAME,
            (SELECT CONSUMER_NAME +' '+ CONSUMER_SURNAME FROM CONSUMER WHERE  CONSUMER_ID=G.SERVICE_CONSUMER_ID)CNS_NAME,
            (SELECT PRIORITY FROM SETUP_PRIORITY WHERE PRIORITY_ID=G.PRIORITY_ID) PRIORITY,
            (SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID=G.SERVICE_STATUS_ID)STAGE,
            (SELECT SERVICECAT FROM G_SERVICE_APPCAT WHERE SERVICECAT_ID=G.SERVICECAT_ID)SERVICECAT,
            (SELECT SERVICE_SUB_CAT FROM G_SERVICE_APPCAT_SUB WHERE SERVICE_SUB_CAT_ID=GSA.SERVICE_SUB_CAT_ID)SERVICE_SUB_CAT,
            (SELECT SERVICE_SUB_STATUS FROM G_SERVICE_APPCAT_SUB_STATUS WHERE SERVICE_SUB_STATUS_ID=GSA.SERVICE_SUB_STATUS_ID)SERVICE_SUB_STATUS,
            (SELECT COMMETHOD FROM SETUP_COMMETHOD WHERE COMMETHOD_ID=G.COMMETHOD_ID)COMMETHOD,
            REF_NO,
            (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID=G.RESP_EMP_ID) EMP_NAME,
            APPLY_DATE,
            START_DATE,
            FINISH_DATE,
            SERVICE_PARTNER_ID,
            SERVICE_CONSUMER_ID,
            SUBSCRIPTION_ID,
            PROJECT_ID,
            SERVICE_COMPANY_ID
        FROM
            G_SERVICE G,
            G_SERVICE_APP_ROWS GSA
        WHERE 
            1=1
       		<cfif len(attributes.company_id) and len(attributes.member_company)>AND SERVICE_COMPANY_ID=#attributes.company_id#</cfif>
            <cfif len(attributes.partner_id) and len(attributes.member_name)>AND SERVICE_PARTNER_ID=#attributes.partner_id#</cfif>
            <cfif len(attributes.consumer_id) and len(attributes.member_name)>AND SERVICE_CONSUMER_ID=#attributes.consumer_id#</cfif>
         	<cfif len(attributes.notify_app_type) and attributes.notify_app_type is 'partner' and len(attributes.notify_app_name)>AND NOTIFY_PARTNER_ID=#attributes.notify_app_id#</cfif>
            <cfif len(attributes.notify_app_type) and attributes.notify_app_type is 'consumer' and len(attributes.notify_app_name)>AND NOTIFY_CONSUMER_ID=#attributes.notify_app_id#</cfif>
            <cfif len(attributes.notify_app_type) and attributes.notify_app_type is 'employee' and len(attributes.notify_app_name)>AND NOTIFY_EMPLOYEE_ID=#attributes.notify_app_id#</cfif>
            <cfif len(attributes.appcat_id)>
            	AND G.SERVICECAT_ID=#attributes.appcat_id#
                	<cfif len(attributes.servicecat_sub_id)>
						AND GSA.SERVICE_SUB_CAT_ID=#attributes.servicecat_sub_id#
                        	<cfif len(attributes.servicecat_sub_tree_id)>
								AND GSA.SERVICE_SUB_STATUS_ID=#attributes.servicecat_sub_tree_id#
							</cfif>
					</cfif>
			</cfif>
            <cfif len(attributes.process_stage)>AND SERVICE_STATUS_ID=#attributes.process_stage#</cfif>
            <cfif len(attributes.Commethod_Id)>AND COMMETHOD_ID=#attributes.Commethod_Id#</cfif>
            <cfif len(attributes.project_id) and len(attributes.project_head)>AND G.PROJECT_ID=#attributes.project_id#</cfif>
            <cfif len(attributes.subscription_id) and len(attributes.subscription_no)>AND SUBSCRIPTION_ID=#attributes.subscription_id#</cfif>
            <cfif len(attributes.resp_emp_id) and len(attributes.responsible_person)>AND RESP_EMP_ID=#attributes.resp_emp_id#</cfif>
            <cfif len(attributes.start_date)>AND START_DATE<#attributes.start_date_1# AND START_DATE>#attributes.start_date_2#</cfif>
            <cfif len(attributes.finish_date)>AND FINISH_DATE<#attributes.finish_date_1# AND FINISH_DATE>#attributes.finish_date_2#</cfif>
            <cfif len(attributes.app_date)>AND APPLY_DATE<#attributes.app_date_1# AND APPLY_DATE>#attributes.app_date_2#</cfif>
            <cfif len(attributes.responsible_id) and len(attributes.responsible)>AND <cfif listlen(valuelist(get_work.g_service_id,','))>G.SERVICE_ID IN(#listdeleteduplicates(valuelist(get_work.g_service_id,','))#)<cfelse>G.SERVICE_ID IN(0)</cfif></cfif>
            <cfif len(attributes.is_active)>AND SERVICE_ACTIVE=#attributes.is_active#</cfif>
            <cfif len(attributes.subject)>AND SERVICE_HEAD LIKE '#attributes.subject#%'</cfif>
			<cfif len(attributes.keyword)>AND SERVICE_NO LIKE '%#attributes.keyword#%'</cfif>
			<cfif isDefined('attributes.workgroup_id') And len(attributes.workgroup_id) And get_workgroup.recordCount And (ListLen(valueList(get_workgroup.EMPLOYEE_ID)) OR ListLen(valueList(get_workgroup.PARTNER_ID)) OR valueList(get_workgroup.CONSUMER_ID))>
				<cfif ListLen(valueList(get_workgroup.EMPLOYEE_ID))>AND RESP_EMP_ID IN(#listRemoveDuplicates(valueList(get_workgroup.EMPLOYEE_ID))#)</cfif>
				<cfif ListLen(valueList(get_workgroup.PARTNER_ID))>AND RESP_PAR_ID IN(#listRemoveDuplicates(valueList(get_workgroup.PARTNER_ID))#)</cfif>
				<cfif ListLen(valueList(get_workgroup.CONSUMER_ID))>AND RESP_CONS_ID IN(#listRemoveDuplicates(valueList(get_workgroup.CONSUMER_ID))#)</cfif>
			</cfif>
        AND 
            GSA.SERVICE_ID=G.SERVICE_ID
    </cfquery>
    <cfparam name="attributes.totalrecords" default="#get_service_detail.recordcount#">
</cfif>

<cfsavecontent variable="head"><cf_get_lang dictionary_id='38722.Şikayet Raporu'></cfsavecontent>
<cfform name="cmplaint_report" id="cmplaint_report" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
	<input type="hidden" name="form_submitted" id="form_submitted" value="">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<cfoutput>
				<div class="row">
					<div class="col col-12 col-xs-12">
						<div class="row formContent">
							<div class="row" type="row">
								<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="col col-12 col-md-12 col-xs-12">
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29514.Başvuru Yapan'></label>
												<div class="col col-6 col-md-6">
													<input type="hidden" name="partner_id" id="partner_id" value="#attributes.partner_id#">
													<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
													<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');">
													<cfif len(attributes.consumer_id)>
														<cfquery name="get_cons_detail" datasource="#dsn#">
															SELECT MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
														</cfquery>
													</cfif>
													<input type="text" name="member_company" id="member_company" value="#attributes.member_company#" style="width:120px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\',0,0,0','PARTNER_ID,COMPANY_ID,CONSUMER_ID,MEMBER_NAME2','partner_id,company_id,consumer_id,member_company','','3','250','return_member_code()');" autocomplete="off">
												</div>
												<div class="col col-6 col-md-6">
													<div class="input-group">
														<input type="text" name="member_name" id="member_name" value="#attributes.member_name#" style="width:120px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\',0,0,0','PARTNER_ID,COMPANY_ID,CONSUMER_ID,MEMBER_NAME2','partner_id,company_id,consumer_id,member_company','','3','250','return_member_code()');" autocomplete="off">
														<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_consumer=cmplaint_report.consumer_id&field_partner=cmplaint_report.partner_id&field_comp_id=cmplaint_report.company_id&field_comp_name=cmplaint_report.member_company&field_cons_code=cmplaint_report.member_company&field_name=cmplaint_report.member_name&select_list=7,8&is_form_submitted=1&keyword='+encodeURIComponent(document.getElementById('member_company').value),'list');"></span>
													</div>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38725.Başvuru Bildiren'></label>
												<div class="col col-6 col-md-6">
													<input type="hidden" name="notify_app_type" id="notify_app_type" value="#attributes.notify_app_type#">
													<input type="hidden" name="notify_app_id" id="notify_app_id" value="#attributes.notify_app_id#">
													<input type="text" name="notify_company_name" id="notify_company_name" value="#attributes.notify_company_name#" style="width:120px;">
												</div>
												<div class="col col-6 col-md-6">
													<div class="input-group">
														<input type="text" name="notify_app_name" id="notify_app_name" value="#attributes.notify_app_name#" style="width:120px;" onfocus="AutoComplete_Create('notify_app_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\'','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID','notify_emp_id,notify_par_id,notify_con_id','list_service','3','110');">
														<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_id=cmplaint_report.notify_app_id&field_comp_name=cmplaint_report.notify_company_name&field_name=cmplaint_report.notify_app_name&field_type=cmplaint_report.notify_app_type&field_emp_id=cmplaint_report.notify_app_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3','list');"></span>
													</div>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
												<div class="col col-12 col-md-12 col-xs-12">
													<select name="appcat_id" id="appcat_id" style="width:120px;" onchange="kategori_getir();">
														<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfloop query="get_service_appcat">
															<option value="#servicecat_id#" <cfif attributes.appcat_id eq servicecat_id>selected</cfif>>#servicecat#</option>
														</cfloop>
													</select>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38730.Alt Kategori'></label>
												<div class="col col-12 col-md-12 col-xs-12">
													<cfif len(attributes.appcat_id)>
														<cfquery name="get_service_sub_id" datasource="#dsn#">
															SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM G_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID=#attributes.appcat_id#
														</cfquery>
													</cfif>
													<select name="servicecat_sub_id" id="servicecat_sub_id" style="width:120px;" onchange="sub_kategori_getir();">
														<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfif isdefined("get_service_sub_id")>
															<cfloop query="get_service_sub_id">
																<option value="#service_sub_cat_id#" <cfif service_sub_cat_id eq attributes.servicecat_sub_id>selected</cfif>>#service_sub_cat#</option>
															</cfloop>
														</cfif>
													</select>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38732.Alt Tree Kategori'></label>
												<div class="col col-12 col-md-12 col-xs-12">
													<cfif len(attributes.servicecat_sub_id)>
														<cfquery name="get_service_sub2_id" datasource="#dsn#">
															SELECT SERVICE_SUB_STATUS_ID,SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS FROM G_SERVICE_APPCAT_SUB_STATUS WHERE SERVICE_SUB_CAT_ID=#attributes.servicecat_sub_id#
														</cfquery>
													</cfif>
													<select name="servicecat_sub_tree_id" id="servicecat_sub_tree_id" style="width:120px;">
														<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<cfif isdefined("get_service_sub2_id")>
															<cfloop query="get_service_sub2_id">
																<option value="#SERVICE_SUB_STATUS_ID#" <cfif attributes.servicecat_sub_tree_id eq service_sub_status_id>selected</cfif>>#SERVICE_SUB_STATUS#</option>
															</cfloop>
														</cfif>
													</select> 
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="col col-12 col-md-12 col-xs-12">
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
												<div class="col col-12">
													<select name="process_stage" id="process_stage" style="width:135px;;">
														<option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
														<cfloop query="get_process_stage">
															<option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
														</cfloop>
													</select> 
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58143.İletişim'></label>
												<div class="col col-12">
													<cf_wrkcommethod width="135" commethod_id="#attributes.Commethod_Id#" isdefault="">
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
												<div class="col col-12">
													<div class="input-group">
														<input type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
														<input name="project_head" type="text" id="project_head" value="#attributes.project_head#" style="width:130px;" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','148');" autocomplete="off" />
														<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_service.project_id&project_head=add_service.project_head');"></span>
													</div>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
												<div class="col col-12">
													<div class="input-group">
														<input type="hidden" name="subscription_id" id="subscription_id" value="#attributes.subscription_id#">
														<input type="text" name="subscription_no" id="subscription_no" value="#attributes.subscription_no#" style="width:130px;"  onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
														<cfset str_subscription_link="field_partner=&field_id=cmplaint_report.subscription_id&field_no=cmplaint_report.subscription_no">
														<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_subscription&#str_subscription_link#','list','popup_list_subscription');"></span>
													</div>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
												<div class="col col-12">
													<div class="input-group">
														<input type="hidden" name="resp_emp_id" id="resp_emp_id" value="#attributes.resp_emp_id#">
														<cfinput type="text" name="responsible_person" id="responsible_person" value="#attributes.responsible_person#" style="width:130px;" onFocus="AutoComplete_Create('responsible_person','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','resp_emp_id','','3','160');">
														<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="tree_gonder1();"></span>
													</div>
												</div>
											</div>
											<div class="form-group" id="item-workgroup_id">
												<label><cf_get_lang dictionary_id='58140.İş Grubu'></label>
												<select name="workgroup_id" id="workgroup_id" >				  
													<option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>
													<cfloop query="get_workgroups">
														<option value="#get_workgroups.workgroup_id#"<cfif attributes.workgroup_id eq workgroup_id>selected</cfif>>#get_workgroups.workgroup_name#</option>
													</cfloop>
												</select>                 
											</div>
										</div>
									</div>
								</div>
								<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="col col-12 col-md-12 col-xs-12">
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40660.Başvuru Tarihi'></label>
												<div class="col col-12">
													<div class="input-group">
														<input type="text" name="app_date" id="app_date" value="#dateformat(attributes.app_date,dateformat_style)#" style="width:65px"><span class="input-group-addon"><cf_wrk_date_image date_field="app_date"></span>
													</div>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38749.Kabul Tarihi'></label>
												<div class="col col-12">
													<div class="input-group">
														<input type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px"><span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
													</div>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
												<div class="col col-12">
													<div class="input-group">
														<input type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px"><span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
													</div>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57569.Görevli'></label>
												<div class="col col-12">
													<div class="input-group">
														<input type="hidden" name="responsible_id" id="responsible_id" value="#attributes.responsible_id#">
														<input type="text" name="responsible" id="responsible" value="#attributes.responsible#" style="width:130px">
														<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_name=cmplaint_report.responsible&field_emp_id=cmplaint_report.responsible_id','list');"></span>
													</div>
												</div>
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
												<div class="col col-12">
													<input type="text" name="subject" id="subject" value="#attributes.subject#" style="width:130px">
												</div>
											</div>
										</div>
									</div>
								</div>		 
								<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="col col-12 col-md-12 col-xs-12">
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'> <cfinput type="Text" maxlength="255" style="width:50px;" value="#attributes.keyword#" name="keyword"></label>
												<div class="col col-12">
													<select name="is_active" id="is_active" style="width:65px;">
														<option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
														<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
														<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
													</select>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row ReportContentBorder">
							<div class="ReportContentFooter">
								<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
								<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#"  required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:20px;">
								<cf_wrk_report_search_button button_type='1' is_excel="1" search_function="kontrol()">
								<!---<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>--->
								<!--- <cf_workcube_process is_upd='0' select_value='#attributes.process_stage#' process_cat_width='135' is_detail='0'>--->
							</div>
						</div>
					</div>
				</div>
			</cfoutput>  
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-16">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-16">
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows = get_service_detail.recordcount>
	</cfif>	


    <cf_report_list>
        <thead>
            <tr>
                <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='38753.Başvuru No'></th>
                <th><cf_get_lang dictionary_id='57480.Konu'></th>
                <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                <th><cf_get_lang dictionary_id='58832.Abone'><cf_get_lang dictionary_id="57487.No"></th>
                <th><cf_get_lang dictionary_id='57416.Proje'></th>
                <th><cf_get_lang dictionary_id='29514.Başvuru Yapan'></th>
                <th><cf_get_lang dictionary_id='57485.Öncelik'></th>
                <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                <th><cf_get_lang dictionary_id='38730.Alt Kategori'></th>
                <th><cf_get_lang dictionary_id='38732.Alt Tree Kategori'></th>
                <th><cf_get_lang dictionary_id='58143.İletişim'></th>
                <th><cf_get_lang dictionary_id='58794.Referans No'></th>
                <th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
                <th><cf_get_lang dictionary_id='40660.Başvuru Tarihi'></th>
                <th><cf_get_lang dictionary_id='38749.Kabul Tarihi'></th>
                <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                <th><cf_get_lang dictionary_id='57569.Görevli'></th>
                <th><cf_get_lang dictionary_id='38761.İş No'></th>
                <th><cf_get_lang dictionary_id='40000.Tahmini Bütçe'></th>
                <th><cf_get_lang dictionary_id='57684.Sonuç'></th>
            </tr>
        </thead>
        <tbody>
			<cfif not isdefined("attributes.form_submitted")>
				<tr><td colspan="22"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td></tr>
			<cfelseif get_service_detail.recordcount eq 0>
				<tr><td colspan="22"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td></tr>
			<cfelseif isdefined("attributes.form_submitted") and get_service_detail.recordcount>
				<cfoutput query="get_service_detail" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><cfif attributes.is_excel neq 1><a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#service_id#" class="tableyazi" target="_blank">#service_no#</a><cfelse>#service_no#</cfif></td>
						<td><cfif attributes.is_excel neq 1><a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#service_id#" class="tableyazi" target="_blank">#service_head#</a><cfelse>#service_head#</cfif></td>
						<td>#service_detail#</td>
						<td><cfif attributes.is_excel neq 1><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#subscription_id#" class="tableyazi">#subscription_no#</a><cfelse>#subscription_no#</cfif></td>
						<td><cfif attributes.is_excel neq 1><a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#project_head#</a><cfelse>#project_head#</cfif></td>
						<td>
							<cfif len(service_partner_id)>
							<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#service_company_id#','medium');">#cmp_name#</a> -
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#service_partner_id#')" class="tableyazi">#partner_name#</a> 
							<cfelseif len(service_consumer_id)>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#service_consumer_id#')" class="tableyazi">#cns_name#</a>
							</cfif>
						</td>
						<td>#priority#</td>
						<td>#stage#</td>
						<td>#servicecat#</td>
						<td>#service_sub_cat#</td>
						<td>#service_sub_status#</td>
						<td>#commethod#</td>
						<td>#ref_no#</td>
						<td>#emp_name#</td>
						<td>#dateformat(apply_date,dateformat_style)#</td>
						<td>#dateformat(start_date,dateformat_style)#</td>
						<td>#dateformat(finish_date,dateformat_style)#</td>
							<cfif get_work.recordcount>
								<cfquery name="get_work_name" dbtype="query">
									SELECT * FROM GET_WORK WHERE G_SERVICE_ID=#service_id#
								</cfquery>
							</cfif>
						<td>
							<cfif isdefined('get_work_name.recordcount')>
									<cfloop query="get_work_name">
										#EMPLOYEE_NAME#<br />
									</cfloop>
							</cfif>
						</td>
						<td>
							<cfif isdefined('get_work_name.recordcount')>
									<cfloop query="get_work_name">
										<cfif attributes.is_excel neq 1><a href="#request.self#?fuseaction=project.works&event=det&id=#work_id#" class="tableyazi">#WORK_NO#</a><cfelse>#WORK_NO#</cfif><br />
									</cfloop>
							</cfif>
						</td>
						<td>
							<cfif isdefined('get_work_name.recordcount')>
									<cfloop query="get_work_name">
										<cfif len(EXPECTED_BUDGET)>#EXPECTED_BUDGET# #EXPECTED_BUDGET_MONEY#<cfelse>&nbsp;</cfif><br />
									</cfloop>
							</cfif>
						</td>
						<td>
							<cfif isdefined('get_work_name.recordcount')>
									<cfloop query="get_work_name">
										#WORK_DETAIL_#<br />
									</cfloop>
							</cfif>
					</td>
					</tr>
				</cfoutput>
			</cfif>
        </tbody>
	</cf_report_list>
	<cfif isdefined("attributes.form_submitted")> 
        <cfset url_str = "report.list_complaint">
        <cfif attributes.totalrecords gt attributes.maxrows>
          	<cfif len(attributes.company_id) and len(attributes.member_company)>
                <cfset url_str = "#url_str#&company_id=#attributes.company_id#&member_company=#attributes.member_company#">
            </cfif>
            <cfif len(attributes.partner_id) and len(attributes.member_name)>
                <cfset url_str = "#url_str#&partner_id=#attributes.partner_id#&member_name=#attributes.member_name#">
            </cfif>
           <cfif len(attributes.consumer_id) and len(attributes.member_name)>
                <cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#&member_name=#attributes.member_name#">
            </cfif>
            <cfif len(attributes.notify_app_type) and len(attributes.notify_app_type) and len(attributes.notify_app_name)>
            	<cfset url_str = "#url_str#&notify_app_type=#attributes.notify_app_type#&notify_app_type=#attributes.notify_app_type#">
            </cfif>
            <cfif len(attributes.appcat_id)>
            	<cfset url_str = "#url_str#&appcat_id=#attributes.appcat_id#">
			</cfif>
            <cfif len(attributes.servicecat_sub_id)>
            	<cfset url_str = "#url_str#&servicecat_sub_id=#attributes.servicecat_sub_id#">
			</cfif>
            <cfif len(attributes.servicecat_sub_tree_id)>
            	<cfset url_str = "#url_str#&servicecat_sub_tree_id=#attributes.servicecat_sub_tree_id#">
			</cfif>
            <cfif len(attributes.process_stage)>
            	<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
            </cfif>
            <cfif len(attributes.Commethod_Id)>
				<cfset url_str = "#url_str#&Commethod_Id=#attributes.Commethod_Id#">
			</cfif>
            <cfif len(attributes.project_id) and len(attributes.project_head)>
            	<cfset url_str = "#url_str#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
            </cfif>
            <cfif len(attributes.subscription_id) and len(attributes.subscription_no)>
            	<cfset url_str = "#url_str#&subscription_id=#attributes.subscription_id#&subscription_no=#attributes.subscription_no#">
            </cfif>
            <cfif len(attributes.resp_emp_id) and len(attributes.responsible_person)>
            	<cfset url_str = "#url_str#&resp_emp_id=#attributes.resp_emp_id#&responsible_person=#attributes.responsible_person#">
            </cfif>
            <cfif len(attributes.start_date)>
            	<cfset url_str = "#url_str#&start_date=#attributes.start_date#">
            </cfif>
            <cfif len(attributes.finish_date)>
            	<cfset url_str = "#url_str#&finish_date=#attributes.finish_date#">
            </cfif>
            <cfif len(attributes.app_date)>
            	<cfset url_str = "#url_str#&app_date=#attributes.app_date#">
            </cfif>
            <cfif len(attributes.responsible_id) and len(attributes.responsible)>
            	<cfset url_str = "#url_str#&responsible_id=#attributes.responsible_id#&responsible=#attributes.responsible#">
            </cfif>
            <cfif len(attributes.is_active)>
            	<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
			</cfif>
            <cfif len(attributes.subject)>
				<cfset url_str = "#url_str#&subject=#attributes.subject#">
			</cfif>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.is_excel)>
				<cfset url_str = "#url_str#&is_excel=#attributes.is_excel#">
			</cfif>
			<cfif isDefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
				<cfset url_str = "#url_str#&workgroup_id=#attributes.workgroup_id#" />
			</cfif>
			<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#url_str#&form_submitted=1">
     </cfif>
   </cfif>
<script type="text/javascript">
	function kontrol()
	{
		if(document.cmplaint_report.is_excel.checked==false)
		{
			document.cmplaint_report.action="<cfoutput>#request.self#?fuseaction=report.list_complaint</cfoutput>";
			return true;
		}
		else
			document.cmplaint_report.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_list_complaint</cfoutput>";
	}
	//kategori secimine gore alt kategorileri getirir
	function kategori_getir()
	{
		category_value = document.getElementById('appcat_id').value;
		document.getElementById('servicecat_sub_tree_id').value='';
		if(category_value != '')
		{
			var get_sub_category = wrk_safe_query('clcr_get_sub_category','dsn',0,category_value);
			var option_count = document.getElementById('servicecat_sub_id').options.length; 
			for(x=option_count;x>=0;x--)
			{
				document.getElementById('servicecat_sub_id').options[x] = null;
				document.getElementById('servicecat_sub_id').options[0] = new Option('Seçiniz','');
			}
			for(sc=0;sc<get_sub_category.recordcount;sc++)
			{
				document.getElementById('servicecat_sub_id').options[sc+1]=new Option(get_sub_category.SERVICE_SUB_CAT[sc],get_sub_category.SERVICE_SUB_CAT_ID[sc]);
			}
		}
		
		//sub_kategori_getir();
	}
	function sub_kategori_getir()
	{
		if(document.getElementById('servicecat_sub_id').value!='')
		{
			var get_sub_tree_category = wrk_safe_query('clcr_get_sub_tree_category','dsn',0,document.getElementById('servicecat_sub_id').value);
			var option_count_sub = document.getElementById('servicecat_sub_tree_id').options.length; 
			for(y=option_count_sub;y>=0;y--)
			{
				document.getElementById('servicecat_sub_tree_id').options[y] = null;
				document.getElementById('servicecat_sub_tree_id').options[0] = new Option('Seçiniz','');
			}
			for(stc=0;stc<get_sub_tree_category.recordcount;stc++)
			{
				document.getElementById('servicecat_sub_tree_id').options[stc+1]=new Option(get_sub_tree_category.SERVICE_SUB_STATUS[stc],get_sub_tree_category.SERVICE_SUB_STATUS_ID[stc]);
			}
		}
	}
	function tree_gonder1()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=cmplaint_report.responsible_person&field_emp_id=cmplaint_report.resp_emp_id&select_list=1</cfoutput>&keyword='+encodeURIComponent(document.getElementById('responsible_person').value),'list');
	}
</script>