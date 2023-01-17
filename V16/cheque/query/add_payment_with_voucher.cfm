<cf_get_lang_set module_name="cheque">
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		IS_CHEQUE_BASED_ACTION
	 FROM 
		SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfset process_type = get_process_type.PROCESS_TYPE>
<cfset is_cari =get_process_type.IS_CARI>
<cfset is_account = get_process_type.IS_ACCOUNT>
<cfset is_voucher_based = get_process_type.IS_CHEQUE_BASED_ACTION>
<cfset rd_money_value = session.ep.money>
<cfquery name="control_no" datasource="#dsn2#">
	SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_NO = '#attributes.PAYROLL_NO#' 
</cfquery>
<cfif is_account eq 1>
	<cfif len(attributes.company_id)>
		<cfset acc=get_company_period(attributes.company_id)>
	<cfelse>
		<cfset acc=get_consumer_period(attributes.consumer_id)>
	</cfif>
	<cfif not len(acc)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='126.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfloop from="1" to="#attributes.record_num#" index="kk">
	<cfif evaluate("attributes.row_kontrol#kk#")>
		<cfscript>
			'attributes.voucher_value#kk#' = filterNum(evaluate('attributes.voucher_value#kk#'));
			'attributes.voucher_system_value#kk#' = filterNum(evaluate('attributes.voucher_system_value#kk#'));
		</cfscript>
	</cfif>
</cfloop>
<cfscript>
	attributes.total_voucher_value = filterNum(attributes.total_voucher_value);
	attributes.net_total = filterNum(attributes.net_total);
	currency_multiplier ='';
</cfscript>
<cfquery name="get_moneys" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfoutput query="get_moneys">
	<cfif get_moneys.money eq session.ep.money2>
		<cfset currency_multiplier = get_moneys.rate2 / get_moneys.rate1>
	</cfif>
</cfoutput>
<!--- Satır ağırlıklarına göre ortalama vade hesaplanıyor --->
<cfset all_total =0 >
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
		<cfset my_date = DateDiff("d",now(),evaluate("attributes.due_date#i#"))>
		<cfset all_total = all_total + (evaluate("attributes.voucher_system_value#i#")*my_date)>
	</cfif>
