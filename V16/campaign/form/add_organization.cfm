<cf_xml_page_edit fuseact="campaign.add_organization" is_multi_page="1">
<cfquery name="get_site_menu" datasource="#DSN#">
	SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE IS_ACTIVE = 1 AND SITE_DOMAIN IS NOT NULL
</cfquery>
<cfquery name="FIND_DEPARTMENT_BRANCH" datasource="#DSN#">
	SELECT
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH
	WHERE
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
 <cf_catalystHeader>
<cfform name="add_organization" method="post" action="#request.self#?fuseaction=campaign.emptypopup_add_organization">
	<cfif isdefined("attributes.prj_id")>
		<cfquery name="GET_PROJECT" datasource="#DSN#">
			SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.prj_id#
		</cfquery>
		<input type="hidden" name="caller_project_id" id="caller_project_id" value="<cfoutput>#attributes.prj_id#</cfoutput>" />
	</cfif>	
	<cfif isdefined("attributes.camp_id")><input type="hidden" name="caller_campaign_id" id="caller_campaign_id" value="<cfoutput>#attributes.camp_id#</cfoutput>" /></cfif>
	<input type="hidden" name="xml_project_date_control" id="xml_project_date_control" value="<cfoutput>#xml_project_date_control#</cfoutput>">
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cf_tab defaultOpen="sayfa_1" divId="sayfa_1,sayfa_2" divLang="#getLang('','Etkinlik İçeriği','49341')#;#getLang('','Etkinlik Bilgileri','51624')#">
                <div id="unique_sayfa_2" class="ui-info-text uniqueBox">
                    <cf_box_elements vertical="1">
                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-is_active">
                                <label><input type="checkbox" name="online" id="online" value="1" onclick="gizle_goster(url_organization_);"><cf_get_lang dictionary_id='30015.online'></label>
                                <label><input type="checkbox" name="is_active" id="is_active" value="1" checked="checked"><cf_get_lang dictionary_id='57493.Aktif'></label>
                                <label><input type="checkbox" name="int_or_ext" id="int_or_ext" value="1"><cf_get_lang dictionary_id='58562.Dış'><cf_get_lang dictionary_id='29465.Etkinlik'> </label>
                                <label><input type="checkbox" name="is_net_display" id="is_net_display" value="1" onClick="gizle_goster(is_site_display);"><cf_get_lang dictionary_id='47667.İnternette Gözüksün'></label>
                                <label><input type="Checkbox" name="view_to_all" id="view_to_all" value="1" onClick="view_control(1);"><cf_get_lang dictionary_id='49348.Bu Olayı Herkes Görsün'></label>
                                <label><input type="checkbox" name="is_view_branch" id="is_view_branch" value="#find_department_branch.branch_id#" onClick="view_control(2);"><cf_get_lang dictionary_id='57914.Şubemdeki Herkes Görsün'></label>
                                <input type="hidden" name="is_view_branch_" id="is_view_branch_" value="#find_department_branch.branch_id#"> 
                                <label><input type="checkbox" name="is_view_department" id="is_view_department" value="#find_department_branch.department_id#" onClick="view_control(3);"><cf_get_lang dictionary_id='57915.Departmanımdaki Herkes Görsün'></label>
                            </div>
                            <div class="form-group scrollContent scroll-x2" id="is_site_display" style="display:none;"> 
                                <label class="col col-12 col-xs-12 formbold"><cf_get_lang dictionary_id='49342.Yayınlanacak Site'></label> 
                                <cfoutput query="get_site_menu">
                                    <div class="col col-12 col-xs-12">
                                        <input name="menu_#menu_id#" id="menu_#menu_id#" type="checkbox" value="#menu_id#">#site_domain#
                                    </div>
                                </cfoutput> 
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="url_organization_" style="display:none;">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29761.url'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="url_organization" id="url_organization" value="">
                                </div>
                            </div>
                            <div class="form-group" id="item-organization_cat_id"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.kategori'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_combo 
                                            query_name="GET_ORGANIZATION_CAT" 
                                            name="organization_cat_id" 
                                            option_value="organization_cat_id" 
                                            option_name="organization_cat_name"
                                            width=275>
                                </div>
                            </div>
                            <div class="form-group" id="item-organization_head"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51770.Etkinlik Adı'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.başlık'></cfsavecontent>
                                    <cfinput type="text" name="organization_head" required="Yes" maxlength="100" message="#message#">
                                </div>
                            </div>
                            <div class="form-group" id="item-form_ul_process_stage">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0'>
                                </div>
                            </div>
                            <div class="form-group" id="item-company_name"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49714.Etkinlik Yetkilisi'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="emp_id" id="emp_id" value="">
                                        <input type="hidden" name="par_id" id="par_id" value="">
                                        <input type="hidden" name="cons_id" id="cons_id" value=""> 
                                        <input type="hidden" name="member_type" id="member_type" value="">
                                        <input type="text" name="company_name" id="company_name" value="" readonly>
                                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_organization.emp_id&field_name=add_organization.company_name&field_comp_name=add_organization.company_name&field_type=add_organization.member_type&field_partner=add_organization.par_id&field_consumer=add_organization.cons_id&select_list=1<cfif get_module_user(4)>,2,8</cfif></cfoutput>');" title="<cf_get_lang dictionary_id='49714.Etkinlik Yetkilisi'>"></span>
                                    </div>
                                </div>
                            </div>
                            <!--- <div class="form-group" id="item-emp_par_name"> 
                                <label class="col col-4 col-xs-12"></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="emp_par_name" id="emp_par_name" value="" readonly>
                                </div>
                            </div> --->
                            <div class="form-group" id="item-start_date"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.başlama'> *</label>
                                    <div class="col col-4 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"> <cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='58053.başlangıç tarihi'></cfsavecontent>
                                            <cfinput type="text" name="start_date" id="start_date" value="" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-xs-12"> 
                                        <cf_wrkTimeFormat name="event_start_clock" value="0">
                                    </div>
                                    <div class="col col-2 col-xs-12">  
                                        <select name="event_start_minute" id="event_start_minute">
                                            <option value="00" selected>00</option>
                                            <option value="05">05</option>
                                            <option value="10">10</option>
                                            <option value="15">15</option>
                                            <option value="20">20</option>
                                            <option value="25">25</option>
                                            <option value="30">30</option>
                                            <option value="35">35</option>
                                            <option value="40">40</option>
                                            <option value="45">45</option>
                                            <option value="50">50</option>
                                            <option value="55">55</option>
                                        </select>
                                    </div>
                            </div>                      
                            <div class="form-group" id="item-finish_date"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.bitis'> *</label>
                                <div class="col col-4 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.bitis tarihi'></cfsavecontent>
                                        <cfinput type="text" name="finish_date" id="finish_date" value="" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                    </div>
                                </div>
                                <div class="col col-2 col-xs-12"> 
                                    <cf_wrkTimeFormat name="event_finish_clock" value="0">
                                </div>
                                <div class="col col-2 col-xs-12"> 
                                    <select name="event_finish_minute" id="event_finish_minute">
                                        <option value="00" selected>00</option>
                                        <option value="05">05</option>
                                        <option value="10">10</option>
                                        <option value="15">15</option>
                                        <option value="20">20</option>
                                        <option value="25">25</option>
                                        <option value="30">30</option>
                                        <option value="35">35</option>
                                        <option value="40">40</option>
                                        <option value="45">45</option>
                                        <option value="50">50</option>
                                        <option value="55">55</option>
                                    </select>  
                                </div>
                            </div> 
                            <div class="form-group" id="item-total_date"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57492.Toplam'></label>
                                <div class="col col-4 col-xs-12">
                                    <cfinput type="text" name="total_date" id="total_date" placeholder="#getlang('main','Gün',57490)#" onKeyup='return(FormatCurrency(this,event));' maxlength="100">
                                </div>
                                <div class="col col-4 col-xs-12">
                                    <cfinput type="text" name="total_hour" id="total_hour" placeholder="#getlang('main','Saat',57491)#" onKeyup='return(FormatCurrency(this,event));' maxlength="100">
                                </div>
                            </div>  
                            <div class="form-group" id="item-organization_target"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55474.Amaç'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="organization_target" id="organization_target"></textarea> 
                                </div>
                            </div>
                            <div class="form-group" id="item-organization_announcement"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49340.Etkinlik Duyurusu'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="organization_announcement" id="organization_announcement" ></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true"> 
                            <div class="form-group" id="item-max_participant"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49343.Maksimum Katılımcı'></label>
                                <div class="col col-4 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58195.tam sayı'></cfsavecontent>
                                    <cfinput type="text" name="max_participant" placeholder="#getLang('','Maksimum Katılımcı','49343')#"  onKeyUp="isNumber(this);" validate="integer" message="#message#">
                                </div>
                                <div class="col col-4 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58195.tam sayı'></cfsavecontent>
                                    <cfinput type="text" name="additional_participant" placeholder="#getLang('','Ek Kontenjan',49345)#" validate="integer" message="#message#">
                                </div>
                            </div>
                            <div class="form-group" id="item-organization_place"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49712.Etkinlik Yeri'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="organization_place" maxlength="100">							 
                                </div>
                            </div>                   
                            <div class="form-group" id="item-organization_place_manager"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49401.Etkinlik Yeri Sorumlusu'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" value="" name="organization_place_manager" maxlength="100">							 
                                </div>
                            </div>                        
                            <div class="form-group" id="item-organization_place_address"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49365.Etkinlik Yeri Adresi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" value="" name="organization_place_address" maxlength="100">							 
                                </div>
                            </div>                      
                            <div class="form-group" id="item-organization_place_tel"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49366.Etkinlik Yeri Telefonu'></label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" value="" name="organization_place_tel" maxlength="100">							 
                                </div>
                            </div>            
                            <div class="form-group" id="item-camp_name"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="camp_id" id="camp_id" value="">
                                        <input type="text" name="camp_name" id="camp_name" value="">
                                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns</cfoutput>&field_id=add_organization.camp_id&field_name=add_organization.camp_name&is_next_day');" title="<cf_get_lang dictionary_id='57446.Kampanya'>"></span>
                                    </div>
                                </div>
                            </div>          
                            <div class="form-group" id="item-project_head"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.proje'> <cfif xml_project_required eq 1>*</cfif></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group"> 
                                        <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.prj_id")><cfoutput>#get_project.project_id#</cfoutput></cfif>">
                                        <input type="text" name="project_head" id="project_head" value="<cfif isdefined("attributes.prj_id")><cfoutput>#get_project.project_id# - #get_project.project_head#</cfoutput></cfif>">
                                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_organization.project_id&project_head=add_organization.project_head');" title="<cfoutput>#getLang('','Proje',57416)#</cfoutput>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-organization_tools"> 
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64192.Araçlar'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="organization_tools" id="organization_tools" style="width:250px;height:50px;"></textarea>							 
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                </div>
                <div id="unique_sayfa_1" class="ui-info-text uniqueBox">
                    <cf_box_elements vertical="1">
                        <div class="col col-12 col-sm-12 col-xs-12" type="column" index="4" sort="true">
                            <div class="form-group" id="item-editor">
								<label style="display:none!important;"><cf_get_lang dictionary_id='57653.İçerik'></label>
                                <cfmodule
                                    template="/fckeditor/fckeditor.cfm"
                                    toolbarSet="Basic"
                                    basePath="/fckeditor/"
                                    instanceName="organization_detail"
                                    valign="top"
                                    value=""
                                    label="#getLang("campaign","Etkinlik İçeriği",49341)#">
                            </div>
                        </div>
                    </cf_box_elements>        
                </div>
            </cf_tab>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_box_footer>
                    <cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
                </cf_box_footer>
            </div>    
        </cf_box>
    </div>
