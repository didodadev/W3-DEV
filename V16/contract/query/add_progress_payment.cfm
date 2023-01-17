<cfquery name="getContract" datasource="#dsn3#">
	SELECT CONTRACT_TYPE,CONTRACT_NO,PROJECT_ID,COMPANY_ID,CONSUMER_ID,CONTRACT_ID,ISNULL(TEVKIFAT_RATE,0) AS TEVKIFAT_RATE FROM RELATED_CONTRACT WHERE CONTRACT_ID = #attributes.contract_id#
</cfquery>
<cfquery name="getProgressNo" datasource="#dsn3#" maxrows="1">
	SELECT TOP 1 PROGRESS_NO FROM PROGRESS_PAYMENT WHERE CONTRACT_ID  = #attributes.contract_id# ORDER BY PROGRESS_ID DESC
</cfquery>
<cfif getProgressNo.recordcount><cfset _count_ = listlast(getProgressNo.progress_no,'-')+1><cfelse><cfset _count_ = 1></cfif>
<cfset progress_no = '#getContract.contract_id#-#_count_#'>

<cfif len(getContract.TEVKIFAT_RATE)><cf_papers paper_type="debit_claim"></cfif>

<cfset get_par_info_ = "">
<cfset get_cons_info_ = "">
<cfif isDefined("attributes.company_id") and Len(attributes.company_id)><cfset get_par_info_ = get_par_info(attributes.company_id,1,1,0)></cfif>
<cfif isDefined("attributes.consumer_id") and Len(attributes.consumer_id)><cfset get_cons_info_ = get_cons_info(attributes.consumer_id,0,0)></cfif>

