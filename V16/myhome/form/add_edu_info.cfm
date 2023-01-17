<cfquery name="get_high_school_part" datasource="#dsn#">
	SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
</cfquery>
<cfquery name="get_unv" datasource="#dsn#">
	SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
</cfquery>
<cfquery name="get_education_level" datasource="#dsn#">
  SELECT 	EDU_LEVEL_ID,EDU_TYPE, #DSN#.#dsn#.Get_Dynamic_Language(EDU_LEVEL_ID,'#session.ep.language#','SETUP_EDUCATION_LEVEL','EDUCATION_NAME',NULL,NULL,SETUP_EDUCATION_LEVEL.EDUCATION_NAME ) AS EDUCATION_NAME  FROM SETUP_EDUCATION_LEVEL
</cfquery>
<cfquery name="get_school_part" datasource="#dsn#">
	SELECT PART_ID, #dsn#.Get_Dynamic_Language(PART_ID,'#session.ep.language#','SETUP_SCHOOL_PART','PART_NAME',NULL,NULL,PART_NAME) AS PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
</cfquery>
<cfquery name="GET_LANGUAGES" datasource="#dsn#">
	SELECT LANGUAGE_ID,#dsn#.Get_Dynamic_Language(LANGUAGE_ID,'#session.ep.language#','SETUP_LANGUAGES','LANGUAGE_SET',NULL,NULL,LANGUAGE_SET) AS LANGUAGE_SET FROM SETUP_LANGUAGES ORDER BY LANGUAGE_SET
