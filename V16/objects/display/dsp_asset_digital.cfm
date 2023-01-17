<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.module" default="">
<cfparam name="attributes.module_id" default="">
<cfif isdefined('attributes.action') and len(attributes.action)>
	<cfparam name="attributes.action_" default="#attributes.action#">
</cfif>
<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.assetcat_id" default="">
<cfparam name="attributes.asset_cat_id" default="">
<cfparam name="attributes.action_type" default="0">
<cfparam name="attributes.list" default="list">
<cfparam name="attributes.action_" default="">
<cfparam name="attributes.is_multi_selection" default="0">
<cfparam name="attributes.modal_id" default="">
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
<cfif isdefined("attributes.property_id") and not len(attributes.property_id)>
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
<cfif isdefined("attributes.is_multi_selection")>
	<cfset url_str = "#url_str#&is_multi_selection=#attributes.is_multi_selection#">
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
<cfif isdefined("attributes.refresh_id")>
	<cfset url_str = "#url_str#&refresh_id=#attributes.refresh_id#">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_assets_digital.cfm">
<cfelse>
	<cfset get_assets.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_assets.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57562.Dijital Varlıklar'></cfsavecontent>

<cf_box title="#getLang('','Dijital Varlıklar',57562)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_asset" method="post" action="#request.self#?fuseaction=objects.popup_asset_digital">	
		<cf_box_search more="0">
			<cfinput type="hidden" name="form_submitted" id="form_submitted" value="1">
			<input type="hidden" name="refresh_id" id="refresh_id" value="<cfif isdefined("attributes.refresh_id")><cfoutput>#attributes.refresh_id#</cfoutput></cfif>">
			<cfinput type="hidden" name="module" id="module" value="#attributes.module#">
			<cfinput type="hidden" name="module_id" id="module_id" value="#attributes.module_id#">
			<cfinput type="hidden" name="action_" id="action_" value="#attributes.action_#">
			<cfinput type="hidden" name="action_id" id="action_id" value="#attributes.action_id#">
			<cfinput type="hidden" name="action_type" id="action_type" value="#attributes.action_type#">
			<cfinput type="hidden" name="asset_cat_id" id="asset_cat_id" value="#attributes.asset_cat_id#">
			<cfif isdefined("attributes.field_id")>
				<cfinput type="hidden" name="field_id" id="field_id" value="#attributes.field_id#">
				<cfinput type="hidden" name="field_name" id="field_name" value="#attributes.field_name#">
				<cfinput type="hidden" name="is_multi_selection" id="is_multi_selection" value="#attributes.is_multi_selection#">
			</cfif>
			<cfif isdefined("attributes.sbmt")><cfinput type="hidden" name="sbmt" id="sbmt" value="1"></cfif>
			<cfif isdefined("attributes.action_id_2") and len(attributes.action_id_2)>
				<cfinput type="hidden" name="action_id_2" id="action_id_2" value="#attributes.action_id_2#">
			</cfif>
			<input type="hidden" name="is_image" id="is_image" value="<cfif isdefined("attributes.is_image")><cfoutput>#attributes.is_image#</cfoutput><cfelse>0</cfif>">
			<div class="form-group" id="item-keyword">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
			</div>
			<div class="form-group" id="item-property_id">
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
			<div class="form-group" id="item-assetcat_id">
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
						<option value="-4"<cfif attributes.assetcat_id eq -4> selected="selected"</cfif>><cf_get_lang dictionary_id='57651.Antlaşma'></option> 
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
					<cfif get_module_user(8)>
					<option value="-23" <cfif attributes.assetcat_id eq -23> selected="selected"</cfif>><cf_get_lang dictionary_id="58833.Fiziki Varlık"></option>
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
						<option value="-5"<cfif attributes.assetcat_id eq -5> selected="selected"</cfif>><cf_get_lang dictionary_id='57656.Servis'></option>
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
			<div class="form-group" id="item-format">
				<select name="format" id="format">
					<option value=""><cf_get_lang dictionary_id='58594.Format'></option>
					<cfoutput query="format">
						<option value=".#format_symbol#"<cfif isdefined("attributes.format") and attributes.format is '.#format_symbol#'>selected</cfif>>#format_symbol#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group" id="item-list">
				<select name="list" id="list">
					<option value="list"><cf_get_lang dictionary_id='57509.List'></option>
					<option value="thumb" <cfif attributes.list is "thumb">selected</cfif>><cf_get_lang dictionary_id='57661.Thumbnail'></option>
				</select>
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			</div>   
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("control() && loadPopupBox('search_asset' , #attributes.modal_id#)"),DE(""))#">
			</div>   

		</cf_box_search>
	</cfform>
	<cfif attributes.list eq "list">
		<cfinclude template="list.cfm">
	<cfelse>
		<cfinclude template="../../objects/display/icon/thumbnail.cfm">
	</cfif>
