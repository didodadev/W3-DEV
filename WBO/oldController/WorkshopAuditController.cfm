<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Göksenin Sönmez Özkorucu		
Analys Date : 01/04/2016			Dev Date	: 20/05/2016		
Description :
	Bu controller işyeri denetim işlemleri objesine ait kontrolleri yapar modelleri çağırarak ilgili setleri çalıştırır.
----------------------------------------------------------------------->

<cfset auditsModel = CreateObject("component","model.WorkshopAuditModel")>
<cfset branches = CreateObject("component","utility.getBranch")>
<cfset departments = CreateObject("component","utility.getDepartment")>
<cfset moneys = CreateObject("component","utility.getMoneys")>

<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>    
	<cfparam name="attributes.finishdate" default="">
	<cfparam name="attributes.startdate" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.audit_type" default="">
	<cfif len(attributes.startdate)>
		<cf_date tarih = 'attributes.startdate'>
		<cfset date_1 = dateformat(attributes.startdate,'dd/mm/yyyy')>
	<cfelse>
		<cfset date_1 = "">
	</cfif>
	<cfif len(attributes.finishdate)>
		<cf_date tarih = 'attributes.finishdate'>
		<cfset date_2 = dateformat(attributes.finishdate,'dd/mm/yyyy')>
	<cfelse>
		<cfset date_2 = "">
	</cfif>
	<cfscript>
		if(isdefined("attributes.form_submit"))
		{
			if(isdefined("attributes.branch_id") and len(attributes.branch_id) and attributes.branch_id neq 0)
				branch_id = attributes.branch_id;
			else
				branch_id = '';
			if(isdefined("attributes.department") and len(attributes.department))
				department = attributes.department;
			else
				department = '';
			get_audits = auditsModel.list(
											keyword		:attributes.keyword,
											startdate	:attributes.startdate,
											finishdate	:attributes.finishdate,
											audit_type	:attributes.audit_type,
											branch_id	:branch_id,
											department	:department
											);
		}
		else
			get_audits.recordcount = 0;
		get_branches = branches.get(authorizationEhesap:session.ep.ehesap);
	</cfscript>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default=#get_audits.recordcount#>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and listfind('add,upd',attributes.event,',')>
	<cfscript>
		branches = branches.get(allData:1,authorizationEhesap:1);
		GET_MONEYS = moneys.get(periodId:session.ep.period_id);
		if(attributes.event is 'upd')
		{
			get_audit = auditsModel.get(audit_id:attributes.audit_id);
			if(len(get_audit.audit_branch_id))
				get_departmant = departments.get(branchId:get_audit.audit_branch_id);
		}
	</cfscript>
</cfif>

