
<div class="col col-12 col-xs-12">
	<cf_box title="#getLang('','settings',32653)#" add_href="#request.self#?fuseaction=settings.form_add_guaranty_cat"><!--- Garanti Kategorisi --->
		<cfform name="guaranty_form" id="guaranty_form" method="post" action="#request.self#?fuseaction=settings.emptypopup_guaranty_cat_add">
			<cf_box_elements>	
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
					<cfinclude template="../display/list_guaranty_cat.cfm">
				</div>
				<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="form-group" id="item-guarantyCat">
							<label class="col col-4 col-md-4 col-xs-12"></label>
							  <div class="col col-3 col-md-3 col-xs-12"><cf_get_lang_main dictionary_id='57493.Aktif'>
								<input type="Checkbox" name="currency" id="currency" checked></div>
							</div>
						<div class="form-group small" id="item-guarantyCat">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'> *</label>
							<div class="col col-8 col-md-6 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
								<cfinput type="Text" name="guarantyCat" id="guarantyCat" value="" maxlength="50" required="Yes" message="#message#">							
							</div>
						 </div>
						 <div class="form-group small" id="item-guarantyCat">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='29513.Süre'></label>
							<div class="col col-3 col-md-6 col-xs-12">
								<cfquery name="get_guarantycat_time" datasource="#dsn#">
									SELECT 
										GUARANTYCAT_TIME_ID, 
										GUARANTYCAT_TIME, 
										GUARANTYCAT_TIME_DETAIL, 
										RECORD_EMP, 
										RECORD_DATE, 
										RECORD_IP, 
										UPDATE_EMP, 
										UPDATE_DATE, 
										UPDATE_IP 
									FROM 
										SETUP_GUARANTYCAT_TIME 
									ORDER BY 
										GUARANTYCAT_TIME
								</cfquery>
								<select name="guarantycat_time_" id="guarantycat_time_" style="width:70px;">
									<cfoutput query="get_guarantycat_time">
										<option value="#guarantycat_time_id#">#guarantycat_time# <cf_get_lang_main dictionary_id='58724.Ay'></option>
									</cfoutput>
								</select>								</div>
						 </div>
						 <div class="form-group" id="item-max_guaranty_time_">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42758.Azami garanti süresi'>*</label>
							<div class="col col-2 col-md-6 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='42758.Azami Garanti Süresi'>!</cfsavecontent>
									<input type="text" name="max_guaranty_time_" id="max_guaranty_time_" value="" onkeyup="isNumber(this);">
							</div>
							<div class="col col-1 col-md-1 col-xs-12"><cf_get_lang_main dictionary_id='57490.gün'></div>
						 </div>
						 <div class="form-group" id="item-detail">
							<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42009.Ayrıntı'></label>
							<div class="col col-8 col-md-6 col-xs-12">
								<Textarea name="detail" id="detail" style="width:170px;height:60px;"></TEXTAREA>							
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
		if(document.getElementById("guarantyCat").value == '')
		{
			alert('<cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'>!')
			return false;
		}
		else if(document.getElementById("max_guaranty_time_").value == '')
		{
			alert('<cf_get_lang dictionary_id='42758.Azami Garanti Süresi'>!')
			return false;
		}
	}

</script>