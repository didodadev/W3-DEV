<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_ACCOUNT,
		IS_ACCOUNT_GROUP,
		IS_CHEQUE_BASED_ACTION,
		IS_UPD_CARI_ROW,
        ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE,
		IS_CARI,
		IS_BUDGET
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
</cfquery>
<cfif not isdefined("is_collacted")><!--- Toplu işlemlerde databaseden geliyor filternuma gerek yok --->
	<cfloop from="1" to="#attributes.kur_say#" index="ii">
		<cfscript>
			'attributes.txt_rate2_#ii#' = filterNum(evaluate('attributes.txt_rate2_#ii#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate1_#ii#' = filterNum(evaluate('attributes.txt_rate1_#ii#'),session.ep.our_company_info.rate_round_num);
		</cfscript>
	</cfloop>
</cfif>
<cfquery name="get_cash_code" datasource="#dsn2#">
	SELECT CASH_ACC_CODE,BRANCH_ID,DUE_DIFF_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(attributes.kasa,';')#
</cfquery>
<cfset total_pay_term_value = 0>
<cfif len(get_cash_code.BRANCH_ID)>
	<cfset cash_branch_id = get_cash_code.BRANCH_ID>
<cfelse>
	<cfset cash_branch_id = ''>
</cfif>
<cf_date tarih="attributes.act_date">
<cfscript>
	process_type = get_process_type.PROCESS_TYPE;
	is_account = get_process_type.IS_ACCOUNT;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	is_voucher_based = get_process_type.IS_CHEQUE_BASED_ACTION;
	is_upd_cari_row = get_process_type.IS_UPD_CARI_ROW;
	is_budget =get_process_type.IS_BUDGET;
	is_cari =get_process_type.IS_CARI;
	currency_multiplier = '';
	currency_multiplier_2 = '';
	rd_money_value = listfirst(attributes.rd_money, ';');
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
	{
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
		{
			if(evaluate("attributes.hidden_rd_money_#mon#") is rd_money_value)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier_2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
		}
	}
	branch_id_info = listgetat(session.ep.user_location,2,'-');
</cfscript>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll')>	
		<cfset my_payroll_no = belge_no>
		<cfset belge_no = get_cheque_no(belge_tipi:'voucher_payroll',belge_no:belge_no+1)>
		<cfquery name="ADD_REVENUE_TO_PAYROLL" datasource="#dsn2#"><!---Tahsilat için yeni bir bordro oluşturuluyor----->
			INSERT INTO
				VOUCHER_PAYROLL
				(
					PROCESS_CAT,
					PAYROLL_TYPE,
					PAYROLL_TOTAL_VALUE,
					PAYROLL_OTHER_MONEY,
					PAYROLL_OTHER_MONEY_VALUE,
					PAYROLL_CASH_ID,
					NUMBER_OF_VOUCHER,
					CURRENCY_ID,
					PAYROLL_REVENUE_DATE,
					PAYROLL_REV_MEMBER,
					MASRAF,
					EXP_CENTER_ID,
					EXP_ITEM_ID,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					VOUCHER_BASED_ACC_CARI,
					ACTION_DETAIL,
					BRANCH_ID,
					COMPANY_ID,
					CONSUMER_ID,
					PAYROLL_NO
				)
				VALUES(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#process_type#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.VOUCHER_VALUE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_money#">,
					<cfif isdefined("attributes.other_payroll_total") and len(attributes.other_payroll_total)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.other_payroll_total#">,<cfelse>NULL,</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cash_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.voucher_id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_type#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#attributes.act_date#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfif attributes.masraf gt 0><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.masraf#"><cfelse>0</cfif>,
					<cfif isdefined("attributes.expense_center") and len(attributes.expense_center)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"><cfelse>NULL</cfif>,
					<cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					<cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>,
					<cfif isDefined("attributes.detail") and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#branch_id_info#">,
					<cfif len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
					<cfif len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#my_payroll_no#">
				)
		</cfquery>
		<cfquery name="GET_VOUCHER" datasource="#dsn2#">
			SELECT 
				VOUCHER_STATUS_ID,
				VOUCHER_VALUE,
				VOUCHER.CURRENCY_ID,
				VOUCHER_PURSE_NO,
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
				OTHER_MONEY2,
				OTHER_MONEY_VALUE2,
				VOUCHER_DUEDATE,
				ACCOUNT_CODE,
				VOUCHER_PAYROLL_ID,
				CASH_ID,
				VOUCHER_PAYROLL.PROJECT_ID,
				VOUCHER_NO,
				IS_PAY_TERM
			FROM
				VOUCHER
                	LEFT JOIN VOUCHER_PAYROLL ON VOUCHER_PAYROLL.ACTION_ID = VOUCHER.VOUCHER_PAYROLL_ID
			WHERE
				VOUCHER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.voucher_id#">  and
				VOUCHER_STATUS_ID=1
		</cfquery>
		<cfquery name="UPD_VOUCHERS" datasource="#dsn2#">
			UPDATE 
				VOUCHER 
			SET 
				VOUCHER_STATUS_ID=3<!--- tahsil edildi----->
			WHERE 
				VOUCHER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.voucher_id#">  
		</cfquery>
		<cfquery name="GET_BORDRO_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS P_ID FROM VOUCHER_PAYROLL
		</cfquery>
		<cfif GET_VOUCHER.is_pay_term eq 1>
			<cfset total_pay_term_value = total_pay_term_value + evaluate("attributes.new_closed_amount_#kk#")>
		</cfif>
		<cfset p_id=get_bordro_id.P_ID> 	
		<cfquery name="ADD_VOUCHER_HISTORY" datasource="#dsn2#" result="MAX_ID"><!-----Senet tarihçesine kayıt ediyor------>
			INSERT INTO
				VOUCHER_HISTORY
				(
					VOUCHER_ID,
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
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.voucher_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#p_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="3">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#attributes.act_date#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_voucher.other_money_value#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_voucher.other_money#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_voucher.other_money_value2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_voucher.other_money2#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
				)
		</cfquery>
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
				INSERT INTO VOUCHER_HISTORY_MONEY 
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
					'#wrk_eval("attributes.hidden_rd_money_#i#")#',
					#evaluate("attributes.txt_rate2_#i#")#,
					#evaluate("attributes.txt_rate1_#i#")#,
					<cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money_value>1<cfelse>0</cfif>
				)
			</cfquery>
		</cfloop>
		<cfquery name="get_cari_id" datasource="#dsn2#">
			SELECT CARI_ACTION_ID,ACTION_TYPE_ID,FROM_CMP_ID,FROM_CONSUMER_ID FROM CARI_ROWS WHERE ACTION_ID = #evaluate("attributes.voucher_id")# AND ACTION_TYPE_ID IN(97,107)
		</cfquery>
		<cfquery name="add_voucher_close" datasource="#dsn2#">
			INSERT INTO
				VOUCHER_CLOSED
			(
				PAYROLL_ID,
				CARI_ACTION_ID,
				ACTION_ID,
				ACTION_TYPE_ID,
				ACTION_VALUE,
				CLOSED_AMOUNT,
				OTHER_CLOSED_AMOUNT,
				OTHER_MONEY
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#p_id#">,
				<cfif get_cari_id.recordcount><cfqueryparam cfsqltype="cf_sql_integer" value="#get_cari_id.cari_action_id#">,<cfelse>NULL,</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.voucher_id#">,
				<cfif get_cari_id.recordcount><cfqueryparam cfsqltype="cf_sql_integer" value="#get_cari_id.action_type_id#">,<cfelse>NULL,</cfif>
				<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.SYSTEM_CURRENCY_VALUE#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.VOUCHER_VALUE#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.VOUCHER_VALUE#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">	
			)
		</cfquery>
		<cfquery name="ADD_BORDRO_TO_CASH" datasource="#dsn2#" result="XX">
			INSERT INTO
				CASH_ACTIONS
				(
					PROCESS_CAT,
					PAPER_NO,
					ACTION_TYPE,
					ACTION_TYPE_ID,
					CASH_ACTION_VALUE,
					CASH_ACTION_CURRENCY_ID,
					CASH_ACTION_TO_CASH_ID,
					ACTION_DATE,
					OTHER_CASH_ACT_VALUE,
					OTHER_MONEY,
					REVENUE_COLLECTOR_ID,
					ACTION_DETAIL,
					IS_ACCOUNT,
					IS_ACCOUNT_TYPE,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					ACTION_VALUE,
					ACTION_CURRENCY_ID,
					CASH_ACTION_FROM_COMPANY_ID,
					CASH_ACTION_FROM_CONSUMER_ID
					<cfif len(session.ep.money2)>
						,ACTION_VALUE_2
						,ACTION_CURRENCY_ID_2
					</cfif>
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#P_ID#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="NAKİT TAHSİLAT">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="31">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.VOUCHER_VALUE#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.currency_type#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cash_id#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#attributes.act_date#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.system_currency_value#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,				
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="SENET TAHSİLAT İŞLEMİ">,
					<cfif is_account eq 1>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="11">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.VOUCHER_VALUE#">,
					<Cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
					<cfif len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
					<cfif len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>
					<cfif len(session.ep.money2)>
						,#wrk_round(attributes.VOUCHER_VALUE/currency_multiplier,4)#
						,<Cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
					</cfif>					
				)
		</cfquery>
		<cfquery name="add_rel_action" datasource="#dsn2#">
			INSERT INTO
				VOUCHER_PAYROLL_ACTIONS
				(
					PAYROLL_ID,
					ACTION_ID,
					ACTION_TYPE_ID
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#p_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#xx.IDENTITYCOL#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="31">
				)
		</cfquery>
		<cfquery name="GET_PAYROLL" datasource="#dsn2#">
			SELECT PAYROLL_ACCOUNT_ID FROM PAYROLL WHERE ACTION_ID = #P_ID#
		</cfquery>
		<cfscript>
			if(is_cari eq 1 and attributes.VOUCHER_VALUE gt 0)//eğer ödeme sözü varsa cari işlem yapılıyor
			{
				carici(
						action_id :XX.IDENTITYCOL,
						workcube_process_type : 31,
						process_cat : 0,
						account_card_type :11,
						action_table :'CASH_ACTIONS',
						islem_tarihi : attributes.act_date,
						islem_tutari : attributes.system_currency_value,
						islem_belge_no :P_ID,
						action_currency : session.ep.money,
						to_cash_id : listfirst(attributes.kasa,';'),
						from_cmp_id : attributes.company_id,
						from_consumer_id : attributes.consumer_id,
						revenue_collector_id :session.ep.userid,
						other_money_value : attributes.masraf,
						other_money : attributes.other_money,
						action_detail : 'ÖDEME SÖZÜ TAHSİLAT İŞLEMİ',
						currency_multiplier : currency_multiplier,
						islem_detay : 'NAKİT TAHSİLAT',
						to_branch_id : cash_branch_id
					);
			}
			
			if(isdefined("attributes.expense_item_id") and len(attributes.expense_item_id) and len(attributes.expense_item_name) and (attributes.masraf gt 0) and len(attributes.expense_center_id) and len(attributes.expense_center))
			{
				butceci(
					action_id : XX.IDENTITYCOL,
					muhasebe_db : dsn2,
					is_income_expense : false,
					process_type : process_type,
					nettotal : wrk_round(attributes.masraf*currency_multiplier),
					other_money_value : attributes.masraf,
					action_currency : rd_money_value,
					currency_multiplier : currency_multiplier,
					expense_date : attributes.act_date,
					expense_center_id : attributes.expense_center_id,
					expense_item_id : attributes.expense_item_id,
					detail : UCase(getLang('main',2734)),//ÇEK TAHSİL MASRAFI
					company_id : attributes.COMPANY_ID,
					consumer_id : attributes.CONSUMER_ID,
					branch_id : listgetat(session.ep.user_location,2,'-'),
					insert_type : 1
				);
				GET_EXP_ACC = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #attributes.expense_item_id#");
			}
			if(is_account eq 1)
			{
				alacakli_hesaplar = '';
				alacakli_tutarlar = '';
				other_amount_alacak_list = '';
				other_currency_alacak_list = '';
				borclu_hesaplar = '';
				borclu_tutarlar = '';
				other_amount_borc_list='';
				other_currency_borc_list='';
				GET_ACC_CODE = cfquery(datasource:"#dsn2#",sqlstring:"SELECT CASH_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(attributes.kasa,';')#");
				acc = GET_ACC_CODE.CASH_ACC_CODE;
				satir_detay_list = ArrayNew(2);
				
				senet_tutar = attributes.system_currency_value;
				if(attributes.other_money is session.ep.money)
					other_alacak_ = attributes.system_currency_value; 
				else
					other_alacak_ = attributes.VOUCHER_VALUE; 
				alacakli_tutarlar=listappend(alacakli_tutarlar,senet_tutar,',');
				other_currency_alacak_list = listappend(other_currency_alacak_list,attributes.other_money,',');
				other_amount_alacak_list =  listappend(other_amount_alacak_list,other_alacak_,',');
				if(get_voucher.IS_PAY_TERM eq 0)
				{
					GET_VOUCHER_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"
						SELECT
							C.A_VOUCHER_ACC_CODE
						FROM
							VOUCHER_PAYROLL AS VP,
							VOUCHER_HISTORY AS VH,
							CASH AS C
						WHERE
							VP.PAYROLL_CASH_ID = C.CASH_ID AND
							(VP.PAYROLL_TYPE=97 OR VP.PAYROLL_TYPE = 109 OR (VP.PAYROLL_TYPE=107 AND VP.PAYROLL_NO='-1')) AND
							VP.ACTION_ID= VH.PAYROLL_ID AND
							VH.VOUCHER_ID=#attributes.voucher_id#");
					alacakli_hesaplar=listappend(alacakli_hesaplar, GET_VOUCHER_ACC_CODE.A_VOUCHER_ACC_CODE, ',');
					satir_detay_list[2][listlen(alacakli_tutarlar)] = '#attributes.company_id# - #dateformat(now(),dateformat_style)# VADELİ SENET TAHSİL İŞLEMİ';
				}
				else
				{
					alacakli_hesaplar=listappend(alacakli_hesaplar, MY_ACC_RESULT, ',');
					satir_detay_list[2][listlen(alacakli_tutarlar)] = '#attributes.company_id# - #dateformat(now(),dateformat_style)# VADELİ ÖDEME SÖZÜ TAHSİL İŞLEMİ';
				}
				borclu_hesaplar=listappend(borclu_hesaplar,GET_ACC_CODE.CASH_ACC_CODE,',');
				borclu_tutarlar=listappend(borclu_tutarlar,attributes.system_currency_value,',');
				
				other_amount_borc_list = listappend(other_amount_borc_list,attributes.voucher_value,',');
				other_currency_borc_list = listappend(other_currency_borc_list,'#get_voucher.currency_id#',',');
				satir_detay_list[1][1] = 'SENET TAHSİLAT İŞLEMİ';
				
				muhasebeci (
					action_id:XX.IDENTITYCOL,
					workcube_process_type:31,
					account_card_type:11,
					company_id : attributes.company_id,
					consumer_id : attributes.consumer_id,
					action_table :'CASH_ACTIONS',
					islem_tarihi: attributes.act_date,
					borc_hesaplar: borclu_hesaplar,
					borc_tutarlar: borclu_tutarlar,
					other_amount_borc: other_amount_borc_list,
					other_currency_borc: other_currency_borc_list,
					alacak_hesaplar: alacakli_hesaplar,
					alacak_tutarlar: alacakli_tutarlar,
					other_amount_alacak: other_amount_alacak_list,
					other_currency_alacak: other_currency_alacak_list,
					action_value2:attributes.system_currency_value2,
					action_currency_2 : session.ep.money2,
					fis_detay:'NAKİT TAHSİLAT',
					fis_satir_detay: satir_detay_list,
					belge_no : P_ID,
					from_branch_id : cash_branch_id,
					is_account_group : is_account_group
					);
			}	
		</cfscript>
	</cftransaction>
</cflock>	
<script type="text/javascript">
	location.href = document.referrer;
</script>
