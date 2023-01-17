<cfquery name="get_emp_att" datasource="#dsn#">
	SELECT 
		EMP_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME 
	FROM 
		TRAINING_CLASS_ATTENDER,
		EMPLOYEES 
	WHERE 
		TRAINING_CLASS_ATTENDER.EMP_ID = EMPLOYEES.EMPLOYEE_ID AND
		CLASS_ID=#attributes.CLASS_ID# AND 
		EMP_ID IS NOT NULL 
		AND PAR_ID IS NULL 
		AND CON_ID IS NULL
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME 
</cfquery>
<cfform name="upd_class_attender_eval" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_class_eval">
<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
<cfsavecontent variable="caption"><cf_get_lang no='185.Eğitim Değerlendirme Formu'></cfsavecontent>
<input type="hidden" name="caption" id="caption" value="<cfoutput>#caption#</cfoutput>">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr class="color-border">
    <td>
<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
  <tr class="color-list">
    <td height="35">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
<td height="35" class="headbold">&nbsp;<cf_get_lang no='185.Eğitim Değerlendirme Formu'></td>
	<td style="text-align:right;">
	<cfoutput>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_eval&action=print&id=#url.class_id#,#url.quiz_id#&module=training_management&quiz_id=#attributes.quiz_id#','page');return false;"><img src="/images/print.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a> 
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_eval&action=mail&id=#url.class_id#,#url.quiz_id#&module=training_management&caption=upd_class_attender_eval.caption','page')"><img src="/images/mail.gif" title="<cf_get_lang_main no='63.Mail Gönder'>" border="0"></a> 
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_class_eval&action=pdf&id=#url.class_id#,#url.quiz_id#&module=training_management','page')"><img src="/images/pdf.gif" title="<cf_get_lang_main no='66.PDF e Dönüştür'>" border="0"></a>
        <a href="#request.self#?fuseaction=training_management.popup_form_add_class_eval&class_id=#class_id#&quiz_id=#quiz_id#"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
	</cfoutput>
	</td>
  </tr>
</table>

	</td>
  </tr>
    <cfinclude template="../display/performance_quiz_2.cfm">
	 <tr class="color-row">
		<td height="35">
			<cf_workcube_buttons is_upd='1' is_delete='0'>
		</td>
	  </tr> 
</table>
	</td>
  </tr>
</table>			
</cfform>
