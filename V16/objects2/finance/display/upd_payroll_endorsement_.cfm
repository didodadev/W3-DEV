<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">

<cfif isdefined("attributes.id")>
	<cfset attributes.cheque_payroll_id = attributes.id>
</cfif>
<cfif isdefined("attributes.period_id") and len(attributes.period_id)>
	<cfquery name="GET_PERIOD" datasource="#DSN#">
		SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
	</cfquery>
	<cfif get_period.recordcount>
		<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
	<cfelse>
		<cfset db_adres = "#dsn2#">
	</cfif>
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>

<cfinclude template="../query/get_money_rate.cfm">
<cfquery name="GET_ACTION_DETAIL" datasource="#db_adres#">
	SELECT 
       	PAYROLL_REVENUE_DATE, 
        PAYROLL_CASH_ID, 
        PAYROLL_NO, 
        PAYROLL_REV_MEMBER,
        PAYROLL_TOTAL_VALUE,
        RECORD_EMP,
        RECORD_DATE,
        COMPANY_ID 
    FROM 
     	PAYROLL 
    WHERE 
    	ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND 
        PAYROLL_TYPE = 91
</cfquery>
<cfquery name="GET_CHEQUE_DETAIL" datasource="#db_adres#">
	SELECT
		CHEQUE.CHEQUE_NO,
		CHEQUE.BANK_NAME,
		CHEQUE.BANK_BRANCH_NAME,
		CHEQUE.CHEQUE_DUEDATE,
		CHEQUE.CHEQUE_VALUE,
		CHEQUE.CURRENCY_ID,
		CHEQUE.OTHER_MONEY_VALUE,
		CHEQUE.OTHER_MONEY	
	FROM
		CHEQUE_HISTORY,
		CHEQUE
	WHERE
		CHEQUE_HISTORY.PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cheque_payroll_id#"> AND 
		(CHEQUE_HISTORY.STATUS = 4 OR CHEQUE_HISTORY.STATUS = 6) AND 
		CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
</cfquery>
<!---
<table cellpadding="0" align="center" cellspacing="0" border="0" style="width:97%;">
  	<tr style="height:35px;"> 
    	<td class="headbold"><cf_get_lang_main no ='443.Çek Çıkış Bordrosu (Ciro)'></td>
  	</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:97%;">
  	<tr class="color-border"> 
    	<td> 
        	<table border="0" cellpadding="2" cellspacing="1" style="width:100%;">
        		<tr class="color-row">
          			<td> 
                        <table>
                            <tr style="height:20px;"> 
                                <td class="txtbold" style="width:60px;"><cf_get_lang no ='1256.Bordro No'></td>
                                <td style="width:100px;">: <cfif  len(get_action_detail.payroll_no) ><cfoutput>#get_action_detail.payroll_no#</cfoutput></cfif></td>
                                <td class="txtbold" style="width:60px;"><cf_get_lang_main no ='330.Tarih'></td>
                                <td>: <cfoutput>#dateformat(get_action_detail.payroll_revenue_date,'dd/mm/yyyy')#</cfoutput></td>
                            </tr>
                            <tr style="height:20px;">
                                <td class="txtbold"><cf_get_lang_main no='162.Firma'></td>
                                <td>:<cfoutput>#get_par_info(get_action_detail.company_id,1,1,0)#</cfoutput></td>
                                <td class="txtbold"><cf_get_lang_main no ='1174.İşlem Yapan'></td>
                                <td>:<cfoutput>#get_emp_info(get_action_detail.payroll_rev_member,0,0)#</cfoutput></td>
                            </tr>
                            <tr style="height:20px;">
                                <td class="txtbold"><cf_get_lang_main no='108.Kasa'></td>
                                <td>:
									<cfset cash_id=get_action_detail.payroll_cash_id>
                                    <cfinclude template="../query/get_action_cash.cfm">
                                    <cfoutput>#get_action_cash.cash_name#</cfoutput> 
                                </td>
                                <td colspan="2" class="txtbold"><cf_get_lang_main no='71.Kayıt'> : <cfoutput>#get_emp_info(get_action_detail.record_emp,0,0)#&nbsp;#dateformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'HH:MM')#</cfoutput></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="color-row">
                    <td>
                        <br/>	
                        <table style="width:650px;">
                        	<tr class="txtbold" style="height:22px;">
                                <td><cf_get_lang_main no ='595.Çek'> No</td>
                                <td><cf_get_lang_main no='109.Banka'></td>
                                <td><cf_get_lang_main no='41.Şube'></td>
                                <td><cf_get_lang_main no='228.Vade'></td>
                                <td><cf_get_lang no ='1257.İşlem Para Br'></td>
                                <td><cf_get_lang_main no='765.Sistem Para Br'></td>
                        	</tr>
                        	<!--- Burasi cek sayisi kadar artacak..--->
                        	<cfoutput query="get_cheque_detail">
                                <tr>
                                    <td>#cheque_no#</td>
                                    <td>#bank_name#</td>
                                    <td>#bank_branch_name#</td>
                                    <td>#dateformat(cheque_duedate,'dd/mm/yyyy')#</td>
                                    <td>#TLFormat(cheque_value)# #currency_id#</td>
                                    <td>#TLFormat(other_money_value)# #other_money#</td>
                                </tr>
                                <tr>
                                	<td colspan="6" style="vertical-align:top;"><hr></td>
                                </tr>
                        	</cfoutput>
                        </table>
                        <br/>
                        <table style="width:650px;">
                            <tr>
                                <td style="text-align:right;">
                                    <table>
                                        <tr>
                                            <td style="width:50px;"><strong><cf_get_lang_main no='1233.Nakit'></strong></td>
                                            <td style="width:150px;">:</td>
                                            <td style="width:75px;"><strong><cf_get_lang no ='1252.Tahsil Eden'></strong></td>
                                            <td>:<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfoutput>#get_emp_info(attributes.emp_id,0,0)#</cfoutput></cfif></td>
                                        </tr>
                                        <tr>
                                            <td><strong><cf_get_lang_main no ='595.Çek'></strong></td>
                                            <td>: <cfoutput>#TLFormat(get_action_detail.payroll_total_value)# #get_money_rate.money#</cfoutput></td>
                                            <td><strong><cf_get_lang_main no='80.Toplam'></strong></td>
                                            <td>: <cfoutput>#TLFormat(get_action_detail.payroll_total_value)# #get_money_rate.money#</cfoutput></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
  	  					</table>
	  				</td>
				</tr>
    		</table>
   		</td>
  	</tr>
