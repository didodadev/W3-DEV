<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif not isdefined("attributes.startdate")>
	<cfset base_date = createdate(year(now()),month(now()),day(now()))>
	<cfset attributes.startdate = date_add("ww",-2,base_date)>
	<cfset attributes.finishdate = date_add("ww",2,base_date)>
</cfif>
<cfset adres = url.fuseaction>
<cfset adres = "#adres#&is_submit=1">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cfset adres = "#adres#&startdate=#attributes.startdate#">
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cfset adres = "#adres#&finishdate=#attributes.finishdate#">
</cfif>
<cfif isdefined("attributes.is_active") and isdate(attributes.is_active)>
	<cfset adres = "#adres#&is_active=#attributes.is_active#">
</cfif>
<cfif isdefined("attributes.vision_type") and isdate(attributes.vision_type)>
	<cfset adres = "#adres#&vision_type=#attributes.vision_type#">
</cfif>

<cfif isdefined("attributes.is_submit")>
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
</cfif>
<cfquery name="GET_VISIONS" datasource="#dsn3#">
	SELECT 
		PV.*,
		S.PRODUCT_NAME,
		S.PROPERTY
	FROM 
		PRODUCT_VISION PV,
		STOCKS S
	WHERE 
		S.PRODUCT_NAME LIKE '%#attributes.keyword#%' AND
		S.PRODUCT_ID = PV.PRODUCT_ID AND
		S.STOCK_ID = PV.STOCK_ID
		<cfif isDefined("attributes.vision_type") and len(attributes.vision_type)>
			AND PV.VISION_TYPE LIKE '%#attributes.vision_type#%' 
		</cfif>
		<cfif (isDefined("attributes.is_active") and (attributes.is_active neq 2))>
			AND IS_ACTIVE = #attributes.is_active# 
		</cfif>
		<cfif len(attributes.startdate) and not len(attributes.finishdate)>
			AND FINISHDATE >= #attributes.startdate#
		<cfelseif len(attributes.finishdate) and not len(attributes.startdate)>
			AND STARTDATE <= #attributes.finishdate#
		<cfelseif len(attributes.startdate) and len(attributes.finishdate)>
			AND STARTDATE <= #attributes.finishdate# AND FINISHDATE >= #attributes.startdate#
		</cfif>
	ORDER BY PV.RECORD_DATE DESC
</cfquery>
<cfelse>
	<cfset GET_VISIONS.recordcount = 0>
</cfif>
<cfquery name="get_vision_type" datasource="#dsn#">
	SELECT VISION_TYPE_ID,VISION_TYPE_NAME FROM SETUP_VISION_TYPE
</cfquery>
<cfparam name="attributes.totalrecords" default='#GET_VISIONS.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isdefined('attributes.event') and attributes.event is 'add'>
	<cfif isdefined("attributes.product_id") and len(attributes.product_id)>
        <cfquery name="get_product_" datasource="#dsn3#" maxrows="1">
            SELECT
                S.PRODUCT_NAME,
                S.STOCK_ID
            FROM
                STOCKS S
            WHERE
                S.PRODUCT_ID = #attributes.product_id#
        </cfquery>
    <cfelse>
        <cfset get_product_.recordcount = 0>
    </cfif>
<cfelseif isdefined('attributes.event') and attributes.event is 'upd'>
    <cfquery name="get_vision" datasource="#dsn3#">
        SELECT 
            PV.*,
            S.PRODUCT_NAME,
            S.PROPERTY
        FROM 
            PRODUCT_VISION PV,
            STOCKS S
        WHERE 
            S.PRODUCT_ID = PV.PRODUCT_ID AND
            S.STOCK_ID = PV.STOCK_ID AND
            PV.VISION_ID = #attributes.vision_id#
    </cfquery>
    <cfsavecontent variable="txt">
        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_add_product_vision"><img src="/images/plus1.gif" title="<cf_get_lang_main no ='170.Ekle'>"></a>
    </cfsavecontent>
</cfif> 
<script type="text/javascript">
	<cfif not isdefined('attributes.event')>
		$('#keyword').focus();
		//document.getElementById('keyword').focus();
	<cfelse>
		function pencere_ac()
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search.stock_id&product_id=search.product_id&field_name=search.product_name<cfif isDefined('attributes.product_id') and len(attributes.product_id)><cfoutput>&list_product_id=#attributes.product_id#</cfoutput></cfif>','list');
		}
	</cfif>
	<cfif isdefined('attributes.event') and attributes.event is 'add'>
		function kontrol()
		{         
			if ( $('#vision_type').val() == "")
			{ 
				alert ("<cf_get_lang_main no='1535.Kategori Seçmelisiniz'>");
				return false;
			}
			else
				return true;
		}
	<cfelse>
        function kontrol()
        {
            if (document.search.vision_type.value == "")
            { 
                alert ("<cf_get_lang_main no='1535.Kategori Seçmelisiniz'>");
                return false;
            }
		    else
				return true;
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product_vision';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_product_vision.cfm';

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.add_product_vision';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_product_vision.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_product_vision.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_product_vision';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.upd_product_vision';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_product_vision.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_product_vision.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_product_vision';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.vision_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.vision_id##';

	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.emptypopup_del_product_vision&vision_id=#attributes.vision_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'product/query/del_product_vision.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'product/query/del_product_vision.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_product_vision';

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_product_vision&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
	}

</cfscript>

