<cf_get_lang_set module_name="finance">
<cf_xml_page_edit fuseact="finance.add_payment_actions">
<cfset module_name = 'finance'>
<cfset module_name2 = 'cost'>
<cfset module_name3 = 'objects'>
<cfset module = 23>
<cfparam name="attributes.action_type" default="">
<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfquery name="GET_ROWS" datasource="#DSN2#">
	SELECT * FROM CARI_CLOSED_ROW WHERE CLOSED_ID = #attributes.closed_id#
</cfquery>
<cfif attributes.act_type contains ','>
    <cfset attributes.act_type = listfirst(attributes.act_type)>
</cfif>
<cfinclude template="../../objects/query/get_acc_types.cfm">
<cfquery name="GET_INVOICE_CLOSE" datasource="#DSN2#">
	SELECT
		<cfif attributes.act_type eq 1><!--- Kapama İşlemi İse --->
			DEBT_AMOUNT_VALUE,
			CLAIM_AMOUNT_VALUE,
			DIFFERENCE_AMOUNT_VALUE,
		<cfelseif attributes.act_type eq 2><!--- Ödeme talebi İse --->
			PAYMENT_DEBT_AMOUNT_VALUE DEBT_AMOUNT_VALUE,
			PAYMENT_CLAIM_AMOUNT_VALUE CLAIM_AMOUNT_VALUE,
			PAYMENT_DIFF_AMOUNT_VALUE DIFFERENCE_AMOUNT_VALUE,
		<cfelseif attributes.act_type eq 3><!--- Ödeme emri İse --->
			P_ORDER_DEBT_AMOUNT_VALUE DEBT_AMOUNT_VALUE,
			P_ORDER_CLAIM_AMOUNT_VALUE CLAIM_AMOUNT_VALUE,
			P_ORDER_DIFF_AMOUNT_VALUE DIFFERENCE_AMOUNT_VALUE,
		</cfif>
		PROJECT_ID,
        ORDER_ID,
		COMPANY_ID,
		CONSUMER_ID,
		EMPLOYEE_ID,
		CLOSED_ID,
		PAPER_DUE_DATE,
		OTHER_MONEY,
		PAYMETHOD_ID,
		PAPER_ACTION_DATE,
		PROCESS_STAGE,
		ACTION_DETAIL,
        ADDITIONAL_DETAIL,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_DATE,
		UPDATE_EMP,
		ACC_TYPE_ID,
        PROCESS_CAT,
        CONTRACT_ID      <!--- Sözleşme ID --->
	FROM
		CARI_CLOSED
	WHERE
        CLOSED_ID = #attributes.closed_id#
       <cfif len(hr_type_list) or len(ehesap_type_list) or len(other_type_list)><!--- İk veya ehesap süper kullanıcı yetkisine bakılacak tip varsa --->
            AND #control_acc_type_list#
        </cfif>
    <cfif (listfind(attributes.fuseaction,'correspondence','.') and not isDefined("attributes.mail_control")) or (isDefined("attributes.correspondence_info") and len(attributes.correspondence_info))>
        AND ( RECORD_EMP = #session.ep.userid#<!--- yazışmalardan girilen kayıtlarda, başkalarının kayıtları görülmesn diye.. --->
                OR <!--- yada sürecinde yetkili olduğu kayıtları görebilsin --->
                EXISTS (SELECT PAGE_WARNINGS.POSITION_CODE FROM #dsn_alias#.PAGE_WARNINGS
                        WHERE ACTION_TABLE = 'CARI_CLOSED' AND ACTION_ID = #attributes.closed_id# AND PAGE_WARNINGS.POSITION_CODE = #session.ep.position_code#
                       )
            )
    </cfif>
</cfquery>
<cfif not (GET_INVOICE_CLOSE.recordcount) or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
	<!--- attributes.active_company Kaldirilmasin surec linklerinden geldiginde sorun olusuyor FBS 20100504 --->
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'><cf_get_lang dictionary_id='57998.Veya'><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfquery name="get_closed_" datasource="#dsn2#">
		SELECT
			ACTION_ID,
			CLOSED_ID,
			P_ORDER_VALUE,
			CLOSED_AMOUNT,
			RELATED_CLOSED_ROW_ID
		FROM 
			CARI_CLOSED_ROW
		WHERE
			CLOSED_ID = #attributes.closed_id#
	</cfquery>
	<cfif attributes.act_type eq 2>
		<cfquery name="get_order_actions" dbtype="query">
			SELECT CLOSED_ID FROM get_closed_ WHERE P_ORDER_VALUE IS NOT NULL
		</cfquery>	
	<cfelseif attributes.act_type eq 3>	
		<cfquery name="get_order_actions" dbtype="query">
			SELECT CLOSED_ID FROM get_closed_ WHERE RELATED_CLOSED_ROW_ID IS NOT NULL
		</cfquery>	
		<cfquery name="get_order_actions_2" dbtype="query">
			SELECT RELATED_CLOSED_ROW_ID FROM get_closed_ WHERE RELATED_CLOSED_ROW_ID IS NOT NULL
		</cfquery>
		<cfset related_row_ids = valuelist(get_order_actions_2.RELATED_CLOSED_ROW_ID)>
	<cfelse>
		<cfset get_order_actions.recordcount = 0>
	</cfif>
	<cfinclude template="../query/get_payment_actions_detail.cfm">
