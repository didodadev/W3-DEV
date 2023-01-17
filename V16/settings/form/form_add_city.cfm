<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<div class="col col-12 col-md-12 col-xs-12 col-sm-12">
	<cf_box title="#getLang('','İl Ekle','43363')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_city" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_city">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='42893.Ülkeler'>*</label>
						<select name="country" id="country">
							<cfoutput query="get_country">
								<option value="#country_id#" <cfif is_default eq 1>selected="selected"</cfif>>#country_name#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='43364.İl Adı'>*</label>
						<cfinput type="text" name="city_name" required="yes" message="#getLang('','İl Adı Girmelisiniz','43365')#" maxlength="30">
					</div>
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='29429.Tel Kodu'></label>
						<cfinput type="text" name="phone_code"  maxlength="5" onkeyup="isNumber(this);" onblur='isNumber(this);'>
					</div>
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='43119.Plaka Kodu'></label>
						<cfinput type="text" name="plate_code" maxlength="2" onKeyUp="isNumber(this);">
					</div>
					<div class="form-group">
						<label class="col col-6"><cf_get_lang dictionary_id='57485.Öncelik'></label>
						<cfinput name="priority" validate="integer" maxlength="2" onKeyUp="isNumber(this);">
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
