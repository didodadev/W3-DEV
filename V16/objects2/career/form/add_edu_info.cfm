<cfsetting showdebugoutput="no">
<cfquery name="GET_HIGH_SCHOOL_PART" datasource="#DSN#">
	SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
</cfquery>
<cfquery name="GET_UNV" datasource="#DSN#">
	SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
</cfquery>
<cfquery name="GET_SCHOOL_PART" datasource="#DSN#">
	SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
</cfquery>
<cfparam name="attributes.stage" default="11"><!--- hangi sayfa olduğunu belirleyen değer--->
<table cellspacing="0" cellpadding="0" border="0" style="width:100%; height:100%">
	<tr class="color-border">
    	<td style="vertical-align:middle;">
      		<table cellspacing="1" cellpadding="2" border="0" style="width:100%; height:100%">
				<tr class="color-list" style="vertical-align:middle;">
					<td style="height:35px;">
						<table align="center" border="0" style="width:98%">
					  		<tr>
								<td class="headbold" style="width:48%; vertical-align:bottom;"><cfif isDefined('attributes.ctrl_edu') and attributes.ctrl_edu eq 0><cf_get_lang no='889.Eğitim Bilgisi Ekle'><cfelse>Eğitim Bilgisi Güncelle</cfif></td>
								<td  style="text-align:right;">&nbsp;</td>
					  		</tr>
						</table>
				  	</td>
				</tr>
				<tr class="color-row" style="vertical-align:top;">
			  		<td>
				 		<table align="center" cellpadding="0" cellspacing="0" border="0" style="width:98%">
						    <tr>
								<td colspan="2">
									<cfform name="emp_add_training" method="post" action="#request.self#?fuseaction=objects2.emptypopup_updcv">
                                    <input type="hidden" name="stage" id="stage" value="<cfoutput>#attributes.stage#</cfoutput>">
                                    <input type="hidden" name="empapp_edu_row_id" id="empapp_edu_row_id" value="<cfif isDefined('attributes.empapp_edu_row_id') and len(attributes.empapp_edu_row_id)><cfoutput>#attributes.empapp_edu_row_id#</cfoutput></cfif>">
                                    <input type="hidden" name="ctrl_edu" id="ctrl_edu" value="<cfif isdefined("attributes.ctrl_edu") and len(attributes.ctrl_edu)><cfoutput>#attributes.ctrl_edu#</cfoutput></cfif>">
								 	<input type="hidden" name="count_edu" id="count_edu" value="<cfif isdefined("attributes.count_edu") and len(attributes.count_edu)><cfoutput>#attributes.count_edu#</cfoutput></cfif>">
									<input type="hidden" name="now_" id="now_" value="<cfoutput>#dateformat(now(),'yyyy')#</cfoutput>">
									<table border="0"> 
										<tr style="height:25px;">
											<td colspan="3"class="formbold"><cf_get_lang no='225.Eğitim Bilgileri'></td>
										</tr>
										<tr>
											<td></td>
											<td style="width:120px;"><cf_get_lang no='835.Okul Türü'> *</td>	
											<td style="width:175px;">
												<select name="edu_type" id="edu_type" style="width:100px;" onChange="degistir_okul()">
													<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
													<cfif not (isdefined("attributes.link_univ") and attributes.link_univ eq 1)><option value="1" <cfif isdefined("attributes.edu_type_new") and len(attributes.edu_type_new) and 1 eq attributes.edu_type_new>selected</cfif>><cf_get_lang no='837.İlkOkul'></option></cfif>
													<cfif not (isdefined("attributes.link_univ") and attributes.link_univ eq 1)><option value="2" <cfif isdefined("attributes.edu_type_new") and len(attributes.edu_type_new) and 2 eq attributes.edu_type_new>selected</cfif>><cf_get_lang no='523.OrtaOkul'></option></cfif>
													<cfif not (isdefined("attributes.link_univ") and attributes.link_univ eq 1)><option value="3" <cfif isdefined("attributes.edu_type_new") and len(attributes.edu_type_new) and 3 eq attributes.edu_type_new>selected</cfif>><cf_get_lang no='524.Lise'></option></cfif>
													<option value="4" <cfif isdefined("attributes.edu_type_new") and len(attributes.edu_type_new) and 4 eq attributes.edu_type_new or(isdefined("attributes.link_univ") and attributes.link_univ eq 1)>selected</cfif>><cf_get_lang_main no='1958.Üniversite'></option>
													<option value="5" <cfif isdefined("attributes.edu_type_new") and len(attributes.edu_type_new) and 5 eq attributes.edu_type_new>selected</cfif>><cf_get_lang no='526.Yükseklisans'></option>
													<option value="6" <cfif isdefined("attributes.edu_type_new") and len(attributes.edu_type_new) and 6 eq attributes.edu_type_new>selected</cfif>><cf_get_lang no='840.Doktora'></option>
												</select>
											</td>
										</tr>
										<tr>
											<td></td>
											<td <cfif isdefined("attributes.edu_id_new") and len(attributes.edu_id_new) and (attributes.edu_type_new eq 4 or attributes.edu_type_new eq 5 or attributes.edu_type_new eq 6) or (isdefined("attributes.link_univ") and attributes.link_univ eq 1)><cfelse>style="display:none;"</cfif> id="edu_td">
												<cf_get_lang no='520.Okul Adı'> *
											</td>
											<td <cfif isdefined("attributes.edu_id_new") and len(attributes.edu_id_new) and (attributes.edu_type_new eq 4 or attributes.edu_type_new eq 5 or attributes.edu_type_new eq 6) or (isdefined("attributes.link_univ") and attributes.link_univ eq 1)><cfelse>style="display:none;"</cfif> id="educ_id">
												<select name="edu_id" id="edu_id" style="width:190px;" onChange="degistir_okul2()">
													<option value=""><cf_get_lang no ='1110.Üniversiteler'></option>
													<cfoutput query="get_unv">
														<option value="#school_id#" <cfif isdefined("attributes.edu_id_new") and len(attributes.edu_id_new) and school_id eq attributes.edu_id_new>selected</cfif>>#school_name#</option>	
													</cfoutput>
													<option value="-1" <cfif isdefined("attributes.edu_id_new") and len(attributes.edu_id_new) and -1 eq attributes.edu_id_new>selected</cfif>><cf_get_lang_main no='744.Diğer'></option>
												</select>
											</td>
											<td <cfif isdefined("attributes.edu_name_new") and len(attributes.edu_name_new) and (attributes.edu_type_new eq 1 or attributes.edu_type_new eq 2 or attributes.edu_type_new eq 3) or (isdefined("attributes.edu_id_new") and attributes.edu_id_new eq -1)>style="display:;"<cfelse>style="display:none"</cfif> id="edu_name_td">
												<input type="text" name="edu_name" id="edu_name" style="width:190px;" value="<cfif isdefined("attributes.edu_name_new") and len(attributes.edu_name_new)><cfoutput>#attributes.edu_name_new#</cfoutput></cfif>" maxlength="75">
											</td>
										</tr>
										<tr>
											<td></td>
											<td><cf_get_lang no='838.Giriş Yılı'></td>
											<td>
												<cfsavecontent variable="message_start"><cf_get_lang no ='1111.Okul Giriş yılı girmelisiniz'></cfsavecontent>
												<cfif isdefined("attributes.edu_start_new") and len(attributes.edu_start_new)>
													<cfinput type="text" name="edu_start" id="edu_start" onKeyUp="isNumber(this);" value="#attributes.edu_start_new#" style="width:60px;" maxlength="4" validate="integer" message="#message_start#" range="1900,">
												<cfelse>
													<cfinput type="text" name="edu_start" id="edu_start" onKeyUp="isNumber(this);" value="" style="width:60px;" maxlength="4" validate="integer" message="#message_start#" range="1900,">
												</cfif>
											</td>
										</tr>
										<tr>
											<td></td>
											<td><cf_get_lang no='839.Mez Yılı'></td>
											<td>
												<cfsavecontent variable="message_finish"><cf_get_lang no ='1112.Okul Mezuniyet Yılı Girmelisiniz'></cfsavecontent>	
												<cfif isdefined("attributes.edu_finish_new") and len(attributes.edu_finish_new)>
													<cfinput type="text" name="edu_finish" id="edu_finish" onKeyUp="isNumber(this);" value="#attributes.edu_finish_new#" style="width:60px;" maxlength="4" validate="integer" message="#message_finish#" range="1900,">
												<cfelse>
													<cfinput type="text" name="edu_finish" id="edu_finish" onKeyUp="isNumber(this);" value="" style="width:60px;" maxlength="4" validate="integer" message="#message_finish#" range="1900,">
												</cfif>
											</td>
										</tr>
										<tr>
											<td></td>
											<td><cf_get_lang no='836.Not Ort'>.</td>
											<td>
												<cfif isdefined("attributes.edu_rank_new") and len(attributes.edu_rank_new)>
													<input type="text" name="edu_rank" id="edu_rank" style="width:60px;" maxlength="10" value="<cfoutput>#attributes.edu_rank_new#</cfoutput>" title="Mezuniye derecenizi araya '/' işareti koyarak kaç üzerinden olduğunu belirterek yazınız !">
												<cfelse>					
													<input type="text" name="edu_rank" id="edu_rank" style="width:60px;" maxlength="10" value="" title="Mezuniye derecenizi araya '/' işareti koyarak kaç üzerinden olduğunu belirterek yazınız !">
												</cfif>
											</td>
										</tr>
										<tr>
											<td></td>
											<td id="bolum_adi" <cfif (isdefined("attributes.edu_high_part_id_new") and len(attributes.edu_high_part_id_new)) or (isdefined("attributes.edu_part_id_new") and len(attributes.edu_part_id_new)) or (isdefined("attributes.edu_part_name_new") and len(attributes.edu_part_name_new)) or (isdefined("attributes.link_univ") and attributes.link_univ eq 1)>style="display:;"<cfelse>style="display:none"</cfif>><cf_get_lang_main no='583.Bölüm'> *</td>
											<td id="high_part_id"<cfif isdefined("attributes.edu_high_part_id_new") and len(attributes.edu_high_part_id_new) and (attributes.edu_type_new eq 3)>style="display:;"<cfelse>style="display:none"</cfif>>
												<select name="edu_high_part_id" id="edu_high_part_id" style="width:190px;" onChange="degistir_bolum();">
													<option value=""><cf_get_lang no ='1113.Lise Bölümleri'></option>
													<cfoutput query="get_high_school_part">
														<option value="#high_part_id#" <cfif isdefined("attributes.edu_high_part_id_new") and len(attributes.edu_high_part_id_new) and high_part_id eq attributes.edu_high_part_id_new>selected</cfif>>#high_part_name#</option>	
													</cfoutput>
													<option value="-1" <cfif isdefined("attributes.edu_high_part_id_new") and len(attributes.edu_high_part_id_new) and -1 eq attributes.edu_high_part_id_new>selected</cfif>><cf_get_lang_main no='744.Diğer'></option>
												</select>
											</td>
											<td id="part_id"<cfif isdefined("attributes.edu_part_id_new") and len(attributes.edu_part_id_new) and listfind('4,5,6',attributes.edu_type_new) or (isdefined("attributes.link_univ") and attributes.link_univ eq 1)>style="display:;"<cfelse>style="display:none"</cfif>>
												<select name="edu_part_id" id="edu_part_id"  style="width:190px;" onChange="degistir_bolum2();">
													<option value=""><cf_get_lang_main no='727.Bölümler'></option>
													<cfoutput query="get_school_part">
														<option value="#part_id#" <cfif isdefined("attributes.edu_part_id_new") and len(attributes.edu_part_id_new) and part_id eq attributes.edu_part_id_new>selected</cfif>>#part_name#</option>	
													</cfoutput>
													<option value="-1" <cfif isdefined("attributes.edu_part_id_new") and len(attributes.edu_part_id_new) and -1 eq attributes.edu_part_id_new>selected</cfif>><cf_get_lang_main no='744.Diğer'></option>
												</select>
											</td>
											<td id="part_name" <cfif isdefined("attributes.edu_part_name_new") and len(attributes.edu_part_name_new) and (attributes.edu_high_part_id_new eq -1 or attributes.edu_part_id_new eq -1 or attributes.edu_type_new eq 6)>style="display:;"<cfelse>style="display:none"</cfif>>
												<cfif isdefined("attributes.edu_part_name_new") and len(attributes.edu_part_name_new)>
													<input type="text" name="edu_part_name" id="edu_part_name" value="<cfoutput>#attributes.edu_part_name_new#</cfoutput>" style="width:190px;" maxlength="75">
												<cfelse>
													<input type="text" name="edu_part_name" id="edu_part_name" value="" style="width:190px;" maxlength="75">
												</cfif>
											</td>
										</tr>
										<tr>
											<td></td>
											<td id="devam" <cfif isdefined("attributes.is_edu_continue_new") and len(attributes.is_edu_continue_new) and listfind('3,4,5,6',attributes.edu_type_new) or (isdefined("attributes.link_univ") and attributes.link_univ eq 1)>style="display:;"<cfelse>style="display:none"</cfif>><cf_get_lang no ='1115.Hala Devam Ediyor'></td>
											<td id="devam_id" <cfif isdefined("attributes.is_edu_continue_new") and len(attributes.is_edu_continue_new) and listfind('3,4,5,6',attributes.edu_type_new) or (isdefined("attributes.link_univ") and attributes.link_univ eq 1)>style="display:;"<cfelse>style="display:none"</cfif>><input type="checkbox" name="is_edu_continue" id="is_edu_continue" <cfif isdefined("attributes.is_edu_continue_new") and len(attributes.is_edu_continue_new) and attributes.is_edu_continue_new eq 1>checked</cfif>></td>
										</tr>
										<tr>
											<td >&nbsp;</td>
											<td colspan="3"  style="text-align:right;">
                                             <cf_workcube_buttons is_upd='0'>
                                            </td>
										</tr>
								 	</table> 
                                  </cfform>
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
	function degistir_okul()
	{   
		if(document.getElementById('edu_type').value == 1 || document.getElementById('edu_type').value == 2 || document.getElementById('edu_type').value == 3)
		{   
			edu_name_td.style.display = '';
			educ_id.style.display = 'none';
			edu_td.style.display = '';
		}
		else if(document.getElementById('edu_type').value == 4 || document.getElementById('edu_type').value == 5 || document.getElementById('edu_type').value == 6)
		{
			educ_id.style.display = '';
			edu_name_td.style.display = 'none';
			edu_td.style.display = '';
		}
		else
		{
			educ_id.style.display = 'none';
			edu_name_td.style.display = 'none';
			edu_td.style.display = 'none';
		}
	
		if(document.getElementById('edu_type').value == 0 || document.getElementById('edu_type').value== 1 || document.getElementById('edu_type').value == 2)
		{
			part_name.style.display = 'none';
			high_part_id.style.display = 'none';
			part_id.style.display = 'none';
			bolum_adi.style.display = 'none';
			devam.style.display = 'none';
			devam_id.style.display = 'none';
			document.getElementById('edu_part_name').value = '';
			document.getElementById('edu_high_part_id').value = '';
			document.getElementById('edu_part_id').value = '';
			document.getElementById('edu_name').value = '';
			document.getElementById('edu_id').value = '';
		}
		else if(document.getElementById('edu_type').value == 3)
		{
			part_name.style.display = 'none';
			high_part_id.style.display = '';
			bolum_adi.style.display = '';
			part_id.style.display = 'none';
			devam.style.display = '';
			devam_id.style.display = '';
			document.getElementById('edu_part_name').value = '';
			document.getElementById('edu_high_part_id').value = '';
			document.getElementById('edu_part_id').value = '';
			document.getElementById('edu_name').value = '';
			document.getElementById('edu_id').value = '';
			document.getElementById('is_edu_continue').value = '';
		}
		else if(document.getElementById('edu_type').value == 4 || document.getElementById('edu_type').value == 5)
		{
			part_name.style.display = 'none';
			high_part_id.style.display = 'none';
			part_id.style.display = '';
			bolum_adi.style.display = '';
			devam.style.display = '';
			devam_id.style.display = '';
			document.getElementById('edu_part_name').value = '';
			document.getElementById('edu_high_part_id').value = '';
			document.getElementById('edu_name').value = '';
			document.getElementById('edu_id').value = '';
			document.getElementById('is_edu_continue').value = '';
		}
		else if(document.emp_add_training.edu_type.value == 6)
		{
			part_name.style.display = '';
			high_part_id.style.display = 'none';
			part_id.style.display = 'none';
			bolum_adi.style.display = '';
			devam.style.display = '';
			devam_id.style.display = '';
			document.getElementById('edu_high_part_id').value = '';
			document.getElementById('edu_part_id').value = '';
			document.getElementById('edu_name').value = '';
			document.getElementById('edu_id').value = '';
			document.getElementById('is_edu_continue').value = '';
		}
	}
	
	function degistir_okul2()
	{
		if(document.getElementById('edu_id').value == -1)
		{
			edu_name_td.style.display = '';
			educ_id.style.display = '';
			document.getElementById('edu_name').value = '';
		}
		else if(document.getElementById('edu_id').value != -1)
		{
			edu_name_td.style.display = 'none';
			document.getElementById('edu_name').value = '';
		}
	}
	
	function degistir_bolum()
	{
		if(document.getElementById('edu_high_part_id').value == -1)
		{
			part_name.style.display = '';
			high_part_id.style.display = '';
			bolum_adi.style.display = '';
			document.getElementById('edu_part_name').value = '';
		}
		else if(document.getElementById('edu_high_part_id').value != -1)
		{
			part_name.style.display = 'none';
			document.getElementById('edu_part_name').value = '';
		}
	}
			
	function degistir_bolum2()
	{
		if(document.getElementById('edu_part_id').value == -1)
		{
			part_name.style.display = '';
			part_id.style.display = '';
			bolum_adi.style.display = '';
			document.getElementById('edu_name').value = '';
		}
		else if(document.getElementById('edu_part_id').value != -1)
		{
			part_name.style.display = 'none';
			document.getElementById('edu_name').value = '';
		}
	}
	
	function control()
	{
		if (document.getElementById('edu_start').value > document.getElementById('edu_finish').value)
		{
			alert("<cf_get_lang no ='1116.Okul Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!");
			return false;
		}
		if (document.getElementById('edu_type').value == "")
		{
			alert("<cf_get_lang no ='1117.Okul Türü Seçmelisiniz'>!");
			return false;
		}
		
		if (document.getElementById('edu_id').value=="" && document.getElementById('edu_name').value=="")
		{
			alert("<cf_get_lang no ='1118.Okul Adı Girmelisiniz'>!");
			return false;
		}
		else if(document.getElementById('edu_id').value == -1 && trim(document.getElementById('edu_name').value)=="")
		{
			alert("<cf_get_lang no ='1119.Okulunuzun Adını Yazınız'>!");
			return false;
		}
		
		if(document.getElementById('edu_type').value == 3)
		{
			if (document.getElementById('edu_high_part_id').value == "" && document.getElementById('edu_part_name').value == "")
			{
				alert("<cf_get_lang no ='1120.Bölüm Adı Seçmek Zorunludur'>!");
				return false;
			}
			else if(document.getElementById('edu_high_part_id').value == -1 && trim(document.getElementById('edu_part_name').value)=="")
			{
				alert("<cf_get_lang no ='1121.Bölüm Adı Lise Bölümleri Listesinde Yoksa Bu alana Yazmalısınız'>!");
				return false;
			}
		}
		if(document.getElementById('edu_type').value == 4 || document.getElementById('edu_type').value == 5)
		{
			if (document.getElementById('edu_part_id').value =="" && document.getElementById('edu_part_name').value == "")
			{
				alert("<cf_get_lang no ='1120.Bölüm Adı Seçmek Zorunludur'>!");
				return false;
			}
			else if(document.getElementById('edu_part_id').value == -1 && trim(document.getElementById('edu_part_name').valu)=="")
			{
				alert("<cf_get_lang no ='1122.Bölüm Adı Listede Yoksa Bu alana Yazmalısınız'>!");
				return false;
			}
		}
		if(document.getElementById('edu_type').value == 6)
		{
			if(document.getElementById('edu_part_name').value == "")
			{
				alert("<cf_get_lang no ='1123.Bölüm Adı Yazmalısınız'>!");
				return false;
			}
		}
		return true;
	}
	
</script>
