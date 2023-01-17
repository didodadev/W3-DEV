<cfif not len(attributes.rowCount)>
	<script type="text/javascript">
		alert("<cf_get_lang no='77.Cari Açılış Fişine Kayıt Seçmediniz'> !");
		window.location.href = '<cfoutput>#request.self#?fuseaction=ch.form_add_account_open&var_=ch_opening_card</cfoutput>';
	</script>
	<cfexit method="exittemplate">
</cfif>

<cfset open_date="01/01/#SESSION.EP.PERIOD_YEAR#">
<cf_date tarih='open_date'>

<cflock name="#createUUID()#" timeout="60">
	<cftransaction>

		<cfscript>
			cari_sil(action_id:-1,process_type:40);
		</cfscript>
			
		<cfloop from="1" to="#attributes.rowCount#" index="i">
			<!---hesap kodunun girilmesi zorunlu + alacak veya borc 0 olmamalı erk 20040107--->
			<cfscript>
				if (isdefined("attributes.COMP_ID_#i#") and len(evaluate("attributes.COMP_ID_#i#")) and (isnumeric(evaluate("attributes.debt_#i#")) or isnumeric(evaluate("attributes.claim_#i#"))) )
				{
					if( isnumeric(evaluate("attributes.debt_#i#")) and evaluate("attributes.debt_#i#") gt 0 )
					{
						carici
						(
							action_id : -1,
							action_table : 'CARI_ROWS',
							process_cat : 0,
							workcube_process_type : 40,	
							other_money : evaluate("attributes.other_money_type_#i#"),
							other_money_value : evaluate("attributes.other_money_value_#i#"),
							islem_tutari : evaluate("attributes.debt_#i#"),
							islem_tarihi : "#open_date#",
							to_cmp_id : evaluate("attributes.comp_id_#i#"),
							to_branch_id : ListGetAt(session.ep.user_location,2,"-"),
							islem_detay : evaluate("attributes.detail_#i#"),
							action_detail : evaluate("attributes.detail_#i#"),
							account_card_type : 10
						);
					}
				 	else if( isnumeric(evaluate("attributes.claim_#i#")) and evaluate("attributes.claim_#i#") gt 0 )
					{
						carici
						(
							action_id : -1,
							action_table : 'CARI_ROWS',
							process_cat : 0,
							workcube_process_type : 40,	
							other_money : evaluate("attributes.other_money_type_#i#"),
							other_money_value : evaluate("attributes.other_money_value_#i#"),
							islem_tutari : evaluate("attributes.claim_#i#"),
							islem_tarihi : "#open_date#",
							from_cmp_id : evaluate("attributes.comp_id_#i#"),
							from_branch_id : ListGetAt(session.ep.user_location,2,"-"),
							islem_detay : evaluate("attributes.detail_#i#"),
							action_detail : evaluate("attributes.detail_#i#"),
							account_card_type : 10
						);
					}
				}
			</cfscript>
		</cfloop>
	</cftransaction>
</cflock>
<!--- account card_row_add --->
<cflocation url="#request.self#?fuseaction=ch.list_caris" addtoken="no"> 
