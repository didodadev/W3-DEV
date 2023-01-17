<cfset cmpLibrary = createObject("component","WDO.development.cfc.data_import_library") />
<cfset get_data = cmpLibrary.getData(data_import_id : attributes.data_import_id) />

<cfset list_wbo = createObject("component", "WDO.development.cfc.list_wbo")>
<cfset query_bp = list_wbo.getBestpractice()>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform method="post" name="upd_data_source" action="">
			<input type="hidden" name="data_import_id" id="data_import_id" value="<cfoutput>#attributes.data_import_id#</cfoutput>">
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_comp">  
						<label class="col-xs-12">
							<cf_get_lang dictionary_id='57574.Şirket'><cf_get_lang dictionary_id='60858.DB'>
							<input type="checkbox" name="is_comp" id="is_comp" value="1" tabindex="4" <cfif get_data.IS_COMP eq 1>checked</cfif>>
						</label>
					</div>
					<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_period">  
						<label class="col-xs-12">
							<cf_get_lang dictionary_id='58472.Dönem'><cf_get_lang dictionary_id='60858.DB'>
							<input type="checkbox" name="is_period" id="is_period" value="1" tabindex="4" <cfif get_data.IS_PERIOD eq 1>checked</cfif>>
						</label>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-data_import_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61332.Name'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='61332.Name'></cfsavecontent>
							<input type="text" name="data_import_name" id="data_import_name" value="<cfoutput>#get_data.NAME#</cfoutput>" required="yes" message="<cfoutput>#message#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52735.Type'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='52735.Type'></cfsavecontent>
							<select name="type" id="type" required="yes" message="<cfoutput>#message#</cfoutput>">
								<option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
								<option value="1" <cfif get_data.TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id='58637.Logo'></option>
								<option value="2" <cfif get_data.TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id='62669.Mikro'></option>
								<option value="3" <cfif get_data.TYPE eq 3>selected</cfif>><cf_get_lang dictionary_id='62670.SAP Hana'></option>
								<option value="4" <cfif get_data.TYPE eq 4>selected</cfif>><cf_get_lang dictionary_id='62671.Netsis'></option>
								<option value="5" <cfif get_data.TYPE eq 5>selected</cfif>><cf_get_lang dictionary_id='62672.Eta'></option>
								<option value="6" <cfif get_data.TYPE eq 6>selected</cfif>><cf_get_lang dictionary_id='62673.NetSuite'></option>
								<option value="7" <cfif get_data.TYPE eq 7>selected</cfif>><cf_get_lang dictionary_id='62674.SAP Business One'></option>
								<option value="8" <cfif get_data.TYPE eq 8>selected</cfif>><cf_get_lang dictionary_id='62671.Workday'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-import_wo">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52734.WO'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='52734.WO'></cfsavecontent>
								<input type="text" name="import_wo"  id="import_wo" value="<cfoutput>#get_data.IMPORT_WO#</cfoutput>" required="yes" message="<cfoutput>#message#</cfoutput>">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_faction_list&field_name=add_data_import_library.import_wo&is_upd=0&choice=1&draggable=1');return false;"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-author">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52783.Author'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="author" id="author" value="<cfoutput>#get_data.AUTHOR#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-file_path">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49955.File Path'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='49955.File Path'></cfsavecontent>
                                <input type="text" id="file_path" name="file_path" value="<cfoutput>#get_data.FILE_PATH#</cfoutput>" required="yes" message="<cfoutput>#message#</cfoutput>">
                                <span class="input-group-addon" onclick=""><i class="fa fa-code"></i></span>
                            </div>
                        </div>
                    </div>
					<div class="form-group" id="item-best_practice">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51038.Best Practice'></label>
						<div class="col col-8 col-xs-12">							
							<select name="best_practice">
								<option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
								<cfoutput query="query_bp">
									<option value="#BESTPRACTICE_ID#" <cfif get_data.BEST_PRACTICE eq BESTPRACTICE_ID>selected</cfif>>#BESTPRACTICE_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_data">
				<cf_workcube_buttons type_format="1" is_upd='1' del_function="del_control()">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
	function del_control() {
		document.upd_data_source.action = '<cfoutput>#request.self#?fuseaction=dev.data_import_library&event=del</cfoutput>';
		document.upd_data_source.submit();
	}

	$(function(){
		$('input[name=is_comp]').click(function(){
			if(!this.checked){
				$('input[name=is_period]').prop("checked", false);
			}
		});

		$('input[name=is_period]').click(function(){
			if(this.checked){
				$('input[name=is_comp]').prop("checked", true);
			}
		});
	});
</script>