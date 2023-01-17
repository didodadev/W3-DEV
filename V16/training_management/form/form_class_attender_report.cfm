<cf_box title="#getLang('','Katılımcı Profili',46537)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form_class_attender_report" action="#request.self#?fuseaction=training_management.popup_class_attender_report&train_group_id=#attributes.train_group_id#" method="post">
		<div class="row">
			<div class="col col-5 col-xs-12 col-md-2 col-s-12">
				<div class="form-group">
					<label class="col col-3 col-md-9 col-xs-3 font-blue-madison bold"><cf_get_lang_main no='669.Hepsi'></label>
					<div class="col col-3 col-xs-3">	
						<input type="checkbox" onclick="durum(this.checked);">
					</div>
				</div>
			</div>
			<div class="col col-5 col-xs-12 col-md-3 col-s-12">
				<div class="form-group" id="item-levelid_1">
					<label class="col col-3 col-md-9 col-xs-3"><cf_get_lang no='344.Yaş'></label>
					<div class="col col-3 col-xs-3">	
						<input type="checkbox" value="1" name="levelid_1" id="levelid_1">
					</div>
				</div>
				<div class="form-group" id="item-levelid_2">
					<label class="col col-3 col-md-9 col-xs-3"><cf_get_lang no='395.Medeni Hali'></label>
					<div class="col col-3 col-xs-3">
						<input type="checkbox" value="2" name="levelid_2" id="levelid_2">
					</div>
				</div>		
				<div class="form-group" id="item-levelid_3">
					<label class="col col-3  col-md-9 col-xs-3"><cf_get_lang_main no='352.Cinsiyet'></label>
					<div class="col col-3 col-xs-3">
						<input type="checkbox" name="levelid_3" id="levelid_3">
					</div>
				</div>
				<div class="form-group" id="item-levelid_4">
					<label class="col col-3  col-md-9 col-xs-3"><cf_get_lang no='338.Askerlik'></label>
					<div class="col col-3 col-xs-3">
						<input type="checkbox" name="levelid_4" id="levelid_4">
					</div>
				</div>
				<div class="form-group" id="item-levelid_5">
					<label class="col col-3  col-md-9 col-xs-3"><cf_get_lang no='345.Öğrenim Seviyesi'></label>
					<div class="col col-3 col-xs-3">
						<input type="checkbox" name="levelid_5" id="levelid_5">
					</div>
				</div>
				<div class="form-group" id="item-levelid_6">
					<label class="col col-3  col-md-9 col-xs-3"><cf_get_lang no='396.Yabancı Dil Seviyesi'></label>
					<div class="col col-3 col-xs-3">
						<input type="checkbox" name="levelid_6" id="levelid_6">
					</div>
				</div>
				<div class="form-group" id="item-levelid_9">
					<label class="col col-3 col-md-9 col-xs-3"><cf_get_lang no='350.Kurs'> / <cf_get_lang no='397.Sertifika'></label>
					<div class="col col-3 col-xs-3">
						<input type="checkbox" name="levelid_9" id="levelid_9">
					</div>
				</div>
			</div>
			<div class="col col-5 col-xs-12 col-md-4 col-s-12">
				<div class="form-group" id="item-levelid_7">
					<label class="col col-3 col-md-9 col-xs-3"><cf_get_lang no='348.Lisans / Bölüm / Üniversite'></label>
					<div class="col col-3 col-xs-3">
						<input type="checkbox" name="levelid_7" id="levelid_7">
					</div>
				</div>		
				<div class="form-group" id="item-levelid_8">
					<label class="col col-3 col-md-9 col-xs-3"><cf_get_lang no='349.Yüksek Lisans/Üniversite'></label>
					<div class="col col-3 col-xs-3">
						<input type="checkbox" name="levelid_8" id="levelid_8">
					</div>
				</div>
				<div class="form-group" id="item-levelid_11">
					<label class="col col-3 col-md-9 col-xs-3"><cf_get_lang no='352.Bölge/Şube/Departman'></label>
					<div class="col col-3 col-xs-3">
						<input type="checkbox" name="levelid_11" id="levelid_11">
					</div>
				</div>
				<div class="form-group" id="item-levelid_10">
					<label class="col col-3 col-md-9 col-xs-3"><cf_get_lang no='306.Sertifika'></label>
					<div class="col col-3 col-xs-3">
						<input type="checkbox" name="levelid_10" id="levelid_10">
					</div>
				</div>
				<div class="form-group" id="item-levelid_12">
					<label class="col col-3 col-md-9 col-xs-3"><cf_get_lang_main no='159.Ünvan'></label>
					<div class="col col-3 col-xs-3">
						<input type="checkbox" name="levelid_12" id="levelid_12">
					</div>
				</div>
				<div class="form-group" id="item-levelid_13">
					<label class="col col-3 col-md-9 col-xs-3"><cf_get_lang_main no='1085.Pozisyon'></label>
					<div class="col col-3 col-xs-3">
						<input type="checkbox" name="levelid_13" id="levelid_13">
					</div>
				</div>
				<div class="form-group" id="item-levelid_14">
					<label class="col col-3 col-md-9 col-xs-3"><cf_get_lang no='353.İşe Giriş Tarihi'></label>
					<div class="col col-3 col-xs-3">
						<input type="checkbox" name="levelid_14" id="levelid_14">
					</div>
				</div>
			</div>
		</div>
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function="kontrol()">
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
    function kontrol(){
        <cfif isdefined("attributes.draggable")>
            loadPopupBox('class_attenders' , '<cfoutput>#attributes.modal_id#</cfoutput>');
            return false;
        </cfif>
    }
    function durum(status)
    {
        if (status == true)
        {
            for(i=1;i<=14;i++)
            {
                var my_chk=eval("document.all.levelid_" + i);
                my_chk.checked=true;
            }	
        }
        else
        {
            for(i=1;i<=14;i++)
            {
                var my_chk=eval("document.all.levelid_" + i);
                my_chk.checked=false;
            }	
        }
    }
</script>