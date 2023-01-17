<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.cat_item_id" default='1'>
<cfset attributes.static_cat_id=-3>
<cfif isdefined("attributes.form_submitted")>
	<cfset attributes.is_all_cat = 1>
	<cfinclude template="../query/get_expense_item_static_cat.cfm">
<cfelse>
	<cfset get_expense_item_sta.recordcount=0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" placeholder="#place#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_add_expense_cat&draggable=1</cfoutput>',);" class="ui-btn ui-btn-gray"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
				</div>
			</cf_box_search> 
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="54252.Gider Kalemi Kategorileri"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cfparam name="attributes.keyword" default="">
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.totalrecords" default="#get_expense_item_sta.recordcount#">
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

		<cf_flat_list>  
			<thead>
				<tr> 
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id ='54252.Gider Kalemi kategorileri'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_add_expense_cat&draggable=1</cfoutput>',);"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_expense_item_sta.recordcount>
				<cfoutput query="get_expense_item_sta" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<cfset sayac_=1>
					<tr>
						<td align="center">#currentrow#</td>
						<td>#expense_cat_name#</td>
						<td>#expense_cat_detail#</td>
						<td align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_form_upd_expense_cat&cat_id=#EXPENSE_CAT_ID#&draggable=1');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="5"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfset url_str = ''>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = '#url_str#&keyword=#attributes.keyword#'>
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_str = '#url_str#&form_submitted=#attributes.form_submitted#'>
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#attributes.fuseaction##url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
