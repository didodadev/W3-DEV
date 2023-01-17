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
		BRANCH.BRANCH_NAME 
	FROM 
		STORE_REPORT, 
		#dsn_alias#.BRANCH AS BRANCH 
	WHERE 
		STORE_REPORT.STORE_REPORT_ID = #URL.ID# AND	
		BRANCH.BRANCH_ID = STORE_REPORT.BRANCH_ID
</cfquery>
<cfquery name="GET_DAILY_SALES_REPORT" datasource="#DSN3#">
	SELECT EQUIPMENT, POS_ID FROM POS_EQUIPMENT WHERE BRANCH_ID = #get_daily_store_report.branch_id# ORDER BY POS_ID
</cfquery>
<cfquery name="CONTROL" datasource="#DSN2#">
	SELECT CASH_ACTION_ID FROM STORE_EXPENSE WHERE STORE_REPORT_ID = #get_daily_store_report.store_report_id#
</cfquery>
  <cfoutput>
  <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td  height="35" class="headbold"><cf_get_lang no='225.Şube Finansal Günlük Durum Raporu'>(#get_daily_store_report.branch_name#)</td>
      <td  style="text-align:right;"><cf_get_lang_main no='330.Tarih'> :#dateformat(get_daily_store_report.store_report_date,dateformat_style)#
	  <!-- sil -->
	  <cf_workcube_file_action print='1'>
	  <!-- sil -->
	  </td>
	</tr>
  </table>
  </cfoutput>
<table cellspacing="0" cellpadding="0" width="98%" border="1" align="center" bordercolor="#000000">
  <tr bgcolor="#FFFFFF">
    <td colspan="9" class="headbold"><cf_get_lang_main no='1245.Kasalar'></td>
  </tr>
  <tr height="25" bgcolor="#FFFFFF">
    <td class="txtboldblue"><cf_get_lang no='188.Kasa No'></td>
    <td class="txtboldblue"><cf_get_lang no='191.Kasiyer'></td>
    <td  class="txtboldblue" style="text-align:right;"><cf_get_lang no='199.Nakit Satış'></td>
    <td  class="txtboldblue" style="text-align:right;"><cf_get_lang no='200.Kredili Satış'></td>
    <td  class="txtboldblue" style="text-align:right;"><cf_get_lang no='201.Toplam Satış'></td>
    <td  class="txtboldblue" style="text-align:right;"><cf_get_lang_main no='298.Z Raporu'></td>
    <td class="txtboldblue">&nbsp;<cf_get_lang no='211.Z No'></td>
    <td  class="txtboldblue" style="text-align:right;"><cf_get_lang_main no='1305.Açık'></td>
  </tr>
   <cfscript>
		toplam_1=0;
		toplam_2=0;
		toplam_3=0;
		toplam_4=0;
		toplam_5=0;
	</cfscript>
	<cfoutput query="GET_DAILY_SALES_REPORT">
    	<cfquery name="GET_STORE_CASH_POS" datasource="#DSN2#">
			SELECT 
				* 
			FROM 
				STORE_POS_CASH 
			WHERE 
				STORE_REPORT_ID = #URL.ID# AND
				STORE_POS_ID = #GET_DAILY_SALES_REPORT.POS_ID#
		</cfquery>
    <cfscript>
		toplam_1_1=0;
		toplam_1_2=0;
		  if (len(get_store_cash_pos.sales_credit) and len(get_store_cash_pos.sales_cash))
				{
					toplam_1_1 = get_store_cash_pos.sales_cash + get_store_cash_pos.sales_credit;
				}
		  if (len(get_store_cash_pos.given_total))
				{
					toplam_1_2 = toplam_1_1 - get_store_cash_pos.given_total;
				}
		  if (len(get_store_cash_pos.sales_cash))
				{
					toplam_1 = toplam_1 + get_store_cash_pos.sales_cash;
				}
		  if (len(get_store_cash_pos.sales_credit))
				{
					toplam_2 = toplam_2 + get_store_cash_pos.sales_credit;
				}
		  toplam_3 = toplam_3 + toplam_1_1;
		  if (len(get_store_cash_pos.given_total))
				{
					toplam_4 = toplam_4 + get_store_cash_pos.given_total;
				}
		  toplam_5 = toplam_5 + toplam_1_2;
  </cfscript>
    <tr height="16" bgcolor="##FFFFFF">
      <td width="170">#equipment#</td>
      <td width="80">&nbsp;#get_emp_info(get_store_cash_pos.employee_id,0,0)#</td>
      <td  style="text-align:right;">#tlformat(get_store_cash_pos.sales_cash)# #session.ep.money#</td>
      <td  style="text-align:right;">#tlformat(get_store_cash_pos.sales_credit)# #session.ep.money#</td>
      <td  style="text-align:right;">#tlformat(toplam_1_1)# #session.ep.money#</td>
      <td  style="text-align:right;">#tlformat(get_store_cash_pos.given_total)# #session.ep.money#</td>
      <td width="60">&nbsp;#get_store_cash_pos.z_no#</td>
      <td  style="text-align:right;">#tlformat(toplam_1_2)# #session.ep.money#</td>
    </tr>
  </cfoutput>
  <cfoutput>
    <tr height="16" bgcolor="##FFFFFF">
      <td class="txtboldblue" colspan="2"><cf_get_lang_main no='80.Toplam'></td>
      <td  style="text-align:right;">&nbsp;#TLFormat(toplam_1)# #session.ep.money#</td>
      <td  style="text-align:right;">&nbsp;#tlformat(toplam_2)# #session.ep.money#</td>
      <td  style="text-align:right;">&nbsp;#tlformat(toplam_3)# #session.ep.money#</td>
      <td  style="text-align:right;">&nbsp;#tlformat(toplam_4)# #session.ep.money#</td>
      <td>&nbsp;</td>
      <td  style="text-align:right;">&nbsp;#tlformat(toplam_5)# #session.ep.money#</td>
    </tr>
  </cfoutput>
</table>
    <cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn3#">
    	SELECT PAYMENT_TYPE_ID, CARD_NO, NUMBER_OF_INSTALMENT, SERVICE_RATE, OTHER_COMISSION_RATE FROM CREDITCARD_PAYMENT_TYPE WHERE IS_ACTIVE = 1 ORDER BY CARD_NO
    </cfquery>
<br/>
<table cellspacing="0" cellpadding="0" width="98%" border="1" bordercolor="#000000" align="center">
      <tr bgcolor="#FFFFFF">
        <td class="headbold" colspan="9" height="22">Bankalar</td>
      </tr>
      <tr height="22" bgcolor="#FFFFFF">
        <td class="txtboldblue"><cf_get_lang_main no='109.Banka'></td>
        <td  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="54855.İşlem Sayısı"></td>
        <td  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="54854.Kredili Satış Tutarı"></td>
        <td  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="54857.Verilen Puan"></td>
        <td  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="54856.Satış Puan"></td>
        <td  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="57492.Toplam"></td>
      </tr>
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
          	SELECT * FROM STORE_POS_BANK WHERE STORE_REPORT_ID = #URL.ID# AND BANK_ID = '#GET_CREDIT_PAYMENT.PAYMENT_TYPE_ID#'
          </cfquery>
          <cfif len(get_store_pos_bank.sales_taksit)>
            <cfset topla_1_1_ = topla_1_1_ + get_store_pos_bank.sales_taksit>
          </cfif>
          <cfif len(get_store_pos_bank.sales_credit)>
            <cfset topla_2_1_ = topla_2_1_ + get_store_pos_bank.sales_credit>
          </cfif>
          <cfif len(get_store_pos_bank.puanli_pesin)>
            <cfset topla_3_1_ = topla_3_1_ + get_store_pos_bank.puanli_pesin>
          </cfif>
          <cfif len(get_store_pos_bank.puanli)>
            <cfset topla_4_1_ = topla_4_1_ + get_store_pos_bank.puanli>
          </cfif>
          <cfif len(get_store_pos_bank.sales_credit)>
            <cfset topla_5_1_ = get_store_pos_bank.sales_credit>
          </cfif>
          <cfif len(get_store_pos_bank.puanli)>
            <cfset topla_5_1_ = topla_5_1_ + get_store_pos_bank.puanli>
          </cfif>
          <cfif len(get_store_pos_bank.puanli_pesin)>
            <cfset topla_5_1_ = topla_5_1_ - get_store_pos_bank.puanli_pesin>
          </cfif>
          <cfset topla_6_1_ = topla_6_1_ + topla_5_1_>
          <tr height="16" bgcolor="##FFFFFF">
            <td width="170">#card_no#</td>
            <td width="80"  style="text-align:right;">#tlformat(get_store_pos_bank.sales_taksit)#</td>
            <td  style="text-align:right;">#tlformat(get_store_pos_bank.sales_credit)# #session.ep.money#</td>
            <td  style="text-align:right;">#tlformat(get_store_pos_bank.puanli_pesin)# #session.ep.money#</td>
            <td  style="text-align:right;">#tlformat(get_store_pos_bank.puanli)# #session.ep.money#</td>
            <td  style="text-align:right;">#tlformat(topla_5_1_)# #session.ep.money#</td>
          </tr>
        </cfoutput>
		<cfoutput>
          <tr height="16" bgcolor="##FFFFFF">
            <td class="txtboldblue"><cf_get_lang_main no='80.Toplam'></td>
            <td  style="text-align:right;">#tlformat(topla_1_1_)#</td>
            <td  style="text-align:right;">#tlformat(topla_2_1_)# #session.ep.money#</td>
            <td  style="text-align:right;">#tlformat(topla_3_1_)# #session.ep.money#</td>
            <td  style="text-align:right;">#tlformat(topla_4_1_)# #session.ep.money#</td>
            <td  style="text-align:right;">#tlformat(topla_6_1_)# #session.ep.money#</td>
          </tr>
        </cfoutput>
      </cfif>
    </table>
<br/>
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
		BRANCH.BRANCH_NAME
	FROM 
		STORE_REPORT, 
		#dsn_alias#.BRANCH AS BRANCH 
	WHERE 
		STORE_REPORT.STORE_REPORT_ID = #URL.ID# 
		AND
		BRANCH.BRANCH_ID = STORE_REPORT.BRANCH_ID
</cfquery>
<cfquery name="GET_DAILY_SALES_REPORT" datasource="#DSN3#">
	SELECT EQUIPMENT, POS_ID FROM POS_EQUIPMENT WHERE BRANCH_ID = #get_daily_store_report.branch_id# ORDER BY POS_ID
</cfquery>
<cfquery name="CONTROL" datasource="#DSN2#">
	SELECT CASH_ACTION_ID FROM STORE_EXPENSE WHERE STORE_REPORT_ID = #get_daily_store_report.store_report_id#
</cfquery>
<cfscript>
	toplam_1=0;
	toplam_2=0;
	toplam_3=0;
	toplam_4=0;
	toplam_5=0;
</cfscript>
<cfoutput query="GET_DAILY_SALES_REPORT">
  <cfquery name="GET_STORE_CASH_POS" datasource="#DSN2#">
  		SELECT * FROM STORE_POS_CASH WHERE STORE_REPORT_ID = #URL.ID# AND STORE_POS_ID = #GET_DAILY_SALES_REPORT.POS_ID#
  </cfquery>
  <cfscript>
		toplam_1_1=0;
		toplam_1_2=0;
		if (len(get_store_cash_pos.sales_credit) and len(get_store_cash_pos.sales_cash))
		{
		toplam_1_1 = get_store_cash_pos.sales_cash + get_store_cash_pos.sales_credit;
		}
		if (len(get_store_cash_pos.given_total))
		{
		toplam_1_2 = toplam_1_1 - get_store_cash_pos.given_total;
		}
		if (len(get_store_cash_pos.sales_cash))
		{
		toplam_1 = toplam_1 + get_store_cash_pos.sales_cash;
		}
		if (len(get_store_cash_pos.sales_credit))
		{
		toplam_2 = toplam_2 + get_store_cash_pos.sales_credit;
		}
		toplam_3 = toplam_3 + toplam_1_1;
		if (len(get_store_cash_pos.given_total))
		{
		toplam_4 = toplam_4 + get_store_cash_pos.given_total;
		}
		toplam_5 = toplam_5 + toplam_1_2;
</cfscript>
</cfoutput>
<cfquery name="GET_CREDIT_PAYMENT" datasource="#dsn3#">
	SELECT PAYMENT_TYPE_ID, CARD_NO, NUMBER_OF_INSTALMENT, SERVICE_RATE, OTHER_COMISSION_RATE FROM CREDITCARD_PAYMENT_TYPE WHERE IS_ACTIVE = 1 ORDER BY CARD_NO
</cfquery>
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
	    SELECT * FROM STORE_POS_BANK WHERE STORE_REPORT_ID = #URL.ID# AND BANK_ID = '#GET_CREDIT_PAYMENT.PAYMENT_TYPE_ID#'
    </cfquery>
    <cfif len(get_store_pos_bank.sales_taksit)>
      <cfset topla_1_1_ = topla_1_1_ + get_store_pos_bank.sales_taksit>
    </cfif>
    <cfif len(get_store_pos_bank.sales_credit)>
      <cfset topla_2_1_ = topla_2_1_ + get_store_pos_bank.sales_credit>
    </cfif>
    <cfif len(get_store_pos_bank.puanli_pesin)>
      <cfset topla_3_1_ = topla_3_1_ + get_store_pos_bank.puanli_pesin>
    </cfif>
    <cfif len(get_store_pos_bank.puanli)>
      <cfset topla_4_1_ = topla_4_1_ + get_store_pos_bank.puanli>
    </cfif>
    <cfif len(get_store_pos_bank.sales_credit)>
      <cfset topla_5_1_ = get_store_pos_bank.sales_credit>
    </cfif>
    <cfif len(get_store_pos_bank.puanli)>
      <cfset topla_5_1_ = topla_5_1_ + get_store_pos_bank.puanli>
    </cfif>
    <cfif len(get_store_pos_bank.puanli_pesin)>
      <cfset topla_5_1_ = topla_5_1_ - get_store_pos_bank.puanli_pesin>
    </cfif>
    <cfset topla_6_1_ = topla_6_1_ + topla_5_1_>
  </cfoutput>
</cfif>
<!---  Ödemeler Burada Yapılıyor --->

<cfset attributes.branch_id = GET_DAILY_STORE_REPORT.branch_id>
<!--- <cfset attributes.branch_id = listgetat(session.ep.user_location, 2, '-')> --->


<cfquery name="GET_STORE_EXPP" datasource="#DSN2#">
		SELECT STORE_EXPENSE.STORE_REPORT_ID, 
		STORE_EXPENSE.STORE_EXPENSE_ID, 
		STORE_EXPENSE.EXPENSE_TYPE_ID,
		STORE_EXPENSE.DETAIL, 
		STORE_EXPENSE.EXPENSE_MONEY, 
		STORE_EXPENSE.MONEY_ID, 
		STORE_EXPENSE.TAX_TOTAL,
		STORE_EXPENSE.TOTAL, 
		STORE_EXPENSE.TAX, 
		SETUP_MONEY.RATE1, 
		SETUP_MONEY.RATE2,
		BRANCH.BRANCH_NAME
	FROM 
		STORE_EXPENSE, 
		#dsn_alias#.SETUP_MONEY AS SETUP_MONEY ,
		#dsn_alias#.BRANCH AS BRANCH
	WHERE 
		STORE_EXPENSE.STORE_REPORT_ID = #URL.ID# AND
		SETUP_MONEY.MONEY = STORE_EXPENSE.MONEY_ID AND
		SETUP_MONEY.MONEY_STATUS = 1 AND
		SETUP_MONEY.PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		BRANCH.BRANCH_ID = #attributes.branch_id# AND
		STORE_EXPENSE.BRANCH_ID = BRANCH.BRANCH_ID
</cfquery>
<cfset row = get_store_expp.recordcount>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
<!--- <tr>
  <td  height="35" class="headbold">
  	Şube Günlük Gelir - Gider Raporu : <cfoutput>(#GET_STORE_EXPP.branch_name#)</cfoutput>
  </td>
  <td ><cf_get_lang_main no='330.Tarih'> :<cfoutput>#dateformat(get_daily_store_report.store_report_date,dateformat_style)#</cfoutput>
  <!-- sil -->
  <cf_workcube_file_action print='1'>
  <!-- sil -->
  </td>
</tr> --->
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="1" bordercolor="#000000" align="center">
  <tr bgcolor="#FFFFFF">
    <td height="22" class="headbold" colspan="7"><cf_get_lang dictionary_id="58658.Ödemeler"></td>
  </tr>
  <tr height="22" bgcolor="#FFFFFF">
    <td class="txtboldblue" width="180"><cf_get_lang dictionary_id="Bütçe Kalemi"> </td>
    <td class="txtboldblue" width="120"><cf_get_lang_main no='217.Açıklama'></td>
    <td  class="txtboldblue" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
    <td class="txtboldblue">.<cf_get_lang dictionary_id="57639.KDV"></td>
    <td  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="54859.KDV Tutar"></td>
    <td  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="57492.Toplam"></td>
    <td class="txtboldblue"><cf_get_lang_main no='77.Para Birimi'></td>
  </tr>
  <cfset toplam_expense_1 = 0>
  <cfoutput query="GET_STORE_EXPP">
    <cfif (isnumeric(total))>
      <cfset toplam_expense_1 = toplam_expense_1 + ((total*rate2)/rate1)>
    </cfif>
    <tr height="16" bgcolor="##FFFFFF">
      <td>&nbsp;<cfif len(get_store_expp.expense_type_id)>
          <cfquery name="GET_STORE_EXPENSE_TYPE" datasource="#dsn2#">
          	SELECT * FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 AND EXPENSE_ITEM_ID = #get_store_expp.expense_type_id#
          </cfquery>#get_store_expense_type.expense_item_name#</cfif></td>
      <td>&nbsp;#detail#</td>
      <td  style="text-align:right;">#tlformat(expense_money)#</td>
	  <td  style="text-align:right;"><cfif len(get_store_expp.tax)>
          <cfquery name="GET_SETUP_TAX" datasource="#DSN2#">
	          SELECT * FROM SETUP_TAX WHERE TAX = #get_store_expp.tax#
          </cfquery>#get_setup_tax.tax#</cfif></td>
      <td  style="text-align:right;">#tlformat(get_store_expp.tax_total)#</td>
      <td  style="text-align:right;">#tlformat(get_store_expp.total)#</td>
	  <td><cfquery name="GET_MONEY" datasource="#DSN#">
        SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1 AND MONEY = '#get_store_expp.money_id#'
        </cfquery>#get_money.money#</td>
    </tr>
  </cfoutput>
</table>
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
		SETUP_MONEY.PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		SETUP_MONEY.MONEY_STATUS = 1
</cfquery>
<br/>
<table cellspacing="0" cellpadding="0" width="98%" border="1" align="center" bordercolor="#000000">
	<tr bgcolor="#FFFFFF">
	  <td height="20" class="headbold" colspan="9"><cf_get_lang dictionary_id ="58089.Gelirler"></td>
	</tr>
      <tr  height="20" bgcolor="#FFFFFF">
        <td class="txtboldblue" width="180"><cf_get_lang dictionary_id ="58234.Bütçe Kalemi"></td>
        <td class="txtboldblue" width="120"><cf_get_lang_main no='217.Açıklama'></td>
        <td  class="txtboldblue" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
        <td class="txtboldblue"><cf_get_lang dictionary_id="57639.KDV"></td>
        <td  class="txtboldblue" style="text-align:right;"><cf_get_lang_main no='54859.KDV Tutar'></td>
        <td  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="57492.Toplam"></td>
        <td class="txtboldblue"><cf_get_lang_main no='77.Para Birimi'></td>
      </tr>
      <cfset income_toplam_expense_1 = 0>
      <cfif get_store_income.recordcount>
        <cfset income_row = get_store_income.recordcount>
        <cfoutput query="get_store_income">
          <cfif (isnumeric(total))>
            <cfset income_toplam_expense_1 = income_toplam_expense_1 + ((total*rate2)/rate1)>
          </cfif>
          <tr height="16" bgcolor="##FFFFFF">
            <td>&nbsp;<cfif len(get_store_income.income_type_id)>
                <cfquery name="GET_STORE_EXPENSE_TYPE_" datasource="#dsn2#">
                	SELECT * FROM EXPENSE_ITEMS WHERE INCOME_EXPENSE = 1 AND EXPENSE_ITEM_ID = #get_store_income.income_type_id#
                </cfquery>#get_store_expense_type_.expense_item_name#</cfif></td>
            <td>&nbsp;#detail#</td>
            <td  style="text-align:right;">#tlformat(income_money)#</td>
			<td  style="text-align:right;"><cfif len(get_store_expp.tax)>
                <cfquery name="GET_SETUP_TAX_" datasource="#DSN2#">
	                SELECT * FROM SETUP_TAX WHERE TAX = #get_store_income.tax#
                </cfquery>#get_setup_tax_.tax#</cfif>
            </td>
            <td  style="text-align:right;">#tlformat(tax_total)#</td>
            <td  style="text-align:right;">#tlformat(total)#</td>
			<td><cfquery name="GET_MONEY_" datasource="#DSN#">
              		SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1 AND MONEY = '#get_store_income.money_id#'
              </cfquery>#get_money_.money# </td>
          </tr>
        </cfoutput>
      </cfif>
    </table>
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
    <cfoutput>
	<br/>
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
					SETUP_MONEY.PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
					SETUP_MONEY.MONEY = CHEQUE_PRINTS.MONEY_TYPE AND
					CHEQUE_PRINTS_ROWS.DAILY_REPORT_ID = #attributes.id# AND
					CHEQUE_PRINTS_ROWS.PERIOD_YEAR = #session.ep.period_year# AND
					CHEQUE_PRINTS_ROWS.COMPANY_ID = #session.ep.company_id#
			  </cfquery>
			  <cfloop query="get_cheque">
			  	<cfset cek_toplam = cek_toplam + money*(rate2/rate1)>
			  </cfloop>
<table cellspacing="0" cellpadding="0" width="98%" border="1" bordercolor="##000000" align="center">
        <tr height="20" bgcolor="##FFFFFF">
          <td class="headbold" colspan="2">#session.ep.money# <cf_get_lang_main no='640.Özet'></td>
          <td width="100"><cf_get_lang no='218.Dünden Kalan'></td>
          <td width="251"  style="text-align:right;">#tlformat(toplam_devreden_in)# #session.ep.money#</td>
          <td rowspan="7" valign="top" width="64"><cf_get_lang_main no='398.Ek Bilgi'></td>
          <td width="480" rowspan="7" valign="top">&nbsp;<cfif len(get_daily_store_report.detail)>#get_daily_store_report.detail#</cfif></td>
        </tr>
       <tr height="20" bgcolor="##FFFFFF">
          <td colspan="2">&nbsp;</td>
          <td width="100">Alışveriş Çekleri</td>
          <td width="251"  style="text-align:right;">#tlformat(cek_toplam)# #session.ep.money#</td>
        </tr>
	    <tr height="20" bgcolor="##FFFFFF">
          <td colspan="2">&nbsp;</td>
          <td width="100"><cf_get_lang no='199.Nakit Satış'></td>
          <td width="251"  style="text-align:right;">#tlformat(toplam_1)# #session.ep.money#</td>
        </tr>
        <tr height="20" bgcolor="##FFFFFF">
          <td colspan="2">&nbsp;</td>
          <td><cf_get_lang no='200.Kredili Satış'></td>
          <td  style="text-align:right;">#tlformat(toplam_2)# #session.ep.money#</td>
        </tr>
        <tr height="20" bgcolor="##FFFFFF">
          <td colspan="2">&nbsp;</td>
          <td><cf_get_lang no='201.Toplam Satış'></td>
          <td  style="text-align:right;">#tlformat(toplam_3)# #session.ep.money#</td>
        </tr>
        <tr height="20" bgcolor="##FFFFFF">
          <td colspan="2">&nbsp;</td>
          <td><cf_get_lang_main no='1246.Ödemeler'></td>
          <td  style="text-align:right;">#tlformat(toplam_expense_1)# #session.ep.money#</td>
        </tr>
        <tr height="20" bgcolor="##FFFFFF">
          <td colspan="2">&nbsp;</td>
          <td>Gelirler</td>
          <td  style="text-align:right;">#tlformat(income_toplam_expense_1)# #session.ep.money#</td>
        </tr>
        <tr height="20" bgcolor="##FFFFFF">
          <td colspan="2">&nbsp;</td>
          <td><cf_get_lang no='223.Kasa Açıkları'></td>
          <td  style="text-align:right;">#tlformat(toplam_5)# #session.ep.money#</td>
		  <td><cf_get_lang no='220.Düzenleyen'></td>
          <td>&nbsp;#get_emp_info(get_daily_store_report.report_order_emp,0,0)#</td>
        </tr>
        <tr height="20" bgcolor="##FFFFFF">
          <td colspan="2">&nbsp;</td>
          <td><cf_get_lang no='221.Bankaya Yatan'></td>
          <td  style="text-align:right;">#tlformat(get_daily_store_report.bankaya_yatan)# #session.ep.money#</td>
            <td>Onaylayan</td>
            <td>&nbsp;<cfif len(get_daily_store_report.report_approval_emp)>#get_emp_info(get_daily_store_report.report_approval_emp,0,0)#&nbsp;-
              <cfif isdefined("get_daily_store_report.report_approval_date") and len(get_daily_store_report.report_approval_date)>
                #dateformat(get_daily_store_report.report_approval_date,dateformat_style)#&nbsp; #timeformat(get_daily_store_report.report_approval_date,timeformat_style)#
              </cfif>
			  </cfif>
            </td>
        </tr>
        <tr height="20" bgcolor="##FFFFFF">
          <td colspan="2">&nbsp;</td>
          <td><cf_get_lang_main no='622.Devreden'></td>
          <td  style="text-align:right;">
		<cfif toplam_5 lt 0>
			<cfset sonuc_1 = (toplam_3 + toplam_devreden_in + income_toplam_expense_1) - (toplam_expense_1 + get_daily_store_report.bankaya_yatan + toplam_2)><!---  + toplam_5 --->
		<cfelseif toplam_5 gte 0>
			<cfset sonuc_1 = (toplam_3 + toplam_devreden_in + income_toplam_expense_1) - (toplam_expense_1 + get_daily_store_report.bankaya_yatan + toplam_2)><!---  - toplam_5 --->
		</cfif>
			#tlformat(sonuc_1-cek_toplam)# #session.ep.money#</td>
			<td colspan="2">&nbsp;</td>
      </table>

    </cfoutput>
