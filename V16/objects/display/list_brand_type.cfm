<!--- 
Bu sayfaya gelen select_list parametresi 
Genel olarak 1- Fiziki Varlıklar
			 2- Motorlu Taşıtlar
			 3- IT Varlıklar
			 4- Hepsi
Eger select_list parametresinin gonderilemedigi yerlerde ise cat_id ile bu degere ulaşılır.
 --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.url_str" default="">
<cfif not isdefined("attributes.select_list")>
	<cfquery name="GET_CAT_TYPE" datasource="#DSN#">
		SELECT
			ASSETP_CATID,
			IT_ASSET,
			MOTORIZED_VEHICLE
		FROM
			ASSET_P_CAT
		WHERE
			ASSETP_CATID = #attributes.cat_id#
	</cfquery>
	<cfif get_cat_type.it_asset eq 0 and get_cat_type.motorized_vehicle eq 0>
		<cfset attributes.select_list=1>
	<cfelseif get_cat_type.motorized_vehicle eq 1>
		<cfset attributes.select_list=2>
	<cfelseif get_cat_type.it_asset eq 1>
		<cfset attributes.select_list=3>
	<cfelseif get_cat_type.it_asset neq 1 or get_cat_type.it_asset neq 0 or get_cat_type.motorized_vehicle neq 1 or get_cat_type.motorized_vehicle neq 0>
		<cfset attributes.select_list=4>
	</cfif>
</cfif>
<cfquery name="GET_BRAND_TYPES" datasource="#dsn#">
	SELECT
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_ID,
		SETUP_BRAND_TYPE.BRAND_ID,
		SETUP_BRAND.BRAND_NAME
	FROM
		SETUP_BRAND_TYPE,
		SETUP_BRAND
	WHERE
		SETUP_BRAND.BRAND_ID = SETUP_BRAND_TYPE.BRAND_ID 
	<cfif attributes.select_list eq 2>
		AND SETUP_BRAND.MOTORIZED_VEHICLE = 1
	<cfelseif attributes.select_list eq 3>
		AND SETUP_BRAND.IT_ASSET = 1
	<cfelseif attributes.select_list eq 1>
		AND (SETUP_BRAND.MOTORIZED_VEHICLE<>1 OR SETUP_BRAND.MOTORIZED_VEHICLE IS NULL ) AND (SETUP_BRAND.IT_ASSET <> 1 OR SETUP_BRAND.IT_ASSET IS NULL)
	</cfif>
	<cfif len(attributes.keyword)>
		AND (SETUP_BRAND_TYPE.BRAND_TYPE_NAME LIKE '%#attributes.keyword#%' OR SETUP_BRAND.BRAND_NAME LIKE '%#attributes.keyword#%')
	</cfif>
	ORDER BY
		SETUP_BRAND.BRAND_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME
</cfquery>
<!---<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfif form_varmi eq 1>
	<cfset get_brand_types.recordCount=0>	
</cfif>--->
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_brand_types.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#getLang('','Marka Tipleri',33169)#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_brand_asset" method="post" action="#request.self#?fuseaction=objects.popup_list_brand_type">
		<cf_box_search>
			<cfif isdefined("field_brand_name")><input type="hidden" name="field_brand_name" id="field_brand_name" value="<cfoutput>#attributes.field_brand_name#</cfoutput>"></cfif>
			<cfif isdefined("field_brand_id")><input type="hidden" name="field_brand_id" id="field_brand_id" value="<cfoutput>#attributes.field_brand_id#</cfoutput>"></cfif>
			<cfif isdefined("field_brand_type_id")><input type="hidden" name="field_brand_type_id" id="field_brand_type_id" value="<cfoutput>#attributes.field_brand_type_id#</cfoutput>"></cfif>
			<cfif isdefined("attributes.select_list")><input type="hidden" name="select_list" id="select_list" value="<cfoutput>#attributes.select_list#</cfoutput>"></cfif>
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<div class="form-group" id="item-keyword">
				<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
			</div>
			<div class="form-group small" id="item-maxrows">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_brand_asset' , #attributes.modal_id#)"),DE(""))#">
			</div>			
		</cf_box_search>
	</cfform>
	<cf_flat_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='58847.Marka'></th>
				<th><cf_get_lang dictionary_id="30041.Marka Tipi"></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_brand_types.recordcount>
			<cfoutput query="get_brand_types" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#brand_name#</td>
					<td><a href="javascript://" onClick="gonder('#brand_name# - #brand_type_name#','#brand_id#','#brand_type_id#')" class="tableyazi">#brand_type_name#</a></td>
				</tr>
			</cfoutput>
			<cfelse>
				<tr> 
					<td height="20" colspan="2"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset url_str = "">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.field_brand_name")>
			<cfset url_str = "#url_str#&field_brand_name=#attributes.field_brand_name#">
		</cfif>
		<cfif isdefined("attributes.field_brand_type_id")>
			<cfset url_str = "#url_str#&field_brand_type_id=#attributes.field_brand_type_id#">
		</cfif>
		<cfif isdefined("attributes.field_brand_id")>
			<cfset url_str = "#url_str#&field_brand_id=#attributes.field_brand_id#">
		</cfif>
		<cfif isdefined("attributes.select_list") and len(attributes.select_list)>
			<cfset url_str = "#url_str#&select_list=#attributes.select_list#">
		</cfif>
		<cfif isdefined("attributes.cat_id") and len(attributes.cat_id)>
			<cfset url_str = "#url_str#&cat_id=#attributes.cat_id#">
		</cfif>
		<cfset url_str = "#url_str#&is_form_submitted=1">
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects.popup_list_brand_type#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<script type="text/javascript">
document.getElementById('keyword').focus();
function gonder(brand_name,brand_id,brand_type_id,cat_id)
{
	<cfif isdefined("field_brand_name")><cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_brand_name#</cfoutput>.value = brand_name;</cfif>					
	<cfif isdefined("field_brand_id")><cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_brand_id#</cfoutput>.value = brand_id;</cfif>					
	<cfif isdefined("field_brand_type_id")><cfif isdefined("attributes.draggable")>document<cfelse>opener.document</cfif>.<cfoutput>#attributes.field_brand_type_id#</cfoutput>.value = brand_type_id;</cfif>					
	<cfif isDefined("attributes.is_calistir")><cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.marka_kontrol();</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
