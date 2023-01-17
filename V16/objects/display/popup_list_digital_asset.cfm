<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.module" default="">
<cfparam name="attributes.module_id" default="">
<cfparam name="attributes.action_" default="">
<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.assetcat_id" default="">
<cfparam name="attributes.asset_cat_id" default="">
<cfparam name="attributes.action_type" default="0">
<cfparam name="attributes.field_name" default="0">
<cfparam name="attributes.field_no" default="0">
<cfparam name="attributes.field_id" default="0">
<cfparam name="attributes.list" default="list">
<cfparam name="attributes.sbmt" default="">
<cfquery name="FORMAT" datasource="#DSN#">
	SELECT FORMAT_SYMBOL FROM SETUP_FILE_FORMAT ORDER BY FORMAT_SYMBOL
</cfquery>
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.module)>
	<cfset url_str = "#url_str#&module=#attributes.module#">
</cfif>
<cfif len(attributes.module_id)>
	<cfset url_str = "#url_str#&module_id=#attributes.module_id#">
</cfif>
<cfif len(attributes.action_)>
	<cfset url_str = "#url_str#&action_=#attributes.action_#">
</cfif>
<cfif len(attributes.action_id)>
	<cfset url_str = "#url_str#&action_id=#attributes.action_id#">
</cfif>
<cfif isdefined("attributes.action_id_2") and len(attributes.action_id_2)>
	<cfset url_str = "#url_str#&action_id_2=#attributes.action_id_2#">
</cfif>
<cfif len(attributes.asset_cat_id)>
	<cfset url_str = "#url_str#&asset_cat_id=#attributes.asset_cat_id#">
</cfif>
<cfif len(attributes.action_type)>
	<cfset url_str = "#url_str#&action_type=#attributes.action_type#">
</cfif>
<cfif len(attributes.assetcat_id)>
	<cfset url_str = "#url_str#&assetcat_id=#attributes.assetcat_id#">
</cfif>
<cfif isdefined("attributes.property_id") and len(attributes.property_id)>
	<cfset url_str = "#url_str#&property_id=#attributes.property_id#">
</cfif>
<cfif len(attributes.list)>
	<cfset url_str = "#url_str#&list=#attributes.list#">
</cfif>
<cfif isdefined("attributes.format")>
	<cfset url_str = "#url_str#&format=#attributes.format#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_no")>
	<cfset url_str = "#url_str#&field_no=#attributes.field_no#">
</cfif>
<cfif isdefined("attributes.sbmt")>
	<cfset url_str = "#url_str#&sbmt=#attributes.sbmt#">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1>
    <cfinclude template="../query/get_assets_digital.cfm">
