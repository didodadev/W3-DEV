<cfif isdefined("attributes.vekaleten_date") and len(attributes.vekaleten_date)>
	<cf_date tarih="attributes.vekaleten_date">
</cfif>
<cfif isdefined("attributes.position_in_out_date") and len(attributes.position_in_out_date)>
	<cf_date tarih="attributes.position_in_out_date">
</cfif>
<cfif isdefined("attributes.observation_date") and len(attributes.observation_date)><cf_date tarih="attributes.observation_date"></cfif>
<cfif not isdefined("attributes.position_name")>
	<cfset attributes.position_name = listlast(attributes.position_cat_id,';')>
</cfif>
<cfset attributes.position_cat_id = listfirst(attributes.position_cat_id,';')>
<cfif not isdefined("attributes.POSITION_CAT_ID")>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1751.Pozisyon Kategorisi Seçmelisiniz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfinclude template="get_position_cat.cfm">
<cfquery name="GET_POS" datasource="#DSN#">
	SELECT
		EMPLOYEE_ID,
		DEPARTMENT_ID
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> 
</cfquery>
<cfquery name="GET_MODULE_ID" datasource="#DSN#">
	SELECT MAX(MODULE_ID) AS MODULE_ID FROM MODULES ORDER BY MODULE_ID 
</cfquery>
<cfscript>
	e_id=get_pos.EMPLOYEE_ID;
	status=1;
	list="',""";
	list2=" , ";
	attributes.POSITION_NAME = replacelist(attributes.POSITION_NAME,list,list2);
	ctr=0;
</cfscript>
<cfset new_hie_ = ''>
<cfif fusebox.dynamic_hierarchy>
	<cfquery name="get_uppers" datasource="#DSN#">
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
	<cfquery name="get_position_cat" datasource="#DSN#">
		SELECT HIERARCHY FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
	</cfquery>
	<cfquery name="get_title" datasource="#DSN#">
		SELECT HIERARCHY FROM SETUP_TITLE WHERE TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
	</cfquery>
	<cfif len(attributes.func_id)><!--- fonksiyon son eleman olacak sekilde ayarlandi --->
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
	<cfquery name="upd_1" datasource="#DSN#">
		UPDATE EMPLOYEE_POSITIONS SET IS_MASTER = 0 WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfif fusebox.dynamic_hierarchy>
		<cfquery name="upd_2" datasource="#DSN#">
			UPDATE EMPLOYEES SET DYNAMIC_HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hie_#">,DYNAMIC_HIERARCHY_ADD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dynamic_hierarchy_add#"> WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfquery>
	</cfif>
</cfif>
<!--- MASTER POZISYON --->
<cfif not isdefined("attributes.is_vekaleten")>
	<cfset attributes.is_vekaleten = 0>
</cfif>
<cfquery name="GET_POS_OLD_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pos.department_id#">
</cfquery>
<cfquery name="GET_POS_NEW_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
</cfquery>
<!--- amirler secili ise amirler tablosuna kayit yaz 
<cfif (len(attributes.upper_position_code) and len(attributes.upper_position)) or (len(attributes.upper_position_code2) and len(attributes.upper_position2))>--->
	<cfquery name="get_old_standby" datasource="#DSN#">
		SELECT * FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
	</cfquery>
	<cfif not get_old_standby.recordcount>
		<cfquery name="insert_" datasource="#DSN#">
			INSERT INTO 
				EMPLOYEE_POSITIONS_STANDBY 
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
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">,
				<cfif len(attributes.upper_position_code) and len(attributes.upper_position)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code#"><cfelse>NULL</cfif>,
				<cfif len(attributes.upper_position_code2) and len(attributes.upper_position2)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code2#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			)
		</cfquery>
	<cfelse>
		<cfquery name="update_" datasource="#DSN#">
			UPDATE
				EMPLOYEE_POSITIONS_STANDBY
			SET
				CHIEF1_CODE = <cfif len(attributes.upper_position_code) and len(attributes.upper_position)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code#"><cfelse>NULL</cfif>,
				CHIEF2_CODE = <cfif len(attributes.upper_position_code2) and len(attributes.upper_position2)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code2#"><cfelse>NULL</cfif>,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			WHERE
				SB_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_old_standby.sb_id#">
		</cfquery>
	</cfif>
