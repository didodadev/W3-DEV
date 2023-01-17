<cfparam name="attributes.keyword" default=''>

<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_project_inventory" datasource="#dsn3#">
    	SELECT
        	*
        FROM 
        	SETUP_PRODUCT_XML_DEFINITION
	<cfif len(attributes.keyword)>
        WHERE
        	XML_DEFINITION_NAME =  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
    </cfif>
    	ORDER BY
        	XML_DEFINITION_NAME
    </cfquery>
<cfelse>
	<cfset get_project_inventory.recordcount = 0>
</cfif>
<cfset curr_year = dateformat(now(),"yyyy")>
<cfform name="search_asset" method="post" action="#request.self#?fuseaction=settings.list_product_xml_definition">
<cf_big_list_search title="Çoklu Ürün XML Tanımları"> 
	<cf_big_list_search_area>
    	<cfoutput>
		<table>
			<tr>
            	<input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <td style="text-align:right";><cf_get_lang dictionary_id='57460.Filtre'>
            	<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
                </td>
                <td><cf_wrk_search_button search_function='kontrol()'></td>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			</tr>
		</table>
        </cfoutput>
	</cf_big_list_search_area>	
</cf_big_list_search> 
</cfform> 
<cf_big_list>
	<thead> 
		<tr>
        	<th width="10px"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='60262.XML Tanım Adı'></th>
			<!-- sil --><th class="header_icn_none"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_add_product_xml_definition','list','popup_add_product_xml_definition');"><img src="/images/plus_list.gif" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th><!-- sil -->
    	</tr>
	</thead>
	<tbody>
		<cfif get_project_inventory.recordcount>
			<cfoutput query="get_project_inventory">
				<tr>
					<td width="10px">#currentrow#</td>
					<td>#xml_definition_name#</td>
					<!-- sil --><td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_upd_product_xml_definition&id=#xml_definition_id#','list','popup_upd_product_xml_definition');"><img src="/images/update_list.gif" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a></td><!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td height="21" colspan="3"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
