<!--- teminat tabloları crm ekranlarnda da kullanılıyor ama sayfalar ortaklaştırılmadı şimdilik,ayrı özellikleri var--->
<cfif len(attributes.START_DATE)><cf_date tarih = "attributes.START_DATE"></cfif>
<cfif len(attributes.FINISH_DATE)><cf_date tarih = "attributes.FINISH_DATE"></cfif>

<cfset attributes.acc_type_id = ''>
<cfif len(attributes.company_id) and find("_", attributes.company_id) neq 0>
	<cfset attributes.acc_type_id = listlast(attributes.company_id,'_')>
	<cfset attributes.company_id = listfirst(attributes.company_id,'_')>
<cfelseif len(attributes.consumer_id) and find("_", attributes.consumer_id) neq 0>
	<cfset attributes.acc_type_id = listlast(attributes.consumer_id,'_')>
	<cfset attributes.consumer_id = listfirst(attributes.consumer_id,'_')>
</cfif>

<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		IS_ACCOUNT,
		IS_CARI,
		IS_ACCOUNT_GROUP,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	rd_money = listfirst(attributes.rd_money,',');
	process_type = get_process_type.PROCESS_TYPE;
	is_account = get_process_type.IS_ACCOUNT;
	is_cari = get_process_type.IS_CARI;
	is_account_group = get_process_type.IS_ACCOUNT_GROUP;
	attributes.action_value = filterNum(attributes.action_value);
	attributes.action_value_2 = filterNum(attributes.action_value_2);
	attributes.expense_total = filterNum(attributes.expense_total);
	if(isDefined('attributes.commission_rate') and len(attributes.commission_rate))
		attributes.commission_rate = filterNum(attributes.commission_rate);
	for(d_sy = 1; d_sy lte attributes.kur_say; d_sy = d_sy+1)
	{
		'attributes.txt_rate1_#d_sy#' = filterNum(evaluate('attributes.txt_rate1_#d_sy#'),session.ep.our_company_info.rate_round_num);
		'attributes.txt_rate2_#d_sy#' = filterNum(evaluate('attributes.txt_rate2_#d_sy#'),session.ep.our_company_info.rate_round_num);
	}
	currency_multiplier = '';//sistem ikinci para biriminin kurunu sayfadan alıyor
	if(isDefined('attributes.kur_say') and len(attributes.kur_say))
		for(mon=1;mon lte attributes.kur_say;mon=mon+1)
			if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2)
				currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
