<cfif form.active_period neq session.ep.period_id>
		<script type="text/javascript">
			alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı.\rMuhasebe Döneminizi Kontrol Ediniz!");
			window.location.href='<cfoutput>#request.self#?fuseaction=bank.list_bank_actions</cfoutput>';
		</script>
	<cfabort>
</cfif>
<cfif attributes.xml_code_control eq 1 and attributes.record_num gt 0>
	<cfset emp_ids = ''>   
	<cfloop from="1" to="#attributes.record_num#" index="i">
    	<cfscript>
    		if(listlen(evaluate("attributes.employee_id#i#"),'_') eq 2)
			{
				"attributes.employee_id#i#" = listfirst(evaluate("attributes.employee_id#i#"),'_');
			}
		</cfscript>
    	<cfif len(evaluate("attributes.employee_id#i#")) and not listfind(emp_ids,evaluate("attributes.employee_id#i#"),',')>
			<cfset emp_ids = listappend(emp_ids,evaluate("attributes.employee_id#i#"),',')>
        </cfif>
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
<cfquery name="get_puantaj" datasource="#dsn#">
	SELECT 
    	PUANTAJ_ID, 
        SAL_MON, 
        SAL_YEAR, 
        IS_ACCOUNT, 
        IS_LOCKED, 
        SSK_OFFICE, 
        SSK_OFFICE_NO, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        IS_BUDGET,
        PUANTAJ_TYPE 
    FROM 
	    EMPLOYEES_PUANTAJ 
    WHERE 
    	PUANTAJ_ID = #attributes.puantaj_id#
</cfquery>
<cfquery name="get_company" datasource="#dsn#">
	SELECT COMPANY_ID FROM BRANCH WHERE SSK_OFFICE = '#get_puantaj.SSK_OFFICE#' AND SSK_NO = '#get_puantaj.SSK_OFFICE_NO#'
