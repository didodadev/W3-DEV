<cfif session.ep.isBranchAuthorization><cfset attributes.store_id = listgetat(session.ep.user_location, 2, '-')></cfif>
<cf_get_lang_set module_name="finance"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_DAILY_STORE_REPORT" datasource="#DSN2#">
	SELECT 
		STORE_REPORT.STORE_REPORT_ID, 
		STORE_REPORT.REPORT_ORDER_EMP, 
		STORE_REPORT.REPORT_APPROVAL_EMP, 
		STORE_REPORT.STORE_REPORT_DATE,
		STORE_REPORT.BANKAYA_YATAN, 
		STORE_REPORT.DETAIL,
		STORE_REPORT.REPORT_APPROVAL_DATE,
		STORE_REPORT.BRANCH_ID,
		STORE_REPORT.RECORD_IP,
		STORE_REPORT.RECORD_EMP,
		STORE_REPORT.RECORD_DATE,
		STORE_REPORT.UPDATE_IP,
		STORE_REPORT.UPDATE_EMP,
		STORE_REPORT.UPDATE_DATE,
		BRANCH.BRANCH_NAME
	FROM 
		STORE_REPORT,
		#dsn_alias#.BRANCH AS BRANCH
	WHERE
		STORE_REPORT.STORE_REPORT_ID = #URL.ID# AND
	<cfif session.ep.isBranchAuthorization>
		BRANCH.BRANCH_ID = #listgetat(session.ep.user_location, 2, '-')# AND
	</cfif>
		BRANCH.BRANCH_ID = STORE_REPORT.BRANCH_ID
</cfquery>
<cfif not get_daily_store_report.recordcount>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<!--- Finansal Günlük Durum Raporunda kaydedilen kasalari bulmak icin BK 20090112 --->
<cfquery name="GET_STORE_POS_ID" datasource="#DSN2#">
	SELECT STORE_POS_ID FROM STORE_POS_CASH WHERE STORE_REPORT_ID = #url.id#
</cfquery>
<cfif Len(get_store_pos_id.store_pos_id)>
	<cfquery name="GET_DAILY_SALES_REPORT" datasource="#DSN3#">
		SELECT EQUIPMENT,POS_ID FROM POS_EQUIPMENT WHERE BRANCH_ID = #get_daily_store_report.branch_id# AND POS_ID IN (#valuelist(get_store_pos_id.store_pos_id)#) ORDER BY POS_ID
	</cfquery>