<cfform name="add_payment_actions2" id="add_payment_actions2" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_payment_actions">
	<input type="hidden" name="closed_id" id="closed_id" value="<cfoutput>#attributes.closed_id#</cfoutput>">
    <cfif isdefined("attributes.extra_type_info")>
        <input type="hidden" name="extra_type_info" id="extra_type_info" value="<cfoutput>#attributes.extra_type_info#</cfoutput>">
    <cfelse>
        <input type="hidden" name="extra_type_info" id="extra_type_info" value="">
    </cfif>
	<input type="hidden" name="act_type" id="act_type" value="<cfoutput>#attributes.act_type#</cfoutput>">
	<input type="hidden" name="all_records" id="all_records" value="<cfoutput>#get_cari_closed_row_1.recordcount+get_cari_closed_row_2.recordcount#</cfoutput>">
	<input type="hidden" name="order_row_id_info" id="order_row_id_info" value="">
    <input type="hidden" name="company_id" id="company_id" value="1">
	<cfif get_closed_.action_id eq 0><input type="hidden" name="correspondence_info" id="correspondence_info" value=""></cfif>
	<cfif isdefined("attributes.mail_control")><input type="hidden" name="mail_control" id="mail_control" value="1"></cfif><!--- Silmeyin urlden gelen verinin kaybolmamasi icin konuldu FBS 20090526 --->    
    
    <cfscript>
		if(len(GET_INVOICE_CLOSE.company_id))
			title = "#get_par_info(GET_INVOICE_CLOSE.company_id,1,1,0)#";
		else if(len(GET_INVOICE_CLOSE.consumer_id))
			title= "#get_cons_info(GET_INVOICE_CLOSE.consumer_id,0,0)#";
		else if(len(GET_INVOICE_CLOSE.employee_id) and isdefined('attributes.acc_type_id'))
            title = "#get_emp_info(GET_INVOICE_CLOSE.employee_id,0,0,0,attributes.acc_type_id)#";
		else if (len(GET_INVOICE_CLOSE.employee_id))
            title = "#get_emp_info(GET_INVOICE_CLOSE.employee_id,0,0,0)#";
		else
            title = "#getlang('main',2403)# : #attributes.closed_id#";
	</cfscript>
    <cfset pageHead = "#getlang('main',2403)# : #attributes.closed_id#">
    <cf_catalystHeader>
    <cf_box title="#title#" closable="0">
        <cf_grid_list>
            <thead>
                <cfoutput>
                    <tr>
                        <th width="20" rowspan="2"></th>
                        <th width="60" rowspan="2"><cf_get_lang dictionary_id='57880.Belge No'></th>			
                        <th width="20%"rowspan="2" nowrap="nowrap"><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
                        <th width="60" rowspan="2"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></th>
                        <th width="40" rowspan="2"><cf_get_lang dictionary_id='57640.Vade'></th>
                        <th width="60" rowspan="2"><cf_get_lang dictionary_id ='57881.Vade Tarihi'></th>
                        <th width="170" align="center" colspan="2"><cf_get_lang dictionary_id='58923.Belge Tutarı'></th>
                        <th width="170" align="center" colspan="2"><cf_get_lang dictionary_id ='54451.Kapanmış Tutar'></th>
                        <cfif attributes.act_type eq 3>
                        <th width="170" align="center" colspan="2"><cf_get_lang dictionary_id ='57527.Talepler'></th>
                        </cfif>
                        <cfif attributes.act_type eq 2>
                        <th width="170" align="center" colspan="2"><cf_get_lang dictionary_id ='57123.Emirler'></th>
                        </cfif>
                        <th width="210" align="center" colspan="3"><cfif attributes.act_type eq 1><cf_get_lang dictionary_id ='54411.Kapama'> <cfelseif attributes.act_type eq 2><cf_get_lang dictionary_id ='54403.Talep'><cfelseif attributes.act_type eq 3><cf_get_lang dictionary_id ='57123.Emir'></cfif></th>
                    </tr>
                    <tr>
                        <th width="85" class="text-right">#session.ep.money# <cf_get_lang dictionary_id='57673.Tutar'></th>
                        <th width="85" class="text-right"><cf_get_lang dictionary_id ='54948.İşlem Tutar'></th>
                    
                        <th width="85" class="text-right">#session.ep.money# <cf_get_lang dictionary_id='57673.Tutar'></th>
                        <th width="85" class="text-right"><cf_get_lang dictionary_id ='54948.İşlem Tutar'></th>
                        <cfif attributes.act_type eq 2>
                        <th width="85" class="text-right">#session.ep.money# <cf_get_lang dictionary_id='57673.Tutar'></th>
                        <th width="85" class="text-right"><cf_get_lang dictionary_id ='54948.İşlem Tutar'></th>
                        </cfif>
                        <cfif attributes.act_type eq 3>
                        <th width="85" class="text-right">#session.ep.money# <cf_get_lang dictionary_id='57673.Tutar'></th>
                        <th width="85" class="text-right"><cf_get_lang dictionary_id ='54948.İşlem Tutar'></th>
                        </cfif>
                        <th width="85" class="text-right">#session.ep.money# <cf_get_lang dictionary_id='57673.Tutar'></th>
                        <th width="85" class="text-right"><cf_get_lang dictionary_id ='54948.İşlem Tutar'></th>
                        <th width="40"></th>
                    </tr>
                </cfoutput>
            </thead>
            <tbody>
                <cfoutput query="get_cari_closed_row_1">
                    <cfquery name="GET_ALL_ACTION" datasource="#dsn2#">
                        SELECT 
                            ACTION_ID,
                            RELATED_CLOSED_ROW_ID,
                            SUM(ISNULL(CLOSED_AMOUNT,0)) ALL_CLOSED_AMOUNT,
                            SUM(ISNULL(P_ORDER_VALUE,0)) ALL_ORDER_AMOUNT,
                            SUM(CLOSED_AMOUNT) CLOSED_AMOUNT,
                            SUM(OTHER_CLOSED_AMOUNT) OTHER_CLOSED_AMOUNT,
                            SUM(PAYMENT_VALUE) PAYMENT_VALUE,
                            SUM(OTHER_PAYMENT_VALUE) OTHER_PAYMENT_VALUE,
                            SUM(ISNULL(P_ORDER_VALUE,0)) P_ORDER_VALUE,
                            SUM(ISNULL(OTHER_P_ORDER_VALUE,0)) OTHER_P_ORDER_VALUE
                        FROM 
                            CARI_CLOSED_ROW
                        WHERE
                            ACTION_ID = #ACTION_ID# AND
                            ACTION_TYPE_ID = #ACTION_TYPE_ID# AND
                            <cfif ACTION_TABLE is 'INVOICE' OR ACTION_TABLE is 'EXPENSE_ITEM_PLANS'>
                                DUE_DATE = #CreateODBCDateTime(DUE_DATE)# AND
                            <cfelse>
                                CARI_ACTION_ID = #CARI_ACTION_ID# AND
                            </cfif>
                            OTHER_MONEY = '#OTHER_MONEY#' AND
                            CLOSED_ROW_ID = #CLOSED_ROW_ID#
                        GROUP BY
                            ACTION_ID,
                            RELATED_CLOSED_ROW_ID
                    </cfquery>
                    <cfquery name="GET_ALL_ACTION2" datasource="#dsn2#">
                        SELECT 
                            ACTION_ID,
                            RELATED_CLOSED_ROW_ID,
                            SUM(ISNULL(CLOSED_AMOUNT,0)) ALL_CLOSED_AMOUNT,
                            SUM(ISNULL(P_ORDER_VALUE,0)) ALL_ORDER_AMOUNT,
                            SUM(CLOSED_AMOUNT) CLOSED_AMOUNT,
                            SUM(OTHER_CLOSED_AMOUNT) OTHER_CLOSED_AMOUNT,
                            SUM(PAYMENT_VALUE) PAYMENT_VALUE,
                            SUM(OTHER_PAYMENT_VALUE) OTHER_PAYMENT_VALUE,
                            SUM(ISNULL(P_ORDER_VALUE,0)) P_ORDER_VALUE,
                            SUM(ISNULL(OTHER_P_ORDER_VALUE,0)) OTHER_P_ORDER_VALUE
                        FROM 
                            CARI_CLOSED_ROW
                        WHERE
                            ACTION_ID = #ACTION_ID# AND
                            ACTION_TYPE_ID = #ACTION_TYPE_ID# AND
                            <cfif ACTION_TABLE is 'INVOICE' OR ACTION_TABLE is 'EXPENSE_ITEM_PLANS'>
                                DUE_DATE = #CreateODBCDateTime(DUE_DATE)# AND
                            <cfelse>
                                CARI_ACTION_ID = #CARI_ACTION_ID# AND
                            </cfif>
                            OTHER_MONEY = '#OTHER_MONEY#'
                        GROUP BY
                            ACTION_ID,
                            RELATED_CLOSED_ROW_ID
                    </cfquery>
                    <cfif (len(from_cmp_id) and len(get_invoice_close.company_id) and from_cmp_id eq get_invoice_close.company_id) or (len(from_consumer_id) and len(get_invoice_close.consumer_id) and from_consumer_id eq get_invoice_close.consumer_id) or (len(from_employee_id) and len(get_invoice_close.employee_id) and from_employee_id eq get_invoice_close.employee_id)>
                        <tr>
                            <td>
                                <input type="hidden" name="kontrol_#currentrow#" id="kontrol_#currentrow#" value="1">
                                <input type="hidden" name="closed_row_id_#currentrow#" id="closed_row_id_#currentrow#" value="#closed_row_id#">
                                <input type="hidden" name="type_#currentrow#" id="type_#currentrow#" value="0">
                                <input type="hidden" name="action_id_#currentrow#" id="action_id_#currentrow#" value="#action_id#">
                                <input type="hidden" name="cari_action_id_#currentrow#" id="cari_action_id_#currentrow#" value="#cari_action_id#">
                                <input type="hidden" name="paper_no_#currentrow#" id="paper_no_#currentrow#" value="#paper_no#">
                                <input type="hidden" name="due_date_#currentrow#" id="due_date_#currentrow#" value="#dateformat(due_date,dateformat_style)#">
                                <input type="hidden" name="action_type_id_#currentrow#" id="action_type_id_#currentrow#" value="#action_type_id#">
                                <input type="hidden" name="action_value_#currentrow#" id="action_value_#currentrow#" value="#tlformat(cr_action_value)#">
                                <input type="hidden" name="p_order_value_#currentrow#" id="p_order_value_#currentrow#" value="#tlformat(GET_ALL_ACTION2.P_ORDER_VALUE)#">
                                <input type="hidden" name="rate2_#currentrow#" id="rate2_#currentrow#" value="<cfif len(other_cash_act_value) and other_cash_act_value gt 0>#wrk_round(CR_ACTION_VALUE/other_cash_act_value,session.ep.our_company_info.rate_round_num)#</cfif>">
                                <input type="hidden" name="other_money_#currentrow#" id="other_money_#currentrow#" value="#other_money#">
                                <input type="checkbox" name="is_closed_#currentrow#" id="is_closed_#currentrow#" value="" checked onClick="check_kontrol(this);total_amount();" <cfif (attributes.act_type eq 2 and len(GET_ALL_ACTION.ALL_ORDER_AMOUNT) and GET_ALL_ACTION.ALL_ORDER_AMOUNT gt 0) or (attributes.act_type eq 3 and (len(GET_ALL_ACTION.RELATED_CLOSED_ROW_ID)) or (isdefined("related_row_ids") and len(related_row_ids) and listfind(related_row_ids,closed_row_id,',')))>disabled</cfif>> 
                            </td>
                            <td>
                                <cfset type="">
                                <cfswitch expression = "#ACTION_TYPE_ID#">
                                    <cfcase value="24"><cfset type="objects.popup_dsp_gelenh"></cfcase>
                                    <cfcase value="25"><cfset type="objects.popup_dsp_gidenh"></cfcase>
                                    <cfcase value="26,27"><cfset type="ch.popup_check_preview"></cfcase>
                                    <cfcase value="31"><cfset type="objects.popup_dsp_cash_revenue"></cfcase><!---tahsilat--->
                                    <cfcase value="32"><cfset type="objects.popup_dsp_cash_payment"></cfcase><!---odeme--->
                                    <cfcase value="40"><cfset type="ch.popup_dsp_account_open"></cfcase>
                                    <cfcase value="43"><cfset type="objects.popup_cari_action"></cfcase>
                                    <cfcase value="41,42,45,46"><cfset type="ch.popup_print_upd_debit_claim_note"></cfcase>
                                    <cfcase value="90"><cfset type="objects.popup_dsp_payroll_entry"></cfcase>
                                    <cfcase value="106"><cfset type="objects.popup_dsp_payroll_entry"></cfcase>
                                    <cfcase value="91"><cfset type="objects.popup_dsp_payroll_endorsement"></cfcase>
                                    <cfcase value="94"><cfset type="objects.popup_dsp_payroll_endor_return"></cfcase>
                                    <cfcase value="95"><cfset type="objects.popup_dsp_payroll_entry_return"></cfcase>
                                    <cfcase value="97"><cfset type="objects.popup_dsp_voucher_payroll_action"></cfcase>
                                    <cfcase value="98"><cfset type="objects.popup_dsp_voucher_payroll_action"></cfcase>
                                    <cfcase value="101"><cfset type="objects.popup_dsp_voucher_payroll_action"></cfcase>
                                    <cfcase value="108"><cfset type="objects.popup_dsp_voucher_payroll_action"></cfcase>
                                    <cfcase value="131"><cfset type="ch.popup_dsp_collacted_dekont"></cfcase>
                                    <cfcase value="160"><cfset type="objects.popup_detail_budget_plan"></cfcase> 
                                    <cfcase value="241"><cfset type="ch.popup_dsp_credit_card_payment_type"></cfcase>
                                    <cfcase value="242"><cfset type="ch.popup_dsp_credit_card_payment"></cfcase>
                                    <cfcase value="251,260"><cfset type="bank.popup_dsp_assign_order"></cfcase>
                                    <cfcase value="120,121"><cfset type="objects.popup_list_cost_expense"></cfcase><!--- Masraf Fişi, Gelir Fişi --->
                                    <cfcase value="291,292"><cfset type="credit.popup_dsp_credit_payment"></cfcase><!--- Kredi Odeme, Kredi Tahsilat --->
                                    <cfcase value="293,294"><cfset type="credit.popup_dsp_stockbond_purchase"></cfcase><!--- Menkul Kıymet Alımı, Menkul Kıymet Satışı --->
                                    <cfcase value="48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691">
                                        <cfif isdefined("invoice_partner_link")>
                                            <cfset type = invoice_partner_link>
                                        <cfelse>
                                            <cfset type="objects.popup_detail_invoice">
                                        </cfif>
                                    </cfcase>
                                    <cfdefaultcase><cfset type=""></cfdefaultcase>
                                </cfswitch>
                                <cfif listfind('24,25,26,27,31,32,34,35,36,43,241,242,177,250,260,251,131',ACTION_TYPE_ID,',')>
                                    <cfset page_type = 'small'>
                                <cfelse>
                                    <cfset page_type = 'page'>
                                </cfif>
                                <cfif ACTION_TABLE is 'CHEQUE'> 
                                    <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&ID=#action_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','small')">#paper_no#</a>
                                <cfelseif ACTION_TABLE is 'VOUCHER'> 
                                    <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&ID=#action_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','small')">#paper_no#</a>
                                <cfelseif len(type)>
                                    <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#ACTION_ID#','#page_type#');">#paper_no#</a>
                                <cfelse>
                                    #paper_no#
                                </cfif>
                            </td>			
                            <td>#action_name#</td>
                            <td>#dateformat(action_date,dateformat_style)#</td>
                            <td align="center"><cfif len(due_date)>#datediff("d",action_date, due_date)#<cfelse>0</cfif></td>
                            <td><cfif len(due_date)>#dateformat(due_date,dateformat_style)#<cfelse>&nbsp;</cfif></td>
                            <td class="text-right">#TLFormat(CR_ACTION_VALUE)#&nbsp;#session.ep.money#</td>
                            <td class="text-right"><cfif len(other_cash_act_value)>#TLFormat(other_cash_act_value)#&nbsp;#other_money#</cfif></td>
                            <td class="text-right">#TLFormat(get_all_action.CLOSED_AMOUNT)#&nbsp;#session.ep.money#</td>
                            <td class="text-right">#TLFormat(get_all_action.OTHER_CLOSED_AMOUNT)# #I_OTHER_MONEY#</td>
                            <cfif attributes.act_type eq 3>
                                <td class="text-right">#TLFormat(get_all_action.PAYMENT_VALUE)#&nbsp;#session.ep.money#</td>
                                <td class="text-right">#TLFormat(get_all_action.OTHER_PAYMENT_VALUE)# #I_OTHER_MONEY#</td>
                            </cfif>
                            <cfif attributes.act_type eq 2>
                                <td class="text-right">#TLFormat(get_all_action.P_ORDER_VALUE)#&nbsp;#session.ep.money#</td>
                                <td class="text-right">#TLFormat(get_all_action.OTHER_P_ORDER_VALUE)# #I_OTHER_MONEY#</td>
                            </cfif>
                            <td class="text-right">
                                <input type="hidden" name="h_max_closed_amount_#currentrow#" id="h_max_closed_amount_#currentrow#" value="#wrk_round(cr_action_value-get_all_action.all_closed_amount+closed_amount)#">
                                <input type="hidden" name="h_to_closed_amount_#currentrow#" id="h_to_closed_amount_#currentrow#" value="#get_all_action.all_closed_amount#">
                                <input type="hidden" name="h_to_other_closed_amount_#currentrow#" id="h_to_other_closed_amount_#currentrow#" value="#get_all_action.other_closed_amount#">
                                <input type="text" name="to_closed_amount_#currentrow#" id="to_closed_amount_#currentrow#" value="#TLFormat(closed_amount)#" onBlur="convert_to_other_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_other_money(#currentrow#);" class="moneybox" <cfif ((attributes.act_type eq 2 and len(GET_ALL_ACTION.ALL_ORDER_AMOUNT) and GET_ALL_ACTION.ALL_ORDER_AMOUNT gt 0) or (attributes.act_type eq 3 and (len(GET_ALL_ACTION.RELATED_CLOSED_ROW_ID)) or (isdefined("related_row_ids") and len(related_row_ids) and listfind(related_row_ids,closed_row_id,',')))) or get_closed_.action_id eq 0>readonly</cfif>></td>
                            <td class="text-right">			 
                                <input type="text" name="other_closed_amount_#currentrow#" id="other_closed_amount_#currentrow#" value="#tlformat(OTHER_CLOSED_AMOUNT)#" onBlur="convert_to_system_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" <cfif ((attributes.act_type eq 2 and len(GET_ALL_ACTION.ALL_ORDER_AMOUNT) and GET_ALL_ACTION.ALL_ORDER_AMOUNT gt 0) or (attributes.act_type eq 3 and (len(GET_ALL_ACTION.RELATED_CLOSED_ROW_ID)) or (isdefined("related_row_ids") and len(related_row_ids) and listfind(related_row_ids,closed_row_id,',')))) or get_closed_.action_id eq 0>readonly</cfif>>
                            </td>
                            <td class="text-right">#other_money#</td>
                        </tr>
                    <cfelse>
                        <tr class="color-row" height="20">
                            <td>
                                <input type="hidden" name="kontrol_#currentrow#" id="kontrol_#currentrow#" value="1">
                                <input type="hidden" name="type_#currentrow#"  id="type_#currentrow#"value="1">
                                <input type="hidden" name="action_id_#currentrow#" id="action_id_#currentrow#" value="#action_id#">
                                <input type="hidden" name="cari_action_id_#currentrow#" id="cari_action_id_#currentrow#" value="#cari_action_id#">
                                <input type="hidden" name="paper_no_#currentrow#" id="paper_no_#currentrow#" value="#paper_no#">
                                <input type="hidden" name="action_type_id_#currentrow#" id="action_type_id_#currentrow#" value="#action_type_id#">
                                <input type="hidden" name="due_date_#currentrow#" id="due_date_#currentrow#" value="#dateformat(due_date,dateformat_style)#">
                                <input type="hidden" name="closed_row_id_#currentrow#" id="closed_row_id_#currentrow#" value="#closed_row_id#">
                                <input type="hidden" name="action_value_#currentrow#" id="action_value_#currentrow#" value="#tlformat(cr_action_value)#">
                                <input type="hidden" name="p_order_value_#currentrow#" id="p_order_value_#currentrow#" value="#tlformat(GET_ALL_ACTION2.P_ORDER_VALUE)#">
                                <input type="hidden" name="rate2_#currentrow#" id="rate2_#currentrow#" value="<cfif len(other_cash_act_value) and other_cash_act_value gt 0>#wrk_round(CR_ACTION_VALUE/other_cash_act_value,session.ep.our_company_info.rate_round_num)#</cfif>">
                                <input type="hidden" name="other_money_#currentrow#" id="other_money_#currentrow#" value="#other_money#">
                                <input type="checkbox" name="is_closed_#currentrow#" id="is_closed_#currentrow#" value="" checked onClick="check_kontrol(this);total_amount();" <cfif (attributes.act_type eq 2 and len(GET_ALL_ACTION.ALL_ORDER_AMOUNT) and GET_ALL_ACTION.ALL_ORDER_AMOUNT gt 0) or (attributes.act_type eq 3 and (len(GET_ALL_ACTION.RELATED_CLOSED_ROW_ID)) or (isdefined("related_row_ids") and len(related_row_ids) and listfind(related_row_ids,closed_row_id,',')))>disabled</cfif>> 
                            </td>
                            <td>
                                <cfset type="">
                                <cfswitch expression = "#ACTION_TYPE_ID#">
                                    <cfcase value="24"><cfset type="objects.popup_dsp_gelenh"></cfcase>
                                    <cfcase value="25"><cfset type="objects.popup_dsp_gidenh"></cfcase>
                                    <cfcase value="26,27"><cfset type="ch.popup_check_preview"></cfcase>
                                    <cfcase value="31"><cfset type="objects.popup_dsp_cash_revenue"></cfcase><!---tahsilat--->
                                    <cfcase value="32"><cfset type="objects.popup_dsp_cash_payment"></cfcase><!---odeme--->
                                    <cfcase value="40"><cfset type="ch.popup_dsp_account_open"></cfcase>
                                    <cfcase value="43"><cfset type="objects.popup_cari_action"></cfcase>
                                    <cfcase value="41,42,45,46"><cfset type="ch.popup_print_upd_debit_claim_note"></cfcase>
                                    <cfcase value="90"><cfset type="objects.popup_dsp_payroll_entry"></cfcase>
                                    <cfcase value="106"><cfset type="objects.popup_dsp_payroll_entry"></cfcase>
                                    <cfcase value="91"><cfset type="objects.popup_dsp_payroll_endorsement"></cfcase>
                                    <cfcase value="94"><cfset type="#module_name3#.popup_dsp_payroll_endor_return"></cfcase>
                                    <cfcase value="95"><cfset type="#module_name3#.popup_dsp_payroll_entry_return"></cfcase>
                                    <cfcase value="97"><cfset type="#module_name3#.popup_dsp_voucher_payroll_action"></cfcase>
                                    <cfcase value="98"><cfset type="#module_name3#.popup_dsp_voucher_payroll_action"></cfcase>
                                    <cfcase value="101"><cfset type="#module_name3#.popup_dsp_voucher_payroll_action"></cfcase>
                                    <cfcase value="108"><cfset type="#module_name3#.popup_dsp_voucher_payroll_action"></cfcase>
                                    <cfcase value="131"><cfset type="ch.popup_dsp_collacted_dekont"></cfcase>
                                    <cfcase value="160"><cfset type="objects.popup_detail_budget_plan"></cfcase> 
                                    <cfcase value="241"><cfset type="ch.popup_dsp_credit_card_payment_type"></cfcase>
                                    <cfcase value="242"><cfset type="ch.popup_dsp_credit_card_payment"></cfcase>
                                    <cfcase value="251,260"><cfset type="bank.popup_dsp_assign_order"></cfcase>
                                    <cfcase value="120,121"><cfset type="#module_name2#.popup_list_cost_expense"></cfcase><!--- Masraf Fişi, Gelir Fişi --->
                                    <cfcase value="291,292"><cfset type="credit.popup_dsp_credit_payment"></cfcase><!--- Kredi Odeme, Kredi Tahsilat --->
                                    <cfcase value="293,294"><cfset type="credit.popup_dsp_stockbond_purchase"></cfcase><!--- Menkul Kıymet Alımı, Menkul Kıymet Satışı --->
                                    <cfcase value="48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,591,531,561,592,68,601,690,691">
                                        <cfif isdefined("invoice_partner_link")>
                                            <cfset type = invoice_partner_link>
                                        <cfelse>
                                            <cfset type="objects.popup_detail_invoice">
                                        </cfif>
                                    </cfcase>
                                    <cfdefaultcase><cfset type=""></cfdefaultcase>
                                </cfswitch>
                                <cfif listfind('24,25,26,27,31,32,34,35,36,43,241,242,177,250,260,251,131',ACTION_TYPE_ID,',')>
                                    <cfset page_type = 'small'>
                                <cfelse>
                                    <cfset page_type = 'page'>
                                </cfif>
                                <cfif ACTION_TABLE is 'CHEQUE'> 
                                    <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_cheque_det&ID=#action_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','small')"><font color="red">#paper_no#</font></a>
                                <cfelseif ACTION_TABLE is 'VOUCHER'> 
                                    <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_voucher_det&ID=#action_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','small')"><font color="red">#paper_no#</font></a>
                                <cfelseif len(type)>
                                    <a class="tableyazi" href="javascript://" onclick="windowopen('#request.self#?fuseaction=#type#&id=#ACTION_ID#','#page_type#');"><font color="red">#paper_no#</font></a>
                                <cfelse>
                                    <font color="red">#paper_no#</font>
                                </cfif>
                            </td>
                            <td><font color="red">#action_name#</font></td>
                            <td><font color="red">#dateformat(action_date,dateformat_style)#</font></td>
                            <td align="center"><font color="red"><cfif len(due_date)>#datediff("d",action_date, due_date)#<cfelse>0</cfif></font></td>
                            <td><cfif len(due_date)><font color="red">#dateformat(due_date,dateformat_style)#</font><cfelse>&nbsp;</cfif></td>
                            <td class="text-right"><font color="red">#TLFormat(CR_ACTION_VALUE)#&nbsp;#session.ep.money#</font></td>		
                            <td class="text-right"><font color="red"><cfif len(other_cash_act_value)>#TLFormat(other_cash_act_value)#&nbsp;#other_money#</cfif></font></td>
                            <td class="text-right"><font color="red">#TLFormat(get_all_action.CLOSED_AMOUNT)#&nbsp;#session.ep.money#</font></td>
                            <td class="text-right"><font color="red">#TLFormat(get_all_action.OTHER_CLOSED_AMOUNT)# #I_OTHER_MONEY#</font></td>
                            <cfif attributes.act_type eq 3>
                                <td class="text-right"><font color="red">#TLFormat(get_all_action.PAYMENT_VALUE)#&nbsp;#session.ep.money#</font></td>
                                <td class="text-right"><font color="red">#TLFormat(get_all_action.OTHER_PAYMENT_VALUE)# #I_OTHER_MONEY#</font></td>
                            </cfif>
                            <cfif attributes.act_type eq 2>
                                <td class="text-right"><font color="red">#TLFormat(get_all_action.P_ORDER_VALUE)#&nbsp;#session.ep.money#</font></td>
                                <td class="text-right"><font color="red">#TLFormat(get_all_action.OTHER_P_ORDER_VALUE)# #I_OTHER_MONEY#</font></td>
                            </cfif>
                            <td class="text-right">
                                <input type="hidden" name="h_max_closed_amount_#currentrow#" id="h_max_closed_amount_#currentrow#" value="#wrk_round(cr_action_value-get_all_action.all_closed_amount+closed_amount)#">
                                <input type="hidden" name="h_to_closed_amount_#currentrow#" id="h_to_closed_amount_#currentrow#" value="#get_all_action.all_closed_amount#">
                                <input type="hidden" name="h_to_other_closed_amount_#currentrow#" id="h_to_other_closed_amount_#currentrow#" value="#get_all_action.other_closed_amount#">
                                <input type="text" name="to_closed_amount_#currentrow#" id="to_closed_amount_#currentrow#" value="#TLFormat(closed_amount)#" onBlur="convert_to_other_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_other_money(#currentrow#);" class="moneybox" <cfif ((attributes.act_type eq 2 and len(GET_ALL_ACTION.ALL_ORDER_AMOUNT) and GET_ALL_ACTION.ALL_ORDER_AMOUNT gt 0) or (attributes.act_type eq 3 and (len(GET_ALL_ACTION.RELATED_CLOSED_ROW_ID)) or (isdefined("related_row_ids") and len(related_row_ids) and listfind(related_row_ids,closed_row_id,',')))) or get_closed_.action_id eq 0>readonly</cfif>></td> 
                            <td class="text-right">			 
                                <input type="text" name="other_closed_amount_#currentrow#" id="other_closed_amount_#currentrow#" value="#tlformat(OTHER_CLOSED_AMOUNT)#" onBlur="convert_to_system_money(#currentrow#);total_amount();" onkeyup="return(FormatCurrency(this,event));convert_to_system_money(#currentrow#);" class="moneybox" <cfif ((attributes.act_type eq 2 and len(GET_ALL_ACTION.ALL_ORDER_AMOUNT) and GET_ALL_ACTION.ALL_ORDER_AMOUNT gt 0) or (attributes.act_type eq 3 and (len(GET_ALL_ACTION.RELATED_CLOSED_ROW_ID)) or (isdefined("related_row_ids") and len(related_row_ids) and listfind(related_row_ids,closed_row_id,',')))) or get_closed_.action_id eq 0>readonly</cfif>>
                            </td>
                            <td class="text-right">#other_money#</td>
                        </tr>
                    </cfif>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
    <cf_box title="#getLang('','Açık Hareketler',50097)#" closable="0">   
	<cfif attributes.act_type eq 1>
		<cfinclude template="../display/dsp_payment_open_actions.cfm">
    </cfif>
    </cf_box>
    <cfsavecontent variable="title">
        <cfoutput>
            <cfif attributes.act_type eq 1>#getLang('finance',25)#<cfelseif attributes.act_type eq 2>#getLang('finance',17)#<cfelseif attributes.act_type eq 3>#getLang('finance',24)#</cfif>
        </cfoutput>
    </cfsavecontent>
    <cf_box title="#title#">
        <cfoutput>
            <cf_box_elements id="seperator_2">
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <cfif attributes.act_type eq 2 and xml_show_process_stage eq 1>
                        <div class="form-group" id="item_process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.işlem tipi'></label>
                            <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat select_value='#get_invoice_close.PROCESS_CAT#' slct_width="135">
                            </div>
                        </div>
                    </cfif> 
                    <cfif get_closed_.action_id neq 0>
                        <div class="form-group" id="item-total_debt_amount">
                            <label class="col col-4 col-xs-12">#getLang('finance',69)#</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="total_debt_amount" id="total_debt_amount" value="#TLFormat(get_invoice_close.debt_amount_value)#" class="moneybox" readonly>
                                    <span class="input-group-addon bold">#get_invoice_close.other_money#</span>
                                </div>
                            </div>
                        </div>
                    <cfelse>
                        <div class="form-group" id="item-total_difference_amount">
                            <label class="col col-4 col-xs-12"><cfif attributes.act_type eq 1>#getLang('finance',25)#<cfelseif attributes.act_type eq 2>#getLang('finance',17)#<cfelseif attributes.act_type eq 3>#getLang('finance',24)#</cfif> #getLang('finance',66)#</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="hidden_total_difference_amount" id="hidden_total_difference_amount" readonly="yes" value="<cfif len(get_invoice_close.difference_amount_value)>#TLFormat(abs(get_invoice_close.difference_amount_value))#<cfelse>#tlFormat(0)#</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
                                    <input type="text" name="total_difference_amount" id="total_difference_amount" value="<cfif len(get_invoice_close.difference_amount_value)>#TLFormat(abs(get_invoice_close.difference_amount_value))#<cfelse>#tlFormat(0)#</cfif>" class="moneybox" onKeyUp="return(FormatCurrency(this,event));">
                                    <span class="input-group-addon">
                                        <select name="money_type" id="money_type">
                                            <cfloop query="get_money_rate">
                                                <option value="#money#" <cfif get_invoice_close.other_money eq get_money_rate.money>selected</cfif>>#money#</option>
                                            </cfloop>
                                        </select>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <cfif get_closed_.action_id neq 0>
                        <input type="hidden" name="money_type" id="money_type" value="#get_invoice_close.other_money#">
                        <div class="form-group" id="item-total_claim_amount">
                            <label class="col col-4 col-xs-12">#getLang('finance',70)#</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="total_claim_amount" id="total_claim_amount" value="#TLFormat(get_invoice_close.claim_amount_value)#" class="moneybox" readonly> 
                                    <span class="input-group-addon bold">#get_invoice_close.other_money#</span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <cfif get_closed_.action_id neq 0>
                        <div class="form-group" id="item-total_difference_amount">
                            <label class="col col-4 col-xs-12"><cfif attributes.act_type eq 1>#getLang('finance',25)#<cfelseif attributes.act_type eq 2>#getLang('finance',17)#<cfelseif attributes.act_type eq 3>#getLang('finance',24)#</cfif> #getLang('finance',66)#</label>
                            <div class="col col-8 col-xs-12">
                                <input type="hidden" name="hidden_total_difference_amount" id="hidden_total_difference_amount" value="#TLFormat(get_invoice_close.difference_amount_value)#" class="moneybox" readonly>
                                <div class="input-group">
                                    <input type="text" name="total_difference_amount" id="total_difference_amount" value="#TLFormat(get_invoice_close.difference_amount_value)#" class="moneybox" readonly>  
                                    <span class="input-group-addon bold">#get_invoice_close.other_money#</span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-payment_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57742.Tarih'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                                <cfinput type="text" name="payment_date" id="payment_date" required="Yes" message="#message#" value="#dateformat(get_invoice_close.PAPER_ACTION_DATE,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="payment_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-due_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57861.Ortalama Vade'></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='54454.Vade Tarihi Girmelisiniz'></cfsavecontent>
                            <div class="input-group">
                                <cfinput type="text" name="due_date" id="due_date" required="Yes" message="#message#" value="#dateformat(get_invoice_close.PAPER_DUE_DATE,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="due_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-paymethod">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif len(get_invoice_close.paymethod_id)>
                                <cfquery name="GET_PAYM" datasource="#dsn#">
                                    SELECT PAYMETHOD,PAYMETHOD_ID FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #get_invoice_close.paymethod_id#
                                </cfquery>
                            </cfif>
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfif len(get_invoice_close.paymethod_id)>#get_invoice_close.paymethod_id#</cfif>">
                            <div class="input-group">
                                <input type="text" name="paymethod" id="paymethod" value="<cfif len(get_invoice_close.paymethod_id)>#GET_PAYM.PAYMETHOD#</cfif>">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="open_pay_window();" title="#getLang('main',322)#"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-process">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                        <div class="col col-9 col-xs-12">
                            <cf_workcube_process is_upd='0' select_value='#get_invoice_close.process_stage#' process_cat_width='160' is_detail='1'>
                        </div>
                    </div>
                    <div class="form-group" id="item-project_head">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-9 col-xs-12">
                        <input type="hidden" name="project_id" id="project_id" value="<cfif len(get_invoice_close.project_id)>#get_invoice_close.project_id#</cfif>">
                            <div class="input-group">
                                <input type="text" name="project_head" id="project_head" value="<cfif len(get_invoice_close.project_id)>#get_project_name(get_invoice_close.project_id)#</cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_payment_actions2.project_id&project_head=add_payment_actions2.project_head');"></span>
                            </div>
                        </div>
                    </div>
                    <cfif attributes.act_type neq 1>
                        <div class="form-group" id="item-contract_id">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29522.Sözlesme'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="contract_id" id="contract_id" value="<cfoutput>#get_invoice_close.contract_id#</cfoutput>">
                                    <cfif len(get_invoice_close.contract_id)>
                                        <cfquery name="get_contract_head" datasource="#dsn3#">
                                            SELECT CONTRACT_ID,CONTRACT_HEAD,COMPANY_ID,CONSUMER_ID FROM RELATED_CONTRACT WHERE CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_close.contract_id#">
                                        </cfquery>
                                    </cfif>
                                    <input type="text" name="contract_head" id="contract_head" value="<cfif len(get_invoice_close.contract_id)><cfoutput>#get_contract_head.contract_head#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=add_payment_actions2.contract_id&field_name=add_payment_actions2.contract_head<cfif isdefined("get_contract_head.COMPANY_ID") and len(get_contract_head.COMPANY_ID)>&member_id=#get_contract_head.COMPANY_ID#<cfelseif isdefined("get_contract_head.CONSUMER_ID") and len(get_contract_head.CONSUMER_ID)>&consumer_id=#get_contract_head.CONSUMER_ID#</cfif>'</cfoutput>);"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <cfif attributes.act_type neq 1>
                        <div class="form-group" id="item-order_id">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57611.sipariş'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">        
                                    <input type="hidden" name="order_id" id="order_id" value="<cfoutput>#get_invoice_close.order_id#</cfoutput>">                    
                                    <cfquery name="GET_ORDER" datasource="#dsn3#">
                                        SELECT ORDER_ID,ORDER_NUMBER,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID FROM ORDERS WHERE ORDER_ID = '#get_invoice_close.order_id#'
                                    </cfquery>
                                    <input type="text" name="related_order_no" id="related_order_no"  value="<cfif len(get_invoice_close.order_id)><cfoutput>#GET_ORDER.ORDER_NUMBER#</cfoutput></cfif>" readonly>  
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_orders_list&field_id=add_payment_actions2.order_id&field_name=add_payment_actions2.related_order_no<cfif isdefined("GET_ORDER.COMPANY_ID") and len(GET_ORDER.COMPANY_ID)>&member_id=#GET_ORDER.COMPANY_ID#<cfelseif isdefined("GET_ORDER.CONSUMER_ID") and len(GET_ORDER.CONSUMER_ID)>&consumer_id=#GET_ORDER.CONSUMER_ID#<cfelseif isdefined("GET_ORDER.EMPLOYEE_ID") and len(GET_ORDER.EMPLOYEE_ID)>&employee_id=#GET_ORDER.EMPLOYEE_ID#</cfif>&is_purchase=1</cfoutput>');"></span>
                                </div>             
                            </div>                
                        </div>  
                    </cfif>
                    <div class="form-group" id="item-action_detail">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='36199.Açıklama'></label>
                        <div class="col col-9 col-xs-12">
                            <textarea name="action_detail" id="action_detail">#get_invoice_close.action_detail#</textarea>
                        </div>
                    </div>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="5" sort="true">
                    <div class="form-group" id="item-more_detail">
                        <div class="col col-12 col-xs-12">
                            <cfmodule
                                template="/fckeditor/fckeditor.cfm"
                                toolbarset="Basic"
                                basepath="/fckeditor/"
                                instancename="additional_subject"
                                value="#get_invoice_close.additional_detail#"
                                valign="top">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>	
                <div class="col col-6">
                    <cf_record_info query_name="get_invoice_close">
                </div>
                <div class="col col-6">
                    <cfif get_order_actions.recordcount>
                        <cfif attributes.act_type eq 1>
                            <cfsavecontent variable="message_kap">#getLang('finance',73)#</cfsavecontent>
                            <cf_workcube_buttons is_upd='0' is_delete='0' is_cancel='0' insert_info='#message_kap#' add_function='kontrol2(1,0)'>
                        </cfif>
                        <cfif attributes.act_type eq 2>
                            <cfif x_update_payment_button eq 1>
                                <cfsavecontent variable="message_talep">#getLang('finance',83)#</cfsavecontent>
                                <cfsavecontent variable="message_guncelle"><cf_get_lang dictionary_id ='54470.Ödeme Emri Güncelle'></cfsavecontent>
                                <cf_workcube_buttons is_upd='1' is_cancel='0' is_delete='0' insert_info='#message_talep#' add_function='kontrol2(2,0)' history_table_list='CARI_CLOSED,CARI_CLOSED_ROW' history_datasource_list='dsn2,dsn2' history_identy='CLOSED_ID' history_action_id='#attributes.closed_id#' is_wrkId='1' history_act_type='#attributes.act_type#'>
                                <cfif not listfind(attributes.fuseaction,'correspondence','.') and x_payment_command_button eq 1>
                                    <cfsavecontent variable="message">#getLang('finance',71)#</cfsavecontent>
                                    <cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' insert_info='#message_guncelle#' add_function='kontrol2(2,3)' history_table_list='CARI_CLOSED,CARI_CLOSED_ROW' history_datasource_list='dsn2,dsn2' history_identy='CLOSED_ID' history_action_id='#attributes.closed_id#' is_wrkId='1' history_act_type='#attributes.act_type#'>
                                </cfif>
                            <cfelse>
                                <font color="red">#getLang('finance',19)#!</font>
                            </cfif>
                        </cfif>
                        <cfif attributes.act_type eq 3 and get_cari_closed_row_1.recordcount neq 1>
                            <cfsavecontent variable="message_guncelle"><cf_get_lang dictionary_id ='54470.Ödeme Emri Güncelle'></cfsavecontent>
                            <cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' insert_info='#message_guncelle#' add_function='kontrol2(3,0)' history_table_list='CARI_CLOSED,CARI_CLOSED_ROW' history_datasource_list='dsn2,dsn2' history_identy='CLOSED_ID' history_action_id='#attributes.closed_id#' is_wrkId='1' history_act_type='#attributes.act_type#'>
                        <cfelseif attributes.act_type eq 3>
                            <font color="FF0000">#getLang('finance',137)# !</font>
                        </cfif>
                    <cfelse>
                        <cfif attributes.act_type eq 1>
                            <cfsavecontent variable="message_kapp"><cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
                            <cf_workcube_buttons is_upd='1' is_cancel='0'  is_delete='1' insert_info='#message_kapp#' add_function='kontrol2(1,0)' delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_payment_actions&closed_id=#attributes.closed_id#&act_type=#attributes.act_type#' history_table_list='CARI_CLOSED,CARI_CLOSED_ROW' history_datasource_list='dsn2,dsn2' history_identy='CLOSED_ID' history_action_id='#attributes.closed_id#' is_wrkId='1' history_act_type='#attributes.act_type#'>
                        </cfif>
                        <cfif attributes.act_type eq 2>
                            <cfsavecontent variable="message_talep">#getLang('finance',83)#</cfsavecontent>
                            <cf_workcube_buttons is_upd='1' is_cancel='0' insert_info='#message_talep#' add_function='kontrol2(2,0)' delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_payment_actions&closed_id=#attributes.closed_id#&act_type=#attributes.act_type#' history_table_list='CARI_CLOSED,CARI_CLOSED_ROW' history_datasource_list='dsn2,dsn2' history_identy='CLOSED_ID' history_action_id='#attributes.closed_id#' is_wrkId='1' history_act_type='#attributes.act_type#'>
                            <cfif not listfind(attributes.fuseaction,'correspondence','.') and x_payment_command_button eq 1>
                                <cfsavecontent variable="message">#getLang('finance',71)#</cfsavecontent>
                                <cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' insert_info='#message#' add_function='kontrol2(2,3)' history_table_list='CARI_CLOSED,CARI_CLOSED_ROW' history_datasource_list='dsn2,dsn2' history_identy='CLOSED_ID' history_action_id='#attributes.closed_id#' is_wrkId='1' history_act_type='#attributes.act_type#'>
                            </cfif>
                        </cfif>
                        <cfif attributes.act_type eq 3>
                            <cfsavecontent variable="message_guncelle">#getLang('finance',84)#</cfsavecontent>
                            <cf_workcube_buttons is_upd='1' is_cancel='0' insert_info='#message_guncelle#' add_function='kontrol2(3,0)' delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_payment_actions&closed_id=#attributes.closed_id#&act_type=#attributes.act_type#' history_table_list='CARI_CLOSED,CARI_CLOSED_ROW' history_datasource_list='dsn2,dsn2' history_identy='CLOSED_ID' history_action_id='#attributes.closed_id#' is_wrkId='1' history_act_type='#attributes.act_type#'>
                        </cfif>
                    </cfif>
                </div>
            </cf_box_footer>
        </cfoutput>
    </cf_box>
