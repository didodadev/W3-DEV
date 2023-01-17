<script type="text/javascript" src="../../js/js_functions.js"></script>
<!--- 
Güncelemeler :
	EK 20030809 : cfscript yapıldı ve çalışması sağlandı
	ek 20030827 : employees_in_out queryleri eklendi
	erk 20030917 : is_vekaleten ve vekaleten_date eklendi
	erk 20040105 : title_id employees den buraya taşındı
	omer 20050905 : işe alma süreci yok edildi
--->
<cfif isdefined("attributes.VEKALETEN_DATE") and len(attributes.VEKALETEN_DATE)>
	<cf_date tarih="attributes.VEKALETEN_DATE">
</cfif>
<cfif isdefined("attributes.position_in_out_date") and len(attributes.position_in_out_date)>
	<cf_date tarih="attributes.position_in_out_date">
</cfif>
<cfif not isdefined("attributes.POSITION_NAME")>
	<cfset attributes.POSITION_NAME = listlast(attributes.POSITION_CAT_ID,';')>
</cfif>
<cfset attributes.POSITION_CAT_ID = listfirst(attributes.POSITION_CAT_ID,';')>
<cfinclude template="get_position_cat.cfm">
<cfquery  name="GET_MODULE_ID" datasource="#dsn#">
	SELECT MAX(MODULE_ID) AS MODULE_ID FROM MODULES ORDER BY MODULE_ID 
</cfquery>

<cfset new_hie_ = ''>
<cfif fusebox.dynamic_hierarchy>
	<cfquery name="get_uppers" datasource="#dsn#">
		SELECT 
			O.HIERARCHY AS HIE1,
			Z.HIERARCHY AS HIE2,
			O.HIERARCHY2 AS HIE3,			
			B.HIERARCHY AS HIE4,
			D.HIERARCHY AS HIE5
		FROM
			DEPARTMENT D
			INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
			INNER JOIN OUR_COMPANY O ON B.COMPANY_ID = O.COMP_ID
			INNER JOIN ZONE Z ON B.ZONE_ID = Z.ZONE_ID
		WHERE
			D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
	</cfquery>
	<cfquery name="get_position_cat" datasource="#dsn#">
		SELECT HIERARCHY FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.POSITION_CAT_ID#">
	</cfquery>
	<cfquery name="get_title" datasource="#dsn#">
		SELECT HIERARCHY FROM SETUP_TITLE WHERE TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.TITLE_ID#">
	</cfquery>
	<cfif isdefined("attributes.func_id") and len(attributes.func_id)><!--- fonksiyon son eleman olacak sekilde ayarlandi --->
		<cfquery name="get_fonk" datasource="#DSN#">
			SELECT
			   HIERARCHY
			FROM
				SETUP_CV_UNIT
			WHERE
				UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.func_id#">
		</cfquery>
		<cfif get_fonk.recordcount and len(get_fonk.HIERARCHY)>
			<cfset fonk_add_ = '.#get_fonk.HIERARCHY#'>
		<cfelse>
			<cfset fonk_add_ = ''>
		</cfif>
	<cfelse>
		<cfset fonk_add_ = ''>
	</cfif>
	<cfif get_uppers.recordcount>
		<cfset new_hie_ = '#get_uppers.HIE1#.' & '#get_uppers.HIE2#.' & '#get_uppers.HIE3#.' & '#get_uppers.HIE4#.' & '#get_uppers.HIE5#.' & '#get_title.HIERARCHY#.' & '#get_position_cat.HIERARCHY#' & '#fonk_add_#'>
	<cfelse>
		<cfset new_hie_ = ''>
	</cfif>
</cfif>

<!--- MASTER POZISYON --->
<cfif len(attributes.employee_id) and len(attributes.employee) and isdefined("attributes.is_master")>
	<cfquery name="upd_" datasource="#dsn#">
		UPDATE EMPLOYEE_POSITIONS SET IS_MASTER = 0 WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfif fusebox.dynamic_hierarchy>
		<cfquery name="upd_2" datasource="#dsn#">
			UPDATE EMPLOYEES SET DYNAMIC_HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hie_#">,DYNAMIC_HIERARCHY_ADD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dynamic_hierarchy_add#"> WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfquery>
	</cfif>
</cfif>
<!--- MASTER POZISYON --->

