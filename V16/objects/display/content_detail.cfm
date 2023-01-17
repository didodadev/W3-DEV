<script type="text/javascript">
   function arrangeRadio(){
		if(document.add_service1.uye[0].checked == true){
			document.add_service2.uye[0].checked == true;
		}	
		else if(document.add_service1.uye[1].checked == true){
			document.add_service2.uye[1].checked == true;
		}	
		else if(document.add_service1.uye[2].checked == true){
			document.add_service2.uye[2].checked == true;
		}   
   }
</script>
<table cellpadding="0" cellspacing="0" width="100%" height="100%">
  <tr id="sec">
    <td class="color-row" valign="top">
      <cfinclude template="../../service/form/add_service1.cfm">
    </td>
  </tr>
  <tr id="kayit" style="display:none;">
  <td class="color-row" valign="top" >
  <form name="add_service2" action="" id="service1" onsubmit="gizleme();" >
  <table border="0">
    <tr>
      <td colspan="2">
        <input type="radio" name="uye" id="uye" value="1" id="uye4">
        <cf_get_lang dictionary_id='32402.Kurumsal'>
        <input type="radio" name="uye" id="uye" value="2" id="uye5">
        <cf_get_lang dictionary_id='32403.Bireysel'>
        <input type="radio" name="uye" id="uye" value="3" id="uye6">
        <cf_get_lang dictionary_id='57576.Çalışan'> </td>
    </tr>
    <tr>
      <td width="75"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
      <td><input type="text" value="" style="width:150px;" name="">
      </td>
    </tr>
    <tr>
      <td><cf_get_lang dictionary_id='57574.Şirket'></td>
      <td><input type="text" value="" style="width:150px;" name="Input" id="Input">
      </td>
    </tr>
    <tr>
      <td><cf_get_lang dictionary_id='57428.E-mail'></td>
      <td><input type="text" value="" style="width:150px;" name="Input2" id="Input2">
      </td>
    </tr>
    <tr>
      <td><cf_get_lang dictionary_id='32407.Tel Kod'></td>
      <td  style="text-align:right;">
        <input type="text" value="" style="width:53px;" name="Input22" id="Input22">
        <input type="text" value="" style="width:94px;" name="Input22" id="Input22">
      </td>
    </tr>
    <tr>
      <td><cf_get_lang dictionary_id='57488.Fax'></td>
      <td  style="text-align:right;">
        <input type="text" value="" style="width:94px;" name="Input222" id="Input222">
      </td>
    </tr>
    <tr>
      <td><cf_get_lang dictionary_id='58482.Mobil Kod/Tel'></td>
      <td  style="text-align:right;">
        <select style="width:53px;">
        </select>
        <input type="text" value="" style="width:94px;" name="Input2222" id="Input2222">
      </td>
    </tr>
    <tr>
      <td valign="top"><cf_get_lang dictionary_id='58723.Adres'></td>
      <td><textarea style="width:150px;height:60px;"></textarea>
      </td>
    </tr>
    <tr>
      <td><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
      <td><input type="text" value="" style="width:150px;" name="Input22222" id="Input22222">
      </td>
    </tr>
    <tr>
      <td><cf_get_lang dictionary_id='57992.Bölge'></td>
      <td><input type="text" value="" style="width:150px;" name="Input225222" id="Input225222">
      </td>
    </tr>
    <tr>
      <td><cf_get_lang dictionary_id='57971.Şehir'></td>
      <td><input type="text" value="" style="width:150px;" name="Input28222" id="Input28222">
      </td>
    </tr>
    <tr>
      <td><cf_get_lang dictionary_id='58219.Ülke'></td>
      <td><input type="text" value="" style="width:150px;" name="Input228822" id="Input228822">
      </td>
    </tr>
    <tr>
      <td style="text-align:right;" align="right" height="35" colspan="2">
		  <cf_workcube_buttons is_upd='0'>
      </td>
    </tr>
  </table>
  </form>
  </td>
  </tr>
</table>
