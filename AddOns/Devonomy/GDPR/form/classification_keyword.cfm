<!---
    File: add_classificaiton_keyword.cfm
    Author: 
    Date: 
    Controller: 
    Description:
		
--->
<cfscript>
	enums = createObject("component","addons.devonomy.gdpr.cfc.enums");
	status = enums.get_status(is_form:true);
	keyword_types = enums.get_keyword_types();
	keyword_search_types = enums.get_keyword_search_types();
	type_comp = createObject("component","addons.devonomy.gdpr.cfc.data_category");
	types = type_comp.get_data_category();

	if(Not isDefined("attributes.id")) attributes.id = "";
	if(Not isDefined("attributes.keyword")) attributes.keyword = "";  
	if(Not isDefined("attributes.keyword_type")) attributes.keyword_type = '';
	if(Not isDefined("attributes.search_type")) attributes.search_type = '';
	if(Not isDefined("attributes.is_active")) attributes.is_active = 1;
	if(Not isDefined("attributes.data_category_id")) attributes.data_category_id = 0;

	if(attributes.event == "upd"){
		if(len(attributes.id)){
			gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.classification_keyword");
			gdpr_comp.dsn = dsn;
			gdpr_data = gdpr_comp.get_classification_keyword_byId(keyword_id :'#attributes.id#');

			attributes.id = gdpr_data.keyword_id;
			attributes.keyword =   gdpr_data.keyword;  
			attributes.keyword_type = gdpr_data.keyword_type;
			attributes.search_type = gdpr_data.search_type;
			attributes.data_category_id = gdpr_data.data_category_id;
			attributes.is_active = gdpr_data.is_active;
		}else{
			writeOutput("<script>alert('Hata Oluştu');</script>");
			exit;
		}
	}
</cfscript>

<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="gdpr_keyword" id="gdpr_keyword" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=GDPR.welcome&event=upd&id=<cfoutput>#attributes.id#</cfoutput>">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
			<input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>" />
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
					<div class="form-group" id="item-keyword">
						<label class="col col-4 col-xs-12" for="keyword"><cf_get_lang dictionary_id='47722.Anahtar Kelime'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-data_category_id">
						<label class="col col-4 col-xs-12" for="is_active"><cf_get_lang dictionary_id='61728.Veri Kategori Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="data_category_id" id="data_category_id">
								<cfoutput query="types">
									<option VALUE="#DATA_CATEGORY_ID#" <cfif attributes.data_category_id eq DATA_CATEGORY_ID>selected</cfif>>#DATA_CATEGORY# (#DATA_CATEGORY_DESCRIPTION#)</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-is_active">
						<label class="col col-4 col-xs-12" for="keyword_type"><cf_get_lang dictionary_id='34969.Kelime'><cf_get_lang dictionary_id='30152.Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="keyword_type" id="keyword_type">
								<cfoutput>
								<cfloop index="ty" array="#keyword_types#">
									<option VALUE="#ty.value#" <cfif attributes.keyword_type eq ty.value>selected</cfif>>#ty.name#</option>
								</cfloop>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-search_type">
						<label class="col col-4 col-xs-12" for="search_type"><cf_get_lang dictionary_id='47641.Arama'><cf_get_lang dictionary_id='30152.Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="search_type" id="search_type">
								<cfoutput>
								<cfloop index="kst" array="#keyword_search_types#">
									<option VALUE="#kst.value#" <cfif attributes.search_type eq kst.value>selected</cfif>>#kst.name#</option>
								</cfloop>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-is_active">
						<label class="col col-4 col-xs-12" for="is_active"><cf_get_lang dictionary_id='57493.Aktif'></label>
						<div class="col col-8 col-xs-12">
							<select name="is_active" id="is_active">
								<cfoutput>
								<cfloop index="st" array="#status#">
									<option VALUE="#st.value#" <cfif attributes.is_active eq st.value>selected</cfif>>#st.name#</option>
								</cfloop>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6">
					<cfif isDefined("gdpr_data") and gdpr_data.RecordCount gt 0>
						<cf_record_info query_name="gdpr_data">
					</cfif>
				</div>
				<div class="col col-6">
					<cfif attributes.event EQ "upd">
						<cf_workcube_buttons is_upd='1' is_delete="0" add_function="controlFormGdpr()"><!---  delete_page_url="#request.self#?fuseaction=gdpr.welcome&event=del&id=#attributes.id#" --->
					<cfelse>
						<cf_workcube_buttons is_upd='0' add_function="controlFormGdpr()">
					</cfif>
				</div>
			</cf_box_footer>
		</cfform>
  	</cf_box>
</div>
<script type="text/javascript">
    function controlFormGdpr()
    {
		if(!$("#keyword").val().length)
		{
			alert('<cf_get_lang dictionary_id="58194.girilmesi zorunlu alan">');
			$("#keyword").focus();
			return false;
		}
		return true;
    }
</script>