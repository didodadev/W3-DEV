<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfparam name="attributes.module_id" default="">
<cfparam name="attributes.asset_cat_id" default="19">
<cfparam name="attributes.property_id" default="11">

<cfform name="add_asset" method="post" enctype="multipart/form-data">
	<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
	<input type="hidden" name="action_section" id="action_section" value="<cfoutput>#attributes.action_section#</cfoutput>">
	<input type="hidden" name="asset_cat_id" id="asset_cat_id" value="<cfoutput>#attributes.asset_cat_id#</cfoutput>">
	<input type="hidden" name="property_id" id="property_id" value="<cfoutput>#attributes.property_id#</cfoutput>">
	<input type="hidden" name="module" id="module" value="<cfoutput>#attributes.module#</cfoutput>">
	<input type="hidden" name="module_id" id="module_id" value="<cfoutput>#attributes.module_id#</cfoutput>">
	<div class="row ui-scroll">
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<div class="form-group">
				<div class="drop">
					<div class="drop-zone">
						<span class="drop-zone__prompt">Drag file here or click and select</span>
						<input type="file" name="asset_file" id="asset_file" class="drop-zone__input">
					</div>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<label><cf_get_lang dictionary_id='29761.URL'></label>
						<cfsavecontent variable="msg"><cf_get_lang dictionary_id='65467.Dosyanın URL linkini yazarak belgeyi arşivleyebilirsiniz.'></cfsavecontent>
						<cfinput type="text" name="url" id="url" value="" maxlength="100" placeholder="#msg#" class="form-control">
					</div>
				</div>
			</div>        
			<div class="form-group">
				<label><cf_get_lang dictionary_id='32462.Document Name'> *</label>
				<cfsavecontent variable="msg"><cf_get_lang no='1615.Lütfen Belge Adı Giriniz'>!</cfsavecontent>
				<cfinput type="text" name="asset_file_name" id="asset_file_name" value="" maxlength="100" required="yes" message="#msg#" class="form-control">
			</div> 
			<div class="form-group">
				<label><cf_get_lang dictionary_id='38499.Annotation'></label>
				<textarea name="detail" id="detail" style="height:80px;" class="form-control"></textarea>
			</div>     
  
		</div>
		<div class="draggable-footer">
			<cfset act_id=attributes.action_section>
			<cfif attributes.action_section eq 'G_SERVICE_ID'>
				<cfset act_id='id'>
			<cfelseif attributes.action_section eq 'WORK_ID'>
				<cfset act_id='wid'>
			</cfif>
			<cf_workcube_buttons class="btn-save" data_action="/V16/objects2/cfc/asset:addAsset" next_page="#site_language_path#/#attributes.page_name#?#act_id#=" add_function="input_control()" is_insert="1">
			<cf_workcube_buttons extraButton="1" class="btn red-mint mr-2" extraFunction="clearForm()" extraButtonText = "#getLang('','',57934)#" update_status="0">
		</div>
	</div>
</cfform>
<script language="javascript">
	function clearForm(){
		$('form[name=add_asset]').reset();
		$('input[type=file]').val("");
		$('.drop-zone__thumb').remove();
	}
	function input_control()
	{
		
		if(document.getElementById('asset_file').value == ""  && document.getElementById('url').value == "")
		{
			alert("<cf_get_lang dictionary_id='61842.You must upload file.'>");
			return false;
		}
	}
	document.querySelectorAll(".drop-zone__input").forEach((inputElement) => {
	const dropZoneElement = inputElement.closest(".drop-zone");

	dropZoneElement.addEventListener("click", (e) => {
		inputElement.click();
	});

	inputElement.addEventListener("change", (e) => {
		if (inputElement.files.length) {
		updateThumbnail(dropZoneElement, inputElement.files[0]);
		}
	});

	dropZoneElement.addEventListener("dragover", (e) => {
		e.preventDefault();
		dropZoneElement.classList.add("drop-zone--over");
	});

	["dragleave", "dragend"].forEach((type) => {
		dropZoneElement.addEventListener(type, (e) => {
		dropZoneElement.classList.remove("drop-zone--over");
		});
	});

	dropZoneElement.addEventListener("drop", (e) => {
		e.preventDefault();

		if (e.dataTransfer.files.length) {
		inputElement.files = e.dataTransfer.files;
		updateThumbnail(dropZoneElement, e.dataTransfer.files[0]);
		}

		dropZoneElement.classList.remove("drop-zone--over");
	});
	});

	/**
	 * Updates the thumbnail on a drop zone element.
	 *
	 * @param {HTMLElement} dropZoneElement
	 * @param {File} file
	 */
	function updateThumbnail(dropZoneElement, file) {
	let thumbnailElement = dropZoneElement.querySelector(".drop-zone__thumb");

	// First time - remove the prompt
	if (dropZoneElement.querySelector(".drop-zone__prompt")) {
		dropZoneElement.querySelector(".drop-zone__prompt").remove();
	}

	// First time - there is no thumbnail element, so lets create it
	if (!thumbnailElement) {
		thumbnailElement = document.createElement("div");
		thumbnailElement.classList.add("drop-zone__thumb");
		dropZoneElement.appendChild(thumbnailElement);
	}

	thumbnailElement.dataset.label = file.name;

	// Show thumbnail for image files
	if (file.type.startsWith("image/")) {
		const reader = new FileReader();

		reader.readAsDataURL(file);
		reader.onload = () => {
		thumbnailElement.style.backgroundImage = `url('${reader.result}')`;
		};
	} else {
		thumbnailElement.style.backgroundImage = null;
	}
	}

</script>
