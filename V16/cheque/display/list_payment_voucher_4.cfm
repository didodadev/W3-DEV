<cfset payroll_id_list=''>
<cfif isDefined("attributes.company_id") and len(attributes.company_id) or isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="get_voucher_actions" datasource="#dsn2#">
		SELECT
			VP.*,
			VPA.ACTION_ID AS ACT_ID,
			VPA.ACTION_TYPE_ID/* ,
            VH.VOUCHER_ID */
		FROM
			VOUCHER_PAYROLL VP,
			VOUCHER_PAYROLL_ACTIONS VPA/* ,
            VOUCHER_HISTORY VH */
		WHERE
            VP.PAYROLL_TYPE IN (1057,104)
			AND VP.ACTION_ID = VPA.PAYROLL_ID  
           /*  AND VH.PAYROLL_ID = VPA.PAYROLL_ID */
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			AND VP.COMPANY_ID = #attributes.company_id#
		<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			AND VP.CONSUMER_ID = #attributes.consumer_id#
		</cfif>
		<cfif session.ep.isBranchAuthorization>
			AND VP.PAYROLL_CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID IN(SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#))
		</cfif>
		ORDER BY PAYROLL_REVENUE_DATE
	</cfquery>
<cfelse>
	<cfset get_voucher_actions.recordcount = 0>
</cfif>

<cfif get_voucher_actions.recordcount>
	<cfset payroll_id_list = valuelist(get_voucher_actions.action_id)>
    <cf_seperator title="#getLang('cheque',237)#" id="yapilan_tahsilatlar_">
</cfif>
<cf_box>
    <cf_grid_list id="yapilan_tahsilatlar_">
        <thead>
            <tr> 
                <th width="30"><cf_get_lang_main no='75.No'></th>
                <th width="30"><cf_get_lang no='11.Bordro No'></th>
                <th width="75"><cf_get_lang_main no='388.İşlem Tipi'></th>
                <th width="75"><cf_get_lang no ='238.Ödeme Aracı'></th>
                <th width="75"><cf_get_lang_main no='467.İşlem Tarihi'></th>
                <th><cf_get_lang_main no='108.Kasa'></th>
                <th><cf_get_lang no ='239.Tahsilatı Yapan'></th>
                <th style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                <th width="25"></th>
                <th width="25"></th>
            </tr>
        </thead>
        <tbody>
        <cfscript>
            cash_id_list='';
            employee_id_list='';
        </cfscript>
        <cfif get_voucher_actions.recordcount>
            <cfoutput query="get_voucher_actions">
                <cfif len(PAYROLL_CASH_ID) and not listfind(cash_id_list,PAYROLL_CASH_ID)>
                    <cfset cash_id_list=listappend(cash_id_list,PAYROLL_CASH_ID)>
                </cfif>
                <cfif len(PAYROLL_REV_MEMBER) and not listfind(employee_id_list,PAYROLL_REV_MEMBER)>
                    <cfset employee_id_list=listappend(employee_id_list,PAYROLL_REV_MEMBER)>
                </cfif>
            </cfoutput> 
            <cfif len(cash_id_list)>
                <cfset cash_id_list=listsort(cash_id_list,"numeric","ASC",",")>
                <cfquery name="get_cash" datasource="#dsn2#">
                    SELECT CASH_NAME FROM CASH WHERE CASH_ID IN (#cash_id_list#) ORDER BY CASH_ID
                </cfquery>
            </cfif>
            <cfif len(employee_id_list)>
                <cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
                <cfquery name="get_employee" datasource="#dsn#">
                    SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
                </cfquery>
            </cfif>
            <cfoutput query="get_voucher_actions"> 
                <tr> 
                    <td>#get_voucher_actions.currentrow#&nbsp;</td>
                    <td>
                        <a href="javascript://" onclick="sayfa_getir(#currentrow#,#action_id#)" class="tableyazi" title="<cf_get_lang no ='242.Ödenen Senetler'>">
                            #get_voucher_actions.PAYROLL_NO#
                        </a>
                    </td>
                    <td>#get_process_name(PAYROLL_TYPE)#</td>
                    <td>
                        <cfif action_type_id eq 31>
                            <cf_get_lang_main no='1233.Nakit'>
                        <cfelseif action_type_id eq 24>
                            <cf_get_lang_main no ='109.Banka'>
                        <cfelse>
                            <cf_get_lang_main no='787.Kredi Kartı'>
                        </cfif>
                    </td>
                    <td>#dateformat(get_voucher_actions.PAYROLL_REVENUE_DATE,dateformat_style)#&nbsp;</td>
                    <td>
                        <cfif action_type_id eq 31 and len(PAYROLL_CASH_ID)>
                            #get_cash.CASH_NAME[listfind(cash_id_list,PAYROLL_CASH_ID,',')]#
                        </cfif>
                    </td>
                    <td>
                        <cfif len(PAYROLL_REV_MEMBER)>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#payroll_rev_member#','medium');" class="tableyazi">
                                #get_employee.employee_name[listfind(employee_id_list,PAYROLL_REV_MEMBER,',')]# #get_employee.employee_surname[listfind(employee_id_list,PAYROLL_REV_MEMBER,',')]#
                            </a>
                        </cfif>
                    </td>
                    <td  style="text-align:right;">#TLFormat(get_voucher_actions.PAYROLL_TOTAL_VALUE)# #get_voucher_actions.CURRENCY_ID# 
                    <input type="hidden" name="temp_currency_id" id="temp_currency_id" value="#get_voucher_actions.CURRENCY_ID#">
                    </td>
                    <td align="center">
                        <cfif not listfindnocase(denied_pages,'cheque.emptypopup_add_payroll_cancel')>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_upd_voucher_revenue&payroll_id=#action_id#&head=#payroll_no#&payroll_type=#payroll_type#','small');"><img src="/images/refusal.gif" border="0" alt="<cf_get_lang no ='240.Tahsilat İptal'>" title="<cf_get_lang no ='240.Tahsilat İptal'>"></a>
                        </cfif>
                    </td>
                    <td align="center">
                        <cfif action_type_id eq 31 or action_type_id eq 241 or action_type_id eq 24>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=133&action_id=#act_id#','print_page')"><img src="/images/print2.gif" alt="<cf_get_lang_main no='62.Yazdır'>" title="<cf_get_lang_main no='62.Yazdır'>" border="0"></a>
                        </cfif>
                    </td>
                </tr>
                <tr style="display:none;" id="voucher_info#currentrow#">
                    <td colspan="10">
                        <div id="show_voucher_info#currentrow#" style="outset cccccc;"></div>
                    </td>
                </tr>
            </cfoutput> 
        <cfelse>
            <tr><td colspan="10"><cf_get_lang_main no ='72.Kayıt Yok'> !</td></tr>
        </cfif>
       </tbody>
    </cf_grid_list>
</cf_box>
<script type="text/javascript">
	function sayfa_getir(no,action_id)
	{
		gizle_goster(eval('document.all.voucher_info'+no));
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=#fusebox.circuit#</cfoutput>.emptypopup_display_pay_vouchers&action_id='+action_id,'show_voucher_info'+no);
	}
</script>  

