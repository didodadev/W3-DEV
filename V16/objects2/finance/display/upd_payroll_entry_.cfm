<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">

<cfscript>structdelete(session,"cheque");</cfscript>
<cfif isdefined("attributes.id")>
	<cfset attributes.cheque_payroll_id = attributes.id>
</cfif>
<cfif isdefined("attributes.period_id") and len(attributes.period_id)>
	<cfquery name="GET_PERIOD" datasource="#DSN#">
		SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfinclude template="../query/get_money_rate.cfm">
<cfquery name="GET_ACTION_DETAIL" datasource="#db_adres#">
	SELECT 
    	PAYROLL_NO, 
        PAYROLL_REVENUE_DATE,
        PAYROLL_CASH_ID,
        PAYROLL_TOTAL_VALUE,
        COMPANY_ID,
        RECORD_EMP,
        RECORD_DATE 
    FROM 
    	PAYROLL 
    WHERE 
    	ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND 
        PAYROLL_TYPE = 90
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
		PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cheque_payroll_id#"> AND 
		STATUS = 1 AND
		CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
</cfquery>
<!---
<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:97%;">
  	<tr style="height:35px;">
    	<td class="headbold">Çek Giriş Bordrosu</td>
  	</tr>
</table>
<cfoutput>
<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:97%;">
	<tr class="color-border">
		<td>
			<table cellpadding="2" cellspacing="1" name="table1" id="table1" border="0" style="width:100%;">
				<tr class="color-row">
					<td>
						<table>
                            <tr style="height:20px;">
                                <td class="txtbold" style="width:60px;"><cf_get_lang no ='1256.Bordro No'></td>
                                <td style="width:100px;">: <cfif len(get_action_detail.payroll_no)>#get_action_detail.payroll_no#</cfif></td>
                                <td class="txtbold" style="width:,60px;"><cf_get_lang_main no ='330.Tarih'></td>
                                <td>:<cfif get_action_detail.recordcount>#dateformat(get_action_detail.payroll_revenue_date,'dd/mm/yyyy')#</cfif></td>
                            </tr>
                            <tr style="height:20px;">
                                <td class="txtbold"><cf_get_lang_main no='108.Kasa'></td>
                                <td>:
									<cfset cash_id=get_action_detail.payroll_cash_id>
                                    <cfinclude template="../query/get_action_cash.cfm">
                                    #get_action_cash.cash_name# 
                                </td>
                                <td class="txtbold"><cf_get_lang_main no='162.Firma'></td>
                                <td>: #get_par_info(get_action_detail.company_id,1,1,0)#</td>
                            </tr>
                            <tr>
                            	<td colspan="4" class="txtbold"><cf_get_lang_main no='71.Kayıt'>:#get_emp_info(get_action_detail.record_emp,0,0)#&nbsp;#dateformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'HH:MM')#</td>
							</tr>
						</table>
					</td>
				</tr>
                <tr class="color-row">
                	<td>
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
                            <cfloop query="get_cheque_detail">
                                <tr>
                                    <td>#cheque_no#</td>
                                    <td>#bank_name#</td>
                                    <td>#bank_branch_name#</td>
                                    <td>#DateFormat(cheque_duedate,'dd/mm/yyyy')#</td>
                                    <td>#tlformat(cheque_value)# #currency_id#</td>
                                    <td>#tlformat(other_money_value)# #other_money#</td>
                                </tr>
                                <tr>
                                	<td colspan="6" style="vertical-align:top;"><hr></td>
                                </tr>
                            </cfloop>
                        </table>
						<!--- Çek Liste --->
                        <br/>>
                        </cfoutput>
                        <table style="width:650px;">
                        	<tr>
                        		<td  style="text-align:right;">
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
<cfoutput>
    <hgroup class="finance_display" style="height:50%">
        <h3>Çek Giriş Bordrosu</h3>
        <div class="colmn_left">
            <div class="area_colmn">
                <label><cf_get_lang dictionary_id ='35577.Bordro No'></label>
                <span>: <cfif len(get_action_detail.payroll_no)>#get_action_detail.payroll_no#</cfif></span>
            </div>
            <div class="area_colmn">
                <label><cf_get_lang_main no='108.Kasa'></label>
                <span>:
                    <cfset cash_id=get_action_detail.payroll_cash_id>
                    <cfinclude template="../query/get_action_cash.cfm">
                    #get_action_cash.cash_name#
                </span>
            </div>
        </div>
        <div class="colmn_left">
            <div class="area_colmn">
                <label><cf_get_lang_main no ='330.Tarih'></label>
                <span>: <cfif get_action_detail.recordcount>#dateformat(get_action_detail.payroll_revenue_date,'dd/mm/yyyy')#</cfif></span>
            </div>
            <div class="area_colmn">
                <label><cf_get_lang_main no='162.Firma'></label>
                <span>: #get_par_info(get_action_detail.company_id,1,1,0)#</span>
            </div>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang_main no='71.Kayıt'></label>
            <span>: #get_emp_info(get_action_detail.record_emp,0,0)#&nbsp;#dateformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_action_detail.record_date),'HH:MM')#</span>
        </div>
        <div class="clear_area"></div>
        <table class="objects2_list">
            <thead>
                <tr>
                    <th><cf_get_lang_main no ='595.Çek'> No</th>
                    <th><cf_get_lang_main no='109.Banka'></th>
                    <th><cf_get_lang_main no='41.Şube'></th>
                    <th><cf_get_lang_main no='228.Vade'></th>
                    <th><cf_get_lang dictionary_id ='50272.İşlem Para Br'></th>
                    <th><cf_get_lang_main no='765.Sistem Para Br'></th>
                </tr>
            </thead>
            <tbody>
                <cfloop query="get_cheque_detail">
                    <tr>
                        <td>#cheque_no#</td>
                        <td>#bank_name#</td>
                        <td>#bank_branch_name#</td>
                        <td>#DateFormat(cheque_duedate,'dd/mm/yyyy')#</td>
                        <td>#tlformat(cheque_value)# #currency_id#</td>
                        <td>#tlformat(other_money_value)# #other_money#</td>
                    </tr>
                </cfloop>
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
                <label><cf_get_lang dictionary_id ='35573.Tahsil Eden'></label><span>: <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfoutput>#get_emp_info(attributes.emp_id,0,0)#</cfoutput></cfif></span>
            </div>
            <div class="area_colmn">
                <label><cf_get_lang_main no='80.Toplam'></label><span>: <cfoutput>#TLFormat(get_action_detail.payroll_total_value)# #get_money_rate.money#</cfoutput></span>
            </div>
        </div>
    </hgroup>
</cfoutput>
