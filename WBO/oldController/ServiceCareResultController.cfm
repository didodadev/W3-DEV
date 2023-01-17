<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Semih Bozal		
Analys Date : 01/04/2016			Dev Date	: 25/05/2016		
Description :
	* Bu controller bakım sonucu objesine ait kontrolleri yapar modelleri çağırarak ilgili setleri çalıştırır.
	
	* add,upd ve list eventlerini içerisinde barındırır.
----------------------------------------------------------------------->

<!------------------------------------------------------
	Event lere göre kontroller yapılıyor
-------------------------------------------------------->
<!--- add,upd,list utility --->
<cfscript>
	get_service_sub_status = getServiceSubStatus.get();
</cfscript>

<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.service_care" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.task_par_id" default="">
    <cfparam name="attributes.task_cmp_id" default="">
    <cfparam name="attributes.task_par_id2" default="">
    <cfparam name="attributes.task_cmp_id2" default="">
    <cfparam name="attributes.task_employee_id" default="">
    <cfparam name="attributes.task_person_name" default="">
    <cfparam name="attributes.task_employee_id2" default="">
    <cfparam name="attributes.task_person_name2" default="">
    <cfparam name="attributes.service_substatus_id" default="">
    <cfif isdefined("attributes.form_submitted")>
    <cfif len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
	<cfif len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
		<cfscript> 
            get_service_report = serviceCareResultModel.list(
                keyword 	 	 	 : attributes.keyword,
                service_care 	 	 : attributes.service_care,
                start_date   	 	 : attributes.start_date,
                finish_date  	 	 : attributes.finish_date,
                task_employee_id 	 : iif(len(attributes.task_employee_id), attributes.task_employee_id,0),
                task_employee_id2	 : iif(len(attributes.task_employee_id2), attributes.task_employee_id2,0),
                product_id 		 	 : iif(len(attributes.product_id), attributes.product_id,0),
                company_id 		 	 : iif(len(attributes.company_id), attributes.company_id,0),
                consumer_id 	 	 : iif(len(attributes.consumer_id), attributes.consumer_id,0),
				service_substatus_id : iif(len(attributes.service_substatus_id), attributes.service_substatus_id,0)			
            );
        </cfscript>
    <cfelse>
        <cfset get_service_report.recordcount = 0>
    </cfif>    
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default=#get_service_report.recordcount#>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	<cfscript>
		get_service_care_con.contract_head = '';
		get_service_care_con.product_id = '';
		get_service_care_con.product_name = '';
		get_service_care_con.serial_no = '';
		get_service_care_con.company_partner_id = '';
		get_service_care_con.company_partner_type = '';
		get_service_care_con.company = '';
		get_service_care_con.name = '';
		get_service_care_con.employee1_id = '';
		get_service_care_con.employee2_id = '';
		get_service_care_con.care_date = '';
		get_service_care_con.care_finish_date = '';
		get_service_care_con.detail = '';
		get_service_care_con.care_cat = '';
		get_service_care_con.service_substatus = '';
		get_service_care_con.serial_no = '';
    </cfscript>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
    <cfscript>
    	get_service_care_con = serviceCareResultModel.get(
    		id : attributes.id
    	);
	</cfscript>
</cfif>
<cfif isdefined("attributes.event") and listfindnocase("add,upd",attributes.event)>	
	<cfif len(get_service_care_con.care_date)>
        <cfset start_hour = hour(get_service_care_con.care_date)>
    <cfelse>
        <cfset start_hour = 0>	
    </cfif>
    <cfif len(get_service_care_con.care_date)>
        <cfset start_minute = minute(get_service_care_con.care_date)>
    <cfelse>
        <cfset start_minute = 0>	
    </cfif>
    <cfif len(get_service_care_con.care_date)>
        <cfset finish_hour = hour(get_service_care_con.care_finish_date)>
    <cfelse>
        <cfset finish_hour = 0>	
    </cfif>
    <cfif len(get_service_care_con.care_finish_date)>
        <cfset finish_minute = minute(get_service_care_con.care_finish_date)>
    <cfelse>
        <cfset finish_minute = 0>	
    </cfif>   
