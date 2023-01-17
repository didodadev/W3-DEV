<cf_get_lang_set module_name="finance">
<cfsavecontent variable="head_">
	<font color="##FF0000" style=" padding: 3px; line-height: 50px; font-size:16px"><cf_get_lang no='230.Dikkat Toplu Çek Girişi Workcubeu kullanacak şirketlerin sadece başlangıçta çeklerini sisteme girmeleri için kullanılır'></font>
</cfsavecontent>
<cfinclude template="../finance/query/get_money.cfm">
<cfinclude template="../finance/query/get_cashes.cfm">
<cfif isdefined("attributes.event") and attributes.event is "addBankExp">
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
			if(document.getElementById('VOUCHER_NO'+i).value != "")
			{
				if(document.getElementById('VOUCHER_VALUE'+i).value == "")
				{
					alert(i + ".Satır için Lütfen Tutar Giriniz !");
					return false;
				}
				if(document.getElementById('VOUCHER_DUEDATE'+i).value == "")
				{
					alert(i + ".Satır için Lütfen Tarih Seçiniz !");
					return false;
				}	
				if(document.getElementById('VOUCHER_VALUE'+i).value != "" && ( document.getElementById('company_name'+i).value == "" || ( document.getElementById('company_name'+i).value != "" && document.getElementById('company_id'+i).value == "" && document.getElementById('consumer_id'+i).value == "" )) )
				{
					alert(i + ".Satır için Lütfen Cari Hesap Seçiniz!");
					return false;
				}
				<cfif isDefined("attributes.is_ciro_voucher")>
					if(document.getElementById('VOUCHER_VALUE'+i).value != "" && ( document.getElementById('owner_company_name'+i).value == "" || ( document.getElementById('owner_company_name'+i).value != "" && document.getElementById('owner_company_id'+i).value == "" && document.getElementById('owner_consumer_id'+i).value == "" )) )
					{
						alert(i + ".Satır için Lütfen Senet Sahibi Seçiniz!");
						return false;
					}
				</cfif>
			}
			else
			{
				if(document.getElementById('VOUCHER_VALUE'+i).value != "" || document.getElementById('VOUCHER_DUEDATE'+i).value != "" || document.getElementById('company_name'+i).value != "")
				{
					alert(i + ".Satır için Lütfen Senet No Giriniz !");
					return false;
				}
			}
			if (document.getElementById('VOUCHER_VALUE'+i).value != "" && list_getat(document.getElementById('hesap'+i).value,2,';') != list_getat(document.getElementById('CURRENCY_ID'+i).value,1,';'))
			{
				<cfif isdefined("attributes.event") and (attributes.event is "addCashExp" or attributes.event is "addPaymExp")>
					alert(i + '. Satırda Kasa ile Senetin Para Birimi Farklı');
				<cfelseif isdefined("attributes.event") and attributes.event is "addBankExp">
					alert(i + '. Satırda Banka ile Senetin Para Birimi Farklı');
				</cfif>	
				return false;
			} 
			
			if(document.getElementById('VOUCHER_VALUE'+i).value != "" && document.getElementById('SYSTEM_VOUCHER_VALUE'+i).value == "")
			{
				alert(i + ". Satırda <cf_get_lang no ='518.Sistem Para Birimi Tutarları Eksik'>!");
				return false;
			}
			if(document.getElementById('company_name'+i).value == "" )
				document.getElementById('company_id'+i).value == "";
		}
		unformat_fields();
		return true;	
	}
	function unformat_fields()
	{
		for(var i=1; i<=15; i++)
		{
			document.getElementById('VOUCHER_VALUE'+i).value=filterNum(document.getElementById('VOUCHER_VALUE'+i ).value);
			document.getElementById('SYSTEM_VOUCHER_VALUE'+i).value=filterNum(document.getElementById('SYSTEM_VOUCHER_VALUE'+i ).value);
			document.getElementById('VOUCHER_OTHER_MONEY_VALUE'+i).value=filterNum(document.getElementById('VOUCHER_OTHER_MONEY_VALUE'+i ).value);
		}
		return true;
	}
	function hesapla(i)
	{
		if(document.getElementById('VOUCHER_VALUE'+i).value != '')
		{
			var temp_cheque_value = filterNum(document.getElementById('VOUCHER_VALUE'+i).value);
			var money_type=document.getElementById('CURRENCY_ID'+i)[document.getElementById('CURRENCY_ID'+i).options.selectedIndex].value;
			money_rate = (list_getat(money_type,2,';')/list_getat(money_type,3,';'));
			
			document.getElementById('SYSTEM_VOUCHER_VALUE'+i).value = commaSplit(parseFloat(temp_cheque_value)*parseFloat(money_rate));
			document.getElementById('VOUCHER_VALUE'+i).value = commaSplit(temp_cheque_value);
			document.getElementById('VOUCHER_OTHER_MONEY_VALUE'+i).value = commaSplit(filterNum(document.getElementById('SYSTEM_VOUCHER_VALUE'+i).value)/document.add_voucher_entry.money_rate2.value);
		}
		else
			document.getElementById('SYSTEM_VOUCHER_VALUE'+i).value =0;
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
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'finance.form_add_voucher_exp';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'finance/display/add_voucher_exp.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'finance/display/add_voucher_exp.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'finance.form_add_voucher_exp';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '';
	
	WOStruct['#attributes.fuseaction#']['addCashExp'] = structNew();
	WOStruct['#attributes.fuseaction#']['addCashExp']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addCashExp']['fuseaction'] = 'finance.form_add_voucher_cash_exp';
	WOStruct['#attributes.fuseaction#']['addCashExp']['filePath'] = 'finance/form/add_voucher_cash_exp.cfm';
	WOStruct['#attributes.fuseaction#']['addCashExp']['queryPath'] = 'finance/query/add_voucher_cash_exp.cfm';
	WOStruct['#attributes.fuseaction#']['addCashExp']['nextEvent'] = 'finance.form_add_voucher_exp';
	if(isDefined("attributes.is_ciro_voucher"))
		WOStruct['#attributes.fuseaction#']['addCashExp']['Identity'] = '#lang_array.item[53]#';
	else
		WOStruct['#attributes.fuseaction#']['addCashExp']['Identity'] = '#lang_array.item[58]#';
		
	WOStruct['#attributes.fuseaction#']['addBankExp'] = structNew();
	WOStruct['#attributes.fuseaction#']['addBankExp']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addBankExp']['fuseaction'] = 'finance.form_add_voucher_bank_exp';
	WOStruct['#attributes.fuseaction#']['addBankExp']['filePath'] = 'finance/form/add_voucher_bank_exp.cfm';
	WOStruct['#attributes.fuseaction#']['addBankExp']['queryPath'] = 'finance/query/add_voucher_bank_exp.cfm';
	WOStruct['#attributes.fuseaction#']['addBankExp']['nextEvent'] = 'finance.form_add_voucher_exp';
	WOStruct['#attributes.fuseaction#']['addBankExp']['Identity'] = '#lang_array.item[512]#';
	
	WOStruct['#attributes.fuseaction#']['addPaymExp'] = structNew();
	WOStruct['#attributes.fuseaction#']['addPaymExp']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addPaymExp']['fuseaction'] = 'finance.form_add_voucher_payment_exp';
	WOStruct['#attributes.fuseaction#']['addPaymExp']['filePath'] = 'finance/form/add_voucher_payment_exp.cfm';
	WOStruct['#attributes.fuseaction#']['addPaymExp']['queryPath'] = 'finance/query/add_voucher_payment_exp.cfm';
	WOStruct['#attributes.fuseaction#']['addPaymExp']['nextEvent'] = 'finance.form_add_voucher_exp';
	WOStruct['#attributes.fuseaction#']['addPaymExp']['Identity'] = '#lang_array.item[126]#';

</cfscript>
