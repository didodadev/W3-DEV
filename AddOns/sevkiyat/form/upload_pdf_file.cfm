<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/upload_pdf_file.cfm">
<cfelse>
	<cf_form_box title="Upload PDF" nofooter="1">
		<cfform action="index.cfm?fuseaction=sevkiyat.upload_pdf_file" method="post" enctype="multipart/form-data">
			<cfinput type="hidden" name="is_submit" value="1">
			
			<div class="row" type="row">
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-process_cat">
					<label class="col col-3 col-xs-12">File</label>
					<div class="col col-9 col-xs-12"><cfinput type="file" name="fileToUpload" id="fileToUpload" required="yes" message="Upload File!"></div>
				</div>
				<div class="form-group" id="item-process_cat">
					<label class="col col-3 col-xs-12">Type</label>
					<div class="col col-9 col-xs-12">
						<select name="pdf_type">
							<option value="SG">SG</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-process_cat">
					<label class="col col-3 col-xs-12"></label>
					<div class="col col-9 col-xs-12">
						<input type="submit" value="Upload PDF" name="submit">
					</div>
				</div>
			</div>
			</div>			
		</cfform>
	</cf_form_box>
</cfif>