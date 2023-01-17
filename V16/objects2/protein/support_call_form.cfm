<form class="col-12" name="contactForm2" id="contactForm2">
    <div class="form-group">
        <label>Firma Ünvanı</label>
        <input class="form-control" type="text" name="contact_firm">
    </div>
    <div class="row">
        <div class="form-group col-12 col-sm-6">
            <label><cf_get_lang dictionary_id='57631.Ad'> <span class="required">*</span></label>
            <input class="form-control" type="text" required name="contact_name" id="contact_name">
        </div>
        <div class="form-group col-12 col-sm-6">
            <label><cf_get_lang dictionary_id='58726.Soyad'> <span class="required">*</span></label>
            <input class="form-control" type="text" required name="contact_surname" id="contact_surname">
        </div>
    </div>
    <div class="form-group">
        <label><cf_get_lang dictionary_id='57428.E-posta'> <span class="required">*</span></label>
        <input class="form-control" type="email" name="contact_mail" id="contact_mail" required >
    </div>
    <div class="form-group">
        <label><cf_get_lang dictionary_id='57499.Telefon'> <span class="required">*</span></label>
        <input class="form-control" type="number" name="contact_phone" id="contact_phone" required>
    </div>
    <div class="form-group">
        <label><cf_get_lang dictionary_id='57467.Not'></label>
        <textarea class="form-control" rows="3" maxlength="5000" name="contact_note" id="contact_note"></textarea>
    </div>
        <span>(*) <cf_get_lang dictionary_id='45058.Zorunludur'>.</span>
    <div class="form-group text-right">
        <cf_workcube_buttons is_insert="1" data_action="V16/objects2/protein/data/support_forms_data:CALL_SUPPORT" next_page="/" add_function="control()">
    </div>
</form>

<script language="javascript" type="text/javascript">
	function control()
	{   
		if(document.getElementById('contact_name').value == "")
		{
			alert("Ad Giriniz !");
			return false;
		}
		if(document.getElementById('contact_surname').value == "")
		{
			alert("Soyad Giriniz !");
			return false;
		}
		var aaa = document.getElementById('contact_mail').value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)))
			{ 
				alert("<cf_get_lang dictionary_id='626.Lütfen mail alanına geçerli bir mail giriniz'> !");
				return false;
			}
		
		var bbb = document.getElementById('contact_mail').value;
		if (((bbb == '') || (bbb.indexOf('@') == -1) || (bbb.indexOf('.') == -1) || (bbb.length < 6)))
			{
				alert("<cf_get_lang dictionary_id='626.Lütfen mail alanına geçerli bir mail giriniz'> !");
				return false;
			}
		if(document.getElementById('contact_phone').value == "")
		{
			alert("Telefon Zorunlu alan !");
			return false;
		}
		if(document.getElementById('contact_note').value.length > 5000)
		{
			alert("<cf_get_lang dictionary_id='50599.Açıklama Alanı Uzun!'>");
			return false;
		}	
		
	}
</script>