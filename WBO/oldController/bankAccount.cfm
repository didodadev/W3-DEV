<cf_get_lang_set module_name="bank">
<cfif not isdefined("attributes.event")>
	<cfset attributes.event = "list">
</cfif>
<cfinclude template="../bank/query/get_money_rate.cfm">
<cfquery name="GET_BANK_NAMES" datasource="#DSN#">
	SELECT BANK_ID, BANK_CODE, BANK_NAME FROM SETUP_BANK_TYPES SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cfset branchInfo = ''>
<cfset accountAccCode = ''>
<cfset accountAccCodeName = ''>
<cfset accountOrderCode = ''>
<cfset accountOrderCodeName = ''>
<cfset vChequeAccCode = ''>
<cfset vChequeAccCodeName = ''>
<cfset exchangeCode = ''>
<cfset exchangeCodeName = ''>
<cfset vExchangeCode = ''>
<cfset vExchangeCodeName = ''>
<cfset guarantyCode = ''>
<cfset guarantyCodeName = ''>
<cfset vGuarantyCode = ''>
<cfset vGuarantyCodeName = ''>
<cfset bouncedChequeCode = ''>
<cfset bouncedChequeCodeName = ''>
<cfset protestedVoucherCode = ''>
<cfset protestedVoucherCodeName = ''>
<cfset ibanCode = ''>
<cfset accountName = ''>
<cfset bankId = ''>
<cfset bankCode = ''>
<cfset branchCode = ''>
<cfset accountNo = ''>
<cfset creditLimit = ''>
<cfset actionDetail = ''>
<cfif not isDefined('attributes.event') or attributes.event is 'list'>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.account_currency_id" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.acc_type" default="">
    <cfparam name="attributes.date1" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined("attributes.date1") and len(attributes.date1)>
        <cf_date tarih="attributes.date1">
    </cfif>
    <cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../bank/query/get_account_list.cfm">
    <cfelse>
        <cfset get_account_list.recordcount=0>
    </cfif>
    <cfparam name="attributes.totalrecords" default="#get_account_list.recordcount#">
    <cfif fuseaction contains "popup">
        <cfset is_popup=1>
    <cfelse>
        <cfset is_popup=0>
    </cfif>