<cfelse>
	<cfset get_assets.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_assets.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_asset" action="#request.self#?fuseaction=objects.popup_list_digital_asset" method="post">
    <input type="hidden" name="is_image" id="is_image" value="<cfif isdefined("attributes.is_image")><cfoutput>#attributes.is_image#</cfoutput><cfelse>0</cfif>">
    <cfinput type="hidden" name="form_submitted" value="1">
    <cfinput type="hidden" name="module" value="#attributes.module#">
    <cfinput type="hidden" name="module_id" value="#attributes.module_id#">
    <cfinput type="hidden" name="action_" value="#attributes.action_#">
    <cfinput type="hidden" name="action_id" value="#attributes.action_id#">
    <cfinput type="hidden" name="action_type" value="#attributes.action_type#">
    <cfinput type="hidden" name="asset_cat_id" value="#attributes.asset_cat_id#">
    <cfinput type="hidden" name="field_name" value="#attributes.field_name#">
    <cfinput type="hidden" name="field_no" value="#attributes.field_no#">
    <cfinput type="hidden" name="field_id" value="#attributes.field_id#">
    <cfinput type="hidden" name="sbmt" value="#attributes.sbmt#">                      
    <cfif isdefined("attributes.action_id_2") and len(attributes.action_id_2)>
        <cfinput type="hidden" name="action_id_2" value="#attributes.action_id_2#">
    </cfif>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57562.Dijital Varlıklar'></cfsavecontent>
    <cf_big_list_search title="#message#">
        <cf_big_list_search_area>
    <div class="row form-inline">
		<div class="form-group" id="item-keyword">
                <div class="input-group x-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                        <cfinput type="text" name="keyword" style="width:100px;" placeholder="#message#" value="#attributes.keyword#" maxlength="255">
                    </div>
                </div>
        <div class="form-group" id="item-property_id">
                <div class="input-group x-20">            
                        <cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
                            SELECT CONTENT_PROPERTY_ID, NAME FROM CONTENT_PROPERTY ORDER BY NAME
                        </cfquery>							
                        <select name="property_id" id="property_id">
                        <option value=""><cf_get_lang dictionary_id='33663.Döküman Tipleri'></option>
                        <cfoutput query="get_content_property">
                            <option value="#content_property_id#"<cfif isDefined("attributes.property_id") and (content_property_id eq attributes.property_id)> selected</cfif>>#name#</option>
                        </cfoutput>
                        </select>				
                    </div>
                </div>    
        <div class="form-group" id="item-assetcat_id">
                <div class="input-group x-20">				  
                        <cfset attributes.kont=0>
                        <cfloop index="i" from="1" to="33">
                            <cfif get_module_user(i)>
                                <cfset attributes.kont=attributes.kont+1>
                            </cfif>
                        </cfloop>
                        <cfquery name="GET_TEMP_ASSET" datasource="#DSN#">
                            SELECT ASSETCAT_ID, ASSETCAT FROM ASSET_CAT WHERE ASSETCAT_ID >= 0 ORDER BY ASSETCAT
                        </cfquery>
                        <select name="assetcat_id" id="assetcat_id">				   
                            <option value=""><cf_get_lang dictionary_id='29536.Tüm Kategoriler'></option>
                        <cfif get_module_user(17)>
                            <option value="-4"<cfif attributes.assetcat_id eq -4> selected="selected"</cfif> ><cf_get_lang dictionary_id='57651.Anlaşma'></option> 
                        </cfif> 
                        <cfif get_module_user(9)>
                            <option value="-6"<cfif attributes.assetcat_id eq -6> selected="selected"</cfif>><cf_get_lang dictionary_id='57419.Eğitim'></option>
                        </cfif> 
                        <cfif get_module_user(11)>
                            <option value="-13"<cfif attributes.assetcat_id eq -13> selected="selected"</cfif>><cf_get_lang dictionary_id='57612.Fırsat'></option>
                        </cfif>	
                        <cfif get_module_user(16)>
                            <option value="-17"<cfif attributes.assetcat_id eq -17> selected="selected"</cfif>><cf_get_lang dictionary_id='57442.Finans'></option>	
                        </cfif>
                        <cfif get_module_user(10)>
                            <option value="-10"<cfif attributes.assetcat_id eq -10> selected="selected"</cfif>><cf_get_lang dictionary_id='57421.Forum'></option> 
                        </cfif>
                        <cfif get_module_user(22)>
                            <option value="-16"<cfif attributes.assetcat_id eq -16> selected="selected"</cfif>><cf_get_lang dictionary_id='57652.Hesap'></option>
                        </cfif>
                        <cfif get_module_user(2)>
                            <option value="-7"<cfif attributes.assetcat_id eq -7> selected="selected"</cfif>><cf_get_lang dictionary_id='57653.İçerik'></option>
                        </cfif>
                        <cfif get_module_user(29)>
                            <option value="-2"<cfif attributes.assetcat_id eq -2> selected="selected"</cfif>><cf_get_lang dictionary_id='57459.Yazışmalar'></option>
                        </cfif>
                        <cfif get_module_user(3)>
                            <option value="-8"<cfif attributes.assetcat_id eq -8> selected="selected"</cfif>><cf_get_lang dictionary_id='57444.İnsan Kaynakları'></option>
                        </cfif>
                        <cfif get_module_user(15)>
                            <option value="-15"<cfif attributes.assetcat_id eq -15> selected="selected"</cfif>><cf_get_lang dictionary_id='57446.Kampanya'></option>
                        </cfif> 
                        <cfif get_module_user(1)>
                            <option value="-1"<cfif attributes.assetcat_id eq -1> selected="selected"</cfif>><cf_get_lang dictionary_id='57416.Proje'></option>
                        </cfif> 
                        <cfif get_module_user(14)> 
                            <option value="-5"<cfif attributes.assetcat_id eq -5> selected="selected"</cfif> ><cf_get_lang dictionary_id='57656.Servis'></option>
                        </cfif>
                        <cfif get_module_user(11)>
                            <option value="-12"<cfif attributes.assetcat_id eq -12> selected="selected"</cfif>><cf_get_lang dictionary_id='57611.Sipariş'></option>
                        </cfif>
                        <cfif get_module_user(11)>
                            <option value="-11"<cfif attributes.assetcat_id eq -11> selected="selected"</cfif>><cf_get_lang dictionary_id='57545.Teklif'></option>
                        </cfif>
                        <cfif get_module_user(5)>
                            <option value="-3"<cfif attributes.assetcat_id eq -3> selected="selected"</cfif>><cf_get_lang dictionary_id='57657.Ürün'></option>
                        </cfif>
                        <cfif get_module_user(4)>
                            <option value="-9"<cfif attributes.assetcat_id eq -9> selected="selected"</cfif>><cf_get_lang dictionary_id='57658.Üye'></option>
                        </cfif> 
                            <option value="-18"<cfif attributes.assetcat_id eq -18> selected="selected"</cfif>><cf_get_lang dictionary_id='57659.Satış Bölgesi'></option>					
                        <cfoutput query="get_temp_asset">
                            <option value="#assetcat_id#" <cfif attributes.assetcat_id eq assetcat_id>selected</cfif>>#assetcat#</option> 
                        </cfoutput>
                        </select>
                    </div>
                </div>    
        <div class="form-group" id="item-format">
                <div class="input-group x-12">
                    <select name="format" id="format">
                            <option value=""><cf_get_lang dictionary_id='58594.Format'></option>
                            <cfoutput query="format">
                                <option value=".#format_symbol#"<cfif isdefined("attributes.format") and attributes.format is '.#format_symbol#'>selected</cfif>>#format_symbol#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>    
        <div class="form-group" id="item-format">
                <div class="input-group x-12">
                        <select name="list" id="list">
                            <option value="list"><cf_get_lang dictionary_id='57509.Liste'></option>
                            <option value="thumb" <cfif attributes.list is "thumb">selected</cfif>><cf_get_lang dictionary_id='57661.Thumbnail'></option>
                        </select>
                    </div>
                </div>    
        <div class="form-group x-3_5">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
        <div class="form-group">
                    <cf_wrk_search_button>
                    </div>
                </div>
    </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cfif attributes.list eq "list">
	<cfinclude template="list.cfm">
<cfelse>
	<cfinclude template="../../objects/display/icon/thumbnail.cfm">
</cfif>
<script type="text/javascript">
document.getElementById('keyword').focus();
function sendAsset(file,path,desc,asset_name,size,property,asset_id,real_name,my_assetcat_id,action_,action_id,asset_no)
{   
	<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
		window.opener.document.getElementById(<cfoutput>'#attributes.field_name#'</cfoutput>).value = asset_name;
	</cfif>
	<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
		window.opener.document.getElementById(<cfoutput>'#attributes.field_id#'</cfoutput>).value = asset_id;
	</cfif>
	<cfif isdefined("attributes.field_no") and len(attributes.field_no)>
		window.opener.document.getElementById(<cfoutput>'#attributes.field_no#'</cfoutput>).value = asset_no;
	</cfif>
	window.close();
}
</script>
