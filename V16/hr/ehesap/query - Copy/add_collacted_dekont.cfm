<cfif not isdefined("attributes.branch_id")>
	<cfset attributes.branch_id = ListGetAt(session.ep.user_location,2,"-")>
</cfif>
<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı.\rMuhasebe Döneminizi Kontrol Ediniz!");
		history.back();	
	</script>
	<cfabort>
</cfif>

<cfif not isDefined("attributes.rd_money_")>
	<script type="text/javascript">
		alert("Döviz seçmelisiniz!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfif isdefined("attributes.company_id")>
	<cfquery name="get_company" datasource="#dsn#">
		SELECT COMP_ID AS COMPANY_ID FROM OUR_COMPANY WHERE COMP_ID = #attributes.company_id#
	</cfquery>
<cfelse>	
	<cfquery name="get_company" datasource="#dsn#">
		SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = #attributes.branch_id#
	</cfquery>
</cfif>

<cfif not isdefined("attributes.puantaj_id")>
	<cfset attributes.cari_action_id = createUUID()>
</cfif>

<cfquery name="get_period" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #get_company.COMPANY_ID# AND (PERIOD_YEAR = #attributes.sal_year# OR YEAR(FINISH_DATE) = #attributes.sal_year#) AND (FINISH_DATE IS NULL OR (FINISH_DATE IS NOT NULL AND FINISH_DATE >= #createdate(attributes.sal_year,attributes.sal_mon,1)#))
</cfquery>

<cfif get_period.recordcount eq 0>
	<script type="text/javascript">
		alert("İlgili Şubenin Muhasebe Dönemi Tanımlı Değil.\rMuhasebe Döneminizi Kontrol Ediniz!");
		history.back();	
	</script>
	<cfabort>
<cfelse>
	<cfset new_dsn2 = '#dsn#_#get_period.period_year#_#get_company.COMPANY_ID#'>
</cfif>
<cfif attributes.xml_code_control eq 1 and attributes.record_num gt 0>
	<cfset emp_ids = ''>   
	<cfloop from="1" to="#attributes.record_num#" index="i">
    	<cfscript>
    		if(listlen(evaluate("attributes.employee_id#i#"),'_') eq 2)
				emp_ids = listappend(emp_ids,listfirst(evaluate("attributes.employee_id#i#"),'_'),',');
			else
				emp_ids = listappend(emp_ids,evaluate("attributes.employee_id#i#"),',');
		</cfscript>
    </cfloop>
    <cfset emp_ids = ListDeleteDuplicates(emp_ids)>
    <cfif len(emp_ids)>
        <cfquery name="get_in_out_periods" datasource="#dsn#">
            SELECT
                COUNT(EMP_ACC_ID) AS TOTAL,
				EMPLOYEE_ID
            FROM
                EMPLOYEES_ACCOUNTS 
            WHERE
                PERIOD_ID = #session.ep.period_id# 
                AND EMPLOYEE_ID IN (#emp_ids#)
                AND ACC_TYPE_ID = -1
          	GROUP BY
				EMPLOYEE_ID
        </cfquery>
        <cfif get_in_out_periods.recordcount neq listlen(emp_ids,',')>
        	<script type="text/javascript">
				alert("Çalışanların ücret kartlarında muhasebe kodu ya da maaş cari hesap tipi bulunmamaktadır !");
				history.back();	
			</script>
            <cfabort>
		</cfif>
    </cfif>
</cfif>

<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT PROCESS_TYPE,IS_CARI,IS_BUDGET FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.process_type;
	is_cari =  get_process_type.is_cari;
	is_budget =  get_process_type.is_budget;
</cfscript>
<cf_date tarih='attributes.action_date'>
<cfquery name="control_paper_no" datasource="#dsn#">
	SELECT PAPER_NO FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE PAPER_NO = '#attributes.paper_no#'
</cfquery>

<cfif control_paper_no.recordcount>
	<script type="text/javascript">
		alert("Aynı Belge No İle Kayıtlı Maaş Tahakkuk İşlemi Var!");
		history.back();	
	</script>
</cfif>

<cfscript>
for(r=1; r lte attributes.record_num; r=r+1)
{
	if(evaluate('attributes.row_kontrol#r#') eq 1)
	{
		'attributes.action_value#r#' = filterNum(evaluate('attributes.action_value#r#'));
		'attributes.other_action_value#r#' = filterNum(evaluate('attributes.other_action_value#r#'));	}
}
rd_money_value = listfirst(attributes.rd_money_, ',');
attributes.total_amount = filterNum(attributes.total_amount);
attributes.other_total_amount = filterNum(attributes.other_total_amount);
currency_multiplier = '';
paper_currency_multiplier = '';
if(isDefined('attributes.kur_say') and len(attributes.kur_say))
	for(mon=1;mon lte attributes.kur_say;mon=mon+1)
	{
		'attributes.txt_rate2_#mon#' = filterNum(evaluate('attributes.txt_rate2_#mon#'),4);
		if( evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
			currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		if( evaluate("attributes.hidden_rd_money_#mon#") is attributes.rd_money_)
			paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
	}
</cfscript>
<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
			<cfquery name="ADD_CARI_ACTION" datasource="#new_dsn2#" result="MAX_ID">
				INSERT INTO
					#dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS
					(
						IS_VIRTUAL,
						PROCESS_CAT,
						PROCESS_TYPE,
						ACTION_DATE,
						PAPER_NO,
						EMPLOYEE_ID,
						PUANTAJ_ID,
						CARI_ACTION_ID,
						ACTION_DETAIL,
						ACTION_VALUE,
						OTHER_ACTION_VALUE,
						OTHER_MONEY,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE				
					)
					VALUES
					(
						#attributes.is_virtual#,
						#form.process_cat#,
						#process_type#,
						#attributes.action_date#,
						'#attributes.paper_no#',
						#attributes.action_employee_id#,
						<cfif isdefined("attributes.puantaj_id")>#attributes.puantaj_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.cari_action_id")>'#attributes.cari_action_id#'<cfelse>NULL</cfif>,
						<cfif isDefined("attributes.action_detail") and len(attributes.action_detail)>'#attributes.action_detail#'<cfelse>NULL</cfif>,
						#attributes.total_amount#,
						#attributes.other_total_amount#,
						<cfif len(rd_money_value)>'#rd_money_value#',<cfelse>NULL,</cfif>
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#',
						#NOW()#				
					)
			</cfquery>
            <cfset GET_MAX_ID.MAX_ID = MAX_ID.IDENTITYCOL>
		<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
                	<cfscript>
						attributes.acc_type_id = '';
						if(listlen(evaluate("attributes.employee_id#i#"),'_') eq 2)
						{
							attributes.acc_type_id = listlast(evaluate("attributes.employee_id#i#"),'_');
							"attributes.employee_id#i#" = listfirst(evaluate("attributes.employee_id#i#"),'_');
						}
                   	</cfscript>
					<cfquery name="ADD_ROWS" datasource="#new_dsn2#">
						INSERT INTO
						#dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW
						(
							DEKONT_ID,
							EMPLOYEE_ID,
							EXPENSE_CENTER_ID,
							EXPENSE_ITEM_ID,
							ACTION_VALUE,
							OTHER_ACTION_VALUE,
							IN_OUT_ID,
                            ACC_TYPE_ID,
							IS_TAX_REFUND
						)
						VALUES
						(
							#GET_MAX_ID.MAX_ID#,
							#evaluate("attributes.employee_id#i#")#,
							<cfif isdefined("attributes.expense_center#i#") and len(evaluate("attributes.expense_center#i#"))>#evaluate("attributes.expense_center#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
							#evaluate("attributes.action_value#i#")#,
							#evaluate("attributes.other_action_value#i#")#,
							<cfif isdefined("attributes.in_out_id#i#") and len(evaluate("attributes.in_out_id#i#"))>#evaluate("attributes.in_out_id#i#")#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.is_tax_refund#i#")>1<cfelse>0</cfif>
						)
					</cfquery>
					<cfquery name="get_max_row_id" datasource="#new_dsn2#">
						SELECT MAX(DEKONT_ROW_ID) AS MAX_ID FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW
					</cfquery>
					<cfscript>
						if(is_cari eq 1)
						{
						carici(
							action_id : get_max_row_id.MAX_ID,
							action_table : 'EMPLOYEES_PUANTAJ_CARI_ACTIONS',
							islem_belge_no : attributes.paper_no,
							workcube_process_type : process_type,		
							process_cat : form.process_cat,
							islem_tarihi : attributes.action_date,
							islem_tutari : evaluate("attributes.action_value#i#"),
							other_money_value : evaluate("attributes.other_action_value#i#"),
							action_detail : attributes.action_detail,
							other_money : attributes.rd_money_,			
							action_currency : session.ep.money,
							acc_type_id : attributes.acc_type_id,
							currency_multiplier : currency_multiplier,
							account_card_type : 13,
							islem_detay : 'ÜCRET DEKONTU',
							due_date: attributes.action_date,
							from_employee_id : evaluate("attributes.employee_id#i#"),
							//from_branch_id : ListGetAt(session.ep.user_location,2,"-"),
							from_branch_id : attributes.branch_id,
							cari_db : new_dsn2,
							rate2:paper_currency_multiplier
							);
						}
						if(is_budget eq 1)
						{
							if (isdefined("attributes.expense_center#i#") and isdefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.expense_center#i#")))
							butceci(
								action_id : get_max_row_id.MAX_ID,
								is_income_expense : false,
								employee_id : evaluate("attributes.employee_id#i#"),
								process_type : process_type,
								nettotal : evaluate("attributes.action_value#i#"),
								other_money_value : evaluate("attributes.other_action_value#i#"),
								action_currency : attributes.rd_money_,
								currency_multiplier : currency_multiplier,
								expense_date : attributes.action_date,
								detail : 'PUANTAJ MASRAFI',
								expense_center_id : evaluate("attributes.expense_center#i#"),
								expense_item_id : evaluate("attributes.expense_item_id#i#"),
								insert_type :1,
								//branch_id : ListGetAt(session.ep.user_location,2,"-"),
								branch_id : attributes.branch_id,
								muhasebe_db:new_dsn2
								);
						}
			    	</cfscript>
				</cfif>
			</cfloop>
		</cfif>
		<cfloop from="1" to="#attributes.kur_say#" index="r">
			<cfquery name="EMPLOYEES_PUANTAJ_CARI_ACTIONS_MONEY" datasource="#new_dsn2#">
				INSERT 
				INTO 
					#dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#GET_MAX_ID.MAX_ID#,
						'#wrk_eval("attributes.hidden_rd_money_#r#")#',
						#evaluate("attributes.txt_rate2_#r#")#,
						#evaluate("attributes.txt_rate1_#r#")#,
						<cfif evaluate("attributes.hidden_rd_money_#r#") is attributes.rd_money_>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.puantaj_id")>
		opener.open_form_ajax(1);
	<cfelse>
		wrk_opener_reload();
	</cfif>
	window.close();
</script>

