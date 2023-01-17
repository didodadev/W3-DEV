<cfif not isdefined('xml_import') and form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1659.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=ch.list_caris</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_CARI,
		IS_ACCOUNT,
		PROCESS_CAT,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #attributes.process_cat#
</cfquery>
<cfset process_type = get_process_type.process_type>
<cfset is_cari =get_process_type.is_cari>
<cfset is_account = get_process_type.is_account>
<cfset ACTION_CURRENCY_ID = listlast(attributes.ACTION_CURRENCY_ID,';')> // BORÇ
<cfset ACTION_CURRENCY_ID_ = listlast(attributes.ACTION_CURRENCY_ID_,';')> // ALACAK 
<cf_date tarih="attributes.action_date">
<cf_date tarih="attributes.due_date">
<cf_date tarih="attributes.from_due_date">
<cfscript>
	if(not isdefined('xml_import'))
	{
		attributes.action_value = filterNum(attributes.action_value);
		attributes.OTHER_CASH_ACT_VALUE = filterNum(attributes.OTHER_CASH_ACT_VALUE);
		attributes.system_amount = filterNum(attributes.system_amount);
		for(dd_y=1; dd_y lte attributes.kur_say; dd_y=dd_y+1)
		{
			'attributes.txt_rate1_#dd_y#' = filterNum(evaluate('attributes.txt_rate1_#dd_y#'),session.ep.our_company_info.rate_round_num);
			'attributes.txt_rate2_#dd_y#' = filterNum(evaluate('attributes.txt_rate2_#dd_y#'),session.ep.our_company_info.rate_round_num);
		}
	}
	attributes.acc_type_id = '';
	attributes.from_acc_type_id = '';
	if(listlen(attributes.to_employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.to_employee_id,'_');
		attributes.to_employee_id = listfirst(attributes.to_employee_id,'_');
	}
	else if(listlen(attributes.to_company_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.to_company_id,'_');
		attributes.to_company_id = listfirst(attributes.to_company_id,'_');
	}
	else if(listlen(attributes.to_consumer_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.to_consumer_id,'_');
		attributes.to_consumer_id = listfirst(attributes.to_consumer_id,'_');
	}
	if(listlen(attributes.from_employee_id,'_') eq 2)
	{
		attributes.from_acc_type_id = listlast(attributes.from_employee_id,'_');
		attributes.from_employee_id = listfirst(attributes.from_employee_id,'_');
	}
	else if(listlen(attributes.from_company_id,'_') eq 2)
	{
		attributes.from_acc_type_id = listlast(attributes.from_company_id,'_');
		attributes.from_company_id = listfirst(attributes.from_company_id,'_');
	}
	else if(listlen(attributes.from_consumer_id,'_') eq 2)
	{
		attributes.from_acc_type_id = listlast(attributes.from_consumer_id,'_');
		attributes.from_consumer_id = listfirst(attributes.from_consumer_id,'_');
	}
</cfscript>

<cfif ACTION_CURRENCY_ID eq session.ep.money>
	<cfif attributes.system_amount neq attributes.action_value>
		<cfset attributes.system_amount = attributes.action_value>
	<cfelse>
		<cfset attributes.system_amount = attributes.system_amount>
	</cfif>
<cfelseif ACTION_CURRENCY_ID_ eq session.ep.money>
	<cfif attributes.system_amount neq attributes.OTHER_CASH_ACT_VALUE>
		<cfset attributes.system_amount = attributes.OTHER_CASH_ACT_VALUE>
	<cfelse>
		<cfset attributes.system_amount = attributes.system_amount>
	</cfif>
<cfelse>
	<cfset attributes.system_amount = attributes.system_amount>
</cfif>