</cfscript>
<cf_papers paper_type="securefund">
<cflock timeout="60" name="#CreateUUID()#">
	<cftransaction>	
		<cfif Len(attributes.SECUREFUND_FILE)>
			<cftry>
				<cfset file_name = CreateUUID()>
				<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="SECUREFUND_FILE" destination="#upload_folder#member">
				<cffile action="rename" source="#upload_folder#member#dir_seperator##cffile.serverfile#" destination="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
				<!---Script dosyalarını engelle  02092010 FA-ND --->
				<cfset assetTypeName = listlast(cffile.serverfile,'.')>
				<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
				<cfif listfind(blackList,assetTypeName,',')>
					<cffile action="delete" file="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
					<script type="text/javascript">
						alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
						history.back();
					</script>
					<cfabort>
				</cfif>
				
				<cfcatch>
					<script type="text/javascript">
						alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
						history.back();
					</script>
					<cfabort>
				</cfcatch>
			</cftry>
		</cfif>
		<cfquery name="add_secure" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				#dsn_alias#.COMPANY_SECUREFUND
				(
					SECUREFUND_STATUS,
					COMPANY_ID,
					CONSUMER_ID,
					ACCOUNT_TYPE_ID,
					OUR_COMPANY_ID,
                    OURCOMP_BRANCH,
					SECUREFUND_CAT_ID,
					GIVE_TAKE,
					SECUREFUND_TOTAL,
					ACTION_VALUE,
					ACTION_VALUE2,
					MONEY_CAT,
					MONEY_CAT_EXPENSE,	
					EXPENSE_TOTAL,
					BANK_BRANCH_ID,
					REALESTATE_DETAIL,
					START_DATE,
					FINISH_DATE,
					<cfif len(attributes.SECUREFUND_FILE)>SECUREFUND_FILE,</cfif>
					<cfif len(attributes.SECUREFUND_FILE)>SECUREFUND_FILE_SERVER_ID,</cfif>
					ACTION_TYPE_ID,
					ACTION_CAT_ID,
					GIVEN_ACC_CODE,
					TAKEN_ACC_CODE,
					COMMISSION_RATE,
					ACTION_PERIOD_ID,
					PROJECT_ID,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					CREDIT_LIMIT,
					CONTRACT_ID,
					OFFER_ID,
					PAPER_NO,
					DEPARTMENT_ID
				)
			VALUES
				(
					<cfif isdefined("attributes.SECUREFUND_STATUS")>1,<cfelse>0,</cfif>
					<cfif len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
					<cfif isdefined('attributes.acc_type_id') and len(attributes.acc_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_type_id#"><cfelse>NULL</cfif>,
					#attributes.our_company_id#,
                    <cfif len(attributes.comp_branch_id)>#attributes.comp_branch_id#,<cfelse>NULL,</cfif>
					#attributes.SECUREFUND_CAT_ID#,
					#attributes.give_take#,
					#attributes.action_value_2#,
					#attributes.action_value#,
					<cfif len(currency_multiplier)>#wrk_round(attributes.action_value/currency_multiplier)#<cfelse>NULL</cfif>,
					'#rd_money#',
					<cfif len(attributes.money_cat_expense)>'#attributes.money_cat_expense#',<cfelse>NULL,</cfif>
					<cfif len(attributes.EXPENSE_TOTAL)>#attributes.EXPENSE_TOTAL#,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID)>#attributes.BRANCH_ID#,<cfelse>NULL,</cfif>
 					<cfif len(attributes.REALESTATE_DETAIL)>'#attributes.REALESTATE_DETAIL#',<cfelse>NULL,</cfif>
					<cfif len(attributes.START_DATE)>#attributes.START_DATE#,<cfelse>NULL,</cfif>
					<cfif len(attributes.FINISH_DATE)>#attributes.FINISH_DATE#,<cfelse>NULL,</cfif>
					<cfif len(attributes.SECUREFUND_FILE)>
						'#file_name#.#cffile.serverfileext#',
						#fusebox.server_machine#,
					</cfif>
					#process_type#,
					#attributes.process_cat#,
					<cfif len(attributes.given_acc_id) and len(attributes.given_acc_name)>'#attributes.given_acc_id#',<cfelse>NULL,</cfif>
					<cfif len(attributes.taken_acc_id) and len(attributes.taken_acc_name)>'#attributes.taken_acc_id#',<cfelse>NULL,</cfif>
					<cfif isDefined('attributes.commission_rate') and len(attributes.commission_rate)>#attributes.commission_rate#,<cfelse>0,</cfif>	
 					#session.ep.period_id#,
					<cfif isdefined("attributes.project_id")and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#,<cfelse>NULL,</cfif>
					#SESSION.EP.USERID#,
					'#REMOTE_ADDR#',
					#NOW()#,
					<cfif len(attributes.credit_limit_id) and len(attributes.credit_limit_name)>#attributes.credit_limit_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.contract_id") and len(attributes.contract_id) and len(attributes.contract_head)>#attributes.contract_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.offer_id") and len(attributes.offer_id) and len(attributes.offer_name)>#attributes.offer_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.paper_number") and len(attributes.paper_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_number#"><cfelse>NULL</cfif>,
					<cfif len(attributes.department) and len(attributes.department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"><cfelse>NULL</cfif>
				)
		</cfquery>
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="ADD_MONEY" datasource="#dsn2#">
				INSERT INTO
					#dsn_alias#.COMPANY_SECUREFUND_MONEY
					(
						MONEY_TYPE,
						ACTION_ID,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						'#wrk_eval("attributes.hidden_rd_money_#i#")#',
						 #MAX_ID.IDENTITYCOL#,
						 #evaluate("attributes.txt_rate2_#i#")#,
						 #evaluate("attributes.txt_rate1_#i#")#,
						 <cfif evaluate("attributes.hidden_rd_money_#i#") is rd_money>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfloop>
		<cfscript>
			if(is_cari and attributes.give_take eq 1)
			{
				carici (
					action_id : MAX_ID.IDENTITYCOL,
					action_table : 'COMPANY_SECUREFUND',
					workcube_process_type : process_type,		
					process_cat : attributes.process_cat,
					islem_tarihi : attributes.start_date,
					account_card_type: 13,
					action_detail : attributes.REALESTATE_DETAIL,
					islem_detay : 'TEMİNAT İŞLEMİ',
					project_id : attributes.project_id,
					from_cmp_id : attributes.company_id,
					from_consumer_id : attributes.consumer_id,
					acc_type_id : attributes.acc_type_id,
					currency_multiplier : currency_multiplier,
					islem_tutari : attributes.action_value,
					action_currency : session.ep.money,
					other_money_value : iif(len(attributes.action_value_2),'attributes.action_value_2',de('')),
					other_money : rd_money,
					islem_belge_no : attributes.paper_number,
					from_branch_id : iif(len(attributes.comp_branch_id),'attributes.comp_branch_id',de(''))
				);
			}
			else if(is_cari and attributes.give_take eq 0)
			{
				carici (
					action_id : MAX_ID.IDENTITYCOL,
					action_table : 'COMPANY_SECUREFUND',
					workcube_process_type : process_type,		
					process_cat : attributes.process_cat,
					islem_tarihi : attributes.start_date,
					account_card_type: 13,
					action_detail : attributes.REALESTATE_DETAIL,
					islem_detay : 'TEMİNAT İŞLEMİ',
					project_id : attributes.project_id,
					to_cmp_id : attributes.company_id,
					to_consumer_id : attributes.consumer_id,
					acc_type_id : attributes.acc_type_id,
					currency_multiplier : currency_multiplier,
					islem_tutari : attributes.action_value,
					action_currency : session.ep.money,
					other_money_value : iif(len(attributes.action_value_2),'attributes.action_value_2',de('')),
					other_money : rd_money,
					islem_belge_no : attributes.paper_number,
					to_branch_id : iif(len(attributes.comp_branch_id),'attributes.comp_branch_id',de(''))
				);	
			}
			
			if(is_account and len(attributes.given_acc_id) and len(attributes.given_acc_name) and len(attributes.taken_acc_id) and len(attributes.taken_acc_name))
			{
				if(isDefined("attributes.REALESTATE_DETAIL") and len(attributes.REALESTATE_DETAIL))
					str_detail = '#attributes.REALESTATE_DETAIL# - TEMİNAT İŞLEMİ';
				else
					str_detail = 'TEMİNAT İŞLEMİ';
					
				muhasebeci (
					action_id: MAX_ID.IDENTITYCOL,
					belge_no : attributes.paper_number,
					workcube_process_type: process_type,
					workcube_process_cat:attributes.process_cat,
					account_card_type: 13,
					company_id: attributes.company_id,
					consumer_id:attributes.consumer_id,
					islem_tarihi: attributes.start_date,
					fis_satir_detay: str_detail,
					borc_hesaplar: attributes.taken_acc_id,
					borc_tutarlar: attributes.action_value,
					other_amount_borc : iif(len(attributes.action_value_2),'attributes.action_value_2',de('')),
					other_currency_borc : rd_money,
					alacak_hesaplar: attributes.given_acc_id,
					alacak_tutarlar: attributes.action_value,
					other_amount_alacak : iif(len(attributes.action_value_2),'attributes.action_value_2',de('')),
					other_currency_alacak : rd_money,
					currency_multiplier : currency_multiplier,
					fis_detay : 'TEMİNAT İŞLEMİ',
					to_branch_id : listgetat(session.ep.user_location,2,'-'),
					acc_project_id : iif((isdefined("attributes.project_id") and len(attributes.project_id) and isDefined("attributes.project_head") and len(attributes.project_head)),attributes.project_id,de('')),
					is_acc_type : 1
				);
			}
		</cfscript>
 		<!--- Belge No update ediliyor --->
		<cfif len(paper_number)>
			<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN2#">
				UPDATE 
					#dsn3_alias#.GENERAL_PAPERS
				SET
					SECUREFUND_NUMBER = #paper_number#
				WHERE
					SECUREFUND_NUMBER IS NOT NULL
			</cfquery>
		</cfif>

		<cf_workcube_process_cat 
			process_cat="#attributes.process_cat#"
			action_id = "#MAX_ID.IDENTITYCOL#"
			action_table="COMPANY_SECUREFUND"
			action_column="SECUREFUND_ID"
			action_page='#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_securefund&event=upd&securefund_id=#MAX_ID.IDENTITYCOL#'
			action_db_type = "#dsn2#"
			is_action_file = "1"
			action_file_name='#get_process_type.action_file_name#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>

	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=finance.list_securefund&event=upd&securefund_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>
