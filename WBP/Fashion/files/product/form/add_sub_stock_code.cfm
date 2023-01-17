<cf_xml_page_edit fuseact="product.form_add_product">
	<cfparam name="attributes.property_color_id" default="">
	<cfparam name="attributes.property_size_id" default="">
	
	<cfparam name="attributes.beden_id" default="">
	<cfparam name="attributes.renk_id" default="">
	<cfparam name="attributes.all_properties" default="">
	<!--- Urun Ozelliklerini Getirir  --->
	<!--- Guncellemede, kategoriye yeni bir ozellik eklendiginde buraya gelmiyordu, bu sekilde , olmayanlarin gelmesi seklinde unionli bir duzenleme yapilmis--->
	<cfquery name="get_property" datasource="#dsn1#">
		SELECT 
			PRODUCT_PROPERTY.PROPERTY_ID,
			PRODUCT_PROPERTY.PROPERTY,
			PRODUCT_PROPERTY.PROPERTY_SIZE,
			PRODUCT_PROPERTY.PROPERTY_COLOR
		FROM 
			PRODUCT_CAT_PROPERTY,
			PRODUCT_PROPERTY,
			PRODUCT AS PRODUCT
		WHERE 
			PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_CAT_PROPERTY.PROPERTY_ID AND
			PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = PRODUCT.PRODUCT_CATID AND
			PRODUCT.PRODUCT_ID = #attributes.pid#
		UNION
		SELECT 
			PRODUCT_DT_PROPERTIES.PROPERTY_ID,
			PRODUCT_PROPERTY.PROPERTY,
			PRODUCT_PROPERTY.PROPERTY_SIZE,
			PRODUCT_PROPERTY.PROPERTY_COLOR
		FROM 
			PRODUCT_DT_PROPERTIES,
			PRODUCT_PROPERTY
		WHERE
			PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
			PRODUCT_DT_PROPERTIES.PRODUCT_ID = #attributes.pid#
	</cfquery>
	 <cfquery name="get_property_id" datasource="#dsn1#">
		SELECT PROPERTY_ID FROM PRODUCT_DT_PROPERTIES WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfquery> 
	<cfset property_id_list = valuelist(get_property_id.property_id,',')>
	<cfquery dbtype="query" name="get_color_property">
		SELECT PROPERTY_ID,PROPERTY FROM get_property WHERE PROPERTY_COLOR = 1
	</cfquery>
	<cfquery dbtype="query" name="get_size_property">
		SELECT PROPERTY_ID,PROPERTY FROM get_property WHERE PROPERTY_SIZE = 1
	</cfquery>
	
	<cfif not get_color_property.recordcount or not get_size_property.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no='1002.Ürün Renk ve Beden Özelliklerini Giriniz !'> !");
			window.close();
		</script>
		<cfabort>
	</cfif>
	
	<cfquery name="get_color_property_dett" datasource="#dsn1#"> 
		SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL,PRPT_ID FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = <cfif isdefined('attributes.property_color_id') and len(attributes.property_color_id)>#attributes.property_color_id#<cfelse>#get_color_property.property_id#</cfif>
		
	</cfquery>
	<cfquery name="get_size_property_dett" datasource="#dsn1#">
		SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL,PRPT_ID FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = <cfif isdefined('attributes.property_size_id') and len(attributes.property_size_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_size_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_size_property.property_id#"></cfif> 		
	</cfquery>
	
	
	<cfquery name="get_color_property_det" dbtype="query"> 
		SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM get_color_property_dett WHERE PRPT_ID = <cfif isdefined('attributes.property_color_id') and len(attributes.property_color_id)>#attributes.property_color_id#<cfelse>#get_color_property.property_id#</cfif>
		<cfif len(attributes.renk_id)> AND PROPERTY_DETAIL_ID IN(#attributes.renk_id#)</cfif>
	</cfquery>
	<cfquery name="get_size_property_det" dbtype="query">
		SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM get_size_property_dett WHERE PRPT_ID = <cfif isdefined('attributes.property_size_id') and len(attributes.property_size_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_size_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_size_property.property_id#"></cfif> 
			<cfif len(attributes.beden_id)> AND PROPERTY_DETAIL_ID IN(#attributes.beden_id#)</cfif>
	</cfquery>
	
	<!--- Urun Ozelliklerini Getirir  --->
<cfform name="search" method="post" action="#request.self#?fuseaction=textile.form_add_popup_sub_stock_code">
<cf_medium_list_search title="Asorti"><!---Asorti--->
    <cf_medium_list_search_area>
        <table>
            <input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
            <input type="hidden" name="pcode" id="pcode" value="<cfoutput>#attributes.pcode#</cfoutput>"> 
            <tr>
				<td>
						<select name="beden_id" multiple id="beden_id" style="width:150px;height:100px;">
							<option value="">Beden Seçiniz</option>
                        <cfoutput query="get_size_property_dett">	
                            <option value="#property_detail_id#" <cfif len(attributes.beden_id) and ListFind(attributes.beden_id,property_detail_id)>selected</cfif>>#property_detail#</option>
                        </cfoutput>
                    </select>
				</td>
				<td>
						<select name="renk_id" multiple id="renk_id" style="width:150px;height:100px;">
							<option value="">Renk Seçiniz</option>
                        <cfoutput query="get_color_property_dett">	
                            <option value="#property_detail_id#" <cfif len(attributes.renk_id) and ListFind(attributes.renk_id,property_detail_id)>selected</cfif>>#property_detail#</option>
                        </cfoutput>
                    </select>
				</td>
                <td valign="top"><select name="property_color_id" id="property_color_id" style="width:100px;">
                        <cfoutput query="get_color_property">	
                            <option value="#property_id#" <cfif property_id eq attributes.property_color_id>selected</cfif>>#property#</option>
                        </cfoutput>
                    </select>
                </td>
                <td valign="top"><select name="property_size_id" id="property_size_id" style="width:100px;">
                        <cfoutput query="get_size_property">	
                            <option value="#property_id#"  <cfif property_id eq attributes.property_size_id>selected</cfif>>#property#</option>
                        </cfoutput>
                    </select>
                </td>
                 <td valign="top">
                    <input type="submit" name="gonder" id="gonder" value="Çalıştır">
					
                </td>  
            </tr>
        </table>
    </cf_medium_list_search_area>
</cf_medium_list_search>
</cfform>

<cfform name="search_" method="post" action="#request.self#?fuseaction=textile.emptypopup_add_sub_stock_code&product_id=#attributes.pid#&pcode=#attributes.pcode#&size_detail_id=#get_size_property.property_id#&color_detail_id=#get_color_property.property_id#">
<cf_medium_list>
		<!--- Olusan toplam checkbox sayisi(size*color), hepsini sec icin kullanilir--->
		<cfset cartesian_ = get_color_property_det.recordcount * get_size_property_det.recordcount>
		<input type="hidden" name="cartesian" id="cartesian" value="<cfoutput>#cartesian_#</cfoutput>">
		<!--- //Olusan toplam checkbox sayisi(size*color), hepsini sec icin kullanilir --->
		<cfset colspan = 1>
		<thead>
            <tr>
                <th align="center">Beden/Renk</th>
                <cfoutput query="get_color_property_det">
                    <th align="center">#property_detail#</th>
                    <cfset colspan = colspan + 1>
                </cfoutput>
            </tr>
        </thead>
		<!--- ilgili urunun kayitli tum ozelliklerini getirir, listeler --->
		<cfquery name="get_all_product_propert" datasource="#dsn3#">
			SELECT * FROM STOCKS WHERE PRODUCT_ID = #attributes.pid# ORDER BY RECORD_DATE DESC
		</cfquery>
		<cfset product_property_list = valuelist(get_all_product_propert.property,',')>
		<!--- //ilgili urunun kayitli tum ozelliklerini getirir, listeler --->
        <tbody>
		
		<cfoutput query="get_size_property_det">
			<tr  >
				<td align="center" >#property_detail#</td>
				
				<cfloop query="get_color_property_det">
					<!--- urunun ozelligini size-color olarak birlestirir, cunku value degeri size-color id seklinde atanir --->
                    <cfset pro = get_color_property_det.PROPERTY_DETAIL>
                    <cfset pro = listappend(pro,get_size_property_det.PROPERTY_DETAIL,'-')>
				
                    <!--- //urunun ozelligini size-color olarak birlestirir, cunku value degeri size-color id seklinde atanir --->
                    <td align="center"  ><input type="checkbox" name="assortment" id="assortment" value="#get_color_property_det.property_detail_id#-#get_size_property_det.property_detail_id#" <cfif listfind(product_property_list,pro)>checked disabled</cfif>></td>
				</cfloop>
			</tr>
		</cfoutput>
		
        </tbody>
        <tfoot>
            <tr>
                <td colspan="<cfoutput>#colspan#</cfoutput>">
                    <input type="checkbox" name="all_properties" id="all_properties" value="1" onClick="hepsini_sec_main();">Hepsini Seç&nbsp;
						<cfsavecontent variable="message">Kaydet</cfsavecontent>
						<div style="float:right;"><button class="btn btn-primary" name="btnkaydet">Kaydet</button></div>
                	   <!--- <cf_workcube_buttons is_upd='0'  insert_info='#message#' type_format='1'>--->
                </td>
            </tr>
        </tfoot>
</cf_medium_list>
</cfform>
<script type="text/javascript">
	function hepsini_sec_main()
	{
		if (document.search_.all_properties.checked)
		{	
			for(var say=1;say<=document.search_.cartesian.value;say++)
			{
				m = say - 1;
				var check = eval('search_.assortment['+m+']');
				if (check.checked == false)
					check.checked = true;
			}
			
		}
		else
		{
			for(var say=0;say<document.search_.cartesian.value;say++)
				document.search_.assortment[say].checked = false;
		}
		return false;
	}
</script>
