<!--- START EMPLOYEE QUERY --->
<cfset cmp = createObject("component","V16.hr.cfc.add_rapid_emp")>
<!--- EMPLOYEE PROCESS STAGE --->
<cfset attributes.process_stage1 = listFirst(attributes.process_stage,',')>
<!--- POSITION PROCESS STAGE --->
<cfset attributes.process_stage2 = listLast(attributes.process_stage,',')>

<cfif len(attributes.employee_password)>
	<cf_cryptedpassword password="#employee_password#" output="sifreli" mod="1">
	<cfset add_iam_cmp = createObject("V16.hr.cfc.add_iam")>
	<cfset add_iam = add_iam_cmp.add_iam(
		username : attributes.employee_username,
		member_name : attributes.employee_name,
		member_sname : attributes.employee_surname,
		password : sifreli,
		pr_mail : isdefined("attributes.employee_email_spc") ? attributes.employee_email_spc : "",
		sec_mail : isdefined("attributes.employee_email_spc") ? attributes.employee_email_spc : "",
		mobile_code : isdefined("attributes.mobilcode") ? attributes.mobilcode : "",
		mobile_no : isdefined("attributes.MOBILTEL") ? attributes.MOBILTEL : "",
		is_add : 1
	)>
</cfif>

<cfif not isDefined("form.employee_status")>
	<cfset form.employee_status = 1>
</cfif>

<cftransaction>
    <cfset LAST_ID = cmp.add_employee(
        EMPLOYEE_STATUS:EMPLOYEE_STATUS,
        EMPLOYEE_NAME:attributes.EMPLOYEE_NAME,
        EMPLOYEE_SURNAME:attributes.EMPLOYEE_SURNAME,
        EMPLOYEE_EMAIL:attributes.employee_email_spc,
        EMPLOYEE_USERNAME:EMPLOYEE_USERNAME,
        EMPLOYEE_PASSWORD:EMPLOYEE_PASSWORD,
		sifreli:sifreli,
		EMPLOYEE_STAGE:attributes.process_stage1,
		EMPLOYEE_NO:attributes.employee_no
    )>
</cftransaction>

<cfset ADD_EMPLOYEES_DETAIL = cmp.add_employee_detail(
    EMPLOYEE_ID:LAST_ID.LATEST_RECORD_ID,
    SEX:ATTRIBUTES.SEX,
    employee_email_spc:ATTRIBUTES.employee_email_spc
)>

<cfset UPD_MEMBER_CODE = cmp.upd_member_code_f(EMPLOYEE_ID:LAST_ID.LATEST_RECORD_ID)>
<cfset ADD_IDENTY = cmp.ADD_IDENTY_F(EMPLOYEE_ID:LAST_ID.LATEST_RECORD_ID,TC_IDENTY_NO:ATTRIBUTES.TC_IDENTY_NO)>

<!--- Adres Defteri --->
<cf_addressbook
	design		= "1"
	type		= "1"
	type_id		= "#last_id.latest_record_id#"
	name		= "#attributes.employee_name#"
	surname		= "#attributes.employee_surname#"
	email		= "#attributes.employee_email_spc#"
	telcode		= ""
	telno		= ""
	mobilcode	= ""
    mobilno		= "">
    
<cfset ADD_TIME_ZONE = cmp.ADD_TIME_ZONE_F(
    EMPLOYEE_ID:LAST_ID.LATEST_RECORD_ID,
    TIME_ZONE:FORM.TIME_ZONE,
    LANGUAGE:FORM.LANGUAGE,
    DESIGN_ID:FORM.DESIGN_ID
)>
<cfset attributes.ini_employee_id = LAST_ID.LATEST_RECORD_ID>
<cfinclude template="../../myhome/query/initialize_menu_positions.cfm">
<cfset UPD_GEN_PAP = cmp.UPD_GEN_PAP_F(system_paper_no_add:attributes.system_paper_no_add)>
<!---Ek Bilgiler--->
<cfset attributes.info_id = LAST_ID.LATEST_RECORD_ID>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -4>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<cf_workcube_process
	is_upd='1'
	old_process_line='0'
	process_stage='#attributes.process_stage1#'
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='EMPLOYEES'
	action_column='EMPLOYEE_ID'
	action_id='#LAST_ID.LATEST_RECORD_ID#'
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_hr&event=upd&employee_id=#LAST_ID.LATEST_RECORD_ID#'
	warning_description="#getLang('','Kişi',29831)# : #attributes.employee_name# #attributes.employee_surname#">
<!--- END OF EMPLOYEE QUERY --->

