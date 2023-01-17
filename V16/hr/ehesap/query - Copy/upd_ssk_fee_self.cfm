<cf_date tarih="attributes.DATE">
<cf_date tarih="attributes.DATEOUT">
<cfset attributes.sal_mon = month(attributes.DATE)>
<cfset attributes.sal_year = year(attributes.DATE)>
<cfif isDefined("attributes.workcheck") and isDefined("attributes.ILLNESS")>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='201.İş kazası'> - <cf_get_lang no='516.Meslek Hastalığı'>");
		history.back();
	</script>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="get_in_out" datasource="#DSN#">
	SELECT
		START_DATE,
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

<cfif len(attributes.DATEEVENT) and isdate(attributes.DATEEVENT)>
	<cf_date tarih="attributes.DATEEVENT">
</cfif>
<cfquery name="ADD_SSK_FEE" datasource="#DSN#">
	UPDATE
		EMPLOYEES_SSK_FEE
	SET
		EMPLOYEE_ID = #attributes.employee_id#,
		IN_OUT_ID = #attributes.in_out_id#,
		FEE_DATE = #attributes.DATE#,
		FEE_HOUR = #attributes.HOUR#,
		FEE_DATEOUT = #attributes.DATEOUT#,
		FEE_HOUROUT = #attributes.HOUROUT#,
	<cfif isdefined("attributes.valid") and len(attributes.valid)>
		VALID = #attributes.valid#,
		VALID_EMP = #session.ep.userid#,
		VALID_DATE = #now()#,
	<cfelseif isdefined("ATTRIBUTES.VALIDATOR_POS_CODE") and len(ATTRIBUTES.VALIDATOR_POS_CODE)>
		VALIDATOR_POS_CODE = #ATTRIBUTES.VALIDATOR_POS_CODE#,
	</cfif>
		ACCIDENT = <cfif isdefined("attributes.workcheck")>1,<cfelse>0,</cfif>
		TOTAL_EMP = <cfif isdefined("attributes.workcheck") and len(attributes.TOTAL_EMP)>#attributes.TOTAL_EMP#,<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>EMP_WORK = '#attributes.EMP_WORK#',<cfelse>EMP_WORK = NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>EVENT = '#attributes._event_shape#',<cfelse>EVENT = NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>PLACE = '#attributes.PLACE#',<cfelse>PLACE = NULL,</cfif>
		<cfif isdefined("attributes.workcheck") and len(attributes.DATEEVENT)>EVENT_DATE = #attributes.DATEEVENT#,<cfelse>EVENT_DATE = NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>EVENT_HOUR = #attributes.HOUREVENT#,<cfelse>EVENT_HOUR = NULL,</cfif> 
		<cfif isdefined("attributes.workcheck")>EVENT_MIN = '#attributes.EVENT_MIN#',<cfelse>EVENT_MIN = NULL,</cfif> 
		<cfif isdefined("attributes.workcheck")>WORKSTART = '#attributes.WORKSTART#',<cfelse>WORKSTART = NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>WITNESS1 = '#attributes.WITNESS1#',<cfelse>WITNESS1 = NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>WITNESS2 = '#attributes.WITNESS2#',<cfelse>WITNESS2 = NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>WITNESS1_ID = '#attributes.WITNESS1_ID#',<cfelse>WITNESS1_ID = NULL,</cfif>
		<cfif isdefined("attributes.workcheck")>WITNESS2_ID = '#attributes.WITNESS2_ID#',<cfelse>WITNESS2_ID = NULL,</cfif>
		<cfif isdefined("attributes.accident_type_id") and len(attributes.accident_type_id)>ACCIDENT_TYPE_ID = #attributes.ACCIDENT_TYPE_ID#,<cfelse>ACCIDENT_TYPE_ID = NULL,</cfif>
		<cfif isdefined("attributes.accident_security_id") and len(attributes.accident_security_id)>ACCIDENT_SECURITY_ID = #attributes.ACCIDENT_SECURITY_ID#,<cfelse>ACCIDENT_SECURITY_ID = NULL,</cfif>
		ILLNESS = <cfif isdefined("attributes.illness")> 1, <cfelse> 0 ,</cfif>
	    JOB_ILLNESS_TO_FIX = <cfif isdefined('attributes.JOB_ILLNESS_TO_FIX') and len(attributes.JOB_ILLNESS_TO_FIX)>#attributes.JOB_ILLNESS_TO_FIX#<cfelse>NULL</cfif>,
		ACCIDENT_RESULT_DEAD = <cfif isdefined('attributes.accident_result_dead') and len(attributes.accident_result_dead)>#attributes.accident_result_dead#<cfelse>NULL</cfif>,
		ACCIDENT_RESULT_DEAD_WOUNDED = <cfif isdefined('attributes.accident_result_wounded') and len(attributes.accident_result_wounded)>#attributes.accident_result_wounded#<cfelse>NULL</cfif>,
		ORGAN_TO_LOSE = <cfif isdefined('attributes.organ_to_lose') and len(attributes.organ_to_lose)>#attributes.organ_to_lose#<cfelse>NULL</cfif>,
		LIGHT_WOUNDED = <cfif isdefined('attributes.light_wounded') and len(attributes.light_wounded)>#attributes.light_wounded#<cfelse>NULL</cfif>,
		REST_FIRST_DAY = <cfif isdefined('attributes.rest_first_day') and len(attributes.rest_first_day)>#attributes.rest_first_day#<cfelse>NULL</cfif>,
		REST_SECOND_DAY = <cfif isdefined('attributes.rest_second_day') and len(attributes.rest_second_day)>#attributes.rest_second_day#<cfelse>NULL</cfif>,
		REST_THIRD_DAY = <cfif isdefined('attributes.rest_third_day') and len(attributes.rest_third_day)>#attributes.rest_third_day#<cfelse>NULL</cfif>,
		REST_EXTRA_DAY = <cfif isdefined('attributes.rest_extra_day') and len(attributes.rest_extra_day)>#attributes.rest_extra_day#<cfelse>NULL</cfif>,
		RELATIVE_NAME_SURNAME = <cfif isdefined('attributes.relative_name_surname') and len(attributes.relative_name_surname)>'#attributes.relative_name_surname#'<cfelse>NULL</cfif>,
		RELATIVE_ADDRESS =  <cfif isdefined('attributes.relative_address') and len(attributes.relative_address)>'#attributes.relative_address#'<cfelse>NULL</cfif>,
		PROFESSION_ILL_DIAGNOSIS = <cfif isdefined('attributes.profession_ill_diagnosis') and len(attributes.profession_ill_diagnosis)>'#attributes.profession_ill_diagnosis#'<cfelse>NULL</cfif>,
		PROFESSION_ILL_WORK = <cfif isdefined('attributes.profession_ill_work') and len(attributes.profession_ill_work)>'#attributes.profession_ill_work#'<cfelse>NULL</cfif>,
		PROFESSION_ILL_DOUBT = <cfif isdefined('attributes.profession_ill_doubt') and len(attributes.profession_ill_doubt)>'#attributes.profession_ill_doubt#'<cfelse>NULL</cfif>,
		BRANCH_ID = #get_in_out.BRANCH_ID#,
		DETAIL = '#FORM.DETAIL#',
		RELATIVE_REPORT=<cfif isdefined("attributes.relativecheck")>1<cfelse>0</cfif>,
		ACCIDENT_CONTINUATION=<cfif isdefined("attributes.continuationcheck")>1<cfelse>0</cfif>,
		DETAIL_PRINT=<cfif isdefined("attributes.detail_print")>1<cfelse>0</cfif>,
		WILFUL_ERROR = '#attributes.WILFUL_ERROR#',
		DISMEMBERMENT = '#attributes.DISMEMBERMENT#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #NOW()#
	WHERE
		FEE_ID = #attributes.FEE_ID#
</cfquery>

<script type="text/javascript">
<cfif isDefined("attributes.valid") and len(attributes.valid)>
    window.location.href = "<cfoutput>#request.self#?fuseaction=hr.list_visited&event=upd&fee_id=#attributes.fee_id#</cfoutput>";
<cfelse>
	window.location.reload();
</cfif>
</script>