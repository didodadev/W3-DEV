<cf_get_lang_set module_name="account">
<cfif (isdefined("attributes.event") and attributes.event is "list") or not isdefined("attributes.event")>
    <cf_xml_page_edit fuseact="account.list_account_plan">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
    <cfif isdefined("attributes.is_form_exist")>
        <cfstoredproc procedure="get_account_plan" datasource="#dsn2#">
            <cfif isdefined("is_xml_remainder")>
                <cfif is_show_remainder eq 1 >
                    <cfprocparam cfsqltype="cf_sql_bit" value="1">
                <cfelse>
                    <cfprocparam cfsqltype="cf_sql_bit" value="0">
                </cfif>
            <cfelse>
                <cfprocparam cfsqltype="cf_sql_bit" value="1">
            </cfif>
            <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                <cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
            <cfelse>
                <cfprocparam cfsqltype="cf_sql_varchar" value="">
            </cfif>
            <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.startrow#">
            <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.maxrows#">
            <cfprocresult name="get_acc_remainder">
        </cfstoredproc>
        <cfparam name="attributes.totalrecords" default='#get_acc_remainder.query_count#'>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is "add">
	<cfscript>
        url_string = "";
        if(isdefined("attributes.field_id") and len(attributes.field_id))
            url_string = "#url_string#&field_id=#field_id#";
        if(isdefined("attributes.field_name") and len(attributes.field_name))
            url_string = "#url_string#&field_name=#attributes.field_name#";
        if(isdefined("attributes.code") and len(attributes.code))
            url_string = "#url_string#&code=#attributes.code#";
        if(isdefined("attributes.db_source") and len(attributes.db_source))
            url_string = "#url_string#&db_source=#attributes.db_source#";
        if(isdefined("attributes.period_year") and len(attributes.period_year))
            url_string = "#url_string#&period_year=#attributes.period_year#";
        if(isdefined("attributes.nereden_geldi") and len(attributes.nereden_geldi))
            url_string = "#url_string#&nereden_geldi=#attributes.nereden_geldi#";
        if(isdefined("attributes.search_account_code") and len(attributes.search_account_code))
            url_string = "#url_string#&account_code=#attributes.search_account_code#";
        if(isdefined('attributes.db_source'))
        {
            if(database_type is "MSSQL")
            {
                db_source = "#DSN#_#attributes.PERIOD_YEAR#_#attributes.db_source#";
                db_source3_alias = "#DSN#_#attributes.db_source#";
            }else if (database_type is "DB2")
            {
                db_source="#DSN#_#attributes.db_source#_#Right(Trim(attributes.PERIOD_YEAR),2)#";
                db_source3_alias="#DSN#_#attributes.db_source#_dbo";
            }
        }
        else
        {
            db_source = DSN2 ;
            db_source3_alias = DSN3_ALIAS;
        }
    </cfscript> 
<cfelseif isdefined("attributes.event") and attributes.event is "upd">
	<!--- Bu sorgularin sirasi degismesin! --->
    <cfinclude template="../account/query/get_account.cfm">
    <cfinclude template="../account/query/get_account_hareket.cfm">
    <!--- // Bu sorgularin sirasi degismesin! --->
	<cfscript>
        if (get_acc.recordcount)
        {
            islem_gormus = 1;
            is_update = 1;
        } else {
            islem_gormus = 0 ;
            is_update = 0;
        }
        if ((is_update eq 0) and (account.sub_account eq 1)) is_update = 1;
    </cfscript>
