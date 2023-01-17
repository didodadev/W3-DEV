<cfquery  name="upd_mail_info" datasource="#DSN#">
	SELECT 
		*
	FROM 
		CUBE_MAIL
	WHERE 
		MAILBOX_ID=#url.mailbox_id#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55264.Mail Hesapları Güncelle"></cfsavecontent>
<div class="col col-6" style="width:50%;">
	<cf_box add_href="javascript:openBoxDraggable('#request.self#?fuseaction=hr.popup_crate_mail_account&employee_id=#attributes.employee_id#')" title="#message#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="#request.self#?fuseaction=hr.emptypopup_upd_email" method="post" name="upd_mail_account_form">
			<cfinput type="hidden" name="MAILBOX_ID" value="#attributes.mailbox_id#"/>
			<cfinput type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="#attributes.employee_id#"/>
			<cfoutput query="upd_mail_info">
				<cf_box_elements>
					<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id="57493.Aktif"></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfscript>
								secim = "yes";
								if (ISACTIVE != 1)
									secim = "no";
							</cfscript>
							<cfinput type="checkbox" name="ACTIVE" value="ACTIVE" checked="#secim#">
						</div>
					</div>
					<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="45116.Mail adresi giriniz"></cfsavecontent>
							<label><cf_get_lang dictionary_id='57428.mail'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="hidden" name="employee_id" value="#attributes.employee_id#"/>
							<cfinput type="text" name="EMAIL" required="yes" message="#message#" VALUE="#EMAIL#"/>
						</div>
					</div>
					<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="34327.Bir kullanıcı adı giriniz"></cfsavecontent>
							<label><cf_get_lang dictionary_id='55271.Hesap_Adi'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="text" name="ACC_NAME" required="yes" message="#message#" VALUE="#ACCOUNT#">
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
							<cfinput type="text" name="POP" required="yes" message="#message#" VALUE="#POP#">
						</div>
					</div>
					<div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="51286.Giden Posta Sunucu Adını Giriniz"></cfsavecontent>
							<label><cf_get_lang dictionary_id='51128.Giden Posta Sunucusu - SMTP'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfinput type="text" name="SMTP" required="yes" message="#message#" VALUE="#SMTP#">
						</div>
					</div>
				</cf_box_elements>
			</cfoutput>
			<cf_box_footer>
				<cf_record_info query_name="upd_mail_info">
				<cf_workcube_buttons is_upd='1' insert_alert='' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_email_account&mailbox_id=#attributes.mailbox_id#' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script>
	function kontrol(){
		<cfoutput>
			loadPopupBox('upd_mail_account_form' , '#attributes.modal_id#')
		</cfoutput>
	}
</script>