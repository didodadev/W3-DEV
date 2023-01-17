<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfset keyword = ""> 
<cfif isdefined("attributes.module_") and len(attributes.module_)>
	<cfset keyword = keyword&'#attributes.module_#'>
	<cfif isdefined("attributes.fuseaction_") and len(attributes.fuseaction_)>
		<cfset keyword = keyword&'.#attributes.fuseaction_#'>
	</cfif>
<cfelseif isdefined("attributes.fuseaction_") and len(attributes.fuseaction_)>
	<cfset keyword = keyword&'#attributes.fuseaction_#'>
</cfif>
<cfquery name="get_faction_all" datasource="#dsn#">
	SELECT 
		DENIED_PAGE,
		DENIED_TYPE
	FROM 
		DENIED_PAGES_LOCK
	<cfif len(keyword)>
	WHERE
		DENIED_PAGE LIKE '%#keyword#%'
	</cfif>
	GROUP BY DENIED_PAGE,DENIED_TYPE
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_faction_all.recordcount#">
<cfset attributes.startrow = (( attributes.page - 1 ) * attributes.maxrows ) + 1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form1" method="post" action="#request.self#?fuseaction=settings.list_denied_pages_lock">
			<cf_box_search> 
				<div class="form-group">
					<cfinput type="hidden" name="is_form_submitted" value="1">
					<input type="text" name="module_" id="module_" maxlength="50" placeholder="<cfoutput>#getLang('','Filtre','57460')#</cfoutput>" value="<cfif isdefined("attributes.module_") and len(attributes.module_)><cfoutput>#attributes.module_#</cfoutput></cfif>">
				</div>
				<div class="form-group">
					<input type="text"  name="fuseaction_" id="fuseaction_" placeholder="<cfoutput>#getLang('','Fuseaction','40574')#</cfoutput>" value="<cfif isdefined("attributes.fuseaction_") and len(attributes.fuseaction_)><cfoutput>#attributes.fuseaction_#</cfoutput></cfif>">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Incorrect Record Number','57537')#" maxlength="3">
				</div>
				<div class="form-group">
                	<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('', 'Kilitli Sayfalar', '43965')#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th class="text-center" width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57581.Sayfa'></th>
					<th><cf_get_lang dictionary_id='43964.Kilit Tanımı'></th>
					<th class="text-center" width="30"><a href="javascript://" onClick=''><i class="fa fa-pencil"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_faction_all.recordcount and form_varmi eq 1>
				<form name="denied_page_" id="denied_page_" action="" method="post">
				<input type="hidden" name="act" id="act" value=""></form>
					<cfoutput query="get_faction_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td class="text-center" width="30">#currentrow#</td>
							<td>#DENIED_PAGE#</td> 
							<td><cfif DENIED_TYPE eq 1><cf_get_lang dictionary_id='58575.İzin'><cfelse><cf_get_lang dictionary_id='43963.Yasak'></cfif></td>
							<!-- sil -->
							<td class="text-center" width="30"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_denied_pages_lock&act=#replace(replace(denied_page,'&','|','all'),'=','-','all')#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>! </cfif></td>
					</tr>
				</cfif>
			</tbody>			
		</cf_flat_list>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('module_').focus();
/*function gonder_denied(lock_page)
{
	document.denied_page_.act.value = lock_page;
	openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_denied_pages_lock</cfoutput>');
	document.denied_page_.action= '<cfoutput>#request.self#?fuseaction=objects.popup_denied_pages_lock</cfoutput>';
	document.denied_page_.submit();
}*/
</script>
<cfset url_str = "settings.list_denied_pages_lock">
<cfif isdefined("attributes.module_") and len(attributes.module_)>
	<cfset url_str = url_str&'&module_=#attributes.module_#'>
</cfif>
<cfif isdefined("attributes.fuseaction_") and len(attributes.fuseaction_)>
	<cfset url_str = url_str&'&fuseaction_=attributes.fuseaction_'>
</cfif>
<cfif isdefined("attributes.is_form_submitted") and len (attributes.is_form_submitted)>
	<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
</cfif>
<cf_paging 
	page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#url_str#">
