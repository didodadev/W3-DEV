<cf_xml_page_edit>
<cfparam name="attributes.is_virtual_puantaj" default="0">
<cfif attributes.is_virtual_puantaj eq 0>
	<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
	<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
	<cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT">
	<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
	<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cfelse>
	<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ_VIRTUAL">
	<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_VIRTUAL">
	<cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT_VIRTUAL">
	<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD_VIRTUAL">
	<cfset maas_puantaj_table = "EMPLOYEES_SALARY_PLAN">
</cfif>
<cfinclude template="../query/get_puantaj.cfm">
<cfquery name="get_puantaj_branch" datasource="#dsn#" maxrows="1">
	SELECT BRANCH_ID,BRANCH_NAME,COMPANY_ID FROM BRANCH WHERE BRANCH_ID = '#get_puantaj.SSK_BRANCH_ID#'
</cfquery>
<cfset attributes.sal_mon = get_puantaj.sal_mon>
<cfset attributes.sal_year = get_puantaj.sal_year>
<cfquery name="get_period_id" datasource="#dsn#" maxrows="1">
	SELECT PERIOD_ID,PERIOD_YEAR FROM SETUP_PERIOD WHERE (PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj.sal_year#"> OR YEAR(FINISH_DATE) = #get_puantaj.sal_year#) AND (FINISH_DATE IS NULL OR (FINISH_DATE IS NOT NULL AND FINISH_DATE >= #createdate(get_puantaj.sal_year,get_puantaj.sal_mon,1)#)) AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_branch.company_id#">
</cfquery>
<cfset new_dsn2 = '#dsn#_#get_period_id.period_year#_#get_puantaj_branch.COMPANY_ID#'>
<cfset new_period_id = get_period_id.period_id>
<cfset new_dsn2_alias = "#new_dsn2#">
<cfinclude template="../query/get_puantaj_rows.cfm">
<cfquery name="GET_IS_INTEGRATED" datasource="#dsn#">
	SELECT IS_INTEGRATED FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#">
</cfquery>

<cfif get_puantaj_rows.recordcount>
	<cfset in_out_list = listdeleteduplicates(valuelist(get_puantaj_rows.in_out_id))>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='53377.Puantaja Bağlı Satır Bulunamadı'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_box title="#getLang('ehesap',424)# : #get_puantaj_branch.BRANCH_NAME# (#listgetat(ay_list(),attributes.sal_mon)# - #attributes.sal_year# <cf_get_lang dictionary_id ='53379.Dönemi'> )">
<table>
	<tr>
		<td valign="top">
			<cfif GET_PUANTAJ.IS_BUDGET EQ 1>
				<font color="FF0000">*** <cf_get_lang dictionary_id='53375.Puantajın Bütçe Kaydı Daha Önce Oluşturulmuş'> !<br/><br/></font>
                <cfquery name="get_budget_act" datasource="#new_dsn2#">
                    SELECT DISTINCT
						EX.RECORD_DATE,
                        EX.EXPENSE_DATE,
                        E.EMPLOYEE_NAME,
                        E.EMPLOYEE_SURNAME 
                    FROM 
                        EXPENSE_ITEMS_ROWS EX,
                        #dsn_alias#.EMPLOYEES E 
                    WHERE 
                        EX.RECORD_EMP = E.EMPLOYEE_ID AND
                        EX.EXPENSE_COST_TYPE = 161 AND 
                        EX.ACTION_ID = #GET_PUANTAJ.PUANTAJ_ID#
                        AND EX.ACTION_TABLE = 'EMPLOYEES_PUANTAJ'
                </cfquery>
			
                <table>
                    <tr height="25" class="formbold">
                        <td colspan="7"><cf_get_lang dictionary_id='53382.Bütçe Hareketleri'></td>
                    </tr>
                    <tr class="txtboldblue">
                        <td width="75"><cf_get_lang dictionary_id='57879.İşlem T'></td>
                        <td width="75"><cf_get_lang dictionary_id='57627.Kayıt T'></td>
                        <td width="125"><cf_get_lang dictionary_id='57483.Kayıt'></td>
                        <cfif new_period_id eq session.ep.period_id>
                            <td></td>
                        </cfif>
                    </tr>
                    <cfif get_budget_act.recordcount>
                        <cfoutput query="get_budget_act">
                            <tr height="20">
                                <td>#dateformat(expense_date,dateformat_style)#</td>
                                <td>#dateformat(RECORD_date,dateformat_style)#</td>
                                <td>#employee_name# #employee_surname#</td>
                                <cfif new_period_id eq session.ep.period_id>
                                    <td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_puantaj_act&type=3&puantaj_id=#get_puantaj.puantaj_id#','medium')" class="tableyazi"><img src="/images/update_list.gif" border="0" style="vertical-align:middle" alt="Detay" title="Detay"></a></td>
                                </cfif>
                            </tr>
                        </cfoutput>
                        <tr>
                            <cfif not listfindnocase(denied_pages,'ehesap.del_budget_act')>
                                <cfform name="del_account_card" action="">
                                    <input type="hidden" name="puantaj_budget_date_del" id="puantaj_budget_date_del" value="<cfoutput>#dateFormat(CREATEDATE(get_puantaj.sal_year,get_puantaj.sal_mon,puantaj_gun_),dateformat_style)#</cfoutput>">
                                    <td colspan="6" style="text-align:right;">
                                        <input type="button" value="<cf_get_lang dictionary_id='53344.Fişleri Sil'>" onclick="if(!chk_period(document.getElementById('puantaj_budget_date_del'),'İşlem')) return false; go_to_sil();"> 
                                    </td>
                                </cfform>
                            </cfif>
                        </tr>
                    <cfelse>
                        <tr>
                            <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                        </tr>
                    </cfif>
                </table>
			<cfelseif not isdefined("attributes.is_submitted")>
				<cfform name="add_budget_act" action="">
					<table>
						<tr>
							<td>
                                <input type="hidden" name="is_submitted" id="is_submitted" value="1">
                                <input type="hidden" name="puantaj_budget_date" id="puantaj_budget_date" value="<cfoutput>#dateFormat(CREATEDATE(get_puantaj.sal_year,get_puantaj.sal_mon,puantaj_gun_),dateformat_style)#</cfoutput>">
                                <b><cfoutput> #get_puantaj_branch.BRANCH_NAME# (#listgetat(ay_list(),attributes.sal_mon)# - #attributes.sal_year# <cf_get_lang dictionary_id ='53379.Dönemi'> )</cfoutput></b>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='53485.Bütçe Kaydı Oluştur'></cfsavecontent>
                                <input type="button" name="add_acc_card" id="add_acc_card" value="<cfoutput>#message#</cfoutput>" onclick="if(!chk_period(document.getElementById('puantaj_budget_date'),'İşlem')) return false; add_budget_act.submit();">
							</td>
						</tr>
					</table>
				</cfform>
			</cfif>
			<cfif isdefined("attributes.is_submitted") and GET_PUANTAJ.IS_BUDGET neq 1>
				<cfinclude template="add_puantaj_to_budget.cfm">
			</cfif>
		</td>
	</tr>
</table>
</cf_box>
<script language="javascript">
	function go_to_sil()
	{
		if (confirm("<cf_get_lang dictionary_id='53400.Kayıtlı Bütçe Tahakkuk Fişlerini Siliyorsunuz Emin misiniz'>?"))
		{
			windowopen('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_del_budget_act&is_puantaj=1&puantaj_id=#get_puantaj.puantaj_id#&new_dsn2=#new_dsn2#</cfoutput>','small');
		}
		else
			return false;
	}
</script>
