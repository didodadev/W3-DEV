<cfquery name="get_high_school_part" datasource="#dsn#">
	SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
</cfquery>
<cfquery name="get_unv" datasource="#dsn#">
	SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
</cfquery>
<cfquery name="get_education_level" datasource="#dsn#">
  SELECT * FROM SETUP_EDUCATION_LEVEL
</cfquery>
<cfquery name="get_school_part" datasource="#dsn#">
	SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
</cfquery>
<cfquery name="GET_LANGUAGES" datasource="#dsn#">
	SELECT LANGUAGE_ID,LANGUAGE_SET FROM SETUP_LANGUAGES ORDER BY LANGUAGE_SET
</cfquery>
<cfset getInfoTemp = createObject("component","cfc.right_menu_fnc")>
<cfset get_lang = getInfoTemp.getLangs('#dsn#')>
<cfif attributes.ctrl_edu eq 0>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="56495.Eğitim Bilgisi Ekle"></cfsavecontent>
<cfelse>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="56608.Eğitim Bilgisi Güncelle"></cfsavecontent>
</cfif>
<cfif isDefined("attributes.edu_start_new") and len(attributes.edu_start_new)>
	<cf_date tarih="attributes.edu_start_new">
</cfif>
<cfif isDefined("attributes.edu_finish_new") and len(attributes.edu_finish_new)>
	<cf_date tarih="attributes.edu_finish_new">
