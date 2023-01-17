<cf_get_lang_set module="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.our_company" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.product_status" default="">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>    
    <cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
    	SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY
    </cfquery>    
    <cfif isdefined("attributes.form_submitted")>	
		<cfscript>
            get_all_property_action=createobject("component","product.cfc.getAllProperty");
            get_all_property_action.DSN1=#DSN1#;
            get_all_property_action.page=attributes.page;
            get_all_property_action.maxrows=attributes.maxrows;
            getAllProperty=get_all_property_action.getAllProperty(keyword:attributes.keyword,our_company:attributes.our_company,is_active:attributes.product_status);
        </cfscript>
    <cfelse>
		<cfset getAllProperty.recordcount=0>	
        <cfset getAllProperty.query_count=0>	
    </cfif>    
    <cfif getAllProperty.recordcount>
        <cfquery name="GET_ALL_PROPERTY_DETAIL" datasource="#DSN1#">
            SELECT 
                PRPT_ID,
                PROPERTY_DETAIL
            FROM 
                PRODUCT_PROPERTY_DETAIL 
            WHERE 
                PRPT_ID IN (#valueList(getAllProperty.property_id)#)
            ORDER BY 
                PROPERTY_DETAIL
        </cfquery>
    <cfelse>
    	<cfset Get_All_Property_Detail.recordcount=0>
    </cfif>
    <cfparam name="attributes.totalrecords" default='#getAllProperty.query_count#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1> 
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
    <cf_xml_page_edit fuseact="product.upd_property_main">
    <cfinclude template="../product/query/get_our_companies.cfm"> 
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	<cfinclude template="../product/query/get_property_detail.cfm">
	<cfquery name="GET_PROPERTY_CAT" datasource="#dsn1#">
		SELECT
			*
		FROM
			PRODUCT_PROPERTY
		WHERE
			PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
	</cfquery>
	<cfset related_variation_list = listdeleteduplicates(ValueList(get_property_detail.related_variation_id,','))>
    <cfif listlen(related_variation_list)>
        <cfquery name="get_relations_variations_all" datasource="#dsn1#">
            SELECT 
                PROPERTY_DETAIL,PROPERTY_DETAIL_ID
            FROM 
                PRODUCT_PROPERTY_DETAIL 
            WHERE 
                PROPERTY_DETAIL_ID IN (#related_variation_list#)
        </cfquery>
    </cfif>
        <cfquery name="GET_VARIATION" datasource="#DSN1#">
        SELECT 
            VARIATION_ID
        FROM 
            PRODUCT_DT_PROPERTIES
        WHERE
            PROPERTY_ID=#attributes.prpt_id# 
        </cfquery>
    <cfparam name="attributes.related_variation_id" default="">
    <cfparam name="attributes.related_variation" default="">
<cfelseif (isdefined("attributes.event") and attributes.event is 'det2')>
    <cfinclude template="../product/query/get_sub_property_detail.cfm">
    <cfparam name="attributes.related_variation_id" default="">
    <cfparam name="attributes.related_variation" default="">
<cfelseif (isdefined("attributes.event") and attributes.event is 'det')>
	<cf_xml_page_edit fuseact="product.upd_property_main">
	<!--- Ürün özellik tablosu --->
	<cfquery name="GET_PROPERTY_CAT" datasource="#DSN1#">
		SELECT * 
		FROM 
			PRODUCT_PROPERTY 
		WHERE 
			PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
	</cfquery>
	<!--- Ürün özellik varyasyon (detay) tablosu --->
	<cfquery name="GET_PROPERTY_DETAIL" datasource="#DSN1#">
		SELECT 
			PRPT_ID 
		FROM 
			PRODUCT_PROPERTY_DETAIL 
		WHERE 
			PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
		UNION ALL
		SELECT
			PROPERTY_ID
		FROM
			PRODUCT_DT_PROPERTIES
		WHERE 
			PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
	</cfquery>
	<!---Şirket tablosu --->
	<cfquery name="GET_PERIOD" datasource="#dsn#">
		SELECT 
			COMP_ID 
		FROM 
			OUR_COMPANY
	</cfquery>
	<!---Konfügrasyon ve formül tabloları --->
	<cfquery name="GET_PROPERTY_CONFIGURATOR_FORMULA_TABLES" datasource="#DSN#">
		<cfloop query="get_period">
			SELECT 
				PROPERTY_ID 
			FROM 
				#dsn#_#get_period.comp_id#.SETUP_PRODUCT_CONFIGURATOR_COMPONENTS 
			WHERE 
			PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
			<cfif get_period.currentrow neq get_period.recordcount>UNION ALL </cfif>
		</cfloop>
		UNION ALL
		<cfloop query="get_period">
			SELECT 
				PROPERTY_ID 
			FROM 
				#dsn#_#get_period.comp_id#.SETUP_PRODUCT_FORMULA_COMPONENTS 
			WHERE 
				PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
			<cfif get_period.currentrow neq get_period.recordcount>UNION ALL </cfif>
		</cfloop>
	</cfquery>
	<cfquery name="GET_PROPERT_OUR_COMPANY" datasource="#DSN1#">
		SELECT 
			OUR_COMPANY_ID 
		FROM 
			PRODUCT_PROPERTY_OUR_COMPANY 
		WHERE PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prpt_id#">
	</cfquery>
	<cfset our_comp_list=valuelist(get_propert_our_company.our_company_id)>
</cfif>

<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")> 
	<script type="text/javascript">
        $('#keyword').focus();
    </script>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	<script type="text/javascript">	
		function kontrol_prop()
		{
			<cfif xml_size_color eq 1> 
				if(add_property_main.size_color[0].checked && add_property_main.size_color[1].checked)
				{
					alert("Özellik, Hem Renk Hem Beden seçilemez!!");
					return false;
				}
			</cfif>
			
			if (document.add_property_main.our_company_ids.value == "")
			  { 
				   alert ("Özellik kaydedebilmeniz için en az bir şirket seçmeniz gerekmektedir ");
				   return false;
			  }
			  return true;
		}
    </script>
<cfelseif (isdefined("attributes.event") and attributes.event is 'det')>
	<script type="text/javascript">	
		function kontrol_prop()
		{
			<cfif xml_size_color eq 1> 
				if(upd_property_main.size_color[0].checked && upd_property_main.size_color[1].checked)
				{
					alert("Özellik, Hem Renk Hem Beden seçilemez!!");
					return false;
				}
			</cfif>
			
			if (document.upd_property_main.our_company_ids.value == "")
			  { 
				   alert ("Özellik kaydedebilmeniz için en az bir şirket seçmeniz gerekmektedir ");
				   return false;
			  }
			  return true;
		}
    </script>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	<script type="text/javascript">
		function kapa_refresh()
		{
			wrk_opener_reload();
			window.close();
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_property';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_property.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.list_property';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_property_main.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_property_main.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_property';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.list_property';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/add_property.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/add_property_act.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_property';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'prpt_id=##attributes.prpt_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.prpt_id##';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'product.list_property';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'product/form/upd_property_main.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'product/query/upd_property_main.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'product.list_property';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'prpt_id=##attributes.prpt_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.prpt_id##';
	
	WOStruct['#attributes.fuseaction#']['det2'] = structNew();
	WOStruct['#attributes.fuseaction#']['det2']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det2']['fuseaction'] = 'product.list_property';
	WOStruct['#attributes.fuseaction#']['det2']['filePath'] = 'product/form/upd_sub_property.cfm';
	WOStruct['#attributes.fuseaction#']['det2']['queryPath'] = 'product/query/upd_product_property.cfm';
	WOStruct['#attributes.fuseaction#']['det2']['nextEvent'] = 'product.list_property&event=upd&prpt_id=##attributes.prpt_id##';
	WOStruct['#attributes.fuseaction#']['det2']['parameters'] = 'property_detail_id=##attributes.property_detail_id##';
	WOStruct['#attributes.fuseaction#']['det2']['Identity'] = '##attributes.property_detail_id##';
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.list_property';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'product/query/del_product_property.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'product/query/del_product_property.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_property&event=upd&prpt_id=##attributes.prpt_id##';
	WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'property_detail_id=##attributes.property_detail_id##';
	WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.property_detail_id##';
	
	WOStruct['#attributes.fuseaction#']['del2'] = structNew();
	WOStruct['#attributes.fuseaction#']['del2']['window'] = 'emptypopup';
	WOStruct['#attributes.fuseaction#']['del2']['fuseaction'] = 'product.list_property';
	WOStruct['#attributes.fuseaction#']['del2']['filePath'] = 'product/query/del_product_property_main.cfm';
	WOStruct['#attributes.fuseaction#']['del2']['queryPath'] = 'product/query/del_product_property_main.cfm';
	WOStruct['#attributes.fuseaction#']['del2']['nextEvent'] = 'product.list_property&event=upd&prpt_id=##attributes.prpt_id##';
	WOStruct['#attributes.fuseaction#']['del2']['parameters'] = 'property_detail_id=##attributes.prpt_id##';
	WOStruct['#attributes.fuseaction#']['del2']['Identity'] = '##attributes.prpt_id##';


	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=product.list_property&event=add','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(attributes.event is 'det')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=product.list_property&event=add','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
