<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr height="35">
    <td class="headbold" width="500"><cf_get_lang no='182.Detaylı Müşteri Ara'></td>
  </tr>
</table>
<table border="0" align="center" cellpadding="0" cellspacing="0" width="98%">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
	  	  <tr class="color-header">
		  <td class="form-title" width="35%"><cf_get_lang no='431.Kolonlar'></td>
		  <td class="form-title"><cf_get_lang no='432.Koşullar'></td>
		  </tr>
          <tr>
            <td class="color-row" valign="top">
			<table>
			<tr>
			<td>
			<select name="database_field" id="database_field" multiple style="width:150;height=200;">
                <option value=""><cf_get_lang_main no='338.İşyeri Adı'></option>
                <option value=""><cf_get_lang_main no='780.Müşteri Adı'></option>
                <option value=""><cf_get_lang no='37.Müşteri Soyadı'></option>
                <option value=""><cf_get_lang_main no='1350.Vergi Dairesi'></option>
                <option value=""><cf_get_lang_main no='340.Vergi Numarası'></option>
                <option value=""><cf_get_lang_main no='720.Semt'></option>
                <option value=""><cf_get_lang_main no='1323.Mahalle'></option>
                <option value=""><cf_get_lang_main no='722.Mikro Bolge Kodu'></option>
                <option value=""><cf_get_lang no='45.Cadde'></option>
                <option value=""><cf_get_lang_main no='1196.İl'></option>
                <option value=""><cf_get_lang_main no='60.Posta Kodu'></option>
                <option value=""><cf_get_lang_main no='87.Telefon Numarası'></option>
                <option value=""><cf_get_lang_main no='16.Email'></option>
                <option value=""><cf_get_lang no='433.İnternet Sitesi'></option>
                <option value=""><cf_get_lang_main no='2114.Evlilik Tarihi'></option>
                <option value=""><cf_get_lang no='76.Çocuk Sayısı'></option>
			</select>
			</td>
			<td>
			<img src="images/listele.gif">
			<br/>
			<img src="images/listele2.gif">
			</td>
			<td>
			<select name="database_field" id="database_field" multiple style="width:150;height=200;">
			</select>
			</td>
			<td><img src="images/listele_up.gif"><br/>
			<br/>
			<img src="images/listele_down.gif">
			</td>
			</tr>
			</table>
			</td>
			<td valign="top" class="color-row">
			<div id="offer_sag" style="position:absolute;width:100%;height:98%; z-index:88;overflow:auto;">
			<cfform name="a">
            <table>
                <tr class="color-list">
                    <td width="15"><img src="/images/plus_list.gif" title="<cf_get_lang no='Koşul Ekle'>" border="0" align="absmiddle"></td>
                    <td></td>
                    <td></td>
                    <td>A/0</td>
                    <td><cf_get_lang no='435.Kolon'></td>
                    <td><cf_get_lang_main no='218.Tip'></td>
                    <td><cf_get_lang_main no='1182.Format'></td>
                    <td><cf_get_lang no='437.Değer'></td>
                </tr>
                <tr>
                    <td><img src="/images/delete_list.gif" align="absmiddle" title="<cf_get_lang no='Koşul Ekle'>" border="0"></td>
                    <td><img src="images/listele_up.gif"></td>
                    <td><img src="images/listele_down.gif"></td>
                    <td>
                        <select name="compare" id="compare" style="width:50px;">
                            <option value="and">AND</option>
                            <option value="or">OR</option>
                        </select>
                    </td>
                    <td>
                        <input type="hidden" name="field_id_1" id="field_id_1" value="">
                        <input type="hidden" name="field_column_1" id="field_column_1" value="">
                        <select name="compare" id="compare" style="width:210px;">
                            <option value="and">AND</option>
                            <option value="or">OR</option>
                        </select>
                    </td>
                    <td width="65">
                        <select name="condition" id="condition" style="width:65px;">
                            <option value="="> = </option>
                            <option value="<>"> <> </option>
                            <option value=">="> >= </option>
                            <option value="<="> <= </option>
                            <option value="<"> < </option>
                            <option value=">"> > </option>
                            <option value="LIKE">Like</option>
                            <option value="NOT LIKE">Not Like</option>
                            <option value="IS">Is</option>
                            <option value="IS NOT">IS Not</option>
                        </select>
                    </td>
                    <td>
                        <select name="cond_type" id="cond_type" style="width:60px;">
                            <option value="0"><cf_get_lang_main no='250.Alan'></option>
                            <option value="1"><cf_get_lang no='438.Sayı'></option>
                            <option value="2">String</option>
                            <option value="3"><cf_get_lang_main no='330.Tarih'></option>
                            <option value="4">NULL</option>
                        </select>
                    </td>
                    <td>
                        <cfinput type="text" name="field_name_2" message="Alan 2 !" value="" style="width:175px;">
                        <input type="hidden" name="field_id_2" id="field_id_2" value="">
                        <input type="hidden" name="field_column_2" id="field_column_2" value="">
                    </td>
                </tr>
            </table>
			</cfform>
			</div>
			</td>
          </tr>
            <tr>
		  <td colspan="2"  class="color-row" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
          </tr>
      </table>
    </td>
  </tr>
</table>
<br/>
<!--- <table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
<tr class="color-border"> 
  <td> 
	<table cellspacing="1" cellpadding="2" width="100%" border="0">
	    <tr class="color-header" height="22">
          <td width="30" class="form-title">No</td>
		  <td width="150" class="form-title">İşyeri Adı</td>
          <td width="140" class="form-title">Müşteri Adı</td>
          <td class="form-title">Müşteri Soyadı</td>
          <td class="form-title">IMS Bölge Kodu</td>
          <td class="form-title">Semt</td>
		  <td class="form-title">İlçe</td>
          <td class="form-title">İl</td>
          <td class="form-title">Telefon</td>
          <td class="form-title" width="170">Depo Müşteri Cari Hesap No</td>
        </tr>
	  <tr height="22"> 
		<td colspan="10" class="color-row">Filtre Ediniz !</td>
	  </tr>
	</table>
  </td>
</tr>
</table> --->
