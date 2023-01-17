<cfscript>
	if(isdefined("to_pos_ids") and len(to_pos_ids)) to_pos_ids = ListSort(to_pos_ids,"Numeric", "Desc"); else to_pos_ids ='';
	if(isdefined("cc_par_ids") and len(cc_par_ids))  cc_par_ids = ListSort(cc_par_ids,"Numeric", "Desc") ; else cc_par_ids ='';
	if(isdefined("cc_comp_ids") and len(cc_comp_ids)) cc_comp_ids =  ListSort(cc_comp_ids,"Numeric", "Desc") ; else cc_comp_ids ='';
	if(isdefined("cc_cons_ids") and len(cc_cons_ids)) cc_cons_ids =  ListSort(cc_cons_ids,"Numeric", "Desc") ; else cc_cons_ids ='';
</cfscript>

<cfset attributes.company_id = ListDeleteDuplicates(attributes.company_id)>
<cfset attributes.consumer_id = ListDeleteDuplicates(attributes.consumer_id)>
<cf_date tarih = "attributes.start">
<cf_date tarih = "attributes.finish"> 
<cfquery name="ADD_CONTRACT" datasource="#DSN3#" result="MAX_ID">
	INSERT INTO
		RELATED_CONTRACT
		(
			STAGE_ID,
			PROCESS_CAT,
			STATUS,
			TERM,
			CONTRACT_CAT_ID,
			STARTDATE,
			FINISHDATE,
			CONTRACT_HEAD,
			PROJECT_ID,
			CONTRACT_BODY,
			OUR_COMPANY_ID,
			COMPANY_ID,
			CONSUMER_ID,
			<cfif isdefined("cc_par_ids") and len(cc_par_ids)>
			COMPANY_PARTNER,
			COMPANY,
			</cfif>
			<cfif isdefined("to_pos_ids") and len(to_pos_ids)>EMPLOYEE,</cfif>
			<cfif isdefined("cc_cons_ids") and len(cc_cons_ids)>CONSUMERS,</cfif>
			CONTRACT_NO,
			CONTRACT_AMOUNT,
			CONTRACT_TAX,
			CONTRACT_TAX_AMOUNT,
			CONTRACT_UNIT_PRICE,
			CONTRACT_MONEY,
			GUARANTEE_AMOUNT,
			GUARANTEE_RATE,
			ADVANCE_AMOUNT,
			TEVKIFAT_RATE_ID,
			TEVKIFAT_RATE,
            STOPPAGE_RATE_ID,
			STOPPAGE_RATE,
			ADVANCE_RATE,
			CONTRACT_TYPE,
			CONTRACT_CALCULATION,
            DISCOUNT_RATE,
            PAYMETHOD_ID,
            CARD_PAYMETHOD_ID,
            DELIVER_DEPT_ID,
            LOCATION_ID,
            SHIP_METHOD_ID,
			STAMP_TAX,
			STAMP_TAX_RATE,
			COPY_NUMBER,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
	VALUES
		(
			#attributes.process_stage#,
			<cfif isdefined('attributes.process_cat')>#attributes.process_cat#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
			#year(attributes.start)#,
			'#CONTRACT_CAT_ID#',
			#attributes.START#,
			#attributes.FINISH#,
			'#attributes.CONTRACT_HEAD#',
			<cfif len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
			'#attributes.CONTRACT_BODY#',
			#session.ep.company_id#,
			<cfif len(attributes.company_id) and len(attributes.member_name)>#ListDeleteDuplicates(attributes.company_id)#<cfelse>NULL</cfif>,
			<cfif len(attributes.consumer_id) and len(attributes.member_name)>#attributes.consumer_id#<cfelse>NULL</cfif>,
			<cfif isdefined("cc_par_ids") and len(cc_par_ids)>
			',#cc_par_ids#,',
			',#ListDeleteDuplicates(cc_comp_ids)#,', 
			</cfif>
			<cfif isdefined("to_pos_ids") and len(to_pos_ids)>',#to_pos_ids#,',</cfif>
			<cfif isdefined("cc_cons_ids") and len(cc_cons_ids)>',#cc_cons_ids#,',</cfif>
			<cfif isdefined('attributes.contract_no') and len(attributes.contract_no)>'#attributes.contract_no#'<cfelse>NULL</cfif>,
			<cfif len(attributes.contract_amount)>#attributes.contract_amount#<cfelse>NULL</cfif>,
			<cfif len(attributes.contract_tax)>#attributes.contract_tax#<cfelse>NULL</cfif>,
			<cfif len(attributes.contract_tax_amount)>#attributes.contract_tax_amount#<cfelse>NULL</cfif>,
			<cfif len(attributes.contract_unit_price)>#attributes.contract_unit_price#<cfelse>NULL</cfif>,
			<cfif len(attributes.contract_money)>'#attributes.contract_money#'<cfelse>NULL</cfif>,
			<cfif len(attributes.guarantee_amount)>#attributes.guarantee_amount#<cfelse>NULL</cfif>,
			<cfif len(attributes.guarantee_rate)>#attributes.guarantee_rate#<cfelse>0</cfif>,
			<cfif len(attributes.advance_amount)>#attributes.advance_amount#<cfelse>NULL</cfif>,
			<cfif len(attributes.tevkifat_oran) and len(attributes.tevkifat_oran_id)>#attributes.tevkifat_oran_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.tevkifat_oran) and len(attributes.tevkifat_oran_id)>#attributes.tevkifat_oran#<cfelse>NULL</cfif>,
            <cfif len(attributes.stoppage_oran) and len(attributes.stoppage_oran_id)>#attributes.stoppage_oran_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.stoppage_oran) and len(attributes.stoppage_oran_id)>#attributes.stoppage_oran#<cfelse>NULL</cfif>,
			<cfif len(attributes.advance_rate)>#attributes.advance_rate#<cfelse>0</cfif>,
			<cfif len(attributes.contract_type)>#attributes.contract_type#<cfelse>NULL</cfif>,
			<cfif len(attributes.contract_calculation)>#attributes.contract_calculation#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.discount') and len(attributes.discount)>#attributes.discount#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.pay_method') and len(attributes.pay_method) and isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.ship_method_name') and len(attributes.ship_method_name) and isdefined('attributes.card_paymethod_id') and len(attributes.card_paymethod_id)>#attributes.card_paymethod_id#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.deliver_dept_id') and isdefined('attributes.deliver_dept_name') and len(attributes.deliver_dept_name) and len(attributes.deliver_dept_id)>#attributes.deliver_dept_id#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.deliver_loc_id') and isdefined('attributes.deliver_dept_name') and len(attributes.deliver_dept_name) and len(attributes.deliver_loc_id)>#attributes.deliver_loc_id#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.ship_method_name') and len(attributes.ship_method_name) and isdefined('attributes.ship_method_id') and len(attributes.ship_method_id)>#attributes.ship_method_id#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.stamp_tax') and len(attributes.stamp_tax)>#attributes.stamp_tax#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.stamp_tax_rate') and len(attributes.stamp_tax_rate)>#attributes.stamp_tax_rate#<cfelse>0</cfif>,
			<cfif isdefined('attributes.copy_number') and len(attributes.copy_number)>#attributes.copy_number#<cfelse>NULL</cfif>,
			#SESSION.EP.USERID#,
			#now()#,
			'#cgi.remote_addr#'
		)
</cfquery>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<!--- Bu cariye ait onceki hareketler siliniyor --->
		<cfif isDefined("attributes.form_upd_") and len(MAX_ID.IDENTITYCOL)>
			<cfquery name="DEL_PRICE_CAT_EXCEPTIONS" datasource="#DSN3#">
				DELETE FROM
					PRICE_CAT_EXCEPTIONS
				WHERE
					ISNULL(ACT_TYPE,1) IN(1,3) AND		
					CONTRACT_ID = #MAX_ID.IDENTITYCOL#
			</cfquery>
		</cfif>
       <!---  <cfif isdefined('attributes.record_num_')>
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
                            <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.PRODUCT_CAT_ID#i#")) and len(evaluate("attributes.product_cat_name#i#"))>#evaluate("attributes.PRODUCT_CAT_ID#i#")#<cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.brand_id#i#")) and len(evaluate("attributes.brand_name#i#"))>#evaluate("attributes.brand_id#i#")#<cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.PRODUCT_ID#i#")) and len(evaluate("attributes.product_name#i#"))>#evaluate("attributes.PRODUCT_ID#i#")#<cfelse>NULL</cfif>,
                            #evaluate("attributes.price_cat#i#")#,
                            <cfif len(evaluate("attributes.price#i#")) >#evaluate("attributes.price#i#")#<cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.price_money#i#")) >'#evaluate("attributes.price_money#i#")#'<cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.discount_info#i#"))>#filternum(evaluate("attributes.discount_info#i#"))#<cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.discount_info2#i#"))>#filternum(evaluate("attributes.discount_info2#i#"))#<cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.discount_info3#i#"))>#filternum(evaluate("attributes.discount_info3#i#"))#<cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.discount_info4#i#"))>#filternum(evaluate("attributes.discount_info4#i#"))#<cfelse>NULL</cfif>,
                            <cfif len(evaluate("attributes.discount_info5#i#"))>#filternum(evaluate("attributes.discount_info5#i#"))#<cfelse>NULL</cfif>,
                            <cfif isdefined("attributes.short_code_id#i#") and len(evaluate("attributes.short_code_id#i#")) and isdefined("attributes.short_code#i#") and len(evaluate("attributes.short_code#i#"))>#evaluate("attributes.short_code_id#i#")#<cfelse>NULL</cfif>,
                            #MAX_ID.IDENTITYCOL#,
                            <cfif isdefined("attributes.payment_type_id#i#") and len(evaluate("attributes.payment_type_id#i#")) and isdefined("attributes.payment_type#i#")>#evaluate("attributes.payment_type_id#i#")#<cfelse>NULL</cfif>,
                            #session.ep.userid#,
                            '#remote_addr#',
                            #now()#
                        )
                    </cfquery>
                </cfif>
			</cfloop>
		</cfif> --->
	
        <cfsavecontent variable="contract"><cf_get_lang_main no='1725.Sözleşme'></cfsavecontent>
		<cf_workcube_process is_upd='1' 
			data_source='#dsn3#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='RELATED_CONTRACT'
			action_column='CONTRACT_ID'
			action_id='#MAX_ID.IDENTITYCOL#'
			action_page='#request.self#?fuseaction=contract.list_related_contracts&event=upd&contract_id=#MAX_ID.IDENTITYCOL#' 
			warning_description='#contract# : #MAX_ID.IDENTITYCOL#'>
		<cfif isdefined("attributes.process_cat")>
			<cfset get_contract= createObject("component","V16.contract.cfc.contract") />
			<cfset get_process_type=get_contract.get_process_type(process_cat:form.process_cat)/>
			<cf_workcube_process_cat 
				process_cat="#attributes.process_cat#"
				action_id = #MAX_ID.IDENTITYCOL#
				is_action_file = 1
				action_table="RELATED_CONTRACT"
				action_column="CONTRACT_ID"
				action_file_name='#get_process_type.action_file_name#'
				action_page='#request.self#?fuseaction=contract.list_related_contracts&event=upd&contract_id=#MAX_ID.IDENTITYCOL#'
				action_db_type="#dsn3#"
				is_template_action_file = '#get_process_type.action_file_from_template#'>		
		</cfif>
	</cftransaction>
	<!--- History --->
		<!---Ek Bilgiler--->
		<cfset attributes.info_id = MAX_ID.IDENTITYCOL>
		<cfset attributes.is_upd = 0>
		<cfset attributes.info_type_id = -21>
		<cfinclude template="../../objects/query/add_info_plus2.cfm">
	<!---Ek Bilgiler--->
	<cf_wrk_get_history  datasource='#dsn3#' source_table='RELATED_CONTRACT' target_table='RELATED_CONTRACT_HISTORY' record_id='#MAX_ID.IDENTITYCOL#' record_name='CONTRACT_ID'>
</cflock>
<cfif not isdefined("attributes.is_popup")>
	<script type="text/javascript">
        window.location.href="<cfoutput>#request.self#?fuseaction=contract.list_related_contracts&event=upd&contract_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
    </script>
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>
<cfset attributes.actionId = MAX_ID.IDENTITYCOL>

