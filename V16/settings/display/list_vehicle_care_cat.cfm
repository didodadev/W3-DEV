 <cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfset sayfa_ad = "list_vehicle_care_cat">
<cfinclude template="../query/get_care_cat.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.totalrecords" default=#get_care_cat.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_care" method="post" action="#request.self#?fuseaction=settings.list_vehicle_care_cat" >  
			<cfinput type="hidden" name="is_form_submitted" value="1">   
			<cf_box_search more="0">
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('','Filtre','57460')#" maxlength="50" value="#attributes.keyword#">
				</div>
				<div class="form-group">
                    <select name="cat" id="cat">
                     <option value="" selected><cf_get_lang dictionary_id='29536.Tüm Kategoriler'></option>
                        <cfoutput query="get_care_cat">
                            <option value="#hierarchy#" <cfif isDefined("attributes.cat") and attributes.cat is hierarchy and len(attributes.cat) eq len(hierarchy)>selected</cfif>>#hierarchy#-#care_cat#</option>
                        </cfoutput>
                    </select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
				<div class="form-group" id="item-add-button">
					<a href="javascript://" class="ui-btn ui-btn-gray" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=settings.popup_form_add_care_cat</cfoutput>','','ui-draggable-box-medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                </div>
			</cf_box_search>
		</cfform>
	</cf_box>
      <!--- Bakım Kategorileri --->
	<cf_box title="#getLang('','Bakım Kategorileri','42903')#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="25"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th width="105"><cf_get_lang dictionary_id='58585.Kod'></th>
					<th class="form-title"><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th class="header_icn_none"></th>
					<th class="header_icn_none"><a href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=settings.popup_form_add_care_cat</cfoutput>','','ui-draggable-box-medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='43379.Bakım Kategorisi Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_care_cat.recordcount and form_varmi eq 1>
					<cfoutput query="get_care_cat" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</a></td>
							<td>#hierarchy#</td>
							<td><cfloop from="1" to="#listlen(hierarchy,'.')#" index="i"></cfloop><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_form_upd_care_cat&id=#care_cat_id#','ui-draggable-box-medium');">#care_cat#</a></td>                   
							<td width="20" class="header_icn_none"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_form_upd_care_cat&id=#care_cat_id#','ui-draggable-box-medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='43387.Bakım Kategorisi Güncelle'>"></i></a></td><!-- sil -->
							<td width="20" class="header_icn_none"><a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_form_add_care_cat&ust_cat=#hierarchy#');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='42929.Alt Bakım Kategorisi Ekle'>"></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="5"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
<cfset adres = attributes.fuseaction>
<cfif isDefined('attributes.cat') and len(attributes.cat)>
	<cfset adres = "#adres#&cat=#attributes.cat#">
</cfif>
<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfset adres = "#adres#&is_form_submitted=1">
<cf_paging 
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#adres#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
<!-- sil -->
