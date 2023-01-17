
<cf_xml_page_edit fuseact="settings.form_add_sector_cat" is_multi_page="1">
	<cf_box title="#getLang('','Sektör Kategorisi Ekle',42451)#" uidrop="1" >
	<cfform name="add_sector_cat" action="#request.self#?fuseaction=settings.emptypopup_sector_cat_add" method="post" enctype="multipart/form-data">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12">

					<div class="form-group" >
						<label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='43647.Üst Sektör'></label>
						   <div class="col col-8  col-xs-12"> 
							<cfinclude template="../query/get_sector_cat_upper.cfm">
							<select name="sector_upper" id="sector_upper"  onchange="put_upper_code();">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_sector_cat_upper">
									<option value="#sector_upper_id#">#sector_cat#</option>
								</cfoutput>
							</select>
							</div>
					</div>
					<div class="form-group" >
						<label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='58585.Kod'></label>
						   <div class="col col-8  col-xs-12"> 
								<input type="text" name="upper_sector_cat_code" id="upper_sector_cat_code" value="" readonly="readonly" />
            					<input type="text" name="sector_cat_code" id="sector_cat_code" value="" onkeyup="isNumber(this);"  />
                
							</div>
					</div>
					<div class="form-group" >
						<label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'> *</label>
						   <div class="col col-8  col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="sector_cat"  value="" maxlength="255" required="Yes" message="#message#">
							
							</div>
					</div>
					<div class="form-group" >
						<label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='54820.Limit'></label>
						   <div class="col col-8  col-xs-12"> 
							<cfinput type="text" name="sector_limit" value=""  onkeyup="return(FormatCurrency(this,event));">
							</div>
					</div>
					<div class="form-group" >
						<label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='29762.İmaj'></label>
						   <div class="col col-8  col-xs-12"> 
							<input type="file" name="sector_image" id="sector_image" >
							</div>
					</div>
					<div class="form-group" >
						<label class="col col-4  col-xs-12"></label>
						   <div class="col col-8  col-xs-12"> 
							<input type="checkbox" name="is_internet" id="is_internet" value="1"> <cf_get_lang dictionary_id='43478.İnternette Yayımlansın'>
							</div>
					</div>
				</div>

			</cf_box_elements>
  <cf_box_footer>
	<cf_workcube_buttons is_upd='0' add_function="check_catid()">
    </cf_box_footer>
</cfform>
</cf_box>

<script type="text/javascript">
	function put_upper_code()
	{
		upper_sector_id = document.getElementById("sector_upper").options[document.getElementById("sector_upper").selectedIndex].value;
		query = 'SELECT SECTOR_CAT_CODE FROM SETUP_SECTOR_CAT_UPPER WHERE SECTOR_UPPER_ID = ' + upper_sector_id;
		result = wrk_query(query,'dsn','10');
		document.getElementById('upper_sector_cat_code').value = result.SECTOR_CAT_CODE;
	}
	function check_catid()
	{
		upper_sector_id = document.getElementById("sector_upper").options[document.getElementById("sector_upper").selectedIndex].value;
		sector_cat_code_input = document.getElementById('sector_cat_code').value;
		if (upper_sector_id == '' && sector_cat_code_input == '')
		return true;
		sector_cat_query = 'SELECT SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_UPPER_ID = ' + upper_sector_id + ' AND SECTOR_CAT_CODE = ' + sector_cat_code_input ;
		if (upper_sector_id == '' && sector_cat_code_input != '' )
		<cfif xml_is_uppercat_required eq 1> //Üst Kategorisi yok ise alt sektör kod kontrolü yapılsınmı
		return true;
		<cfelse>
		sector_cat_query = 'SELECT SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_UPPER_ID IS NULL AND SECTOR_CAT_CODE = ' + sector_cat_code_input;  
		</cfif>
		sector_cat_result = wrk_query(sector_cat_query,'dsn','10');
		if (sector_cat_result.recordcount > 0)
		{
		alert('Alt Sektör Kodu Mevcuttur Lütfen Değiştirin!');
		return false;
		}
	}
</script>