<cfif is_account eq 1>
	<cfif attributes.to_member_type eq "partner" and len(attributes.to_company_id)>
		<cfset get_acc_code.account_code = get_company_period(attributes.to_company_id,session.ep.period_id,dsn2,attributes.acc_type_id)>
	<cfelseif attributes.to_member_type eq "consumer" and len(attributes.to_consumer_id)>
		<cfset get_acc_code.account_code = get_consumer_period(attributes.to_consumer_id,session.ep.period_id,dsn2,attributes.acc_type_id)>
	<cfelseif attributes.to_member_type eq "employee" and len(attributes.to_employee_id)>
		<cfset get_acc_code.account_code = get_employee_period(attributes.to_employee_id,attributes.acc_type_id)>
	</cfif>
	<cfif attributes.from_member_type eq "partner" and len(attributes.from_company_id)>
		<cfset get_acc_code.account_code2 = get_company_period(attributes.from_company_id,session.ep.period_id,dsn2,attributes.from_acc_type_id)>
	<cfelseif attributes.from_member_type eq "consumer" and len(attributes.from_consumer_id)>
		<cfset get_acc_code.account_code2 = get_consumer_period(attributes.from_consumer_id,session.ep.period_id,dsn2,attributes.from_acc_type_id)>
	<cfelseif attributes.from_member_type eq "employee" and len(attributes.from_employee_id)>
		<cfset get_acc_code.account_code2 = get_employee_period(attributes.from_employee_id,attributes.from_acc_type_id)>
	</cfif>
	<cfif not (len(get_acc_code.ACCOUNT_CODE) and len(get_acc_code.account_code2))>
		<cfif not isdefined('xml_import')>
			<script type="text/javascript">
				alert("<cf_get_lang no='76.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'>!");
				window.location.href='<cfoutput>#request.self#?fuseaction=ch.form_add_cari_to_cari</cfoutput>';
			</script>
		<cfelse>
			<cfoutput>Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş!</cfoutput>
		</cfif>
		<cfabort>
	</cfif>