</cfif>
<cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="emp_add_training" method="post" action="#request.self#?fuseaction=hr.popup_add_edu_info">
			<input name="ctrl_edu" id="ctrl_edu" type="hidden" value="<cfif isdefined("attributes.ctrl_edu") and len(attributes.ctrl_edu)><cfoutput>#attributes.ctrl_edu#</cfoutput></cfif>">
			<input name="count_edu" id="count_edu" type="hidden" value="<cfif isdefined("attributes.count_edu") and len(attributes.count_edu)><cfoutput>#attributes.count_edu#</cfoutput></cfif>">
			<cf_box_elements>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-edu_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='56481.Okul Türü'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="edu_type" id="edu_type" style="width:100px;" onchange="degistir_okul(this.value);">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_education_level">
								<option value="#edu_level_id#;#edu_type#" <cfif isdefined("attributes.edu_type_new") and len(attributes.edu_type_new) and (edu_level_id eq attributes.edu_type_new)>SELECTED</cfif>>#education_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<cfset edu_type_control ="">
					<cfif isdefined("attributes.edu_type_new")>
						<cfquery name="get_edu_type" datasource="#dsn#">
							SELECT EDU_TYPE FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID = #attributes.edu_type_new#
						</cfquery>
						<cfset edu_type_control = get_edu_type.EDU_TYPE>
					</cfif>
					<div class="form-group" id="edu_id_tr" <cfif edu_type_control neq 2>style="display:none"<cfelse>style="display:"</cfif>>
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57709.Okul'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="edu_id" id="edu_id" style="width:190px;" onchange="degistir_okul2()">
								<option value=""><cf_get_lang dictionary_id='56155.Üniversiteler'></option>
								<cfoutput query="get_unv">
									<option value="#school_id#" <cfif isdefined("attributes.edu_id_new") and len(attributes.edu_id_new) and school_id eq attributes.edu_id_new>selected</cfif>>#school_name#</option>	
								</cfoutput>
								<option value="-1" <cfif isdefined("attributes.edu_id_new") and len(attributes.edu_id_new) and -1 eq attributes.edu_id_new>selected</cfif>>Diğer</option>
							</select>
						</div>
					</div>
					<div class="form-group" id="edu_name_tr" <cfif isdefined("attributes.edu_id_new") and attributes.edu_id_new eq -1 or (isdefined("edu_type_control") and listfind("1,0,2,3,4,5",edu_type_control))>style="display:"<cfelse>style="display:none"</cfif>>
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56482.Okul'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="edu_name" id="edu_name" style="width:190px;" value="<cfif isdefined("attributes.edu_name_new") and len(attributes.edu_name_new)><cfoutput>#attributes.edu_name_new#</cfoutput></cfif>" maxlength="75">
						</div>
					</div>
					<div class="form-group" id="item-edu_start">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='56496.Giriş Yılı'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message_start"><cf_get_lang dictionary_id='55955.Okul Giriş yılı girmelisiniz'></cfsavecontent>
								<cfif isdefined("attributes.edu_start_new") and len(attributes.edu_start_new)>
									<cfinput type="text" name="edu_start" value="#dateformat(attributes.edu_start_new,dateformat_style)#" style="width:60px;" maxlength="10" message="#message_start#">
								<cfelse>
									<cfinput type="text" name="edu_start" style="width:60px;" maxlength="10"  message="#message_start#">
								</cfif>	
								<span class="input-group-addon"><cf_wrk_date_image date_field="edu_start"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-edu_finish">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55954.Mez Yılı'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
							<cfsavecontent variable="message_finish"><cf_get_lang dictionary_id='712.Okul Mezuniyet yılı girmelisiniz'></cfsavecontent>	
								<cfif isdefined("attributes.edu_finish_new") and len(attributes.edu_finish_new)>
									<cfinput type="text" name="edu_finish" value="#dateformat(attributes.edu_finish_new,dateformat_style)#" style="width:60px;" maxlength="10" message="#message_finish#">
								<cfelse>
									<cfinput type="text" name="edu_finish" style="width:60px;" maxlength="10"  message="#message_finish#">
								</cfif> 
								<span class="input-group-addon"><cf_wrk_date_image date_field="edu_finish"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-edu_rank">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56153.Not Ort'></label>
						<div class="col col-8 col-xs-12">
							<cfif isdefined("attributes.edu_rank_new") and len(attributes.edu_rank_new)>
								<cfinput type="text" name="edu_rank" style="width:60px;" maxlength="10" value="#attributes.edu_rank_new#" title="Mezuniye derecenizi araya '/' işareti koyarak kaç üzerinden olduğunu belirterek yazınız !">
							<cfelse>					
								<cfinput type="text" name="edu_rank" style="width:60px;" maxlength="10" value="" title="Mezuniye derecenizi araya '/' işareti koyarak kaç üzerinden olduğunu belirterek yazınız !" onKeyUp="return(FormatCurrency(this,event));">
							</cfif>
						</div>
					</div>
					<div id="bolum_adi" <cfif (isdefined("edu_type_control") and listfind('1,2,3,4',edu_type_control))>style="display:;"<cfelse>style="display:none"</cfif>>
						<div class="form-group" id="high_part_id" <cfif isdefined("edu_type_control") and edu_type_control eq 1>style="display:;"<cfelse>style="display:none"</cfif>>
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57995.Bölüm'> *</label>
							<div class="col col-8 col-xs-12">
								<select name="edu_high_part_id" id="edu_high_part_id" style="width:190px;" onchange="degistir_bolum();">
									<option value=""><cf_get_lang dictionary_id='56154.Lise Bölümleri'></option>
									<cfoutput query="get_high_school_part">
										<option value="#high_part_id#" <cfif isdefined("attributes.edu_high_part_id_new") and len(attributes.edu_high_part_id_new) and high_part_id eq attributes.edu_high_part_id_new>selected</cfif>>#high_part_name#</option>	
									</cfoutput>
									<option value="-1" <cfif isdefined("attributes.edu_high_part_id_new") and len(attributes.edu_high_part_id_new) and -1 eq attributes.edu_high_part_id_new>selected</cfif>>Diğer</option>
								</select>
							</div>
						</div>
				
						<div class="form-group" id="edu_lang">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='41520.Öğrenim dili'></label>
							<div class="col col-8 col-xs-12">
								<select name="edu_lang">
									<option value=""><cf_get_lang dictionary_id='58996.Dil'></option>
									<cfoutput query="get_languages">
										<option value="#language_set#" <cfif isdefined("attributes.edu_lang_new") and len(attributes.edu_lang_new) and (language_set eq attributes.edu_lang_new)>selected</cfif>>#language_set#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="edu_lang_rate">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='59616.Öğrenim dili'><cf_get_lang dictionary_id ='58671.Oranı'></label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined("attributes.edu_lang_rate_new") and len(attributes.edu_lang_rate_new)>									
									<cfinput type="text" name="edu_lang_rate" value="#attributes.edu_lang_rate_new#">
								<cfelse>
									<cfinput type="text" name="edu_lang_rate" value="">
								</cfif>
							</div>
						</div>
						<div class="form-group" id="education_time">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id = "41519.Öğrenim süresi"></label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined("attributes.edu_lang_new") and len(attributes.edu_lang_new)>									
									<cfinput type="text" name="education_time" value="#attributes.education_time_new#">
								<cfelse>
									<cfinput type="text" name="education_time" value="">
								</cfif>
							</div>
						</div>
						<div class="form-group" id="part_id" <cfif isdefined("edu_type_control") and listfind('2,3,4',edu_type_control)>style="display:;"<cfelse>style="display:none"</cfif>>
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57995.Bölüm'></label>
							<div class="col col-8 col-xs-12">
								<select name="edu_part_id" id="edu_part_id" onchange="degistir_bolum2();">
									<option value=""><cf_get_lang dictionary_id='58139.Bölümler'></option>
									<cfoutput query="get_school_part">
										<option value="#part_id#" <cfif isdefined("attributes.edu_part_id_new") and len(attributes.edu_part_id_new) and part_id eq attributes.edu_part_id_new>selected</cfif>>#part_name#</option>	
									</cfoutput>
									<option value="-1" <cfif isdefined("attributes.edu_part_id_new") and len(attributes.edu_part_id_new) and -1 eq attributes.edu_part_id_new>selected</cfif>>Diğer</option>
								</select>
							</div>
						</div>
						<div class="form-group" id="part_name" <cfif (isdefined("attributes.edu_part_name_new") and len(attributes.edu_part_name_new) and attributes.edu_part_name_new eq -1) or ((isdefined("attributes.edu_high_part_id_new") and attributes.edu_high_part_id_new eq -1) or (isdefined("attributes.edu_part_id_new") and attributes.edu_part_id_new eq -1))>style="display:;"<cfelse>style="display:none"</cfif>>
							<label class="col col-4 col-xs-12"></label>
							<div class="col col-8 col-xs-12">
								<cfif isdefined("attributes.edu_part_name_new") and len(attributes.edu_part_name_new)>
									<cfinput type="text" name="edu_part_name" value="#attributes.edu_part_name_new#" style="width:190px;" maxlength="75">
								<cfelse>
									<cfinput type="text" name="edu_part_name" value="" style="width:190px;" maxlength="75">
								</cfif>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-is_edu_continue">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="31415.Hala Devam Ediyor"></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="is_edu_continue" id="is_edu_continue" <cfif isdefined("attributes.is_edu_continue_new") and len(attributes.is_edu_continue_new) and attributes.is_edu_continue_new eq 1>checked</cfif>>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-12">
					<cfif attributes.ctrl_edu eq 1>
						<cf_workcube_buttons is_upd="1" is_cancel="0" is_delete="0" add_function="gonder_training()">
					<cfelse>
						<cf_workcube_buttons is_upd="0" is_cancel="0" is_delete="0" add_function="gonder_training()">
					</cfif>
				</div>
			</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function degistir_okul(abc)
{
	document.emp_add_training.edu_id.value = "";
	document.emp_add_training.edu_high_part_id.value = "";
	document.emp_add_training.edu_part_name.value = "";
	var edu_type_id = abc.split(';')[1];
	if((edu_type_id ==0)){
		edu_name_tr.style.display = '';
		high_part_id.style.display = 'none';
		edu_id_tr.style.display='none';
		part_id.style.display='none';
		bolum_adi.style.display='none';
	}
	else if((edu_type_id ==1))
	{
		edu_name_tr.style.display = '';
		high_part_id.style.display = '';
		edu_id_tr.style.display='none';
		part_id.style.display='none';
		bolum_adi.style.display='';
	}
	else
	{
		edu_name_tr.style.display = 'none';
		high_part_id.style.display = 'none';
		edu_id_tr.style.display='';
		part_id.style.display='';
		bolum_adi.style.display='';
	}
	
}
function degistir_okul2()
	{	
		if(document.emp_add_training.edu_id.value == -1)
			{
				edu_name_tr.style.display = '';
				edu_id.style.display = '';
				document.emp_add_training.edu_name.value = '';
			}
		else if(document.emp_add_training.edu_id.value != -1)
			{
				edu_name_tr.style.display = 'none';
				document.emp_add_training.edu_name.value = '';
			}
	}
