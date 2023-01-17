<cfsetting showdebugoutput="no">
<cfoutput>
	<cf_box title="#getLang('','Dosya ekle','57515')#" draggable="1" closable="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="upload_form_page"  enctype="multipart/form-data" action="#request.self#?fuseaction=objects.emptypopup_get_income_row_from_file" target="import_file_frame">
		
			<cf_box_elements>	
				<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
						</div>
					</div>	
				</div>
				<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
					<table border="0" align="left">
						<tr>
							<td colspan="2">
								<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
								<cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır. Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır .'> 
								<cf_get_lang dictionary_id='62372.Belgede toplam 23 alan olacaktır. Alanlar sırası ile'>;<br/>
							</td>
						</tr>
						<tr>
							<td colspan="2">1 - <cf_get_lang dictionary_id='57742.Tarih'></td>
						</tr>
						<tr>
							<td colspan="2">2 - <cf_get_lang dictionary_id='57629.Açıklama'></td>
						</tr>
						<tr>
							<td colspan="2">3 - <cf_get_lang dictionary_id='58930.Masraf'>/<cf_get_lang dictionary_id='58172.Gelir Merkezi'> <cf_get_lang dictionary_id='58527.ID'></td>
						</tr>
						<tr>
							<td colspan="2">4 - <cf_get_lang dictionary_id='58173.Gelir Kalemi'> <cf_get_lang dictionary_id='58527.ID'></td>
						</tr>
						<tr>
							<td colspan="2">5 - <cf_get_lang dictionary_id='58811.Muhasebe Kodu'></td>
						</tr>
						<tr>
							<td colspan="2">6 - <cf_get_lang dictionary_id='58833.Fiziki Varlık'> <cf_get_lang dictionary_id='58527.ID'></td>
						</tr>
						<tr>
							<td colspan="2">7 - <cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id='58527.ID'></td>
						</tr>
						<tr>
							<td colspan="2">8 - <cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='58527.ID'></td>
						</tr>
						<tr>
							<td colspan="2">9 - <cf_get_lang dictionary_id='57452.Stok'> <cf_get_lang dictionary_id='58527.ID'></td>
						</tr>
						<tr>
							<td colspan="2">10 - <cf_get_lang dictionary_id='57636.Birim'></td>
						</tr>
						<tr>
							<td colspan="2">11 - <cf_get_lang dictionary_id='57635.Miktar'></td>
						</tr>
						<tr>
							<td colspan="2">12 - <cf_get_lang dictionary_id='57673.Tutar'></td>
						</tr>
						<tr>
							<td colspan="2">13 - <cf_get_lang dictionary_id='57639.KDV'>%</td>
						</tr>
						<tr>
							<td colspan="2">14 - <cf_get_lang dictionary_id='58021.ÖTV'>%</td>
						</tr>
						<tr>
							<td colspan="2">15 - <cf_get_lang dictionary_id='58864.Para Br'> <cf_get_lang dictionary_id='58527.ID'></td>
						</tr>
						<tr>
							<td colspan="2">16 - <cf_get_lang dictionary_id='51319.Akitivite Tipi'> <cf_get_lang dictionary_id='58527.ID'></td>
						</tr>
						<tr>
							<td colspan="2">17 - <cf_get_lang dictionary_id='58140.İş Grubu'> <cf_get_lang dictionary_id='58527.ID'></td>
						</tr>
						<tr>
							<td colspan="2">18 - <cf_get_lang dictionary_id='58445.İş'> <cf_get_lang dictionary_id='58527.ID'></td>
						</tr>
						<tr>
							<td colspan="2">19 - <cf_get_lang dictionary_id='57612.Fırsat'> <cf_get_lang dictionary_id='58527.ID'></td>
						</tr>
						<tr>
							<td colspan="2">20 - <cf_get_lang dictionary_id='58832.Abone'> <cf_get_lang dictionary_id='58527.ID'></td>
						</tr>
						<tr>
							<td colspan="2">21 - <cf_get_lang dictionary_id='60195.Harcama Yapan Kurumsal Üye Kodu'></td>
						</tr>
						<tr>
							<td colspan="2">22 - <cf_get_lang dictionary_id='60196.Harcama Yapan Bireysel Üye Kodu'></td>
						</tr>
						<tr>
							<td colspan="2">23 - <cf_get_lang dictionary_id='60197.Harcama Yapan Çalışanlar Üye Kodu'></td>
						</tr>
					</table>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='58715.Listele'></cfsavecontent>
				<cf_workcube_buttons insert_info='#message#' add_function='ekle_form_action()' is_cancel='0'>
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
	}
</script>
