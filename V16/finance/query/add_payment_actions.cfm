<cf_get_lang_set module_name="finance"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined("attributes.employee_id_new") and listlen(attributes.employee_id_new,'_') eq 2>
	<cfset acc_type_id = listlast(attributes.employee_id_new,'_')>
	<cfset attributes.employee_id_new = listfirst(attributes.employee_id_new,'_')>
<cfelseif not isdefined("attributes.employee_id_new")>
	<cfset attributes.employee_id_new = ''>
	<cfset acc_type_id = ''>
</cfif>
<cfif isdefined("attributes.value_list")>
	<cfset total=0>
	<cfset all_total=0>
	<cfset my_date =0>
	<cfset tarih_farki =0>
	<cfloop list="#attributes.value_list#" index="k">
		<cfset total = total + k>
	</cfloop>
	<cfset list_len = listlen(attributes.value_list)>
	<cfif list_len gt 0>
		<cfloop from="1" to="#list_len#" index="j">
			<cfif len(listgetat(attributes.due_datelist,j))>
				<cfset my_date = DateDiff("d",createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'),listgetat(attributes.due_datelist,j))>
			<cfelse>
				<cfset my_date = DateDiff("d",createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'),listgetat(attributes.action_datelist,j))>
			</cfif>	
			<cfset all_total = all_total + (listgetat(attributes.value_list,j)*my_date)>
		</cfloop>
		<cfif total neq 0>
			<cfset tarih_farki = all_total / total>
		<cfelse>
			<cfset tarih_farki = 1>	
		</cfif>
		<cfset attributes.due_date = dateformat(date_add("d",tarih_farki,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')),dateformat_style)>
	<cfelse>
		<cfset attributes.due_date = dateformat(now(),dateformat_style)>
	</cfif>
</cfif>
<cf_date tarih='attributes.payment_date'>
<cf_date tarih='attributes.due_date'>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfif isDefined("attributes.correspondence_info")>
			<cfset attributes.all_records = 1>
			<cfset attributes.is_closed_1 = 1>
		</cfif>
		<cfquery name="ADD_CARI_CLOSED" datasource="#DSN2#">
			INSERT INTO 
				CARI_CLOSED
			(	
				PROCESS_STAGE,
				COMPANY_ID,
				CONSUMER_ID,
				EMPLOYEE_ID,
				PROJECT_ID,
				ORDER_ID,
				OTHER_MONEY,
				<cfif isDefined("attributes.correspondence_info")><!--- yazışmalardan geliyorsa --->
					<cfif attributes.act_type eq 2>IS_DEMAND<cfelseif attributes.act_type eq 3>IS_ORDER</cfif>,
					<cfif attributes.act_type eq 2>PAYMENT_DEBT_AMOUNT_VALUE<cfelseif attributes.act_type eq 3>P_ORDER_DEBT_AMOUNT_VALUE</cfif>,
					<cfif attributes.act_type eq 2>PAYMENT_CLAIM_AMOUNT_VALUE<cfelseif attributes.act_type eq 3>P_ORDER_CLAIM_AMOUNT_VALUE</cfif>,
					<cfif attributes.act_type eq 2>PAYMENT_DIFF_AMOUNT_VALUE<cfelseif attributes.act_type eq 3>P_ORDER_DIFF_AMOUNT_VALUE</cfif>,
				<cfelse>
					<cfif attributes.act_type eq 1><!--- Kapama İşlemi İse --->
						IS_CLOSED,							
						DEBT_AMOUNT_VALUE,
						CLAIM_AMOUNT_VALUE,
						DIFFERENCE_AMOUNT_VALUE,
					<cfelseif attributes.act_type eq 2><!--- Ödeme talebi İse --->
						IS_DEMAND,
						PAYMENT_DEBT_AMOUNT_VALUE,
						PAYMENT_CLAIM_AMOUNT_VALUE,
						PAYMENT_DIFF_AMOUNT_VALUE,
					<cfelseif attributes.act_type eq 3><!--- Ödeme emri İse --->
						IS_ORDER,
						P_ORDER_DEBT_AMOUNT_VALUE,
						P_ORDER_CLAIM_AMOUNT_VALUE,
						P_ORDER_DIFF_AMOUNT_VALUE,
					</cfif>
				</cfif>
				ACTION_DETAIL,
				ADDITIONAL_DETAIL,
				PAPER_ACTION_DATE,
				PAPER_DUE_DATE,
				PAYMETHOD_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				ACC_TYPE_ID,
				PROCESS_CAT,
				CONTRACT_ID
			)
			VALUES
			(
				#attributes.process_stage#,
				<cfif len(attributes.member_id)>#attributes.member_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.employee_id_new)>#attributes.employee_id_new#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.order_id") and len(attributes.order_id)>#attributes.order_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">,
				</cfif>
				<cfif isDefined("attributes.correspondence_info")><!--- yazışmalardan geliyorsa --->
					1,
					0,
					#attributes.total_difference_amount#,
					#(-1*attributes.total_difference_amount)#,
				<cfelse>
					1,
					#attributes.total_debt_amount#,
					#attributes.total_claim_amount#,
					#attributes.total_difference_amount#,
				</cfif>
				<cfif len(attributes.action_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(attributes.action_detail,500)#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.additional_subject") and len(attributes.additional_subject)><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(attributes.additional_subject,1000)#"><cfelse>NULL</cfif>,
				#attributes.payment_date#,
				#attributes.due_date#,
				<cfif len(attributes.paymethod_id) and len(attributes.paymethod)>#attributes.paymethod_id#,<cfelse>NULL,</cfif>
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfif isdefined("acc_type_id") and len(acc_type_id)>#acc_type_id#<cfelse>NULL</cfif>,
				<cfif isdefined("process_cat") and len(process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.contract_id") and len(attributes.contract_id)>#attributes.contract_id#<cfelse>NULL</cfif>
			)
		</cfquery>
		<cfquery name="GET_MAX_CLOSED" datasource="#DSN2#">
			SELECT MAX(CLOSED_ID) AS CLOSED_ID FROM CARI_CLOSED
		</cfquery>
		<cfloop from="1" to="#attributes.all_records#" index="int_i">
			<cfif isdefined("attributes.is_closed_#int_i#")><!--- bu hareket secilmis --->
				<cfif not isDefined("attributes.correspondence_info")>
					<cfset form_action_id = Evaluate("attributes.action_id_#int_i#")>
					<cfset form_cari_action_id = Evaluate("attributes.cari_action_id_#int_i#")>
					<cfset form_action_type_id = Evaluate("attributes.action_type_id_#int_i#")>
					<cfset form_action_value = Evaluate("attributes.action_value_#int_i#")>
					<cfset form_to_closed_amount = Evaluate("attributes.to_closed_amount_#int_i#")>
					<cfset other_closed_amount = Evaluate("attributes.other_closed_amount_#int_i#")>
					<cfset other_money = Evaluate("attributes.other_money_#int_i#")>
					<cfset due_date = Evaluate("attributes.due_date_#int_i#")>
					<cf_date tarih = "due_date">
				<cfelse>
					<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
						SELECT RATE2 FROM SETUP_MONEY WHERE MONEY = '#attributes.money_type#'
					</cfquery>
					<cfif attributes.money_type eq session.ep.money>
						<cfset attributes.other_total_difference_amount = attributes.total_difference_amount>
						<cfset attributes.total_difference_amount = attributes.total_difference_amount>
					<cfelse>
						<cfset attributes.other_total_difference_amount = attributes.total_difference_amount>
						<cfset attributes.total_difference_amount = wrk_round(attributes.total_difference_amount*GET_MONEY_INFO.RATE2)>
					</cfif>
				</cfif>
                <cfif IsDefined("form_cari_action_id") and len(form_cari_action_id)>
                    <cfquery name="check_multi_records" datasource="#dsn2#">
                        SELECT
                            ROUND(ISNULL(CR.ACTION_VALUE,0) - ISNULL(SUM(CCR.CLOSED_AMOUNT),0),2) REMAINING_AMOUNT,
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
                    <cfif check_multi_records.recordcount and check_multi_records.REMAINING_AMOUNT lt other_closed_amount>
                        <script type="text/javascript">
                            alert('<cfoutput>#check_multi_records.paper_no# numaralı belgenin fatura kapama tutarı toplam tutarından fazla olmaktadır. Lütfen carinin ilgili belgesinin önceki faturalarını da kontrol ediniz.</cfoutput>');
                            window.location = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_payment_actions&event=add&act_type=#attributes.act_type#&member_id=#check_multi_records.cmp_id#&consumer_id=#check_multi_records.cons_id#&employee_id_new=#check_multi_records.emp_id#</cfoutput>";
                        </script>
                        <cfabort>
                    </cfif>
                </cfif>
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
						#get_max_closed.closed_id#,
						<cfif isDefined("attributes.correspondence_info")>
							0,
							0,
							0,
							0,
							#attributes.total_difference_amount#,
							#attributes.other_total_difference_amount#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money_type#">,
							#attributes.due_date#
						<cfelse>
							#form_cari_action_id#,
							#form_action_id#,
							#form_action_type_id#,
							#form_action_value#,
							#form_to_closed_amount#,
							#other_closed_amount#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#other_money#">,
							#due_date#
						</cfif>
					)
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cfif listgetat(attributes.fuseaction,1,'.') is 'correspondence'><cfset mail_control_ = "&mail_control=1"><cfelse><cfset mail_control_ = ""></cfif>
<cfset member_info = "">
<cfif isdefined("attributes.member_id") and len(attributes.member_id)><cfset member_info = '&company_id=#attributes.member_id#'>
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfset member_info = '&con_id=#attributes.consumer_id#'>
<cfelseif isdefined("attributes.employee_id_new") and len(attributes.employee_id_new)><cfset member_info = '&emp_id=#attributes.employee_id_new#'>
</cfif>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='CARI_CLOSED'
	action_column='CLOSED_ID'
	action_id='#get_max_closed.closed_id#'
	action_page='#request.self#?fuseaction=#nextEvent##get_max_closed.closed_id#&act_type=#attributes.act_type##mail_control_##member_info#' 
	warning_description = 'Ödeme Talebi : #left(action_detail,100)#'>

	<cfif isdefined("attributes.act_type") and len(attributes.act_type) eq 2>
		<cfquery name="get_process_cat_type" datasource="#dsn3#">
			SELECT PROCESS_TYPE,PROCESS_CAT_ID,IS_ACCOUNT,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID  = #attributes.process_cat#
		</cfquery>
		<cf_workcube_process_cat 
			process_cat="#attributes.process_cat#"
			action_id = "#get_max_closed.closed_id#"
			action_table="CARI_CLOSED"
			action_column="CLOSED_ID"
			is_action_file = 1
			action_page='#request.self#?fuseaction=#nextEvent##get_max_closed.closed_id#&act_type=#attributes.act_type##mail_control_##member_info#'
			action_file_name='#get_process_cat_type.action_file_name#'
			action_db_type = '#dsn2#'
			is_template_action_file = '#get_process_cat_type.action_file_from_template#'>
	</cfif>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#nextEvent##get_max_closed.closed_id#&act_type=#attributes.act_type##mail_control_#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
