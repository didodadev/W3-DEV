<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Göksenin Sönmez Özkorucu
Analys Date : 01/04/2016			Dev Date	: 17/05/2016		
Description :
	Bu controller çalışan yakını visiteleri objesine ait kontrolleri yapar modelleri çağırarak ilgili setleri çalıştırır.
----------------------------------------------------------------------->

<cfset visitedRelativeModel = CreateObject("component","model.ParentMedicalVisitModel")>

<cfif not isdefined('attributes.formSubmittedController')>
    <cf_get_lang_set module_name="hr">
    <cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
        <cfif not isdefined('attributes.keyword')>
            <cfset arama_yapilmali = 1>
        <cfelse>
            <cfset arama_yapilmali = 0>
        </cfif>
        <cfparam name="attributes.keyword" default="">
        <cfparam name="attributes.branch_id" default="">
        <cfparam name="attributes.startdate" default="#dateformat(date_add('m',-1,CreateDate(year(now()),month(now()),1)),'dd/mm/yyyy')#">
        <cfparam name="attributes.finishdate" default="#dateformat(CreateDate(year(now()),month(now()),DaysInMonth(now())),'dd/mm/yyyy')#"> 
        <cfinclude template="../hr/ehesap/query/get_branch_name.cfm">
        <cfif arama_yapilmali eq 1>
          <cfset get_fees_relative.recordcount = 0>
        <cfelse>
            <cfinclude template="../hr/ehesap/query/get_fees_relative.cfm">
            <cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
                <cfset attributes.finishdate = dateformat(attributes.finishdate, "dd/mm/yyyy")>
            </cfif>
            <cfif len(attributes.startdate) and isdate(attributes.startdate)>
                <cfset attributes.startdate = dateformat(attributes.startdate, "dd/mm/yyyy")>
            </cfif>
        </cfif>
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfparam name="attributes.totalrecords" default=#GET_FEES_RELATIVE.recordcount#>
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfelseif isdefined("attributes.event") and attributes.event is 'add'>
        <cfparam name="attributes.employee_id" default="">
    <cfelseif isdefined('attributes.event') and attributes.event is 'upd'>
        <cfscript>
            get_fee_relative = visitedRelativeModel.get(fee_id:attributes.fee_id);
        </cfscript>
    </cfif>
    <script type="text/javascript">
        <cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
            $(document).ready(function() {
                $('#keyword').focus();
            });
        </cfif>
    </script>
</cfif>


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
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEES_SSK_FEE_RELATIVE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'FEE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-emp_name','item-ill_name','item-ill_surname','item-ill_relative','item-birth_date','item-birth_place','item-tc_identy_no','item-date']";
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_visited_relative';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_visited_relative.cfm';

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_visited_relative&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/formParentMedicalVisit.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_visited_relative&event=upd&fee_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'ssk_fee';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_visited_relative';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/formParentMedicalVisit.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_visited_relative&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'fee_id=##attributes.fee_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.fee_id##';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'ssk_fee';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_fee_relative';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	
	if(isdefined("attributes.event") and listFind('upd,del',attributes.event))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_del_ssk_fee_relative&fee_id=#attributes.fee_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_visited_relative';
	}
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_visited_relative&event=add','medium')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if(not isdefined('attributes.formSubmittedController'))
	{
		if (IsDefined("attributes.event") and attributes.event is 'add')
		{
			employee_id = '';
			in_out_id = '';
			emp_name = '';
			branch_id = '';
			ill_name = '';
			ill_surname = '';
			ill_relative = '';
			ill_sex = 1;
			birth_date = '';
			birth_place = '';
			tc_identy_no = '';
			fee_date = '';
			fee_hour = 8;
			validator_pos_code_1 = '';
			valid_1 = '';
			valid_emp_1 = '';
			validator_pos_code_2 = '';
			valid_2 = '';
			valid_emp_2 = '';
			valid_emp = '';
			validator_pos_code = '';
		}
		else if (IsDefined("attributes.event") and attributes.event is 'upd')
		{
			employee_id = get_fee_relative.employee_id;
			in_out_id = get_fee_relative.in_out_id;
			emp_name = '#get_fee_relative.employee_name# #get_fee_relative.employee_surname#';
			branch_id = get_fee_relative.branch_id;
			branch_name = get_fee_relative.branch_name;
			ssk_office = get_fee_relative.ssk_office;
			ssk_no = get_fee_relative.ssk_no;
			ill_name = get_fee_relative.ill_name;
			ill_surname = get_fee_relative.ill_surname;
			ill_relative = get_fee_relative.ill_relative;
			ill_sex = get_fee_relative.ill_sex;
			birth_date = get_fee_relative.birth_date;
			birth_place = get_fee_relative.birth_place;
			tc_identy_no = get_fee_relative.tc_identy_no;
			fee_date = get_fee_relative.fee_date;
			fee_hour = get_fee_relative.fee_hour;
			validator_pos_code_1 = get_fee_relative.validator_pos_code_1;
			valid_1 = get_fee_relative.valid_1;
			valid_emp_1 = get_fee_relative.valid_emp_1;
			validator_pos_code_2 = get_fee_relative.validator_pos_code_2;
			valid_2 = get_fee_relative.valid_2;
			valid_emp_2 = get_fee_relative.valid_emp_2;
			valid_emp = get_fee_relative.valid_emp;
			validator_pos_code = get_fee_relative.validator_pos_code;
			valid = get_fee_relative.valid;
			valid_date_2 = get_fee_relative.valid_date_2;
			valid_date_1 = get_fee_relative.valid_date_1;
		}
	}