</cfquery>
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Eğitim Bilgisi Ekle',31555)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="emp_add_training" method="post" action="#request.self#?fuseaction=hr.popup_add_edu_info">
			<input name="ctrl_edu" id="ctrl_edu" type="hidden" value="<cfif isdefined("attributes.ctrl_edu") and len(attributes.ctrl_edu)><cfoutput>#attributes.ctrl_edu#</cfoutput></cfif>">
			<input name="count_edu" id="count_edu" type="hidden" value="<cfif isdefined("attributes.count_edu") and len(attributes.count_edu)><cfoutput>#attributes.count_edu#</cfoutput></cfif>">
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group require" id="item-process_stage">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31551.Okul_Turu'>*</label>
						<div class="col col-8 col-sm-12">
							<select name="edu_type" id="edu_type" onChange="degistir_okul(this.value);">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="get_education_level">
									<option value="#edu_level_id#;#edu_type#" <cfif isdefined("attributes.edu_type_new") and len(attributes.edu_type_new) and (edu_level_id eq attributes.edu_type_new)>selected</cfif>>#education_name#</option>
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
					<div class="form-group require" id="edu_id_tr" <cfif (isdefined("edu_type_control") and not listfind("2,3,4,5",edu_type_control))>style="display:none"<cfelse>style="display:"</cfif>>
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57709.Okul'>*</label>
						<div class="col col-8 col-sm-12">
							<select name="edu_id" id="edu_id" onChange="degistir_okul2()">
								<option value=""><cf_get_lang dictionary_id="31413.Üniversiteler"></option>
								<cfoutput query="get_unv">
								<option value="#school_id#" <cfif isdefined("attributes.edu_id_new") and len(attributes.edu_id_new) and school_id eq attributes.edu_id_new>selected</cfif>>#school_name#</option>	
								</cfoutput>
								<option value="-1" <cfif isdefined("attributes.edu_id_new") and len(attributes.edu_id_new) and -1 eq attributes.edu_id_new>selected</cfif>><cf_get_lang dictionary_id='58156.Diğer'></option>
							</select>
						</div>                
					</div> 
					<div class="form-group require" id="edu_name_tr" <cfif isdefined("attributes.edu_id_new") and attributes.edu_id_new eq -1 or (isdefined("edu_type_control") and listfind("1,0,2,3,4,5",edu_type_control))>style="display:"<cfelse>style="display:none"</cfif>>
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57709.Okul'>*</label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="edu_name" id="edu_name" value="<cfif isdefined("attributes.edu_name_new") and len(attributes.edu_name_new)><cfoutput>#attributes.edu_name_new#</cfoutput></cfif>" maxlength="75">
						</div>                
					</div> 
					<div class="form-group require" id="item-edu_start">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31556.Giriş Yılı'>*</label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfsavecontent variable="message_start"><cf_get_lang dictionary_id='31321.Okul Giriş yılı girmelisiniz'></cfsavecontent>
								<cfif isdefined("attributes.edu_start_new") and len(attributes.edu_start_new)>
									<cfinput type="text" name="edu_start" value="#dateformat(attributes.edu_start_new,dateformat_style)#" maxlength="10" message="#message_start#">
								<cfelse>
									<cfinput onKeyUp="isNumber(this);" type="text" name="edu_start" id="edu_start" maxlength="4" validate="integer" message="#message_start#" range="1900,">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="edu_start"></span>
							</div>                
						</div>                
					</div> 
					<div class="form-group require" id="item-edu_finish">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31050.Mezuniyet Yılı'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfsavecontent variable="message_finish"><cf_get_lang dictionary_id='31322.Okul Mezuniyet yılı girmelisiniz'></cfsavecontent>	
								<cfif isdefined("attributes.edu_finish_new") and len(attributes.edu_finish_new)>
									<cfinput type="text" name="edu_finish" id="edu_finish" value="#dateformat(attributes.edu_finish_new,dateformat_style)#" maxlength="10" message="#message_finish#">
								<cfelse>
									<cfinput onKeyUp="isNumber(this);" type="text" id="edu_finish" name="edu_finish" maxlength="4" validate="integer" message="#message_finish#" range="1900,">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="edu_finish"></span>
							</div>
						</div>       
					</div> 
					<div class="form-group require" id="item-edu_rank">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='31482.Not Ort'></label>
						<div class="col col-8 col-sm-12">
							<cfif isdefined("attributes.edu_rank_new") and len(attributes.edu_rank_new)>
								<cfinput type="text" name="edu_rank" id="edu_rank" maxlength="10" value="#attributes.edu_rank_new#" title="Mezuniye derecenizi araya '/' işareti koyarak kaç üzerinden olduğunu belirterek yazınız !">
							<cfelse>					
								<cfinput type="text" name="edu_rank" id="edu_rank" maxlength="10" value="" title="Mezuniye derecenizi araya '/' işareti koyarak kaç üzerinden olduğunu belirterek yazınız !" onkeyup="return(FormatCurrency(this,event));">
							</cfif>
						</div>                
					</div>
					<div class="form-group" id="item-edu_lang">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='41520.Öğrenim dili'></label>
						<div class="col col-8 col-sm-12">
							<select name="edu_lang" id="edu_lang">
								<option value="0"><cf_get_lang dictionary_id='58996.Dil'></option>
								<cfoutput query="get_languages">
									<option value="#LANGUAGE_ID#" <cfif isdefined("attributes.edu_lang_new") and len(attributes.edu_lang_new) and (LANGUAGE_ID eq attributes.edu_lang_new)>selected</cfif>>#language_set#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-edu_lang_rate">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='59616.Öğrenim dili'><cf_get_lang dictionary_id ='58671.Oranı'></label>
						<div class="col col-8 col-sm-12">
							<cfif isdefined("attributes.edu_lang_rate_new") and len(attributes.edu_lang_rate_new)>
								<cfinput type="text" id="edu_lang_rate" name="edu_lang_rate" value="#attributes.edu_lang_rate_new#">
							<cfelse>
								<cfinput type="text" id="edu_lang_rate" name="edu_lang_rate" value="">
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-education_time">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id = "41519.Öğrenim süresi"></label>
						<div class="col col-8 col-sm-12">
							<cfif isdefined("attributes.education_time_new") and len(attributes.education_time_new)>
								<cfinput type="text" id="education_time" name="education_time" value="#attributes.education_time_new#">
							<cfelse>
								<cfinput type="text" id="education_time" name="education_time" value="">
							</cfif>
						</div>
					</div>
					<div class="form-group require" id="part_id"<cfif isdefined("edu_type_control") and listfind('2,3,4,5',edu_type_control)>style="display:;"<cfelse>style="display:none"</cfif>>
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57995.Bölüm'> *</label>
						<div class="col col-8 col-sm-12">
							<select name="edu_part_id" id="edu_part_id" onChange="degistir_bolum2();">
								<option value=""><cf_get_lang dictionary_id='58139.Bölümler'></option>
								<cfoutput query="get_school_part">
									<option value="#part_id#" <cfif isdefined("attributes.edu_part_id_new") and len(attributes.edu_part_id_new) and part_id eq attributes.edu_part_id_new>selected</cfif>>#part_name#</option>	
								</cfoutput>
								<option value="-1" <cfif isdefined("attributes.edu_part_id_new") and len(attributes.edu_part_id_new) and -1 eq attributes.edu_part_id_new>selected</cfif>><cf_get_lang dictionary_id='58156.Diğer'></option>
							</select>
						</div>                
					</div> 
					<div class="form-group require" id="part_name" <cfif (isdefined("attributes.edu_part_name_new") and len(attributes.edu_part_name_new) and attributes.edu_part_name_new eq -1) or ((isdefined("attributes.edu_high_part_id_new") and attributes.edu_high_part_id_new eq -1) or (isdefined("attributes.edu_part_id_new") and attributes.edu_part_id_new eq -1))>style="display:;"<cfelse>style="display:none"</cfif>>
						<label class="col col-4 col-sm-12"></label>
						<div class="col col-8 col-sm-12">
							<input type="text" name="edu_part_name" id="edu_part_name" value="<cfif isdefined("attributes.edu_part_name_new") and len(attributes.edu_part_name_new)><cfoutput>#attributes.edu_part_name_new#</cfoutput></cfif>" maxlength="75">
						</div>                
					</div>
					
					<!--- <div class="form-group require" id="devam" <cfif isdefined("attributes.is_edu_continue_new") and len(attributes.is_edu_continue_new) and listfind('3,4,5,6',attributes.edu_type_new)>style="display:;"<cfelse>style="display:none"</cfif>>
						<label class="col col-12 col-sm-12"><cf_get_lang dictionary_id='31415.Hala Devam Ediyor'></label>
					</div>  --->
					<div class="form-group" id="item-is_edu_continue">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="31415.Hala Devam Ediyor"></label>
						<div class="col col-8 col-sm-12">
							<input type="checkbox" name="is_edu_continue" id="is_edu_continue" <cfif isdefined("attributes.is_edu_continue_new") and len(attributes.is_edu_continue_new) and attributes.is_edu_continue_new eq 1>checked</cfif>>
						</div>
					</div>
					<div class="form-group require" id="bolum_adi" <cfif (isdefined("edu_type_control") and listfind('1',edu_type_control))>style="display:;"<cfelse>style="display:none"</cfif>>
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57995.Bölüm'> *</label>
						<div class="col col-8 col-sm-12" id="high_part_id" <cfif isdefined("edu_type_control") and edu_type_control eq 1>style="display:;"<cfelse>style="display:none"</cfif>>
							<select name="edu_high_part_id" id="edu_high_part_id" onChange="degistir_bolum();">
								<option value=""><cf_get_lang dictionary_id="31483.Lise Bölümleri"></option>
								<cfoutput query="get_high_school_part">
									<option value="#high_part_id#" <cfif isdefined("attributes.edu_high_part_id_new") and len(attributes.edu_high_part_id_new) and high_part_id eq attributes.edu_high_part_id_new>selected</cfif>>#high_part_name#</option>	
								</cfoutput>
								<option value="-1" <cfif isdefined("attributes.edu_high_part_id_new") and len(attributes.edu_high_part_id_new) and -1 eq attributes.edu_high_part_id_new>selected</cfif>><cf_get_lang dictionary_id='58156.Diğer'></option>
							</select>
						</div>
					</div>
				</div>
			</cf_box_elements>
		</cfform>
		<cf_box_footer>
			<input type="button" value="<cfif isdefined("attributes.ctrl_edu") and len(attributes.ctrl_edu) and attributes.ctrl_edu eq 1><cf_get_lang dictionary_id ='57464.Güncelle'><cfelse><cf_get_lang dictionary_id ='57582.Ekle'></cfif>" onClick="gonder_training();">
		</cf_box_footer>
	</cf_box>