<cfelseif isdefined("attributes.event") and attributes.event is "listAct">
    <cf_xml_page_edit fuseact="account.list_account_plan_rows">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.acc_branch_id" default="">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfparam name="attributes.acc_code_type" default="0">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.is_sub_project" default="">
    <cfinclude template="../account/query/get_branch_list.cfm">
    <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
        <cf_date tarih = "attributes.startdate">
    <cfelse>
        <cfset attributes.startdate = createodbcdatetime('#session.ep.period_year#-#month(now())#-1')>
    </cfif>
    <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
        <cf_date tarih = "attributes.finishdate">
    <cfelse>
        <cfset attributes.finishdate = createodbcdatetime('#session.ep.period_year#-#month(now())#-#DaysInMonth(attributes.startdate)#')>
    </cfif>
    <cfif isdefined("attributes.form_varmi")>
        <cfinclude template="../account/query/get_account_rows.cfm">
        <cfparam name="attributes.page" default="1">
        <cfparam name="attributes.totalrecords" default="#get_account_rows.recordcount#">
        <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
    </cfif>
    <cfquery name="get_money" datasource="#dsn2#">
        SELECT MONEY FROM SETUP_MONEY WHERE MONEY_STATUS =1
    </cfquery>
    <cfset money_list=valuelist(get_money.MONEY)>
	<!--- devreden islemlerin hesabi --->
    <cfloop  list="#money_list#" index="kk">
        <cfset 'dev_alacak_islem_dovizli#kk#'=0>
        <cfset 'dev_borc_islem_dovizli#kk#'=0>
        <cfset 'alacak_islem_dovizli#kk#'=0>
        <cfset 'borc_islem_dovizli#kk#'=0>
        <cfset 'bakiye_dovizli_#kk#'=0>
    </cfloop>
	<cfscript>
		duty_total = 0 ;
		duty_total_2 = 0;
		claim_total = 0 ;
		claim_total_2 = 0 ;
		borc_ = 0 ;
		alacak_ = 0 ;
		borc_2 = 0;
		alacak_2 = 0;
	</cfscript>
	<cfset colspan_numb_ = 3>
	<cfif isdefined('is_acc_department') and is_acc_department eq 1>
		<cfset colspan_numb_ = colspan_numb_ + 1>
	</cfif>
	<cfif isdefined('is_acc_branch') and is_acc_branch eq 1>
		<cfset colspan_numb_ = colspan_numb_ + 1>
	</cfif>
	<cfif isdefined('is_acc_project') and is_acc_project eq 1>
		<cfset colspan_numb_ = colspan_numb_ + 1>
	</cfif>
    <cfif isdefined("attributes.form_varmi") and get_account_rows.recordcount>
		
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is "det">
    <cfsavecontent variable="ay1"><cf_get_lang_main no='180.Ocak'></cfsavecontent>
    <cfsavecontent variable="ay2"><cf_get_lang_main no='181.Şubat'></cfsavecontent>
    <cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
    <cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
    <cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
    <cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
    <cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
    <cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
    <cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
    <cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
    <cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
    <cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
    <cfset ay_list = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
    <cfparam name="attributes.startdate" default="01/#month(now())#/#SESSION.EP.PERIOD_YEAR#">
    <cfparam name="attributes.finishdate" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfquery name="get_money" datasource="#dsn2#">
        SELECT MONEY FROM SETUP_MONEY WHERE MONEY_STATUS =1<!---  AND MONEY <> '#session.ep.money#' --->
    </cfquery>
    <cfset money_list=valuelist(get_money.MONEY)>
    <cfloop  list="#money_list#" index="kk">
        <cfset 'toplam_#kk#'=0>
        <cfset 'alacak_#kk#'=0>
        <cfset 'other_bakiye_#kk#'=0>
    </cfloop>
    <cfquery name="get_sub_acount" datasource="#dsn2#">
        SELECT SUB_ACCOUNT FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#CODE#'
    </cfquery>
    <cfquery name="GET_BORC" datasource="#dsn2#">
        SELECT
            SUM(ACR.AMOUNT) AS AMOUNT,
            SUM(ACR.AMOUNT_2) AS AMOUNT_2,
            ACR.AMOUNT_CURRENCY_2,
        <cfif (database_type is 'MSSQL')>
            Datepart("m",ACTION_DATE) AS BU_AY
        <cfelseif (database_type is 'DB2')>
            MONTH(ACTION_DATE) AS BU_AY
        </cfif>				
        FROM
            ACCOUNT_CARD_ROWS ACR,
            ACCOUNT_CARD AC
        WHERE
            <cfif get_sub_acount.SUB_ACCOUNT eq 1>
                ACR.ACCOUNT_ID LIKE '#CODE#.%' AND
            <cfelse>
                ACR.ACCOUNT_ID = '#CODE#' AND
            </cfif>
                ACR.CARD_ID=AC.CARD_ID AND
                ACR.BA = 0			
        GROUP BY
            <cfif (database_type is 'MSSQL')>
                Datepart("m",ACTION_DATE),
            <cfelseif (database_type is 'DB2')>
                MONTH(ACTION_DATE),
            </cfif>		
            ACR.AMOUNT_CURRENCY_2
    </cfquery>
    <cfset borc_ay_list=ListDeleteDuplicates(valuelist(GET_BORC.BU_AY))>
    <cfquery name="GET_ALACAK" datasource="#dsn2#">
        SELECT
            SUM(ACR.AMOUNT) AS AMOUNT,
            SUM(ACR.AMOUNT_2) AS AMOUNT_2,
            ACR.AMOUNT_CURRENCY_2,
        <cfif (database_type is 'MSSQL')>
            Datepart("m",ACTION_DATE) AS BU_AY
        <cfelseif (database_type is 'DB2')>
            MONTH(ACTION_DATE) AS BU_AY
        </cfif>				
        FROM
            ACCOUNT_CARD_ROWS ACR,
            ACCOUNT_CARD AC
        WHERE
            <cfif get_sub_acount.SUB_ACCOUNT eq 1>
                ACR.ACCOUNT_ID LIKE '#CODE#.%' AND
            <cfelse>
                ACR.ACCOUNT_ID = '#CODE#' AND
            </cfif>
                ACR.CARD_ID=AC.CARD_ID AND
                ACR.BA = 1		
        GROUP BY
            <cfif (database_type is 'MSSQL')>
                Datepart("m",ACTION_DATE),
            <cfelseif (database_type is 'DB2')>
                MONTH(ACTION_DATE),
            </cfif>		
            ACR.AMOUNT_CURRENCY_2
    </cfquery>
    <cfset alacak_ay_list=ListDeleteDuplicates(valuelist(GET_ALACAK.BU_AY))>
    <cfquery name="OTHER_BORC_ALACAK" datasource="#dsn2#">
        SELECT
            SUM(ACR.OTHER_AMOUNT) AS OTHER_AMOUNT,
            ACR.OTHER_CURRENCY,
        <cfif (database_type is 'MSSQL')>
            Datepart("m",ACTION_DATE) AS BU_AY,
        <cfelseif (database_type is 'DB2')>
            MONTH(ACTION_DATE) AS BU_AY,
        </cfif>				
            ACR.BA AS BORC_ALACAK
        FROM
            ACCOUNT_CARD_ROWS ACR,
            ACCOUNT_CARD AC
        WHERE
            <cfif get_sub_acount.SUB_ACCOUNT eq 1>
                ACR.ACCOUNT_ID LIKE '#CODE#.%' AND
            <cfelse>
                ACR.ACCOUNT_ID = '#CODE#' AND
            </cfif>
                ACR.CARD_ID=AC.CARD_ID AND 
                ACR.OTHER_CURRENCY IS NOT NULL
        GROUP BY
            <cfif (database_type is 'MSSQL')>
                Datepart("m",ACTION_DATE),
            <cfelseif (database_type is 'DB2')>
                MONTH(ACTION_DATE),
            </cfif>		
                ACR.OTHER_CURRENCY,
                ACR.BA		
    </cfquery>
    <cfscript>
        borc_total = 0 ;
        alacak_total = 0 ;
        borc2_total = 0 ;
        alacak2_total = 0 ;
        bakiye_total = 0 ;
        bakiye2_total = 0 ;
    </cfscript>	
