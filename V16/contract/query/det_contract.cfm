<cfset contract_cmp = createObject("component","V16.contract.cfc.contract")>
<cf_xml_page_edit fuseact ="sales.popup_subscription_payment_plan">
<cf_date tarih='attributes.start_date'>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
	<cfif isdefined('attributes.record_num_')>
		<cfif isDefined("attributes.form_upd_")>
			<cfquery name="DEL_PRICE_CAT_EXCEPTIONS" datasource="#DSN3#">
				DELETE FROM
					PRICE_CAT_EXCEPTIONS
				WHERE
					ISNULL(ACT_TYPE,1) IN(1,3) AND	
					CONTRACT_ID = #attributes.contract_id#
			</cfquery>
		</cfif>
		<cfloop from="1" to="#attributes.record_num_#" index="i">
			  <cfif evaluate("attributes.row_kontrol_2#i#") neq 0>
				<cfquery name="add_price_list_for_company" datasource="#DSN3#">
					INSERT INTO
						PRICE_CAT_EXCEPTIONS
					(
						COMPANY_ID,
						PRODUCT_CATID, 
						BRAND_ID, 
						PRODUCT_ID,
						PRICE_CATID,
						PRICE,
						PRICE_MONEY,
						DISCOUNT_RATE,
						DISCOUNT_RATE_2,
						DISCOUNT_RATE_3,
						DISCOUNT_RATE_4,
						DISCOUNT_RATE_5,
						SHORT_CODE_ID,
						CONTRACT_ID,
						PAYMENT_TYPE_ID,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
					VALUES
					(
						<cfif len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.PRODUCT_CAT_ID#i#")) and len(evaluate("attributes.product_cat_name#i#"))>#evaluate("attributes.PRODUCT_CAT_ID#i#")#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.brand_id#i#")) and len(evaluate("attributes.brand_name#i#"))>#evaluate("attributes.brand_id#i#")#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.PRODUCT_ID#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.PRODUCT_ID#i#")#<cfelse>NULL</cfif>,
						#evaluate("attributes.price_cat#i#")#,
						<cfif len(evaluate("attributes.price#i#"))>#filternum(evaluate("attributes.price#i#"))#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.price_money#i#"))>'#evaluate("attributes.price_money#i#")#'<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.discount_info_#i#"))>#filternum(evaluate("attributes.discount_info_#i#"))#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.discount_info2_#i#"))>#filternum(evaluate("attributes.discount_info2_#i#"))#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.discount_info3_#i#"))>#filternum(evaluate("attributes.discount_info3_#i#"))#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.discount_info4_#i#"))>#filternum(evaluate("attributes.discount_info4_#i#"))#<cfelse>NULL</cfif>,
						<cfif len(evaluate("attributes.discount_info5_#i#"))>#filternum(evaluate("attributes.discount_info5_#i#"))#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.short_code_id#i#") and len(evaluate("attributes.short_code_id#i#")) and isdefined("attributes.short_code#i#") and len(evaluate("attributes.short_code#i#"))>#evaluate("attributes.short_code_id#i#")#<cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contract_id#">,
						<cfif isdefined("attributes.payment_type_id#i#") and len(evaluate("attributes.payment_type_id#i#")) and isdefined("attributes.payment_type#i#")>#evaluate("attributes.payment_type_id#i#")#<cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
               
					)
				</cfquery>
		  </cfif>
		</cfloop>
	<cfelse>
		<cfset attributes.amount=filterNum(attributes.amount,#session.ep.our_company_info.rate_round_num#)>
	
		<!--- //ödeme planı history kayıtları --->
		<cfset get_subscription_payment_plan = contract_cmp.GET_PAYMENT(contract_id : attributes.contract_id)> 
		
		<cfif get_subscription_payment_plan.recordcount gt 0>
			<cfset UPD_PAYMENT_PLAN = contract_cmp.UPD_PAYMENT_PLAN(
									product_id : attributes.product_id,
									stock_id : attributes.stock_id,
									unit : attributes.unit,
									unit_id : attributes.unit_id,
									quantity : attributes.quantity,
									amount : attributes.amount,
									money_type : attributes.money_type,
									period : attributes.period,
									start_date : attributes.start_date,
									process_stage : attributes.process_stage,
									paymethod_id : attributes.paymethod_id,
									card_paymethod_id : attributes.card_paymethod_id,
									contract_id : attributes.contract_id)> 
			
		<cfelse>
	 	 	<cfset ADD_PAYMENT_PLAN = contract_cmp.ADD_PAYMENT_PLAN(
									contract_id : attributes.contract_id,
									product_id : attributes.product_id,
									stock_id : attributes.stock_id,
									unit : attributes.unit,
									unit_id : attributes.unit_id,
									quantity : attributes.quantity,
									amount : attributes.amount,
									money_type : attributes.money_type,
									period : attributes.period,
									start_date : attributes.start_date,
									paymethod_id : attributes.paymethod_id,
									card_paymethod_id : attributes.card_paymethod_id,
									process_stage : attributes.process_stage)>  
            </cfif>
		<cfif attributes.record_num gt 0>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cf_date tarih='attributes.payment_date#i#'>
				<cfif isdefined("attributes.payment_finish_date#i#")>
					<cf_date tarih='attributes.payment_finish_date#i#'>
				</cfif>
				<cfif (evaluate("attributes.is_disabled_#i#") eq 0 or session.ep.admin eq 1) and ((attributes.xml_change_row eq 1 and isdefined("attributes.is_change#i#")) or attributes.xml_change_row eq 0)><!--- faturalanmışsa o satırlar disable ediliyor --->
					<cfset "attributes.amount#i#" = filterNum(evaluate("attributes.amount#i#"),#session.ep.our_company_info.rate_round_num#)>
					<cfset "attributes.quantity#i#" = evaluate("attributes.quantity#i#")>
					<cfset "attributes.row_total#i#" = filterNum(evaluate("attributes.row_total#i#"),#session.ep.our_company_info.rate_round_num#)>
					<cfset "attributes.discount#i#" = filterNum(evaluate("attributes.discount#i#"))>
					<cfset "attributes.row_bsmv_amount#i#" = filterNum(evaluate("attributes.row_bsmv_amount#i#"),#session.ep.our_company_info.rate_round_num#)>
					<cfset "attributes.row_bsmv_rate#i#" = filterNum(evaluate("attributes.row_bsmv_rate#i#"),#session.ep.our_company_info.rate_round_num#)>
					<cfset "attributes.row_oiv_amount#i#" = filterNum(evaluate("attributes.row_oiv_amount#i#"),#session.ep.our_company_info.rate_round_num#)>
					<cfset "attributes.row_oiv_rate#i#" = filterNum(evaluate("attributes.row_oiv_rate#i#"),#session.ep.our_company_info.rate_round_num#)>
					<cfif isdefined("attributes.row_tevkifat_rate#i#")>
						<cfset "attributes.row_tevkifat_rate#i#" = filterNum(evaluate("attributes.row_tevkifat_rate#i#"),#session.ep.our_company_info.rate_round_num#)>
					<cfelse>
						<cfset "attributes.row_tevkifat_rate#i#" = 0>
					</cfif>
					<cfif isdefined("attributes.row_tevkifat_amount#i#")>
						<cfset "attributes.row_tevkifat_amount#i#" = filterNum(evaluate("attributes.row_tevkifat_amount#i#"),#session.ep.our_company_info.rate_round_num#)>
					<cfelse>
						<cfset "attributes.row_tevkifat_amount#i#" = 0>
					</cfif>
					<cfif isdefined("attributes.discount_amount#i#")>
						<cfset "attributes.discount_amount#i#" = filterNum(evaluate("attributes.discount_amount#i#"))>
					<cfelse>
						<cfset "attributes.discount_amount#i#" = 0>
					</cfif>
					<cfif isdefined("attributes.row_net_total#i#")>
						<cfset "attributes.row_net_total#i#" = filterNum(evaluate("attributes.row_net_total#i#"),#session.ep.our_company_info.rate_round_num#)>
					<cfelse>
						<cfset "attributes.row_net_total#i#" = 0>
					</cfif>
					<cfif isdefined("attributes.row_rate#i#")>
						<cfset "attributes.row_rate#i#" = filterNum(evaluate("attributes.row_rate#i#"))>
					</cfif>           
					<cfset UPD_PAYMENT_PLAN_ROW= contract_cmp.UPD_PAYMENT_PLAN_ROW(
												product_id = evaluate("attributes.product_id#i#"),
												stock_id = evaluate("attributes.stock_id#i#"),
												payment_date = evaluate("attributes.payment_date#i#"),
												payment_finish_date = "#isdefined("attributes.payment_finish_date#i#") ? "#evaluate("attributes.payment_finish_date#i#")#" : "" #",
												detail = left(wrk_eval("attributes.detail#i#"),50),
												unit = "#wrk_eval("attributes.unit#i#")#",
												unit_id = "#evaluate("attributes.unit_id#i#")#",
												contract_id = attributes.contract_id,
												xml_payment_finish_date = xml_payment_finish_date,
												quantity = "#evaluate("attributes.quantity#i#")#",
												amount = "#len(evaluate("attributes.amount#i#")) ? "#evaluate("attributes.amount#i#")#" : 0 #",
												money_type_row =  "#wrk_eval("attributes.money_type_row#i#")#",
												row_total = "#len(evaluate("attributes.row_total#i#")) ? "#evaluate("attributes.row_total#i#")#" : 0 #",
												discount = "#len(evaluate("attributes.discount#i#")) ? "#evaluate("attributes.discount#i#")#" : 0 #",
												discount_amount = "#len(evaluate("attributes.discount_amount#i#")) ? "#evaluate("attributes.discount_amount#i#")#" : 0 #",
												row_net_total = "#len(evaluate("attributes.row_net_total#i#")) ? "#evaluate("attributes.row_net_total#i#")#" : 0 #",
												is_collected_inv =  "#isDefined("attributes.is_collected_inv#i#") ?  1 : 0 #",
												is_group_inv =  "#isDefined("attributes.is_group_inv#i#") ? 1 : 0 #",
												is_billed = "#isDefined("attributes.is_billed#i#") ? 1 : 0 #" ,
												is_collected_prov = "#isDefined("attributes.is_collected_prov#i#") ? 1 : 0 #",
												is_paid = "#isDefined("attributes.is_paid#i#") ? 1 : 0 #",
												invoice_id = "#isdefined("attributes.invoice_id#i#") and len(evaluate("attributes.invoice_id#i#")) ? "#evaluate("attributes.invoice_id#i#")#" : "" #",
												bill_info =  len(evaluate("attributes.bill_info#i#")),
												period_id = "#isdefined("attributes.period_id#i#") and len(evaluate("attributes.period_id#i#")) ? "#evaluate("attributes.period_id#i#")#" : "" #",
												paymethod_id = "#isDefined("attributes.paymethod_id#i#") and len(evaluate("attributes.paymethod_id#i#")) ? "#evaluate("attributes.paymethod_id#i#")#" : "" #",
												card_paymethod_id = evaluate("attributes.card_paymethod_id#i#"),
												subs_ref_id = "#isdefined('attributes.subs_ref_id#i#') and len(evaluate("attributes.subs_ref_id#i#")) ? "#evaluate("attributes.subs_ref_id#i#")#" : "" #",
												service_id = "#isdefined('attributes.service_id#i#') and len(evaluate("attributes.service_id#i#")) ? "#evaluate("attributes.service_id#i#")#" : "" #",
												call_id ="#isdefined("attributes.call_id#i#") and len(evaluate("attributes.call_id#i#")) and isdefined("attributes.call_no#i#") and len(evaluate("attributes.call_no#i#")) ? "#evaluate("attributes.call_id#i#")#" : ""#",
												camp_id = "#isdefined('attributes.camp_id#i#') and len(evaluate("attributes.camp_id#i#")) and isdefined('attributes.camp_name#i#') and len(evaluate("attributes.camp_name#i#")) ? "#evaluate("attributes.camp_id#i#")#" : ""#",
												cari_action_id = "#isDefined("attributes.is_paid#i#") and isdefined('attributes.cari_action_id#i#') and len(evaluate("attributes.cari_action_id#i#")) ? "#evaluate("attributes.cari_action_id#i#")#" : ""#",
												cari_period_id = "#isDefined("attributes.is_paid#i#") and isdefined('attributes.cari_period_id#i#') and len(evaluate("attributes.cari_period_id#i#")) ? "#evaluate("attributes.cari_period_id#i#")#" : ""#",
												cari_act_type = "#isDefined("attributes.is_paid#i#") and isdefined('attributes.cari_act_type#i#') and len(evaluate("attributes.cari_act_type#i#")) ? "#evaluate("attributes.cari_act_type#i#")#" : ""#",
												cari_act_id = "#isDefined("attributes.is_paid#i#") and isdefined('attributes.cari_act_id#i#') and len(evaluate("attributes.cari_act_id#i#")) ? "#evaluate("attributes.cari_act_id#i#")#" : ""#",
												cari_act_table = "#isDefined("attributes.is_paid#i#") and isdefined('attributes.cari_act_table#i#') and len(evaluate("attributes.cari_act_table#i#")) ? "#evaluate("attributes.cari_act_table#i#")#" : ""#",
												is_active = "#isdefined("attributes.is_active#i#") ? 1 : 0 #",
												row_rate = "#isDefined("attributes.row_rate#i#") and len(evaluate("attributes.row_rate#i#")) ?  "#evaluate("attributes.row_rate#i#")#" : ""#",
												row_reason_code = "#isDefined("attributes.row_reason_code#i#") and len(evaluate("attributes.row_reason_code#i#")) ? "#evaluate("attributes.row_reason_code#i#")#" : "" #",
												row_bsmv_rate = "#evaluate('attributes.row_bsmv_rate#i#')#",
												row_bsmv_amount = "#evaluate('attributes.row_bsmv_amount#i#')#",
												row_oiv_rate = "#evaluate('attributes.row_oiv_rate#i#')#",
												row_oiv_amount = "#evaluate('attributes.row_oiv_amount#i#')#",
												row_tevkifat_rate = "#evaluate('attributes.row_tevkifat_rate#i#')#",
												row_tevkifat_amount = "#evaluate('attributes.row_tevkifat_amount#i#')#",
												payment_row_id = evaluate("attributes.payment_row_id#i#")						
					)> 
					<cfelseif evaluate("attributes.is_disabled_#i#") eq 1>
						<cfset IS_PAID= contract_cmp.IS_PAID( 
										is_collected_prov : "#isDefined("attributes.is_collected_prov#i#") ? 1 : 0 #",
										is_paid : "#isDefined("attributes.is_paid#i#") ? 1 : 0 #",
										payment_row_id : evaluate("attributes.payment_row_id#i#") )>
					</cfif>
			</cfloop>
		</cfif>
	
		<cfloop from="#attributes.record_num+1#" to="#attributes.count_camp + attributes.count + attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_control#i#") and evaluate("attributes.row_control#i#") eq 1>
				<cfset "attributes.amount#i#" = filterNum(evaluate("attributes.amount#i#"),#session.ep.our_company_info.rate_round_num#)>
				<cfset "attributes.row_total#i#" = filterNum(evaluate("attributes.row_total#i#"),#session.ep.our_company_info.rate_round_num#)>
				<cfset "attributes.discount#i#" = filterNum(evaluate("attributes.discount#i#"))>
				<cfset "attributes.row_bsmv_amount#i#" = filterNum(evaluate("attributes.row_bsmv_amount#i#"),#session.ep.our_company_info.rate_round_num#)>
				<cfset "attributes.row_bsmv_rate#i#" = filterNum(evaluate("attributes.row_bsmv_rate#i#"),#session.ep.our_company_info.rate_round_num#)>
				<cfset "attributes.row_oiv_amount#i#" = filterNum(evaluate("attributes.row_oiv_amount#i#"),#session.ep.our_company_info.rate_round_num#)>
				<cfset "attributes.row_oiv_rate#i#" = filterNum(evaluate("attributes.row_oiv_rate#i#"),#session.ep.our_company_info.rate_round_num#)>
				<cfif isdefined("attributes.row_tevkifat_rate#i#")>
					<cfset "attributes.row_tevkifat_rate#i#" = filterNum(evaluate("attributes.row_tevkifat_rate#i#"),#session.ep.our_company_info.rate_round_num#)>
				<cfelse>
					<cfset "attributes.row_tevkifat_rate#i#" = 0>
				</cfif>
				<cfif isdefined("attributes.row_tevkifat_amount#i#")>
					<cfset "attributes.row_tevkifat_amount#i#" = filterNum(evaluate("attributes.row_tevkifat_amount#i#"),#session.ep.our_company_info.rate_round_num#)>
				<cfelse>
					<cfset "attributes.row_tevkifat_amount#i#" = 0>
				</cfif>
				<cfif isdefined("attributes.discount_amount#i#")>
					<cfset "attributes.discount_amount#i#" = filterNum(evaluate("attributes.discount_amount#i#"))>
				<cfelse>
					<cfset "attributes.discount_amount#i#" = 0>
				</cfif>
				<cfif isdefined("attributes.row_net_total#i#")>
					<cfset "attributes.row_net_total#i#" = filterNum(evaluate("attributes.row_net_total#i#"),#session.ep.our_company_info.rate_round_num#)>
				<cfelse>
					<cfset "attributes.row_net_total#i#" = 0>
				</cfif>
				<cfif isdefined("attributes.row_rate#i#")>
					<cfset "attributes.row_rate#i#" = filterNum(evaluate("attributes.row_rate#i#"))>
				</cfif>
				<cf_date tarih='attributes.payment_date#i#'>
				<cfif isdefined("attributes.payment_finish_date#i#")>
					<cf_date tarih='attributes.payment_finish_date#i#'>
				</cfif>
				<cfset  ADD_PAYMENT_PLAN_ROW = contract_cmp.ADD_PAYMENT_PLAN_ROW(
                                            contract_id : attributes.contract_id,
											product_id : "#isdefined("attributes.product_id#i#") and len(evaluate("attributes.product_id#i#")) ? "#evaluate("attributes.product_id#i#")#" : "" #",  
											stock_id : "#isdefined("attributes.stock_id#i#") and len(evaluate("attributes.stock_id#i#")) ? "#evaluate("attributes.stock_id#i#")#" : "" #",
											payment_date : "#isdefined("attributes.payment_date#i#") and len(evaluate("attributes.payment_date#i#")) ? "#evaluate("attributes.payment_date#i#")#" : "" #", 
											payment_finish_date : "#isdefined("attributes.payment_finish_date#i#") and len(evaluate("attributes.payment_finish_date#i#")) ? "#evaluate("attributes.payment_finish_date#i#")#" : "" #",
											detail :"#isdefined("attributes.detail#i#") and len("attributes.detail#i#") ? "#left(wrk_eval("attributes.detail#i#"),50)#" : "" #", 
											unit : "#wrk_eval("attributes.unit#i#")#",  
											unit_id : "#isdefined(evaluate("attributes.unit_id#i#")) and len(evaluate("attributes.unit_id#i#")) ? "#evaluate("attributes.unit_id#i#")#" : 0 #", 
											quantity : "#evaluate("attributes.quantity#i#")#", 
											amount : "#isDefined("attributes.amount#i#") ? "#evaluate("attributes.amount#i#")#" : "" #",
											money_type_row :"#evaluate("attributes.money_type_row#i#")#", 
											row_total : "#len(evaluate("attributes.row_total#i#")) ? "#evaluate("attributes.row_total#i#")#" : 0 #",
											discount : "#len(evaluate("attributes.discount#i#")) ? "#evaluate("attributes.discount#i#")#" : 0 #",
											discount_amount : "#len(evaluate("attributes.discount_amount#i#")) ? "#evaluate("attributes.discount_amount#i#")#" : 0 #",
											row_net_total : "#len(evaluate("attributes.row_net_total#i#")) ? "#evaluate("attributes.row_net_total#i#")#" : 0 #",
											is_collected_inv : "#isDefined("attributes.is_collected_inv#i#") ? 1 : 0 #",
											is_group_inv : "#isDefined("attributes.is_group_inv#i#") ? 1 : 0 #",
											is_billed : "#isDefined("attributes.is_billed#i#")  or isdefined("arguments.invoice_id#i#") ? 1 : 0 #",
											is_collected_prov : "#isDefined("attributes.is_collected_prov#i#") ? 1 : 0 #",
											is_paid : "#isDefined("attributes.is_paid#i#") ? 1 : 0 #",
											invoice_id : "#isdefined("attributes.invoice_id#i#") and len(evaluate("attributes.invoice_id#i#")) ? "#evaluate("attributes.invoice_id#i#")#" : "" #",
											bill_info : "#isdefined("attributes.bill_info#i#") and len(evaluate("attributes.bill_info#i#")) ? "" : "" #",  
											period_id : "#isdefined("attributes.period_id#i#") and len(evaluate("attributes.period_id#i#")) ? "#evaluate("attributes.period_id#i#")#" : "" #",
											paymethod_id :"#isdefined("attributes.paymethod_id#i#") and len(evaluate("attributes.paymethod_id#i#")) ? "#evaluate("attributes.paymethod_id#i#")#" : "" #", 
											card_paymethod_id :"#isdefined("attributes.card_paymethod_id#i#") and len(evaluate("attributes.card_paymethod_id#i#")) ? "#evaluate("attributes.card_paymethod_id#i#")#" : "" #",  
											subs_ref_id : "#isdefined('attributes.subs_ref_id#i#') and len(evaluate("attributes.subs_ref_id#i#")) and isdefined('attributes.subs_ref_name#i#') and len(evaluate("attributes.subs_ref_name#i#")) ? "#evaluate("attributes.subs_ref_id#i#")#" : "" #",
											service_id : "#isdefined('attributes.service_id#i#') and len(evaluate("attributes.service_id#i#")) and isdefined('attributes.service_no#i#') and len(evaluate("attributes.service_no#i#")) ? "#evaluate("attributes.service_id#i#")#" : "" #",
											camp_id : "#isdefined('attributes.camp_id#i#') and len(evaluate("attributes.camp_id#i#")) and isdefined('attributes.camp_name#i#') and len(evaluate("attributes.camp_name#i#")) ? "#evaluate("attributes.camp_id#i#")#" : "" #",
											call_id :  "#isdefined('attributes.call_id#i#') and len(evaluate("attributes.call_id#i#")) and isdefined('attributes.call_no#i#') and len(evaluate("attributes.call_no#i#")) ? "#evaluate("attributes.call_id#i#")#" : "" #",
											cari_action_id : "#isdefined('attributes.cari_action_id#i#') and len(evaluate("attributes.cari_action_id#i#")) ? "#evaluate("attributes.cari_action_id#i#")#" : "" #",
											cari_period_id : "#isdefined('attributes.cari_period_id#i#') and len(evaluate("attributes.cari_period_id#i#")) ? "#evaluate("attributes.cari_period_id#i#")#" : "" #",
											cari_act_type :	"#isdefined('attributes.cari_act_type#i#') and len(evaluate("attributes.cari_act_type#i#")) ? "#evaluate("attributes.cari_act_type#i#")#" : "" #",
											cari_act_id : "#isdefined('attributes.cari_act_id#i#') and len(evaluate("attributes.cari_act_id#i#")) ? "#evaluate("attributes.cari_act_id#i#")#" : "" #",
											cari_act_table : "#isdefined('attributes.cari_act_table#i#') and len(evaluate("attributes.cari_act_table#i#")) ? "#evaluate("attributes.cari_act_table#i#")#" : "" #",
											is_active : "#isDefined("attributes.is_active#i#") ? 1 : 0 #",
											row_rate : "#isDefined("attributes.row_rate#i#") and len(evaluate("attributes.row_rate#i#")) ? "#evaluate("attributes.row_rate#i#")#" : "" #",
											row_reason_code : "#isDefined("attributes.row_reason_code#i#") and len(evaluate("attributes.row_reason_code#i#")) ? "#evaluate("attributes.row_reason_code#i#")#" : "" #",			
											row_bsmv_rate : "#isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#")) ? "#evaluate('attributes.row_bsmv_rate#i#')#" : "" #", 
											row_bsmv_amount : "#isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#")) ? "#evaluate('attributes.row_bsmv_amount#i#')#" : "" #",
											row_oiv_rate : "#isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#")) ? "#evaluate('attributes.row_oiv_rate#i#')#" : "" #",	
											row_oiv_amount : "#isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#")) ? "#evaluate('attributes.row_oiv_amount#i#')#" : "" #",
											row_tevkifat_rate : "#isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#")) ? "#evaluate('attributes.row_tevkifat_rate#i#')#" : "" #",
											row_tevkifat_amount : "#isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#")) ? "#evaluate('attributes.row_tevkifat_amount#i#')#" : "" #" 

									)> 
 		
			</cfif>
		</cfloop>
	</cfif>
	</cftransaction>
</cflock>
<cfif not  isdefined('attributes.record_num_')>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	data_source='#dsn3#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#'
	action_table='SUBSCRIPTION_PAYMENT_PLAN'
	action_column='CONTRACT_ID'
	action_id='#attributes.contract_id#'
	action_page='#request.self#?fuseaction=contract.list_related_contracts&event=det&contract_id=#attributes.contract_id#'
	warning_description = '#getLang("","",32499)# : #attributes.contract_id#'>
</cfif>

	<script type="text/javascript">
        window.location.href="<cfoutput>#request.self#?fuseaction=contract.list_related_contracts&event=det&contract_id=#attributes.contract_id#</cfoutput>";
    </script>
