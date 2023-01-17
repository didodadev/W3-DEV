<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Meltem Aşkın		
Analys Date : 01/04/2016			Dev Date	: 17/05/2016		
Description :
	Bu controller ilanlar objesine ait kontrolleri yapar modelleri çağırarak ilgili setleri çalıştırır.
----------------------------------------------------------------------->

<!------------------------------------------------------
	Event lere göre kontroller yapılıyor
-------------------------------------------------------->

<cfif not isdefined('attributes.formSubmittedController')>
	<!--- objede kullanılan utility ler --->
    <cfscript>
		if((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
			get_our_company = getOurCompany.get();
			
		get_process_stage = getProcessStage.get(companyId : session.ep.company_id, objectFuseaction : 'hr.list_notice');
	</cfscript>

	<cf_get_lang_set module_name="hr">
	<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
        <cfparam name="is_filtered" default="0">
        <cfparam name="attributes.comp_id" default="">
        <cfparam name="attributes.company" default="">
        <cfparam name="attributes.company_id" default="">
        <cfparam name="attributes.keyword" default="">
        <cfparam name="attributes.startdate" default="#date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(Now())#-#day(Now())#'))#">
        <cfparam name="attributes.finishdate" default="#date_add('d',7,attributes.startdate)#">
        <cfparam name="attributes.status" default="2">
        <cfparam name="attributes.process_stage" default="">
        <cfparam name="attributes.notice_cat_id" default="">
        <cfparam name="attributes.branch_id" default="">
        <cfparam name="attributes.department" default="">
        
		<cfif is_filtered>
        	<cfif len(attributes.STARTDATE)>
                <cf_date tarih="attributes.startdate">
            </cfif>
            <cfif len(attributes.FINISHDATE)>
                <cf_date tarih="attributes.finishdate">
            </cfif>
			<cfscript>
				get_notices = RecruitmentAnnounceModel.list(
						keyword : attributes.keyword,
						status : attributes.status,
						process_stage : attributes.process_stage,
						startdate : attributes.startdate,
						finishdate : attributes.finishdate,
						comp_id : iif(len(attributes.comp_id),attributes.comp_id,0),
						company_id : iif(len(attributes.company_id) and len(attributes.company) ,attributes.company_id,0),
						branch_id : iif(len(attributes.branch_id) ,attributes.branch_id,0),
						department : iif(len(attributes.department) ,attributes.department,0),
						notice_cat_id : iif(len(attributes.notice_cat_id) ,attributes.notice_cat_id,0)
				);
			</cfscript>
        <cfelse>
            <cfset get_notices.recordcount = 0>
        </cfif>

        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfparam name="attributes.totalrecords" default=#get_notices.recordcount#>
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
        
		<cfif isdefined("attributes.comp_id") and len(attributes.comp_id) and attributes.comp_id is not "all">
            <cfquery name="get_branch" datasource="#dsn#">
                SELECT * FROM BRANCH WHERE BRANCH_STATUS = 1 AND COMPANY_ID = #attributes.comp_id# ORDER BY BRANCH_NAME
            </cfquery>
        </cfif>
        
		<cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all">
            <cfquery name="get_department" datasource="#dsn#">
                SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID = #attributes.branch_id# AND DEPARTMENT_STATUS =1 AND IS_STORE<>1 ORDER BY DEPARTMENT_HEAD
            </cfquery>
        </cfif>
        
		<cfset url_str = "">
        <cfset url_str = "#url_str#&status=#attributes.status#">
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
            <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
        </cfif>
        <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
            <cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
        </cfif>
        <cfif isdefined('attributes.is_filtered')>
            <cfset url_str = "#url_str#&is_filtered=#attributes.is_filtered#">
        </cfif>
        <cfif len(attributes.startdate)>
            <cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#">
        </cfif>
        <cfif len(attributes.finishdate)>
            <cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
        </cfif>
        <cfif isdefined('attributes.company') and len(attributes.company)>
            <cfset url_str = "#url_str#&company=#attributes.company#&company_id=#attributes.company_id#">
        </cfif>
        <cfif isdefined('attributes.department') and len(attributes.department)>
            <cfset url_str = "#url_str#&department=#attributes.department#">
        </cfif>
        <cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
            <cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
        </cfif>
    <cfelseif isdefined("attributes.event") and attributes.event is 'add'>
        <cfset attributes.start_date = DateFormat(now(),'DD/MM/YYYY')>
        <cfset attributes.finish_date = DateFormat(date_add('d',15,now()),'DD/MM/YYYY')>
        
        <cfscript>
			notice_head = '';
			if(isdefined("attributes.per_req_id"))
				get_per_req = EmployeeDemandModel.get(per_req_id:attributes.per_req_id);
				
			if(isdefined("get_per_req") and get_per_req.recordcount)
			{
				pif_id = get_per_req.personel_requirement_id;
				pif_name = get_per_req.personel_requirement_head;
				position_cat_id = get_per_req.position_cat_id;
				position_cat = get_per_req.position_cat;
				position_id = get_per_req.position_id;
				app_position =  "#get_per_req.position_name# - #get_per_req.employee_name# #get_per_req.employee_surname#";
				our_company_id = get_per_req.our_company_id;
				our_company = get_per_req.nick_name;
				branch_id = get_per_req.branch_id;
				branch = get_per_req.branch_name;
				department_id = get_per_req.department_id;
				department = get_per_req.department_head;
				staff_count = get_per_req.personel_count;
				work_detail = get_per_req.personel_detail;
			} else
			{
				pif_id = '';
				pif_name = '';
				position_cat_id = '';
				position_cat = '';
				position_id = '';
				app_position = '';
				our_company_id = '';
				our_company = '';
				branch_id = '';
				branch = '';
				department_id = '';
				department = '';
				staff_count = '';
				work_detail = '';
			}
			view_logo = '';
			view_company_name = '';
			status = 1;
			publish = '';
			company_id = '';
			company = '';
			interview_position_code = '';
			interview_par = '';
			interview_position = '';
			validator_position_code = '';
			validator_par = '';
			validator_position = '';
			notice_city = '';
			notice_cat_id = '';
			startdate = attributes.start_date;
			finishdate = attributes.finish_date;
			view_visual_notice = '';
			detail = '';			
        </cfscript>        
    <cfelseif isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'det')>
		<cfset get_notice = RecruitmentAnnounceModel.get(notice_id:attributes.notice_id)>
        
		<cfif not get_notice.RECORDCOUNT>
            <script type="text/javascript">
                alertObject({message: "<cf_get_lang no='1243.Olmayan bir ilana erişmeye çalışıyorsunuz'>"});
            </script>
        </cfif>

        <cfscript>
			//ilana ait başvuru var mı?
			get_notice_apps = RecruitmentApplicationModel.get(notice_id:attributes.notice_id);
		
            paper_number = get_notice.notice_no;
            notice_head = get_notice.notice_head;
            pif_id = get_notice.PIF_ID;
			pif_name = get_notice.PIF_NAME;
            position_cat_id = get_notice.position_cat_id;
            position_cat = get_notice.POSITION_CAT_NAME;
            position_id = get_notice.POSITION_ID;
            app_position = get_notice.POSITION_NAME;
			our_company_id = get_notice.our_company_id;
			our_company = get_notice.nick_name;
			branch_id = get_notice.branch_id;
			branch = get_notice.branch_name;
			department_id = get_notice.department_id;
			department = get_notice.department_head;
			view_logo = get_notice.is_view_logo;
			view_company_name = get_notice.is_view_company_name;
			status = get_notice.status;
			publish = get_notice.publish;
			staff_count = get_notice.count_staff;
			company_id = get_notice.company_id;
			company = get_notice.fullname;
			interview_position_code = get_notice.interview_position_code;
			interview_par = get_notice.interview_par;
			if(len(get_notice.interview_position_code)) 
				interview_position = get_notice.emp_interview;
			else if(len(get_notice.interview_par));
				interview_position = get_notice.par_interview;
			
			validator_position_code = get_notice.validator_position_code;
			validator_par = get_notice.validator_par;
			if(len(validator_position_code)) 
				validator_position = get_notice.emp_validator;
			else if(len(validator_par))
				validator_position = get_notice.par_validator;

			notice_city = get_notice.notice_city;
			notice_cat_id = get_notice.notice_cat_id;
			startdate = dateformat(get_notice.startdate,'dd/mm/yyyy');
			finishdate = dateformat(get_notice.finishdate,'dd/mm/yyyy');
			view_visual_notice = get_notice.view_visual_notice;
			work_detail = get_notice.work_detail;
			detail = get_notice.detail;
        </cfscript>
    </cfif>
    <script type="text/javascript">
        <cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
            $(document).ready(function(){
                $('#keyword').focus();
            });
            function showDepartment(branch_id)	
            {
                var branch_id = $('#branch_id').val();
                if (branch_id != "")
                {
                    var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
                    AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
                }
                else
                {
                    var myList = document.getElementById("department");
                    myList.options.length = 0;
                    var txtFld = document.createElement("option");
                    txtFld.value='';
                    txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="160.Departman">'));
                    myList.appendChild(txtFld);
                }
            }
            function showBranch(comp_id)	
            {
                var comp_id = $('#comp_id').val();
                if (comp_id != "")
                {
                    var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
                    AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang no="684.İlişkili Şubeler">');
                }
                else {
                    $('#branch_id').val("");
                    $('#department').val("");
                }
                //departman bilgileri sıfırla
                var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
                AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang no="685.İlişkili Departmanlar">');
            }
        <cfelseif isdefined("attributes.event") and attributes.event is 'add'>
            function kontrol()
            {				
                var notice_no = $('#paper_number').val();
                var get_notice_no_query = wrk_safe_query('hr_notice_no_qry','dsn',0,notice_no);
            
                var run_query = wrk_safe_query('hr_notice_detail','dsn',0,notice_no);
				if(get_notice_no_query.recordcount)
                {
                    alertObject({message: "<cf_get_lang no='1223.Aynı İlan No İle Kayıt Var! Yeni Numara Atanacaktır!'>"});
                    var run_query = wrk_safe_query('hr_notice_detail','dsn',0,notice_no);
                    var notice_num = parseFloat(run_query.BIGGEST_NUMBER) + 1;
                    var notice_num_join = $('#paper_code').val() + '-' + notice_num;
                    $('#paper_number').val() = notice_num_join;
					$('#paper_no').val() = notice_num;
                }
                if ($('#position_cat').val().length == 0) 
                {
                    $('#position_cat_id').val("");
                }
                if($('#department').val().length != 0 && $('#company').val().length != 0)
                {
                    alertObject({message: "<cf_get_lang no='1125.İlgili Firma veya Departmandan Birini Seçmelisiniz'>!"});
                    $('#position_id').val("");
					$('#app_position').val("");
					$('#department_id').val("");
                    $('#department').val("");
                    $('#branch').val("");
                    $('#branch_id').val("");
                    $('#company').val("");
                    $('#company_id').val("");
					$('#our_company').val("");
					$('#our_company_id').val("");
                    return false;
                }
				if ($('#startdate').val() != "" && $('#finishdate').val() != "")
                {
					return date_check(document.FormRecruitmentAnnounce.startdate,document.FormRecruitmentAnnounce.finishdate,"<cf_get_lang no='1123.Başlama Tarihi Bitiş Tarihinden küçük olmalıdır'> !"); 
				}
                return true;
            }
        <cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
            function kontrol()
            {
                if ($('#app_position').val().length == 0)
				{
                    $('#position_id').val("");
					$('#our_company').val("");
					$('#our_company_id').val("");
					$('#branch').val("");
					$('#branch_id').val("");
					$('#department').val("");
					$('#department_id').val("");
				}
				if ($('#position_cat').val().length == 0)
				{
                    $('#position_cat_id').val("");
				}
				                    
                if ($('#startdate').val() != "" && $('#finishdate').val() != "")
                    return date_check(document.FormRecruitmentAnnounce.startdate,document.FormRecruitmentAnnounce.finishdate,"<cf_get_lang no='1123.Başlama Tarihi Bitiş Tarihinden küçük olmalıdır'> !"); 
            }
        </cfif>
    </script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_notice';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_notice.cfm';
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn;
	
	if(isdefined("attributes.event") and attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['paperNumber'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['paperType'] = 'emp_notice';
	}
	
	if(not isdefined('attributes.formSubmittedController') and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = get_notice.stage;
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,det';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'NOTICES';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'NOTICE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-notice_head','item-startdate','item-finishdate']";
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_notice';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/form_upd_notice.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_notice&event=det&notice_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'FormRecruitmentAnnounce';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_notice';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/form_upd_notice.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_notice&event=upd&notice_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'notice_id=##attributes.notice_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_notice.notice_id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_notice';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'FormRecruitmentAnnounce';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['det']['pageParams'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['pageParams']['size'] = '9-3';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'hr.list_notice&event=det&notice_id=';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##get_notice.notice_id##';
	
	if(isdefined("attributes.event") and (attributes.event is 'det' or attributes.event is 'upd'))
	{	
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteEvent'] = 'del';
	}
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' or attributes.event is 'del' or attributes.event is 'det'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_del_notice&notice_id=#attributes.notice_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_notice';
		WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'notice_id=##attributes.notice_id##';
		WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.notice_id##';
	}
	
	if(not isdefined('attributes.formSubmittedController'))
	{
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'hr.list_notice';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'hr/form/form_upd_notice.cfm';
		WOStruct['#attributes.fuseaction#']['det']['pageObjects'] = structNew();
		
		if(isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'det'))
		{
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['type'] = 0; // Include
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceController']  = 'RecruitmentAnnounceController.cfm';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceEvent']  = 'upd';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['type'] = 1; // Custom Tag
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['file'] = '<cf_get_workcube_asset asset_cat_id="-8" module_id="3" action_section="NOTICE_ID" action_id="#attributes.notice_id#">';
		}
	}
	
	if(IsDefined("attributes.event") and attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_notice&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.notice_id#&print_type=172','page')";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

<!------------------------------------------------------
	modelden CRUD işlemleri yapılıyor...
-------------------------------------------------------->

<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
	<cfif isdefined("attributes.event") and attributes.event is 'add'>
    <!--- add modeli ve kontrolleri calisacak --->
		<cfif not len(attributes.paper_number)>
            <script type="text/javascript">
                alertObject({message: "<cf_get_lang no='1228.İlan Eklemek İçin Sistemde Belge Numarası Tanımlamanız Gerekmektedir.'>"});
            </script>
            <cfabort>
        </cfif>
        <cf_date tarih="attributes.startdate">
        <cf_date tarih="attributes.finishdate">
        
        <cfif len(attributes.paper_number)>
            <cfset control = RecruitmentAnnounceModel.controlNotice(notice_no:attributes.paper_number)>
            <cfif control.recordcount> 
                <script type="text/javascript">
                    alertObject({message: "<cf_get_lang no='1231.Aynı ilan no lu kayıt var'>!"});
                </script>
                <cfabort>
            </cfif>
        </cfif>
		<cfscript>
			if(isDefined("attributes.visual_notice") and len(attributes.visual_notice))
			{
				upload = fileUpload.fileUpload(
						file_name 		: attributes.visual_notice,
						moduleName		: 'hr'
					);
			}
			
			if(isdefined("attributes.validator_position_code") and len(attributes.validator_position_code))validator_position_code = attributes.validator_position_code;else validator_position_code = 0;
			if(isdefined("attributes.validator_position") and len(attributes.validator_position))validator_position = attributes.validator_position;else validator_position = '';
			if(isdefined("attributes.validator_par") and len(attributes.validator_par))validator_par = attributes.validator_par;else validator_par = 0;
			if(isdefined("attributes.publish") and len(attributes.publish))publish = attributes.publish;else publish = '';
			if(isdefined("attributes.city") and len(attributes.city))city = attributes.city; else city = 0;
			if(isdefined("upload") and len(upload))upload = upload; else upload = '';

			add = RecruitmentAnnounceModel.add (
				process_stage			: attributes.process_stage,
				paper_number			: attributes.paper_number,
				paper_no				: attributes.paper_no,
				notice_head				: attributes.notice_head,
				validator_position		: validator_position,
				validator_position_code	: validator_position_code,
				validator_par			: validator_par,
				notice_cat_id			: iif(isdefined("attributes.notice_cat_id") and len(attributes.notice_cat_id),attributes.notice_cat_id,0),
				status					: iif(isdefined("attributes.status"),1,0),
				detail					: iif(len(attributes.detail),attributes.detail,de("")),
				app_position			: iif(isdefined("attributes.app_position") and len(attributes.app_position),attributes.app_position,de("")),
				position_id				: iif(isdefined("attributes.position_id") and len(attributes.position_id),attributes.position_id,0),
				position_cat			: iif(isdefined("attributes.position_cat") and len(attributes.position_cat),attributes.position_cat,de("")),
				position_cat_id			: iif(isdefined("attributes.position_cat_id") and len(attributes.position_cat_id),attributes.position_cat_id,0),
				interview_position_code	: iif(len(attributes.interview_position_code),attributes.interview_position_code,0),
				interview_par			: iif(isdefined("attributes.interview_par") and len(attributes.interview_par),attributes.interview_par,0),
				valid					: iif(not len(attributes.validator_position),1,0),
				startdate				: attributes.startdate,
				finishdate				: attributes.finishdate,
				publish					: publish,
				company_id				: iif(len(attributes.company) and len(attributes.company_id),attributes.company_id,0),
				company					: iif(len(attributes.company) and len(attributes.company_id),attributes.company,de("")),
				our_company_id			: iif(isdefined("attributes.our_company_id") and len(attributes.our_company_id),attributes.our_company_id,0),
				department_id			: iif(len(attributes.department) and len(attributes.department_id),attributes.department_id,0),
				branch_id				: iif(len(attributes.branch) and len(attributes.branch_id),attributes.branch_id,0),
				city					: city,
				staff_count				: iif(len(attributes.staff_count),attributes.staff_count,0),
				work_detail				: iif(len(attributes.work_detail),attributes.work_detail,de("")),
				pif_name				: iif(isdefined("attributes.pif_name") and len(attributes.pif_name),attributes.pif_name,de("")),
				pif_id					: iif(len(attributes.pif_id) and len(attributes.pif_name),attributes.pif_id,0),
				view_logo				: iif(isdefined("attributes.view_logo"),1,0),
				view_company_name		: iif(isdefined("attributes.view_company_name"),1,0),
				view_visual_notice		: iif(isdefined("attributes.view_visual_notice"),1,0),
				visual_notice			: iif(isdefined('upload') and len(upload),upload,de(''))
			);
			attributes.actionId = add;
		</cfscript>
   	<cfelseif attributes.event is 'upd'>
        <cf_date tarih="attributes.startdate">
        <cf_date tarih="attributes.finishdate">
        
		<cfif len(attributes.paper_number)>
            <cfset control = RecruitmentAnnounceModel.controlNotice(notice_no:attributes.paper_number,notice_id:attributes.notice_id)>
            <cfif control.recordcount> 
                <script type="text/javascript">
                    alertObject({message: "<cf_get_lang no='1231.Aynı ilan no lu kayıt var'>!"});
                </script>
                <cfabort>
            </cfif>
        </cfif>
        
        <cfset get_image = RecruitmentAnnounceModel.getImage(notice_id:attributes.notice_id)>
        
        <cfif isDefined("del_visual_notice")>
            <cfif len(get_image.visual_notice)>
                <cf_del_server_file output_file="hr/#get_image.visual_notice#" output_server="#get_image.server_visual_notice_id#">
            </cfif>
            <cfset attributes.visual_notice = "">
        <cfelse>
            <cfif isDefined("attributes.visual_notice") and len(attributes.visual_notice)>
                <cfif len(get_image.visual_notice)>
                    <cf_del_server_file output_file="hr/#get_image.visual_notice#" output_server="#get_image.server_visual_notice_id#">
                </cfif>
                <cfscript>
					upload = fileUpload.fileUpload(
							file_name 		: attributes.visual_notice,
							moduleName		: 'hr'
						);
			   </cfscript>
                <cfset attributes.visual_notice = upload>
            <cfelse>
                <cfset attributes.visual_notice = get_image.visual_notice>
            </cfif>
        </cfif>
        
        <cftry>
        <cfsavecontent variable="control5">
            <cfdump var="#attributes#">
        </cfsavecontent>
        <cffile action="write" file = "c:\attt.html" output="#control5#"></cffile>
    <cfcatch></cfcatch>
    </cftry>
    	<cfscript>
			attributes.detail=replace(attributes.detail,"'"," ","all");		
			if(isdefined("attributes.validator_position_code") and len(attributes.validator_position_code))validator_position_code = attributes.validator_position_code;else validator_position_code = 0;
			if(isdefined("attributes.validator_par") and len(attributes.validator_par))validator_par = attributes.validator_par;else validator_par = 0;
			if(isdefined("attributes.valid") and len(attributes.valid)) valid = attributes.valid; else valid = "";
			if(isdefined("attributes.publish") and len(attributes.publish))publish = attributes.publish;else publish = '';
			if(isdefined("attributes.city") and len(attributes.city))city = attributes.city; else city = 0;
			if(isdefined("upload") and len(upload))upload = upload; else upload = '';
			
			upd = RecruitmentAnnounceModel.upd (
				notice_id				: attributes.notice_id,
				process_stage			: attributes.process_stage,
				paper_number			: attributes.paper_number,
				notice_head				: attributes.notice_head,
				validator_position_code	: validator_position_code,
				validator_par			: validator_par,
				notice_cat_id			: iif(isdefined("attributes.notice_cat_id") and len(attributes.notice_cat_id),attributes.notice_cat_id,0),
				status					: iif(isdefined("attributes.status"),1,0),
				detail					: iif(len(attributes.detail),attributes.detail,de("")),
				app_position			: iif(len(attributes.app_position),attributes.app_position,de("")),
				position_id				: iif(len(attributes.position_id),attributes.position_id,0),
				position_cat			: iif(len(attributes.position_cat),attributes.position_cat,de("")),
				position_cat_id			: iif(len(attributes.position_cat_id),attributes.position_cat_id,0),
				interview_position_code	: iif(len(attributes.interview_position_code),attributes.interview_position_code,0),
				interview_par			: iif(len(attributes.interview_par),attributes.interview_par,0),
				valid					: valid,
				startdate				: attributes.startdate,
				finishdate				: attributes.finishdate,
				publish					: publish,
				company_id				: iif(len(attributes.company) and len(attributes.company_id),attributes.company_id,0),
				company					: iif(len(attributes.company) and len(attributes.company_id),attributes.company,de("")),
				our_company_id			: iif(len(attributes.our_company_id),attributes.our_company_id,0),
				department_id			: iif(len(attributes.department) and isdefined("attributes.department_id") and len(attributes.department_id),attributes.department_id,0),
				branch_id				: iif(len(attributes.branch) and len(attributes.branch_id),attributes.branch_id,0),
				city					: city,
				staff_count				: iif(len(attributes.staff_count),attributes.staff_count,0),
				work_detail				: iif(len(attributes.work_detail),attributes.work_detail,de("")),
				pif_id					: iif(len(attributes.pif_id) and len(attributes.pif_name),attributes.pif_id,0),
				view_logo				: iif(isdefined("attributes.view_logo"),1,0),
				view_company_name		: iif(isdefined("attributes.view_company_name"),1,0),
				view_visual_notice		: iif(isdefined("attributes.view_visual_notice"),1,0),
				visual_notice			: upload
			);
			attributes.actionId = upd;
		</cfscript>
  	<cfelseif isdefined('attributes.event') and attributes.event is 'del'>
        <!--- del modeli ve kontrolleri calisacak --->
        <cfset get_image = RecruitmentAnnounceModel.getImage(notice_id:attributes.notice_id)>
        
        <cfif len(get_image.visual_notice)>
            <cf_del_server_file output_file="hr/#get_image.visual_notice#" output_server="#get_image.server_visual_notice_id#">
        </cfif>
        <cfscript>
			del = RecruitmentAnnounceModel.del (
				notice_id			: attributes.notice_id
				);
			attributes.actionId = attributes.notice_id;
		</cfscript>
    </cfif>
</cfif>