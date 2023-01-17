<cfif attributes.fuseaction contains "myhome" and not isNumeric(attributes.employee_id)>
	<cfset attributes.employee_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.employee_id,accountKey:'wrk')>
	<cfset attributes.relative_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.relative_id,accountKey:'wrk')>
<cfelse>
	<cfset attributes.employee_id = attributes.employee_id>
	<cfset attributes.relative_id = attributes.relative_id>
</cfif>
<cfif fuseaction eq "hr.employee_relative_ssk">
	<cfset relative_url_string = "&field_name=ssk_fee.ill_name&field_surname=ssk_fee.ill_surname&field_relative=ssk_fee.ill_relative&field_birth_date=ssk_fee.BIRTH_DATE&field_birth_place=ssk_fee.BIRTH_PLACE&field_tc_identy_no=ssk_fee.TC_IDENTY_NO&field_ill_sex=ssk_fee.ill_sex">
	<cfset ssk_ek = "_ssk">
<cfelseif fuseaction eq "hr.employee_relative" or fuseaction eq "myhome.employee_relative">
	<cfset relative_url_string = "">
	<cfset ssk_ek = "">
</cfif>

<cfquery name="get_relative_valid" datasource="#DSN#">
	SELECT
		RELATIVE_ID
	FROM
		EMPLOYEES_RELATIVES
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		AND TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tc_identy_no#">
        AND RELATIVE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.RELATIVE_ID#">
</cfquery>
<cfif get_relative_valid.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='30309.Aynı TC kimlik numarası ile kayıtlı üye var. Kontrol ediniz'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif isDefined("attributes.BIRTH_DATE") and len(attributes.BIRTH_DATE)>
	<CF_DATE tarih="attributes.BIRTH_DATE">
</cfif>
<cfif isDefined("attributes.marriage_date") and len(attributes.marriage_date)>
	<CF_DATE tarih="attributes.marriage_date">
</cfif>
<cfif isDefined("attributes.EDUCATION_RECORD_DATE") and len(attributes.EDUCATION_RECORD_DATE)>
	<CF_DATE tarih="attributes.EDUCATION_RECORD_DATE">
</cfif>
<cfif isDefined("attributes.validity_date") and len(attributes.validity_date)>
	<cf_date tarih="attributes.validity_date">
</cfif>
<cfif isdefined("attributes.defection_startdate") and len(attributes.defection_startdate)>
	<cf_date tarih="attributes.defection_startdate">
</cfif>
<cfif isdefined("attributes.defection_finishdate") and len(attributes.defection_finishdate)>
	<cf_date tarih="attributes.defection_finishdate">
