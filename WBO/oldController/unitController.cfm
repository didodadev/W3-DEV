<cf_get_lang_set module_name="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfquery name="GET_SETUP_UNIT" datasource="#DSN#">
        SELECT * FROM SETUP_UNIT
    </cfquery>
<cfelseif isdefined("attributes.event") and listFindNoCase('add,upd',attributes.event)>
    <cffile action="read" file="#index_folder#admin_tools#dir_seperator#xml#dir_seperator#units.xml" variable="xmldosyam" charset = "UTF-8">
    <cfset dosyam = XmlParse(xmldosyam)>
    <cfset xml_dizi = dosyam.SETUP_UNITS.XmlChildren>
    <cfset d_boyut = ArrayLen(xml_dizi)>
        <cfif (isdefined("attributes.event") and attributes.event is 'upd')>
            <cfquery name="categories" datasource="#dsn#">
                SELECT UNIT,UNIT_CODE,RECORD_DATE,RECORD_EMP,UPDATE_DATE,UPDATE_EMP FROM SETUP_UNIT WHERE UNIT_ID = #attributes.unit_id#
            </cfquery>
            <cfquery name="get_our_companies" datasource="#dsn#">
                SELECT COMP_ID FROM OUR_COMPANY
            </cfquery>
            <cfset kontrol_degiskeni = 0>
            <cfloop query="get_our_companies">
                <cfset newdsn = '#dsn#_#comp_id#'>
                <cfquery name="get_pro" datasource="#newdsn#" maxrows="1">
                    SELECT UNIT_ID FROM PRODUCT_UNIT WHERE UNIT_ID = #attributes.unit_id#
                </cfquery>
                <cfif get_pro.recordcount>
                    <cfset kontrol_degiskeni = 1>
                    <cfbreak>
                </cfif>
            </cfloop>
    	</cfif>    
        <cfquery name="GET_SETUP_EFATURA" datasource="#DSN#">
            SELECT IS_EFATURA FROM OUR_COMPANY_INFO WHERE IS_EFATURA = 1
        </cfquery>
</cfif>  
<cfif isdefined("attributes.event") and listFindNoCase('add,upd',attributes.event)> 
    <script type="text/javascript">
		function check_code()
		{
			if($('#unit').val() == '')
			{
				alert('Birim Adı Girmelisiniz !');	
				return false;
			}
			<cfif GET_SETUP_EFATURA.recordcount> 
			
			if($('#unit_code').val() == '')
			{
				alert('UNECE Standart Değerini Seçiniz !');	
				return false;
			}
			</cfif>
			
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_unit';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_unit.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.list_unit';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/form_add_unit.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_unit.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_unit';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.list_unit';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/form_upd_unit.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_unit.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_unit';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'unit_id=##attributes.unit_id##&unit=##attributes.unit##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.unit_id##';
	
	if(not attributes.event is 'list' and not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.list_unit&unit_id=#attributes.unit_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'product/query/del_unit.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'product/query/del_unit.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_unit';
	}
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=product.list_unit&event=add&popup_page=1','small')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>
