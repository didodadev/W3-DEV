<script type="text/javascript">
function ColorPalette_OnClick(colorString){
	
	document.getElementById('pick').style.backgroundColor = colorString;
	document.event_cat.colour.value=colorString;
}
</script>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='39863.Olay Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_event_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_event_cat.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
        <cfform name="event_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_event_cat_add">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="eventCat">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52494.Olay Kategorisi'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='42643.Olay Kategorisi Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="Text" name="eventCat" id="eventCat" size="60" value="" maxlength="50" required="Yes" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="colour">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43496.Renk Kodu'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_color_picker name="colour" id="colour" width="200">
                            </div>
                        </div>
                        <div class="form-group" id="is_vip">
                            <div class="col col-4 col-xs-12">&nbsp</div>
                            <div class="col col-8 col-xs-12">
                                <input type="checkbox" name="is_vip" id="is_vip"><cf_get_lang dictionary_id='43497.Kişisel Olay'>
                            </div>
                        </div>
                        <div class="form-group" id="IS_RD_SSK">
                            <div class="col col-4 col-xs-12">&nbsp</div>
                            <div class="col col-8 col-xs-12">
                                <input type="checkbox" name="IS_RD_SSK" id="IS_RD_SSK" value="1"><cf_get_lang dictionary_id='31750.Arge Gününe Dahil'>
                            </div>
                        </div>
                        
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function="kontrol()">
				</cf_box_footer>
			</cfform>
    	</div>
  	</cf_box>
</div>