</cfif>
<cfquery name="UPD_RELATIVE" datasource="#DSN#">
  UPDATE
 	EMPLOYEES_RELATIVES
  SET
	EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">,
	NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.NAME#">,
	SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SURNAME#">,
	<cfif isdefined("attributes.sex") and len(attributes.sex)>SEX = #attributes.sex#,<cfelse>SEX = 1,</cfif>
	RELATIVE_LEVEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.RELATIVE_LEVEL#">,
	BIRTH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.BIRTH_DATE#">,
	BIRTH_PLACE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.BIRTH_PLACE#">,
	TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TC_IDENTY_NO#">,
	DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
	MARRIAGE_DATE = <cfif len(attributes.marriage_date)>#attributes.marriage_date#<cfelse>NULL</cfif>,
	EDUCATION = <cfif LEN(attributes.EDUCATION)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EDUCATION#">,<cfelse>NULL,</cfif>
	WORK_STATUS = <cfif isdefined("attributes.work_status")>1,<cfelse>0,</cfif>	
	EDUCATION_STATUS = <cfif isdefined("attributes.education_status")>1,<cfelse>0,</cfif>	
	DISCOUNT_STATUS = <cfif isdefined("attributes.discount_status")>1,<cfelse>0,</cfif>
	JOB = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.JOB#">,
	COMPANY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.COMPANY#">,
	JOB_POSITION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.JOB_POSITION#">,
	UPDATE_EMP = #SESSION.EP.USERID#,
	UPDATE_IP = '#CGI.REMOTE_ADDR#',
	EDUCATION_SCHOOL_NAME = <cfif attributes.RELATIVE_LEVEL EQ 4 OR attributes.RELATIVE_LEVEL EQ 5><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EDUCATION_SCHOOL_NAME#"><cfelse>null</cfif>,
	EDUCATION_CLASS_NAME = <cfif attributes.RELATIVE_LEVEL EQ 4 OR attributes.RELATIVE_LEVEL EQ 5><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EDUCATION_CLASS_NAME#"><cfelse>null</cfif>,
	EDUCATION_RECORD_DATE = <cfif len(attributes.EDUCATION_RECORD_DATE) AND (attributes.RELATIVE_LEVEL EQ 4 OR attributes.RELATIVE_LEVEL EQ 5)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.EDUCATION_RECORD_DATE#"><cfelse>null</cfif>,
	UPDATE_DATE = #NOW()#,
    VALIDITY_DATE = <cfif len(attributes.validity_date)><cfqueryparam cfsqltype="cf_sql_date" value="#attributes.validity_date#"><cfelse>NULL</cfif>,
	CHILD_HELP = <cfif isdefined("attributes.child_help")>1<cfelse>0</cfif>,
	DISABLED_RELATIVE = <cfif isdefined("attributes.disabled_relative")>1<cfelse>0</cfif>,
	IS_MARRIED = <cfif isdefined("attributes.is_married")>1<cfelse>0</cfif>,
	CORPORATION_EMPLOYEE = <cfif isdefined("attributes.corporation_employee")>1<cfelse>0</cfif>,
	IS_RETIRED = <cfif isdefined("attributes.is_retired")>1<cfelse>0</cfif>,
	KINDERGARDEN_SUPPORT = <cfif isDefined("attributes.kindergarden_support")>1<cfelse>0</cfif>,
	IS_COMMITMENT_NOT_ASSURANCE = <cfif isDefined("attributes.is_commitment_not_assurance")>1<cfelse>0</cfif>,
	IS_ASSURANCE_POLICY = <cfif isDefined("attributes.is_assurance_policy")>1<cfelse>0</cfif>,
	USE_TAX = <cfif isdefined("attributes.use_tax")>1<cfelse>0</cfif>,
	DEFECTION_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DEFECTION_LEVEL#">,
	PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
	DEFECTION_RATE = <cfif isdefined("attributes.defection_rate") and len(attributes.defection_rate)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.defection_rate#"><cfelse>NULL</cfif>,
	DEFECTION_STARTDATE = <cfif isdefined("attributes.defection_startdate") and len(attributes.defection_startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.defection_startdate#"><cfelse>NULL</cfif>,
	DEFECTION_FINISHDATE = <cfif isdefined("attributes.defection_finishdate") and len(attributes.defection_finishdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.defection_finishdate#"><cfelse>NULL</cfif>
  WHERE
	RELATIVE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.RELATIVE_ID#">
</cfquery>
<cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEES_RELATIVES" target_table="EMPLOYEES_RELATIVES_HISTORY" record_id= "#attributes.RELATIVE_ID#" record_name="RELATIVE_ID">
<!--- <cfif attributes.fuseaction eq "myhome.employee_relative">
	<cfset attributes.relative_id = contentEncryptingandDecodingAES(isEncode:1,content:attributes.relative_id,accountKey:'wrk')>
	<cfset employee_id = contentEncryptingandDecodingAES(isEncode:1,content:attributes.employee_id,accountKey:'wrk')>
<cfelse>
	<cfset attributes.relative_id = attributes.relative_id>
	<cfset employee_id = attributes.employee_id>
</cfif> --->
<cf_workcube_process 
	is_upd='1'
	data_source='#dsn#'
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#'
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='EMPLOYEES_RELATIVES'
	action_column='RELATIVE_ID'
	action_id='#attributes.RELATIVE_ID#'
	action_page='#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.employee_relative&event_upevent=upd&employee_id=#attributes.employee_id#&relative_id=#attributes.RELATIVE_ID#'
	warning_description='#getLang("","Çalışan yakını",31468)#: #attributes.RELATIVE_ID#'>

<script>
	<cfif attributes.fuseaction eq 'myhome.employee_relative'>
		location.href= document.referrer;
	<cfelseif not isdefined("attributes.draggable")>
        window.location.href = "<cfoutput>#request.self#?fuseaction=#listFirst(attributes.pageFuseaction,'.')#.employee_relative#ssk_ek#&event=upd&#relative_url_string#&employee_id=#employee_id#&relative_id=#attributes.relative_id#</cfoutput>";
    <cfelseif isdefined("attributes.draggable")>
		location.reload();
	</cfif>
</script>