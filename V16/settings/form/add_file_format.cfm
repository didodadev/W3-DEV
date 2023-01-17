<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Dosya Formatları','42108')#" add_href="#request.self#?fuseaction=settings.form_add_file_format" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
			<cfinclude template="../display/list_file_formats.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="format_form"  method="post" action="#request.self#?fuseaction=settings.emptypopup_add_file_format" enctype="multipart/form-data">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-format_symbol">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58594.Format'>*</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='43723.Format Eklemelisiniz'>!</cfsavecontent>
								<cfinput type="Text" name="format_symbol" id="format_symbol" maxlength="50" value="" required="yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-icon">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29762.İmaj'>*</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='29762.İmaj'></cfsavecontent>
								<cfinput type="file" name="icon" id="icon" value="" required="yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-css">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63081.CSS'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<input type="Text" name="css_file" id="css_file" value="">
							</div>
						</div>
						<div class="form-group" id="item-size">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57713.Boyut'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<div class="input-group">
									<input type="Text" name="format_size" id="format_size" onkeyup="isNumber(this);">
									<span class="input-group-addon">MB</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-format_description">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<input type="Text" name="format_description" id="format_description" maxlength="100" onkeyup="return ismaxlength(this)" onblur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 100" value="">
							</div>
						</div>		
					</div>				
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='control();kontrol()'>
				</cf_box_footer>
			</cfform>
		</div>				
	</cf_box>
</div>				

<script type="text/javascript">
function control()
{
	var obj =  document.format_form.icon.value;		
	if ((obj == "") || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() != 'jpg')){
		alert("<cf_get_lang dictionary_id='43417.Lütfen jpg formatında resim giriniz'> !");        
		return false;
	}	
	return true;
}
</script>
