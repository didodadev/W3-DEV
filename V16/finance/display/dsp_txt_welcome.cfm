<cfoutput>
    <div class="pagemenus_container">
    	<div style="float:left;">
			<cfif get_module_user(23)>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang_main no='107.Cari Hesap'></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'ch.list_caris')><li><a href="#request.self#?fuseaction=ch.list_caris"><cf_get_lang_main no='507.Hareketler'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'objects.popup_list_comp_extre')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre','medium');"><cf_get_lang_main no='375.Cari Hesap Ekstresi'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'ch.list_duty_claim')><li><a href="#request.self#?fuseaction=ch.list_duty_claim"> <cf_get_lang_main no='2279.Borç Alacak Dökümü'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.add_payment_actions')><li><a href="#request.self#?fuseaction=finance.add_payment_actions&act_type=2"> <cf_get_lang no='43.Ödeme Talebi'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'ch.list_duty_claim')><li><a href="#request.self#?fuseaction=ch.list_duty_claim&from_rev_collecter=1"> <cf_get_lang no='449.Ödeme Takip'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'ch.dsp_make_age')><li><a href="#request.self#?fuseaction=ch.dsp_make_age"> <cf_get_lang_main no='390.Odeme Performansi'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.add_payment_actions')><li><a href="#request.self#?fuseaction=finance.add_payment_actions&act_type=1"> <cf_get_lang no='386.Fatura Kapama'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.list_payment_actions')><li><a href="#request.self#?fuseaction=finance.list_payment_actions&act_type=1"> <cf_get_lang no='387.Fatura Kapama Belgeleri'></a></li></cfif>						
                            <cfif not listfindnocase(denied_pages,'form_upd_account_open&var_=ch_opening_card')><li><a href="#request.self#?fuseaction=ch.form_upd_account_open&var_=ch_opening_card"> <cf_get_lang_main no='1344.Açılış Fişi'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'popup_form_add_debit_claim_note')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ch.popup_form_add_debit_claim_note','medium');"> <cf_get_lang no='304.Dekont Ekle'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'ch.popup_add_cari_to_cari')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ch.popup_add_cari_to_cari','medium');"> <cf_get_lang_main no='2328.Cari Virman Ekle'></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>
            <cfif get_module_user(18)>
            	<div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang_main no='108.Kasa'></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'cash.list_cashes')><li><a href="#request.self#?fuseaction=cash.list_cashes"><cf_get_lang_main no='1245.Kasalar'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cash.form_add_cash_open')><li><a href="#request.self#?fuseaction=cash.form_add_cash_open"><cf_get_lang no='306.Kasa Devir'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cash.list_cash_actions')><li><a href="#request.self#?fuseaction=cash.list_cash_actions"><cf_get_lang_main no='1485.Kasa İşlemleri'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cash.form_add_cash_to_cash')><li><a href="#request.self#?fuseaction=cash.form_add_cash_to_cash"><cf_get_lang_main no ='2233.Virman - Döviz Alış\Satış İşlemi'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cash.form_add_cash_revenue')><li><a href="#request.self#?fuseaction=cash.form_add_cash_revenue"><cf_get_lang_main no='2284.Nakit Tahsilat'></a></li></cfif>					
                            <cfif not listfindnocase(denied_pages,'cash.form_add_cash_payment')><li><a href="#request.self#?fuseaction=cash.form_add_cash_payment"><cf_get_lang no='76.Ödeme Isleme'></a></li></cfif>	
                            <cfif not listfindnocase(denied_pages,'finance.list_stores_daily_reports')><li><a href="#request.self#?fuseaction=finance.list_stores_daily_reports"><cf_get_lang_main no='1772.Şube Kasa Raporu'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.list_daily_zreport')><li><a href="#request.self#?fuseaction=finance.list_daily_zreport"><cf_get_lang_main no='1026.Z Raporu'></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>
        </div>
        <div style="float:left;">
			<cfif get_module_user(19)>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang_main no='109.Banka'></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'bank.list_bank_account')><li><a href="#request.self#?fuseaction=bank.list_bank_account"><cf_get_lang_main no='1590.Banka Hesapları'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.list_bank_actions')><li><a href="#request.self#?fuseaction=bank.list_bank_actions"><cf_get_lang_main no='1484.Banka İşlemleri'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.form_add_bank_account_open')><li><a href="#request.self#?fuseaction=bank.form_add_bank_account_open"><cf_get_lang_main no='2280.Banka Hesabı Açılışı'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.list_assign_order')><li><a href="#request.self#?fuseaction=bank.list_assign_order"><cf_get_lang no='322.Banka Talimatları'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.form_add_invest_money')><li><a href="#request.self#?fuseaction=bank.form_add_invest_money"><cf_get_lang_main no='2285.Hesaba Para Yatır'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.form_add_get_money')><li><a href="#request.self#?fuseaction=bank.form_add_get_money"><cf_get_lang_main no='2286.Hesaptan Para Çek'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.form_add_virman')><li><a href="#request.self#?fuseaction=bank.form_add_virman"><cf_get_lang_main no ='2233.Virman - Döviz Alış\Satış İşlemi'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.form_add_gelenh')><li><a href="#request.self#?fuseaction=bank.form_add_gelenh"><cf_get_lang_main no='422.Gelen Havale'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.form_add_gidenh')><li><a href="#request.self#?fuseaction=bank.form_add_gidenh"><cf_get_lang_main no='423.Giden Havale'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.list_creditcard_revenue')><li><a href="#request.self#?fuseaction=bank.list_creditcard_revenue"><cf_get_lang_main no='424.Kredi Kartı Tahsilatları'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.list_credit_card_expense')><li><a href="#request.self#?fuseaction=bank.list_credit_card_expense"><cf_get_lang no='394.Kredi Kartıyla Ödemeler'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.list_payment_credit_cards')><li><a href="#request.self#?fuseaction=bank.list_payment_credit_cards"><cf_get_lang no='395.Kredi Kartı Hesaba Geçişler'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.list_multi_provision')><li><a href="#request.self#?fuseaction=bank.list_multi_provision"><cf_get_lang no='396.Toplu Provizyon'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.list_multi_provision_import')><li><a href="#request.self#?fuseaction=bank.list_multi_provision_import"><cf_get_lang no='397.Toplu Provizyon Dönüşleri'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.list_multi_pos_import')><li><a href="#request.self#?fuseaction=bank.list_multi_pos_import"><cf_get_lang no='398.Toplu Pos Dönüşleri'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.add_collacted_gelenh')><li><a href="#request.self#?fuseaction=bank.add_collacted_gelenh"><cf_get_lang_main no='1750.Toplu Gelen Havale'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.add_collacted_gidenh')><li><a href="#request.self#?fuseaction=bank.add_collacted_gidenh"><cf_get_lang_main no='1758.Toplu Giden Havale'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'bank.popup_form_bank_order_copy')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.popup_form_bank_order_copy','small');"><cf_get_lang no='331.Banka Emirleri Aktar'></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>
            <cfif get_module_user(49)>
            	<div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang_main no='86.Masraf Yönetimi'></strong>
                        <ul>   
                            <cfif not listfindnocase(denied_pages,'cost.list_expense_income')><li><a href="#request.self#?fuseaction=cost.list_expense_income"><cf_get_lang_main no='652.Masraf Fişleri'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cost.form_add_expense_cost')><li><a href="#request.self#?fuseaction=cost.form_add_expense_cost"><cf_get_lang_main no='2296.Masraf Ekle'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cost.list_expense_management')><li><a href="#request.self#?fuseaction=cost.list_expense_management"><cf_get_lang no='125.Masraflar'></a></li></cfif>
                        </ul> 
                    </li>
                </ul>
            </cfif>
        </div>
        <div style="float:left;">
			<cfif get_module_user(21)>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang_main no='110.Çek / Senet'></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'cheque.list_cheque_actions')><li><a href="#request.self#?fuseaction=cheque.list_cheque_actions"><cf_get_lang_main no='2290.Çek İşlemleri'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.list_cheques')><li><a href="#request.self#?fuseaction=cheque.list_cheques"><cf_get_lang_main no='2305.Çek Listesi'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.form_add_payroll_entry')><li><a href="#request.self#?fuseaction=cheque.form_add_payroll_entry"><cf_get_lang_main no='440.Çek Giriş Bordrosu'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.form_add_payroll_bank_revenue')><li><a href="#request.self#?fuseaction=cheque.form_add_payroll_bank_revenue"><cf_get_lang no='338.Çek Çıkış-Tahsil'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.form_add_payroll_bank_guaranty')><li><a href="#request.self#?fuseaction=cheque.form_add_payroll_bank_guaranty"><cf_get_lang no='339.Çek Çıkış-Banka'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.form_add_payroll_endorsement')><li><a href="#request.self#?fuseaction=cheque.form_add_payroll_endorsement"><cf_get_lang_main no='2292.Çek Çıkış Bordrosu'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.form_add_payroll_entry_return')><li><a href="#request.self#?fuseaction=cheque.form_add_payroll_entry_return"><cf_get_lang_main no='444.Çek İade Giriş Bordrosu'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.form_add_payroll_endor_return')><li><a href="#request.self#?fuseaction=cheque.form_add_payroll_endor_return"><cf_get_lang_main no='445.Çek İade Çıkış Bordrosu'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.form_add_payroll_bank_guaranty_return')><li><a href="#request.self#?fuseaction=cheque.form_add_payroll_bank_guaranty_return"><cf_get_lang no='393.Çek İade Giriş - Banka'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.list_voucher_actions')><li><a href="#request.self#?fuseaction=cheque.list_voucher_actions"><cf_get_lang_main no='2294.Senet İşlemleri'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.list_vouchers')><li><a href="#request.self#?fuseaction=cheque.list_vouchers"><cf_get_lang_main no='2295.Senet Listesi'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.form_add_voucher_payroll_entry')><li><a href="#request.self#?fuseaction=cheque.form_add_voucher_payroll_entry"><cf_get_lang no='347.Senet Giriş Bordro'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.form_add_voucher_payroll_endorsement')><li><a href="#request.self#?fuseaction=cheque.form_add_voucher_payroll_endorsement"><cf_get_lang_main no='599.Senet Çıkış Bordrosu'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.form_add_voucher_payroll_revenue')><li><a href="#request.self#?fuseaction=cheque.form_add_voucher_payroll_revenue"><cf_get_lang no='348.Senet Çıkış-Tahsil'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.form_add_voucher_payroll_bank_tah')><li><a href="#request.self#?fuseaction=cheque.form_add_voucher_payroll_bank_tah"><cf_get_lang no='349.Senet Çıkış-Banka Tahsil'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.form_add_voucher_payroll_bank_tem')><li><a href="#request.self#?fuseaction=cheque.form_add_voucher_payroll_bank_tem"><cf_get_lang no='350.Senet Çıkış-Banka Teminat'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.add_voucher_payroll_entry_return')><li><a href="#request.self#?fuseaction=cheque.add_voucher_payroll_entry_return"><cf_get_lang_main no='601.Senet İade Giriş Bordrosu'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'cheque.add_voucher_payroll_endor_return')><li><a href="#request.self#?fuseaction=cheque.add_voucher_payroll_endor_return"><cf_get_lang_main no='600.Senet İade Çıkış Bordrosu'></a></li></cfif>				
                        </ul>
                    </li>
                </ul>
            </cfif>
            <div class="pagemenus_clear"></div>
            <ul class="pagemenus">
                <li><strong><cf_get_lang_main no='113.Senaryolar'></strong>   
                    <ul>
                        <cfif not listfindnocase(denied_pages,'finance.list_scen_expense')><li><a href="#request.self#?fuseaction=finance.list_scen_expense"><cf_get_lang no='2.Gelir-Giderler'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'finance.form_add_scen_expense')><li><a href="#request.self#?fuseaction=finance.form_add_scen_expense"><cf_get_lang no='3.Gelir-Gider Ekle'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'finance.scenario&requesttimeout=1000')><li><a href="#request.self#?fuseaction=finance.scenario&requesttimeout=1000"><cf_get_lang no='4.Finans Senaryosu'></a></li></cfif>
                    </ul>
                </li>
            </ul>
        </div>
        <div style="float:left;">
			<cfif get_module_power_user(16)>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang_main no='117.Tanımlar'></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'finance.definitons')><li><a href="#request.self#?fuseaction=budget.list_expense_center"><cf_get_lang no='6.Masraf/Gelir Merkezleri'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'budget.list_expense_cat')><li><a href="#request.self#?fuseaction=budget.list_expense_cat"><cf_get_lang no='7.Bütçe Kategorileri'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'budget.list_expense_item')><li><a href="#request.self#?fuseaction=budget.list_expense_item"><cf_get_lang no='8.Bütçe Kalemleri'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'budget.list_cost_bill_templates')><li><a href="#request.self#?fuseaction=budget.list_cost_bill_templates"><cf_get_lang no='352.Masraf Şablonları'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.form_add_cheque_exp')><li><a href="#request.self#?fuseaction=finance.form_add_cheque_exp"><cf_get_lang no='246.Toplu Çek Girişi'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.form_add_voucher_exp')><li><a href="#request.self#?fuseaction=finance.form_add_voucher_exp"><cf_get_lang no='367.Toplu Senet Girişi'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.list_currencies')><li><a href="#request.self#?fuseaction=finance.list_currencies"><cf_get_lang_main no='262.Kur Bilgileri'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.list_scenarios')><li><a href="#request.self#?fuseaction=finance.list_scenarios"><cf_get_lang no='172.Senaryo Tanımları'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.list_pos_equipment')><li><a href="#request.self#?fuseaction=finance.list_pos_equipment"><cf_get_lang no='206.Yazar Kasalar'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.list_bank_pos')><li><a href="#request.self#?fuseaction=finance.list_bank_pos"><cf_get_lang no='247.Banka Posları'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.list_creditcard')><li><a href="#request.self#?fuseaction=finance.list_creditcard"><cf_get_lang no='389.Kredi Kartları'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.list_credit_payment_types')><li><a href="#request.self#?fuseaction=finance.list_credit_payment_types"><cf_get_lang no='355.Kredi Kartı Ödeme/Tahsil Yöntemi'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.list_bank_types')><li><a href="#request.self#?fuseaction=finance.list_bank_types"><cf_get_lang_main no='575.Bankalar'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'finance.list_bank_branch')><li><a href="#request.self#?fuseaction=finance.list_bank_branch"><cf_get_lang_main no='2245.Banka Şubeleri'></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>
            <div class="pagemenus_clear"></div>
            <ul class="pagemenus">    
                <li><strong><cf_get_lang_main no='1.Gündem'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'finance.list_finance_agenda')><li><a href="#request.self#?fuseaction=finance.list_finance_agenda"><cf_get_lang no='16.Finans Gündemi'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'finance.list_securefund')><li><a href="#request.self#?fuseaction=finance.list_securefund"><cf_get_lang_main no='264.Teminatlar'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'member.popup_form_add_securefund')><li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=member.popup_form_add_securefund','wide');"><cf_get_lang no='249.Teminat Ekle'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'finance.list_payment_actions')><li><a href="#request.self#?fuseaction=finance.list_payment_actions&act_type=3"><cf_get_lang no='262.Odeme Emirleri'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'finance.list_credits')><li><a href="#request.self#?fuseaction=finance.list_credits"><cf_get_lang no='269.Risk Tanımları'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'contract.popup_add_company_credit')><li><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=contract.popup_add_company_credit','medium');"><cf_get_lang no='358.Risk Ekle'></a></li></cfif>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</cfoutput> 
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
