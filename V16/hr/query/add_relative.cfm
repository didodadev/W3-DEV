<cfif pageFuseaction eq "hr.employee_relative_ssk">
	<cfset relative_url_string = "&field_name=ssk_fee.ill_name&field_surname=ssk_fee.ill_surname&field_relative=ssk_fee.ill_relative&field_birth_date=ssk_fee.BIRTH_DATE&field_birth_place=ssk_fee.BIRTH_PLACE&field_tc_identy_no=ssk_fee.TC_IDENTY_NO&field_ill_sex=ssk_fee.ill_sex">
	<cfset ssk_ek = "_ssk">
<cfelseif pageFuseaction eq "hr.employee_relative" or pageFuseaction eq "myhome.employee_relative">
	<cfset relative_url_string = "">
	<cfset ssk_ek = "">
</cfif>
<cfif attributes.fuseaction contains "myhome" and not isNumeric(attributes.employee_id)>
	<cfset attributes.employee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.employee_id,accountKey:'wrk')>
<cfelse>
	<cfset attributes.employee_id = attributes.employee_id>
</cfif>
<cfif len(attributes.birth_date)>
	<cf_date tarih="attributes.birth_date">
</cfif>
<cfif len(attributes.marriage_date)>
	<cf_date tarih="attributes.marriage_date">
</cfif>
<cfif len(attributes.education_record_date)>
	<CF_DATE tarih="attributes.education_record_date">
</cfif>
<cfif len(attributes.validity_date)>
	<cf_date tarih="attributes.validity_date">
</cfif>
<cfquery name="get_relative" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		EMPLOYEES_RELATIVES 
	WHERE 
		TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tc_identy_no#">
		AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
<cfif get_relative.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='30309.Aynı TC kimlik numarası ile kayıtlı üye var. Kontrol ediniz'>");
		<cfif not isdefined("attributes.draggable")>history.back();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</script>
	<cfabort>
</cfif>
<cfquery name="ADD_RELATIVE" datasource="#DSN#" result="MAX_ID">
  INSERT INTO
 	EMPLOYEES_RELATIVES
	(
		EMPLOYEE_ID,
		NAME,
		SURNAME,
		SEX,
		RELATIVE_LEVEL,
		BIRTH_DATE,
		BIRTH_PLACE,
		TC_IDENTY_NO,
		EDUCATION,
		EDUCATION_STATUS,
		WORK_STATUS,
		DISCOUNT_STATUS,
		JOB,
		COMPANY,
		JOB_POSITION,
		DETAIL,
		MARRIAGE_DATE,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE,
		EDUCATION_SCHOOL_NAME,
		EDUCATION_CLASS_NAME,
		EDUCATION_RECORD_DATE,
        VALIDITY_DATE,
		CHILD_HELP,
		DISABLED_RELATIVE,
		IS_MARRIED,
		CORPORATION_EMPLOYEE,
		IS_RETIRED,
		KINDERGARDEN_SUPPORT,
		IS_COMMITMENT_NOT_ASSURANCE,
		IS_ASSURANCE_POLICY,
		PROCESS_STAGE
	)
  VALUES
    (
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.name#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.surname#">,
		<cfif isDefined("attributes.sex")>#attributes.sex#,<cfelse>0,</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.relative_level#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.birth_date#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.birth_place#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tc_identy_no#">,
		<cfif LEN(attributes.education)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.education#">,<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.education_status")>1,<cfelse>0,</cfif>
		<cfif isdefined("attributes.work_status")>1,<cfelse>0,</cfif>	
		<cfif isdefined("attributes.discount_status")>1,<cfelse>0,</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.job#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.company#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.job_position#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
		<cfif len(attributes.marriage_date)>#attributes.marriage_date#<cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.education_school_name#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.education_class_name#">,
		<cfif len(attributes.education_record_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.education_record_date#"><cfelse>null</cfif>,
        <cfif len(attributes.validity_date)><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.validity_date#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.child_help")>1,<cfelse>0,</cfif>
		<cfif isdefined("attributes.disabled_relative")>1,<cfelse>0,</cfif>
		<cfif isdefined("attributes.is_married")>1,<cfelse>0,</cfif>
		<cfif isdefined("attributes.corporation_employee")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.is_retired")>1<cfelse>0</cfif>,
		<cfif isDefined("attributes.kindergarden_support")>1<cfelse>0</cfif>,
		<cfif isDefined("attributes.is_commitment_not_assurance")>1<cfelse>0</cfif>,
		<cfif isDefined("attributes.is_assurance_policy")>1<cfelse>0</cfif>,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
	)
</cfquery>	
<cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEES_RELATIVES" target_table="EMPLOYEES_RELATIVES_HISTORY" record_id= "#MAX_ID.IDENTITYCOL#" record_name="RELATIVE_ID">
<cfif pageFuseaction eq "myhome.employee_relative">
	<cfset attributes.relative_id = contentEncryptingandDecodingAES(isEncode:1,content:MAX_ID.IDENTITYCOL,accountKey:'wrk')>
	<cfset employee_id = contentEncryptingandDecodingAES(isEncode:1,content:attributes.employee_id,accountKey:'wrk')>
<cfelse>
	<cfset attributes.relative_id = MAX_ID.IDENTITYCOL>
	<cfset employee_id = attributes.employee_id>
</cfif>
<cf_workcube_process 
	is_upd='1'
	data_source='#dsn#'
	old_process_line='0'
	process_stage='#attributes.process_stage#'
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='EMPLOYEES_RELATIVES'
	action_column='RELATIVE_ID'
	action_id='#MAX_ID.IDENTITYCOL#'
	action_page='#request.self#?fuseaction=#listFirst(attributes.pageFuseaction,'.')#.employee_relative&event=upd&employee_id=#employee_id#&relative_id=#attributes.relative_id#'
	warning_description='#getLang("","Çalışan yakını",31468)#: #MAX_ID.IDENTITYCOL#'>		


<script>
	<cfif attributes.fuseaction eq 'myhome.employee_relative'>
		location.href= document.referrer;
	<cfelseif not isdefined("attributes.draggable")>
        window.location.href = "<cfoutput>#request.self#?fuseaction=#listFirst(attributes.pageFuseaction,'.')#.employee_relative#ssk_ek#&event=upd&#relative_url_string#&employee_id=#employee_id#&relative_id=#attributes.relative_id#</cfoutput>";
    <cfelseif isdefined("attributes.draggable")>
		location.reload();
	</cfif>
</script>