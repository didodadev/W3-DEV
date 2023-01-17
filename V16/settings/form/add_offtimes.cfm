<cfif fusebox.circuit eq 'settings'>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='42379.Genel Tatil Zamanları'></cfsavecontent>
<cfelse>
	<cfsavecontent variable="title">Cumartesi Tatil Günleri></cfsavecontent>
</cfif>
<div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="1" sort="true">
	<cfinclude template="../display/list_offtimes.cfm"> 
</div>	
<div class="col col-10 col-md-10 col-sm-10 col-xs-12">
	<cf_box title="#title#" add_href="#request.self#?fuseaction=settings.form_add_offtimes">
		<cfform name="agenda_offtime" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.add_offtime">	
			<cf_box_elements>		
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-halftime">
							<label class="col col-3 col-md-6 col-xs-12"></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<label><input name="is_halfofftime" id="is_halfofftime" type="checkbox"><cf_get_lang dictionary_id='42914.Yarım Günlük Tatil'></label>
							</div>
						</div>
						<div class="form-group" id="item-offtime">
							<label class="col col-3 col-md-6 col-xs-12"><cfif fusebox.circuit eq 'settings'><cf_get_lang dictionary_id='42313.Tatil Adı'><cfelse><cf_get_lang_main dictionary_id='57631.Ad'></cfif>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='42760.Genel Tatil Zamanları Girmelisiniz!'></cfsavecontent>
									<cfinput maxlength="150" required="Yes" type="text" name="offtime_name" id="offtime_name" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-start">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='57655.Başlama Tarihi'> *</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='39354.Başlangıç Tarihini Giriniz!'></cfsavecontent>
								<cfinput maxlength="10" required="Yes" validate="#validate_style#" message="#message#" type="text" id="startdate" name="startdate">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-finish">
							<label class="col col-3 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='57700.Bitiş Tarihi'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='39357.Bitiş Tarihini Giriniz!'></cfsavecontent>
										<cfinput maxlength="10" type="text" name="finishdate" id="finishdate" required="Yes" message="#message#" validate="#validate_style#" value="">
										<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
								</div>
							</div>
						</div>
					</div>
			    </div>
			</cf_box_elements>
			<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='control()'>
		</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function control()
	{
		if(agenda_offtime.finishdate.value > agenda_offtime.startdate.value && agenda_offtime.is_halfofftime.checked == true)
		{
			agenda_offtime.is_halfofftime.checked = false;
			alert("Yarım günlük izin sadece başlangıç ve bitişi aynı olan kayıtlarda seçilebilir");
		}
		if ( (agenda_offtime.startdate.value !="") && (agenda_offtime.finishdate.value !="")) 
		{
			return date_check(agenda_offtime.startdate,agenda_offtime.finishdate,"<cf_get_lang dictionary_id ='43833.Başlangıç tarihi bitiş tarihinden küçük olmalıdır'>!");
		}
		return true;	
	}
	</script>