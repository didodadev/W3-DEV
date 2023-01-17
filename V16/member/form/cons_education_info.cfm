<script type="text/javascript">
function isSayi(nesne) 
{
	var inputStr=nesne.value;
	if(inputStr.length>0)
	{
		for(var i=0;i<inputStr.length;i++)
		{
			var oneChar = inputStr.substring(i,i+1);
			if (oneChar < "0" || oneChar > "9") 
			{
				nesne.value=inputStr.substring(0,i);
				return false;
			}
		}
	}
}

function connectAjax()
{
	var bb = "<cfoutput>#request.self#?fuseaction=member.add_popup_education_info</cfoutput>";
	AjaxPageLoad(bb,'ADD_EDUCATIONS');
}
</script>
<cfquery name="GET_UNV" datasource="#DSN#">
	SELECT SCHOOL_ID,SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME ASC
</cfquery>
<cfquery name="GET_CONS_EDUCATION" datasource="#DSN#">
	SELECT TOP 1 * FROM CONSUMER_EDUCATION_INFO WHERE CONS_ID = #attributes.consumer_id#
</cfquery>
<cfquery name="get_school_part" datasource="#dsn#">
	SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
</cfquery>
<cf_box title="#getLang('','Eğitim Bilgileri','30644')#" popup_box="1">
	<cfform name="consumer_education" method="post" action="#request.self#?fuseaction=member.emptypopup_cons_add_education_info&consumer_id=#attributes.consumer_id#">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="110"></th>
					<th class="txtbold"><cf_get_lang dictionary_id='30645.Okul Adı'></th>
					<th class="txtbold"><cf_get_lang dictionary_id='57554.Giriş'></th>
					<th class="txtbold"><cf_get_lang dictionary_id='30646.Mezuniyet'></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><cf_get_lang dictionary_id ='30647.İlköğretim'></td>
					<td><input type="text" name="edu1" id="edu1" style="width:190px;" maxlength="75" value="<cfoutput>#get_cons_education.edu1#</cfoutput>"></td>
					<td><input type="text" name="edu1_start" id="edu1_start" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu1_start#</cfoutput>" validate="integer" onkeyup="isNumber(this);" onblur="isNumber(this)"></td>
					<td><input type="text" name="edu1_finish" id="edu1_finish" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu1_finish#</cfoutput>" validate="integer" onkeyup="isNumber(this);" onblur="isNumber(this)"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id ='30479.Ortaokul'></td>
					<td><input type="text" name="edu2" id="edu2" style="width:190px;" maxlength="75" value="<cfoutput>#get_cons_education.edu2#</cfoutput>"></td>
					<td><input type="text" name="edu2_start" id="edu2_start" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu2_start#</cfoutput>" validate="integer" onkeyup="isNumber(this);" onblur="isNumber(this)"></td>
					<td><input type="text" name="edu2_finish" id="edu2_finish" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu2_finish#</cfoutput>" validate="integer" onkeyup="isNumber(this);" onblur="isNumber(this)"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id ='30480.Lise'></td>
					<td><input type="text" name="edu3" id="edu3" style="width:190px;" maxlength="75" value="<cfoutput>#get_cons_education.edu3#</cfoutput>"></td>
					<td><input type="text" name="edu3_start" id="edu3_start" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu3_start#</cfoutput>" validate="integer" onkeyup="isNumber(this);" onblur="isNumber(this)"></td>
					<td><input type="text" name="edu3_finish" id="edu3_finish" style="width:40px;" maxlength="4"  value="<cfoutput>#get_cons_education.edu3_finish#</cfoutput>"validate="integer" onkeyup="isNumber(this);" onblur="isNumber(this)"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id ='29755.Üniversite'></td>
					<td>
						<div class="form-group">
							<select name="edu4_id" id="edu4_id" onchange="bolum_getir();">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_unv">
									<option value="#get_unv.school_id#"<cfif get_unv.school_id eq get_cons_education.edu4_id>selected="selected"</cfif>>#get_unv.school_name#</option>	
								</cfoutput>
							</select>
						</div>
					</td>
					<td><input type="text" name="edu4_start" id="edu4_start" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu4_start#</cfoutput>" validate="integer" onkeyup="isNumber(this);" onblur="isNumber(this)"></td>
					<td nowrap="nowrap"><input type="text" name="edu4_finish" id="edu4_finish" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu4_finish#</cfoutput>" validate="integer" onkeyup="isNumber(this);" onblur="isNumber(this)"></td>
				</tr>
				<tr id="school_parts_div" style="display:none;">
					<td><cf_get_lang dictionary_id='58139.Bölümler'></td>
					<td colspan="4">
						<div class="form-group">
							<select name="edu_part_id" id="edu_part_id" style="width:190px;">
								<option value=""><cf_get_lang dictionary_id='58139.Bölümler'></option>
								<cfoutput query="get_school_part">
									<option value="#part_id#" <cfif get_cons_education.EDU4_PART_ID eq part_id >selected</cfif>>#part_name#</option>	
								</cfoutput>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id ='30483.Yüksek Lisans'></td>
					<td><input type="text" name="edu5" id="edu5" style="width:190px;" maxlength="75" value="<cfoutput>#get_cons_education.edu5#</cfoutput>"></td>
					<td><input type="text" name="edu5_start" id="edu5_start" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu5_start#</cfoutput>" validate="integer" onkeyup="isNumber(this);" onblur="isNumber(this)"></td>
					<td><input type="text" name="edu5_finish" id="edu5_finish" style="width:40px;" maxlength="4" value="<cfoutput>#get_cons_education.edu5_finish#</cfoutput>" validate="integer" onkeyup="isNumber(this);" onblur="isNumber(this)"></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='58156.Diğer'> <cf_get_lang dictionary_id ='29755.Üniversite'></td>
					<td colspan="4"><input type="text" name="edu4" id="edu4" style="width:190px;" maxlength="75" value="<cfoutput>#get_cons_education.edu4#</cfoutput>"></td>
				</tr>
			</tbody>
		</cf_grid_list>
		<cf_box_footer><cf_workcube_buttons type_format='1' is_add='1' is_delete='0' add_function=''></cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
if(document.getElementById("edu4_id").value)
{
document.getElementById('school_parts_div').style.display = '';
}
function bolum_getir()
{
	document.getElementById('school_parts_div').style.display = '';
	}
function edu_control(show_detail)
{
	var GET_UNV=wrk_safe_query("mr_get_unv","dsn",0,title);
	
   	if(GET_UNV.recordcount){
	   alert("<cf_get_lang dictionary_id='30273.Kayıtlı olan üniversite adı girdiniz'>");
	   return false;
	}
	else
	{
	 	alert("<cf_get_lang dictionary_id='58890.kaydedildi.'>");
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_add_school&is_js_func=1&title='+title+'&title_detail='+document.getElementById('title_detail').value+'','show_detail_edu','1','Kaydediliyor....');
		gizle(_UNV_,show_detail);
	}	
}
</script>
