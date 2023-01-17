<cf_get_lang_set module_name="finance">
<cfquery name="BRANCHES" datasource="#dsn#">
	SELECT * FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# ORDER BY BRANCH_NAME
</cfquery>
<cfif not isdefined("attributes.event")>
	<cfset attributes.event = "list">
</cfif>
<cfset posCode = "">
<cfset equipment = "">
<cfset sellerCode = "">
<cfset assetId = "">
<cfset assetName = "">
<cfset compId = "">
<cfset compName = "">
<cfset casher1 = "">
<cfset casher2 = "">
<cfset casherName1 = "">
<cfset casherName2 = "">
<cfif attributes.event is "list">
    <cfparam name = "attributes.keyword" default="">
    <cfparam name = "attributes.branch_id" default="">
    <cfparam name = "get_pos_equipment_bank.recordcount" default="0">
    <cfparam name = "attributes.page" default='1'>
    <cfparam name = "attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif isdefined('attributes.is_submitted')>
        <cfquery name="GET_POS_EQUIPMENT_BANK" datasource="#dsn3#">
            SELECT
                *
            FROM
                POS_EQUIPMENT_BANK
            WHERE
                POS_ID IS NOT NULL
                <cfif len(attributes.keyword)>
                AND
                (
                    EQUIPMENT LIKE '%#attributes.keyword#%' OR
                    POS_CODE LIKE '%#attributes.keyword#%' OR
                    SELLER_CODE LIKE '%#attributes.keyword#%'
                )
                </cfif>
                <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>AND BRANCH_ID = #attributes.branch_id#</cfif>
        </cfquery>
    </cfif>
    <cfparam name="attributes.totalrecords" default='#get_pos_equipment_bank.recordcount#'>
</cfif>
<cfif attributes.event is 'upd' or attributes.event is 'add'>
    <cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
        SELECT
            ACCOUNTS.ACCOUNT_ID,
            ACCOUNTS.ACCOUNT_NAME,
            <cfif session.ep.period_year lt 2009>
                CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID,
            </cfif>
            BANK_BRANCH.*
        FROM
            ACCOUNTS,
            BANK_BRANCH
        WHERE
            ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID AND
            <cfif session.ep.period_year lt 2009>
                (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
            <cfelse>
                ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY)
            </cfif>
        ORDER BY
            BANK_NAME,
            ACCOUNT_NAME
    </cfquery>

	<cfif attributes.event is 'upd'>
        <cfquery name="GET_POS_EQUIPMENT" datasource="#dsn3#">
            SELECT
                POS_EQUIPMENT_BANK.*,
                ASSET_P.ASSETP
            FROM
                POS_EQUIPMENT_BANK
                    LEFT JOIN #dsn_alias#.ASSET_P ON ASSET_P.ASSETP_ID = POS_EQUIPMENT_BANK.ASSETP_ID
            WHERE
                POS_ID = #ATTRIBUTES.POS_ID#
        </cfquery>
        <cfif get_pos_equipment.recordcount>
        	<cfset posCode = get_pos_equipment.pos_code>
            <cfset equipment = get_pos_equipment.equipment>
            <cfset sellerCode = get_pos_equipment.seller_code>
            <cfset assetId = get_pos_equipment.assetp_id>
            <cfset assetName = get_pos_equipment.assetp>
            <cfset compId = GET_POS_EQUIPMENT.COMPANY_ID>
            <cfif len(compId)>
            	<cfset compName = get_par_info(get_pos_equipment.company_id,1,0,0)>
            </cfif>
			<cfset casher1 = GET_POS_EQUIPMENT.CASHIER1>
            <cfset casher2 = GET_POS_EQUIPMENT.CASHIER2>
            <cfif len(casher1)>
            	<cfset casherName1 = get_emp_info(GET_POS_EQUIPMENT.CASHIER1,1,0)>
            </cfif>
 			<cfif len(casher2)>
            	<cfset casherName2 = get_emp_info(GET_POS_EQUIPMENT.CASHIER2,1,0)>
            </cfif>
        </cfif>
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
        function kontrol()
        {
            x = document.bankPos.branch_id.selectedIndex;
            if (document.bankPos.branch_id[x].value == "")
            { 
                alert ("<cf_get_lang_main no='1167.Lütfen Şube Seçiniz'> !");
                return false;
            }
			if(document.getElementById('pos_code').value == "")
			{
				alert("<cf_get_lang no='425.Cihaz Kodu Girmelisiniz'> !");
				return false;
			}
			if(document.getElementById('equipment').value == "")
			{
				alert("<cf_get_lang no='198.Cihaz Adı Girmelisiniz'> !");
				return false;
			}
			if(document.getElementById('seller_code').value == "")
			{
				alert("<cf_get_lang no='421.İşyeri Kodu Girmelisiniz'> !");
				return false;
			}
            return true;
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.form_add_pos_bank';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'finance/form/form_pos_bank.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'finance/query/add_pos_bank.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_bank_pos&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.form_upd_pos_bank';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'finance/form/form_pos_bank.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'finance/query/upd_pos_bank.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_bank_pos&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'pos_id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.pos_id##';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_bank_pos';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'finance/display/list_pos_bank.cfm';
	
	if(isDefined('attributes.event') and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_bank_pos&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'bankPos';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'POS_EQUIPMENT_BANK';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-pos_code','item-equipment','item-seller_code','item-branch_id']";
</cfscript>
