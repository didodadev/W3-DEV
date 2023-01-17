<cfset password_style = createObject('component','V16.hr.cfc.add_rapid_emp')><!--- Şifre standartları çekiliyor. --->
<cfset get_password_style = password_style.pass_control()>

<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfif not isDefined("attributes.partner_id")>
    <cfparam name="attributes.partner_id" default="#session_base.userid#">
</cfif>

<cfscript>

    get_partner = company_cmp.get_partner_(
        cpid : session_base.company_id,
        partner_id : attributes.partner_id
    );

    get_partner_positions = company_cmp.GET_PARTNER_POSITIONS();

    GET_STATUS = company_cmp.GET_STATUS();

</cfscript>
<cfoutput>
    <cfform name="upd_company_partner" method="post">
        <cfinput type="hidden" id="partner_id" name="partner_id" value="#attributes.partner_id#">      
        <div class="ui-scroll row">            
            <div class="col-md-7">
                <div class="form-row">
                    <div class="form-group col-lg-6 col-xl-6">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='57631.Ad'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57631.Ad'></cfsavecontent>
                        <input type="text" name="company_partner_name" id="company_partner_name" required="yes" message="<cfoutput>#message#</cfoutput>" class="form-control" placeholder="<cf_get_lang dictionary_id='57631.Ad'>" value="#get_partner.COMPANY_PARTNER_NAME#">
                    </div>
                    <div class="form-group col-lg-6 col-xl-6">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='58726.Soyad'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='58726.Soyad'></cfsavecontent>
                        <input type="text" name="company_partner_surname" id="company_partner_surname" required="yes" message="<cfoutput>#message#</cfoutput>" class="form-control" placeholder="<cf_get_lang dictionary_id='58726.Soyad'>" value="#get_partner.COMPANY_PARTNER_SURNAME#">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-lg-12 col-xs-12">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='58497.Pozisyon'></cfsavecontent>
                        <select class="form-control" name="mission" id="mission" required="yes" message="<cfoutput>#message#</cfoutput>">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_partner_positions">
                                <option value="#partner_position_id#" <cfif partner_position_id eq get_partner.mission>selected</cfif>>#partner_position#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-lg-12 col-xs-12">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='57756.Durum'> - <cf_get_lang dictionary_id='57894.Statü'></label>
                        <select class="form-control" name="status_id" id="status_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="GET_STATUS">
                                <option value="#cps_id#" <cfif get_partner.cp_status_id eq cps_id>selected</cfif>>#status_name#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-lg-6 col-xl-6">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='42782.E-Mail'></label>
                        <input type="email" name="company_partner_email" id="company_partner_email" class="form-control" placeholder="<cf_get_lang dictionary_id='42782.E-Mail'>" value="#get_partner.COMPANY_PARTNER_EMAIL#">
                    </div>
                    <div class="form-group col-lg-3 col-xl-3">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='61819.?'></label>
                        <input type="text" name="mobilcat_id" id="mobilcat_id" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.?'>" value="#get_partner.MOBIL_CODE#">
                    </div>
                    <div class="form-group col-lg-3 col-xl-3">
                        <label class="font-weight-bold">&nbsp;</label>
                        <input type="text" name="mobiltel" id="mobiltel" class="form-control" placeholder="<cf_get_lang dictionary_id='61824.?'>" value="#get_partner.MOBILTEL#">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group col-lg-12 col-xl-12">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='57551.Username'>*</label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57551.Username'></cfsavecontent>
                        <input type="text" name="username" id="username" class="form-control" value="#get_partner.COMPANY_PARTNER_USERNAME#" placeholder="<cf_get_lang dictionary_id='57551.Username'>" required="yes" message="<cfoutput>#message#</cfoutput>">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group col-lg-12 col-xl-12">
                        <label class="font-weight-bold"><cf_get_lang dictionary_id='57552.Şifre'>*</label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57552.Şifre'></cfsavecontent>
                        <input type="password" name="password" id="password" class="form-control" placeholder="<cf_get_lang dictionary_id='57552.Şifre'>">
                    </div>
                </div>   
            </div>
            <cfif attributes.param_1 eq 'myinfo'>
                <div class="col-md-5 d-flex justify-content-center align-items-center flex-column">
                    <label class="cursor-pointer label" data-toggle="tooltip" title="<cf_get_lang dictionary_id='30037.Change Image'>">
                        <img class="rounded-circle" width="200" height="200" id="avatar" src="<cfif len(get_partner.PHOTO)><cfoutput>http://#cgi.server_name#/documents/hr/#get_partner.PHOTO#</cfoutput><cfelse>/images/<cfif len(get_partner.sex) and get_partner.sex eq 1>male.jpg<cfelse>female.jpg</cfif></cfif>" alt="avatar" >
                        <input type="file" class="sr-only" id="input" name="image" accept="image/*">
                    </label>
                    <div class="progress">
                        <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">0%</div>
                    </div>
                    <div class="alert" role="alert"></div>
                    <div class="modal fade" id="modal" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="modalLabel">Crop the image</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <div class="img-container">
                                        <img id="image" src="https://avatars0.githubusercontent.com/u/3456749">
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    <button type="button" class="btn btn-primary" id="crop">Crop</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>  
                <style>  
                    .progress {
                    display: none;
                    margin-bottom: 1rem;
                    }

                    .alert {
                    display: none;
                    }

                    .img-container img {
                    max-width: 100%;
                    }
                </style> 
            </cfif>
                
        </div>
        <div class="<cfif attributes.param_1 eq 'updateUser'>draggable-footer<cfelse>col-lg-12</cfif>">
            <cf_workcube_buttons is_upd="1" is_delete="0" add_function="pass_control()" data_action="/V16/member/cfc/member_company:upd_partner_protein" next_page="#iif((attributes.param_1 eq 'myinfo'),DE('/myinfo'),DE('/users'))#" >
        </div>
    </cfform>
