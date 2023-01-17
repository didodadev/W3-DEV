<cfif not isDefined('session.ep.userid')>
	<cfexit method="exittemplate">
</cfif>
<!--- <cfflush interval="1000">  excel alınırken ColdFusion was unable to add the header hatası sebebiyle kapatıldı. --->
<cfset session_base = evaluate('session.ep')>
<cf_xml_page_edit fuseact='objects.popup_list_extre,objects.popup_list_comp_extre'>
<cfscript>
	accountingType = createObject("component","V16.settings.cfc.accountingType");
    getAccount = accountingType.getAccountType();
</cfscript>
<cfparam name="attributes.maxrows" default="#session_base.maxrows#">
<cfparam name="attributes.is_duedate_group" default="1">
<cfparam name="attributes.invoice_color" default="0">
<cfparam name="attributes.is_date_filter" default="">
<cfparam name="attributes.special_code_toplu" default="">
<cfparam name="attributes.due_date_2" default="">
<cfparam name="attributes.due_date_1" default="">
<cfparam name="attributes.action_date_1" default="">
<cfparam name="attributes.action_date_2" default="">
<cfparam name="attributes.other_money_2" default="">
<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.acc_type" default="">
<cfparam name="attributes.other_money" default="">
<cfparam name="attributes.list_type" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.process_catid" default="">
<cfparam name="attributes.special_definition_id" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.modal_id" default="">
<cfif len(attributes.subscription_id) and len(attributes.subscription_no)>
	<cfset attributes.subscription_no = get_subscription_no(attributes.subscription_id)>
<cfelse>
	<cfset attributes.subscription_no = "">
	<cfset attributes.subscription_id = "">
</cfif>
<cfif not isdefined("attributes.popup_page")>
	<cfparam name="attributes.is_page" default="1">
</cfif>
<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
	<cfif isdefined("attributes.form_type") and len(attributes.form_type) and attributes.form_type neq -1>
        <cfquery name="GET_FORM" datasource="#DSN3#">
            SELECT
                TEMPLATE_FILE,
                FORM_ID
            FROM
                SETUP_PRINT_FILES
            WHERE
                FORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.form_type#">
        </cfquery>
        <cfif get_form.recordcount>
            <cfinclude template="#file_web_path#settings/#get_form.template_file#">
        <cfelse>
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id='57808.Yazıcı Belgeleri Tanımlı Değil'>");
                wrk_opener_reload();
                window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_comp_extre";
            </script>
            <cfabort>
        </cfif>
    <cfelse>
		<cfif isdefined("attributes.is_page") and attributes.is_page eq 1>
            <cfset action = "">
            <cfset action1 = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_list_extre">
        <cfelse>
            <cfset action = "">
            <cfset action1 = "#request.self#?fuseaction=objects.emptypopup_list_extre">
        </cfif>        	
    </cfif>
<cfelse>
	<cfquery name="GET_DET_FORM" datasource="#DSN#">
		SELECT 
			SPF.TEMPLATE_FILE,
			SPF.FORM_ID,
			SPF.NAME,
			SPF.PROCESS_TYPE,
			SPF.MODULE_ID,
			SPF.IS_DEFAULT,		
			SPFC.PRINT_NAME
		FROM 
			#dsn3_alias#.SETUP_PRINT_FILES SPF,
			SETUP_PRINT_FILES_CATS SPFC,
			MODULES MOD
		WHERE
			MOD.MODULE_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="objects"> AND
			SPF.MODULE_ID = MOD.MODULE_ID AND
			SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND
			SPF.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="190">
		ORDER BY
			SPF.NAME		
	</cfquery>	
	<cfif isdefined("attributes.is_page")>
		<cfset action = "">
		<cfset action1 = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_list_extre">
	<cfelseif not isdefined("attributes.other")>
		<cfset action = "">
		<cfset action1 = "#request.self#?fuseaction=objects.emptypopup_list_extre">
	<cfelse>
		<cfset action = "#request.self#?fuseaction=objects.popup_list_comp_extre&other=1">
		<cfset action1 = "#request.self#?fuseaction=objects.emptypopup_list_extre&other=1">
	</cfif>
	<!-----<cfset date1="#dateformat(session.ep.period_start_date,dateformat_style)#">
	<cfset date2="#dateformat(session.ep.period_finish_date,dateformat_style)#">------><!----Date1 ve date 2 attributesten gelmiyordu. Kaldırıldı Sorun oluşturması halinde tekrar açılabilir. ERU---->
</cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.get_comp_name")>
	<cfset attributes.comp_name = get_par_info(attributes.company_id,1,0,0)>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.get_comp_name")>
	<cfset attributes.comp_name = get_cons_info(attributes.consumer_id,0,0)>
</cfif>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT DISTINCT
		MONEY,
		RATE2,
		RATE1 
	FROM 
		SETUP_MONEY 
	WHERE 
		MONEY_STATUS = 1
		AND PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY CONSCAT
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT 
    	BRANCH_ID,BRANCH_NAME 
    FROM 
    	BRANCH 
    WHERE 
    	BRANCH_STATUS = 1 
		AND COMPANY_ID = #session.ep.company_id#
		<cfif is_show_store_acts eq 0 and session.ep.isBranchAuthorization>
			AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
    ORDER BY 
    	BRANCH_NAME
</cfquery>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN#">
    SELECT
        SMC.MAIN_PROCESS_CAT_ID,
		#dsn#.Get_Dynamic_Language(SMC.MAIN_PROCESS_CAT_ID,'#session.ep.language#','SETUP_MAIN_PROCESS_CAT','MAIN_PROCESS_CAT',NULL,NULL,SMC.MAIN_PROCESS_CAT) AS MAIN_PROCESS_CAT
    FROM 
        SETUP_MAIN_PROCESS_CAT SMC,
        SETUP_MAIN_PROCESS_CAT_ROWS SMR,
        EMPLOYEE_POSITIONS
    WHERE
        SMC.MAIN_PROCESS_CAT_ID = SMR.MAIN_PROCESS_CAT_ID AND
        EMPLOYEE_POSITIONS.POSITION_CODE =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND 
        (EMPLOYEE_POSITIONS.POSITION_CAT_ID = SMR.MAIN_POSITION_CAT_ID OR EMPLOYEE_POSITIONS.POSITION_CODE = SMR.MAIN_POSITION_CODE)
    ORDER BY
    	SMC.MAIN_PROCESS_CAT
</cfquery>
<cfif isdefined("attributes.due_date_2") and isdate(attributes.due_date_2)>
	<cf_date tarih = "attributes.due_date_2">
</cfif>
<cfif isdefined("attributes.due_date_1") and isdate(attributes.due_date_1)>
	<cf_date tarih = "attributes.due_date_1">
</cfif>
<cfif isdefined("attributes.action_date_1") and isdate(attributes.action_date_1)>
	<cf_date tarih = "attributes.action_date_1">
</cfif>
<cfif isdefined("attributes.action_date_2") and isdate(attributes.action_date_2)>
	<cf_date tarih = "attributes.action_date_2">
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih = "attributes.date1">
<cfelse>
    <cfset date1 = dateformat(session.ep.period_start_date,dateformat_style)>
	<cfparam name="attributes.date1" default="#date1#">
	<cf_date tarih = "attributes.date1">
</cfif>
<cfif isdefined('attributes.date2') and isdate(attributes.date2)>
	<cf_date tarih = "attributes.date2">
<cfelse>
    <cfset date2 = dateformat(session.ep.period_finish_date,dateformat_style)>
	<cfparam name="attributes.date2" default="#date2#">
	<cf_date tarih = "attributes.date2">
</cfif>
<cfif session.ep.isBranchAuthorization>
	<cfset module = 32>
<cfelse>
	<cfset module = xml_module>
