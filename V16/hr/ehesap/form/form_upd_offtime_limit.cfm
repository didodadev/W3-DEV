<cf_xml_page_edit  fuseact='ehesap.offtime_limit'>
<cfinclude template="../query/get_offtime_limit.cfm">
<cfscript>
	cmp = createObject("component","V16.hr.ehesap.cfc.employee_puantaj_group");
	cmp.dsn = dsn;
	get_groups = cmp.get_groups();
</cfscript>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='55196.İzin Süreleri'> <cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
<cf_box closable="0">
<cfform name="offtime_limit" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_offtime_limit">
	<cf_box_elements>
		<input type="hidden" name="limit_id" id="limit_id" value="<cfoutput>#attributes.limit_id#</cfoutput>">
		<div class="col col-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group" id="item-definition_type">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53872.Tanım Tipi'></label>
				<div class="col col-8 col-xs-12">
					<select id="definition_type" name="definition_type" onchange="change_page(this.value)">
						<option value="1" <cfif get_offtime_limit.definition_type eq 1>selected</cfif>><cf_get_lang dictionary_id='54199.Yıllara Göre'></option>
						<option value="0" <cfif get_offtime_limit.definition_type eq 0>selected</cfif>><cf_get_lang dictionary_id='29675.Aylara Göre'></option>
					</select>
				</div>
			</div>
			<div class="form-group" id="item-group_id">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="56857.Çalışan Grubu"></label>
				<div class="col col-8 col-xs-12">
					<cf_multiselect_check
						query_name="get_groups"
						name="group_id"
						width="150"
						option_text="#getLang('main',322)#"
						option_value="group_id"
						option_name="group_name"
						value="#get_offtime_limit.puantaj_group_ids#">
				</div>
			</div>
			<div class="form-group" id="item-startdate">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'> *</label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlama Tarihi girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="startdate" value="#dateformat(get_offtime_limit.startdate,dateformat_style)#" style="width:65px;" validate="#validate_style#" required="yes" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
						<span class="input-group-addon no-bg"></span>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="finishdate" value="#dateformat(get_offtime_limit.finishdate,dateformat_style)#" style="width:65px;" validate="#validate_style#" required="yes" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-day_control">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="51042.Öğleden Önce"><cf_get_lang dictionary_id='54351.Yarım günlük izin süresi'> (<cf_get_lang dictionary_id='57491.saat'>)</label>
				<div class="col col-8 col-xs-12">
					<!--- <cfsavecontent variable="message"><cf_get_lang no='1338.8-24 arası bir değer giriniz'></cfsavecontent> --->
					<cfinput type="text" value="#get_offtime_limit.day_control#" name="day_control" validate="integer">
					<!---  <cf_get_lang no='182.den öncesi yarım gün sayılır'> --->
				</div>
			</div>
			<div class="form-group" id="item-day_control_afternoon">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="51160.Öğleden Sonra"><cf_get_lang dictionary_id='54351.Yarım günlük izin süresi'> (<cf_get_lang dictionary_id='57491.saat'>)</label>
				<div class="col col-8 col-xs-12">
					<cfinput type="text" value="#get_offtime_limit.day_control_afternoon#" name="day_control_afternoon" validate="integer">
				</div>
			</div>
			<div class="form-group" id="item-saturday_on">
				<label class="col col-4 col-xs-12 hide"><cf_get_lang dictionary_id='53120.Cumartesi günlerini izin hesabına dahil et'></label>
				<div class="col col-8 col-xs-12">
					<label><input type="checkbox" name="saturday_on" id="saturday_on"<cfif get_offtime_limit.saturday_on eq 1> checked="checked"</cfif> value="1" /><cf_get_lang dictionary_id='53120.Cumartesi günlerini izin hesabına dahil et'></label>
				</div>
			</div>
			<div class="form-group" id="item-sunday_on">
				<label class="col col-4 col-xs-12 hide"><cf_get_lang dictionary_id='54352.Pazar günlerini izin hesabına dahil et'></label>
				<div class="col col-8 col-xs-12">
					<label><input type="checkbox" name="sunday_on" id="sunday_on"<cfif get_offtime_limit.sunday_on eq 1> checked="checked"</cfif> value="1" /><cf_get_lang dictionary_id='54352.Pazar günlerini izin hesabına dahil et'></label>
				</div>
			</div>
			<div class="form-group" id="item-public_holiday_on">
				<label class="col col-4 col-xs-12 hide"><cf_get_lang dictionary_id='54353.Genel tatil günlerini izin hesabına dahil et'></label>
				<div class="col col-8 col-xs-12">
					<label><input type="checkbox" name="public_holiday_on" id="public_holiday_on"<cfif get_offtime_limit.public_holiday_on eq 1> checked="checked"</cfif> value="1" /><cf_get_lang dictionary_id='54353.Genel tatil günlerini izin hesabına dahil et'></label>
				</div>
			</div>
		</div>
		<div class="col col-6 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group" id="item-limit_1">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53213.Limit'> 1</label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='53214.Limit girmelisiniz'></cfsavecontent>
						<cfinput value="#get_offtime_limit.limit_1#" required="Yes" message="#message#" type="text" name="limit_1" style="width:50px;" maxlength="4"  validate="integer">
						<span class="input-group-addon no-bg"><label id="limit1_yil_td"><cfif get_offtime_limit.definition_type eq 1><cf_get_lang dictionary_id='59601.aya kadar'><cfelse><cf_get_lang dictionary_id='58724.Ay'></cfif></label></span>
						<span class="input-group-addon no-bg"></span>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='60865.yıla kadar girmelisiniz'></cfsavecontent>
						<cfinput value="#get_offtime_limit.limit_1_days#" required="Yes" message="#message#" type="text" name="limit_1_days" style="width:50px;" maxlength="4"  validate="integer">
						<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='57490.gün'></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="limit2_tr" <cfif get_offtime_limit.definition_type eq 0>style="display:none;"</cfif>>
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53213.Limit'> 2</label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='53214.Limit girmelisiniz'></cfsavecontent>
						<cfinput value="#get_offtime_limit.limit_2#" message="#message#" type="text" name="limit_2" id="limit_2" style="width:50px;" maxlength="4" validate="integer">
						<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53215.yıla kadar'></span>
						<span class="input-group-addon no-bg"></span>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='60865.yıla kadar girmelisiniz'></cfsavecontent>
						<cfinput value="#get_offtime_limit.limit_2_days#" message="#message#" type="text" name="limit_2_days" id="limit_2_days" style="width:50px;" maxlength="4"  validate="integer">
						<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='57490.gün'></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="limit3_tr" <cfif get_offtime_limit.definition_type eq 0>style="display:none;"</cfif>>
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53213.Limit'> 3</label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='53214.Limit girmelisiniz'></cfsavecontent>
						<cfinput value="#get_offtime_limit.limit_3#" message="#message#" type="text" name="limit_3" id="limit_3" style="width:50px;" validate="integer">
						<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53215.yıla kadar'></span>
						<span class="input-group-addon no-bg"></span>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='60865.yıla kadar girmelisiniz'></cfsavecontent>
						<cfinput value="#get_offtime_limit.limit_3_days#" message="#message#" type="text" name="limit_3_days" id="limit_3_days" style="width:50px;" maxlength="4" validate="integer">
						<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='57490.gün'></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="limit4_tr" <cfif get_offtime_limit.definition_type eq 0>style="display:none;"</cfif>>
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53213.Limit'> 4</label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='53214.Limit girmelisiniz'></cfsavecontent>
						<cfinput value="#get_offtime_limit.limit_4#" message="4. aralık üst limiti !" type="text" name="limit_4" id="limit_4" style="width:50px;" maxlength="4" validate="integer">
						<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53215.yıla kadar'></span>
						<span class="input-group-addon no-bg"></span>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='60865.yıla kadar girmelisiniz'></cfsavecontent>
						<cfinput value="#get_offtime_limit.limit_4_days#" message="#message#" type="text" name="limit_4_days" id="limit_4_days" style="width:50px;" maxlength="4" validate="integer">
						<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='57490.gün'></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="limit5_tr" <cfif get_offtime_limit.definition_type eq 0>style="display:none;"</cfif>>
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53213.Limit'> 5</label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='53214.Limit girmelisiniz'></cfsavecontent>
						<cfinput value="#get_offtime_limit.limit_5#" message="4. aralık üst limiti !" type="text" name="limit_5" id="limit_5" style="width:50px;" maxlength="4" validate="integer">
						<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53215.yıla kadar'></span>
						<span class="input-group-addon no-bg"></span>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='60865.yıla kadar girmelisiniz'></cfsavecontent>
						<cfinput value="#get_offtime_limit.limit_5_days#" message="#message#" type="text" name="limit_5_days" id="limit_5_days" style="width:50px;" maxlength="4" validate="integer">
						<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='57490.gün'></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-MIN_YEARS">
				<div class="col col-4">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='53217.Minumum Değeri girmelisiniz'></cfsavecontent>
						<cfinput name="min_years" value="#get_offtime_limit.min_years#" required="yes" message="#message#" type="text" style="width:50px;" validate="integer">
						<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='30963.den küçük'></span>
					</div>
				</div>
				<div class="col col-8">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='53218.Maximum Değeri girmelisiniz'></cfsavecontent>
						<cfinput name="max_years" value="#get_offtime_limit.max_years#" required="yes" message="#message#" type="text" style="width:50px;" validate="integer">
						<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='53221.den büyükler için'></span>
						<span class="input-group-addon no-bg"></span>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='53219.Gün Değeri girmelisiniz'></cfsavecontent>
						<cfinput name="min_max_days" value="#get_offtime_limit.min_max_days#" required="yes" message="#message#" type="text" style="width:50px;" validate="integer">
						<span class="input-group-addon no-bg"><cf_get_lang dictionary_id='57490.gün'></span>
					</div>
				</div>
			</div>
			<label class="col col-12"><b>* <cf_get_lang dictionary_id='53222.Not : Sonsuz için (9999) yazınız'>!</b></label>
		</div>
	</cf_box_elements>
	<cf_box_footer>
		<div class="col col-6 col-xs-12">
			<cf_record_info query_name="get_offtime_limit">
		</div>
		<div class="col col-6 col-xs-12">
			<cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_offtime_limit&limit_id=#attributes.limit_id#' add_function='kontrol()'>
		</div>
	</cf_box_footer>
</cfform>
</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if($('#definition_type').val() == 1)
		{
			if($('#limit2').val() == '' || $('#limit3').val() == '' || $('#limit4').val() == '')
			{
				alert("<cf_get_lang dictionary_id='53214.Limit girmelisiniz'>");
				return false;
			}
			if($('#limit_2_days').val() == '' || $('#limit_3_days').val() == '' || $('#limit_4_days').val() == '')
			{
				alert("<cf_get_lang dictionary_id='53216.aya kadar girmelisiniz'>");
				return false;
			}
		}
		return true;
	}
	function change_page(i)
	{
		if (i == 0)
		{
			$('#limit2_tr').css('display','none');
			$('#limit3_tr').css('display','none');
			$('#limit4_tr').css('display','none');
			$('#limit5_tr').css('display','none');
			$('#limit1_yil_td').text("<cf_get_lang dictionary_id='58724.Ay'>");
		}
		else
		{
			$('#limit2_tr').css('display','');
			$('#limit3_tr').css('display','');
			$('#limit4_tr').css('display','');
			$('#limit5_tr').css('display','');
			$('#limit1_yil_td').text("<cf_get_lang dictionary_id='59601.aya kadar'>");
		}
	}
</script>
