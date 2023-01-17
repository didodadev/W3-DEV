<!--- upload_folder = '#GetDirectoryFromPath(GetCurrentTemplatePath())#documents#dir_seperator#'; --->
<cf_xml_page_edit fuseact="objects.popup_save_asset_file">
<cf_papers paper_type="ASSET">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cfif len(paper_number)>
	<cfset asset_no = system_paper_no>
<cfelse>
	<cfset asset_no = ''>
</cfif>
<cfparam name="attributes.stream_name" default="#createUUID()#"/>
<cfinclude template="../../asset/query/get_asset_cats.cfm">
<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
	SELECT 
		CONTENT_PROPERTY_ID,
		NAME
	FROM 
		CONTENT_PROPERTY
	ORDER BY
		NAME
</cfquery>

<cfset StringSpl = attributes.asset_file.Split("/")>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='29487.Belge Kaydetme'></cfsavecontent>
<cf_box title="#title#" closable="0" collapsable="1">
<cfform name="add_asset" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=asset.add_asset">
	<input type="hidden" name="x_is_asset_stage_display" id="x_is_asset_stage_display" value="">
	<input type="hidden" name="is_archive" id="is_archive" value="1">
	<input type="hidden" name="foldername" value="<cfoutput>#StringSpl[3]&"\"&StringSpl[4]#</cfoutput>">
	<input type="hidden" name="is_image" id="is_image" value="0">
	<input type="hidden" name="is_active" id="is_active" value="1">
	<input type="hidden" name="revision_no" value="0">
	<input type="hidden" name="module" id="module" value="">
	<input type="hidden" name="module_id" id="module_id" value="">
	<input type="hidden" name="action_section" id="action_section" value="">
	<input type="hidden" name="action_id" id="action_id" value="">
	<input type="hidden" name="action_id_2" id="action_id_2" value="">
	<input type="hidden" name="action_type" id="action_type" value="">
	<input type="hidden" name="asset_cat_id" id="asset_cat_id" value="">
	<!--- <input type="hidden" name="is_own_file" id="is_own_file" value="1"> --->
	<input type="hidden" name="ASSET_DESCRIPTION" id="ASSET_DESCRIPTION" value="">
	<input type="hidden" name="ASSET_DETAIL" id="ASSET_DETAIL" value="">
	<div class="row">
		<div class="col col-12 uniqueRow">
				<div class="row" type="row">
					<div class="form-group">
						<input type="checkbox" name="is_upd_detail" id="is_upd_detail" value="0" /><cf_get_lang dictionary_id='29486.Detay Sayfasına Gitsin'>
					</div>
					<div class="form-group">
						<label class="col col-2"><cf_get_lang dictionary_id ='57880.Belge No'></label>
						<div class="col col-4"><cfinput type="text" name="asset_no" value="#asset_no#"></div>
					</div>
					<cfif x_is_stage eq 1>
						<div class="form-group">
							<label class="col col-2"><cf_get_lang dictionary_id="58859.Süreç"></label>
							<div class="col col-4"><cf_workcube_process is_upd='0' process_cat_width='250' is_detail='0'></div>
						</div>
					</cfif>
					<div class="form-group">
						<label class="col col-2"><cf_get_lang dictionary_id='57486.Kategori'></label>
						<div class="col col-4">
							<select name="assetcat_id" id="assetcat_id" <cfif isdefined('attributes.asset_cat_id') and len(attributes.asset_cat_id)>disabled="disabled"</cfif>>
								<cfoutput query="get_asset_cats"> 
									<option value="#assetcat_id#" <cfif isdefined('attributes.asset_cat_id') and (attributes.asset_cat_id eq assetcat_id)>selected</cfif>>#assetcat#</option>
								</cfoutput> 
							</select>
							<input type="hidden" id="stream_name" name="stream_name" value="">
							<input type="hidden" id="is_stream" name="is_stream" value="0">
						</div>
					</div>
					<div class="form-group">
						<label class="col col-2"><cf_get_lang dictionary_id='58067.Döküman Tipi'> *</label>
						<div class="col col-4">
							<select name="property_id" id="property_id">
								<option value="-1"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_content_property">
									<option value="#content_property_id#">#name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-2"><cf_get_lang dictionary_id='29452.Varlık Adı'>*</label>
						<div class="col col-4">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik veri'>:<cf_get_lang dictionary_id='47706.Varlık Adı !'></cfsavecontent>
							<cfinput type="text" name="asset_name" required="Yes" message="#message#">
						</div>
					</div>
					<div class="form-group">
						<label class="col col-2"><cf_get_lang dictionary_id='29485.Doküman'>*</label>
						<div class="col col-4">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik veri'>:<cf_get_lang dictionary_id='47706.Varlık Adı !'></cfsavecontent>
								<cfinput type="text" name="asset" readonly="yes" value="#attributes.asset_file#"/>
						</div>
					</div>
				</div>
				<div class="row formContentFooter">
					<cf_workcube_buttons is_='0' add_function='check()'>
				</div>
		</div>
	</div>
</cfform>
<script type="text/javascript">

function check()
{
	if (document.add_asset.asset_name.value == "")
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik veri'>: <cf_get_lang dictionary_id='47706.Varlık Adı'> !");
		return false;
	}

	if (document.add_asset.property_id.value < 0)
	{
		alert("<cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='58067.Döküman Tipi'> !");
		return false;
	}
							
	if (!process_cat_control()) return false;
	return true;
}
</script>
