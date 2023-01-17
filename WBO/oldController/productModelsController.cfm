<cf_get_lang_set module="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.is_obm" default="1">
    <cfparam name="attributes.brand_id" default="">
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="get_product_models" datasource="#dsn1#">
            SELECT
                MODEL_ID,
                MODEL_CODE,
                MODEL_NAME,
                PRODUCT_BRANDS.BRAND_NAME
            FROM
                PRODUCT_BRANDS_MODEL LEFT JOIN PRODUCT_BRANDS ON PRODUCT_BRANDS_MODEL.BRAND_ID = PRODUCT_BRANDS.BRAND_ID
            WHERE
                1=1
            <cfif len(attributes.keyword)>
                AND (MODEL_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
            </cfif> 
            ORDER BY
            <cfif isdefined("attributes.is_obm") and attributes.is_obm eq 0>
                MODEL_CODE
            <cfelse>
                MODEL_NAME
            </cfif>
        </cfquery>
    <cfelse>
        <cfset get_product_models.recordcount = 0>
    </cfif>      
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	<cfset model_id = 0> 
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd') and attributes.model_id neq 0> 
   <cfif isdefined('attributes.model_id') and len(attributes.model_id)>
        <cfquery name="get_model_det" datasource="#dsn1#">
            SELECT MODEL_NAME, MODEL_CODE,BRAND_ID FROM PRODUCT_BRANDS_MODEL WHERE MODEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.model_id#">
        </cfquery>
    </cfif>
    <cfif isdefined('attributes.model_id') and len(attributes.model_id)>
		<cfset model_id = attributes.model_id>
	<cfelse>
		<cfset model_id = 0>
	</cfif>
</cfif>

<cfif isdefined("attributes.event") and listFindNoCase('add,upd',attributes.event)>
   <script type="text/javascript">
		function control()
		{			
			if($('#model_name').val()=='')
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='813.Model'>");
				return false;
			}
			if($('#model_code').val()=='')
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='1173.Kod'>");
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product_models';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_product_models.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.list_product_models';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_product_model.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_product_model.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_product_models';
	WOStruct['#attributes.fuseaction#']['add']['parameters'] = 'model_id=##attributes.model_id##';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.list_product_models';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/add_product_model.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/add_product_model.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_product_models';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'model_id=##attributes.model_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.model_id##';

</cfscript>
