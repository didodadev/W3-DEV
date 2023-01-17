<cfif isdefined("attributes.hr")>
    <cfset formun_adresi = 'settings.emptypopup_headquarters_add&hr=1'>
<cfelse>
    <cfset formun_adresi = 'settings.emptypopup_headquarters_add'>
</cfif>
<cf_catalystHeader>
<cfform name="add_contract_cat" method="post" action="#request.self#?fuseaction=#formun_adresi#">
    <div class="row"> 
		<div class="col col-12 uniqueRow">
			<div class="row formContent">
				<div class="row" type="row">
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-is_organization">
							<label class="col col-3 col-xs-12"><cf_get_lang no='953.Org Şemada Göster'></label>
							<div class="col col-9 col-xs-12"> 
								<input type="Checkbox" name="is_organization" id="is_organization" value="1" checked>
							</div>
						</div>
                        <div class="form-group" id="item-name">
							<label class="col col-3 col-xs-12"><cf_get_lang_main no='219.Ad'>*</label>
							<div class="col col-9 col-xs-12"> 
								<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="name" id="name" style="width:250px;" value="" maxlength="200" required="yes" message="#message#">
							</div>
						</div>
                        <div class="form-group" id="item-upper_headquarters_name">
							<label class="col col-3 col-xs-12"><cf_get_lang no='954.Üst Başkanlık'></label>
							<div class="col col-9 col-xs-12"> 
								<div class="input-group">
									<input type="hidden" name="upper_headquarters_id" id="upper_headquarters_id" value="">
                                    <input type="text" name="upper_headquarters_name" id="upper_headquarters_name" value="" style="width:250px;">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_headquarters&field_name=add_contract_cat.upper_headquarters_name&field_id=add_contract_cat.upper_headquarters_id</cfoutput>','list');"></span>
								</div>
							</div>
						</div>
                        <div class="form-group" id="item-hierarchy">
							<label class="col col-3 col-xs-12"><cf_get_lang_main no='349.Hiyerarşi'></label>
							<div class="col col-9 col-xs-12"> 
								<cfinput type="text" name="hierarchy" id="hierarchy" style="width:250px;" value="" maxlength="75">
							</div>
						</div>
						<div class="form-group" id="item-detail">
							<label class="col col-3 col-xs-12"><cf_get_lang_main no='217.Acıklama'></label>
							<div class="col col-9 col-xs-12"> 
								<cfsavecontent variable="textmessage"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>
                                <textarea name="detail" id="detail" style="width:250px;height:50px" message="<cfoutput>#textmessage#</cfoutput>" maxlength="300" onkeyup="return ismaxlength(this);" onBlur="return ismaxlength(this);"></textarea>
							</div>
						</div>
					</div>
				</div>	
				<div class="row formContentFooter">	
					<div class="col col-12"><cf_workcube_buttons type_format="1" is_upd='0' cancel_function ='goBack()'></div> 
				</div>
			</div>
		</div>
	</div>
</cfform>
<script>
function goBack() {
    window.history.back()
}
</script>
