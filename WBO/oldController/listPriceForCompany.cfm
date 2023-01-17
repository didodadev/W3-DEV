<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_PRICE_CAT_EXCEPTIONS" datasource="#DSN3#">
            SELECT
                ISNULL(COMPANYCAT_ID,(SELECT COMPANYCAT_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = PRICE_CAT_EXCEPTIONS.COMPANY_ID)) COMPANY_CAT,
                *
            FROM
                PRICE_CAT_EXCEPTIONS
            WHERE
                <cfif isdefined("keyword") and len(keyword)>
                    PRICE_CATID IN (SELECT PRICE_CATID FROM PRICE_CAT WHERE PRICE_CAT LIKE '%#attributes.keyword#%') AND
                </cfif>
                CONTRACT_ID IS NULL  AND
                (IS_GENERAL = 1 OR ACT_TYPE IN (1))
        </cfquery>
    <cfelse>
        <cfset get_price_cat_exceptions.recordcount=0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_price_cat_exceptions.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>  
	<!--- İstisnai Fiyat Ekleme --->
    <cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
        SELECT PRICE_CATID,PRICE_CAT,PRICE_CAT_STATUS FROM PRICE_CAT ORDER BY PRICE_CAT
    </cfquery>
    <cfquery name="GET_PRICE_CAT_ACTIVE" dbtype="query">
        SELECT * FROM GET_PRICE_CATS WHERE PRICE_CAT_STATUS = 1 
    </cfquery>
    <cfquery name="GET_COMP_CATS" datasource="#DSN#">
        SELECT DISTINCT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT
    </cfquery>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>  
	<!--- İstisnai Fiyat Guncelleme --->
    <cfquery name="GET_PRICE_CAT_EXCEPTIONS" datasource="#DSN3#">
        SELECT
            ISNULL(COMPANYCAT_ID,(SELECT COMPANYCAT_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = PRICE_CAT_EXCEPTIONS.COMPANY_ID)) COMPANY_CAT,
            (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE E.EMPLOYEE_ID=PRICE_CAT_EXCEPTIONS.RECORD_EMP) AS RECORD_NAME,
            (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE E.EMPLOYEE_ID=PRICE_CAT_EXCEPTIONS.UPDATE_EMP) AS UPDATE_NAME,
            *
        FROM
            PRICE_CAT_EXCEPTIONS
        WHERE
            PRICE_CAT_EXCEPTION_ID = #attributes.pid#
    </cfquery>
    <cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
					SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT ORDER BY PRICE_CAT
				</cfquery>
    <cfif len(get_price_cat_exceptions.supplier_id)>
						<cfquery name="GET_SUP_NAME" datasource="#DSN#">
							SELECT COMPANY_ID, NICKNAME FROM COMPANY WHERE COMPANY_ID = #get_price_cat_exceptions.supplier_id#
						</cfquery>
					</cfif>
    <cfquery name="GET_COMP_CATS" datasource="#DSN#">
						SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
					</cfquery> 
    <cfif len(get_price_cat_exceptions.company_id)>
						<cfquery name="get_member" datasource="#DSN#">
							SELECT FULLNAME MEMBER_NAME, COMPANY_ID FROM COMPANY WHERE COMPANY_ID = #get_price_cat_exceptions.company_id#
						</cfquery>
					<cfelseif len(get_price_cat_exceptions.consumer_id)>
						<cfquery name="get_member" datasource="#DSN#">
							SELECT (CONSUMER_NAME+' '+CONSUMER_SURNAME) MEMBER_NAME, CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID = #get_price_cat_exceptions.consumer_id#
						</cfquery>
					</cfif> 
    <cfif len(get_price_cat_exceptions.product_catid)>
						<cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
							SELECT PRODUCT_CATID, HIERARCHY, PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = #get_price_cat_exceptions.product_catid#
						</cfquery>
					</cfif>
	<cfif len(get_price_cat_exceptions.brand_id)>
        <cfquery name="GET_BRAND_NAME" datasource="#DSN3#">
            SELECT BRAND_NAME, BRAND_ID	FROM PRODUCT_BRANDS WHERE BRAND_ID = #get_price_cat_exceptions.brand_id#
        </cfquery>
    </cfif>
    <cfif len(get_price_cat_exceptions.product_id)>
        <cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
            SELECT PRODUCT_ID, PRODUCT_NAME, PROD_COMPETITIVE FROM  PRODUCT WHERE PRODUCT_ID = #get_price_cat_exceptions.product_id#
        </cfquery>
    </cfif>
</cfif>
<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	$('#keyword').focus();
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	function unformat_fields()
	{
		if(document.price_company.price_cat.value == '')
		{
			window.alert("Fiyat Listesi Seçiniz!");
			return false;
		}
	
		return true;
	}
	function pencere_pos()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products_only&product_id=price_company.product_id&field_name=price_company.product_name','list'); /*&process=purchase_contract  var_=purchase_contr_cat_premium&*/
	}
		
	function pencr_ac_supplier(type)
	{
		if(type==2) /*üye*/
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=price_company.company&field_comp_id=price_company.company_id&select_list=2,3&field_consumer=price_company.consumer_id&field_member_name=price_company.company&comp_cat=price_company.comp_cat','list');
		else /*üretici*/
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_comp_id=price_company.supplier_id&field_comp_name=price_company.supplier_name','list');
	}
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	function pencere_pos()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products_only&product_id=price_company.product_id&field_name=price_company.product_name','list'); /*&process=purchase_contract  var_=purchase_contr_cat_premium&*/
	}
	
	function pencr_ac_supplier(type)
	{
		if(type==2) /*üye*/
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=price_company.company&field_comp_id=price_company.company_id&select_list=2,3&field_consumer=price_company.consumer_id&field_member_name=price_company.company&comp_cat=price_company.comp_cat','list');
		else /*üretici*/
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_comp_id=price_company.supplier_id&field_comp_name=price_company.supplier_name','list');
	}
</cfif>
</script>


<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_price_for_company';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_price_for_company.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.list_price_for_company';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_price_for_company.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_price_company.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_price_for_company&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.list_price_for_company';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_price_for_company.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_price_company.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_price_for_company&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'pid=##attributes.pid##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.pid##';
	
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=product.emptypopup_upd_price_company&is_del=1&pid=#get_price_cat_exceptions.price_cat_exception_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'product/query/upd_price_company.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'product/query/upd_price_company.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_price_for_company';
	}
		
		
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	// Upd //	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_price_for_company&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'cariToCariVirman';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PRICE_CAT_EXCEPTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-price_cat']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
