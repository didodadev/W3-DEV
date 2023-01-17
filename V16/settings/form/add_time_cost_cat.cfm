<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','settings',43099)#" add_href="#request.self#?fuseaction=settings.form_add_time_cost_cat" is_blank="0"><!--- Zaman Harcamaları Kategorileri --->
		<cfform name="time_cost_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_time_cost_cat_add">
			<cf_box_elements>	
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
					<cfinclude template="../display/list_time_cost_cat.cfm">
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-time_cost_cat">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='1135.Zaman Harcamaları Kategorisi'> *</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang no='1164.Zaman Harcamaları Kategorisi Girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="time_cost_cat" id="time_cost_cat" size="60" value="" maxlength="50" required="yes" message="#message#">
							</div>
						</div>
						<div class="form-group" id="item-colour">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='341.Kategori Rengi'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<cf_workcube_color_picker name="colour" value="" width="200">
							</div>
						</div>
					</div>
			    </div>
			</cf_box_elements>
			<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
		</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
    function kontrol()
	{
		if(document.getElementById("time_cost_cat").value == '')
		{
			alert('<cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!')
			return false;
		}
	}

</script>