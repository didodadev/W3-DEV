<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfscript>
	attributes.startrow = ((attributes.page - 1) * attributes.maxrows) + 1;
	cmp_headquarter = createObject("component","V16.objects.cfc.get_headquarters");
	cmp_headquarter.dsn = dsn;
	get_headquarters = cmp_headquarter.get_headquarter(
		keyword: attributes.keyword,
		maxrows: attributes.maxrows,
		startrow: attributes.startrow
	);
	url_str = '';
	if (isdefined("attributes.keyword") and len(attributes.keyword))
		url_str = '#url_str#&keyword=#attributes.keyword#';
</cfscript>
<cfparam name="attributes.totalrecords" default="#get_headquarters.query_count#">

<cf_box title="#getLang('','Grup Başkanlıkları',33200)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform action="#request.self#?fuseaction=objects.popup_list_headquarters&#url_str#" method="post" name="headquarters_search">
		<cf_box_search>
			<div class="form-group">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('headquarters_search' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_flat_list>
		<thead>
			<tr> 
				<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='33201.Grup Başkanlığı'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_headquarters.query_count gt 0>
				<cfoutput query="get_headquarters">
					<tr>
						<td>#headquarters_id#</td>
						<td><a href="javascript://" onClick="add_company('#headquarters_id#','#name#');">#name#</a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
	<cf_paging 
		page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="objects.popup_list_headquarters#url_str#"
		isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
</cf_box>

<script type="text/javascript">
	function add_company(id,name)
	{
		<cfif isdefined("attributes.field_name")>
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#field_name#</cfoutput>.value = name;
		</cfif>
		<cfif isdefined("attributes.field_id")>
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#field_id#</cfoutput>.value = id;
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
