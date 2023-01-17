<cfsetting showdebugoutput="no">
<link rel="stylesheet" href="/css/assets/template/codemirror/codemirror.css">

<cfset d_hata = a_hata = 0>
<cfif isdefined('attributes.main_action_file') and len(attributes.main_action_file)>
	<cfset file_name = isdefined('attributes.display_file') and attributes.display_file eq 1 ? 'Display File' : 'Main Display File' />
<cfelseif isdefined('attributes.main_file') and len(attributes.main_file)>
	<cfset file_name = isdefined('attributes.action_file') and attributes.action_file eq 1 ? 'Action File' : 'Main Action File' />
</cfif>

<cf_box title="#file_name#" closable="1" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_box_elements>
		<form name="upd_files" method="post" action="<cfoutput>#request.self#?fuseaction=process.emtypopup_upd_stage_files</cfoutput>">
			<input type="hidden" name="process_id_" id="process_id_" value="<cfoutput>#attributes.process_id#</cfoutput>">
			<cfif isDefined("attributes.process_row_id") and Len(attributes.process_row_id)>
            	<input type="hidden" name="process_row_id_" id="process_row_id_" value="<cfoutput>#attributes.process_row_id#</cfoutput>">
			</cfif>
			<input type="hidden" name="ftype" id="ftype" value="">
			<input type="hidden" name="type" id="type" value="">
			<cfif isdefined('attributes.main_action_file') and len(attributes.main_action_file)>
				<input type="hidden" value="<cfoutput>#attributes.main_action_file#</cfoutput>" name="display_file_name" id="display_file_name">
			<cfelseif isdefined('attributes.main_file') and len(attributes.main_file)>
				<input type="hidden" value="<cfoutput>#attributes.main_file#</cfoutput>" name="file_name" id="file_name">
			</cfif>
			<div id="loader_panel" style="width:100%;">
				<svg width="32px" height="32px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" class="uil-ring-alt"><rect x="0" y="0" width="100" height="100" fill="none" class="bk"></rect><circle cx="50" cy="50" r="40" stroke="rgba(255,255,255,0)" fill="none" stroke-width="10" stroke-linecap="round"></circle><circle cx="50" cy="50" r="40" stroke="#ff8a00" fill="none" stroke-width="6" stroke-linecap="round"><animate attributeName="stroke-dashoffset" dur="2s" repeatCount="indefinite" from="0" to="502"></animate><animate attributeName="stroke-dasharray" dur="2s" repeatCount="indefinite" values="150.6 100.4;1 250;150.6 100.4"></animate></circle></svg>
			</div>
			<!--- <cfdump  var="#attributes#"> --->
			<cfif isdefined('attributes.main_action_file') and len(attributes.main_action_file)>
				<cftry>
					<cfif attributes.is_main_action_file eq 1>
						<cffile action="read" file="#download_folder##attributes.main_action_file#" variable="kosul_file">
					<cfelse>
						<cffile action="read" file="#upload_folder#settings#dir_seperator##attributes.main_action_file#" variable="kosul_file">
					</cfif>
					<!--- Main Display --->
					<textarea name="dosya_icerik" id="dosya_icerik" style="display:none;"><cfoutput>#kosul_file#</cfoutput></textarea>
					<cfcatch type="any"><cf_get_lang dictionary_id='57969.Dosya Görüntüleme Hatası'>!<cfset d_hata = 1></cfcatch>
				</cftry>
			<cfelseif isdefined('attributes.main_file') and len(attributes.main_file)>
				<cftry> 
					<cfif attributes.is_main_file eq 1>
						<cffile action="read" file="#download_folder##attributes.main_file#" variable="diger_file">
					<cfelse>
						<cffile action="read" file="#upload_folder#settings#dir_seperator##attributes.main_file#" variable="diger_file">
					</cfif>
					<!--- Main Action --->
					<textarea name="dosya_icerik" id="dosya_icerik" style="display:none;"><cfoutput>#diger_file#</cfoutput></textarea>
					<cfcatch type="any"><cf_get_lang dictionary_id='57969.Dosya Görüntüleme Hatası'>!<cfset a_hata = 1></cfcatch>
				</cftry>
			</cfif>
		</form>
	</cf_box_elements>
	<cf_box_footer>
		<div class="col col-md-12">
			<cfif isdefined('attributes.main_action_file') and len(attributes.main_action_file)>
				<cfif attributes.is_main_action_file neq 1 and d_hata eq 0>
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='dosya_guncelle(1)'>
				</cfif>
			<cfelseif isdefined('attributes.main_file') and len(attributes.main_file)>
				<cfif attributes.is_main_file neq 1 and a_hata eq 0>
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='dosya_guncelle(2)'>
				</cfif>
			</cfif>	
		</div>
	</cf_box_footer>
</cf_box>

<script type="text/javascript" src="/JS/codemirror/codemirror.js"></script>
<script type="text/javascript" src="/JS/codemirror/simplescrollbars.js"></script>
<script type="text/javascript" src="/JS/codemirror/sql.js"></script>
<script type="text/javascript">
	
	setTimeout(function(){
		var codeMirrorcontent = document.getElementById("dosya_icerik");
		var codeMirrorEditor = CodeMirror.fromTextArea(codeMirrorcontent, {
			mode: "text/x-sql",
			lineNumbers: true,
			autofocus: true
		});
		document.getElementById('loader_panel').style.display = 'none';
	},5000);

	
	function dosya_guncelle(type)
	{		
		let res_array = [];
		$.each($('.CodeMirror-code span[role="presentation"]'), function(){
			res_array.push($(this).text());
		});
		document.getElementById('dosya_icerik').value = res_array.join('\n');
		
		if (type==1)//Display File
		{
			<cfif isdefined('attributes.is_main_action_file') and attributes.is_main_action_file eq 1>
				document.upd_files.ftype.value = 1;
			<cfelse>
				document.upd_files.ftype.value = 0;
			</cfif>
		}
		if (type==2)//Action File
		{
			<cfif isdefined('attributes.is_main_file') and attributes.is_main_file eq 1>
				document.upd_files.ftype.value = 1;
			<cfelse>
				document.upd_files.ftype.value = 0;
			</cfif>
		}
		document.upd_files.type.value = type;
		<cfif isDefined("attributes.draggable")>loadPopupBox('upd_files','<cfoutput>#attributes.modal_id#</cfoutput>')<cfelse>upd_files.submit()</cfif>;
	}
</script>