</table>
<br/>
--->
<hgroup class="finance_display">
    <h3><cf_get_lang_main no ='443.Çek Çıkış Bordrosu (Ciro)'></h3>
    <div class="colmn_left">
        <div class="area_colmn">
            <label><cf_get_lang no ='1256.Bordro No'></label>
            <span>: <cfif  len(get_action_detail.payroll_no) ><cfoutput>#get_action_detail.payroll_no#</cfoutput></cfif></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='162.Firma'></label>
            <span>: <cfoutput>#get_par_info(get_action_detail.company_id,1,1,0)#</cfoutput></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='108.Kasa'></label>
            <span>:
                <cfset cash_id=get_action_detail.payroll_cash_id>
                <cfinclude template="../query/get_action_cash.cfm">
                <cfoutput>#get_action_cash.cash_name#</cfoutput> 
            </span>
        </div>
    </div>
    <div class="colmn_left">
        <div class="area_colmn">
            <label><cf_get_lang_main no ='330.Tarih'></label>
            <span>: <cfoutput>#dateformat(get_action_detail.payroll_revenue_date,'dd/mm/yyyy')#</cfoutput></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='1174.İşlem Yapan'></label>
            <span>: <cfoutput>#get_emp_info(get_action_detail.payroll_rev_member,0,0)#</cfoutput></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='71.Kayıt'> </label>
            <span>:  <cfoutput>#get_emp_info(get_action_detail.record_emp,0,0)#&nbsp;#dateformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'HH:MM')#</cfoutput></span>
        </div>
    </div>
    <div class="clear_area"></div>
    <table class="objects2_list">
        <thead>
            <tr>
                <th><cf_get_lang_main no ='595.Çek'> No</th>
                <th><cf_get_lang_main no='109.Banka'></th>
                <th><cf_get_lang_main no='41.Şube'></th>
                <th><cf_get_lang_main no='228.Vade'></th>
                <th><cf_get_lang no ='1257.İşlem Para Br'></th>
                <th><cf_get_lang_main no='765.Sistem Para Br'></th>
            </tr>
        </thead>
        <tbody>
            <tr class="odd">
                <td>15</td>
                <td>DG Bank</td>
                <td>AB</td>
                <td>AHL</td>
                <td>04685</td>
                <td>usd</td>
            </tr>
            <cfoutput query="get_cheque_detail">
                <tr>
                    <td>#cheque_no#</td>
                    <td>#bank_name#</td>
                    <td>#bank_branch_name#</td>
                    <td>#dateformat(cheque_duedate,'dd/mm/yyyy')#</td>
                    <td>#TLFormat(cheque_value)# #currency_id#</td>
                    <td>#TLFormat(other_money_value)# #other_money#</td>
                </tr>
            </cfoutput>
        </tbody>
    </table>
    <div class="clear_area"></div>
    <div class="colmn_left">
        <div class="area_colmn">
            <label><cf_get_lang_main no='1233.Nakit'></label><span>: </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no ='595.Çek'></label><span>: <cfoutput>#TLFormat(get_action_detail.payroll_total_value)# #get_money_rate.money#</cfoutput></span>
        </div>
    </div>
    <div class="colmn_left">
        <div class="area_colmn">
            <label><cf_get_lang no ='1252.Tahsil Eden'></label><span>: <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfoutput>#get_emp_info(attributes.emp_id,0,0)#</cfoutput></cfif></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='80.Toplam'></label><span>: <cfoutput>#TLFormat(get_action_detail.payroll_total_value)# #get_money_rate.money#</cfoutput></span>
        </div>
    </div>
</hgroup>

