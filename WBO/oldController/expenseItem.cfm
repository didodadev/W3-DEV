<cf_get_lang_set module_name="budget">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.income_expense" default="">
<cfparam name="attributes.is_expense" default="">
<cfparam name="attributes.expense_category_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.expense_item_code" default="">
<cfparam name="attributes.account_code" default="">
<cfparam name="attributes.account_name" default="">
<cfparam name="attributes.tax_code" default="">
<cfparam name="attributes.expense_item_detail" default="">
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event eq 'list')>
	<cfparam name="attributes.expense_cat" default="">
    <cfparam name="attributes.process_type" default="">
    <cfparam name="attributes.is_active" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.form_exist" default="0">
    <cfparam name="attributes.acc_code" default="">
    <cfif attributes.form_exist>
        <cfquery name="GET_EXPENSE_ITEMS" datasource="#dsn2#">
            SELECT
                EXPENSE_ITEMS.EXPENSE_ITEM_ID,
                EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                EXPENSE_ITEMS.ACCOUNT_CODE,
                EXPENSE_ITEMS.EXPENSE_ITEM_DETAIL,
                EXPENSE_ITEMS.EXPENSE_CATEGORY_ID,
                EXPENSE_ITEMS.IS_ACTIVE,
                EXPENSE_ITEMS.EXPENSE_ITEM_CODE,
                ACCOUNT_PLAN.ACCOUNT_NAME,
                EXPENSE_CATEGORY.EXPENSE_CAT_NAME
            FROM
                EXPENSE_ITEMS
                    LEFT JOIN ACCOUNT_PLAN ON EXPENSE_ITEMS.ACCOUNT_CODE = ACCOUNT_PLAN.ACCOUNT_CODE
                    LEFT JOIN EXPENSE_CATEGORY ON EXPENSE_ITEMS.EXPENSE_CATEGORY_ID = EXPENSE_CATEGORY.EXPENSE_CAT_ID
            WHERE
                EXPENSE_ITEM_ID IS NOT NULL
            <cfif len(attributes.keyword)>
                AND EXPENSE_ITEM_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            </cfif>
            <cfif len(attributes.process_type) and attributes.process_type eq 1>
                AND IS_EXPENSE = 1
            <cfelseif len(attributes.process_type) and attributes.process_type eq 0>
                AND INCOME_EXPENSE = 1
            </cfif>
            <cfif len(attributes.is_active) and attributes.is_active eq 1>
                AND IS_ACTIVE=1
            <cfelseif len(attributes.is_active) and attributes.is_active eq 0>
                AND IS_ACTIVE = 0
            </cfif>
            <cfif isdefined("attributes.expense_cat") and len(attributes.expense_cat)>
                AND EXPENSE_CATEGORY_ID = #attributes.expense_cat#
            </cfif>
            <cfif len(attributes.acc_code)>
                AND (EXPENSE_ITEMS.ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code#"> OR EXPENSE_ITEMS.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.acc_code#.%">)
            </cfif>
            ORDER BY 
                EXPENSE_ITEM_NAME
        </cfquery>
    <cfelse>
        <cfset get_expense_items.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default='1'>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_expense_items.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <script type="text/javascript">
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});
		function open_acc_code(str_alan_1,str_alan_2,str_alan)
		{
			var txt_keyword = eval(str_alan_1 + ".value" );
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id='+str_alan_1+'&field_id2='+str_alan_1+'&keyword='+txt_keyword,'list');
		}
	</script>
