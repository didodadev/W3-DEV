<cf_get_lang_set module_name="myhome">
<cfset visitedRelativeModel = CreateObject("component","model.ParentMedicalVisitModel")>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.start_date" default="#dateformat(date_add('m',-1,CreateDate(year(now()),month(now()),1)),'dd/mm/yyyy')#">
    <cfparam name="attributes.finish_date" default="#dateformat(CreateDate(year(now()),month(now()),DaysInMonth(now())),'dd/mm/yyyy')#"> 
    <cfquery name="get_in_out" datasource="#dsn#">
        SELECT IN_OUT_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = #session.ep.userid#
    </cfquery>
    <cfif len(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    </cfif>
    <cfif len(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    </cfif>
    <cfinclude template="../myhome/query/get_visits.cfm">
    <cfinclude template="../myhome/query/get_related_visits.cfm">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#GET_FEES.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfif isdefined("attributes.my_emp_id")>
        <cfquery name="GET_POSITION_DETAIL" datasource="#dsn#">
            SELECT
                UPPER_POSITION_CODE,
                UPPER_POSITION_CODE2
            FROM
                EMPLOYEE_POSITIONS
            WHERE
                EMPLOYEE_POSITIONS.EMPLOYEE_ID=#attributes.my_emp_id# 
        </cfquery>
    </cfif>
    <cfquery name="GET_ACCIDENT_SECURITIES" datasource="#dsn#">
        SELECT 
            *
        FROM 
            EMPLOYEE_ACCIDENT_SECURITY
        <cfif isDefined("attributes.ACCIDENT_SECURITY_ID")>
        WHERE
            ACCIDENT_SECURITY_ID = #attributes.ACCIDENT_SECURITY_ID#
        </cfif>
    </cfquery>
    <cfquery name="GET_WORK_ACCIDENT_TYPE" datasource="#dsn#">
        SELECT 
            *
        FROM 
            EMPLOYEE_WORK_ACCIDENT_TYPE
        <cfif isDefined("attributes.ACCIDENT_TYPE_ID")>
        WHERE
            ACCIDENT_TYPE_ID = #attributes.ACCIDENT_TYPE_ID#
        </cfif>
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
        <cfset attributes.fee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.fee_id,accountKey:session.ep.userid)>
        <cfset attributes.my_emp_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.my_emp_id,accountKey:session.ep.userid)>
        <cfset attributes.inout_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.inout_id,accountKey:session.ep.userid)>
    <cfquery name="GET_FEE" datasource="#dsn#">
        SELECT
            ES.*,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
        FROM
            EMPLOYEES_SSK_FEE ES,
            EMPLOYEES E
        WHERE 
            E.EMPLOYEE_ID = ES.EMPLOYEE_ID
            AND ES.FEE_ID = #attributes.FEE_ID#
    </cfquery>
    <cfif len(GET_FEE.BRANCH_ID)>
        <cfquery name="get_ssk_offices" datasource="#dsn#">
            SELECT
                BRANCH_NAME,		
                SSK_OFFICE,
                SSK_NO
            FROM
                BRANCH
            WHERE
                BRANCH_ID = #GET_FEE.BRANCH_ID#
        </cfquery>
    </cfif>
    <cfquery name="GET_ACCIDENT_SECURITIES" datasource="#dsn#">
        SELECT 
            *
        FROM 
            EMPLOYEE_ACCIDENT_SECURITY
        <cfif isDefined("attributes.ACCIDENT_SECURITY_ID")>
        WHERE
            ACCIDENT_SECURITY_ID = #attributes.ACCIDENT_SECURITY_ID#
        </cfif>
    </cfquery>
    <cfquery name="GET_WORK_ACCIDENT_TYPE" datasource="#dsn#">
        SELECT 
            *
        FROM 
            EMPLOYEE_WORK_ACCIDENT_TYPE
        <cfif isDefined("attributes.ACCIDENT_TYPE_ID")>
        WHERE
            ACCIDENT_TYPE_ID = #attributes.ACCIDENT_TYPE_ID#
        </cfif>
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'add_relative'>
	<cf_get_lang_set module_name="hr">
	<cfif isdefined("attributes.my_emp_id")>
        <cfquery name="GET_POSITION_DETAIL" datasource="#dsn#">
            SELECT
                UPPER_POSITION_CODE,
                UPPER_POSITION_CODE2
            FROM
                EMPLOYEE_POSITIONS
            WHERE
                EMPLOYEE_POSITIONS.EMPLOYEE_ID=#attributes.my_emp_id# 
        </cfquery>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_relative'>
    <cfscript>
		attributes.fee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.fee_id,accountKey:session.ep.userid);
        get_fee_relative = visitedRelativeModel.get(fee_id:attributes.fee_id);
    </cfscript>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_other'>
        <cfset attributes.fee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.fee_id,accountKey:session.ep.userid)>
        <cfset attributes.my_emp_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.my_emp_id,accountKey:session.ep.userid)>
        <cfset attributes.inout_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.inout_id,accountKey:session.ep.userid)>
    <cfquery name="GET_VISITS" datasource="#DSN#">
        SELECT 
            * 
        FROM 
            EMPLOYEES_SSK_FEE 
        WHERE 
            FEE_ID = #attributes.FEE_ID#
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_other_relative'>
        <cfset attributes.fee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.fee_id,accountKey:session.ep.userid)>
        <cfset attributes.my_emp_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.my_emp_id,accountKey:session.ep.userid)>
        <cfset attributes.inout_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.inout_id,accountKey:session.ep.userid)>
    <cfquery name="GET_VISITS" datasource="#DSN#">
        SELECT 
            * 
        FROM 
            EMPLOYEES_SSK_FEE_RELATIVE
        WHERE 
            FEE_ID = #attributes.FEE_ID#
    </cfquery>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function kontrol()
		{
			if (ssk_fee.emp_name.value == "")
			{
				alert("<cf_get_lang_main no='1701.Çalışan Girmelisinz'>!");
						return false;
			}
			return true;
		}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_my_visits';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_my_visits.cfm';
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.popup_ssk_fee_self';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'myhome/form/add_ssk_fee_self.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'myhome/query/add_ssk_fee_self.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.list_my_visits';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.popup_upd_ssk_fee_self';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'myhome/form/upd_ssk_fee_self.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'myhome/query/upd_ssk_fee_self.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.list_my_visits';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'FEE_ID=##attributes.FEE_ID##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.FEE_ID##';
		
	if(attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=hr.list_visited&event=del&fee_id=#attributes.fee_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_ssk_fee_self.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_ssk_fee_self.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'myhome.list_my_visits';
	}
	
	WOStruct['#attributes.fuseaction#']['add_relative'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_relative']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add_relative']['fuseaction'] = 'myhome.popup_ssk_fee_relative';
	WOStruct['#attributes.fuseaction#']['add_relative']['filePath'] = 'hr/ehesap/form/formParentMedicalVisit.cfm';
	WOStruct['#attributes.fuseaction#']['add_relative']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add_relative']['nextEvent'] = 'myhome.list_my_visits&event=upd_relative&fee_id=';
	WOStruct['#attributes.fuseaction#']['add_relative']['formName'] = 'ssk_fee';
	
	WOStruct['#attributes.fuseaction#']['add_relative']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add_relative']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add_relative']['buttons']['saveFunction'] = 'validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd_relative'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_relative']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_relative']['fuseaction'] = 'myhome.popup_upd_ssk_fee_relative';
	WOStruct['#attributes.fuseaction#']['upd_relative']['filePath'] = 'hr/ehesap/form/formParentMedicalVisit.cfm';
	WOStruct['#attributes.fuseaction#']['upd_relative']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd_relative']['nextEvent'] = 'myhome.list_my_visits&event=upd_relative';
	WOStruct['#attributes.fuseaction#']['upd_relative']['parameters'] = 'FEE_ID=##attributes.FEE_ID##';
	WOStruct['#attributes.fuseaction#']['upd_relative']['Identity'] = '##attributes.FEE_ID##';
	WOStruct['#attributes.fuseaction#']['upd_relative']['formName'] = 'ssk_fee';
	WOStruct['#attributes.fuseaction#']['upd_relative']['recordQuery'] = 'get_fee_relative';
	
	WOStruct['#attributes.fuseaction#']['upd_relative']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_relative']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd_relative']['buttons']['updateFunction'] = 'validate().check()';
	WOStruct['#attributes.fuseaction#']['upd_relative']['buttons']['delete'] = 1;
	
	if(isdefined("attributes.event") and listFind('upd_relative,del_relative',attributes.event))
	{
		WOStruct['#attributes.fuseaction#']['del_relative'] = structNew();
		WOStruct['#attributes.fuseaction#']['del_relative']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['del_relative']['fuseaction'] = 'hr.list_visited_relative&event=del_relative&fee_id=#attributes.fee_id#';
		WOStruct['#attributes.fuseaction#']['del_relative']['filePath'] = '';
		WOStruct['#attributes.fuseaction#']['del_relative']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del_relative']['nextEvent'] = '';
	}
	
	WOStruct['#attributes.fuseaction#']['upd_other'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_other']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_other']['fuseaction'] = 'myhome.popup_upd_ssk_fee_self_other';
	WOStruct['#attributes.fuseaction#']['upd_other']['filePath'] = 'myhome/form/upd_ssk_fee_self_other.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd_other_relative'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_other_relative']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd_other_relative']['fuseaction'] = 'myhome.popup_upd_ssk_fee_self_other_rel';
	WOStruct['#attributes.fuseaction#']['upd_other_relative']['filePath'] = 'myhome/form/upd_ssk_fee_self_other_rel.cfm';
	
	if(not isdefined('attributes.formSubmittedController'))
	{
		if (IsDefined("attributes.event") and attributes.event is 'add_relative')
		{
			if (isdefined("attributes.my_emp_id"))
				employee_id = attributes.my_emp_id;
			else
				employee_id = '';
			if (isdefined("attributes.inout_id"))
				in_out_id = attributes.inout_id;
			else
				in_out_id = '';
			if (isdefined("attributes.my_emp_id"))
				emp_name = get_emp_info(attributes.my_emp_id,0,0);
			else
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
			if (isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code") and len(get_position_detail.upper_position_code))
				validator_pos_code_1 = get_position_detail.upper_position_code;
			else
				validator_pos_code_1 = '';
			valid_1 = '';
			if (isdefined("attributes.my_emp_id") and isdefined("get_position_detail.upper_position_code2") and len(get_position_detail.upper_position_code2))
				validator_pos_code_2 = get_position_detail.upper_position_code2;
			else
				validator_pos_code_2 = '';
			valid_2 = '';
			valid_emp = '';
			validator_pos_code = '';
		}
		else if (IsDefined("attributes.event") and attributes.event is 'upd_relative')
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
			valid_date_2 = get_fee_relative.valid_date_2;
			valid_date_1 = get_fee_relative.valid_date_1;
		}
	}