</cfif>
<!--- print icin ekstra parametreler degiskene atiliyor --->
<cfscript>
	extra_params = '';
	
	if(isdefined("attributes.company_id") and len(attributes.company_id) and ((isdefined("attributes.comp_name") and len(attributes.comp_name)) or (isdefined("attributes.comp_name") and len(attributes.comp_name))))
		extra_params = listAppend(extra_params,attributes.company_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');

	if(isdefined("attributes.consumer_id") and len(attributes.consumer_id) and ((isdefined("attributes.comp_name") and len(attributes.comp_name)) or (isdefined("attributes.comp_name") and len(attributes.comp_name))))
		extra_params = listAppend(extra_params,attributes.consumer_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');

	if(isdefined("attributes.employee_id") and len(attributes.employee_id) and ((isdefined("attributes.comp_name") and len(attributes.comp_name)) or (isdefined("attributes.comp_name") and len(attributes.comp_name))))
		extra_params = listAppend(extra_params,attributes.employee_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');

	if(isdefined("attributes.member_type") and len(attributes.member_type) and ((isdefined("attributes.comp_name") and len(attributes.comp_name)) or (isdefined("attributes.comp_name") and len(attributes.comp_name))))
		extra_params = listAppend(extra_params,attributes.member_type,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.action_type") and len(attributes.action_type))
		extra_params = listAppend(extra_params,attributes.action_type,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.branch_id") and len(attributes.branch_id))
		extra_params = listAppend(extra_params,attributes.branch_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');

	if(isdefined("attributes.process_catid") and len(attributes.process_catid))
		extra_params = listAppend(extra_params,attributes.process_catid,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head))
		extra_params = listAppend(extra_params,attributes.project_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.company_id2") and len(attributes.company_id2) and ((isdefined("attributes.company2") and len(attributes.company2)) or (isdefined("attributes.company2") and len(attributes.company2))))
		extra_params = listAppend(extra_params,attributes.company_id2,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.consumer_id2") and len(attributes.consumer_id2) and ((isdefined("attributes.company2") and len(attributes.company2)) or (isdefined("attributes.company2") and len(attributes.company2))))
		extra_params = listAppend(extra_params,attributes.consumer_id2,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.employee_id2") and len(attributes.employee_id2) and ((isdefined("attributes.company2") and len(attributes.company2)) or (isdefined("attributes.company2") and len(attributes.company2))))
		extra_params = listAppend(extra_params,attributes.employee_id2,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.member_type2") and len(attributes.member_type2) and ((isdefined("attributes.company2") and len(attributes.company2)) or (isdefined("attributes.company2") and len(attributes.company2))))
		extra_params = listAppend(extra_params,attributes.member_type2,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.pos_code") and len(attributes.pos_code) and isdefined("attributes.pos_code_text") and len(attributes.pos_code_text))
		extra_params = listAppend(extra_params,attributes.pos_code,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.member_cat_type") and len(attributes.member_cat_type))
		extra_params = listAppend(extra_params,attributes.member_cat_type,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
		
	if(isdefined("attributes.asset_id") and len(attributes.asset_id) and isdefined("attributes.asset_name") and len(attributes.asset_name))
		extra_params = listAppend(extra_params,attributes.asset_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');

	if(isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_no") and len(attributes.subscription_no))
		extra_params = listAppend(extra_params,attributes.subscription_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');
	
	if(isdefined("attributes.buy_status") and len(attributes.buy_status))
		extra_params = listAppend(extra_params,attributes.buy_status,'£');
	else
		extra_params = listAppend(extra_params,'null','£');

	if(isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and ((isdefined("attributes.comp_name") and len(attributes.comp_name)) or (isdefined("attributes.comp_name") and len(attributes.comp_name))))
		extra_params = listAppend(extra_params,attributes.acc_type_id,'£');
	else
		extra_params = listAppend(extra_params,'null','£');	
</cfscript>
<cfif isDefined('session.pp.userid')>
	<cfset invoice_partner_link = "objects.popup_detail_invoice&period_id=#get_periods.period_id#">
</cfif>
<cfif not isDefined("attributes.draggable")><cf_catalystHeader></cfif>
<cfset yilbasi = createodbcdatetime('#session_base.period_year#-01-01')>

<style>
	.fatura_detay{
		background-color:#e6e6e6bf!important;
	}
</style>
<cf_box title="#getLang('','Cari Extre',47101)#" scroll="1" collapsable="1" resize="1" uidrop="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfif not isdefined("is_ajax")><!--- Rapordan çağrılan ajax değilse ---> 
		<cfif isdefined('attributes.comp_name') and len(attributes.comp_name)>
			<cfset attributes.company = attributes.comp_name>
		</cfif>
		<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and isdefined("attributes.employee_id") and len(attributes.employee_id)>
			<cfquery name="get_all_ch_type" datasource="#dsn#">
				SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = #attributes.acc_type_id#
			</cfquery>
			<cfset attributes.company = "#attributes.company# - #get_all_ch_type.acc_type_name#">
			<cfset attributes.employee_id_ = "#attributes.employee_id#_#attributes.acc_type_id#">
		<cfelseif  isdefined("attributes.employee_id") and len(attributes.employee_id) and findnocase('_',attributes.employee_id) and findnocase('-',attributes.company) eq 0>
			<cfquery name="get_all_ch_type" datasource="#dsn#">
				SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = #listlast(attributes.employee_id,'_')#
			</cfquery>
			<cfset attributes.company = "#attributes.company# - #get_all_ch_type.acc_type_name#">
		<cfelseif isdefined("attributes.employee_id")>
			<cfset attributes.employee_id_ = attributes.employee_id>
		</cfif>
		<cfif (isdefined("attributes.form_submit") and isdefined("attributes.is_collacted") and attributes.is_collacted eq 1)>
			<cfset dsp_info = "">
			<cfset dsp_info2 = "display:none;">
		<cfelse>
			<cfset dsp_info = "display:none;">
			<cfset dsp_info2 = "">
		</cfif>
		<cfform name="list_ekstre" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
			<div class="ui-form-list ui-form-block row" type="row">
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<input type="hidden" value="1" name="form_submit" id="form_submit">
					<input type="hidden" value="1" name="date_control" id="date_control">
				
					<input type="hidden" value="<cfif (isdefined("attributes.is_collacted") and attributes.is_collacted eq 1) or isdefined("collacted_extre")>1<cfelse>0</cfif>" name="is_collacted" id="is_collacted">
					<input type="hidden" name="is_page" id="is_page" value="<cfif isdefined("attributes.is_page") and attributes.is_page eq 1>1<cfelse>0</cfif>">		
					<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_store_module")>
						<input type="hidden" value="1" name="is_store_module" id="is_store_module">
					</cfif>
					
					<div class="form-group" id="item-company">
						<label><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
						<cfif isdefined('attributes.member_id') and len(attributes.member_id) and isdefined("attributes.member_type") and len(attributes.member_type)>
							<cfset attributes.company = ''>
							<cfif attributes.member_type is 'partner'>
								<cfset attributes.company_id = attributes.member_id>
								<cfset attributes.company = get_par_info(attributes.company_id,1,0,0)>
							<cfelseif attributes.member_type is 'consumer'>
								<cfset attributes.consumer_id = attributes.member_id>
								<cfset attributes.company = get_cons_info(attributes.consumer_id,0,0)>
							<cfelseif attributes.member_type is 'employee'>
								<cfset attributes.employee_id = attributes.member_id>
								<cfset attributes.company = get_emp_info(attributes.employee_id,0,0)>
							</cfif>
						</cfif>
						<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'partner'><cfoutput>#attributes.company_id#</cfoutput></cfif>">
						<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'consumer'><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
						<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'employee'><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
						<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
						<div class="input-group">
							<cfif isdefined("attributes.company") and len(attributes.company)>
								<input type="text" name="comp_name" id="comp_name" value="<cfoutput>#attributes.company#</cfoutput>" onFocus="AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'1\',\'1\',\'0\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','','3','225');">
							<cfelse>
								<input name="comp_name" type="text" id="comp_name" onFocus="AutoComplete_Create('comp_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'1\',\'1\',\'0\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','','3','225');" value="" autocomplete="off">
							</cfif>
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="hesap_sec(1); openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&is_company_info=1&field_name=list_ekstre.comp_name&field_type=list_ekstre.member_type&field_comp_name=list_ekstre.comp_name&field_consumer=list_ekstre.consumer_id&field_emp_id=list_ekstre.employee_id&field_comp_id=list_ekstre.company_id<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_store_module")>&is_store_module=1</cfif>&select_list=2,3<cfif get_module_power_user(48)>,1,9</cfif></cfoutput>');"></span>
						</div>
					</div>
					
					<div class="form-group" id="item-project_id">
						<label><cf_get_lang dictionary_id='57416.Proje'></label>
						<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
						<div class="input-group">
							<input name="project_head_" type="text" id="project_head_" onfocus="AutoComplete_Create('project_head_','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','217');" value="<cfif isdefined('attributes.project_head_') and  len(attributes.project_head_)><cfoutput>#attributes.project_head_#</cfoutput></cfif>" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=list_ekstre.project_id&project_head=list_ekstre.project_head_&is_empty_project');"></span>
						</div>
					</div>
					<div class="form-group" id="item-action_type">
						<label style="display:none;"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
						<cfif isdefined("attributes.is_collacted") and attributes.is_collacted eq 1>
							<cfset height_info = 130>
						<cfelse>
							<cfset height_info = 105>
						</cfif>
						<cf_wrk_chprocesstypes fieldid='action_type' is_multiple='1' selected_value='#attributes.action_type#' select_process_cat='#is_select_process_cat#'>
					</div>
					
					<cfif isdefined("attributes.form_submit")>
						<input type="hidden" name="due_date_2" id="due_date_2" value="">
						<input type="hidden" name="is_date_filter" id="is_date_filter" value="">
						<input type="hidden" name="is_duedate_group" id="is_duedate_group" value="<cfoutput>#attributes.is_duedate_group#</cfoutput>">
						<input type="hidden" name="due_date_1" id="due_date_1" value="">
						<input type="hidden" name="other_money_2" id="other_money_2" value="">
						<input type="hidden" name="action_date_1" id="action_date_1" value="">
						<input type="hidden" name="action_date_2" id="action_date_2" value="">
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-special_definition_id">
						<label ><cf_get_lang dictionary_id='59291.Tahsilat/Ödeme Tipi'></label>
						<cf_wrk_special_definition list_filter_info="1" field_id="special_definition_id" selected_value='#attributes.special_definition_id#'>
					</div>
					<div class="form-group" id="item-subscription_id">
						<label><cf_get_lang dictionary_id ='29502.Abone No'></label>
						<cf_wrk_subscriptions fieldId='subscription_id' fieldName='subscription_no' form_name='list_ekstre' subscription_id='#attributes.subscription_id#' subscription_no='#attributes.subscription_no#'>
					</div>
					<div class="form-group" id="item-branch_id">
						<label style="display:none;"><cf_get_lang dictionary_id='57453.Şube'></label>
						<select name="branch_id" id="branch_id" multiple="multiple">
							<optgroup label="<cf_get_lang dictionary_id='57453.Şube'>">
							<cfoutput query="GET_BRANCH">
								<option value="#BRANCH_ID#" title="#GET_BRANCH.branch_name#" <cfif listfind(attributes.branch_id,BRANCH_ID)>selected</cfif>>#BRANCH_NAME#</option>
							</cfoutput>
							</optgroup>
						</select>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-acc_type">
						<label><cf_get_lang dictionary_id='48681.Hesap Tipi'></label>                     
						<select name="acc_type" id="acc_type">
							<option value=""><cf_get_lang dictionary_id='48681.Hesap Tipi'></option>
							<cfoutput query="getAccount">
								<option value="#ACCOUNT_TYPE_ID#" <cfif attributes.acc_type eq ACCOUNT_TYPE_ID>selected</cfif>>#ACCOUNT_TYPE#</option>
							</cfoutput>
						</select>
					</div>
					<cfif session.ep.our_company_info.asset_followup eq 1>
						<div class="form-group" id="item-asset_id">
							<label><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
							<cf_wrkassetp fieldid='asset_id' asset_id="#attributes.asset_id#" fieldname='asset_name' form_name='list_ekstre' button_type='plus_thin'>
						</div>
					</cfif>
					<div class="form-group" id="item-process_catid">
						<label style="display:none;"><cf_get_lang dictionary_id='59293.Proje Kategorileri'></label>
						<select name="process_catid" id="process_catid" multiple="multiple" >
							<optgroup label="<cf_get_lang dictionary_id='59293.Proje Kategorileri'>">
							<cfoutput query="get_process_cat"> 
								<option value="#main_process_cat_id#" <cfif listfind(attributes.process_catid,main_process_cat_id)>selected</cfif>>#main_process_cat#</option>
							</cfoutput> 
							</optgroup>
						</select>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-date1">
						<label><cf_get_lang dictionary_id='57742.Tarih'></label>
						<div class="col col-6 col-xs-6 pl-0">
							<div class="input-group">
								<cfinput type="text" name="date1" value="#date1#" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
							</div>
						</div>
						<div class="col col-6 col-xs-6 pr-0">
							<div class="input-group">
								<cfinput type="text" name="date2" value="#date2#" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
							</div>
						</div>
					</div>
					<cfif not isdefined("attributes.form_submit")>
						<div class="form-group" id="item-form_type">
							<label><cf_get_lang dictionary_id='57791.Şablon Türü'>*</label>
							<select name="form_type" id="form_type" onChange="islem_goster();">
								<option value=""><cf_get_lang dictionary_id='57792.Modül İçi Yazıcı Belgeleri'></option>
								<option value="-1" selected><cf_get_lang dictionary_id='57793.Detaylı Hesap Ekstresi'></option>
								<cfoutput query="GET_DET_FORM">
									<option value="#form_id#" <cfif is_default eq 1>selected</cfif>>#name#</option>
								</cfoutput>
							</select>
						</div>
					</cfif>
					
					<div class="form-group" id="item-list_type">
						<label  style="display:none;"><cf_get_lang dictionary_id='57912.Liste Seçenekleri'></label>
						<cfif not isdefined("attributes.form_submit") and listlen(attributes.list_type) eq 0>
							<cfset attributes.list_type = xml_list_options_selected>
						</cfif>
						<select name="list_type" id="list_type" multiple="multiple" height='#height_info#'>
							<optgroup label="<cf_get_lang dictionary_id='57912.Liste Seçenekleri'>">
							<option value="1" <cfif listfind(attributes.list_type,1)>selected</cfif>> <cf_get_lang dictionary_id='57795.İşlem Dövizli'></option>
							<option value="2" <cfif listfind(attributes.list_type,2)>selected</cfif>> 2.<cf_get_lang dictionary_id='57796.Dövizli'></option>
							<option value="3" <cfif listfind(attributes.list_type,3)>selected</cfif>> 2.<cf_get_lang dictionary_id='57797.Döviz Bakiyeli'></option>
							<option value="4" <cfif listfind(attributes.list_type,4)>selected</cfif>> <cf_get_lang dictionary_id='57798.Vadeli'></option>
							<option value="6" <cfif listfind(attributes.list_type,6)>selected</cfif>> <cf_get_lang dictionary_id='57799.Renkli'></option>
							<option value="7" <cfif listfind(attributes.list_type,7)>selected</cfif>> <cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
							<option value="8" <cfif listfind(attributes.list_type,8)>selected</cfif>> <cf_get_lang dictionary_id='57629.Açıklama'></option>
							<cfif session.ep.our_company_info.project_followup eq 1>
								<option value="5" <cfif listfind(attributes.list_type,5)>selected</cfif>> <cf_get_lang dictionary_id='57416.Proje'></option>
							</cfif>
							<option value="9" <cfif listfind(attributes.list_type,9)>selected</cfif>><cf_get_lang dictionary_id ='58085.Finansal Özet'></option>
							<option value="10" <cfif listfind(attributes.list_type,10)>selected</cfif>> <cf_get_lang dictionary_id='58042.Fatura Detaylı'></option>
							</optgroup>
						</select>
					</div>
					<div class="form-group" id="member_code" style="display:none;">
						<label><cf_get_lang dictionary_id='57789.Özel Kod'></label>
						<input type="text" name="special_code" id="special_code" maxlength="75" value="">
					</div>
					<cfif isdefined("attributes.form_submit")>
						<div class="form-group" id="item-other_money">
							<label><cf_get_lang dictionary_id='57489.Para Birimi'></label>
							<select name="other_money" id="other_money">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_money">
									<option value="#money#" <cfif attributes.other_money eq money>selected</cfif>>#money#</option>
								</cfoutput>
							</select>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
					<div class="form-group">
						<label><input type="checkbox" name="is_pay_cheques" id="is_pay_cheques" <cfif isdefined('attributes.is_pay_cheques')>checked</cfif>><cf_get_lang dictionary_id='57913.Ödenmemiş Çek/Senetleri Getirme'></label>
					</div>
					<cfif isdefined("attributes.form_submit")>
						<div class="form-group">
							<label><input type="checkbox" name="is_subscription_group" id="is_subscription_group" <cfif isdefined('attributes.is_subscription_group')>checked</cfif>><cf_get_lang dictionary_id="30401.Aboneye Göre Grupla"></label>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
					<div class="form-group">
						<label><input type="checkbox" name="is_pay_bankorders" id="is_pay_bankorders" <cfif isdefined('attributes.is_pay_bankorders')>checked</cfif>><cf_get_lang dictionary_id='58819.Ödenmemiş Talimatları Getirme'></label>
					</div>
					<cfif isdefined("attributes.form_submit")>
						<div class="form-group">
							<label><input type="checkbox" name="is_acc_type_group" id="is_acc_type_group" <cfif isdefined('attributes.is_acc_type_group')>checked</cfif>><cf_get_lang dictionary_id='60084.Hesap Tipine Göre Grupla'></label>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="7" sort="true">
					<div class="form-group" id="is_make_age_tr" style="<cfoutput>#dsp_info2#</cfoutput>">
						<label><input type="checkbox" name="is_make_age" id="is_make_age" onclick="kontrol_perf(1);" <cfif isdefined('attributes.is_make_age')>checked</cfif>><cf_get_lang dictionary_id='57802.Ödeme Performansı'></label>
					</div>
					<cfif session.ep.our_company_info.is_paper_closer eq 1>
						<div class="form-group">
							<label><cf_get_lang dictionary_id='58500.Manuel'><input type="checkbox" name="is_make_age_manuel" id="is_make_age_manuel"  onclick="kontrol_perf(2);" <cfif isdefined('attributes.is_make_age_manuel')>checked</cfif>><cf_get_lang dictionary_id='57802.Ödeme Performansı'></label>
						</div>
					</cfif>
					<cfif isdefined("attributes.form_submit")>
						<div class="form-group">
							<label><input type="checkbox" name="is_project_group" id="is_project_group" <cfif isdefined('attributes.is_project_group')>checked</cfif>><cf_get_lang dictionary_id='58931.Proje Bazında Grupla'></label>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="8" sort="true">
					<div class="form-group" id="is_cheque_duedate"<cfif not isdefined('attributes.is_make_age')>style="display:none;"</cfif>>
						<label><input type="checkbox" name="is_cheque_duedate" id="is_cheque_duedate" <cfif isdefined('attributes.is_cheque_duedate')>checked</cfif>><cf_get_lang dictionary_id ='58168.Çek ve Senetleri Tahsil Tarihine Göre Hesapla'></label>
					</div>
				</div>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<cfif isdefined("attributes.is_page") and session.ep.isBranchAuthorization eq 0 and  not isdefined("attributes.is_store_module")>
						<div class="form-group" id="item-collacted_extre">
							<label><input type="checkbox" name="collacted_extre" id="collacted_extre" onClick="gizle_goster(toplu_extre);degistir();" <cfif isdefined('attributes.collacted_extre')>checked</cfif>><cf_get_lang dictionary_id='57788.Toplu Extre'></label>
						</div>
					</cfif>
				</div>
			</div>
			<div id="toplu_extre" style="<cfif not isdefined('attributes.collacted_extre')> display:none;</cfif>">
				<cfsavecontent  variable="head_"><cf_get_lang dictionary_id='57788.Toplu Extre'></cfsavecontent>
				<cfif isdefined("attributes.is_page") and session.ep.isBranchAuthorization eq 0 and  not isdefined("attributes.is_store_module")>
					<cf_seperator title="#head_#" id="collacted_extre_part">
					<cf_box_elements vertical="1" id="collacted_extre_part">
						<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="member_cat_display" >
							<label><cf_get_lang dictionary_id ='58609.Üye Kategorisi'></label>
							<select name="member_cat_type" id="member_cat_type">
								<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<option value="1" disabled style="font-weight:bold;"><cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'></option>
								<cfoutput query="get_company_cat">
								<option value="1-#COMPANYCAT_ID#" <cfif attributes.member_cat_type is '1-#COMPANYCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option>
								</cfoutput>
								<option value="2" disabled style="font-weight:bold;"><cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'></option>
								<cfoutput query="get_consumer_cat">
								<option value="2-#CONSCAT_ID#" <cfif attributes.member_cat_type is '2-#CONSCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
								</cfoutput>
							</select>
						</div>
						<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="item_pos_code" >
							<label><cf_get_lang dictionary_id ='58795.Müşteri Temsilcisi'></label>
							<input type="hidden" name="pos_code" id="pos_code" value="<cfif isdefined("attributes.pos_code_text") and len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
							<div class="input-group">
								<input type="text" name="pos_code_text" id="pos_code_text" value="<cfif isdefined("attributes.pos_code_text") and len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('pos_code_text','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','130');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="hesap_sec(3); openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=list_ekstre.pos_code&field_name=list_ekstre.pos_code_text&select_list=1')"></span>
							</div>
						</div>
						<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12"  id="item_buy_status" >
							<label><cf_get_lang dictionary_id='58733.Alıcı'>/<cf_get_lang dictionary_id='58873.Satici'></label>
							<select name="buy_status" id="buy_status">
								<option value=""><cf_get_lang dictionary_id='58733.Alıcı'>/<cf_get_lang dictionary_id='58873.Satici'></option>
								<option value="1" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 1>selected</cfif>><cf_get_lang dictionary_id='58733.Alıcı'></option>
								<option value="2" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 2>selected</cfif>><cf_get_lang dictionary_id='58873.Satici'></option>
								<option value="3" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 3>selected</cfif>><cf_get_lang dictionary_id ='57577.Potansiyel'></option>
							</select>
						</div>
						<cfif (isdefined("attributes.form_submit") and isdefined("attributes.is_collacted") and attributes.is_collacted eq 1) or (not isdefined("attributes.form_submit") and isdefined("attributes.is_page") and session.ep.isBranchAuthorization eq 0 and not isdefined("attributes.is_store_module"))>
							<cfif isdefined('attributes.is_make_age') or not isdefined("attributes.form_submit")>
								<cfset dsp_inf = 'display:none;'>
							<cfelse>
								<cfset dsp_inf = ''>
							</cfif>
							<cfif isdefined('attributes.company2') and len(attributes.company2)>
								<cfset attributes.company2= attributes.company2>
							</cfif>
							<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="last_account">
								<label><cf_get_lang dictionary_id='57807.Cari Bitiş Hesap'></label>
								<input type="hidden" name="company_id2" id="company_id2" value="<cfif isdefined("attributes.company_id2") and len(attributes.company_id2) and isdefined("attributes.member_type") and len(attributes.member_type2) and attributes.member_type2 is 'partner'><cfoutput>#attributes.company_id2#</cfoutput></cfif>">
								<input type="hidden" name="consumer_id2" id="consumer_id2" value="<cfif isdefined("attributes.consumer_id2") and len(attributes.consumer_id2) and isdefined("attributes.member_type") and len(attributes.member_type2) and attributes.member_type2 is 'consumer'><cfoutput>#attributes.consumer_id2#</cfoutput></cfif>">
								<input type="hidden" name="employee_id2" id="employee_id2" value="<cfif isdefined("attributes.employee_id2") and len(attributes.employee_id2) and isdefined("attributes.member_type") and len(attributes.member_type2) and attributes.member_type2 is 'employee'><cfoutput>#attributes.employee_id2#</cfoutput></cfif>">
								<input type="hidden" name="member_type2" id="member_type2" value="<cfif isdefined("attributes.member_type2") and len(attributes.member_type2)><cfoutput>#attributes.member_type2#</cfoutput></cfif>">
								<div class="input-group">
									<input name="company2" type="text" id="company2" onfocus="AutoComplete_Create('company2','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'1\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id2,consumer_id2,employee_id2,member_type2','','3','225');" value="<cfif  isdefined("attributes.company2") and len(attributes.company2)><cfoutput>#attributes.company2#</cfoutput></cfif>" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="hesap_sec(2); openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&is_company_info=1&field_name=list_ekstre.company2&field_type=list_ekstre.member_type2&field_comp_name=list_ekstre.company2&field_consumer=list_ekstre.consumer_id2&field_emp_id=list_ekstre.employee_id2&field_comp_id=list_ekstre.company_id2<cfif session.ep.isBranchAuthorization or isdefined("attributes.is_store_module")>&is_store_module=1</cfif>&select_list=2,3<cfif get_module_power_user(48)>,1</cfif></cfoutput>');"></span>
								</div>
							</div>                
						</cfif>
						<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12"  id="item_special_code" >
							<label><cf_get_lang dictionary_id='57789.Özel Kod'></label>
							<input type="text" id="special_code_toplu" name="special_code_toplu" value="<cfif isdefined('attributes.special_code_toplu') and len(attributes.special_code_toplu)><cfoutput>#attributes.special_code_toplu#</cfoutput></cfif>">
						</div>
						<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="show_rel_mem">
							<label><input type="checkbox" name="is_rel_mem" id="is_rel_mem" <cfif isdefined('attributes.is_rel_mem')>checked</cfif>><cf_get_lang dictionary_id ='58014.İlişkili Üyeleri Getir'></label>
						</div>
						<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12"  id="show_bakiye" >
							<label><input type="checkbox" name="is_bakiye" id="is_bakiye" <cfif isdefined('attributes.is_bakiye')>checked</cfif>><cf_get_lang dictionary_id ='58634.Hareket Görenleri Getir'></label>
						</div>
						<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="sifir_bakiye" >
							<label>	<input type="checkbox" name="is_sifir_bakiye" id="is_sifir_bakiye" <cfif isdefined('attributes.is_sifir_bakiye')>checked</cfif>><cf_get_lang dictionary_id ="50146.Sıfır Bakiye Getirme"></label>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<!--- <div class="col col-6 pl-0">
								<div class="form-group" id="show_excel">
									<label><input type="checkbox" name="is_excel" id="is_excel" onClick="show_cari_();degistir_action();" <cfif isdefined('attributes.is_excel')>checked</cfif>><cf_get_lang dictionary_id ='58631.Excel e Aktar'></label>
								</div>
							</div> --->
							<div class="form-group" id="show_pdf">
								<label><input type="checkbox" name="is_pdf" id="is_pdf" onClick="show_cari_();" <cfif isdefined('attributes.is_pdf')>checked</cfif>> <cf_get_lang dictionary_id ='58630.PDF e Aktar'></label>
							</div>
						</div>
						<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="show_pdf2" style="display:none;">
							<label><input type="checkbox" name="is_cari_page" id="is_cari_page" <cfif isdefined('attributes.is_cari_page')>checked</cfif>><cf_get_lang dictionary_id ='58632.Cari Bazında Sayfalama'></label>
						</div>
						<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="show_pdf3" style="display:none;">
							<label ><input type="checkbox" name="is_pos_group" id="is_pos_group" <cfif isdefined('attributes.is_pos_group')>checked</cfif>><cf_get_lang dictionary_id ='58633.Müşteri Temsilcisi Bazında Grupla'></label>
						</div>
					</cf_box_elements>
				</cfif>
			</div>
			<div class="ui-form-list-btn">
				<div class="ui-form-list flex-list">
					<div class="form-group">
						<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" value="1" name="is_excel" id="is_excel" onclick="show_cari_();degistir_action();" <cfif isdefined('attributes.is_excel')>checked</cfif>></label>
					</div>
					<div class="form-group small">
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
					</div>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57650.Dök'></cfsavecontent>
					<cfset float_inf="right">
					<div class="form-group">
						<cf_wrk_search_button button_type='2' button_name='#message#' search_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('list_ekstre' , #attributes.modal_id#)"),DE("kontrol()"))#">
					</div>
					<!---<cf_workcube_buttons is_upd='0' insert_alert='' insert_info='#message#' add_function='kontrol()' excel_input="is_excel" form_name="list_ekstre">--->
				</div>
			</div>
		</cfform>
	</cfif>
	<cfset min_name = ''>
	<cfset max_name = ''>
	<cfif isdefined("attributes.employee_id")>
		<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
			<cfquery name="get_all_ch_type" datasource="#dsn#">
				SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = #attributes.acc_type_id#
			</cfquery>
			<cfif not findnocase('-',attributes.company)>
				<cfset attributes.company = "#attributes.company# - #get_all_ch_type.acc_type_name#">
			</cfif>
			<cfset attributes.employee_id = "#attributes.employee_id#_#attributes.acc_type_id#">
		<cfelse>
			<cfset attributes.employee_id = attributes.employee_id>
		</cfif>    
		<cfscript>
			attributes.acc_type_id = '';
			if(listlen(attributes.employee_id,'_') eq 2)
			{
				attributes.acc_type_id = listlast(attributes.employee_id,'_');
				attributes.employee_id = listfirst(attributes.employee_id,'_');
			}
		</cfscript>
	</cfif>
	<cfif isdefined("attributes.is_collacted") and attributes.is_collacted eq 1>
		<cfif isdefined("attributes.comp_name") and len(attributes.comp_name)>
			<cfif listlen(attributes.company,'-') eq 2>
				<cfset max_name = listfirst(attributes.company,'-')>
			<cfelse>	
				<cfset max_name = attributes.company>
			</cfif>
			<cfif isdefined("attributes.company2") and len(attributes.company2)>
				<cfif listlen(attributes.company2,'-') eq 2>
					<cfset min_name = listfirst(attributes.company2,'-')>
				<cfelse>	
					<cfset min_name = attributes.company2>
				</cfif>
				<cfif max_name lt min_name and len(min_name)>
					<cfif listlen(attributes.company2,'-') eq 2>
						<cfset max_name = listfirst(attributes.company2,'-')>
					<cfelse>	
						<cfset max_name = attributes.company2>
					</cfif>
					<cfif listlen(attributes.company,'-') eq 2>
						<cfset min_name = listfirst(attributes.company,'-')>
					<cfelse>	
						<cfset min_name = attributes.company>
					</cfif>
				</cfif>
			</cfif>
			<cfif len(attributes.COMPANY_ID) and len(attributes.comp_name) and attributes.member_type eq 'partner'>
				<cfquery name="GET_CMP_IDS" datasource="#dsn#">
					SELECT 
						COMPANY_ID,
						'' CONSUMER_ID,
						'' EMPLOYEE_ID,
						FULLNAME,
						MEMBER_CODE MEMBER_CODE,
						COMPANY_ADDRESS ADDRESS,
						SEMT SEMT,
						COUNTY,
						CITY,
						COUNTRY,
						'('+COMPANY_TELCODE+')'+' '+COMPANY_TEL1 TELEFON
					FROM 
						COMPANY
					WHERE
						<cfif len(max_name) and LEN(min_name)>
							FULLNAME >= '#min_name#' AND 
							FULLNAME <= '#max_name#'
						<cfelseif LEN(max_name)>
							FULLNAME >= '#max_name#' 
						</cfif>
						AND COMPANY_STATUS = 1
						<cfif isdefined("attributes.special_code_toplu") and len(attributes.special_code_toplu)>
							AND OZEL_KOD LIKE '%#attributes.special_code_toplu#%'
						</cfif>
						<cfif listfind(attributes.list_type,1)>
							<cfif isdefined("attributes.is_sifir_bakiye")>
								AND 
								(
									COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
									OR COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
								)
							</cfif>
						<cfelse>
							<cfif isdefined("attributes.is_sifir_bakiye")>AND COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
						</cfif>
						<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
							AND WORK_CITY_ID = #attributes.city_id# 
						</cfif>	
						<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
							AND IS_BUYER = 1
						</cfif>
						<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
							AND IS_SELLER = 1
						</cfif>
						<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
							AND ISPOTANTIAL = 1
						</cfif>
						<!--- <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
							AND 1 = 2
						</cfif> --->
						AND COMPANY.COMPANYCAT_ID IN (SELECT COMPANYCAT_ID FROM COMPANY_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID = #session.ep.company_id#)
					ORDER BY
						FULLNAME
				</cfquery>
				<!--- İlişkili üyelerin bilgileri çekiliyor --->
				<cfif isdefined('is_rel_mem')>
					<cfquery name="get_related_companies" datasource="#dsn#">
						SELECT 
							CPR.COMPANY_ID AS REL_COMP_ID,
							C.COMPANY_ID,
							'' CONSUMER_ID,
							'' EMPLOYEE_ID,
							FULLNAME,
							MEMBER_CODE MEMBER_CODE,
							COMPANY_ADDRESS ADDRESS,
							SEMT SEMT,
							SCT.COUNTY_NAME,
							SC.CITY_NAME,
							SCN.COUNTRY_NAME,
							'('+COMPANY_TELCODE+')'+' '+COMPANY_TEL1 TELEFON
						FROM 
							COMPANY_PARTNER_RELATION CPR
								LEFT JOIN COMPANY C ON C.COMPANY_ID = CPR.PARTNER_COMPANY_ID
								LEFT JOIN SETUP_COUNTRY SCN ON SCN.COUNTRY_ID = C.COUNTRY
								LEFT JOIN SETUP_CITY SC ON SC.CITY_ID = C.CITY
								LEFT JOIN SETUP_COUNTY SCT ON SCT.COUNTY_ID = C.COUNTY
						WHERE
							--COMPANY_STATUS = 1 AND
							CPR.COMPANY_ID IN (#valueList(get_cmp_ids.company_id)#)
					</cfquery> 
				</cfif> 
			<cfelseif len(attributes.consumer_id) and len(attributes.comp_name) and attributes.member_type eq 'consumer'> 
				<cfquery name="GET_CMP_IDS" datasource="#dsn#">
				SELECT 
					'' COMPANY_ID,
					CONSUMER_ID,
					'' EMPLOYEE_ID,
					CONSUMER_NAME + ' ' +CONSUMER_SURNAME FULLNAME,
					MEMBER_CODE MEMBER_CODE,
					WORKADDRESS ADDRESS,
					WORKSEMT SEMT,
					WORK_COUNTY_ID COUNTY,
					WORK_CITY_ID AS CITY,
					WORK_COUNTRY_ID COUNTRY,
					'('+CONSUMER_HOMETELCODE+')'+' '+CONSUMER_HOMETEL TELEFON
				FROM 
					CONSUMER
				WHERE
					<cfif len(max_name) and LEN(min_name)>
						CONSUMER_NAME + ' ' +CONSUMER_SURNAME >= '#min_name#' AND 
						CONSUMER_NAME + ' ' +CONSUMER_SURNAME <= '#max_name#'
					<cfelseif LEN(max_name)>
						CONSUMER_NAME + ' ' +CONSUMER_SURNAME >= '#max_name#' 
					</cfif>
					AND CONSUMER_STATUS = 1
					<cfif listfind(attributes.list_type,1)>
						<cfif isdefined("attributes.is_sifir_bakiye")>
							AND 
							(
								CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
								OR CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
							)
						</cfif>
					<cfelse>
						<cfif isdefined("attributes.is_sifir_bakiye")>AND CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.CONSUMER_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
					</cfif>
					<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
						AND WORK_CITY_ID = #attributes.city_id#
					</cfif>
					<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
						AND ISPOTANTIAL = 1
					</cfif>
					<!--- <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
						AND 1 = 2
					</cfif> --->
					AND CONSUMER.CONSUMER_CAT_ID IN (SELECT CONSUMER_CAT_ID FROM CONSUMER_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID = #session.ep.company_id#)
				ORDER BY
					FULLNAME
				</cfquery> 
			<cfelseif len(attributes.employee_id) and len(attributes.comp_name) and attributes.member_type eq 'employee'>
				<cfquery name="GET_CMP_IDS" datasource="#dsn#">
					SELECT 
						'' COMPANY_ID,
						'' CONSUMER_ID,
						EMPLOYEE_ID,
						EMPLOYEE_NAME + ' ' +EMPLOYEE_SURNAME FULLNAME,
						'' MEMBER_CODE,
						'' ADDRESS,
						'' SEMT,
						'' COUNTY,
						'' AS CITY,
						'' COUNTRY,
						'' TELEFON
					FROM 
						EMPLOYEES
					WHERE
						<cfif len(max_name) and LEN(min_name)>
							EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME >= '#min_name#' AND 
							EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME <= '#max_name#'
						<cfelseif LEN(max_name)>
							EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME >= '#max_name#' 
						</cfif>
						<cfif listfind(attributes.list_type,1)>
							<cfif isdefined("attributes.is_sifir_bakiye")>
								AND 
								(
									EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
									OR EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
								)
							</cfif>
						<cfelse>
							<cfif isdefined("attributes.is_sifir_bakiye")>AND EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.EMPLOYEE_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
						</cfif>
						<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
							AND EMPLOYEE_ID IN
							(
								SELECT 		
									EMPLOYEE_POSITIONS.EMPLOYEE_ID
								FROM							
									EMPLOYEE_POSITIONS,
									DEPARTMENT
								WHERE		
									EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
									AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID								
									AND DEPARTMENT.BRANCH_ID IN (#attributes.branch_id#) 
							)
						</cfif>
						AND EMPLOYEE_STATUS = 1
					ORDER BY
						FULLNAME
			</cfquery> 
			<cfelseif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
				<cfquery name="GET_CMP_IDS" datasource="#dsn#">
					SELECT 
						'' COMPANY_ID,
						'' CONSUMER_ID,
						'' EMPLOYEE_ID,
						ASSETP_ID,
						ASSETP ASSET_NAME,
						'' FULLNAME,
						'' MEMBER_CODE,
						'' ADDRESS,
						'' SEMT,
						'' COUNTY,
						'' AS CITY,
						'' COUNTRY,
						'' TELEFON				
					FROM 
						ASSETP
					WHERE
						ASSETP_ID = #attributes.asset_id#
					ORDER BY
						FULLNAME
			</cfquery> 
			</cfif> 
		<cfelseif isdefined("attributes.special_code_toplu") and len(attributes.special_code_toplu)>
			<cfquery name="GET_CMP_IDS" datasource="#dsn#">
				SELECT 
					COMPANY_ID,
					'' CONSUMER_ID,
					'' EMPLOYEE_ID,
					FULLNAME,
					MEMBER_CODE,
					COMPANY_ADDRESS ADDRESS,
					SEMT SEMT,
					COUNTY,
					CITY,
					COUNTRY,
					'('+COMPANY_TELCODE+')'+' '+COMPANY_TEL1 TELEFON
				FROM 
					COMPANY 
				WHERE
					COMPANY_STATUS = 1
					<cfif isdefined("attributes.member_cat_type") and len(attributes.member_cat_type)>
						AND COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = #listlast(attributes.member_cat_type,'-')#)
					</cfif>
					<cfif isdefined("attributes.special_code_toplu") and len(attributes.special_code_toplu)>
						AND OZEL_KOD LIKE '%#attributes.special_code_toplu#%'
					</cfif>
					<cfif listfind(attributes.list_type,1)>
						<cfif isdefined("attributes.is_sifir_bakiye")>
							AND 
							(
								COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
								OR COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
							)
						</cfif>
					<cfelse>
						<cfif isdefined("attributes.is_sifir_bakiye")>AND COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
					</cfif>
					<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
						AND CITY = #attributes.city_id# 
					</cfif>
					<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
						AND IS_BUYER = 1
					</cfif>
					<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
						AND IS_SELLER = 1
					</cfif>
					<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
						AND ISPOTANTIAL = 1
					</cfif>
				ORDER BY
					FULLNAME
			</cfquery> 	
		<cfelseif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') eq '1'>
			<cfquery name="GET_CMP_IDS" datasource="#dsn#">
				SELECT 
					COMPANY_ID,
					'' CONSUMER_ID,
					'' EMPLOYEE_ID,
					FULLNAME,
					MEMBER_CODE,
					COMPANY_ADDRESS ADDRESS,
					SEMT SEMT,
					COUNTY,
					CITY,
					COUNTRY,
					'('+COMPANY_TELCODE+')'+' '+COMPANY_TEL1 TELEFON
				FROM 
					COMPANY 
				WHERE
					COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = #listlast(attributes.member_cat_type,'-')#)
					AND COMPANY_STATUS = 1
					<cfif isdefined("attributes.special_code_toplu") and len(attributes.special_code_toplu)>
						AND OZEL_KOD LIKE '%#attributes.special_code_toplu#%'
					</cfif>
					<cfif listfind(attributes.list_type,1)>
						<cfif isdefined("attributes.is_sifir_bakiye")>
							AND 
							(
								COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
								OR COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
							)
						</cfif>
					<cfelse>
						<cfif isdefined("attributes.is_sifir_bakiye")>AND COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
					</cfif>
					<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
						AND CITY = #attributes.city_id# 
					</cfif>
					<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
						AND IS_BUYER = 1
					</cfif>
					<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
						AND IS_SELLER = 1
					</cfif>
					<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
						AND ISPOTANTIAL = 1
					</cfif>
				ORDER BY
					FULLNAME
			</cfquery> 	
		<cfelseif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') eq '2'>
			<cfquery name="GET_CMP_IDS" datasource="#dsn#">
				SELECT 
					'' COMPANY_ID,					
					CONSUMER_ID,
					'' EMPLOYEE_ID,
					CONSUMER_NAME + ' ' +CONSUMER_SURNAME FULLNAME,
					MEMBER_CODE MEMBER_CODE,
					WORKADDRESS ADDRESS,
					WORKSEMT SEMT,
					WORK_COUNTY_ID COUNTY,
					WORK_CITY_ID AS CITY,
					WORK_COUNTRY_ID COUNTRY,
					'('+CONSUMER_HOMETELCODE+')'+' '+CONSUMER_HOMETEL TELEFON
				FROM 
					CONSUMER
				WHERE
					CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = #listlast(attributes.member_cat_type,'-')# )
					AND CONSUMER_STATUS = 1
					<cfif listfind(attributes.list_type,1)>
						<cfif isdefined("attributes.is_sifir_bakiye")>
							AND 
							(
								CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
								OR CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
							)
						</cfif>
					<cfelse>
						<cfif isdefined("attributes.is_sifir_bakiye")>AND CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.CONSUMER_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
					</cfif>
					<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
						AND WORK_CITY_ID = #attributes.city_id# 
					</cfif>
					<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 3>
						AND ISPOTANTIAL = 1
					</cfif>
				ORDER BY
					FULLNAME
			</cfquery> 
		<cfelseif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>	
			<cfquery name="GET_CMP_IDS" datasource="#dsn#">
				SELECT
					C.COMPANY_ID,
					'' CONSUMER_ID,
					'' EMPLOYEE_ID,
					C.MEMBER_CODE,
					C.FULLNAME,
					C.COMPANY_ADDRESS ADDRESS,
					C.SEMT SEMT,
					C.COUNTY,
					C.CITY,
					C.COUNTRY,
					'('+C.COMPANY_TELCODE+')'+' '+C.COMPANY_TEL1 TELEFON
				FROM
					WORKGROUP_EMP_PAR WP,
					COMPANY C
				WHERE
					WP.COMPANY_ID = C.COMPANY_ID AND
					WP.COMPANY_ID IS NOT NULL AND
					WP.OUR_COMPANY_ID = #session.ep.company_id# AND
					WP.POSITION_CODE = #attributes.pos_code# AND 
					WP.IS_MASTER = 1
					<cfif listfind(attributes.list_type,1)>
						<cfif isdefined("attributes.is_sifir_bakiye")>
							AND 
							(
								C.COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = C.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
								OR C.COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = C.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
							)
						</cfif>
					<cfelse>
						<cfif isdefined("attributes.is_sifir_bakiye")>AND C.COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = C.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
						<cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
					</cfif>
					<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
						AND CITY = #attributes.city_id# 
					</cfif>
					<cfif isdefined("attributes.special_code_toplu") and len(attributes.special_code_toplu)>
						AND OZEL_KOD LIKE '%#attributes.special_code_toplu#%' 
					</cfif>				
			</cfquery> 	
		<cfelseif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			<cfquery name="GET_CMP_IDS" datasource="#dsn#">
				SELECT 
					'' COMPANY_ID,
					'' CONSUMER_ID,
					EMPLOYEE_ID,
					EMPLOYEE_NAME + ' ' +EMPLOYEE_SURNAME FULLNAME,
					'' MEMBER_CODE,
					'' ADDRESS,
					'' SEMT,
					'' COUNTY,
					'' AS CITY,
					'' COUNTRY,
					'' TELEFON
				FROM 
					EMPLOYEES
				WHERE
					1 = 1
					<cfif len(max_name) and LEN(min_name)>
						AND EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME >= '#min_name#' AND 
						AND EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME <= '#max_name#'
					<cfelseif LEN(max_name)>
						AND EMPLOYEE_NAME+ ' ' +EMPLOYEE_SURNAME >= '#max_name#' 
					</cfif>
					<cfif listfind(attributes.list_type,1)>
						<cfif isdefined("attributes.is_sifir_bakiye")>
							AND 
							(
								EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
								OR EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
							)
						</cfif>
					<cfelse>
						<cfif isdefined("attributes.is_sifir_bakiye")>AND EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.EMPLOYEE_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
					</cfif>
					<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
						AND EMPLOYEE_ID IN
						(
							SELECT 		
								EMPLOYEE_POSITIONS.EMPLOYEE_ID
							FROM							
								EMPLOYEE_POSITIONS,
								DEPARTMENT
							WHERE		
								EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
								AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID								
								AND DEPARTMENT.BRANCH_ID IN (#attributes.branch_id#)
						)
					</cfif>
					AND EMPLOYEE_STATUS = 1
				ORDER BY
					FULLNAME
			</cfquery> 
		</cfif>
	<cfelseif isdefined("attributes.member_type") and isdefined("attributes.comp_name") and len(attributes.comp_name) and attributes.member_type is 'partner'>
		<cfquery name="GET_CMP_IDS" datasource="#DSN#">
			SELECT 
				COMPANY_ID,
				'' CONSUMER_ID,
				'' EMPLOYEE_ID,
				FULLNAME,
				MEMBER_CODE,
				COMPANY_ADDRESS ADDRESS,
				SEMT SEMT,
				COUNTY,
				CITY,
				COUNTRY,
				'('+COMPANY_TELCODE+')'+' '+COMPANY_TEL1 TELEFON
			FROM 
				COMPANY 
			WHERE
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				<cfif listfind(attributes.list_type,1)>
					<cfif isdefined("attributes.is_sifir_bakiye")>
						AND 
						(
							COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
							OR COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
						)
					</cfif>
				<cfelse>
					<cfif isdefined("attributes.is_sifir_bakiye")>AND COMPANY_ID IN(SELECT CR.COMPANY_ID FROM #dsn2_alias#.CARI_ROWS_TOPLAM CR WHERE CR.COMPANY_ID = COMPANY.COMPANY_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
				</cfif>
		</cfquery>
	<cfelseif isdefined("attributes.member_type") and isdefined("attributes.comp_name") and len(attributes.comp_name) and attributes.member_type is 'consumer'>
		<cfquery name="GET_CMP_IDS" datasource="#dsn#">
			SELECT 
				'' COMPANY_ID,
				CONSUMER_ID,
				'' EMPLOYEE_ID,
				CONSUMER_NAME + ' ' +CONSUMER_SURNAME FULLNAME,
				MEMBER_CODE MEMBER_CODE,
				WORKADDRESS ADDRESS,
				WORKSEMT SEMT,
				WORK_COUNTY_ID COUNTY,
				WORK_CITY_ID AS CITY,
				WORK_COUNTRY_ID COUNTRY,
				'('+CONSUMER_HOMETELCODE+')'+' '+CONSUMER_HOMETEL TELEFON
			FROM 
				CONSUMER 
			WHERE
				CONSUMER_ID = #attributes.consumer_id#
				<cfif listfind(attributes.list_type,1)>
					<cfif isdefined("attributes.is_sifir_bakiye")>
						AND 
						(
							CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
							OR CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
						)
					</cfif>
				<cfelse>
					<cfif isdefined("attributes.is_sifir_bakiye")>AND CONSUMER_ID IN(SELECT CR.CONSUMER_ID FROM #dsn2_alias#.CARI_ROWS_CONSUMER CR WHERE CR.CONSUMER_ID = CONSUMER.CONSUMER_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.CONSUMER_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
				</cfif>
	</cfquery> 
	<cfelseif isdefined("attributes.member_type") and isdefined("attributes.comp_name") and len(attributes.comp_name) and attributes.member_type is 'employee'>
		<cfquery name="GET_CMP_IDS" datasource="#dsn#">
			SELECT 
				'' COMPANY_ID,
				'' CONSUMER_ID,
				EMPLOYEE_ID,
				EMPLOYEE_NAME + ' ' +EMPLOYEE_SURNAME FULLNAME,
				'' MEMBER_CODE,
				'' ADDRESS,
				'' SEMT,
				'' COUNTY,
				'' CITY,
				'' COUNTRY,
				'' TELEFON
			FROM 
				EMPLOYEES 
			WHERE
				EMPLOYEE_ID = #attributes.employee_id#
				<cfif listfind(attributes.list_type,1)>
					<cfif isdefined("attributes.is_sifir_bakiye")>
						AND 
						(
							EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)
							OR EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.COMPANY_ID HAVING ROUND(SUM(BORC3-ALACAK3),2) <> 0)
						)
					</cfif>
				<cfelse>
					<cfif isdefined("attributes.is_sifir_bakiye")>AND EMPLOYEE_ID IN(SELECT CR.EMPLOYEE_ID FROM #dsn2_alias#.CARI_ROWS_EMPLOYEE CR WHERE CR.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"><cfif isdefined("attributes.date2") and isdate(attributes.date2)>AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"></cfif> GROUP BY CR.EMPLOYEE_ID HAVING ROUND(SUM(BORC-ALACAK),2) <> 0)</cfif>
				</cfif>
	</cfquery>   
	<cfelseif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
		<cfquery name="GET_CMP_IDS" datasource="#dsn#">
			SELECT 
				'' COMPANY_ID,
				'' CONSUMER_ID,
				'' EMPLOYEE_ID,
				ASSETP_ID,
				ASSETP ASSET_NAME,
				'' FULLNAME,
				'' MEMBER_CODE,
				'' ADDRESS,
				'' SEMT,
				'' COUNTY,
				'' AS CITY,
				'' COUNTRY,
				'' TELEFON
			FROM 
				ASSET_P
			WHERE
				ASSETP_ID = #attributes.asset_id#
			ORDER BY
				FULLNAME
	</cfquery> 
	</cfif>
	<!--- PY ?? get_cmp_ids  --->
	<cfif isdefined('attributes.is_excel')>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-16">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="Content-Type" content="text/html;charset=utf-16">
	</cfif>
	<div id="list_extre_content">
		<cfif (isdefined('attributes.is_make_age') or isdefined('attributes.is_make_age_manuel')) and not (isdefined("attributes.is_collacted") and attributes.is_collacted eq 1)><!--- ödeme performansını getirir,bu gelirse diğer extre görüntüsü gelmeyecek --->
			<cfif listfind(attributes.list_type,9) and not (isdefined("attributes.is_collacted") and attributes.is_collacted eq 1) and not (isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name))>
				<cfinclude template="dsp_extre_summary.cfm">
			</cfif>
			<cfif listfind(attributes.list_type,1)>
				<cfset attributes.is_doviz_group = 1>
			</cfif>
			<cfif isdefined('attributes.is_make_age')>
				<cfinclude template="dsp_make_age.cfm">
			<cfelseif isdefined('attributes.is_make_age_manuel')>
				<cfinclude template="dsp_make_age_manuel.cfm">
			</cfif>
		<cfelse>
			<cfif isdefined('attributes.form_submit')>	
				<cfquery name="GET_PERIODS" datasource="#DSN#">
					SELECT
						PERIOD_ID, 
						IS_INTEGRATED,
						IS_LOCKED,
						OTHER_MONEY,
						OUR_COMPANY_ID,
						PERIOD,
						PERIOD_DATE,
						PERIOD_ID,
						PERIOD_YEAR,
						PROCESS_DATE,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						STANDART_PROCESS_MONEY,
						UPDATE_DATE,
						UPDATE_IP,
						UPDATE_EMP 
					FROM 
						SETUP_PERIOD 
					WHERE 
						OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
						<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
							AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.date1#">
						</cfif>
						<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
							AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.date2#">
						</cfif>
					ORDER BY 
						OUR_COMPANY_ID,
						PERIOD_YEAR 
				</cfquery>
				<cfif GET_PERIODS.recordcount gt 1>
					<cfoutput query="GET_PERIODS">
						<cfif currentrow eq 1>
							<cfset 'start_#PERIOD_YEAR#' = dateFormat(attributes.date1,dateformat_style)>
						<cfelse>
							<cfset 'start_#PERIOD_YEAR#' = dateFormat('01/01/'&PERIOD_YEAR,dateformat_style)>
						</cfif>
						<cfif currentrow eq recordcount>
							<cfset 'finish_#PERIOD_YEAR#' = dateFormat(attributes.date2,dateformat_style)>
						<cfelse>
							<cfset 'finish_#PERIOD_YEAR#' = dateFormat('31/12/'&PERIOD_YEAR,dateformat_style)>
						</cfif>
					</cfoutput>
				<cfelse>
					<cfset 'start_#get_periods.PERIOD_YEAR#' = dateFormat(attributes.date1,dateformat_style)>
					<cfset 'finish_#get_periods.PERIOD_YEAR#' = dateFormat(attributes.date2,dateformat_style)>
				</cfif>
				<cfif not get_periods.recordcount>
					<script type="text/javascript">
						alert("<cf_get_lang dictionary_id='57859.Dönem Kaydı Bulunmamaktadır'>!");
						history.back();	
					</script>
					<cfabort>
				</cfif>
				<cfset city_id_list = ''>
				<cfset county_id_list = ''>
				<cfset country_id_list = ''>
				<cfoutput query="GET_CMP_IDS">
					<cfif len(county) and not listfind(county_id_list,county)>
						<cfset county_id_list = listappend(county_id_list,county)>
					</cfif>	
					<cfif len(city) and not listfind(city_id_list,city)>
						<cfset city_id_list = listappend(city_id_list,city)>
					</cfif>	
					<cfif len(country) and not listfind(country_id_list,country)>
						<cfset country_id_list = listappend(country_id_list,country)>
					</cfif>	
				</cfoutput>

				<cfif len(county_id_list)>
					<cfset county_id_list=listsort(county_id_list,"numeric","ASC",",")>
					<cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
						SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_id_list#) ORDER BY COUNTY_ID
					</cfquery>
					<cfset county_id_list = listsort(listdeleteduplicates(valuelist(get_county_name.county_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(city_id_list)>
					<cfset city_id_list=listsort(city_id_list,"numeric","ASC",",")>
					<cfquery name="GET_CITY_NAME" datasource="#DSN#">
						SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_id_list#) ORDER BY CITY_ID
					</cfquery>
					<cfset city_id_list = listsort(listdeleteduplicates(valuelist(get_city_name.city_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(country_id_list)>
					<cfset country_id_list=listsort(country_id_list,"numeric","ASC",",")>
					<cfquery name="GET_COUNTRY_NAME" datasource="#DSN#">
						SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_id_list#) ORDER BY COUNTRY_ID
					</cfquery>
					<cfset country_id_list = listsort(listdeleteduplicates(valuelist(get_country_name.country_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfset card_index = 1>
				<cfloop query="GET_CMP_IDS">
					<cfif len(company_id)>
						<cfset attributes.company_id=company_id>
						<cfset member_type = 'partner'>
					<cfelse>
						<cfset attributes.company_id=''>
					</cfif>
					<cfif len(consumer_id)>
						<cfset attributes.consumer_id=consumer_id>
						<cfset member_type = 'consumer'>
					<cfelse>
						<cfset attributes.consumer_id=''>
					</cfif>
					<cfif len(employee_id)>
						<cfset attributes.employee_id=employee_id>
						<cfset member_type = 'employee'>
					<cfelse>
						<cfset attributes.employee_id=''>
					</cfif>
					<cfset attributes.company=replace(fullname,"&"," ","all")>
					<cfloop query="get_periods">
						<cfif get_periods.period_year lt year(now())>
							<cfset new_date = createodbcdatetime('31/12/#get_periods.period_year#')>
						<cfelseif attributes.date2 lt now()>
							<cfset new_date = attributes.date2>
						<cfelse>
							<cfset new_date = now()>
						</cfif>
						<cfset new_period = get_periods.period_id>
						<cfset new_dsn = '#dsn#_#get_periods.PERIOD_YEAR#_#get_periods.OUR_COMPANY_ID#'>
						<cfif isdefined('attributes.form_submit')>
							<cfif listfind(attributes.list_type,4)>
								<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
									SELECT PAYMETHOD_ID,DUE_DAY,DUE_MONTH FROM SETUP_PAYMETHOD ORDER BY PAYMETHOD_ID
								</cfquery>
								<cfset pay_method_id_list = ''>
								<cfset pay_method_gun_list = ''>
								<cfoutput query="GET_PAYMETHOD">
									<cfif len(DUE_DAY)>
										<cfset pay_method_id_list = listappend(pay_method_id_list,PAYMETHOD_ID,',')>
										<cfset pay_method_gun_list = listappend(pay_method_gun_list,DUE_DAY,',')>
									<cfelseif len(DUE_MONTH)>
										<cfset pay_method_id_list = listappend(pay_method_id_list,PAYMETHOD_ID,',')>
										<cfset pay_method_gun_list = listappend(pay_method_gun_list,(DUE_MONTH*30)/2,',')>
									</cfif>
								</cfoutput>
							</cfif>
							<cfinclude template="../query/get_extre.cfm">
						<cfelse>
							<cfset CARI_ROWS_ALL.recordcount = 0>
						</cfif>
						<cfif isdefined('attributes.is_excel') or isdefined("is_ajax") or get_periods.recordcount neq 1 or (isdefined("attributes.is_collacted") and attributes.is_collacted eq 1) or (listfind(attributes.list_type,10))>
							<cfset attributes.startrow=1>
							<cfset attributes.maxrows=CARI_ROWS_ALL.recordcount>
						</cfif>
						<cfparam name="attributes.page" default = "1">
						<cfparam name="attributes.totalrecords" default = "#CARI_ROWS_ALL.recordcount#">
						<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
						<cfif (isdefined("attributes.is_bakiye") and CARI_ROWS_ALL.recordcount gt 0) or not isdefined("attributes.is_bakiye")>
							<cf_seperator title="#get_cmp_ids.member_code# - #get_cmp_ids.fullname#" id="get_#card_index#">
							<div id="get_<cfoutput>#card_index#</cfoutput>">
								<div class="ui-card">
									<div class="ui-card-item">
										<table>
											<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and isdefined("attributes.employee_id")>
												<cfquery name="get_acc_type" datasource="#dsn#">
													SELECT ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = #attributes.acc_type_id#
												</cfquery>
											</cfif>
											<cfoutput>
												<cfif len(get_cmp_ids.member_code)><tr><td class="bold"><cf_get_lang dictionary_id="30707.Member Code"></td><td>#get_cmp_ids.member_code#</td></tr></cfif>
												<cfif len(get_cmp_ids.fullname)><tr><td class="bold"><cf_get_lang dictionary_id="57571.Unvan"></td><td>#get_cmp_ids.fullname#</td></tr></cfif> 
												<cfif isdefined ('attributes.company') and len(attributes.comp_name)>
													<tr><td class="bold"><cf_get_lang dictionary_id="57574.Company"></td><td>#attributes.company#</td></tr>
												</cfif>
												<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and isdefined("attributes.employee_id")> 
													<tr><td class="bold"><cf_get_lang dictionary_id="57652.Account"></td><td>#get_acc_type.acc_type_name#</td></tr>
												</cfif>
												<tr>
													<td width="120" class="bold"><cf_get_lang dictionary_id="57809.Account Statement"></td>
													<td>
														<cfif is_show_member_address eq 1 and not isdefined("show_member_address")>
															#get_cmp_ids.address# #get_cmp_ids.semt# 
															<cfif len(county_id_list) and len(get_cmp_ids.county)>
																&nbsp;&nbsp;&nbsp;#get_county_name.county_name[listfind(county_id_list,get_cmp_ids.county,',')]#	
															</cfif>
															<cfif len(city_id_list) and len(get_cmp_ids.city)> 
																/ #get_city_name.city_name[listfind(city_id_list,get_cmp_ids.city,',')]#
															</cfif> 
															<cfif len(country_id_list) and len(get_cmp_ids.country)> 
																- #get_country_name.country_name[listfind(country_id_list,get_cmp_ids.country,',')]#
															</cfif>
														</cfif>
													</td>
												</tr>
												<tr>
													<td class="bold"><cf_get_lang dictionary_id="58472.Period"></td>
													<td>#session.ep.company# #get_periods.period_year#</td>
												</tr>
												<tr>
													<td class="bold"><cf_get_lang dictionary_id="60238.Period Range"></td>
													<td>#Evaluate('start_#PERIOD_YEAR#')# - #Evaluate('finish_#PERIOD_YEAR#')#</td>
												</tr>
												<tr>
													<td class="bold"><cf_get_lang dictionary_id='57742.Tarih'></td>
													<td>#dateFormat(Now(),"dd/mm/YYYY")# #timeFormat(Now(),"hh:mm:ss")#</td>
												</tr>
												<tr>
													<td class="bold"><cf_get_lang dictionary_id="57499.Telefon"></td>
													<td>#get_cmp_ids.telefon#</td>
												</tr>
											</cfoutput>
										</table>
									</div>
								</div>
								<cfif listfind(attributes.list_type,9) and not (isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name))>
									<cfinclude template="dsp_extre_summary.cfm">
								</cfif>
								<cf_grid_list>
									<thead>	
										<tr>
											<th><cf_get_lang dictionary_id='57487.No'></th>
											<th><cf_get_lang dictionary_id='57742.Tarih'></th>
											<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
											<th><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
											<th><cf_get_lang dictionary_id='57490.Gün'></th>
											</cfif>
											<cfif listfind(attributes.list_type,5)><th><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
											<th><cf_get_lang dictionary_id='57468.Belge'></th>
											<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
												<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
											</cfif>
											<th><cf_get_lang dictionary_id='57692.İşlem'></th>
											<cfif listfind(attributes.list_type,8)><th><cf_get_lang dictionary_id='57629.Açıklama'></th></cfif>
											<th class="text-right"><cf_get_lang dictionary_id='57587.Borç'></th>
											<th width="30"></th>
											<th class="text-right"><cf_get_lang dictionary_id='57588.Alacak'></th>
											<th width="30"></th>
											<cfif listfind(attributes.list_type,2)>		
											<th class="text-right">2.<cf_get_lang dictionary_id='57587.Borç'></th>
											<th width="30"></th>
											<th class="text-right">2.<cf_get_lang dictionary_id='57588.Alacak'></th>
											<th width="30"></th>
											</cfif>
											<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>	
											<th class="text-right"><cf_get_lang dictionary_id='57862.İşlem Dövizi Borç'></th>
											<th class="text-right"><cf_get_lang dictionary_id='57863.İşlem Dövizi Alacak'></th>
											<th class="text-right"><cf_get_lang dictionary_id='57677.Döviz'></th>
											<th class="text-right"><cf_get_lang dictionary_id='57648.Kur'></th>
											</cfif>
											<th class="text-right"><cf_get_lang dictionary_id='57589.Bakiye'></th>
											<th width="30"></th>
											<th width="25"><cf_get_lang dictionary_id='29683.B/A'></th>
											<cfif listfind(attributes.list_type,3)>
												<th width="100" class="text-right">2.<cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id='57589.Bakiye'></th>
												<th width="10"></th>
												<th width="25"><cf_get_lang dictionary_id='29683.B/A'></th>
											</cfif>
											<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
												<th width="100" class="text-right"><cf_get_lang dictionary_id='58121.İşlem Dövizi'> <cf_get_lang dictionary_id='57589.Bakiye'></th>
												<th width="30"></th>
												<th width="25"><cf_get_lang dictionary_id='29683.B/A'></th>
											</cfif>
											<th width="20"><cf_get_lang dictionary_id='57756.Durum'></th>
										</tr>
									</thead>
										<cfset money_list_borc_2 = ''>
										<cfset money_list_borc_1 = ''>
										<cfset money_list_alacak_2 = ''>
										<cfset money_list_alacak_1 = ''>
										<cfset row_money_list_borc_2 = ''>
										<cfset row_money_list_borc_1 = ''>
										<cfset row_money_list_alacak_2 = ''>
										<cfset row_money_list_alacak_1 = ''>
										<cfscript>
											devir_total = 0;
											devir_total_other = 0;
											devir_borc = 0;
											devir_alacak = 0;
											devir_borc_other = 0;
											devir_alacak_other = 0;

											bakiye = 0;
											other_bakiye = 0;
											devir_total_2 = 0;
											devir_borc_2 = 0;
											devir_alacak_2 = 0;

											bakiye_2 = 0;
											gen_borc_top = 0;
											gen_ala_top = 0;
											gen_bak_top = 0;
											gen_bak_top_other = 0;
											gen_bak_top_2 = 0;
											gen_borc_top_2 = 0;
											gen_ala_top_2 = 0;
											gen_borc_top_other = 0;
											gen_ala_top_other = 0;
											
											devir_total_pro = 0;
											devir_total_other_pro = 0;
											devir_borc_pro = 0;
											devir_alacak_pro= 0;
											devir_borc_other_pro = 0;
											devir_alacak_other_pro= 0;
											row_bakiye = 0;
											row_other_bakiye = 0;
											devir_total_pro_2 = 0;
											devir_borc_pro_2 = 0;
											devir_alacak_pro_2 = 0;

											devir_total_sub = 0;
											devir_total_other_sub = 0;
											devir_borc_sub = 0;
											devir_alacak_sub= 0;
											devir_borc_other_sub = 0;
											devir_alacak_other_sub= 0;
											devir_total_sub_2 = 0;
											devir_borc_sub_2 = 0;
											devir_alacak_sub_2 = 0;

											devir_total_acc = 0;
											devir_total_other_acc = 0;
											devir_borc_acc = 0;
											devir_alacak_acc= 0;
											devir_borc_other_acc = 0;
											devir_alacak_other_acc= 0;
											devir_total_acc_2 = 0;
											devir_borc_acc_2 = 0;
											devir_alacak_acc_2 = 0;

											row_bakiye_2 = 0;
											row_gen_borc_top = 0;
											row_gen_ala_top = 0;
											row_gen_bak_top = 0;
											row_gen_bak_top_other = 0;
											row_gen_bak_top_2 = 0;
											row_gen_borc_top_2 = 0;
											row_gen_ala_top_2 = 0;
											row_gen_borc_top_other = 0;
											row_gen_ala_top_other = 0;
											//subscription için 
											srow_bakiye_2 = 0;
											srow_gen_borc_top = 0;
											srow_gen_ala_top = 0;
											srow_gen_bak_top = 0;
											srow_gen_bak_top_other = 0;
											srow_gen_bak_top_2 = 0;
											srow_gen_borc_top_2 = 0;
											srow_gen_ala_top_2 = 0;
											srow_gen_borc_top_other = 0;
											srow_gen_ala_top_other = 0;
											//acc_type_id için 
											arow_bakiye_2 = 0;
											arow_gen_borc_top = 0;
											arow_gen_ala_top = 0;
											arow_gen_bak_top = 0;
											arow_gen_bak_top_other = 0;
											arow_gen_bak_top_2 = 0;
											arow_gen_borc_top_2 = 0;
											arow_gen_ala_top_2 = 0;
											arow_gen_borc_top_other = 0;
											arow_gen_ala_top_other = 0;
										</cfscript>
										<cfoutput query="get_money">
											<cfset 'devir_borc_#money#' = 0>
											<cfset 'devir_alacak_#money#' = 0>
										</cfoutput>
										<cfloop query="get_money">
											<cfset 'devir_borc_pro_#money#' = 0>
											<cfset 'devir_alacak_pro_#money#' = 0>
										</cfloop>
										<cfloop query="get_money">
											<cfset 'devir_borc_sub_#money#' = 0>
											<cfset 'devir_alacak_sub_#money#' = 0>
										</cfloop>
										<cfloop query="get_money">
											<cfset 'devir_borc_acc_#money#' = 0>
											<cfset 'devir_alacak_acc_#money#' = 0>
										</cfloop>
										<cfif datediff('d',yilbasi,date1) neq 0>
											<cfquery name="GET_TARIH_DEVIR" dbtype="query">
												SELECT
													SUM(BORC) BORC,
													SUM(ALACAK) ALACAK,
													SUM(BORC-ALACAK) DEVIR_TOTAL,
													SUM(BORC2) BORC2,
													SUM(ALACAK2) ALACAK2,
													SUM(BORC2-ALACAK2) DEVIR_TOTAL2
												FROM
													CARI_ROWS
												WHERE
													ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
													<cfif isdefined("attributes.is_project_group")>
														AND PROJECT_ID = 0
													</cfif>
													<cfif isdefined("attributes.is_subscription_group")> <!--- PY ??--->
														AND SUBSCRIPTION_ID IS NULL
													</cfif>
													<cfif isdefined("attributes.is_acc_type_group")> <!--- PY ??--->
														AND ACC_TYPE_ID IS NULL
													</cfif>
											</cfquery>
											<cfquery name="GET_TARIH_DEVIR_OTHER" dbtype="query">
												SELECT
													SUM(BORC_OTHER) BORC_OTHER,
													SUM(ALACAK_OTHER) ALACAK_OTHER,
													OTHER_MONEY
													<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
														,SUM(BORC_OTHER-ALACAK_OTHER) DEVIR_TOTAL_OTHER
													</cfif>
												FROM
													CARI_ROWS
												WHERE
													ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
													<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
														<cfif attributes.other_money is 'YTL' or attributes.other_money is 'TL'>
															AND (OTHER_MONEY = 'YTL' OR OTHER_MONEY = 'TL')
														<cfelse>
															AND OTHER_MONEY = '#attributes.other_money#'
														</cfif>
													</cfif>
													<cfif isdefined("attributes.is_project_group")>
														AND PROJECT_ID = 0
													</cfif>
													<cfif isdefined("attributes.is_subscription_group")> <!--- PY ??--->
														AND SUBSCRIPTION_ID IS NULL
													</cfif>
													<cfif isdefined("attributes.is_acc_type_group")> <!--- PY ??--->
														AND ACC_TYPE_ID IS NULL
													</cfif>
												GROUP BY
													OTHER_MONEY
											</cfquery>
											<cfif get_tarih_devir.recordcount>
												<cfset devir_borc = get_tarih_devir.BORC>
												<cfset devir_alacak = get_tarih_devir.ALACAK>
												<cfset devir_borc_other = get_tarih_devir_other.BORC_OTHER>
												<cfset devir_alacak_other = get_tarih_devir_other.ALACAK_OTHER>
												<cfset devir_total = get_tarih_devir.DEVIR_TOTAL>
												<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
													<cfset devir_total_other = get_tarih_devir_other.DEVIR_TOTAL_OTHER>
												</cfif>
												<cfset devir_borc_2 = get_tarih_devir.BORC2>
												<cfset devir_alacak_2 = get_tarih_devir.ALACAK2>
												<cfset devir_total_2 = get_tarih_devir.DEVIR_TOTAL2>
												<cfset row_gen_borc_top = devir_borc+row_gen_borc_top>
												<cfset row_gen_ala_top = devir_alacak+row_gen_ala_top>
												<cfset row_gen_borc_top_2 = devir_borc_2+row_gen_borc_top_2>
												<cfset row_gen_ala_top_2 = devir_alacak_2+row_gen_ala_top_2 >
												<cfset row_gen_bak_top = (devir_borc-devir_alacak)+row_gen_bak_top>	
												<cfset row_gen_bak_top_2 = (devir_borc_2-devir_alacak_2)+row_gen_bak_top_2>		
												<cfset row_gen_bak_top_other = (devir_borc_other-devir_alacak_other)+row_gen_bak_top_other>	
											</cfif>
											<cfif get_tarih_devir_other.recordcount>
												<cfoutput query="get_tarih_devir_other">
													<cfset 'devir_borc_#other_money#' = evaluate('devir_borc_#other_money#') +borc_other>
													<cfset 'devir_alacak_#other_money#' = evaluate('devir_alacak_#other_money#') +alacak_other>
												</cfoutput>
											</cfif>
										</cfif>
										<cfif attributes.page gt 1>
											<cfset max_=(attributes.page-1)*attributes.maxrows>
											<cfoutput query="CARI_ROWS_ALL" startrow="1" maxrows="#max_#">
												<cfset devir_borc = devir_borc + borc>
												<cfset devir_alacak = devir_alacak + alacak>
												<cfset devir_borc_other = devir_borc_other + borc_other>
												<cfset devir_alacak_other = devir_alacak_other + alacak_other>
												<cfset devir_total = devir_borc - devir_alacak>
												<cfset devir_total_other = devir_borc_other - devir_alacak_other>
												<cfif len(borc2)><cfset devir_borc_2 = devir_borc_2 + borc2></cfif>
												<cfif len(alacak2)><cfset devir_alacak_2 = devir_alacak_2 + alacak2></cfif>
												<cfset devir_total_2 = devir_borc_2 - devir_alacak_2>
												<cfset 'devir_borc_#other_money#' = evaluate('devir_borc_#other_money#') +borc_other>
												<cfset 'devir_alacak_#other_money#' = evaluate('devir_alacak_#other_money#') +alacak_other>
											</cfoutput>
										</cfif>
										<cfif devir_borc neq 0 or devir_alacak neq 0>
											<cfoutput>
												<tr <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
													<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
														<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 9>
															<cfelse>
																<cfset colspan_info = 8>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 7>
															<cfelse>
																<cfset colspan_info = 6>
															</cfif>
														</cfif>
													<cfelse>
														<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 7>
															<cfelse>
																<cfset colspan_info = 6>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 5>
															<cfelse>
																<cfset colspan_info = 4>
															</cfif>
														</cfif>
													</cfif>
													<td colspan="#colspan_info#"  style="text-align:right;"><b><cf_get_lang dictionary_id='57864.Devir'></b></td>
													<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>
													<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc)#</td>
													<td>#session_base.money#</td>
													<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak)#</td>
													<td>#session_base.money#</td>
													<cfif listfind(attributes.list_type,2)>
														<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_2)#</td>
														<td>#session_base.money2#</td>
														<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_2)#</td>
														<td>#session_base.money2#</td>
													</cfif>	
													<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
														<td style="text-align:right;">
															<cfloop query="get_money">
																<cfif evaluate('devir_borc_#get_money.money#') gt 0>#TLFormat(evaluate('devir_borc_#get_money.money#'))#<br/></cfif>
															</cfloop>
														</td>
														<td style="text-align:right;">
															<cfloop query="get_money">
																<cfif evaluate('devir_alacak_#get_money.money#') gt 0>#TLFormat(evaluate('devir_alacak_#get_money.money#'))#<br/></cfif>
															</cfloop>
														</td>
														<td style="text-align:right;"><cfloop query="get_money"><cfif evaluate('devir_borc_#get_money.money#') gt 0>#get_money.money#<br/></cfif></cfloop></td>
														<td style="text-align:right;">
															<cfloop query="get_money">
																<cfif evaluate('devir_alacak_#get_money.money#') gt 0>#get_money.money#<br/></cfif>
															</cfloop>
														</td>
														<!---
														<td></td>
														<td></td>
														--->
													</cfif>
													<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(ABS(devir_total))#</td>
													<td>#session_base.money#</td>
													<td><cfif devir_borc gt devir_alacak><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc lt devir_alacak><cf_get_lang dictionary_id='29684.A'></cfif></td>
													<cfif listfind(attributes.list_type,3)>
														<td  style="text-align:right;">#TLFormat(ABS(devir_total_2))#</td>
														<td>#session_base.money2#</td>
														<td><cfif devir_borc_2 gt devir_alacak_2><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_2 lt devir_alacak_2><cf_get_lang dictionary_id='29684.A'></cfif></td>
													</cfif> 
													<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
														<td  style="text-align:right;">#TLFormat(ABS(devir_total_other))#</td>
														<td>#attributes.other_money#</td>
														<td><cfif devir_borc_other gt devir_alacak_other><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_other lt devir_alacak_other><cf_get_lang dictionary_id='29684.A'></cfif></td>
													</cfif>
												</tr>
											</cfoutput>
										</cfif>
										<cfif CARI_ROWS_ALL.recordcount>
											<cfset bank_order_list="">
											<cfset company_id_list="">
											<cfset consumer_id_list="">
											<cfset employee_id_list="">
											<cfset row_count = 1>
											<cfset process_cat_id_list = ''>
											<cfset project_id_list = "">
											<cfset subscription_id_list = "">
											<cfset acc_type_id_list = "">
											<cfset row_project_id_list = "">
											<cfset wrk_row_id_list = ''>
											<cfset wrk_id_list = ''>
											<cfoutput query="CARI_ROWS_ALL" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
												<cfif (CARI_ROWS_ALL.ACTION_TYPE_ID eq 250)>
													<cfset bank_order_list=listappend(bank_order_list,CARI_ROWS_ALL.ACTION_ID)>
												</cfif>
												<cfif len(from_cmp_id) and not listfind(company_id_list,from_cmp_id)>
													<cfset company_id_list=listappend(company_id_list,from_cmp_id)>
												</cfif>	
												<cfif len(to_cmp_id) and not listfind(company_id_list,to_cmp_id)>
													<cfset company_id_list=listappend(company_id_list,to_cmp_id)>
												</cfif>
												<cfif len(from_consumer_id) and not listfind(consumer_id_list,from_consumer_id)>
													<cfset consumer_id_list=listappend(consumer_id_list,from_consumer_id)>
												</cfif>	
												<cfif len(to_consumer_id) and not listfind(consumer_id_list,to_consumer_id)>
													<cfset consumer_id_list=listappend(consumer_id_list,to_consumer_id)>
												</cfif>
												<cfif len(from_employee_id) and not listfind(employee_id_list,from_employee_id)>
													<cfset employee_id_list=listappend(employee_id_list,from_employee_id)>
												</cfif>	
												<cfif len(to_employee_id) and not listfind(employee_id_list,to_employee_id)>
													<cfset employee_id_list=listappend(employee_id_list,to_employee_id)>
												</cfif>				
												<cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
													<cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
												</cfif>
												<cfif len(project_id) and project_id neq 0 and not listfind(project_id_list,project_id)>
													<cfset project_id_list = Listappend(project_id_list,project_id)>
												</cfif>
												<cfif len(subscription_id) and subscription_id neq 0 and not listfind(subscription_id_list,subscription_id)>
													<cfset subscription_id_list = Listappend(subscription_id_list,subscription_id)>
												</cfif>
												<cfif len(acc_type_id) and acc_type_id neq 0 and not listfind(acc_type_id_list,acc_type_id)>
													<cfset acc_type_id_list = Listappend(acc_type_id_list,acc_type_id)>
												</cfif>
												<cfif len(row_project_id) and row_project_id neq 0 and not listfind(row_project_id_list,row_project_id)>
													<cfset row_project_id_list = Listappend(row_project_id_list,row_project_id)>
												</cfif>
												<cfif len(inv_wrk_row_rel_id) and not listfind(wrk_row_id_list,inv_wrk_row_rel_id)>
													<cfset wrk_row_id_list=listappend(wrk_row_id_list,"'#inv_wrk_row_rel_id#'")>
												</cfif>
												<cfif len(inv_wrk_row_id) and not listfind(wrk_id_list,inv_wrk_row_id)>
													<cfset wrk_id_list=listappend(wrk_id_list,"'#inv_wrk_row_id#'")>
												</cfif>
											</cfoutput>
											<cfset wrk_row_id_list=listsort(listdeleteduplicates(wrk_row_id_list,','),'text','ASC',',')>
											<cfset wrk_id_list=listsort(listdeleteduplicates(wrk_id_list,','),'text','ASC',',')>
											<cfif listlen(wrk_id_list)>
												<cfquery name="get_rel_ship_2" datasource="#DSN2#">
													SELECT
														SHIP_NUMBER,
														WRK_ROW_RELATION_ID
													FROM 
														SHIP S,
														SHIP_ROW SR
													WHERE
														S.SHIP_ID = SR.SHIP_ID
														AND SR.WRK_ROW_RELATION_ID IS NOT NULL
														AND SR.WRK_ROW_RELATION_ID IN (#PreserveSingleQuotes(wrk_id_list)#)
													ORDER BY
														S.SHIP_ID,
														WRK_ROW_RELATION_ID
												</cfquery>
												<cfset main_ship_wrk_list_2 = valuelist(get_rel_ship_2.WRK_ROW_RELATION_ID,',')>
											</cfif>
											<cfif listlen(wrk_row_id_list)>
												<cfquery name="get_rel_ship" datasource="#DSN2#">
													SELECT
														SHIP_NUMBER,
														WRK_ROW_ID
													FROM 
														SHIP S,
														SHIP_ROW SR
													WHERE
														S.SHIP_ID = SR.SHIP_ID
														AND SR.WRK_ROW_ID IS NOT NULL
														AND SR.WRK_ROW_ID IN (#PreserveSingleQuotes(wrk_row_id_list)#)
													ORDER BY
														S.SHIP_ID,
														WRK_ROW_ID
												</cfquery>
												<cfset main_ship_wrk_list = valuelist(get_rel_ship.WRK_ROW_ID,',')>
												<cfquery name="get_rel_order" datasource="#DSN2#">
													SELECT
														ORDER_NUMBER,
														ORDER_HEAD,
														WRK_ROW_ID
													FROM
													(
														SELECT
															O.ORDER_NUMBER,
															O.ORDER_HEAD,
															SR.WRK_ROW_ID
														FROM 
															SHIP S,
															SHIP_ROW SR,
															#dsn3_alias#.ORDERS O,
															#dsn3_alias#.ORDER_ROW ORR
														WHERE
															S.SHIP_ID = SR.SHIP_ID
															AND O.ORDER_ID = ORR.ORDER_ID
															AND SR.WRK_ROW_RELATION_ID IS NOT NULL
															AND SR.WRK_ROW_ID IS NOT NULL
															AND ORR.WRK_ROW_ID IS NOT NULL 
															AND SR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID
															AND SR.WRK_ROW_ID IN (#PreserveSingleQuotes(wrk_row_id_list)#)
														UNION
														SELECT
															O.ORDER_NUMBER,
															O.ORDER_HEAD,
															ORR.WRK_ROW_ID
														FROM 
															#dsn3_alias#.ORDERS O,
															#dsn3_alias#.ORDER_ROW ORR
														WHERE
															O.ORDER_ID = ORR.ORDER_ID
															AND ORR.WRK_ROW_ID IS NOT NULL 
															AND ORR.WRK_ROW_ID IN (#PreserveSingleQuotes(wrk_row_id_list)#)
													)T1
													ORDER BY
														WRK_ROW_ID
												</cfquery>
												<cfset main_order_wrk_list = listsort(listdeleteduplicates(valuelist(get_rel_order.WRK_ROW_ID,',')),'text','ASC',',')>
											</cfif>
											<cfif len(bank_order_list)>
												<cfset bank_order_list=listsort(bank_order_list,"numeric","desc",",")>
												<cfquery name="GET_BANK_ORDER" datasource="#new_dsn#">
													SELECT 
														BANK_ORDER_ID,
														PAYMENT_DATE
													FROM
														BANK_ORDERS
													WHERE
														BANK_ORDER_ID IN (#bank_order_list#)
													ORDER BY
														BANK_ORDER_ID DESC
												</cfquery>
											</cfif>
											<cfif len(company_id_list)>
												<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
												<cfquery name="GET_COMPANY" datasource="#DSN#">
													SELECT FULLNAME	FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
												</cfquery>
											</cfif>
											<cfif len(consumer_id_list)>
												<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
												<cfquery name="GET_CONSUMER" datasource="#DSN#">
													SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
												</cfquery>
											</cfif>
											<cfif len(employee_id_list)>
												<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
												<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
													SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
												</cfquery>
											</cfif>
											<cfif len(process_cat_id_list)>
												<cfset process_cat_id_list=listsort(process_cat_id_list,"numeric","ASC",",")>			
												<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
													SELECT PROCESS_CAT_ID,#dsn#.Get_Dynamic_Language(PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,PROCESS_CAT) AS PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY PROCESS_CAT_ID
												</cfquery>
												<cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat.PROCESS_CAT_ID,',')),'numeric','ASC',',')>
											</cfif>
											<cfif len(project_id_list)>
												<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>			
												<cfquery name="get_project_name" datasource="#dsn#">
													SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
												</cfquery>
												<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
											</cfif>
											<cfif len(subscription_id_list)>
												<cfset subscription_id_list=listsort(subscription_id_list,"numeric","ASC",",")>			
												<cfquery name="get_subscription_name" datasource="#dsn3#">
													SELECT SUBSCRIPTION_ID,SUBSCRIPTION_NO,SUBSCRIPTION_HEAD FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IN (#subscription_id_list#) ORDER BY SUBSCRIPTION_ID
												</cfquery>
												<cfset subscription_id_list = listsort(listdeleteduplicates(valuelist(get_subscription_name.SUBSCRIPTION_ID,',')),'numeric','ASC',',')>
											</cfif>
											<cfif len(acc_type_id_list)>
												<cfset acc_type_id_list=listsort(acc_type_id_list,"numeric","ASC",",")>		
												<cfquery name="getAccount_Name" datasource="#dsn#">
												SELECT ACCOUNT_TYPE_ID, ACCOUNT_TYPE FROM ACCOUNT_TYPES WHERE ACCOUNT_TYPE_ID IN (#acc_type_id_list#) ORDER BY ACCOUNT_TYPE_ID
												</cfquery>
												<cfset acc_type_id_list = listsort(listdeleteduplicates(valuelist(getAccount_Name.ACCOUNT_TYPE_ID,',')),'numeric','ASC',',')>
											</cfif> 
											<cfif len(row_project_id_list)>
												<cfset row_project_id_list=listsort(row_project_id_list,"numeric","ASC",",")>			
												<cfquery name="get_project_name_row" datasource="#dsn#">
													SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list#) ORDER BY PROJECT_ID
												</cfquery>
												<cfset row_project_id_list = listsort(listdeleteduplicates(valuelist(get_project_name_row.project_id,',')),'numeric','ASC',',')>
											</cfif>
											<cfoutput query="CARI_ROWS_ALL" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
												<cfif len(borc_other)>
													<cfset bakiye_borc_2 = borc_other>
													<cfset bakiye_borc_1 = borc>
												<cfelse>
													<cfset bakiye_borc_2 = 0>
													<cfset bakiye_borc_1 = 0>
												</cfif>
												<cfif len(alacak_other)>
													<cfset bakiye_alacak_2 = alacak_other>
													<cfset bakiye_alacak_1 = alacak>
												<cfelse>
													<cfset bakiye_alacak_2 = 0>
													<cfset bakiye_alacak_1 = 0>
												</cfif>
												<cfset money_2 = other_money>
												<cfset money_1 = session_base.money>
												<cfif bakiye_borc_2 gt 0>
													<cfset money_list_borc_2 = listappend(money_list_borc_2,'#bakiye_borc_2#;#money_2#',',')>
													<cfset money_list_borc_1 = listappend(money_list_borc_1,'#bakiye_borc_1#;#money_1#',',')>
													<cfset row_money_list_borc_2 = listappend(row_money_list_borc_2,'#bakiye_borc_2#;#money_2#',',')>
													<cfset row_money_list_borc_1 = listappend(row_money_list_borc_1,'#bakiye_borc_1#;#money_1#',',')>
												</cfif>	
												<cfif bakiye_alacak_2 gt 0>
													<cfset money_list_alacak_2 = listappend(money_list_alacak_2,'#bakiye_alacak_2#;#money_2#',',')>
													<cfset money_list_alacak_1 = listappend(money_list_alacak_1,'#bakiye_alacak_1#;#money_1#',',')>
													<cfset row_money_list_alacak_2 = listappend(row_money_list_alacak_2,'#bakiye_alacak_2#;#money_2#',',')>
													<cfset row_money_list_alacak_1 = listappend(row_money_list_alacak_1,'#bakiye_alacak_1#;#money_1#',',')>
												</cfif>
												<cfset type="">
												<cfswitch expression = "#ACTION_TYPE_ID#">
													<cfcase value="24"><cfset type="objects.popup_dsp_gelenh&period_id=#new_period#"></cfcase>
													<cfcase value="25"><cfset type="objects.popup_dsp_gidenh&period_id=#new_period#"></cfcase>
													<cfcase value="26,27"><cfset type="objects.popup_check_preview"></cfcase>
													<cfcase value="31"><cfset type="objects.popup_dsp_cash_revenue&period_id=#new_period#"></cfcase>
													<cfcase value="32"><cfset type="objects.popup_dsp_cash_payment&period_id=#new_period#"></cfcase>
													<cfcase value=34><cfset type="objects.popup_dsp_alisf_kapa"></cfcase><!---alış f. kapama--->
													<cfcase value=35><cfset type="objects.popup_dsp_satisf_kapa"></cfcase><!---satış f. kapama--->
													<cfcase value="40"><cfset type="objects.popup_dsp_account_open&period_id=#new_period#"></cfcase>
													<cfcase value="43"><cfset type="objects.popup_cari_action&period_id=#new_period#"></cfcase>
													<cfcase value="41,42,45,46"><cfset type="objects.popup_print_upd_debit_claim_note&period_id=#new_period#"></cfcase>
													<cfcase value="90,106"><cfset type="objects.popup_dsp_payroll_entry&period_id=#new_period#"></cfcase>
													<cfcase value="91"><cfset type="objects.popup_dsp_payroll_endorsement&period_id=#new_period#"></cfcase>
													<cfcase value="94"><cfset type="objects.popup_dsp_payroll_endor_return&period_id=#new_period#"></cfcase>
													<cfcase value="95"><cfset type="objects.popup_dsp_payroll_entry_return&period_id=#new_period#"></cfcase>
													<cfcase value="97,98,101,108"><cfset type="objects.popup_dsp_voucher_payroll_action&period_id=#new_period#"></cfcase>
													<cfcase value="131"><cfset type="objects.popup_dsp_collacted_dekont"></cfcase>
													<cfcase value="160,161"><cfset type="objects.popup_detail_budget_plan"></cfcase> 
													<cfcase value="241,245"><cfset type="objects.popup_dsp_credit_card_payment_type"></cfcase>
													<cfcase value="242"><cfset type="objects.popup_dsp_credit_card_payment"></cfcase>
													<cfcase value="251,250"><cfset type="objects.popup_dsp_assign_order&period_id=#new_period#"></cfcase>
													<cfcase value="120,121"><cfset type="objects.popup_list_cost_expense&period_id=#new_period#"></cfcase>
													<cfcase value="291,292"><cfset type="objects.popup_dsp_credit_payment"></cfcase>
													<cfcase value="293,294"><cfset type="objects.popup_dsp_stockbond_purchase"></cfcase>
													<cfcase value="48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691,532,5311">
														<cfif isdefined("invoice_partner_link")>
															<cfset type = invoice_partner_link>
														<cfelse>
															<cfset type="objects.popup_detail_invoice&period_id=#new_period#">
														</cfif>
													</cfcase>
													<cfdefaultcase><cfset type=""></cfdefaultcase>
												</cfswitch>
												<cfif listfind('24,25,26,27,31,32,34,35,36,43,241,242,245,177,250,251,131',ACTION_TYPE_ID,',')>
													<cfset page_type = 'small'>
												<cfelseif listfind('120,121,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691,532,5311',ACTION_TYPE_ID,',')>
													<cfset page_type = 'wide'>
												<cfelse>
													<cfset page_type = 'page'>
												</cfif>
												<cfif isdefined("attributes.is_project_group") and len(CARI_ROWS_ALL.PROJECT_ID[currentrow]) and CARI_ROWS_ALL.PROJECT_ID[currentrow] gt 0 and (CARI_ROWS_ALL.PROJECT_ID[currentrow] neq CARI_ROWS_ALL.PROJECT_ID[currentrow-1] or (attributes.page gt 1 and currentrow mod attributes.maxrows eq 1))>
													<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
														<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 8>
															<cfelse>
																<cfset colspan_info = 7>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 6>
															<cfelse>
																<cfset colspan_info = 5>
															</cfif>
														</cfif>
													<cfelse>
														<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 7>
															<cfelse>
																<cfset colspan_info = 6>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 5>
															<cfelse>
																<cfset colspan_info = 4>
															</cfif>
														</cfif>
													</cfif>
													<cfif len(project_id) and project_id neq 0>
														<cfset row_colspan = colspan_info+3>
														<cfif listfind(attributes.list_type,8)>
															<cfset row_colspan = row_colspan+1> 
														</cfif>
														<cfif listfind(attributes.list_type,2)>
															<cfset row_colspan = row_colspan+2> 
														</cfif>
														<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
															<cfset row_colspan = row_colspan+4> 
														</cfif>
														<cfif listfind(attributes.list_type,3)>
															<cfset row_colspan = row_colspan+1> 
														</cfif>
														<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
															<cfset row_colspan = row_colspan+1>
														</cfif>
														<tr height="20" <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
															<td colspan="#row_colspan#" class="txtbold">
															#get_project_name.project_head[listfind(project_id_list,project_id,',')]#
														<cfelse>&nbsp;</td></cfif>
															</td>
														</tr>
													</td>
													<cfquery name="get_tarih_devir_pro" dbtype="query">
														SELECT
															SUM(BORC) BORC,
															SUM(ALACAK) ALACAK,
															SUM(BORC-ALACAK) DEVIR_TOTAL,
															SUM(BORC2) BORC2,
															SUM(ALACAK2) ALACAK2,
															SUM(BORC2-ALACAK2) DEVIR_TOTAL2
														FROM
															CARI_ROWS
														WHERE
															ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
															AND PROJECT_ID = #CARI_ROWS_ALL.PROJECT_ID#
													</cfquery>
													<cfquery name="get_tarih_devir_other_pro" dbtype="query">
														SELECT
															SUM(BORC_OTHER) BORC_OTHER,
															SUM(ALACAK_OTHER) ALACAK_OTHER,
															OTHER_MONEY
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																,SUM(BORC_OTHER-ALACAK_OTHER) DEVIR_TOTAL_OTHER
															</cfif>
														FROM
															CARI_ROWS
														WHERE
															ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<cfif attributes.other_money is 'YTL' or attributes.other_money is 'TL'>
																	AND (OTHER_MONEY = 'YTL' OR OTHER_MONEY = 'TL')
																<cfelse>
																	AND OTHER_MONEY = '#attributes.other_money#'
																</cfif>
															</cfif>
															AND PROJECT_ID = #CARI_ROWS_ALL.PROJECT_ID#
														GROUP BY
															OTHER_MONEY
													</cfquery>
													<cfif get_tarih_devir_pro.recordcount>
														<cfset devir_borc_pro = get_tarih_devir_pro.BORC>
														<cfset devir_alacak_pro = get_tarih_devir_pro.ALACAK>
														<cfset devir_borc_other_pro = get_tarih_devir_other_pro.BORC_OTHER>
														<cfset devir_alacak_other_pro = get_tarih_devir_other_pro.ALACAK_OTHER>
														<cfset devir_total_pro = get_tarih_devir_pro.DEVIR_TOTAL>
														<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
															<cfset devir_total_other_pro = get_tarih_devir_other_pro.DEVIR_TOTAL_OTHER>
														</cfif>
														<cfset devir_borc_2_pro = get_tarih_devir_pro.BORC2>
														<cfset devir_alacak_2_pro = get_tarih_devir_pro.ALACAK2>
														<cfset devir_total_2_pro = get_tarih_devir_pro.DEVIR_TOTAL2>
														
														<cfset gen_borc_top = gen_borc_top + get_tarih_devir_pro.BORC>
														<cfset gen_ala_top = gen_ala_top + get_tarih_devir_pro.ALACAK>
														<cfset gen_bak_top = gen_bak_top + (get_tarih_devir_pro.BORC-get_tarih_devir_pro.ALACAK)>
														<cfset gen_bak_top_other = gen_bak_top_other + (get_tarih_devir_other_pro.BORC_OTHER-get_tarih_devir_other_pro.ALACAK_OTHER)>
														<cfset gen_bak_top_2 = gen_bak_top_2 + (get_tarih_devir_pro.BORC2-get_tarih_devir_pro.ALACAK2)>
													</cfif>
													<cfif get_tarih_devir_other_pro.recordcount>
														<cfloop query="get_tarih_devir_other_pro">
															<cfset 'devir_borc_pro_#other_money#' = evaluate('devir_borc_pro_#other_money#') +borc_other>
															<cfset 'devir_alacak_pro_#other_money#' = evaluate('devir_alacak_pro_#other_money#') +alacak_other>
														</cfloop>
													</cfif>
													<cfif get_tarih_devir_pro.recordcount>
														<cfset row_gen_borc_top = devir_borc_pro+row_gen_borc_top>
														<cfset row_gen_ala_top = devir_alacak_pro+row_gen_ala_top>
														<cfset row_gen_borc_top_2 = devir_borc_2_pro+row_gen_borc_top_2>
														<cfset row_gen_ala_top_2 = devir_alacak_2_pro+row_gen_ala_top_2 >
														<cfset row_gen_bak_top = (devir_borc_pro-devir_alacak_pro)+row_gen_bak_top>	
														<cfset row_gen_bak_top_2 = (devir_borc_2_pro-devir_alacak_2_pro)+row_gen_bak_top_2>		
														<cfset row_gen_bak_top_other = (devir_borc_other_pro-devir_alacak_other_pro)+row_gen_bak_top_other>		 
														<tr  <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
															<td colspan="#colspan_info#" style="text-align:right;"><b><cf_get_lang dictionary_id='57864.Devir'></b></td>
															<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>
															<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_pro)#</td>
															<td>#session_base.money#</td>
															<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_pro)#</td>
															<td>#session_base.money#</td>
															<cfif listfind(attributes.list_type,2)>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_pro_2)#</td>
																<td>#session_base.money2#</td>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_pro_2)#</td>
																<td>#session_base.money2#</td>
															</cfif>	
															<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
																<td style="text-align:right;">
																	<cfloop query="get_money">
																		<cfif evaluate('devir_borc_pro_#get_money.money#') gt 0>#TLFormat(evaluate('devir_borc_pro_#get_money.money#'))# #get_money.money#<br/></cfif>
																	</cfloop>
																</td>
																<td style="text-align:right;">
																	<cfloop query="get_money">
																		<cfif evaluate('devir_alacak_pro_#get_money.money#') gt 0>#TLFormat(evaluate('devir_alacak_pro_#get_money.money#'))# #get_money.money#<br/></cfif>
																	</cfloop>
																</td>
																<td></td>
																<td></td>
															</cfif>
															<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(ABS(devir_total_pro))#</td> 
															<td>#session_base.money#</td>
															<td><cfif devir_borc_pro gt devir_alacak_pro><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_pro lt devir_alacak_pro><cf_get_lang dictionary_id='29684.A'></cfif></td>
															<cfif listfind(attributes.list_type,3)>
																<td  style="text-align:right;">#TLFormat(ABS(devir_total_2_pro))#</td>
																<td>#session_base.money2#</td>
																<td><cfif devir_borc_2_pro gt devir_alacak_2_pro><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_2_pro lt devir_alacak_2_pro><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif> 
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<td  style="text-align:right;">#TLFormat(ABS(devir_total_other_pro))#</td>
																<td>#attributes.other_money#</td>
																<td><cfif devir_borc_other_pro gt devir_alacak_other_pro><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_other_pro lt devir_alacak_other_pro><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
														</tr>										
													</cfif>
												</cfif>
												<!--- Abone bazlı gruplama PY--->
												<cfif isdefined("attributes.is_subscription_group") and len(CARI_ROWS_ALL.SUBSCRIPTION_ID[currentrow]) and CARI_ROWS_ALL.SUBSCRIPTION_ID[currentrow] gt 0 and (CARI_ROWS_ALL.SUBSCRIPTION_ID[currentrow] neq CARI_ROWS_ALL.SUBSCRIPTION_ID[currentrow-1] or (attributes.page gt 1 and currentrow mod attributes.maxrows eq 1))>
													<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
														<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 8>
															<cfelse>
																<cfset colspan_info = 7>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 6>
															<cfelse>
																<cfset colspan_info = 5>
															</cfif>
														</cfif>
													<cfelse>
														<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 7>
															<cfelse>
																<cfset colspan_info = 6>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 5>
															<cfelse>
																<cfset colspan_info = 4>
															</cfif>
														</cfif>
													</cfif>
													<cfif len(subscription_id) and subscription_id neq 0>
														<cfset row_colspan = colspan_info+3>
														<cfif listfind(attributes.list_type,8)>
															<cfset row_colspan = row_colspan+1> 
														</cfif>
														<cfif listfind(attributes.list_type,2)>
															<cfset row_colspan = row_colspan+2> 
														</cfif>
														<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
															<cfset row_colspan = row_colspan+4> 
														</cfif>
														<cfif listfind(attributes.list_type,3)>
															<cfset row_colspan = row_colspan+1> 
														</cfif>
														<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
															<cfset row_colspan = row_colspan+1>
														</cfif>
														<tr height="20" <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
															<td colspan="#row_colspan#" class="txtbold">
															#get_subscription_name.subscription_no[listfind(subscription_id_list,subscription_id,',')]#  
															<cfelse>&nbsp;</td></cfif>
															</td>
														</tr>
													</td>
													<cfquery name="get_tarih_devir_sub" dbtype="query">
														SELECT
															SUM(BORC) BORC,
															SUM(ALACAK) ALACAK,
															SUM(BORC-ALACAK) DEVIR_TOTAL,
															SUM(BORC2) BORC2,
															SUM(ALACAK2) ALACAK2,
															SUM(BORC2-ALACAK2) DEVIR_TOTAL2
														FROM
															CARI_ROWS
														WHERE
															ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
															AND SUBSCRIPTION_ID = #CARI_ROWS_ALL.SUBSCRIPTION_ID#
													</cfquery>
													<cfquery name="get_tarih_devir_other_sub" dbtype="query">
														SELECT
															SUM(BORC_OTHER) BORC_OTHER,
															SUM(ALACAK_OTHER) ALACAK_OTHER,
															OTHER_MONEY
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																,SUM(BORC_OTHER-ALACAK_OTHER) DEVIR_TOTAL_OTHER
															</cfif>
														FROM
															CARI_ROWS
														WHERE
															ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<cfif attributes.other_money is 'YTL' or attributes.other_money is 'TL'>
																	AND (OTHER_MONEY = 'YTL' OR OTHER_MONEY = 'TL')
																<cfelse>
																	AND OTHER_MONEY = '#attributes.other_money#'
																</cfif>
															</cfif>
															AND SUBSCRIPTION_ID = #CARI_ROWS_ALL.SUBSCRIPTION_ID#
														GROUP BY
															OTHER_MONEY
													</cfquery>
													<cfif get_tarih_devir_sub.recordcount>
														<cfset devir_borc_sub = get_tarih_devir_sub.BORC>
														<cfset devir_alacak_sub = get_tarih_devir_sub.ALACAK>
														<cfset devir_borc_other_sub = get_tarih_devir_other_sub.BORC_OTHER>
														<cfset devir_alacak_other_sub = get_tarih_devir_other_sub.ALACAK_OTHER>
														<cfset devir_total_sub = get_tarih_devir_sub.DEVIR_TOTAL>
														<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
															<cfset devir_total_other_sub = get_tarih_devir_other_sub.DEVIR_TOTAL_OTHER>
														</cfif>
														<cfset devir_borc_2_sub = get_tarih_devir_sub.BORC2>
														<cfset devir_alacak_2_sub = get_tarih_devir_sub.ALACAK2>
														<cfset devir_total_2_sub = get_tarih_devir_sub.DEVIR_TOTAL2>
														
														<cfset gen_borc_top = gen_borc_top + get_tarih_devir_sub.BORC>
														<cfset gen_ala_top = gen_ala_top + get_tarih_devir_sub.ALACAK>
														<cfset gen_bak_top = gen_bak_top + (get_tarih_devir_sub.BORC-get_tarih_devir_sub.ALACAK)>
														<cfset gen_bak_top_other = gen_bak_top_other + (get_tarih_devir_other_sub.BORC_OTHER-get_tarih_devir_other_sub.ALACAK_OTHER)>
														<cfset gen_bak_top_2 = gen_bak_top_2 + (get_tarih_devir_sub.BORC2-get_tarih_devir_sub.ALACAK2)>
													</cfif>
													<cfif get_tarih_devir_other_sub.recordcount>
														<cfloop query="get_tarih_devir_other_sub">
															<cfset 'devir_borc_sub_#other_money#' = evaluate('devir_borc_sub_#other_money#') +borc_other>
															<cfset 'devir_alacak_sub_#other_money#' = evaluate('devir_alacak_sub_#other_money#') +alacak_other>
														</cfloop>
													</cfif>
													<cfif get_tarih_devir_sub.recordcount>
														<cfset srow_gen_borc_top = devir_borc_sub+srow_gen_borc_top>
														<cfset srow_gen_ala_top = devir_alacak_sub+srow_gen_ala_top>
														<cfset srow_gen_borc_top_2 = devir_borc_2_sub+srow_gen_borc_top_2>
														<cfset srow_gen_ala_top_2 = devir_alacak_2_sub+srow_gen_ala_top_2 >
														<cfset srow_gen_bak_top = (devir_borc_sub-devir_alacak_sub)+srow_gen_bak_top>	
														<cfset srow_gen_bak_top_2 = (devir_borc_2_sub-devir_alacak_2_sub)+srow_gen_bak_top_2>		
														<cfset srow_gen_bak_top_other = (devir_borc_other_sub-devir_alacak_other_sub)+srow_gen_bak_top_other>		 
														<tr  <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
															<td colspan="#colspan_info#" style="text-align:right;"><b><cf_get_lang dictionary_id='57864.Devir'></b></td>
															<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>
															<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_sub)#</td>
															<td>#session_base.money#</td>
															<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_sub)#</td>
															<td>#session_base.money#</td>
															<cfif listfind(attributes.list_type,2)>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_sub_2)#</td>
																<td>#session_base.money2#</td>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_sub_2)#</td>
																<td>#session_base.money2#</td>
															</cfif>	
															<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
																<td style="text-align:right;">
																	<cfloop query="get_money">
																		<cfif evaluate('devir_borc_sub_#get_money.money#') gt 0>#TLFormat(evaluate('devir_borc_sub_#get_money.money#'))# #get_money.money#<br/></cfif>
																	</cfloop>
																</td>
																<td style="text-align:right;">
																	<cfloop query="get_money">
																		<cfif evaluate('devir_alacak_sub_#get_money.money#') gt 0>#TLFormat(evaluate('devir_alacak_sub_#get_money.money#'))# #get_money.money#<br/></cfif>
																	</cfloop>
																</td>
																<td></td>
																<td></td>
															</cfif>
															<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(ABS(devir_total_sub))#</td> 
															<td>#session_base.money#</td>
															<td><cfif devir_borc_sub gt devir_alacak_sub><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_sub lt devir_alacak_sub><cf_get_lang dictionary_id='29684.A'></cfif></td>
															<cfif listfind(attributes.list_type,3)>
																<td  style="text-align:right;">#TLFormat(ABS(devir_total_2_sub))#</td>
																<td>#session_base.money2#</td>
																<td><cfif devir_borc_2_sub gt devir_alacak_2_sub><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_2_sub lt devir_alacak_2_sub><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif> 
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<td  style="text-align:right;">#TLFormat(ABS(devir_total_other_sub))#</td>
																<td>#attributes.other_money#</td>
																<td><cfif devir_borc_other_sub gt devir_alacak_other_sub><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_other_sub lt devir_alacak_other_sub><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
														</tr>										
													</cfif>
												</cfif>
												<!--- Hesap tipi bazlı gruplama PY--->
												<cfif isdefined("attributes.is_acc_type_group") and len(CARI_ROWS_ALL.ACC_TYPE_ID[currentrow]) and (CARI_ROWS_ALL.ACC_TYPE_ID[currentrow] neq CARI_ROWS_ALL.ACC_TYPE_ID[currentrow-1] or (attributes.page gt 1 and currentrow mod attributes.maxrows eq 1))>
													<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
														<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 8>
															<cfelse>
																<cfset colspan_info = 7>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 6>
															<cfelse>
																<cfset colspan_info = 5>
															</cfif>
														</cfif>
													<cfelse>
														<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 7>
															<cfelse>
																<cfset colspan_info = 6>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,5)>
																<cfset colspan_info = 5>
															<cfelse>
																<cfset colspan_info = 4>
															</cfif>
														</cfif>
													</cfif>
													<cfif len(acc_type_id) and acc_type_id neq 0>
														<cfset row_colspan = colspan_info+3>
														<cfif listfind(attributes.list_type,8)>
															<cfset row_colspan = row_colspan+1> 
														</cfif>
														<cfif listfind(attributes.list_type,2)>
															<cfset row_colspan = row_colspan+2> 
														</cfif>
														<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
															<cfset row_colspan = row_colspan+4> 
														</cfif>
														<cfif listfind(attributes.list_type,3)>
															<cfset row_colspan = row_colspan+1> 
														</cfif>
														<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
															<cfset row_colspan = row_colspan+1>
														</cfif>
														<tr height="20" <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
															<td colspan="#row_colspan#" class="txtbold">
															#getaccount_name.ACCOUNT_TYPE[listfind(acc_type_id_list,acc_type_id,',')]#  
															<cfelse>&nbsp;</td></cfif>
															</td>
														</tr>
													</td>
													<cfquery name="get_tarih_devir_acc" dbtype="query">
														SELECT
															SUM(BORC) BORC,
															SUM(ALACAK) ALACAK,
															SUM(BORC-ALACAK) DEVIR_TOTAL,
															SUM(BORC2) BORC2,
															SUM(ALACAK2) ALACAK2,
															SUM(BORC2-ALACAK2) DEVIR_TOTAL2
														FROM
															CARI_ROWS
														WHERE
															ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
															AND ACC_TYPE_ID = #CARI_ROWS_ALL.ACC_TYPE_ID#
													</cfquery>
													<cfquery name="get_tarih_devir_other_acc" dbtype="query">
														SELECT
															SUM(BORC_OTHER) BORC_OTHER,
															SUM(ALACAK_OTHER) ALACAK_OTHER,
															OTHER_MONEY
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																,SUM(BORC_OTHER-ALACAK_OTHER) DEVIR_TOTAL_OTHER
															</cfif>
														FROM
															CARI_ROWS
														WHERE
															ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<cfif attributes.other_money is 'YTL' or attributes.other_money is 'TL'>
																	AND (OTHER_MONEY = 'YTL' OR OTHER_MONEY = 'TL')
																<cfelse>
																	AND OTHER_MONEY = '#attributes.other_money#'
																</cfif>
															</cfif>
															AND ACC_TYPE_ID = #CARI_ROWS_ALL.ACC_TYPE_ID#
														GROUP BY
															OTHER_MONEY
													</cfquery>
													<cfif get_tarih_devir_acc.recordcount>
														<cfset devir_borc_acc = get_tarih_devir_acc.BORC>
														<cfset devir_alacak_acc = get_tarih_devir_acc.ALACAK>
														<cfset devir_borc_other_acc = get_tarih_devir_other_acc.BORC_OTHER>
														<cfset devir_alacak_other_acc = get_tarih_devir_other_acc.ALACAK_OTHER>
														<cfset devir_total_acc = get_tarih_devir_acc.DEVIR_TOTAL>
														<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
															<cfset devir_total_other_acc = get_tarih_devir_other_acc.DEVIR_TOTAL_OTHER>
														</cfif>
														<cfset devir_borc_2_acc = get_tarih_devir_acc.BORC2>
														<cfset devir_alacak_2_acc = get_tarih_devir_acc.ALACAK2>
														<cfset devir_total_2_acc = get_tarih_devir_acc.DEVIR_TOTAL2>
														
														<cfset gen_borc_top = gen_borc_top + get_tarih_devir_acc.BORC>
														<cfset gen_ala_top = gen_ala_top + get_tarih_devir_acc.ALACAK>
														<cfset gen_bak_top = gen_bak_top + (get_tarih_devir_acc.BORC-get_tarih_devir_acc.ALACAK)>
														<cfset gen_bak_top_other = gen_bak_top_other + (get_tarih_devir_other_acc.BORC_OTHER-get_tarih_devir_other_acc.ALACAK_OTHER)>
														<cfset gen_bak_top_2 = gen_bak_top_2 + (get_tarih_devir_acc.BORC2-get_tarih_devir_acc.ALACAK2)>
													</cfif>
													<cfif get_tarih_devir_other_acc.recordcount>
														<cfloop query="get_tarih_devir_other_acc">
															<cfset 'devir_borc_acc_#other_money#' = evaluate('devir_borc_acc_#other_money#') +borc_other>
															<cfset 'devir_alacak_acc_#other_money#' = evaluate('devir_alacak_acc_#other_money#') +alacak_other>
														</cfloop>
													</cfif>
													<cfif get_tarih_devir_acc.recordcount>
														<cfset arow_gen_borc_top = devir_borc_acc+arow_gen_borc_top>
														<cfset arow_gen_ala_top = devir_alacak_acc+arow_gen_ala_top>
														<cfset arow_gen_borc_top_2 = devir_borc_2_acc+arow_gen_borc_top_2>
														<cfset arow_gen_ala_top_2 = devir_alacak_2_acc+arow_gen_ala_top_2 >
														<cfset arow_gen_bak_top = (devir_borc_acc-devir_alacak_acc)+arow_gen_bak_top>	
														<cfset arow_gen_bak_top_2 = (devir_borc_2_acc-devir_alacak_2_acc)+arow_gen_bak_top_2>		
														<cfset arow_gen_bak_top_other = (devir_borc_other_acc-devir_alacak_other_acc)+arow_gen_bak_top_other>		 
														<tr  <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
															<td colspan="#colspan_info#" style="text-align:right;"><b><cf_get_lang dictionary_id='57864.Devir'></b></td>
															<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>
															<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_acc)#</td>
															<td>#session_base.money#</td>
															<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_acc)#</td>
															<td>#session_base.money#</td>
															<cfif listfind(attributes.list_type,2)>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_acc_2)#</td>
																<td>#session_base.money2#</td>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_acc_2)#</td>
																<td>#session_base.money2#</td>
															</cfif>	
															<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
																<td style="text-align:right;">
																	<cfloop query="get_money">
																		<cfif evaluate('devir_borc_acc_#get_money.money#') gt 0>#TLFormat(evaluate('devir_borc_acc_#get_money.money#'))# #get_money.money#<br/></cfif>
																	</cfloop>
																</td>
																<td style="text-align:right;">
																	<cfloop query="get_money">
																		<cfif evaluate('devir_alacak_acc_#get_money.money#') gt 0>#TLFormat(evaluate('devir_alacak_acc_#get_money.money#'))# #get_money.money#<br/></cfif>
																	</cfloop>
																</td>
																<td></td>
																<td></td>
															</cfif>
															<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(ABS(devir_total_acc))#</td> 
															<td>#session_base.money#</td>
															<td><cfif devir_borc_acc gt devir_alacak_acc><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_acc lt devir_alacak_acc><cf_get_lang dictionary_id='29684.A'></cfif></td>
															<cfif listfind(attributes.list_type,3)>
																<td  style="text-align:right;">#TLFormat(ABS(devir_total_2_acc))#</td>
																<td>#session_base.money2#</td>
																<td><cfif devir_borc_2_acc gt devir_alacak_2_acc><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_2_acc lt devir_alacak_2_acc><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif> 
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<td  style="text-align:right;">#TLFormat(ABS(devir_total_other_acc))#</td>
																<td>#attributes.other_money#</td>
																<td><cfif devir_borc_other_acc gt devir_alacak_other_acc><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_other_acc lt devir_alacak_other_acc><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
														</tr>										
													</cfif>
												</cfif>
												<tbody>
													
													<cfif DETAIL_TYPE eq 0>
														<tr <cfif isdefined("is_from_report")>class="css1"<cfelseif attributes.invoice_color eq 1>class="fatura_detay"</cfif>>
														<td>
															<cfif listfind(attributes.list_type,6)>
																<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#currentrow#</font>
															<cfelseif listfind(attributes.list_type,10)>
																#row_count#
															<cfelse>
																#currentrow#
															</cfif>
															<cfset row_count = row_count + 1>
														</td>
														<td>
															<cfif listfind(attributes.list_type,6)>
																<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#dateformat(action_date,dateformat_style)#</font>
															<cfelse>
																#dateformat(action_date,dateformat_style)#
															</cfif>
														</td>
														<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
															<cfif len(DUE_DATE)>
																<td>#dateformat(DUE_DATE,dateformat_style)#</td>
																<td>#datediff('d',ACTION_DATE,DUE_DATE)#</td>
															<cfelseif len(PAY_METHOD) and PAY_METHOD neq 0 and ListFind(pay_method_id_list,PAY_METHOD,',')>
																<td>#dateformat(date_add('d', listgetat(pay_method_gun_list,ListFind(pay_method_id_list,PAY_METHOD,','),','), action_date),dateformat_style)#</td>
																<td>#listgetat(pay_method_gun_list,ListFind(pay_method_id_list,PAY_METHOD,','),',')#</td>
															<cfelseif listfind(bank_order_list,ACTION_ID)>
																<td>#dateformat(GET_BANK_ORDER.PAYMENT_DATE[listfind(bank_order_list,ACTION_ID)],dateformat_style)#</td>
																<td>#datediff('d',ACTION_DATE,GET_BANK_ORDER.PAYMENT_DATE[listfind(bank_order_list,ACTION_ID)])#</td>					
															<cfelse>
																<td></td>
																<td></td>
															</cfif>
														</cfif> 
														<cfif listfind(attributes.list_type,5)><td><cfif len(project_id) and project_id neq 0>#get_project_name.project_head[listfind(project_id_list,project_id,',')]#<cfelse>&nbsp;</cfif></td></cfif>
														<td>
															<cfif listfind(attributes.list_type,6)>
																<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#paper_no#</font>
															<cfelse>
																#paper_no#
															</cfif>
														</td>
														<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
															<td>
																<cfif len(from_cmp_id)>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#from_cmp_id#','medium');">#get_company.FULLNAME[listfind(company_id_list,from_cmp_id,',')]#</a>
																<cfelseif len(to_cmp_id)>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#to_cmp_id#','medium');">#get_company.FULLNAME[listfind(company_id_list,to_cmp_id,',')]#</a>
																<cfelseif len(from_consumer_id)>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#from_consumer_id#','medium');">#get_consumer.CONSUMER_NAME[listfind(consumer_id_list,from_consumer_id,',')]# #get_consumer.CONSUMER_SURNAME[listfind(consumer_id_list,from_consumer_id,',')]#</a>
																<cfelseif len(to_consumer_id)>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#to_consumer_id#','medium');">#get_consumer.CONSUMER_NAME[listfind(consumer_id_list,to_consumer_id,',')]# #get_consumer.CONSUMER_SURNAME[listfind(consumer_id_list,to_consumer_id,',')]#</a>
																<cfelseif len(from_employee_id)>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#from_employee_id#','medium');">#get_employee.EMPLOYEE_NAME[listfind(employee_id_list,from_employee_id,',')]# #get_employee.EMPLOYEE_SURNAME[listfind(employee_id_list,from_employee_id,',')]#</a>
																<cfelseif len(to_employee_id)>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#to_employee_id#','medium');">#get_employee.EMPLOYEE_NAME[listfind(employee_id_list,to_employee_id,',')]# #get_employee.EMPLOYEE_SURNAME[listfind(employee_id_list,to_employee_id,',')]#</a>
																</cfif>
															</td>
														</cfif>
														<td>
															<cfif listfind('24,25,26,27,31,32,34,35,36,40,41,42,45,46,43,90,91,92,93,94,95,106,160,161',ACTION_TYPE_ID) and (not get_module_user(module))>
																<cfif listfind(attributes.list_type,7)><!--- İslem tipi secili ise --->
																	<cfif listfind(process_cat_id_list,process_cat,',')>
																		<cfif listfind(attributes.list_type,6)>
																			<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#</font>
																		<cfelse>
																			#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#
																		</cfif>
																	<cfelse>
																		<cfif listfind(attributes.list_type,6)>
																			<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
																		<cfelse>
																			#action_name#
																		</cfif>
																	</cfif>	
																<cfelse>
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
																	<cfelse>
																		#action_name#
																	</cfif>
																</cfif>
															<cfelseif not len(type)><!--- display sayfası olmayan tipler için --->
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
																<cfelse>
																	#action_name#
																</cfif>
															<cfelse>
																<cfif not isdefined("attributes.is_excel") and not isdefined("attributes.due_date_info")>
																	<cfif listfind("291,292",action_type_id)><!--- Kredi Odemesi ,Kredi Tahsilat --->
																		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#ACTION_ID#&period_id=#new_period#&our_company_id=#get_periods.our_company_id#','#page_type#');">
																	<cfelseif ACTION_TABLE is 'CHEQUE'> 
																		<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_cheque_det&ID=#ACTION_ID#&period_id=#new_period#','','ui-draggable-box-small')">
																	<cfelseif ACTION_TABLE is 'VOUCHER'> 
																		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&ID=#ACTION_ID#&period_id=#new_period#','small')">
																	<cfelseif ACTION_TABLE is 'EMPLOYEES_PUANTAJ' and ACTION_TYPE_ID eq 161> 
																		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_puantaj_act&type=1&ID=#CARI_ACTION_ID#','small')">
																	<cfelseif ACTION_TABLE is 'BUDGET_PLAN'> 
																		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_budget_plan&ID=#CARI_ACTION_ID#','small')">
																	<cfelse>
																		<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=#type#&ID=#ACTION_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>');">
																	</cfif>										
																</cfif>
																<cfif listfind(attributes.list_type,7)>
																	<cfif listfind(process_cat_id_list,process_cat,',')>
																		<cfif listfind(attributes.list_type,6)>
																			<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#</font>
																		<cfelse>
																			#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#
																		</cfif>
																	<cfelse>
																		<cfif listfind(attributes.list_type,6)>
																			<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
																		<cfelse>
																		#action_name#
																		</cfif>
																	</cfif>					
																<cfelse>
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
																	<cfelse>
																		#action_name#
																	</cfif>
																</cfif>
																<cfif not isdefined("attributes.is_excel")>
																	</a>
																</cfif>
															</cfif>
														</td>
														<cfif listfind(attributes.list_type,8)>
															<td>
																#action_detail#
																<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																	<cfif ACTION_TYPE_ID eq 250 and len(bank_order_list)>
																		(#dateformat(GET_BANK_ORDER.PAYMENT_DATE[listfind(bank_order_list,ACTION_ID)],dateformat_style)#)
																		<cfif IS_PROCESSED eq 1>(Havale Oluşturulmuş)</cfif>
																	</cfif>
																<cfelseif ACTION_TYPE_ID eq 250 and IS_PROCESSED eq 1>
																	(Havale Oluşturulmuş)
																</cfif>
															</td>	
														</cfif>
														<td style="text-align:right; mso-number-format:'0\.00';">
															<cfif listfind(attributes.list_type,6)>
																<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc)#</font>
															<cfelse>
																#TLFormat(borc)#
															</cfif>
														</td>
														<td>#session_base.money#</td>
														<td style="text-align:right; mso-number-format:'0\.00'">
															<cfif listfind(attributes.list_type,6)>
																<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak)#</font>
															<cfelse>
																#TLFormat(alacak)#
															</cfif>
														</td>
														<td>#session_base.money#</td>
														<cfif listfind(attributes.list_type,2)><!--- Dovizli secili --->
															<td style="text-align:right; mso-number-format:'0\.00'">
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc2)#</font>
																<cfelse>
																	#TLFormat(borc2)#
																</cfif>
															</td>
															<td>#session_base.money2#</td>
															<td style="text-align:right; mso-number-format:'0\.00'">
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak2)#</font>
																<cfelse>
																	#TLFormat(alacak2)#
																</cfif>
															</td>
															<td>#session_base.money2#</td>
														</cfif>
														<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)><!--- Dovizli secili --->	
															<td style="text-align:right; mso-number-format:'0\.00'">
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc_other)#</font>
																<cfelse>
																	#TLFormat(borc_other)#
																</cfif>
															</td>
															<td style="text-align:right; mso-number-format:'0\.00'">
																<cfif listfind(attributes.list_type,6)>
										
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak_other)#</font>
																<cfelse>
																	#TLFormat(alacak_other)#
																</cfif>
															</td>
															<td style="text-align:right;">
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#other_money#</font>
																<cfelse>
																	#other_money#
																</cfif>
															</td>
															<cfif (wrk_round(borc_other) gt 0 or wrk_round(alacak_other) gt 0)>
																<cfif borc_other gt 0>
																	<cfset other_tutar = borc_other>
																	<cfset tutar = borc>
																<cfelse>
																	<cfset other_tutar = alacak_other>
																	<cfset tutar = alacak>
																</cfif>
																<td style="text-align:right;">
																	<cfif other_money eq session.ep.money2>
																		<cfif len(rate2)><cfset new_rate = rate2><cfelse><cfset new_rate = tutar/other_tutar></cfif>
																	<cfelse>
																		<cfset new_rate = tutar/other_tutar>
																	</cfif>
																	<cfif other_money neq session.ep.money>
																		<cfif listfind(attributes.list_type,6)>
																			<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(new_rate,session.ep.our_company_info.rate_round_num)#</font>
																		<cfelse>
																			#TLFormat(new_rate,session.ep.our_company_info.rate_round_num)#
																		</cfif>
																	<cfelse>
																	&nbsp;
																	</cfif>
																</td>
															<cfelse>
																<td></td>
															</cfif>
														</cfif>
														<cfif (currentrow mod attributes.maxrows) eq 1 or (cari_rows_all.recordcount eq 1)>
															<cfset bakiye = devir_total + borc - alacak>
															<cfset bakiye_other = devir_total_other + borc_other - alacak_other>
															<cfset gen_borc_top = devir_borc + borc + gen_borc_top>
															<cfset gen_ala_top = devir_alacak + alacak + gen_ala_top>
															<cfif len(borc2) and len(alacak2)><cfset bakiye_2 = devir_total_2 + borc2 - alacak2></cfif>
															<cfif len(borc2)><cfset gen_borc_top_2 = devir_borc_2 + borc2 + gen_borc_top_2></cfif>
															<cfif len(alacak2)><cfset gen_ala_top_2 = devir_alacak_2 + alacak2 + gen_ala_top_2></cfif>
														<cfelse>
															<cfset bakiye = borc - alacak >
															<cfset bakiye_other = borc_other - alacak_other>
															<cfset gen_borc_top = borc + gen_borc_top>
															<cfset gen_ala_top = alacak + gen_ala_top>
															<cfif len(borc2) and len(alacak2)><cfset bakiye_2 = borc2 - alacak2></cfif>
															<cfif len(borc2)><cfset gen_borc_top_2 = borc2 + gen_borc_top_2></cfif>
															<cfif len(alacak2)><cfset gen_ala_top_2 = alacak2 + gen_ala_top_2></cfif>
														</cfif>
														<cfif isdefined("attributes.is_project_group")>
															<cfset row_gen_borc_top = row_gen_borc_top + borc>
															<cfset row_gen_ala_top = row_gen_ala_top + alacak>
															<cfset row_gen_borc_top_2 = row_gen_borc_top_2 + borc2>
															<cfset row_gen_ala_top_2 = row_gen_ala_top_2 + alacak2>
															<cfset row_gen_bak_top = row_gen_bak_top + (borc - alacak)>		
															<cfset row_gen_bak_top_2 = row_gen_bak_top_2 + (borc2 - alacak2)>		
															<cfset row_gen_bak_top_other = row_gen_bak_top_other + (borc_other - alacak_other)>		 
														</cfif>
														<cfif isdefined("attributes.is_subscription_group")>
															<cfset srow_gen_borc_top = srow_gen_borc_top + borc>
															<cfset srow_gen_ala_top = srow_gen_ala_top + alacak>
															<cfset srow_gen_borc_top_2 = srow_gen_borc_top_2 + borc2>
															<cfset srow_gen_ala_top_2 = srow_gen_ala_top_2 + alacak2>
															<cfset srow_gen_bak_top = srow_gen_bak_top + (borc - alacak)>	
															<cfset srow_gen_bak_top_2 = srow_gen_bak_top_2 + (borc2 - alacak2)>		
															<cfset srow_gen_bak_top_other = srow_gen_bak_top_other + (borc_other - alacak_other)>		 
														</cfif>
														<cfif isdefined("attributes.is_acc_type_group")>
															<cfset arow_gen_borc_top = arow_gen_borc_top + borc>
															<cfset arow_gen_ala_top = arow_gen_ala_top + alacak>
															<cfset arow_gen_borc_top_2 = arow_gen_borc_top_2 + borc2>
															<cfset arow_gen_ala_top_2 = arow_gen_ala_top_2 + alacak2>
															<cfset arow_gen_bak_top = arow_gen_bak_top + (borc - alacak)>		
															<cfset arow_gen_bak_top_2 = arow_gen_bak_top_2 + (borc2 - alacak2)>		
															<cfset arow_gen_bak_top_other = arow_gen_bak_top_other + (borc_other - alacak_other)>		 
														</cfif>
														<cfset gen_bak_top = bakiye + gen_bak_top>
														<cfset gen_bak_top_other = bakiye_other + gen_bak_top_other>
														<cfset gen_bak_top_2 = bakiye_2 + gen_bak_top_2>
													
														<cfif isdefined("attributes.is_project_group")>
															<td style="text-align:right; mso-number-format:'0\.00'">
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(row_gen_bak_top))#</font>
																<cfelse>
																	#TLFormat(abs(row_gen_bak_top))#
																</cfif>
															</td>
															<td>#session_base.money#</td>
															<td><cfif row_gen_bak_top gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															<cfif listfind(attributes.list_type,3)>
																<td style="text-align:right; mso-number-format:'0\.00'">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(row_gen_bak_top_2))#</font>
																	<cfelse>
																		#TLFormat(abs(row_gen_bak_top_2))#
																	</cfif>
																</td>
																<td>#session_base.money2#</td>
																<td><cfif row_gen_bak_top_2 gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<td style="text-align:right; mso-number-format:'0\.00'">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(row_gen_bak_top_other))#</font>
																	<cfelse>
																		#TLFormat(abs(row_gen_bak_top_other))#
																	</cfif>
																</td>
																<td style="text-align:right;">#attributes.other_money#</td>
																<td><cfif row_gen_bak_top_other gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
														<cfelseif isdefined("attributes.is_subscription_group")>
															<td style="text-align:right; mso-number-format:'0\.00'">
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(srow_gen_bak_top))#</font>
																<cfelse>
																	#TLFormat(abs(srow_gen_bak_top))#
																</cfif>
															</td>
															<td>#session_base.money#</td>
															<td><cfif srow_gen_bak_top gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															<cfif listfind(attributes.list_type,3)>
																<td style="text-align:right; mso-number-format:'0\.00'">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(srow_gen_bak_top_2))#</font>
																	<cfelse>
																		#TLFormat(abs(srow_gen_bak_top_2))#
																	</cfif>
																</td>
																<td>#session_base.money2#</td>
																<td><cfif srow_gen_bak_top_2 gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<td style="text-align:right; mso-number-format:'0\.00'">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(srow_gen_bak_top_other))#</font>
																	<cfelse>
																		#TLFormat(abs(srow_gen_bak_top_other))#
																	</cfif>
																</td>
																<td style="text-align:right;">#attributes.other_money#</td>
																<td><cfif srow_gen_bak_top_other gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
														<cfelseif isdefined("attributes.is_acc_type_group")>
															<td style="text-align:right; mso-number-format:'0\.00'">
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(arow_gen_bak_top))#</font>
																<cfelse>
																	#TLFormat(abs(arow_gen_bak_top))#
																</cfif>
															</td>
															<td>#session_base.money#</td>
															<td><cfif arow_gen_bak_top gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															<cfif listfind(attributes.list_type,3)>
																<td style="text-align:right; mso-number-format:'0\.00'">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(arow_gen_bak_top_2))#</font>
																	<cfelse>
																		#TLFormat(abs(arow_gen_bak_top_2))#
																	</cfif>
																</td>
																<td>#session_base.money2#</td>
																<td><cfif arow_gen_bak_top_2 gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<td style="text-align:right; mso-number-format:'0\.00'">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(arow_gen_bak_top_other))#</font>
																	<cfelse>
																		#TLFormat(abs(arow_gen_bak_top_other))#
																	</cfif>
																</td>
																<td style="text-align:right;">#attributes.other_money#</td>
																<td><cfif arow_gen_bak_top_other gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
														<cfelse>
															<td style="text-align:right; mso-number-format:'0\.00'">
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(gen_bak_top))#</font>
																<cfelse>
																	#TLFormat(abs(gen_bak_top))#
																</cfif>
															</td>
															<td>#session_base.money#</td>
															<td><cfif gen_bak_top gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															<cfif listfind(attributes.list_type,3)>
																<td  style="text-align:right;">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(gen_bak_top_2))#</font>
																	<cfelse>
																		#TLFormat(abs(gen_bak_top_2))#
																	</cfif>
																</td>
																<td>#session_base.money2#</td>
																<td><cfif gen_bak_top_2 gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<td style="text-align:right;">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(gen_bak_top_other))#</font>
																	<cfelse>
																		#TLFormat(abs(gen_bak_top_other))#
																	</cfif>
																</td>
																<td style="text-align:right;">#attributes.other_money#</td>
																<td><cfif gen_bak_top_other gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>	
														</cfif>
														<cfquery name="GETCLOSED" datasource="#dsn2#">
															SELECT SUM(ACTION_VALUE) ACTION_VALUE, SUM(CLOSED_AMOUNT) CLOSED_AMOUNT, SUM(OTHER_CLOSED_AMOUNT) OTHER_CLOSED_AMOUNT FROM CARI_CLOSED_ROW WHERE ACTION_ID = #action_id# AND ACTION_TYPE_ID = #action_type_id# AND CARI_ACTION_ID = #cari_action_id#
														</cfquery>
														<td class="text-center">
															<cfif len(borc) and borc gt 0>
																<cfset bakiye = borc>
															<cfelseif len(alacak) and alacak gt 0>
																<cfset bakiye = alacak>
															<cfelse>
																<cfset bakiye = 0>
															</cfif>
															<cfif getclosed.recordcount gt 0 and len(bakiye) and len(getclosed.closed_amount)>
																<cfif bakiye gt getclosed.closed_amount>
																	<i class="fa fa-check-circle" style="font-size:20px;color:##e3e327;" alt="Kısmi Kapama Yapıldı" title="Kısmi Kapama Yapıldı. İşlem Tutarı : #tlformat(bakiye)#. Kapama Tutarı : #tlformat(getclosed.closed_amount)#"></i>
																<cfelse>
																	<i class="fa fa-check-circle" style="font-size:20px;color:blue;" alt="Manuel Kapama Yapıldı" title="Manuel Kapama Yapıldı. İşlem Tutarı : #tlformat(bakiye)#. Kapama Tutarı : #tlformat(getclosed.closed_amount)#"></i>
																</cfif>
															<cfelse>
																<i class="fa fa-check-circle" style="font-size:20px;color:red;" alt="Manuel Kapatma Yapılmadı" title="Manuel Kapatma Yapılmadı."></i>
															</cfif>
														</td>
													</tr>
												<cfelseif DETAIL_TYPE neq 3>
													<cfif not isdefined("round_number") or not len(round_number)><cfset round_number = 2></cfif>
													<tr <cfif isdefined("is_from_report")>class="css1"<cfelse>class="nohover"</cfif>>
														<td <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>colspan="21"<cfelse>colspan="20"</cfif>>
																<thead>
																<cfif DETAIL_TYPE[currentrow-1] eq 0><!--- BAŞLIKLAR 1KERE OLUŞSN DİYE --->
																	<cfif DETAIL_TYPE eq 1><!--- fatura detaylı gösterim için --->
																		<cfset attributes.invoice_color=1>
																		<tr>
																			<th width="180"><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
																			<th width="150"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
																			<cfif isdefined("is_show_spect_name") and is_show_spect_name eq 1>
																				<th width="150"><cf_get_lang dictionary_id ='57647.Spec'></th>
																			</cfif>
																			<cfif isdefined("is_show_inv_ship") and is_show_inv_ship eq 1>
																				<th width="80"><cf_get_lang dictionary_id='57773.İrsaliye'></th>
																			</cfif>
																			<cfif isdefined("is_show_inv_order_no") and is_show_inv_order_no eq 1>
																				<th width="80"><cf_get_lang dictionary_id='57611.Sipariş'></th>
																			</cfif>
																			<cfif isdefined("is_show_inv_order_head") and is_show_inv_order_head eq 1>
																				<th width="80"><cf_get_lang dictionary_id='57611.Sipariş'> <cf_get_lang dictionary_id='57480.Konu'></th>
																			</cfif>
																			<th width="60" style="text-align:right;"><cf_get_lang dictionary_id ='57635.Miktar'></th>
																			<th width="80"><cf_get_lang dictionary_id ='57636.Birim'></th>
																			<th width="80" style="text-align:right;"><cf_get_lang dictionary_id ='57638.Birim Fiyat'></th>
																			<cfif listfind(attributes.list_type,1)>
																			<th width="120" style="text-align:right;"><cf_get_lang dictionary_id ='58169.İşlem Dövizi Fiyat'></th> 
																		</cfif>
																			<th width="30"></th>
																			<th width="40" style="text-align:right;"><cf_get_lang dictionary_id ='57639.KDV'></th>
																			<th width="40" style="text-align:right;"><cf_get_lang dictionary_id ='34128.KDV li Birim Fiyat'></th>
																			<cfif isdefined("is_show_discount") and is_show_discount eq 1>
																				<cfloop from="1" to="#discount_count#" index="dis_indx">
																					<th width="50" style="text-align:right;">ISK #dis_indx#</th>
																				</cfloop>
																			</cfif>
																			<th width="100" style="text-align:right;"><cf_get_lang dictionary_id ='58170.Satır Toplamı'></th>
																			<cfif listfind(attributes.list_type,1)>
																			<th width="120" style="text-align:right;"><cf_get_lang dictionary_id ='58171.İşlem Dövizi Toplam'></th>
																			</cfif>
																		</tr>
																	<cfelseif DETAIL_TYPE eq 2><!--- masraf fişi detaylı gösterim için --->
																		<tr <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-list"</cfif>>
																			<th width="100"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
																			<th width="150"><cfif ACTION_TYPE_ID eq 121><cf_get_lang dictionary_id ='58172.Gelir Merkezi'><cfelse><cf_get_lang dictionary_id ='58460.Masraf Merkezi'></cfif></th>
																			<th width="150"><cfif ACTION_TYPE_ID eq 121><cf_get_lang dictionary_id ='58173.Gelir Kalemi'><cfelse><cf_get_lang dictionary_id ='58551.Gider Kalemi'></cfif></th>
																			<th width="150"><cf_get_lang dictionary_id ='57416.Proje'></th>
																			<th width="40" style="text-align:right;"><cf_get_lang dictionary_id ='57635.Miktar'></th>
																			<th width="90" style="text-align:right;"><cf_get_lang dictionary_id ='57673.Tutar'></th>
																			<th width="40" style="text-align:right;"><cf_get_lang dictionary_id ='57639.KDV'></th>
																			<th width="40" style="text-align:right;"><cf_get_lang dictionary_id ='58021.ÖTV'></th>
																			<th width="90" style="text-align:right;"><cf_get_lang dictionary_id ='58170.Satır Toplam'></th>
																			<th width="100" style="text-align:right;"><cf_get_lang dictionary_id ='58124.Döviz Toplam'></th>
																		</tr>
																	</cfif>
																</cfif>
																</thead>
																<tbody>
																	<cfif DETAIL_TYPE eq 1><!--- fatura detaylı gösterim için --->
																		<tr>
																			<td width="180">#stock_code#</td>
																			<td width="150">#name_product#</td>
																			<cfif isdefined("is_show_spect_name") and is_show_spect_name eq 1>
																				<td width="150"><cfif SPECT_VAR_NAME neq NAME_PRODUCT>#spect_var_name#<cfelse>&nbsp;&nbsp;</cfif></td>	
																			</cfif>
																			<cfif isdefined("is_show_inv_ship") and is_show_inv_ship eq 1>
																				<td width="80">
																					<cfif len(wrk_row_id_list) and listfind(main_ship_wrk_list,inv_wrk_row_rel_id,',')>
																						#get_rel_ship.ship_number[listfind(main_ship_wrk_list,inv_wrk_row_rel_id,',')]#
																					<cfelseif len(wrk_id_list) and listfind(main_ship_wrk_list_2,inv_wrk_row_id,',')>
																						#get_rel_ship_2.ship_number[listfind(main_ship_wrk_list_2,inv_wrk_row_id,',')]#
																					</cfif>															</td>
																			</cfif>
																			<cfif isdefined("is_show_inv_order_no") and is_show_inv_order_no eq 1>
																				<td width="80">
																					<cfif len(wrk_row_id_list)>
																						#get_rel_order.order_number[listfind(main_order_wrk_list,inv_wrk_row_rel_id,',')]#
																					</cfif>															</td>
																			</cfif>
																			<cfif isdefined("is_show_inv_order_head") and is_show_inv_order_head eq 1>
																				<td width="80">
																					<cfif len(wrk_row_id_list)>
																						#get_rel_order.order_head[listfind(main_order_wrk_list,inv_wrk_row_rel_id,',')]#
																					</cfif>															</td>
																			</cfif>
																			<td width="60"   style="text-align:right;">#AMOUNT#</td>
																			<td width="80">#UNIT# </td>
																			
																			<td width="80" style="text-align:right;">#TLFormat(PRICE,round_number)#</td>
																			<cfif listfind(attributes.list_type,1)>
																			<td width="120" style="text-align:right;">#TLFormat(PRICE_OTHER,round_number)#</td>
																			</cfif>
																			<td width="80" style="text-align:right;">#ROW_MONEY#</td>
																			<td width="40" style="text-align:right;">#TAX#</td>
																			<cfset tax_price = PRICE+(PRICE*TAX/100)>
																			<td width="40" style="text-align:right;">#TLFormat(tax_price,round_number)#</td>
																			<cfif isdefined("is_show_discount") and is_show_discount eq 1>
																				<cfloop from="1" to="#discount_count#" index="dis_indx">
																					<td width="50" style="text-align:right;"><cfif len(evaluate("DISCOUNT#dis_indx#"))>#tlformat(evaluate("DISCOUNT#dis_indx#"),round_number)#</cfif></td>
																				</cfloop>
																			</cfif>
																			<td width="100" style="text-align:right;">#TLFormat(GROSSTOTAL,round_number)#</td>
																			<cfif listfind(attributes.list_type,1)>
																			<td width="120" style="text-align:right;">#TLFormat(OTHER_MONEY_GROSS_TOTAL,round_number)#</td>
																			</cfif>
																		</tr>
																	<cfelseif DETAIL_TYPE eq 2><!--- masraf fişi detaylı gösterim için --->
																		<tr>
																			<td width="100">#exp_detail#</td>
																			<td width="150">#expense_center#</td>
																			<td width="150">#expense_item_name#</td>
																			<td width="150"><cfif len(row_project_id)>#get_project_name_row.project_head[listfind(row_project_id_list,row_project_id,',')]#<cfelse>&nbsp;</cfif></td>
																			<td width="40" style="text-align:right;">#amount#</td>
																			<td width="90" style="text-align:right;">#TLFormat(price,round_number)#</td>
																			<td width="40" style="text-align:right;">#tax#</td>
																			<td width="40" style="text-align:right;">#otv_rate#</td>
																			<td width="90" style="text-align:right;">#TLFormat(grosstotal,round_number)#</td>
																			<td width="100" style="text-align:right;">#TLFormat(other_money_gross_total,round_number)# #row_money#</td>
																		</tr>
																	</cfif>
																</tbody>
														</td>
													</tr>
												</cfif>
												<cfif isdefined("attributes.is_project_group") and ((CARI_ROWS_ALL.PROJECT_ID[currentrow] neq CARI_ROWS_ALL.PROJECT_ID[currentrow+1]) or currentrow/attributes.page eq attributes.maxrows)>
													<tr height="20" <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
														<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 8>
																<cfelse>
																	<cfset colspan_info = 7>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 6>
																<cfelse>
																	<cfset colspan_info = 5>
																</cfif>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 7>
																<cfelse>
																	<cfset colspan_info = 6>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 5>
																<cfelse>
																	<cfset colspan_info = 4>
																</cfif>
															</cfif>
														</cfif>
														<td colspan="#colspan_info#" style="text-align:right;"><cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id ='57492.Toplam'></td>
														<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>	
														<td style="text-align:right;">#TLFormat(row_gen_borc_top)#</td>
														<td>#session_base.money#</td>
														<td style="text-align:right;">#TLFormat(row_gen_ala_top)#</td>
														<td>#session_base.money#</td>
														<cfif listfind(attributes.list_type,2)>
															<td style="text-align:right;">#TLFormat(row_gen_borc_top_2)#</td>
															<td>#session_base.money2#</td>
															<td style="text-align:right;">#TLFormat(row_gen_ala_top_2)#</td>
															<td>#session_base.money2#</td>
														</cfif>
														<cfif listfind(attributes.list_type,1) or  listfind(attributes.list_type,9)>
															<td style="width:125px;text-align:right;">
																<cfloop query="get_money">
																<cfset toplam_ara_2 = 0>
																<cfif len(row_money_list_borc_2)>
																	<cfloop list="#row_money_list_borc_2#" index="i">
																		<cfset tutar_ = listfirst(i,';')>
																		<cfset money_ = listgetat(i,2,';')>
																		<cfif money_ eq money>
																		<cfset toplam_ara_2 = toplam_ara_2 + tutar_>
																		</cfif>
																	</cfloop> 
																</cfif>
																<cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_borc_pro_#money#')>
																<cfif toplam_ara_2 neq 0>
																	#TLFormat(ABS(toplam_ara_2))# #money#<br/>
																</cfif>
																</cfloop>  
															</td>
															<td style="width:125px;text-align:right;">
																<cfloop query="get_money">
																<cfset toplam_ara_2 = 0>
																<cfif len(row_money_list_alacak_2)>
																	<cfloop list="#row_money_list_alacak_2#" index="i">
																		<cfset tutar_ = listfirst(i,';')>
																		<cfset money_ = listgetat(i,2,';')>
																		<cfif money_ eq money>
																		<cfset toplam_ara_2 = toplam_ara_2 + tutar_>
																		</cfif>
																</cfloop> 
																</cfif>
																<cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_alacak_pro_#money#') >
																<cfif toplam_ara_2 neq 0>
																	#TLFormat(ABS(toplam_ara_2))# #money#<br/>
																</cfif>
																</cfloop>  
															</td>
															<td>&nbsp;</td><td>&nbsp;</td>
														</cfif>
														<td style="text-align:right; mso-number-format:'0\.00'"> 
															#TLFormat(abs(row_gen_bak_top))#
														</td>
														<td>#session_base.money#</td>
														<td><cfif row_gen_bak_top gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
														<cfif listfind(attributes.list_type,3)>
															<td style="text-align:right;"> 
																#TLFormat(abs(row_gen_bak_top_2))#
															</td>
															<td>#session_base.money2#</td>
															<td><cfif row_gen_bak_top_2 gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
														</cfif>
														<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
															<td style="text-align:right;">
																#TLFormat(abs(row_gen_bak_top_other))#
															</td>
															<td style="text-align:right;">#attributes.other_money#</td>
															<td><cfif row_gen_bak_top_other gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
														</cfif>
													</tr>
													<cfset row_gen_borc_top = 0>	
													<cfset row_gen_ala_top = 0>	
													<cfset row_gen_borc_top_2 = 0>		
													<cfset row_gen_ala_top_2 = 0>		
													<cfset row_gen_bak_top = 0>		
													<cfset row_gen_bak_top_2 = 0>		
													<cfset row_gen_bak_top_other = 0>		
													<cfset row_money_list_borc_2 = ''>
													<cfset row_money_list_borc_1 = ''>
													<cfset row_money_list_alacak_2 = ''>
													<cfset row_money_list_alacak_1 = ''>
													<cfloop query="get_money">
														<cfset 'devir_borc_pro_#money#' = 0>
														<cfset 'devir_alacak_pro_#money#' = 0>
													</cfloop>
												</cfif>
												<!--- Abone bazlı gruplama PY--->
												<cfif isdefined("attributes.is_subscription_group") and ((CARI_ROWS_ALL.SUBSCRIPTION_ID[currentrow] neq CARI_ROWS_ALL.SUBSCRIPTION_ID[currentrow+1]) or currentrow/attributes.page eq attributes.maxrows)>
													<tr height="20" <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
														<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 8>
																<cfelse>
																	<cfset colspan_info = 7>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 6>
																<cfelse>
																	<cfset colspan_info = 5>
																</cfif>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 7>
																<cfelse>
																	<cfset colspan_info = 6>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 5>
																<cfelse>
																	<cfset colspan_info = 4>
																</cfif>
															</cfif>
														</cfif>
														<td colspan="#colspan_info#" style="text-align:right;"><cf_get_lang dictionary_id="58832.Abone"> <cf_get_lang dictionary_id="57492.Toplam"></td>
														<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>	
														<td style="text-align:right;">#TLFormat(srow_gen_borc_top)#</td>
														<td>#session_base.money#</td>
														<td style="text-align:right;">#TLFormat(srow_gen_ala_top)#</td>
														<td>#session_base.money#</td>
														<cfif listfind(attributes.list_type,2)>
															<td style="text-align:right;">#TLFormat(srow_gen_borc_top_2)#</td>
															<td>#session_base.money2#</td>
															<td style="text-align:right;">#TLFormat(srow_gen_ala_top_2)#</td>
															<td>#session_base.money2#</td>
														</cfif>
														<cfif listfind(attributes.list_type,1) or  listfind(attributes.list_type,9)>
															<td style="width:125px;text-align:right;">
																<cfloop query="get_money">
																<cfset toplam_ara_2 = 0>
																<cfif len(row_money_list_borc_2)>
																	<cfloop list="#row_money_list_borc_2#" index="i">
																		<cfset tutar_ = listfirst(i,';')>
																		<cfset money_ = listgetat(i,2,';')>
																		<cfif money_ eq money>
																		<cfset toplam_ara_2 = toplam_ara_2 + tutar_>
																		</cfif>
																	</cfloop> 
																</cfif>
																<cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_borc_sub_#money#')>
																<cfif toplam_ara_2 neq 0>
																	#TLFormat(ABS(toplam_ara_2))# #money#<br/>
																</cfif>
																</cfloop>  
															</td>
															<td style="width:125px;text-align:right;">
																<cfloop query="get_money">
																<cfset toplam_ara_2 = 0>
																<cfif len(row_money_list_alacak_2)>
																	<cfloop list="#row_money_list_alacak_2#" index="i">
																		<cfset tutar_ = listfirst(i,';')>
																		<cfset money_ = listgetat(i,2,';')>
																		<cfif money_ eq money>
																		<cfset toplam_ara_2 = toplam_ara_2 + tutar_>
																		</cfif>
																</cfloop> 
																</cfif>
																<cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_alacak_sub_#money#') >
																<cfif toplam_ara_2 neq 0>
																	#TLFormat(ABS(toplam_ara_2))# #money#<br/>
																</cfif>
																</cfloop>  
															</td>
															<td>&nbsp;</td><td>&nbsp;</td>
														</cfif>
														<td style="text-align:right; mso-number-format:'0\.00'"> 
															#TLFormat(abs(srow_gen_bak_top))#
														</td>
														<td>#session_base.money#</td>
														<td><cfif srow_gen_bak_top gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
														<cfif listfind(attributes.list_type,3)>
															<td style="text-align:right;"> 
																#TLFormat(abs(srow_gen_bak_top_2))#
															</td>
															<td>#session_base.money2#</td>
															<td><cfif srow_gen_bak_top_2 gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
														</cfif>
														<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
															<td style="text-align:right;">
																#TLFormat(abs(srow_gen_bak_top_other))#
															</td>
															<td style="text-align:right;">#attributes.other_money#</td>
															<td><cfif srow_gen_bak_top_other gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
														</cfif>
													</tr>
													<cfset srow_gen_borc_top = 0>	
													<cfset srow_gen_ala_top = 0>	
													<cfset srow_gen_borc_top_2 = 0>		
													<cfset srow_gen_ala_top_2 = 0>		
													<cfset srow_gen_bak_top = 0>		
													<cfset srow_gen_bak_top_2 = 0>		
													<cfset srow_gen_bak_top_other = 0>		
													<cfset row_money_list_borc_2 = ''>
													<cfset row_money_list_borc_1 = ''>
													<cfset row_money_list_alacak_2 = ''>
													<cfset row_money_list_alacak_1 = ''>
													<cfloop query="get_money">
														<cfset 'devir_borc_sub_#money#' = 0>
														<cfset 'devir_alacak_sub_#money#' = 0>
													</cfloop>
												</cfif>
												<!--- Hesap tipi bazlı gruplama PY--->
												<cfif isdefined("attributes.is_acc_type_group") and ((CARI_ROWS_ALL.ACC_TYPE_ID[currentrow] neq CARI_ROWS_ALL.ACC_TYPE_ID[currentrow+1]) or currentrow/attributes.page eq attributes.maxrows)>
													<tr height="20" <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
														<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 8>
																<cfelse>
																	<cfset colspan_info = 7>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 6>
																<cfelse>
																	<cfset colspan_info = 5>
																</cfif>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 7>
																<cfelse>
																	<cfset colspan_info = 6>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 5>
																<cfelse>
																	<cfset colspan_info = 4>
																</cfif>
															</cfif>
														</cfif>
														<td colspan="#colspan_info#" style="text-align:right;"><cf_get_lang dictionary_id="40546.Hesap tipi"> <cf_get_lang dictionary_id="57492.Toplam"></td>
														<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>	
														<td style="text-align:right;">#TLFormat(arow_gen_borc_top)#</td>
														<td>#session_base.money#</td>
														<td style="text-align:right;">#TLFormat(arow_gen_ala_top)#</td>
														<td>#session_base.money#</td>
														<cfif listfind(attributes.list_type,2)>
															<td style="text-align:right;">#TLFormat(arow_gen_borc_top_2)#</td>
															<td>#session_base.money2#</td>
															<td style="text-align:right;">#TLFormat(arow_gen_ala_top_2)#</td>
															<td>#session_base.money2#</td>
														</cfif>
														<cfif listfind(attributes.list_type,1) or  listfind(attributes.list_type,9)>
															<td style="width:125px;text-align:right;">
																<cfloop query="get_money">
																<cfset toplam_ara_2 = 0>
																<cfif len(row_money_list_borc_2)>
																	<cfloop list="#row_money_list_borc_2#" index="i">
																		<cfset tutar_ = listfirst(i,';')>
																		<cfset money_ = listgetat(i,2,';')>
																		<cfif money_ eq money>
																		<cfset toplam_ara_2 = toplam_ara_2 + tutar_>
																		</cfif>
																	</cfloop> 
																</cfif>
																<cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_borc_acc_#money#')>
																<cfif toplam_ara_2 neq 0>
																	#TLFormat(ABS(toplam_ara_2))# #money#<br/>
																</cfif>
																</cfloop>  
															</td>
															<td style="width:125px;text-align:right;">
																<cfloop query="get_money">
																<cfset toplam_ara_2 = 0>
																<cfif len(row_money_list_alacak_2)>
																	<cfloop list="#row_money_list_alacak_2#" index="i">
																		<cfset tutar_ = listfirst(i,';')>
																		<cfset money_ = listgetat(i,2,';')>
																		<cfif money_ eq money>
																		<cfset toplam_ara_2 = toplam_ara_2 + tutar_>
																		</cfif>
																</cfloop> 
																</cfif>
																<cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_alacak_acc_#money#') >
																<cfif toplam_ara_2 neq 0>
																	#TLFormat(ABS(toplam_ara_2))# #money#<br/>
																</cfif>
																</cfloop>  
															</td>
															<td>&nbsp;</td><td>&nbsp;</td>
														</cfif>
														<td style="text-align:right; mso-number-format:'0\.00'"> 
															#TLFormat(abs(arow_gen_bak_top))#
														</td>
														<td>#session_base.money#</td>
														<td><cfif arow_gen_bak_top gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
														<cfif listfind(attributes.list_type,3)>
															<td style="text-align:right;"> 
																#TLFormat(abs(arow_gen_bak_top_2))#
															</td>
															<td>#session_base.money2#</td>
															<td><cfif arow_gen_bak_top_2 gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
														</cfif>
														<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
															<td style="text-align:right;">
																#TLFormat(abs(arow_gen_bak_top_other))#
															</td>
															<td style="text-align:right;">#attributes.other_money#</td>
															<td><cfif arow_gen_bak_top_other gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
														</cfif>
													</tr>
													<cfset arow_gen_borc_top = 0>	
													<cfset arow_gen_ala_top = 0>	
													<cfset arow_gen_borc_top_2 = 0>		
													<cfset arow_gen_ala_top_2 = 0>		
													<cfset arow_gen_bak_top = 0>		
													<cfset arow_gen_bak_top_2 = 0>		
													<cfset arow_gen_bak_top_other = 0>		
													<cfset row_money_list_borc_2 = ''>
													<cfset row_money_list_borc_1 = ''>
													<cfset row_money_list_alacak_2 = ''>
													<cfset row_money_list_alacak_1 = ''>
													<cfloop query="get_money">
														<cfset 'devir_borc_acc_#money#' = 0>
														<cfset 'devir_alacak_acc_#money#' = 0>
													</cfloop>
												</cfif>
											</cfoutput>
											</tbody>	 
										<cfelse>
											<tbody>
												<tr>
													<td colspan="24" class="color-row" height="20"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
												</tr>
											</tbody>  	       
										</cfif>

										<tfoot>	<!--genel toplam kısmı-->
											
											<tr style="height: 50px;">
												<th></th>
												<th></th>
												<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
												<th></th>
												<th></th>
												</cfif>
												<cfif listfind(attributes.list_type,5)><th ></th></cfif>
												<th></th>
												<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
													<th></th>
												</cfif>
												<th><b><cf_get_lang dictionary_id='57680.Genel Toplam'></b></th>
												<cfif listfind(attributes.list_type,8)></cfif>
													<th style="text-align:right;"><b><cf_get_lang dictionary_id='57587.Borç'>:<cfoutput>#TLFormat(gen_borc_top)# </cfoutput></b></th>
													<th width="30"><b><cfoutput>#session_base.money#</cfoutput></b></th>
													<th style="text-align:right; "><b><cf_get_lang dictionary_id='57588.Alacak'>:<cfoutput>#TLFormat(gen_ala_top)# </cfoutput></b></th>
													<th width="30"><b><cfoutput>#session_base.money#</cfoutput></b></th>
												<cfif listfind(attributes.list_type,2)>		
													<th style="text-align:right; "><b>2.<cf_get_lang dictionary_id='57587.Borç'>:<cfoutput>#TLFormat(gen_borc_top_2)# </cfoutput></b></th>
													<th width="30" ><b><cfoutput>#session_base.money2#</cfoutput></b></th>
													<th style="text-align:right; "><b>2.<cf_get_lang dictionary_id='57588.Alacak'>:<cfoutput>#TLFormat(gen_ala_top_2)# </cfoutput></b></th>
													<th width="30" ><b><cfoutput>#session_base.money2#</cfoutput></b></th>
												</cfif>
												<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>	
													<th style="text-align:right; "><b><cf_get_lang dictionary_id='57862.İşlem Dövizi Borç'>:<cfoutput query="get_money">
														<cfset toplam_ara_2 = 0>
														<cfif len(money_list_borc_2)>
															<cfloop list="#money_list_borc_2#" index="i">
																<cfset tutar_ = listfirst(i,';')>
																<cfset money_ = listgetat(i,2,';')>
																<cfif money_ eq money>
																<cfset toplam_ara_2 = toplam_ara_2 + tutar_>
																</cfif>
															</cfloop> 
														</cfif>
														<cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_borc_#money#')>
														<cfif toplam_ara_2 neq 0>
															#TLFormat(ABS(toplam_ara_2))# #money#<br/>
														</cfif>
														</cfoutput></b>
													</th>
													<th style="text-align:right; "><b><cf_get_lang dictionary_id='57863.İşlem Dövizi Alacak'>:<cfoutput query="get_money">
														<cfset toplam_ara_2 = 0>
														<cfif len(money_list_alacak_2)>
															<cfloop list="#money_list_alacak_2#" index="i">
																<cfset tutar_ = listfirst(i,';')>
																<cfset money_ = listgetat(i,2,';')>
																<cfif money_ eq money>
																<cfset toplam_ara_2 = toplam_ara_2 + tutar_>
																</cfif>
														</cfloop> 
														</cfif>
														<cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_alacak_#money#') >
														<cfif toplam_ara_2 neq 0>
															#TLFormat(ABS(toplam_ara_2))# #money#<br/>
														</cfif>
														</cfoutput></b></th>
													<th style="text-align:right; "></th>
													<th style="text-align:right; "></th>
												</cfif>
												<th style="text-align:right; "><b><cf_get_lang dictionary_id='57589.Bakiye'>:
													<cfoutput>#TLFormat(abs(gen_bak_top))# </cfoutput></b>
												</th>
												<th width="30" ><b><cfoutput>#session_base.money#</cfoutput></b></th>
												<th><b><cf_get_lang dictionary_id='29683.B/A'>: <cfif gen_bak_top gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></b></th>
												<cfif listfind(attributes.list_type,3)>
													<th width="100" style="text-align:right; "> <b>2.<cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id='57589.Bakiye'>:<cfoutput>#TLFormat(abs(gen_bak_top_2))# </cfoutput></b> </th>
													<th width="30" ><b><cfoutput>#session_base.money2#</cfoutput></b></th>
													<th><b><cf_get_lang dictionary_id='29683.B/A'>: <cfif gen_bak_top_2 gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></b></th>
												</cfif>
												<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
													<th width="100" style="text-align:right;"> <b><cf_get_lang dictionary_id='58121.İşlem Dövizi'> <cf_get_lang dictionary_id='57589.Bakiye'>:<cfoutput>#TLFormat(abs(gen_bak_top_other))# </cfoutput></b> </th>
													<th width="30" ><b><cfoutput>#attributes.other_money#</cfoutput></b></th>
													<th><b><cf_get_lang dictionary_id='29683.B/A'>:</b> <cfif gen_bak_top_other gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></b></th>
												</cfif>
												<th></th>
											</tr>
										</tfoot>
								</cf_grid_list>
								<cfif CARI_ROWS_ALL.recordcount>
									<div class="ui-info-bottom flex-end ">
										<div class="ui-row "> 
											<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
												<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
													<cfif listfind(attributes.list_type,5)>
														<cfset colspan_info = 8>
													<cfelse>
														<cfset colspan_info = 7>
													</cfif>
												<cfelse>
													<cfif listfind(attributes.list_type,5)>
														<cfset colspan_info = 6>
													<cfelse>
														<cfset colspan_info = 5>
													</cfif>
												</cfif>
											<cfelse>
												<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
													<cfif listfind(attributes.list_type,5)>
														<cfset colspan_info = 7>
													<cfelse>
														<cfset colspan_info = 6>
													</cfif>
												<cfelse>
													<cfif listfind(attributes.list_type,5)>
														<cfset colspan_info = 5>
													<cfelse>
														<cfset colspan_info = 4>
													</cfif>
												</cfif>
											</cfif>
										</div>
									</div>
								</cfif>
								<cfif listfind(attributes.list_type,1)>
									<cf_grid_list>
										<thead>
											<tr>
												<th nowrap="nowrap"><cf_get_lang dictionary_id ='58121.İşlem Dövizi'></th>
												<th width="33%" style="text-align:right;"><cf_get_lang dictionary_id ='57862.İşlem Dövizi Borç'></th>
												<th width="33%" style="text-align:right;"><cf_get_lang dictionary_id ='57863.İşlem Dövizi Alacak'></th>
												<th width="33%" style="text-align:right;"><cf_get_lang dictionary_id ='58174.İşlem Dövizi Bakiye'></th>
											</tr>
										</thead>
										<tbody>
										<cfquery name="get_money_list" datasource="#dsn#">
											SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #new_period# AND MONEY_STATUS=1
										</cfquery>
										<cfoutput query="get_money_list">
											<tr class="color-row">
												<td class="txtbold" style="width:60px;">#money#</td>
												<cfset toplam_borc_2 = 0>
												<cfif len(money_list_borc_2)>
													<cfloop list="#money_list_borc_2#" index="i">
														<cfset tutar_ = listfirst(i,';')>
														<cfset money_ = listgetat(i,2,';')>
														<cfif money_ eq money>
														<cfset toplam_borc_2 = toplam_borc_2 + tutar_>
														</cfif>
													</cfloop> 
												</cfif>
												<cfset toplam_borc_2 = toplam_borc_2 + evaluate('devir_borc_#money#')>
												<td style="text-align:right;">#TLFormat(abs(toplam_borc_2))# #money#</td>
												<cfset toplam_ala_2 = 0>
												<cfif len(money_list_alacak_2)>
													<cfloop list="#money_list_alacak_2#" index="i">
														<cfset tutar_ = listfirst(i,';')>
														<cfset money_ = listgetat(i,2,';')>
														<cfif money_ eq money>
														<cfset toplam_ala_2 = toplam_ala_2 + tutar_>
														</cfif>
												</cfloop> 
												</cfif>
												<cfset toplam_ala_2 = toplam_ala_2 + evaluate('devir_alacak_#money#') >
												<td style="text-align:right;">#TLFormat(abs(toplam_ala_2))# #money#</td>
												<td style="text-align:right;">#TLFormat(abs(toplam_borc_2 - toplam_ala_2))# #money#<cfif toplam_borc_2 gte toplam_ala_2>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
											</tr>
										</cfoutput>
										</tbody>
									</cf_grid_list>
								</cfif>
							</div>
						</cfif>
					</cfloop>
					<!--- carinin ilişkili üyeleri çekiliyor --->
					<cfif isdefined('is_rel_mem')>
						<cfquery name="get_related" dbtype="query">
							SELECT * FROM get_related_companies WHERE REL_COMP_ID = #attributes.company_id#
						</cfquery>
						<!--- ilişkili üyelerin ekstreleri dökülüyor --->
						<cfloop query="get_related">
							<cfif len(company_id)>
								<cfset attributes.company_id=company_id>
								<cfset member_type = 'partner'>
							<cfelse>
								<cfset attributes.company_id=''>
							</cfif>
							<cfif len(consumer_id)>
								<cfset attributes.consumer_id=consumer_id>
								<cfset member_type = 'consumer'>
							<cfelse>
								<cfset attributes.consumer_id=''>
							</cfif>
							<cfif len(employee_id)>
								<cfset attributes.employee_id=employee_id>
								<cfset member_type = 'employee'>
							<cfelse>
								<cfset attributes.employee_id=''>
							</cfif>
							<cfset attributes.company=replace(fullname,"&"," ","all")>
							<cfloop query="get_periods">
								<cfif get_periods.period_year lt year(now())>
									<cfset new_date = createodbcdatetime('31/12/#get_periods.period_year#')>
								<cfelseif attributes.date2 lt now()>
									<cfset new_date = attributes.date2>
								<cfelse>
									<cfset new_date = now()>
								</cfif>
								<cfset new_period = get_periods.period_id>
								<cfset new_dsn = '#dsn#_#get_periods.PERIOD_YEAR#_#get_periods.OUR_COMPANY_ID#'>
								<cfif isdefined('attributes.form_submit')>
									<cfif listfind(attributes.list_type,4)>
										<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
											SELECT PAYMETHOD_ID,DUE_DAY,DUE_MONTH FROM SETUP_PAYMETHOD ORDER BY PAYMETHOD_ID
										</cfquery>
										<cfset pay_method_id_list = ''>
										<cfset pay_method_gun_list = ''>
										<cfoutput query="GET_PAYMETHOD">
											<cfif len(DUE_DAY)>
												<cfset pay_method_id_list = listappend(pay_method_id_list,PAYMETHOD_ID,',')>
												<cfset pay_method_gun_list = listappend(pay_method_gun_list,DUE_DAY,',')>
											<cfelseif len(DUE_MONTH)>
												<cfset pay_method_id_list = listappend(pay_method_id_list,PAYMETHOD_ID,',')>
												<cfset pay_method_gun_list = listappend(pay_method_gun_list,(DUE_MONTH*30)/2,',')>
											</cfif>
										</cfoutput>
									</cfif>
									<cfinclude template="../query/get_extre.cfm">
								<cfelse>
									<cfset CARI_ROWS_ALL.recordcount = 0>
								</cfif>
								<cfif isdefined('attributes.is_excel') or isdefined("is_ajax") or get_periods.recordcount neq 1 or (isdefined("attributes.is_collacted") and attributes.is_collacted eq 1) or (listfind(attributes.list_type,10))>
									<cfset attributes.startrow=1>
									<cfset attributes.maxrows=CARI_ROWS_ALL.recordcount>
								</cfif>
								<cfparam name="attributes.page" default = "1">
								<cfparam name="attributes.totalrecords" default = "#CARI_ROWS_ALL.recordcount#">
								<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
								<cfif (isdefined("attributes.is_bakiye") and CARI_ROWS_ALL.recordcount gt 0) or not isdefined("attributes.is_bakiye")>
									<cf_grid_list>
										<thead>
											<tr>
												<th colspan="17" style="text-align:left; padding:3px 15px 12px 2px;">
													<cfoutput><cfif len(get_related.member_code)>(#get_related.member_code#) </cfif> <cfif isdefined ('attributes.company') and len(attributes.comp_name)>#attributes.company# </cfif> #session.ep.company# #get_periods.period_year#&nbsp;<cf_get_lang dictionary_id='57860.Dönemi Hesap Ekstresi'>
														<cfif is_show_member_address eq 1 and not isdefined("show_member_address")>
															#get_related.address# #get_related.semt# <cfif len(get_related.county_name)>&nbsp;&nbsp;&nbsp;#get_related.county_name#</cfif> <cfif len(get_related.city_name)> / #get_related.city_name#</cfif> <cfif len(get_related.country_name)> - #get_related.country_name#</cfif>
														</cfif>
														#get_related.telefon# &nbsp;&nbsp;&nbsp;  #Evaluate('start_#PERIOD_YEAR#')# - #Evaluate('finish_#PERIOD_YEAR#')#
													</cfoutput>
												</th>
											</tr>
										</thead>
									</cf_grid_list>
									<cfif listfind(attributes.list_type,9) and not (isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name))>
										<cfinclude template="dsp_extre_summary.cfm">
									</cfif>	
									<cf_grid_list>
										<thead>	
											<tr>
												<th><cf_get_lang dictionary_id='57487.No'></th>
												<th><cf_get_lang dictionary_id='57742.Tarih'></th>
												<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
												<th><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
												<th><cf_get_lang dictionary_id='57490.Gün'></th>
												</cfif>
												<cfif listfind(attributes.list_type,5)><th><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
												<th><cf_get_lang dictionary_id='57468.Belge'></th>
												<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
													<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
												</cfif>
												<th><cf_get_lang dictionary_id='57692.İşlem'></th>
												<cfif listfind(attributes.list_type,8)><th><cf_get_lang dictionary_id='57629.Açıklama'></th></cfif>
												<th style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></th>
												<th width="30"></th>
												<th style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></th>
												<th width="30"></th>
												<cfif listfind(attributes.list_type,2)>		
												<th style="text-align:right;">2.<cf_get_lang dictionary_id='57587.Borç'></th>
												<th width="30"></th>
												<th style="text-align:right;">2.<cf_get_lang dictionary_id='57588.Alacak'></th>
												<th width="30"></th>
												</cfif>
												<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>	
												<th style="text-align:right;"><cf_get_lang dictionary_id='57862.İşlem Dövizi Borç'></th>
												<th style="text-align:right;"><cf_get_lang dictionary_id='57863.İşlem Dövizi Alacak'></th>
												<th style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></th>
												<th style="text-align:right;"><cf_get_lang dictionary_id='57648.Kur'></th>
												</cfif>
												<th style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></th>
												<th width="30"></th>
												<th><cf_get_lang dictionary_id='29683.B/A'></th>
												<cfif listfind(attributes.list_type,3)>
													<th width="100" style="text-align:right;">2.<cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id='57589.Bakiye'></th>
													<th width="30"></th>
													<th><cf_get_lang dictionary_id='29683.B/A'></th>
												</cfif>
												<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
													<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'> <cf_get_lang dictionary_id='57589.Bakiye'></th>
													<th width="30"></th>
													<th><cf_get_lang dictionary_id='29683.B/A'></th>
												</cfif>
											</tr>
										</thead>
											<cfset money_list_borc_2 = ''>
											<cfset money_list_borc_1 = ''>
											<cfset money_list_alacak_2 = ''>
											<cfset money_list_alacak_1 = ''>
											<cfset row_money_list_borc_2 = ''>
											<cfset row_money_list_borc_1 = ''>
											<cfset row_money_list_alacak_2 = ''>
											<cfset row_money_list_alacak_1 = ''>
											<cfscript>
												devir_total = 0;
												devir_total_other = 0;
												devir_borc = 0;
												devir_alacak = 0;
												devir_borc_other = 0;
												devir_alacak_other = 0;
												bakiye = 0;
												other_bakiye = 0;
												devir_total_2 = 0;
												devir_borc_2 = 0;
												devir_alacak_2 = 0;
												bakiye_2 = 0;
												gen_borc_top = 0;
												gen_ala_top = 0;
												gen_bak_top = 0;
												gen_bak_top_other = 0;
												gen_bak_top_2 = 0;
												gen_borc_top_2 = 0;
												gen_ala_top_2 = 0;
												gen_borc_top_other = 0;
												gen_ala_top_other = 0;
												
												devir_total_pro = 0;
												devir_total_other_pro = 0;
												devir_borc_pro = 0;
												devir_alacak_pro= 0;
												devir_borc_other_pro = 0;
												devir_alacak_other_pro= 0;
												row_bakiye = 0;
												row_other_bakiye = 0;
												devir_total_pro_2 = 0;
												devir_borc_pro_2 = 0;
												devir_alacak_pro_2 = 0;

												row_bakiye_2 = 0;
												row_gen_borc_top = 0;
												row_gen_ala_top = 0;
												row_gen_bak_top = 0;
												row_gen_bak_top_other = 0;
												row_gen_bak_top_2 = 0;
												row_gen_borc_top_2 = 0;
												row_gen_ala_top_2 = 0;
												row_gen_borc_top_other = 0;
												row_gen_ala_top_other = 0;
												// subscription 
												srow_bakiye_2 = 0;
												srow_gen_borc_top = 0;
												srow_gen_ala_top = 0;
												srow_gen_bak_top = 0;
												srow_gen_bak_top_other = 0;
												srow_gen_bak_top_2 = 0;
												srow_gen_borc_top_2 = 0;
												srow_gen_ala_top_2 = 0;
												srow_gen_borc_top_other = 0;
												srow_gen_ala_top_other = 0;
												// acc_type_id
												arow_bakiye_2 = 0;
												arow_gen_borc_top = 0;
												arow_gen_ala_top = 0;
												arow_gen_bak_top = 0;
												arow_gen_bak_top_other = 0;
												arow_gen_bak_top_2 = 0;
												arow_gen_borc_top_2 = 0;
												arow_gen_ala_top_2 = 0;
												arow_gen_borc_top_other = 0;
												arow_gen_ala_top_other = 0;
											</cfscript>
											<cfoutput query="get_money">
												<cfset 'devir_borc_#money#' = 0>
												<cfset 'devir_alacak_#money#' = 0>
											</cfoutput>
											<cfloop query="get_money">
												<cfset 'devir_borc_pro_#money#' = 0>
												<cfset 'devir_alacak_pro_#money#' = 0>
											</cfloop>
											<cfif datediff('d',yilbasi,date1) neq 0>
												<cfquery name="GET_TARIH_DEVIR" dbtype="query">
													SELECT
														SUM(BORC) BORC,
														SUM(ALACAK) ALACAK,
														SUM(BORC-ALACAK) DEVIR_TOTAL,
														SUM(BORC2) BORC2,
														SUM(ALACAK2) ALACAK2,
														SUM(BORC2-ALACAK2) DEVIR_TOTAL2
													FROM
														CARI_ROWS
													WHERE
														ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
														<cfif isdefined("attributes.is_project_group")>
															AND PROJECT_ID = 0
														</cfif>
												</cfquery>
												<cfquery name="GET_TARIH_DEVIR_OTHER" dbtype="query">
													SELECT
														SUM(BORC_OTHER) BORC_OTHER,
														SUM(ALACAK_OTHER) ALACAK_OTHER,
														OTHER_MONEY
														<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
															,SUM(BORC_OTHER-ALACAK_OTHER) DEVIR_TOTAL_OTHER
														</cfif>
													FROM
														CARI_ROWS
													WHERE
														ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
														<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
															<cfif attributes.other_money is 'YTL' or attributes.other_money is 'TL'>
																AND (OTHER_MONEY = 'YTL' OR OTHER_MONEY = 'TL')
															<cfelse>
																AND OTHER_MONEY = '#attributes.other_money#'
															</cfif>
														</cfif>
														<cfif isdefined("attributes.is_project_group")>
															AND PROJECT_ID = 0
														</cfif>
													GROUP BY
														OTHER_MONEY
												</cfquery>
												<cfif get_tarih_devir.recordcount>
													<cfset devir_borc = get_tarih_devir.BORC>
													<cfset devir_alacak = get_tarih_devir.ALACAK>
													<cfset devir_borc_other = get_tarih_devir_other.BORC_OTHER>
													<cfset devir_alacak_other = get_tarih_devir_other.ALACAK_OTHER>
													<cfset devir_total = get_tarih_devir.DEVIR_TOTAL>
													<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
														<cfset devir_total_other = get_tarih_devir_other.DEVIR_TOTAL_OTHER>
													</cfif>
													<cfset devir_borc_2 = get_tarih_devir.BORC2>
													<cfset devir_alacak_2 = get_tarih_devir.ALACAK2>
													<cfset devir_total_2 = get_tarih_devir.DEVIR_TOTAL2>
													<cfset row_gen_borc_top = devir_borc+row_gen_borc_top>
													<cfset row_gen_ala_top = devir_alacak+row_gen_ala_top>
													<cfset row_gen_borc_top_2 = devir_borc_2+row_gen_borc_top_2>
													<cfset row_gen_ala_top_2 = devir_alacak_2+row_gen_ala_top_2 >
													<cfset row_gen_bak_top = (devir_borc-devir_alacak)+row_gen_bak_top>	
													<cfset row_gen_bak_top_2 = (devir_borc_2-devir_alacak_2)+row_gen_bak_top_2>		
													<cfset row_gen_bak_top_other = (devir_borc_other-devir_alacak_other)+row_gen_bak_top_other>	
												</cfif>
												<cfif get_tarih_devir_other.recordcount>
													<cfoutput query="get_tarih_devir_other">
														<cfset 'devir_borc_#other_money#' = evaluate('devir_borc_#other_money#') +borc_other>
														<cfset 'devir_alacak_#other_money#' = evaluate('devir_alacak_#other_money#') +alacak_other>
													</cfoutput>
												</cfif>
											</cfif>
											<cfif attributes.page gt 1>
												<cfset max_=(attributes.page-1)*attributes.maxrows>
												<cfoutput query="CARI_ROWS_ALL" startrow="1" maxrows="#max_#">
													<cfset devir_borc = devir_borc + borc>
													<cfset devir_alacak = devir_alacak + alacak>
													<cfset devir_borc_other = devir_borc_other + borc_other>
													<cfset devir_alacak_other = devir_alacak_other + alacak_other>
													<cfset devir_total = devir_borc - devir_alacak>
													<cfset devir_total_other = devir_borc_other - devir_alacak_other>
													<cfif len(borc2)><cfset devir_borc_2 = devir_borc_2 + borc2></cfif>
													<cfif len(alacak2)><cfset devir_alacak_2 = devir_alacak_2 + alacak2></cfif>
													<cfset devir_total_2 = devir_borc_2 - devir_alacak_2>
													<cfset 'devir_borc_#other_money#' = evaluate('devir_borc_#other_money#') +borc_other>
													<cfset 'devir_alacak_#other_money#' = evaluate('devir_alacak_#other_money#') +alacak_other>
												</cfoutput>
											</cfif>
											<cfif devir_borc neq 0 or devir_alacak neq 0>
												<cfoutput>
													<tr <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
														<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 9>
																<cfelse>
																	<cfset colspan_info = 8>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 7>
																<cfelse>
																	<cfset colspan_info = 6>
																</cfif>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 7>
																<cfelse>
																	<cfset colspan_info = 6>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 5>
																<cfelse>
																	<cfset colspan_info = 4>
																</cfif>
															</cfif>
														</cfif>
														<td colspan="#colspan_info#"  style="text-align:right;"><b><cf_get_lang dictionary_id='57864.Devir'></b></td>
														<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>
														<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc)#</td>
														<td>#session_base.money#</td>
														<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak)#</td>
														<td>#session_base.money#</td>
														<cfif listfind(attributes.list_type,2)>
															<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_2)#</td>
															<td>#session_base.money2#</td>
															<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_2)#</td>
															<td>#session_base.money2#</td>
														</cfif>	
														<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
															<td style="text-align:right;">
																<cfloop query="get_money">
																	<cfif evaluate('devir_borc_#get_money.money#') gt 0>#TLFormat(evaluate('devir_borc_#get_money.money#'))#<br/></cfif>
																</cfloop>
															</td>
															<td style="text-align:right;">
																<cfloop query="get_money">
																	<cfif evaluate('devir_alacak_#get_money.money#') gt 0>#TLFormat(evaluate('devir_alacak_#get_money.money#'))#<br/></cfif>
																</cfloop>
															</td>
															<td style="text-align:right;"><cfloop query="get_money"><cfif evaluate('devir_borc_#get_money.money#') gt 0>#get_money.money#<br/></cfif></cfloop></td>
															<td style="text-align:right;">
																<cfloop query="get_money">
																	<cfif evaluate('devir_alacak_#get_money.money#') gt 0>#get_money.money#<br/></cfif>
																</cfloop>
															</td>
															<!---
															<td></td>
															<td></td>
															--->
														</cfif>
														<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(ABS(devir_total))#</td>
														<td>#session_base.money#</td>
														<td><cfif devir_borc gt devir_alacak><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc lt devir_alacak><cf_get_lang dictionary_id='29684.A'></cfif></td>
														<cfif listfind(attributes.list_type,3)>
															<td  style="text-align:right;">#TLFormat(ABS(devir_total_2))#</td>
															<td>#session_base.money2#</td>
															<td><cfif devir_borc_2 gt devir_alacak_2><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_2 lt devir_alacak_2><cf_get_lang dictionary_id='29684.A'></cfif></td>
														</cfif> 
														<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
															<td  style="text-align:right;">#TLFormat(ABS(devir_total_other))#</td>
															<td>#attributes.other_money#</td>
															<td><cfif devir_borc_other gt devir_alacak_other><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_other lt devir_alacak_other><cf_get_lang dictionary_id='29684.A'></cfif></td>
														</cfif>
													</tr>
												</cfoutput>
											</cfif>
											<cfif CARI_ROWS_ALL.recordcount>
												<cfset bank_order_list="">
												<cfset company_id_list="">
												<cfset consumer_id_list="">
												<cfset employee_id_list="">
												<cfset row_count = 1>
												<cfset process_cat_id_list = ''>
												<cfset project_id_list = "">
												<cfset row_project_id_list = "">
												<cfset wrk_row_id_list = ''>
												<cfset wrk_id_list = ''>
												<cfoutput query="CARI_ROWS_ALL" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
													<cfif (CARI_ROWS_ALL.ACTION_TYPE_ID eq 250)>
														<cfset bank_order_list=listappend(bank_order_list,CARI_ROWS_ALL.ACTION_ID)>
													</cfif>
													<cfif len(from_cmp_id) and not listfind(company_id_list,from_cmp_id)>
														<cfset company_id_list=listappend(company_id_list,from_cmp_id)>
													</cfif>	
													<cfif len(to_cmp_id) and not listfind(company_id_list,to_cmp_id)>
														<cfset company_id_list=listappend(company_id_list,to_cmp_id)>
													</cfif>
													<cfif len(from_consumer_id) and not listfind(consumer_id_list,from_consumer_id)>
														<cfset consumer_id_list=listappend(consumer_id_list,from_consumer_id)>
													</cfif>	
													<cfif len(to_consumer_id) and not listfind(consumer_id_list,to_consumer_id)>
														<cfset consumer_id_list=listappend(consumer_id_list,to_consumer_id)>
													</cfif>
													<cfif len(from_employee_id) and not listfind(employee_id_list,from_employee_id)>
														<cfset employee_id_list=listappend(employee_id_list,from_employee_id)>
													</cfif>	
													<cfif len(to_employee_id) and not listfind(employee_id_list,to_employee_id)>
														<cfset employee_id_list=listappend(employee_id_list,to_employee_id)>
													</cfif>				
													<cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
														<cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
													</cfif>
													<cfif len(project_id) and project_id neq 0 and not listfind(project_id_list,project_id)>
														<cfset project_id_list = Listappend(project_id_list,project_id)>
													</cfif>
													<cfif len(row_project_id) and row_project_id neq 0 and not listfind(row_project_id_list,row_project_id)>
														<cfset row_project_id_list = Listappend(row_project_id_list,row_project_id)>
													</cfif>
													<cfif len(inv_wrk_row_rel_id) and not listfind(wrk_row_id_list,inv_wrk_row_rel_id)>
														<cfset wrk_row_id_list=listappend(wrk_row_id_list,"'#inv_wrk_row_rel_id#'")>
													</cfif>
													<cfif len(inv_wrk_row_id) and not listfind(wrk_id_list,inv_wrk_row_id)>
														<cfset wrk_id_list=listappend(wrk_id_list,"'#inv_wrk_row_id#'")>
													</cfif>
												</cfoutput>
												<cfset wrk_row_id_list=listsort(listdeleteduplicates(wrk_row_id_list,','),'text','ASC',',')>
												<cfset wrk_id_list=listsort(listdeleteduplicates(wrk_id_list,','),'text','ASC',',')>
												<cfif listlen(wrk_id_list)>
													<cfquery name="get_rel_ship_2" datasource="#DSN2#">
														SELECT
															SHIP_NUMBER,
															WRK_ROW_RELATION_ID
														FROM 
															SHIP S,
															SHIP_ROW SR
														WHERE
															S.SHIP_ID = SR.SHIP_ID
															AND SR.WRK_ROW_RELATION_ID IS NOT NULL
															AND SR.WRK_ROW_RELATION_ID IN (#PreserveSingleQuotes(wrk_id_list)#)
														ORDER BY
															WRK_ROW_RELATION_ID
													</cfquery>
													<cfset main_ship_wrk_list_2 = listsort(listdeleteduplicates(valuelist(get_rel_ship_2.WRK_ROW_RELATION_ID,',')),'text','ASC',',')>
												</cfif>
												<cfif listlen(wrk_row_id_list)>
													<cfquery name="get_rel_ship" datasource="#DSN2#">
														SELECT
															SHIP_NUMBER,
															WRK_ROW_ID
														FROM 
															SHIP S,
															SHIP_ROW SR
														WHERE
															S.SHIP_ID = SR.SHIP_ID
															AND SR.WRK_ROW_ID IS NOT NULL
															AND SR.WRK_ROW_ID IN (#PreserveSingleQuotes(wrk_row_id_list)#)
														ORDER BY
															WRK_ROW_ID
													</cfquery>
													<cfset main_ship_wrk_list = listsort(listdeleteduplicates(valuelist(get_rel_ship.WRK_ROW_ID,',')),'text','ASC',',')>
													<cfquery name="get_rel_order" datasource="#DSN2#">
														SELECT
															ORDER_NUMBER,
															ORDER_HEAD,
															WRK_ROW_ID
														FROM
														(
															SELECT
																O.ORDER_NUMBER,
																O.ORDER_HEAD,
																SR.WRK_ROW_ID
															FROM 
																SHIP S,
																SHIP_ROW SR,
																#dsn3_alias#.ORDERS O,
																#dsn3_alias#.ORDER_ROW ORR
															WHERE
																S.SHIP_ID = SR.SHIP_ID
																AND O.ORDER_ID = ORR.ORDER_ID
																AND SR.WRK_ROW_RELATION_ID IS NOT NULL
																AND SR.WRK_ROW_ID IS NOT NULL
																AND ORR.WRK_ROW_ID IS NOT NULL 
																AND SR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID
																AND SR.WRK_ROW_ID IN (#PreserveSingleQuotes(wrk_row_id_list)#)
															UNION
															SELECT
																O.ORDER_NUMBER,
																O.ORDER_HEAD,
																ORR.WRK_ROW_ID
															FROM 
																#dsn3_alias#.ORDERS O,
																#dsn3_alias#.ORDER_ROW ORR
															WHERE
																O.ORDER_ID = ORR.ORDER_ID
																AND ORR.WRK_ROW_ID IS NOT NULL 
																AND ORR.WRK_ROW_ID IN (#PreserveSingleQuotes(wrk_row_id_list)#)
														)T1
														ORDER BY
															WRK_ROW_ID
													</cfquery>
													<cfset main_order_wrk_list = listsort(listdeleteduplicates(valuelist(get_rel_order.WRK_ROW_ID,',')),'text','ASC',',')>
												</cfif>
												<cfif len(bank_order_list)>
													<cfset bank_order_list=listsort(bank_order_list,"numeric","desc",",")>
													<cfquery name="GET_BANK_ORDER" datasource="#new_dsn#">
														SELECT 
															BANK_ORDER_ID,
															PAYMENT_DATE
														FROM
															BANK_ORDERS
														WHERE
															BANK_ORDER_ID IN (#bank_order_list#)
														ORDER BY
															BANK_ORDER_ID DESC
													</cfquery>
												</cfif>
												<cfif len(company_id_list)>
													<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
													<cfquery name="GET_COMPANY" datasource="#DSN#">
														SELECT FULLNAME	FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
													</cfquery>
												</cfif>
												<cfif len(consumer_id_list)>
													<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
													<cfquery name="GET_CONSUMER" datasource="#DSN#">
														SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
													</cfquery>
												</cfif>
												<cfif len(employee_id_list)>
													<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
													<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
														SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
													</cfquery>
												</cfif>
												<cfif len(process_cat_id_list)>
													<cfset process_cat_id_list=listsort(process_cat_id_list,"numeric","ASC",",")>			
													<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
														SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY PROCESS_CAT_ID
													</cfquery>
													<cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat.PROCESS_CAT_ID,',')),'numeric','ASC',',')>
												</cfif>
												<cfif len(project_id_list)>
													<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>			
													<cfquery name="get_project_name" datasource="#dsn#">
														SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
													</cfquery>
													<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
												</cfif>
												<cfif len(row_project_id_list)>
													<cfset row_project_id_list=listsort(row_project_id_list,"numeric","ASC",",")>			
													<cfquery name="get_project_name_row" datasource="#dsn#">
														SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list#) ORDER BY PROJECT_ID
													</cfquery>
													<cfset row_project_id_list = listsort(listdeleteduplicates(valuelist(get_project_name_row.project_id,',')),'numeric','ASC',',')>
												</cfif>
												<cfoutput query="CARI_ROWS_ALL" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
													<cfif len(borc_other)>
														<cfset bakiye_borc_2 = borc_other>
														<cfset bakiye_borc_1 = borc>
													<cfelse>
														<cfset bakiye_borc_2 = 0>
														<cfset bakiye_borc_1 = 0>
													</cfif>
													<cfif len(alacak_other)>
														<cfset bakiye_alacak_2 = alacak_other>
														<cfset bakiye_alacak_1 = alacak>
													<cfelse>
														<cfset bakiye_alacak_2 = 0>
														<cfset bakiye_alacak_1 = 0>
													</cfif>
													<cfset money_2 = other_money>
													<cfset money_1 = session_base.money>
													<cfif bakiye_borc_2 gt 0>
														<cfset money_list_borc_2 = listappend(money_list_borc_2,'#bakiye_borc_2#;#money_2#',',')>
														<cfset money_list_borc_1 = listappend(money_list_borc_1,'#bakiye_borc_1#;#money_1#',',')>
														<cfset row_money_list_borc_2 = listappend(row_money_list_borc_2,'#bakiye_borc_2#;#money_2#',',')>
														<cfset row_money_list_borc_1 = listappend(row_money_list_borc_1,'#bakiye_borc_1#;#money_1#',',')>
													</cfif>	
													<cfif bakiye_alacak_2 gt 0>
														<cfset money_list_alacak_2 = listappend(money_list_alacak_2,'#bakiye_alacak_2#;#money_2#',',')>
														<cfset money_list_alacak_1 = listappend(money_list_alacak_1,'#bakiye_alacak_1#;#money_1#',',')>
														<cfset row_money_list_alacak_2 = listappend(row_money_list_alacak_2,'#bakiye_alacak_2#;#money_2#',',')>
														<cfset row_money_list_alacak_1 = listappend(row_money_list_alacak_1,'#bakiye_alacak_1#;#money_1#',',')>
													</cfif>
													<cfset type="">
													<cfswitch expression = "#ACTION_TYPE_ID#">
														<cfcase value="24"><cfset type="objects.popup_dsp_gelenh&period_id=#new_period#"></cfcase>
														<cfcase value="25"><cfset type="objects.popup_dsp_gidenh&period_id=#new_period#"></cfcase>
														<cfcase value="26,27"><cfset type="objects.popup_check_preview"></cfcase>
														<cfcase value="31"><cfset type="objects.popup_dsp_cash_revenue&period_id=#new_period#"></cfcase>
														<cfcase value="32"><cfset type="objects.popup_dsp_cash_payment&period_id=#new_period#"></cfcase>
														<cfcase value=34><cfset type="objects.popup_dsp_alisf_kapa"></cfcase><!---alış f. kapama--->
														<cfcase value=35><cfset type="objects.popup_dsp_satisf_kapa"></cfcase><!---satış f. kapama--->
														<cfcase value="40"><cfset type="objects.popup_dsp_account_open&period_id=#new_period#"></cfcase>
														<cfcase value="43"><cfset type="objects.popup_cari_action&period_id=#new_period#"></cfcase>
														<cfcase value="41,42,45,46"><cfset type="objects.popup_print_upd_debit_claim_note&period_id=#new_period#"></cfcase>
														<cfcase value="90,106"><cfset type="objects.popup_dsp_payroll_entry&period_id=#new_period#"></cfcase>
														<cfcase value="91"><cfset type="objects.popup_dsp_payroll_endorsement&period_id=#new_period#"></cfcase>
														<cfcase value="94"><cfset type="objects.popup_dsp_payroll_endor_return&period_id=#new_period#"></cfcase>
														<cfcase value="95"><cfset type="objects.popup_dsp_payroll_entry_return&period_id=#new_period#"></cfcase>
														<cfcase value="97,98,101,108"><cfset type="objects.popup_dsp_voucher_payroll_action&period_id=#new_period#"></cfcase>
														<cfcase value="131"><cfset type="objects.popup_dsp_collacted_dekont"></cfcase>
														<cfcase value="160,161"><cfset type="objects.popup_detail_budget_plan"></cfcase> 
														<cfcase value="241,245"><cfset type="objects.popup_dsp_credit_card_payment_type"></cfcase>
														<cfcase value="242"><cfset type="objects.popup_dsp_credit_card_payment"></cfcase>
														<cfcase value="251,250"><cfset type="objects.popup_dsp_assign_order&period_id=#new_period#"></cfcase>
														<cfcase value="120,121"><cfset type="objects.popup_list_cost_expense&period_id=#new_period#"></cfcase>
														<cfcase value="291,292"><cfset type="objects.popup_dsp_credit_payment"></cfcase>
														<cfcase value="293,294"><cfset type="objects.popup_dsp_stockbond_purchase"></cfcase>
														<cfcase value="48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691,532,5311">
															<cfif isdefined("invoice_partner_link")>
																<cfset type = invoice_partner_link>
															<cfelse>
																<cfset type="objects.popup_detail_invoice&period_id=#new_period#">
															</cfif>
														</cfcase>
														<cfdefaultcase><cfset type=""></cfdefaultcase>
													</cfswitch>
													<cfif listfind('24,25,26,27,31,32,34,35,36,43,241,242,245,177,250,251,131',ACTION_TYPE_ID,',')>
														<cfset page_type = 'small'>
													<cfelseif listfind('120,121,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691,532,5311',ACTION_TYPE_ID,',')>
														<cfset page_type = 'wide'>
													<cfelse>
														<cfset page_type = 'page'>
													</cfif>
													<cfif isdefined("attributes.is_project_group") and len(CARI_ROWS_ALL.PROJECT_ID[currentrow]) and CARI_ROWS_ALL.PROJECT_ID[currentrow] gt 0 and (CARI_ROWS_ALL.PROJECT_ID[currentrow] neq CARI_ROWS_ALL.PROJECT_ID[currentrow-1] or (attributes.page gt 1 and currentrow mod attributes.maxrows eq 1))>
														<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 8>
																<cfelse>
																	<cfset colspan_info = 7>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 6>
																<cfelse>
																	<cfset colspan_info = 5>
																</cfif>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 7>
																<cfelse>
																	<cfset colspan_info = 6>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 5>
																<cfelse>
																	<cfset colspan_info = 4>
																</cfif>
															</cfif>
														</cfif>
														<cfif len(project_id) and project_id neq 0>
															<cfset row_colspan = colspan_info+3>
															<cfif listfind(attributes.list_type,8)>
																<cfset row_colspan = row_colspan+1> 
															</cfif>
															<cfif listfind(attributes.list_type,2)>
																<cfset row_colspan = row_colspan+2> 
															</cfif>
															<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
																<cfset row_colspan = row_colspan+4> 
															</cfif>
															<cfif listfind(attributes.list_type,3)>
																<cfset row_colspan = row_colspan+1> 
															</cfif>
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<cfset row_colspan = row_colspan+1>
															</cfif>
															<tr height="20" <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
																<td colspan="#row_colspan#" class="txtbold">
																#get_project_name.project_head[listfind(project_id_list,project_id,',')]#<cfelse>&nbsp;</td></cfif>
																</td>
															</tr>
														</td>
														<cfquery name="get_tarih_devir_pro" dbtype="query">
															SELECT
																SUM(BORC) BORC,
																SUM(ALACAK) ALACAK,
																SUM(BORC-ALACAK) DEVIR_TOTAL,
																SUM(BORC2) BORC2,
																SUM(ALACAK2) ALACAK2,
																SUM(BORC2-ALACAK2) DEVIR_TOTAL2
															FROM
																CARI_ROWS
															WHERE
																ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
																AND PROJECT_ID = #CARI_ROWS_ALL.PROJECT_ID#
														</cfquery>
														<cfquery name="get_tarih_devir_other_pro" dbtype="query">
															SELECT
																SUM(BORC_OTHER) BORC_OTHER,
																SUM(ALACAK_OTHER) ALACAK_OTHER,
																OTHER_MONEY
																<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																	,SUM(BORC_OTHER-ALACAK_OTHER) DEVIR_TOTAL_OTHER
																</cfif>
															FROM
																CARI_ROWS
															WHERE
																ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
																<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																	<cfif attributes.other_money is 'YTL' or attributes.other_money is 'TL'>
																		AND (OTHER_MONEY = 'YTL' OR OTHER_MONEY = 'TL')
																	<cfelse>
																		AND OTHER_MONEY = '#attributes.other_money#'
																	</cfif>
																</cfif>
																AND PROJECT_ID = #CARI_ROWS_ALL.PROJECT_ID#
															GROUP BY
																OTHER_MONEY
														</cfquery>
														<cfif get_tarih_devir_pro.recordcount>
															<cfset devir_borc_pro = get_tarih_devir_pro.BORC>
															<cfset devir_alacak_pro = get_tarih_devir_pro.ALACAK>
															<cfset devir_borc_other_pro = get_tarih_devir_other_pro.BORC_OTHER>
															<cfset devir_alacak_other_pro = get_tarih_devir_other_pro.ALACAK_OTHER>
															<cfset devir_total_pro = get_tarih_devir_pro.DEVIR_TOTAL>
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<cfset devir_total_other_pro = get_tarih_devir_other_pro.DEVIR_TOTAL_OTHER>
															</cfif>
															<cfset devir_borc_2_pro = get_tarih_devir_pro.BORC2>
															<cfset devir_alacak_2_pro = get_tarih_devir_pro.ALACAK2>
															<cfset devir_total_2_pro = get_tarih_devir_pro.DEVIR_TOTAL2>
															
															<cfset gen_borc_top = gen_borc_top + get_tarih_devir_pro.BORC>
															<cfset gen_ala_top = gen_ala_top + get_tarih_devir_pro.ALACAK>
															<cfset gen_bak_top = gen_bak_top + (get_tarih_devir_pro.BORC-get_tarih_devir_pro.ALACAK)>
															<cfset gen_bak_top_other = gen_bak_top_other + (get_tarih_devir_other_pro.BORC_OTHER-get_tarih_devir_other_pro.ALACAK_OTHER)>
															<cfset gen_bak_top_2 = gen_bak_top_2 + (get_tarih_devir_pro.BORC2-get_tarih_devir_pro.ALACAK2)>
														</cfif>
														<cfif get_tarih_devir_other_pro.recordcount>
															<cfloop query="get_tarih_devir_other_pro">
																<cfset 'devir_borc_pro_#other_money#' = evaluate('devir_borc_pro_#other_money#') +borc_other>
																<cfset 'devir_alacak_pro_#other_money#' = evaluate('devir_alacak_pro_#other_money#') +alacak_other>
															</cfloop>
														</cfif>
														<cfif get_tarih_devir_pro.recordcount>
															<cfset row_gen_borc_top = devir_borc_pro+row_gen_borc_top>
															<cfset row_gen_ala_top = devir_alacak_pro+row_gen_ala_top>
															<cfset row_gen_borc_top_2 = devir_borc_2_pro+row_gen_borc_top_2>
															<cfset row_gen_ala_top_2 = devir_alacak_2_pro+row_gen_ala_top_2 >
															<cfset row_gen_bak_top = (devir_borc_pro-devir_alacak_pro)+row_gen_bak_top>	
															<cfset row_gen_bak_top_2 = (devir_borc_2_pro-devir_alacak_2_pro)+row_gen_bak_top_2>		
															<cfset row_gen_bak_top_other = (devir_borc_other_pro-devir_alacak_other_pro)+row_gen_bak_top_other>		 
															<tr  <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
																<td colspan="#colspan_info#" style="text-align:right;"><b><cf_get_lang_main no='452.Devir'></b></td>
																<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_pro)#</td>
																<td>#session_base.money#</td>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_pro)#</td>
																<td>#session_base.money#</td>
																<cfif listfind(attributes.list_type,2)>
																	<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_pro_2)#</td>
																	<td>#session_base.money2#</td>
																	<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_pro_2)#</td>
																	<td>#session_base.money2#</td>
																</cfif>	
																<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
																	<td style="text-align:right;">
																		<cfloop query="get_money">
																			<cfif evaluate('devir_borc_pro_#get_money.money#') gt 0>#TLFormat(evaluate('devir_borc_pro_#get_money.money#'))# #get_money.money#<br/></cfif>
																		</cfloop>
																	</td>
																	<td style="text-align:right;">
																		<cfloop query="get_money">
																			<cfif evaluate('devir_alacak_pro_#get_money.money#') gt 0>#TLFormat(evaluate('devir_alacak_pro_#get_money.money#'))# #get_money.money#<br/></cfif>
																		</cfloop>
																	</td>
																	<td></td>
																	<td></td>
																</cfif>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(ABS(devir_total_pro))#</td> 
																<td>#session_base.money#</td>
																<td><cfif devir_borc_pro gt devir_alacak_pro><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_pro lt devir_alacak_pro><cf_get_lang dictionary_id='29684.A'></cfif></td>
																<cfif listfind(attributes.list_type,3)>
																	<td  style="text-align:right;">#TLFormat(ABS(devir_total_2_pro))#</td>
																	<td>#session_base.money2#</td>
																	<td><cfif devir_borc_2_pro gt devir_alacak_2_pro><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_2_pro lt devir_alacak_2_pro><cf_get_lang dictionary_id='29684.A'></cfif></td>
																</cfif> 
																<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																	<td  style="text-align:right;">#TLFormat(ABS(devir_total_other_pro))#</td>
																	<td>#attributes.other_money#</td>
																	<td><cfif devir_borc_other_pro gt devir_alacak_other_pro><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_other_pro lt devir_alacak_other_pro><cf_get_lang dictionary_id='29684.A'></cfif></td>
																</cfif>
															</tr>										
														</cfif>
													</cfif>
													<!---- Abone bazlı grupla PY---->
													<cfif isdefined("attributes.is_subscription_group") and len(CARI_ROWS_ALL.SUBSCRIPTION_ID[currentrow]) and CARI_ROWS_ALL.SUBSCRIPTION_ID[currentrow] gt 0 and (CARI_ROWS_ALL.SUBSCRIPTION_ID[currentrow] neq CARI_ROWS_ALL.SUBSCRIPTION_ID[currentrow-1] or (attributes.page gt 1 and currentrow mod attributes.maxrows eq 1))>
														<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 8>
																<cfelse>
																	<cfset colspan_info = 7>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 6>
																<cfelse>
																	<cfset colspan_info = 5>
																</cfif>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 7>
																<cfelse>
																	<cfset colspan_info = 6>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 5>
																<cfelse>
																	<cfset colspan_info = 4>
																</cfif>
															</cfif>
														</cfif>
														<cfif len(subscription_id) and subscription_id neq 0>
															<cfset row_colspan = colspan_info+3>
															<cfif listfind(attributes.list_type,8)>
																<cfset row_colspan = row_colspan+1> 
															</cfif>
															<cfif listfind(attributes.list_type,2)>
																<cfset row_colspan = row_colspan+2> 
															</cfif>
															<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
																<cfset row_colspan = row_colspan+4> 
															</cfif>
															<cfif listfind(attributes.list_type,3)>
																<cfset row_colspan = row_colspan+1> 
															</cfif>
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<cfset row_colspan = row_colspan+1>
															</cfif>
															<tr height="20" <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
																<td colspan="#row_colspan#" class="txtbold">
																#get_subscription_no(subscription_id)#
																<cfelse>&nbsp;</td></cfif>
																</td>
															</tr>
														</td>
														<cfquery name="get_tarih_devir_pro" dbtype="query">
															SELECT
																SUM(BORC) BORC,
																SUM(ALACAK) ALACAK,
																SUM(BORC-ALACAK) DEVIR_TOTAL,
																SUM(BORC2) BORC2,
																SUM(ALACAK2) ALACAK2,
																SUM(BORC2-ALACAK2) DEVIR_TOTAL2
															FROM
																CARI_ROWS
															WHERE
																ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
																AND SUBSCRIPTION_ID = #CARI_ROWS_ALL.SUBSCRIPTION_ID#
														</cfquery>
														<cfquery name="get_tarih_devir_other_sub" dbtype="query">
															SELECT
																SUM(BORC_OTHER) BORC_OTHER,
																SUM(ALACAK_OTHER) ALACAK_OTHER,
																OTHER_MONEY
																<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																	,SUM(BORC_OTHER-ALACAK_OTHER) DEVIR_TOTAL_OTHER
																</cfif>
															FROM
																CARI_ROWS
															WHERE
																ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
																<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																	<cfif attributes.other_money is 'YTL' or attributes.other_money is 'TL'>
																		AND (OTHER_MONEY = 'YTL' OR OTHER_MONEY = 'TL')
																	<cfelse>
																		AND OTHER_MONEY = '#attributes.other_money#'
																	</cfif>
																</cfif>
																AND SUBSCRIPTION_ID = #CARI_ROWS_ALL.SUBSCRIPTION_ID#
															GROUP BY
																OTHER_MONEY
														</cfquery>
														<cfif get_tarih_devir_sub.recordcount>
															<cfset devir_borc_sub = get_tarih_devir_sub.BORC>
															<cfset devir_alacak_sub = get_tarih_devir_sub.ALACAK>
															<cfset devir_borc_other_sub = get_tarih_devir_other_sub.BORC_OTHER>
															<cfset devir_alacak_other_sub = get_tarih_devir_other_sub.ALACAK_OTHER>
															<cfset devir_total_sub = get_tarih_devir_sub.DEVIR_TOTAL>
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<cfset devir_total_other_sub = get_tarih_devir_other_sub.DEVIR_TOTAL_OTHER>
															</cfif>
															<cfset devir_borc_2_sub = get_tarih_devir_sub.BORC2>
															<cfset devir_alacak_2_sub = get_tarih_devir_sub.ALACAK2>
															<cfset devir_total_2_sub = get_tarih_devir_sub.DEVIR_TOTAL2>
															
															<cfset gen_borc_top = gen_borc_top + get_tarih_devir_sub.BORC>
															<cfset gen_ala_top = gen_ala_top + get_tarih_devir_sub.ALACAK>
															<cfset gen_bak_top = gen_bak_top + (get_tarih_devir_sub.BORC-get_tarih_devir_sub.ALACAK)>
															<cfset gen_bak_top_other = gen_bak_top_other + (get_tarih_devir_other_sub.BORC_OTHER-get_tarih_devir_other_sub.ALACAK_OTHER)>
															<cfset gen_bak_top_2 = gen_bak_top_2 + (get_tarih_devir_sub.BORC2-get_tarih_devir_sub.ALACAK2)>
														</cfif>
														<cfif get_tarih_devir_other_sub.recordcount>
															<cfloop query="get_tarih_devir_other_sub">
																<cfset 'devir_borc_sub_#other_money#' = evaluate('devir_borc_sub_#other_money#') +borc_other>
																<cfset 'devir_alacak_sub_#other_money#' = evaluate('devir_alacak_sub_#other_money#') +alacak_other>
															</cfloop>
														</cfif>
														<cfif get_tarih_devir_sub.recordcount>
															<cfset srow_gen_borc_top = devir_borc_sub+srow_gen_borc_top>
															<cfset srow_gen_ala_top = devir_alacak_sub+srow_gen_ala_top>
															<cfset srow_gen_borc_top_2 = devir_borc_2_sub+srow_gen_borc_top_2>
															<cfset srow_gen_ala_top_2 = devir_alacak_2_sub+srow_gen_ala_top_2 >
															<cfset srow_gen_bak_top = (devir_borc_sub-devir_alacak_sub)+srow_gen_bak_top>	
															<cfset srow_gen_bak_top_2 = (devir_borc_2_sub-devir_alacak_2_sub)+srow_gen_bak_top_2>		
															<cfset srow_gen_bak_top_other = (devir_borc_other_sub-devir_alacak_other_sub)+srow_gen_bak_top_other>		 
															<tr  <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
																<td colspan="#colspan_info#" style="text-align:right;"><b><cf_get_lang dictionary_id='57864.Devir'></b></td>
																<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_sub)#</td>
																<td>#session_base.money#</td>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_sub)#</td>
																<td>#session_base.money#</td>
																<cfif listfind(attributes.list_type,2)>
																	<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_sub_2)#</td>
																	<td>#session_base.money2#</td>
																	<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_sub_2)#</td>
																	<td>#session_base.money2#</td>
																</cfif>	
																<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
																	<td style="text-align:right;">
																		<cfloop query="get_money">
																			<cfif evaluate('devir_borc_sub_#get_money.money#') gt 0>#TLFormat(evaluate('devir_borc_sub_#get_money.money#'))# #get_money.money#<br/></cfif>
																		</cfloop>
																	</td>
																	<td style="text-align:right;">
																		<cfloop query="get_money">
																			<cfif evaluate('devir_alacak_sub_#get_money.money#') gt 0>#TLFormat(evaluate('devir_alacak_sub_#get_money.money#'))# #get_money.money#<br/></cfif>
																		</cfloop>
																	</td>
																	<td></td>
																	<td></td>
																</cfif>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(ABS(devir_total_sub))#</td> 
																<td>#session_base.money#</td>
																<td><cfif devir_borc_sub gt devir_alacak_sub><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_sub lt devir_alacak_sub><cf_get_lang dictionary_id='29684.A'></cfif></td>
																<cfif listfind(attributes.list_type,3)>
																	<td  style="text-align:right;">#TLFormat(ABS(devir_total_2_sub))#</td>
																	<td>#session_base.money2#</td>
																	<td><cfif devir_borc_2_sub gt devir_alacak_2_sub><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_2_sub lt devir_alacak_2_sub><cf_get_lang dictionary_id='29684.A'></cfif></td>
																</cfif> 
																<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																	<td  style="text-align:right;">#TLFormat(ABS(devir_total_other_sub))#</td>
																	<td>#attributes.other_money#</td>
																	<td><cfif devir_borc_other_sub gt devir_alacak_other_sub><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_other_sub lt devir_alacak_other_sub><cf_get_lang dictionary_id='29684.A'></cfif></td>
																</cfif>
															</tr>										
														</cfif>
													</cfif>
													<!---- Hesap Tipi bazlı grupla PY---->
													<cfif isdefined("attributes.is_acc_type_group") and len(CARI_ROWS_ALL.ACC_TYPE_ID[currentrow]) and CARI_ROWS_ALL.ACC_TYPE_ID[currentrow] gt 0 and (CARI_ROWS_ALL.ACC_TYPE_ID[currentrow] neq CARI_ROWS_ALL.ACC_TYPE_ID[currentrow-1] or (attributes.page gt 1 and currentrow mod attributes.maxrows eq 1))>
														<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 8>
																<cfelse>
																	<cfset colspan_info = 7>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 6>
																<cfelse>
																	<cfset colspan_info = 5>
																</cfif>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 7>
																<cfelse>
																	<cfset colspan_info = 6>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 5>
																<cfelse>
																	<cfset colspan_info = 4>
																</cfif>
															</cfif>
														</cfif>
														<cfif len(acc_type_id) and acc_type_id neq 0>
															<cfset row_colspan = colspan_info+3>
															<cfif listfind(attributes.list_type,8)>
																<cfset row_colspan = row_colspan+1> 
															</cfif>
															<cfif listfind(attributes.list_type,2)>
																<cfset row_colspan = row_colspan+2> 
															</cfif>
															<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
																<cfset row_colspan = row_colspan+4> 
															</cfif>
															<cfif listfind(attributes.list_type,3)>
																<cfset row_colspan = row_colspan+1> 
															</cfif>
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<cfset row_colspan = row_colspan+1>
															</cfif>
															<tr height="20" <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
																<td colspan="#row_colspan#" class="txtbold">
																#getAccount_Name.ACCOUNT_TYPE[listfind(acc_type_id_list,acc_type_id,',')]#
															<cfelse>&nbsp;</td></cfif>
																</td>
															</tr>
														</td>
														<cfquery name="get_tarih_devir_acc" dbtype="query">
															SELECT
																SUM(BORC) BORC,
																SUM(ALACAK) ALACAK,
																SUM(BORC-ALACAK) DEVIR_TOTAL,
																SUM(BORC2) BORC2,
																SUM(ALACAK2) ALACAK2,
																SUM(BORC2-ALACAK2) DEVIR_TOTAL2
															FROM
																CARI_ROWS
															WHERE
																ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
																AND ACC_TYPE_ID = #CARI_ROWS_ALL.ACC_TYPE_ID#
														</cfquery>
														<cfquery name="get_tarih_devir_other_acc" dbtype="query">
															SELECT
																SUM(BORC_OTHER) BORC_OTHER,
																SUM(ALACAK_OTHER) ALACAK_OTHER,
																OTHER_MONEY
																<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																	,SUM(BORC_OTHER-ALACAK_OTHER) DEVIR_TOTAL_OTHER
																</cfif>
															FROM
																CARI_ROWS
															WHERE
																ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
																<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																	<cfif attributes.other_money is 'YTL' or attributes.other_money is 'TL'>
																		AND (OTHER_MONEY = 'YTL' OR OTHER_MONEY = 'TL')
																	<cfelse>
																		AND OTHER_MONEY = '#attributes.other_money#'
																	</cfif>
																</cfif>
																AND ACC_TYPE_ID = #CARI_ROWS_ALL.ACC_TYPE_ID#
															GROUP BY
																OTHER_MONEY
														</cfquery>
														<cfif get_tarih_devir_acc.recordcount>
															<cfset devir_borc_acc = get_tarih_devir_acc.BORC>
															<cfset devir_alacak_acc = get_tarih_devir_acc.ALACAK>
															<cfset devir_borc_other_acc = get_tarih_devir_other_acc.BORC_OTHER>
															<cfset devir_alacak_other_acc = get_tarih_devir_other_acc.ALACAK_OTHER>
															<cfset devir_total_acc = get_tarih_devir_acc.DEVIR_TOTAL>
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<cfset devir_total_other_acc = get_tarih_devir_other_acc.DEVIR_TOTAL_OTHER>
															</cfif>
															<cfset devir_borc_2_acc = get_tarih_devir_acc.BORC2>
															<cfset devir_alacak_2_acc = get_tarih_devir_acc.ALACAK2>
															<cfset devir_total_2_acc = get_tarih_devir_acc.DEVIR_TOTAL2>
															
															<cfset gen_borc_top = gen_borc_top + get_tarih_devir_acc.BORC>
															<cfset gen_ala_top = gen_ala_top + get_tarih_devir_acc.ALACAK>
															<cfset gen_bak_top = gen_bak_top + (get_tarih_devir_acc.BORC-get_tarih_devir_acc.ALACAK)>
															<cfset gen_bak_top_other = gen_bak_top_other + (get_tarih_devir_other_acc.BORC_OTHER-get_tarih_devir_other_acc.ALACAK_OTHER)>
															<cfset gen_bak_top_2 = gen_bak_top_2 + (get_tarih_devir_acc.BORC2-get_tarih_devir_acc.ALACAK2)>
														</cfif>
														<cfif get_tarih_devir_other_acc.recordcount>
															<cfloop query="get_tarih_devir_other_acc">
																<cfset 'devir_borc_acc_#other_money#' = evaluate('devir_borc_acc_#other_money#') +borc_other>
																<cfset 'devir_alacak_acc_#other_money#' = evaluate('devir_alacak_acc_#other_money#') +alacak_other>
															</cfloop>
														</cfif>
														<cfif get_tarih_devir_acc.recordcount>
															<cfset row_gen_borc_top = devir_borc_acc+row_gen_borc_top>
															<cfset row_gen_ala_top = devir_alacak_acc+row_gen_ala_top>
															<cfset row_gen_borc_top_2 = devir_borc_2_acc+row_gen_borc_top_2>
															<cfset row_gen_ala_top_2 = devir_alacak_2_acc+row_gen_ala_top_2 >
															<cfset row_gen_bak_top = (devir_borc_acc-devir_alacak_acc)+row_gen_bak_top>	
															<cfset row_gen_bak_top_2 = (devir_borc_2_acc-devir_alacak_2_acc)+row_gen_bak_top_2>		
															<cfset row_gen_bak_top_other = (devir_borc_other_acc-devir_alacak_other_acc)+row_gen_bak_top_other>		 
															<tr  <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
																<td colspan="#colspan_info#" style="text-align:right;"><b><cf_get_lang dictionary_id='57864.Devir'></b></td>
																<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_acc)#</td>
																<td>#session_base.money#</td>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_acc)#</td>
																<td>#session_base.money#</td>
																<cfif listfind(attributes.list_type,2)>
																	<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_borc_acc_2)#</td>
																	<td>#session_base.money2#</td>
																	<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(devir_alacak_acc_2)#</td>
																	<td>#session_base.money2#</td>
																</cfif>	
																<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)>
																	<td style="text-align:right;">
																		<cfloop query="get_money">
																			<cfif evaluate('devir_borc_acc_#get_money.money#') gt 0>#TLFormat(evaluate('devir_borc_acc_#get_money.money#'))# #get_money.money#<br/></cfif>
																		</cfloop>
																	</td>
																	<td style="text-align:right;">
																		<cfloop query="get_money">
																			<cfif evaluate('devir_alacak_acc_#get_money.money#') gt 0>#TLFormat(evaluate('devir_alacak_acc_#get_money.money#'))# #get_money.money#<br/></cfif>
																		</cfloop>
																	</td>
																	<td></td>
																	<td></td>
																</cfif>
																<td style="text-align:right; mso-number-format:'0\.00'">#TLFormat(ABS(devir_total_acc))#</td> 
																<td>#session_base.money#</td>
																<td><cfif devir_borc_acc gt devir_alacak_acc><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_acc lt devir_alacak_acc><cf_get_lang dictionary_id='29684.A'></cfif></td>
																<cfif listfind(attributes.list_type,3)>
																	<td  style="text-align:right;">#TLFormat(ABS(devir_total_2_acc))#</td>
																	<td>#session_base.money2#</td>
																	<td><cfif devir_borc_2_acc gt devir_alacak_2_acc><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_2_acc lt devir_alacak_2_acc><cf_get_lang dictionary_id='29684.A'></cfif></td>
																</cfif> 
																<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																	<td  style="text-align:right;">#TLFormat(ABS(devir_total_other_acc))#</td>
																	<td>#attributes.other_money#</td>
																	<td><cfif devir_borc_other_acc gt devir_alacak_other_acc><cf_get_lang dictionary_id='58591.B'><cfelseif devir_borc_other_acc lt devir_alacak_other_acc><cf_get_lang dictionary_id='29684.A'></cfif></td>
																</cfif>
															</tr>										
														</cfif>
													</cfif>
													<tbody>
													<cfif DETAIL_TYPE eq 0>
														<tr <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
															<td>
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#currentrow#</font>
																<cfelseif listfind(attributes.list_type,10)>
																	#row_count#
																<cfelse>
																	#currentrow#
																</cfif>
																<cfset row_count = row_count + 1>
															</td>
															<td>
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#dateformat(action_date,dateformat_style)#</font>
																<cfelse>
																	#dateformat(action_date,dateformat_style)#
																</cfif>
															</td>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif len(DUE_DATE)>
																	<td>#dateformat(DUE_DATE,dateformat_style)#</td>
																	<td>#datediff('d',ACTION_DATE,DUE_DATE)#</td>
																<cfelseif len(PAY_METHOD) and PAY_METHOD neq 0 and ListFind(pay_method_id_list,PAY_METHOD,',')>
																	<td>#dateformat(date_add('d', listgetat(pay_method_gun_list,ListFind(pay_method_id_list,PAY_METHOD,','),','), action_date),dateformat_style)#</td>
																	<td>#listgetat(pay_method_gun_list,ListFind(pay_method_id_list,PAY_METHOD,','),',')#</td>
																<cfelseif listfind(bank_order_list,ACTION_ID)>
																	<td>#dateformat(GET_BANK_ORDER.PAYMENT_DATE[listfind(bank_order_list,ACTION_ID)],dateformat_style)#</td>
																	<td>#datediff('d',ACTION_DATE,GET_BANK_ORDER.PAYMENT_DATE[listfind(bank_order_list,ACTION_ID)])#</td>					
																<cfelse>
																	<td></td>
																	<td></td>
																</cfif>
															</cfif> 
															<cfif listfind(attributes.list_type,5)><td><cfif len(project_id) and project_id neq 0>#get_project_name.project_head[listfind(project_id_list,project_id,',')]#<cfelse>&nbsp;</cfif></td></cfif>
															<td>
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#paper_no#</font>
																<cfelse>
																	#paper_no#
																</cfif>
															</td>
															<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
																<td>
																	<cfif len(from_cmp_id)>
																		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#from_cmp_id#','medium');">#get_company.FULLNAME[listfind(company_id_list,from_cmp_id,',')]#</a>
																	<cfelseif len(to_cmp_id)>
																		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#to_cmp_id#','medium');">#get_company.FULLNAME[listfind(company_id_list,to_cmp_id,',')]#</a>
																	<cfelseif len(from_consumer_id)>
																		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#from_consumer_id#','medium');">#get_consumer.CONSUMER_NAME[listfind(consumer_id_list,from_consumer_id,',')]# #get_consumer.CONSUMER_SURNAME[listfind(consumer_id_list,from_consumer_id,',')]#</a>
																	<cfelseif len(to_consumer_id)>
																		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#to_consumer_id#','medium');">#get_consumer.CONSUMER_NAME[listfind(consumer_id_list,to_consumer_id,',')]# #get_consumer.CONSUMER_SURNAME[listfind(consumer_id_list,to_consumer_id,',')]#</a>
																	<cfelseif len(from_employee_id)>
																		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#from_employee_id#','medium');">#get_employee.EMPLOYEE_NAME[listfind(employee_id_list,from_employee_id,',')]# #get_employee.EMPLOYEE_SURNAME[listfind(employee_id_list,from_employee_id,',')]#</a>
																	<cfelseif len(to_employee_id)>
																		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#to_employee_id#','medium');">#get_employee.EMPLOYEE_NAME[listfind(employee_id_list,to_employee_id,',')]# #get_employee.EMPLOYEE_SURNAME[listfind(employee_id_list,to_employee_id,',')]#</a>
																	</cfif>
																</td>
															</cfif>
															<td>
																<cfif listfind('24,25,26,27,31,32,34,35,36,40,41,42,45,46,43,90,91,92,93,94,95,106,160,161',ACTION_TYPE_ID) and (not get_module_user(module))>
																	<cfif listfind(attributes.list_type,7)><!--- İslem tipi secili ise --->
																		<cfif listfind(process_cat_id_list,process_cat,',')>
																			<cfif listfind(attributes.list_type,6)>
																				<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#</font>
																			<cfelse>
																				#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#
																			</cfif>
																		<cfelse>
																			<cfif listfind(attributes.list_type,6)>
																				<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
																			<cfelse>
																				#action_name#
																			</cfif>
																		</cfif>	
																	<cfelse>
																		<cfif listfind(attributes.list_type,6)>
																			<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
																		<cfelse>
																			#action_name#
																		</cfif>
																	</cfif>
																<cfelseif not len(type)><!--- display sayfası olmayan tipler için --->
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
																	<cfelse>
																		#action_name#
																	</cfif>
																<cfelse>
																	<cfif not isdefined("attributes.is_excel") and not isdefined("attributes.due_date_info")>
																		<cfif listfind("291,292",action_type_id)><!--- Kredi Odemesi ,Kredi Tahsilat --->
																			<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#ACTION_ID#&period_id=#new_period#&our_company_id=#get_periods.our_company_id#','#page_type#');">
																		<cfelseif ACTION_TABLE is 'CHEQUE'> 
																			<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_cheque_det&ID=#ACTION_ID#&period_id=#new_period#','','ui-draggable-box-small')">
																		<cfelseif ACTION_TABLE is 'VOUCHER'> 
																			<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&ID=#ACTION_ID#&period_id=#new_period#','small')">
																		<cfelseif ACTION_TABLE is 'EMPLOYEES_PUANTAJ' and ACTION_TYPE_ID eq 161> 
																			<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_puantaj_act&type=1&ID=#CARI_ACTION_ID#','small')">
																		<cfelseif ACTION_TABLE is 'BUDGET_PLAN'> 
																			<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_budget_plan&ID=#CARI_ACTION_ID#','small')">
																		<cfelse>
																			<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&ID=#ACTION_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','#page_type#');">
																		</cfif>										
																	</cfif>
																	<cfif listfind(attributes.list_type,7)>
																		<cfif listfind(process_cat_id_list,process_cat,',')>
																			<cfif listfind(attributes.list_type,6)>
																				<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#</font>
																			<cfelse>
																				#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#
																			</cfif>
																		<cfelse>
																			<cfif listfind(attributes.list_type,6)>
																				<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
																			<cfelse>
																			#action_name#
																			</cfif>
																		</cfif>					
																	<cfelse>
																		<cfif listfind(attributes.list_type,6)>
																			<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#action_name#</font>
																		<cfelse>
																			#action_name#
																		</cfif>
																	</cfif>
																	<cfif not isdefined("attributes.is_excel")>
																		</a>
																	</cfif>
																</cfif>
															</td>
															<cfif listfind(attributes.list_type,8)>
																<td>
																	#action_detail#
																	<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																		<cfif ACTION_TYPE_ID eq 250 and len(bank_order_list)>
																			(#dateformat(GET_BANK_ORDER.PAYMENT_DATE[listfind(bank_order_list,ACTION_ID)],dateformat_style)#)
																			<cfif IS_PROCESSED eq 1>(Havale Oluşturulmuş)</cfif>
																		</cfif>
																	<cfelseif ACTION_TYPE_ID eq 250 and IS_PROCESSED eq 1>
																		(Havale Oluşturulmuş)
																	</cfif>
																</td>	
															</cfif>
															<td style="text-align:right; mso-number-format:'0\.00';">
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc)#</font>
																<cfelse>
																	#TLFormat(borc)#
																</cfif>
															</td>
															<td>#session_base.money#</td>
															<td style="text-align:right; mso-number-format:'0\.00'">
																<cfif listfind(attributes.list_type,6)>
																	<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak)#</font>
																<cfelse>
																	#TLFormat(alacak)#
																</cfif>
															</td>
															<td>#session_base.money#</td>
															<cfif listfind(attributes.list_type,2)><!--- Dovizli secili --->
																<td style="text-align:right; mso-number-format:'0\.00'">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc2)#</font>
																	<cfelse>
																		#TLFormat(borc2)#
																	</cfif>
																</td>
																<td>#session_base.money2#</td>
																<td style="text-align:right; mso-number-format:'0\.00'">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak2)#</font>
																	<cfelse>
																		#TLFormat(alacak2)#
																	</cfif>
																</td>
																<td>#session_base.money2#</td>
															</cfif>
															<cfif listfind(attributes.list_type,1) or listfind(attributes.list_type,9)><!--- Dovizli secili --->	
																<td style="text-align:right; mso-number-format:'0\.00'">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc_other)#</font>
																	<cfelse>
																		#TLFormat(borc_other)#
																	</cfif>
																</td>
																<td style="text-align:right; mso-number-format:'0\.00'">
																	<cfif listfind(attributes.list_type,6)>
											
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak_other)#</font>
																	<cfelse>
																		#TLFormat(alacak_other)#
																	</cfif>
																</td>
																<td style="text-align:right;">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#other_money#</font>
																	<cfelse>
																		#other_money#
																	</cfif>
																</td>
																<cfif (wrk_round(borc_other) gt 0 or wrk_round(alacak_other) gt 0)>
																	<cfif borc_other gt 0>
																		<cfset other_tutar = borc_other>
																		<cfset tutar = borc>
																	<cfelse>
																		<cfset other_tutar = alacak_other>
																		<cfset tutar = alacak>
																	</cfif>
																	<td style="text-align:right;">
																		<cfif other_money neq session.ep.money>
																			<cfif len(rate2)><cfset new_rate = rate2><cfelse><cfset new_rate = tutar/other_tutar></cfif>
																			<cfif listfind(attributes.list_type,6)>
																				<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(new_rate,session.ep.our_company_info.rate_round_num)#</font>
																			<cfelse>
																				#TLFormat(new_rate,session.ep.our_company_info.rate_round_num)#
																			</cfif>
																		<cfelse>
																		&nbsp;
																		</cfif>
																	</td>
																<cfelse>
																	<td></td>
																</cfif>
															</cfif>
															<cfif (currentrow mod attributes.maxrows) eq 1 or (cari_rows_all.recordcount eq 1)>
																<cfset bakiye = devir_total + borc - alacak>
																<cfset bakiye_other = devir_total_other + borc_other - alacak_other>
																<cfset gen_borc_top = devir_borc + borc + gen_borc_top>
																<cfset gen_ala_top = devir_alacak + alacak + gen_ala_top>
																<cfif len(borc2) and len(alacak2)><cfset bakiye_2 = devir_total_2 + borc2 - alacak2></cfif>
																<cfif len(borc2)><cfset gen_borc_top_2 = devir_borc_2 + borc2 + gen_borc_top_2></cfif>
																<cfif len(alacak2)><cfset gen_ala_top_2 = devir_alacak_2 + alacak2 + gen_ala_top_2></cfif>
															<cfelse>
																<cfset bakiye = borc - alacak >
																<cfset bakiye_other = borc_other - alacak_other>
																<cfset gen_borc_top = borc + gen_borc_top>
																<cfset gen_ala_top = alacak + gen_ala_top>
																<cfif len(borc2) and len(alacak2)><cfset bakiye_2 = borc2 - alacak2></cfif>
																<cfif len(borc2)><cfset gen_borc_top_2 = borc2 + gen_borc_top_2></cfif>
																<cfif len(alacak2)><cfset gen_ala_top_2 = alacak2 + gen_ala_top_2></cfif>
															</cfif>
															<cfif isdefined("attributes.is_project_group")>
																<cfset row_gen_borc_top = row_gen_borc_top + borc>
																<cfset row_gen_ala_top = row_gen_ala_top + alacak>
																<cfset row_gen_borc_top_2 = row_gen_borc_top_2 + borc2>
																<cfset row_gen_ala_top_2 = row_gen_ala_top_2 + alacak2>
																<cfset row_gen_bak_top = row_gen_bak_top + (borc - alacak)>		
																<cfset row_gen_bak_top_2 = row_gen_bak_top_2 + (borc2 - alacak2)>		
																<cfset row_gen_bak_top_other = row_gen_bak_top_other + (borc_other - alacak_other)>		 
															</cfif>
															<cfset gen_bak_top = bakiye + gen_bak_top>
															<cfset gen_bak_top_other = bakiye_other + gen_bak_top_other>
															<cfset gen_bak_top_2 = bakiye_2 + gen_bak_top_2>
															<cfif isdefined("attributes.is_project_group")>
																<td style="text-align:right; mso-number-format:'0\.00'">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(row_gen_bak_top))#</font>
																	<cfelse>
																		#TLFormat(abs(row_gen_bak_top))#
																	</cfif>
																</td>
																<td>#session_base.money#</td>
																<td><cfif row_gen_bak_top gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
																<cfif listfind(attributes.list_type,3)>
																	<td style="text-align:right; mso-number-format:'0\.00'">
																		<cfif listfind(attributes.list_type,6)>
																			<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(row_gen_bak_top_2))#</font>
																		<cfelse>
																			#TLFormat(abs(row_gen_bak_top_2))#
																		</cfif>
																	</td>
																	<td>#session_base.money2#</td>
																	<td><cfif row_gen_bak_top_2 gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
																</cfif>
																<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																	<td style="text-align:right; mso-number-format:'0\.00'">
																		<cfif listfind(attributes.list_type,6)>
																			<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(row_gen_bak_top_other))#</font>
																		<cfelse>
																			#TLFormat(abs(row_gen_bak_top_other))#
																		</cfif>
																	</td>
																	<td style="text-align:right;">#attributes.other_money#</td>
																	<td><cfif row_gen_bak_top_other gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
																</cfif>
															<cfelse>
																<td style="text-align:right; mso-number-format:'0\.00'">
																	<cfif listfind(attributes.list_type,6)>
																		<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(gen_bak_top))#</font>
																	<cfelse>
																		#TLFormat(abs(gen_bak_top))#
																	</cfif>
																</td>
																<td>#session_base.money#</td>
																<td><cfif gen_bak_top gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
																<cfif listfind(attributes.list_type,3)>
																	<td  style="text-align:right;">
																		<cfif listfind(attributes.list_type,6)>
																			<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(gen_bak_top_2))#</font>
																		<cfelse>
																			#TLFormat(abs(gen_bak_top_2))#
																		</cfif>
																	</td>
																	<td>#session_base.money2#</td>
																	<td><cfif gen_bak_top_2 gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
																</cfif>
																<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																	<td style="text-align:right;">
																		<cfif listfind(attributes.list_type,6)>
																			<cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(abs(gen_bak_top_other))#</font>
																		<cfelse>
																			#TLFormat(abs(gen_bak_top_other))#
																		</cfif>
																	</td>
																	<td style="text-align:right;">#attributes.other_money#</td>
																	<td><cfif gen_bak_top_other gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
																</cfif>	
															</cfif>
														</tr>
													<cfelseif DETAIL_TYPE neq 3>
														<cfif not isdefined("round_number") or not len(round_number)><cfset round_number = 2></cfif>
														<tr <cfif isdefined("is_from_report")>class="css1"<cfelse>class="nohover"</cfif>>
															<td <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>colspan="21"<cfelse>colspan="20"</cfif>>
																	<thead>
																	<cfif DETAIL_TYPE[currentrow-1] eq 0><!--- BAŞLIKLAR 1KERE OLUŞSN DİYE --->
																		<cfif DETAIL_TYPE eq 1><!--- fatura detaylı gösterim için --->
																			<tr>
																				<th width="100"><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
																				<th width="100"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
																				<cfif isdefined("is_show_spect_name") and is_show_spect_name eq 1>
																					<th width="150"><cf_get_lang dictionary_id ='57647.Spec'></th>
																				</cfif>
																				<cfif isdefined("is_show_inv_ship") and is_show_inv_ship eq 1>
																					<th width="70"><cf_get_lang dictionary_id='57773.İrsaliye'></th>
																				</cfif>
																				<cfif isdefined("is_show_inv_order_no") and is_show_inv_order_no eq 1>
																					<th width="70"><cf_get_lang dictionary_id='57611.Sipariş'></th>
																				</cfif>
																				<cfif isdefined("is_show_inv_order_head") and is_show_inv_order_head eq 1>
																					<th width="70"><cf_get_lang dictionary_id='57611.Sipariş'> <cf_get_lang dictionary_id='57480.Konusu'></th>
																				</cfif>
																				<th width="60" style="text-align:right;"><cf_get_lang dictionary_id ='57635.Miktar'></th>
																				<th width="40"><cf_get_lang dictionary_id ='57636.Birim'></th>
																				<th width="80" style="text-align:right;"><cf_get_lang dictionary_id ='57638.Birim Fiyat'></th>
																				<th width="120" style="text-align:right;"><cf_get_lang dictionary_id ='58169.İşlem Dövizi Fiyat'></th>
																				<th width="30"></th>
																				<th width="40" style="text-align:right;"><cf_get_lang dictionary_id ='57639.KDV'></th>
																				<cfif isdefined("is_show_discount") and is_show_discount eq 1>
																					<cfloop from="1" to="#discount_count#" index="dis_indx">
																						<th width="40" style="text-align:right;">ISK #dis_indx#</th>
																					</cfloop>
																				</cfif>
																				<th width="100" style="text-align:right;"><cf_get_lang dictionary_id ='58170.Satır Toplamı'></th>
																				<th width="120" style="text-align:right;"><cf_get_lang dictionary_id ='58171.İşlem Dövizi Toplam'></th>
																			</tr>
																		<cfelseif DETAIL_TYPE eq 2><!--- masraf fişi detaylı gösterim için --->
																			<tr <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-list"</cfif>>
																				<th width="100"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
																				<th width="150"><cfif ACTION_TYPE_ID eq 121><cf_get_lang dictionary_id ='58172.Gelir Merkezi'><cfelse><cf_get_lang dictionary_id ='58460.Masraf Merkezi'></cfif></th>
																				<th width="150"><cfif ACTION_TYPE_ID eq 121><cf_get_lang dictionary_id ='58173.Gelir Kalemi'><cfelse><cf_get_lang dictionary_id ='58551.Gider Kalemi'></cfif></th>
																				<th width="150"><cf_get_lang dictionary_id ='57416.Proje'></th>
																				<th width="40" style="text-align:right;"><cf_get_lang dictionary_id ='57635.Miktar'></th>
																				<th width="90" style="text-align:right;"><cf_get_lang dictionary_id ='57673.Tutar'></th>
																				<th width="40" style="text-align:right;"><cf_get_lang dictionary_id ='57639.KDV'></th>
																				<th width="40" style="text-align:right;"><cf_get_lang dictionary_id ='58021.ÖTV'></th>
																				<th width="90" style="text-align:right;"><cf_get_lang dictionary_id ='58170.Satır Toplam'></th>
																				<th width="100" style="text-align:right;"><cf_get_lang dictionary_id ='58124.Döviz Toplam'></th>
																			</tr>
																		</cfif>
																	</cfif>
																	</thead>
																	<tbody>
																		<cfif DETAIL_TYPE eq 1><!--- fatura detaylı gösterim için --->
																			<tr>
																				<td width="100">#stock_code#</td>
																				<td width="100">#name_product#</td>
																				<cfif isdefined("is_show_spect_name") and is_show_spect_name eq 1>
																					<td width="150"><cfif SPECT_VAR_NAME neq NAME_PRODUCT>#spect_var_name#<cfelse>&nbsp;&nbsp;</cfif></td>	
																				</cfif>
																				<cfif isdefined("is_show_inv_ship") and is_show_inv_ship eq 1>
																					<td width="70">
																						<cfif len(wrk_row_id_list) and listfind(main_ship_wrk_list,inv_wrk_row_rel_id,',')>
																							#get_rel_ship.ship_number[listfind(main_ship_wrk_list,inv_wrk_row_rel_id,',')]#
																						<cfelseif len(wrk_id_list) and listfind(main_ship_wrk_list_2,inv_wrk_row_id,',')>
																							#get_rel_ship_2.ship_number[listfind(main_ship_wrk_list_2,inv_wrk_row_id,',')]#
																						</cfif>															</td>
																				</cfif>
																				<cfif isdefined("is_show_inv_order_no") and is_show_inv_order_no eq 1>
																					<td width="70">
																						<cfif len(wrk_row_id_list)>
																							#get_rel_order.order_number[listfind(main_order_wrk_list,inv_wrk_row_rel_id,',')]#
																						</cfif>															</td>
																				</cfif>
																				<cfif isdefined("is_show_inv_order_head") and is_show_inv_order_head eq 1>
																					<td width="70">
																						<cfif len(wrk_row_id_list)>
																							#get_rel_order.order_head[listfind(main_order_wrk_list,inv_wrk_row_rel_id,',')]#
																						</cfif>															</td>
																				</cfif>
																				<td width="60"   style="text-align:right;">#AMOUNT#</td>
																				<td width="40">#UNIT#</td>
																				<td width="80" style="text-align:right;">#TLFormat(PRICE,round_number)#</td>
																				<td width="120" style="text-align:right;">#TLFormat(PRICE_OTHER,round_number)#</td>
																				<td width="80" style="text-align:right;">#ROW_MONEY#</td>
																				<td width="40" style="text-align:right;">#TAX#</td>
																				<cfif isdefined("is_show_discount") and is_show_discount eq 1>
																					<cfloop from="1" to="#discount_count#" index="dis_indx">
																						<td width="40" style="text-align:right;"><cfif len(evaluate("DISCOUNT#dis_indx#"))>#tlformat(evaluate("DISCOUNT#dis_indx#"),round_number)#</cfif></td>
																					</cfloop>
																				</cfif>
																				<td width="100" style="text-align:right;">#TLFormat(GROSSTOTAL,round_number)#</td>
																				<td width="120" style="text-align:right;">#TLFormat(OTHER_MONEY_GROSS_TOTAL,round_number)#</td>
																			</tr>
																		<cfelseif DETAIL_TYPE eq 2><!--- masraf fişi detaylı gösterim için --->
																			<tr>
																				<td width="100">#exp_detail#</td>
																				<td width="150">#expense_center#</td>
																				<td width="150">#expense_item_name#</td>
																				<td width="150"><cfif len(row_project_id)>#get_project_name_row.project_head[listfind(row_project_id_list,row_project_id,',')]#<cfelse>&nbsp;</cfif></td>
																				<td width="40" style="text-align:right;">#amount#</td>
																				<td width="90" style="text-align:right;">#TLFormat(price,round_number)#</td>
																				<td width="40" style="text-align:right;">#tax#</td>
																				<td width="40" style="text-align:right;">#otv_rate#</td>
																				<td width="90" style="text-align:right;">#TLFormat(grosstotal,round_number)#</td>
																				<td width="100" style="text-align:right;">#TLFormat(other_money_gross_total,round_number)# #row_money#</td>
																			</tr>
																		</cfif>
																	</tbody>
															</td>
														</tr>
													</cfif>
													<cfif isdefined("attributes.is_project_group") and ((CARI_ROWS_ALL.PROJECT_ID[currentrow] neq CARI_ROWS_ALL.PROJECT_ID[currentrow+1]) or currentrow/attributes.page eq attributes.maxrows)>
														<tr height="20" <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
															<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
																<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																	<cfif listfind(attributes.list_type,5)>
																		<cfset colspan_info = 8>
																	<cfelse>
																		<cfset colspan_info = 7>
																	</cfif>
																<cfelse>
																	<cfif listfind(attributes.list_type,5)>
																		<cfset colspan_info = 6>
																	<cfelse>
																		<cfset colspan_info = 5>
																	</cfif>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																	<cfif listfind(attributes.list_type,5)>
																		<cfset colspan_info = 7>
																	<cfelse>
																		<cfset colspan_info = 6>
																	</cfif>
																<cfelse>
																	<cfif listfind(attributes.list_type,5)>
																		<cfset colspan_info = 5>
																	<cfelse>
																		<cfset colspan_info = 4>
																	</cfif>
																</cfif>
															</cfif>
															<td colspan="#colspan_info#" style="text-align:right;">Proje Toplam</td>
															<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>	
															<td style="text-align:right;">#TLFormat(row_gen_borc_top)#</td>
															<td>#session_base.money#</td>
															<td style="text-align:right;">#TLFormat(row_gen_ala_top)#</td>
															<td>#session_base.money#</td>
															<cfif listfind(attributes.list_type,2)>
																<td style="text-align:right;">#TLFormat(row_gen_borc_top_2)#</td>
																<td>#session_base.money2#</td>
																<td style="text-align:right;">#TLFormat(row_gen_ala_top_2)#</td>
																<td>#session_base.money2#</td>
															</cfif>
															<cfif listfind(attributes.list_type,1) or  listfind(attributes.list_type,9)>
																<td style="width:125px;text-align:right;">
																	<cfloop query="get_money">
																	<cfset toplam_ara_2 = 0>
																	<cfif len(row_money_list_borc_2)>
																		<cfloop list="#row_money_list_borc_2#" index="i">
																			<cfset tutar_ = listfirst(i,';')>
																			<cfset money_ = listgetat(i,2,';')>
																			<cfif money_ eq money>
																			<cfset toplam_ara_2 = toplam_ara_2 + tutar_>
																			</cfif>
																		</cfloop> 
																	</cfif>
																	<cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_borc_pro_#money#')>
																	<cfif toplam_ara_2 neq 0>
																		#TLFormat(ABS(toplam_ara_2))# #money#<br/>
																	</cfif>
																	</cfloop>  
																</td>
																<td style="width:125px;text-align:right;">
																	<cfloop query="get_money">
																	<cfset toplam_ara_2 = 0>
																	<cfif len(row_money_list_alacak_2)>
																		<cfloop list="#row_money_list_alacak_2#" index="i">
																			<cfset tutar_ = listfirst(i,';')>
																			<cfset money_ = listgetat(i,2,';')>
																			<cfif money_ eq money>
																			<cfset toplam_ara_2 = toplam_ara_2 + tutar_>
																			</cfif>
																	</cfloop> 
																	</cfif>
																	<cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_alacak_pro_#money#') >
																	<cfif toplam_ara_2 neq 0>
																		#TLFormat(ABS(toplam_ara_2))# #money#<br/>
																	</cfif>
																	</cfloop>  
																</td>
																<td>&nbsp;</td><td>&nbsp;</td>
															</cfif>
															<td style="text-align:right; mso-number-format:'0\.00'"> 
																#TLFormat(abs(row_gen_bak_top))#
															</td>
															<td>#session_base.money#</td>
															<td><cfif row_gen_bak_top gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															<cfif listfind(attributes.list_type,3)>
																<td style="text-align:right;"> 
																	#TLFormat(abs(row_gen_bak_top_2))#
																</td>
																<td>#session_base.money2#</td>
																<td><cfif row_gen_bak_top_2 gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<td style="text-align:right;">
																	#TLFormat(abs(row_gen_bak_top_other))#
																</td>
																<td style="text-align:right;">#attributes.other_money#</td>
																<td><cfif row_gen_bak_top_other gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
														</tr>
														<cfset row_gen_borc_top = 0>	
														<cfset row_gen_ala_top = 0>	
														<cfset row_gen_borc_top_2 = 0>		
														<cfset row_gen_ala_top_2 = 0>		
														<cfset row_gen_bak_top = 0>		
														<cfset row_gen_bak_top_2 = 0>		
														<cfset row_gen_bak_top_other = 0>		
														<cfset row_money_list_borc_2 = ''>
														<cfset row_money_list_borc_1 = ''>
														<cfset row_money_list_alacak_2 = ''>
														<cfset row_money_list_alacak_1 = ''>
														<cfloop query="get_money">
															<cfset 'devir_borc_pro_#money#' = 0>
															<cfset 'devir_alacak_pro_#money#' = 0>
														</cfloop>
													</cfif>
													</tbody>
												</cfoutput>
												<tfoot>
													<tr <cfif isdefined("is_from_report")>class="css1"<cfelse>class="color-row"</cfif>>
														<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name) and not len(attributes.comp_name)>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 8>
																<cfelse>
																	<cfset colspan_info = 7>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 6>
																<cfelse>
																	<cfset colspan_info = 5>
																</cfif>
															</cfif>
														<cfelse>
															<cfif listfind(attributes.list_type,4) or isdefined("attributes.due_date_info")>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 7>
																<cfelse>
																	<cfset colspan_info = 6>
																</cfif>
															<cfelse>
																<cfif listfind(attributes.list_type,5)>
																	<cfset colspan_info = 5>
																<cfelse>
																	<cfset colspan_info = 4>
																</cfif>
															</cfif>
														</cfif>
														<td colspan="<cfoutput>#colspan_info#</cfoutput>" style="text-align:right;"><b><cf_get_lang dictionary_id='57680.Genel Toplam'></b></td>
														<cfif listfind(attributes.list_type,8)><td>&nbsp;</td></cfif>	
														<td style="text-align:right;"><cfoutput>#TLFormat(gen_borc_top)#</cfoutput></td>
														<td><cfoutput>#session_base.money#</cfoutput></td>
														<td style="text-align:right;"><cfoutput>#TLFormat(gen_ala_top)#</cfoutput></td>
														<td><cfoutput>#session_base.money#</cfoutput></td>
														<cfif listfind(attributes.list_type,2)>
															<td style="text-align:right;"><cfoutput>#TLFormat(gen_borc_top_2)#</cfoutput></td>
															<td><cfoutput>#session_base.money2#</cfoutput></td>
															<td style="text-align:right;"><cfoutput>#TLFormat(gen_ala_top_2)#</cfoutput></td>
															<td><cfoutput>#session_base.money2#</cfoutput></td>
														</cfif>
														<cfif listfind(attributes.list_type,1) or  listfind(attributes.list_type,9)>
															<td style="width:125px;text-align:right;">
																<cfoutput query="get_money">
																<cfset toplam_ara_2 = 0>
																<cfif len(money_list_borc_2)>
																	<cfloop list="#money_list_borc_2#" index="i">
																		<cfset tutar_ = listfirst(i,';')>
																		<cfset money_ = listgetat(i,2,';')>
																		<cfif money_ eq money>
																		<cfset toplam_ara_2 = toplam_ara_2 + tutar_>
																		</cfif>
																	</cfloop> 
																</cfif>
																<cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_borc_#money#')>
																<cfif toplam_ara_2 neq 0>
																	#TLFormat(ABS(toplam_ara_2))# #money#<br/>
																</cfif>
																</cfoutput>  
						
															</td>
															<td style="width:125px;text-align:right;">
																<cfoutput query="get_money">
																<cfset toplam_ara_2 = 0>
																<cfif len(money_list_alacak_2)>
																	<cfloop list="#money_list_alacak_2#" index="i">
																		<cfset tutar_ = listfirst(i,';')>
																		<cfset money_ = listgetat(i,2,';')>
																		<cfif money_ eq money>
																		<cfset toplam_ara_2 = toplam_ara_2 + tutar_>
																		</cfif>
																</cfloop> 
																</cfif>
																<cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_alacak_#money#') >
																<cfif toplam_ara_2 neq 0>
																	#TLFormat(ABS(toplam_ara_2))# #money#<br/>
																</cfif>
																</cfoutput>  
															</td>
															<td>&nbsp;</td><td>&nbsp;</td>
														</cfif>
														<cfoutput>
															<td style="text-align:right;"> 
																#TLFormat(abs(gen_bak_top))#
															</td>
															<td>#session_base.money#</td>
															<td><cfif gen_bak_top gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															<cfif listfind(attributes.list_type,3)>
																<td style="text-align:right;"> 
																	#TLFormat(abs(gen_bak_top_2))#
																</td>
																<td>#session_base.money2#</td>
																<td><cfif gen_bak_top_2 gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
															<cfif listfind(attributes.list_type,1) and len(attributes.other_money)>
																<td style="text-align:right;">
																	#TLFormat(abs(gen_bak_top_other))#
																</td>
																<td style="text-align:right;">#attributes.other_money#</td>
																<td><cfif gen_bak_top_other gt 0><cf_get_lang dictionary_id='58591.B'><cfelse><cf_get_lang dictionary_id='29684.A'></cfif></td>
															</cfif>
														</cfoutput>
													</tr>
												</tfoot>	 
											<cfelse>
												<tbody>
													<tr>
														<td colspan="24" class="color-row" height="20"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
													</tr>
												</tbody>  	       
											</cfif>
									</cf_grid_list> 
									<cfif listfind(attributes.list_type,1)>
										<cf_grid_list>
											<thead>
												<tr>
													<th nowrap="nowrap"><cf_get_lang dictionary_id ='58121.İşlem Dövizi'></th>
													<th width="33%" style="text-align:right;"><cf_get_lang dictionary_id ='57862.İşlem Dövizi Borç'></th>
													<th width="33%" style="text-align:right;"><cf_get_lang dictionary_id ='57863.İşlem Dövizi Alacak'></th>
													<th width="33%" style="text-align:right;"><cf_get_lang dictionary_id ='58174.İşlem Dövizi Bakiye'></th>
												</tr>
											</thead>
											<tbody>
											<cfquery name="get_money_list" datasource="#dsn#">
												SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #new_period# AND MONEY_STATUS=1
											</cfquery>
											<cfoutput query="get_money_list">
											<tr class="color-row">
												<td class="txtbold" style="width:60px;">#money#</td>
												<cfset toplam_borc_2 = 0>
												<cfif len(money_list_borc_2)>
													<cfloop list="#money_list_borc_2#" index="i">
														<cfset tutar_ = listfirst(i,';')>
														<cfset money_ = listgetat(i,2,';')>
														<cfif money_ eq money>
														<cfset toplam_borc_2 = toplam_borc_2 + tutar_>
														</cfif>
													</cfloop> 
												</cfif>
												<cfset toplam_borc_2 = toplam_borc_2 + evaluate('devir_borc_#money#')>
												<td style="text-align:right;">#TLFormat(abs(toplam_borc_2))# #money#</td>
												<cfset toplam_ala_2 = 0>
												<cfif len(money_list_alacak_2)>
													<cfloop list="#money_list_alacak_2#" index="i">
														<cfset tutar_ = listfirst(i,';')>
														<cfset money_ = listgetat(i,2,';')>
														<cfif money_ eq money>
														<cfset toplam_ala_2 = toplam_ala_2 + tutar_>
														</cfif>
												</cfloop> 
												</cfif>
												<cfset toplam_ala_2 = toplam_ala_2 + evaluate('devir_alacak_#money#') >
												<td style="text-align:right;">#TLFormat(abs(toplam_ala_2))# #money#</td>
												<td style="text-align:right;">#TLFormat(abs(toplam_borc_2 - toplam_ala_2))# #money#<cfif toplam_borc_2 gte toplam_ala_2>(<cf_get_lang dictionary_id='58591.B'>)<cfelse>(<cf_get_lang dictionary_id='29684.A'>)</cfif></td>
											</tr>
											</cfoutput>
											</tbody>
										</cf_grid_list>
									</cfif>
								</cfif>
							</cfloop>
						</cfloop>            
					</cfif>
					<cfif isdefined('attributes.is_make_age_manuel') and ((isdefined("attributes.is_bakiye") and CARI_ROWS_ALL.recordcount gt 0) or not isdefined("attributes.is_bakiye"))> 
						<cfset is_from_collacted = 1>
						<cfinclude template="dsp_make_age_manuel.cfm">
					</cfif>
					<cfset card_index ++>
				</cfloop>
			<cfelse>
				<cfparam name="attributes.totalrecords" default="0">
			</cfif>
			<!-- sil -->
			<cfif not isdefined("is_ajax") and not (isdefined("attributes.is_collacted") and attributes.is_collacted eq 1) and not (listfind(attributes.list_type,10)) and isdefined("get_periods.recordcount") and get_periods.recordcount eq 1>
				<cfif isdefined("attributes.totalrecords") and attributes.totalrecords gt attributes.maxrows>
					<cfscript>
						wrkUrlStrings('adres','company_id','consumer_id','is_page','form_submit','employee_id','member_type','action_type','other_money','list_type','is_pay_cheques','is_pay_bankorders','project_id','project_head_','is_project_group','is_sifir_bakiye');
					</cfscript>
					<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and isdefined("attributes.employee_id")>
						<cfset adres="#adres#&acc_type_id=#attributes.acc_type_id#">
					</cfif>
					<cfif isdefined("attributes.date1") and len(attributes.date1)>
						<cfset adres="#adres#&date1=#dateformat(attributes.date1,dateformat_style)#">
					</cfif>
					<cfif isdefined("attributes.comp_name") and len(attributes.comp_name)>
						<cfset adres="#adres#&company=#replace(attributes.company,'&','','all')#">
					</cfif>
					<cfif isdefined("attributes.comp_name") and len(attributes.comp_name)>
						<cfset adres="#adres#&comp_name=#replace(attributes.comp_name,'&','','all')#">
					</cfif>
					<cfif isdefined("attributes.company2") and len(attributes.company2)>
						<cfset adres="#adres#&company2=#company2#">
					</cfif>
					<cfif isdefined("attributes.date2") and len(attributes.date2)>
						<cfset adres="#adres#&date2=#dateformat(attributes.date2,dateformat_style)#">
					</cfif>
					<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>
						<cfset adres="#adres#&asset_id=#attributes.asset_id#&asset_name=#attributes.asset_name#">
					</cfif>
					<cfif isDefined('attributes.special_definition_id')>
						<cfset adres = '#adres#&special_definition_id=#attributes.special_definition_id#'>
					</cfif>
					<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
						<cfset adres="#adres#&branch_id=#attributes.branch_id#">
					</cfif>
					<cfif isdefined("attributes.process_catid") and len(attributes.process_catid)>
						<cfset adres="#adres#&process_catid=#attributes.process_catid#">
					</cfif>
					<cfif isdefined("attributes.is_page") and attributes.is_page eq 1>
						<cfif listgetat(attributes.fuseaction,1,'.') eq "ch">
							<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_company_extre#adres#">
						<cfelse>
							<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.popup_list_comp_extre#adres#">
						</cfif>
					<cfelse>	
						<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_company_extre#adres#">
					</cfif>
				</cfif> 
				<!-- sil -->
			</cfif> 
		</cfif>
	</div>
	<cfif not isdefined("is_ajax") and not (isdefined("attributes.is_collacted") and attributes.is_collacted eq 1) and not (listfind(attributes.list_type,10)) and isdefined("get_periods.recordcount") and get_periods.recordcount eq 1>
		<cfif isdefined("attributes.totalrecords") and attributes.totalrecords gt attributes.maxrows>
			<cfif isdefined("attributes.page")>
				<cf_paging 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#adres#"
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#"> 
			</cfif>
		</cfif>
	</cfif>	
