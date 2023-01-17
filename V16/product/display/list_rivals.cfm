<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_rival_list.cfm">
<cfelse>
	<cfset get_rival_list.recordcount=0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_rival_list.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form" action="#request.self#?fuseaction=product.rivals" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">	
			<cf_box_search more="0">
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
					</div>
				</div>
				<div class="form-group">
					<div class="input-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cf_wrk_search_button button_type="4">
					</div>
				</div>
			</cf_box_search>	
		</cfform>
	</cf_box>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='37025.Rakipler'></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58779.Rakip'></th>
					<!-- sil -->
					<th class="header_icn_none" width="20"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.rivals&event=add</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<th class="header_icn_none" width="20"><a href="javascript://"><i class="fa fa-question" title="<cf_get_lang dictionary_id ='57560.Analiz'>" alt="Analiz"></i></a></th>
						
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_rival_list.recordcount>
					<cfoutput query="get_rival_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_company_info&r_id=#r_id#');" class="tableyazi">#rival_name#</a></td>
							<!-- sil -->
							<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.rivals&event=upd&r_id=#r_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>" alt="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td>
							<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.rivals&event=upd&r_id=#r_id#&is_analysis=1');"><i class="fa fa-question" title="<cf_get_lang dictionary_id ='57560.Analiz'>" alt="<cf_get_lang dictionary_id ='57560.Analiz'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfset url_str = "">
		<cfif isdefined ("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined ("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="product.rivals#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
</script>
