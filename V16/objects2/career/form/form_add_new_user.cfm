<cfif isDefined('session.cp.userid')>
	<script language="javascript">
		alert('Lütfen sistemden çıkıp da üye olunuz!'); 
		history.back(-1);       
    </script>
    <cfabort>
</cfif>
<div class="row">
    <div class="col-xl-12">
        <h1><cf_get_lang dictionary_id='35070.Yeni Kullanıcı'></h1>
    </div>
    <div class="col-xl-12">
        <p><cf_get_lang dictionary_id='35071.Aşağıdaki bilgileri doldurup Kaydet e bastığınızda  şifreniz belirttiğiniz e-posta adresine gönderilecektir'></p> 
    </div>
    <div class="col-xl-12">
        <h1>Hızlı Üyelik</h1>
        <cfform name="form_new_user" action="#request.self#?fuseaction=objects2.popup_add_new_user" method="post">
        <div class="form-group row">
            <label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='57631.Ad'></label>
            <div class="col-12 col-md-8 col-lg-6 col-xl-2">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='34540.Lütfen adınızı giriniz!'></cfsavecontent>
                <cfinput type="text" name="user_name" class="input_1 form-control" id="user_name" value="" required="yes" message="#message#">
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='58726.Soyad'></label>
            <div class="col-12 col-md-8 col-lg-6 col-xl-2">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='34558.Lütfen soyadınızı giriniz!'></cfsavecontent>
                <cfinput type="text" name="user_surname" class="input_1 form-control" id="user_surname" value="" required="yes" message="#message#!">
            </div>
        </div>
        <div class="form-group row">
            <label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='57428.E-posta'></label>
            <div class="col-12 col-md-8 col-lg-6 col-xl-2">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29707.Lütfen e-mail adresinizi giriniz'></cfsavecontent>
                <cfinput type="text" name="mail" id="mail" class="input_1 form-control" value="" validate="email" required="yes" message="#message#!">
            </div>
        </div>
        <div class="row">
            <div class="col-xl-12">
                <input type="submit" class="btn btn-primary" name="giris" id="giris" value="<cf_get_lang dictionary_id='59031.Kaydet'>" class="input_goner">
            </div>
        </div>         
        </cfform>   
        <div class="float-right"><img src="objects2/image/uyeol-cvolustur2.jpg" /></div>
    </div>       
</div>