</cfform>
<script type="text/javascript">
    $(document).ready(function(){
        control_closed=document.all.control_closed;
        total_amount_check();
        total_amount();
        convert_to_system_money();
    });
	function open_pay_window()
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_payment_actions2.paymethod_id&field_name=add_payment_actions2.paymethod</cfoutput>&paymentdate_value=' + add_payment_actions2.payment_date.value);
	}
	function get_type_search()
	{
		add_payment_actions2.action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_payment_actions&event=upd&closed_id=#attributes.closed_id#&act_type=#attributes.act_type#</cfoutput>';
		add_payment_actions2.submit();
	}
	
	function kontrol2(type_info,extra_type_info)
	{
		if(document.add_payment_actions2.order_row_id_info.value=="") {
			alert('Kapanacak işlem seçiniz!');
			return false;
		}
		<cfif get_closed_.action_id eq 0>
			if(document.add_payment_actions2.total_difference_amount.value=="")
			{
				alert("<cf_get_lang dictionary_id='54619.Tutar Giriniz'>!");
				return false;
			}
		</cfif>
		if(type_info == 1)
		{
			if(control_closed < 2)
			{
				alert("<cf_get_lang dictionary_id ='54438.Fatura Kapama İçin En Az İki İşlem Seçmelisiniz'>!");
				return false;
			}
			total_difference_amount_ = filterNum(add_payment_actions2.total_difference_amount.value);
			if(total_difference_amount_ != 0)
			{
				alert("<cf_get_lang dictionary_id ='54436.Borç ve Alacak Toplamları Eşit Olmalı'>");
				return false;
			}
		}
		<cfif get_closed_.action_id neq 0>
			total_amount();
		</cfif>
		for (var i=1; i <= <cfoutput>#GET_CARI_CLOSED_ROW_1.recordcount+GET_CARI_CLOSED_ROW_2.recordcount#</cfoutput>; i++)
		{
			if(eval('add_payment_actions2.is_closed_'+i).checked && eval('add_payment_actions2.is_closed_'+i).disabled == false)
			{
				<cfif get_closed_.action_id neq 0>
					if(extra_type_info != 3)
					{
						<cfif attributes.act_type eq 2>
							if(wrk_round(parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value)),4)>parseFloat(filterNum(eval('add_payment_actions2.action_value_'+i).value)))
							{
								alert("<cf_get_lang dictionary_id ='54435.Talep Edilen Tutar İşlem Tutarından Fazla Olamaz'> !");
								eval('add_payment_actions2.to_closed_amount_'+i).focus();
								return false;
							}
							if(wrk_round(parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value))+parseFloat(filterNum(eval('add_payment_actions2.p_order_value_'+i).value)),4) > parseFloat(filterNum(eval('add_payment_actions2.action_value_'+i).value)))
							{
								alert("<cf_get_lang dictionary_id ='54435.Talep Edilen Tutar İşlem Tutarından Fazla Olamaz'> !");
								eval('add_payment_actions2.to_closed_amount_'+i).focus();
								return false;
							}
							if(wrk_round(parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value)),4)>parseFloat(filterNum(eval('add_payment_actions2.h_max_closed_amount_'+i).value)))
							{
								alert("<cf_get_lang dictionary_id ='54943.Toplam Talep Belge Tutarını Aşıyor'>");
								eval('add_payment_actions2.to_closed_amount_'+i).focus();
								return false;
							}
						<cfelseif attributes.act_type eq 3>
							if(wrk_round(parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value)),4)>parseFloat(filterNum(eval('add_payment_actions2.action_value_'+i).value)))
							{
								alert("<cf_get_lang dictionary_id ='54432.Emir Verilen Tutar İşlem Tutarından Fazla Olamaz'>!");
								eval('add_payment_actions2.to_closed_amount_'+i).focus();
								return false;
							}
							if(wrk_round(parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value)),4)>parseFloat(filterNum(eval('add_payment_actions2.h_max_closed_amount_'+i).value)))
							{
								alert("<cf_get_lang dictionary_id ='54944.Toplam Emir Belge Tutarını Aşıyor'>");
								eval('add_payment_actions2.to_closed_amount_'+i).focus();
								return false;
							}
						<cfelse>
							if(parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value))>parseFloat(filterNum(eval('add_payment_actions2.h_max_closed_amount_'+i).value)))
							{
								alert("<cf_get_lang dictionary_id ='54431.İşlem Tutarını Kontrol Ediniz'>");
								eval('add_payment_actions2.to_closed_amount_'+i).focus();
								return false;
							}
						</cfif>
					}
					else
					{
						if(parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value))>parseFloat(filterNum(eval('add_payment_actions2.action_value_'+i).value)))
						{
							alert("<cf_get_lang dictionary_id ='54432.Emir Verilen Tutar İşlem Tutarından Fazla Olamaz'>! Belge No:"+eval('add_payment_actions2.paper_no_'+i).value);
							eval('add_payment_actions2.to_closed_amount_'+i).focus();
							return false;
						}
						if(parseFloat(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value))+parseFloat(filterNum(eval('add_payment_actions2.p_order_value_'+i).value)) > parseFloat(filterNum(eval('add_payment_actions2.action_value_'+i).value)))
						{
							alert("<cf_get_lang dictionary_id ='54432.Emir Verilen Tutar İşlem Tutarından Fazla Olamaz'>! Belge No:"+eval('add_payment_actions2.paper_no_'+i).value);
							eval('add_payment_actions2.to_closed_amount_'+i).focus();
							return false;
						}
					}
				</cfif>
			}
		}
        unformat_fields();
        document.getElementById('extra_type_info').value = extra_type_info;
		address_ = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.emptypopup_upd_payment_actions&act_type='+type_info;
        document.add_payment_actions2.action = address_;
        return process_cat_control();
	}
	function unformat_fields()
	{
		for (var i=1; i <= <cfoutput>#GET_CARI_CLOSED_ROW_1.recordcount+GET_CARI_CLOSED_ROW_2.recordcount#</cfoutput>; i++)
		{
			if(document.getElementById('is_closed_' + i).checked)
			{
				document.getElementById('to_closed_amount_' + i).value = filterNum(document.getElementById('to_closed_amount_' + i).value);
                document.getElementById('other_closed_amount_' + i).value= filterNum(document.getElementById('other_closed_amount_' + i).value);
                document.getElementById('is_closed_' + i).disabled = false;
			}
		}
		<cfif get_closed_.action_id neq 0>
			document.add_payment_actions2.total_debt_amount.value = filterNum(document.add_payment_actions2.total_debt_amount.value);
			document.add_payment_actions2.total_claim_amount.value = filterNum(document.add_payment_actions2.total_claim_amount.value);
		</cfif>
		document.add_payment_actions2.total_difference_amount.value = filterNum(document.add_payment_actions2.total_difference_amount.value);
	}

	function check_kontrol(nesne)
	{
		if(nesne.checked)
			control_closed++;
		else
			control_closed--;
	}
	function total_amount()
	{
		var total_debt_amount = 0;
		var total_claim_amount = 0;
		var h_total_debt_amount = 0;
		var h_total_claim_amount = 0;
		var order_row_id_info = "";
		for (var i=1; i <= <cfoutput>#GET_CARI_CLOSED_ROW_1.recordcount+GET_CARI_CLOSED_ROW_2.recordcount#</cfoutput>; i++)
		{		
			if(eval('add_payment_actions2.is_closed_'+i).checked && eval('add_payment_actions2.is_closed_'+i).disabled == false)
			{
				if(order_row_id_info == "")
					order_row_id_info = eval("add_payment_actions2.closed_row_id_" + i).value;
				else
					order_row_id_info = order_row_id_info + ',' + eval("add_payment_actions2.closed_row_id_" + i).value;
				
				if(eval('add_payment_actions2.type_'+i).value == 1)
					h_total_debt_amount += parseFloat(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value));
				else
					h_total_claim_amount += parseFloat(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value));
				
				if(eval('add_payment_actions2.type_'+i).value == 1)
					total_debt_amount += parseFloat(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value));
				else
					total_claim_amount += parseFloat(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value));
			}
			else if(eval('add_payment_actions2.is_closed_'+i).checked)
			{
				if(eval('add_payment_actions2.type_'+i).value == 1)
					total_debt_amount += parseFloat(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value));
				else
					total_claim_amount += parseFloat(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value));
			}			
		}
		document.getElementById('order_row_id_info').value = order_row_id_info;
		<cfif get_closed_.action_id eq 0>
			if(document.add_payment_actions2.total_difference_amount != undefined)
			{
				document.add_payment_actions2.total_difference_amount.value = commaSplit(total_claim_amount-total_debt_amount);
				document.add_payment_actions2.hidden_total_difference_amount.value = commaSplit(h_total_claim_amount-h_total_debt_amount);
			}
		<cfelse>
			if(document.add_payment_actions2.total_debt_amount != undefined)
			{
				document.add_payment_actions2.total_debt_amount.value = commaSplit(total_debt_amount);
				document.add_payment_actions2.total_claim_amount.value = commaSplit(total_claim_amount);
				document.add_payment_actions2.total_difference_amount.value = commaSplit(total_claim_amount-total_debt_amount);
				document.add_payment_actions2.hidden_total_difference_amount.value = commaSplit(h_total_claim_amount-h_total_debt_amount);
			}
		</cfif>
	}
	function convert_to_other_money(i)
	{
		if(eval('add_payment_actions2.is_closed_'+i).checked)	
		{
			rate2_eleman = eval('add_payment_actions2.rate2_'+i).value;
			if(rate2_eleman == '')rate2_eleman = 1;
			eval('add_payment_actions2.other_closed_amount_'+i).value= commaSplit(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value)/rate2_eleman);
			if(filterNum(eval('add_payment_actions2.to_closed_amount_'+i).value) == filterNum(eval('add_payment_actions2.h_to_closed_amount_'+i).value))
				eval('add_payment_actions2.other_closed_amount_'+i).value = commaSplit(filterNum(eval('add_payment_actions2.h_to_other_closed_amount_'+i).value));
		}
	}
	function convert_to_system_money(i)
	{	
		if(i != undefined)
		{
			if(eval('add_payment_actions2.is_closed_'+i).checked)	
			{
				rate2_eleman = eval('add_payment_actions2.rate2_'+i).value;
				eval('add_payment_actions2.to_closed_amount_'+i).value= commaSplit(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value)*rate2_eleman);
				if(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value) == filterNum(eval('add_payment_actions2.h_to_other_closed_amount_'+i).value))
					eval('add_payment_actions2.to_closed_amount_'+i).value = commaSplit(eval('add_payment_actions2.h_to_closed_amount_'+i).value);
			}
		}
		else
		{
			<cfif isdefined("get_cari_rows")>
				for (var i=1; i <= <cfoutput>#get_cari_rows.recordcount#</cfoutput>; i++)
				{		
					rate2_eleman = eval('add_payment_actions2.rate2_'+i).value;
					eval('add_payment_actions2.to_closed_amount_'+i).value = commaSplit(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value)*rate2_eleman);
					if(filterNum(eval('add_payment_actions2.other_closed_amount_'+i).value) == filterNum(eval('add_payment_actions2.h_to_other_closed_amount_'+i).value))
						eval('add_payment_actions2.to_closed_amount_'+i).value = commaSplit(eval('add_payment_actions2.h_to_closed_amount_'+i).value);
				}
			</cfif>
		}
	}
	function total_amount_check()
	{
		var order_row_id_info = "";
		for (var i=1; i <= <cfoutput>#GET_CARI_CLOSED_ROW_1.recordcount+GET_CARI_CLOSED_ROW_2.recordcount#</cfoutput>; i++)
		{
			if(eval('add_payment_actions2.is_closed_'+i).checked && eval('add_payment_actions2.is_closed_'+i).disabled == false)
			{
				if(order_row_id_info == "")
					order_row_id_info = eval("add_payment_actions2.closed_row_id_" + i).value;
				else
					order_row_id_info = order_row_id_info + ',' + eval("add_payment_actions2.closed_row_id_" + i).value;
			}			
		}
		document.getElementById('order_row_id_info').value = order_row_id_info;
	}
</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