</cfoutput>
  
  

<script>
    <cfif attributes.param_1 eq 'myinfo'>
        window.addEventListener('DOMContentLoaded', function () {
        var avatar = document.getElementById('avatar');
        var image = document.getElementById('image');
        var input = document.getElementById('input');
        var $progress = $('.progress');
        var $progressBar = $('.progress-bar');
        var $alert = $('.alert');
        var $modal = $('#modal');
        var cropper;

        $('[data-toggle="tooltip"]').tooltip();

        input.addEventListener('change', function (e) {
            var files = e.target.files;
            var done = function (url) {
            input.value = '';
            image.src = url;
            $alert.hide();
            $modal.modal('show');
            };
            var reader;
            var file;
            var url;

            if (files && files.length > 0) {
            file = files[0];

            if (URL) {
                done(URL.createObjectURL(file));
            } else if (FileReader) {
                reader = new FileReader();
                reader.onload = function (e) {
                done(reader.result);
                };
                reader.readAsDataURL(file);
            }
            }
        });

        $modal.on('shown.bs.modal', function () {
            cropper = new Cropper(image, {
            aspectRatio: 1,
            viewMode: 3,
            });
        }).on('hidden.bs.modal', function () {
            cropper.destroy();
            cropper = null;
        });

        document.getElementById('crop').addEventListener('click', function () {
            var initialAvatarURL;
            var canvas;

            $modal.modal('hide');

            if (cropper) {
            canvas = cropper.getCroppedCanvas({
                width: 160,
                height: 160,
            });
            initialAvatarURL = avatar.src;
            avatar.src = canvas.toDataURL();
            $progress.show();
            $alert.removeClass('alert-success alert-warning');
            canvas.toBlob(function (blob) {
                var formData = new FormData();

                formData.append('avatar', blob, 'avatar.jpg');
                formData.append('partner_id', '<cfoutput>#attributes.partner_id#</cfoutput>');
                $.ajax('/V16/member/cfc/member_company.cfc?method=upd_partner_img', {
                method: 'POST',
                data: formData,
                processData: false,
                contentType: false,

                xhr: function () {
                    var xhr = new XMLHttpRequest();

                    xhr.upload.onprogress = function (e) {
                    var percent = '0';
                    var percentage = '0%';

                    if (e.lengthComputable) {
                        percent = Math.round((e.loaded / e.total) * 100);
                        percentage = percent + '%';
                        $progressBar.width(percentage).attr('aria-valuenow', percent).text(percentage);
                    }
                    };

                    return xhr;
                },

                success: function (response) {
                    $alert.show().addClass('alert-success').text('Upload success');
                },

                error: function () {
                    avatar.src = initialAvatarURL;
                    $alert.show().addClass('alert-warning').text('Upload error');
                },

                complete: function () {
                    $progress.hide();
                },
                });
            });
            }
        });
        });
    </cfif>
    function pass_control() {
        control_ifade_ = $('#password').val();
		if ($('#password').val().indexOf(" ") != -1)
		{
			alert("Şifre boşluk karakterini içeremez.");
			$('#password').focus();
			return false;
		}
		if(($('#username').val() != "") && ($('#password').val() != "") && ($('#username').val() == $('#password').val()))
		{
			alert("<cf_get_lang dictionary_id='30952.Şifre Kullanıcı Adıyla Aynı Olamaz !'>");
			$('#password').focus();
			return false;
		}
		if ($('#password').val() != "")
		{
			<cfif get_password_style.recordcount>
				var number="0123456789";
				var lowercase = "abcdefghijklmnopqrstuvwxyz";
				var uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
				var ozel="!]'^%&([=?_<£)#$½{\|.:,;/*-+}>";
				var containsNumberCase = contains(control_ifade_,number);
				var containsLowerCase = contains(control_ifade_,lowercase);
				var containsUpperCase = contains(control_ifade_,uppercase);
				var ozl = contains(control_ifade_,ozel);
				<cfoutput>
					if(control_ifade_.length < #get_password_style.password_length#)
					{
						alert("<cf_get_lang dictionary_id='30949.Şifre Karakter Sayısı Az'>! <cf_get_lang dictionary_id='30951.Şifrede Olması Gereken Karakter Sayısı'> : #get_password_style.password_length#");
						document.getElementById('password').focus();				
						return false;
					}
					
					if(#get_password_style.password_number_length# > containsNumberCase)
					{
						alert("<cf_get_lang dictionary_id = '30948.Şifrede Olması Gereken Rakam Sayısı'> : #get_password_style.password_number_length#");
						document.getElementById('password').focus();
						return false;
					}
					
					if(#get_password_style.password_lowercase_length# > containsLowerCase)
					{
						alert("<cf_get_lang dictionary_id = '30947.Şifrede Olması Gereken Küçük Harf Sayısı'> :#get_password_style.password_lowercase_length#");
						document.getElementById('password').focus();				
						return false;
					}
					
					if(#get_password_style.password_uppercase_length# > containsUpperCase)
					{
						alert("<cf_get_lang dictionary_id = '30946.Şifrede Olması Gereken Büyük Harf Sayısı'> : #get_password_style.password_uppercase_length#");
						document.getElementById('password').focus();
						return false;
					}
					
					if(#get_password_style.password_special_length# > ozl)
					{
						alert("<cf_get_lang dictionary_id = '30945.Şifrede Olması Gereken Özel Karakter Sayısı'> : #get_password_style.password_special_length#");
						document.getElementById('password').focus();
						return false;
					}
				</cfoutput>
			</cfif>
		}
    }
</script>