<!--- START POSITION QUERY --->
<script type="text/javascript" src="../../js/js_functions.js"></script>
<cfset attributes.employee_id = LAST_ID.LATEST_RECORD_ID>

<cfif not isdefined("attributes.POSITION_NAME")>
	<cfset attributes.POSITION_NAME = listlast(attributes.POSITION_CAT_ID,';')>
</cfif>
<cfset attributes.POSITION_CAT_ID = listfirst(attributes.POSITION_CAT_ID,';')>
<cfinclude template="get_position_cat.cfm">
<cfset GET_MODULE_ID = cmp.get_module()>

<cfset attributes.status = 1>

<cfset new_hie_ = ''>
<cfif fusebox.dynamic_hierarchy>
	<cfset get_uppers = cmp.get_upper(department_id:attributes.department_id)>
	<cfset get_position_cat = cmp.get_pos_cat(POSITION_CAT_ID:attributes.POSITION_CAT_ID)>
	<cfset get_title = cmp.get_titles(TITLE_ID:attributes.TITLE_ID)>
	<cfset fonk_add_ = ''>
	<cfif get_uppers.recordcount>
		<cfset new_hie_ = '#get_uppers.HIE1#.' & '#get_uppers.HIE2#.' & '#get_uppers.HIE3#.' & '#get_uppers.HIE4#.' & '#get_uppers.HIE5#.' & '#get_title.HIERARCHY#.' & '#get_position_cat.HIERARCHY#' & '#fonk_add_#'>
	<cfelse>
		<cfset new_hie_ = ''>
	</cfif>
</cfif>

<cfif len(attributes.employee_id)>
	<cfset GET_EMP_NAME = cmp.get_employee_name(EMPLOYEE_ID:attributes.EMPLOYEE_ID)>
</cfif>
<cfscript>
	list="',""";
	list2=" , ";
	attributes.POSITION_NAME=replacelist(attributes.POSITION_NAME,list,list2);
	status=1;
</cfscript>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfset GET_MAX_POS = cmp.get_pos_max()>
		<cfif not len(get_max_pos.PCODE)>
			<cfset p=0>
		<cfelse>
			<cfset p=get_max_pos.PCODE>
		</cfif>
		<cfset pcode=evaluate(p + 1)>
		<!---yeni pozisyonu ekle--->
		<cfif isdefined("attributes.position_id") and len(attributes.position_id)>
			<cfset add_pos_employee = cmp.UPD_POSITION_EMPLOYEE(
				position_id : attributes.position_id,
				employee_id : attributes.employee_id,
				branch_id : attributes.branch_id,
				department_id : attributes.department_id,
				position_cat_id : attributes.position_cat_id,
				title_id : attributes.title_id,
				process_stage2 : attributes.process_stage2,
				status:attributes.status,
				position_name:attributes.position_name,
				employee_name:attributes.employee_name,
				employee_surname:attributes.employee_surname,
				employee_email_spc:attributes.employee_email_spc
			)>
			<cfset GET_LAST_ID.POSITION_ID = attributes.position_id>
			<cfset history_position_id = attributes.position_id>

		<cfelse>
			<cfset GET_LAST_ID = cmp.add_emp_pos(
				pcode:pcode,
				position_cat_id:attributes.position_cat_id,
				status:attributes.status,
				position_name:attributes.position_name,
				group_id1:#iif(len(group_id1),group_id1,DE(""))#,
				employee_id:attributes.employee_id,
				employee_name:attributes.employee_name,
				employee_surname:attributes.employee_surname,
				employee_email_spc:attributes.employee_email_spc,
				department_id:attributes.department_id,
				title_id:attributes.title_id,
				new_hie_:new_hie_,
				process_stage2:attributes.process_stage2
			)>
			<cfif len(group_id1) and len(attributes.employee_id)>
				<cfset ADD_USER_GROUP_PERMISSION = cmp.ADD_USER_GROUP_PERM(
					POSITION_ID:GET_LAST_ID.POSITION_ID,
					employee_id:attributes.employee_id,
					group_id1:group_id1
				)>
			</cfif>
			<cfset history_position_id = GET_LAST_ID.POSITION_ID>
		</cfif>
	</cftransaction>
</cflock>

<!--- yeni pozisyonu history ye ekle --->

<cfinclude template="add_position_history.cfm">

<!--- calisanin yeni pozisyonu ve goreve baslama tarihi tabloya yaziliyor--->
<!--- <cfif len(attributes.employee_id)>
	<cfset change_position_id = GET_LAST_ID.POSITION_ID>
	<cfset attributes.is_add = 1>
	<cfinclude template="add_position_change_history.cfm">	
</cfif> --->

