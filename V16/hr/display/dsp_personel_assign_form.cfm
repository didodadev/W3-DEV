<!--- Atama Formu --->
<cfoutput>
<input type="hidden" name="x_display_page_detail" id="x_display_page_detail" value="#x_display_page_detail#"><!--- Xml ile gelen parametreye gore queryde guncelleme islemi yapmayacagiz FBS 20110411 --->
<input type="hidden" name="personel_assign_head" id="personel_assign_head" value="#get_per_req.personel_assign_head#">
<table>
	<tr>
		<td height="20" >Personel Talebissss</td>
		<td height="20" ><cfif Len(get_per_req.personel_req_id) and get_relation_requirement.recordcount and ListFind(ValueList(get_req.personel_requirement_id),get_per_req.personel_req_id)>#get_relation_requirement.personel_requirement_head# - #get_relation_requirement.personel_requirement_head#</cfif></td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id='58820.Başlık'>*</td>
		<td height="20" >#get_per_req.personel_assign_head#</td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id='57574.Şirket'> - <cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Departman'>*</td>
		<td height="20" ><cfif len(get_per_req.our_company_id)>#get_department_info.nick_name#</cfif> -
			<cfif isdefined('get_department_info.branch_name')>#get_department_info.branch_name#</cfif> -
			<cfif isdefined('get_department_info.department_head')>#get_department_info.department_head#</cfif>
		</td>
	</tr>
	<tr>
		<td height="20"  width="200"><cf_get_lang dictionary_id="57570.Ad Soyad"></td>
		<td height="20" >#get_per_req.personel_name#	#get_per_req.personel_surname#</td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="58025.TC Kimlik No"></td>
		<td height="20" >#get_per_req.personel_tc_identy_no#</td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="55280.Birim ve Görev"> *</td>
		<td height="20" >#position_cat#</td>
	</tr>
	<cfif ListLen(x_show_warning_process)>
		<tr>
			<td height="20" >&nbsp;</td>
			<td height="20" ><label id="process_detail_control_td" class="table_warning"><cfoutput>#Detail_#</cfoutput></label></td>
		</tr>
	</cfif>
	<tr>
		<td height="20"  colspan="2">&nbsp;</td>
	</tr>
</table>
<cf_seperator id="kisi_" title="#getLang('hr',1788)#"><!---KİŞİ ÖZELLİKLERİ--->
<table id="kisi_">
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
		<td height="20" ><cfif len(get_per_req.birth_date)>#dateformat(get_per_req.birth_date,dateformat_style)#</cfif>
		</td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="55309.Bu Alandaki İş Tecrübesi (Yıl)"></td>
		<td height="20" >#get_per_req.PERSONEL_ATTEMPT#</td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="57764.Cinsiyet"></td>
		<td height="20" ><cfif get_per_req.sex eq 0><cf_get_lang dictionary_id="58958.Kadın"><cfelse><cf_get_lang dictionary_id="58959.Erkek"></cfif></td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="35141.Askerlik Durumu"></td>
		<td height="20" ><cfif get_per_req.military_status eq 0><cf_get_lang dictionary_id='55624.Yapmadı'></cfif>
			<cfif get_per_req.military_status eq 1><cf_get_lang dictionary_id='55625.Yaptı'></cfif>
			<cfif get_per_req.military_status eq 2><cf_get_lang dictionary_id='55626.Muaf'></cfif>
			<cfif get_per_req.military_status eq 3><cf_get_lang dictionary_id='55627.Yabancı'></cfif>
			<cfif get_per_req.military_status eq 4><cf_get_lang dictionary_id='55340.Tecilli'></cfif>
		</td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="33568.Askerlik Durumu Açıklama"></td>
		<td height="20" >#get_per_req.military_detail#</td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="30237.Eğitim Durumu"></td>
		<td height="20" ><cfloop query="GET_EDU_LEVEL">
				<cfif EDU_LEVEL_ID eq get_per_req.TRAINING_LEVEL>#GET_EDU_LEVEL.EDUCATION_NAME#</cfif>
			</cfloop>
		</td>
	</tr>
	
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="31200.Ehliyet"></td>
		<td height="20" ><cfquery name="DRIVERLICENCECATEGORIES" datasource="#dsn#">
				SELECT 
                	LICENCECAT_ID, 
                    LICENCECAT, 
                    RECORD_EMP, 
                    RECORD_IP, 
                    RECORD_DATE, 
                    UPDATE_EMP, 
                    UPDATE_IP, 
                    UPDATE_DATE, 
                    IS_LAST_YEAR_CONTROL, 
                    USAGE_YEAR 
                FROM 
                	SETUP_DRIVERLICENCE 
                ORDER BY 
                	LICENCECAT
			</cfquery>
			<cfloop query="DRIVERLICENCECATEGORIES">
				<cfif len(get_per_req.LICENCECAT_ID) and listfindnocase(get_per_req.LICENCECAT_ID,LICENCECAT_ID)>#LICENCECAT#,</cfif>
			</cfloop>
		</td>
	</tr>
	<cfif x_show_psychotechnics_info eq 1>
		<tr>
			<td height="20" ><cf_get_lang dictionary_id="55136.Psikoteknik"></td>
			<td height="20" ><cfif get_per_req.is_psychotechnics eq 0>Hayır<cfelse><cf_get_lang dictionary_id="57495.Evet"></cfif></td>
		</tr>
	</cfif>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="55764.Aynı Depoda Çalışan Yakını Var mı"></td>
		<td height="20" ><cfif get_per_req.relative_status eq 0>Hayır<cfelse><cf_get_lang dictionary_id="57495.Evet"></cfif></td>
	</tr>
	<cfif get_per_req.relative_status eq 1>
		<tr>
			<td height="20" ><cf_get_lang dictionary_id="55766.Var İse Yakınlığı"></td>
			<td height="20" >#get_per_req.relative_detail#</td>
		</tr>
	</cfif>
	<tr>
		<td height="20"  colspan="2" class="formbold" height="30"><cf_get_lang dictionary_id="55771.Belirsiz Süreli Çalışan ise"></td>
	</tr>
	<tr>
		<td height="20"><cf_get_lang dictionary_id="55538.Çalışma Başlangıç"></td>
		<td height="20" ><cfif len(get_per_req.work_start)>#dateformat(get_per_req.work_start,dateformat_style)#</cfif></td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="55555.Çalışma Bitiş"></td>
		<td height="20" ><cfif len(get_per_req.work_finish)>#dateformat(get_per_req.work_finish,dateformat_style)#</cfif></td>
	</tr>
