<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_upper_cat" default="1">
<cfquery name="GET_INVENTORY_CATS" datasource="#dsn3#">
	SELECT
		*
	FROM
		SETUP_INVENTORY_CAT
	<cfif len(attributes.keyword)>
	WHERE
		INVENTORY_CAT LIKE '%#attributes.keyword#%'
		OR
		HIERARCHY LIKE '%#attributes.keyword#%'
	</cfif> 
	ORDER BY
		HIERARCHY
</cfquery>
<cfset url_string = "form_submitted=1">
<cfif isdefined("field_id")>
	<cfset url_string = "#url_string#&field_id=#field_id#">
</cfif>
<cfif isdefined("field_name")>
	<cfset url_string = "#url_string#&field_name=#field_name#">
</cfif>
<cfif isdefined("is_budget_items")>
	<cfset url_string = "#url_string#&is_budget_items=#is_budget_items#">
</cfif>
<cfif isdefined("is_income")>
	<cfset url_string = "#url_string#&is_income=#is_income#">
</cfif>
<cfif isdefined("field_account_no")>
	<cfset url_string = "#url_string#&field_account_no=#field_account_no#">
</cfif>
<cfif isdefined("field_account_no2")>
	<cfset url_string = "#url_string#&field_account_no2=#field_account_no2#">
</cfif>
<cfif isdefined("field_inventory_duration")>
	<cfset url_string = "#url_string#&field_inventory_duration=#field_inventory_duration#">
</cfif>
<cfif isdefined("field_amortization_rate")>
	<cfset url_string = "#url_string#&field_amortization_rate=#field_amortization_rate#">
</cfif>
<cfif len(attributes.is_upper_cat)>
	<cfset url_string = "#url_string#&is_upper_cat=#attributes.is_upper_cat#">
</cfif>
<cfparam name="attributes.totalrecords" default="#get_inventory_cats.recordcount#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Sabit Kıymet Kategorileri',34247)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform method="post" name="inv_cat" action="#request.self#?fuseaction=objects.popup_list_inventory_cat&#url_string#">
		<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<cf_box_search>
			<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
			<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
			<cfif isDefined("attributes.field_account_no")>
				<input type="hidden" name="field_account_no" id="field_account_no" value="<cfoutput>#attributes.field_account_no#</cfoutput>">
				</cfif>
			<div class="form-group">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('inv_cat' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>  
	<cf_grid_list>
		<thead>
			<tr>		
				<th width="35"><cf_get_lang dictionary_id='57487.no'></th>
				<th><cf_get_lang dictionary_id='32775.Kategori Kodu'></th>
				<th><cf_get_lang dictionary_id='34248.Sabit Kıymet Kategorisi'></th>
				<th><cf_get_lang dictionary_id='34249.Faydalı Ömür'></th>
				<th><cf_get_lang dictionary_id='34250.Amortisman Oranı'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_inventory_cats.recordcount>
				<cfoutput query="get_inventory_cats" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">		
					<tr>
						<td>#currentrow#</td>
						<td>#hierarchy#</td>
						<td id="is_inventory" title="#detail#">
							<cfloop from="1" to="#listlen(hierarchy,'.')#" index="i">&nbsp;&nbsp;</cfloop>
							<cfif listlen(hierarchy,'.') eq 1>
								<cfquery name="get_sub_hierarchy" datasource="#dsn3#">
									SELECT HIERARCHY FROM SETUP_INVENTORY_CAT WHERE HIERARCHY LIKE '#get_inventory_cats.hierarchy#.%'
								</cfquery>
							</cfif>
							<cfif (attributes.is_upper_cat lt listlen(hierarchy,'.')) or (isdefined("get_sub_hierarchy") and get_sub_hierarchy.recordcount eq 0)>
								<a href="javascript://" onClick="gonder('#inventory_cat_id#','#inventory_cat#','#inventory_duration#','#amortization_rate#')">#inventory_cat#</a>
							<cfelse>
								#inventory_cat#
							</cfif>
						</td>
						<td class="text-right">#TLFormat(inventory_duration)#</td>
						<td class="text-right">#TLFormat(amortization_rate)#</td>
					</tr>		
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="5"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif attributes.maxrows lt attributes.totalrecords and isdefined("attributes.form_submitted")>
		<cfif len(attributes.keyword)>
			<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects.popup_list_inventory_cat&#url_string#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<script type="text/javascript">
document.getElementById('keyword').focus();
function gonder(id,name,duration,rate)
{
	<cfoutput>
		<cfif isDefined("attributes.field_id")>
			<cfif listlen(attributes.field_id,".") eq 1>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#attributes.field_id#').value=id; 
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value=id;
			</cfif>
		</cfif>
		<cfif isDefined("attributes.field_name")>
			<cfif listlen(attributes.field_name,".") eq 1>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#attributes.field_name#').value=name;
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=name;
			</cfif>
		</cfif>
		<cfif isDefined("attributes.field_inventory_duration")>
			<cfif listlen(attributes.field_inventory_duration,".") eq 1>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#attributes.field_inventory_duration#').value=commaSplit(duration);
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_inventory_duration#</cfoutput>.value=commaSplit(duration);
			</cfif>
		</cfif>
		<cfif isDefined("attributes.field_amortization_rate")>
			<cfif listlen(attributes.field_amortization_rate,".") eq 1>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('#attributes.field_amortization_rate#').value=commaSplit(rate);
			<cfelse>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_amortization_rate#</cfoutput>.value=commaSplit(rate);
			</cfif>
		</cfif>
	</cfoutput>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
