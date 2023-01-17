<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.static_cat_id=-3>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_expense_item_static_cat.cfm">
<cfelse>
	<cfset get_expense_item_sta.recordcount=0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
			<cf_box_search>
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group" id="item-filtre">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
					<cfinput type="text" placeholder="#message#" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3" onKeyUp="isNumber (this)">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.totalrecords" default="#get_expense_item_sta.recordcount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="58551.Gider Kalemi"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_flat_list> 
			<thead>
				<tr> 
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id ='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id ='58551.Gider Kalemi'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.list_expense_item&event=add</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_expense_item_sta.recordcount>
					<cfoutput query="get_expense_item_sta" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<cfset sayac_=1>
						<tr>
							<td height="35">#currentrow#</td>
							<td>
								#EXPENSE_CAT_NAME#
							</td>
							<td>#expense_item_name#</td>
							<td>#expense_item_detail#</td>
							<!-- sil -->
							<td align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_expense_item&event=upd&item_id=#EXPENSE_ITEM_ID#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list> 
			
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#attributes.fuseaction#&keyword=#attributes.keyword#&form_submitted=#attributes.form_submitted#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