</table>
<cf_seperator id="nakil" title="<cf_get_lang dictionary_id='55772.Nakil Yoluyla Atama Yapılıyorsa veya Eski Çalışanımızsa Son İşyerine Ait'>">
<table id="nakil">
	<tr>
		<td height="20" ><cf_get_lang dictionary_id='57574.Şirket'> - <cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Departman'>*</td>
		<td height="20" ><cfif len(get_per_req.old_OUR_COMPANY_ID)>#get_old_department_info.nick_name#</cfif> -
			<cfif isdefined('get_old_department_info.branch_name')>#get_old_department_info.branch_name#</cfif>	-
			<cfif isdefined('get_old_department_info.department_head')>#get_old_department_info.department_head#</cfif>
		</td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="49674.Görev"></td>
		<td height="20" >#get_per_req.old_position_name#</td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="35087.Ayrılma Nedeni"></td>
		<td height="20" ><cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'İstifa')><cf_get_lang dictionary_id="55508.İstifa"></cfif>
			<cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'Fesih')><cf_get_lang dictionary_id="55509.Fesih"></cfif>
			<cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'Nakil')><cf_get_lang dictionary_id="40516.Nakil"></cfif>
			<cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'Diğer')><cf_get_lang dictionary_id="58156.Diğer"></cfif>
			<cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'Diğer') and listlen(get_per_req.old_finish_detail) eq 2>#listgetat(get_per_req.old_finish_detail,2)#</cfif>
		</td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="55538.Çalışma Başlangıç"></td>
		<td height="20" ><cfif len(get_per_req.old_work_start)>#dateformat(get_per_req.old_work_start,dateformat_style)#</cfif></td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="55555.Çalışma Bitiş"></td>
		<td height="20" ><cfif len(get_per_req.old_work_finish)>#dateformat(get_per_req.old_work_finish,dateformat_style)#</cfif></td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="55171.Eski Ücret"></td>
		<td height="20" >#tlformat(get_per_req.old_salary)# <cfif Len(get_per_req.old_salary)>#get_per_req.old_salary_money#</cfif></td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="55774.Brüt Ücret"></td>
		<td height="20" >#tlformat(get_per_req.salary)# <cfif Len(get_per_req.salary)>#get_per_req.salary_money#</cfif></td>
	</tr>
	<tr>
		<td height="20" >&nbsp;</td>
		<td height="20" >#get_per_req.assign_properties#</td>
	</tr>
</table>
<cf_seperator id="gorus_" title="<cf_get_lang dictionary_id='55571.Görüş Ve Onay'>">
<table id="gorus_">
	<tr>
		<td height="20"  valign="top"><cf_get_lang dictionary_id="31406.Görüş"> *</td>
		<td height="20" ><textarea name="personel_assign_detail" id="personel_assign_detail" style="width:505px;height:40px;" onKeyUp="CheckLen(this,500);"></textarea></td>
	</tr>
	<tr>
		<td height="20" ><cf_get_lang dictionary_id="55179.Atama Durumu"></td>
		<td height="20" ><cf_workcube_process is_upd='0' select_value='#get_per_req.per_assign_stage#' process_cat_width='150' is_detail='1'></td>
	</tr>
</table>
<cf_form_box_footer>
	<cf_record_info query_name="get_per_req">
	<cfif len(get_per_req.is_finished)>
        <font color="red"><cf_get_lang dictionary_id="55182.Talebin Süreci Tamamlanmıştır">.</font>
    <cfelse>
        <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_personel_assign_form&per_assign_id=#attributes.per_assign_id#&cat=#get_per_req.per_assign_stage#&head=#get_per_req.PERSONEL_assign_HEAD#' add_function='kontrol()'>
    </cfif>
</cf_form_box_footer>
</cfoutput>
