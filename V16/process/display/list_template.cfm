<cffile action="read" variable="xmldosyam" file="#index_folder#process#dir_seperator#files#dir_seperator#process_template.xml" charset = "UTF-8">
<cfscript>
	dosyam = XmlParse(xmldosyam);
	xml_dizi = dosyam.process_stage_file.XmlChildren;
	d_boyut = ArrayLen(xml_dizi);
</cfscript>
<div class="row">
	<div class="col col-12">
		<h4 class="wrkPageHeader"><cfoutput>#getLang('process',75)#</cfoutput></h4>
	</div>
</div>
<cf_medium_list>
        <thead>
		<tr>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='55060.Modül'></th>
			<th><cf_get_lang dictionary_id='58640.Şablon'></th>
			<th><cf_get_lang dictionary_id='57630.Tip'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
		</tr>
	</thead>
	<tbody>
		<cfloop index="i" from="1" to ="#d_boyut#">
			<cfoutput>
				<tr>
					<td valign="top" width="30">#i#</td>
					<td valign="top" nowrap>#dosyam.process_stage_file.stage_file[i].file_module.XmlText#</td>
					<td valign="top" nowrap><!--- <a href="#dir_seperator##dir_seperator##cgi.remote_host##dir_seperator#process#dir_seperator#files#dir_seperator##dosyam.process_stage_file.stage_file[i].file_name.XmlText#" class="tableyazi"> --->#dosyam.process_stage_file.stage_file[i].file_name.XmlText#<!--- </a> ---></td>
					<td>#dosyam.process_stage_file.stage_file[i].file_type.XmlText#</td>
					<td valign="top">#dosyam.process_stage_file.stage_file[i].file_aim.XmlText#</td>
				</tr>
				</cfoutput>
			</cfloop>
		</tbody>
    </cf_medium_list>
