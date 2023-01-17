<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
<!--- kisi icin yapilan form varsa buluyor ve secili getiriyor--->
	<cfif not len(attributes.period_year)>
		<cfset attributes.period_year=session.ep.period_year>
	</cfif>
	<cfquery name="GET_EMP_POS_CAT" datasource="#DSN#">
		SELECT POSITION_CAT_ID,POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#attributes.employee_id# AND IS_MASTER=1
	</cfquery>
	<cfquery name="GET_QUIZ" datasource="#DSN#">
		SELECT 
			EQ.QUIZ_ID,
			EQ.QUIZ_HEAD,
			FORM_OPEN_TYPE,
			EQ.START_DATE,
			EQ.FINISH_DATE
		FROM 
			EMPLOYEE_QUIZ EQ,
			RELATION_SEGMENT_QUIZ RS
		WHERE
			EQ.QUIZ_ID IS NOT NULL 		
			AND EQ.QUIZ_ID = RS.RELATION_FIELD_ID 
			AND RS.RELATION_ACTION_ID = #GET_EMP_POS_CAT.POSITION_CAT_ID#
			AND RS.RELATION_ACTION = 3
			AND EQ.QUIZ_ID = #attributes.quiz_id#
		UNION
		SELECT 
			EQ.QUIZ_ID,
			EQ.QUIZ_HEAD,
			FORM_OPEN_TYPE,
			EQ.START_DATE,
			EQ.FINISH_DATE
		FROM 
			EMPLOYEE_QUIZ EQ
		WHERE
			EQ.IS_ALL_EMPLOYEE = 1 AND 
			EQ.QUIZ_ID IS NOT NULL AND 
			EQ.QUIZ_ID = #attributes.quiz_id#
	</cfquery><!---Kisiye ait listeden gelen form id sine gore kaydı bulur --->
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='31377.Ölçme Değerlendirme Formu Girişi'></cfsavecontent>
<cf_form_box title="#message#">
<cfform name="add_perf_emp_info" method="post" action="#request.self#?fuseaction=myhome.form_add_perf_emp">
			<table>
				<tr>
					<td width="160"><cf_get_lang dictionary_id='57576.Çalışan'></td>
					<td><input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
						<cfinput type="text" name="emp_name" value="#get_emp_info(attributes.employee_id,0,0)#" style="width:180px;" readonly="yes">
					</td>            
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='58472.Dönem'></td>
					<td nowrap>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
						<cfif isdefined('GET_QUIZ') and GET_QUIZ.RECORDCOUNT>
							<cfset s_date=dateformat(GET_QUIZ.START_DATE,dateformat_style)>
						<cfelse>
							<cfset s_date='01/01/#attributes.period_year#'>
						</cfif>
						<cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" value="#s_date#" style="width:65px;">
						<cf_wrk_date_image date_field="start_date">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
						<cfif isdefined('GET_QUIZ') and GET_QUIZ.RECORDCOUNT>
							<cfset f_date=dateformat(GET_QUIZ.FINISH_DATE,dateformat_style)>
						<cfelse>
							<cfset f_date='01/01/#attributes.period_year#'>
						</cfif>
						<cfinput required="Yes" message="#message#" type="text" name="finish_date" validate="#validate_style#" value="#f_date#" style="width:65px;">
						<cf_wrk_date_image date_field="finish_date">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='31376.Ölçme Değerlendirme Formu'></td>
					<td><input type="hidden" name="quiz_id" id="quiz_id" value="">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='31378.Ölçme Değerlendirme Formu Seçiniz'></cfsavecontent>
						<cfinput type="text" name="quiz_name" value="" required="yes" message="#message#" readonly="true" style="width:180px;">
					</td>            
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='31379.Gruba Giriş'></td>
					<td><cfquery name="GET_HR" datasource="#dsn#">
							SELECT GROUP_STARTDATE FROM EMPLOYEES WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# 
						</cfquery>
						<cfoutput>#dateformat(get_hr.group_startdate,dateformat_style)#</cfoutput>
					</td>
				</tr>
			</table>
			<cf_form_box_footer><cf_workcube_buttons is_upd='0' type_format="1" insert_alert='' add_function='kontrol()'></cf_form_box_footer>
	</cfform>
</cf_form_box>
<script type="text/javascript">
<cfif isdefined("GET_QUIZ") and GET_QUIZ.RECORDCOUNT>
	document.add_perf_emp_info.quiz_id.value=<CFOUTPUT>#GET_QUIZ.QUIZ_ID#</CFOUTPUT>;
	document.add_perf_emp_info.quiz_name.value='<CFOUTPUT>#GET_QUIZ.QUIZ_HEAD#</CFOUTPUT>';
</cfif>
function kontrol()
{
	if(document.add_perf_emp_info.quiz_id.value.length==0)
	{
		alert("<cf_get_lang dictionary_id='31378.Ölçme Değerlendirme Formu Seçiniz'>");
		return false;
	}
	if(document.add_perf_emp_info.employee_id.value.length==0)
	{
		alert("<cf_get_lang dictionary_id='31183.Çalışan Seçiniz'>");
		return false;
	}
	return true;
}
</script>
