<cfset attributes.class_id = ListGetAt(attributes.id,1)>
<cfinclude template="../query/get_class.cfm">
<cfset attributes.quiz_id = ListGetAt(attributes.id,2)>
<cfquery name="get_emp_att" datasource="#dsn#">
	SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.CLASS_ID# AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfinclude template="../display/view_class.cfm">
<cfform name="upd_class_attender_eval" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_class_eval">
<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
    <table width="650" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
            <td height="35" class="headbold">&nbsp;<cf_get_lang no='185.Eğitim Değerlendirme Formu'></td>
        </tr>
    </table>
    <table width="650" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr class="color-border">
            <td>
                <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
                    <cfinclude template="../display/print_performance_quiz.cfm">
                </table>
            </td>
        </tr>
    </table>			
</cfform>
