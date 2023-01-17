<cf_get_lang_set module ="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.is_active" default="1">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.stock_id" default="">
    <cfparam name="attributes.product_name" default="">
    <cfif isdefined("attributes.is_submit")>
        <cfquery name="get_conf" datasource="#dsn3#">
            SELECT 
                SETUP_PRODUCT_CONFIGURATOR.*,
                S.STOCK_ID,
                S.PRODUCT_ID,
                S.PRODUCT_NAME
            FROM 
                SETUP_PRODUCT_CONFIGURATOR,
                STOCKS S
            WHERE
                S.STOCK_ID = CONFIGURATOR_STOCK_ID
                <cfif len(attributes.keyword)> AND SETUP_PRODUCT_CONFIGURATOR.CONFIGURATOR_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif>
                <cfif len(attributes.is_active)>AND SETUP_PRODUCT_CONFIGURATOR.IS_ACTIVE = #attributes.is_active#</cfif>
                <cfif len(attributes.product_name) and len(attributes.stock_id)>
                    AND CONFIGURATOR_STOCK_ID = #attributes.stock_id#
                </cfif>
            ORDER BY
                SETUP_PRODUCT_CONFIGURATOR.CONFIGURATOR_NAME
        </cfquery>
    <cfelse>
    	<cfset get_conf.recordcount = 0>
    </cfif>    
</cfif>
	
<cfif (isdefined("attributes.event") and attributes.event is 'add')>
	<script type="text/javascript">
        function configurator_save()
        {
            if(document.add_product_configuration.configuration_name.value == '')
            {
                alert('Lütfen Konfigrasyon Tanımı Giriniz!');
                return false;
            }
            if(document.add_product_configuration.stock_id.value == '' || document.add_product_configuration.product_name.value == '')
            {
                alert('Lütfen Ürün Seçiniz!');
                return false;
            }	
            if(document.add_product_configuration.configuration_detail.value == '')
            {
                alert('Lütfen Açıklama Giriniz!');
                return false;
            }	
            return true;
        }
    </script>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>  
    <cfquery name="get_conf" datasource="#dsn3#">
        SELECT 
            SETUP_PRODUCT_CONFIGURATOR.*
        FROM 
            SETUP_PRODUCT_CONFIGURATOR
        WHERE
            SETUP_PRODUCT_CONFIGURATOR.PRODUCT_CONFIGURATOR_ID = #attributes.id#
    </cfquery>  
</cfif>

<cfif (isdefined("attributes.event") and attributes.event is 'upd')>    
    <script type="text/javascript">
		 adres = '<cfoutput>#request.self#?fuseaction=product.emptypopup_detail_configurator&product_configurator_id=#attributes.id#'</cfoutput>;
		AjaxPageLoad(adres,'configurator_save_divid','1',"Bekleyiniz!");			
		 adres = '<cfoutput>#request.self#?fuseaction=product.emptypopup_detail_formula_row&product_configurator_id=#attributes.id#'</cfoutput>;
		AjaxPageLoad(adres,'configurator_save_divid2','1',"Bekleyiniz!");			
			function configurator_save()
			{
				if(document.add_product_configuration.configuration_name.value == '')
				{
					alert('Lütfen Konfigrasyon Tanımı Giriniz!');
					return false;
				}
				if(document.add_product_configuration.stock_id.value == '' || document.add_product_configuration.product_name.value == '')
				{
					alert('Lütfen Ürün Seçiniz!');
					return false;
				}	
				if(document.add_product_configuration.configuration_detail.value == '')
				{
					alert('Lütfen Açıklama Giriniz!');
					return false;
				}
				for(r=1;r<=add_product_configuration.record_num.value;r++)
				{
					if(eval("document.add_product_configuration.row_control"+r).value == 1)
					{
						if(eval("document.add_product_configuration.property_id"+r).value == '' || eval("document.add_product_configuration.property"+r).value == '')
						{
							alert("Lütfen Özellik Seçiniz !");
							return false;
						}
						if(eval("document.add_product_configuration.price_type"+r).value == 3)
						{ 
							if(eval("document.add_product_configuration.property_id_row"+r).value == '' || eval("document.add_product_configuration.property_row"+r).value == '')
							{
								alert("Fiyat Kriteri Özellik İse Satırda Ek Özellik Seçmelisiniz !");
								return false;
							}
						}
					}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product_configration';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_product_configration.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.list_product_configration';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_product_configuration.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_product_configuration.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_product_configration';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.list_product_configration';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_product_configuration.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_product_configuration.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_product_configration';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=product.list_product_configration&event=add','list')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>
