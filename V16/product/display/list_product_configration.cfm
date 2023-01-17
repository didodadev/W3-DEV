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
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_conf.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_form" action="#request.self#?fuseaction=#url.fuseaction#" method="post">
			<input type="hidden" name="is_submit" id="is_submit" value="1"> 
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfoutput>
							<input type="hidden" name="stock_id" maxlength="50" id="stock_id" value="#attributes.stock_id#">
							<input type="text" name="product_name" maxlength="50" id="product_name" value="#attributes.product_name#" placeholder="<cfoutput>#getLang('main',245)#</cfoutput>" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','stock_id','','3','150');">
						</cfoutput>
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&ajax_form=1&field_name=product_name&field_id=stock_id', 'list');" title="<cf_get_lang dictionary_id='37786.Ürün Seç'>"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="is_active" id="is_active">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#?fuseaction=product.list_product_configration&event=add</cfoutput>"><i class="fa fa-plus"></i></a>
				</div>
			</cf_box_search>
		</cfform> 
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='37479.Ürün Konfigürasyonları'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='37499.Konfigürasyon'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='57501.Baslangic'></th>
					<th><cf_get_lang dictionary_id='57502.Bitiş'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#?fuseaction=product.list_product_configration&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>			 
				<cfif get_conf.recordcount>
					<cfoutput query="get_conf" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td>#currentrow#</td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=product.list_product_configration&event=upd&id=#product_configurator_id#','longpage');" class="tableyazi">#configurator_name#</a></td>
							<td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','medium');">#product_name#</a></td>
							<td>#dateformat(start_date,dateformat_style)#</td>
							<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
							<td><cfif is_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<!-- sil -->
							<td width="20"><a href="#request.self#?fuseaction=product.list_product_configration&event=upd&id=#product_configurator_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse> 
					<tr> 
						<td colspan="7"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset adres = url.fuseaction>
		<cfif isdefined ("attributes.keyword") and len(attributes.keyword)>
			<cfset adres = '#adres#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isdefined("attributes.is_active") and len (attributes.is_active)>
			<cfset adres = "#adres#&is_active=#attributes.is_active#">
		</cfif>
		<cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
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
	</cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
</script>
