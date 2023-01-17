<cfquery name="GET_ANNOUNCE_DETAIL" datasource="#DSN#">
	SELECT 
    	ANNOUNCE_ID, 
        ANNOUNCE_HEAD, 
        DETAIL, 
        START_DATE, 
        FINISH_DATE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	TRAINING_CLASS_ANNOUNCEMENTS 
    WHERE 
    	ANNOUNCE_ID = #attributes.announce_id#
</cfquery>
<cf_popup_box title="#getLang('training_management',462)#">
	
<cfform name="upd_announce" method="post" action="#request.self#?fuseaction=training_management.upd_announce">
	<div class="row">
		<div class="col col-12 col-xs-12 uniqueRow">
			<div class="row formContent"> 
				<input type="hidden" name="announce_id" id="announce_id" value="<cfoutput>#attributes.announce_id#</cfoutput>">
				<div class="form-group">
					<label class="col col-2 col-xs-12"><cf_get_lang_main no='1408.Başlık'> *</label>
					<div class="col col-7 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang_main no='324.Başlık Girmelisiniz'> !</cfsavecontent>
						<cfinput type="text" name="announce_head" required="yes" message="#message#" value="#get_announce_detail.announce_head#">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='58053. Başlangıç Tarihi'> * </label>
					<div class="col col-7 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>
							<cfinput validate="#validate_style#" message="#message#" required="yes" type="text" name="start_date" maxlength="10" value="#dateformat(get_announce_detail.start_date,dateformat_style)#" style="width:70px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-2 col-xs-12"><cf_get_lang_main dictionary_id='57700.Bitis tarihi'> *  </label>
					<div class="col col-7 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.bitis tarihi'></cfsavecontent>
							<cfinput validate="#validate_style#" message="#message#" type="text" name="finish_date" required="yes" maxlength="10" value="#dateformat(get_announce_detail.finish_date,dateformat_style)#" style="width:70px;">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-2 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
					<div class="col col-7 col-xs-12 paddingNone">
						<cfset tr_detail = get_announce_detail.detail>
						<cfmodule
						template="/fckeditor/fckeditor.cfm"
						toolbarSet="WRKContent"
						basePath="/fckeditor/"
						instanceName="detail"
						valign="top"
						value="#tr_detail#"
						width="500"
						height="300">
					</div>
				</div>
			</div>
		</div>
	</div>

	<cf_popup_box_footer>
		<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=training_management.del_announce&announce_id=#attributes.announce_id#&head=#get_announce_detail.announce_head#'>
		<cf_record_info query_name="GET_ANNOUNCE_DETAIL">
	</cf_popup_box_footer>
</cfform>
</cf_popup_box>

<script type="text/javascript">
	function kontrol()
	{
		
		if(document.upd_announce.start_date.value != '' && document.upd_announce.finish_date.value != '' )
		{
			return date_check(upd_announce.start_date,upd_announce.finish_date,"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'> !");
		}
		return OnFormSubmit();
	}
	
</script>
