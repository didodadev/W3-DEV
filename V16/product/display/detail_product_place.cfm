<!---
	Bir urune ait lokasyon ve raf bilgileri listelenir.
	pid product_id yani urunun id si arzu
--->
<cfparam name="attributes.place_status" default="">

<cfinclude template="../query/get_stores.cfm">
<cfinclude template="../query/get_shelves.cfm">
<cfinclude template="../query/get_product_place.cfm">

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_product_place.recordcount#'>
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="head">
	<cfif isDefined("attributes.pid")>
		<cfinclude template="../query/get_product_name.cfm"><span class="bold"><cf_get_lang dictionary_id='57657.Ürün'>: </span>
		<a target="_blank" href="<cfoutput>#request.self#?fuseaction=product.list_product&event=det&pid=#attributes.pid#</cfoutput>"><cfoutput>#get_product_name.product_name#</cfoutput></a>
	</cfif>
</cfsavecontent>

<cf_box title="#getLang('','Ürün Raf Detay Bilgileri',37106)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" add_href="javascript:openBoxDraggable('#request.self#?fuseaction=stock.list_shelves&event=add&pid=#attributes.pid#&popup_page=1','','ui-draggable-box-medium');">
	<cfform name="search_product_place" action="#request.self#?fuseaction=product.detail_product_place&pid=#attributes.pid#&popup_page=1" method="post">
		<cf_box_search more="0">
			<div class="form-group">
				<select name="store" id="store">
					<option  value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_stores">
						<option value="#department_id#" <cfif isDefined("attributes.store") and attributes.store eq department_id> Selected</cfif> >#department_head#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group">
				<select name="shelf_type" id="shelf_type">
					<option value="" ><cf_get_lang dictionary_id='57630.Tip'></option>
					<cfoutput query="get_shelves">
						<option value="#shelf_id#" <cfif isDefined("attributes.shelf_type") and (attributes.shelf_type eq shelf_id)>selected</cfif>>#shelf_name#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group">
				<select name="place_status" id="place_status">
					<option value="1"<cfif isDefined("attributes.place_status") and (attributes.place_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					<option value="0"<cfif isDefined("attributes.place_status") and (attributes.place_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					<option value=""<cfif isDefined("attributes.place_status") and not len(attributes.place_status)> selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
				</select>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_product_place' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<div class="ui-card">
		<div class="ui-card-item">
			<p><cfoutput>#head#</cfoutput> </p>
		</div>
	</div>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang dictionary_id='37540.Raf Kodu'></th>
				<th><cf_get_lang dictionary_id='37110.Raf Tipi'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
				<th><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></th>
				<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
				<th><cf_get_lang dictionary_id='57756.Durum'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_product_place.recordcount>
			<cfoutput query="get_product_place" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfinclude template="../query/get_store_location.cfm">
					<tr>
						<td>#currentrow#</td>
						<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=stock.list_shelves&event=upd&product_place_id=#product_place_id#','','ui-draggable-box-medium');">#shelf_code#</a></td>
						<td>#shelf_name#</td>
						<td class="text-right"><cfif isDefined("attributes.pid") and len(attributes.pid)>#amount#<cfelse>#quantity#</cfif></td>
						<td>#get_location_info(get_product_place.store_id,get_product_place.location_id,1)#</td>
						<td>#dateformat(start_date,dateformat_style)#</td>
						<td>#dateformat(finish_date,dateformat_style)#</td>
						<td><cfif place_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
					</tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody> 
	</cf_grid_list>
	<cfset adres = "product.detail_product_place&pid=" & attributes.pid >
	<cfif isDefined('attributes.cat') and len(attributes.cat)>
		<cfset adres = adres & "&cat=" & attributes.cat>
	</cfif>
	<cfif len(attributes.place_status)>
		<cfset adres = '#adres#&place_status=#attributes.place_status#'>
	</cfif>				
	<cf_paging 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#adres#">
</cf_box>