<cfif len(attributes.employee_id)>
	<cfquery name="GET_EMP_NAME" datasource="#dsn#">
		SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
	</cfquery>
</cfif>
<cfif not isdefined("attributes.POSITION_NAME")>
	<cfset attributes.POSITION_NAME = listlast(attributes.POSITION_CAT_ID,';')>
</cfif>
<cfset attributes.POSITION_CAT_ID = listfirst(attributes.POSITION_CAT_ID,';')>
<cfscript>
	list="',""";
	list2=" , ";
	attributes.POSITION_NAME=replacelist(attributes.POSITION_NAME,list,list2);
	status=1;
</cfscript>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="GET_MAX_POS" datasource="#dsn#">
			SELECT
				MAX(POSITION_CODE) AS PCODE
			FROM
				EMPLOYEE_POSITIONS
		</cfquery>
		<cfif not len(get_max_pos.PCODE)>
			<cfset p=0>
		<cfelse>
			<cfset p=get_max_pos.PCODE>
		</cfif>
		<cfset pcode=evaluate(p + 1)>
		<!---yeni pozisyonu ekle--->
		<cfquery name="ADD_POSITION" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				EMPLOYEE_POSITIONS
				(
					IN_COMPANY_REASON_ID,
					POSITION_CODE,
					POSITION_CAT_ID,
					COLLAR_TYPE,
					POSITION_STATUS,
					POSITION_NAME,
					DETAIL,
					<cfif len(GROUP_ID)>USER_GROUP_ID,</cfif>
					EMPLOYEE_ID,
					EMPLOYEE_NAME,
					EMPLOYEE_SURNAME,
					EMPLOYEE_EMAIL,
					DEPARTMENT_ID,
					EHESAP,
					IS_VEKALETEN,
					VEKALETEN_DATE,
					TITLE_ID,
					IS_CRITICAL,
					ORGANIZATION_STEP_ID,
					OZEL_KOD,
					HIERARCHY,
					DYNAMIC_HIERARCHY,
					DYNAMIC_HIERARCHY_ADD,
					IS_MASTER,
					UPPER_POSITION_CODE,
					UPPER_POSITION_CODE2,
					IS_ORG_VIEW,
					FUNC_ID,
					POSITION_STAGE
				)
				VALUES
				(
					<cfif len(attributes.reason_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reason_id#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#pcode#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">,
					<cfif len(attributes.collar_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#"><cfelse>NULL</cfif>,
				    <cfif isdefined("attributes.status")>1,<cfelse>0,</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.position_name#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#">,
					<cfif len(group_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#group_id#">,</cfif>
					<cfif len(attributes.employee_id) and len(attributes.employee)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_emp_name.employee_name#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_emp_name.employee_surname#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_emp_name.employee_email#">,
					<cfelse>
						0,
						'',
						'',
						'',
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">,
					0,
					<cfif isdefined("attributes.IS_VEKALETEN")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.VEKALETEN_DATE") and len(attributes.VEKALETEN_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.vekaleten_date#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">,
					<cfif isdefined("attributes.is_critical")>1<cfelse>0</cfif>,
					<cfif len(attributes.ORGANIZATION_STEP_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_step_id#"><cfelse>NULL</cfif>,
					<cfif len(attributes.ozel_kod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#"><cfelse>NULL</cfif>,
					<cfif len(EMPLOYEE_ID) and len(GET_EMP_NAME.ozel_kod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_emp_name.ozel_kod#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hie_#">,
					<cfif fusebox.dynamic_hierarchy><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dynamic_hierarchy_add#">,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.is_master")>1<cfelse>0</cfif>,
					<cfif len(attributes.upper_position_code) and len(attributes.upper_position)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code#"><cfelse>NULL</cfif>,
					<cfif len(attributes.upper_position_code2) and len(attributes.upper_position2)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code2#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_org_view")>1<cfelse>0</cfif>,
					<cfif len(attributes.func_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.func_id#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
				)                
		</cfquery>
		<cfquery name="GET_LAST_ID" datasource="#dsn#">
			SELECT MAX(POSITION_ID) AS POSITION_ID FROM EMPLOYEE_POSITIONS
		</cfquery>
        <cfif len(group_id) and len(attributes.employee_id)>
            <cfquery name="ADD_USER_GROUP_PERMISSION" datasource="#dsn#">
                INSERT INTO USER_GROUP_EMPLOYEE
                (POSITION_ID,EMPLOYEE_ID,USER_GROUP_ID)
                VALUES
                (<cfqueryparam cfsqltype="cf_sql_integer" value="#GET_LAST_ID.POSITION_ID#">,<cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#group_id#">)
            </cfquery>
		</cfif>
		<cf_add_log log_type="1" action_id="#MAX_ID.IDENTITYCOL#" action_name="#attributes.pagehead#" process_stage="#attributes.process_stage#">
	</cftransaction>
</cflock>

<!--- amirler secili ise amirler tablosuna kayit yaz --->
<cfif (len(attributes.upper_position_code) and len(attributes.upper_position)) or (len(attributes.upper_position_code2) and len(attributes.upper_position2))>
	<cfquery name="insert_" datasource="#dsn#">
		INSERT INTO EMPLOYEE_POSITIONS_STANDBY 
			(
			POSITION_CODE,
			CHIEF1_CODE,
			CHIEF2_CODE,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
			)
			VALUES
			(
			#PCODE#,
			<cfif len(attributes.upper_position_code) and len(attributes.upper_position)>#attributes.upper_position_code#,<cfelse>NULL,</cfif>
			<cfif len(attributes.upper_position_code2) and len(attributes.upper_position2)>#attributes.upper_position_code2#,<cfelse>NULL,</cfif>
			#SESSION.EP.USERID#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			#NOW()#
			)
	</cfquery>
</cfif>
<!--- amirler secili ise amirler tablosuna kayit yaz --->

<!--- yeni pozisyonu history ye ekle --->
<cfset history_position_id = GET_LAST_ID.POSITION_ID>
<cfinclude template="add_position_history.cfm">

<!--- calisanin yeni pozisyonu ve goreve baslama tarihi tabloya yaziliyor--->
<cfif len(attributes.employee_id) and len(attributes.position_in_out_date)>
	<cfset change_position_id = GET_LAST_ID.POSITION_ID>
	<cfset attributes.is_add = 1>
	<cfinclude template="add_position_change_history.cfm">	
</cfif>

<cfset process_description = "#getLang('','Pozisyon',58497)# : #attributes.position_name#">
<cfif len(attributes.employee_id) and len(attributes.employee)>
    <cfset process_description = "#process_description# - #get_emp_name.employee_name# #get_emp_name.employee_surname#">
</cfif>

<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='EMPLOYEE_POSITIONS'
	action_column='POSITION_ID'
	action_id='#get_last_id.position_id#'
	action_page='#request.self#?fuseaction=#nextEvent#&position_id=#get_last_id.position_id#' 
	warning_description='#process_description#'>
<script type="text/javascript">
	function pencere_in()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=ehesap.list_fire&event=addIn&position_code=#PCODE#&employee_id=#attributes.employee_id#</cfoutput>','medium');
		window.location.href='<cfoutput>#request.self#?fuseaction=#nextEvent#&position_id=#GET_LAST_ID.POSITION_ID#</cfoutput>';
	}
	function pencere_out()
	{
		<cfif isdefined("attributes.callAjax") and attributes.callAjax eq 1><!--- Organizasyon Planlama sayfasından ajax ile çağırıldıysa 20190912ERU --->
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#nextEvent#&position_id=#GET_LAST_ID.POSITION_ID#&comp_id=#attributes.comp_id#</cfoutput>&department_id=#department_id#&position_catid=#position_catid#','ajax_right');
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.organization_management&event=ajaxSub&type=5&comp_id=#attributes.comp_id#</cfoutput>&department_id=#department_id#&position_catid=#position_catid#','DepartmentPositionsDiv' +  id + '_' + branch_id + '_' + department_id + '_' +position_catid);
			$('#DepartmentPositions' + id + '_' + branch_id + '_' + department_id + '_' + position_catid).show();
		<cfelse>
			window.location.href='<cfoutput>#request.self#?fuseaction=#nextEvent#&position_id=#GET_LAST_ID.POSITION_ID#</cfoutput>';
		</cfif>
	}
	<cfif len(attributes.employee_id) and len(attributes.employee)>
		if (confirm("<cf_get_lang no='971.İşe Giriş İşlemi Yapılacak mı'>")) {pencere_in();}  else {pencere_out()};
	<cfelse>
		pencere_out();
	</cfif>
</script>