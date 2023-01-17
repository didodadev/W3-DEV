<cf_date tarih="attributes.return_date">
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="get_control" datasource="#dsn2#">
			SELECT
				RETURN_RECORD_EMP,
				GIVEN_ACC_CODE,
				TAKEN_ACC_CODE,
				ACTION_VALUE,
				ACTION_VALUE2,
				MONEY_CAT,
				RETURN_PROCESS_CAT,
				PROJECT_ID,
				REALESTATE_DETAIL,
				GIVE_TAKE,
				COMPANY_ID,
				CONSUMER_ID,
                PAPER_NO,
				RETURN_DETAIL,
				SECUREFUND_TOTAL
			FROM
				#dsn_alias#.COMPANY_SECUREFUND
			WHERE
				SECUREFUND_ID = #attributes.securefund_id#	
		</cfquery>
		<cfquery name="get_process_type" datasource="#dsn2#">
			SELECT 
				PROCESS_TYPE,
				IS_ACCOUNT,
				IS_CARI,
				IS_ACCOUNT_GROUP
			 FROM 
				#dsn3_alias#.SETUP_PROCESS_CAT 
			WHERE 
				<cfif isdefined("form.process_cat")>
					PROCESS_CAT_ID = #form.process_cat#
				<cfelse>
					PROCESS_CAT_ID = #get_control.return_process_cat#
				</cfif>
		</cfquery>
		<cfscript>
			process_type = get_process_type.PROCESS_TYPE;
			is_account = get_process_type.IS_ACCOUNT;
			is_cari = get_process_type.IS_CARI;
			is_account_group = get_process_type.IS_ACCOUNT_GROUP;
			if(not isdefined("form.old_process_type"))
				form.old_process_type = process_type;
		</cfscript>
		<cfif is_account and attributes.return_period_id neq session.ep.period_id>
			<script type="text/javascript">
				alert("<cf_get_lang no ='572.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
				window.close();
				wrk_opener_reload();
			</script>
			<cfabort>
		</cfif>
		<cfif isdefined("attributes.is_delete")>
			<cfquery name="upd_securefund_to_cancel" datasource="#dsn2#">
				UPDATE 
					#dsn_alias#.COMPANY_SECUREFUND		
				SET
					RETURN_DATE	= NULL,
					IS_RETURN = NULL,
					RETURN_PROCESS_CAT = NULL,
					RETURN_GIVEN_ACC_CODE = NULL,
					RETURN_TAKEN_ACC_CODE = NULL,
					RETURN_UPDATE_DATE = NULL,
					RETURN_UPDATE_IP = NULL,
					RETURN_UPDATE_EMP = NULL,
					RETURN_PERIOD_ID = NULL,
					RETURN_RECORD_DATE = NULL,
					RETURN_RECORD_IP = NULL,
					RETURN_RECORD_EMP = NULL,
					RETURN_DETAIL = NULL
				WHERE
					SECUREFUND_ID = #attributes.securefund_id#
			</cfquery>
			<cfscript>
				muhasebe_sil (action_id:attributes.securefund_id,process_type:form.old_process_type);
				cari_sil (action_id:attributes.securefund_id,process_type:form.old_process_type);
			</cfscript>
		<cfelse>	
			<cfquery name="upd_securefund_to_cancel" datasource="#dsn2#">
				UPDATE 
					#dsn_alias#.COMPANY_SECUREFUND		
				SET
					RETURN_DATE	= #attributes.return_date#,
					IS_RETURN = 1,
					RETURN_PROCESS_CAT = #form.process_cat#,
					RETURN_GIVEN_ACC_CODE = <cfif len(attributes.given_acc_id) and len(attributes.given_acc_name)>'#attributes.given_acc_id#',<cfelse>NULL,</cfif>
					RETURN_TAKEN_ACC_CODE = <cfif len(attributes.taken_acc_id) and len(attributes.taken_acc_name)>'#attributes.taken_acc_id#',<cfelse>NULL,</cfif>
					RETURN_DETAIL = <cfif len(attributes.return_detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.return_detail#"><cfelse>NULL</cfif>,
					<cfif len(get_control.return_record_emp)>
						RETURN_UPDATE_DATE = #now()#,
						RETURN_UPDATE_IP = '#cgi.remote_addr#',
						RETURN_UPDATE_EMP = #session.ep.userid#	
					<cfelse> 
						RETURN_PERIOD_ID = #attributes.return_period_id#,
						RETURN_RECORD_DATE = #now()#,
						RETURN_RECORD_IP = '#cgi.remote_addr#',
						RETURN_RECORD_EMP = #session.ep.userid#	
					</cfif>
				WHERE
					SECUREFUND_ID = #attributes.securefund_id#
			</cfquery>
			<cfscript>
				if(is_cari and get_control.give_take eq 0)
				{
					carici(
						action_id : attributes.securefund_id,
						action_table : 'COMPANY_SECUREFUND',
						workcube_process_type : process_type,
						workcube_old_process_type: form.old_process_type,		
						process_cat : attributes.process_cat,
						islem_tarihi : attributes.return_date,
						account_card_type: 13,
						action_detail : get_control.REALESTATE_DETAIL,
						islem_detay : 'TEMİNAT İADE İŞLEMİ',
						project_id : get_control.project_id,
						from_cmp_id : get_control.company_id,
						from_consumer_id : get_control.consumer_id,
						islem_tutari : get_control.action_value,
						action_currency : session.ep.money,
						other_money_value : iif(len(get_control.securefund_total),'get_control.securefund_total',de('')),
						other_money : get_control.money_cat,
						islem_belge_no : get_control.paper_no
					);
				}
				else if(is_cari and get_control.give_take eq 1)
				{
					carici(
						action_id : attributes.securefund_id,
						action_table : 'COMPANY_SECUREFUND',
						workcube_process_type : process_type,
						workcube_old_process_type: form.old_process_type,		
						process_cat : attributes.process_cat,
						islem_tarihi : attributes.return_date,
						account_card_type: 13,
						action_detail : get_control.REALESTATE_DETAIL,
						islem_detay : 'TEMİNAT İADE İŞLEMİ',
						project_id : get_control.project_id,
						to_cmp_id : get_control.company_id,
						to_consumer_id : get_control.consumer_id,
						islem_tutari : get_control.action_value,
						action_currency : session.ep.money,
						other_money_value : iif(len(get_control.securefund_total),'get_control.securefund_total',de('')),
						other_money : get_control.money_cat,
						islem_belge_no : get_control.paper_no
					);
				}
				else
					cari_sil(action_id:attributes.SECUREFUND_ID,process_type:form.old_process_type);
						
				if(is_account and len(attributes.given_acc_id) and len(attributes.given_acc_name) and len(attributes.taken_acc_id) and len(attributes.taken_acc_name))
				{
					if(len(get_control.REALESTATE_DETAIL))
						str_detail = '#get_control.REALESTATE_DETAIL# - TEMİNAT İADE İŞLEMİ';
					else
						str_detail = 'TEMİNAT İADE İŞLEMİ';
						
					muhasebeci (
						action_id: attributes.securefund_id,
						belge_no : get_control.paper_no,
						workcube_process_type: process_type,
						workcube_old_process_type: form.old_process_type,
						workcube_process_cat:attributes.process_cat,
						account_card_type: 13,
						islem_tarihi: attributes.return_date,
						fis_satir_detay: str_detail,
						borc_hesaplar: attributes.given_acc_id,
						borc_tutarlar: get_control.action_value,
						other_amount_borc : iif(len(get_control.action_value2),'get_control.action_value2',de('')),
						other_currency_borc : get_control.money_cat,
						alacak_hesaplar: attributes.taken_acc_id,
						alacak_tutarlar: get_control.action_value,
						acc_project_id : get_control.project_id,
						other_amount_alacak : iif(len(get_control.action_value2),'get_control.action_value2',de('')),
						other_currency_alacak : get_control.money_cat,
						fis_detay : 'TEMİNAT İADE İŞLEMİ',
						to_branch_id : listgetat(session.ep.user_location,2,'-'),
						company_id: get_control.company_id,
						consumer_id: get_control.consumer_id
					);
				}
				else
					muhasebe_sil(action_id:attributes.securefund_id,process_type:form.old_process_type);
			</cfscript>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfoutput>
        window.location.href = '#request.self#?fuseaction=finance.list_securefund&event=upd&securefund_id=#attributes.securefund_id#';
    </cfoutput>
	
</script>
