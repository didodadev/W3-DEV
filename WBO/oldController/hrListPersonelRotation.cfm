<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="is_filtered" default="0">
	<cfparam name="attributes.keyword" default="">
	<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
		<cf_date tarih="attributes.finishdate">
	<cfelse>
		<cfset attributes.finishdate = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
	</cfif>
	<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
		<cf_date tarih="attributes.startdate">
	<cfelse>
		<cfset attributes.startdate = date_add('ww',-1,attributes.finishdate)>
	</cfif>
	<cfif is_filtered>
		<cfquery name="get_form" datasource="#dsn#">
			SELECT
				PRF.*,
				PTR.STAGE,
				EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS EXIST_NAME,
				EP.POSITION_NAME AS EXIST_POS,
				EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS REQUEST_NAME,
				EP.POSITION_NAME AS REQUEST_POS
			FROM
				PERSONEL_ROTATION_FORM PRF
				LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = PRF.FORM_STAGE
				LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = PRF.POS_CODE_EXIST
				LEFT JOIN EMPLOYEE_POSITIONS EP2 ON EP2.POSITION_CODE = PRF.POS_CODE_REQUEST
			WHERE
				PRF.ROTATION_FORM_ID IS NOT NULL
				AND PRF.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				AND PRF.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND PRF.ROTATION_FORM_HEAD LIKE '#attributes.keyword#%'
			</cfif>
			<cfif isdefined ("attributes.form_type") and len (attributes.form_type)>
				<cfif attributes.form_type eq 1>
					AND PRF.IS_RISE =1
				<cfelseif attributes.form_type eq 2>
					AND PRF.IS_TRANSFER=1
				<cfelseif attributes.form_type eq 3>
					AND PRF.IS_ROTATION=1
				<cfelseif attributes.form_type eq 4>
					AND PRF.IS_SALARY_CHANGE=1
				</cfif>
			</cfif>
			ORDER BY 
				PRF.RECORD_DATE DESC
		</cfquery>
	<cfelse>
		<cfset get_form.recordcount = 0>
	</cfif>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default='#get_form.recordcount#'>
	<cfscript>
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		url_str = "";
		if (isdefined('attributes.keyword') and len(attributes.keyword))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (is_filtered)
			url_str = "#url_str#&is_filtered=#attributes.is_filtered#";
		if (isdate(attributes.startdate))
			url_str = url_str & "&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#";
		if (isdefined('attributes.form_type'))
			url_str = url_str & "&form_type=#(attributes.form_type)#";
		if (isdate(attributes.finishdate))
			url_str = url_str & "&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#";
	</cfscript>
<cfelseif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
	<cf_get_lang_set module_name="hr">
	<cfinclude template="../hr/query/get_moneys.cfm">
	<cfif isdefined("attributes.event") and attributes.event is 'upd'>
		<cfquery name="GET_PER_FORM" datasource="#dsn#">
			SELECT
				PRF.*,
				EP.EMPLOYEE_NAME,
				EP.EMPLOYEE_SURNAME,
				EP.POSITION_NAME,
				OC.NICK_NAME,
				D.DEPARTMENT_HEAD,
				B.BRANCH_NAME,
				SH.NAME,
				EP2.EMPLOYEE_NAME AS EMPLOYEE_NAME2,
				EP2.EMPLOYEE_SURNAME AS EMPLOYEE_SURNAME2,
				EP2.POSITION_NAME AS POSITION_NAME2,
				D2.DEPARTMENT_HEAD AS DEPARTMENT_HEAD2,
				B2.BRANCH_NAME AS BRANCH_NAME2,
				SEL.EDUCATION_NAME
			FROM
				PERSONEL_ROTATION_FORM PRF
				LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = PRF.POS_CODE_EXIST
				LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = PRF.COMPANY_EXIST
				LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = PRF.DEPARTMENT_EXIST
				LEFT JOIN BRANCH B ON B.BRANCH_ID = PRF.BRANCH_EXIST
				LEFT JOIN SETUP_HEADQUARTERS SH ON SH.HEADQUARTERS_ID = PRF.HEADQUARTERS_EXIST
				LEFT JOIN EMPLOYEE_POSITIONS EP2 ON EP2.POSITION_CODE = PRF.POS_CODE_REQUEST
				LEFT JOIN DEPARTMENT D2 ON D2.DEPARTMENT_ID = PRF.DEPARTMENT_REQUEST
				LEFT JOIN BRANCH B2 ON B2.BRANCH_ID = PRF.BRANCH_REQUEST
				LEFT JOIN SETUP_EDUCATION_LEVEL SEL ON SEL.EDU_LEVEL_ID = PRF.TRAINING_LEVEL
			WHERE
				PRF.ROTATION_FORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_rot_id#">
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
		function kontrol()
		{
			if($('#rise').is(':checked')==false && $('#transfer').is(':checked')==false && $('#rotation').is(':checked')==false && $('#salary_change').is(':checked')==false)
			{
				alert("<cf_get_lang no='527.Terfi,Transfer,Rotasyon ve Ücret Değişikliği Seçeneklerinden Birini Seçmelisiniz'>!");
				return false;
			}
			if($('#emp_name').val().length==0 || $('#pos_code').val().length==0)
			{
				alert("<cf_get_lang no='1462.Mevcut kadroya bir çalışan seçmelisiniz'>!");
				return false;
			}
			if($('#pos_request').val().length==0 || $('#pos_request_id').val().length==0)
			{
				alert("<cf_get_lang no='1463.Talep edilen unvanı seçmelisiniz'>!");
				return false;
			}
			<cfif attributes.event is 'add'>
				if($('#rotation').is(':checked') && $('#rotation_finish_date').val().length==0)
				{
					alert("<cf_get_lang no='528.Rotasyon tarihini girmelisiniz'>!");
					return false;
				}
			<cfelseif attributes.event is 'upd'>
				$('#move_amount').val(filterNum($('#move_amount').val()));
			</cfif>
			$('#salary_exist').val(filterNum($('#salary_exist').val()));
			$('#salary_request').val(filterNum($('#salary_request').val()));
			return process_cat_control();
		}
		<cfif attributes.event is 'upd'>
			function isSayi(nesne) 
			{
				inputStr=nesne.value;
				if(inputStr.length>0)
				{
					var oneChar = inputStr.substring(0,1)
					if (oneChar < "1" ||  oneChar > "9") 
					{
						nesne.focus();
					}
				}
			}
		</cfif>
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_personel_rotation_form';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_personel_rotation_form.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.add_personel_rotation_form';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_personel_rotation_form.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_personel_rotation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_personel_rotation_form&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.upd_personel_rotation_form';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_personel_rotation_form.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_personel_rotation.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_personel_rotation_form&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'per_rot_id=##attributes.per_rot_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.per_rot_id##';
	
	if(isdefined("attributes.event") and(attributes.event is 'upd' or attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_del_personel_rotation&&per_rot_id=#attributes.per_rot_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_personel_rotation.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_personel_rotation.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_personel_rotation_form';
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'hrListPersonelRotation';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PERSONEL_ROTATION_FORM';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-form_stage','item-form_type','item-form_head']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
