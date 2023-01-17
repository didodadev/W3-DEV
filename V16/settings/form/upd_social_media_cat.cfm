<!--- 
<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_upd_social_media_links&id=#url.id#</cfoutput>','small')"><img src="/images/info_plus.gif" border="0" alt="<cf_get_lang no='242.Ek Bilgiler'>" title="<cf_get_lang no='242.Ek Bilgiler'>"></a> --->

	<div class="col col-12 col-xs-12">
		<cf_box title="#getLang('','main',29529)# #getLang('','main',39091)#" add_href="#request.self#?fuseaction=settings.form_add_social_media_cat" is_blank="0"><!--- Sosyal Medya Kategorileri --->
			<cfform name="social_cat" enctype="multipart/form-data" action="#request.self#?fuseaction=settings.emptypopup_social_media_cat_upd" method="post">
				<cf_box_elements>
					<cfoutput>	
					<input type="hidden" id="clicked" name="clicked" value="">
					<cfquery name="smc2" datasource="#dsn#">
						SELECT 
							* 
						FROM 
							SETUP_SOCIAL_MEDIA_CAT 
						WHERE 
							SMCAT_ID=#attributes.ID#
					</cfquery>
					<input type="hidden" name="smcat_id" id="smcat_id" value="<cfoutput>#URL.ID#</cfoutput>">
					<input type="hidden" name="smicon_old" id="smicon_old" value="<cfoutput>#smc2.smcat_icon#</cfoutput>">
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
						<cfinclude template="../display/list_social_media_cat.cfm"> 
					</div>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group" id="item-socialCat">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42003.Kategori Adı'>*</label>
								<div class="col col-8 col-md-6 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>:<cf_get_lang no='20.Kategori Adi'></cfsavecontent>
							<cfinput type="text" name="socialCat" id="socialCat" style="width:150px;" value="#smc2.smcat#" maxlength="50" required="yes" message="#message#">						
							</div>
							</div>
							<div class="form-group" id="item-socialCat">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='41986.Simge'>*</label>
								<div class="col col-8 col-md-6 col-xs-12">
									<div class="input-group col col-12">
										<span class="col col-7">
									<cfinput type="file" name="file_name_" id="file_name_" style="width:150px;" value="">
										</span>
									<span class="col col-1">
									<cfif len(smc2.smcat_icon)>
										<img align="absbottom" width="20" height="20" src="../documents/settings/<cfoutput>#smc2.smcat_icon#</cfoutput>" title="<cf_get_lang dictionary_id='58029.İkon'>"/>
									</cfif>		
								</span>			
								</div>
							</div>
							</div>
							<div class="form-group" id="item-socialCat">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='41994.Link Tipi'></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<cfinput type="text" name="socialLinkType" id="socialLinkType"  value="#smc2.smcat_link_type#" maxlength="40">						
						   </div>
							</div>
						</div>
					</div>
				</cfoutput>
				</cf_box_elements>
				<cf_box_footer>	
					<cf_record_info query_name="smc2">
						<cf_workcube_buttons is_upd='1' add_function="kontrol()" delete_page_url='#request.self#?fuseaction=settings.emptypopup_social_media_cat_upd&smcat_id=#URL.ID#&is_del=1'>
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