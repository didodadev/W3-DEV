<cfoutput>
	<cf_box title="#getLang('','Dosya Ekle',57515)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_box_elements>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group require" id="item-process_stage">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
					<div class="col col-8 col-sm-12">
						<input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
					</div>                
				</div> 
				<div class="form-group require" id="item-process_stage">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='60212.Seçim Kriteri'></label>
					<div class="col col-8 col-sm-12">
						<select name="choose_option" id="choose_option" multiple="multiple">
							<option value="0"><cf_get_lang dictionary_id="57658.Üye"></option>
							<option value="1"><cf_get_lang dictionary_id="58847.Marka"></option>
							<option value="2"><cf_get_lang dictionary_id="57486.Kategori"></option>
							<option value="3"><cf_get_lang dictionary_id="57657.Ürün"></option>
						</select>
					</div>                
				</div> 
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<input class="ui-wrk-btn ui-wrk-btn-success" type="button" value="#getLang('','Listele',58715)#" onclick="ekle_form_action();">
		</cf_box_footer>
		<table border="0" align="left">
			<tr>
				<td colspan="2">
				<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
				<cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır. Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır.'> 
				<cf_get_lang dictionary_id='60210.Belgede Toplam Olması Gereken Alan'>:18 <cf_get_lang dictionary_id='43095.çarpı işareti ile işaretli alanlar zorunludur'> <cf_get_lang dictionary_id='45042.Alanlar sırası ile'>;<br/>
				</td>
			</tr>
			<tr>
				<td colspan="2">1 - <cf_get_lang dictionary_id='57635.Miktar'> *</td>
			</tr>
			<tr>
				<td colspan="2">2 - <cf_get_lang dictionary_id='57558.Üye No'></td>
			</tr>
			<tr>
				<td colspan="2">3 - <cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id ='57518.Stok Kodu'></td>
			</tr>
			<tr>
				<td colspan="2">4 - <cf_get_lang dictionary_id='58847.Marka'> <cf_get_lang dictionary_id='58527.ID'></td>
			</tr>
			<tr>
				<td colspan="2">5 - <cf_get_lang dictionary_id='57486.Kategori'> <cf_get_lang dictionary_id='58527.ID'></td>
			</tr>
			<tr>
				<td colspan="2">6 - <cf_get_lang dictionary_id='58472.Dönem'>(<cf_get_lang dictionary_id='58724.Ay'> 0, 3 <cf_get_lang dictionary_id='58724.Ay'> 1, <cf_get_lang dictionary_id='58455.Yıl'> 2)</td>
			</tr>
			<tr>
				<td colspan="2">7 - <cf_get_lang dictionary_id='60214.Min Tutar'></td>
			</tr>
			<tr>
				<td colspan="2">8 - <cf_get_lang dictionary_id='60215.Max Tutar'></td>
			</tr>
			<tr>
				<td colspan="2">9 - <cf_get_lang dictionary_id='58908.Min'> <cf_get_lang dictionary_id='57279.Döviz Tutar'></td>
			</tr>
			<tr>
				<td colspan="2">10 - <cf_get_lang dictionary_id='58909.Max'> <cf_get_lang dictionary_id='57279.Döviz Tutar'></td>
			</tr>
			<tr>
				<td colspan="2">11 - <cf_get_lang dictionary_id='50720.Prim'> %</td>
			</tr>
			<tr>
				<td colspan="2">12 - <cf_get_lang dictionary_id='57635.Prim'> 2 %</td>
			</tr>
			<tr>
				<td colspan="2">13 - <cf_get_lang dictionary_id='57635.Prim'> 3 %</td>
			</tr>
			<tr>
				<td colspan="2">14 - <cf_get_lang dictionary_id='57635.Prim'> Tutar</td>
			</tr>
			<tr>
				<td colspan="2">15 - <cf_get_lang dictionary_id='57379.Mal Fazlası'></td>
			</tr>
			<tr>
				<td colspan="2">16 - <cf_get_lang dictionary_id='39553.Kâr'> %</td>
			</tr>
			<tr>
				<td colspan="2">17 - <cf_get_lang dictionary_id='60216.Kâr Tutar'></td>
			</tr>
			<tr>
				<td colspan="2">18 - <cf_get_lang dictionary_id='57629.Açıklama'> / <cf_get_lang dictionary_id='57467.Not'></td>
			</tr>
		</table>
	</cf_box>
</cfoutput>
<script type="text/javascript">
	function ekle_form_action()
	{
		selectedValues = $('#choose_option').val();
		if(selectedValues != null)
		{
			if(selectedValues.indexOf('3')>-1 && selectedValues.indexOf('2')>-1 && selectedValues.indexOf('1')>-1)
			{
				alert("<cf_get_lang dictionary_id='60226.Ürün, Marka ve Kategori beraber seçilemez'>");
				return false;
			}
			if(selectedValues.indexOf('3')>-1 && selectedValues.indexOf('2')>-1)
			{
				alert("<cf_get_lang dictionary_id='60227.Ürün ve Kategori beraber seçilemez'>");
				return false;
			}
			if(selectedValues.indexOf('3')>-1 && selectedValues.indexOf('1')>-1)
			{
				alert("<cf_get_lang dictionary_id='60228.Ürün ve Marka beraber seçilemez'>");
				return false;
			}

		}
		if(document.getElementById('uploaded_file').value == "")
		{
			alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'> !");
			return false;
		}
		document.add_sales_quota.action = "<cfoutput>#request.self#?fuseaction=salesplan.list_sales_quotas&event=add&is_from_file=1</cfoutput>";
		document.add_sales_quota.submit();
	}
</script>