function degistir_bolum()
	{
		if(document.emp_add_training.edu_high_part_id.value == -1)
			{
				part_name.style.display = '';
				high_part_id.style.display = '';
				bolum_adi.style.display = '';
				document.emp_add_training.edu_part_name.value = '';
			}
			else if(document.emp_add_training.edu_high_part_id.value != -1)
			{
				part_name.style.display = 'none';
				document.emp_add_training.edu_part_name.value = '';
			}
	}
		
function degistir_bolum2()
	{
		if(document.emp_add_training.edu_part_id.value == -1)
			
			{
				part_name.style.display = '';
				part_id.style.display = '';
				bolum_adi.style.display = '';
				document.emp_add_training.edu_part_name.value = '';
			}
		else if(document.emp_add_training.edu_part_id.value != -1)
			{
				part_name.style.display = 'none';
				document.emp_add_training.edu_part_name.value = '';
			}
	}
function control()
	{
		if (document.emp_add_training.is_edu_continue.checked==false)
		{
		if(datediff(emp_add_training.edu_start.value,emp_add_training.edu_finish.value,0)<0)
		{
			alert("<cf_get_lang dictionary_id ='56497.Okul Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!");
			return false;
		}  
		}
		if (emp_add_training.edu_type.value=="")
		{
			alert("<cf_get_lang dictionary_id ='56498.Okul Türü Seçmelisiniz'>!");
			return false;
		}
		
		if (emp_add_training.edu_id.value=="" && emp_add_training.edu_name.value=="")
		{
			alert("<cf_get_lang dictionary_id ='56499.Okul Adı Girmelisiniz'>!");
			return false;
		}
		else if(emp_add_training.edu_id.value==-1 && trim(emp_add_training.edu_name.value)=="")
		{
			alert("<cf_get_lang dictionary_id ='56500.Okulunuzun Adını Yazınız'>!");
			return false;
		}
		
		if(emp_add_training.edu_type.value == 3)
		{
			if (emp_add_training.edu_high_part_id.value=="" && emp_add_training.edu_part_name.value=="")
			{
				alert("<cf_get_lang dictionary_id ='56501.Bölüm Adı Seçmek Zorunludur'>!");
				return false;
			}
			else if(emp_add_training.edu_high_part_id.value==-1 && trim(emp_add_training.edu_part_name.value)=="")
			{
				alert("<cf_get_lang dictionary_id ='56502.Bölüm Adı Lise Bölümleri Listesinde Yoksa Bu alana Yazmalısınız'>!");
				return false;
			}
		}
		
		if(emp_add_training.edu_type.value == 4 || emp_add_training.edu_type.value == 5)
		{
			if (emp_add_training.edu_part_id.value=="" && emp_add_training.edu_part_name.value=="")
			{
				alert("<cf_get_lang dictionary_id ='56501.Bölüm Adı Seçmek Zorunludur'>!");
				return false;
			}
			else if(emp_add_training.edu_part_id.value==-1 && trim(emp_add_training.edu_part_name.value)=="")
			{
				alert("<cf_get_lang dictionary_id ='56503.Bölüm Adı Listede Yoksa Bu alana Yazmalısınız'>!");
				return false;
			}
		}
		if(emp_add_training.edu_type.value == 6)
		{
			if(emp_add_training.edu_part_name.value=="")
			{
				alert("<cf_get_lang dictionary_id ='56504.Bölüm Adı Yazmalısınız'>!");
				return false;
			}
		}
		return true;
	}
