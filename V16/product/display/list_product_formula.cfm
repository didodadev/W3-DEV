<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_name" default="">
<cfif isdefined("attributes.is_submit")>
    <cfquery name="get_conf" datasource="#dsn3#">
        SELECT 
            SETUP_PRODUCT_FORMULA.*,
            S.STOCK_ID,
            S.PRODUCT_ID,
            S.PRODUCT_NAME
        FROM 
            SETUP_PRODUCT_FORMULA,
            STOCKS S
        WHERE
        	S.STOCK_ID = FORMULA_STOCK_ID
            <cfif len(attributes.keyword)> AND SETUP_PRODUCT_FORMULA.FORMULA_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
            <cfif len(attributes.is_active)>AND SETUP_PRODUCT_FORMULA.IS_ACTIVE = #attributes.is_active#</cfif>
            <cfif len(attributes.product_name) and len(attributes.stock_id)>
				AND FORMULA_STOCK_ID = #attributes.stock_id#
			</cfif>
        ORDER BY
            SETUP_PRODUCT_FORMULA.FORMULA_NAME
    </cfquery>
<cfelse>
	<cfset get_conf.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_conf.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_form" action="#request.self#?fuseaction=#url.fuseaction#" method="post">
<input type="hidden" name="is_submit" id="is_submit" value="1">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37051.Formüller'></cfsavecontent>
<cf_big_list_search title="#message#"> 
	<cf_big_list_search_area>
		<table>
			<tr>
				<td><cf_get_lang dictionary_id='57460.Filtre'></td>
				<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
				<td><cf_get_lang dictionary_id ='57657.Product'></td>
				<td>
					<cfoutput>
					<input type="hidden" name="stock_id" id="stock_id" value="#attributes.stock_id#">
					<input type="text" name="product_name" id="product_name" value="#attributes.product_name#" style="width:150px;" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','stock_id','','3','150');">
					</cfoutput>
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&ajax_form=1&field_name=product_name&field_id=stock_id', 'list');"><img src="/images/plus_thin.gif" align="absbottom" title="<cf_get_lang dictionary_id='37786.Ürün Seç'>"></a>
				</td>
				<td align="right" style="text-align:right;">
					<select name="is_active" id="is_active">
					<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
					<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
					<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
					</select>
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
				<td><cf_wrk_search_button></td>
			</tr>
		</table>  
	</cf_big_list_search_area>
</cf_big_list_search> 
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='58028.Formul'></th>
			<th width="200"><cf_get_lang dictionary_id='57657.Urun'></th>
			<th width="35"><cf_get_lang dictionary_id='57756.Durum'></th>
			<!-- sil -->
            <th class="header_icn_none"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=product.popup_add_product_formula</cfoutput>','longpage');"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th>
			<!-- sil -->
        </tr>
	</thead>
	<tbody>			 
		<cfif get_conf.recordcount>
			<cfoutput query="get_conf" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
			<tr>
				<td>#currentrow#</td>
				<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=product.popup_upd_product_formula&id=#product_formula_id#','longpage');" class="tableyazi">#formula_name#</a></td>
				<td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','medium');">#product_name#</a></td>
				<td><cfif is_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
				<!-- sil -->
                <td width="10"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=product.popup_upd_product_formula&id=#product_formula_id#','longpage');"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a></td>
				<!-- sil -->
			</tr>
			</cfoutput>
		<cfelse> 
			<tr> 
				<td colspan="5"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
	<cfset adres = url.fuseaction>
    <cfif isdefined ("attributes.keyword") and len(attributes.keyword)>
    <cfset adres = '#adres#&keyword=#attributes.keyword#'>
    </cfif>
    <cfif isdefined("attributes.is_active") and len (attributes.is_active)>
    <cfset adres = "#adres#&is_active=#attributes.is_active#">
    </cfif>
    <cfif isdefined ("attributes.is_submit") and len(attributes.is_submit)>
    <cfset adres = "#adres#&is_submit=#attributes.is_submit#">
    </cfif>
    <cfif isdefined ("attributes.product_name") and len(attributes.product_name)>
    <cfset adres = "#adres#&product_name=#attributes.product_name#">
    </cfif>
    <cfif isdefined ("attributes.stock_id") and len(attributes.stock_id)>
    <cfset adres = "#adres#&stock_id=#attributes.stock_id#">
    </cfif>
        <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#adres#">
<script type="text/javascript">
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
</script>
