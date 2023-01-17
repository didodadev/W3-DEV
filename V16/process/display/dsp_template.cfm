<cfif attributes.process_type eq 2>
	<!--- Burasi Islem Kategorilerinde Kullanilmak Uzere Eklenmis --->
 	<cffile action="read" variable="xmldosyam" file="#index_folder#process#dir_seperator#process_type_files#dir_seperator#process_template.xml" charset = "UTF-8">
	<cfscript>
		dosyam = XmlParse(xmldosyam);
		xml_dizi = dosyam.process_stage_file.XmlChildren;
		d_boyut = ArrayLen(xml_dizi);
	</cfscript>
	<cfif attributes.type eq 1><cfset type_ = 'display'></cfif>
	<cfif attributes.type eq 2><cfset type_ = 'action'></cfif>
	<cfset row_ = 0>

	<cf_medium_list_search title="#getLang('process',75)#"></cf_medium_list_search>
	<cf_medium_list>
		<thead>
			<tr>
				<th width="30"><cf_get_lang dictionary_id="57487.No"></th>
				<th><cf_get_lang dictionary_id='55060.Modül'></th>
				<th><cf_get_lang dictionary_id='58640.Şablon'></th>
				<th width="40"><cf_get_lang dictionary_id ='57630.Tip'></th>
				<th width="600"><cf_get_lang dictionary_id='57629.Açıklama'></th>
			</tr>
		</thead>
		<tbody>
			<cfloop index="i" from="1" to ="#d_boyut#">
				<cfif dosyam.process_stage_file.stage_file[i].file_type.XmlText is type_>
					<cfset row_ = row_ + 1>
					<cfoutput>
					<tr>
						<td width="30">#row_#</td>
						<td valign="top" nowrap>#dosyam.process_stage_file.stage_file[i].file_module.XmlText#</td>
						<td valign="top" nowrap><a href="javascript://" class="tableyazi" onClick="gonder('#dosyam.process_stage_file.stage_file[i].file_name.XmlText#');">#dosyam.process_stage_file.stage_file[i].file_name.XmlText#</a></td>
						<td>#dosyam.process_stage_file.stage_file[i].file_type.XmlText#</td>
						<td valign="top" width="600" nowrap>#dosyam.process_stage_file.stage_file[i].file_aim.XmlText#</td>
					</tr>
					</cfoutput>
				</cfif>
			</cfloop>
		</tbody>
	</cf_medium_list>
	<br/>
	<script type="text/javascript">
	function gonder(id1){
		opener.<cfoutput>#attributes.field_id#</cfoutput>.style.display='none';		
		opener.<cfoutput>#attributes.field_name#</cfoutput>.style.display='';
		opener.<cfoutput>#attributes.field_name#</cfoutput>.value=id1;
		<cfif isDefined("attributes.is_file")>
				opener.<cfoutput>#attributes.is_file#</cfoutput>.value=1;
		</cfif>
		<cfif attributes.type eq 1>
			opener.value11.style.display='none';
			opener.value12.style.display='';
		<cfelse>
			opener.value21.style.display='none';
			opener.value22.style.display='';
			/*islem kategorilerine template dosya eklerken*/
			if(opener.display_action_file_id != undefined)
				opener.display_action_file_id.style.display='none';
			if(opener.upd_process_cat != undefined && opener.upd_process_cat.display_action_file != undefined)
				opener.upd_process_cat.display_action_file.value='';
		</cfif>
		window.close();
	}
	</script>