</cfform>
<script type="text/javascript">
var temp=add_organization.organization_id;

function redirect(x)
{
	for (m=temp.options.length-1;m>0;m--)
		temp.options[m] = null;
	for (i=0;i<group[x].length;i++)
		temp.options[i]=new Option(group[x][i].text,group[x][i].value);

	temp.options[0].selected=true;
}
function check()
{
	if (document.add_organization.organization_cat_id.value =='' || document.add_organization.organization_cat_id.value == 0)
		{
			alert("<cf_get_lang dictionary_id='58947.Kategori Seçiniz'>");
			return false;
		}
	
	if ( (add_organization.start_date.value != "") && (add_organization.finish_date.value != "") )
		return time_check(add_organization.start_date, add_organization.event_start_clock, add_organization.event_start_minute, add_organization.finish_date,  add_organization.event_finish_clock, add_organization.event_finish_minute, "<cf_get_lang dictionary_id='54751.Etkinlik Başlama Tarihi Bitiş Tarihinden önce olmalıdır'>!");
	return true;
	
}
function kontrol()
{
	/*x = (750 - document.add_organization.class_objective.value.length);
	if ( x < 0)
	{ 
		alert ("<cf_get_lang dictionary_id='121.Eğitim İçeriğindeki Fazla Karakter Sayısı'>"+ ((-1) * x));
		return false;
	}*/
	if(document.getElementById('organization_announcement').value.length > 1500)
	{
		alert("<cf_get_lang dictionary_id='54754.Etkinlik Duyurusu Karakter Sayısı Maksimum'>:1500!");
		return false;
	}
	if(document.getElementById('organization_target').value.length > 4000)
	{
		alert("<cf_get_lang dictionary_id='52642.Etkinlik İçeriğinin Karakter sayısı 4000 den fazla olamaz'>!");
		return false;
	}
	if(document.getElementById("organization_cat_id").value == "")
	{
		alert("<cf_get_lang dictionary_id='58947.Kategori Seçiniz'>!");
		return false;
	}
	if(document.getElementById("company_name").value == "")
	{
		alert("<cf_get_lang dictionary_id='30638.Etkinlik Yetkilisi Seçiniz'>!");
		return false;
	}
<cfif xml_project_required eq 1>
 	if(document.getElementById("project_id").value == "" || document.getElementById("project_head").value == "")
	{
		alert("<cf_get_lang dictionary_id='58797.Proje Seçiniz'>!");
		return false;
	}
</cfif>
	return check();
	
}

function view_control(type)
{
	if(type==1)
	{
		document.add_organization.is_view_branch.checked=false;
		document.add_organization.is_view_department.checked=false;
	}
	if(type==2)
	{
		document.add_organization.view_to_all.checked=false;
		document.add_organization.is_view_department.checked=false;
	}
	if(type==3)
	{
		document.add_organization.view_to_all.checked=false;
		document.add_organization.is_view_branch.checked=false;
	}
}
</script>
