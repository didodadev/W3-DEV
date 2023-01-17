<cfsetting showdebugoutput="no">
<cfquery name="get_sales_zone" datasource="#dsn#">	
	SELECT * FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfoutput>
	<cf_box title="#getLang('','',57515)#" closable="1">
		<table border="0" align="left">
			<tr>
				<td nowrap="nowrap"><cf_get_lang dictionary_id='32450.Kapsam'> *</td>
				<td><select name="sale_scope" id="sale_scope" style="width:142px;">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<option value="1"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></option>
						<option value="2"><cf_get_lang dictionary_id='57453.Şube'></option>
						<option value="3"><cf_get_lang dictionary_id='32452.Satış Takımı'></option>
						<option value="4"><cf_get_lang dictionary_id='32460.Mikro Bölge'></option>
						<option value="5"><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
						<option value="6"><cf_get_lang dictionary_id='58673.Müşteriler'></option>
						<option value="7"><cf_get_lang dictionary_id='57567.Ürün Kategorileri'></option>
						<option value="8"><cf_get_lang dictionary_id='32436.Markalar'></option>
						<option value="9"><cf_get_lang dictionary_id='32463.Üye Kategorileri'></option>
					</select>
				</td>
			</tr>
			<tr>
				<td width="70"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></td>
				<td width="160">
					<select name="zone_id_" id="zone_id_" style="width:142px;">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						 <cfloop query="get_sales_zone">
							<option value="#sz_id#">#sz_name#</option>
						</cfloop> 
					</select>				  
				</td>	
			</tr> 
			<tr>
				<td nowrap><cf_get_lang dictionary_id='57468.Belge'> *</td>
				<td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;"></td>
			</tr>
			<tr>
				<td></td>
				<td  style="text-align:right;">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58715.Listele'></cfsavecontent>
					<cf_workcube_buttons insert_info='#message#' add_function='ekle_form_action()' is_cancel='0'>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
				<cf_get_lang dictionary_id='44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır .Aktarım işlemi dosyanın 2. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır .'>
				<cf_get_lang dictionary_id='60210.Belgede Toplam Olması Gereken Alan'>:60  <cf_get_lang dictionary_id='60211.her ay için aşağıdaki alanlar doldurulmalıdır'>. <cf_get_lang dictionary_id='45042.Alanlar Sırası ile'>;<br/>
				</td>
			</tr>
			<tr><cf_get_lang dictionary_id='60210.Belgede Toplam Olması Gereken Alan'>:60
				<td colspan="2">1 - <cf_get_lang dictionary_id='30010.Ciro'> <cf_get_lang dictionary_id='37345.TL'></td>
			</tr>
			<tr>
				<td colspan="2">2 - <cf_get_lang dictionary_id='30010.Ciro'> <cf_get_lang dictionary_id='37344.USD'></td>
			</tr>
			<tr>
				<td colspan="2">3 - <cf_get_lang dictionary_id='57635.Miktar'></td>
			</tr>
			<tr>
				<td colspan="2">4 - <cf_get_lang dictionary_id='41516.Kar'> %</td>
			</tr>
			<tr>
				<td colspan="2">5 - <cf_get_lang dictionary_id='50720.Prim'> %</td>
			</tr>
		</table>
	</cf_box>
</cfoutput>
<script type="text/javascript">
	function ekle_form_action()
	{
		if(document.getElementById('sale_scope').value == "")
		{
			alert("<cf_get_lang dictionary_id='41618.Kapsam Seçmelisiniz'> !");
			return false;
		}
		if(list_find('3,4,5,6',document.getElementById("sale_scope").value) && document.getElementById('zone_id_').value ==  '')
		{
			alert("<cf_get_lang dictionary_id='30529.Lütfen Satış Bölgesi Seçiniz'>!");
			return false;
		}
		if(document.getElementById('uploaded_file').value == "")
		{
			alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'> !");
			return false;
		}
		document.add_sales_plan.action = "<cfoutput>#request.self#?fuseaction=salesplan.form_add_sales_plan_quota&is_from_file=1<cfif isdefined("attributes.plan_id")>&plan_id=#attributes.plan_id#</cfif>&sale_scope_=</cfoutput>"+document.getElementById('sale_scope').value+"&zone_id_="+document.getElementById("zone_id_").value;
		document.add_sales_plan.submit();
	}
</script>
