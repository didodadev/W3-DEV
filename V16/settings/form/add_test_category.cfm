<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Test Kategorileri','42271')#" add_href="#request.self#?fuseaction=settings.list_test_category" is_blank="0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
            <cfinclude template="../form/list_test_category.cfm"> 
        </div>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="save_category" id="save_category" action="#request.self#?fuseaction=settings.emptypopup_add_test_cat" method="post">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-cat_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42003.Kategori Adı'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="text" name="test_name" id="test_name" size="60" value="" maxlength="250" required="yes" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cftextarea name="detail" id="detail" style="width:180px; height:60px" maxlength="400"></cftextarea>  
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='control_()' is_cancel='0'>
                </cf_box_footer>
            </cfform>
        </div>
<script type="text/javascript">
	function  control_()
	{
		if(document.getElementById('test_name').value=='')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='42003.Kategori Adı'>");
			return false;
		}
		return true;
	}
</script>