<cfset process_description = "#getLang('','Pozisyon',58497)# : #attributes.position_name#">
<cfif len(attributes.employee_id) and len(attributes.employee_name)>
    <cfset process_description = "#process_description# - #attributes.employee_name# #attributes.employee_surname#">
</cfif>

<cf_workcube_process
	is_upd='1'
	old_process_line='0'
	process_stage='#attributes.process_stage2#'
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='EMPLOYEE_POSITIONS'
	action_column='POSITION_ID'
	action_id='#get_last_id.position_id#'
	action_page='#request.self#?fuseaction=#nextEvent#&position_id=#get_last_id.position_id#'
	warning_description='#process_description#'>
<!--- END OF POSITION QUERY --->

<!--- START PERIOD QUERY --->
<cfset emp_pos_ids = "">
<cfset emp_emp_ids = "">
<cfif isdefined('attributes.auth_emps_pos') and len(attributes.auth_emps_pos) and isdefined('attributes.auth_emps_id') and len(attributes.auth_emps_id)>
	<cfset emp_pos_ids = attributes.auth_emps_pos>
	<cfset emp_emp_ids = attributes.auth_emps_id>
<cfelse>
	<cfset emp_pos_ids = listappend(emp_pos_ids,GET_LAST_ID.POSITION_ID,',')>
	<cfset emp_emp_ids = listAppend(emp_emp_ids,attributes.employee_id,',')>
</cfif>
<cfloop list="#emp_pos_ids#" index="pos_id">
	<cfset GET_POS = cmp.get_position(pos_id:pos_id)>
	<cfparam  name="attributes.menu_id" default="0">
	<cfset GET_POS2 = cmp.GET_POS_2(
		employee_id:attributes.employee_id,
		pos_id:pos_id,
		group_id2:attributes.group_id2,
		menu_id:attributes.menu_id,
		emp_emp_ids:emp_emp_ids
	)>
</cfloop>

<cfif isDefined('attributes.periods')>
	<cfset attributes.period_default = attributes.periods>
	<cfset APERIODS=ListToArray(attributes.periods)>
	<cfset emp_pos_ids = "">
	<cfset emp_emp_ids = "">
    <cfif isdefined('attributes.auth_emps_pos') and len(attributes.auth_emps_pos) and isdefined('attributes.auth_emps_id') and len(attributes.auth_emps_id)>
    	<cfset emp_pos_ids = attributes.auth_emps_pos>
    	<cfset emp_emp_ids = attributes.auth_emps_id>
    <cfelse>
    	<cfset emp_pos_ids = listappend(emp_pos_ids,GET_LAST_ID.POSITION_ID,',')>
    	<cfset emp_emp_ids = listAppend(emp_emp_ids,attributes.employee_id,',')>
	</cfif>
	<cfset DEL_CONSUMER_PERIODS = cmp.DEL_CONSUMER_PERIOD(emp_pos_ids:emp_pos_ids)>
	<cfif isDefined('attributes.period_default') and len(attributes.period_default)>
		<cfset UPD_CONSUMER_PERIODS_DEFAULT = cmp.UPD_CONSUMER_PERIODS(
			period_default:attributes.period_default,
			emp_pos_ids:emp_pos_ids
		)>
	</cfif>
	<cfloop from="1" to="#ArrayLen(APERIODS)#" index="i">
		<cfset attributes.period_date="">
		<cfset attributes.proc_date="">
		<cfif len(evaluate("attributes.ACTION_DATE#APERIODS[i]#")) and isdate(evaluate("attributes.ACTION_DATE#APERIODS[i]#"))>
			<cfset attributes.period_date=evaluate("attributes.ACTION_DATE#APERIODS[i]#")>
			<cf_date tarih='attributes.period_date'>
		</cfif>
		<cfquery name="ADD_COMPANY_PERIODS" datasource="#DSN#">
			<cfloop list="#emp_pos_ids#" index="pos_id">
				INSERT INTO
					EMPLOYEE_POSITION_PERIODS
				(
					POSITION_ID,
					PERIOD_ID,
					<cfif len(attributes.period_date)>PERIOD_DATE,</cfif>
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#pos_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#APERIODS[i]#">,
					<cfif len(attributes.period_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.period_date#">,</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				)
			</cfloop>
		</cfquery>
	</cfloop>
	<cfset del_wrk_app = cmp.del_wrk_apps(emp_emp_ids:emp_emp_ids)>
<cfelse>
	<script type="text/javascript">
		alert("Muhasebe Dönemi Seçmeden Kayıt Yapamazsınız!");
		history.back();
	</script>
</cfif>
<!--- END OF PERIOD QUERY --->

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#LAST_ID.LATEST_RECORD_ID#</cfoutput>';
</script>