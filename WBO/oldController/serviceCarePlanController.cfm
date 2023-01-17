<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Semih Bozal		
Analys Date : 01/04/2016			Dev Date	: 21/05/2016		
Description :
	* Bu controller bakım planı objesine ait kontrolleri yapar modelleri çağırarak ilgili setleri çalıştırır.
	
	* add,upd ve list eventlerini içerisinde barındırır.
----------------------------------------------------------------------->

<!------------------------------------------------------
	Event lere göre kontroller yapılıyor
-------------------------------------------------------->

<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.is_active" default="1">
    <cfparam name="attributes.care_type" default="">
    <cfparam name="attributes.period_type" default="">
    <cfparam name="attributes.product_id" default="">
		<cfif isdefined("attributes.form_submitted")>
            <cfscript>
				get_service_care = serviceCarePlanModel.list(
					keyword 	: attributes.keyword,
					is_active	: attributes.is_active					
				);
			</cfscript>

        <cfelse>
            <cfset get_service_care.recordcount = 0>
        </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_service_care.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	<cfscript>
    	status = 1;
		careDescription = '';
		productId = '';
		productName = '';
		serialNo = '';
		mark = '';
		memberId = '';
		memberType = '';
		company = '';
		memberName = '';
		salesDate = '';
		guarantyStartDate = '';
		guarantyFinishDate = '';
		action_date = now();
		finishDate = '';
		employeeId = '';
		employee = '';
		employeeId2 = '';
		employee2 = '';
		serviceMemberId = '';
		serviceMemberType = '';
		serviceCompany = '';
		serviceMemberName = '';
		get_service_care.detail = '';
    </cfscript>	    
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
    <cfscript>
		care_states = serviceCarePlanModel.getCareStates(id:attributes.id);
		get_service_care = serviceCarePlanModel.get(id:attributes.id);
    	status = get_service_care.status;
		careDescription = get_service_care.care_description; 
		productId = get_service_care.product_id;
		productName = get_service_care.product_name;
		serialNo = get_service_care.serial_no;
		mark = get_service_care.mark;
		memberId = get_service_care.company_authorized;
		memberType = get_service_care.company_authorized_type;
		company = get_service_care.company;
		memberName = get_service_care.name;
		salesDate = get_service_care.sales_date;
		guarantyStartDate = get_service_care.guaranty_start_date;
		guarantyFinishDate = get_service_care.guaranty_finish_date;
		action_date = get_service_care.start_date;
		finishDate = get_service_care.finish_date;
		employeeId = get_service_care.service_employee;
		employee = get_emp_info(get_service_care.service_employee,0,0);
		employeeId2 = get_service_care.service_employee2;
		employee2 = get_emp_info(get_service_care.service_employee2,0,0);
		serviceMemberId = get_service_care.service_authorized_id;
		serviceMemberType = get_service_care.service_authorized_type;
		serviceCompany = get_service_care.company1;
		serviceMemberName = get_service_care.name1;		
    </cfscript>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<script type="text/javascript">
		$(document).ready(function(){
			$('#keyword').focus();
		});
    </script>
