<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='37000.Kalite Başarımı'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.add_production_quality_success" is_blank="0">


            <cfform  name="add_lib" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_quality_success">
        		<cf_box_elements>
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <cfinclude template="../display/quality_success.cfm">
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-is_success_type">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12"> &nbsp </div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="radio" name="is_success_type" id="is_success_type" value="1"><cf_get_lang dictionary_id='42792.Kabul'>
                                </div>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="radio" name="is_success_type" id="is_success_type" value="0"><cf_get_lang dictionary_id='29537.Red'>
                                </div>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="radio" name="is_success_type" id="is_success_type" value="2"><cf_get_lang dictionary_id='42799.Yeniden Muayene'>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-qua-success">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37000.Kalite Başarımı'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="Text" name="qua_success" id="qua_success" value="" maxlength="50" required="Yes" message="#message#" >
                            </div>
                        </div>
                        <div class="form-group" id="item-quality-color">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43496.Renk Kodu'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_color_picker name="quality_color" id="quality_color" width="200">
                            </div>
                        </div>
                        <div class="form-group" id="item-quality-code">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58585.Kod'></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="Text" name="code" id="code" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="detail" id="detail" maxlength="50" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);" style="height:60px;" message="<cf_get_lang dictionary_id='50595.En Fazla 50 Karakter'>!"></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-is_default_type">
                            <div class="col col-4 col-xs-12">&nbsp</div>
                            <div class="col col-8 col-xs-12">
                                <input type="checkbox" name="is_default_type" id="is_default_type" value="1"><cf_get_lang dictionary_id='43115.Standart Seçenek Olarak Gelsin'>
                            </div>
                        </div>
					</div>
                </div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function="kontrol()">
				</cf_box_footer>
			</cfform>

  	</cf_box>
</div>

<script type="text/javascript">
    function kontrol(){
        var deger = document.add_lib.is_success_type.value;		
        if(deger == ''){
        alert("Kabul - Red - Yeniden Muayeneden bir tanesini seçmelisiniz!")
        return false;	
        }
        return true;
        
    }
    
    function pageLoad(page){
         AjaxPageLoad('index.cfm?fuseaction='+page+'&spa=1','pageContent');
        }
</script>