<cfif len(attributes.employee_password1)>
	<CF_CRYPTEDPASSWORD password="#attributes.employee_password1#" output="employee_password" mod="1">
	<!--- iam kayıt --->
	<cfset add_iam_cmp = createObject("V16.hr.cfc.add_iam")>
	<cfset get_emp_info_ = add_iam_cmp.GET_EMP_INFO_(userid : session.ep.userid)>
	<cfset add_iam = add_iam_cmp.add_iam(
		username : session.ep.username,
		member_name : session.ep.name,
		member_sname : session.ep.username,
		password : employee_password,
		pr_mail : isdefined("get_emp_info_.EMPLOYEE_EMAIL") ? get_emp_info_.EMPLOYEE_EMAIL : "",
		sec_mail : isdefined("get_emp_info_.EMAIL_SPC") ? get_emp_info_.EMAIL_SPC : "",
		mobile_code : isdefined("get_emp_info_.MOBILCODE") ? get_emp_info_.MOBILCODE : "",
		mobile_no : isdefined("get_emp_info_.MOBILTEL") ? get_emp_info_.MOBILTEL : "",
		is_add : 0
	)>
</cfif>
<cfif len(attributes.employee_password0)>
	<CF_CRYPTEDPASSWORD password="#attributes.employee_password0#" output="employee_password0" mod="1">
</cfif>
	<!--- kullanıcı bilgileri alınıyor --->
	<cfscript>
    	get_employee_name_tmp = createObject("component","cfc.right_menu_fnc");
		get_employee_name_tmp.dsn = dsn;
		get_employee_name = get_employee_name_tmp.upd_password(userid:session.ep.userid);
    </cfscript>



<cfif len(attributes.employee_username)>
	<!--- kullanıcı kotrolü --->
	<cfscript>
		check_name_tmp = createObject("component","cfc.right_menu_fnc");
		check_name_tmp.dsn = dsn;
		check_name = check_name_tmp.check_name_fnc(session.ep.userid,iif(isdefined("attributes.employee_id"),"attributes.employee_id",DE("")),attributes.employee_username);
    </cfscript> 
	<cfif check_name.recordcount>
		<cfoutput>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1228.Bu Kullanıcı Adı Kullanılıyor'>!");
				history.back();
			</script>
			<CFABORT>
		</cfoutput>
	</cfif>
</cfif>
<cfif len(attributes.employee_password1) or len(attributes.employee_username)>
	<!--- update işlemi --->
	<cfscript>
		upd_employee_tmp = createObject("component","cfc.right_menu_fnc");
		upd_employee_tmp.dsn = dsn;
		update_emp = upd_employee_tmp.upd_employee_fnc('#dsn#',session.ep.userid,iif(isdefined("attributes.employee_id"),"attributes.employee_id",DE("")),employee_password,attributes.employee_password1,attributes.employee_username);
    </cfscript> 
</cfif>
<cfif len(attributes.employee_password1)>
	 <!--- güncellemeler insert ediliyor --->
	 <cfscript>
    	add_tmp = createObject("component","cfc.right_menu_fnc");
		add_tmp.dsn = dsn;
		add_ = add_tmp.add_fnc(session.ep.userid,iif(isdefined("attributes.employee_id"),"attributes.employee_id",DE("")),get_employee_name.employee_password,employee_password);
    </cfscript>
	<cfif isdefined("attributes.employee_id")>
    	<cfset attributes.actionid = attributes.employee_id>
    <cfelse>
    	<cfset attributes.actionid = SESSION.EP.USERID>
    </cfif>
    <cf_add_log  log_type="0" action_id="#attributes.actionid#" action_name="Kullanıcı Adı Şifre Güncelle :#get_emp_info(attributes.actionid,0,0)#(#attributes.actionid#)">
	<cfset session.ep.must_password_change = 0>
	<cfif isDefined("session.ep.must_password_change_ignore_actions")>
		<cfset session.ep.must_password_change_ignore_actions = []>
	</cfif>
</cfif>
<cfif isdefined("attributes.employee_id")>
	<cflocation url="#request.self#?fuseaction=hr.popup_mysettings&employee_id=#attributes.employee_id#" addtoken="No">
<cfelse>
	<cflocation url="#request.self#?fuseaction=myhome.list_myaccount_password&type=upd" addtoken="No">
</cfif>
