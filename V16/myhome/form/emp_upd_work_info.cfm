<cfquery name="get_sector" datasource="#dsn#">
	SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT_ID
</cfquery>
<cfquery name="get_task" datasource="#dsn#">
	SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION ORDER BY PARTNER_POSITION_ID
</cfquery>
<cfquery name="get_work_type" datasource="#dsn#">
	SELECT WORK_TYPE_ID, WORK_TYPE_NAME FROM SETUP_WORK_TYPE ORDER BY WORK_TYPE_ID
</cfquery>
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','İş Tecrübesi Ekle',31526)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_work_info" method="post" action="#request.self#?fuseaction=myhome.popup_upd_work_info">
			<input name="my_count" id="my_count" value="<cfif isdefined("attributes.my_count") and len(attributes.my_count)><cfoutput>#attributes.my_count#</cfoutput></cfif>" type="hidden">
			<input name="control" id="control" value="<cfif isdefined("attributes.control") and len(attributes.control)><cfoutput>#attributes.control#</cfoutput></cfif>" type="hidden">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='31529.Hala Çalışıyorum'></label>
						<div class="col col-8 col-sm-12">
							<input type="checkbox" name="is_cont_work" id="is_cont_work" <cfif isdefined("attributes.is_cont_work_new") and len(attributes.is_cont_work_new) and attributes.is_cont_work_new eq 1>checked</cfif>>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
						<div class="col col-8 col-sm-12">
							<cfif isdefined("attributes.exp_name_new") and len(attributes.exp_name_new)>
								<cfinput type="text" name="exp_name" value="#attributes.exp_name_new#" maxlength="500">
							<cfelse>
								<cfinput type="text" name="exp_name" value="" maxlength="500">
							</cfif>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
						<div class="col col-8 col-sm-12">
							<cfif isdefined("attributes.exp_position_new") and len(attributes.exp_position_new)>
								<cfinput type="text" name="exp_position" value="#attributes.exp_position_new#" maxlength="50">
							<cfelse>
								<cfinput type="text" name="exp_position" value="" maxlength="50">
							</cfif>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57579.Sektör'></label>
						<div class="col col-8 col-sm-12">
							<select name="exp_sector_cat" id="exp_sector_cat">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_sector">
									<option value="#sector_cat_id#" <cfif isdefined("attributes.exp_sector_cat_new") and len(attributes.exp_sector_cat_new) and sector_cat_id eq attributes.exp_sector_cat_new>selected</cfif>>
									#sector_cat#</option>
								</cfoutput>
							</select>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
						<div class="col col-8 col-sm-12">
							<select name="exp_task_id" id="exp_task_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_task">
									<option value="#partner_position_id#" <cfif isdefined("attributes.exp_task_id_new") and len(attributes.exp_task_id_new) and partner_position_id eq attributes.exp_task_id_new>selected</cfif>>#partner_position#</option>
								</cfoutput>
							</select>
						</div>                
					</div> 
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57501.Başlangıç'>*</label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30122.Başlangıç Tarihini Kontrol Ediniz'>!</cfsavecontent>
								<cfif isdefined("attributes.exp_start_new") and isdate(attributes.exp_start_new)>
									<cfinput type="text" name="exp_start" id="exp_start_"  value="#dateformat(attributes.exp_start_new,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:130px;">
								<cfelse>
									<cfinput type="text" name="exp_start" id="exp_start_"  value="" validate="#validate_style#" maxlength="10" message="#message#" style="width:130px;">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="exp_start_"></span>
							</div>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57502.Bitiş'>*</label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='30123.Bitiş Tarihini Kontrol Ediniz'>!</cfsavecontent>
								<cfif isdefined("attributes.exp_finish_new") and isdate(attributes.exp_finish_new)>
									<cfinput type="text" name="exp_finish" id="exp_finish_"  value="#dateformat(attributes.exp_finish_new,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:130px;">
								<cfelse>
									<cfinput type="text" name="exp_finish" id="exp_finish_"  value="" validate="#validate_style#" maxlength="10" message="#message#" style="width:130px;">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="exp_finish_"></span>
							</div>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='31281.Kod / Telefon'></label>
						<div class="col col-2 col-md-6 col-sm-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='55106.Telefon girmelisiniz'></cfsavecontent>
							<cfif isdefined("attributes.exp_telcode_new") and len(attributes.exp_telcode_new)>
								<cfinput type="text" name="exp_telcode" style="width:55px;" validate="integer" message="#message#" maxlength="4" value="#attributes.exp_telcode_new#">
							<cfelse>
								<cfinput type="text" name="exp_telcode" style="width:55px;" validate="integer" message="#message#" maxlength="4" value="">
							</cfif>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='34343.Telefon Kodu girmelisiniz'></cfsavecontent>
							<cfif isdefined("attributes.exp_tel_new") and len(attributes.exp_tel_new)>
								<cfinput type="text" name="exp_tel" style="width:92px;" validate="integer" message="#message#" maxlength="10" value="#attributes.exp_tel_new#">
							<cfelse>
								<cfinput type="text" name="exp_tel" style="width:92px;" validate="integer" message="#message#" maxlength="10" value="">
							</cfif>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='31528.Ücret (Son Ayın Brüt Ücreti)'></label>
						<div class="col col-8 col-sm-12">
							<cfif isdefined("attributes.exp_salary_new") and len(attributes.exp_salary_new)>
								<cfinput type="text" name="exp_salary" value="#tlformat(attributes.exp_salary_new)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
							<cfelse>
								<cfinput type="text" name="exp_salary" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
							</cfif>
						</div>                
					</div> 
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='31283.Ek Ödemeler'></label>
						<div class="col col-8 col-sm-12">
							<input type="text" onkeyup="return(FormatCurrency(this,event));" name="exp_extra_salary" id="exp_extra_salary" value="<cfif isdefined("attributes.exp_extra_salary_new") and len(attributes.exp_extra_salary_new)><cfoutput>#tlformat(attributes.exp_extra_salary_new)#</cfoutput></cfif>" maxlength="75">
						</div>                
					</div>
					<div class="form-group" id="item-exp_work_type_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55908.Çalışma Şekli'></label>
						<div class="col col-8 col-xs-12">
							<select name="exp_work_type_id" id="exp_work_type_id">
							<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
							<cfoutput query="get_work_type">
								<option value="#work_type_id#" <cfif isdefined("attributes.exp_work_type_id_new") and len(attributes.exp_work_type_id_new) and work_type_id eq attributes.exp_work_type_id_new>selected</cfif>>#work_type_name#</option>
							</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='31284.Görev Sorumluluk ve Ek Açıklamalar'></label>
						<div class="col col-8 col-sm-12">
							<textarea name="exp_extra" id="exp_extra" style="width:433px;height:30px;"><cfif isdefined("attributes.exp_extra_new") and len(attributes.exp_extra_new)><cfoutput>#attributes.exp_extra_new#</cfoutput></cfif></textarea>
						</div>                
					</div> 
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='31530.Ayrılma nedeni'></label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.FAzla karakter sayısı'></cfsavecontent>
							<textarea name="exp_reason" id="exp_reason" style="width:433px;height:30px;" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfif isdefined("attributes.exp_reason_new") and len(attributes.exp_reason_new)><cfoutput>#attributes.exp_reason_new#</cfoutput></cfif></textarea>
						</div>                
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<input type="button" value="<cfif isdefined("attributes.control") and len(attributes.control) and attributes.control eq 1><cf_get_lang dictionary_id='57464.Güncelle'><cfelse><cf_get_lang dictionary_id ='57582.Ekle'></cfif>" onClick="form_gonder();">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function form_gonder()
	{
		if(_CF_checkadd_work_info(add_work_info))
		{
			var exp_salary = filterNum(document.add_work_info.exp_salary.value);
			var exp_extra_salary = filterNum(document.add_work_info.exp_extra_salary.value);
			var control = document.add_work_info.control.value;
			if(document.add_work_info.is_cont_work.checked == true)
			{
				kont_work = 1;
				if(document.add_work_info.exp_finish.value != '')
				{
					document.add_work_info.exp_finish.value == '';
					alert("<cf_get_lang dictionary_id ='31534.Hala Çalışıyorsanız Bitiş Tarihi Giremezsiniz'>!");
					return false;
				}
			}
			else
			{
				kont_work= 0;
			}
			if(document.add_work_info.exp_finish.value == '' && document.add_work_info.is_cont_work.checked == false)
			{
				alert("<cf_get_lang dictionary_id='58491.Bitiş tarihi giriniz'>");
				return false;
			}
			if(document.add_work_info.exp_finish.value != '' && document.add_work_info.exp_start.value != '' )
			{			
				if(!date_check(document.add_work_info.exp_start, document.add_work_info.exp_finish, "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>"))
				return false;
			}
			

			<cfif not isdefined("attributes.draggable")>window.opener.</cfif>gonder(document.add_work_info.exp_name.value,document.add_work_info.exp_position.value,document.add_work_info.exp_start.value,document.add_work_info.exp_finish.value,document.add_work_info.exp_sector_cat.value,document.add_work_info.exp_task_id.value,document.add_work_info.exp_telcode.value,document.add_work_info.exp_tel.value,exp_salary,exp_extra_salary,document.add_work_info.exp_extra.value,document.add_work_info.exp_reason.value,control,/*document.add_work_info.exp_work_type_id.value,*/document.add_work_info.my_count.value,kont_work);
			<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		}
		else
		{
		return false;
		}
	}
</script>
