<cf_box title="Product-Price-Stock Wizard" closable="0">
	<cfinclude template="product_export_xml_data.cfm">
	<cfset attributes.mode = 3>
	<div class="row">
		<div class="col col-12 uniqueRow">
			<div class="row">
			<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
				<br>
				<cfform name="create_documentation" id="create_documentation" action="" enctype="multipart/form-data" method="post">
					<div class="row" type="row">
						<div class="column" id="general">
							<cfloop from="1" to="#listlen(id_list,'*')#" index="sira">
							<cfoutput>
							<cfif sira eq 1 or sira mod attributes.mode eq 1><div class="form-group require"></cfif>
								<cfset id_ = trim(listgetat(id_list,sira,'*'))>
								<cfset text_ = trim(listgetat(name_list,sira,'*'))>
								<cfset value_ = trim(listgetat(text_name_list,sira,'*'))>
								<div class="col col-2">
									<input type="checkbox" name="#id_#" id="#id_#" value="1" checked>&nbsp;#text_#
								</div>
								<div class="col col-2">						
									<input type="text" id="#id_#_text" name="#id_#_text" value="#value_#">		
								</div>
							<cfif sira eq listlen(id_list,'*') or (sira gte attributes.mode and sira mod attributes.mode eq 0)></div></cfif>
							</cfoutput>
							</cfloop><br><br><br><br>
							<div class="form-group require">
								<label class="col col-2"><cf_get_lang dictionary_id='46248.Belge Formatı'></label>
								<div class="col col-3">						
									<select name="print_type" class="form-control" id="print_type" style="width:120px;">
										<option value="1">XML</option>
										<option value="2">JSON</option> <!--- ekleme --->
									</select>	
								</div>
							</div>
							<div class="form-group require">
								<label class="col col-2"><cf_get_lang dictionary_id='29800.Dosya Adı'> *</label>
								<div class="col col-3">						
									<input type="text" name="documentation_main_tag" id="documentation_main_tag" value="" required>	
								</div>
							</div>
							<div class="form-group require">
								<label class="col col-2">Root *</label>
								<div class="col col-3">						
									<input type="text" name="root" id="root" value="root" required>	
								</div>
							</div>
							<div class="form-group require">
								<label class="col col-2">Item *</label>
								<div class="col col-3">						
									<input type="text" name="item" id="item" value="item" required>	
								</div>
							</div>
							<div class="form-group require">
								<label class="col col-2"><cf_get_lang dictionary_id='53710.Para Formatı'></label>
								<div class="col col-3">						
									<select name="money_type" class="form-control" id="money_type" style="width:120px;">
										<option value="1"><cf_get_lang dictionary_id='42242.Sembol'></option>
										<option value="2"><cf_get_lang dictionary_id='30394.Yazı'></option>
									</select>	
								</div>
							</div>
							<div class="form-group require">
								<label class="col col-2"><cf_get_lang_main no='217.Açıklama'></label>
								<div class="col col-3">						
									<textarea id="desciription" name="desciription" class="form-control" style="width:230px;height:80px;"> </textarea>	
								</div>
							</div>				
						</div>
					</div>
					<div class="row formContentFooter">
						<div class="form-group">
							<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
						</div>
					</div>
				</cfform>
			</div>
		</div>
		</div>
	</div>
</cf_box>

<cf_box title="Versions" closable="0">
	<cfinclude template="product_export_wex.cfm">
</cf_box>

<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById('documentation_main_tag').value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='29800.Dosya Adı'>!");
			document.getElementById('documentation_main_tag').focus();
			return false;
		}
		if(document.getElementById('root').value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: Root!");
			document.getElementById('root').focus();
			return false;
		}
		if(document.getElementById('item').value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>: Item!");
			document.getElementById('item').focus();
			return false;
		}
		return true;
	}
</script>