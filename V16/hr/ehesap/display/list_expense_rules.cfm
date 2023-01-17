<cfset ExpenseRules= createObject("component","V16.hr.ehesap.cfc.expense_rules") />
<cfparam name="attributes.expense_hr_rules_id" default="">
<cfset GET_EXPENSE_RULES_LIST=ExpenseRules.GET_EXPENSE_RULES_LIST() />
<table width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang dictionary_id = "41550.Harcırah Kuralları"></td>
    </tr>
<cfif GET_EXPENSE_RULES_LIST.recordcount>
<cfoutput query="GET_EXPENSE_RULES_LIST">
    <tr>	
        <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
        <td width="380"><a href="#request.self#?fuseaction=ehesap.list_expense_rules&event=upd&expense_hr_rules_id=#expense_hr_rules_id#"  class="tableyazi">#expense_hr_rules_detail#</a></td>
    </tr>
</cfoutput>
<cfelse>
    <tr>
        <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
        <td width="380"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
</cfif>
</table>