<cfelse>
	
	<!--- Burasi Sureclerde Kullanilmak Uzere Eklenmis --->
	<!---  <cffile action="read" variable="xmldosyam" file="#index_folder#process#dir_seperator#files#dir_seperator#process_template.xml" charset = "UTF-8"> --->
	<!--- <cfloop index="i" from="1" to ="#d_boyut#">
		<cfquery name="add" datasource="#dsn#">
			INSERT INTO WRK_PROCESS_TEMPLATES
			(
				WRK_PROCESS_TEMPLATE_NAME,
				IS_ACTION,
				IS_DISPLAY,
				PROCESS_TEMPLATE_DETAIL,
				RELATED_WO,
				PROCESS_TEMPLATE_PATH
			)
			VALUES 
			(
				'#dosyam.process_stage_file.stage_file[i].file_module.XmlText#',
				<cfif dosyam.process_stage_file.stage_file[i].file_type.XmlText eq 'action'>1<cfelse>NULL</cfif>,
				<cfif dosyam.process_stage_file.stage_file[i].file_type.XmlText eq 'display'>1<cfelse>NULL</cfif>
				'#dosyam.process_stage_file.stage_file[i].file_aim.XmlText#',
				'#dosyam.process_stage_file.stage_file[i].file_fuseaction.XmlText#',
				'V16/process/files/#dosyam.process_stage_file.stage_file[i].file_name.XmlText#'

			)
		</cfquery>

	</cfloop> --->
	<cfset getComponent = createObject('component','WDO.development.cfc.process_template')>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.type" default="">
	<cfparam name="attributes.bp_code" default="">
	<cfparam name="attributes.related_sectors" default="">
	<cfparam name="attributes.related_wo" default="">
	<cfparam name="attributes.module" default="">
	<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
	<cfset get_process_templates = getComponent.get_process_templates(keyword : attributes.keyword, bp_code : attributes.bp_code, related_sectors : attributes.related_sectors, related_wo : attributes.related_wo, module : attributes.module, type: attributes.type)>
	<cfelse>
		<cfset get_process_templates.recordcount=0>
	</cfif>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="Process Templates" closable="1" draggable="1"  >
			<cfform name="list_process_templates" action="" method="post">
				<cf_box_search more="0">
					<input type="hidden" name="is_submitted" id="is_submitted" value="1" />
                    <input type="hidden" name="type" id="type" value="<cfoutput>#attributes.type#</cfoutput>" />
                    <div class="form-group">
                        <cfinput type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#getlang('main',48)#">
                    </div>                   
                    <div class="form-group">
                        <cfinput type="text" name="related_sectors" id="related_sectors" value="#attributes.related_sectors#" placeholder="Sectors">
					</div>
					<div class="form-group">
                        <cfinput type="text" name="bp_code" id="bp_code" maxlength="50" value="#attributes.bp_code#" placeholder="WBP">
                    </div>
                    <div class="form-group">
                        <cfinput type="text" name="related_wo" id="related_wo" value="#attributes.related_wo#" placeholder="WO">
                    </div>
                    <div class="form-group">
                        <select name="module" id="module">
                            <option value="">Module</option>
                            <cfset get_modules=getComponent.get_modules()>
                            <cfoutput query="get_modules">
                                <option value="#module_id#"<cfif attributes.module eq module_id>selected</cfif>>#module#</option>
                            </cfoutput>                                
                        </select>
                    </div>       
                    <div class="form-group">
						<cf_wrk_search_button button_type="4"  search_function="loader_page()">
                    </div>
                </cf_box_search>
			</cfform>
			<cf_flat_list>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th><span title="Main Stage Display Action">MSDA</span></th>
                        <th>WBP</th>
                        <th>Licence</th>
                        <th>Module</th>
                        <th width="20"><a href="javascript://" title="WO" alt="WO"><i class="fa fa-cube"></i></a></th>
                        <th>Author</th>
                        <th width="20"><a href="javascript://"><i class="fa fa-shopping-cart"></i></a></th>                        
                    </tr>
                </thead>
                
                <tbody>
                    <cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted) and get_process_templates.recordcount neq 0>
                        <cfoutput query="get_process_templates">
                            <tr>
                                <td>#currentrow#</td>
                                <td><a href="javascript://" class="tableyazi" onClick="gonder('#PROCESS_TEMPLATE_PATH#');">#WRK_PROCESS_TEMPLATE_NAME#</a></td>
                                <td><cfif is_main eq 1><span title="Main">M</span></cfif><cfif is_stage eq 1><span title="Stage">S</span></cfif><cfif is_display eq 1><span title="Display">D</span></cfif><cfif is_action eq 1><span title="Action">A</span></cfif></td>
                                <td>#BEST_PRACTISE_CODE#</td>
                                <td><cfif licence_type eq 1>Standart<cfelse>Add-on</cfif></td>
                                <td><cfif len(module_id)>#getComponent.get_module(module : module_id)#</cfif></td>
                                <td>
                                    <a href="javascript://"  title="WO" alt="WO" onclick="cfmodal('V16/process/display/list_processfuseactions.cfm?id=#WRK_PROCESS_TEMPLATE_ID#&process_template=1','warning_modal');"><i class="fa fa-cube"></i></a>
                                </td>
                                <td>#AUTHOR_NAME#</td>
                                <td><a href="javascript://"><i class="fa fa-shopping-cart"></i></a></td>                                
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="9">
                                <cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>
                            </td>
                        </tr>
                    </cfif> 
                    </tbody>
        
            </cf_flat_list>
		</cf_box>
	</div>
	<script type="text/javascript">
		function loader_page()
		{    
            adress_ = '<cfoutput>#request.self#?fuseaction=process.popup_dsp_template&process_type=1</cfoutput>'+ '&keyword='+document.getElementById('keyword').value+'&is_submitted=' + document.getElementById('is_submitted').value + '&bp_code=' + document.getElementById('bp_code').value  + '&related_sectors=' + document.getElementById('related_sectors').value + '&related_wo=' + document.getElementById('related_wo').value+ '&module=' + document.getElementById('module').value+'&type=' + document.getElementById('type').value ;
			AjaxPageLoad(adress_,'process_templates');
			return false;
		}
		function gonder(id1){
			document.<cfoutput>#attributes.field_id#</cfoutput>.style.display='none';		
			document.<cfoutput>#attributes.field_name#</cfoutput>.style.display='';
			document.<cfoutput>#attributes.field_name#</cfoutput>.value=id1;
			<cfif isDefined("attributes.is_file")>
				document.<cfoutput>#attributes.is_file#</cfoutput>.value=1;
			</cfif>
			<cfif attributes.type eq 1>
				$('#value11').hide();
				$('#value12').show();
			<cfelse>
				$('#value21').hide();
				$('#value22').show();
			</cfif>
			$('#process_templates').hide();
		}
	</script>
</cfif>
