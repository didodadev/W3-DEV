<cf_get_lang_set module_name="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_COUPONS" datasource="#DSN3#">
            SELECT
                *
            FROM 
                COUPONS 
            WHERE 
                1=1 <cfif IsDefined("attributes.keyword") and len(attributes.keyword)> AND COUPON_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
        </cfquery>
    <cfelse>
        <cfset get_coupons.recordcount=0>
    </cfif>
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
    <cfparam name="attributes.cat" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_coupons.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="GET_COUPON_TYPE" datasource="#DSN3#">
        SELECT * FROM COUPONS WHERE COUPON_ID = #attributes.coupon_id#
    </cfquery>
</cfif>  

<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
   <script type="text/javascript">
	   $(document).ready(function(){
			$('#keyword').focus();
	   });		
    </script> 
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<script type="text/javascript">
        function kapa_refresh()
        {	
            y=(200-add_coupon_main.coupon_detail.value.length);
            if(y<0)
            {
                alert("<cf_get_lang_main no='217.Açıklama'> "+((-1)*y)+"<cf_get_lang_main no='1741. Karakter Uzun'>");
                return false;
            }
            return true;
        }
    </script>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<script type="text/javascript">
		function kontrol()
		{
			y=(200-upd_coupon_main.coupon_detail.value.length);
			if(y<0)
			{
				alert("<cf_get_lang_main no ='217.Açıklama'> "+((-1)*y)+"<cf_get_lang_main no='1741.Karakter Uzun'> ");
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
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_coupons';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_coupons.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.popup_add_coupon';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_coupon.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_coupon.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_coupons';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_upd_coupon';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_coupon.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_coupons.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_coupons';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'coupon_id=##get_coupons.coupon_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.coupon_id##';
	
	if(not attributes.event is 'list' and not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.list_coupons&coupon_id=#attributes.coupon_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'product/query/del_coupon.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'product/query/del_coupon.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_coupons';
	}
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_coupons&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listCouponsController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'COUPONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-coupon_name','item-start_date','item-finish_date']";
	
</cfscript>