<cfinclude template="../../../invoice/query/control_bill_no.cfm">
<cfset payroll_id_list = valuelist(get_puantaj_rows.account_bill_type_)>
<cfquery name="GET_ACCOUNTS" datasource="#dsn#">
	SELECT 
    	PAYROLL_ID, 
        DEFINITION, 
        RECORD_EMP, 
        UPDATE_EMP, 
        RECORD_IP, 
        UPDATE_IP, 
        RECORD_DATE, 
        UPDATE_DATE 
    FROM 
	    SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF 
    WHERE 
    	PAYROLL_ID IN (#payroll_id_list#)
</cfquery>
<cfif not get_accounts.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='59575.Çalışan Muhasebe Tanımları Bulunamadı. Lütfen Kayıtları Kontrol Ediniz'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
	<cfset action_table = 'EMPLOYEES_PUANTAJ_VIRTUAL'>
<cfelse>
	<cfset action_table = 'EMPLOYEES_PUANTAJ'>
</cfif>
<cfquery name="get_project_rates" datasource="#dsn#">
	SELECT
		PROJECT_ID,
		RATE,
		ACCOUNT_BILL_TYPE
	FROM
		PROJECT_ACCOUNT_RATES PA,
		PROJECT_ACCOUNT_RATES_ROW PAR
	WHERE
		PA.PROJECT_RATE_ID = PAR.PROJECT_RATE_ID
		AND PA.YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
		AND PA.MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
</cfquery>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT IS_ACCOUNT_GROUP FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#account_process_cat#">
</cfquery>
<cfset puantaj_act_date = CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.SAL_MON,puantaj_gun_))>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="get_employee_no_accounts" datasource="#new_dsn2#">
			SELECT 
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				EI.START_DATE,
				EI.FINISH_DATE
			FROM 
				#dsn_alias#.EMPLOYEES_IN_OUT EI,
				#dsn_alias#.EMPLOYEES E
			WHERE 
				EI.IN_OUT_ID IN (#in_out_list#) AND 
				EI.IN_OUT_ID NOT IN (SELECT EIOP.IN_OUT_ID FROM #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD EIOP WHERE EIOP.ACCOUNT_BILL_TYPE IS NOT NULL AND EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#">) AND
				EI.EMPLOYEE_ID = E.EMPLOYEE_ID
			ORDER BY
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME
		</cfquery>
		<cfquery name="get_employee_accounts" datasource="#new_dsn2#">
			SELECT DISTINCT
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				EI.START_DATE,
				EI.FINISH_DATE,
				SA.DEFINITION,
				EIOP.ACCOUNT_BILL_TYPE
			FROM 
				#dsn_alias#.EMPLOYEES_IN_OUT EI,
				#dsn_alias#.EMPLOYEES_IN_OUT_PERIOD EIOP,
				#dsn_alias#.EMPLOYEES E,
				#dsn_alias#.SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF SA
			WHERE 
				EI.IN_OUT_ID IN (#in_out_list#) AND 
				EIOP.ACCOUNT_BILL_TYPE IS NOT NULL AND
				EIOP.IN_OUT_ID = EI.IN_OUT_ID AND
				EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#new_period_id#"> AND
				EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				SA.PAYROLL_ID = EIOP.ACCOUNT_BILL_TYPE	
			ORDER BY
				SA.DEFINITION,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME
		</cfquery>
		<cfset control_acc_type = 0>
		<cf_seperator title="#getLang('','Muhasebe Hesap Tanımı Olmayan Çalışanlar','53413')#" id="emp_no_acc">
		<cf_grid_list id="emp_no_acc">
			<thead>
				<tr>
					<th width="200"><cf_get_lang dictionary_id ='57576.Çalışan'></th>
					<th width="75"><cf_get_lang dictionary_id ='57501.Başlangıç'></th>
					<th width="75"><cf_get_lang dictionary_id ='57502.Bitiş'></th>
				</tr>
			</thead>
			<cfif get_employee_no_accounts.recordcount>
				<cfset control_acc_type = 1>
				<cfoutput query="get_employee_no_accounts">
					<tbody>
						<tr>
							<td>#employee_name# #employee_surname#</td>
							<td>#dateformat(start_date,dateformat_style)#</td>
							<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
						</tr>
					</tbody>
				</cfoutput>
			<cfelse>
				<tbody>
					<tr>
						<td colspan="3"><cf_get_lang dictionary_id ='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</tbody>
			</cfif>
		</cf_grid_list>
		
		<cf_seperator title="#getLang('','Muhasebe Hesap Tanımı Olan Çalışanlar','53520')#" id="item_emp_acc">
		<cf_grid_list id="item_emp_acc">
			<thead>
				<tr>
					<th width="200"><cf_get_lang dictionary_id ='58233.Tanım'></th>
					<th width="200"><cf_get_lang dictionary_id ='57576.Çalışan'></th>
					<th width="75"><cf_get_lang dictionary_id ='57501.Başlangıç'></th>
					<th width="75"><cf_get_lang dictionary_id ='57502.Bitiş'></th>
				</tr>
			</thead>
			<cfif get_employee_accounts.recordcount>
				<cfoutput query="get_employee_accounts">
					<tbody>
						<tr>
							<td>#definition#</td>
							<td>#employee_name# #employee_surname#</td>
							<td>#dateformat(start_date,dateformat_style)#</td>
							<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
						</tr>
					</tbody>
				</cfoutput>
			<cfelse>
				<tbody>
					<tr>
						<td colspan="4"><cf_get_lang dictionary_id ='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</tbody>
			</cfif>
		</cf_grid_list>

		
		<cfif xml_control_account_type eq 1 and control_acc_type eq 1><!--- xml de Muhasebe Kod Grubu Tanımlı Olmayan Çalışanlar Kontrol Edilsin mi? evet seçili ve muhasebe kod grubu olmayan çalışan varsa kayıt yapılmaacak --->
			<table>
				<tr height="25" class="formbold">
					<td colspan="4"><font color="red"><cf_get_lang dictionary_id="59576.Muhasebe Kod Grubu Olmayan Çalışanlar Mevcut , Lütfen Kayıtları Kontrol Ediniz."></font></td>
				</tr>
			</table>	
		<cfelse>
			<table>
				<tr height="25" class="formbold">
					<td colspan="2"><cf_get_lang dictionary_id ='53521.Muhasebe Aktarım Durumu'></td>
				</tr>
				<tr class="txtboldblue">
					<td width="200"><cf_get_lang dictionary_id='58233.Tanım'></td>
					<td><cf_get_lang dictionary_id ='57556.Bilgi'></td>
				</tr>
				<cfscript>
					DETAIL_1 = '#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# Personel Maaş Tahakkuku';
					str_borclu_hesaplar = '';
					str_borclu_tutarlar = '';
					str_alacakli_hesaplar = '';
					str_alacakli_tutarlar = '';
					/*str_borclu_tutarlar_other = '';
					str_borclu_tutarlar_money = '';
					str_alacakli_tutarlar_other = '';	
					str_alacakli_tutarlar_money = '';*/
					borclu_project_list = '';
					alacakli_project_list = '';
					satir_detay_list = ArrayNew(2);
					sira_alacak_ = 0;
					sira_borc_ = 0;
				</cfscript>
                <!---<cfquery name="get_money" dbtype="query">
                	SELECT DISTINCT MONEY_ FROM get_puantaj_rows
                </cfquery>--->
				<cfoutput query="GET_ACCOUNTS">
					<cfquery name="get_account_rows" datasource="#new_dsn2#">
						SELECT * FROM #dsn_alias#.SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS WHERE PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PAYROLL_ID#"> AND ISNULL(IS_EXPENSE,0) = 0
					</cfquery>
					                
					<cfquery name="get_project_rates_row" dbtype="query">
						SELECT 
							* 
						FROM 
							get_project_rates 
						WHERE 
							ACCOUNT_BILL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#PAYROLL_ID#">
					</cfquery>
                   <!--- <cfloop query="get_money">--->
						<cfscript>
                            borclu_list = '';
                            borclu_name_list = '';
                            alacakli_list = '';
                            alacakli_name_list = '';
                            alacakli_detail_list = '';
                            borc_deger_ = '';
                            /*borc_deger_other_ = '';
                            borc_money_other_ = '';*/
                            borclu_detail_list = '';
                            alacak_deger_ = '';
                           /* alacak_deger_other_ = '';
                            alacak_money_other_ = '';*/
                            alacak_pay_id = '';
                            borc_pay_id = '';
                            alacak_pay_id_net = '';
                            borc_pay_id_net = '';
                            alacakli_rate_list='';
                            borclu_rate_list='';
                        	if(account_card_type eq 0)
							{
                                sira_alacak_ = 0;
                                sira_borc_ = 0;
                                satir_detay_list = ArrayNew(2);
                                borclu_project_list = '';
                                alacakli_project_list = '';
							}
                        </cfscript>					
                        <cfloop query="get_account_rows">
                            <cfif PUANTAJ_BORC_ALACAK eq 1>
                                <cfif len(is_project) and is_project eq 1>
                                    <cfloop query="get_project_rates_row">
                                        <cfset sira_alacak_ = sira_alacak_ + 1>
                                        <cfset alacakli_list = listappend(alacakli_list,'#get_account_rows.ACCOUNT_CODE#')>
                                        <cfset alacakli_detail_list = listappend(alacakli_detail_list,'#get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#')>
                                        <cfset alacakli_name_list = listappend(alacakli_name_list,'#get_account_rows.PUANTAJ_ACCOUNT#')>
                                        <cfset alacakli_project_list = listappend(alacakli_project_list,get_project_rates_row.project_id)>
                                        <cfset alacakli_rate_list = listappend(alacakli_rate_list,get_project_rates_row.rate)>
                                        <cfset alacak_deger_ = listappend(alacak_deger_,0)>
                                       <!--- <cfset alacak_deger_other_ = listappend(alacak_deger_other_,0)>
                                        <cfset alacak_money_other_ = listappend(alacak_money_other_,0)>--->
                                        <cfif len(get_account_rows.comment_pay_id)>
                                            <cfif get_account_rows.is_net eq 1>
                                                <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,get_account_rows.comment_pay_id)>
                                                <cfset alacak_pay_id = listappend(alacak_pay_id,0)>
                                            <cfelse>
                                                <cfset alacak_pay_id = listappend(alacak_pay_id,get_account_rows.comment_pay_id)>
                                                <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,0)>
                                            </cfif>
                                        <cfelse>
                                            <cfset alacak_pay_id = listappend(alacak_pay_id,0)>
                                            <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,0)>
                                        </cfif>
                                        <cfif get_process_type.is_account_group eq 0>
                                            <cfset satir_detay_list[2][sira_alacak_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
                                        <cfelse>
                                            <cfset satir_detay_list[2][sira_alacak_]=detail_1&'(#get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#)'>
                                        </cfif>
                                    </cfloop>
                                <cfelse>
                                    <cfset sira_alacak_ = sira_alacak_ + 1>
                                    <cfset alacakli_list = listappend(alacakli_list,'#ACCOUNT_CODE#')>
                                    <cfset alacakli_detail_list = listappend(alacakli_detail_list,'#PUANTAJ_ACCOUNT_DEFINITION#')>
                                    <cfset alacakli_name_list = listappend(alacakli_name_list,'#PUANTAJ_ACCOUNT#')>
                                    <cfset alacakli_project_list = listappend(alacakli_project_list,0)>
                                    <cfset alacakli_rate_list = listappend(alacakli_rate_list,100)>
                                    <cfset alacak_deger_ = listappend(alacak_deger_,0)>
                                   <!--- <cfset alacak_deger_other_ = listappend(alacak_deger_other_,0)>
                                    <cfset alacak_money_other_ = listappend(alacak_money_other_,0)>--->
                                    <cfif len(get_account_rows.comment_pay_id)>
                                        <cfif get_account_rows.is_net eq 1>
                                            <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,get_account_rows.comment_pay_id)>
                                            <cfset alacak_pay_id = listappend(alacak_pay_id,0)>
                                        <cfelse>
                                            <cfset alacak_pay_id = listappend(alacak_pay_id,get_account_rows.comment_pay_id)>
                                            <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,0)>
                                        </cfif>
                                    <cfelse>
                                        <cfset alacak_pay_id = listappend(alacak_pay_id,0)>
                                        <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,0)>
                                    </cfif>
                                    <cfif get_process_type.is_account_group eq 0>
                                        <cfset satir_detay_list[2][sira_alacak_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
                                    <cfelse>
                                        <cfset satir_detay_list[2][sira_alacak_]=detail_1&'(#get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#)'>
                                    </cfif>
                                </cfif>
                            <cfelse>
                                <cfif len(is_project) and is_project eq 1>
                                    <cfloop query="get_project_rates_row">
                                        <cfset sira_borc_ = sira_borc_ + 1>
                                        <cfset borclu_list = listappend(borclu_list,'#get_account_rows.ACCOUNT_CODE#')>
                                        <cfset borclu_detail_list = listappend(borclu_detail_list,'#get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#')>
                                        <cfset borclu_name_list = listappend(borclu_name_list,'#get_account_rows.PUANTAJ_ACCOUNT#')>
                                        <cfset borclu_project_list = listappend(borclu_project_list,get_project_rates_row.project_id)>
                                        <cfset borclu_rate_list = listappend(borclu_rate_list,get_project_rates_row.rate)>
                                        <cfset borc_deger_ = listappend(borc_deger_,0)>
                                        <!---<cfset borc_deger_other_ = listappend(borc_deger_other_,0)>
                                        <cfset borc_money_other_ = listappend(borc_money_other_,0)>--->
                                        <cfif len(get_account_rows.comment_pay_id)>
                                            <cfif get_account_rows.is_net eq 1>
                                                <cfset borc_pay_id_net = listappend(borc_pay_id_net,get_account_rows.comment_pay_id)>
                                                <cfset borc_pay_id = listappend(borc_pay_id,0)>
                                            <cfelse>
                                                <cfset borc_pay_id = listappend(borc_pay_id,get_account_rows.comment_pay_id)>
                                                <cfset borc_pay_id_net = listappend(borc_pay_id_net,0)>
                                            </cfif>
                                        <cfelse>
                                            <cfset borc_pay_id = listappend(borc_pay_id,0)>
                                            <cfset borc_pay_id_net = listappend(borc_pay_id_net,0)>
                                        </cfif>
                                        <cfif get_process_type.is_account_group eq 0>
                                            <cfset satir_detay_list[1][sira_borc_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
                                        <cfelse>
                                            <cfset satir_detay_list[1][sira_borc_]=detail_1&'(#get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#)'>
                                        </cfif>
                                    </cfloop>
                                <cfelse>
                                    <cfset sira_borc_ = sira_borc_ + 1>
                                    <cfset borclu_list = listappend(borclu_list,'#ACCOUNT_CODE#')>
                                    <cfset borclu_detail_list = listappend(borclu_detail_list,'#PUANTAJ_ACCOUNT_DEFINITION#')>
                                    <cfset borclu_name_list = listappend(borclu_name_list,'#PUANTAJ_ACCOUNT#')>
                                    <cfset borclu_project_list = listappend(borclu_project_list,0)>
                                    <cfset borclu_rate_list = listappend(borclu_rate_list,100)>
                                    <cfset borc_deger_ = listappend(borc_deger_,0)>
                                    <!---<cfset borc_deger_other_ = listappend(borc_deger_other_,0)>
                                    <cfset borc_money_other_ = listappend(borc_money_other_,0)>--->
                                    <cfif len(get_account_rows.comment_pay_id)>
                                        <cfif get_account_rows.is_net eq 1>
                                            <cfset borc_pay_id_net = listappend(borc_pay_id_net,get_account_rows.comment_pay_id)>
                                            <cfset borc_pay_id = listappend(borc_pay_id,0)>
                                        <cfelse>
                                            <cfset borc_pay_id = listappend(borc_pay_id,get_account_rows.comment_pay_id)>
                                            <cfset borc_pay_id_net = listappend(borc_pay_id_net,0)>
                                        </cfif>
                                    <cfelse>
                                        <cfset borc_pay_id = listappend(borc_pay_id,0)>
                                        <cfset borc_pay_id_net = listappend(borc_pay_id_net,0)>
                                    </cfif>
                                    <cfif get_process_type.is_account_group eq 0>
                                        <cfset satir_detay_list[1][sira_borc_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
                                    <cfelse>
                                        <cfset satir_detay_list[1][sira_borc_]=detail_1&'(#get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#)'>
                                    </cfif>
                                </cfif>
                            </cfif>
                        </cfloop>
                        <cfquery name="get_account_puantaj" dbtype="query">
                            SELECT 
                                * 
                            FROM 
                                get_puantaj_rows 
                            WHERE 
                                ACCOUNT_BILL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ACCOUNTS.PAYROLL_ID#">
                                <!---AND MONEY_ = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_money.MONEY_#">--->
                        </cfquery>
                        
                        <cfquery name="get_account_inout" dbtype="query">
                            SELECT 
                                * 
                            FROM 
                                get_employee_accounts 
                            WHERE 
                                ACCOUNT_BILL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ACCOUNTS.PAYROLL_ID#">
                        </cfquery>
                        <cfloop query="get_account_puantaj">
                            <cfset sira_ = 0>
                            <cfset money_ = get_account_puantaj.money_>
                            <cfloop list="#alacakli_name_list#" index="alacak_">
                                <cfset sira_ = sira_ + 1>
                                <cfset deger_ = listgetat(alacak_deger_,sira_)>
                                <cfset deger_kontrol = listgetat(alacak_pay_id,sira_)>
                                <cfset deger_kontrol2 = listgetat(alacak_pay_id_net,sira_)>
                                <cfset deger_rate = listgetat(alacakli_rate_list,sira_)>
                                <cfif deger_kontrol eq 0 and deger_kontrol2 eq 0 and len(evaluate("get_account_puantaj.#alacak_#"))>
                                    <cfset new_deger_ = deger_ + (evaluate("get_account_puantaj.#alacak_#")*deger_rate/100)>
                                    <!---<cfset alacak_deger_ = listsetat(alacak_deger_,sira_,new_deger_*get_account_puantaj.amount_rate)>--->
                                    <cfset alacak_deger_ = listsetat(alacak_deger_,sira_,new_deger_)>
                                    <!---<cfset alacak_deger_other_ = listsetat(alacak_deger_other_,sira_,new_deger_)>
                                    <cfset alacak_money_other_ = listsetat(alacak_money_other_,sira_,money_)>--->
                                </cfif>
                            </cfloop>
                            
                            <cfset sira_ = 0>
                            <cfloop list="#borclu_name_list#" index="alacak_">
                                <cfset sira_ = sira_ + 1>
                                <cfset deger_ = listgetat(borc_deger_,sira_)>
                                <cfset deger_kontrol = listgetat(borc_pay_id,sira_)>
                                <cfset deger_kontrol2 = listgetat(borc_pay_id_net,sira_)>
                                <cfset deger_rate = listgetat(borclu_rate_list,sira_)>
                                <cfif deger_kontrol eq 0 and deger_kontrol2 eq 0 and len(evaluate("get_account_puantaj.#alacak_#"))>
                                    <cfset new_deger_ = deger_ + (evaluate("get_account_puantaj.#alacak_#")*deger_rate/100)>
                                    <!---<cfset borc_deger_ = listsetat(borc_deger_,sira_,new_deger_*get_account_puantaj.amount_rate)>--->
                                    <cfset borc_deger_ = listsetat(borc_deger_,sira_,new_deger_)>
									<!---<cfset borc_deger_other_ = listsetat(borc_deger_other_,sira_,new_deger_)>
                                    <cfset borc_money_other_ = listsetat(borc_money_other_,sira_,money_)>--->
                                </cfif>
                            </cfloop>
                            
                            <cfset sira_ = 0>
                            <cfloop list="#alacak_pay_id#" index="alacak_">
                                <cfset sira_ = sira_ + 1>
                                <cfset deger_ = listgetat(alacak_pay_id,sira_)>
                                <cfset new_deger_ = listgetat(alacak_deger_,sira_)>
                                <cfset deger_rate = listgetat(alacakli_rate_list,sira_)>
                                <cfif deger_ neq 0>
                                    <cfquery name="get_ext_puantaj" datasource="#new_dsn2#">
                                        SELECT #dsn_alias#.IS_ZERO(AMOUNT_2,AMOUNT) AMOUNT_ FROM #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#deger_#"> AND EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_puantaj.employee_puantaj_id#">
                                    </cfquery>
                                    <cfloop query="get_ext_puantaj">
                                        <cfset new_deger_ = new_deger_ + (get_ext_puantaj.AMOUNT_*deger_rate/100)>
                                    </cfloop>
                                    <cfset alacak_deger_ = listsetat(alacak_deger_,sira_,new_deger_)>
                                    <!---<cfset alacak_deger_other_ = listsetat(alacak_deger_other_,sira_,new_deger_)>
                                    <cfset alacak_money_other_ = listsetat(alacak_money_other_,sira_,session.ep.money)>--->
                                </cfif>
                            </cfloop>
                            <cfset sira_ = 0>
                            <cfloop list="#borc_pay_id#" index="borc_">
                                <cfset sira_ = sira_ + 1>
                                <cfset deger_ = listgetat(borc_pay_id,sira_)>
                                <cfset new_deger_ = listgetat(borc_deger_,sira_)>
                                <cfset deger_rate = listgetat(borclu_rate_list,sira_)>
                                <cfif deger_ neq 0>
                                    <cfquery name="get_ext_puantaj" datasource="#new_dsn2#">
                                        SELECT #dsn_alias#.IS_ZERO(AMOUNT_2,AMOUNT) AMOUNT_ FROM #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#deger_#"> AND EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_puantaj.employee_puantaj_id#">
                                    </cfquery>
                                    <cfloop query="get_ext_puantaj">
                                        <cfset new_deger_ = new_deger_ + (get_ext_puantaj.AMOUNT_*deger_rate/100)>
                                    </cfloop>
                                    <cfset borc_deger_ = listsetat(borc_deger_,sira_,new_deger_)>
                                    <!---<cfset borc_deger_other_ = listsetat(borc_deger_other_,sira_,new_deger_)>
                                    <cfset borc_money_other_ = listsetat(borc_money_other_,sira_,session.ep.money)>--->
                                </cfif>
                            </cfloop>
                            <cfset sira_ = 0>
                            <cfloop list="#alacak_pay_id_net#" index="alacak_">
                                <cfset sira_ = sira_ + 1>
                                <cfset deger_ = listgetat(alacak_pay_id_net,sira_)>
                                <cfset new_deger_ = listgetat(alacak_deger_,sira_)>
                                <cfset deger_rate = listgetat(alacakli_rate_list,sira_)>
                                <cfif deger_ neq 0>
                                    <cfquery name="get_ext_puantaj" datasource="#new_dsn2#">
                                        SELECT ISNULL(AMOUNT_PAY,0) AMOUNT_PAY FROM #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#deger_#"> AND EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_puantaj.employee_puantaj_id#">
                                    </cfquery>
                                    <cfloop query="get_ext_puantaj">
                                        <cfset new_deger_ = new_deger_ + wrk_round(wrk_round(get_ext_puantaj.amount_pay,2)*deger_rate/100,2)>
                                    </cfloop>
                                    <cfset alacak_deger_ = listsetat(alacak_deger_,sira_,new_deger_)>
                                    <!---<cfset alacak_deger_other_ = listsetat(alacak_deger_other_,sira_,new_deger_)>
                                    <cfset alacak_money_other_ = listsetat(alacak_money_other_,sira_,session.ep.money)>--->
                                </cfif>
                            </cfloop>
                            <cfset sira_ = 0>
                            <cfloop list="#borc_pay_id_net#" index="borc_">
                                <cfset sira_ = sira_ + 1>
                                <cfset deger_ = listgetat(borc_pay_id_net,sira_)>
                                <cfset new_deger_ = listgetat(borc_deger_,sira_)>
                                <cfset deger_rate = listgetat(borclu_rate_list,sira_)>
                                <cfif deger_ neq 0>
                                    <cfquery name="get_ext_puantaj" datasource="#new_dsn2#">
                                        SELECT ISNULL(AMOUNT_PAY,0) AMOUNT_PAY FROM #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#deger_#"> AND EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_puantaj.employee_puantaj_id#">
                                    </cfquery>
                                    <cfloop query="get_ext_puantaj">
                                        <cfset new_deger_ = new_deger_ + wrk_round(wrk_round(get_ext_puantaj.amount_pay,2)*deger_rate/100,2)>
                                    </cfloop>
                                    <cfset borc_deger_ = listsetat(borc_deger_,sira_,new_deger_)>
                                    <!---<cfset borc_deger_other_ = listsetat(borc_deger_other_,sira_,new_deger_)>
                                    <cfset borc_money_other_ = listsetat(borc_money_other_,sira_,session.ep.money)>--->
                                </cfif>
                            </cfloop>
                        </cfloop>

                   <!--- </cfloop>--->
					<cfif account_card_type eq 0>
						<cfscript>
							str_borclu_hesaplar = borclu_list;
							str_borclu_tutarlar = borc_deger_;
							/*str_borclu_tutarlar_other = borc_deger_other_;
							str_borclu_tutarlar_money = borc_money_other_;*/
							str_alacakli_hesaplar = alacakli_list;
							str_alacakli_tutarlar = alacak_deger_;						
							/*str_alacakli_tutarlar_other = alacak_deger_other_;
							str_alacakli_tutarlar_money = alacak_money_other_;*/
							
							/*writeoutput('#str_alacakli_tutarlar#\n');
							writeoutput('#str_alacakli_hesaplar#\n');
							writeoutput('#str_borclu_tutarlar#\n');
							abort(str_borclu_hesaplar);*/
							GET_NO_ = cfquery(datasource:"#new_dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
							//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
							str_fark_gelir =GET_NO_.FARK_GELIR;
							str_fark_gider =GET_NO_.FARK_GIDER;
							str_max_round = 0.9;
							acc_flag=muhasebeci(
								action_id :attributes.PUANTAJ_ID,
								workcube_process_type : 130,
								workcube_process_cat : account_process_cat,
								account_card_type : 13,
								action_table : action_table,
								islem_tarihi : puantaj_act_date,
								borc_hesaplar : str_borclu_hesaplar,
								borc_tutarlar : str_borclu_tutarlar,
								/*other_amount_borc : str_borclu_tutarlar_other,
								other_currency_borc : str_borclu_tutarlar_money,*/
								alacak_hesaplar : str_alacakli_hesaplar,
								alacak_tutarlar : str_alacakli_tutarlar,
								/*other_amount_alacak : str_alacakli_tutarlar_other,
								other_currency_alacak : str_alacakli_tutarlar_money,*/
								from_branch_id : get_puantaj_branch.branch_id,
								fis_detay : "#DETAIL_1#",
								fis_satir_detay : satir_detay_list,
								muhasebe_db:new_dsn2,
								acc_project_list_borc : borclu_project_list,
								acc_project_list_alacak : alacakli_project_list,
								dept_round_account :str_fark_gider,
								claim_round_account : str_fark_gelir,
								max_round_amount :str_max_round,
								round_row_detail:DETAIL_1,
								dsn3_alias:new_dsn3_alias,
								is_account_group : get_process_type.is_account_group//,
								//currency_multiplier : get_puantaj_rows.AMOUNT_RATE_2
							);
						</cfscript>
						<cfif acc_flag>
							<cfquery name="UPD_PUANTAJ_MUHASEBE_STATUS" datasource="#new_dsn2#">
								UPDATE
									#dsn_alias#.#main_puantaj_table#
								SET
									IS_ACCOUNT = 1
								WHERE
									PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#">
							</cfquery>
						</cfif>
					<cfelse>
						<cfscript>
							str_borclu_hesaplar = listappend(str_borclu_hesaplar,borclu_list);
							str_borclu_tutarlar = listappend(str_borclu_tutarlar,borc_deger_);
							/*str_borclu_tutarlar_other = listappend(str_borclu_tutarlar_other,borc_deger_other_);
							str_borclu_tutarlar_money = listappend(str_borclu_tutarlar_money,borc_money_other_);*/
							str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,alacakli_list);
							str_alacakli_tutarlar = listappend(str_alacakli_tutarlar,alacak_deger_);	
							/*str_alacakli_tutarlar_other = listappend(str_alacakli_tutarlar_other,alacak_deger_other_);	
							str_alacakli_tutarlar_money = listappend(str_alacakli_tutarlar_money,alacak_money_other_);*/
						</cfscript>
					</cfif>
					<tr>
						<td>#definition#</td>
						<td><font color="FF0000"><cf_get_lang dictionary_id ='53535.Muhasebe Aktarımı Başarıyla Yapıldı'>!</font></td>
					</tr>
				</cfoutput>
                
				<cfif account_card_type eq 1>
					<cfscript>
						GET_NO_ = cfquery(datasource:"#new_dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
						//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
						str_fark_gelir =GET_NO_.FARK_GELIR;
						str_fark_gider =GET_NO_.FARK_GIDER;
						str_max_round = 2;
						acc_flag=muhasebeci(
							action_id :attributes.PUANTAJ_ID,
							workcube_process_type : 130,
							workcube_process_cat : account_process_cat,
							account_card_type : 13,
							action_table : action_table,
							islem_tarihi : puantaj_act_date,
							borc_hesaplar : str_borclu_hesaplar,
							borc_tutarlar : str_borclu_tutarlar,
							/*other_amount_borc : str_borclu_tutarlar_other,
							other_currency_borc : str_borclu_tutarlar_money,*/
							alacak_hesaplar : str_alacakli_hesaplar,
							alacak_tutarlar : str_alacakli_tutarlar,
							/*other_amount_alacak : str_alacakli_tutarlar_other,
							other_currency_alacak : str_alacakli_tutarlar_money,*/
							from_branch_id : get_puantaj_branch.branch_id,
							fis_detay : "#DETAIL_1#",
							fis_satir_detay : satir_detay_list,
							muhasebe_db:new_dsn2,
							acc_project_list_borc : borclu_project_list,
							acc_project_list_alacak : alacakli_project_list,
							dept_round_account :str_fark_gider,
							claim_round_account : str_fark_gelir,
							max_round_amount :str_max_round,
							round_row_detail:DETAIL_1,
							dsn3_alias:new_dsn3_alias,
							is_account_group : get_process_type.is_account_group//,
							//currency_multiplier : get_puantaj_rows.AMOUNT_RATE_2
						);
					</cfscript>
					<cfif acc_flag>
						<cfquery name="UPD_PUANTAJ_MUHASEBE_STATUS" datasource="#new_dsn2#">
							UPDATE
								#dsn_alias#.#main_puantaj_table#
							SET
								IS_ACCOUNT = 1
							WHERE
								PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#">
						</cfquery>
					</cfif>
				</cfif>
			</table>
			<cfquery name="get_puantaj_ext" datasource="#new_dsn2#">
				SELECT 
					----EPR.ACCOUNT_CODE EMP_ACC_CODE,
                    CASE WHEN
                    	 LEN(EPR.ACCOUNT_CODE) > 0 THEN EPR.ACCOUNT_CODE 
                    ELSE 
                    	(SELECT TOP 1 EA.ACCOUNT_CODE FROM #dsn_alias#.EMPLOYEES_ACCOUNTS EA INNER JOIN #dsn_alias#.SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = EA.ACC_TYPE_ID WHERE EA.IN_OUT_ID = EPR.IN_OUT_ID AND (SA.IS_SALARY_ACCOUNT = 1 OR SA.ACC_TYPE_ID = -1) AND EA.PERIOD_ID = #session.ep.period_id#)	 <!--- çalışan muhasebe kodu boş ise maaş tipli cari hesap tipinin hesap kodunu alacak SG20160107--->	
                    END AS EMP_ACC_CODE,   
					EPR.IN_OUT_ID,
					EPR.EMPLOYEE_ID,
					E.EMPLOYEE_ID,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME,
					ISNULL(EPRE.ACCOUNT_CODE,(SELECT TOP 1 EA.ACCOUNT_CODE FROM #dsn_alias#.EMPLOYEES_ACCOUNTS EA WHERE EA.IN_OUT_ID = EPR.IN_OUT_ID AND EA.PERIOD_ID=#session.ep.period_id# AND EA.ACC_TYPE_ID = EPRE.ACC_TYPE_ID)) ACCOUNT_CODE_,
					EPRE.* ,
					#dsn_alias#.IS_ZERO(AMOUNT_2,AMOUNT) AMOUNT_
				FROM 
					#dsn_alias#.EMPLOYEES_PUANTAJ_ROWS_EXT EPRE,
					#dsn_alias#.EMPLOYEES_PUANTAJ_ROWS EPR,
					#dsn_alias#.EMPLOYEES E
				WHERE 
					EPRE.PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PUANTAJ.PUANTAJ_ID#"> 
					AND (EPRE.ACCOUNT_CODE IS NOT NULL OR EPRE.COMPANY_ID IS NOT NULL OR EPRE.CONSUMER_ID IS NOT NULL OR EPRE.ACC_TYPE_ID IS NOT NULL)
					AND (EPRE.EXT_TYPE = 1 OR EPRE.EXT_TYPE = 3) <!--- 3=eski icra kesintisi --->
					AND EPRE.EMPLOYEE_PUANTAJ_ID = EPR.EMPLOYEE_PUANTAJ_ID
					AND E.EMPLOYEE_ID = EPR.EMPLOYEE_ID
					AND ( 
							(AMOUNT_2 <> 0 AND RELATED_TABLE= 'COMMANDMENT') 
							OR 
							(AMOUNT_2 = 0 AND RELATED_TABLE  IS NULL )
						)
			</cfquery>
			<cfif get_puantaj_ext.recordcount>
				<cfscript>
					DETAIL_1 = '#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# Personel Kesintileri';
					satir_detay_list = ArrayNew(2);
					str_borclu_hesaplar = '';
					str_borclu_tutarlar = '';
					str_alacakli_hesaplar = '';
					str_alacakli_tutarlar = '';		
				</cfscript>
				<cfoutput query="get_puantaj_ext">
					<cfset row_detail = '#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay - #get_puantaj_ext.detail# - #get_puantaj_ext.comment_pay#'>
					<cfif len(account_code_)>
						<cfscript>
							str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,'#ACCOUNT_CODE_#');
							str_alacakli_tutarlar = listappend(str_alacakli_tutarlar,wrk_round(AMOUNT_,2));
							if(get_process_type.is_account_group eq 0)
								satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#row_detail#';
							else
								satir_detay_list[2][listlen(str_alacakli_tutarlar)]='#DETAIL_1#';
							str_borclu_hesaplar = listappend(str_borclu_hesaplar,'#EMP_ACC_CODE#');
							str_borclu_tutarlar = listappend(str_borclu_tutarlar,wrk_round(AMOUNT_,2));
							if(get_process_type.is_account_group eq 0)
								satir_detay_list[1][listlen(str_borclu_tutarlar)]='#row_detail#';
							else
								satir_detay_list[1][listlen(str_borclu_tutarlar)]='#DETAIL_1#';
						</cfscript>
					</cfif>
					<cfif len(company_id)>
						<cfscript>
							wrk_amount = '';
							wrk_amount = wrk_round(AMOUNT_,2);
							carici
							(
								action_id : attributes.PUANTAJ_ID,
								process_cat : budget_process_cat,
								workcube_process_type : 161,
								action_table : action_table,
								action_detail : row_detail,
								islem_tutari : wrk_amount,
								action_currency : session.ep.money,
								islem_tarihi : puantaj_act_date,
								due_date : puantaj_act_date,
								islem_detay : 'PUANTAJ KESİNTİ TAHAKKUK FİŞİ',
								to_employee_id : employee_id,
								to_branch_id : get_puantaj_branch.branch_id,
								account_card_type : 13,
								acc_type_id : -1,
								other_money_value : amount,
								other_money : session.ep.money,
								cari_db:new_dsn2
							);
							carici
							(
								action_id : attributes.PUANTAJ_ID,
								process_cat : budget_process_cat,
								workcube_process_type : 161,
								action_detail : row_detail,
								action_table : action_table,
								islem_tutari : wrk_amount,
								action_currency : session.ep.money,
								islem_tarihi : puantaj_act_date,
								due_date : puantaj_act_date,
								islem_detay : 'PUANTAJ KESİNTİ TAHAKKUK FİŞİ',
								from_cmp_id : company_id,
								from_branch_id : get_puantaj_branch.branch_id,
								account_card_type : 13,
								acc_type_id : -1,
								other_money_value : amount,
								other_money : session.ep.money,
								cari_db:new_dsn2
							);
						</cfscript>
					<cfelseif len(consumer_id)>
						<cfscript>
							wrk_amount = '';
							wrk_amount = wrk_round(AMOUNT_,2);
							carici
							(
								action_id : attributes.PUANTAJ_ID,
								process_cat : budget_process_cat,
								workcube_process_type : 161,
								action_table : action_table,
								islem_tutari : wrk_amount,
								action_detail : row_detail,
								action_currency : session.ep.money,
								islem_tarihi : puantaj_act_date,
								due_date : puantaj_act_date,
								islem_detay : 'PUANTAJ KESİNTİ TAHAKKUK FİŞİ',
								to_employee_id : employee_id,
								to_branch_id : get_puantaj_branch.branch_id,
								account_card_type : 13,
								acc_type_id : -1,
								other_money_value : amount,
								other_money : session.ep.money,
								cari_db:new_dsn2
							);
							carici
							(
								action_id : attributes.PUANTAJ_ID,
								process_cat : budget_process_cat,
								workcube_process_type : 161,
								action_table : action_table,
								islem_tutari : wrk_amount,
								action_detail : row_detail,
								action_currency : session.ep.money,
								islem_tarihi : puantaj_act_date,
								due_date : puantaj_act_date,
								islem_detay : 'PUANTAJ KESİNTİ TAHAKKUK FİŞİ',
								from_consumer_id : consumer_id,
								from_branch_id : get_puantaj_branch.branch_id,
								account_card_type : 13,
								acc_type_id : -1,
								other_money_value : amount,
								other_money : session.ep.money,
								cari_db:new_dsn2
							);
						</cfscript>
					<cfelseif len(acc_type_id)>
						<!--- -1 maas hesabi, -2 avans hesabi --->
						<cfquery name="get_emp_account" datasource="#new_dsn2#">
							SELECT CASE WHEN EA.ACC_TYPE_ID = -1 THEN 0 ELSE 1 END AS ORDER_NUMBER,ISNULL(EA.ACC_TYPE_ID,-1) AS ACC_TYPE_ID,ISNULL(ACC.IS_SALARY_ACCOUNT,0) AS IS_SALARY_ACCOUNT FROM #dsn_alias#.EMPLOYEES_ACCOUNTS EA INNER JOIN #dsn_alias#.SETUP_ACC_TYPE ACC
                            ON EA.ACC_TYPE_ID = ACC.ACC_TYPE_ID 
                            WHERE EMPLOYEE_ID = #get_puantaj_ext.employee_id# AND IN_OUT_ID =#get_puantaj_ext.in_out_id# AND PERIOD_ID = #get_period_id.period_id# AND 
                            (
                            	ACC.ACC_TYPE_ID IN(-1,-2) OR 
                                IS_SALARY_ACCOUNT = 1 OR <!--- maaş hesabı--->
                                IS_PAYMENT_ACCOUNT = 1   <!--- avans hesabı--->
                             )
						</cfquery>
                        <cfquery name="get_maas_type" dbtype="query">
                        	SELECT 
								ACC_TYPE_ID 
							FROM 
								get_emp_account 
							WHERE 
								IS_SALARY_ACCOUNT = 1 OR 
								ACC_TYPE_ID = -1 
							ORDER BY 
								ORDER_NUMBER ASC,
								ACC_TYPE_ID ASC
						</cfquery>
						<!--- Eğer hesap tipi tanımlı geliyorsa tanımlanan hesap tipi ile çalışanın avans hesabı arasında virman yapıyoruz. --->
						<cfif get_emp_account.recordcount gte 2 and get_maas_type.recordcount>
							<cfscript>
								wrk_amount = '';
								wrk_amount = wrk_round(AMOUNT_,2);
								carici
								(
									action_id : attributes.PUANTAJ_ID,
									process_cat : budget_process_cat,
									workcube_process_type : 161,
									action_table : action_table,
									islem_tutari : wrk_amount,
									action_detail : row_detail,
									action_currency : session.ep.money,
									islem_tarihi : puantaj_act_date,
									due_date : puantaj_act_date,
									islem_detay : 'PUANTAJ KESİNTİ TAHAKKUK FİŞİ',
									to_employee_id : employee_id,
									//acc_type_id : -1,
									acc_type_id : get_maas_type.ACC_TYPE_ID,
									to_branch_id : get_puantaj_branch.branch_id,
									account_card_type : 13,
									other_money_value : amount,
									other_money : session.ep.money,
									cari_db:new_dsn2
								);
								carici
								(
									action_id : attributes.PUANTAJ_ID,
									process_cat : budget_process_cat,
									workcube_process_type : 161,
									action_table : action_table,
									islem_tutari : AMOUNT_,
									action_detail : row_detail,
									action_currency : session.ep.money,
									islem_tarihi : puantaj_act_date,
									due_date : puantaj_act_date,
									islem_detay : 'PUANTAJ KESİNTİ TAHAKKUK FİŞİ',
									from_employee_id : employee_id,
									acc_type_id : acc_type_id,
									from_branch_id : get_puantaj_branch.branch_id,
									account_card_type : 13,
									other_money_value : amount,
									other_money : session.ep.money,
									cari_db:new_dsn2
								);
							</cfscript>
						</cfif>
					</cfif>
				</cfoutput>
				<cfscript>
					acc_flag=muhasebeci(
						action_id :attributes.PUANTAJ_ID,
						workcube_process_type : 161,
						workcube_process_cat : budget_process_cat,
						account_card_type : 13,
						action_table : action_table,
						islem_tarihi : puantaj_act_date,
						borc_hesaplar : str_borclu_hesaplar,
						borc_tutarlar : str_borclu_tutarlar,
						alacak_hesaplar : str_alacakli_hesaplar,
						alacak_tutarlar : str_alacakli_tutarlar,
						from_branch_id : get_puantaj_branch.branch_id,
						fis_detay : "#DETAIL_1#",
						fis_satir_detay : satir_detay_list,
						muhasebe_db:new_dsn2,
						dsn3_alias:new_dsn3_alias,
						is_account_group : get_process_type.is_account_group//,
						//currency_multiplier : get_puantaj_rows.AMOUNT_RATE_2
					);
				</cfscript>
			</cfif>
            <!--- Harcırah bordrosu muhasebeleştirme--->
			<cfscript>
                DETAIL_1 = '#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay - #get_puantaj.SSK_OFFICE# Harcırah Bordrosu';
                str_borclu_hesaplar = '';
                str_borclu_tutarlar = '';
                str_alacakli_hesaplar = '';
                str_alacakli_tutarlar = '';
                borclu_project_list = '';
                alacakli_project_list = '';
                satir_detay_list = ArrayNew(2);
                sira_alacak_ = 0;
                sira_borc_ = 0;
            </cfscript>
			<cfscript>
                borclu_list = '';
                borclu_name_list = '';
                alacakli_list = '';
                alacakli_name_list = '';
                alacakli_detail_list = '';
                borc_deger_ = '';
                borclu_detail_list = '';
                alacak_deger_ = '';
                alacak_pay_id = '';
                borc_pay_id = '';
                alacak_pay_id_net = '';
                borc_pay_id_net = '';
                alacakli_rate_list='';
                borclu_rate_list='';
            </cfscript>
            <script type="text/javascript">
				get_wrk_message_div();
			</script>
            <cfoutput query="GET_ACCOUNTS">
				<cfquery name="get_expense_puantaj" datasource="#new_dsn2#">
					SELECT
						SUM(EMPLOYEES_EXPENSE_PUANTAJ.BRUT_AMOUNT) AS BRUT_AMOUNT,
						SUM(EMPLOYEES_EXPENSE_PUANTAJ.NET_AMOUNT) AS NET_AMOUNT,
						SUM(EMPLOYEES_EXPENSE_PUANTAJ.DAMGA_VERGISI) AS DAMGA_VERGISI,
						SUM(EMPLOYEES_EXPENSE_PUANTAJ.GELIR_VERGISI) AS GELIR_VERGISI
					FROM
						#dsn_alias#.EMPLOYEES_EXPENSE_PUANTAJ INNER JOIN #dsn_alias#.EMPLOYEES_PUANTAJ_ROWS EPR 
						ON EMPLOYEES_EXPENSE_PUANTAJ.IN_OUT_ID = EPR.IN_OUT_ID
					WHERE
						EMPLOYEES_EXPENSE_PUANTAJ.IN_OUT_ID IN(#valuelist(get_puantaj_rows.in_out_id)#) AND
						YEAR(EXPENSE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_rows.sal_year#"> AND
						MONTH(EXPENSE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_rows.sal_mon#"> AND
						EPR.PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#"> AND
						EPR.ACCOUNT_BILL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ACCOUNTS.PAYROLL_ID#">
					GROUP BY 	
						EMPLOYEES_EXPENSE_PUANTAJ.IN_OUT_ID
				</cfquery>
				<cfquery name="get_account_rows" datasource="#new_dsn2#">
					SELECT * FROM #dsn_alias#.SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS WHERE PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PAYROLL_ID#"> AND IS_EXPENSE = 1 <!--- harcırah bordro kalemleri SG 20140826--->
				</cfquery>
				<cfscript>
                    borclu_list = '';
                    borclu_name_list = '';
                    alacakli_list = '';
                    alacakli_name_list = '';
                    alacakli_detail_list = '';
                    borc_deger_ = '';
                   /* borc_deger_other_ = '';
                    borc_money_other_ = '';*/
                    borclu_detail_list = '';
                    alacak_deger_ = '';
                    /*alacak_deger_other_ = '';
                    alacak_money_other_ = '';*/
                    alacak_pay_id = '';
                    borc_pay_id = '';
                    alacak_pay_id_net = '';
                    borc_pay_id_net = '';
                    alacakli_rate_list='';
                    borclu_rate_list='';
                </cfscript>
                <cfloop query="get_account_rows">
					<cfif PUANTAJ_BORC_ALACAK eq 1>
						<cfset sira_alacak_ = sira_alacak_ + 1>
                        <cfset alacakli_list = listappend(alacakli_list,'#ACCOUNT_CODE#')>
                        <cfset alacakli_detail_list = listappend(alacakli_detail_list,'#PUANTAJ_ACCOUNT_DEFINITION#')>
                        <cfset alacakli_name_list = listappend(alacakli_name_list,'#PUANTAJ_ACCOUNT#')>
                        <cfset alacakli_project_list = listappend(alacakli_project_list,0)>
                        <cfset alacakli_rate_list = listappend(alacakli_rate_list,100)>
                        <cfset alacak_deger_ = listappend(alacak_deger_,0)>
						<cfset alacak_pay_id = listappend(alacak_pay_id,0)>
                        <cfset alacak_pay_id_net = listappend(alacak_pay_id_net,0)>
                        <cfif get_process_type.is_account_group eq 0>
                            <cfset satir_detay_list[2][sira_alacak_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
                        <cfelse>
                            <cfset satir_detay_list[2][sira_alacak_]=detail_1>
                        </cfif>
                    <cfelse>
						<cfset sira_borc_ = sira_borc_ + 1>
                        <cfset borclu_list = listappend(borclu_list,'#ACCOUNT_CODE#')>
                        <cfset borclu_detail_list = listappend(borclu_detail_list,'#PUANTAJ_ACCOUNT_DEFINITION#')>
                        <cfset borclu_name_list = listappend(borclu_name_list,'#PUANTAJ_ACCOUNT#')>
                        <cfset borclu_project_list = listappend(borclu_project_list,0)>
                        <cfset borclu_rate_list = listappend(borclu_rate_list,100)>
                        <cfset borc_deger_ = listappend(borc_deger_,0)>
						<cfset borc_pay_id = listappend(borc_pay_id,0)>
                        <cfset borc_pay_id_net = listappend(borc_pay_id_net,0)>
                        <cfif get_process_type.is_account_group eq 0>
                            <cfset satir_detay_list[1][sira_borc_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
                        <cfelse>
                            <cfset satir_detay_list[1][sira_borc_]=detail_1>
                        </cfif>
                    </cfif> 
					</cfloop>
                    <cfloop query="get_expense_puantaj">
						<cfset sira_ = 0>
						<cfloop list="#alacakli_name_list#" index="alacak_">
							<cfset sira_ = sira_ + 1>
							<cfset deger_ = listgetat(alacak_deger_,sira_)>
							<cfset deger_kontrol = listgetat(alacak_pay_id,sira_)>
							<cfset deger_kontrol2 = listgetat(alacak_pay_id_net,sira_)>
							<cfset deger_rate = listgetat(alacakli_rate_list,sira_)>
							<cfif deger_kontrol eq 0 and deger_kontrol2 eq 0 and len(evaluate("get_expense_puantaj.#alacak_#"))>
								<cfset new_deger_ = deger_ + (evaluate("get_expense_puantaj.#alacak_#")*deger_rate/100)>
								<cfset alacak_deger_ = listsetat(alacak_deger_,sira_,new_deger_)>
							</cfif>
						</cfloop>
						<cfset sira_ = 0>
						<cfloop list="#borclu_name_list#" index="alacak_">
							<cfset sira_ = sira_ + 1>
							<cfset deger_ = listgetat(borc_deger_,sira_)>
							<cfset deger_kontrol = listgetat(borc_pay_id,sira_)>
							<cfset deger_kontrol2 = listgetat(borc_pay_id_net,sira_)>
							<cfset deger_rate = listgetat(borclu_rate_list,sira_)>
							<cfif deger_kontrol eq 0 and deger_kontrol2 eq 0 and len(evaluate("get_expense_puantaj.#alacak_#"))>
								<cfset new_deger_ = deger_ + (evaluate("get_expense_puantaj.#alacak_#")*deger_rate/100)>
								<cfset borc_deger_ = listsetat(borc_deger_,sira_,new_deger_)>
							</cfif>
						</cfloop>
                    	<cfscript>
							str_borclu_hesaplar = listappend(str_borclu_hesaplar,borclu_list);
							str_borclu_tutarlar = listappend(str_borclu_tutarlar,borc_deger_);
							str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,alacakli_list);
							str_alacakli_tutarlar = listappend(str_alacakli_tutarlar,alacak_deger_);	
						</cfscript>
                    </cfloop>
					<cfscript>
                        str_borclu_hesaplar = borclu_list;
                        str_borclu_tutarlar = borc_deger_;
                        str_alacakli_hesaplar = alacakli_list;
                        str_alacakli_tutarlar = alacak_deger_;						
                        GET_NO_ = cfquery(datasource:"#new_dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
                        //muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
                        str_fark_gelir =GET_NO_.FARK_GELIR;
                        str_fark_gider =GET_NO_.FARK_GIDER;
                        str_max_round = 0.9;
                        acc_flag=muhasebeci(
                            action_id :attributes.PUANTAJ_ID,
                            workcube_process_type : 130,
                            workcube_process_cat : account_process_cat,
                            account_card_type : 13,
                            action_table : action_table,
                            islem_tarihi : puantaj_act_date,
                            borc_hesaplar : str_borclu_hesaplar,
                            borc_tutarlar : str_borclu_tutarlar,
                            alacak_hesaplar : str_alacakli_hesaplar,
                            alacak_tutarlar : str_alacakli_tutarlar,
                            from_branch_id : get_puantaj_branch.branch_id,
                            fis_detay : "#DETAIL_1#",
                            fis_satir_detay : satir_detay_list,
                            muhasebe_db:new_dsn2,
                            acc_project_list_borc : '',
                            acc_project_list_alacak : '',
                            dept_round_account :str_fark_gider,
                            claim_round_account : str_fark_gelir,
                            max_round_amount :str_max_round,
                            round_row_detail:DETAIL_1,
                            dsn3_alias:new_dsn3_alias,
                            is_account_group : get_process_type.is_account_group
                        );
                    </cfscript>
                    <cfif acc_flag>
                        <cf_get_lang dictionary_id='64559.Harcırah Muhasebe Fişi Oluşturuldu'>!
                    </cfif>
			</cfoutput>

			<!--- Memur bordrosu muhasebeleştirme--->
			<cfscript>
				DETAIL_1 = "#get_puantaj.sal_year# #get_puantaj.sal_mon#.<cf_get_lang dictionary_id='58724.Ay'> - #get_puantaj.SSK_OFFICE# <cf_get_lang dictionary_id='62870.Memur'>";
				str_borclu_hesaplar = '';
				str_borclu_tutarlar = '';
				str_alacakli_hesaplar = '';
				str_alacakli_tutarlar = '';
				borclu_project_list = '';
				alacakli_project_list = '';
				satir_detay_list = ArrayNew(2);
				sira_alacak_ = 0;
				sira_borc_ = 0;
			</cfscript>
			<cfscript>
				borclu_list = '';
				borclu_name_list = '';
				alacakli_list = '';
				alacakli_name_list = '';
				alacakli_detail_list = '';
				borc_deger_ = '';
				borclu_detail_list = '';
				alacak_deger_ = '';
				alacak_pay_id = '';
				borc_pay_id = '';
				alacak_pay_id_net = '';
				borc_pay_id_net = '';
				alacakli_rate_list='';
				borclu_rate_list='';
			</cfscript>
			<script type="text/javascript">
				get_wrk_message_div();
			</script>
			<cfoutput query="GET_ACCOUNTS">
				<cfquery name="get_officer_payroll" datasource="#new_dsn2#">
					SELECT
						OPR.*
					FROM
						#dsn#.EMPLOYEES_PUANTAJ_ROWS EPR
						INNER JOIN #dsn#.OFFICER_PAYROLL_ROW OPR ON OPR.EMPLOYEE_PAYROLL_ID = EPR.EMPLOYEE_PUANTAJ_ID
					WHERE
						EPR.PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#"> AND
						ACCOUNT_BILL_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ACCOUNTS.PAYROLL_ID#"> AND
						OPR.IN_OUT_ID IN( #valuelist(get_puantaj_rows.in_out_id)#)
				</cfquery>
				<cfif get_officer_payroll.recordCount gt 0>
					<cfquery name="get_account_rows" datasource="#new_dsn2#">
						SELECT * FROM #dsn_alias#.SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF_ROWS WHERE PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PAYROLL_ID#"> AND IS_EXPENSE = 1 
					</cfquery>
					<cfscript>
						borclu_list = '';
						borclu_name_list = '';
						alacakli_list = '';
						alacakli_name_list = '';
						alacakli_detail_list = '';
						borc_deger_ = '';
						borclu_detail_list = '';
						alacak_deger_ = '';
						alacak_pay_id = '';
						borc_pay_id = '';
						alacak_pay_id_net = '';
						borc_pay_id_net = '';
						alacakli_rate_list='';
						borclu_rate_list='';
					</cfscript>
					<cfloop query="get_account_rows">
					<cfif PUANTAJ_BORC_ALACAK eq 1>
						<cfset sira_alacak_ = sira_alacak_ + 1>
						<cfset alacakli_list = listappend(alacakli_list,'#ACCOUNT_CODE#')>
						<cfset alacakli_detail_list = listappend(alacakli_detail_list,'#PUANTAJ_ACCOUNT_DEFINITION#')>
						<cfset alacakli_name_list = listappend(alacakli_name_list,'#PUANTAJ_ACCOUNT#')>
						<cfset alacakli_project_list = listappend(alacakli_project_list,0)>
						<cfset alacakli_rate_list = listappend(alacakli_rate_list,100)>
						<cfset alacak_deger_ = listappend(alacak_deger_,0)>
						<cfset alacak_pay_id = listappend(alacak_pay_id,0)>
						<cfset alacak_pay_id_net = listappend(alacak_pay_id_net,0)>
						<cfif get_process_type.is_account_group eq 0>
							<cfset satir_detay_list[2][sira_alacak_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
						<cfelse>
							<cfset satir_detay_list[2][sira_alacak_]=detail_1>
						</cfif>
					<cfelse>
						<cfset sira_borc_ = sira_borc_ + 1>
						<cfset borclu_list = listappend(borclu_list,'#ACCOUNT_CODE#')>
						<cfset borclu_detail_list = listappend(borclu_detail_list,'#PUANTAJ_ACCOUNT_DEFINITION#')>
						<cfset borclu_name_list = listappend(borclu_name_list,'#PUANTAJ_ACCOUNT#')>
						<cfset borclu_project_list = listappend(borclu_project_list,0)>
						<cfset borclu_rate_list = listappend(borclu_rate_list,100)>
						<cfset borc_deger_ = listappend(borc_deger_,0)>
						<cfset borc_pay_id = listappend(borc_pay_id,0)>
						<cfset borc_pay_id_net = listappend(borc_pay_id_net,0)>
						<cfif get_process_type.is_account_group eq 0>
							<cfset satir_detay_list[1][sira_borc_]='#get_puantaj.sal_year# #get_puantaj.sal_mon#.Ay #get_account_rows.PUANTAJ_ACCOUNT_DEFINITION#'>
						<cfelse>
							<cfset satir_detay_list[1][sira_borc_]=detail_1>
						</cfif>
					</cfif> 
					</cfloop>
					<cfloop query="get_officer_payroll">
						<cfset sira_ = 0>
						<cfloop list="#alacakli_name_list#" index="alacak_">
							<cfset sira_ = sira_ + 1>
							<cfset deger_ = listgetat(alacak_deger_,sira_)>
							<cfset deger_kontrol = listgetat(alacak_pay_id,sira_)>
							<cfset deger_kontrol2 = listgetat(alacak_pay_id_net,sira_)>
							<cfset deger_rate = listgetat(alacakli_rate_list,sira_)>
							<cfif deger_kontrol eq 0 and deger_kontrol2 eq 0 and len(evaluate("get_officer_payroll.#alacak_#"))>
								<cfset new_deger_ = deger_ + (evaluate("get_officer_payroll.#alacak_#")*deger_rate/100)>
								<cfset alacak_deger_ = listsetat(alacak_deger_,sira_,new_deger_)>
							</cfif>
						</cfloop>
						<cfset sira_ = 0>
						<cfloop list="#borclu_name_list#" index="alacak_">
							<cfset sira_ = sira_ + 1>
							<cfset deger_ = listgetat(borc_deger_,sira_)>
							<cfset deger_kontrol = listgetat(borc_pay_id,sira_)>
							<cfset deger_kontrol2 = listgetat(borc_pay_id_net,sira_)>
							<cfset deger_rate = listgetat(borclu_rate_list,sira_)>
							<cfif deger_kontrol eq 0 and deger_kontrol2 eq 0 and len(evaluate("get_officer_payroll.#alacak_#"))>
								<cfset new_deger_ = deger_ + (evaluate("get_officer_payroll.#alacak_#")*deger_rate/100)>
								<cfset borc_deger_ = listsetat(borc_deger_,sira_,new_deger_)>
							</cfif>
						</cfloop>
						<cfscript>
							str_borclu_hesaplar = listappend(str_borclu_hesaplar,borclu_list);
							str_borclu_tutarlar = listappend(str_borclu_tutarlar,borc_deger_);
							str_alacakli_hesaplar = listappend(str_alacakli_hesaplar,alacakli_list);
							str_alacakli_tutarlar = listappend(str_alacakli_tutarlar,alacak_deger_);	
						</cfscript>
					</cfloop>
					<cfscript>
						str_borclu_hesaplar = borclu_list;
						str_borclu_tutarlar = borc_deger_;
						str_alacakli_hesaplar = alacakli_list;
						str_alacakli_tutarlar = alacak_deger_;						
						GET_NO_ = cfquery(datasource:"#new_dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE_PURCHASE");
						//muhasebe fisi icin, olusabilecek yuvarlama satırının bilgileri
						str_fark_gelir =GET_NO_.FARK_GELIR;
						str_fark_gider =GET_NO_.FARK_GIDER;
						str_max_round = 0.9;
						writeOutput(" str_alacakli_hesaplar : #str_alacakli_hesaplar# #str_alacakli_tutarlar#<<br>");
						acc_flag=muhasebeci(
							action_id :attributes.PUANTAJ_ID,
							workcube_process_type : 130,
							workcube_process_cat : account_process_cat,
							account_card_type : 13,
							action_table : action_table,
							islem_tarihi : puantaj_act_date,
							borc_hesaplar : str_borclu_hesaplar,
							borc_tutarlar : str_borclu_tutarlar,
							alacak_hesaplar : str_alacakli_hesaplar,
							alacak_tutarlar : str_alacakli_tutarlar,
							from_branch_id : get_puantaj_branch.branch_id,
							fis_detay : "#DETAIL_1#",
							fis_satir_detay : satir_detay_list,
							muhasebe_db:new_dsn2,
							acc_project_list_borc : '',
							acc_project_list_alacak : '',
							dept_round_account :str_fark_gider,
							claim_round_account : str_fark_gelir,
							max_round_amount :str_max_round,
							round_row_detail:DETAIL_1,
							dsn3_alias:new_dsn3_alias,
							is_account_group : get_process_type.is_account_group
						);
					</cfscript>
					<cfif acc_flag>
						<cfquery name="UPD_PUANTAJ_MUHASEBE_STATUS" datasource="#new_dsn2#">
							UPDATE
								#dsn_alias#.#main_puantaj_table#
							SET
								IS_ACCOUNT = 1
							WHERE
								PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PUANTAJ_ID#">
						</cfquery>
						<cf_get_lang dictionary_id='64602.Memur Muhasebe Fişi Oluşturuldu'>!
					</cfif>
				</cfif>
			</cfoutput>
			<script type="text/javascript">
				window.location= '<cfoutput>#request.self#?fuseaction=ehesap.popup_add_puantaj_to_muhasebe&puantaj_id=#attributes.puantaj_id#</cfoutput>';
			</script>
		</cfif>
	</cftransaction>
</cflock>