</cf_box>
<script type="text/javascript">
	$(document).ready(function(){
    $("form[name=search_asset] #keyword").focus();

});
function control()
	{
		
			var action = $('form[name =search_asset]').attr('action');
			action += '&module=' + $('#module').val() + '&module_id=' + $('#module_id').val() + '&action=' + $('#action_').val() + '&action_id=' + $('#action_id').val() + '&asset_cat_id=' + $('#asset_cat_id').val() + '&action_type=' + $('#action_type').val() + '&asset_archive=' + $('#asset_archive').val();
			$('form[name =search_asset]').attr('action', action);
		return true;
	}
	function sendAsset(file,path,desc,asset_name,size,property,asset_id,real_name,my_assetcat_id,action_,action_id,asset_no,embedcode_url)
	{
		document.asset_archive.filename.value = file;
		document.asset_archive.filepath.value = path;
		document.asset_archive.keyword.value = desc;
		document.asset_archive.asset_name.value = asset_name;
		document.asset_archive.asset_id.value = asset_id;
		document.asset_archive.filesize.value = size;
		document.asset_archive.property_id.value = property;
		document.asset_archive.asset_file_real_name.value = real_name;
		document.asset_archive.my_assetcat_id.value = my_assetcat_id;
		document.asset_archive.action_id.value = action_id;
		document.asset_archive.action_section.value = action_;
		document.asset_archive.embedcode_url.value = embedcode_url;
		<cfif isdefined("attributes.sbmt")>
			<cfif isdefined("attributes.is_multi_selection") and attributes.is_multi_selection eq 1>
				<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value + ',' + asset_name;
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value =  asset_name;
				</cfif>
			</cfif>
			<cfif isdefined("attributes.is_multi_selection") and attributes.is_multi_selection eq 1>
				<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value + ',' + asset_id;
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = asset_id;
				</cfif>
			</cfif>
			<cfif isdefined("attributes.field_no") and len(attributes.field_no)>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_no#</cfoutput>.value =  asset_no;
			</cfif>
			<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		<cfelse>
			<cfif isdefined("attributes.draggable")>loadPopupBox('asset_archive');<cfif isdefined("attributes.refresh_id") and len(attributes.refresh_id)>jQuery( '#<cfoutput>#attributes.refresh_id#</cfoutput> .catalyst-refresh' ).click();</cfif><cfelse>document.asset_archive.submit();</cfif>;
		</cfif>
	}
</script>	
<cfoutput>
<form name="asset_archive" method="post" action="#request.self#?fuseaction=objects.emptypopup_copy_asset">
	<input type="hidden" name="filename" id="filename" value="">
	<input type="hidden" name="is_image" id="is_image" value="<cfif isdefined("attributes.is_image")>#attributes.is_image#<cfelse>0</cfif>">
	<input type="hidden" name="image_size" id="image_size" value="">
	<input type="hidden" name="asset_file_real_name" id="asset_file_real_name" value="">
	<input type="hidden" name="filepath" id="filepath" value="">
	<input type="hidden" name="filesize" id="filesize" value="">
	<input type="hidden" name="property_id" id="property_id" value="">
	<input type="hidden" name="asset_name" id="asset_name" value="">
	<input type="hidden" name="asset_id" id="asset_id" value="">
	<input type="hidden" name="refresh_id" id="refresh_id" value="">
	<input type="hidden" name="keyword" id="keyword" value="">
	<input type="hidden" name="action_id" id="action_id" value="#attributes.action_id#">
	<input type="hidden" name="asset_archive" id="asset_archive" value="#attributes.asset_archive#">
	<input type="hidden" name="action_type" id="action_type" value="#attributes.action_type#">
	<input type="hidden" name="action_section" id="action_section" value="#attributes.action_#">
	<input type="hidden" name="module" id="module" value="#attributes.module#">
	<input type="hidden" name="module_id" id="module_id" value="#attributes.module_id#">
	<input type="hidden" name="asset_cat_id" id="asset_cat_id" value="#attributes.asset_cat_id#">
	<input type="hidden" name="my_assetcat_id" id="my_assetcat_id" value="">
	<cfif isdefined("attributes.action_id_2") and len(attributes.action_id_2)>
		<input type="hidden" name="action_id_2" id="action_id_2" value="#attributes.action_id_2#">
	</cfif>
	<input type="hidden" name="embedcode_url" id="embedcode_url" value="">
</form>	
</cfoutput>