<cfelse>
	<cfset GET_DAILY_SALES_REPORT.recordcount = 0>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
        <form name="add_daily_sales_report" action="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.emptypopup_upd_daily_report" method="post">
        <input type="hidden" name="bug_state" id="bug_state" value="0">
        <input type="hidden" name="store_report_id" id="store_report_id" value="<cfoutput>#get_daily_store_report.store_report_id#</cfoutput>">
        <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_daily_store_report.branch_id#</cfoutput>">
			<cf_box_search plus="0">
				<div class="form-group" id="tarih">
					<div class="input-group medium">
						<input type="text" name="report_date" id="report_date" readonly="yes" value="<cfoutput>#dateformat(get_daily_store_report.store_report_date,dateformat_style)#</cfoutput>" maxlength="10"> 
						<span class="input-group-addon"><cf_wrk_date_image date_field="report_date"></span>
					</div>
				</div>
			</cf_box_search>
            <!--- Kasa Hesapları Burada Yapılıyor --->
            <cf_seperator title="#getLang('main',1245)#" id="kasalar_">
            <cf_grid_list id="kasalar_">
                        <thead>
                            <tr>
                                <th><cf_get_lang dictionary_id='54574.Kasa No'></th>
                                <th><cf_get_lang dictionary_id='54577.Kasiyer'></th>
                                <th><cf_get_lang dictionary_id='54585.Nakit Satış'></th>
                                <th><cf_get_lang dictionary_id='54586.Kredili Satış'></th>
                                <th><cf_get_lang dictionary_id='54587.Toplam Satış'></th>
                                <th><cf_get_lang dictionary_id='58438.Z Raporu'></th>
                                <th><cf_get_lang dictionary_id='54597.Z No'></th>
                                <th><cf_get_lang dictionary_id='58717.Açık'></th>
                            </tr>
                        </thead>
                        <cfscript>
                            toplam_1=0;
                            toplam_2=0;
                            toplam_3=0;
                            toplam_4=0;
                            toplam_5=0;
                        </cfscript>
                        <cfif GET_DAILY_SALES_REPORT.recordcount>
                        <cfoutput query="GET_DAILY_SALES_REPORT">
                            <cfquery name="GET_STORE_CASH_POS" datasource="#DSN2#">
                                SELECT * FROM STORE_POS_CASH WHERE STORE_REPORT_ID = #url.id# AND STORE_POS_ID = #get_daily_sales_report.pos_id#
                            </cfquery>
                            <cfscript>
                                toplam_1_1=0;
                                toplam_1_2=0;
                                if (len(get_store_cash_pos.sales_credit) and len(get_store_cash_pos.sales_cash))
                                        { toplam_1_1 = get_store_cash_pos.sales_cash + get_store_cash_pos.sales_credit; }
                                if (len(get_store_cash_pos.given_total))
                                        { toplam_1_2 = toplam_1_1 - get_store_cash_pos.given_total; }
                                if (len(get_store_cash_pos.sales_cash))
                                        { toplam_1 = toplam_1 + get_store_cash_pos.sales_cash; }
                                if (len(get_store_cash_pos.sales_credit))
                                        { toplam_2 = toplam_2 + get_store_cash_pos.sales_credit; }
                                toplam_3 = toplam_3 + toplam_1_1;
                                if (len(get_store_cash_pos.given_total))
                                        { toplam_4 = toplam_4 + get_store_cash_pos.given_total; }
                                toplam_5 = toplam_5 + toplam_1_2;
                            </cfscript>
                            <tbody>
                                <tr>
                                    <td>#equipment#</td>
                                    <td nowrap="nowrap"><div class="input-group">
                                    <input type="hidden" name="pos_id#currentrow#" id="pos_id#currentrow#" value="#get_daily_sales_report.pos_id#">
                                    <input type="hidden" name="pos_no#currentrow#" id="pos_no#currentrow#" value="#equipment#">
                                    <input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#get_store_cash_pos.employee_id#">
                                    <input type="text" name="employee#currentrow#" id="employee#currentrow#" value="#get_emp_info(get_store_cash_pos.employee_id,0,0)#">
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_daily_sales_report.employee_id#currentrow#&field_name=add_daily_sales_report.employee#currentrow#&select_list=1','list');"></span></div></td>
                                    <td style="text-align:right;"><input type="text" name="total_cash#currentrow#" id="total_cash#currentrow#" value="<cfif len(get_store_cash_pos.sales_cash)>#tlformat(get_store_cash_pos.sales_cash)#<cfelse>#tlformat(0)#</cfif>" onBlur="toplam_center();" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></td>
                                    <td style="text-align:right;"><input type="text" name="total_credit#currentrow#" id="total_credit#currentrow#" value="<cfif len(get_store_cash_pos.sales_credit)>#tlformat(get_store_cash_pos.sales_credit)#<cfelse>#tlformat(0)#</cfif>" onBlur="toplam_center();" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></td>
                                    <td style="text-align:right;"><input type="text" name="total#currentrow#" id="total#currentrow#" readonly="yes" value="<cfif len(toplam_1_1)>#tlformat(toplam_1_1)#<cfelse>#tlformat(0)#</cfif>" class="moneybox"></td>
                                    <td style="text-align:right;"><input type="text" name="given_money#currentrow#" id="given_money#currentrow#" value="<cfif len(get_store_cash_pos.given_total)>#tlformat(get_store_cash_pos.given_total)#<cfelse>#tlformat(0)#</cfif>" onBlur="toplam_center();" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></td>
                                    <td style="text-align:right;"><input type="text" name="z_no#currentrow#" id="z_no#currentrow#" value="#get_store_cash_pos.z_no#" maxlength="100"></td>
                                    <td style="text-align:right;"><input type="text" name="open_cash#currentrow#" id="open_cash#currentrow#" readonly="yes" value="<cfif len(toplam_1_2)>#tlformat(toplam_1_2)#<cfelse>#tlformat(0)#</cfif>" class="moneybox"></td>
                                    </tr>
                            </tbody>
                            </cfoutput>
                            <cfoutput>
                                <tfoot>
                                    <tr height="20">
                                        <td colspan="2"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                        <td style="text-align:right;"><input type="text" name="a_total_cash" id="a_total_cash" readonly="yes" value="#TLFormat(toplam_1)#" class="moneybox"></td>
                                        <td style="text-align:right;"><input type="text" name="a_total_credit" id="a_total_credit" readonly="yes" value="#tlformat(toplam_2)#" class="moneybox"></td>
                                        <td style="text-align:right;"><input type="text" name="a_total" id="a_total" readonly="yes" value="#tlformat(toplam_3)#" class="moneybox"></td>
                                        <td style="text-align:right;"><input type="text" name="a_given_money" id="a_given_money" readonly="yes" value="#tlformat(toplam_4)#" class="moneybox"></td>
                                        <td>&nbsp;</td>
                                        <td style="text-align:right;"><input type="text" name="a_open_cash" id="a_open_cash" readonly="yes" value="#tlformat(toplam_5)#" class="moneybox"></td>
                                    </tr>
                                </tfoot>
                            </cfoutput>
                            <cfelse>
                                <tbody>
                                    <tr>
                                        <td colspan="9"><cf_get_lang dictionary_id='54852.Kasalarınızı Tanımlayınız'>!</td>
                                    </tr>
                                </tbody>
                            </cfif>
                    </cf_grid_list>
            <!--- Bankalar--->
            <cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn3#">
                SELECT PAYMENT_TYPE_ID, CARD_NO, NUMBER_OF_INSTALMENT, SERVICE_RATE, OTHER_COMISSION_RATE, GIVEN_POINT_RATE FROM CREDITCARD_PAYMENT_TYPE WHERE IS_ACTIVE = 1 ORDER BY CARD_NO
            </cfquery>
            <cf_seperator title="#getLang('','Bankalar',57987)#" id="bankalar_">
                <cf_grid_list id="bankalar_">
                    <thead>
                        <tr>
                            <th width="260"><cf_get_lang dictionary_id='57521.Banka'></th>
                            <th><cf_get_lang dictionary_id='40025.İşlem Sayısı'></th>
                            <th><cf_get_lang dictionary_id='54854.Kredili Satış Tutarı'></th>
                            <th><cf_get_lang dictionary_id='54857.Verilen Puan'></th>
                            <th><cf_get_lang dictionary_id='54856.Satış Puan'></th>
                            <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                        </tr>
                    </thead>
                    <cfif get_credit_payment.recordcount>
                    <cfscript>
                    topla_1_1_ = 0;
                    topla_2_1_ = 0;
                    topla_3_1_ = 0;
                    topla_4_1_ = 0;
                    topla_5_1_ = 0;
                    topla_6_1_ = 0;
                    </cfscript>
                    <cfoutput query="GET_CREDIT_PAYMENT">
                        <cfquery name="GET_STORE_POS_BANK" datasource="#DSN2#">
                            SELECT * FROM STORE_POS_BANK WHERE STORE_REPORT_ID = #url.id# AND BANK_ID = '#GET_CREDIT_PAYMENT.PAYMENT_TYPE_ID#'
                        </cfquery>
                        <cfscript>
                            if (len(get_store_pos_bank.sales_taksit))
                                { topla_1_1_ = topla_1_1_ + get_store_pos_bank.sales_taksit; }
                            if (len(get_store_pos_bank.sales_credit))
                                { topla_2_1_ = topla_2_1_ + get_store_pos_bank.sales_credit; }
                            if (len(get_store_pos_bank.puanli_pesin))
                                { topla_3_1_ = topla_3_1_ + 0; }//get_store_pos_bank.puanli_pesin
                            if (len(get_store_pos_bank.puanli))
                                { topla_4_1_ = topla_4_1_ + 0; }//get_store_pos_bank.puanli
                            if (len(get_store_pos_bank.sales_credit))
                                { topla_5_1_ = get_store_pos_bank.sales_credit; }
                            if (len(get_store_pos_bank.puanli))
                                { topla_5_1_ = topla_5_1_ + 0; }//get_store_pos_bank.puanli
                            if (len(get_store_pos_bank.puanli_pesin))
                                { topla_5_1_ = topla_5_1_ - 0; }//get_store_pos_bank.puanli_pesin
                                topla_6_1_ = topla_6_1_ + topla_5_1_;
                        </cfscript>
                        <tbody>
                            <tr>
                                <td><input type="hidden" name="given_point_rate#currentrow#" id="given_point_rate#currentrow#" value="0"><input type="hidden" name="bank_branch_id#currentrow#" id="bank_branch_id#currentrow#" value="#payment_type_id#">#card_no#</td><!--- <cfif len(get_credit_payment.given_point_rate)>#get_credit_payment.given_point_rate#<cfelse>#tlformat(0)#</cfif> --->
                                <td style="text-align:right;"><input type="text" name="number_of_operation#currentrow#" id="number_of_operation#currentrow#"  value="<cfif len(get_store_pos_bank.sales_taksit)>#tlformat(get_store_pos_bank.sales_taksit,0)#<cfelse>#tlformat(0)#</cfif>" onBlur="hesapla_banka();" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></td>
                                <td style="text-align:right;"><input type="text" name="sales_credit#currentrow#" id="sales_credit#currentrow#" value="<cfif len(get_store_pos_bank.sales_credit)>#tlformat(get_store_pos_bank.sales_credit)#<cfelse>#tlformat(0)#</cfif>" onBlur="hesapla_banka();" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></td>
                                <td style="text-align:right;"><input type="text" name="puanli_pesin#currentrow#" id="puanli_pesin#currentrow#" value="0" maxlength="100" class="moneybox" readonly="yes"></td><!--- <cfif len(get_store_pos_bank.puanli_pesin)>#tlformat(get_store_pos_bank.puanli_pesin)#<cfelse>#tlformat(0)#</cfif> --->
                                <td style="text-align:right;"><input type="text" name="puanli#currentrow#" id="puanli#currentrow#" readonly="yes" value="0" maxlength="100" class="moneybox" onBlur="hesapla_banka();" onkeyup="return(FormatCurrency(this,event));"></td><!--- <cfif len(get_store_pos_bank.puanli)>#tlformat(get_store_pos_bank.puanli)#<cfelse>#tlformat(0)#</cfif> --->
                                <td style="text-align:right;"><input type="text" name="sales_open_cash#currentrow#" id="sales_open_cash#currentrow#" readonly="yes" value="<cfif len(topla_5_1_)>#tlformat(topla_5_1_)#<cfelse>#tlformat(0)#</cfif>" class="moneybox"></td>
                            </tr>
                        </tbody>
                    </cfoutput>
                    <cfoutput>
                        <tfoot>
                            <tr>
                                <td><cf_get_lang dictionary_id='57492.Toplam'></td>
                                <td style="text-align:right;"><input type="text"  name="bank_total_number_of_operation" id="bank_total_number_of_operation" value="#tlformat(topla_1_1_)#" class="moneybox" readonly="yes"></td>
                                <td style="text-align:right;"><input type="text" name="bank_total_credit" id="bank_total_credit" value="#tlformat(topla_2_1_)#" readonly="yes" class="moneybox"></td>
                                <td style="text-align:right;"><input type="text" name="bank_total_puanli_pesin" id="bank_total_puanli_pesin" value="#tlformat(topla_3_1_)#" class="moneybox" readonly="yes"></td>
                                <td style="text-align:right;"><input type="text" name="bank_total_puanli" id="bank_total_puanli" value="#tlformat(topla_4_1_)#" class="moneybox" readonly="yes"></td>
                                <td style="text-align:right;"><input type="text" name="bank_total_toplam" id="bank_total_toplam" value="#tlformat(topla_6_1_)#" readonly="yes" class="moneybox"></td>
                            </tr>
                        </tfoot>
                    </cfoutput>
                    </cfif>
                </cf_grid_list>
            <!--- Ödemeler --->
            <cfquery name="GET_MONEY" datasource="#DSN#">
                SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
            </cfquery>
            <cfquery name="GET_STORE_EXPENSE_TYPE" datasource="#dsn2#">
                SELECT * FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 AND IS_ACTIVE = 1 ORDER BY EXPENSE_ITEM_NAME
            </cfquery>
            <cfquery name="GET_SETUP_TAX" datasource="#DSN2#">
                SELECT * FROM SETUP_TAX
            </cfquery>
            <cfquery name="GET_STORE_EXPP" datasource="#DSN2#">
                SELECT 
                    STORE_EXPENSE.STORE_REPORT_ID, 
                    STORE_EXPENSE.STORE_EXPENSE_ID,
                    STORE_EXPENSE.EXPENSE_TYPE_ID, 
                    STORE_EXPENSE.DETAIL, 
                    STORE_EXPENSE.EXPENSE_MONEY,
                    STORE_EXPENSE.MONEY_ID,
                    STORE_EXPENSE.TAX_TOTAL,
                    STORE_EXPENSE.TOTAL,
                    STORE_EXPENSE.TAX,
                    SETUP_MONEY.RATE1, 
                    SETUP_MONEY.RATE2 
                FROM
                    STORE_EXPENSE, 
                    #dsn_alias#.SETUP_MONEY AS SETUP_MONEY 
                WHERE 
                    STORE_EXPENSE.STORE_REPORT_ID = #URL.ID# AND 
                    SETUP_MONEY.MONEY = STORE_EXPENSE.MONEY_ID AND 
                    SETUP_MONEY.MONEY_STATUS = 1 AND
                    SETUP_MONEY.PERIOD_ID = #SESSION.EP.PERIOD_ID#
            </cfquery>
            <cfquery name="GET_GIFT_EXPENSE" datasource="#dsn#">
                SELECT * FROM CHEQUE_PRINTS_ROWS WHERE DAILY_REPORT_ID = #attributes.id# AND PERIOD_YEAR = #session.ep.period_year# AND COMPANY_ID = #session.ep.company_id#
            </cfquery>
            <cfset row = get_store_expp.recordcount> 
                <cf_seperator title="#getLang('','Ödemeler',58658)#" id="odemeler_">
                <cf_grid_list id="odemeler_">
                <thead>
                    <tr>
                        <th width="20" style="text-align:center;"><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#row#</cfoutput>"><input type="button" class="eklebuton" title="" onClick="add_row();"></th>
                        <th><cf_get_lang dictionary_id='58234.Bütçe Kalemi'>*</th>
                        <th><cf_get_lang dictionary_id='36199.Açıklama'>*</th>
                        <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                        <th><cf_get_lang dictionary_id='57639.KDV'></th>
                        <th><cf_get_lang dictionary_id='33214.KDV Tutar'></th>
                        <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                        <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                    </tr>
                </thead>
                <tbody id="table1">
                    <cfset toplam_expense_1 = 0>
                    <cfoutput query="get_store_expp">
                        <cfif (isnumeric(total))><cfset toplam_expense_1 = toplam_expense_1 + ((total*rate2)/rate1)></cfif>
                        <tr id="frm_row#currentrow#">
                            <td width="20"><a style="cursor:pointer" onClick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang no ='498.Ödeme Sil'>"></i></a></td>
                            <td><div class="form-group"><input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#">
                            <select name="payment_type#currentrow#" id="payment_type#currentrow#">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfset exp_type =  get_store_expp.expense_type_id>
                                <cfloop query="get_store_expense_type">
                                    <option value="#expense_item_id#" <cfif exp_type eq expense_item_id>selected</cfif>>#expense_item_name#</option>
                                </cfloop>
                            </select></div></td>
                            <td><div class="form-group"><input type="text" name="detail#currentrow#" id="detail#currentrow#" value="#detail#"></div></td>
                            <td><div class="form-group"><input type="text" name="expense_total#currentrow#" id="expense_total#currentrow#"  value="#tlformat(expense_money)#" onBlur="expense_topla();" onKeyUp="return(FormatCurrency(this,event));" class="moneybox"></div></td>
                            <td><div class="form-group"><select name="payment_tax#currentrow#" id="payment_tax#currentrow#" onChange="expense_topla();">
                            <cfset tax_gelen = get_store_expp.tax> 
                            <cfloop query="get_setup_tax">
                                <option value="#tax#" <cfif tax eq tax_gelen>selected</cfif>>#tax#</option>								  
                            </cfloop></select></div></td>
                            <td><div class="form-group"><input type="text" name="payment_net_total_tax#currentrow#" id="payment_net_total_tax#currentrow#" value="#tlformat(get_store_expp.tax_total)#" class="moneybox"  onKeyUp="return(FormatCurrency(this,event));" onBlur="expense_topla();"></div></td>
                            <td><div class="form-group"><input type="text" name="payment_net_total#currentrow#" id="payment_net_total#currentrow#" value="#tlformat(get_store_expp.total)#" class="moneybox"  readonly="yes"></div></td><!--- onkeyup="return(FormatCurrency(this,event));" onBlur="expense_topla();"  --->
                            <td><div class="form-group"><select name="money_type#currentrow#" id="money_type#currentrow#" onChange="expense_topla();">
                                    <cfset money_id = get_store_expp.money_id>
                                    <cfloop query="get_money">
                                        <option value="#money#,#rate1#,#rate2#" <cfif money_id eq money>selected</cfif>>#money#</option>
                                    </cfloop>
                                </select>
                                </div>
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>
                </cf_grid_list>
                <!--- Gelirler --->
                <cfquery name="GET_INCOME" datasource="#dsn2#">
                    SELECT * FROM EXPENSE_ITEMS WHERE INCOME_EXPENSE = 1 AND IS_ACTIVE = 1 ORDER BY EXPENSE_ITEM_NAME
                </cfquery>
                <cfquery name="GET_STORE_INCOME" datasource="#DSN2#">
                    SELECT 
                    STORE_INCOME.STORE_REPORT_ID, 
                    STORE_INCOME.STORE_INCOME_ID,
                    STORE_INCOME.INCOME_TYPE_ID, 
                    STORE_INCOME.DETAIL, 
                    STORE_INCOME.INCOME_MONEY,
                    STORE_INCOME.MONEY_ID,
                    STORE_INCOME.TAX_TOTAL,
                    STORE_INCOME.TOTAL,
                    STORE_INCOME.TAX,
                    SETUP_MONEY.RATE1, 
                    SETUP_MONEY.RATE2 
                    FROM
                    STORE_INCOME, 
                    #dsn_alias#.SETUP_MONEY AS SETUP_MONEY 
                    WHERE 
                    STORE_INCOME.STORE_REPORT_ID = #URL.ID# AND 
                    SETUP_MONEY.MONEY = STORE_INCOME.MONEY_ID AND 
                    SETUP_MONEY.MONEY_STATUS = 1 AND 
                    SETUP_MONEY.PERIOD_ID = #SESSION.EP.PERIOD_ID#
                </cfquery>
                <cfset income_row = get_store_income.recordcount>
                <cf_seperator title="#getLang('','Gelirler',58089)#" id="gelirler_">
                <cf_grid_list id="gelirler_">
                    <thead>
                        <tr>
                            <th width="20" style="text-align:center;"><input name="income_record_num" id="income_record_num" type="hidden" value="<cfoutput>#income_row#</cfoutput>"><input type="button" class="eklebuton" title="" onClick="income_add_row();"></th>
                            <th><cf_get_lang dictionary_id='58234.Bütçe Kalemi'>*</th>
                            <th><cf_get_lang dictionary_id='36199.Açıklama'>*</th>
                            <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                            <th><cf_get_lang dictionary_id='57639.KDV'></th>
                            <th><cf_get_lang dictionary_id='33214.KDV Tutar'></th>
                            <th><cf_get_lang dictionary_id='57492.Toplam'></th>
                            <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                        </tr>
                    </thead>
                    <tbody id="table2">
                        <cfset income_toplam_expense_1 = 0>
                        <cfif get_store_income.recordcount>
                            <cfoutput query="get_store_income">
                                <cfif (isnumeric(total))><cfset income_toplam_expense_1 = income_toplam_expense_1 + ((total*rate2)/rate1)></cfif>
                                <tr id="income_frm_row#currentrow#">
                                    <td width="20"><a style="cursor:pointer" onClick="income_sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang no ='498.Ödeme Sil'>" border="0"></i></a></td>
                                    <td><div class="form-group"><input type="hidden" value="1" name="income_row_kontrol#currentrow#" id="income_row_kontrol#currentrow#">
                                        <select name="income_payment_type#currentrow#" id="income_payment_type#currentrow#">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfset inc_type =  get_store_income.income_type_id>
                                            <cfloop query="get_income">
                                                <option value="#expense_item_id#" <cfif inc_type eq expense_item_id>selected</cfif>>#expense_item_name#</option>
                                            </cfloop>
                                        </select></div>
                                    </td>
                                    <td><div class="form-group"><input type="text" name="income_detail#currentrow#" id="income_detail#currentrow#" value="#detail#"></div></td>
                                    <td><div class="form-group"><input type="text" name="income_expense_total#currentrow#" id="income_expense_total#currentrow#"  value="#tlformat(income_money)#" onBlur="income_expense_topla();" onKeyUp="return(FormatCurrency(this,event));" class="moneybox"></div></td>
                                    <td><div class="form-group"><select name="income_payment_tax#currentrow#" id="income_payment_tax#currentrow#" onChange="income_expense_topla();">
                                        <cfset income_tax_gelen = get_store_income.tax> 
                                        <cfloop query="get_setup_tax">
                                        <option value="#tax#" <cfif tax eq income_tax_gelen>selected</cfif>>#tax#</option>								  
                                        </cfloop></select></div>
                                    </td>
                                    <td><div class="form-group"><input type="text" name="income_payment_net_total_tax#currentrow#" id="income_payment_net_total_tax#currentrow#" value="#tlformat(tax_total)#" class="moneybox"  onKeyUp="return(FormatCurrency(this,event));" onBlur="income_expense_topla();"></div></td>
                                    <td><div class="form-group"><input type="text" name="income_payment_net_total#currentrow#" id="income_payment_net_total#currentrow#" value="#tlformat(total)#" class="moneybox"  readonly="yes"></div></td>
                                    <td><div class="form-group"><select name="income_money_type#currentrow#" id="income_money_type#currentrow#" onChange="income_expense_topla();">
                                            <cfset income_money_id = get_store_income.money_id>
                                            <cfloop query="get_money">
                                                <option value="#money#,#rate1#,#rate2#" <cfif money eq income_money_id>selected</cfif>>#money#</option>
                                            </cfloop>
                                        </select></div>
                                    </td>
                                </tr>
                            </cfoutput>
                        </cfif>
                    </tbody>
                </cf_grid_list>
                <!--- 4. Kısım --->
                <cfset cek_toplam = 0>
                <cfquery name="GET_CHEQUE" datasource="#dsn#">
                    SELECT
                        CHEQUE_PRINTS.MONEY,
                        SETUP_MONEY.RATE2,
                        SETUP_MONEY.RATE1
                    FROM
                        CHEQUE_PRINTS,
                        CHEQUE_PRINTS_ROWS,
                        SETUP_MONEY
                    WHERE
                        CHEQUE_PRINTS.CHEQUE_ID = CHEQUE_PRINTS_ROWS.CHEQUE_PRINT_ID AND
                        SETUP_MONEY.MONEY = CHEQUE_PRINTS.MONEY_TYPE AND
                        SETUP_MONEY.PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
                        CHEQUE_PRINTS_ROWS.DAILY_REPORT_ID = #attributes.id# AND
                        CHEQUE_PRINTS_ROWS.PERIOD_YEAR = #session.ep.period_year# AND
                        CHEQUE_PRINTS_ROWS.COMPANY_ID = #session.ep.company_id#
                </cfquery>
                <cfloop query="get_cheque">
                    <cfset cek_toplam = cek_toplam + money*(rate2/rate1)>
                </cfloop>
                <cfquery name="GET_DEVREDEN_IN" datasource="#DSN2#">
                    SELECT DEVREDEN_IN FROM STORE_REPORT WHERE STORE_REPORT_ID = #URL.ID#
                </cfquery>
                <cfset search_tarih = date_add("d", -1, GET_DAILY_STORE_REPORT.STORE_REPORT_DATE)>
                <cfquery name="GET_TOTAL_KALAN" datasource="#DSN2#">
                    SELECT DEVREDEN, STORE_REPORT_DATE FROM STORE_REPORT WHERE STORE_REPORT_DATE = #search_tarih# AND BRANCH_ID = #GET_DAILY_STORE_REPORT.BRANCH_ID#
                </cfquery>
                <cfif len(get_devreden_in.devreden_in)>
                    <cfset toplam_devreden_in = get_devreden_in.devreden_in>
                <cfelseif len(get_total_kalan.devreden)>
                    <cfset toplam_devreden_in = get_total_kalan.devreden>
                <cfelse>
                    <cfset toplam_devreden_in = 0>
                </cfif>
                <cf_seperator title="#session.ep.money#" id="money">
                <cf_box_elements id="money">
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-kalan_eski">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50245.Alışveriş Çekleri'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif cek_toplam gt 0>
                                    <input type="text" name="alisveris_ceki" id="alisveris_ceki" readonly="yes;"  value="<cfoutput>#tlformat(cek_toplam)#</cfoutput>" class="moneybox">
                                <cfelse>
                                    <input type="text" name="alisveris_ceki" id="alisveris_ceki" readonly="yes;" value="0" class="moneybox">
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-kalan_eski">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54604.Dünden Kalan'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="kalan_eski" id="kalan_eski" value="<cfoutput>#tlformat(toplam_devreden_in)#</cfoutput>" class="moneybox" onBlur="toplam_center();" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        <div class="form-group" id="item-kalan_eski">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54585.Nakit Satış'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="summary_genel_nakit" id="summary_genel_nakit" readonly="yes" value="<cfoutput>#tlformat(toplam_1)#</cfoutput>" class="moneybox">
                            </div>
                        </div>
                        <div class="form-group" id="item-kalan_eski">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54586.Kredili Satış'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="summary_genel_kredili" id="summary_genel_kredili" value="<cfoutput>#tlformat(toplam_2)#</cfoutput>" readonly="yes" class="moneybox">
                            </div>
                        </div>
                        <div class="form-group" id="item-kalan_eski">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54607.Bankaya Yatan'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="bankaya_yatan" id="bankaya_yatan" value="<cfoutput>#tlformat(get_daily_store_report.bankaya_yatan)#</cfoutput>" class="moneybox" onBlur="expense_topla();" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-kalan_eski">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37285.Toplam Satış'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="summary_genel_toplam" id="summary_genel_toplam" value="<cfoutput>#tlformat(toplam_3)#</cfoutput>" readonly="yes" class="moneybox">
                            </div>
                        </div>
                        <div class="form-group" id="item-kalan_eski">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58658.Ödemeler'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="summary_genel_gider" id="summary_genel_gider" value="<cfoutput>#tlformat(toplam_expense_1)#</cfoutput>" readonly="yes" class="moneybox">
                            </div>
                        </div>
                        <div class="form-group" id="item-kalan_eski">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58089.Gelirler'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="summary_genel_gelir" id="summary_genel_gelir" value="<cfoutput>#tlformat(income_toplam_expense_1)#</cfoutput>" readonly="yes" class="moneybox">
                            </div>
                        </div>
                        <div class="form-group" id="item-kalan_eski">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54609.Kasa Açıkları'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="summary_genel_acik" id="summary_genel_acik" value="<cfoutput>#tlformat(toplam_5)#</cfoutput>" readonly="yes" class="moneybox">
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-kalan_eski">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58034.Devreden'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif toplam_5 lt 0>
                                    <cfset sonuc_1 = (toplam_3 + toplam_devreden_in + income_toplam_expense_1) - (toplam_expense_1 + get_daily_store_report.bankaya_yatan + toplam_2 + cek_toplam)><!---  + toplam_5 --->
                                <cfelseif toplam_5 gte 0>
                                    <cfset sonuc_1 = (toplam_3 + toplam_devreden_in + income_toplam_expense_1) - (toplam_expense_1 + get_daily_store_report.bankaya_yatan + toplam_2 + cek_toplam)><!---  - toplam_5 --->
                                </cfif>
                                <input type="hidden" name="ilk_deger" id="ilk_deger" value="<cfoutput>#tlformat(sonuc_1)#</cfoutput>">
                                <input type="text" name="summary_genel_kalan" id="summary_genel_kalan" value="<cfoutput>#tlformat(sonuc_1)#</cfoutput>" readonly="yes" class="moneybox">
                            </div>
                        </div>
                        <div class="form-group" id="item-kalan_eski">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54606.Düzenleyen'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="report_emp_id" id="report_emp_id" value="<cfoutput>#get_daily_store_report.report_order_emp#</cfoutput>">
                                    <input type="text" name="report_emp" id="report_emp" value="<cfoutput>#get_emp_info(get_daily_store_report.report_order_emp,0,0)#</cfoutput>" readonly>
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_daily_sales_report.report_emp_id&field_name=add_daily_sales_report.report_emp&select_list=1,9</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-kalan_eski">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30982.Onaylayan'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="approval_emp_id" id="approval_emp_id" value="<cfoutput>#get_daily_store_report.report_approval_emp#</cfoutput>">
                                    <input type="text" name="approval_emp" id="approval_emp" value="<cfoutput>#get_emp_info(get_daily_store_report.report_approval_emp,0,0)#</cfoutput>" readonly>
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_daily_sales_report.approval_emp_id&field_name=add_daily_sales_report.approval_emp&select_list=1,9</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-kalan_eski">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="ek_info" id="ek_info" style="width:120px;height:65px;"><cfif len(get_daily_store_report.detail)><cfoutput>#get_daily_store_report.detail#</cfoutput></cfif></textarea>
                            </div>
                        </div>
                        <cfif len(get_daily_store_report.report_approval_emp)>
                            <div class="form-group" id="item-kalan_eski">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30982.Onaylayan'></label>
                                <div class="col col-4 col-xs-12">
                                    <cfoutput>#get_emp_info(get_daily_store_report.report_approval_emp,0,0)#</cfoutput>
                                </div>
                                <cfif isdefined("get_daily_store_report.report_approval_date") and len(get_daily_store_report.report_approval_date)>
                                    <div class="col col-2 col-xs-12"><cfoutput>#dateformat(get_daily_store_report.report_approval_date,dateformat_style)#&nbsp;</cfoutput></div>
                                    <div class="col col-2 col-xs-12"><cfoutput>#timeformat(get_daily_store_report.report_approval_date,timeformat_style)#</cfoutput></div>
                                </cfif>
                            </div>
                        </cfif>
                    </div>
                </cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="GET_DAILY_STORE_REPORT">
                <cf_workcube_buttons type_format="1" is_upd='1' add_function='gonder_temizle()' delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_stores_daily_reports&event=del&id=#url.id#'>
            </cf_box_footer>
        </form>
    </cf_box>
