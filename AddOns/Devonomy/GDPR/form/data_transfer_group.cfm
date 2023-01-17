<!---
    File: add_data_category_type.cfm
    Author: 
    Date: 
    Controller: 
    Description:
		
--->
<cfscript>
	enums = createObject("component","addons.devonomy.gdpr.cfc.enums");
	status = enums.get_status(is_form:true);

	if(Not isDefined("attributes.id")) attributes.id =  "";
	if(Not isDefined("attributes.data_transfer_group")) attributes.data_transfer_group =  "";  
	if(Not isDefined("attributes.data_transfer_group_description")) attributes.data_transfer_group_description = '';
	if(Not isDefined("attributes.is_active")) attributes.is_active = 1;

	if(attributes.event == "upd"){
		if(len(attributes.id)){
			gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.data_transfer_group");
			gdpr_data = gdpr_comp.get_data_transfer_group_byId(DATA_TRANSFER_GROUP_ID :'#attributes.id#');

			attributes.id = gdpr_data.data_transfer_group_id;
			attributes.data_transfer_group =   gdpr_data.data_transfer_group;  
			attributes.data_transfer_group_description = gdpr_data.data_transfer_group_description;
			attributes.is_active = gdpr_data.is_active;
		}else{
			writeOutput("<script>alert('Hata Oluştu');history.back();</script>");
			exit;
		}
	}
	
</cfscript>

<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="gdpr_data_transfer_group" id="gdpr_data_transfer_group" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=GDPR.data_transfer_group&event=upd&id=<cfoutput>#attributes.id#</cfoutput>">
			<input type="hidden" name="form_submitted" value="1" />
			<input type="hidden" name="id" value="<cfoutput>#attributes.id#</cfoutput>" />
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
					<div class="form-group" id="item-data_transfer_group">
						<label class="col col-4 col-xs-12" for="data_transfer_group"><cf_get_lang dictionary_id='61735.Veri Aktarım Grubu'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="data_transfer_group" id="data_transfer_group" value="<cfoutput>#attributes.data_transfer_group#</cfoutput>" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-data_transfer_group_description">
						<label class="col col-4 col-xs-12" for="data_transfer_group_description"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="data_transfer_group_description" id="data_transfer_group_description" maxlength="500" ><cfoutput>#attributes.data_transfer_group_description#</cfoutput></textarea>
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
						<cf_workcube_buttons is_upd='1' is_delete="0" add_function="controlFormGdpr()"><!---  delete_page_url="#request.self#?fuseaction=gdpr.data_transfer_group&event=del&id=#attributes.id#" --->
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
		if(!$("#data_transfer_group").val().length)
		{
			alert('<cf_get_lang dictionary_id="58194.girilmesi zorunlu alan">');
			$("#data_transfer_group").focus();
			return false;
		}
		return true;
    }
</script>