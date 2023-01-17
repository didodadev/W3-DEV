<cfif attributes.id is "employee_user">
	<cfif not(isdefined('attributes.from_sec') and attributes.from_sec eq 1)>
		<cfif isdefined('attributes.employee_password') and len(employee_password)>
			<cf_cryptedpassword password="#employee_password#" output="employee_password" mod="1">
			<!--- iam kayıt --->
			<cfset add_iam_cmp = createObject("V16.hr.cfc.add_iam")>
			<cfset get_emp_info_ = add_iam_cmp.GET_EMP_INFO_(attributes.employee_id)>
		
			<cfset add_iam = add_iam_cmp.add_iam(
				username : attributes.employee_username,
				member_name : get_emp_info_.EMPLOYEE_NAME,
				member_sname : get_emp_info_.employee_surname,
				password : employee_password,
				pr_mail : isdefined("get_emp_info_.EMPLOYEE_EMAIL") ? get_emp_info_.EMPLOYEE_EMAIL : "",
				sec_mail : isdefined("get_emp_info_.EMAIL_SPC") ? get_emp_info_.EMAIL_SPC : "",
				mobile_code : isdefined("get_emp_info_.MOBILCODE") ? get_emp_info_.MOBILCODE : "",
				mobile_no : isdefined("get_emp_info_.MOBILTEL") ? get_emp_info_.MOBILTEL : "",
				is_add : 0
			)>
		</cfif>
		<cfif isdefined('attributes.employee_username') and len(attributes.employee_username)>
			<cfquery name="CHECK_USERNAME" datasource="#DSN#">
				SELECT
					EMPLOYEE_ID
				FROM
					EMPLOYEES
				WHERE
					EMPLOYEE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
					EMPLOYEE_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.employee_username#">
			</cfquery>
			<cfif check_username.recordcount>
				<cfoutput>
					<script type="text/javascript">
						alert("<cf_get_lang dictionary_id='52638.Lütfen Başka Bir Kullanıcı Adı Girin!'>");
						history.back();
					</script>
					<cfabort>
				</cfoutput>
			</cfif>
		</cfif>
		<cfquery name="UPD_EMPLOYEES" datasource="#DSN#">
			UPDATE
				EMPLOYEES
			SET
				<cfif isdefined('employee_password') and len(employee_password)>EMPLOYEE_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#employee_password#">,</cfif>
				<cfif isdefined('employee_username') and len(employee_username)>EMPLOYEE_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#employee_username#"><cfelse>EMPLOYEE_USERNAME = NULL</cfif>,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			WHERE
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfquery>
	    <cfif (isdefined('employee_username') and employee_username neq old_employee_username) or (isdefined('employee_password') and len(employee_password) and employee_password neq old_employee_password)>
	        <cf_add_log log_type="0" action_id="#attributes.employee_id#" action_name="Kullanıcı Adı Şifre Güncelle :#get_emp_info(attributes.employee_id,0,0)#(#attributes.employee_id#)">
	    </cfif>
    </cfif>
    <cfset emp_pos_ids = "">
	<cfset emp_emp_ids = "">
    <cfif isdefined('attributes.auth_emps_pos') and len(attributes.auth_emps_pos) and isdefined('attributes.auth_emps_id') and len(attributes.auth_emps_id)>
    	<cfset emp_pos_ids = attributes.auth_emps_pos>
    	<cfset emp_emp_ids = attributes.auth_emps_id>
    <cfelse>
    	<cfset emp_pos_ids = listappend(emp_pos_ids,attributes.position_id,',')>
    	<cfset emp_emp_ids = listAppend(emp_emp_ids,attributes.employee_id,',')>
    </cfif>
    <cfloop list="#emp_pos_ids#" index="pos_id">
	    <cfquery name="GET_POS" datasource="#DSN#">
			SELECT
				LEVEL_ID,
				LEVEL_EXTRA_ID,
				USER_GROUP_ID,
				EMPLOYEE_ID
			FROM
				EMPLOYEE_POSITIONS
			WHERE
				POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_id#">
		</cfquery>
		<!---
		<cfquery name="GET_POS2" datasource="#DSN#">
        	SELECT POSITION_ID FROM USER_GROUP_EMPLOYEE WHERE USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.group_id#"> AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_id#">
        </cfquery>
		--->
        <!---<cfif not (GET_POS2.recordcount)> --->
			<cfparam  name="attributes.menu_id" default="0">
            <cfquery name="GET_POS2" datasource="#DSN#">
				DELETE FROM USER_GROUP_EMPLOYEE WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_id#">
                INSERT INTO USER_GROUP_EMPLOYEE (EMPLOYEE_ID,POSITION_ID,USER_GROUP_ID) VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,<cfqueryparam cfsqltype="cf_sql_integer" value="#pos_id#">,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.group_id#">)
                UPDATE 
					EMPLOYEE_POSITIONS 
				SET
					USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.group_id#">,
					WRK_MENU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.menu_id#">
				WHERE 
					POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#pos_id#">
                DELETE FROM WRK_SESSION WHERE USERID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_emp_ids#">) AND USER_TYPE = 0
            </cfquery>
        <!--- </cfif> --->
	</cfloop>