<cfelse>
	<cf_xml_page_edit fuseact="bank.form_add_bank_account">
	<cfif attributes.event is 'upd'>
        <cfinclude template="../bank/query/get_acc_detail.cfm">
        <cfquery name="GET_PERIODS" datasource="#DSN#">
            SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
        <cfquery name="CONTROL" datasource="#DSN2#" maxrows="1">
            <cfloop query="get_periods">
                <cfset new_dsn_2 = "#dsn#_#period_year#_#session.ep.company_id#">
                SELECT ACTION_ID FROM #new_dsn_2#.BANK_ACTIONS WHERE ACTION_FROM_ACCOUNT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">  OR ACTION_TO_ACCOUNT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> 
                <cfif currentrow neq get_periods.recordcount>UNION ALL</cfif>
            </cfloop>
        </cfquery>
        <!--- Banka Talimatlari icin eklendi. --->
        <cfquery name="CONTROL2" datasource="#DSN2#" maxrows="1">
            <cfloop query="get_periods">
                <cfset new_dsn_2 = "#dsn#_#period_year#_#session.ep.company_id#">
                SELECT ACCOUNT_ID FROM #new_dsn_2#.BANK_ORDERS WHERE ACCOUNT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
                <cfif currentrow neq get_periods.recordcount>UNION ALL</cfif>
            </cfloop>
        </cfquery>
        <!--- kredi kartı tahsilatları için(gerçi hesaba geçiş işlemi yapılmış bir kayıtsa üst query e girer ama henuz hesaba geçiş yapılmamış kayıtsa hesap silinmemeli) AE20060622--->
        <cfquery name="CONTROL3" datasource="#DSN3#" maxrows="1">
            SELECT ACTION_TO_ACCOUNT_ID FROM CREDIT_CARD_BANK_PAYMENTS WHERE ACTION_TO_ACCOUNT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> 
        </cfquery>
        <cfif not get_acc_detail.recordcount>
            <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
        </cfif>
        <cfquery name="GET_BRANCH_NAMES" datasource="#DSN3#">
            SELECT BANK_ID, BANK_BRANCH_ID, BANK_BRANCH_NAME, BRANCH_CODE FROM BANK_BRANCH WHERE BANK_ID IN (SELECT BANK_ID FROM BANK_BRANCH WHERE BANK_BRANCH_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_acc_detail.account_branch_id#">) ORDER BY BANK_BRANCH_NAME
        </cfquery>
        <cfquery name="GET_ACC_BRANCHS" datasource="#DSN3#">
            SELECT BRANCH_ID FROM ACCOUNTS_BRANCH WHERE ACCOUNT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfquery>
        <cfquery name="GET_ACC_1" datasource="#DSN2#">
            SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.account_acc_code#">
        </cfquery>
        <cfquery name="GET_ACC_2" datasource="#DSN2#">
            SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.account_order_code#">
        </cfquery>
        <cfquery name="GET_ACC_3" datasource="#DSN2#">
            SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.v_cheque_acc_code#">
        </cfquery>
        <cfquery name="GET_ACC_4" datasource="#DSN2#">
            SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.cheque_exchange_code#">
        </cfquery>
        <cfif len(get_acc_detail.voucher_exchange_code)>
            <cfquery name="GET_ACC_5" datasource="#DSN2#">
                SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.voucher_exchange_code#">
            </cfquery>
			<cfset vExchangeCode = get_acc_detail.voucher_exchange_code>
            <cfset vExchangeCodeName = get_acc_detail.voucher_exchange_code & ' - ' & get_acc_5.account_name>
        </cfif>
        <cfif len(get_acc_detail.cheque_guaranty_code)>
            <cfquery name="GET_ACC_6" datasource="#DSN2#">
                SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.cheque_guaranty_code#">
            </cfquery>
			<cfset guarantyCode = get_acc_detail.cheque_guaranty_code>
            <cfset guarantyCodeName = get_acc_detail.cheque_guaranty_code & ' - ' & GET_ACC_6.ACCOUNT_NAME>
        </cfif>
        <cfif len(get_acc_detail.voucher_guaranty_code)>
            <cfquery name="GET_ACC_7" datasource="#DSN2#">
                SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.voucher_guaranty_code#">
            </cfquery>
			<cfset vGuarantyCode = get_acc_detail.voucher_guaranty_code>
            <cfset vGuarantyCodeName = get_acc_detail.voucher_guaranty_code & ' - ' & GET_ACC_7.ACCOUNT_NAME>
        </cfif>
        <cfif len(get_acc_detail.karsiliksiz_cekler_code)>
            <cfquery name="GET_ACC_8" datasource="#DSN2#">
                SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.karsiliksiz_cekler_code#">
            </cfquery>
			<cfset bouncedChequeCode = get_acc_detail.karsiliksiz_cekler_code>
            <cfset bouncedChequeCodeName = get_acc_detail.karsiliksiz_cekler_code & ' - ' & GET_ACC_8.ACCOUNT_NAME>
        </cfif>
        <cfif len(get_acc_detail.protestolu_senetler_code)>
            <cfquery name="GET_ACC_9" datasource="#DSN2#">
                SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_acc_detail.protestolu_senetler_code#">
            </cfquery>
			<cfset protestedVoucherCode = get_acc_detail.protestolu_senetler_code>
            <cfset protestedVoucherCodeName = get_acc_detail.protestolu_senetler_code & ' - ' & GET_ACC_9.ACCOUNT_NAME>
        </cfif>
        <cfset branchInfo = valuelist(get_acc_branchs.branch_id)>
        <cfset accountAccCode = get_acc_detail.account_acc_code>
        <cfset accountAccCodeName = get_acc_detail.account_acc_code & ' - ' & get_acc_1.account_name>
        <cfset accountOrderCode = get_acc_detail.account_order_code>
		<cfset accountOrderCodeName = get_acc_detail.account_order_code & ' - ' & get_acc_2.account_name>
		<cfset vChequeAccCode = get_acc_detail.v_cheque_acc_code>
        <cfset vChequeAccCodeName = get_acc_detail.v_cheque_acc_code & ' - ' & get_acc_3.account_name>
		<cfset exchangeCode = get_acc_detail.cheque_exchange_code>
        <cfset exchangeCodeName = get_acc_detail.cheque_exchange_code & ' - ' & get_acc_4.account_name>
        <cfset ibanCode = get_acc_detail.account_owner_customer_no>
        <cfset accountName = get_acc_detail.account_name>
        <cfset bankId = get_branch_names.bank_id>
        <cfset bankCode = get_acc_detail.bank_code>
		<cfset branchCode = get_acc_detail.branch_code>
        <cfset accountNo = get_acc_detail.account_no>
        <cfset creditLimit = TLFormat(get_acc_detail.account_credit_limit)>
        <cfset actionDetail = get_acc_detail.account_detail>
    </cfif>
</cfif>
<cfif not isDefined('attributes.event') or attributes.event is 'list'>
	<script type="text/javascript">
            $( document ).ready(function() {
                document.getElementById('keyword').focus();
            });
    </script>
<cfelse>
	<script type="text/javascript">
        function unformat_fields()
        {
            fld=bankAccount.account_credit_limit;
            fld.value=filterNum(fld.value);
        }
        function kontrol()
        {
            if (document.bankAccount.branch_id.value == "")
            { 
                alert ("<cf_get_lang_main no ='2329.Şube Seçiniz'>!");
                return false;
            }
            if(document.bankAccount.account_owner_customer_no.value == '')
            {
               alert('<cf_get_lang_main no="1600.IBAN Code Değerini Giriniz"> !');
               return false;
            }
            //if(!isIBAN(document.bankAccount.account_owner_customer_no)) return false;
            
            b = document.bankAccount.account_bank_id.options.selectedIndex;
            if (document.bankAccount.account_bank_id.options[b].value == "")
            { 
                alert ("<cf_get_lang no ='88.Banka Seçiniz'>");
                return false;
            }
            c = document.bankAccount.account_branch_id.options.selectedIndex;
            if (document.bankAccount.account_branch_id.options[c].value == "")
            { 
                alert ("<cf_get_lang no ='262.Banka Şubesi Seçiniz'>!");
                return false;
            }
            d = document.bankAccount.account_type.options.selectedIndex;
            if (document.bankAccount.account_type.options[d].value == "")
            { 
                alert ("<cf_get_lang no='184.Hesap Türü Seçiniz'> !");
                return false;
            }
            <cfif isDefined('attributes.event') and attributes.event is 'upd' and control.recordcount eq 0>
                e = document.bankAccount.account_currency_id.options.selectedIndex;
                if (document.bankAccount.account_currency_id.options[e].value == "")
                { 
                    alert ("<cf_get_lang no='185.Para Birimi Seçiniz'> !");
                    return false;
                }
            </cfif>
            if (document.getElementById('account_id').value == "" || document.getElementById('account_code_name').value == "" )
            { 
                alert ("<cf_get_lang no='186.Muhasebe Kodu Seçiniz'> !");
                return false;
            }
            if (document.getElementById('bank_order').value == "" || document.getElementById('bank_order_name').value == "")
            { 
                alert ("<cf_get_lang no='182.Banka Talimatı Muhasebe Kodu'> !");
                return false;
            }
            if (document.getElementById('v_account_id').value == "" || document.getElementById('v_account_name').value == "")
            { 
                alert ("<cf_get_lang no='187.Verilen Çek Muhasebe Kodu Seçiniz'> !");
                return false;
            }	
            if (document.getElementById('exchange_code_id').value == "" || document.getElementById('exchange_code_name').value == "")
            { 
                alert ("<cf_get_lang no ='263.Takas Çeki Muhasebe Kodunu Seçiniz'>!");
                return false;
            }	
            if (document.getElementById('v_exchange_code_id').value == "" || document.getElementById('v_exchange_code_name').value == "")
            { 
                alert ("<cf_get_lang no ='264.Takas Senet Muhasebe Kodunu Seçiniz'>!");
                return false;
            }	
            if (document.getElementById("protestolu_senetler_id").value == "" || document.getElementById("protestolu_senetler_name").value == "")
            { 
                alert ("Protestolu Senetler <cf_get_lang no='186.Muhasebe Kodu Seçiniz'> !");
                return false;
            }
            if (document.getElementById("karsiliksiz_cekler_id").value == "" || document.getElementById("karsiliksiz_cekler_name").value == "")
            { 
                alert ("Karşılıksız Çekler <cf_get_lang no='186.Muhasebe Kodu Seçiniz'> !");
                return false;
            }
            unformat_fields();
            return true;
        }
        function pencere_ac(isim)
        {
            temp_account_code = eval('cheques.'+isim);
            if (temp_account_code.value.length != 0)
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=cheques.'+isim+'&account_code=' + temp_account_code.value, 'list');
            else
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=cheques.'+isim, 'list');
        }
        function set_bank_branch(xyz)
        {
            document.bankAccount.branch_code.value = "";
            if(xyz.split(';')[1]!= undefined)
                document.bankAccount.bank_code.value = xyz.split(';')[1];
            else
                document.bankAccount.bank_code.value = "";
            
            var bank_id_ = xyz.split(';')[0];
            var bank_branch_names = wrk_safe_query('bnk_branch_names','dsn3',0,bank_id_);
            
            var option_count = document.getElementById('account_branch_id').options.length; 
            for(x=option_count;x>=0;x--)
                document.getElementById('account_branch_id').options[x] = null;
            
            if(bank_branch_names.recordcount != 0)
            {	
                document.getElementById('account_branch_id').options[0] = new Option("<cf_get_lang dictionary_id='57734.Seçiniz'>",'');
                for(var xx=0;xx<bank_branch_names.recordcount;xx++)
                    document.getElementById('account_branch_id').options[xx+1]=new Option(bank_branch_names.BANK_BRANCH_NAME[xx],bank_branch_names.BANK_BRANCH_ID[xx]+';'+bank_branch_names.BRANCH_CODE[xx]);
            }
            else
                document.getElementById('account_branch_id').options[0] = new Option("<cf_get_lang dictionary_id='57734.Seçiniz'>",'');
        }
        function set_branch_code(abc)
        {
            if(abc.split(';')[1]!= undefined)
                document.bankAccount.branch_code.value = abc.split(';')[1];
            else
                document.bankAccount.branch_code.value = "";
        }
    </script>
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.form_add_account';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/form_account.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'bank/query/add_account.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.list_bank_account&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.form_upd_bank_account';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/form/form_account.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'bank/query/upd_account.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.list_bank_account&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_bank_account';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'bank/display/list_accounts.cfm';
	
	if(isDefined('attributes.event') and attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.del_bank_account&id=#attributes.id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_account.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_account.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_account';
	}
	
	if(isDefined('attributes.event') and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.list_bank_account&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'bankAcount';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ACCOUNTS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-branch_id','item-account_owner_customer_no','item-account_name','item-account_bank_id','item-account_branch_id','item-account_no','item-account_type','item-account_currency_id','item-account_id','item-bank_order','item-v_account_id','item-exchange_code_id','item-v_exchange_code_id','item-karsiliksiz_cekler_id','item-protestolu_senetler_id']";
</cfscript>