</div>
<script type="text/javascript">
if(( document.emp_add_training.edu_id.value == -1 )){
    document.getElementById('edu_name_tr').style.display = '';
}else{
    document.getElementById('edu_name_tr').style.display = 'none';
}
function degistir_okul(abc)
{        
	document.emp_add_training.edu_id.value = "";
	document.emp_add_training.edu_high_part_id.value = "";
	document.emp_add_training.edu_part_name.value = "";
	var edu_type = abc.split(';')[1];
	if((edu_type ==0)){
		document.getElementById('edu_name_tr').style.display = '';
		document.getElementById('high_part_id').style.display = 'none';
		document.getElementById('edu_id_tr').style.display='none';
		document.getElementById('edu_lang').style.display = 'none';
		document.getElementById('edu_lang_rate').style.display = 'none';
		document.getElementById('education_time').style.display = 'none';
		document.getElementById('part_id').style.display='none';
		document.getElementById('bolum_adi').style.display='none';
	}
	else if((edu_type ==1))
	{
		document.getElementById('edu_name_tr').style.display = '';
		document.getElementById('high_part_id').style.display = '';
		document.getElementById('edu_lang').style.display = '';
		document.getElementById('edu_lang_rate').style.display = '';
		document.getElementById('edu_id_tr').style.display='none';
		document.getElementById('part_id').style.display='none';
		document.getElementById('bolum_adi').style.display='';
	}
	else
	{
		document.getElementById('edu_name_tr').style.display = 'none';
		document.getElementById('high_part_id').style.display = 'none';
		document.getElementById('edu_lang').style.display = '';
		document.getElementById('edu_lang_rate').style.display = '';
		document.getElementById('edu_id_tr').style.display='';
		document.getElementById('part_id').style.display='';
		document.getElementById('bolum_adi').style.display='none';
	}
	
}

