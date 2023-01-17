<cfquery name="GET_FORMAT" datasource="#DSN#">
	SELECT 
		* 
	FROM	
		SETUP_FILE_FORMAT
<cfif isDefined("attributes.file_format_id")>
	WHERE 
		FORMAT_ID = #attributes.file_format_id#
</cfif>
</cfquery>
<cfinclude template="../query/get_file_format.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Dosya Formatları','42108')#" add_href="#request.self#?fuseaction=settings.form_add_file_format" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
			<cfinclude template="../display/list_file_formats.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="file_format" method="post" enctype="multipart/form-data"  action="#request.self#?fuseaction=settings.emptypopup_file_format_upd&icon_name=#get_format.icon_name#&server_id=#get_format.icon_name_server_id#">
				<input type="Hidden" name="file_format_id" id="file_format_id" value="<cfoutput>#attributes.file_format_id#</cfoutput>">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-format_symbol">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58594.Format'>*</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='43723.Format Eklemelisiniz'>!</cfsavecontent>
								<cfinput type="Text" name="format_symbol" id="format_symbol" maxlength="50" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="#message#" value="#get_format.format_symbol#" required="yes">
							</div>
						</div>
						<div class="form-group" id="item-icon">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29762.İmaj'>*</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<div class="input-group">
									<input type="hidden" name="old_icon" id="old_icon" value="<cfoutput>#get_format.icon_name#</cfoutput>">
									<input type="file" name="icon" id="icon" value="">
									<span class="input-group-addon" href="javascript://" onClick="windowopen('<cfoutput>#file_web_path#settings/#get_format.icon_name#</cfoutput> ','medium');"><i class="fa fa-image"></i></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-css">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63081.CSS'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<cfinput type="Text" name="css_file" id="css_file" value="#get_format.CSS_FILE_NAME#">
							</div>
						</div>
						<div class="form-group" id="item-size">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57713.Boyut'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<div class="input-group">
									<cfinput type="Text" name="format_size" id="format_size" value="#get_format.format_size#" onkeyup="isNumber(this);">
									<span class="input-group-addon">MB</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-format_description">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='29725.Maksimum Karakter Sayısı'>: 100</cfsavecontent>
								<cfinput type="Text" name="format_description" id="format_description"  maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="#message#" value="#get_format.FORMAT_DESCRIPTION#">
							</div>
						</div>		
					</div>				
				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="get_format">
					<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_file_format_del&file_format_id=#attributes.file_format_id#' add_function="kontrol();control()">
				</cf_box_footer>
			</cfform>
		</div>				
	</cf_box>
</div>		
<script type="text/javascript">
    function control()
    {
        var obj =  document.file_format.icon.value;		
        if ((obj != "") && (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() != 'jpg'))
        {
            alert("<cf_get_lang dictionary_id='43417.Lütfen jpg formatında resim giriniz'> ");        
            return false;
        }	
        document.getElementById('upload_status').style.display = '';		
        return true;
    }
</script>

