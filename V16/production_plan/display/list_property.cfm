<cfparam name="attributes.keyword" default="">
<cfif isdefined("form_submitted")>
	<cfquery name="GET_PROPERTY_CAT" datasource="#DSN1#">
			SELECT * FROM PRODUCT_PROPERTY
			 WHERE 
			 1= 1
			 <cfif len(attributes.keyword)>
				AND PROPERTY LIKE <cfqueryparam value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			</cfif>
			 ORDER BY PROPERTY
	</cfquery>
<cfelse>
	<cfset GET_PROPERTY_CAT.recordcount = 0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_property_cat.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.currency" default="">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_asset" method="post" action="#request.self#?fuseaction=prod.list_property">
			<input type="hidden" name="form_submitted" id="form_submitted" value="0">
			<cf_box_search>
				<div class="form-group" id="item-form_ul_keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
				</div>
				<div class="form-group small" id="item-maxrows">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='kontrol()'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='59318.Üretim Özellikleri'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="50"><cf_get_lang dictionary_id='57632.Özellik'></th>
					<th><cf_get_lang dictionary_id='36637.Varyasyonlar'></th>
					<th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.list_property&event=add');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='36639.Özellik Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
			<cfif get_property_cat.recordcount>
				<cfoutput query="get_property_cat" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
					<tr>
						<td nowrap="nowrap"><a href="javascript://" class="tableyazi" onClick="openBoxDraggable('#request.self#?fuseaction=prod.list_property&event=upd&prpt_id=#get_property_cat.property_ID#')">#get_property_cat.property#</a></td>
						<td>
							<cfset attributes.PRPT_ID = get_property_cat.property_ID>
							<cfinclude template="../query/get_property_detail_1.cfm">
							<cfloop query="get_property_detail">
								#property_detail#,
							</cfloop>
						</td>
						<td style="text-align:center;"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=prod.list_property&event=padd&prpt_id=#get_property_cat.property_ID#&property=#get_property_cat.property#');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='36638.Varyasyon Ekle'>"></i></a></td>
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td height="22" colspan="3"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>

		<cfset adres = url.fuseaction>
		<cfif len(attributes.keyword)>
		<cfset adres = '#adres#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif get_property_cat.recordcount and (attributes.maxrows lt attributes.totalrecords)>
			<cf_paging page="#attributes.page#" 
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="#adres#&form_submitted=1">
		</cfif>
	</cf_box>
</div>

<script type="text/javascript">
	function kontrol(){
		return true;
	}
</script>