function degistir_okul2()
	{	
		if(document.getElementById('edu_id').value == -1)
			{
				document.getElementById('edu_name_tr').style.display = '';
				document.getElementById('edu_id').style.display = '';
				document.getElementById('edu_name').value = '';
			}
		else if(document.getElementById('edu_id').value != -1)
			{
				document.getElementById('edu_name_tr').style.display = 'none';
				document.getElementById('edu_name').value = '';
			}
	}
function degistir_bolum()
	{
		if(document.getElementById('edu_high_part_id').value == -1)
			{
				document.getElementById('part_name').style.display = '';
				document.getElementById('high_part_id').style.display = '';
				document.getElementById('bolum_adi').style.display = '';
				document.getElementById('edu_part_name').value = '';
			}
		else if(document.getElementById('edu_high_part_id').value != -1)
			{
				document.getElementById('part_name').style.display = 'none';
				document.getElementById('edu_part_name').value = '';
			}
	}
		
function degistir_bolum2()
	{
		if(document.getElementById('edu_part_id').value == -1)
			
			{
				document.getElementById('part_name').style.display = '';
				document.getElementById('part_id').style.display = '';
				document.getElementById('bolum_adi').style.display = '';
				document.getElementById('edu_part_name').value = '';
			}
		else if(document.getElementById('edu_part_id').value != -1)
			{
				document.getElementById('part_name').style.display = 'none';
				document.getElementById('edu_part_name').value = $("#edu_part_id option:selected").text();
			}
	}