</cfif>
<cf_papers paper_type="cari_to_cari">
<cflock name="#createUUID()#" timeout="60">	
	<cftransaction>
		<cfquery name="ADD_CARI_TO_CARI" datasource="#DSN2#">
			INSERT INTO
				CARI_ACTIONS
			(
				PROCESS_CAT,
				ACTION_NAME,
				ACTION_TYPE_ID,	
				ACTION_VALUE,
				ACTION_CURRENCY_ID,
				TO_CMP_ID,
				TO_CONSUMER_ID,
				TO_EMPLOYEE_ID,
				FROM_CMP_ID,
				FROM_CONSUMER_ID,
				FROM_EMPLOYEE_ID,
				OTHER_CASH_ACT_VALUE,
				OTHER_MONEY,
				PROJECT_ID,
				PROJECT_ID_2,
				ACTION_DETAIL,
				ACTION_DATE,
				DUE_DATE,
				PAPER_NO,
				ASSETP_ID,
				ASSETP_ID_2,
                ACC_TYPE_ID,
                FROM_ACC_TYPE_ID,
				TO_BRANCH_ID,
				FROM_BRANCH_ID,  
				TO_SUBSCRIPTION_ID,
				SUBSCRIPTION_ID,           
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				FROM_DUE_DATE			
			)
			VALUES
			(
				#attributes.process_cat#,
				'#UCase(getLang("main",1770))#',
				#process_type#,
				#attributes.action_value#,
				'#ACTION_CURRENCY_ID#',
				<cfif attributes.to_member_type eq "partner" and len(attributes.to_company_id)>#attributes.to_company_id#<cfelse>NULL</cfif>,
				<cfif attributes.to_member_type eq "consumer" and len(attributes.to_consumer_id)>#attributes.to_consumer_id#<cfelse>NULL</cfif>,
				<cfif attributes.to_member_type eq "employee" and len(attributes.to_employee_id)>#attributes.to_employee_id#<cfelse>NULL</cfif>,
				<cfif attributes.from_member_type eq "partner" and len(attributes.from_company_id)>#attributes.from_company_id#<cfelse>NULL</cfif>,
				<cfif attributes.from_member_type eq "consumer" and len(attributes.from_consumer_id)>#attributes.from_consumer_id#<cfelse>NULL</cfif>,
				<cfif attributes.from_member_type eq "employee" and len(attributes.from_employee_id)>#attributes.from_employee_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.OTHER_CASH_ACT_VALUE") and len(attributes.OTHER_CASH_ACT_VALUE)>#attributes.OTHER_CASH_ACT_VALUE#<cfelse>NULL</cfif>,
				'#ACTION_CURRENCY_ID_#',
				<cfif len(attributes.project_name) and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.project_name_2) and len(attributes.project_id_2)>#attributes.project_id_2#<cfelse>NULL</cfif>,
				'#attributes.action_detail#',
				#attributes.action_date#,
				<cfif len(attributes.due_date)>#attributes.due_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.paper_number)>'#attributes.paper_number#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.asset_id1") and len(attributes.asset_id1) and len(attributes.asset_name1)>#attributes.asset_id1#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.asset_id2") and len(attributes.asset_id2) and len(attributes.asset_name2)>#attributes.asset_id2#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.from_acc_type_id") and len(attributes.from_acc_type_id)>#attributes.from_acc_type_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.branch_id_borc") and len(attributes.branch_id_borc)>#attributes.branch_id_borc#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.branch_id_alacak") and len(attributes.branch_id_alacak)>#attributes.branch_id_alacak#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.subscription_id2") and len(attributes.subscription_id2)and len(attributes.subscription_no2)>#attributes.subscription_id2#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				<cfif len(attributes.from_due_date)>#attributes.from_due_date#<cfelse>NULL</cfif>		
			)					
		</cfquery>
		<cfquery name="GET_MAX" datasource="#DSN2#">
			SELECT MAX(ACTION_ID) AS ACTION_ID FROM CARI_ACTIONS
		</cfquery>		
		<cfscript>
			currency_multiplier = '';
			paper_currency_multiplier = '';
			paper_currency_multiplier2 = '';
			if(isDefined('attributes.kur_say') and len(attributes.kur_say))
				for(mon=1;mon lte attributes.kur_say;mon=mon+1)
				{
					if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
						currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if(evaluate("attributes.hidden_rd_money_#mon#") is ACTION_CURRENCY_ID) // borç tarafı para birimi
						paper_currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
					if(evaluate("attributes.hidden_rd_money_#mon#") is ACTION_CURRENCY_ID_) // alacak tarafı para pirimi
						paper_currency_multiplier2 = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
				}
			
			// borç tarafı 
				act_other_money_value = attributes.action_value; // para değeri
				act_other_money = ACTION_CURRENCY_ID; // para birimi

			// alacak tarafı 
				act_other_money_value_ = attributes.OTHER_CASH_ACT_VALUE; // para değeri
				act_other_money_ = ACTION_CURRENCY_ID_; // para birimi 
			
			//borclu sube
			if(isdefined("attributes.branch_id_borc") and len(attributes.branch_id_borc))
				to_branch_id_info = attributes.branch_id_borc;
			else
				to_branch_id_info = listgetat(session.ep.user_location,2,'-');	
			//alacakli sube	
			if(isdefined("attributes.branch_id_alacak") and len(attributes.branch_id_alacak))
				from_branch_id_info = attributes.branch_id_alacak;
			else
				from_branch_id_info = listgetat(session.ep.user_location,2,'-');	
			
			if (is_cari eq 1)
			{
					carici
					(
						action_id : get_max.action_id,
						islem_belge_no : attributes.paper_number,
						process_cat : attributes.process_cat,
						workcube_process_type : process_type,
						action_table : 'CARI_ACTIONS',
						islem_tutari : attributes.system_amount,
						action_currency : session.ep.money,
						islem_tarihi : attributes.action_date,
						due_date : attributes.due_date,
						action_detail : attributes.action_detail,
						islem_detay : UCase(getLang('main',1770)), //CARİ VİRMAN
						to_cmp_id : iif(attributes.to_member_type eq "partner",'attributes.to_company_id',de('')),
						to_consumer_id : iif(attributes.to_member_type eq "consumer",'attributes.to_consumer_id',de('')),
						to_employee_id : iif(attributes.to_member_type eq "employee",'attributes.to_employee_id',de('')),
						to_branch_id : to_branch_id_info,
						acc_type_id : attributes.acc_type_id,
						account_card_type : 13,
						other_money_value : act_other_money_value,
						other_money : act_other_money,
						project_id : attributes.project_id,
						currency_multiplier : currency_multiplier,
						special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
						assetp_id : iif((isdefined("attributes.asset_id1") and len(attributes.asset_id1) and len(attributes.asset_name1)),'attributes.asset_id1',de('')),
						rate2:paper_currency_multiplier
					);
					carici
					(
						action_id : get_max.action_id,
						islem_belge_no : attributes.paper_number,
						process_cat : attributes.process_cat,
						workcube_process_type : process_type,
						action_table : 'CARI_ACTIONS',
						islem_tutari : attributes.system_amount,
						action_currency : session.ep.money,
						islem_tarihi : attributes.action_date,
						due_date : attributes.from_due_date,
						action_detail : attributes.action_detail,
						islem_detay : UCase(getLang('main',1770)), //CARİ VİRMAN
						from_cmp_id : iif(attributes.from_member_type eq "partner",'attributes.from_company_id',de('')),
						from_consumer_id : iif(attributes.from_member_type eq "consumer",'attributes.from_consumer_id',de('')),
						from_employee_id : iif(attributes.from_member_type eq "employee",'attributes.from_employee_id',de('')),
						from_branch_id : from_branch_id_info,
						acc_type_id : attributes.from_acc_type_id,
						account_card_type : 13,
						other_money_value : act_other_money_value_,
						other_money : act_other_money_,
						project_id : attributes.project_id_2,
						currency_multiplier : currency_multiplier,
						special_definition_id : iif((isdefined("attributes.special_definition_id") and len(attributes.special_definition_id)),'attributes.special_definition_id',de('')),
						assetp_id : iif((isdefined("attributes.asset_id2") and len(attributes.asset_id2) and len(attributes.asset_name2)),'attributes.asset_id2',de('')),
						rate2:paper_currency_multiplier2
					);
			}
			if ((is_account eq 1) and len(get_acc_code.account_code) and len(get_acc_code.account_code2))
			{
				satir_detay_list = ArrayNew(2);
				satir_detay_list[1][1]= '#attributes.to_company_name#-#attributes.action_detail#'; //borclu satırın acıklaması
				satir_detay_list[2][1]='#attributes.from_company_name#-#attributes.action_detail#';//alacak satırın acıklaması
				acc_project_list_borc = '';
				acc_project_list_alacak = '';
				/*borclu proje muhabesebe kaydi */
				if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_name))
					acc_project_list_borc = listappend(acc_project_list_borc,attributes.project_id,',');
				else
					acc_project_list_borc = listappend(acc_project_list_borc,'',',');
				/*alacakli proje muhabesebe kaydi */
				if(isdefined("attributes.project_id_2") and len(attributes.project_id_2) and len(attributes.project_name_2))
					acc_project_list_alacak = listappend(acc_project_list_alacak,attributes.project_id_2,',');
				else
					acc_project_list_alacak = listappend(acc_project_list_alacak,'',',');
				
				muhasebeci
				(
					action_id : get_max.action_id,
					belge_no : attributes.paper_number,
					workcube_process_type : process_type,
					workcube_process_cat:attributes.process_cat,
					islem_tarihi : attributes.action_date,
					fis_detay :  UCase(getLang('main',1770)), //CARİ VİRMAN
					fis_satir_detay: satir_detay_list,
					company_id : iif(attributes.from_member_type eq "partner",'attributes.from_company_id',de('')),
					consumer_id : iif(attributes.from_member_type eq "consumer",'attributes.from_consumer_id',de('')),
					employee_id : iif(attributes.from_member_type eq "employee",'attributes.from_employee_id',de('')),
					borc_hesaplar : get_acc_code.account_code,
					borc_tutarlar : attributes.system_amount,
					alacak_hesaplar : get_acc_code.account_code2,
					alacak_tutarlar :attributes.system_amount,
					other_amount_alacak : iif(len(attributes.OTHER_CASH_ACT_VALUE),'attributes.OTHER_CASH_ACT_VALUE',de('')),
					other_currency_alacak : act_other_money_,
					other_amount_borc : attributes.action_value,
					other_currency_borc : act_other_money,
					currency_multiplier : currency_multiplier,
					to_branch_id : to_branch_id_info,
					from_branch_id : from_branch_id_info,
					acc_project_list_alacak : acc_project_list_alacak,
					acc_project_list_borc : acc_project_list_borc,
					account_card_type : 13,
					is_acc_type : 1
				);		
			}
			f_kur_ekle_action(action_id:get_max.action_id,process_type:0,action_table_name:'CARI_ACTION_MONEY',action_table_dsn:'#dsn2#');
		</cfscript>
		<cfif not isdefined('xml_import')>
			<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
				UPDATE 
					#dsn3_alias#.GENERAL_PAPERS
				SET
					CARI_TO_CARI_NUMBER = #paper_number#
				WHERE
					CARI_TO_CARI_NUMBER IS NOT NULL
			</cfquery>
		</cfif>
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			action_id = #get_max.action_id#
			is_action_file = 1
			action_file_name='#get_process_type.action_file_name#'
			action_page='#request.self#?fuseaction=ch.form_add_cari_to_cari&event=upd&id=#get_max.action_id#'
			action_db_type = '#dsn2#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
    <cf_add_log log_type="1" action_id="#get_max.action_id#" action_name="#attributes.paper_number# Eklendi" paper_no="#attributes.paper_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
</cflock>
<cfif not isdefined('xml_import')>
	<cfif my_fuseaction contains 'popup'>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
	<cfelse>
		<script type="text/javascript">	
			window.location.href='<cfoutput>#request.self#?fuseaction=ch.form_add_cari_to_cari&event=upd&id=#get_max.action_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>';
		</script>
	</cfif>
</cfif>
