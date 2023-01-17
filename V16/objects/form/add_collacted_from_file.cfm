<cfoutput>
	<iframe src="" width="1" height="1" style="display:none;" name="import_file_frame" id="import_file_frame"></iframe>
	<cf_box title="#getlang('','Dosya Ekle','57515')#"  closable="1" draggable="1" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="upload_form_page" id="upload_form_page" enctype="multipart/form-data" action="#request.self#?fuseaction=objects.emptypopup_get_collacted_row_from_file" target="import_file_frame">
		<input type="hidden" name="type" id="type" value="#attributes.type#" />
	<cf_box_elements>
		<div class="col col-12">
		<div class="form-group" id="item-type">
			<label class="col col-2 col-md-2 col-xs-12"><cf_get_lang dictionary_id='43926.Üye Tipi'> *</label>
		<div class="col col-4 col-md-4 col-xs-12">
			<select name="member_type" id="member_type" style="width:200px;">
				<option value="0" selected><cf_get_lang dictionary_id='57734.Seciniz'></option>
				<option value="1"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></option>
				<option value="2"><cf_get_lang dictionary_id='57586.Bireysel Üye'></option>
				<option value="3"><cf_get_lang dictionary_id='30368.Çalışan'></option>
			</select>
		</div>
		</div>
		<div class="form-group" id="item-document">
			<label class="col col-2 col-md-2 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
		<div class="col col-4 col-md-4 col-xs-12">
			<input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
		</div>
		</div>
	</div>
			<table border="0" align="left">

				<cfif type eq 1><!--- type 1: Toplu Dekont Ekleme  --->
					<tr>
						<td colspan="2">
						<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
						<cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır. Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'>
						<cf_get_lang dictionary_id='60186.Belgede toplam 12 alan olacaktır'> <cf_get_lang dictionary_id='43095.yıldız işaretli alanlar zorunludur'>. <cf_get_lang dictionary_id='45042.Alanlar sırası ile'>;<br/>
						</td>
					</tr>
					<tr>
						<td colspan="2">1 - <cf_get_lang dictionary_id='57658.Üye'>/ <cf_get_lang dictionary_id='60187.Çalışan Kodu'>*</td>
					</tr>
					<tr>
						<td colspan="2">2 - <cf_get_lang dictionary_id='57279.Döviz Tutar'></td>
					</tr>
					<tr>
						<td colspan="2">3 - <cf_get_lang dictionary_id='57489.Para Birimi'></td>
					</tr>
					<tr>
						<td colspan="2">4 - <cf_get_lang dictionary_id='57629.Açıklama'></td>
					</tr>
					<tr>
						<td colspan="2">5 - <cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">6 - <cf_get_lang dictionary_id='29522.Sözleşme'> <cf_get_lang dictionary_id='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">7 - <cf_get_lang dictionary_id='58811.Muhasebe Kodu'></td>
					</tr>
					<tr>
						<td colspan="2" nowrap="nowrap">8 - <cf_get_lang dictionary_id='58460.Masraf Merkezi'> <cf_get_lang dictionary_id='58527.ID'> (<cf_get_lang dictionary_id='60188.Alacak Tipli Cari İşlemlerde Yazılmalıdır'>)</td>
					</tr>
					<tr>
						<td colspan="2">9 - <cf_get_lang dictionary_id='58551.Gider Kalemi'> <cf_get_lang dictionary_id='58527.ID'> (<cf_get_lang dictionary_id='60188.Alacak Tipli Cari İşlemlerde Yazılmalıdır'>)</td>
					</tr>
					<tr>
						<td colspan="2">10 - <cf_get_lang dictionary_id='58172.Gelir Merkezi'> <cf_get_lang dictionary_id='58527.ID'> (<cf_get_lang dictionary_id='60189.Borç Tipli Cari İşlemlerde Yazılmalıdır'>)</td>
					</tr>
					<tr>
						<td colspan="2">11 - <cf_get_lang dictionary_id='58173.Gelir Kalemi'> <cf_get_lang dictionary_id='58527.ID'> (<cf_get_lang dictionary_id='60189.Borç Tipli Cari İşlemlerde Yazılmalıdır'>)</td>
					</tr>
					<tr>
						<td colspan="2">12 - <cf_get_lang dictionary_id='59132.Cari Hesap Tipleri'></td>
					</tr>
				<cfelseif type eq 2><!--- type 2: Toplu Gelen Havale Ekleme --->
					<tr>
						<td colspan="2">
						<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
						<cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır'>. <cf_get_lang dictionary_id='54200.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'>
						<cf_get_lang dictionary_id='56627.Belgede toplam 11 alan olacaktır alanlar sırası ile'>;<br/>
						</td>
					</tr>
					<tr>
						<td colspan="2">1 - <cf_get_lang dictionary_id='57658.Üye'>/ <cf_get_lang dictionary_id='60187.Çalışan Kodu'>/<cf_get_lang dictionary_id='56085.Vergi Numarası'>/<cf_get_lang dictionary_id='30574.TC Kimlik No - 11 Hane'>*</td>
					</tr>
					<tr>
						<td colspan="2">2 - <cf_get_lang dictionary_id='54332.IBAN No'></td>
					</tr>
					<tr>
						<td colspan="2">3 - <cf_get_lang dictionary_id='57673.Tutar'>*</td>
					</tr>
					<tr>
						<td colspan="2">4 - <cf_get_lang dictionary_id='57489.Para Birimi'>*</td>
					</tr>
					<tr>
						<td colspan="2">5 - <cf_get_lang dictionary_id='57629.Açıklama'></td>
					</tr>
					<tr>
						<td colspan="2">6 - <cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">7 - <cf_get_lang dictionary_id='61766.Abone ID'></td>
					</tr>
					<tr>
						<td colspan="2">8 - <cf_get_lang dictionary_id='58833.Fiziki Varlık'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">9 - <cf_get_lang dictionary_id='58929.Tahsilat Tipi'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">10 - <cf_get_lang dictionary_id='30060.Masraf Tutarı'></td>
					</tr>
					<tr>
						<td colspan="2">11 - <cf_get_lang dictionary_id='58460.Masraf Merkezi'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">12 - <cf_get_lang dictionary_id='58551.Gider Kalemi'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">13 - <cf_get_lang dictionary_id='59132.Cari Hesap Tipi'></td>
					</tr>
				<cfelseif type eq 3><!--- type 3: Toplu Giden Havale Ekleme --->
					<tr>
						<td colspan="2">
						<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
					 	<cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır'>. <cf_get_lang dictionary_id='44960.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'>
						<cf_get_lang dictionary_id='56627.Belgede toplam 11 alan olacaktır alanlar sırası ile'>;<br/>
						</td>
					</tr>
					<tr>
						<td colspan="2">1 - <cf_get_lang dictionary_id='57658.Üye'>/ <cf_get_lang dictionary_id='60187.Çalışan Kodu'>/<cf_get_lang dictionary_id='56085.Vergi Numarası'>/<cf_get_lang dictionary_id='30574.TC Kimlik No - 11 Hane'>*</td>
					</tr>
					<tr>
						<td colspan="2">2 - <cf_get_lang dictionary_id='57673.Tutar'>*</td>
					</tr>
					<tr>
						<td colspan="2">3 - <cf_get_lang dictionary_id='57489.Para Birimi'>*</td>
					</tr>
					<tr>
						<td colspan="2">4 - <cf_get_lang dictionary_id='57629.Açıklama'></td>
					</tr>
					<tr>
						<td colspan="2">5 - <cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">6 - <cf_get_lang dictionary_id='61766.Abone ID'></td>
					</tr>
					<tr>
						<td colspan="2">7 - <cf_get_lang dictionary_id='58833.Fiziki Varlık'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">8 - <cf_get_lang dictionary_id='58928.Ödeme Tipi'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">9 - <cf_get_lang dictionary_id='30060.Masraf Tutarı'></td>
					</tr>
					<tr>
						<td colspan="2">10 - <cf_get_lang dictionary_id='58460.Masraf Merkezi'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">11 - <cf_get_lang dictionary_id='58551.Gider Kalemi'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">12 - <cf_get_lang dictionary_id='59132.Cari Hesap Tipi'></td>
					</tr>
                <cfelseif type eq 4><!--- type 4: Kasa Toplu Tahsilat --->
                	<tr>
						<td colspan="2">
						<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
						<cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır'>. <cf_get_lang dictionary_id='44960.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'>
						<cf_get_lang dictionary_id='44970.Belgede toplam 9 alan olacaktır alanlar sırası ile'>;<br/>
						</td>
					</tr>
					<tr>
						<td colspan="2">1 - <cf_get_lang dictionary_id='57658.Üye'>/ <cf_get_lang dictionary_id='60187.Çalışan Kodu'>/<cf_get_lang dictionary_id='56085.Vergi Numarası'>*</td>
					</tr>
					<tr>
						<td colspan="2">2 - <cf_get_lang dictionary_id='57673.Tutar'>*</td>
					</tr>
					<tr>
						<td colspan="2">3 - <cf_get_lang dictionary_id='57489.Para Birimi'>*</td>
					</tr>
					<tr>
						<td colspan="2">4 - <cf_get_lang dictionary_id='57629.Açıklama'></td>
					</tr>
					<tr>
						<td colspan="2">5 - <cf_get_lang dictionary_id='50233.Tahsil Eden'> <cf_get_lang dictionary_id ='58527.ID'>*</td>
					</tr>
                    <tr>
						<td colspan="2">6 - <cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">7 - <cf_get_lang dictionary_id='58833.Fiziki Varlık'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr> 
					<tr>
						<td colspan="2">8 - <cf_get_lang dictionary_id='58929.Tahsilat Tipi'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
                    <tr>
						<td colspan="2">9 - <cf_get_lang dictionary_id='59132.Cari Hesap Tipi'></td>
					</tr>
            	<cfelseif type eq 5><!--- type 4: Kasa Toplu Ödeme --->
                	<tr>
						<td colspan="2">
						<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
							<cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır'>. <cf_get_lang dictionary_id='44960.Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'>
								<cf_get_lang dictionary_id='44970.Belgede toplam 9 alan olacaktır alanlar sırası ile'>;<br/>
						</td>
					</tr>
					<tr>
						<td colspan="2">1 - <cf_get_lang dictionary_id='57658.Üye'>/ <cf_get_lang dictionary_id='60187.Çalışan Kodu'>/<cf_get_lang dictionary_id='56085.Vergi Numarası'>*</td>
					</tr>
					<tr>
						<td colspan="2">2 - <cf_get_lang dictionary_id='57673.Tutar'>*</td>
					</tr>
					<tr>
						<td colspan="2">3 - <cf_get_lang dictionary_id='57489.Para Birimi'>*</td>
					</tr>
					<tr>
						<td colspan="2">4 - <cf_get_lang dictionary_id='57629.Açıklama'></td>
					</tr>
					<tr>
						<td colspan="2">5 - <cf_get_lang dictionary_id='51313.Ödeme Yapan'> <cf_get_lang dictionary_id ='58527.ID'>*</td>
					</tr>
                    <tr>
						<td colspan="2">6 - <cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
					<tr>
						<td colspan="2">7 - <cf_get_lang dictionary_id='58833.Fiziki Varlık'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr> 
					<tr>
						<td colspan="2">8 - <cf_get_lang dictionary_id='58928.Ödeme Tipi'> <cf_get_lang dictionary_id ='58527.ID'></td>
					</tr>
                    <tr>
						<td colspan="2">9 - <cf_get_lang dictionary_id='59132.Cari Hesap Tipi'></td>
					</tr>
				</cfif>
			</table>
		</cf_box_elements>
			<cf_box_footer>
					<input type="submit" value="#getlang('','Listele','58715')#" onclick="ekle_form_action();">
			</cf_box_footer>
	</cfform>
</cf_box>
</cfoutput>
<script type="text/javascript">
	function ekle_form_action()
	{
		if(document.getElementById('member_type').value == 0)
		{
			alert("<cf_get_lang dictionary_id='60190.Üye Tipi Seçmelisiniz'> !");
			return false;
		}
		if(document.getElementById('uploaded_file').value == "")
		{
			alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'>!");
			return false;
		}
		var url = $("#upload_form_page").attr('action');
		var formData = new FormData();
		var sfile = document.querySelector('#uploaded_file');
		var member_type = $("#member_type").val();
						
		formData.append("uploaded_file", sfile.files[0]);
		formData.append("member_type", member_type);
		formData.append("type", <cfoutput>#attributes.type#</cfoutput>);
		formData.append("modal_id", "<cfoutput>#attributes.modal_id#</cfoutput>");

		$.ajax({
			type: "POST",
			url: url,
			processData: false,
			contentType: false,
			data : formData
	 	});	
	 }
</script>