</cfif>
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and (attributes.event is "list" or attributes.event is "listAct")) or not isdefined("attributes.event")>
		$(document).ready(function(){
			document.getElementById('keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is "add" or attributes.event is "upd")>
		function kontrol()
		{
			var temp_str = document.accountCode.account_code.value;
			if ((temp_str.indexOf(',') >= 0) || (temp_str.indexOf('.') >= 0))
			{
				alert("<cf_get_lang no ='248.Girdiğiniz Hesap Kodu Geçerli Değil'> !");
				return false;			
			}
			if (trim(document.accountCode.account_name.value)=='')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no ='38.Hesap Adı'>");
				return false;
			}
			return true;
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_account_plan';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/list_account_plan.cfm';
	
	if(attributes.event is "add")
	{
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.popup_form_add_account';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/form_add_account.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/add_account.cfm';
		if(len(url_string))
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'objects.popup_account_plan#url_string#&account_code=#attributes.account_code#';
		else
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.list_account_plan';
	}
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.popup_form_upd_account';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'account/form/form_upd_account.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'account/query/upd_account.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.list_account_plan';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#lang_array.item [210]#';
	
	if(attributes.event is "upd" or attributes.event is "del")
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'account.del_account&old_account=#account.account_code#&account_id=#attributes.account_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'account/query/del_account.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'account/query/del_account.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'account.list_account_plan';
	}
	
	if(attributes.event is "listAct")
	{
		WOStruct['#attributes.fuseaction#']['listAct'] = structNew();
		WOStruct['#attributes.fuseaction#']['listAct']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['listAct']['fuseaction'] = 'account.list_account_plan_rows';
		WOStruct['#attributes.fuseaction#']['listAct']['filePath'] = 'account/display/list_account_plan_rows.cfm';
		WOStruct['#attributes.fuseaction#']['listAct']['queryPath'] = 'account/display/list_account_plan_rows.cfm';
		WOStruct['#attributes.fuseaction#']['listAct']['nextEvent'] = 'account.list_account_plan&event=listAct&acc_code_type=#attributes.acc_code_type#';
		
		head = "";
		if(isdefined("attributes.form_varmi"))
		{
			if(isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)
				head = get_account_rows.ifrs_name;
			else
				head = get_account_rows.account_name;
			head = head & " : " & attributes.code;
		}
		WOStruct['#attributes.fuseaction#']['listAct']['Identity'] = '<br/>#lang_array_main.item [507]# #head#';
	}
	
	if(attributes.event is 'det')
	{
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'account.popup_list_account_monthly';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'account/display/popup_list_account_monthly.cfm';
		WOStruct['#attributes.fuseaction#']['det']['Identity'] = '<br/> #SESSION.EP.PERIOD_YEAR# #lang_array_main.item[505]# : #attributes.code#';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=account.list_account_plan&event=add','small')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'det')
	{
		if(get_sub_acount.SUB_ACCOUNT neq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#lang_array_main.item [507]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.list_account_plan&event=listAct&code=#attributes.code#','longpage')";
	/*		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['text'] = '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['customTag'] = '<cf_workcube_file_action pdf="0" mail="0" doc="0" print="1" simple="1">';	*/	
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
</cfscript>
