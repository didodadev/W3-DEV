<cfif isdefined("attributes.workcheck") and isdefined("attributes.ILLNESS")>
  <script type="text/javascript">
    alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='201.İş Kazası'> - <cf_get_lang no='516.Meslek Hastalığı'>");
	history.back();
  </script>
  <cfexit method="exittemplate">
</cfif>

<cfif len(attributes.DATE)>
	<cf_date tarih="attributes.DATE">
</cfif>
<cfif len(attributes.DATEOUT)>
	<cf_date tarih="attributes.DATEOUT">
</cfif>
<cfif isdefined("attributes.DATEEVENT") and len(attributes.DATEEVENT)>
	<cf_date tarih="attributes.DATEEVENT">
</cfif>
<cfquery name="get_in_out" datasource="#DSN#">
	SELECT
		BRANCH_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		IN_OUT_ID = #attributes.in_out_id#
</cfquery>

<cfif not get_in_out.recordcount>
	<script type="text/javascript">
		alert('Çalışanın Seçilen Şube İçin Giriş Çıkış Kaydı Bulunamadı!');
		history.back();
	</script>
	<cfabort>
</cfif>


<cfquery name="ADD_SSK_FEE" datasource="#DSN#" result="MAXID">
	INSERT INTO EMPLOYEES_SSK_FEE
		(
		EMPLOYEE_ID,
		IN_OUT_ID,
		FEE_DATE,
		FEE_HOUR,
		FEE_DATEOUT,
		FEE_HOUROUT,
	<cfif isdefined("attributes.VALIDATOR_POS_CODE") and len(attributes.VALIDATOR_POS_CODE)>
		VALIDATOR_POS_CODE,
	<cfelse>
		VALID,
		VALID_EMP,
		VALID_DATE,
	</cfif>
	<cfif isdefined("attributes.workcheck")>
		ACCIDENT,
		<cfif len(attributes.TOTAL_EMP)>
		TOTAL_EMP,
		</cfif>
		EMP_WORK,
		EVENT,
		PLACE,
		ACCIDENT_TYPE_ID,
		ACCIDENT_SECURITY_ID,
		<cfif len(attributes.DATEEVENT)>
		EVENT_DATE,
		</cfif>
		EVENT_HOUR,
		EVENT_MIN,
		WORKSTART,
		WITNESS1,
		WITNESS2,
	<cfelse>
		ACCIDENT,
	</cfif>
		ILLNESS,
	<cfif LEN(FORM.DETAIL)>
		DETAIL,
	</cfif>
		RELATIVE_REPORT,
		ACCIDENT_CONTINUATION,
		DISMEMBERMENT,
		WILFUL_ERROR,
		BRANCH_ID,
		DETAIL_PRINT,
	    JOB_ILLNESS_TO_FIX,
		ACCIDENT_RESULT_DEAD,
		ACCIDENT_RESULT_DEAD_WOUNDED,
		ORGAN_TO_LOSE,
		LIGHT_WOUNDED,
		REST_FIRST_DAY,
		REST_SECOND_DAY,
		REST_THIRD_DAY,
		REST_EXTRA_DAY,
		RELATIVE_NAME_SURNAME,
		RELATIVE_ADDRESS,
		PROFESSION_ILL_DIAGNOSIS,
		PROFESSION_ILL_WORK,
		PROFESSION_ILL_DOUBT,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
		)
	VALUES
		(
		#attributes.EMPLOYEE_ID#,
		#attributes.IN_OUT_ID#,
		#attributes.DATE#,
		#attributes.HOUR#,
		#attributes.DATEOUT#,
		#attributes.HOUROUT#,
	<cfif isdefined("attributes.VALIDATOR_POS_CODE") and len(attributes.VALIDATOR_POS_CODE)>
		#ATTRIBUTES.VALIDATOR_POS_CODE#,
	<cfelse>
		1,
		#session.ep.userid#,
		#now()#,
	</cfif>
	<cfif isdefined("attributes.workcheck")>
		1,
		<cfif len(attributes.TOTAL_EMP)>
		#attributes.total_emp#,
		</cfif>
		'#attributes.emp_work#',
		'#attributes._event_shape#',
		'#attributes.PLACE#',
		<cfif isdefined("attributes.ACCIDENT_TYPE_ID") and len(attributes.ACCIDENT_TYPE_ID)>
		#attributes.ACCIDENT_TYPE_ID#,
		<cfelse>
		NULL,
		</cfif>
		<cfif isdefined("attributes.ACCIDENT_SECURITY_ID") and len(attributes.ACCIDENT_SECURITY_ID)>
		#attributes.ACCIDENT_SECURITY_ID#,
		<cfelse>
		NULL,
		</cfif>
		<cfif len(attributes.DATEEVENT)>
		#attributes.DATEEVENT#,
		</cfif>
		#attributes.HOUREVENT#,
		'#attributes.EVENT_MIN#',
		'#attributes.workstart#',
		'#attributes.witness1#',
		'#attributes.witness2#',
	<cfelse>
		0,
	</cfif>
	<cfif isDefined("attributes.ILLNESS")>
		1,
	<cfelse>
		0,
	</cfif>
	<cfif LEN(FORM.DETAIL)>
		'#FORM.DETAIL#',
	</cfif>
	<cfif isdefined('attributes.relativecheck')>
		1,
	<cfelse>
		0,
	</cfif>
	<cfif isdefined('attributes.continuationcheck')>
		1,
	<cfelse>
		0,
	</cfif>
		'#attributes.DISMEMBERMENT#',
		'#attributes.WILFUL_ERROR#',
		#get_in_out.BRANCH_ID#,
		<cfif isdefined("attributes.detail_print")>1<cfelse>0</cfif>,
		<cfif isdefined('attributes.JOB_ILLNESS_TO_FIX') and len(attributes.JOB_ILLNESS_TO_FIX)>#attributes.JOB_ILLNESS_TO_FIX#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.accident_result_dead') and len(attributes.accident_result_dead)>#attributes.accident_result_dead#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.accident_result_wounded') and len(attributes.accident_result_wounded)>#attributes.accident_result_wounded#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.organ_to_lose') and len(attributes.organ_to_lose)>#attributes.organ_to_lose#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.light_wounded') and len(attributes.light_wounded)>#attributes.light_wounded#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.rest_first_day') and len(attributes.rest_first_day)>#attributes.rest_first_day#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.rest_second_day') and len(attributes.rest_second_day)>#attributes.rest_second_day#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.rest_third_day') and len(attributes.rest_third_day)>#attributes.rest_third_day#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.rest_extra_day') and len(attributes.rest_extra_day)>#attributes.rest_extra_day#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.relative_name_surname') and len(attributes.relative_name_surname)>'#attributes.relative_name_surname#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.relative_address') and len(attributes.relative_address)>'#attributes.relative_address#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.profession_ill_diagnosis') and len(attributes.profession_ill_diagnosis)>'#attributes.profession_ill_diagnosis#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.profession_ill_work') and len(attributes.profession_ill_work)>'#attributes.profession_ill_work#'<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.profession_ill_doubt') and len(attributes.profession_ill_doubt)>'#attributes.profession_ill_doubt#'<cfelse>NULL</cfif>,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#',
		#NOW()#
		)
</cfquery>
<cfquery name="get_last" datasource="#dsn#">
    SELECT MAX(FEE_ID) AS LAST_ID FROM EMPLOYEES_SSK_FEE
</cfquery>
<script>
    window.location.href = "<cfoutput>#request.self#?fuseaction=hr.list_visited&event=upd&fee_id=#get_last.LAST_ID#</cfoutput>";
</script>