function control()
	{
		if (!$('#is_edu_continue').is(':checked')){
			if(!date_check(document.getElementById("edu_start"), document.getElementById("edu_finish"), "<cf_get_lang dictionary_id='31559.Okul Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
		}
		
		if (emp_add_training.edu_type.value=="")
		{
			alert("<cf_get_lang dictionary_id='56498.Okul Türü Seçmelisiniz'>!");
			return false;
		}
		
		if (emp_add_training.edu_id.value=="" && emp_add_training.edu_name.value=="")
		{
			alert("<cf_get_lang dictionary_id='56499.Okul Adı Girmelisiniz'>!");
			return false;
		}
		else if(emp_add_training.edu_id.value==-1 && trim(emp_add_training.edu_name.value)=="")
		{
			alert("<cf_get_lang dictionary_id='56500.Okulunuzun Adını Yazınız'>!");
			return false;
		}		
		if(emp_add_training.edu_type.value == 3)
		{
			if (emp_add_training.edu_high_part_id.value=="" && emp_add_training.edu_part_name.value=="")
			{
				alert("<cf_get_lang dictionary_id='56501.Bölüm Adı Seçmek Zorunludur'>!");
				return false;
			}
			else if(emp_add_training.edu_high_part_id.value==-1 && trim(emp_add_training.edu_part_name.value)=="")
			{
				alert("<cf_get_lang dictionary_id='56502.Bölüm Adı Lise Bölümleri Listesinde Yoksa Bu alana Yazmalısınız'>!");
				return false;
			}
		}
		
		if(emp_add_training.edu_type.value[0] == 3 || emp_add_training.edu_type.value[0] == 4 || emp_add_training.edu_type.value[0] == 5)
		{
			if (emp_add_training.edu_part_id.value=="" && emp_add_training.edu_part_name.value=="")
			{
				alert("<cf_get_lang dictionary_id='56501.Bölüm Adı Seçmek Zorunludur'>!");
				return false;
			}
			else if(emp_add_training.edu_part_id.value==-1 && trim(emp_add_training.edu_part_name.value)=="")
			{
				alert("<cf_get_lang dictionary_id='56503.Bölüm Adı Listede Yoksa Bu alana Yazmalısınız'>!");
				return false;
			}
		}
		if(emp_add_training.edu_type.value == 6)
		{
			if(emp_add_training.edu_part_name.value=="")
			{
				alert("<cf_get_lang dictionary_id='56504.Bölüm Adı Yazmalısınız'>!");
				return false;
			}
		}
		return true;
	}
    function gonder_training()
    {
        if(control()==true)
        {
            var ctrl_edu = document.getElementById('ctrl_edu').value;
            var count_edu = document.getElementById('count_edu').value;
            var edu_type = document.getElementById('edu_type').value;
            var edu_part_id = document.getElementById('edu_part_id').value;
            var edu_part_name_ = document.getElementById('edu_part_name').value;
            var edu_name_ = document.getElementById('edu_name').value;
            var education_time_ =  document.getElementById('education_time').value;
            var edu_lang_ = document.getElementById('edu_lang').value;
            var edu_lang_rate_ = document.getElementById('edu_lang_rate').value;

        if($('#is_edu_continue').is(":checked"))
            is_edu_continue = 1;
        else
            is_edu_continue= 0;

            <cfif not isdefined("attributes.draggable")>window.opener.</cfif>gonder_edu(edu_type,ctrl_edu,count_edu,document.getElementById('edu_id').value,edu_name_,document.getElementById('edu_start').value,document.getElementById('edu_finish').value,document.getElementById('edu_rank').value,document.getElementById('edu_high_part_id').value,edu_part_id,edu_part_name_,education_time_,edu_lang_,edu_lang_rate_,is_edu_continue);//,document.emp_add_training.edu_part_name.value
            <cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
        }
        else
        {
            return false;
        }
    }
</script>