</cfif>
<cfif attributes.id is "power_user">
	<cfset emp_pos_ids = "">
	<cfset emp_emp_ids = "">
    <cfif isdefined('attributes.auth_emps_pos') and len(attributes.auth_emps_pos) and isdefined('attributes.auth_emps_id') and len(attributes.auth_emps_id)>
    	<cfset emp_pos_ids = attributes.auth_emps_pos>
    	<cfset emp_emp_ids = attributes.auth_emps_id>
    <cfelse>
    	<cfset emp_pos_ids = listappend(emp_pos_ids,attributes.position_id,',')>
    	<cfset emp_emp_ids = listAppend(emp_emp_ids,attributes.employee_id,',')>
    </cfif>
    <cfquery name="GET_MODULE_ID" datasource="#DSN#">
		SELECT MAX(MODULE_ID) AS MODULE_ID FROM MODULES ORDER BY MODULE_ID 
	</cfquery>
	<cfscript>
		e_id = attributes.EMPLOYEE_ID;	
		old_power_user = attributes.old_power_user;
		attributes.POWER_USER_LEVEL_ID = "";
	</cfscript>
	<cfscript>
		for (loop_level=1; loop_level lte GET_MODULE_ID.MODULE_ID; loop_level=loop_level+1)
			if (IsDefined("attributes.POWER_USER_LEVEL_ID_#loop_level#"))
				attributes.POWER_USER_LEVEL_ID = ListAppend(attributes.POWER_USER_LEVEL_ID,Evaluate("attributes.POWER_USER_LEVEL_ID_#loop_level#"));
			else
				attributes.POWER_USER_LEVEL_ID = ListAppend(attributes.POWER_USER_LEVEL_ID,0);
	</cfscript>
	<cfquery name="UPD_POS" datasource="#DSN#">
		UPDATE
			EMPLOYEE_POSITIONS
		SET
			POWER_USER = <cfif len(attributes.POWER_USER_LEVEL_ID)>1<cfelse>0</cfif>,
			POWER_USER_LEVEL_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.power_user_level_id#">,
			DISCOUNT_VALID = <cfif isdefined("attributes.discount_valid")>1<cfelse>0</cfif>,
			PRICE_VALID = <cfif isdefined("attributes.price_valid")>1<cfelse>0</cfif>,
			PRICE_DISPLAY_VALID = <cfif isdefined("attributes.price_display_valid")>1<cfelse>0</cfif>,
			COST_DISPLAY_VALID = <cfif isdefined("attributes.cost_display_valid")>1<cfelse>0</cfif>,
			MEMBER_VIEW_CONTROL = <cfif isdefined("attributes.member_view_control")>1<cfelse>0</cfif>,
			CONSUMER_PRIORITY = <cfif isdefined("attributes.consumer_priority")>1<cfelse>0</cfif>,
            MEMBER_DIRECT_DENIED = <cfif isdefined("attributes.member_direct_denied")>1<cfelse>0</cfif>,
            DUEDATE_VALID = <cfif isdefined("attributes.duedate_valid")>1<cfelse>0</cfif>,
			RATE_VALID = <cfif isdefined("attributes.rate_valid")>1<cfelse>0</cfif>,
			THEIR_RECORDS_ONLY = <cfif isdefined("attributes.their_records_only")>1<cfelse>0</cfif>,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE
			POSITION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_pos_ids#">)
	</cfquery>
	<!--- power_user degeri degistiginde kullanıcıyı sistemden at --->
	<cfif (get_workcube_app_user(e_id,0).recordcount and isdefined("attributes.power_user") neq old_power_user) or listlen(emp_emp_ids,',') gt 1>
		<cfquery name="DEL_WRK_APP" datasource="#DSN#">
			DELETE FROM WRK_SESSION WHERE USERID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_emp_ids#">) AND USER_TYPE = 0
		</cfquery>
	</cfif>
</cfif>
<cfif attributes.id is "add_options">
	<cfset emp_pos_ids = "">
    <cfif isdefined('attributes.auth_emps_pos') and len(attributes.auth_emps_pos)>
    	<cfset emp_pos_ids = attributes.auth_emps_pos>
    <cfelse>
    	<cfset emp_pos_ids = listappend(emp_pos_ids,attributes.position_id,',')>
    </cfif>
	<cfquery name="UPD_POS" datasource="#DSN#">
		UPDATE
			EMPLOYEE_POSITIONS
		SET
			DISCOUNT_VALID = <cfif isdefined("attributes.discount_valid")>1<cfelse>0</cfif>,
			PRICE_VALID = <cfif isdefined("attributes.price_valid")>1<cfelse>0</cfif>,
			PRICE_DISPLAY_VALID = <cfif isdefined("attributes.price_display_valid")>1<cfelse>0</cfif>,
			COST_DISPLAY_VALID = <cfif isdefined("attributes.cost_display_valid")>1<cfelse>0</cfif>,
			MEMBER_VIEW_CONTROL = <cfif isdefined("attributes.member_view_control")>1<cfelse>0</cfif>,
			CONSUMER_PRIORITY = <cfif isdefined("attributes.consumer_priority")>1<cfelse>0</cfif>,
            MEMBER_DIRECT_DENIED = <cfif isdefined("attributes.member_direct_denied")>1<cfelse>0</cfif>,
            DUEDATE_VALID = <cfif isdefined("attributes.duedate_valid")>1<cfelse>0</cfif>,
			RATE_VALID = <cfif isdefined("attributes.rate_valid")>1<cfelse>0</cfif>,
			THEIR_RECORDS_ONLY = <cfif isdefined("attributes.their_records_only")>1<cfelse>0</cfif>,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE
			POSITION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_pos_ids#">)
	</cfquery>
</cfif>
<cfif not isdefined("attributes.draggable")>
	<cfif attributes.employee_id eq session.ep.userid>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
	</cfif>
<cfelse>
	<script type="text/javascript">
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</script>
</cfif>
	
