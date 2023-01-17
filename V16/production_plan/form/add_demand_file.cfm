<cfsetting showdebugoutput="no">
<cfoutput>
	<cf_box title="#getLang('','Dosya Ekle',57515)#" sscroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="form_add_file" action="" method="post" enctype="multipart/form-data">
			<cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="form_ul_uploaded_file">
                    </div>
                    <div class="form-group" id="form_ul_uploaded_file">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
                        <div class="col col-6 col-xs-12">
                            <cfinput type="file" id="uploaded_file" name="uploaded_file" required="yes" message="#getLang('','Belge Seçiniz',47469)#">
                        </div>
                    </div>
                </div>
				<div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
					<cf_get_lang dictionary_id="44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır"> . <br/><br/>
					<cf_get_lang dictionary_id="36516.Belgede toplam 7 alan olacaktır alanlar sırası ile">;<br/>
						1 - <cf_get_lang dictionary_id="57518.Stok Kodu"> <cf_get_lang dictionary_id="57998.veya"> <cf_get_lang dictionary_id="57789.Özel Kod"> (<cf_get_lang dictionary_id="29801.Zorunlu">)<br/>
						2 - <cf_get_lang dictionary_id="57635.Miktar"> (<cf_get_lang dictionary_id="29801.Zorunlu">)<br/>
						3 - <cf_get_lang dictionary_id="36536.Spect Main ID"><br/>
						4 - <cf_get_lang dictionary_id="58053.Başlangıç Tarihi"><br/>
						5 - <cf_get_lang dictionary_id="57700.Bitiş Tarihi"><br/>
						6 - <cf_get_lang dictionary_id="57611.Sipariş"> <cf_get_lang dictionary_id="58508.Satır"> <cf_get_lang dictionary_id="58527.ID"><br/>
						7 - <cf_get_lang dictionary_id="36438.Talep Numarası"><br/>
			</div>
			</cf_box_elements>
			<cf_box_footer>
                <cf_workcube_buttons insert_info='#getLang('','Listele',58715)#' add_function="ekle_form_action()" is_cancel='0'>
			</cf_box_footer>
	</cfform>
	</cf_box>
</cfoutput>
<script type="text/javascript">
	function ekle_form_action()
	{
		if(document.all.uploaded_file.value == "")
		{
			alert("<cf_get_lang dictionary_id='36540.Belge Seçmelisiniz'> !");
			return false;
		}
		form_add_file.action = "<cfoutput>#request.self#?fuseaction=prod.demands&event=multi-add&is_collacted=1&is_from_file=1<cfif isdefined("attributes.is_demand")>&is_demand=1</cfif></cfoutput>";
		return true;
	}
</script>
<cfabort>