</cfif>
<script type="text/javascript">
	//Event : list
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	$(document).ready(function(){
			$('#list_care.keyword').focus();
			});
	</cfif>	
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn3; // Transaction icin yapildi.*/
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SERVICE_CARE_REPORT';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CARE_REPORT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-contract_head,item-product_id,item-serial_no,item-service_start_date']";
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'service.form_add_service_care_report';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'service/form/FormServiceCareResult.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'service.ListServiceCareResult&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'service_contract';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'validate().check()';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'service.form_upd_service_care_report';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'service/form/FormServiceCareResult.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'service.ListServiceCareResult&event=upd&id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'service_contract';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_service_care_con';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryRecordEmp'] = 'RECORD_EMP';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'service.ListServiceCareResult';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'service/display/ListServiceCareResult.cfm';
	// Upd //
	if(isdefined("attributes.event") and listfindnocase('upd,del',attributes.event))
	{
	
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'service.emptypopup_del_service_care_contract&id=#attributes.id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'service.ListServiceCareResult';
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=service.ListServiceCareResult&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";			
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
		
	}
</cfscript>

<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
    <cfif isdefined('attributes.event') and attributes.event is not 'del'>
		<cfif isdefined("attributes.service_start_date") and len(attributes.service_start_date)>
        	<cf_date tarih='attributes.service_start_date'>
        	<cfscript>
        		if(len(attributes.start_clock))
            		attributes.service_start_date = date_add('h',attributes.start_clock, attributes.service_start_date);
        		if(len(attributes.start_minute))
            		attributes.service_start_date = date_add('n',attributes.start_minute, attributes.service_start_date);
        	</cfscript>
        </cfif>
    	<cfif isdefined("attributes.service_finish_date") and  len(attributes.service_finish_date)>
        	<cf_date tarih='attributes.service_finish_date'>
        	<cfscript>
            	if(len(attributes.finish_clock))
            	    attributes.service_finish_date = date_add('h',attributes.finish_clock, attributes.service_finish_date);
            	if(len(attributes.finish_minute))
            	    attributes.service_finish_date = date_add('n',attributes.finish_minute, attributes.service_finish_date);
        	</cfscript>
    	</cfif>
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
            
            add = serviceCareResultModel.add (
                serial_no 				: attributes.serial_no,
                service_member_type		: attributes.service_member_type,
                service_member_id		: iif(len(attributes.service_member_id),attributes.service_member_id,0),
                employee_id 			: iif(len(attributes.employee_id),attributes.employee_id,0),
                employee_id2 			: iif(len(attributes.employee_id2),attributes.employee_id2,0),
                file_name 				: upload,
                service_start_date 		: attributes.service_start_date,
                service_finish_date 	: attributes.service_finish_date,
                detail 					: attributes.detail,
                product_id 				: attributes.product_id,
                service_substatus 		: iif(len(attributes.service_substatus),attributes.service_substatus,0),
                contract_head 			: attributes.contract_head,
                service_care 			: iif(len(attributes.service_care),attributes.service_care,0)	
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
			
			upd = serviceCareResultModel.upd (
				id 						: attributes.id,	
				serial_no 				: attributes.serial_no,
                service_member_type		: attributes.service_member_type,
                service_member_id		: iif(len(attributes.service_member_id),attributes.service_member_id,0),
                employee_id 			: iif(len(attributes.employee_id),attributes.employee_id,0),
                employee_id2 			: iif(len(attributes.employee_id2),attributes.employee_id2,0),
                file_name 				: upload,
                service_start_date 		: attributes.service_start_date,
                service_finish_date 	: attributes.service_finish_date,
                detail 					: attributes.detail,
                product_id 				: attributes.product_id,
                service_substatus 		: iif(len(attributes.service_substatus),attributes.service_substatus,0),
                contract_head 			: attributes.contract_head,
                service_care 			: iif(len(attributes.service_care),attributes.service_care,0)	
            );
			attributes.actionId = upd;	
       </cfscript>
	 <cfelseif isdefined('attributes.event') and attributes.event is 'del'>
        <!--- del modeli ve kontrolleri calisacak --->
        <cfscript>
			get_service_care_con = serviceCareResultModel.get(id:attributes.id);
			del = serviceCareResultModel.del (
				id			: attributes.id,
				file_name 	: get_service_care_con.file_name
				);				
			attributes.actionId = attributes.id;
		</cfscript>
    </cfif>
</cfif>

