<cfparam name="attributes.modal_id" default="">
<cfsetting showdebugoutput="no">
<cfoutput>

	<cf_box title="#getLang('','Dosya Ekle',57515)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="upload_form_page" enctype="multipart/form-data" action="#request.self#?fuseaction=ch.emptypopup_add_collected_virman_from_file">
	<cf_box_elements>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
		<div class="form-group">
			<label class="col col-2"><cf_get_lang dictionary_id='57574.Şirket'></label>
			<div class="col col-4 col-md-4">
				<input type="file" name="uploaded_file" id="uploaded_file">
			</div>
			<div class="col col-6 col-md-6">
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4"><b><cf_get_lang dictionary_id="58594.Format"></b></label>
			<div class="col col-8 col-md-8">
			</div>
		</div>
		<b></b><br/>
		<div class="form-group">
			<label class="col col-12">
		<cf_get_lang dictionary_id="44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır. Aktarım işlemi dosyanın 2. satırından itibaren başlar, bu yüzden birinci satırda alan isimleri olmalıdır."><br/>
		<cf_get_lang dictionary_id="56453.Belgede toplam 13 alan olacaktır">. <cf_get_lang dictionary_id="56452.İşaretli alanlar zorunludur. Alanlar sırası ile şu şekilde olmalıdır">;<br/>
			<br/>1 - <cf_get_lang dictionary_id="30446.Borçlu Üye/Çalışan Kodu">
			<br/>2 - <cf_get_lang dictionary_id="30445.Alacaklı Üye/Çalışan Kodu"> 
			<br/>3 - <cf_get_lang dictionary_id="30443.Borçlu Proje ID">
			<br/>4 - <cf_get_lang dictionary_id="30438.Alacaklı Proje ID">
			<br/>5 - <cf_get_lang dictionary_id="30435.Borçlu Şube ID">
			<br/>6 - <cf_get_lang dictionary_id="30434.Alacaklı Şube ID">
			<br/>7 - <cf_get_lang dictionary_id="57880.Belge No">
			<br/>8 - <cf_get_lang dictionary_id="57673.Tutar">
			<br/>9 - <cf_get_lang dictionary_id="48861.Döviz Birimi">
			<br/>10 - <cf_get_lang dictionary_id="36199.Açıklama">
			<br/>11 - <cf_get_lang dictionary_id ="57587.Borç"><cf_get_lang dictionary_id="58851.Ödeme Tarihi"> *
			<br/>12 - <cf_get_lang dictionary_id="30429.Borçlu Fiziki Varlık ID">
			<br/>13 - <cf_get_lang dictionary_id="Alacaklı Fiziki Varlık ID">
			<br/>14 - <cf_get_lang dictionary_id="57588.Alacak"><cf_get_lang dictionary_id='58851.Ödeme Tarihi'>
			</label>
		</div>
		</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons insert_info='#getlang('','Listele','58715')#' add_function='ekle_form_action()' is_cancel='0'>
			</cf_box_footer>
		</cfform>
		</cf_box>
</cfoutput>
<script type="text/javascript">
	function ekle_form_action()
	{
		if(document.getElementById('uploaded_file').value == "")
		{
			alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>");
		}
		else
		{
			loadPopupBox('upload_form_page' , <cfoutput>#attributes.modal_id#</cfoutput>);
		}
	return false;
	}
</script>