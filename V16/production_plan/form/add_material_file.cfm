<cfsetting showdebugoutput="no">
<cfoutput>
    <cfparam name="attributes.modal_id" default="">
        <cf_box id="demand_file" title="#getlang('','Dosya ekle','57515')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
            <cfform name="list_meterials_" method="post" action="" enctype="multipart/form-data">
            <cf_box_elements>
            <div class="form-group" id="item-uploaded_file">
                <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
            <div class="col col-8 col-md-8 col-xs-12">
                <input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
            </div>
            </div><div class="form-group col-12 col-md-12 col-xs-12" id="item-Format">
                <h3><cf_get_lang dictionary_id='58594.Format'></h3>
                </div>
            <div class="form-group col-12 col-md-12 col-xs-12" id="item-document">
                <cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır .Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır .'>
                    <cf_get_lang dictionary_id='44683.Belgede toplam 3 alan olacaktır'> <cf_get_lang dictionary_id='45042.alanlar sırası ile'>;<br/>
            </div>
            <div class="form-group col-12 col-md-12 col-xs-12" id="item-Stock">
         
                1 - <cf_get_lang dictionary_id='44964.Stok Kodu veya Özel Kod(Zorunlu)'>
             
            </div>
            <div class="form-group col-12 col-md-12 col-xs-12" id="item-Miktar">
                2 - <cf_get_lang dictionary_id='44965.Miktar (Zorunlu)'>
            </div>
            <div class="form-group col-12 col-md-12 col-xs-12" id="item-Spec">
                3 - <cf_get_lang dictionary_id='37354.Spec Main ID'>
            </div>
        </cf_box_elements>
            <cf_box_footer>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58715.Listele'></cfsavecontent>
                    <cf_workcube_buttons insert_info='#message#' add_function='ekle_form_action()' is_cancel='0'>
            </cf_box_footer>
        </cfform>
        </cf_box>
</cfoutput>
<script language="JavaScript">
	function ekle_form_action()
	{
		if(document.all.uploaded_file.value == "")
		{
			alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'> !");
			return false;
		}
		list_meterials_.action = "<cfoutput>#request.self#?fuseaction=prod.list_materials_total&is_from_file=1&list_type=2</cfoutput>";
		return true;
	}
</script>
