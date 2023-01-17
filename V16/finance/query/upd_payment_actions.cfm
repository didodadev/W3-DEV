<cf_get_lang_set module_name="finance"><!--- sayfanin en altinda kapanisi var --->
<cf_date tarih='attributes.payment_date'>
<cf_date tarih='attributes.due_date'>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="GET_CLOSED" datasource="#DSN2#">
			SELECT * FROM CARI_CLOSED WHERE CLOSED_ID = #attributes.closed_id#
		</cfquery>
		<cfquery name="ADD_CARI_CLOSED" datasource="#DSN2#">
			UPDATE
				CARI_CLOSED
			SET
				<cfif isdefined("attributes.extra_type_info") and attributes.extra_type_info eq 3>
					IS_ORDER = 1,
					<cfif isDefined("attributes.correspondence_info")><!--- yazışmalardan geliyorsa --->
						P_ORDER_DEBT_AMOUNT_VALUE = 0,
						P_ORDER_CLAIM_AMOUNT_VALUE = #attributes.total_difference_amount#,
						P_ORDER_DIFF_AMOUNT_VALUE = #attributes.total_difference_amount#,
					<cfelse>
						P_ORDER_DEBT_AMOUNT_VALUE = #attributes.total_debt_amount#,
						P_ORDER_CLAIM_AMOUNT_VALUE = #attributes.total_claim_amount#,
						P_ORDER_DIFF_AMOUNT_VALUE = #attributes.total_difference_amount#,
					</cfif>
				<cfelse>
					<cfif isDefined("attributes.correspondence_info")><!--- yazışmalardan geliyorsa --->
						<cfif attributes.act_type eq 1><!--- Kapama İşlemi İse --->
							DEBT_AMOUNT_VALUE = 0,
							CLAIM_AMOUNT_VALUE = #attributes.total_difference_amount#,
							DIFFERENCE_AMOUNT_VALUE = #(attributes.total_difference_amount)#,
						<cfelseif attributes.act_type eq 2><!--- Ödeme talebi İse --->
							PAYMENT_DEBT_AMOUNT_VALUE = 0,
							PAYMENT_CLAIM_AMOUNT_VALUE = #attributes.total_difference_amount#,
							PAYMENT_DIFF_AMOUNT_VALUE = #(attributes.total_difference_amount)#,
						<cfelseif attributes.act_type eq 3><!--- Ödeme emri İse --->
							P_ORDER_DEBT_AMOUNT_VALUE = 0,
							P_ORDER_CLAIM_AMOUNT_VALUE = #attributes.total_difference_amount#,
							P_ORDER_DIFF_AMOUNT_VALUE = #(attributes.total_difference_amount)#,
						</cfif>
					<cfelse>
						<cfif attributes.act_type eq 1><!--- Kapama İşlemi İse --->
							DEBT_AMOUNT_VALUE = #attributes.total_debt_amount#,
							CLAIM_AMOUNT_VALUE = #attributes.total_claim_amount#,
							DIFFERENCE_AMOUNT_VALUE = #attributes.total_difference_amount#,
						<cfelseif attributes.act_type eq 2><!--- Ödeme talebi İse --->
							PAYMENT_DEBT_AMOUNT_VALUE = #attributes.total_debt_amount#,
							PAYMENT_CLAIM_AMOUNT_VALUE = #attributes.total_claim_amount#,
							PAYMENT_DIFF_AMOUNT_VALUE = #attributes.total_difference_amount#,
						<cfelseif attributes.act_type eq 3><!--- Ödeme emri İse --->
							P_ORDER_DEBT_AMOUNT_VALUE = #attributes.total_debt_amount#,
							P_ORDER_CLAIM_AMOUNT_VALUE = #attributes.total_claim_amount#,
							P_ORDER_DIFF_AMOUNT_VALUE = #attributes.total_difference_amount#,
						</cfif>
					</cfif>
					PROCESS_STAGE = #attributes.process_stage#,
					<cfif isDefined("attributes.project_id") and Len(attributes.project_id) and isDefined("attributes.project_head") and Len(attributes.project_head)>
						<!--- Proje varsa degissin, aksi taktirde bosaltilmasin diye NULL atamadik --->
						PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">,
					</cfif>
					ORDER_ID = <cfif isdefined("attributes.order_id") and len(attributes.order_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"><cfelse>NULL</cfif>,
					ACTION_DETAIL = <cfif len(action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(action_detail,500)#"><cfelse>NULL</cfif>,
					ADDITIONAL_DETAIL = <cfif len(additional_subject)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(additional_subject,1000)#"><cfelse>NULL</cfif>,
					PAPER_ACTION_DATE = #attributes.payment_date#,
					PAPER_DUE_DATE = #attributes.due_date#,
					PAYMETHOD_ID = <cfif len(attributes.paymethod_id) and len(attributes.paymethod)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
				</cfif>
				<cfif isDefined("attributes.member_name") and Len(attributes.member_name) and isDefined("attributes.member_id") and Len(attributes.member_id)>
					COMPANY_ID = #attributes.member_id#,
					CONSUMER_ID = NULL,
				<cfelseif isDefined("attributes.member_name") and Len(attributes.member_name) and isDefined("attributes.consumer_id") and Len(attributes.consumer_id)>
					COMPANY_ID = NULL,
					CONSUMER_ID = #attributes.consumer_id#,
				</cfif>
				OTHER_MONEY = <cfif isdefined("attributes.money_type") and len(attributes.money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#">,<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,</cfif>
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				PROCESS_CAT = <cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>#attributes.process_cat#<cfelse>NULL</cfif>,
				CONTRACT_ID = <cfif isdefined("attributes.contract_id") and len(attributes.contract_id)>#attributes.contract_id#<cfelse>NULL</cfif>
			WHERE
				CLOSED_ID = #attributes.closed_id#
		</cfquery>
		<cfloop from="1" to="#attributes.all_records#" index="int_i">
			<cfif isdefined("attributes.is_closed_#int_i#")><!--- bu hareket secilmis --->
				<cfset form_action_id = Evaluate("attributes.action_id_#int_i#")>
				<cfset form_cari_action_id = Evaluate("attributes.cari_action_id_#int_i#")>
				<cfset form_action_type_id = Evaluate("attributes.action_type_id_#int_i#")>
				<cfset form_action_value = filterNum(Evaluate("attributes.action_value_#int_i#"))>
                <cfset closed_row_id = Evaluate("attributes.closed_row_id_#int_i#")>
				<cfset due_date = Evaluate("attributes.due_date_#int_i#")>
				<cf_date tarih = "due_date">
				<cfif not isDefined("attributes.correspondence_info")>
					<cfset form_to_closed_amount = Evaluate("attributes.to_closed_amount_#int_i#")>
					<cfset other_closed_amount = Evaluate("attributes.other_closed_amount_#int_i#")>
					<cfset other_money = Evaluate("attributes.other_money_#int_i#")>
				<cfelse>
					<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
						SELECT RATE2 FROM SETUP_MONEY WHERE MONEY = '#attributes.money_type#'
					</cfquery>
					<cfif attributes.money_type eq session.ep.money>
						<cfset form_to_closed_amount = -1*attributes.total_difference_amount>
						<cfset other_closed_amount = -1*attributes.total_difference_amount>
					<cfelse>
						<cfset other_closed_amount = -1*attributes.total_difference_amount>
						<cfset form_to_closed_amount = wrk_round(-1*attributes.total_difference_amount*GET_MONEY_INFO.RATE2)>
					</cfif>
					<cfset other_money = attributes.money_type>
				</cfif>
                <cfquery name="check_multi_records" datasource="#dsn2#">
                    SELECT
                        ISNULL(CR.ACTION_VALUE,0) - ISNULL(SUM(CCR.CLOSED_AMOUNT),0) REMAINING_AMOUNT,
                        CR.PAPER_NO,
                        ISNULL(CR.FROM_CMP_ID,CR.TO_CMP_ID) CMP_ID,
                        ISNULL(CR.FROM_CONSUMER_ID,CR.TO_CONSUMER_ID) CONS_ID,
                        ISNULL(CR.FROM_EMPLOYEE_ID,CR.TO_EMPLOYEE_ID) EMP_ID
                    FROM
                        CARI_CLOSED_ROW CCR
                            LEFT JOIN CARI_ROWS CR ON CR.CARI_ACTION_ID = CCR.CARI_ACTION_ID
                    WHERE
                        CR.CARI_ACTION_ID = #form_cari_action_id#
                    GROUP BY
                        CR.CARI_ACTION_ID,
                        CR.ACTION_VALUE,
                        CR.PAPER_NO,
                        ISNULL(CR.FROM_CMP_ID,CR.TO_CMP_ID),
                        ISNULL(CR.FROM_CONSUMER_ID,CR.TO_CONSUMER_ID),
                        ISNULL(CR.FROM_EMPLOYEE_ID,CR.TO_EMPLOYEE_ID)
                </cfquery>
                <cfset attributes.employee_id_new = check_multi_records.EMP_ID>
                <cfif check_multi_records.recordcount and check_multi_records.REMAINING_AMOUNT lt other_closed_amount and closed_row_id eq 0>
                	<cfdump var="#check_multi_records#"><cfabort>
                	<script type="text/javascript">
						alert('<cfoutput>#check_multi_records.paper_no# numaralı belgenin fatura kapama tutarı toplam tutarından fazla olmaktadır. Lütfen carinin ilgili belgesinin önceki faturalarını da kontrol ediniz.</cfoutput>');
						window.location = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_payment_actions&event=add&act_type=#attributes.act_type#&member_id=#check_multi_records.cmp_id#&consumer_id=#check_multi_records.cons_id#&employee_id_new=#check_multi_records.emp_id#</cfoutput>";
					</script>
                    <cfabort>
                </cfif>
				<cfif isDefined("attributes.closed_row_id_#int_i#") and len(evaluate("attributes.closed_row_id_#int_i#")) and evaluate("attributes.closed_row_id_#int_i#") neq 0>
					<cfquery name="ADD_CARI_CLOSED_ROW" datasource="#DSN2#">
						UPDATE
							CARI_CLOSED_ROW
						SET
						<cfif isdefined("attributes.extra_type_info") and attributes.extra_type_info eq 3>
							P_ORDER_VALUE = #form_to_closed_amount#,
							OTHER_P_ORDER_VALUE = #other_closed_amount#
						<cfelse>
							CARI_ACTION_ID = #form_cari_action_id#,
							ACTION_ID = #form_action_id#,
							ACTION_TYPE_ID = #form_action_type_id#,
							ACTION_VALUE = #form_action_value#,
							<cfif attributes.act_type eq 1><!--- Kapama İşlemi İse --->
								CLOSED_AMOUNT = #form_to_closed_amount#,
								OTHER_CLOSED_AMOUNT = #other_closed_amount#,
							<cfelseif attributes.act_type eq 2><!--- Ödeme talebi İse --->
								PAYMENT_VALUE = #form_to_closed_amount#,
								OTHER_PAYMENT_VALUE = #other_closed_amount#,
							<cfelseif attributes.act_type eq 3><!--- Ödeme emri İse --->
								P_ORDER_VALUE = #form_to_closed_amount#,
								OTHER_P_ORDER_VALUE = #other_closed_amount#,
							</cfif>
							OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#other_money#">,
							DUE_DATE = #due_date#
						</cfif>
						WHERE
							CLOSED_ID = #attributes.closed_id# AND
							CLOSED_ROW_ID = #evaluate("attributes.closed_row_id_#int_i#")#
					</cfquery>
				<cfelseif not (isdefined("attributes.extra_type_info") and attributes.extra_type_info eq 3)> 
					<cfquery name="ADD_CARI_CLOSED_ROW" datasource="#DSN2#">
						INSERT INTO
							CARI_CLOSED_ROW
						(
							CLOSED_ID,
							CARI_ACTION_ID,
							ACTION_ID,
							ACTION_TYPE_ID,
							ACTION_VALUE,
						<cfif attributes.act_type eq 1><!--- Kapama İşlemi İse --->
							CLOSED_AMOUNT,
							OTHER_CLOSED_AMOUNT,
						<cfelseif attributes.act_type eq 2><!--- Ödeme talebi İse --->
							PAYMENT_VALUE,
							OTHER_PAYMENT_VALUE,
						<cfelseif attributes.act_type eq 3><!--- Ödeme emri İse --->
							P_ORDER_VALUE,
							OTHER_P_ORDER_VALUE,
						</cfif>
							OTHER_MONEY,
							DUE_DATE
						)
						VALUES
						(
							#attributes.closed_id#,
							#form_cari_action_id#,
							#form_action_id#,
							#form_action_type_id#,
							#form_action_value#,
							#form_to_closed_amount#,
							#other_closed_amount#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#other_money#">,
							#due_date#
						)
					</cfquery>
				</cfif>
			<cfelseif attributes.act_type eq 3 and not(isdefined("attributes.extra_type_info") and attributes.extra_type_info eq 3) and isDefined("attributes.closed_row_id_#int_i#") and len(evaluate("attributes.closed_row_id_#int_i#")) and evaluate("attributes.closed_row_id_#int_i#") neq 0>
				<cfquery name="ADD_CARI_CLOSED_ROW" datasource="#DSN2#">
					UPDATE
						CARI_CLOSED_ROW
					SET
						P_ORDER_VALUE = NULL,
						OTHER_P_ORDER_VALUE = NULL
					WHERE
						CLOSED_ID = #attributes.closed_id# AND
						CLOSED_ROW_ID = #evaluate("attributes.closed_row_id_#int_i#")#
				</cfquery>
			<cfelseif not(isdefined("attributes.extra_type_info") and attributes.extra_type_info eq 3) and isDefined("attributes.closed_row_id_#int_i#") and len(evaluate("attributes.closed_row_id_#int_i#")) and evaluate("attributes.closed_row_id_#int_i#") neq 0>
				<cfquery name="DEL_CARI_CLOSED" datasource="#DSN2#">
					DELETE FROM CARI_CLOSED_ROW WHERE CLOSED_ROW_ID = #evaluate("attributes.closed_row_id_#int_i#")# AND CLOSED_ID = #attributes.closed_id#
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cfif isdefined("attributes.extra_type_info") and attributes.extra_type_info eq 3>
	<cfset act_type_ = attributes.extra_type_info>
<cfelse>
	<cfset act_type_ = attributes.act_type>
</cfif>
<cfset member_info = "">
<cfif isdefined("attributes.member_id") and len(attributes.member_id)><cfset member_info = '&company_id=#attributes.member_id#'>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfset member_info = '&con_id=#attributes.consumer_id#'>
<cfelseif isdefined("attributes.employee_id_new") and len(attributes.employee_id_new)><cfset member_info = '&emp_id=#attributes.employee_id_new#'>
</cfif>
<cfif isdefined("attributes.mail_control")><cfset mail_control_ = "&mail_control=1"><cfelse><cfset mail_control_ = ""></cfif><!--- Silmeyin urlden gelen verinin kaybolmamasi icin konuldu FBS 20090526 --->
<cf_workcube_process 
	is_upd='1' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='CARI_CLOSED'
	action_column='CLOSED_ID'
	action_id='#attributes.closed_id#'
	action_page='#request.self#?fuseaction=#nextEvent##attributes.closed_id##mail_control_##member_info#' 
	warning_description = 'Ödeme Talebi : #left(action_detail,100)#'>

	<cfif isdefined("attributes.extra_type_info") and attributes.extra_type_info eq 2>
		<cfquery name="get_process_cat_type" datasource="#dsn3#">
			SELECT PROCESS_TYPE,PROCESS_CAT_ID,IS_ACCOUNT,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID  = #attributes.process_cat#
		</cfquery>
		<cf_workcube_process_cat 
			process_cat="#attributes.process_cat#"
			action_id = "#attributes.closed_id#"
			action_table="CARI_CLOSED"
			action_column="CLOSED_ID"
			is_action_file = 1
			action_page='#request.self#?fuseaction=#nextEvent##attributes.closed_id#&act_type=#act_type_##mail_control_##member_info#'
			action_file_name='#get_process_cat_type.action_file_name#'
			action_db_type = '#dsn2#'
			is_template_action_file = '#get_process_cat_type.action_file_from_template#'>
	</cfif>
<cfif isdefined("attributes.extra_type_info") and attributes.extra_type_info eq 3>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=finance.list_payment_actions_order&event=upd&closed_id=#attributes.closed_id#&act_type=3#mail_control_#</cfoutput>";
	</script>
<cfelse>
	<script type="text/javascript">	
		window.location.href="<cfoutput>#request.self#?fuseaction=#nextEvent##attributes.closed_id#&act_type=#act_type_##mail_control_#</cfoutput>";
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
