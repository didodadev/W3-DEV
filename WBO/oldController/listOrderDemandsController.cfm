<cf_xml_page_edit fuseact ="sales.list_order_demands" default_value="1">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_pos_id" default="">
<cfparam name="attributes.product_position" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.demand_type" default="">
<cfparam name="attributes.sales_member_name" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.sales_member_type" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.status" default="1">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfparam name="attributes.start_date" default="">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfparam name="attributes.finish_date" default="">
</cfif>
<cfset adres = url.fuseaction>
<cfset adres = "#adres#&is_submit=1">
<cfset adres = "#adres#&demand_type=#attributes.demand_type#">
<cfif isdefined("attributes.is_submit")>
	<cfquery name="GET_DEMANDS" datasource="#DSN3#">
		SELECT 
			OD.RECORD_PAR,
			OD.RECORD_CON,
			OD.RECORD_DATE,
			OD.DEMAND_ID,
			OD.DEMAND_TYPE,
			OD.DEMAND_STATUS,
			OD.DEMAND_AMOUNT,
			OD.PRICE,
            OD.PRICE_KDV,	
			OD.STOCK_ID,
			OD.ORDER_ID,
            OD.DEMAND_DATE,
            OD.RECORD_DATE,
            OD.PRICE_MONEY,
            COM_PART.NICKNAME,
            COM_PART.MEMBER_CODE,
            COM_PART.COMPANY_PARTNER_NAME,
            COM_PART.COMPANY_PARTNER_SURNAME
		FROM 
			ORDER_DEMANDS OD LEFT JOIN (
                                        SELECT 
                                            C.NICKNAME,
                                            C.MEMBER_CODE,
                                            C.COMPANY_ID,
                                            CP.COMPANY_PARTNER_NAME,
                                            CP.COMPANY_PARTNER_SURNAME,
                                            CP.PARTNER_ID 
                                        FROM 
                                            #DSN_ALIAS#.COMPANY_PARTNER CP,
                                            #DSN_ALIAS#.COMPANY C
                                        WHERE 
                                            C.COMPANY_ID = CP.COMPANY_ID
                                        )
			COM_PART ON OD.RECORD_PAR = COM_PART.PARTNER_ID
		WHERE
			1=1
		<cfif len(attributes.demand_type)>
            AND OD.DEMAND_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_type#">
        </cfif>
        <cfif len(attributes.keyword)>
            AND OD.ORDER_ID	IN (SELECT ORDER_ID FROM ORDERS WHERE ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
        </cfif>
        <cfif len(attributes.product_id) and len(attributes.product_name)>
            AND OD.STOCK_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
        </cfif>
        <cfif len(attributes.product_pos_id) and len(attributes.product_position)>
            AND OD.STOCK_ID IN (SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_pos_id#">)
        </cfif>
        <cfif isDefined("attributes.status") and len(attributes.status)>
            AND OD.DEMAND_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
        </cfif>
        <cfif len(attributes.member_type) and (attributes.member_type is 'partner') and len(attributes.company_id) and len(attributes.member_name)>
            AND COM_PART.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        </cfif>
        <cfif len(attributes.member_type) and (attributes.member_type is 'consumer') and len(attributes.consumer_id) and len(attributes.member_name)>
            AND OD.RECORD_CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
        </cfif>
        <cfif isdefined('attributes.start_date') and len(attributes.start_date)>
			AND OD.DEMAND_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		</cfif>
		<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
			AND OD.DEMAND_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		</cfif>
		ORDER BY 
			OD.RECORD_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_demands.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_demands.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif get_demands.recordcount>
        <cfset partner_list = ''>
        <cfset consumer_list = ''>
        <cfset stock_list = ''>
        <cfset order_list = ''>
        <cfset product_code=''>
        <cfoutput query="get_demands" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfif len(record_con) and not listfind(consumer_list,record_con,',')>
                <cfset consumer_list = listappend(consumer_list,record_con)>
            </cfif>
            <cfif len(stock_id) and not listfind(stock_list,stock_id,',')>
                <cfset stock_list = listappend(stock_list,stock_id)>
            </cfif>
            <cfif len(order_id) and not listfind(order_list,order_id,',')>
                <cfset order_list = listappend(order_list,order_id)>
            </cfif>						
        </cfoutput>
        <cfif listlen(consumer_list)>
            <cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
            <cfquery name="GET_CONSUMERS" datasource="#DSN#">
                SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID,MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
            </cfquery>
            <cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_consumers.consumer_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif listlen(stock_list)>
            <cfset stock_list=listsort(stock_list,"numeric","ASC",",")>
            <cfquery name="GET_STOCKS" datasource="#DSN3#">
                SELECT S.PRODUCT_NAME,S.PROPERTY,S.STOCK_ID,S.PRODUCT_ID,S.STOCK_CODE,S.PRODUCT_CODE_2,P.TAX FROM STOCKS S INNER JOIN PRODUCT P on P.PRODUCT_ID=S.PRODUCT_ID where STOCK_ID IN (#stock_list#) ORDER BY STOCK_ID
            </cfquery>
            <cfset stock_list = listsort(listdeleteduplicates(valuelist(get_stocks.stock_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif listlen(order_list)>
            <cfset order_list=listsort(order_list,"numeric","ASC",",")>
            <cfquery name="GET_ORDERS" datasource="#DSN3#">
                SELECT ORDER_NUMBER,ORDER_ID FROM ORDERS WHERE ORDER_ID IN (#order_list#) ORDER BY ORDER_ID
            </cfquery>
            <cfset order_list = listsort(listdeleteduplicates(valuelist(get_orders.order_id,',')),'numeric','ASC',',')>
        </cfif>
	</cfif>
<cf_xml_page_edit fuseact ="sales.form_add_order" default_value="1">
<cfif isdefined('attributes.event')>
    <cfquery name="GET_MONEY" datasource="#DSN#">
        SELECT
            MONEY,
            MONEY_ID
        FROM
            SETUP_MONEY
        WHERE	
            PERIOD_ID = #SESSION.EP.PERIOD_ID#
            AND MONEY_STATUS = 1 ORDER BY MONEY
    </cfquery>
</cfif>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT RATE1, RATE2, MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cfparam name="attributes.date" default="">
<cfif isdefined('attributes.event') and attributes.event is 'upd'>
    <cf_xml_page_edit fuseact ="sales.form_add_order" default_value="1">
    <cfquery name="GET_ORDER_DEMANDS" datasource="#DSN3#">
        SELECT 
            DEMAND_ID, 
            DEMAND_STATUS, 
            STOCK_ID, 
            PRICE, 
            PRICE_KDV,
            PRICE_MONEY, 
            DEMAND_TYPE, 
            DEMAND_NOTE, 
            DEMAND_AMOUNT, 
            STOCK_ACTION_TYPE, 
            GIVEN_AMOUNT, 
            ORDER_ID, 
            INVOICE_ID, 
            PROMOTION_ID, 
            RECORD_PAR, 
            RECORD_CON, 
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP, 
            UPDATE_EMP, 
            UPDATE_DATE, 
            UPDATE_IP,
            DEMAND_DATE
        FROM 
            ORDER_DEMANDS 
        WHERE 
            DEMAND_ID = #attributes.demand_id#
    </cfquery>
    <cfsavecontent variable="right_images">
        <cf_wrk_history act_type='1' act_id='#attributes.demand_id#'>
    </cfsavecontent>
        <cfif len(get_order_demands.record_con)>
            <cfset sale_member_id = get_order_demands.record_con>
            <cfset sale_member_type = 'consumer'>
            <cfset sale_member_name = get_cons_info(get_order_demands.record_con,0,0)>
        <cfelseif len(get_order_demands.record_par)>
            <cfset sale_member_id = get_order_demands.record_par>
            <cfset sale_member_type = 'partner'>
            <cfset sale_member_name = get_par_info(get_order_demands.record_par,0,-1,0)>
        <cfelse>
            <cfset sale_member_id = ''>
            <cfset sale_member_type = ''>
            <cfset sale_member_name = ''>
        </cfif>
        <cfparam name="attributes.sales_member_name" default="#sale_member_name#">
        <cfif len(get_order_demands.stock_id)>
            <cfquery name="GET_PRO_NAME" datasource="#DSN3#">
                SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #get_order_demands.stock_id#
            </cfquery>							
        </cfif>
        <cfparam name="attributes.product_name" default="#get_pro_name.product_name#">
</cfif>
<script type="text/javascript">
	function kontrol()
	{
		if(document.search.sales_member_name.value == '' || document.search.sales_member_id.value =='')
		{
			alert("<cf_get_lang no='254.Cari Hesap Seçmelisiniz '>!");
			return false;
		}
		<cfif is_date_request eq 1>
			if(document.search.demand_date.value=='' || document.search.demand_date.value=='')
			{
				alert("<cf_get_lang_main no='1091.Lütfen Tarih Giriniz '>!");
				document.search.demand_date.focus();
				return false;
			}
		</cfif>
		if(document.search.product_name.value == '' || document.search.stock_id.value == '')
		{
			alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz'> !");
			return false;
		}
		if(document.search.price_kdv.value == '')
		{
			alert("<cf_get_lang_main no='1738.Tutar Girmelisiniz'> !");
			return false;
		}
		if(document.search.demand_amount.value == '' || document.search.demand_amount.value == 0)
		{
			alert("<cf_get_lang no ='501.Miktar Girmelisiniz'> !");
			return false;
		}
		<cfif isdefined('attributes.event') and attributes.event is 'add'>
			document.search.price_kdv.value = filterNum(document.search.price_kdv.value);
			return true;
		<cfelse>
			document.getElementById('price_kdv').value = filterNum(document.getElementById('price_kdv').value);
			return true;
		</cfif>		
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.add_order_demand';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'sales/form/add_order_demand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'sales/query/add_order_demand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_order_demands&event=list';

	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_order_demands';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'sales/display/list_order_demands.cfm';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.list_order_demands';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'sales/form/upd_order_demand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'sales/query/upd_order_demand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_order_demands';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.demand_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.demand_id##';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'sales.list_order_demands&event=upd&demand_id=#attributes.demand_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'sales/query/del_demand.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'sales/query/del_demand.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.list_order_demands';
	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] ='<cf_wrk_history act_type="1" act_id="#attributes.demand_id#">';
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
	}
</cfscript>
