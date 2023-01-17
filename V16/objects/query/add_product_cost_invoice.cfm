<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfloop from="1" to="#attributes.record_num#" index="rw_ind">
			<cfif isdefined('attributes.row_kontrol_#rw_ind#') and evaluate('attributes.row_kontrol_#rw_ind#') eq 1>
				<cfset is_cost_work=1>
            	<cf_date tarih = 'attributes.start_date_#rw_ind#'>
				<cfif isdefined('attributes.product_cost_invoice_#rw_ind#') and len(evaluate('attributes.product_cost_invoice_#rw_ind#'))>
					<cfquery name="add_exchange" datasource="#dsn2#">
						UPDATE 
							PRODUCT_COST_INVOICE
						SET
							INVOICE_ID = #attributes.invoice_id#,
							PRODUCT_ID = #evaluate('attributes.product_id_#rw_ind#')#,
                            STOCK_ID = #evaluate('attributes.stock_id_#rw_ind#')#,
							SPECT_MAIN_ID = <cfif len(evaluate('attributes.spect_main_name_#rw_ind#')) and len(evaluate('attributes.spect_main_id_#rw_ind#'))>#evaluate('attributes.spect_main_id_#rw_ind#')#<cfelse>NULL</cfif>,
							COST_DATE = #evaluate('attributes.start_date_#rw_ind#')#,
							COST_TYPE_ID = <cfif len(evaluate('attributes.cost_type_#rw_ind#'))>#evaluate('attributes.cost_type_#rw_ind#')#<cfelse>NULL</cfif>,
							PRICE_PROTECTION_TYPE = #evaluate('attributes.price_protection_type_#rw_ind#')#,
							PRICE_PROTECTION = #evaluate('attributes.price_#rw_ind#')#,
							PRICE_PROTECTION_MONEY = '#wrk_eval('attributes.price_protection_money_#rw_ind#')#',
							AMOUNT = #evaluate('attributes.amount_#rw_ind#')#,
							TOTAL_PRICE_PROTECTION = #evaluate('attributes.row_total_price_#rw_ind#')#,
							UPDATE_EMP = #session.ep.userid#,
							UPDATE_IP = '#CGI.REMOTE_ADDR#',
							UPDATE_DATE = #now()#,
                            DEPARTMENT_ID = <cfif len(evaluate('attributes.department_#rw_ind#'))>#evaluate('attributes.department_#rw_ind#')#<cfelse>NULL</cfif>,
                            AMOUNT_CONSIGMENT = <cfif len(evaluate('attributes.amount_consignment_#rw_ind#'))>#evaluate('attributes.amount_consignment_#rw_ind#')#<cfelse>NULL</cfif>
						WHERE
							PRODUCT_COST_INVOICE_ID = #evaluate('attributes.product_cost_invoice_#rw_ind#')#
					</cfquery>
				<cfelse>
					<cfquery name="add_exchange" datasource="#dsn2#">
						INSERT INTO
							PRODUCT_COST_INVOICE
						(
							INVOICE_ID,
							PRODUCT_ID,
							STOCK_ID,
							SPECT_MAIN_ID,
							COST_DATE,
							COST_TYPE_ID,
							PRICE_PROTECTION_TYPE,
							PRICE_PROTECTION,
							PRICE_PROTECTION_MONEY,
							AMOUNT,
							TOTAL_PRICE_PROTECTION,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
                            DEPARTMENT_ID,
                            AMOUNT_CONSIGMENT
						)
						VALUES
						(
							#attributes.invoice_id#,
							#evaluate('attributes.product_id_#rw_ind#')#,
							#evaluate('attributes.stock_id_#rw_ind#')#,
							<cfif len(evaluate('attributes.spect_main_name_#rw_ind#')) and len(evaluate('attributes.spect_main_id_#rw_ind#'))>#evaluate('attributes.spect_main_id_#rw_ind#')#<cfelse>NULL</cfif>,
							#evaluate('attributes.start_date_#rw_ind#')#,
							<cfif len(evaluate('attributes.cost_type_#rw_ind#'))>#evaluate('attributes.cost_type_#rw_ind#')#<cfelse>NULL</cfif>,
							#evaluate('attributes.price_protection_type_#rw_ind#')#,
							#evaluate('attributes.price_#rw_ind#')#,
							'#wrk_eval('attributes.price_protection_money_#rw_ind#')#',
							#evaluate('attributes.amount_#rw_ind#')#,
							#evaluate('attributes.row_total_price_#rw_ind#')#,
							#session.ep.userid#,
							'#CGI.REMOTE_ADDR#',
							#now()#,
                            <cfif len(evaluate('attributes.department_#rw_ind#'))>#evaluate('attributes.department_#rw_ind#')#<cfelse>NULL</cfif>,
                            <cfif len(evaluate('attributes.amount_consignment_#rw_ind#'))>#evaluate('attributes.amount_consignment_#rw_ind#')#<cfelse>NULL</cfif>
						)
					</cfquery>
				</cfif>
			<cfelse>
				<cfif isdefined('attributes.product_cost_invoice_#rw_ind#') and len(evaluate('attributes.product_cost_invoice_#rw_ind#'))>
					<cfquery name="DEL_PROD_COST" datasource="#DSN2#">
						DELETE FROM PRODUCT_COST_INVOICE WHERE PRODUCT_COST_INVOICE_ID=#evaluate('attributes.product_cost_invoice_#rw_ind#')#
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>

<!--- maliyet --->
<cfif session.ep.our_company_info.is_cost eq 1>
<!--- BU ŞEKİLDE YAPILDI ÇÜNKÜ FATURA KONTROLDEN GELİNCE ZATEN MALİYETİ AŞAĞI YADA YUKARI DOĞRU ETKİLİYOR BİRDE BURDA GİRİLEN ETKİLER İSE SORUN OLUŞABİLİR--->
	<cfquery name="UPD_INVOICE_COMP" datasource="#dsn2#">
		SELECT MAIN_INVOICE_ID FROM INVOICE_CONTRACT_COMPARISON WHERE DIFF_INVOICE_ID = #attributes.invoice_id#
	</cfquery>
	<cfif UPD_INVOICE_COMP.RECORDCOUNT>
		<cflocation url="#request.self#?fuseaction=#fusebox.circuit#.popup_form_add_product_cost_invoice&invoice_id=#attributes.invoice_id#" addtoken="No">
		<cfabort>
	</cfif>
	<!--- KONTROLDE KAYDI YOK İSE MALİYET ÇALIŞTIRACAK --->
	<cfscript>
	if(isdefined('is_cost_work'))
		cost_action(action_type:8,action_id:attributes.invoice_id,query_type:2);
	else
		cost_action(action_type:8,action_id:attributes.invoice_id,query_type:3);
	</cfscript>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.popup_form_add_product_cost_invoice&invoice_id=#attributes.invoice_id#</cfoutput>";
	</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=#fusebox.circuit#.popup_form_add_product_cost_invoice&invoice_id=#attributes.invoice_id#" addtoken="No">
</cfif>
<cfabort>