</cfloop>
<cfset tarih_farki = all_total / attributes.total_voucher_value>
<cfset average_due_date = dateformat(DateAdd("d",tarih_farki,now()),dateformat_style)>
<cf_date tarih="average_due_date">
<cf_date tarih="attributes.payroll_revenue_date">
<cf_date tarih="attributes.revenue_start_date">
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<!--- Senet iadeleri yapılıyor --->
		<cfinclude template="add_payment_with_voucher_return.cfm">
		<!--- Yeni senetler kaydediliyor --->
		<cfquery name="ADD_PAYROLL" datasource="#dsn2#">
		 INSERT INTO
			VOUCHER_PAYROLL
			(
				PROCESS_CAT,
				PAYROLL_TYPE,
				COMPANY_ID,
				CONSUMER_ID,
				PAYROLL_TOTAL_VALUE,
				PAYROLL_OTHER_MONEY,
				PAYROLL_OTHER_MONEY_VALUE, 
				NUMBER_OF_VOUCHER,
				PAYROLL_CASH_ID,
				CURRENCY_ID,
				PAYROLL_REVENUE_DATE,
				<cfif len(attributes.PAYROLL_NO)>PAYROLL_NO,</cfif>
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				REVENUE_COLLECTOR_ID,
				VOUCHER_BASED_ACC_CARI,
				PAYMETHOD_ID
			)
			VALUES
			(
				#form.process_cat#,
				#process_type#,
				<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
				#attributes.total_voucher_value#,
				<cfif len(rd_money_value)>'#rd_money_value#',<cfelse>NULL,</cfif>				
				#attributes.total_voucher_value#,
				#attributes.due_month#,
				#listfirst(attributes.cash_id,';')#,
				'#session.ep.money#',
				#attributes.payroll_revenue_date#,
				<cfif len(attributes.PAYROLL_NO)>'#attributes.PAYROLL_NO#',</cfif>
				#session.ep.userid#,
				'#CGI.REMOTE_ADDR#',
				#NOW()#,
				#session.ep.userid#,
				<cfif len(is_voucher_based)>#is_voucher_based#<cfelse>0</cfif>,
				<cfif len("attributes.paymethod_id")>#attributes.paymethod_id#<cfelse>NULL</cfif>
			)
		</cfquery>
		<cfquery name="get_bordro_id" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS P_ID FROM VOUCHER_PAYROLL
		</cfquery>
		<cfset P_ID=get_bordro_id.P_ID>
		<cfoutput query="get_moneys">
			<cfquery name="add_money_obj_bskt" datasource="#dsn2#">
				INSERT INTO VOUCHER_PAYROLL_MONEY 
				(
					ACTION_ID,
					MONEY_TYPE,
					RATE2,
					RATE1,
					IS_SELECTED
				)
				VALUES
				(
					#P_ID#,
					'#get_moneys.money#',
					#get_moneys.rate2#,
					#get_moneys.rate1#,
				<cfif get_moneys.money is session.ep.money>
					1
				<cfelse>
					0
				</cfif>					
				)
			</cfquery>
		</cfoutput>	
		<cfset portfoy_no = get_cheque_no(belge_tipi:'voucher')>
		<cfset a_voucher = 1>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
				<cf_date tarih='attributes.due_date#i#'>
				<cfquery name="ADD_VOUCHER" datasource="#dsn2#" result="MAX_ID">
				  INSERT INTO
					VOUCHER
					(
						VOUCHER_PAYROLL_ID,
						VOUCHER_NO,
						COMPANY_ID,
						CONSUMER_ID,						
						VOUCHER_VALUE,
						CURRENCY_ID,
						OTHER_MONEY_VALUE,
						OTHER_MONEY,
						OTHER_MONEY_VALUE2,
						OTHER_MONEY2,
						VOUCHER_STATUS_ID,
						VOUCHER_PURSE_NO,
						SELF_VOUCHER,
						VOUCHER_DUEDATE,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
					VALUES
					(
						#P_ID#,
						'#attributes.payroll_no##a_voucher#',
						<cfif len(attributes.COMPANY_ID)>#attributes.COMPANY_ID#<cfelse>NULL</cfif>,
						<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
						#evaluate("attributes.voucher_value#i#")#,
						'#session.ep.money#',
						#evaluate("attributes.voucher_system_value#i#")#,
						'#session.ep.money#',
						#wrk_round((evaluate("attributes.voucher_system_value#i#")/currency_multiplier))#,
						'#session.ep.money2#',
						1,
						'#portfoy_no#',
						0,
						#evaluate("attributes.due_date#i#")#,
						#session.ep.userid#,
						'#cgi.remote_addr#',
						#now()#
						)
				</cfquery>
				<cfoutput query="get_moneys">
					<cfquery name="add_money_obj_bskt" datasource="#dsn2#">
						INSERT INTO VOUCHER_MONEY 
						(
							ACTION_ID,
							MONEY_TYPE,
							RATE2,
							RATE1,
							IS_SELECTED
						)
						VALUES
						(
							#MAX_ID.IDENTITYCOL#,
							'#get_moneys.money#',
							#get_moneys.rate2#,
							#get_moneys.rate1#,
						<cfif get_moneys.money is session.ep.money>1<cfelse>0</cfif>					
						)
					</cfquery>
				</cfoutput>	
				<cfset portfoy_no = portfoy_no+1>
				<cfset a_voucher = a_voucher+1>
			</cfif>
		</cfloop>
		<cfset portfoy_no = get_cheque_no(belge_tipi:'voucher',belge_no:portfoy_no)>
		<cfquery name="get_last_vouchers" datasource="#dsn2#">
			SELECT * FROM VOUCHER WHERE VOUCHER_PAYROLL_ID=#P_ID#
		</cfquery>
		<cfoutput query="get_last_vouchers">
			<cfquery name="ADD_VOUCHER_HISTORY" datasource="#dsn2#">
				INSERT INTO
					VOUCHER_HISTORY
					(
						VOUCHER_ID,
						COMPANY_ID,
						CONSUMER_ID,
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
						#VOUCHER_ID#,
						<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
						#VOUCHER_PAYROLL_ID#,
						#VOUCHER_STATUS_ID#,
						#attributes.PAYROLL_REVENUE_DATE#,
						<cfif len(OTHER_MONEY_VALUE)>#OTHER_MONEY_VALUE#,<cfelse>NULL,</cfif>
						<cfif len(OTHER_MONEY)>'#OTHER_MONEY#',<cfelse>NULL,</cfif>
						<cfif len(OTHER_MONEY_VALUE2)>#OTHER_MONEY_VALUE2#,<cfelse>NULL,</cfif>
						<cfif len(OTHER_MONEY2)>'#OTHER_MONEY2#',<cfelse>NULL,</cfif>
						#NOW()#
					)
			</cfquery>
		</cfoutput>
	<cfif attributes.net_total neq attributes.total_voucher_value>
		<cfset fark_tutar = attributes.total_voucher_value - attributes.net_total>
		<cfinclude template="add_payment_with_voucher_dekont.cfm">
	</cfif>
	<cfscript>
		if(is_cari eq 1)
		{
			if(is_voucher_based eq 1) /*cari hareket senet bazında yapılıyor.senet bazında carici calıstırılırken ACTION_TABLE parametresine dikkat plz...*/
			{				
					for(ind_cari=1; ind_cari lte get_last_vouchers.recordcount; ind_cari=ind_cari+1)
					{
						if(get_last_vouchers.CURRENCY_ID[ind_cari] is not session.ep.money)
						{
							other_money =get_last_vouchers.CURRENCY_ID[ind_cari];
							other_money_value =get_last_vouchers.VOUCHER_VALUE[ind_cari];
						}
						else if(len(rd_money_value))
						{
							other_money = rd_money_value;
							other_money_value = wrk_round(get_last_vouchers.VOUCHER_VALUE[ind_cari]);
						}
						else if(len(get_last_vouchers.OTHER_MONEY_VALUE2[ind_cari]) and len(get_last_vouchers.OTHER_MONEY2[ind_cari]))
						{
							other_money =get_last_vouchers.OTHER_MONEY2[ind_cari];
							other_money_value =get_last_vouchers.OTHER_MONEY_VALUE2[ind_cari];
						}
						else
						{
							other_money =get_last_vouchers.OTHER_MONEY[ind_cari];
							other_money_value =get_last_vouchers.OTHER_MONEY_VALUE[ind_cari];
						}
						carici(
							action_id :get_last_vouchers.voucher_id[ind_cari],
							workcube_process_type :process_type,		
							process_cat : form.process_cat,
							account_card_type :13,
							action_table :'VOUCHER',
							islem_tarihi :attributes.payroll_revenue_date,
							islem_tutari :get_last_vouchers.other_money_value[ind_cari],
							other_money_value : iif(isdefined('other_money_value'),'other_money_value',de('')),
							other_money :iif(isdefined('other_money'),'other_money',de('')),
							islem_belge_no : get_last_vouchers.voucher_no[ind_cari],
							action_currency :session.ep.money,
							to_cash_id : listfirst(form.cash_id,';'),
							due_date :createodbcdatetime(get_last_vouchers.voucher_duedate[ind_cari]),
							from_cmp_id :attributes.company_id,
							from_consumer_id : attributes.consumer_id,
							currency_multiplier : currency_multiplier,
							islem_detay : 'SENET GİRİŞ BORDROSU(Senet Bazında)',
							payroll_id :P_ID, 
							to_branch_id : listlast(form.cash_id,';')
							);
					}
				}
				else
				{
					carici(
						action_id :P_ID,
						workcube_process_type :process_type,		
						process_cat : form.process_cat,
						account_card_type :13,
						action_table :'VOUCHER_PAYROLL',
						islem_tarihi :attributes.PAYROLL_REVENUE_DATE,
						islem_tutari :attributes.total_voucher_value,
						other_money_value : attributes.total_voucher_value,
						other_money :iif(len(rd_money_value),'rd_money_value',de('')),
						action_currency :session.ep.money ,
						from_cmp_id :COMPANY_ID,
						from_consumer_id:attributes.consumer_id,
						islem_belge_no : attributes.payroll_no,
						to_cash_id : listfirst(form.cash_id,';'),
						due_date : average_due_date,
						currency_multiplier : currency_multiplier,
						islem_detay : 'SENET GİRİŞ BORDROSU',
						to_branch_id : listlast(form.cash_id,';')
						);
				}
		}
		if(is_account eq 1)
		{
			GET_NO_=cfquery(datasource:"#dsn2#", sqlstring:"SELECT * FROM #dsn3_alias#.SETUP_INVOICE");			
			GET_ACC_CODE=cfquery(datasource:"#dsn2#", sqlstring:"SELECT A_VOUCHER_ACC_CODE FROM CASH WHERE CASH_ID=#listfirst(form.cash_id,';')#");
			check_tutar_list = '';
			check_hesap_list = '';
			other_currency_borc_list= '';
			other_amount_borc_list= '';
			for(i=1; i lte get_last_vouchers.recordcount; i=i+1)
			{
				if(get_last_vouchers.CURRENCY_ID[i] neq session.ep.money)
					check_tutar_list = listappend(check_tutar_list,get_last_vouchers.OTHER_MONEY_VALUE[i],',');
				else
					check_tutar_list=listappend(check_tutar_list,get_last_vouchers.VOUCHER_VALUE[i],',');
				if(get_last_vouchers.CURRENCY_ID[i] is not session.ep.money)
				{
					other_currency_borc_list =listappend(other_currency_borc_list,get_last_vouchers.CURRENCY_ID[i]);
					other_amount_borc_list =listappend(other_amount_borc_list,get_last_vouchers.VOUCHER_VALUE[i]);
				}
				else if(len(rd_money_value))
				{
					other_currency_borc_list = listappend(other_currency_borc_list,rd_money_value,',');
					other_amount_borc_list =  listappend(other_amount_borc_list,wrk_round(get_last_vouchers.OTHER_MONEY_VALUE[i]),',');
				}
				else if(get_last_vouchers.OTHER_MONEY_VALUE2[i])	
				{
					other_currency_borc_list = listappend(other_currency_borc_list,get_last_vouchers.OTHER_MONEY2[i]);
					other_amount_borc_list = listappend(other_amount_borc_list,get_last_vouchers.OTHER_MONEY_VALUE2[i]);
				}	
				else
				{
					other_currency_borc_list = listappend(other_currency_borc_list,get_last_vouchers.OTHER_MONEY[i],',');
					other_amount_borc_list =  listappend(other_amount_borc_list,get_last_vouchers.OTHER_MONEY_VALUE[i],',');
				}
				check_hesap_list=listappend(check_hesap_list,GET_ACC_CODE.A_VOUCHER_ACC_CODE,',');
			}
			muhasebeci (
				action_id:P_ID,
				workcube_process_type:process_type,
				account_card_type:13,
				action_table :'VOUCHER_PAYROLL',
				islem_tarihi:attributes.PAYROLL_REVENUE_DATE,
				company_id : attributes.company_id,
				consumer_id : attributes.consumer_id,
				borc_hesaplar: check_hesap_list,
				borc_tutarlar: check_tutar_list,
				other_amount_borc : other_amount_borc_list,
				other_currency_borc :other_currency_borc_list,
				alacak_hesaplar: acc,
				alacak_tutarlar: attributes.total_voucher_value,
				other_amount_alacak : attributes.total_voucher_value,
				other_currency_alacak : iif(len(rd_money_value),'rd_money_value',de('')),
				fis_detay:'SENET GİRİŞİ',
				fis_satir_detay:'#dateformat(attributes.PAYROLL_REVENUE_DATE,dateformat_style)# VADELİ SENET GİRİŞ İŞLEMİ',
				currency_multiplier : currency_multiplier,
				belge_no : form.payroll_no,
				to_branch_id : listlast(form.cash_id,';'),
				dept_round_account :GET_NO_.FARK_GIDER,
				claim_round_account : GET_NO_.FARK_GELIR,
				max_round_amount :0.09,
				round_row_detail:'#dateformat(attributes.PAYROLL_REVENUE_DATE,dateformat_style)# VADELİ SENET GİRİŞ İŞLEMİ',
				workcube_process_cat : form.process_cat
				);
		}
	</cfscript>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

