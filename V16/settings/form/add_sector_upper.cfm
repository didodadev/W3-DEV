<cf_box title="#getLang('','Üst Sektör Ekle',43586)#" uidrop="1">
<cfform action="#request.self#?fuseaction=settings.emptypopup_sector_upper_add" method="post" name="add_sector_upper" enctype="multipart/form-data">
    <cf_box_elements>
        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="form-group" >
                             <label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'> *</label>
                                <div class="col col-8  col-xs-12"> 
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="sector_cat"  value="" maxlength="255" required="Yes" message="#message#">
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='58585.Kod'></label>
                                <div class="col col-8  col-xs-12"> 
                                    <input type="text" name="sector_cat_code" id="sector_cat_code"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col col-4  col-xs-12"><cf_get_lang dictionary_id='29762.İmaj'></label>
                                <div class="col col-8  col-xs-12"> 
                                    <div class="input-group">
                                        <input type="file" name="sector_image" id="sector_image"  value="" > 
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="col col-4 col-xs-12"></label>
                                <div class="col col-8 col-xs-12"> 
                                    <input type="checkbox" name="is_internet" id="is_internet" value="1" > <cf_get_lang dictionary_id='43478.İnternette Yayımlansın'>
                                </div>
                            </div>
</cf_box_elements>
    <cf_box_footer>
         <cf_workcube_buttons is_upd='0' add_function="check_catid()">
    </cf_box_footer>
</cfform>
</cf_box>

<script type="text/javascript">
	function check_catid(id)
	{
		id = document.getElementById('sector_cat_code').value;
		query = 'SELECT SECTOR_UPPER_ID FROM SETUP_SECTOR_CAT_UPPER WHERE SECTOR_CAT_CODE = ' + id;
		result = wrk_query(query,'dsn','10');
		if(result.recordcount > 0)
		{
		alert('Girmiş olduğunuz sektör kodu mevcuttur');
		return false;
		}
	}
</script>

