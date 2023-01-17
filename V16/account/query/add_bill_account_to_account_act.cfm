<cf_date tarih='attributes.ACTION_DATE'>
<cfset attributes.acc_code = attributes.to_account_id>
<cfinclude template="get_account_plan.cfm">
<cfset attributes.acc_code = attributes.from_account_id>
<cfinclude template="get_account_plan.cfm">
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="GET_ACC_CARD_ID" datasource="#DSN2#">
		SELECT MAX(CARD_ID) AS CARD_ID FROM ACCOUNT_CARD
	</cfquery>
		<cfscript>
			if(isdefined("attributes.acc_branch_id") and len(attributes.acc_branch_id))
				to_branch_id = attributes.acc_branch_id; 
			else if(len(listgetat(session.ep.user_location,2,'-')) )
				to_branch_id =listgetat(session.ep.user_location,2,'-'); 
			else
				to_branch_id = '';
					
			if(isdefined('attributes.acc_department_id') and len(attributes.acc_department_id) and isdefined('attributes.acc_department_name') and len(attributes.acc_department_name) )
				acc_department_id = attributes.acc_department_id;
			else
				acc_department_id = '';
			
			//borclu yada alacakli doviz tutar girilmisse 
			if(isdefined("attributes.BILL_DETAIL") and len(attributes.BILL_DETAIL))
				detail_info = attributes.BILL_DETAIL;
			else
				detail_info = UCase(getLang('main',2743));//VİRMAN (MUHASEBE) İŞLEMİ
			if((isDefined("attributes.to_account_value") and len(attributes.to_account_value)) or (isDefined("attributes.from_account_value") and len(attributes.from_account_value)))
				muhasebeci (
					action_id : (GET_ACC_CARD_ID.CARD_ID+1),
					workcube_process_type : 17,			
					account_card_type : 13,
					islem_tarihi : attributes.ACTION_DATE,
					borc_hesaplar : TO_ACCOUNT_ID,
					borc_tutarlar : ACTION_VALUE,
					alacak_hesaplar : FROM_ACCOUNT_ID,
					alacak_tutarlar : ACTION_VALUE,
					other_amount_borc : attributes.to_account_value,
					other_currency_borc : '#attributes.to_money_type#',
					other_amount_alacak : attributes.from_account_value,
					other_currency_alacak : '#attributes.from_money_type#',
					to_branch_id : to_branch_id,
					acc_department_id : acc_department_id,
					fis_satir_detay : detail_info,
					fis_detay : detail_info
					);
			else
				muhasebeci (
					action_id : (GET_ACC_CARD_ID.CARD_ID+1),
					workcube_process_type : 17,			
					account_card_type : 13,
					islem_tarihi : attributes.ACTION_DATE,
					borc_hesaplar : TO_ACCOUNT_ID,
					borc_tutarlar : ACTION_VALUE,
					alacak_hesaplar : FROM_ACCOUNT_ID,
					alacak_tutarlar : ACTION_VALUE,
					other_amount_borc : ACTION_VALUE,
					other_currency_borc : '#session.ep.money#',
					other_amount_alacak : ACTION_VALUE,
					other_currency_alacak : '#session.ep.money#',
					to_branch_id : to_branch_id,
					acc_department_id : acc_department_id,
					fis_satir_detay : detail_info,
					fis_detay : detail_info
					);		
		</cfscript>
        <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#(GET_ACC_CARD_ID.CARD_ID+1)#" action_name= "muhasebe_virman_ekleme" period_id="#session.ep.period_id#" process_type="17" data_source="#dsn2#">
	</cftransaction> 
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=account.list_cards</cfoutput>";
</script>
