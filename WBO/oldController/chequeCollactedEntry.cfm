<cf_get_lang_set module_name="finance">
<cfsavecontent variable="head_">
	<font color="##FF0000" style=" padding: 3px; line-height: 50px; font-size:16px"><cf_get_lang no='231.Dikkat Toplu Çek Girişi Workcubeu kullanacak şirketlerin sadece başlangıçta çeklerini sisteme girmeleri için kullanılır'>.</font>
</cfsavecontent>
<cfinclude template="../finance/query/get_money.cfm">
<cfif isdefined("attributes.event") and attributes.event is "addCashExp">
    <cfinclude template="../finance/query/get_cashes.cfm">
<cfelseif isdefined("attributes.event") and (attributes.event is "addBankExp" or attributes.event is "addPaymExp")>
    <cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
        SELECT
            ACCOUNTS.ACCOUNT_NAME,
            ACCOUNTS.ACCOUNT_ID,
            ACCOUNTS.ACCOUNT_CURRENCY_ID,
            BANK_BRANCH.BANK_BRANCH_NAME
        FROM
            ACCOUNTS,	
            BANK_BRANCH
        WHERE
            ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID
        ORDER BY
            ACCOUNTS.ACCOUNT_NAME
    </cfquery>
</cfif>
<script type="text/javascript">
	function check()
	{
		for(var i=1; i<=15; i++)
		{
			if(eval('add_cheque_entry.CHEQUE_NO'+i).value != "")
			{
				if(eval('add_cheque_entry.CHEQUE_DUEDATE'+i).value == "")
				{
					alert(i + ".Satır için Lütfen Tarih Seçiniz !");
					return false;
				}	
				if(eval('add_cheque_entry.CHEQUE_VALUE'+i).value != "" && ( eval('add_cheque_entry.company_name'+i).value == "" || ( eval('add_cheque_entry.company_name'+i).value != "" && eval('add_cheque_entry.company_id'+i).value == "" && eval('add_cheque_entry.consumer_id'+i).value == "" )) )
				{
					alert(i + "<cf_get_lang dictionary_id='54489.Satır için Lütfen Cari Hesap Seçiniz'>!");
					return false;
				}
				if(eval('add_cheque_entry.CHEQUE_VALUE'+i).value == "")
				{
					alert(i + "<cf_get_lang dictionary_id='54493.Satır için Lütfen Tutar Giriniz'>!");
					return false;
				}
			}
			<cfif isdefined("attributes.event") and attributes.event is "addCashExp">
				if (eval('add_cheque_entry.CHEQUE_VALUE'+i).value != "" && list_getat(eval('add_cheque_entry.hesap'+i).value,2,';') != list_getat(eval('add_cheque_entry.CURRENCY_ID'+i).value,1,';'))
				{
					alert("<cf_get_lang dictionary_id='50481.Kasa ile Çekin Para Birimi Farklı'>!");
					return false;
				}
			<cfelseif isdefined("attributes.event") and (attributes.event is "addBankExp" or attributes.event is "addPaymExp")>
				if(eval('add_cheque_entry.CHEQUE_NO'+i).value != "" && eval('add_cheque_entry.CHEQUE_VALUE'+i).value != "" && list_getat(eval('add_cheque_entry.hesap'+i).value,2,';') != list_getat(eval('add_cheque_entry.CURRENCY_ID'+i).value,1,';'))
				{
					alert("<cf_get_lang dictionary_id='50482.Banka ile Çekin Para Birimi Farklı'>!");
					return false;
				} 
			</cfif> 
			if(eval('add_cheque_entry.CHEQUE_VALUE'+i).value != "" && eval('add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value == "")
			{
				alert("<cf_get_lang dictionary_id='54904.Sistem Para Birimi Tutarları Eksik'>!");
				return false;
			}
			
		}
		unformat_fields();
		return true;
	}
	function unformat_fields()
	{
		for(var i=1; i<=15; i++)
		{
			eval('document.add_cheque_entry.CHEQUE_VALUE'+i).value=filterNum(eval('document.add_cheque_entry.CHEQUE_VALUE'+i ).value);
			eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value=filterNum(eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i ).value);
			eval('document.add_cheque_entry.CHEQUE_OTHER_MONEY_VALUE'+i).value=filterNum(eval('document.add_cheque_entry.CHEQUE_OTHER_MONEY_VALUE'+i ).value);
		}
		return true;
	}
	function hesapla(i)
	{
		if(eval('document.add_cheque_entry.CHEQUE_VALUE'+i).value != '')
		{
			var temp_cheque_value = filterNum(eval('document.add_cheque_entry.CHEQUE_VALUE'+i).value);
			var money_type=eval('document.add_cheque_entry.CURRENCY_ID'+i)[eval('document.add_cheque_entry.CURRENCY_ID'+i).options.selectedIndex].value;
			money_rate = (list_getat(money_type,2,';')/list_getat(money_type,3,';'));
			eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value = commaSplit(parseFloat(temp_cheque_value)*parseFloat(money_rate));
			eval('document.add_cheque_entry.CHEQUE_VALUE'+i).value = commaSplit(temp_cheque_value);
			eval('document.add_cheque_entry.CHEQUE_OTHER_MONEY_VALUE'+i).value = commaSplit(filterNum(eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value)/document.add_cheque_entry.money_rate2.value);
		}
		else
			eval('document.add_cheque_entry.SYSTEM_CHEQUE_VALUE'+i).value =0;
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'det';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'finance.form_add_cheque_exp';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'finance/display/add_cheque_exp.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'finance/display/add_cheque_exp.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'finance.form_add_cheque_exp';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '';
	
	WOStruct['#attributes.fuseaction#']['addCashExp'] = structNew();
	WOStruct['#attributes.fuseaction#']['addCashExp']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addCashExp']['fuseaction'] = 'finance.form_add_cheque_cash_exp';
	WOStruct['#attributes.fuseaction#']['addCashExp']['filePath'] = 'finance/form/add_cheque_cash_exp.cfm';
	WOStruct['#attributes.fuseaction#']['addCashExp']['queryPath'] = 'finance/query/add_cheque_cash_exp.cfm';
	WOStruct['#attributes.fuseaction#']['addCashExp']['nextEvent'] = 'finance.form_add_cheque_exp';
	if(isDefined("attributes.is_ciro_cheque"))
		WOStruct['#attributes.fuseaction#']['addCashExp']['Identity'] = '#lang_array.item[90]#';
	else
		WOStruct['#attributes.fuseaction#']['addCashExp']['Identity'] = '#lang_array.item[232]#';
		
	WOStruct['#attributes.fuseaction#']['addBankExp'] = structNew();
	WOStruct['#attributes.fuseaction#']['addBankExp']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addBankExp']['fuseaction'] = 'finance.form_add_cheque_bank_exp';
	WOStruct['#attributes.fuseaction#']['addBankExp']['filePath'] = 'finance/form/add_cheque_bank_exp.cfm';
	WOStruct['#attributes.fuseaction#']['addBankExp']['queryPath'] = 'finance/query/add_cheque_bank_exp.cfm';
	WOStruct['#attributes.fuseaction#']['addBankExp']['nextEvent'] = 'finance.form_add_cheque_exp';
	WOStruct['#attributes.fuseaction#']['addBankExp']['Identity'] = '#lang_array.item[287]#';
	
	WOStruct['#attributes.fuseaction#']['addPaymExp'] = structNew();
	WOStruct['#attributes.fuseaction#']['addPaymExp']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addPaymExp']['fuseaction'] = 'finance.form_add_cheque_payment_exp';
	WOStruct['#attributes.fuseaction#']['addPaymExp']['filePath'] = 'finance/form/add_cheque_payment_exp.cfm';
	WOStruct['#attributes.fuseaction#']['addPaymExp']['queryPath'] = 'finance/query/add_cheque_payment_exp.cfm';
	WOStruct['#attributes.fuseaction#']['addPaymExp']['nextEvent'] = 'finance.form_add_cheque_exp';
	WOStruct['#attributes.fuseaction#']['addPaymExp']['Identity'] = '#lang_array.item[226]#';

</cfscript>
