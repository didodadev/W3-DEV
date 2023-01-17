<cf_get_lang_set module ="product">
<cfif (isdefined("attributes.event") and attributes.event is 'upd') or not isdefined("attributes.event")>
    <cfparam name="attributes.brand_id" default="">
    <cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
        SELECT 
            PRODUCT_CAT.PRODUCT_CATID, 
            PRODUCT_CAT.HIERARCHY, 
            PRODUCT_CAT.PRODUCT_CAT
        FROM 
            PRODUCT_CAT,
            PRODUCT_CAT_OUR_COMPANY PCO
        WHERE 
            PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
            PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        ORDER BY 
            HIERARCHY
    </cfquery>
    <cfquery name="COMPANIES" datasource="#DSN#">
		SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY
	</cfquery>
    <cfquery name="GET_PRODUCT_COMP" datasource="#DSN3#">
		SELECT COMPETITIVE_ID,COMPETITIVE FROM PRODUCT_COMP ORDER BY COMPETITIVE
	</cfquery>
</cfif>

<cfif (isdefined("attributes.event") and attributes.event is 'upd') or not isdefined("attributes.event")>
	<script type="text/javascript">
		function control_tr()
		{
			if(document.set_.upd_type[0].checked==true)
			{
				gizle(tedarikci_1);
				gizle(tedarikci_2);
				gizle(marka_1);
				gizle(marka_2);
				goster(kategori_1);
				goster(kategori_2);
			}
			else if(document.set_.upd_type[1].checked==true)
			{
				goster(tedarikci_1);
				goster(tedarikci_2);
				gizle(kategori_1);
				gizle(kategori_2);
				gizle(marka_1);
				gizle(marka_2);
			}
			else if(document.set_.upd_type[2].checked==true)
			{
				gizle(tedarikci_1);
				gizle(tedarikci_2);
				gizle(kategori_1);
				gizle(kategori_2);
				goster(marka_1);
				goster(marka_2);
			}
			else if(document.set_.upd_type[3].checked==true)
			{
				goster(tedarikci_1);
				goster(tedarikci_2);
				gizle(kategori_1);
				gizle(kategori_2);
				goster(marka_1);
				goster(marka_2);
			}
		}
		function kontrol()
		{
			if(document.set_.upd_type[0].checked==true)
			{
				if(document.set_.cat.value=='')
				{
					alert("<cf_get_lang_main no='1535.Kategori Seçmelisiniz'>");
					return false;
				}
			}
			else if(document.set_.upd_type[1].checked==true)
			{
				if(document.set_.comp.value=='' || document.set_.company_id.value=='')
				{
					alert("<cf_get_lang no='988.Tedarikçi Seçmelisiniz'>!");
					return false;
				}
			}
			else if(document.set_.upd_type[2].checked==true)
			{
				if(document.set_.brand_name.value=='' || document.set_.brand_id.value=='')
				{
					alert("<cf_get_lang_main no='1534.Marka Seçmelisiniz'>");
					return false;
				}
			}
			else if(document.set_.upd_type[3].checked==true)
			{
				if(document.set_.brand_name.value=='' || document.set_.brand_id.value=='')
				{
					alert("<cf_get_lang_main no='1534.Marka Seçmelisiniz'>");
					return false;
				}
				if(document.set_.comp.value=='' || document.set_.company_id.value=='')
				{
					alert("<cf_get_lang no='988.Tedarikçi Seçmelisiniz'>!");
					return false;
				}
			}
			return true;
		}
		
		function filter_char(strng)
		{
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=product.ajax_product_categories&keyword=' + strng + '','prod_cats',1);
		}
		
		function showBranch(comp_id)	
		{
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=product.ajax_company_branches&company_id='+comp_id+'','comp_branches',1);
		}
	
		 $(document).keydown(function (e) {
			if (e.keyCode == 8) {
				var str = document.getElementById('keyword').value;
				str = str.substring(0, str.length - 1);
				filter_char(str);
			}
		});
			
	</script>
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'upd';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'window';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.change_product_info';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/display/change_product_info.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/change_product_info.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.change_product_info';

</cfscript>
