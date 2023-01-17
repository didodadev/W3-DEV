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
		<cfquery name="ADD_COMPANY_BRANCH_CONTRACT" datasource="#DSN#">
			INSERT INTO
				COMPANY_BRANCH_CONTRACT
			(
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
				1,
				#attributes.company_id#,
				#listfirst(attributes.branch_id)#,
				#listlast(attributes.branch_id)#,
				#attributes.process_stage#,
				#attributes.target_customer_type#,
				'#attributes.detail#',
				#attributes.contract_date#,
				#attributes.start_date#,
				#attributes.finish_date#,
				
				<cfif len(attributes.restrict_rate)>#attributes.restrict_rate#<cfelse>NULL</cfif>,
				#attributes.control_method#,
				#attributes.monthly_capacity#,
				#attributes.monthly_endorsement#,
				'#attributes.customer_type_detail#',				
							
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		<cfquery name="GET_MAXID" datasource="#DSN#">
			SELECT MAX(COMPANY_BRANCH_CONTRACT_ID) COMPANY_BRANCH_CONTRACT_ID FROM COMPANY_BRANCH_CONTRACT
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
						#get_maxid.company_branch_contract_id#,
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
							#get_maxid.company_branch_contract_id#,
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

		<cfquery name="GET_BRANCH" datasource="#DSN#">
			SELECT			
				BRANCH.BRANCH_NAME
			FROM
				BRANCH
			WHERE
				BRANCH.BRANCH_ID = #listlast(attributes.branch_id)#
		</cfquery>
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_page='#request.self#?fuseaction=crm.popup_upd_branch_contract&contract_id=#get_maxid.company_branch_contract_id#' 
			action_id='#get_maxid.company_branch_contract_id#'
			warning_description = 'İlgili Eczane ve Şube : #attributes.company_name# - #get_branch.branch_name#'>		
	</cftransaction>
</cflock>
<script type="text/javascript">
	opener.window.location.reload();
	window.close();
</script>
