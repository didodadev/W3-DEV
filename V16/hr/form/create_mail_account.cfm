<div class="col col-6" style="width:50%;">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="55586.Mail Hesabı Ekle"></cfsavecontent>
	<cf_box title="#message#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="#request.self#?fuseaction=hr.emptypopup_crate_mail_account" method="post" name="create_mail_form">
			<cf_box_elements >
				<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<label><cf_get_lang dictionary_id="57493.Aktif"></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cfinput type="checkbox" name="ACTIVE" value="ACTIVE" checked="yes">
					</div>
				</div>
				<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="45116.Mail adresi giriniz"></cfsavecontent>
						<label><cf_get_lang dictionary_id='57428.mail'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cfinput type="hidden" name="employee_id" value="#attributes.employee_id#"/>
						<cfinput type="text" name="EMAIL" required="yes" message="#message#"/>
					</div>
				</div>
				<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="34327.Bir kullanıcı adı giriniz"></cfsavecontent>
						<label><cf_get_lang dictionary_id='55271.Hesap_Adi'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cfinput type="text" name="ACC_NAME" required="yes" message="#message#">
					</div>
				</div>
				<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="49039.Şifre Giriniz"></cfsavecontent>
						<label><cf_get_lang dictionary_id='55279.Parola'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cfinput type="text" name="PSWRD" required="yes" message="#message#">
					</div>
				</div>
				<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="51285.Gelen Posta Sunucu Adını Giriniz"></cfsavecontent>
						<label><cf_get_lang dictionary_id='51144.Gelen_Posta_Sunucusu - POP3'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cfinput type="text" name="POP" required="yes" message="#message#">
					</div>
				</div>
				<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="51286.Giden Posta Sunucu Adını Giriniz"></cfsavecontent>
						<label><cf_get_lang dictionary_id='51128.Giden Posta Sunucusu - SMTP'></label>
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
						<cfinput type="text" name="SMTP" required="yes" message="#message#">
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format="1" is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('create_mail_form' , #attributes.modal_id#)"),DE(""))#'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>