</cfquery>
<cfquery name="get_period" datasource="#dsn#">
	SELECT 
    	PERIOD_ID, 
        PERIOD, 
        PERIOD_YEAR, 
        OUR_COMPANY_ID, 
        OTHER_MONEY, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP, 
        IS_LOCKED 
    FROM 
    	SETUP_PERIOD 
    WHERE 
	    OUR_COMPANY_ID = #get_company.COMPANY_ID# 
   		AND (PERIOD_YEAR = #get_puantaj.sal_year# OR YEAR(FINISH_DATE) = #get_puantaj.sal_year#)
        AND (FINISH_DATE IS NULL OR (FINISH_DATE IS NOT NULL AND FINISH_DATE >= #createdate(get_puantaj.sal_year,get_puantaj.sal_mon,1)#))
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
<cf_date tarih='attributes.action_date'>
<cfquery name="control_paper_no" datasource="#dsn#">
	SELECT PAPER_NO FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE PAPER_NO = '#attributes.paper_no#' AND DEKONT_ID <> #attributes.dekont_id#
</cfquery>
<cfif control_paper_no.recordcount>
	<script type="text/javascript">
		alert("Aynı Belge No İle Kayıtlı Toplu Dekont İşlemi Var!");
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
		<cfquery name="UPD_CARI_ACTION" datasource="#new_dsn2#">
			UPDATE 
				#dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS
			SET
				IS_VIRTUAL = #attributes.is_virtual#,
				PROCESS_CAT = #form.process_cat#,
				PROCESS_TYPE = #process_type#,
				ACTION_DATE = #attributes.action_date#,
				PAPER_NO = '#attributes.paper_no#',
				EMPLOYEE_ID = #attributes.action_employee_id#,
				PUANTAJ_ID = #attributes.puantaj_id#,
				ACTION_DETAIL = <cfif isDefined("attributes.action_detail") and len(attributes.action_detail)>'#attributes.action_detail#'<cfelse>NULL</cfif>,
				ACTION_VALUE = #attributes.total_amount#,
				OTHER_ACTION_VALUE = #attributes.other_total_amount#,
				OTHER_MONEY = <cfif len(rd_money_value)>'#rd_money_value#',<cfelse>NULL,</cfif>
				UPDATE_EMP = #SESSION.EP.USERID#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_DATE	= #NOW()#
			WHERE 
				DEKONT_ID = #attributes.dekont_id#
		</cfquery>
		<cfquery name="GET_ALL_DEKONT" datasource="#new_dsn2#">
			SELECT DEKONT_ROW_ID FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW WHERE DEKONT_ID = #attributes.dekont_id#
		</cfquery>
		<cfquery name="DEL_DEKONT_ROW" datasource="#new_dsn2#">
			DELETE FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW WHERE DEKONT_ID = #attributes.dekont_id#
		</cfquery>
		<cfquery name="DEL_MONEY" datasource="#new_dsn2#">
			DELETE FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_MONEY WHERE ACTION_ID = #attributes.dekont_id#
		</cfquery>	
		<cfscript>
		for (k = 1; k lte get_all_dekont.recordcount;k=k+1)
		{
			cari_sil(action_id:get_all_dekont.DEKONT_ROW_ID[k],process_type:form.old_process_type,cari_db : new_dsn2);
			butce_sil(action_id:get_all_dekont.DEKONT_ROW_ID[k],process_type:form.old_process_type,muhasebe_db:new_dsn2);
		}
		</cfscript>
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
					<cfquery name="ADD_ROWS" datasource="#new_dsn2#" result="MAX_ID">
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
							#attributes.dekont_id#,
							#evaluate("attributes.employee_id#i#")#,
							<cfif isdefined("attributes.expense_center#i#") and len(evaluate("attributes.expense_center#i#"))>#evaluate("attributes.expense_center#i#")#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_id#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
							#evaluate("attributes.action_value#i#")#,
							#evaluate("attributes.other_action_value#i#")#,
							<cfif isdefined("attributes.in_out_id#i#") and len(evaluate("attributes.in_out_id#i#"))>#evaluate("attributes.in_out_id#i#")#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
							<cfif isdefined("attributes.is_tax_refund#i#") and len(evaluate("attributes.is_tax_refund#i#"))>#evaluate("attributes.is_tax_refund#i#")#<cfelse>NULL</cfif>
						)
					</cfquery>
					<cfscript>
						if(is_cari eq 1)
						{
							carici(
								action_id : MAX_ID.IDENTITYCOL,
								action_table : 'EMPLOYEES_PUANTAJ_CARI_ACTIONS',
								islem_belge_no : attributes.paper_no,
								workcube_process_type : process_type,	
								process_cat : form.process_cat,
								islem_tarihi : attributes.action_date,
								action_detail : attributes.action_detail,
								islem_tutari : evaluate("attributes.action_value#i#"),
								other_money_value : evaluate("attributes.other_action_value#i#"),
								other_money : attributes.rd_money_,			
								action_currency : session.ep.money,
								acc_type_id : attributes.acc_type_id,
								currency_multiplier : currency_multiplier,
								account_card_type : 13,
								islem_detay : 'ÜCRET DEKONTU',
								due_date: attributes.action_date,
								//from_branch_id : ListGetAt(session.ep.user_location,2,"-"),
								from_branch_id : attributes.branch_id,
								from_employee_id : evaluate("attributes.employee_id#i#"),
								rate2:paper_currency_multiplier,
								cari_db : new_dsn2
								);
						}
						if(is_budget eq 1)
						{
							if (isdefined("attributes.expense_center#i#") and isdefined("attributes.expense_item_id#i#") and len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.expense_center#i#")))
							butceci(
								action_id : MAX_ID.IDENTITYCOL,
								is_income_expense : false,
								process_type : process_type,
								employee_id : evaluate("attributes.employee_id#i#"),
								nettotal : evaluate("attributes.action_value#i#"),
								other_money_value : evaluate("attributes.other_action_value#i#"),
								action_currency : attributes.rd_money_,
								currency_multiplier : currency_multiplier,
								expense_date : attributes.action_date,
								detail : 'PUANTAJ MASRAFI',
								expense_center_id : evaluate("attributes.expense_center#i#"),
								expense_item_id : evaluate("attributes.expense_item_id#i#"),
								//branch_id : ListGetAt(session.ep.user_location,2,"-"),
								branch_id : attributes.branch_id,
								insert_type :1,
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
						#attributes.dekont_id#,
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
	opener.open_form_ajax(1);
	window.close();
</script>