<!--- </cfif>
//amirler secili ise amirler tablosuna kayit yaz --->
<cfif len(attributes.employee_id)>
	<cfquery name="GET_EMP_NAME" datasource="#DSN#">
		SELECT
			EMPLOYEE_ID,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_EMAIL
		FROM
			EMPLOYEES
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
</cfif>	
<!--- Onaya gore islem --->
<cfquery name="UPD_POSITION" datasource="#DSN#">
	UPDATE
		EMPLOYEE_POSITIONS
	SET
		IN_COMPANY_REASON_ID = <cfif isdefined('attributes.reason_id') and len(attributes.reason_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reason_id#"><cfelse>NULL</cfif>,
		DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">,
		COLLAR_TYPE = <cfif len(attributes.collar_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#"><cfelse>NULL</cfif>,
		POSITION_STATUS = <cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
		IS_MASTER = <cfif isdefined("attributes.is_master")>1<cfelse>0</cfif>,
		UPPER_POSITION_CODE = <cfif len(attributes.upper_position_code) and len(attributes.upper_position)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code#"><cfelse>NULL</cfif>,
		UPPER_POSITION_CODE2 = <cfif len(attributes.upper_position_code2) and len(attributes.upper_position2)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code2#"><cfelse>NULL</cfif>,
		POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">,
		DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
		POSITION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.position_name#">,
		VEKALETEN_DATE = <cfif isdefined("attributes.vekaleten_date") and len(attributes.vekaleten_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.vekaleten_date#"><cfelse>NULL</cfif>,
		IS_VEKALETEN = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_vekaleten#">,
		<cfif session.ep.ehesap>EHESAP = <cfif isdefined("attributes.ehesap")>1<cfelse>0</cfif>,</cfif>
		TITLE_ID = <cfif len(attributes.title_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#"><cfelse>NULL</cfif>,
		IS_CRITICAL = <cfif isdefined("attributes.is_critical")>1<cfelse>0</cfif>,
		ORGANIZATION_STEP_ID = <cfif isdefined("attributes.organization_step_id") and len(attributes.organization_step_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_step_id#"><cfelse>NULL</cfif>,
		OBSERVATION_DATE = <cfif isdefined("attributes.observation_date") and len(attributes.observation_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.observation_date#"><cfelse>NULL</cfif>,
		IS_OBSERVATION = <cfif isdefined("attributes.is_observation")>1<cfelse>0</cfif>,
		OZEL_KOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#">,
		DYNAMIC_HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hie_#">,
		<cfif fusebox.dynamic_hierarchy>DYNAMIC_HIERARCHY_ADD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dynamic_hierarchy_add#">,</cfif>
		IS_ORG_VIEW = <cfif isdefined("attributes.is_org_view")>1<cfelse>0</cfif>,
		FUNC_ID = <cfif len(attributes.func_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.func_id#"><cfelse>NULL</cfif>,
		EMPLOYEE_ID = <cfif len(attributes.employee_id) and len(attributes.employee)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><cfelse>NULL</cfif>,
		EMPLOYEE_NAME = <cfif len(attributes.employee) and len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_EMP_NAME.EMPLOYEE_NAME#">,<cfelse>NULL,</cfif>
		EMPLOYEE_SURNAME = <cfif len(attributes.employee) and len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_EMP_NAME.EMPLOYEE_SURNAME#">,<cfelse>NULL,</cfif>
		EMPLOYEE_EMAIL = <cfif len(attributes.employee) and len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#GET_EMP_NAME.EMPLOYEE_EMAIL#">,<cfelse>NULL,</cfif>
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		POSITION_STAGE=<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>		
	WHERE
		POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">					
</cfquery>
<cfset attribute.actionID = attributes.id>
<cfif len(e_id)>
	<cfquery name="del_wrk_app" datasource="#dsn#">
		DELETE FROM WRK_SESSION WHERE USERID = #e_id# AND USER_TYPE = 0
	</cfquery>
</cfif>
<!--- pozisyonun yeni halini history ye ekle --->
<cfinclude template="add_pos_his_info.cfm">
<cfset history_position_id = attributes.id>
<cfinclude template="add_position_history.cfm">

<!---gorev degisikligi kartina degisikligi at --->
<cfif len(attributes.position_in_out_date) and attributes.is_change_position eq 1>
	<cfset change_position_id = attributes.id>
	<cfset attributes.is_update = 1>
	<cfinclude template="add_position_change_history.cfm">	
</cfif>
<!--- ücret kartindaki departman bilgisini guncelle SG13082012---->
<cfif isdefined("x_upd_in_out") and x_upd_in_out eq 1>
	<cfif attributes.department_id neq attributes.old_department_id and len(attributes.employee_id)>
		<cfquery name="get_in_out" datasource="#dsn#" maxrows="1">
			SELECT IN_OUT_ID,BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> ORDER BY START_DATE DESC <!--- AND FINISH_DATE IS NULL --->
		</cfquery>
		<cfif get_in_out.recordcount and attributes.branch_id eq get_in_out.branch_id>
			<cfquery name="upd_in_out" datasource="#dsn#">
				UPDATE EMPLOYEES_IN_OUT	SET DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_in_out.in_out_id#">	
			</cfquery>
		</cfif>
	</cfif>
</cfif>
<!--- ücret kartindaki meslek grubunu guncelle GSO15012015 --->
<cfif isdefined("attributes.is_master")>
	<cfif len(attributes.position_cat_id)>
		<cfquery name="get_business_code" datasource="#dsn#">
			SELECT BUSINESS_CODE_ID FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
		</cfquery>
		<cfif len(get_business_code.business_code_id) and len(attributes.employee_id)>
			<cfquery name="get_in_out_emp" datasource="#dsn#" maxrows="1">
				SELECT IN_OUT_ID,BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> ORDER BY START_DATE DESC <!--- AND FINISH_DATE IS NULL --->
			</cfquery>
			<cfif get_in_out_emp.recordcount and get_business_code.business_code_id neq 0>
				<cfquery name="upd_in_out" datasource="#dsn#">
					UPDATE EMPLOYEES_IN_OUT	SET BUSINESS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_business_code.business_code_id#"> WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_in_out_emp.in_out_id#">	
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
</cfif>
	
<cfif (not len(attributes.employee_id) or not len(attributes.employee)) and (get_pos.EMPLOYEE_ID neq 0)>
	<!--- pozisyon elemanı silinmiş --->
	<cfset free_position_id = attributes.id>
	<cfinclude template="free_position.cfm">

	<cfif len(attributes.position_in_out_date) and attributes.is_change_position eq 1>
		<cfset change_position_id =  attributes.id>
		<cfset attributes.is_update = 1>
		<cfinclude template="add_position_change_history.cfm">	
	</cfif>
</cfif>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='EMPLOYEE_POSITIONS'
	action_column='POSITION_ID'
	action_id='#attributes.id#' 
	action_page='#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#attributes.id#'
	warning_description="#getLang('','Pozisyon',58497)# : #attributes.POSITION_NAME#">
	<cf_add_log log_type="0" action_id="#attributes.id#" action_name="#attributes.pagehead#" process_stage="#attributes.process_stage#">

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#attributes.id#</cfoutput>';
</script>