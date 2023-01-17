<cf_get_lang_set module="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.is_active" default="">
    <cfparam name="attributes.is_internet" default="">
    <cfparam name="attributes.is_obm" default="1">
    <cfparam name="attributes.our_company" default="#session.ep.company_id#">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfquery name="get_our_company" datasource="#dsn#">
		SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY
	</cfquery>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_PRODUCT_BRANDS" datasource="#dsn1#">
            SELECT
                *
            FROM
                PRODUCT_BRANDS
            WHERE
                1=1
            <cfif len(attributes.is_active)>
                AND IS_ACTIVE = #attributes.is_active#
            </cfif>
            <cfif len(attributes.is_internet)>
                AND IS_INTERNET = #attributes.is_internet#
            </cfif>
            <cfif isdefined("attributes.our_company") and len(attributes.our_company)>
                AND BRAND_ID IN (SELECT BRAND_ID FROM PRODUCT_BRANDS_OUR_COMPANY WHERE OUR_COMPANY_ID = #attributes.our_company#)
            </cfif>
            <cfif len(attributes.keyword)>
                AND (BRAND_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
            </cfif> 
            ORDER BY
                <cfif isdefined("attributes.is_obm") and attributes.is_obm eq 0>
                    BRAND_CODE
                <cfelse>
                    BRAND_NAME
                </cfif>
        </cfquery>
    <cfelse>
        <cfset get_product_brands.recordcount = 0>
    </cfif>   
    <cfparam name="attributes.totalrecords" default=#get_product_brands.recordcount#>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')> 
 	<cfquery name="get_our_companies" datasource="#DSN#">
        SELECT 
            COMP_ID,
            NICK_NAME
        FROM
            OUR_COMPANY
        ORDER BY
            NICK_NAME
    </cfquery>  
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	<cfset attributes.brand_id = attributes.id>
    <cfquery name="get_brand" datasource="#dsn1#">
        SELECT 
            BRAND_ID,
            BRAND_CODE,
            BRAND_NAME,
            DETAIL,
            IS_ACTIVE,
            IS_INTERNET,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP,
            UPDATE_DATE,
            UPDATE_EMP,
            UPDATE_IP 
        FROM 
            PRODUCT_BRANDS 
        WHERE 
            BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfquery>
    
    <cfquery name="get_brand_comps" datasource="#dsn1#">
        SELECT * FROM PRODUCT_BRANDS_OUR_COMPANY WHERE BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfquery>
    
    <cfset our_comp_list = valuelist(get_brand_comps.our_company_id)>
    
    <cfinclude template="../objects/query/get_our_companies.cfm">
</cfif>

<cfif (isdefined("attributes.event") and attributes.event is 'upd')>
	<script type="text/javascript">
        function productcat_comp()
        {		
             new_our_company_list='';		
            for(ii=0;ii<document.product_cat.our_company_ids.length; ii++)
            {
                if(product_cat.our_company_ids[ii].selected && product_cat.our_company_ids.options[ii].value.length!='')
                    new_our_company_list= new_our_company_list + ',' + product_cat.our_company_ids.options[ii].value;
            }
            <cfloop list="#our_comp_list#" index="k">
                if(!list_find(new_our_company_list,<cfoutput>#k#</cfoutput>,',') )
                {
                     new_dsn3 = '<cfoutput>#dsn#_#k#</cfoutput>';
                     get_productcat = wrk_safe_query("obj_get_productcat",new_dsn3,0,<cfoutput>#attributes.id#</cfoutput>);
                    if (get_productcat.recordcount)
                    {
                        alert("<cf_get_lang no ='1568.İlgili Şirkette Bu Kategori Bir Üründe Kullanılmıştır'>");
                        return false;
                    }
                }
            </cfloop>
                return true;
        }
        function kapa_refresh()
        {
            y=(1000-product_cat.detail.value.length);
            if(y<0)
            {
                alert("<cf_get_lang_main no ='217.Açıklama'> "+((-1)*y)+"<cf_get_lang_main no='1741.Karakter Uzun'> ");
                return false;
            }
            return true;
        }
        function del_images()
        {
            document.product_cat.del_1.style.display='';
            document.product_cat.del_2.style.display='none';
            document.product_cat.old_logo_del.value=1;
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product_brands';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_product_brands.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.list_product_brands';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'objects/form/add_product_brands.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'objects/query/add_product_brands.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_product_brands';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.list_product_brands';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'objects/form/upd_product_brands.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'objects/query/upd_product_brands.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_product_brands';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##&brand_name=##attributes.brand_name##&brand_code=##attributes.brand_code##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(not attributes.event is 'list' and not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.list_product_brands&id=#attributes.id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'objects/query/del_product_brands.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'objects/query/del_product_brands.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_product_brands';
	}
	
</cfscript>