</cfif>
<cfif IsDefined("attributes.event")>
	<cfscript>
		TAX_CODES = QueryNew("TAX_CODE_ID, TAX_CODE_NAME,DETAIL");
		QueryAddRow(TAX_CODES,24);
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",0003,1);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","STPJ",1);
		QuerySetCell(TAX_CODES,"DETAIL","GELİR VERGİSİ STOPAJI",1);
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",0015,2);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","KDV GERÇEK",2);		
		QuerySetCell(TAX_CODES,"DETAIL","GERÇEK USULDE KATMA DEĞER VERGİSİ",2);
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",0061,3);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","KKDF KESİNTİ",3);
		QuerySetCell(TAX_CODES,"DETAIL","KAYNAK KULLANIMI DESTEKLEME FONU KESİNTİSİ",3);
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",0071,4);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","ÖTV 1.LİSTE",4);
		QuerySetCell(TAX_CODES,"DETAIL","PETROL VE DOĞALGAZ ÜRÜNLERİNE İLİŞKİN ÖZEL TÜKETİM VERGİSİ",4);
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",0073,5);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","ÖTV 3.LİSTE",5);
		QuerySetCell(TAX_CODES,"DETAIL","KOLALI GAZOZ,ALKÖLLÜ İÇECEKLER VE TÜTÜN MAMÜLLERİNE İLİŞKİN ÖZEL TÜKETİM VERGİSİ",5);	
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",0074,6);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","ÖTV 4.LİSTE",6);
		QuerySetCell(TAX_CODES,"DETAIL","DAYANIKLI TÜKETİM VE DİĞER MALLARA İLİŞKİN ÖZEL TÜKETİM VERGİSİ",6);		
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",0075,7);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","ÖTV 3A LİSTE",7);
		QuerySetCell(TAX_CODES,"DETAIL","ALKOLLÜ İÇEÇEKLERE İLİŞKİN ÖZEL TÜKETİM VERGİSİ",7);	
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",0076,8);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","ÖTV 3B LİSTE",8);
		QuerySetCell(TAX_CODES,"DETAIL","TÜTÜN MAMÜLLERİNE İLİŞKİN ÖZEL TÜKETİM VERGİSİ",8);
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",0077,9);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","ÖTV 3C LİSTE",9);
		QuerySetCell(TAX_CODES,"DETAIL","KOLALI GAZOZLARA İLİŞKİN ÖZEL TÜKETİM VERGİSİ",9);
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",1047,10);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","DAMGA V",10);
		QuerySetCell(TAX_CODES,"DETAIL","DAMGA VERGİSİ",10);
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",1048,11);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","5035SKDAMGAV",11);
		QuerySetCell(TAX_CODES,"DETAIL","5035 SAYILI KANUNA GÖRE DAMGA VERGİSİ",11);		
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",4080,12);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","Ö.İLETİŞİM V",12);
		QuerySetCell(TAX_CODES,"DETAIL","ÖZEL İLETİŞİM VERGİSİ",12);
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",4081,13);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","5035ÖZİLETV",13);
		QuerySetCell(TAX_CODES,"DETAIL","5035 SAYILI KANUNA GÖRE ÖZEL İLETİŞİM VERGİSİ",13);	
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",9015,14);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","KDV TEVKİFAT",14);
		QuerySetCell(TAX_CODES,"DETAIL","KATMA DEĞER VERGİSİ TEVKİFATI",14);		
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",9021,15);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","4961BANKASMW",15);
		QuerySetCell(TAX_CODES,"DETAIL","4961 BANKA SİGORTA MUAMELELERİ VERGİSİ",15);	
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",9077,16);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","ÖTV 2.LİSTE",16);
		QuerySetCell(TAX_CODES,"DETAIL","MOTORLU TAŞIT ARAÇLARINA İLİŞKİN ÖZEL TÜKETİM VERGİSİ(TASCİLE TABİ OLANLAR)",16);	
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",8001,17);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","BORSA TES.ÜC",17);
		QuerySetCell(TAX_CODES,"DETAIL","BORSA TESCİL ÜCRETİ",17);		
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",8002,18);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","ENERJİ FONU",18);
		QuerySetCell(TAX_CODES,"DETAIL","ENERJİ FONU",18);	
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",8003,19);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","BEL.TÜK.VER",19);
		QuerySetCell(TAX_CODES,"DETAIL","BELEDİYE TÜKETİM VERGİSİ",19);		
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",8004,20);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","TRT PAYI",20);
		QuerySetCell(TAX_CODES,"DETAIL","TRT PAYI",20);
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",8005,21);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","ELK.TÜL.VER",21);
		QuerySetCell(TAX_CODES,"DETAIL","ELEKTRİK TÜKETİM VERGİSİ",21);	
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",8006,22);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","TK KULLANIM",22);
		QuerySetCell(TAX_CODES,"DETAIL","TELSİZ KULLANIM ÜCRETİ",22);
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",8007,23);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","TK RUHSAT",23);
		QuerySetCell(TAX_CODES,"DETAIL","TELSİZ RUHSAT ÜCRETİ",23);
		QuerySetCell(TAX_CODES,"TAX_CODE_ID",8008,24);
		QuerySetCell(TAX_CODES,"TAX_CODE_NAME","ÇEV.TEM.VER.",24);
		QuerySetCell(TAX_CODES,"DETAIL","ÇEVRE TEMİZLİK VERGİSİ",24);
	</cfscript>
    <cfquery name="get_expense_cat_list" datasource="#dsn2#">
        SELECT 
            *
        FROM
            EXPENSE_CATEGORY
        WHERE
            1=1
            <cfif isdefined("attributes.cat_id")>
                AND EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">
            </cfif>
            <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                AND EXPENSE_CAT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
            </cfif>
            <cfif isdefined('attributes.kategory_secim') and len(attributes.kategory_secim) and kategory_secim is 'ik'>
                AND EXPENCE_IS_HR = 1
            </cfif>
            <cfif isdefined('attributes.kategory_secim') and len(attributes.kategory_secim) and kategory_secim is 'eg'>
                AND EXPENCE_IS_TRAINING = 1
            </cfif>
        ORDER BY
            EXPENSE_CAT_NAME
    </cfquery>
	 <cfif attributes.event eq 'upd'>
     	<cfquery name="GET_EXPENSE_ITEM_STA" datasource="#dsn2#">
			SELECT
                *
            FROM
                EXPENSE_ITEMS
            WHERE 
                EXPENSE_ITEM_ID IS NOT NULL
              <cfif isdefined('attributes.item_id')>
                AND EXPENSE_ITEM_ID = #attributes.item_id#
              </cfif>
              <cfif isdefined('attributes.keyword') and len(attributes.keyword)>
                AND EXPENSE_ITEM_NAME LIKE '#attributes.keyword#%'
              </cfif>
              <cfif isdefined('attributes.static_cat_id')>
                AND EXPENSE_CATEGORY_ID = #attributes.static_cat_id#
              </cfif>
              <cfif isdefined("attributes.is_expense") and len(attributes.is_expense)>
                AND EXPENSE_ITEMS.IS_EXPENSE = 1
              <cfelseif  isdefined("attributes.is_expense") and not len(attributes.is_expense)>
                AND EXPENSE_ITEMS.INCOME_EXPENSE = 1
              </cfif>		
            ORDER BY
                EXPENSE_ITEM_NAME
        </cfquery>
         <cfset attributes.account_code = get_expense_item_sta.account_code>
        <cfquery name="get_account_name" datasource="#dsn2#">
            SELECT ACCOUNT_NAME,ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#attributes.account_code#'		
        </cfquery>   
     </cfif>
     <script type="text/javascript">
		function kontrol()
		{
			if(document.getElementById("expense_cat").value == '')
			{
				alert("<cf_get_lang no='41.Bütçe Kategorisi Seçmediniz'> !");
				return false;
			}
			if(document.getElementById("expense_item_code").value == '')
			{
				alert("Kod Girmelisiniz !");
				return false;
			}
			if(document.getElementById("expense_item_name").value == '')
			{
				alert("<cf_get_lang no='26.Gider Kalemi Girmelisiniz'>!");
				return false;
			}
			 <cfif attributes.event eq 'add'>
				if(document.getElementById("account_code").value == '')
				{
					alert("<cf_get_lang no='61.Muhasebe Kodu girmelisiniz'>!");
					return false;
				}
			</cfif>
			if(document.getElementById("income_expense").checked == false && document.getElementById("is_expense").checked == false)
			{
				alert("<cf_get_lang no='64.Gelir yada Gider Seçmelisiniz'> !");
				return false;
			}	
			return true;
		}
	</script>
