<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.is_sub_category" default="0">
<cfinclude template="../query/get_care_cat.cfm">
<cfset url_string = "">
 <cfif isdefined("attributes.product_catid")>
	<cfset url_string = "#url_string#&product_catid=#attributes.product_catid#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_code")>
	<cfset url_string = "#url_string#&field_code=#attributes.field_code#">
</cfif>
<cfif isdefined("attributes.is_sub_category")>
	<cfset url_string = "#url_string#&is_sub_category=#attributes.is_sub_category#">
</cfif>
<cfif isdefined("attributes.is_select")>
	<cfset url_string = "#url_string#&is_select=#attributes.is_select#">
</cfif>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default=#get_care_cat.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='33672.Bakım KAtegorileri'></cfsavecontent>
	<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		</cfif> 
		<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
			<cfset url_string = '#url_string#&draggable=#attributes.draggable#'>
		</cfif>
		<cfform name="search_care_cat" method="post" action="#request.self#?fuseaction=objects.popup_care_cat_names">
			<cf_box_search more="0">
				<cfif isdefined("attributes.product_catid")>
					<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
				</cfif>
				<cfif isdefined("attributes.field_id")>
					<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
				</cfif>
				<cfif isdefined("attributes.field_name")>
					<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
				</cfif>
				<cfif isdefined("attributes.field_code")>
					<input type="hidden" name="field_code" id="field_code" value="<cfoutput>#attributes.field_code#</cfoutput>">
				</cfif>
				<cfif isdefined("attributes.is_sub_category")>
					<input type="hidden" name="is_sub_category" id="is_sub_category" value="<cfoutput>#attributes.is_sub_category#</cfoutput>">
				</cfif>
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="Filtre"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="Text" name="keyword" maxlength="50" value="#attributes.keyword#" title="Filtre">
				</div>
				<div class="form-group" id="item-maxrows">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group" id="item-button">
					<cf_wrk_search_button  button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_care_cat' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search> 
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th width="100"><cf_get_lang dictionary_id='58585.Kod'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_care_cat.recordcount>
					<cfoutput query="get_care_cat" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<cfset cont="#HIERARCHY#">
						<cfset pro_cont=care_cat>
						<cfset rm = '#chr(13)#'>
						<cfset cont = ReplaceList(cont,rm,'')>
						<cfset pro_cont = ReplaceList(pro_cont,rm,'')>
						<cfset rm = '#chr(10)#'>
						<cfset cont = ReplaceList(cont,rm,'')>
						<cfset pro_cont = ReplaceList(pro_cont,rm,'')>
						<cfset pro_cont = ReplaceList(pro_cont,"'",' ')>

						<cfif IS_SUB_CARE_CAT is 0>
							<td><a href="javascript://" class="tableyazi" onclick="gonder('#care_cat_id#','#hierarchy# #pro_cont#','#hierarchy#');">#hierarchy#</a></td>
							<td><cfloop from="1" to="#listlen(hierarchy,'.')#" index="i">&nbsp;</cfloop><a href="javascript://" class="tableyazi" onclick="gonder('#care_cat_id#','#cont# #pro_cont#','#cont#');">#care_cat#</a></td>
						<cfelse>
							<td><cfif attributes.is_sub_category lte listlen(hierarchy,'.') and attributes.is_sub_category neq 0>
							<a href="javascript://" class="tableyazi" onclick="gonder('#care_cat_id#','#hierarchy# #pro_cont#','#hierarchy#');">#hierarchy#</a>
								<cfelse>
								#hierarchy#
								</cfif></td>
							<td><cfloop from="1" to="#listlen(hierarchy,'.')#" index="i">&nbsp;</cfloop>					
								<cfif attributes.is_sub_category lte listlen(hierarchy,'.')  and attributes.is_sub_category neq 0>
									<a href="javascript://" class="tableyazi" onclick="gonder('#care_cat_id#','#hierarchy# #pro_cont#','#hierarchy#');">#product_cat#</a>
								<cfelse>
								#care_cat#
								</cfif></td>
						</cfif>
					</tr>
					</cfoutput>
				<cfelse>
				<tr>
					<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<br/>
				</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<table cellpadding="2" cellspacing="0" border="0" width="99%" align="center">
				<tr height="2" >
					<td><cf_pages page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="objects.popup_care_cat_names&#url_string#">
					</td>
					<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
				</tr>
			</table>
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	function gonder(p_cat_id,p_cat,p_cat_code)
	{
		<cfoutput>
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#attributes.field_id#.value = p_cat_id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#attributes.field_name#.value = p_cat;
		</cfif>
		<cfif isdefined("attributes.field_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#attributes.field_code#.value = p_cat_code;
		</cfif>
		<cfif isdefined("attributes.is_select")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.calistir();
		</cfif>
		</cfoutput>
		<cfif isdefined("attributes.process") and attributes.process is "purchase_contract">
			opener.form_basket.submit();
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}		
</script>