function gonder_training()
	{
		if(control()==true)
		{
		var ctrl_edu = document.emp_add_training.ctrl_edu.value;
		var count_edu = document.emp_add_training.count_edu.value;
		var edu_type = document.emp_add_training.edu_type.value;
		var edu_part_id = document.emp_add_training.edu_part_id.value;
		var edu_part_name = document.emp_add_training.edu_part_name.value;
		var edu_name = document.emp_add_training.edu_name.value;
		var edu_id_ = document.emp_add_training.edu_id.value;
		var edu_start_ = document.emp_add_training.edu_start.value;
		var edu_finish_ = document.emp_add_training.edu_finish.value;
		var edu_rank_ = document.emp_add_training.edu_rank.value;
		var edu_high_part_id_ = document.emp_add_training.edu_high_part_id.value;
		var education_time_ =  document.emp_add_training.education_time.value;
		var edu_lang_ = document.emp_add_training.edu_lang.value;
		var edu_lang_rate_ = document.emp_add_training.edu_lang_rate.value;
		if(document.emp_add_training.is_edu_continue.checked == true)
			is_edu_continue = 1;
		else
			is_edu_continue= 0;
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>gonder_edu(edu_type,ctrl_edu,count_edu,edu_id_,edu_name,edu_start_,edu_finish_,edu_rank_,edu_high_part_id_,edu_part_id,is_edu_continue,edu_part_name,edu_lang_,edu_lang_rate_,education_time_);
		
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		return false;
		}
		else
		{
		return false;
		}
	}
</script>
