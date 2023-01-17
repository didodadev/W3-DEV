<cfquery name="get_process_type" datasource="#dsn3#">
	SELECT 
		PROCESS_TYPE,
		ACTION_FILE_NAME,
		ACTION_FILE_FROM_TEMPLATE
	 FROM 
	 	SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfscript>
			attributes.acc_type_id = '';
			if(listlen(attributes.emp_id,'_') eq 2)
			{
				attributes.acc_type_id = listlast(attributes.emp_id,'_');
				attributes.emp_id = listfirst(attributes.emp_id,'_');
			}
			if(listlen(attributes.old_emp_id,'_') eq 2)
			{
				attributes.old_emp_id = listfirst(attributes.old_emp_id,'_');
			}
			if(len(attributes.emp_id)) attributes.comp_id = "";
			if(listlen(attributes.old_comp_id,'_') eq 2)
			{
				attributes.old_comp_id = listfirst(attributes.old_comp_id,'_');
			}
			if(listlen(attributes.old_cons_id,'_') eq 2)
			{
				attributes.old_cons_id = listfirst(attributes.old_cons_id,'_');
			}
			if(listlen(attributes.comp_id,'_') eq 2)
			{
				attributes.acc_type_id = listlast(attributes.comp_id,'_');
				attributes.comp_id = listfirst(attributes.comp_id,'_');
			}
			if(listlen(attributes.cons_id,'_') eq 2)
			{
				attributes.acc_type_id = listlast(attributes.cons_id,'_');
				attributes.cons_id = listfirst(attributes.cons_id,'_');
			}
		</cfscript>
		<cfif len(attributes.old_comp_id)>
			<cfquery name="del_cari_open" datasource="#dsn2#">
				DELETE FROM CARI_ROWS WHERE ACTION_TYPE_ID = #get_process_type.process_type# AND CARI_ACTION_ID = #attributes.CARI_ACTION_ID# AND (FROM_CMP_ID = #attributes.old_comp_id# OR TO_CMP_ID = #attributes.old_comp_id#)
				<cfif len(attributes.acc_type_id)>AND ACC_TYPE_ID = #attributes.acc_type_id# </cfif>
			</cfquery>
		</cfif>
		<cfif len(attributes.old_cons_id)>
			<cfquery name="del_cari_open" datasource="#dsn2#">
				DELETE FROM CARI_ROWS WHERE ACTION_TYPE_ID = #get_process_type.process_type# AND CARI_ACTION_ID = #attributes.CARI_ACTION_ID# AND (FROM_CONSUMER_ID = #attributes.old_cons_id# OR TO_CONSUMER_ID = #attributes.old_cons_id#)
				<cfif len(attributes.acc_type_id)>AND ACC_TYPE_ID = #attributes.acc_type_id# </cfif>
			</cfquery>
		</cfif>
		<cfif len(attributes.old_emp_id)>
			<cfif not len(attributes.acc_type_id)>
				<cfquery name="del_cari_open" datasource="#dsn2#">
					DELETE FROM CARI_ROWS WHERE ACTION_TYPE_ID = #get_process_type.process_type# AND CARI_ACTION_ID = #attributes.CARI_ACTION_ID# AND (FROM_EMPLOYEE_ID = #attributes.old_emp_id# OR TO_EMPLOYEE_ID = #attributes.old_emp_id#) 
				</cfquery>
			<cfelse>
				<cfquery name="del_cari_open" datasource="#dsn2#">
					DELETE FROM CARI_ROWS WHERE ACTION_TYPE_ID = #get_process_type.process_type# AND CARI_ACTION_ID = #attributes.CARI_ACTION_ID# AND (FROM_EMPLOYEE_ID = #attributes.old_emp_id# OR TO_EMPLOYEE_ID = #attributes.old_emp_id#) AND ACC_TYPE_ID = #attributes.acc_type_id#
				</cfquery>
			</cfif>
		</cfif>
		<cf_date tarih='attributes.open_date'>
		<cf_date tarih='attributes.due_date'>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			<cfset to_branch_id = attributes.branch_id>
		<cfelse>
			<cfset to_branch_id = listgetat(session.ep.user_location,2,'-')>
		</cfif>
		<cfscript>
			if (session.ep.our_company_info.project_followup neq 1)//isdefined lar altta functionlarda sıkıntı yaratıyordu buraya tanımlandı
			{
				attributes.project_id = "";
				attributes.project_name = "";
			}
			str_currency_multiplier ='';
			if(isnumeric(attributes.debt) and attributes.debt gt 0)
			{
				if(attributes.action_value_2 gt 0)
					str_currency_multiplier = wrk_round((attributes.debt/attributes.action_value_2),session.ep.our_company_info.rate_round_num);
				carici
				(
					action_id : -1,
					action_table : 'CARI_ROWS',
					process_cat : form.process_cat,
					islem_belge_no : attributes.paper_no,
					workcube_process_type : get_process_type.process_type,
					other_money_value :  attributes.other_money_value,
					other_money : attributes.other_money_type,
					islem_tutari : attributes.debt,
					islem_tarihi : attributes.open_date,
					to_cmp_id : attributes.comp_id,
					to_consumer_id : attributes.cons_id,
					acc_type_id : attributes.acc_type_id,
					to_employee_id : attributes.emp_id,
					islem_detay : iif(len(attributes.detail),de('#attributes.detail#'),de('AÇILIŞ FİŞİ')),
					subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)),attributes.subscription_id,de('')),
					action_detail : attributes.detail,
					action_value2 :attributes.action_value_2,
					action_currency_2 : session.ep.money2,
					due_date : attributes.due_date,
					account_card_type : 10,
					project_id : iif((isdefined("attributes.project_id") and len(attributes.project_name)),'attributes.project_id',de('')),
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					to_branch_id : to_branch_id
				);
			}		
			else if(isnumeric(attributes.claim) and attributes.claim gt 0)
			{
				if(attributes.action_value_2 gt 0)
					str_currency_multiplier = wrk_round((attributes.claim/attributes.action_value_2),session.ep.our_company_info.rate_round_num);
				
				carici
				(
					action_id : -1,
					action_table : 'CARI_ROWS',
					process_cat : form.process_cat,
					islem_belge_no : attributes.paper_no,
					workcube_process_type : get_process_type.process_type,	
					other_money_value :  attributes.other_money_value,
					other_money : attributes.other_money_type,
					islem_tutari : attributes.claim,
					islem_tarihi : attributes.open_date,
					from_cmp_id : attributes.comp_id,
					from_consumer_id : attributes.cons_id,
					acc_type_id : attributes.acc_type_id,
					from_employee_id : attributes.emp_id,
					subscription_id : iif((isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)),attributes.subscription_id,de('')),
					islem_detay : iif(len(attributes.detail),de('#attributes.detail#'),de('AÇILIŞ FİŞİ')),
					action_detail : attributes.detail,
					action_value2 :attributes.action_value_2,
					action_currency_2 : session.ep.money2,
					due_date : attributes.due_date,
					account_card_type : 10,
					project_id : iif((isdefined("attributes.project_id") and len(attributes.project_name)),'attributes.project_id',de('')),
					assetp_id : iif((isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)),'attributes.asset_id',de('')),
					from_branch_id : to_branch_id
				);
			}
		</cfscript>
        <cfquery name="getMaxId" datasource="#dsn2#">
        	SELECT MAX(CARI_ACTION_ID) MAX_ID FROM CARI_ROWS WHERE ACTION_TYPE_ID = 40
        </cfquery>
        <cf_workcube_process_cat 
            process_cat="#form.process_cat#"
            action_id = #getMaxId.MAX_ID#
            is_action_file = 1
            action_file_name='#get_process_type.action_file_name#'
            action_page='#request.self#?fuseaction=ch.form_upd_account_open&event=upd&cari_act_id=#getMaxId.MAX_ID#&comp_id=#attributes.comp_id#&cons_id=#attributes.cons_id#&emp_id=#attributes.emp_id#'
            action_db_type = '#dsn2#'
            is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isdefined("attributes.modal_id") and len(attributes.modal_id)>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>