<cflock timeout="60" name="#CreateUUID()#">
	<cftransaction>
		<cfquery name="add_progress_payment" datasource="#dsn2#" result="MAX_ID">
			INSERT INTO
				#dsn3_alias#.PROGRESS_PAYMENT
				(
					PROGRESS_TYPE,
					PROGRESS_VALUE,
					GROSS_PROGRESS_VALUE,
					TODAY_PROGRESS_VALUE,
					NET_PROGRESS_VALUE,
					PROGRESS_CURRENCY_ID,
					PROGRESS_DATE,
					PROGRESS_NO,
					PRODUCT_ID,
					STOCK_ID,
					COMPANY_ID,
					CONSUMER_ID,
					CONTRACT_ID,
					PROJECT_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					#getContract.contract_type#,
					#attributes.action_value#,
					#attributes.gross_progress_value#,
					#attributes.today_progress_value#,
					#attributes.net_progress_value#,
					'#attributes.action_currency_id#',
					#now()#,
					'#progress_no#',
					#attributes.product_id#,
					#attributes.stock_id#,
					<cfif len(getContract.company_id)>#getContract.company_id#<cfelse>NULL</cfif>,
					<cfif len(getContract.consumer_id)>#getContract.consumer_id#<cfelse>NULL</cfif>,
					#attributes.contract_id#,
					<cfif len(getContract.project_id)>#getContract.project_id#<cfelse>NULL</cfif>,
					#now()#,
					#session.ep.userid#,
					'#cgi.REMOTE_ADDR#'
				)
		</cfquery>
		<cfquery name="updProgressReceipt" datasource="#dsn2#">
			UPDATE 
				CARI_ACTIONS 
			SET 
				PROGRESS_ID = #MAX_ID.IDENTITYCOL# 
			WHERE 
				ACTION_VALUE > 0
				AND CONTRACT_ID = #attributes.contract_id# 
				<cfif len(attributes.company_id)>
                    AND (TO_CMP_ID = #attributes.company_id# OR FROM_CMP_ID = #attributes.company_id#)
                <cfelseif len(attributes.consumer_id)>
                    AND (TO_CONSUMER_ID = #attributes.consumer_id# OR FROM_CONSUMER_ID = #attributes.consumer_id#)
                </cfif>
				AND PROGRESS_ID IS NULL
				<cfif getContract.contract_type eq 1> AND ACTION_TYPE_ID = 41<cfelse> AND ACTION_TYPE_ID = 42</cfif>
		</cfquery>
		<cfquery name="updProgressInvoice" datasource="#dsn2#">
			UPDATE
				INVOICE
			SET
				PROGRESS_ID = #MAX_ID.IDENTITYCOL# 
			WHERE
				INVOICE_ID > 0
				AND IS_IPTAL = 0 
				AND CONTRACT_ID = #attributes.contract_id#
				AND PROGRESS_ID IS NULL
		</cfquery>
		
		<!--- tevkifat orani var ise dekont kaydediliyor. --->
		<cfif len(attributes.tevkifat_amount_value) and attributes.tevkifat_amount_value gt 0 and getContract.contract_type eq 1>
			<cfquery name="GET_PROCESS_CAT_CLAIM_NOTE" datasource="#DSN2#">
				SELECT 
					PROCESS_CAT_ID,
					IS_CARI,
					IS_ACCOUNT,
					PROCESS_CAT,
					PROCESS_TYPE,
					ACTION_FILE_NAME,
					ACTION_FILE_FROM_TEMPLATE 
				FROM 
					#dsn3_alias#.SETUP_PROCESS_CAT 
				WHERE 
					PROCESS_TYPE = 41
			</cfquery>
			<cfif GET_PROCESS_CAT_CLAIM_NOTE.is_account eq 1>
				<cfif len(attributes.company_id)>
					<cfset my_acc_result = get_company_period(attributes.company_id)>
                <cfelseif len(attributes.consumer_id)>
                	<cfset my_acc_result = get_consumer_period(attributes.consumer_id)>
                </cfif>
				<cfif not len(my_acc_result)>
					<script type="text/javascript">
						alert("Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş");
						history.back();	
					</script>
					<cfabort>
				</cfif>
			</cfif>
			<cfquery name="get_money_bskt" datasource="#DSN2#">
				SELECT 
					MONEY AS MONEY_TYPE,
					RATE1,
					RATE2,
					0 AS IS_SELECTED 
				FROM 
					#dsn_alias#.SETUP_MONEY 
				WHERE 
					COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#"> AND 
					PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> AND 
					MONEY_STATUS = 1 
				ORDER BY 
					MONEY_ID
			</cfquery>
			<cfquery name="get_system_money" dbtype="query">
				SELECT RATE2/RATE1 AS RATE FROM get_money_bskt WHERE MONEY_TYPE = '#attributes.action_currency_id#'
			</cfquery>
			
			<cfoutput query="get_money_bskt">
				<cfset "attributes.hidden_rd_money_#currentrow#" = get_money_bskt.money_type>
				<cfset "attributes.txt_rate1_#currentrow#" = filterNum(get_money_bskt.rate1)>
				<cfset "attributes.txt_rate2_#currentrow#" = filterNum(TLFormat(get_money_bskt.rate2,session.ep.our_company_info.rate_round_num))>
			</cfoutput>
			
			<cfscript>
				attributes.kur_say = get_money_bskt.recordcount;
				process_type = GET_PROCESS_CAT_CLAIM_NOTE.PROCESS_TYPE;
				form.process_cat = GET_PROCESS_CAT_CLAIM_NOTE.PROCESS_CAT_ID;
				is_cari = GET_PROCESS_CAT_CLAIM_NOTE.is_cari;
				is_account = GET_PROCESS_CAT_CLAIM_NOTE.is_account;
				get_process_type.action_file_name = GET_PROCESS_CAT_CLAIM_NOTE.ACTION_FILE_NAME;
				get_process_type.action_file_from_template = GET_PROCESS_CAT_CLAIM_NOTE.ACTION_FILE_FROM_TEMPLATE;
				ACTION_CURRENCY_ID = attributes.action_currency_id;
				attributes.action_value = attributes.tevkifat_amount_value;
				attributes.money_type = attributes.action_currency_id;
				form.money_type = attributes.action_currency_id;
				if (len(getContract.project_id))
					{
					attributes.project_id = getContract.project_id;
					attributes.project_name = getContract.project_id;
					}
				else
					{
					attributes.project_id = '';
					attributes.project_name = '';
					}
				attributes.other_cash_act_value = attributes.tevkifat_amount_value;
				if (len(attributes.company_id))
					attributes.company_id = attributes.company_id;
				else if(len(attributes.consumer_id))
					attributes.consumer_id = attributes.consumer_id;
					
				attributes.employee_id = '';
				if(len(get_par_info_))
					attributes.action_detail = 'Hakediş Belgesinden Gelen Dekont. #get_par_info_#';
				else if(len(get_cons_info_))
					attributes.action_detail = 'Hakediş Belgesinden Gelen Dekont. #get_cons_info_#';
					
				attributes.action_account_code = '';
				attributes.action_date = now();
				attributes.paper_number = '#paper_code & '-' & paper_number#';
				attributes.system_amount = attributes.tevkifat_amount_value*get_system_money.RATE;
				
				attributes.expense_center_1 = attributes.expense_center_id;
				attributes.EXPENSE_CENTER_ID_1 = attributes.expense_center_id;
				
				attributes.EXPENSE_ITEM_ID_1 = attributes.expense_item_id;
				attributes.expense_item_name_1 = attributes.expense_item_id;
				
				atttributes.progress_id = MAX_ID.IDENTITYCOL;
				attributes.form_progress = 1;
				attributes.contract_id = attributes.contract_id;
				attributes.contract_no = attributes.contract_id;
			</cfscript>
			<cfinclude template="../../ch/query/add_debit_claim_note_ic.cfm">
		</cfif>
	</cftransaction>
</cflock>
<script language="javascript">
	<cfoutput>
		window.open('#request.self#?fuseaction=contract.list_progress&event=det&id=#MAX_ID.IDENTITYCOL#','list');
		window.location.href = "#request.self#?fuseaction=contract.add_progress_payment";
	</cfoutput>
</script>
<!--- <cflocation url="#request.self#?fuseaction=contract.add_progress_payment&id=#get_max_progress.max_id#" addtoken="no"> --->
