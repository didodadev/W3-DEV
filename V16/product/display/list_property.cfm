<cfparam name="attributes.our_company" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.product_status" default="">
<cfparam name="attributes.is_web" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
	SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY
</cfquery>
<cfif isdefined("attributes.form_submitted")>	
	<cfscript>
		get_all_property_action=createobject("component","V16.product.cfc.getAllProperty");
		get_all_property_action.DSN1=#DSN1#;
		get_all_property_action.page=attributes.page;
		get_all_property_action.maxrows=attributes.maxrows;
		getAllProperty=get_all_property_action.getAllProperty(keyword:attributes.keyword,our_company:attributes.our_company,is_active:attributes.product_status,is_web:attributes.is_web);
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
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_product" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="our_company" id="our_company">
						<option value=""><cf_get_lang dictionary_id='29531.Şirketler'></option>
						<cfoutput query="get_our_company">
							<option value="#comp_id#" <cfif attributes.our_company eq comp_id>selected</cfif>>#nick_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="product_status" id="product_status">
						<option value="1"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="2"<cfif isDefined("attributes.product_status") and (attributes.product_status eq 2)> selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="is_web" id="is_web">
						<option value="1"<cfif attributes.is_web eq 1> selected</cfif>><cf_get_lang dictionary_id='37161.Web de Göster'></option>
						<option value="0"<cfif attributes.is_web eq 0> selected</cfif>><cf_get_lang dictionary_id='64297.Web de Gösterme'></option>
						<option value="2"<cfif attributes.is_web eq 2 or not len(attributes.is_web)> selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.list_property&event=add</cfoutput>');"><i class="fa fa-plus"></i></a>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='58910.Ürün Özellikleri'></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sira'></th>
					<th><cf_get_lang dictionary_id='57789.Özel Kodu'></th>
					<th><cf_get_lang dictionary_id='57632.Özellik'></th>
					<th><cf_get_lang dictionary_id='37258.Varyasyonlar'></th>
					<th></th>
					<!-- sil -->
					<th class="header_icn_none" width="20"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.list_property&event=add</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif getAllProperty.recordcount>		 
					<cfoutput query="getAllProperty">
						<tr>
							<td>#rownum#</td>
							<td>#getAllProperty.property_code#</td>
							<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.list_property&event=upd&prpt_id=#getAllProperty.property_ID#');" class="tableyazi">#getAllProperty.property#</a></td>
							<td>
								<cfquery name="GET_ALL_PROPERTY_DETAIL_ROW" dbtype="query" maxrows="10">
									SELECT * FROM GET_ALL_PROPERTY_DETAIL WHERE PRPT_ID = #getAllProperty.property_id#
								</cfquery>
								<cfloop query="Get_All_Property_Detail_row">#property_detail#<cfif not currentrow eq recordcount>,<br/></cfif></cfloop><br>
								<cfif getAllProperty.count_property_id gt 10 >
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.list_property&event=add-sub-property&prpt_id=#getAllProperty.property_ID#');" class="tableyazi"><cf_get_lang dictionary_id='58829.Kayıt Sayısı'> : #getAllProperty.count_property_id#</a>
								</cfif>
							</td>
							<!-- sil -->
							<td width="20"><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.list_property&event=add-sub-property&prpt_id=#getAllProperty.property_ID#');"><i class="fa fa-list-ol" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
							<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.list_property&event=upd&prpt_id=#getAllProperty.property_ID#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='36457.Özellik Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr> 
						<td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset adres = url.fuseaction>
		<cfif isdefined ("attributes.keyword") and len(attributes.keyword)>
			<cfset adres = '#adres#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isdefined ("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset adres = '#adres#&form_submitted=#attributes.form_submitted#'>
		</cfif>
		<cfif isDefined('attributes.our_company') and len(attributes.our_company)>
			<cfset adres = "#adres#&our_company=#attributes.our_company#">
		</cfif>
		<cfif isDefined('attributes.product_status') and len(attributes.product_status)>
		<cfset adres = '#adres#&product_status=#attributes.product_status#'>
		</cfif>
		<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
			<cfset adres = '#adres#&draggable=#attributes.draggable#'>
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
