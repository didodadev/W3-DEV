<cf_xml_page_edit fuseact="objects.popup_add_meta_desc">
<cfset cfc= createObject("component","V16.objects.cfc.get_meta_desc")>
<cfset get_language =cfc.Get_Language()> 
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Meta Tanımı Ekle',58982)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_meta_description" method="post" action="#request.self#?fuseaction=objects.emptypopup_form_add_meta_desc">
		<cf_box_elements>
			<input type="hidden" name="content_keyword" id="content_keyword" value="<cfif isdefined('x_content_keyword') and len(x_content_keyword)><cfoutput>#x_content_keyword#</cfoutput></cfif>">
			<input type="hidden" name="action_type" id="action_type" value="<cfoutput>#attributes.action_type#</cfoutput>">
			<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#attributes.action_id#</cfoutput>">
			<input type="hidden" name="faction_type" id="faction_type" value="<cfoutput>#attributes.faction_type#</cfoutput>">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<div class="form-group" id="language_id">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="language_id" id="language_id">
							<cfoutput query="get_language">
								<option value="#language_short#">#language_set#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="meta_title">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58983.Meta Başlığı'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="text" name="meta_title" id="meta_title" value="" maxlength="80">
					</div>
				</div>
				<div class="form-group" id="meta_desc">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58993.Meta Tanımı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfoutput>
							<cfsavecontent variable="message">200<cf_get_lang dictionary_id='58997.Karakterden Fazla Yazmayınız!'></cfsavecontent>
							<textarea name="meta_desc" id="meta_desc" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="#message#" rows="4" maxlength="200"></textarea>
						</cfoutput>
					</div>
				</div>	
				<div class="form-group" id="meta_keywords">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58994.Meta Anahtar Kelimeleri'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfoutput>
							<cfsavecontent variable="message1">100<cf_get_lang dictionary_id='58997.Karakterden Fazla Yazmayınız!'></cfsavecontent>
							<textarea name="meta_keywords" id="meta_keywords" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="#message1#" maxrows="4"></textarea>
						</cfoutput>
					</div>	
				</div>
			</div>
		</cf_box_elements>		
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function="title_control()">
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	function title_control()
	{
		if(document.getElementById('meta_title').value == '')
		{
			alert("<cf_get_lang dictionary_id='60205.Meta Başlığı Alanı Boş Geçilemez'>!");
			return false;	
		}
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('add_meta_description' , <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
		</cfif>
	}
</script>
