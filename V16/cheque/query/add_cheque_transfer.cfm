<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz!");
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_get_lang_set module_name="cheque">
<cf_date tarih="attributes.payroll_revenue_date">
<cf_date tarih='attributes.pyrll_avg_duedate'>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_ACCOUNT,
		IS_CHEQUE_BASED_ACTION,
		IS_ACCOUNT_GROUP,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_account = get_process_type.IS_ACCOUNT;
	is_cheque_based = get_process_type.IS_CHEQUE_BASED_ACTION;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	attributes.payroll_total = filterNum(attributes.payroll_total);
	attributes.other_payroll_total = filterNum(attributes.other_payroll_total);
	for(ff=1; ff lte attributes.record_num; ff=ff+1)
	{
		if (evaluate("attributes.row_kontrol#ff#"))
		{
			'attributes.cheque_system_currency_value#ff#' = filterNum(evaluate("attributes.cheque_system_currency_value#ff#"));
			'attributes.cheque_value#ff#' = filterNum(evaluate("attributes.cheque_value#ff#"));
		}
	}
	for(rt = 1; rt lte attributes.kur_say; rt = rt + 1)
	{
		'attributes.txt_rate1_#rt#' = filterNum(evaluate('attributes.txt_rate1_#rt#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#rt#' = filterNum(evaluate('attributes.txt_rate2_#rt#'),session.ep.our_company_info.rate_round_num);
	}
</cfscript>
<!--- Transfer çıkış ise statü transfer oluyor değilse portföye alınıyor --->
<cfif process_type eq 134>
	<cfset new_status = 14>
	<cfset branch_id_info = listgetat(form.cash_id,2,';')>
<cfelse>
	<cfset new_status = 1>
	<cfset branch_id_info = listgetat(form.to_cash_id,2,';')>
</cfif>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
	<cfquery name="ADD_REVENUE_TO_PAYROLL" datasource="#dsn2#">
		INSERT INTO
			PAYROLL
			(
				PROCESS_CAT,
				PAYROLL_TYPE,
				PAYROLL_AVG_DUEDATE,
				PAYROLL_TOTAL_VALUE,
				PAYROLL_OTHER_MONEY,
				PAYROLL_OTHER_MONEY_VALUE,
				PAYROLL_AVG_AGE,
				NUMBER_OF_CHEQUE,
				PAYROLL_CASH_ID,
				CURRENCY_ID,
				PAYROLL_REVENUE_DATE,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,		
				REVENUE_COLLECTOR_ID,
				CHEQUE_BASED_ACC_CARI,
				ACTION_DETAIL,
				BRANCH_ID,
				TRANSFER_CASH_ID
			)
			VALUES
			(
				#form.process_cat#,
				#process_type#,
				#attributes.pyrll_avg_duedate#,
				#attributes.payroll_total#,
				<cfif isdefined("attributes.basket_money") and len(attributes.basket_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)>#attributes.other_payroll_total#,<cfelse>NULL,</cfif>
				<cfif len(attributes.pyrll_avg_age)>#attributes.pyrll_avg_age#,<cfelse>NULL,</cfif>
				#attributes.cheque_num#,
				#listfirst(form.cash_id,';')#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
				#attributes.payroll_revenue_date#,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#NOW()#,
				#session.ep.userid#,
				<cfif len(is_cheque_based)>#is_cheque_based#<cfelse>0</cfif>,
				<cfif isDefined("attributes.action_detail") and len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_detail#"><cfelse>NULL</cfif>,
				#branch_id_info#,
				#listfirst(form.to_cash_id,';')#
			)
	</cfquery>
	<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
		SELECT MAX(ACTION_ID) AS P_ID FROM PAYROLL
	</cfquery>
	<cfset p_id=get_bordro_id.P_ID>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#")>
			<cfquery name="UPD_CHEQUES" datasource="#dsn2#">
				UPDATE 
					CHEQUE 
				SET 
					CHEQUE_STATUS_ID = #new_status#,
					CHEQUE_PAYROLL_ID =#p_id#
					<cfif process_type eq 135>
						,CASH_ID = #listfirst(form.to_cash_id,';')#
					</cfif>
				WHERE 
					CHEQUE_ID = #evaluate("attributes.cheque_id#i#")#
			</cfquery>
			<cfquery name="ADD_CHEQUE_HISTORY" datasource="#dsn2#">
				INSERT INTO
					CHEQUE_HISTORY
						(
							CHEQUE_ID,
							PAYROLL_ID,
							STATUS,
							ACT_DATE,
							OTHER_MONEY_VALUE,
							OTHER_MONEY,
							OTHER_MONEY_VALUE2,
							OTHER_MONEY2,
							RECORD_DATE
						)
					VALUES
						(
							#evaluate("attributes.cheque_id#i#")#,
							#p_id#,
							#new_status#,
							#attributes.payroll_revenue_date#,
							<cfif len(evaluate("attributes.cheque_system_currency_value#i#"))>#evaluate("attributes.cheque_system_currency_value#i#")#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.system_money_info#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.system_money_info#i#")#'>,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.other_money_value2#i#"))>#evaluate("attributes.other_money_value2#i#")#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.other_money2#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.other_money2#i#")#'>,<cfelse>NULL,</cfif>
							#NOW()#
						)
			</cfquery>
		</cfif>
	</cfloop>
	<cfscript>
		currency_multiplier = '';//sistem ikinci para biriminin kurunu sayfadan alıyor
		if(isDefined('attributes.kur_say') and len(attributes.kur_say))
			for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
		if(is_account eq 1)
		{
			if(session.ep.our_company_info.is_edefter eq 0)	/*standart muhasebe islemleri yapılıyor*/
			{
				acc_tutarlar = '';
				acc_hesaplar = '';
				acc_hesaplar_2 = '';
				other_currency_acc_list= '';
				other_amount_acc_list= '';
				total_value = 0;
				other_total_value = 0;
				GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"SELECT A_CHEQUE_ACC_CODE,TRANSFER_CHEQUE_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
				GET_ACC_CODE1=cfquery(datasource:"#dsn2#", sqlstring:"SELECT A_CHEQUE_ACC_CODE,TRANSFER_CHEQUE_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.to_cash_id,';')#");
				
				if(process_type eq 134)
				{
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[1][1] = ' #attributes.action_detail#';
					else
						str_card_detail[1][1] = ' ÇEK TRANSFER ÇIKIŞ İŞLEMİ';
				}
				else
				{
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[2][1] = ' #attributes.action_detail#';
					else
						str_card_detail[2][1] = ' ÇEK TRANSFER GİRİŞ İŞLEMİ';
				}
				
				for(i=1; i lte attributes.record_num; i=i+1)
				{
					if (evaluate("attributes.row_kontrol#i#"))
					{
						total_value = total_value + evaluate("attributes.cheque_system_currency_value#i#");
						other_total_value = other_total_value + evaluate("attributes.cheque_value#i#");
						acc_tutarlar = listappend(acc_tutarlar,evaluate("attributes.cheque_system_currency_value#i#"),',');
						other_currency_acc_list = listappend(other_currency_acc_list,listgetat(form.to_cash_id,3,';'),',');
						other_amount_acc_list =  listappend(other_amount_acc_list,evaluate("attributes.cheque_value#i#"),',');
						acc_hesaplar=listappend(acc_hesaplar,GET_ACC_CODE1.A_CHEQUE_ACC_CODE,',');
						acc_hesaplar_2=listappend(acc_hesaplar_2,GET_ACC_CODE.A_CHEQUE_ACC_CODE,',');
						/* cek transfer cikis islemi satir aciklamalari, is_account_group parametresine gore duzenlendi */
						if(process_type eq 134)
						{
							if(is_account_group neq 1)
							{
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][listlen(acc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.action_detail#';
								else
									str_card_detail[2][listlen(acc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - ÇEK TRANSFER ÇIKIŞ İŞLEMİ';
							}
							else
							{
								str_card_detail[2][listlen(acc_tutarlar)] = ' ÇEK TRANSFER ÇIKIŞ İŞLEMİ';	
							}
						}
						/* cek transfer giris islemi satir aciklamalari, is_account_group parametresine gore duzenlendi */
						else
						{
							if(is_account_group neq 1)
							{
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[1][listlen(acc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.action_detail#';
								else
									str_card_detail[1][listlen(acc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - ÇEK TRANSFER GİRİŞ İŞLEMİ';
							}
							else
							{
								str_card_detail[1][listlen(acc_tutarlar)] = ' ÇEK TRANSFER GİRİŞ İŞLEMİ';
							}
						}
					}
				}
				if(process_type eq 134)
				{
					from_branch_id = branch_id_info;
					to_branch_id = '';
					borc_acc = GET_ACC_CODE.TRANSFER_CHEQUE_ACC_CODE;
					
					muhasebeci(
						action_id:P_ID,
						workcube_process_type:process_type,
						account_card_type:13,
						action_table :'PAYROLL',
						islem_tarihi:attributes.payroll_revenue_date,
						borc_hesaplar: borc_acc,
						borc_tutarlar:total_value,
						other_amount_borc: other_total_value,
						other_currency_borc: listgetat(form.to_cash_id,3,';'),
						alacak_hesaplar:acc_hesaplar_2,
						alacak_tutarlar:acc_tutarlar,
						other_amount_alacak: other_amount_acc_list,
						other_currency_alacak: other_currency_acc_list,
						currency_multiplier : currency_multiplier,
						fis_detay:'ÇEK TRANSFER İŞLEMİ',
						fis_satir_detay:str_card_detail,
						from_branch_id : from_branch_id,
						to_branch_id : to_branch_id,
						workcube_process_cat : form.process_cat,
						is_account_group : is_account_group
						);
				}
				else
				{
					from_branch_id = '';
					to_branch_id = branch_id_info;
					alacak_acc = GET_ACC_CODE.TRANSFER_CHEQUE_ACC_CODE;
					
					muhasebeci(
						action_id:P_ID,
						workcube_process_type:process_type,
						account_card_type:13,
						action_table :'PAYROLL',
						islem_tarihi:attributes.payroll_revenue_date,
						borc_hesaplar: acc_hesaplar,
						borc_tutarlar:acc_tutarlar,
						other_amount_borc: other_amount_acc_list,
						other_currency_borc: other_currency_acc_list,
						alacak_hesaplar:alacak_acc,
						alacak_tutarlar:total_value,
						other_amount_alacak: other_total_value,
						other_currency_alacak: listgetat(form.to_cash_id,3,';'),
						currency_multiplier : currency_multiplier,
						fis_detay:'ÇEK TRANSFER İŞLEMİ',
						fis_satir_detay:str_card_detail,
						from_branch_id : from_branch_id,
						to_branch_id : to_branch_id,
						workcube_process_cat : form.process_cat,
						is_account_group : is_account_group
						);
				}
			}
			else		/*e-deftere uygun muhasebe islemleri yapılıyor*/
			{
				acc_tutarlar = '';
				acc_hesaplar = '';
				acc_hesaplar_2 = '';
				other_currency_acc_list= '';
				other_amount_acc_list= '';
				total_value = 0;
				other_total_value = 0;
				project_id = '';
				GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"SELECT A_CHEQUE_ACC_CODE,TRANSFER_CHEQUE_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
				GET_ACC_CODE1=cfquery(datasource:"#dsn2#", sqlstring:"SELECT A_CHEQUE_ACC_CODE,TRANSFER_CHEQUE_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.to_cash_id,';')#");
				
				if(process_type eq 134)
				{
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[1][1] = ' #attributes.action_detail#';
					else
						str_card_detail[1][1] = ' ÇEK TRANSFER ÇIKIŞ İŞLEMİ';
				}
				else
				{
					if(isDefined("attributes.action_detail") and len(attributes.action_detail))
						str_card_detail[2][1] = ' #attributes.action_detail#';
					else
						str_card_detail[2][1] = ' ÇEK TRANSFER GİRİŞ İŞLEMİ';
				}
				
				for(i=1; i lte attributes.record_num; i=i+1)
				{
					if (evaluate("attributes.row_kontrol#i#"))
					{
						total_value = evaluate("attributes.cheque_system_currency_value#i#");
						other_total_value = evaluate("attributes.cheque_value#i#");
						acc_tutarlar = evaluate("attributes.cheque_system_currency_value#i#");
						other_currency_acc_list = listgetat(form.to_cash_id,3,';');
						other_amount_acc_list =  evaluate("attributes.cheque_value#i#");
						acc_hesaplar = GET_ACC_CODE1.A_CHEQUE_ACC_CODE;
						acc_hesaplar_2 = GET_ACC_CODE.A_CHEQUE_ACC_CODE;
						/* cek transfer cikis islemi satir aciklamalari, is_account_group parametresine gore duzenlendi */
						if(process_type eq 134)
						{
							if(is_account_group neq 1)
							{
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[2][listlen(acc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.action_detail#';
								else
									str_card_detail[2][listlen(acc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - ÇEK TRANSFER ÇIKIŞ İŞLEMİ';
							}
							else
							{
								str_card_detail[2][listlen(acc_tutarlar)] = ' ÇEK TRANSFER ÇIKIŞ İŞLEMİ';	
							}
						}
						/* cek transfer giris islemi satir aciklamalari, is_account_group parametresine gore duzenlendi */
						else
						{
							if(is_account_group neq 1)
							{
								if(isDefined("attributes.action_detail") and len(attributes.action_detail))
									str_card_detail[1][listlen(acc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - #attributes.action_detail#';
								else
									str_card_detail[1][listlen(acc_tutarlar)] = ' #evaluate("attributes.cheque_no#i#")# - ÇEK TRANSFER GİRİŞ İŞLEMİ';
							}
							else
							{
								str_card_detail[1][listlen(acc_tutarlar)] = ' ÇEK TRANSFER GİRİŞ İŞLEMİ';
							}
						}
						
						GET_CHEQUE_PROJECT=cfquery(datasource:"#dsn2#",sqlstring:"SELECT
								P.PROJECT_ID
							FROM
								PAYROLL AS P,
								CHEQUE AS C
							WHERE
								P.ACTION_ID= C.CHEQUE_PAYROLL_ID AND
								C.CHEQUE_ID=#evaluate("attributes.cheque_id#i#")#");
							
						project_id = GET_CHEQUE_PROJECT.PROJECT_ID;		
						
						if(process_type eq 134)
						{
							from_branch_id = branch_id_info;
							to_branch_id = '';
							borc_acc = GET_ACC_CODE.TRANSFER_CHEQUE_ACC_CODE;
							
							muhasebeci(
								action_id:P_ID,
								action_row_id : evaluate("attributes.CHEQUE_ID#i#"),
								due_date :iif(len(evaluate("attributes.CHEQUE_DUEDATE#i#")),'createodbcdatetime(evaluate("attributes.CHEQUE_DUEDATE#i#"))','attributes.pyrll_avg_duedate'),
								workcube_process_type:process_type,
								account_card_type:13,
								action_table :'PAYROLL',
								islem_tarihi:attributes.payroll_revenue_date,
								borc_hesaplar: borc_acc,
								borc_tutarlar:total_value,
								other_amount_borc: other_total_value,
								other_currency_borc: listgetat(form.to_cash_id,3,';'),
								alacak_hesaplar:acc_hesaplar_2,
								alacak_tutarlar:acc_tutarlar,
								other_amount_alacak: other_amount_acc_list,
								other_currency_alacak: other_currency_acc_list,
								currency_multiplier : currency_multiplier,
								fis_detay:'ÇEK TRANSFER İŞLEMİ',
								fis_satir_detay:str_card_detail,
								from_branch_id : from_branch_id,
								to_branch_id : to_branch_id,
								workcube_process_cat : form.process_cat,
								is_account_group : is_account_group,
								belge_no : evaluate("attributes.cheque_no#i#"),
								acc_project_id = project_id
							);
						}
						else
						{
							from_branch_id = '';
							to_branch_id = branch_id_info;
							alacak_acc = GET_ACC_CODE.TRANSFER_CHEQUE_ACC_CODE;
							
							muhasebeci(
								action_id:P_ID,
								action_row_id : evaluate("attributes.CHEQUE_ID#i#"),
								due_date :iif(len(evaluate("attributes.CHEQUE_DUEDATE#i#")),'createodbcdatetime(evaluate("attributes.CHEQUE_DUEDATE#i#"))','attributes.pyrll_avg_duedate'),
								workcube_process_type:process_type,
								account_card_type:13,
								action_table :'PAYROLL',
								islem_tarihi:attributes.payroll_revenue_date,
								borc_hesaplar: acc_hesaplar,
								borc_tutarlar:acc_tutarlar,
								other_amount_borc: other_amount_acc_list,
								other_currency_borc: other_currency_acc_list,
								alacak_hesaplar:alacak_acc,
								alacak_tutarlar:total_value,
								other_amount_alacak: other_total_value,
								other_currency_alacak: listgetat(form.to_cash_id,3,';'),
								currency_multiplier : currency_multiplier,
								fis_detay:'ÇEK TRANSFER İŞLEMİ',
								fis_satir_detay:str_card_detail,
								from_branch_id : from_branch_id,
								to_branch_id : to_branch_id,
								workcube_process_cat : form.process_cat,
								is_account_group : is_account_group,
								belge_no : evaluate("attributes.cheque_no#i#"),
								acc_project_id = project_id								
							);
						}	
					}
				}
			}
		}
		basket_kur_ekle(action_id:GET_BORDRO_ID.P_ID,table_type_id:11,process_type:0);
	</cfscript>
	<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
	<cf_workcube_process_cat 
		process_cat="#form.process_cat#"
		action_id = #p_id#
		is_action_file = 1
		action_db_type = '#dsn2#'
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_cheque_transfer&event=upd&id=#p_id#'
		action_file_name='#get_process_type.action_file_name#'
		is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock> 
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=cheque.form_add_cheque_transfer&event=upd&id=#p_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
