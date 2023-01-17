<cfinclude template="xml_data.cfm">
<cfset attributes.mode = 3>

<div class="row">
	<div class="col col-12 uniqueRow">
		<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
			<br>
			<cfform name="create_documentation" id="create_documentation" action="#request.self#?fuseaction=protein.emptypopup_add_xml_file" enctype="multipart/form-data" method="post">
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
					<div class="col col-3"><p style="font-size:16px;">Çıktı Formatı </p></div>
					<div class="col col-3">						
						<select name="print_type" class="form-control" id="print_type" style="width:120px;">
							<option value="">XML</option>
						</select>	
					</div>
				</div>
				<div class="form-group require">
					<div class="col col-3"><p style="font-size:16px;">Dosya İsmi *</p></div>
					<div class="col col-3">						
						<input type="text" name="documentation_main_tag" id="documentation_main_tag" value="">	
					</div>
				</div>
				<div class="form-group require">
					<div class="col col-3"><p style="font-size:16px;">Açıklama </p></div>
					<div class="col col-3">						
						<textarea id="desciription" name="desciription" class="form-control" style="width:230px;height:80px;"> </textarea>	
					</div>
					<!--- <input type="submit" class="btn btn-info" onclick="return control();" value="Kaydet"> --->
					<cf_workcube_buttons is_upd='0' add_function='control()'>
				</div>				
			</div>
			</cfform>
		</div>
	</div>
</div>
<script>
	function control()
	{
		var deger = document.getElementById("documentation_main_tag").value;
		if(deger == '')
		{
			alert("Lütfen XML Dosya İsmi Veriniz!");
			return false;
		}
	}
</script>