</cfif>
<cfif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfscript>
		get_service_care_period =  getServiceCarePeriod.get();
    	get_service_care_cat = getServiceCarePlanCat.get();	
    </cfscript>
	<script type="text/javascript">
		function add_row()
		{
			row_count = document.getElementById('record_num').value ; 
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onClick="sil(' + row_count + ');"><img src="/images/delete_list.gif" align="absmiddle" border="0" alt="<cf_get_lang_main no ='51.sil'>"></a>';							
	
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			
			document.getElementById('record_num').value=row_count;

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="service_care_cat' + row_count +'" id="service_care_cat' + row_count +'" style="width:100;"><option value=""><cfoutput query="get_service_care_cat"><option value="#service_carecat_id#">#service_care#</option></cfoutput></select>'+ ' ' + '<input type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'">';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="period' + row_count +'" id="period' + row_count +'" style="width:100;"><cfoutput query="get_service_care_period"><option value="#period_id#">#period_name#</option></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="day' + row_count +'" id="day' + row_count +'" style="width:100;"><cfoutput><cfloop from="0" to="30" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="hour' + row_count +'" id="hour' + row_count +'" style="width:100;"><cfoutput><cfloop from="0" to="24" index="i"><option value="#i#">#i#</option></cfloop></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="minute' + row_count +'" id="minute' + row_count +'" style="width:100;"><cfoutput><cfloop from="0" to="55" index="i" step=5><option value="#i#">#i#</option></cfloop></cfoutput></select>';
			
		}
		function sil(sy)
		{
			var my_element=document.getElementById('row_kontrol'+sy);
			my_element.value = 0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
		}
	</script>
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
	
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn3; // Transaction icin yapildi.*/
	

	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SERVICE_CARE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PRODUCT_CARE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-care_description','item-product_id','item-company','item-member_name','item-start_date']";	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'service.FormServiceCarePlan';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'service/form/FormServiceCarePlan.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'service.ListServiceCarePlan&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'service_care';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'validate().check()';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'service.FormServiceCarePlan';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'service/form/FormServiceCarePlan.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'service.ListServiceCarePlan&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';	
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'service_care';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_service_care';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryRecordEmp'] = 'RECORD_EMP';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'service.ListServiceCarePlan';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'service/display/ListServiceCarePlan.cfm';
	// Upd //
	if(isdefined("attributes.event") and listfindNoCase('del,upd',attributes.event,','))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'service.del_service_care&id=#attributes.id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'service.ListServiceCarePlan';

	}
	if(isdefined("attributes.event") and (attributes.event is 'upd'))
		{			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=service.ListServiceCarePlan&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";			
	
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
</cfscript>

<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
    <cf_date tarih="attributes.action_date">
    <cfif isdefined('attributes.event') and attributes.event is not 'del'>
		<cfif len(attributes.sales_date)><cf_date tarih="attributes.sales_date"></cfif>
        <cfif len(attributes.guaranty_start_date)><cf_date tarih="attributes.guaranty_start_date"></cfif>
        <cfif len(attributes.guaranty_finish_date)><cf_date tarih="attributes.guaranty_finish_date"></cfif>
        <cfif len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
    </cfif>
		<cfif isdefined('attributes.event') and attributes.event is 'add'>
        <!--- add --->
        <cfscript>
			if(len(attributes.document))
			{
				upload = fileUpload.fileUpload(
					file_name 		: attributes.document,
					warningFormat 	: lang_array_main.item[2644],
					warning 		: lang_array_main.item[43],
					moduleName		: 'service'
				);
			} else upload = '';
			
			if(isdefined('attributes.status') and len(attributes.status)) attributes.status = 1;else attributes.status = 0;	
            add = serviceCarePlanModel.add (
				status 					: attributes.status,
				care_description 		: attributes.care_description,
				product_id 				: attributes.product_id,
				product_name 			: attributes.product_name,
				serial_no 				: attributes.serial_no,
				mark 					: attributes.mark,
				member_id 				: attributes.member_id,
				member_type 			: attributes.member_type,
				company 				: attributes.company,
				member_name 			: attributes.member_name,
				sales_date 				: attributes.sales_date,
				guaranty_start_date 	: attributes.guaranty_start_date,
				guaranty_finish_date 	: attributes.guaranty_finish_date,
				action_date 			: attributes.action_date,
				finish_date 			: attributes.finish_date,
				employee_id 			: iif(isdefined('attributes.employee_id') and len(attributes.employee_id), attributes.employee_id,0),
				employee 				: attributes.employee,
				employee_id2 			: iif(isdefined('attributes.employee_id2') and len(attributes.employee_id2), attributes.employee_id2,0),
				employee2 				: attributes.employee2,
				service_member_id 		: iif(isdefined('attributes.service_member_id') and len(attributes.service_member_id), attributes.service_member_id,0),
				service_member_type 	: attributes.service_member_type,
				service_company 		: attributes.service_company,
				service_member_name 	: attributes.service_member_name,
				aim 					: attributes.aim,
				mark					: attributes.mark,
				file_name				: upload
			
            );
            attributes.actionId = add;
		</cfscript>
    <cfelseif isdefined('attributes.event') and attributes.event is 'upd'>
        <!--- upd --->
        <cfscript>
			if(isdefined("attributes.status") and len(attributes.status)) attributes.status = 1;else attributes.status = 0;
						
			if(len(attributes.document))
			{			
				upload = fileUpload.fileUpload(
					file_name 		: attributes.document,
					warningFormat 	: lang_array_main.item[2644],
					warning 		: lang_array_main.item[43],
					moduleName		: 'service'
				);
			} else upload = '';
			
			upd = serviceCarePlanModel.upd (
				id						: attributes.id,
				status 					: attributes.status,
				care_description 		: attributes.care_description,
				product_id 				: attributes.product_id,
				product_name 			: attributes.product_name,
				serial_no 				: attributes.serial_no,
				mark 					: attributes.mark,
				member_id 				: attributes.member_id,
				member_type 			: attributes.member_type,
				company 				: attributes.company,
				member_name 			: attributes.member_name,
				sales_date 				: attributes.sales_date,
				guaranty_start_date 	: attributes.guaranty_start_date,
				guaranty_finish_date 	: attributes.guaranty_finish_date,
				action_date 			: attributes.action_date,
				finish_date 			: attributes.finish_date,
				employee_id 			: iif(isdefined('attributes.employee_id') and len(attributes.employee_id), attributes.employee_id,0),
				employee 				: attributes.employee,
				employee_id2 			: iif(isdefined('attributes.employee_id2') and len(attributes.employee_id2), attributes.employee_id2,0),
				employee2 				: attributes.employee2,
				service_member_id 		: iif(isdefined('attributes.service_member_id') and len(attributes.service_member_id), attributes.service_member_id,0),
				service_member_type 	: attributes.service_member_type,
				service_company 		: attributes.service_company,
				service_member_name 	: attributes.service_member_name,
				aim 					: attributes.aim,
				mark					: attributes.mark,
				file_name				: upload
			
            );
			attributes.actionId = upd;	
			
			delCareStates = serviceCarePlanModel.delCareStates(id:attributes.id);
			
			for(i=1;i<=attributes.record_num;i++)
			{
			    if ( evaluate("attributes.row_kontrol"&+i)  neq 0 )	
				{	
					add_care = serviceCarePlanModel.addCareStates(
						care_id: iif(len(evaluate("attributes.service_care_cat"&+i)),evaluate("attributes.service_care_cat"&+i),0),
						id	   : attributes.id,
						period : iif(len(evaluate("attributes.period"&+i)),evaluate("attributes.period"&+i),0),
						day_   : iif(len(evaluate("attributes.day"&+i)),evaluate("attributes.day"&+i),0),
						hour_  : iif(len(evaluate("attributes.hour"&+i)),evaluate("attributes.hour"&+i),0),
						minute_: iif(len(evaluate("attributes.minute"&+i)),evaluate("attributes.minute"&+i),0),
						status : attributes.status
					);
				}
			}
       </cfscript>
	<cfelseif isdefined('attributes.event') and attributes.event is 'del'>
        <!--- del modeli ve kontrolleri calisacak --->
        <cfscript>
			get_service_care = serviceCarePlanModel.get(id:attributes.id);
			del = serviceCarePlanModel.del (
				id			: attributes.id,
				file_name 	: get_service_care.file_name
				);				
			attributes.actionId = attributes.id;
		</cfscript>
    </cfif>
</cfif>
