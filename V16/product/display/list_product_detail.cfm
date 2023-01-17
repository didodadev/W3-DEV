<cfquery name="GET_PROPERTY_VARIATION" datasource="#DSN1#">
   SELECT
        PP.PROPERTY_ID,
        CASE
        	WHEN LEN(SLI1.ITEM) > 0 THEN SLI1.ITEM
            ELSE PP.PROPERTY
        END AS PROPERTY,
        PPD.PROPERTY_DETAIL_ID,
        CASE
        	WHEN LEN(SLI2.ITEM) > 0 THEN SLI2.ITEM
            ELSE PPD.PROPERTY_DETAIL
        END AS PROPERTY_DETAIL
		<cfif len(attributes.cat_id) and len(attributes.category_name)>
			,PCP.PRODUCT_CAT_ID
		</cfif>
    FROM
        PRODUCT_PROPERTY PP
        	LEFT JOIN #dsn_alias#.SETUP_LANGUAGE_INFO SLI1 ON SLI1.UNIQUE_COLUMN_ID = PP.PROPERTY_ID
            AND SLI1.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROPERTY">
            AND SLI1.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_PROPERTY">
            AND SLI1.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">,       
        PRODUCT_PROPERTY_DETAIL PPD
        	LEFT JOIN #dsn_alias#.SETUP_LANGUAGE_INFO SLI2 ON SLI2.UNIQUE_COLUMN_ID = PPD.PROPERTY_DETAIL_ID
            AND SLI2.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROPERTY_DETAIL">
            AND SLI2.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_PROPERTY_DETAIL">
            AND SLI2.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
		<cfif len(attributes.cat_id) and len(attributes.category_name)>
			,PRODUCT_CAT_PROPERTY PCP
		</cfif>
    WHERE
        PP.PROPERTY_ID = PPD.PRPT_ID
   		AND PP.PROPERTY_ID IN (SELECT PROPERTY_ID FROM PRODUCT_PROPERTY_OUR_COMPANY WHERE OUR_COMPANY_ID = #session.ep.company_id#)
        <cfif len(attributes.cat_id) and len(attributes.category_name)>
       		AND PP.PROPERTY_ID=PCP.PROPERTY_ID
        	AND PCP.PROPERTY_ID=PPD.PRPT_ID
        	AND PCP.PRODUCT_CAT_ID=#attributes.cat_id#
        </cfif>
    ORDER BY
        PP.PROPERTY,
        PPD.PROPERTY_DETAIL
</cfquery>
<table>
	<cfif get_property_variation.recordcount eq 0>
        <tr><td><cf_get_lang dictionary_id="37315.Bu kategoriye göre özellik mevcut değildir">.</td></tr>
    <cfelse>
    <cfoutput>
        <cfset a=0>
        <cfloop from="1" to="#get_property_variation.recordcount#" index="main_str">						
            <cfif get_property_variation.property_id[main_str] neq get_property_variation.property_id[main_str-1]>
            <cfif ((a mod attributes.mode is 0)) or (a eq 0)>
                <tr id="frm_row#main_str#">
            </cfif>
                 <td>
                    <table>
                        <tr>
                            <td>
                                <input type="hidden" name="property_id#main_str#" id="property_id#main_str#" value="#get_property_variation.property_id[main_str]#">
                                <select name="variation_id#main_str#" id="variation_id#main_str#" style="width:150px;" onchange="showInformation(#main_str#);">
                                    <option value="">#get_property_variation.property[main_str]#</option>
                                    <cfloop from="#main_str#" to="#get_property_variation.recordcount#" index="str">
                                        <cfif get_property_variation.property_id[main_str] eq get_property_variation.property_id[str]>
                                            <option value="#get_property_variation.property_detail_id[str]#" <cfif isdefined('attributes.list_variation_id') and listfind(attributes.list_variation_id,get_property_variation.property_detail_id[str])>selected="selected" style="background-color:##FF9;"</cfif>>#get_property_variation.property_detail[str]#</option>
                                        <cfelse>
                                            <cfbreak>
                                        </cfif>
                                    </cfloop>
                                 </select>
                                <cfset a=a+1>
                            </td>
                        </tr>
                     </table>
                     <div id="information_row#main_str#" <cfif isdefined('attributes.list_variation_id') and listfind(attributes.list_property_id,get_property_variation.property_id[main_str])><cfelse>style="display:none;"</cfif>>
                       <input type="hidden" name="information_select#main_str#" style="width:80px;" id="information_select" value="<cfif isdefined('attributes.list_property_value') and listfind(attributes.list_property_id,get_property_variation.property_id[main_str]) and listgetat(attributes.list_property_value,listfind(attributes.list_property_id,get_property_variation.property_id[main_str]),',') neq 'empty'>#listgetat(attributes.list_property_value,listfind(attributes.list_property_id,get_property_variation.property_id[main_str]),',')#</cfif>" />
                     </div>
            </cfif>
            
        </cfloop>
    </cfoutput>
    </cfif>
</table>
<script type="text/javascript">
	function input_control()
	{  
		row_count=<cfoutput>#get_property_variation.recordcount#</cfoutput>;
		for(r=1;r<=row_count;r++)
		{
			deger_variation_id = eval("document.search_product.variation_id"+r);
			if(deger_variation_id!=undefined && deger_variation_id.value != "")
			{
				deger_property_id = eval("document.search_product.property_id"+r);
				deger_property_value=eval("document.search_product.information_select"+r);
				
				if(search_product.list_property_id.value.length==0) ayirac=''; else ayirac=',';
				search_product.list_property_id.value=search_product.list_property_id.value+ayirac+deger_property_id.value;
				search_product.list_variation_id.value=search_product.list_variation_id.value+ayirac+deger_variation_id.value;
				if(search_product.list_property_value.value.length==0) ayirac=''; else ayirac=',';
				if(deger_property_value.value=='')search_product.list_property_value.value=search_product.list_property_value.value+ayirac+'empty';
				else search_product.list_property_value.value=search_product.list_property_value.value+ayirac+deger_property_value.value;
				
			}
		}
		if(search_product.brand_name.value.length == 0) search_product.brand_id.value = '';
		if(search_product.company.value.length == 0) search_product.company_id.value = '';
		if(search_product.pos_manager.value.length == 0) search_product.pos_code.value = '';
		<cfif not session.ep.our_company_info.unconditional_list>
			if(keyword.value.length==0 && search_product.product_name.value.length == 0 && search_product.barcode.value.length == 0 && search_product.product_code.value.length == 0 && search_product.manufact_code.value.length == 0 && search_product.product_detail.value.length == 0 && search_product.company_product_name.value.length == 0 && search_product.company_stock_code.value.length == 0 && search_product.user_friendly_url.value.length == 0 && search_product.cat.value.length == 0 && search_product.special_code.value.length == 0 &&(search_product.brand_id.value.length == 0 || search_product.brand_name.value.length == 0) && (search_product.pos_code.value.length == 0 || search_product.pos_manager.value.length == 0) && (search_product.company_id.value.length == 0 || search_product.company.value.length == 0) )
			{
				alert("<cf_get_lang dictionary_id='58950.En az bir alanda filtre etmelisiniz'>!");
				return false;
			}		
			else
				return true;
		<cfelse>
		
			return true;
		</cfif>
	}

</script>
