<cfsetting showdebugoutput="no">
<cfparam name="attributes.modal_id" default="">
<cfoutput>
	<cf_box title="Dosya Ekle" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<iframe src="" width="1" height="1" style="display:none;" name="import_file_frame" id="import_file_frame"></iframe>
	<cfform name="upload_form_page"  action="#request.self#?fuseaction=cheque.emptypopup_get_payroll_entry_from_file" target="import_file_frame">
	<cf_box_elements>
		<input type="hidden" name="cash_currency" id="cash_currency" value="#listlast(attributes.cash_currency,';')#" />
		<div class="form-group">
			<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='56.Belge'> *</label>
			<div class="col col-8 col-md-6 col-xs-12">
				<input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-6 col-xs-12"></label>
			<div class="col col-8 col-md-6 col-xs-12">
			</div>
		</div>
		<div class="form-group">
			<div class="col col-12 col-md-12 col-xs-12">

					<b><cf_get_lang dictionary_id="58594.Format"></b><br/>
					<cf_get_lang dictionary_id="44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır. Aktarım işlemi dosyanın 2. satırından itibaren başlar, bu yüzden birinci satırda alan isimleri olmalıdır.">
					<cf_get_lang dictionary_id="56453.Belgede toplam 13 alan olacaktır."> <cf_get_lang dictionary_id="56452.İşaretli alanlar zorunludur. Alanlar sırası ile şu şekilde olmalıdır">;<br/>

					1 - <cf_get_lang dictionary_id="50220.Çek No"> *<br/>

					2 - <cf_get_lang dictionary_id="50973.İşlem Para Birimi"> *<br/>
				
				
					3 - <cf_get_lang dictionary_id="57881.Vade Tarihi"> *<br/>
				
				
					4 - <cf_get_lang dictionary_id="50300.Cari Hesap Çeki"><br/>
				
				
					5 - <cf_get_lang dictionary_id="57521.Banka"><br/>
				
				
					6 - <cf_get_lang dictionary_id="58933.Banka Şubesi"><br/>
				
				
					7 - <cf_get_lang dictionary_id="58178.Hesap No"><br/>
				
				
					8 - <cf_get_lang dictionary_id="57789.Özel Kod"><br/>
				
				
					9 - <cf_get_lang dictionary_id="58762.Vergi Dairesi"><br/>
				
				
					10 - <cf_get_lang dictionary_id="57752.Vergi No"><br/>
				
				
					11 - <cf_get_lang dictionary_id="58181.Ödeme Yeri"><br/>
				
				
					12 - <cf_get_lang dictionary_id="58180.Borçlu"><br/>
				
				
					13 - <cf_get_lang dictionary_id="58970.Ciro Eden"><br/>
				
			</div>
		</div>
	</cf_box_elements>
<cf_box_footer>
	<cfsavecontent variable="message"><cf_get_lang_main no ='1303.Listele'></cfsavecontent>
     <cf_wrk_search_button button_type="2" search_function="ekle_form_action()" button_name="#message#">
</cf_box_footer>
	</cfform>
</cf_box>
</cfoutput>
<script type="text/javascript">
	function ekle_form_action()
	{
		if(document.getElementById('uploaded_file').value == "")
		{
			alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>!");
			return false;
		}
		else{
   var form = $(this);
   var url = form.attr('action');
      $.ajax({
	   type: "POST",
	   url: url,
	   success: function(data)
	   {
	   <cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	   }
	 });
		}
	}
</script>