</cfscript>

<!------------------------------------------------------
	modelden CRUD işlemleri yapılıyor...
-------------------------------------------------------->

<cfif isdefined('attributes.event') and isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
	<cfif listFind('upd,add',attributes.event)>
    	<cfif len(attributes.fee_date)>
            <cf_date tarih="attributes.fee_date">
            <cf_date tarih="attributes.birth_date">
        </cfif>
        <cfquery name="get_in_out" datasource="#DSN#">
            SELECT START_DATE,BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
        </cfquery>
    </cfif>
    <cfif attributes.event is 'add'>
        <!--- add modeli ve kontrolleri calisacak --->
        <cfset CONTROL = date_add("D", -30, now())>
		<cfif (datediff("D",get_in_out.START_DATE,CONTROL) neq 0) and (datediff("M",get_in_out.START_DATE,CONTROL) neq 0) and (datediff("YYYY",get_in_out.START_DATE,CONTROL) NEQ 0)>
			  <script type="text/javascript">
                alertObject({message: "Çalışan Yakınına Vizite Verilebilmesi İçin 30 gün Sigorta Primi Ödenmiş Olması Gerekmektedir!"});
              </script>
              <cfabort>
        </cfif>
        
        <cfscript>            
            add = visitedRelativeModel.add (
                employee_id			: attributes.employee_id,
                feeDate				: attributes.fee_date,
                feeHour				: attributes.fee_hour,
                validator_pos_code	: iif(len(attributes.validator_pos_code),attributes.validator_pos_code,0),
                ill_name			: attributes.ill_name,
                ill_surname			: attributes.ill_surname,
                ill_relative		: attributes.ill_relative,
				ill_sex				: attributes.ill_sex,
                birth_date			: attributes.birth_date,
                birth_place			: attributes.birth_place,
                tc_identy_no		: attributes.tc_identy_no,
                branch_id			: get_in_out.branch_id,
                in_out_id			: attributes.in_out_id
            );
            
            attributes.actionId = add;
        </cfscript>
    <cfelseif attributes.event is 'upd'>
        <!--- upd modeli ve kontrolleri calisacak --->
        <cfscript>
			if(isdefined('attributes.valid') and len(attributes.valid))attributes.valid = attributes.valid; else attributes.valid = '';
			if(isdefined('attributes.validator_pos_code') and len(attributes.validator_pos_code))attributes.validator_pos_code = attributes.validator_pos_code; else attributes.validator_pos_code = 0;
			
            upd = visitedRelativeModel.upd (
				fee_id				: attributes.fee_id,
                employee_id			: attributes.employee_id,
                feeDate				: attributes.fee_date,
                feeHour				: attributes.fee_hour,
				valid 				: attributes.valid,
				validator_pos_code	: attributes.validator_pos_code,
                ill_name			: attributes.ill_name,
                ill_surname			: attributes.ill_surname,
                ill_relative		: attributes.ill_relative,
				ill_sex				: attributes.ill_sex,
                birth_date			: attributes.birth_date,
                birth_place			: attributes.birth_place,
                tc_identy_no		: attributes.tc_identy_no,
                branch_id			: get_in_out.branch_id,
                in_out_id			: attributes.in_out_id
            );
            
            attributes.actionId = upd;
        </cfscript>
    <cfelseif attributes.event is 'del'>
        <!--- del modeli ve kontrolleri calisacak --->
        <cfscript>
			del = visitedRelativeModel.del (
				fee_id			: attributes.fee_id
				);
				
			attributes.actionId = attributes.fee_id;
		</cfscript>
    </cfif>
</cfif>
