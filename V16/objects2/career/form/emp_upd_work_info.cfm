<cfquery name="GET_SECTOR" datasource="#DSN#">
	SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT_ID
</cfquery>
<cfinclude template="../query/get_partner_positions.cfm">
<table cellspacing="0" cellpadding="0" border="0" style="width:100%; height:100%">
  	<tr class="color-border">
    	<td style="vertical-align:middle;">
      		<table cellspacing="1" cellpadding="2" border="0" style="width:100%; height:100%">
        		<tr class="color-list">
          			<td style="vertical-align:middle; height:35px;">
						<table align="center" style="width:98%">
							<tr>
								<td class="headbold" style="width:48%; vertical-align:bottom;"><cfif isDefined('attributes.control') and attributes.control eq 0><cf_get_lang no='758.İş Tecrübesi Ekle'><cfelseif isDefined('attributes.control') and attributes.control eq 1>İş Tecrübesi Güncelle</cfif></td>
								<td style="text-align:right;">&nbsp;		
								</td>
						  	</tr>
						</table>
          			</td>
        		</tr>
        		<tr class="color-row">
          			<td style="vertical-align:top;">
            			<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%">
              				<tr>
                				<td colspan="2">
									<cfform name="add_work_info" method="post" action="#request.self#?fuseaction=objects2.popup_upd_work_info">
									<input type="hidden" name="my_count" id="my_count" value="<cfif isdefined("attributes.my_count") and len(attributes.my_count)><cfoutput>#attributes.my_count#</cfoutput></cfif>">
									<input type="hidden" name="control" id="control" value="<cfif isdefined("attributes.control") and len(attributes.control)><cfoutput>#attributes.control#</cfoutput></cfif>">
									<table border="0">
										<tr style="height:25px;">
											<td colspan="4"class="formbold"><cf_get_lang no='759.Deneyim Bilgileri'></td>
										</tr>
										<tr>
											<td style="width:110px;"><cf_get_lang_main no='162.Şirket'></td>
											<td style="width:200px;">
												<cfif isdefined("attributes.exp_name_new") and len(attributes.exp_name_new)>
													<input type="text" name="exp_name" id="exp_name" value="<cfoutput>#attributes.exp_name_new#</cfoutput>" maxlength="50" style="width:150px;">
												<cfelse>
													<input type="text" name="exp_name" id="exp_name" value="" maxlength="50" style="width:150px;">
												</cfif>
											</td>
											<td style="width:85px;"><cf_get_lang_main no='1085.Pozisyon'></td>
											<td>
												<cfif isdefined("attributes.exp_position_new") and len(attributes.exp_position_new)>
													<input type="text" name="exp_position" id="exp_position" value="<cfoutput>#attributes.exp_position_new#</cfoutput>" maxlength="50" style="width:150px;">
												<cfelse>
													<input type="text" name="exp_position" id="exp_position" value="" maxlength="50" style="width:150px;">
												</cfif>
											</td>
										</tr>
										<tr>
											<td><cf_get_lang_main no='167.Sektör'></td>
											<td>
												<select name="exp_sector_cat" id="exp_sector_cat" style="width:150px;">
													<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
													<cfoutput query="get_sector">
														<option value="#sector_cat_id#" <cfif isdefined("attributes.exp_sector_cat_new") and len(attributes.exp_sector_cat_new) and sector_cat_id eq attributes.exp_sector_cat_new>selected</cfif>>
														#sector_cat#</option>
													</cfoutput>
												</select>
											</td>
											<td><cf_get_lang_main no='159.Ünvan'></td>
											<td>
												<select name="exp_task_id" id="exp_task_id" style="width:150px;">
													<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
													<cfoutput query="get_partner_positions">
														<option value="#partner_position_id#" <cfif isdefined("attributes.exp_task_id_new") and len(attributes.exp_task_id_new) and partner_position_id eq attributes.exp_task_id_new>selected</cfif>>#partner_position#</option>
													</cfoutput>
												</select>
											</td>
										</tr>
										<tr>
											<td><cf_get_lang_main no='89.Başlangıç'></td>
											<td>
												<cfsavecontent variable="message"><cf_get_lang no='154.Başlangıç Tarihini Kontrol Ediniz'>!</cfsavecontent>
												<cfif isdefined("attributes.exp_start_new") and isdate(attributes.exp_start_new)>
													<cfinput type="text" name="exp_start" id="exp_start"  value="#dateformat(attributes.exp_start_new,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:130px;">
												<cfelse>
													<cfinput type="text" name="exp_start" id="exp_start" value="" validate="eurodate" maxlength="10" message="#message#" style="width:130px;">
												</cfif>
												<cf_wrk_date_image date_field="exp_start">
											</td>
											<td><cf_get_lang_main no='90.Bitiş'></td>
											<td>
												<cfsavecontent variable="message"><cf_get_lang_main no ='2326.Bitiş Tarihini Kontrol Ediniz'>!</cfsavecontent>
												<cfif isdefined("attributes.exp_finish_new") and isdate(attributes.exp_finish_new)>
													<cfinput type="text" name="exp_finish" id="exp_finish"  value="#dateformat(attributes.exp_finish_new,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:130px;">
												<cfelse>
													<cfinput type="text" name="exp_finish" id="exp_finish"  value="" validate="eurodate" maxlength="10" message="#message#" style="width:130px;">
												</cfif>
												<cf_wrk_date_image date_field="exp_finish">
											</td>
										</tr>
										<tr>
											<td><cf_get_lang_main no='1173.Kod'> / <cf_get_lang_main no='87.Telefon'></td>
											<td>
												<cfif isdefined("attributes.exp_telcode_new") and len(attributes.exp_telcode_new)>
													<input type="text" name="exp_telcode" id="exp_telcode" value="<cfoutput>#attributes.exp_telcode_new#</cfoutput>" onkeyup="isNumber(this);" maxlength="4" style="width:55px;">
												<cfelse>
													<input type="text" name="exp_telcode" id="exp_telcode"  value="" maxlength="4" onkeyup="isNumber(this);" style="width:55px;">
												</cfif>
												<cfif isdefined("attributes.exp_tel_new") and len(attributes.exp_tel_new)>
													<input type="text" name="exp_tel" id="exp_tel" value="<cfoutput>#attributes.exp_tel_new#</cfoutput>" onkeyup="isNumber(this);" onKeyUp="isNumber(this);" maxlength="10" style="width:92px;">
												<cfelse>
													<input type="text" name="exp_tel" id="exp_tel" value="" onkeyup="isNumber(this);" maxlength="10" style="width:92px;">
												</cfif>
											</td>
											<td><cf_get_lang no='761.Ücret'> (<cf_get_lang no='762.Son Ayın Brüt Ücreti'>)</td>
											<td>
												<cfif isdefined("attributes.exp_salary_new") and len(attributes.exp_salary_new)>
													<input type="text" name="exp_salary" id="exp_salary" value="<cfoutput>#tlformat(attributes.exp_salary_new)#</cfoutput>" style="width:90px;" passthrough = "onkeyup=""return(formatcurrency(this,event));""" class="moneybox">
												<cfelse>
													<input type="text" name="exp_salary" id="exp_salary" value="" style="width:90px;" passthrough = "onkeyup=""return(formatcurrency(this,event));""" class="moneybox">
												</cfif>
												<cfquery name="GET_MONEY" datasource="#DSN#">
													SELECT
														MONEY
													FROM
														SETUP_MONEY
													WHERE
														PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.period_id#">
												</cfquery>
												<select name="exp_money_type" id="exp_money_type" style="width:58px;">
													<cfoutput query="get_money">
														<option value="#money#" <cfif isDefined('attributes.exp_money_type') and attributes.exp_money_type eq money>selected</cfif>>#money#</option>
													</cfoutput>
												</select>		
											</td>
										</tr>
										<tr>
											<td><cf_get_lang no='763.Ek Ödemeler'></td>
											<td><input type="text" name="exp_extra_salary" id="exp_extra_salary" value="<cfif isdefined("attributes.exp_extra_salary_new") and len(attributes.exp_extra_salary_new)><cfoutput>#tlformat(attributes.exp_extra_salary_new)#</cfoutput></cfif>" style="width:150px;" maxlength="75"></td>
											<td><cf_get_lang no='764.Hala Çalışıyorum'></td>
											<td><input type="checkbox" name="is_cont_work" id="is_cont_work" <cfif isdefined("attributes.is_cont_work_new") and len(attributes.is_cont_work_new) and attributes.is_cont_work_new eq 1>checked</cfif>></td>
										</tr>
										<tr>
											<td style="vertical-align:top;"><cf_get_lang no='765.Görev Sorumluluk ve Ek Açıklamalar'></td>
											<td colspan="3"><textarea name="exp_extra" id="exp_extra" style="width:442px;height:30px;"><cfif isdefined("attributes.exp_extra_new") and len(attributes.exp_extra_new)><cfoutput>#attributes.exp_extra_new#</cfoutput></cfif></textarea></td>
										</tr>
										<tr>
											<td><cf_get_lang no='766.Ayrılma nedeni'></td>
											<cfsavecontent variable="message"><cf_get_lang_main no='1687.Fazla karakter sayısı'></cfsavecontent>
											<td colspan="3"><textarea name="exp_reason" id="exp_reason" style="width:442px;height:30px;" maxlength="100" onkeyup="return ismaxlength(this)" onblur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfif isdefined("attributes.exp_reason_new") and len(attributes.exp_reason_new)><cfoutput>#attributes.exp_reason_new#</cfoutput></cfif></textarea></td>
										</tr>
										<tr style="height:35px;">
											<td >&nbsp;</td>
											<td colspan="3"  style="text-align:right;"><input type="button" value="<cfif isdefined("attributes.control") and len(attributes.control) and attributes.control eq 1>Güncelle<cfelse>Ekle</cfif>" onclick="form_gonder();"></td>
					  					</tr>
				  					</cfform>
									</table>
                				</td>
              				</tr>
            			</table>
          			</td>
       			</tr>
      		</table>
    	</td>
  	</tr>