</div>
<script type="text/javascript">

/*Giderler Satırları Eklemeleri Burada Yapılıyor*/
row_count=<cfoutput>#row#</cfoutput>;

function sil(sy)
{
	var my_element=eval("add_daily_sales_report.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}

function kontrol_et()
{
	if(row_count ==0) return false;
	else return true;
}

function add_row()
{
	//Ödemeler
	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);		
	document.add_daily_sales_report.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><i class="fa fa-minus" border="0"></i></a>';		
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><select name="payment_type' + row_count +'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_store_expense_type"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="detail' + row_count +'"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="expense_total' + row_count +'"  value="0" onBlur="expense_topla();" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="payment_tax' + row_count  +'"><cfoutput query="get_setup_tax"><option value="#tax#">#tax#</option></cfoutput></select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="payment_net_total_tax' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox"  onBlur="expense_topla();"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="payment_net_total' + row_count +'" value="0" class="moneybox" readonly="yes"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="money_type' + row_count +'" onChange="expense_topla();"><cfoutput query="get_money"><option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select></div>';
}

/*Gelirler Satırları Eklemeleri Burada Yapılıyor*/
income_row_count=<cfoutput>#income_row#</cfoutput>;
function income_sil(syi)
{
	var income_my_element=eval("add_daily_sales_report.income_row_kontrol"+syi);
	income_my_element.value=0;
	var income_my_element=eval("income_frm_row"+syi);
	income_my_element.style.display="none";
}

function income_kontrol_et()
{
	if(income_row_count ==0) return false;
	else return true;
}

function income_add_row()
{
	
	income_row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
	newRow.setAttribute("name","income_frm_row" + income_row_count);
	newRow.setAttribute("id","income_frm_row" + income_row_count);		
	newRow.setAttribute("NAME","income_frm_row" + income_row_count);
	newRow.setAttribute("ID","income_frm_row" + income_row_count);		
	document.add_daily_sales_report.income_record_num.value=income_row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="income_sil(' + income_row_count + ');"  ><i class="fa fa-minus"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input  type="hidden"  value="1"  name="income_row_kontrol' + income_row_count +'" ><select name="income_payment_type' + income_row_count +'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_income"><option value="#expense_item_id#">#expense_item_name#</option></cfoutput></select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="income_detail' + income_row_count +'"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="income_expense_total' + income_row_count +'"  value="0" onBlur="income_expense_topla();" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="income_payment_tax' + income_row_count  +'" onChange="income_expense_topla();"><cfoutput query="get_setup_tax"><option value="#tax#">#tax#</option></cfoutput></select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="income_payment_net_total_tax' + income_row_count +'" value="0" onkeyup="return(FormatCurrency(this,event));" class="moneybox"  onBlur="income_expense_topla();"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="text" name="income_payment_net_total' + income_row_count +'" value="0" class="moneybox" readonly="yes"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="income_money_type' + income_row_count +'" onChange="income_expense_topla();"><cfoutput query="get_money"><option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select></div>';
}

/*Kasa İle İlgili Tum Hesaplamalar Burada Yapılıyor*/
function toplam_center()
{
	toplam_expense=0;
	toplam_fark_expense=0;
	genel_toplam_1=0;
	genel_toplam_2=0;
	genel_toplam_3=0;
	genel_toplam_4=0;
	genel_toplam_5=0;
	for (var k=1; k <= <cfoutput>#get_daily_sales_report.recordcount#</cfoutput>; k++)
	{
		alan_1 = eval('add_daily_sales_report.total_cash'+k);
		alan_2 = eval('add_daily_sales_report.total_credit'+k);
		alan_3 = eval('add_daily_sales_report.given_money'+k);
		alan_4 = eval('add_daily_sales_report.total'+k);
		alan_5 = eval('add_daily_sales_report.open_cash'+k);
		alan_1.value=filterNum(alan_1.value);
		alan_2.value=filterNum(alan_2.value);
		alan_3.value=filterNum(alan_3.value);
		if(alan_1.value == "") { alan_1.value = 0; }
		if(alan_2.value == "") { alan_2.value = 0; }
		if(alan_3.value == "") { alan_3.value = 0; }
		toplam_expense = parseFloat(alan_1.value) + parseFloat(alan_2.value);
		genel_toplam_3 = genel_toplam_3 + toplam_expense;
		alan_4.value = toplam_expense;		
		add_daily_sales_report.a_total.value = commaSplit(genel_toplam_3);
		toplam_fark_expense = parseFloat(alan_3.value) - (parseFloat(alan_1.value) + parseFloat(alan_2.value));		
		alan_4.value = commaSplit(alan_4.value);
		genel_toplam_5 = genel_toplam_5 + wrk_round(toplam_fark_expense);
		alan_5.value = commaSplit(toplam_fark_expense);
		add_daily_sales_report.a_open_cash.value = commaSplit(genel_toplam_5);
		add_daily_sales_report.summary_genel_acik.value = commaSplit(genel_toplam_5);
		genel_toplam_1 = genel_toplam_1 + parseFloat(alan_1.value);
		add_daily_sales_report.a_total_cash.value = commaSplit(genel_toplam_1);
		add_daily_sales_report.summary_genel_nakit.value = commaSplit(genel_toplam_1);
		genel_toplam_2 = genel_toplam_2 + parseFloat(alan_2.value); 
		add_daily_sales_report.a_total_credit.value = commaSplit(genel_toplam_2);
		add_daily_sales_report.summary_genel_kredili.value = commaSplit(genel_toplam_2);
		genel_toplam_4 = genel_toplam_4 + parseFloat(alan_3.value);
		add_daily_sales_report.a_given_money.value = commaSplit(genel_toplam_4);
		add_daily_sales_report.summary_genel_toplam.value = commaSplit(genel_toplam_3);
		alan_1.value=commaSplit(alan_1.value);
		alan_2.value=commaSplit(alan_2.value);
		alan_3.value=commaSplit(alan_3.value);
	} 
	return expense_topla()
}

/*Banka İle İlgili Hesaplamalar Burada Yapılıyor*/
function hesapla_banka()
{
	banka_toplam_1 = 0;
	banka_toplam_2 = 0;
	banka_toplam_3 = 0;
	banka_toplam_4 = 0;
	banka_toplam_5 = 0;
	banka_toplam_6 = 0;
	for (var d=1; d <= <cfoutput>#get_credit_payment.recordcount#</cfoutput>; d++)
	{
		alan_banka_1 = eval('add_daily_sales_report.sales_credit'+d);
		alan_banka_2 = eval('add_daily_sales_report.puanli_pesin'+d);
		alan_banka_3 = eval('add_daily_sales_report.puanli'+d);
		alan_banka_4 = eval('add_daily_sales_report.number_of_operation'+d);
		alan_banka_5 = eval('add_daily_sales_report.sales_open_cash'+d);
		alan_banka_6 = eval('add_daily_sales_report.given_point_rate'+d);
		
		alan_banka_1.value=filterNum(alan_banka_1.value);
		alan_banka_2.value=filterNum(alan_banka_2.value);
		alan_banka_3.value=filterNum(alan_banka_3.value);
		alan_banka_4.value=filterNum(alan_banka_4.value,0);
		alan_banka_6.value=filterNum(alan_banka_6.value);
		
		if(alan_banka_1.value=="") { alan_banka_1.value = 0; }
		if(alan_banka_2.value=="") { alan_banka_2.value = 0; }
		if(alan_banka_3.value=="") { alan_banka_3.value = 0; }
		if(alan_banka_4.value=="") { alan_banka_4.value = 0; }
		if(alan_banka_6.value=="") { alan_banka_6.value = 0; }
		
		banka_toplam_1 = banka_toplam_1 + parseFloat(alan_banka_1.value);
		add_daily_sales_report.bank_total_credit.value = commaSplit(banka_toplam_1);
		banka_toplam_4 = banka_toplam_4 + parseFloat(alan_banka_4.value);
		add_daily_sales_report.bank_total_number_of_operation.value = commaSplit(banka_toplam_4,0);
		banka_toplam_3 = banka_toplam_3 + parseFloat(alan_banka_3.value);
		add_daily_sales_report.bank_total_puanli.value = commaSplit(banka_toplam_3);
		banka_toplam_2 = ((parseFloat(alan_banka_1.value) * parseFloat(alan_banka_6.value)) / 1000);
		banka_toplam_2 = wrk_round(banka_toplam_2);
		alan_banka_2.value = banka_toplam_2;
		banka_toplam_6 = banka_toplam_6 + banka_toplam_2;
		add_daily_sales_report.bank_total_puanli_pesin.value = commaSplit(banka_toplam_6);
		alan_banka_5.value = parseFloat(alan_banka_1.value) + parseFloat(alan_banka_3.value) - parseFloat(banka_toplam_2);
		banka_toplam_5 = banka_toplam_5 + parseFloat(alan_banka_5.value);
		add_daily_sales_report.bank_total_toplam.value = commaSplit(banka_toplam_5);
		alan_banka_1.value=commaSplit(alan_banka_1.value);
		alan_banka_2.value=commaSplit(alan_banka_2.value);
		alan_banka_3.value=commaSplit(alan_banka_3.value);
		alan_banka_4.value=commaSplit(alan_banka_4.value,0);
		alan_banka_5.value=commaSplit(alan_banka_5.value);
		alan_banka_6.value=commaSplit(alan_banka_6.value);
	}
}

/* Ödeme Hesapları Burada Yapılıyor*/
function expense_topla()
{		
	if(add_daily_sales_report.bankaya_yatan.value=="")
	{
		add_daily_sales_report.bankaya_yatan.value = 0;
	}
	if(add_daily_sales_report.kalan_eski.value=="")
	{
		add_daily_sales_report.kalan_eski.value = 0;
	}
		
	toplam_expense_dongu_1 = 0;
	for (var p=1;p<=row_count;p++)
		{
		deger_toplayacagim_1_1 = 0;
		deger_para_degisim = eval("document.add_daily_sales_report.money_type"+p);
		deger_para_miktarı = eval("document.add_daily_sales_report.expense_total"+p);
		alan_expense_1 = eval("document.add_daily_sales_report.payment_net_total_tax"+p);
		alan_expense_2 = eval("document.add_daily_sales_report.payment_net_total"+p);
		alan_expense_3 = eval("document.add_daily_sales_report.payment_tax"+p);
		deger_para_miktarı.value=filterNum(deger_para_miktarı.value);
		alan_expense_1.value=filterNum(alan_expense_1.value);
		alan_expense_2.value=filterNum(alan_expense_2.value);
		alan_expense_3.value=filterNum(alan_expense_3.value);
		if(deger_para_miktarı.value == "") { deger_para_miktarı.value = 0; }
		if(alan_expense_1.value == "") { alan_expense_1.value = 0; }
		if(alan_expense_2.value == "") { alan_expense_2.value = 0; }
		deger_para_degisim_1 = deger_para_degisim.value.split(',');
		deger_para_degisim_rate_ilk = deger_para_degisim_1[1];
		deger_para_degisim_rate_son = deger_para_degisim_1[2]; 
		alan_expense_1.value = (parseFloat(deger_para_miktarı.value)*alan_expense_3.value/100);
		alan_expense_2.value = parseFloat(deger_para_miktarı.value) + parseFloat(alan_expense_1.value);
		deger_toplayacagim_1_1 = (parseFloat(eval(alan_expense_2.value)) * (parseFloat(deger_para_degisim_rate_son) / parseFloat(deger_para_degisim_rate_ilk)));
		toplam_expense_dongu_1 = toplam_expense_dongu_1 + deger_toplayacagim_1_1;		
		deger_para_miktarı.value = commaSplit(deger_para_miktarı.value);
		alan_expense_1.value = commaSplit(alan_expense_1.value);
		alan_expense_2.value = commaSplit(alan_expense_2.value);
		
		}
	add_daily_sales_report.summary_genel_gider.value = toplam_expense_dongu_1;
	/*toplam_expense_dongu_1= filterNum(toplam_expense_dongu_1);*/
	add_daily_sales_report.kalan_eski.value = filterNum(add_daily_sales_report.kalan_eski.value);
	add_daily_sales_report.a_given_money.value = filterNum(add_daily_sales_report.a_given_money.value);
	add_daily_sales_report.bankaya_yatan.value = filterNum(add_daily_sales_report.bankaya_yatan.value);
	add_daily_sales_report.summary_genel_nakit.value = filterNum(add_daily_sales_report.summary_genel_nakit.value);
	add_daily_sales_report.a_open_cash.value = filterNum(add_daily_sales_report.a_open_cash.value);
	add_daily_sales_report.summary_genel_gelir.value = filterNum(add_daily_sales_report.summary_genel_gelir.value);
	add_daily_sales_report.a_total.value = filterNum(add_daily_sales_report.a_total.value);
	add_daily_sales_report.a_total_credit.value = filterNum(add_daily_sales_report.a_total_credit.value);
	add_daily_sales_report.summary_genel_kalan.value = parseFloat(add_daily_sales_report.a_total.value) + parseFloat(add_daily_sales_report.kalan_eski.value) + parseFloat(add_daily_sales_report.summary_genel_gelir.value) - parseFloat(add_daily_sales_report.a_total_credit.value) - parseFloat(add_daily_sales_report.summary_genel_gider.value) - parseFloat(add_daily_sales_report.bankaya_yatan.value)
	add_daily_sales_report.a_total_credit.value = commaSplit(add_daily_sales_report.a_total_credit.value);
	add_daily_sales_report.a_total.value = commaSplit(add_daily_sales_report.a_total.value);
	add_daily_sales_report.summary_genel_gider.value = commaSplit(toplam_expense_dongu_1);
	toplam_expense_dongu_1= commaSplit(toplam_expense_dongu_1);
	add_daily_sales_report.kalan_eski.value = commaSplit(add_daily_sales_report.kalan_eski.value);
	add_daily_sales_report.a_given_money.value = commaSplit(add_daily_sales_report.a_given_money.value);
	add_daily_sales_report.bankaya_yatan.value = commaSplit(add_daily_sales_report.bankaya_yatan.value);
	add_daily_sales_report.summary_genel_nakit.value = commaSplit(add_daily_sales_report.summary_genel_nakit.value);
	add_daily_sales_report.a_open_cash.value = commaSplit(add_daily_sales_report.a_open_cash.value);
	add_daily_sales_report.summary_genel_gelir.value = commaSplit(add_daily_sales_report.summary_genel_gelir.value);
	add_daily_sales_report.summary_genel_kalan.value = commaSplit(add_daily_sales_report.summary_genel_kalan.value);
}

/* Gelir Hesapları Burada Yapılıyor */
function income_expense_topla()
{
	income_toplam_expense_dongu_1 = 0;
	for (var p=1;p<=income_row_count;p++)
		{
		income_deger_toplayacagim_1_1 = 0;
		income_deger_para_degisim = eval("document.add_daily_sales_report.income_money_type"+p);
		income_deger_para_miktarı = eval("document.add_daily_sales_report.income_expense_total"+p);
		income_alan_expense_1 = eval("document.add_daily_sales_report.income_payment_net_total_tax"+p);
		income_alan_expense_2 = eval("document.add_daily_sales_report.income_payment_net_total"+p);
        income_alan_expense_3 = eval("document.add_daily_sales_report.income_payment_tax"+p);
		income_deger_para_miktarı.value=filterNum(income_deger_para_miktarı.value);
		income_alan_expense_1.value=filterNum(income_alan_expense_1.value);
		income_alan_expense_2.value=filterNum(income_alan_expense_2.value);
        income_alan_expense_3.value=filterNum(income_alan_expense_3.value);
		if(income_deger_para_miktarı.value=="") { income_deger_para_miktarı.value = 0; }
		if(income_alan_expense_1.value=="") { income_alan_expense_1.value = 0; }
		if(income_alan_expense_2.value=="") { income_alan_expense_2.value = 0; }
		income_deger_para_degisim_1 = income_deger_para_degisim.value.split(',');
		income_deger_para_degisim_rate_ilk = income_deger_para_degisim_1[1];
		income_deger_para_degisim_rate_son = income_deger_para_degisim_1[2];
		income_alan_expense_1.value = (parseFloat(income_deger_para_miktarı.value)*income_alan_expense_3.value)/100;
		income_alan_expense_2.value = parseFloat(income_deger_para_miktarı.value) + parseFloat(income_alan_expense_1.value);
		income_deger_toplayacagim_1_1 = (parseFloat(eval(income_alan_expense_2.value)) * (parseFloat(income_deger_para_degisim_rate_son) / parseFloat(income_deger_para_degisim_rate_ilk)));
		income_toplam_expense_dongu_1 = income_toplam_expense_dongu_1 + income_deger_toplayacagim_1_1;			
		income_deger_para_miktarı.value = commaSplit(income_deger_para_miktarı.value);
		income_alan_expense_1.value = commaSplit(income_alan_expense_1.value);
		income_alan_expense_2.value = commaSplit(income_alan_expense_2.value);
		}
	add_daily_sales_report.summary_genel_gelir.value = commaSplit(income_toplam_expense_dongu_1);
	return expense_topla()
}

/* Gelir Hesapları Burada Yapılıyor */
<!---function income_expense_topla()
{
	income_toplam_expense_dongu_1 = 0;
	for (var p=1;p<=income_row_count;p++)
		{
		income_deger_toplayacagim_1_1 = 0;
		income_deger_para_degisim = eval("document.add_daily_sales_report.income_money_type"+p);
		income_deger_para_miktarı = eval("document.add_daily_sales_report.income_expense_total"+p);
		income_alan_expense_1 = eval("document.add_daily_sales_report.income_payment_net_total_tax"+p);
		income_alan_expense_2 = eval("document.add_daily_sales_report.income_payment_net_total"+p);
		income_deger_para_miktarı.value=filterNum(income_deger_para_miktarı.value);
		income_alan_expense_1.value=filterNum(income_alan_expense_1.value);
		income_alan_expense_2.value=filterNum(income_alan_expense_2.value);
		if(income_deger_para_miktarı.value=="") { income_deger_para_miktarı.value = 0; }
		if(income_alan_expense_1.value=="") { income_alan_expense_1.value = 0; }
		if(income_alan_expense_2.value=="") { income_alan_expense_2.value = 0; }
		income_deger_para_degisim_1 = income_deger_para_degisim.value.split(',');
		income_deger_para_degisim_rate_ilk = income_deger_para_degisim_1[1];
		income_deger_para_degisim_rate_son = income_deger_para_degisim_1[2];
		income_alan_expense_1.value = income_alan_expense_1.value;
		income_alan_expense_2.value = parseFloat(income_deger_para_miktarı.value) + parseFloat(income_alan_expense_1.value);
		income_deger_toplayacagim_1_1 = (parseFloat(eval(income_alan_expense_2.value)) * (parseFloat(income_deger_para_degisim_rate_son) / parseFloat(income_deger_para_degisim_rate_ilk)));
		income_toplam_expense_dongu_1 = income_toplam_expense_dongu_1 + income_deger_toplayacagim_1_1;			
		income_deger_para_miktarı.value = commaSplit(income_deger_para_miktarı.value);
		income_alan_expense_1.value = commaSplit(income_alan_expense_1.value);
		income_alan_expense_2.value = commaSplit(income_alan_expense_2.value);
		}
	add_daily_sales_report.summary_genel_gelir.value = commaSplit(income_toplam_expense_dongu_1);
	return expense_topla()
}--->

/* Formumuzu Submit Ederken Zorunlu Alanları Kontrol Edelim */
function gonder_temizle()
{
	if(document.add_daily_sales_report.report_date.value == "")
	{
		alert("<cf_get_lang dictionary_id='54860.Lütfen Rapor Tarihi Giriniz'>!");
		return false;
	}
	
	for (var r=1;r<=row_count;r++)
	{
		deger_row_kontrol = eval("document.add_daily_sales_report.row_kontrol"+r);
		deger_payment_type = eval("document.add_daily_sales_report.payment_type"+r);
		deger_detail = eval("document.add_daily_sales_report.detail"+r);
		if(deger_row_kontrol.value == 1)
		{
			x = deger_payment_type.selectedIndex;
			if (deger_payment_type[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='54861.Lütfen Ödemeler Gider Kalemi Seçiniz'>!");
				return false;
			}	
			
			if (deger_detail.value == "")
			{
				alert("<cf_get_lang dictionary_id='54862.Ödemeler Açıklama Girmelisiniz'>!");
				return false;
			}
		}
	}

	for (var r=1;r<=income_row_count;r++)
	{
		deger_income_row_kontrol = eval("document.add_daily_sales_report.income_row_kontrol"+r);
		deger_income_payment_type = eval("document.add_daily_sales_report.income_payment_type"+r);
		deger_income_detail = eval("document.add_daily_sales_report.income_detail"+r);
		if(deger_income_row_kontrol.value == 1)
		{
			x = deger_income_payment_type.selectedIndex;
			if (deger_income_payment_type[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='54863.Lütfen Gelirler Gider Kalemi Seçiniz'>!");
				return false;
			}
			if (deger_income_detail.value == "")
			{
				alert("<cf_get_lang dictionary_id='54864.Gelirler Açıklama Girmelisiniz'>!");
				return false;
			}
		}
	}
	return unformat_fields();
}

/* Formumuzu Submit Ederken Zorunlu Alanları Kontrol Edelim */
function gonder_temizle()
{
	if(document.add_daily_sales_report.report_date.value == "")
	{
		alert("<cf_get_lang dictionary_id='54860.Lütfen Rapor Tarihi Giriniz'>!");
		return false;
	}
	add_daily_sales_report.bug_state.value = 1;
	for (var r=1;r<=row_count;r++)
	{
		deger_row_kontrol = eval("document.add_daily_sales_report.row_kontrol"+r);
		deger_payment_type = eval("document.add_daily_sales_report.payment_type"+r);
		deger_detail = eval("document.add_daily_sales_report.detail"+r);
		if(deger_row_kontrol.value == 1)
		{
			x = deger_payment_type.selectedIndex;
			if (deger_payment_type[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='54861.Lütfen Ödemeler Gider Kalemi Seçiniz'>!");
				return false;
			}	
			
			if (deger_detail.value == "")
			{
				alert("<cf_get_lang dictionary_id='54862.Ödemeler Açıklama Girmelisiniz'>!");
				return false;
			}
		}
	}
	add_daily_sales_report.bug_state.value = 2;
	for (var r=1;r<=income_row_count;r++)
	{
		deger_income_row_kontrol = eval("document.add_daily_sales_report.income_row_kontrol"+r);
		deger_income_payment_type = eval("document.add_daily_sales_report.income_payment_type"+r);
		deger_income_detail = eval("document.add_daily_sales_report.income_detail"+r);
		if(deger_income_row_kontrol.value == 1)
		{
			x = deger_income_payment_type.selectedIndex;
			if (deger_income_payment_type[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='54863.Lütfen Gelirler Gider Kalemi Seçiniz'>!");
				return false;
			}
			if (deger_income_detail.value == "")
			{
				alert("<cf_get_lang dictionary_id='54864.Gelirler Açıklama Girmelisiniz'>!");
				return false;
			}
		}
	}
	add_daily_sales_report.bug_state.value = 3;
	add_daily_sales_report.summary_genel_kalan.value = filterNum(add_daily_sales_report.summary_genel_kalan.value);
	add_daily_sales_report.bankaya_yatan.value = filterNum(add_daily_sales_report.bankaya_yatan.value); 
	add_daily_sales_report.kalan_eski.value = filterNum(add_daily_sales_report.kalan_eski.value); 
	add_daily_sales_report.bug_state.value = 4;
	for (var g=1; g <= <cfoutput>#get_daily_sales_report.recordcount#</cfoutput>; g++)
	{
		alan_1 = eval('add_daily_sales_report.total_cash'+g);
		alan_2 = eval('add_daily_sales_report.total_credit'+g);
		alan_3 = eval('add_daily_sales_report.given_money'+g);
		alan_4 = eval('add_daily_sales_report.total'+g);
		alan_5 = eval('add_daily_sales_report.open_cash'+g);
		alan_1.value = filterNum(alan_1.value);
		alan_2.value = filterNum(alan_2.value);
		alan_3.value = filterNum(alan_3.value);
		alan_4.value = filterNum(alan_4.value);
		alan_5.value = filterNum(alan_5.value);
	}
	add_daily_sales_report.bug_state.value = 5;
	for (var h=1; h <= <cfoutput>#get_credit_payment.recordcount#</cfoutput>; h++)
	{
		alan_banka_1 = eval('add_daily_sales_report.sales_credit'+h);
		alan_banka_2 = eval('add_daily_sales_report.puanli_pesin'+h);
		alan_banka_3 = eval('add_daily_sales_report.puanli'+h);
		alan_banka_4 = eval('add_daily_sales_report.number_of_operation'+h);
		alan_banka_1.value = filterNum(alan_banka_1.value);
		alan_banka_2.value = filterNum(alan_banka_2.value);
		alan_banka_3.value = filterNum(alan_banka_3.value);
		alan_banka_4.value = filterNum(alan_banka_4.value,0);
	}
	add_daily_sales_report.bug_state.value = 6;
	for (var r=1;r<=row_count;r++)
	{
		deger_para_miktarı = eval("document.add_daily_sales_report.expense_total"+r);
		alan_expense_1 = eval("document.add_daily_sales_report.payment_net_total_tax"+r);
		alan_expense_2 = eval("document.add_daily_sales_report.payment_net_total"+r);
		deger_para_miktarı.value = filterNum(deger_para_miktarı.value);
		alan_expense_1.value = filterNum(alan_expense_1.value);
		alan_expense_2.value = filterNum(alan_expense_2.value);
	}
	add_daily_sales_report.bug_state.value = 7;
	for (var r=1;r<=income_row_count;r++)
	{
		income_deger_para_miktarı = eval("document.add_daily_sales_report.income_expense_total"+r);
		income_alan_expense_1 = eval("document.add_daily_sales_report.income_payment_net_total_tax"+r);
		income_alan_expense_2 = eval("document.add_daily_sales_report.income_payment_net_total"+r);
		income_deger_para_miktarı.value = filterNum(income_deger_para_miktarı.value);
		income_alan_expense_1.value = filterNum(income_alan_expense_1.value);
		income_alan_expense_2.value = filterNum(income_alan_expense_2.value);
	}
	add_daily_sales_report.bug_state.value = 8;
	return true;
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
