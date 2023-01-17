<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','main',29529)# #getLang('','main',39091)#" add_href="#request.self#?fuseaction=settings.form_add_social_media_cat"><!--- Sosyal Medya Kategorileri --->
		<cfform name="social_cat" enctype="multipart/form-data" action="#request.self#?fuseaction=settings.emptypopup_social_media_cat_add" method="post">
			<cf_box_elements>	
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
					<cfinclude template="../display/list_social_media_cat.cfm"> 
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-socialCat">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42003.Kategori Adı'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Girilmesi Zorunlu Alan'>:<cf_get_lang dictionary_id='42003.Kategori Adi'></cfsavecontent>
							<cfinput type="text" name="socialCat" id="socialCat" value="" maxlength="50" required="Yes" message="#message#">							
						</div>
						</div>
						<div class="form-group" id="item-socialCat">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='41986.Simge'>*</label>
							<div class="col col-8 col-md-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Girilmesi Zorunlu Alan'>:<cf_get_lang dictionary_id='41986.Simge'></cfsavecontent>
					        <cfinput type="file" name="file_name_"  id="file_name_"  value="" required="Yes" message="#message#">							
						</div>
						</div>
						<div class="form-group" id="item-socialCat">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='41994.Link Tipi'></label>
							<div class="col col-8 col-md-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Girilmesi Zorunlu Alan'>:<cf_get_lang dictionary_id='41994.Link Tipi'></cfsavecontent>
					<cfinput type="text" name="socialLinkType" id="socialLinkType"  value="" maxlength="40">						
				       </div>
						</div>
					</div>
			    </div>
			</cf_box_elements>
			<cf_box_footer>	
				<cf_workcube_buttons is_upd='0' add_function="kontrol()">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
    function kontrol()
	{
		if(document.getElementById("socialCat").value == '')
		{
			alert('<cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!')
			return false;
		}
	}

</script>