</table>
<script type="text/javascript">
	function form_gonder()
	{
		tarih1_ = document.getElementById('exp_start').value.substr(6,4) +document.getElementById('exp_start').value.substr(3,2) + document.getElementById('exp_start').value.substr(0,2);
		tarih2_ = document.getElementById('exp_finish').value.substr(6,4) + document.getElementById('exp_finish').value.substr(3,2) + document.getElementById('exp_finish').value.substr(0,2);
		if(tarih2_.length > 0 && tarih1_.length > 0 && tarih2_ < tarih1_)
		{
			alert("<cf_get_lang no='1450.Başlangıç tarihi, bitiş tarihinden büyük olamaz!'>");
			return false;
		}
		if(_CF_checkadd_work_info(add_work_info))
		{
			var exp_salary = filterNum(document.getElementById('exp_salary').value);
			var exp_extra_salary = filterNum(document.getElementById('exp_extra_salary').value);
			var control = document.getElementById('control').value;
			if(document.getElementById('is_cont_work').checked == true)
			{
				kont_work = 1;
				if(document.getElementById('exp_finish').value != '')
				{
					document.getElementById('exp_finish').value == '';
					alert("<cf_get_lang no='767.Hala Çalışıyorsanız Bitiş Tarihi Giremezsiniz'>!");
					return false;
				}
			}
			else
			{
				kont_work= 0;
			}
			opener.gonder(document.getElementById('exp_name').value,document.getElementById('exp_position').value,document.getElementById('exp_start').value,document.getElementById('exp_finish').value,document.getElementById('exp_sector_cat').value,document.getElementById('exp_task_id').value,document.getElementById('exp_telcode').value,document.getElementById('exp_tel').value,exp_salary,exp_extra_salary,document.getElementById('exp_money_type').value,document.getElementById('exp_extra').value,document.getElementById('exp_reason').value,control,document.getElementById('my_count').value,kont_work);
			window.close();
		}
	}
</script>
