<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="ehesap">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.comp_id" default="">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.process_stage" default="">
	<cfparam name="attributes.department_id" default="">
	<cfparam name="attributes.startdate" default="#dateformat(date_add('m',-1,CreateDate(year(now()),month(now()),1)),'dd/mm/yyyy')#">
	<cfparam name="attributes.finishdate" default="#dateformat(CreateDate(year(now()),month(now()),DaysInMonth(now())),'dd/mm/yyyy')#"> 
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset url_str = "">
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	<cfif isdefined('attributes.form_submit')>
		<cfset url_str = "#url_str#&form_submit=#attributes.form_submit#">
	</cfif>
	<cfif isdefined('attributes.comp_id')>
		<cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
	</cfif>
	<cfif isdefined('attributes.branch_id')>
		<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined('attributes.department')>
		<cfset url_str = "#url_str#&department=#attributes.department#">
	</cfif>
	<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
		<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
	</cfif>
	<cfif isdefined('attributes.form_submit')>
		<cfif attributes.branch_id eq "all">
	    	<cfset attributes.branch_id = "">
	    </cfif>
		<cfif attributes.comp_id eq "all">
	    	<cfset attributes.comp_id = "">
	    </cfif>
		<cfif attributes.department eq "all">
	    	<cfset attributes.department = "">
	    </cfif>
	    <cf_date tarih="attributes.startdate">
	    <cf_date tarih="attributes.finishdate">
		<cfscript>
	        get_demands = createObject("component","myhome.cfc.get_travel_demands");
	        get_demands.dsn = dsn;
	        get_travel_demand = get_demands.travel_demands
	                        (
	                         	keyword : attributes.keyword,
								comp_id : attributes.comp_id,
								branch_id : attributes.branch_id,
								department_id : attributes.department,
								process_stage : attributes.process_stage,
								startdate : attributes.startdate,
								finishdate : attributes.finishdate
	                        );
	    </cfscript>	
	<cfelse>
		<cfset get_travel_demand.recordcount = 0>
	</cfif>
	<cfscript>
		get_comp_ = createObject("component","hr.cfc.get_our_company");
		get_comp_.dsn = dsn;
		get_our_company = get_comp_.get_company();
		
		get_process = createObject("component","hr.cfc.get_process_rows");
		get_process.dsn = dsn;
		get_process_row = get_process.get_process_type_rows(
			faction : 'myhome.popup_form_add_travel_demand'
		);
		if (isdefined("attributes.comp_id") and len(attributes.comp_id) and attributes.comp_id is not "all")
		{
			branch_ = createObject("component","hr.cfc.get_branches");
            branch_.dsn = dsn;
            get_branch = branch_.get_branch(comp_id:attributes.comp_id);
		}
		if (isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all")
		{
			department = createObject("component","hr.cfc.get_departments");
            department.dsn = dsn;
            get_department = department.get_department(branch_id:attributes.branch_id);
		}
	</cfscript>
	<cfparam name="attributes.totalrecords" default="#get_travel_demand.recordcount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfquery name="get_position_detail" datasource="#dsn#">
		SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND IS_MASTER = 1
	</cfquery>
	<cfscript>
        get_comp_ = createObject("component","hr.cfc.get_our_company");
        get_comp_.dsn = dsn;
        get_our_company = get_comp_.get_company();
	</cfscript>
	<cfquery name="get_department" datasource="#dsn#">
		SELECT
        	D.DEPARTMENT_ID,
            D.DEPARTMENT_HEAD,
            B.BRANCH_NAME,
            OC.NICK_NAME
        FROM 
        	EMPLOYEE_POSITIONS EP INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
            INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
            INNER JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID
       WHERE
       		EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfif fusebox.circuit eq 'myhome'>
		<cfset attributes.travel_demand_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.travel_demand_id,accountKey:'wrk') />
	</cfif>
	<cfscript>
		get_demands = createObject("component","myhome.cfc.get_travel_demands");
		get_demands.dsn = dsn;
		get_travel_demand = get_demands.travel_demands(travel_demand_id : attributes.travel_demand_id);
		
		get_comp_ = createObject("component","hr.cfc.get_our_company");
	    get_comp_.dsn = dsn;
	    get_our_company = get_comp_.get_company();
	</cfscript>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
		function showDepartment(branch_id)	
		{
			var branch_id = document.myform.branch_id.value;
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
			var comp_id = document.myform.comp_id.value;
			if (comp_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
				AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang no="684.İlişkili Şubeler">');
			}
			else {document.myform.branch_id.value = "";document.myform.department.value ="";}
			//departman bilgileri sıfırla
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang no="685.İlişkili Departmanlar">');
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function check()
		{
			if($('#company').val() == "")
			{
				alert("<cf_get_lang_main no='162.Şirket'>");
				return false;	
			}
			if(!$(':radio[name="departure_time"]:checked').length)
			{
				alert("Gidiş Tarihi");
				return false;
			}
			if(!$(':radio[name="departure_of_time"]:checked').length)
			{
				alert("Dönüş Tarihi");
				return false;
			}
			if($('#place').val() == '')
			{
				alert("Göreve Gideceği Yer");
				return false;	
			}
			return process_cat_control();
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function check()
		{
			return process_cat_control();
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_travel_demands';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_travel_demands.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_travel_demand';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'myhome/form/form_add_travel_demand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'myhome/query/add_travel_demand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_travel_demands&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_travel_demand';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'myhome/form/form_upd_travel_demand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'myhome/query/upd_travel_demand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_travel_demands&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'travel_demand_id=##attributes.travel_demand_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_travel_demand';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'myhome/query/del_travel_demand.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'myhome/query/del_travel_demand.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_travel_demands';
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListTravelDemands.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_TRAVEL_DEMAND';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
</cfscript>
