<cf_date tarih='attributes.contract_date'>
<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>

<!--- Anlasma icerigindeki hizmet tipleri listeye alınır --->
<cfset list_duty_type_id = ''>
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif evaluate("attributes.row_kontrol#i#")>
		<cfset list_duty_type_id=listappend(list_duty_type_id,evaluate("attributes.duty_type_id#i#"))>
	</cfif>
</cfloop>

<cfset finish_date_= date_add('d',1,attributes.finish_date)>
<cfquery name="GET_CONTROL" datasource="#DSN#">
	SELECT 
		CBC.COMPANY_BRANCH_CONTRACT_ID
	FROM
		COMPANY_BRANCH_CONTRACT CBC,
		COMPANY_BRANCH_CONTRACT_ROW CBCR
	WHERE
		CBC.COMPANY_BRANCH_CONTRACT_ID = CBCR.CONTRACT_ID AND
		(
	<cfloop from="1" to="#listlen(list_duty_type_id)#" index="k">
		CBCR.DUTY_TYPE_ID = <cfoutput>#listgetat(list_duty_type_id,k)#</cfoutput><cfif k neq listlen(list_duty_type_id)> OR</cfif>
	</cfloop>
		) AND
		CBC.COMPANY_ID = #attributes.company_id# AND
		CBC.BRANCH_ID = #listfirst(attributes.branch_id)# AND
		CBC.COMPANY_BRANCH_CONTRACT_ID <> #attributes.contract_id# AND
		CBC.IS_ACTIVE = 1 AND		
		(
			(CBC.START_DATE >= #attributes.start_date# AND CBC.START_DATE < #finish_date_#) OR
			(CBC.START_DATE <= #attributes.start_date# AND CBC.FINISH_DATE >= #attributes.start_date#)
		)
</cfquery>

<cfif get_control.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='931.Bu Tarih Aralığında Ezcane İçin Anlaşma Kaydı Bulunmaktadır Kontrol Ediniz'> !");
		history.back(-1);
	</script>
	<cfabort>
</cfif>

<cflock timeout="60">
	<cftransaction>
		<cfquery name="GET_COMPANY_BRANCH_CONTRACT" datasource="#DSN#">
			SELECT * FROM COMPANY_BRANCH_CONTRACT WHERE COMPANY_BRANCH_CONTRACT_ID = #attributes.contract_id#
		</cfquery>

		<cfquery name="GET_COMPANY_BRANCH_CONTRACT_ROW" datasource="#DSN#">
			SELECT * FROM COMPANY_BRANCH_CONTRACT_ROW WHERE CONTRACT_ID = #attributes.contract_id#
		</cfquery>

		<cfquery name="ADD_COMPANY_BRANCH_CONTRACT_HISTORY" datasource="#DSN#">
			INSERT INTO
				COMPANY_BRANCH_CONTRACT_HISTORY
			(
				CONTRACT_ID,
				IS_ACTIVE,
				COMPANY_ID,
				BRANCH_ID,
				RELATED_ID,
				PROCESS_CAT,
				CUSTOMER_TYPE_ID,
				DETAIL,
				CONTRACT_DATE,
				START_DATE,
				FINISH_DATE,
				RESTRICT_RATE,
				CONTROL_METHOD_ID,
				MONTHLY_CAPACITY,
				MONTHLY_ENDORSEMENT,
				CUSTOMER_TYPE_DETAIL,				
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#attributes.contract_id#,
				#get_company_branch_contract.is_active#,
				#get_company_branch_contract.company_id#,
				#get_company_branch_contract.branch_id#,
				#get_company_branch_contract.related_id#,
				#get_company_branch_contract.process_cat#,
				#get_company_branch_contract.customer_type_id#,
				'#get_company_branch_contract.detail#',
				#CreateODBCDateTime(get_company_branch_contract.contract_date)#,
				#CreateODBCDateTime(get_company_branch_contract.start_date)#,
				#CreateODBCDateTime(get_company_branch_contract.finish_date)#,
				<cfif len(get_company_branch_contract.restrict_rate)>#get_company_branch_contract.restrict_rate#<cfelse>NULL</cfif>,
				#get_company_branch_contract.control_method_id#,
				#get_company_branch_contract.monthly_capacity#,
				#get_company_branch_contract.monthly_endorsement#,
				'#get_company_branch_contract.customer_type_detail#',
			<cfif len(get_company_branch_contract.update_emp)>
				#CreateODBCDateTime(get_company_branch_contract.update_date)#,
				#get_company_branch_contract.update_emp#,
				'#get_company_branch_contract.update_ip#'
			<cfelse>
				#CreateODBCDateTime(get_company_branch_contract.record_date)#,
				#get_company_branch_contract.record_emp#,
				'#get_company_branch_contract.record_ip#'
			</cfif>
			)
		</cfquery>
		<cfquery name="GET_MAXID" datasource="#DSN#">
			SELECT MAX(CONTRACT_HISTORY_ID) CONTRACT_HISTORY_ID FROM COMPANY_BRANCH_CONTRACT_HISTORY
		</cfquery>
		
		<cfloop query="get_company_branch_contract_row">
			<cfquery name="BRANCH_CONTRACT_ROW" datasource="#DSN#">
				INSERT INTO
					COMPANY_BRANCH_CONTRACT_ROW_HISTORY
				(
					CONTRACT_HISTORY_ID,
					CONTRACT_ID,
					DUTY_TYPE_ID,
					IS_VALUE,
					COST_AMOUNT,
					IS_TARGET,
					TARGET_PERIOD_ID,
					TARGET_AMOUNT,
					IS_CATEGORY
				)
				VALUES
				(
					#get_maxid.contract_history_id#,
					#get_company_branch_contract_row.contract_id#,
					#get_company_branch_contract_row.duty_type_id#,
					#get_company_branch_contract_row.is_value#,						
					#get_company_branch_contract_row.cost_amount#,
					#get_company_branch_contract_row.is_target#,
				<cfif get_company_branch_contract_row.target_period_id eq 1>
					#get_company_branch_contract_row.target_period_id#,
					#get_company_branch_contract_row.target_amount#,					
				<cfelse>
					NULL,
					NULL,
				</cfif>
					#get_company_branch_contract_row.is_category#
				)
			</cfquery>
		</cfloop>

		<cfquery name="UPD_COMPANY_BRANCH_CONTRACT" datasource="#DSN#">
			UPDATE
				COMPANY_BRANCH_CONTRACT
			SET
				IS_ACTIVE = <cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
				COMPANY_ID = #attributes.company_id#,
				BRANCH_ID = #attributes.branch_id#,
				RELATED_ID = #attributes.related_id#,
				PROCESS_CAT = #attributes.process_stage#,
				CUSTOMER_TYPE_ID = #attributes.customer_type_id#,
				DETAIL = '#attributes.detail#',
				CONTRACT_DATE = #attributes.contract_date#,
				START_DATE = #attributes.start_date#,
				FINISH_DATE = #attributes.finish_date#,
			
				RESTRICT_RATE = <cfif len(attributes.restrict_rate)>#attributes.restrict_rate#<cfelse>NULL</cfif>,
				CONTROL_METHOD_ID = #attributes.control_method#,
				MONTHLY_CAPACITY = #attributes.monthly_capacity#,
				MONTHLY_ENDORSEMENT = #attributes.monthly_endorsement#,
				CUSTOMER_TYPE_DETAIL = '#attributes.customer_type_detail#',
								
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE
				COMPANY_BRANCH_CONTRACT_ID = #attributes.contract_id#
		</cfquery>
		
		<cfquery name="DEL_BRANCH_CONTRACT_ROW" datasource="#DSN#">
			DELETE FROM 
				COMPANY_BRANCH_CONTRACT_ROW 
			WHERE
				CONTRACT_ID = #attributes.contract_id#
		</cfquery>
		
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#")>
				<cfscript>
					form_duty_type_id = evaluate("attributes.duty_type_id#i#");
					form_is_value = evaluate("attributes.is_value#i#");
					form_cost_amount = evaluate("attributes.cost_amount#i#");
					form_is_target = evaluate("attributes.is_target#i#");
					if(form_is_target eq 1)
					{
						form_target_period = evaluate("attributes.target_period#i#");
						form_target_amount = evaluate("attributes.target_amount#i#");
					}
				</cfscript>
				
				<cfquery name="BRANCH_CONTRACT_ROW" datasource="#DSN#">
					INSERT INTO
						COMPANY_BRANCH_CONTRACT_ROW
					(
						CONTRACT_ID,
						DUTY_TYPE_ID,
						IS_VALUE,
						COST_AMOUNT,
						IS_TARGET,
						TARGET_PERIOD_ID,
						TARGET_AMOUNT,
						IS_CATEGORY
						
					)
					VALUES
					(
						#attributes.contract_id#,
						#form_duty_type_id#,
						#form_is_value#,						
						#form_cost_amount#,
						#form_is_target#,
					<cfif form_is_target eq 1>
						#form_target_period#,
						#form_target_amount#,
					<cfelse>
						NULL,
						NULL,
					</cfif>
						0
					)
				</cfquery>
			</cfif>
		</cfloop>
		
		<cfif attributes.record_num_ gt 0>
			<cfloop from="1" to="#attributes.record_num_#" index="i">
				<cfif evaluate("attributes.row_kontrol_#i#")>
					<cfscript>
						form_duty_type_id_ = evaluate("attributes.duty_type_id_#i#");
						form_is_value_ = evaluate("attributes.is_value_#i#");
						form_cost_amount_ = evaluate("attributes.cost_amount_#i#");
						form_is_target_ = evaluate("attributes.is_target_#i#");
						if(form_is_target_ eq 1)
						{
							form_target_period_ = evaluate("attributes.target_period_#i#");
							form_target_amount_ = evaluate("attributes.target_amount_#i#");
						}
					</cfscript>
					
					<!--- <cfoutput>record_num : #record_num# -- form_is_target_ : #form_is_target_# -- form_target_period_:#form_target_period_# -- form_target_amount_: #form_target_amount_#</cfoutput> --->
					
					<cfquery name="BRANCH_CONTRACT_ROW" datasource="#DSN#">
						INSERT INTO
							COMPANY_BRANCH_CONTRACT_ROW
						(
							CONTRACT_ID,
							DUTY_TYPE_ID,
							IS_VALUE,
							COST_AMOUNT,
							IS_TARGET,
							TARGET_PERIOD_ID,
							TARGET_AMOUNT,
							IS_CATEGORY
						)
						VALUES
						(
							#attributes.contract_id#,
							#form_duty_type_id_#,
							#form_is_value_#,						
							#form_cost_amount_#,
							#form_is_target_#,
						<cfif form_is_target_ eq 1>
							#form_target_period_#,
							#form_target_amount_#,
						<cfelse>
							NULL,
							NULL,
						</cfif>
							1
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<cf_workcube_process 
			is_upd='1' 
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_company&cpid=#attributes.company_id#' 
			action_id='#attributes.contract_id#'
			old_process_line='#attributes.old_process_line#' 
			warning_description = '(İlgili Eczane ve Şube) : #attributes.company_name# - #attributes.branch_name#'>	
	</cftransaction>
</cflock>
<script type="text/javascript">
	self.close();
	wrk_opener_reload(); 
</script>

