<cf_xml_page_edit fuseact="objects.popup_product_brands">
<cfset url_string = "">
<!---<cfif isdefined("attributes.company_brands")>
	<cfset url_string = "#url_string#&company_brands=1">
</cfif>--->
<cfif isdefined("attributes.brand_name")>
	<cfset url_string = "#url_string#&brand_name=#attributes.brand_name#">
</cfif>
<cfif isdefined("attributes.brand_id")>
	<cfset url_string = "#url_string#&brand_id=#attributes.brand_id#">
</cfif>
<cfif isdefined("attributes.brand_code")>
	<cfset url_string = "#url_string#&brand_code=#attributes.brand_code#">
</cfif>
<cfparam name="attributes.our_company" default="#session.ep.company_id#">
<cfparam name="attributes.keyword" default=''>
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="get_mark_names" datasource="#dsn1#">
		SELECT
			PB.*
		FROM
			PRODUCT_BRANDS PB
			<!---<cfif isdefined("attributes.company_brands") or x_is_company>,PRODUCT_BRANDS_OUR_COMPANY PBO</cfif>--->
		WHERE
			PB.BRAND_NAME LIKE '%#attributes.keyword#%'
			<!---<cfif isdefined("attributes.company_brands") or x_is_company>
			AND PB.BRAND_ID = PBO.BRAND_ID
			AND PBO.OUR_COMPANY_ID = #session.ep.company_id#
			</cfif>--->
            <cfif isdefined("attributes.our_company") and len(attributes.our_company)>
                AND PB.BRAND_ID IN (SELECT BRAND_ID FROM PRODUCT_BRANDS_OUR_COMPANY WHERE OUR_COMPANY_ID = #attributes.our_company#)
            </cfif>
		ORDER BY BRAND_NAME
	</cfquery>
<cfelse>
	<cfset get_mark_names.recordcount = 0>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_mark_names.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Markalar',32436)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_brand" id="search_brand" action="#request.self#?fuseaction=objects.popup_product_brands&#url_string#" method="post">
			<cfif isDefined("attributes.draggable")><input type="hidden" name="draggable" value="1"></cfif>
			<cf_box_search more="0">
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="Text" name="keyword" placeholder="#message#" maxlength="50" value="#attributes.keyword#" style="width:100px;">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_brand' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='58847.Marka'></th>
					<th><cf_get_lang dictionary_id='32864.Web'></th>
					<th width="20"><a href="javascript://"  onclick="windowopen('<cfoutput>#request.self#?fuseaction=product.list_product_brands&event=add&#url_string#</cfoutput>','small');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_mark_names.recordcount and form_varmi eq 1>
				<cfoutput query="get_mark_names" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><a href="##" class="tableyazi"  onclick="add_brand('#brand_id#','#brand_name#','#brand_code#');">#brand_name#</a></td>
						<td><cfif is_internet eq 1><cf_get_lang dictionary_id='32804.Webde Görünür'></cfif></td>
						<td><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=product.list_product_brands&event=upd&id=#brand_id#&#url_string#','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif isdefined("attributes.keyword")>
			<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.is_form_submitted")>
			<cfset url_string = "#url_string#&is_form_submitted=#attributes.is_form_submitted#">
		</cfif>
		<cfif isdefined("attributes.draggable")>
			<cfset url_string = "#url_string#&draggable=#attributes.draggable#">
		</cfif>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="objects.popup_product_brands&#url_string#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">

		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function add_brand(id,brand_name,code)
{
	<cfif isdefined("attributes.brand_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#brand_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.brand_code")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#brand_code#</cfoutput>.value = code;
	</cfif>
	<cfif isDefined("attributes.brand_name")>
		x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.brand_name#</cfoutput>.length;
		if(x != undefined)
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.brand_name#</cfoutput>.length = parseInt(x + 1);
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.brand_name#</cfoutput>.options[x].value = id;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.brand_name#</cfoutput>.options[x].text = brand_name;
		}
		else
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#brand_name#</cfoutput>.value = brand_name;
			<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		}
	</cfif>
	
}
</script>
