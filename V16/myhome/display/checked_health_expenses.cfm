<cfsavecontent variable="title2"><cf_get_lang dictionary_id="57492.Toplam"></cfsavecontent>
<cf_box id="list_checked" closable="0" collapsable="0" title="#title2#">
    <div class="row" type="row">
        <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group" id="item-total_net_amount">
                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id="57492.Toplam"><cf_get_lang dictionary_id="48323.Fatura Tutarı"></label>
                <div class="col col-6 col-xs-12">
                    <input type="text" readonly class="moneybox" name="amount_last_total" id="amount_last_total" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>">
                </div>
            </div>
            <div class="form-group" id="item-total_treatment_amount">
                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id="57492.Toplam"><cf_get_lang dictionary_id="59887.Tedaviye Esas Tutar"></label>
                <div class="col col-6 col-xs-12">
                    <input type="text" readonly class="moneybox" name="treatment_last_total" id="treatment_last_total" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>">
                </div>
            </div>
            <div class="form-group" id="item-total_comp_amount">
                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id="57492.Toplam"><cf_get_lang dictionary_id="41154.Kurum Payı"></label>
                <div class="col col-6 col-xs-12">
                    <input type="text" readonly class="moneybox" name="comp_last_total" id="comp_last_total" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>">
                </div>
            </div>
            <div class="form-group" id="item-total_emp_amount">
                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id="57492.Toplam"><cf_get_lang dictionary_id="41148.Çalışan Payı"></label>
                <div class="col col-6 col-xs-12">
                    <input type="text" readonly class="moneybox" name="emp_last_total" id="emp_last_total" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>">
                </div>
            </div>
        </div>
        <div class="col col-4 col-xs-12" type="column" index="2" sort="true">
            <cfset get_process_f = HealthExpense.GetProcessType(
						fuseaction : attributes.fuseaction,
						expense_stage: attributes.expense_stage)>
            <cfif isDefined("attributes.gp_id")>
                <cf_workcube_general_process general_paper_id = "#attributes.gp_id#">
            <cfelse>
                <cf_workcube_general_process select_value = '#get_process_f.process_row_id#'>
            </cfif>
            <div class="form-group" id="item-payment_order">
                <div style="float:right;">
                    <input type="checkbox" id="is_payment_order" name="is_payment_order" value="1" onclick="excelToggle()">
                    <label for="scales">&nbsp;<cf_get_lang dictionary_id="59978.Ödeme Emri Oluştur"></label>
                </div>
                <div style="float:right;">
                    <input type="checkbox" id="is_print_excel" name="is_print_excel" value="1" onclick="buttonToggle()">
                    <label for="scales">&nbsp;<cf_get_lang dictionary_id="29737.Excel Üret"></label>
                </div>
            </div>
            <div class="form-group" id="item-bank_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'></label>
                <div class="col col-8 col-xs-12">
                    <select name="bank_id" id="bank_id" style="width:200px;">
                        <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                        <cfoutput query="get_accounts">
                            <option value="#bank_id#">#bank_name#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-excel_type">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58531.Aktarım Formatı'></label>
                <div class="col col-8 col-xs-12">
                    <select name="excel_type_id" id="excel_type_id" style="width:200px;">
                        <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                        <option value="1"><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                        <option value="2"><cf_get_lang dictionary_id='29534.Toplam Tutar'><cf_get_lang dictionary_id='58601.Bazında'></option>
                    </select>
                </div>
            </div>
        </div>
    </div>
    <cf_box_footer>
        <div class="col col-12 col-xs-12 text-right">
            <input type="button" name="get_excel" id="get_excel" value="<cf_get_lang dictionary_id='58631.Excele Aktar'>" onclick="getExcel()">
            <input type="button" name="is_create_excel" id="is_create_excel" value="<cf_get_lang dictionary_id='58631.Excele Aktar'>" onclick="getExcel()">
            <input type="button" name="printTemplate" id="printTemplate" value="<cf_get_lang dictionary_id='59979.Çıktı Al'>" onclick="openPrintTab()">
            <cf_workcube_buttons is_upd='0' add_function='setHealthExpenseProcess()'>
        </div>
    </cf_box_footer>
</cf_box>