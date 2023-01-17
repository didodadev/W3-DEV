<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı.\rMuhasebe Döneminizi Kontrol Ediniz!");
		window.opener.location.href='<cfoutput>#request.self#?fuseaction=invoice.list_bill</cfoutput>';
		window.close();
	</script>
	<cfabort>
</cfif>

<cf_date tarih='attributes.invoice_date'>
<cflock name="#CreateUUID()#" timeout="20">
<cftransaction>
	<cfquery name="get_" datasource="#DSN2#">
		SELECT INVOICE_ID FROM INVOICE_CONTROL WHERE INVOICE_ID = #attributes.invoice_id#
	</cfquery>
	<cfif get_.recordcount>
		<script type="text/javascript">
			alert('Bu Faturaya Daha Önce Kontrol Satırı Oluşturulmuş! \n Kayıt İçin Yeniden Kontrol Satırı Yazılmayacak!');
		</script>
	<cfelse>
		<cfquery name="get_invoice" datasource="#DSN2#">
			SELECT INVOICE_ID,CONSUMER_ID,COMPANY_ID,INVOICE_NUMBER,NETTOTAL FROM INVOICE WHERE INVOICE_ID = #attributes.invoice_id#
		</cfquery>
		<cfif get_invoice.recordcount>
			<cfquery name="add_in_con" datasource="#DSN2#">
				INSERT INTO 
					INVOICE_CONTROL
					(
						INVOICE_NUMBER,
						INVOICE_ID,
						COMPANY_ID,
						CONSUMER_ID,
						MONEY,
						RETURN_MONEY_VALUE,				
						IS_CONTROL,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
				VALUES
					(	
						'#get_invoice.INVOICE_NUMBER#',
						#get_invoice.INVOICE_ID#,
						<cfif len(get_invoice.COMPANY_ID)>#get_invoice.COMPANY_ID#,<cfelse>NULL,</cfif>
						<cfif len(get_invoice.CONSUMER_ID)>#get_invoice.CONSUMER_ID#,<cfelse>NULL,</cfif>
						'#session.ep.money#',
						0,
						1,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#',
						#NOW()#
					)
			</cfquery>
		<cfelse>
			<script type="text/javascript">
				alert('İlgili Fatura Kaydı Bulunamadı!');
				window.close();
			</script>
			<cfabort>
		</cfif>
	</cfif>
	<!--- fiyat farkı --->
	<cfloop from="1" to="#attributes.max_kayit#" index="k">
		<cfif isdefined("attributes.chk_diff_#k#")>
			<cfscript>
				fiyat_fark_fordb = 0;
				fiyat_fark_other_fordb = 0;
				if (evaluate("attributes.fiyat_farki_#k#") gt 0)
					fiyat_fark_fordb = evaluate("attributes.fiyat_farki_#k#");
				if (evaluate("attributes.fiyat_farki_other_#k#") gt 0)
					fiyat_fark_other_fordb = evaluate("attributes.fiyat_farki_other_#k#");
			</cfscript>
			<cfif fiyat_fark_fordb gt 0>
				<cfquery name="add_in_com" datasource="#DSN2#">
					INSERT INTO 
						INVOICE_CONTRACT_COMPARISON
					(
						MAIN_INVOICE_ID,
						MAIN_INVOICE_DATE,
						MAIN_INVOICE_NUMBER,
						MAIN_INVOICE_ROW_ID,
						WRK_ROW_RELATION_ID,
						COMPANY_ID,
						CONSUMER_ID,
						MAIN_PRODUCT_ID,
						MAIN_STOCK_ID,
						AMOUNT,
						DIFF_RATE,					
						DIFF_AMOUNT,
						DIFF_AMOUNT_OTHER,
						OTHER_MONEY,
						IS_DIFF_DISCOUNT,
						IS_DIFF_PRICE,
						DIFF_TYPE,
						TAX,
						DEPARTMENT_ID,
						LOCATION_ID,
						INVOICE_TYPE,
						STAGE_ID,
						NOTE,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
					VALUES
					(
						#attributes.invoice_id#,
						#attributes.invoice_date#,
						'#attributes.invoice_number#',
						#evaluate("attributes.invoice_row_id_#k#")#,
						<cfif len(evaluate("attributes.wrk_row_id_#k#"))>'#evaluate("attributes.wrk_row_id_#k#")#',<cfelse>NULL,</cfif>
						<cfif len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
						<cfif len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
						#evaluate("attributes.product_id_#k#")#,
						#evaluate("attributes.stock_id_#k#")#,
						#evaluate("attributes.invoice_row_amount_#k#")#,
						0,
						#fiyat_fark_fordb#,
						#fiyat_fark_other_fordb#,
						<cfif isdefined('attributes.other_money_#k#') and len(evaluate("attributes.other_money_#k#"))>'#wrk_eval("attributes.other_money_#k#")#'<cfelse>'#session.ep.money2#'</cfif>,
						0,
						0,
						#evaluate("attributes.chk_diff_#k#")#,
						#evaluate("attributes.invoice_row_tax_#k#")#,
						#attributes.department_id#,
						#attributes.location_id#,
						<cfif isdefined('attributes.invoice_type_#k#') and evaluate('attributes.invoice_type_#k#') eq 1>1<cfelse>0</cfif>,
						#attributes.process_stage#,
						<cfif len(attributes.customer_note)>'#attributes.customer_note#'<cfelse>NULL</cfif>,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#',
						#NOW()#
					)
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
	<!--- kur farkı --->	
	<cfloop from="1" to="#attributes.max_kayit#" index="k">
		<cfif isdefined("attributes.chk_rate_diff_#k#")>
			<cfscript>
				rate_diff_fordb = 0;
				if (isdefined("attributes.rate_diff_#k#") and evaluate("attributes.rate_diff_#k#") gt 0)
					rate_diff_fordb = evaluate("attributes.rate_diff_#k#");
				if (evaluate("attributes.rate_diff_amount_#k#") gt 0)
					rate_diff_amount_fordb = evaluate("attributes.rate_diff_amount_#k#");
				if (evaluate("attributes.rate_diff_amount_other_#k#") gt 0)
					rate_diff_amount_other_fordb = evaluate("attributes.rate_diff_amount_other_#k#");
				if (len(evaluate("attributes.rate_diff_other_money_#k#")))
					rate_diff_other_money_fordb = evaluate("attributes.rate_diff_other_money_#k#");
				else
					rate_diff_other_money_fordb = session.ep.money2;
			</cfscript>
			<cfif rate_diff_fordb gt 0>
				<cfquery name="add_in_com" datasource="#DSN2#">
					INSERT INTO 
						INVOICE_CONTRACT_COMPARISON
					(
						MAIN_INVOICE_ID,
						MAIN_INVOICE_DATE,
						MAIN_INVOICE_NUMBER,
						MAIN_INVOICE_ROW_ID,
						WRK_ROW_RELATION_ID,
						COMPANY_ID,
						CONSUMER_ID,
						MAIN_PRODUCT_ID,
						MAIN_STOCK_ID,
						AMOUNT,
						DIFF_RATE,						
						DIFF_AMOUNT,
						DIFF_AMOUNT_OTHER,
						OTHER_MONEY,
						IS_DIFF_DISCOUNT,
						IS_DIFF_PRICE,
						DIFF_TYPE,
						TAX,
						DEPARTMENT_ID,
						LOCATION_ID,
						INVOICE_TYPE,
						STAGE_ID,
						NOTE,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
					VALUES
					(
						#attributes.invoice_id#,
						#attributes.invoice_date#,
						'#attributes.invoice_number#',
						#evaluate("attributes.invoice_row_id_#k#")#,
						<cfif len(evaluate("attributes.wrk_row_id_#k#"))>'#evaluate("attributes.wrk_row_id_#k#")#',<cfelse>NULL,</cfif>
						<cfif len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
						<cfif len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
						#evaluate("attributes.product_id_#k#")#,
						#evaluate("attributes.stock_id_#k#")#,
						#evaluate("attributes.invoice_row_amount_#k#")#,
						#rate_diff_fordb#,
						#rate_diff_amount_fordb#,
						#rate_diff_amount_other_fordb#,
						'#rate_diff_other_money_fordb#',
						0,
						0,
						#evaluate("attributes.chk_rate_diff_#k#")#,<!--- 5 --->
						#evaluate("attributes.invoice_row_tax_#k#")#,
						#attributes.department_id#,
						#attributes.location_id#,
						<cfif isdefined('attributes.invoice_type_#k#') and evaluate('attributes.invoice_type_#k#') eq 1>1<cfelse>0</cfif>,
						#attributes.process_stage#,
						<cfif len(attributes.customer_note)>'#attributes.customer_note#'<cfelse>NULL</cfif>,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#',
						#NOW()#
					)
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
	<!--- manuel farkı --->	
	<cfloop from="1" to="#attributes.max_kayit#" index="k">
		<cfif isdefined("attributes.chk_manuel_diff_#k#")>
			<cfscript>
				manuel_diff_fordb = 0;
				manuel_diff_amount_fordb = 0;
				manuel_diff_amount_other_fordb = 0;
				manuel_diff_other_money_fordb = session.ep.money2;
			</cfscript>
			<cfquery name="add_in_com" datasource="#DSN2#">
				INSERT INTO 
					INVOICE_CONTRACT_COMPARISON
				(
					MAIN_INVOICE_ID,
					MAIN_INVOICE_DATE,
					MAIN_INVOICE_NUMBER,
					MAIN_INVOICE_ROW_ID,
					WRK_ROW_RELATION_ID,
					COMPANY_ID,
					CONSUMER_ID,
					MAIN_PRODUCT_ID,
					MAIN_STOCK_ID,
					AMOUNT,
					DIFF_RATE,						
					DIFF_AMOUNT,
					DIFF_AMOUNT_OTHER,
					OTHER_MONEY,
					IS_DIFF_DISCOUNT,
					IS_DIFF_PRICE,
					DIFF_TYPE,
					TAX,
					DEPARTMENT_ID,
					LOCATION_ID,
					INVOICE_TYPE,
					STAGE_ID,
					NOTE,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE
				)
				VALUES
				(
					#attributes.invoice_id#,
					#attributes.invoice_date#,
					'#attributes.invoice_number#',
					#evaluate("attributes.invoice_row_id_#k#")#,
					<cfif len(evaluate("attributes.wrk_row_id_#k#"))>'#evaluate("attributes.wrk_row_id_#k#")#',<cfelse>NULL,</cfif>
					<cfif len(attributes.company_id)>#attributes.company_id#,<cfelse>NULL,</cfif>
					<cfif len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
					#evaluate("attributes.product_id_#k#")#,
					#evaluate("attributes.stock_id_#k#")#,
					#evaluate("attributes.invoice_row_amount_#k#")#,
					#manuel_diff_fordb#,
					#manuel_diff_amount_fordb#,
					#manuel_diff_amount_other_fordb#,
					'#manuel_diff_other_money_fordb#',
					0,
					0,
					#evaluate("attributes.chk_manuel_diff_#k#")#,<!---7 --->
					#evaluate("attributes.invoice_row_tax_#k#")#,
					#attributes.department_id#,
					#attributes.location_id#,
					<cfif isdefined('attributes.invoice_type_#k#') and evaluate('attributes.invoice_type_#k#') eq 1>1<cfelse>0</cfif>,
					#attributes.process_stage#,
					<cfif len(attributes.customer_note)>'#attributes.customer_note#'<cfelse>NULL</cfif>,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#NOW()#
				)
			</cfquery>
		</cfif>
	</cfloop>
</cftransaction>
</cflock>
<cf_workcube_process 
	is_upd='1'
	data_source='#dsn2#'
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#'
	action_table='INVOICE'
	action_column='INVOICE_ID'
	action_id='#attributes.invoice_id#'
	action_page='#request.self#?fuseaction=invoice.form_add_bill_purchase&event=det&iid=#attributes.invoice_id#'
	warning_description = 'Anlaşma-Aksiyon Koşullarına Uygunluk / Fatura No : #attributes.invoice_id#'>

<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.form_add_bill_purchase&event=det&iid=<cfoutput>#attributes.invoice_id#</cfoutput>";
</script>
