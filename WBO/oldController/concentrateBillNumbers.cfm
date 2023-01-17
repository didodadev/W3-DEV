<cf_get_lang_set module_name="account">
<!--- edefter kullanılıyor ise yevmiye no silsile halinde gider bu yüzden bir önceki defterin yevmiye nosundan başlamalıdır FA--->
<cfif session.ep.our_company_info.is_edefter eq 1>
	<cfquery name="getNetbooksRowNumber" datasource="#dsn2#">
        SELECT TOP 1 BILL_FINISH_NUMBER,FINISH_DATE FROM NETBOOKS WHERE STATUS = 1 ORDER BY FINISH_DATE DESC
    </cfquery>	
</cfif>
<cfquery name="get_acc_card_type" datasource="#dsn3#">
    SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
</cfquery>
<script type="text/javascript">
	function kontrol()
	{
		d1 = document.getElementById('yev_start_date').value;
		start_date = d1.substring(6,10)+d1.substring(3,5)+d1.substring(0,2);
		
		d2 = document.getElementById('yev_finish_date').value;
		finish_date = d2.substring(6,10)+d2.substring(3,5)+d2.substring(0,2);
		
		if(start_date>finish_date)
		{
			alert("<cf_get_lang dictionary_id='58862.Başlangıç tarihi bitiş tarihinden büyük olamaz'>!");
			return false;
		}
		<cfif session.ep.our_company_info.is_edefter eq 1 and getNetbooksRowNumber.recordcount>
			if(start_date<=<cfoutput>#dateformat(getNetbooksRowNumber.finish_date,'yyyymmdd')#</cfoutput>)
			{
				alert("<cf_get_lang dictionary_id='58053.Başlangıç tarihi'>"<cfoutput>#dateformat(getNetbooksRowNumber.finish_date,'dd/mm/yyyy')#</cfoutput>"<cf_get_lang dictionary_id='54498.tarihli e-defter bitiş tarihinden küçük ve eşit olamaz'>");
				return false;
			}
			return true;
		</cfif>
		return true;
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'addUpd';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['addUpd'] = structNew();
	WOStruct['#attributes.fuseaction#']['addUpd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addUpd']['fuseaction'] = 'account.form_concentrate_bill_no';
	WOStruct['#attributes.fuseaction#']['addUpd']['filePath'] = 'account/form/concentrate_bill_no.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['queryPath'] = 'account/query/concentrate_bill_numbers.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['nextEvent'] = 'account.list_account_plan';
	
</cfscript>
