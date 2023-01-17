<cfquery name="get_trainer" datasource="#DSN#">
	SELECT
		EQRD.QUESTION_POINT,
		EQRD.QUESTION_USER_ANSWERS,
		EQU.QUIZ_HEAD
	FROM
		EMPLOYEE_QUIZ EQU,
		EMPLOYEE_QUIZ_RESULTS_DETAILS EQRD,
		EMPLOYEE_QUIZ_RESULTS EQR,
		TRAINING_CLASS_QUIZES TCQ,
		TRAINING_CLASS TC
	WHERE
		EQU.IS_TRAINER=1 AND
		EQR.RESULT_ID=EQRD.RESULT_ID AND
		EQR.QUIZ_ID=EQU.QUIZ_ID AND
		TCQ.CLASS_ID=TC.CLASS_ID AND
		TCQ.CLASS_ID=#attributes.CLASS_ID# AND
		EQRD.QUESTION_POINT IS NOT NULL
</cfquery>
<table cellpadding="0" cellspacing="0" style="height:290mm;width:210mm;" align="center" border="0" bordercolor="#CCCCCC">
	<!---<tr><td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td></tr>--->
<tr>
<td valign="top" height="100%">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td class="headbold" height="35" align="center"><font color="#CC0000"><cf_get_lang no='267.Eğitimci Değerlendirme'></font></td>
  </tr>
</table>
<table>
	<tr class="formbold" height="25">
		<td><cf_get_lang_main no='1398.Soru'></td>
		<td><cf_get_lang_main no='1572.Puan'></td>
		<td><cf_get_lang no='249.Görüş'></td>
	</tr>
	<cfoutput query="get_trainer">
		<tr height="20">
			<td>#QUIZ_HEAD#</td>
			<td>#QUESTION_POINT#</td>
			<td>#QUESTION_USER_ANSWERS#</td>
		</tr>	
	</cfoutput>
</table>
		</td>
	</tr>
	<!---<tr><td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td></tr>--->
</table>