</cfif>
<script  type="text/javascript">
	function pencere_ac_muhasebe()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_expense_item.account_code&field_id=add_expense_item.account_id','list');
	}
</script>
<cfif isdefined('attributes.event') and attributes.event eq 'upd' >
	<cfset attributes.is_active = get_expense_item_sta.is_active>
	<cfset attributes.income_expense = get_expense_item_sta.income_expense>
	<cfset attributes.is_expense = get_expense_item_sta.is_expense>
	<cfset attributes.expense_category_id = get_expense_item_sta.expense_category_id>
	<cfset attributes.expense_item_name = get_expense_item_sta.expense_item_name>
	<cfset attributes.expense_item_code = get_expense_item_sta.expense_item_code>
	<cfset attributes.account_code = get_account_name.account_code>
	<cfset attributes.account_name = get_account_name.account_name>
	<cfset attributes.tax_code = GET_EXPENSE_ITEM_STA.tax_code>
	<cfset attributes.expense_item_detail = get_expense_item_sta.expense_item_detail>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.list_expense_item';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'budget/display/list_budget_expense_item.cfm';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.list_expense_item';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'budget/form/add_budget_expense_type.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'budget/query/upd_budget_expense_item.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.list_expense_item';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'item_id=##attributes.item_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.item_id##';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'budget.list_expense_item';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'budget/form/add_budget_expense_type.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'budget/query/add_budget_expense_item.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'budget.list_expense_item';
	
	if(IsDefined("attributes.event") && attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=budget.list_expense_item&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	} 
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'expenseItem';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EXPENSE_ITEMS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item2','item3','item4','item5','item6']"; 
</cfscript>