<script type="text/javascript">
	<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
		$(document).ready(function() {
			$('#keyword').focus();
		});	
	<cfelseif isdefined('attributes.event') and listfind('add,upd',attributes.event,',')>
		function UnformatFields()
		{
			$('#punishment_money').val(filterNum($('#punishment_money').val()));
			return true;
		}
		function showDepartment(branch_id)	
		{
			var branch_id = $('#audit_branch_id').val();
			$('#department').html('<option value=""><cf_get_lang_main no="1424.Lutfen Departman Seciniz"></option>');
			$.ajax({
				type:"get",
				url: "/V16/hr/cfc/get_departments_ajax.cfc?method=get_department&branch_id="+branch_id,
				dataType: "text",
				cache:false,
				async: false,
				success: function(res){ 
					if (res){ 
						data = $.parseJSON(res); 
						if(data.DATA.length != 0)
						{
							$.each(data.DATA, function( key, value ) {   
								var arg1 = value[0] ;
								var arg2 = value[1] ;
								$("#department").append("<option value='"+arg1+"'>"+arg2+"</option>");
							});
						}
					}
				}
			});
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn;
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEES_AUDIT';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'AUDIT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-audit_branch_id','item-auditor','item-audit_date','item-auditor_position','item-department','item-audit_type']";
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_audits';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_audits.cfm';

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_audits&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/workShopAudit.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_audits&event=upd&audit_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_audit';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_audits';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/workShopAudit.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_audits&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'audit_id=##attributes.audit_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.audit_id##';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'upd_audit';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_audit';
	
	if(IsDefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del' ))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_del_audit&audit_id=#attributes.audit_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_audit.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_audits';
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_audits&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if (IsDefined("attributes.event") and attributes.event is 'add')
	{
		audit_branch_id = '';
		auditor = '';
		audit_date = '';
		audit_recheck_date = '';
		term_date = '';
		audit_missings = '';
		audit_detail = '';
		audit_result = '';
		audit_department_id = '';
		auditor_position = '';
		audit_type = '';
		punishment_money = '';
		punishment_money_type = '';
	}
	else if (IsDefined("attributes.event") and attributes.event is 'upd')
	{
		audit_branch_id = get_audit.audit_branch_id;
		auditor = get_audit.auditor;
		audit_date = get_audit.audit_date;
		audit_recheck_date = get_audit.audit_recheck_date;
		term_date = get_audit.term_date;
		audit_missings = get_audit.audit_missings;
		audit_detail = get_audit.audit_detail;
		audit_result = get_audit.audit_result;
		audit_department_id = get_audit.audit_department_id;
		auditor_position = get_audit.auditor_position;
		audit_type = get_audit.audit_type;
		punishment_money = get_audit.punishment_money;
		punishment_money_type = get_audit.punishment_money_type;
	}
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'UnformatFields() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'UnformatFields() && validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
</cfscript>

<!------------------------------------------------------
	modelden CRUD işlemleri yapılıyor...
-------------------------------------------------------->

<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
	<cfif isdefined('attributes.event') and listFind('add,upd,del',attributes.event)>
		<cfif isdefined('attributes.term_date') and len(attributes.term_date)>
            <cf_date tarih='attributes.term_date'>
        </cfif>
        <cfif isdefined('attributes.audit_date') and len(attributes.audit_date)>
            <cf_date tarih='attributes.audit_date'>
        </cfif>
        <cfif isdefined('attributes.audit_recheck_date') and len(attributes.audit_recheck_date)>
            <cf_date tarih='attributes.audit_recheck_date'>
        </cfif>
        
		<cfscript>
            if (attributes.event is 'add')
            {        
                add = auditsModel.add (
                    audit_branch_id			: attributes.audit_branch_id,
                    department				: attributes.department,
                    audit_date				: attributes.audit_date,
                    auditor					: attributes.auditor,
                    audit_type				: attributes.audit_type,
                    auditor_position		: attributes.auditor_position,
                    audit_missings			: attributes.audit_missings,
                    audit_recheck_date		: attributes.audit_recheck_date,
                    audit_detail			: attributes.audit_detail,
                    audit_result			: attributes.audit_result,
                    punishment_money		: attributes.punishment_money,
                    punishment_money_type	: attributes.punishment_money_type,
                    term_date				: attributes.term_date
                );
                
                attributes.actionId = add;
            }
            else if (attributes.event is 'upd')
            {
                upd = auditsModel.upd (
                    audit_id				: attributes.audit_id,
                    audit_branch_id			: attributes.audit_branch_id,
                    department				: attributes.department,
                    audit_date				: attributes.audit_date,
                    auditor					: attributes.auditor,
                    audit_type				: attributes.audit_type,
                    auditor_position		: attributes.auditor_position,
                    audit_missings			: attributes.audit_missings,
                    audit_recheck_date		: attributes.audit_recheck_date,
                    audit_detail			: attributes.audit_detail,
                    audit_result			: attributes.audit_result,
                    punishment_money		: attributes.punishment_money,
                    punishment_money_type	: attributes.punishment_money_type,
                    term_date				: attributes.term_date
                );
                
                attributes.actionId = upd;
            }
            else if (attributes.event is 'del')
            {
                del = auditsModel.del (
                    audit_id				: attributes.audit_id
                );
                
                attributes.actionId = attributes.audit_id;
            }
        </cfscript>
    </cfif>
</cfif>
