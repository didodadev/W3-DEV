<!---
Bu sayfaya gelen select_list parametresi
Genel olarak 1 - Fiziki Varlıklar
			 2 - Motorlu Taşıtlar
			 3 - IT Varlıklar
 --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.url_str" default="">
<cfquery name="GET_BRAND_TYPE_CATS" datasource="#DSN#">
	SELECT
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID,
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME,
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_ID,
		SETUP_BRAND_TYPE_CAT.BRAND_ID,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		SETUP_BRAND.BRAND_NAME
	FROM
		SETUP_BRAND_TYPE_CAT,
		SETUP_BRAND_TYPE,
		SETUP_BRAND
	WHERE
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
		SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID
		<cfif attributes.select_list eq 2>
			AND SETUP_BRAND.MOTORIZED_VEHICLE = 1
		<cfelseif attributes.select_list eq 3>
			AND SETUP_BRAND.IT_ASSET = 1
		<cfelseif attributes.select_list eq 1>
			AND (SETUP_BRAND.MOTORIZED_VEHICLE<>1 OR SETUP_BRAND.MOTORIZED_VEHICLE IS NULL ) AND (SETUP_BRAND.IT_ASSET <> 1 OR SETUP_BRAND.IT_ASSET IS NULL)
		</cfif>
		<cfif len(attributes.keyword)>
			AND (SETUP_BRAND_TYPE.BRAND_TYPE_NAME LIKE '%#attributes.keyword#%' OR SETUP_BRAND.BRAND_NAME LIKE '%#attributes.keyword#%' OR SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME LIKE '%#attributes.keyword#%')
		</cfif>
	ORDER BY
		SETUP_BRAND.BRAND_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_brand_type_cats.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='32701.Marka Tipi Kategorisi'></cfsavecontent>
<cf_medium_list_search title="#message#">
    <cf_medium_list_search_area>
        <cfform name="search_brand_type_cat" method="post" action="#request.self#?fuseaction=objects.popup_list_brand_type_cat">
            <table>
                <tr>
                    <td><cf_get_lang dictionary_id='57460.Filtre'></td>
                    <cfif isdefined("field_brand_name")><input type="hidden" name="field_brand_name" id="field_brand_name" value="<cfoutput>#attributes.field_brand_name#</cfoutput>"></cfif>
                    <cfif isdefined("field_brand_id")><input type="hidden" name="field_brand_id" id="field_brand_id" value="<cfoutput>#attributes.field_brand_id#</cfoutput>"></cfif>
                    <cfif isdefined("field_brand_type_id")><input type="hidden" name="field_brand_type_id" id="field_brand_type_id" value="<cfoutput>#attributes.field_brand_type_id#</cfoutput>"></cfif>
                    <cfif isdefined("field_brand_type_cat_id")><input type="hidden" name="field_brand_type_cat_id" id="field_brand_type_cat_id" value="<cfoutput>#attributes.field_brand_type_cat_id#</cfoutput>"></cfif>
                    <input type="hidden" name="select_list" id="select_list" value="<cfoutput>#attributes.select_list#</cfoutput>">
                    <td><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
                    <td><cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1," required="yes"></td>
                    <td><cf_wrk_search_button></td>
                </tr>
            </table>
        </cfform>
    </cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
        <tr>
            <th><cf_get_lang dictionary_id='58847.Marka'></th>
            <th><cf_get_lang dictionary_id='59088.Tip'></th>
            <th><cf_get_lang dictionary_id='57486.Kategori'></th>
        </tr>
    </thead>
    <tbody>
        <cfif get_brand_type_cats.recordcount>
			<cfoutput query="get_brand_type_cats" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#brand_name#</td>
                    <td>#brand_type_name#</td>
                    <td><a href="javascript://" onClick="gonder('#brand_name# - #brand_type_name# - #URLEncodedFormat(brand_type_cat_name)#','#brand_id#','#brand_type_id#','#brand_type_cat_id#')" class="tableyazi">#brand_type_cat_name#</a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td height="20" colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined('attributes.field_brand_name')>
		<cfset url_str = "#url_str#&field_brand_name=#attributes.field_brand_name#">
	</cfif>
	<cfif isdefined('attributes.field_brand_id')>
		<cfset url_str = "#url_str#&field_brand_id=#attributes.field_brand_id#">
	</cfif>
	<cfif isdefined('attributes.field_brand_type_id')>
		<cfset url_str = "#url_str#&field_brand_type_id=#attributes.field_brand_type_id#">
	</cfif>
	<cfif isdefined('attributes.field_brand_type_cat_id')>
		<cfset url_str = "#url_str#&field_brand_type_cat_id=#attributes.field_brand_type_cat_id#">
	</cfif>
	<cfif isdefined('attributes.select_list')>
		<cfset url_str = "#url_str#&select_list=#attributes.select_list#">
	</cfif>
	<table width="98%" border="0" cellpadding="0" cellspacing="0" height="35" align="center" >
    	<tr>
            <td><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="objects.popup_list_brand_type_cat#url_str#"></td>
            <!-- sil -->
            <td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
            <!-- sil -->
        </tr>
	</table>
</cfif>
<script type="text/javascript">
function gonder(brand_name,brand_id,brand_type_id,brand_type_cat_id)
{
	<cfif isdefined("field_brand_name")>
		opener.document.<cfoutput>#attributes.field_brand_name#</cfoutput>.value = brand_name;
	</cfif>
	<cfif isdefined("field_brand_id")>opener.document.<cfoutput>#attributes.field_brand_id#</cfoutput>.value = brand_id;</cfif>
	<cfif isdefined("field_brand_type_id")>opener.document.<cfoutput>#attributes.field_brand_type_id#</cfoutput>.value = brand_type_id;</cfif>
	<cfif isdefined("field_brand_type_cat_id")>opener.document.<cfoutput>#attributes.field_brand_type_cat_id#</cfoutput>.value = brand_type_cat_id;</cfif>
	<cfif isDefined("attributes.is_calistir")>opener.marka_kontrol();</cfif>
	window.close();
}
</script>
