<cfparam name="attributes.instanceName" type="string">
<cfparam name="attributes.width" 		type="string" default="">
<cfparam name="attributes.height" 		type="string" default="200">
<cfparam name="attributes.toolbarSet" 	type="string" default="WRKContent">
<cfparam name="attributes.value" 		type="string" default="">
<cfparam name="attributes.checkBrowser" type="boolean" default="true">
<cfparam name="attributes.cssFontTags" type="boolean" default="true">
<cfparam name="attributes.maxCharCount" type="string" default="">
<cfparam name="attributes.devmode" type="string" default="0">
<cfparam name="attributes.config" 		type="struct" default="#structNew()#">
<cfparam name="attributes.label" type="string" default="Editör">

<cfif isdefined('session.ep')>
	<cfset temp_language = left(session.ep.language,2)>
<cfelseif isdefined('session.pp')>
	<cfset temp_language = left(session.pp.language,2)>
<cfelseif isdefined('session.ww')>
	<cfset temp_language = left(session.ww.language,2)>
<cfelseif isdefined('session.cp')>
	<cfset temp_language = left(session.cp.language,2)>	
</cfif>
<cfset server_machine_list = application.systemParam.systemParam().fusebox.server_machine_list>
<cfset server_machine = application.systemParam.systemParam().fusebox.server_machine>
<cfset doc_url_ = replace(listgetat(server_machine_list,server_machine,';'),"http://","","all")>
<cfset wrk_fck_add_url_ = doc_url_>
<cfoutput>
	<cfif thisTag.executionMode eq "start">
		<style>
			.weditor_content br{display:unset!important;}
			.boxRow { z-index: unset !important;}
		</style>		
		<link href="/JS/assets/lib/kothing/css/kothing-editor.min.css?v=18112020" rel="stylesheet">

		<link rel="stylesheet" href="/JS/codemirror/lib/codemirror.css">
		<link rel="stylesheet" href="/JS/codemirror/theme/mdn-like.css">
		<script src="/JS/codemirror/lib/codemirror.js"></script>		
		<script src="/JS/codemirror/mode/xml/xml.js"></script>
		<script src="/JS/codemirror/mode/javascript/javascript.js"></script>
		<script src="/JS/codemirror/mode/css/css.js"></script>
		<script src="/JS/codemirror/mode/vbscript/vbscript.js"></script>
		<script src="/JS/codemirror/mode/htmlmixed/htmlmixed.js"></script>
		<script src="/JS/codemirror/addon/show-hint.js"></script>
		<script src="/JS/codemirror/addon/selection/selection-pointer.js"></script>
		<script src="/JS/codemirror/addon/css-hint.js"></script>
		<script src="/JS/codemirror/addon/lint.js"></script>
		<script src="/JS/codemirror/addon/css-lint.js"></script>

		<cfif attributes.devmode eq "1">
			<style>
				span##show_dev_mode:hover {
					right: -44px !important;
				}

				span##show_dev_mode {
					padding: 3px;
					background: ##2196f3;
					color: ##fff;
					position: absolute;
					transform: rotate(90deg);
					right: -31px;
					top: 28px;
					font-weight: 500;
					border: 1px solid ##dadada;
					cursor: pointer;
					transition: all 0.2s ease-out;
				}
			</style>
			<div style="position:relative;">
				<span id="show_dev_mode"><i class="fa fa-code"></i> dev mode </span>
			</div>
			<div class="code form-group" id="item-code_#attributes.instanceName#" style="display: none; border: 1px solid ##dadada;">
				<textarea id="#attributes.instancename#_dev_code_mirror"  name="#attributes.instancename#_dev_code_mirror">#HTMLEditFormat(attributes.value)#</textarea>		
			</div>
		</cfif>

		<div class="weditor_content form-group" id="item-#attributes.instanceName#">
			<textarea id="#attributes.instancename#" style="display:none;" name="#attributes.instancename#">#HTMLEditFormat(attributes.value)#</textarea>		
		</div>
		<script src="/JS/assets/lib/kothing/kothing-editor.min.js?v=02022021"></script>	
		<script src="/JS/assets/lib/kothing/src/lang/en.js"></script>
		<script>
			<cfswitch expression="#attributes.toolbarset#"> 
				<cfcase value="WRKContent">
					var buttonList = [
						['undo', 'redo'],
						['font', 'fontSize', 'formatBlock'],
						['bold', 'underline', 'italic', 'strike', 'subscript', 'superscript'],
						['removeFormat'],
						['fontColor', 'hiliteColor'],
						['outdent', 'indent'],
						['align', 'horizontalRule', 'list', 'table'],
						['link', 'image', 'video'],
						['showBlocks', 'codeView'],
						['fullScreen','preview']
					];
				</cfcase>
				<cfcase value="Workcube">
					var buttonList = [
						['undo', 'redo'],
						['font', 'fontSize', 'formatBlock'],
						['bold', 'underline', 'italic', 'strike', 'subscript', 'superscript'],
						['removeFormat'],
						['fontColor', 'hiliteColor'],
						['outdent', 'indent'],
						['align', 'horizontalRule', 'list', 'table'],
						['link', 'image', 'video'],
						['showBlocks', 'codeView'],
						['fullScreen','preview']
					];
				</cfcase>
				<cfcase value="Special">
					var buttonList = [
						['undo', 'redo'],
						['preview'],
					];
				</cfcase>
				<cfcase value="mailcompose">
					var buttonList = [
						['undo', 'redo'],
						['font', 'fontSize'],
						['bold', 'underline', 'italic', 'strike', 'subscript', 'superscript'],
						['removeFormat'],
						['fontColor', 'hiliteColor'],
						['outdent', 'indent'],
						['align', 'horizontalRule', 'list', 'table'],
						['link', 'image'],
						['showBlocks', 'codeView'],
						['fullScreen','preview']
					];
				</cfcase> 
				<cfcase value="Basic">
					var buttonList = [
						['undo', 'redo'],
						['bold', 'underline', 'italic', 'strike', 'subscript', 'superscript'],
						['removeFormat'],
						['fontColor', 'hiliteColor'],
						['align', 'horizontalRule', 'list', 'table'],
						['link', 'image', 'video'],
						['fullScreen','preview']
					];
				</cfcase>
				<cfdefaultcase>
					var buttonList = [
						['undo', 'redo'],
						['font', 'fontSize', 'formatBlock'],
						['bold', 'underline', 'italic', 'strike', 'subscript', 'superscript'],
						['removeFormat'],
						['fontColor', 'hiliteColor'],
						['outdent', 'indent'],
						['align', 'horizontalRule', 'list', 'table'],
						['link', 'image', 'video'],
						['showBlocks', 'codeView']
					];
				</cfdefaultcase> 
			</cfswitch>
			$(document).ready(function() { 
				setTimeout(function(){
					weditor_#attributes.instancename# = KothingEditor.create('#attributes.instancename#', {
						mode: "classic",
						display: 'block',
						popupDisplay : 'local',
						iframe : true,
						width: '100%',
						height : '#attributes.height#',
						codeMirror: CodeMirror,			
						charCounter: true,
						<cfif len(attributes.maxCharCount)>maxCharCount: #attributes.maxCharCount#,</cfif>
						stickyToolbar : "45",
						toolbarItem : buttonList,
						imageUploadHeader: {"Access-Control-Allow-Origin": "*"},
						imageUploadUrl : "fckeditor/cfc/editor.cfc?method=upload_image"	
					});		
					weditor_#attributes.instancename#.onChange = function(contents) {
						/*zero-width space replace ediliyor*/
						content_val = contents.replace(/\u200B/g,'');
						var find = '​';
						var rgx = new RegExp(find, 'g');
						content_val = content_val.replace(rgx, '');
						$('textarea[name="#attributes.instancename#"]').val(content_val);
					};
					/*CK Editor kullanılıyorken yapılan kontroller için yeni editörde benzer fn oluşturldu SA030920*/
					CKEDITOR = {
						instances : {
							#attributes.instancename# : {
								getData: function() {
									/*zero-width space replace ediliyor*/
									content = weditor_#attributes.instancename#.getContents();
									content_val = content.replace(/\u200B/g,'');
									var find = '​';
									var rgx = new RegExp(find, 'g');
									content_val = content_val.replace(rgx, '');
									return content_val
								}
							}
						}
					};
					<cfif len(attributes.value)>
						weditor_#attributes.instancename#.setContents($('[name="#attributes.instancename#"]').val());				
					</cfif>
				},300);				
			});

			$(document).on('change', '##item-#attributes.instanceName# .CodeMirror', function() {
				$("##item-#attributes.instanceName# ._ke_command_codeView").trigger("click").trigger("click");
				weditor_#attributes.instancename#.save();
			});
			
			<cfif attributes.devmode eq "1">
				$( "##show_dev_mode" ).click(function() {			
					$(this).hide();
					weditor_#attributes.instancename#.disabled();
					weditor_#attributes.instancename#.hide();
					weditor_#attributes.instancename#.destroy();
					weditor_#attributes.instancename# = null;
					$( "##item-code_#attributes.instanceName#").show();
					
					var mixedMode = {
						name: "htmlmixed",
						tags: {
							style: [["type", /^text\/(x-)?scss$/, "text/x-scss"],
									[null, null, "css"]],
							custom: [[null, null, "customMode"]]
						}
					};
					var #attributes.instancename#_dev_code_mirror = CodeMirror.fromTextArea(document.getElementById("#attributes.instancename#_dev_code_mirror"), {
						mode: mixedMode,
						selectionPointer: true,
						lineNumbers: true,
						autoRefresh:true,
						theme: "mdn-like"
					});					
					#attributes.instancename#_dev_code_mirror .save();
					#attributes.instancename#_dev_code_mirror .on("change",function(){
						$( "###attributes.instancename#" ).val(#attributes.instancename#_dev_code_mirror.getValue());
					});							

					#attributes.instancename#_dev_code_mirror.refresh();

					CKEDITOR = {
						instances : {
							#attributes.instancename# : {
								getData: function() {
									/*zero-width space replace ediliyor*/
									content = #attributes.instancename#_dev_code_mirror.getValue();
									content_val = content.replace(/\u200B/g,'');
									var find = '​';
									var rgx = new RegExp(find, 'g');
									content_val = content_val.replace(rgx, '');
									return content_val
								}
							}
						}
					};
				});	
			</cfif>
			
		</script>
	</cfif>
</cfoutput>