</cfscript>

<cfif isdefined('attributes.event') and isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
	<cfif listFind('add_relative,upd_relative',attributes.event)>
    	<cfif isdefined("attributes.fee_date") and len(attributes.fee_date)>
            <cf_date tarih="attributes.fee_date">
            <cf_date tarih="attributes.birth_date">
        </cfif>
        <cfquery name="get_in_out" datasource="#DSN#">
            SELECT START_DATE,BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
        </cfquery>
   	</cfif>
        
	<cfif attributes.event is 'add_relative'>
        <cfset CONTROL = date_add("D", -30, now())>
        <cfif (datediff("D",get_in_out.START_DATE,CONTROL) neq 0) and (datediff("M",get_in_out.START_DATE,CONTROL) neq 0) and (datediff("YYYY",get_in_out.START_DATE,CONTROL) NEQ 0)>
			<script type="text/javascript">
				alertObject({message: "Çalışan Yakınına Vizite Verilebilmesi İçin 30 gün Sigorta Primi Ödenmiş Olması Gerekmektedir!"});
			</script>
            <cfabort>
        </cfif>
        
        <!--- add modeli ve kontrolleri calisacak --->
        <cfscript>            
            add = visitedRelativeModel.add (
                employee_id			: attributes.employee_id,
                feeDate				: attributes.fee_date,
                feeHour				: attributes.fee_hour,
                ill_name			: attributes.ill_name,
                ill_surname			: attributes.ill_surname,
                ill_relative		: attributes.ill_relative,
                ill_sex				: attributes.ill_sex,
                birth_date			: attributes.birth_date,
                birth_place			: attributes.birth_place,
                tc_identy_no		: attributes.tc_identy_no,
                branch_id			: get_in_out.branch_id,
                in_out_id			: attributes.in_out_id,
                validator_pos_code_1: iif(len(attributes.validator_pos_code_1),attributes.validator_pos_code_1,0),
                validator_pos_code_2: iif(len(attributes.validator_pos_code_2),attributes.validator_pos_code_2,0),
                fbx_myhome			: 1
            );
            
            attributes.actionId = add;
        </cfscript>
    <cfelseif listFind('upd_relative',attributes.event)>
        <!--- upd modeli ve kontrolleri calisacak --->
        <cfscript>            
            upd = visitedRelativeModel.upd (
                employee_id			: attributes.employee_id,
                feeDate				: attributes.fee_date,
                feeHour				: attributes.fee_hour,
                ill_name			: attributes.ill_name,
                ill_surname			: attributes.ill_surname,
                ill_relative		: attributes.ill_relative,
                ill_sex				: attributes.ill_sex,
                birth_date			: attributes.birth_date,
                birth_place			: attributes.birth_place,
                tc_identy_no		: attributes.tc_identy_no,
                branch_id			: get_in_out.branch_id,
                in_out_id			: attributes.in_out_id,
                fee_id				: attributes.fee_id
            );
            
            attributes.actionId = upd;
        </cfscript>
    <cfelseif attributes.event is 'del_relative'>
        <!--- del modeli ve kontrolleri calisacak --->
        <cfscript>
            del = visitedRelativeModel.del (
                fee_id			: attributes.fee_id
                );
                
            attributes.actionId = attributes.fee_id;
        </cfscript>
    </cfif>
</cfif>
