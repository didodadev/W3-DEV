<cfif not isdefined("url.id") OR not len(url.id)>
	<cfset url.id = 0>
</cfif>
<cfset setupCancel = CreateObject('V16.settings.cfc.setupCancel') /> 
<cfset setupCancel.dsn3 = DSN3>
<cfset get_cancel_types = setupCancel.getCancelTypeFnc(url.id)>

<cfif get_cancel_types.recordcount eq 0>
	<script language="javascript">
		alert('<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>');
		history.back();
	</script>
	<cfabort>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','İptal Nedeni','58825')#" add_href="#request.self#?fuseaction=settings.form_add_cancel_type" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
			<cfinclude template="../display/list_cancel_type.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="upd_cancel_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_cancel_type">
				<input type="hidden" name="cancel_id" id="cancel_id" value="<cfoutput>#url.id#</cfoutput>">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-is_active">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
								<label><input type="checkbox" value="1" name="is_active" id="is_active" <cfif get_cancel_types.is_active eq 1>checked="checked"</cfif>><cf_get_lang dictionary_id='57493.Aktif'></label>
							</div>
						</div>
						<div class="form-group" id="item-category">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='33281.Kategori Girmelisiniz'>!</cfsavecontent>
								<select name="cancel_type" id="cancel_type" value="#get_cancel_types.cancel_type#" required="yes" message="#message#">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="CREDIT_CARD" <cfif get_cancel_types.cancel_type eq "CREDIT_CARD">selected="selected"</cfif>><cf_get_lang dictionary_id='57836.Kredi Kartı Tahsilat'></option>
								</select>
							</div>				
						</div>
						<div class="form-group" id="item-cancel_name">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58825.İptal Nedeni'> *</label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58825.İptal Nedeni'> <cf_get_lang dictionary_id='57613.Girmelisiniz'> !</cfsavecontent>
								<cfinput type="text" name="cancel_name" id="cancel_name" value="#get_cancel_types.cancel_name#" maxlength="50" required="yes" message="#message#" style="width:180px;">
							</div>
						</div>
						<div class="form-group" id="item-cancel_detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
								<textarea name="cancel_detail" id="cancel_detail"><cfoutput>#get_cancel_types.cancel_detail#</cfoutput></textarea>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="get_cancel_types">
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
				</cf_box_footer>
			</cfform>
		</div>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(document.upd_cancel_type.cancel_detail.value.length>250)
		{
			alert("<cf_get_lang dictionary_id='58774.Maksimum açıklama uzunluğu'>: 250 !");
			return false;
		}
		if(document.getElementById('cancel_type').value == 0 )
		{
			alert("<cf_get_lang dictionary_id='33281.Kategori Girmelisiniz'>!");
			return false;
		}
		if(document.getElementById('cancel_name').value == 0 )
		{
			alert("<cf_get_lang dictionary_id='58825.İptal Nedeni'> <cf_get_lang dictionary_id='57613.Girmelisiniz'>!");
			return false;
		}
		return true;
	}
</script>