</cf_box>
<script type="text/javascript">
$(document).ready(function() {
  $('#is_subscription_group').click(function() {
    if ($(this).is(':checked')) {
      $('#is_project_group').prop("checked", false);
	   $('#is_acc_type_group').prop("checked", false);
    }
  });
  $('#is_project_group').click(function() {
    if ($(this).is(':checked')) {
      $('#is_subscription_group').prop("checked", false);
	   $('#is_acc_type_group').prop("checked", false);
    }
  });
  $('#is_acc_type_group').click(function() {
    if ($(this).is(':checked')) {
      $('#is_subscription_group').prop("checked", false);
	  $('#is_project_group').prop("checked", false);
    }
  });
});
	function islem_goster()
	{
		if(document.list_ekstre.form_type.value == -1)
		{
			document.getElementById('item-list_type').style.display = '';
			document.getElementById('member_code').style.display = 'none';
		}
		else
		{
			document.getElementById('item-list_type').style.display = 'none';
			document.getElementById('member_code').style.display = '';
		}
	}
	function degistir ()
	{
		if(document.list_ekstre.is_collacted.value == 1)
			document.list_ekstre.is_collacted.value = 0;
		else
			document.list_ekstre.is_collacted.value = 1;
	}
	function show_cari_()
	{
		if(document.list_ekstre.is_pdf.checked == true)
		{
			show_pdf2.style.display = '';
			show_pdf3.style.display = '';
		}
		else
		{
			show_pdf2.style.display = 'none';
			show_pdf3.style.display = 'none';
			document.list_ekstre.is_cari_page.checked = false;
		}
	}
	function degistir_action()
	{
		if(document.getElementById("is_excel").checked==false)
			document.list_ekstre.action="<cfoutput>#action#</cfoutput>"
		else
			document.list_ekstre.action="<cfoutput>#action1#</cfoutput>"
	}
	function kontrol()
	{
		/* if(document.list_ekstre.member_cat_type.value !='' || document.list_ekstre.pos_code_text.value !=''){
			document.list_ekstre.is_collacted.value = 1;
		} */
		if((document.list_ekstre.comp_name.value.length == 0))
			{
				document.list_ekstre.company_id.value = '';
				document.list_ekstre.consumer_id.value = '';
				document.list_ekstre.employee_id.value = '';
			}
		if (document.list_ekstre.is_collacted.value == 1)
		{
			if ((document.list_ekstre.is_make_age != undefined && document.list_ekstre.is_make_age.checked == false))
			{
				if((document.list_ekstre.company2.value.length == 0))
					{
						document.list_ekstre.company_id2.value = '';
						document.list_ekstre.consumer_id2.value = '';
						document.list_ekstre.employee_id2.value = '';
					}
			}
		}
		if (document.list_ekstre.is_collacted.value == 1)
		{
			if ((document.list_ekstre.is_make_age != undefined && document.list_ekstre.is_make_age.checked == true))
			{
				document.list_ekstre.company2.value.length ='';
				document.list_ekstre.company_id2.value = '';
				document.list_ekstre.consumer_id2.value = '';
				document.list_ekstre.employee_id2.value = '';
				document.list_ekstre.is_collacted.value = 0;
			}
		}
		if (document.list_ekstre.is_collacted.value == 1)
		{
			if( (document.list_ekstre.company_id.value == "")&&(document.list_ekstre.consumer_id.value == "") && (document.list_ekstre.branch_id.value == "") && (document.list_ekstre.comp_name.value == "") &&(document.list_ekstre.employee_id.value == "")&& (document.list_ekstre.pos_code_text.value == "")&& ((document.list_ekstre.member_cat_type.value == "") || document.list_ekstre.member_cat_type.value == 2 || document.list_ekstre.member_cat_type.value == 1)&&(document.list_ekstre.special_code_toplu.value ==""))
				{ 
				alert ("<cf_get_lang dictionary_id ='58629.Cari Hesap , Çalışan Hesap , Temsilci veya Üye Kategorisi Seçiniz'>!");
				return false;
				}
		}
		else
		{
			<cfif isdefined("attributes.form_submit")>
				<cfif session.ep.our_company_info.asset_followup eq 1>
					if((document.list_ekstre.asset_id.value == "" || document.list_ekstre.asset_name.value == "") && (document.list_ekstre.company_id.value == "") && (document.list_ekstre.consumer_id.value == "") && (document.list_ekstre.employee_id.value == ""))
						{ 
						alert ("<cf_get_lang dictionary_id ='58629.Cari Hesap , Çalışan Hesap , Temsilci veya Üye Kategorisi Seçiniz'> !");
						return false;
						}		
				<cfelse>
					if((document.list_ekstre.company_id.value == "") && (document.list_ekstre.consumer_id.value == "") && (document.list_ekstre.employee_id.value == ""))
						{ 
						alert ("<cf_get_lang dictionary_id ='58629.Cari Hesap , Çalışan Hesap , Temsilci veya Üye Kategorisi Seçiniz'> !");
						return false;
						}
				</cfif>
			<cfelse>
				<cfif session.ep.our_company_info.asset_followup eq 1>
					if((document.list_ekstre.asset_id.value == "" || document.list_ekstre.asset_name.value == "") && (document.list_ekstre.company_id.value == "") && (document.list_ekstre.consumer_id.value == "") && (document.list_ekstre.employee_id.value == "") && (document.list_ekstre.special_code.value == "") && (document.list_ekstre.pos_code_text.value == "") && ((document.list_ekstre.member_cat_type.value == "") || document.list_ekstre.member_cat_type.value == 2 || document.list_ekstre.member_cat_type.value == 1))
						{ 
						alert ("<cf_get_lang dictionary_id ='58911.Cari Hesap  Çalışan Hesap  Fiziki Varlık Temsilci veya Üye Kategorisi Seçiniz'> !");
						return false;
						}		
				<cfelse>
					if((document.list_ekstre.company_id.value == "") && (document.list_ekstre.consumer_id.value == "") && (document.list_ekstre.employee_id.value == "") && (document.list_ekstre.special_code.value == "") && (document.list_ekstre.pos_code_text.value == "") && ((document.list_ekstre.member_cat_type.value == "") || document.list_ekstre.member_cat_type.value == 2 || document.list_ekstre.member_cat_type.value == 1))
						{ 
						alert ("<cf_get_lang dictionary_id ='58175.Cari Hesap  Çalışan Hesap  Temsilci veya Üye Kategorisi Seçiniz'> !");
						return false;
						}
				</cfif>
			</cfif>
		}
		<cfif not isdefined("attributes.form_submit")>
			if (document.list_ekstre.form_type[document.list_ekstre.form_type.selectedIndex].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='57804.Baskı Formu Seçiniz'> !");
				return false;
			}
		</cfif>		
		if (document.list_ekstre.is_collacted.value == 1)
		{
			if((document.list_ekstre.company2.value!='') && (document.list_ekstre.member_type.value != document.list_ekstre.member_type2.value))
				{ 
				alert ("<cf_get_lang dictionary_id='57805.Lütfen Aynı Türde Hesaplar Seçiniz'> !");
				return false;
				}
		}
		if(document.list_ekstre.company_id.value != "" || document.list_ekstre.consumer_id.value != "" || document.list_ekstre.employee_id.value != ""  )
			document.list_ekstre.special_code.value = '';
			if(document.list_ekstre.is_pdf.checked== true && document.list_ekstre.is_collacted.value== 1)
			{
				document.list_ekstre.action='<cfoutput>#request.self#?fuseaction=objects.emptypopup_list_extre_pdf</cfoutput>';
				document.list_ekstre.submit();
				return false;
			}
		
		<cfif is_date_kontrol eq 0>
			return date_diff(document.list_ekstre.date1,document.list_ekstre.date2,1,"<cf_get_lang dictionary_id ='57806.Tarih Aralığını Kontrol Ediniz'>!");
		<cfelse>
			if(document.list_ekstre.is_collacted.value == 1)
				return date_diff(document.list_ekstre.date1,document.list_ekstre.date2,1,"<cf_get_lang dictionary_id ='57806.Tarih Aralığını Kontrol Ediniz'>!");
			else
				return true;	
		</cfif>
	}
	function hesap_sec(no)
	{
		if (no==1)
		{
			if(document.list_ekstre.pos_code_text != undefined)
				document.list_ekstre.pos_code_text.value='';
			if(document.list_ekstre.company_id.value!='')
			{
				document.list_ekstre.company_id.value='';
				document.list_ekstre.comp_name.value='';
			}
			if(document.list_ekstre.employee_id.value!='')
			{
				document.list_ekstre.employee_id.value='';
				document.list_ekstre.comp_name.value='';
			}
			if(document.list_ekstre.consumer_id.value!='')
			{
				document.list_ekstre.consumer_id.value='';
				document.list_ekstre.comp_name.value='';
			}
		}
		else if (no==2)
		{
			if(document.list_ekstre.pos_code_text != undefined)
				document.list_ekstre.pos_code_text.value='';
			if(document.list_ekstre.company_id2.value!='')
			{
				document.list_ekstre.company_id2.value='';
				document.list_ekstre.company2.value='';
			}
			if(document.list_ekstre.employee_id2.value!='')
			{
				document.list_ekstre.employee_id2.value='';
				document.list_ekstre.company2.value='';
			}
			if(document.list_ekstre.consumer_id2.value!='')
			{
				document.list_ekstre.consumer_id2.value='';
				document.list_ekstre.company2.value='';
			}
		}
		else if (no==3)
		{
			if(document.list_ekstre.company_id.value!='')
			{
				document.list_ekstre.company_id.value='';
				document.list_ekstre.comp_name.value='';
			}
			if(document.list_ekstre.employee_id.value!='')
			{
				document.list_ekstre.employee_id.value='';
				document.list_ekstre.comp_name.value='';
			}
			if(document.list_ekstre.consumer_id.value!='')
			{
				document.list_ekstre.consumer_id.value='';
				document.list_ekstre.comp_name.value='';
			}
			if(document.list_ekstre.company_id2.value!='')
			{
				document.list_ekstre.company_id2.value='';
				document.list_ekstre.company2.value='';
			}
			if(document.list_ekstre.employee_id2.value!='')
			{
				document.list_ekstre.employee_id2.value='';
				document.list_ekstre.company2.value='';
			}
			if(document.list_ekstre.consumer_id2.value!='')
			{

				document.list_ekstre.consumer_id2.value='';
				document.list_ekstre.company2.value='';
			}
		}
	}
	function kontrol_perf(kont)
	{
		if(kont==1)
		{
			if(document.list_ekstre.is_make_age != undefined && document.list_ekstre.is_make_age.checked== true)
			{	
				document.list_ekstre.is_cheque_duedate.style.display='';
				<cfif isDefined("attributes.form_submit") and attributes.form_submit eq 1>
					$(".is_cheque_duedate").show();
				</cfif>
				if(document.list_ekstre.is_make_age_manuel != undefined)
					document.list_ekstre.is_make_age_manuel.checked = false;
			}
			else
			{
				document.list_ekstre.is_cheque_duedate.style.display='none';
				$(".is_cheque_duedate").hide();
			}
		}
		else
		{
			if(document.list_ekstre.is_make_age_manuel.checked== true && document.list_ekstre.is_make_age != undefined)
			{
				document.list_ekstre.is_make_age.checked = false;
			}
			else if(document.list_ekstre.is_make_age.checked== true && document.list_ekstre.is_make_age != undefined)
			{
				document.list_ekstre.is_make_age_manuel.checked = false;
			}
		}
	}	
</script>