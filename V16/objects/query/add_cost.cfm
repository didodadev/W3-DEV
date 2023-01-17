<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="get_process_type" datasource="#dsn2#">
				SELECT 
					PROCESS_TYPE,
					IS_CARI,
					IS_ACCOUNT,
					ACTION_FILE_NAME,
					ACTION_FILE_FROM_TEMPLATE,
					IS_PROJECT_BASED_ACC,
					IS_ACCOUNT_GROUP
				FROM 
					#dsn3#.SETUP_PROCESS_CAT 
				WHERE 
					PROCESS_CAT_ID = #form.process_cat#
			</cfquery>
		 <cfif attributes.page_type eq 4>
            <cfquery name="get_max_id" datasource="#dsn2#">
				SELECT MAX(INVOICE_COST_ID) MAX_ID FROM INVOICE_COST WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cost_page_id#">
			</cfquery>
			<cfif len(get_max_id.max_id)>
				<cfscript>
					muhasebe_sil(action_id:get_max_id.max_id, process_type:get_process_type.process_type,action_table:'INVOICE_COST');
				</cfscript>
			</cfif>
		 <cfelseif attributes.page_type eq 1>
			<cfquery name="get_max_id" datasource="#dsn2#">
				SELECT MAX(INVOICE_COST_ID) MAX_ID FROM INVOICE_COST WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cost_page_id#">
			</cfquery>
			<cfif len(get_max_id.max_id)>
				<cfscript>
					muhasebe_sil(action_id:get_max_id.max_id, process_type:get_process_type.process_type,action_table:'INVOICE_COST');
				</cfscript>
			</cfif>
		 </cfif>
		 <cfif isdefined("attributes.page_type") and listfind('1,4,5',attributes.page_type,',')>
			<cfquery name="DEL_INVOICE_COST" datasource="#dsn2#">
				DELETE FROM
					INVOICE_COST
				WHERE
					<cfif attributes.page_type eq 1>
					INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cost_page_id#">
					<cfelse>
					SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cost_page_id#">
					</cfif>
			</cfquery>
			<cfquery name="DEL_INVOICE_COST" datasource="#dsn2#">
				DELETE FROM
					INVOICE_COST_MONEY
				WHERE
					<cfif attributes.page_type eq 1>
					INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cost_page_id#">
					<cfelse>
					SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cost_page_id#">
					</cfif>
			</cfquery>
		 <cfelseif isdefined("attributes.page_type") and listfind('2,3',attributes.page_type,',')>
			<cfquery name="DEL_ORDER_OFFER_COST" datasource="#dsn2#">
				DELETE FROM
					#dsn3_alias#.ORDER_OFFER_COST
				WHERE
					ORDER_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cost_page_id#"> AND
					IS_ORDER = <cfif attributes.page_type eq 2>1<cfelse>0</cfif>
			</cfquery>
			<cfquery name="DEL_INVOICE_COST" datasource="#dsn2#">
				DELETE FROM
					#dsn3_alias#.ORDER_OFFER_COST_MONEY
				WHERE
					<cfif attributes.page_type eq 2>
					ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cost_page_id#">
					<cfelse>
					OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cost_page_id#">
					</cfif>
			</cfquery>
		 </cfif>
		 <!--- Fatih tarafından değerlendirilecek --->
		 <cfset deletedRowCount = 0>
		 <cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#") eq 0>
				<cfset deletedRowCount = deletedRowCount + 1>
			</cfif>
		</cfloop>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#") neq 0>
				<cfset is_inv_cost_row=1> <!---  gecici olarak set edildi, gecerli satır varsa invoice_cost_money tablosuna kayıt atar. --->
				<cfset form_money_type = evaluate("attributes.money_type#i#")>
				<!--- <cfset form_other_money_cost = evaluate("attributes.amount#i#")*listgetat(form_money_type,3,";")/listgetat(form_money_type,2,";")> --->
				<cfset form_other_money_cost =filternum(evaluate("attributes.amount#i#"))*filternum(evaluate("attributes.txt_rate2_#listfirst(form_money_type,';')#"))>
				<cfif isdefined("attributes.page_type") and listfind('1,4,5',attributes.page_type,',')>
					<cfquery name="ADD_INVOICE_COST" datasource="#DSN2#">
						INSERT INTO
							INVOICE_COST
						(
						<cfif attributes.page_type eq 1>
							INVOICE_ID,	INVOICE_NUMBER,
						<cfelse> <!--- ithal mal girisi ise --->
							SHIP_ID,SHIP_NUMBER,
						</cfif>
							PROCESS_CAT,
							PROCESS_TYPE,
							TAX_TYPE,
							COMPANY_ID,
							EMPLOYEE_ID,
							CONSUMER_ID,
							PURCHASE_SALES,
							ROW_PAPER_NO,
							DOCUMENT_TYPE_ID,
							EXPENSE_ITEM_ID,
							DETAIL,
							INVOICE_COST,
							INVOICE_COST_MONEY,
							INVOICE_OTHER_COST,
							OTHER_MONEY,
							FOREIGN_MONEY,
							FOREIGN_MONEY_COST,
							QUANTITY,
							DISTRIBUTE_TYPE,
							ACCOUNT_CODE,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP,
							UPDATE_DATE,
							UPDATE_EMP,
							UPDATE_IP
						)
						VALUES
						(
							#attributes.cost_page_id#,
							'#attributes.cost_page_number#',
							<cfif isDefined("form.process_cat") and len(form.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#"><cfelse>NULL</cfif>,
							<cfif isDefined("get_process_type.process_type") and len(get_process_type.process_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_type.process_type#"><cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.tax_type_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.tax_type_id#i#")#"><cfelse>NULL</cfif>,
							<cfif len(evaluate("ch_member_type#i#")) and evaluate("ch_member_type#i#") eq "partner"><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("ch_member_id#i#")#"><cfelse>NULL</cfif>,
							<cfif len(evaluate("ch_member_type#i#")) and evaluate("ch_member_type#i#") eq "employee"><cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(evaluate("ch_member_id#i#"),'_')#"><cfelse>NULL</cfif>,
							<cfif len(evaluate("ch_member_type#i#")) and evaluate("ch_member_type#i#") eq "consumer"><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("ch_member_id#i#")#"><cfelse>NULL</cfif>,
							#attributes.purchase_sales#,
							'#wrk_eval("attributes.row_paper_no#i#")#',
							<cfif len(evaluate("attributes.document_type_id#i#"))>#evaluate("attributes.document_type_id#i#")#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.expense_item_id#i#")) and len(evaluate("attributes.expense_item#i#"))>#evaluate("attributes.expense_item_id#i#")#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.detail#i#"))>'#wrk_eval("attributes.detail#i#")#',<cfelse>NULL,</cfif>
							#trim(form_other_money_cost)#,
							'#session.ep.money#',
							<cfif len(evaluate("attributes.amount#i#"))>#filternum(evaluate("attributes.amount#i#"))#,<cfelse>NULL,</cfif>
							'#listfirst(form_money_type,";")#',
							<cfif isdefined("attributes.rd_money") and len(listfirst(attributes.rd_money,";"))>'#listfirst(attributes.rd_money,";")#',<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.other_toplam") and len(attributes.other_toplam)>#attributes.other_toplam#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.quantity#i#"))>#filternum(evaluate("attributes.quantity#i#"))#,<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.dis_type#i#") and len(evaluate("attributes.dis_type#i#"))>#evaluate("attributes.dis_type#i#")#,<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.account_id#i#") and len(evaluate("attributes.account_code#i#"))>'#evaluate("attributes.account_id#i#")#',<cfelse>NULL,</cfif>
							#NOW()#,
							#SESSION.EP.USERID#,
							'#CGI.REMOTE_ADDR#',
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
						)
					</cfquery>
				<cfelseif isdefined("attributes.page_type") and listfind('2,3',attributes.page_type,',')>
					<cfset attributes.detail= URLEncodedFormat(evaluate("attributes.detail#i#"))>
					<cfquery name="ADD_ORDER_OFFER_COST" datasource="#dsn2#">
						INSERT INTO
							#dsn3_alias#.ORDER_OFFER_COST
						(
							ORDER_OFFER_ID,
							ORDER_OFFER_NUMBER,
							PROCESS_CAT,
							PROCESS_TYPE,
							TAX_TYPE,
							COMPANY_ID,
							EMPLOYEE_ID,
							CONSUMER_ID,
							PURCHASE_SALES,
							ROW_PAPER_NO,
							DOCUMENT_TYPE_ID,
							EXPENSE_ITEM_ID,
							DETAIL,
							COST,
							COST_MONEY,
							OTHER_COST,
							OTHER_MONEY,
							FOREIGN_MONEY, 
							FOREIGN_MONEY_COST,
							QUANTITY,
							IS_ORDER,
							DISTRIBUTE_TYPE,
							ACCOUNT_CODE,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP,
							UPDATE_DATE,
							UPDATE_EMP,
							UPDATE_IP
						)
						VALUES
						(
							#attributes.cost_page_id#,
							'#attributes.cost_page_number#',
							<cfif isDefined("form.process_cat") and len(form.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#form.process_cat#"><cfelse>NULL</cfif>,
							<cfif isDefined("get_process_type.process_type") and len(get_process_type.process_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_type.process_type#"><cfelse>NULL</cfif>,
							<cfif len(evaluate("attributes.tax_type_id#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.tax_type_id#i#")#"><cfelse>NULL</cfif>,
							<cfif len(evaluate("ch_member_type#i#")) and evaluate("ch_member_type#i#") eq "partner"><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("ch_member_id#i#")#"><cfelse>NULL</cfif>,
							<cfif len(evaluate("ch_member_type#i#")) and evaluate("ch_member_type#i#") eq "employee"><cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(evaluate("ch_member_id#i#"),'_')#"><cfelse>NULL</cfif>,
							<cfif len(evaluate("ch_member_type#i#")) and evaluate("ch_member_type#i#") eq "consumer"><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("ch_member_id#i#")#"><cfelse>NULL</cfif>,
							#attributes.purchase_sales#,
							'#wrk_eval("attributes.row_paper_no#i#")#',
							<cfif len(evaluate("attributes.document_type_id#i#"))>#evaluate("attributes.document_type_id#i#")#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.expense_item_id#i#")) and len(evaluate("attributes.expense_item#i#"))>#evaluate("attributes.expense_item_id#i#")#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.detail#i#"))>'#attributes.detail#',<cfelse>NULL,</cfif>
							#trim(form_other_money_cost)#,
							'#session.ep.money#',
							<cfif len(evaluate("attributes.amount#i#"))>#filternum(evaluate("attributes.amount#i#"))#,<cfelse>NULL,</cfif>
							'#listfirst(form_money_type,";")#',
							<cfif isdefined("attributes.rd_money") and len(listfirst(attributes.rd_money,";"))>'#listfirst(attributes.rd_money,";")#',<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.other_toplam") and len(attributes.other_toplam)>#attributes.other_toplam#,<cfelse>NULL,</cfif>
							<cfif len(evaluate("attributes.quantity#i#"))>#filternum(evaluate("attributes.quantity#i#"))#,<cfelse>NULL,</cfif>
							<cfif attributes.page_type eq 2>1,<cfelse>0,</cfif>
							<cfif isdefined("attributes.dis_type#i#") and len(evaluate("attributes.dis_type#i#"))>#evaluate("attributes.dis_type#i#")#,<cfelse>NULL,</cfif>
							<cfif isdefined("attributes.account_id#i#") and len(evaluate("attributes.account_code#i#"))>'#evaluate("attributes.account_id#i#")#',<cfelse>NULL,</cfif>
							#NOW()#,
							#SESSION.EP.USERID#,
							'#CGI.REMOTE_ADDR#',
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
						)
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
		<cfif isdefined('is_inv_cost_row') and len(is_inv_cost_row)>
			<cfloop from="1" to="#attributes.deger_get_money#" index="fnc_i">
				<cfset temp_cost_money = evaluate("attributes.hidden_rd_money_#fnc_i#")>
				<cfquery name="ADD_INV_COST_MONEY" datasource="#dsn2#">
					INSERT INTO
						<cfif listfind('1,4,5',attributes.page_type)>
						INVOICE_COST_MONEY
						<cfelse>
						#dsn3_alias#.ORDER_OFFER_COST_MONEY
						</cfif>
						(
							MONEY_TYPE,
						<cfif attributes.page_type eq 1>
							INVOICE_ID,
						<cfelseif attributes.page_type eq 2> <!--- siparis --->
							ORDER_ID,
						<cfelseif attributes.page_type eq 3> <!--- teklif --->
							OFFER_ID,
						<cfelseif attributes.page_type eq 4 or attributes.page_type eq 5> <!--- ithal mal veya sevk irsaliyesi ise --->
							SHIP_ID,
						</cfif>
							RATE2,
							RATE1,
							IS_SELECTED
						)
						VALUES
						(
							'#temp_cost_money#',
							'#attributes.cost_page_id#',
							#filternum(evaluate("attributes.txt_rate2_#temp_cost_money#"))#,
							#filternum(evaluate("attributes.txt_rate1_#fnc_i#"))#,
							<cfif isdefined('attributes.rd_money') and (listfirst(attributes.rd_money,';') is temp_cost_money)>
							1
							<cfelse>
							0
							</cfif>
						)
				</cfquery>
			</cfloop>
		</cfif>
		<cfif isdefined("attributes.masraf_dagit") and (attributes.masraf_dagit eq 1 or attributes.masraf_dagit eq 2)>
            <cfinclude template="distribute_cost.cfm">
		</cfif>
		<cfif attributes.page_type eq 4 and isdefined("get_process_type") and get_process_type.is_project_based_acc eq 1 and not (isdefined("attributes.project_id") and len(attributes.project_id))>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='60090.Proje Bazında Muhasebeleştirme Yapabilmek İçin İthal Mal Girişi Detayında Proje Seçmelisiniz'> !");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
				//history.back();
			</script>
			<cfabort>
		</cfif>
		<cfif attributes.page_type eq 1 and isdefined("get_process_type") and get_process_type.is_project_based_acc eq 1 and not (isdefined("attributes.project_id") and len(attributes.project_id))>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='60091.Proje Bazında Muhasebeleştirme Yapabilmek İçin Fatura Detayında Proje Seçmelisiniz'> !");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
				//history.back();
			</script>
			<cfabort>
		</cfif>
		<cfif isdefined("get_process_type.is_account") and get_process_type.is_account eq 1 and (attributes.page_type eq 4 or attributes.page_type eq 1)>
			<!--- ithal mal girişi veya farura ise ve işlem kategorisinde muhasebeleştir seçilmişse muhasebe işlemini yapacak --->		
			<cfinclude template="add_cost_acc_action.cfm">
		</cfif>
	  </cftransaction>
	</cflock>
	<cfif session.ep.our_company_info.is_cost eq 1 and isdefined("attributes.masraf_dagit") and (attributes.masraf_dagit eq 1 or attributes.masraf_dagit eq 2) and listfind('1,4,5',attributes.page_type,',')><!--- ithal mal girişi,sevk irsaliyesi ve faturalarda ise --->
		<cfif attributes.page_type eq 4 or attributes.page_type eq 5>
			<cfif isdefined('GET_SHIP_DETAIL') and GET_SHIP_DETAIL.IS_DELIVERED eq 1><!--- teslim alindi ise --->
				<cfscript>cost_action(action_type:2,action_id:attributes.cost_page_id,query_type:2);</cfscript>
			</cfif>
		<cfelse><!--- fatura ise action_type 1 gidecek--->
			<cfscript>cost_action(action_type:1,action_id:attributes.cost_page_id,query_type:2);</cfscript>
		</cfif>
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("Masraf Satırı Yok!");
		history.back();
	</script>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.masraf_dagit") and (attributes.masraf_dagit eq 1 or attributes.masraf_dagit eq 2)>
		window.opener.parent.location.reload();
	</cfif>
	window.close();
</script> 
