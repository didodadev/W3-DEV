<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career_partner")>
<cfset get_emps_pars_cons = get_components.get_emps_pars_cons()>

<cfset start_ = dateformat(now(),'dd/mm/yyyy')>
<cfset finish_ = date_add('d',15,start_)>

<cfform name="add_notice" method="post" enctype="multipart/form-data">
<table align="center" cellpadding="2" cellspacing="1" border="0" class="color-border" style="width:100%; height:100%;">
  	<tr> 
		<td class="color-row"> 
	  		<table>
	 	 		<tr>
                    <td style="width:110px;"><cf_get_lang dictionary_id='35098.Job Posting No.'>*</td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='35099.Please Enter Job Posting No.'> !</cfsavecontent>
                        <cfinput type="text" name="notice_no" style="width:100px;" required="yes" value="" message="#message#">
                        &nbsp;&nbsp;<cf_get_lang_main no='81.Aktif'><input type="checkbox" name="status" id="status" value="1" checked>
                    </td>
                    <td style="width:100px;"><cf_get_lang_main no='70.Aşama'></td>
                    <td>
                        <select name="status_notice" id="status_notice" style="width:165px;">
                            <option value="-1"><cf_get_lang dictionary_id='35100.Preparation'></option>
                            <option value="-2"><cf_get_lang dictionary_id='29479.Publication'></option>
                        </select>
                    </td>
                </tr>
                <tr> 
                    <td><cf_get_lang dictionary_id='31477.Advert Title'>*</td>
                    <td colspan="3">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Please Enter Title'>!</cfsavecontent>
                        <cfinput type="text" name="notice_head" style="width:500px;" maxlength="100" required="yes" message="#message#">
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id='31343.Number of Positions'></td>
                    <td><cfinput type="text" name="staff_count" id="staff_count" value="" validate="integer" style="width:150px;" maxlength="2" message="Kadro Sayısını Giriniz!"></td>
                    <td><cf_get_lang_main no='1085.Poziyon'></td>
                    <td><input type="text" name="app_position" id="app_position" style="width:165px;" value=""></td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id='31268.Contact Person'></td>
                    <td>                        
                        <select name="interview_par" id="interview_par" style="width:150px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                            <cfoutput query="get_emps_pars_cons">
								<cfif type eq 3>
                                	<option value="#uye_id#,#comp_id#,#type#">#nickname# - #uye_name# #uye_surname#</option>
                                </cfif>
                            </cfoutput>
                        </select>
                    </td>
                    <td><cf_get_lang dictionary_id='30920.Will be approved by'></td>
                    <td>
                        <select name="validator_par" id="validator_par" style="width:165px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                            <cfoutput query="get_emps_pars_cons">
								<cfif type eq 3>
                                	<option value="#uye_id#,#comp_id#,#type#">#nickname# - #uye_name# #uye_surname#</option>
                                </cfif>
                            </cfoutput>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id='50575.Yayın Başlangıç'></td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='62536.Başlangıç Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="startdate" id="startdate" validate="eurodate" value="#start_#" maxlength="10" message="#message#" style="width:130px;">
                        <cf_wrk_date_image date_field="startdate">
                    </td>
                    <td rowspan="4" style="vertical-align:top;"><cf_get_lang dictionary_id='35106.Provinces to Work'></td>
                    <td rowspan="4" style="vertical-align:top;">
                        <cfquery name="get_city" datasource="#dsn#">
                        	SELECT CITY_ID, CITY_NAME, COUNTRY_ID FROM SETUP_CITY ORDER BY CITY_NAME
                        </cfquery>
                        <select name="city" id="city" style="width:165px;height:75px;" multiple>
                            <option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
                            <option value="0"><cf_get_lang dictionary_id='31704.All of Turkey'></option>
                            <cfoutput query="get_city">
                            	<option value="#city_id#">#city_name#</option>
                            </cfoutput>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id='35108.Yayın Bitiş'></td>
                    <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='30753.Please Enter an End'></cfsavecontent>
                    <cfinput type="text" name="finishdate" id="finishdate" style="width:130px;" value="#dateformat(finish_,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#">
                    <cf_wrk_date_image date_field="finishdate">
                    </td>
                </tr>
                <tr> 
                    <td><cf_get_lang_main no='1225.Logo'></td>
                    <td>
                        <input type="checkbox" name="view_logo" id="view_logo" value="1">&nbsp;(<cf_get_lang dictionary_id='35110.Display'>) -
                        <cf_get_lang_main no='162.Şirket'>&nbsp;
                        <input type="checkbox" name="view_company_name" id="view_company_name" value="1"> (<cf_get_lang dictionary_id='35110.Display'>)
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id='35111.Görsel İlan'></td>
                    <td>
                        <input type="file" name="visual_notice" id="visual_notice" style="width:150px;">
                        <input type="checkbox" name="view_visual_notice" id="view_visual_notice" value="1">(<cf_get_lang dictionary_id='35110.Display'>)
                    </td>
                </tr>
                <tr> 
                    <td style="vertical-align:top;"><cf_get_lang dictionary_id='31641.İşin Tanımı'></td>
                    <td colspan="3">
                    	<textarea name="work_detail" id="work_detail" style="width:500px;height:80px;"><cfif isdefined("get_per_req.personel_detail") and len(get_per_req.personel_detail)><cfoutput>#get_per_req.personel_detail#</cfoutput></cfif></textarea>
                    </td>
                </tr>
            </table>
            <table>
                <tr> 
                    <td style="vertical-align:top; width:105px;"><cf_get_lang dictionary_id='36199.Açıklama'></td>
                    <td colspan="3">
                  		<cfmodule template="/fckeditor/fckeditor.cfm"
                            toolbarset="Basic"
                            basepath="/fckeditor/"
                            instancename="detail"
                            valign="top"
                            value=""
                            width="490"
                            height="300">    
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td style="text-align:right;" colspan="3">
                        <!--- <cf_workcube_buttons is_upd='0' add_function='kontrol()'>&nbsp;&nbsp;&nbsp;&nbsp; --->
                        <cf_workcube_buttons is_insert='1'	data_action="/V16/objects2/career/cfc/data_career_partner:add_notice" next_page="/#attributes.update_path_url#?notice_id=" add_function='kontrol()'>                    
                    </td><!--- OnFormSubmit() &&  --->
                </tr>
            </table>
        </td>
 	</tr>
</table>
</cfform>

<script type="text/javascript">
	function kontrol()
	{
		if ((document.getElementById('startdate').value != "") && (document.getElementById('finishdate').value != ""))
			if (!date_check(add_notice.startdate, add_notice.finishdate, "<cf_get_lang dictionary_id='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")) 
			{
				document.getElementById('startdate').focus();
				return false;
			}
		
		if ((document.getElementById('work_detail').value.length)>1000)
		{
			alert("<cf_get_lang dictionary_id='56207.İş Tanımı 1000 Karakterden Fazla Olamaz'>!");
			return false;
		}
		return true;
	}
</script>