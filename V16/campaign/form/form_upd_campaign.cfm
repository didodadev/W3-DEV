<cfset xml_page_control_list = 'is_conscat_segmentation,is_conscat_premium,is_promotion,is_action_,is_camp_operation_rows,is_participation_time'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="campaign.form_upd_campaign">
<cfinclude template="../query/get_campaign_cats.cfm">
<cfinclude template="../query/get_campaign.cfm">
<cfquery name="GET_CAMP_TYPES" datasource="#dsn3#">
	SELECT CAMP_TYPE_ID,CAMP_TYPE FROM CAMPAIGN_TYPES ORDER BY CAMP_TYPE
</cfquery>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID, CONSCAT FROM CONSUMER_CAT ORDER BY CONSCAT
</cfquery>
<cfset attributes.project_id = campaign.project_id>
<cfif len(attributes.project_id)>
	<cfinclude template="../query/get_project_head.cfm">
</cfif>

<cfset getComponent = createObject('component', 'WEX.emailservices.cfc.sendgrid')>
<cfset getSendgridInformations = getComponent.getSendgridInformations()>
<!--- Sayfa ana kısım  --->
<cf_catalystHeader>
<!---Geniş alan: içerik---> 

    <div class="col col-9 col-xs-12 uniqueRow">
        <cf_box>
            <cfform name="upd_camp" id="upd_camp" method="post" action="#request.self#?fuseaction=campaign.emptypopup_upd_campaign">
                <cfoutput>
                    <cf_box_elements>
                            <input type="hidden" name="camp_id" id="camp_id" value="#camp_id#">
                                <div class="col col-12 col-md-12 col-xs-12" type="column" index="1" sort="true">
                                    <div class="form-group">
                                        <label class="col col-12">
                                            <cf_get_lang dictionary_id='57493.Aktif'>
                                            <input type="checkbox" name="camp_status" id="camp_status" value="1" <cfif campaign.camp_status eq 1>checked</cfif>>
                                        </label>
                                        <label class="col col-12">
                                            <cf_get_lang dictionary_id='58019.Extranet'>
                                            <input type="checkbox" name="is_extranet" id="is_extranet" value="1" <cfif campaign.is_extranet eq 1> checked</cfif>>
                                        </label>
                                        <label class="col col-12">
                                            <input type="checkbox" name="is_internet" id="is_internet" value="1" <cfif campaign.is_internet eq 1> checked</cfif>>
                                            <cf_get_lang dictionary_id='49435.İnternet'>
                                        </label>
                                    </div>
                                </div>
                                <div class="col col-4 col-md-6 col-xs-12" type="column" index="2" sort="true">
                                    <div class="form-group" id="item-comp_cat">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49509.Partner Portal'></label>
                                        <div class="col col-8 col-xs-12">
                                            <cf_multiselect_check 
                                                query_name="get_company_cat" 
                                                width="170" 
                                                name="comp_cat" 
                                                option_name="companycat" 
                                                option_value="companycat_id" 
                                                value="#campaign.company_cat#">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-camp_type">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
                                        <div class="col col-8 col-xs-12">
                                            <select name="camp_type" id="camp_type" onChange="redirect(this.options.selectedIndex);">
                                                <option value=""><cf_get_lang dictionary_id ='57630.Tip'></option>
                                                <cfloop query="get_camp_types">
                                                    <option value="#camp_type_id#" <cfif camp_type_id eq campaign.camp_type> selected</cfif>>#camp_type#</option>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-process_stage">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                                        <div class="col col-8 col-xs-12">
                                            <cf_workcube_process is_upd='0' select_value='#campaign.PROCESS_STAGE#' process_cat_width='170' is_detail='1'>
                                        </div>                
                                    </div> 
                                    <div class="form-group" id="item-camp_startdate">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>*</label>
                                        <div class="col col-4 col-xs-12">
                                            <div class="input-group">
                                                <cfset start_date_ = date_add('h',session.ep.time_zone,campaign.camp_startdate)>
                                                <cfset finish_date_ = date_add('h',session.ep.time_zone,campaign.camp_finishdate)>
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi !'></cfsavecontent>
                                                <cfinput type="text" name="camp_startdate" required="Yes" validate="#validate_style#" message="#message#" value="#dateformat(start_date_,dateformat_style)#">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="camp_startdate"></span>
                                            </div>
                                        </div>
                                        <div class="col col-2 col-xs-12">
                                            <cf_wrkTimeFormat name="camp_start_hour" id="camp_start_hour" value="#timeformat(start_date_,'HH')#">
                                        </div>
                                        <div class="col col-2 col-xs-12">
                                            <select name="camp_start_min" id="camp_start_min">
                                                <cfloop from="0" to="55" index="a" step="5">
                                                    <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(start_date_,'mm') is a>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                                </cfloop>			  
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-camp_finishdate">	
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
                                        <div class="col col-4 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi !'></cfsavecontent>
                                                <cfinput type="text" name="camp_finishdate" required="Yes" validate="#validate_style#" message="#message#" value="#dateformat(finish_date_,dateformat_style)#">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="camp_finishdate"></span>
                                            </div>
                                        </div>
                                        <div class="col col-2 col-xs-12">
                                            <cf_wrkTimeFormat name="camp_finish_hour" id="camp_finish_hour" value="#timeformat(finish_date_,'HH')#">
                                        </div>
                                        <div class="col col-2 col-xs-12">
                                            <select name="camp_finish_min" id="camp_finish_min">
                                                <cfloop from="0" to="55" index="a" step="5">
                                                    <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(finish_date_,'mm') is a>selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                                </cfloop>
                                            </select>  
                                        </div>   
                                    </div> 
                                    <div class="form-group" id="item-camp_head">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'>*</label>
                                        <div class="col col-8 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57480.Başlık !'></cfsavecontent>
                                            <cfinput type="text" name="camp_head" value="#campaign.camp_head#" required="Yes" message="#message#">
                                        </div>                
                                    </div>
                                    <div class="form-group" id="item-user_friendly_url" >
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='38023.Kullanıcı Dostu Url'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <cf_publishing_settings fuseaction="campaign.list_campaign" event="det" action_type="CAMP_ID" action_id="#attributes.camp_id#">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-camp_objective">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Acıklama'></label>
                                        <div class="col col-8 col-xs-12">
                                            <textarea name="camp_objective" id="camp_objective"><cfoutput>#campaign.camp_objective#</cfoutput></textarea>
                                        </div>                
                                    </div>
                                </div>
                                <div class="col col-4 col-md-6 col-xs-12" type="column" index="3" sort="true">
                                    <div class="form-group" id="item-camp_no">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57487.Kampanya No'></label>
                                        <div class="col col-8 col-xs-12">
                                            <input type="text" name="camp_no" id="camp_no" maxlength="50" value="<cfoutput>#campaign.camp_no#</cfoutput>">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-cons_cat">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49510.Public Portal'></label>
                                        <div class="col col-8 col-xs-12">
                                            <cf_multiselect_check 
                                                name="cons_cat" 
                                                width="170" 
                                                query_name="get_consumer_cat" 
                                                option_name="conscat" 
                                                option_value="conscat_id" 
                                                value="#campaign.consumer_cat#">
                                        </div>                
                                    </div>
                                    <div class="form-group" id="item-camp_cat_id">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='49552.Alt Kategori'> *</label>
                                        <div class="col col-8 col-xs-12">
                                            <select name="camp_cat_id" id="camp_cat_id">
                                                <cfloop query="get_campaign_cats">
                                                    <option value="#camp_cat_id#" <cfif campaign.camp_cat_id eq camp_cat_id>selected</cfif>>#camp_cat_name#</option> 
                                                </cfloop>
                                            </select>
                                        </div>                
                                    </div> 
                                    <div class="form-group" id="item-project_head">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49344.İlgili Proje'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <input type="Hidden" name="project_id" id="project_id" value="<cfoutput>#campaign.project_id#</cfoutput>">
                                                <cf_wrk_projects form_name="upd_camp" project_id="project_id" project_name="project_head">
                                                <input type="text" name="project_head" id="project_head" value="<cfif len(attributes.project_id) AND GET_PROJECT_HEAD.RecordCount><cfoutput>#GET_PROJECT_HEAD.PROJECT_HEAD#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');"  autocomplete="off">
                                                <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_id=upd_camp.project_id&project_head=upd_camp.project_head</cfoutput>');"></span>
                                            </div>
                                        </div>                
                                    </div>
                                    <div class="form-group" id="item-leader_employee">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49336.Lider'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <cfif len(campaign.leader_employee_id)>
                                                    <input type="hidden" name="leader_employee_id" id="leader_employee_id" value="<cfoutput>#campaign.leader_employee_id#</cfoutput>">
                                                    <input type="text" name="leader_employee" id="leader_employee" readonly value="<cfoutput>#get_emp_info(campaign.leader_employee_id,0,0)#</cfoutput>">
                                                <cfelse>
                                                    <input type="hidden" name="leader_employee_id" id="leader_employee_id" value="">
                                                    <input type="text" name="leader_employee" id="leader_employee" value="" readonly>
                                                </cfif>
                                                <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2,3&field_emp_id=upd_camp.leader_employee_id&field_name=upd_camp.leader_employee</cfoutput>');"></span>
                                            </div>
                                        </div>                
                                    </div>
                                    <div class="form-group" id="item-participation_time">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49362.Katılım Taahhüt Süresi'><cfoutput>(<cf_get_lang dictionary_id='58724.Ay'>)</cfoutput></label>
                                        <div class="col col-8 col-xs-12">
                                            <cfinput type="text" name="participation_time" value="#campaign.part_time#" maxlength="3" onkeyup="isNumber(this);" class="moneybox">
                                        </div>                
                                    </div>
                                </div>
                    </cf_box_elements>
                    <div class="row formContentFooter">
                        <div class="col col-6"><cf_record_info query_name="campaign"></div> 
                        <div class="col col-6"><cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=campaign.emptypopup_del_campaign&camp_id=#attributes.camp_id#&cat=#campaign.camp_type#&head=#URLEncodedFormat(campaign.camp_head)#' add_function='kontrol()'></div>
                    </div>
                </cfoutput>
            </cfform>
        </cf_box>
        <!---Box BEGIN--->
        <!--- kampanya içerikleri --->        
        <cfsavecontent  variable="templates">
            <cfif getSendgridInformations.IS_SENDGRID_INTEGRATED eq 1 and len(getSendgridInformations.MAIL_API_KEY) and len(getSendgridInformations.sender_mail)>
                <li><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=campaign.templates&camp_id=#attributes.camp_id#</cfoutput>')"><i class="catalyst-doc"></i></a></li>
            </cfif>
        </cfsavecontent>
        <cfsavecontent variable="baslik"><cf_get_lang dictionary_id ='49486.Gönderiler'></cfsavecontent>
        <cf_box id="get_camp_content" 
        sms_href="javascript:openBoxDraggable('#request.self#?fuseaction=campaign.popup_form_add_sms_cont&camp_id=#camp_id#','','ui-draggable-box-medium')"
        sms_title="#getLang('','SMS İçeriği Ekle','49381')#"
        add_href="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_content_relation&action_type_id=#attributes.camp_id#&action_type=CAMPAIGN_ID')"
        closable="0"
        title="#baslik#" 
        box_page="#request.self#?fuseaction=campaign.emptypopup_dsp_campaign_contents&camp_id=#attributes.camp_id#" 
        right_images="#templates#"></cf_box>
        <!---İçerikler --->
        <cf_get_workcube_content action_type ='CAMPAIGN_ID' company_id='#session.ep.company_id#' action_type_id ='#attributes.camp_id#' design='0'>
        <!---Değerlendirme formları --->
        <cf_get_workcube_form_generator action_type='3' related_type='3' action_type_id='#attributes.camp_id#' design='3'>
        <!--- İlişkili Organizasyonlar --->
        <cf_box id="main_organization_id" title="#getLang('','Etkinlikler',46909)#" add_href="#request.self#?fuseaction=campaign.list_organization&event=add&camp_id=#attributes.camp_id#" unload_body="1" closable="0" box_page="#request.self#?fuseaction=objects.emptypopup_get_organization_detail&camp_id=#attributes.camp_id#">
        </cf_box>
        <!--- İş akış tasarımcısı --->
        <cfset action_section = "CAMPAIGN">
        <cfset relative_id = attributes.camp_id>
        <cfinclude template="../../process/display/list_designer.cfm"> 
        <!---Promosyonlar --->
        <cfif isdefined("is_promotion") and is_promotion eq 1>
            <cfsavecontent variable="baslik"><cf_get_lang dictionary_id ='61492.Promosyonlar'></cfsavecontent>
            <cf_box id="get_camp_proms" title="#baslik#" unload_body="1" box_page="#request.self#?fuseaction=campaign.emptypopup_dsp_campaign_proms&camp_id=#attributes.camp_id#" closable="0" add_href="#request.self#?fuseaction=product.list_promotions&event=add&camp_id=#attributes.camp_id#">
            </cf_box>
        </cfif>
        <!---Aksiyonlar --->
        <cfif isdefined("is_action_") and is_action_ eq 1>	
            <cfsavecontent variable="baslik"><cf_get_lang dictionary_id='58988.Aksiyonlar'></cfsavecontent>
            <cf_box id="get_camp_catalogs" title="#baslik#" unload_body="1" closable="0" add_href="#request.self#?fuseaction=product.list_catalog_promotion&event=add&camp_id=#attributes.camp_id#" box_page="#request.self#?fuseaction=campaign.emptypopup_dsp_campaign_catalogs&camp_id=#attributes.camp_id#">
            </cf_box>
        </cfif>
        <!---Abonelere Satılabilir Ürünler --->
        <cfif isdefined("is_camp_operation_rows") and is_camp_operation_rows eq 1>
            <cfsavecontent variable="baslik"><cf_get_lang dictionary_id='62557.Abonelere Satılabilir Ürünler'></cfsavecontent>
            <cf_box id="get_camp_operation_rows" unload_body="1" closable="0" title="#baslik#" box_page="#request.self#?fuseaction=campaign.emptypopup_dsp_campaign_operation_rows&camp_id=#attributes.camp_id#&is_operation_show_kdv_amount=#is_operation_show_kdv_amount#&is_operation_show_isk_amount=#is_operation_show_isk_amount#&is_paymethod_value_kontrol=#is_paymethod_value_kontrol#&is_paymethod_kontrol=#is_paymethod_kontrol#&is_operation_show_kdv=#is_operation_show_kdv#&is_operation_show_otv=#is_operation_show_otv#">
            </cf_box>
        </cfif>
    </div>
    <!--- Yan kısım--->
    <div class="col col-3 col-xs-12 uniqueRow"> <!---///content sağ--->
        <!---Hedef Kitle--->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='49363.Hedef Kitle'></cfsavecontent>
        <cfsavecontent variable="info_title_message"><cf_get_lang dictionary_id ='49363.Hedef Kitle'></cfsavecontent>
        <cf_box id="list_target_markets" 
            closable="0" 
            unload_body="1" 
            title="#message#" 
            box_page="#request.self#?fuseaction=campaign.emptypopup_list_target_markets_ajax&camp_id=#camp_id#" 
            info_href="javascript:openBoxDraggable('#request.self#?fuseaction=campaign.popup_list_target_markets&camp_id=#camp_id#&draggable=1')" 
            add_href="#request.self#?fuseaction=campaign.list_target_markets&camp_id=#camp_id#&event=add">
        </cf_box>
        <!---Ekip--->
        <cfif isdefined("attributes.camp_id") and len(attributes.camp_id)>
            <cfset getComponent = createObject('component','V16.project.cfc.get_project_detail')>
	        <cfset GET_ACTION_WORKGROUP = getComponent.GET_ACTION_WORKGROUP(action_field : "campaing", action_id : attributes.camp_id)>
            <div style="display:none;z-index:999;" id="subs_team"></div>
            <cf_box 
                id="workgroup" 
                title="#getLang('','Ekip','41475')#" 
                widget_load="subscriberTeam&action_id=#attributes.camp_id#&action_field=campaing"  
                lock_href="openBoxDraggable('#request.self#?fuseaction=objects.popup_denied_pages_lock&pages_id=#GET_ACTION_WORKGROUP.WORKGROUP_ID#&act=#attributes.fuseaction#')"
    	        lock_href_title="#getLang('','Sayfa Kilidi',58041)#" 
                add_href="javascript:openBoxDraggable('#request.self#?fuseaction=project.popup_add_workgroup&action_id=#attributes.camp_id#&action_field=campaing')">
            </cf_box>
        </cfif>
     <!---    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='49364.Ekip'></cfsavecontent>
        <cf_box 
            id="list_correspondence1_menu" 
            unload_body="1" 
            closable="0" 
            title="#message#" 
            add_href="openBoxDraggable('#request.self#?fuseaction=campaign.popup_form_add_member&campaign_id=#attributes.camp_id#')" 
            add_href_size="medium"
            box_page="#request.self#?fuseaction=campaign.emptypopup_form_add_campaign_team_ajax&camp_id=#attributes.camp_id#">
        </cf_box> --->
        <!---Anketler--->
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57947.Anketler'></cfsavecontent>
        <cf_box id="list_campaigns_survey" unload_body="1" collapsed="1" closable="0" title="#message#" info_href="#request.self#?fuseaction=campaign.popup_list_target_surveys&camp_id=#attributes.camp_id#" add_href="#request.self#?fuseaction=campaign.list_survey&event=add&camp_id=#attributes.camp_id#" box_page="#request.self#?fuseaction=campaign.emptypopup_list_campaigns_surveys_ajax&camp_id=#attributes.camp_id#"></cf_box>
        <cf_get_related_events action_section='CAMPAIGN_ID' action_id='#attributes.camp_id#' company_id='#session.ep.company_id#'>
        <!--- Notlar --->
        <cf_get_workcube_note company_id="#session.ep.company_id#" action_section='CAMPAIGN_ID' action_id='#attributes.camp_id#'>
        <!--- Varlıklar --->
        <cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-15" module_id='15' action_section='CAMPAIGN_ID' action_id='#attributes.camp_id#'>
     
        <!---Box END--->
    </div>
<script language="JavaScript">
	var groups=document.upd_camp.camp_type.options.length;
	var group=new Array(groups);
	for (i=0; i<groups; i++)
		group[i]=new Array();
		group[0][0]=new Option("Kategori","");
		<cfset branch = ArrayNew(1)>
		<cfoutput query="get_camp_types">
			<cfset branch[currentrow]=#camp_type_id#>
		</cfoutput>
		<cfloop from="1" to="#ArrayLen(branch)#" index="indexer">
			<cfquery name="dep_names" datasource="#dsn3#">
				SELECT CAMP_CAT_NAME,CAMP_CAT_ID FROM CAMPAIGN_CATS WHERE CAMP_TYPE = #branch[indexer]# ORDER BY CAMP_CAT_ID
			</cfquery>
			<cfif dep_names.recordcount>
				<cfset deg = 0>
				<cfoutput>group[#indexer#][#deg#]=new Option("Kategori","");</cfoutput>
				<cfoutput query="dep_names">
					<cfset deg = currentrow>
						<cfif dep_names.recordcount>
							group[#indexer#][#deg#]=new Option("#camp_cat_name#","#camp_cat_id#");
						</cfif>
				</cfoutput>
			<cfelse>
				<cfset deg = 0>
				<cfoutput>
					group[#indexer#][#deg#]=new Option("<cf_get_lang dictionary_id='58947.Kategori Seçiniz'>","");
				</cfoutput>
			</cfif>
		</cfloop>	
	var temp = document.upd_camp.camp_cat_id;
	function redirect(x)
	{
		for (m=temp.options.length-1;m>0;m--)
		temp.options[m]=null;
		for (i=0;i<group[x].length;i++)
		{
			temp.options[i]=new Option(group[x][i].text,group[x][i].value)
		}
	}
	function kontrol()
	{
		x = document.upd_camp.camp_type.selectedIndex;
		if (document.upd_camp.camp_type[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49554.Kampanya Tipi'>!");
			return false;
		}		
		x = document.upd_camp.camp_cat_id.selectedIndex;
		if (document.upd_camp.camp_cat_id[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49555.Kampanya Kategorisi'> !");
			return false;
		}
		if (document.upd_camp.camp_head.value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57480.Başlık'> !");
			return false;
		}
		unformat_fields();
		return process_cat_control();
	}
	function unformat_fields()
	{
		return date_check(upd_camp.camp_startdate,upd_camp.camp_finishdate,"<cf_get_lang dictionary_id='49487.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır !'>");
	}
	function sayfa_getir(type)
	{
		if(type == 1)
		{
			gizle_goster(camp_proms_info);
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=campaign.emptypopup_dsp_campaign_proms&camp_id=#attributes.camp_id#</cfoutput>','camp_proms');
		}
		else if(type == 2)
		{
			gizle_goster(camp_catalogs_info);
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=campaign.emptypopup_dsp_campaign_catalogs&camp_id=#attributes.camp_id#</cfoutput>','camp_catalogs');
		}
		else if(type == 3)
		{
			//iliskili belgelerde de ajaxin acilip kapanmasini duzenlemek icin gizle goster secenegi, basliga tasindi
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=campaign.emptypopup_dsp_campaign_contents&camp_id=#attributes.camp_id#</cfoutput>','camp_content');
		}
		else
		{
			gizle_goster(camp_operation_rows_info);
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=campaign.emptypopup_dsp_campaign_operation_rows&camp_id=#attributes.camp_id#&is_operation_show_kdv_amount=#is_operation_show_kdv_amount#&is_operation_show_isk_amount=#is_operation_show_isk_amount#&is_paymethod_value_kontrol=#is_paymethod_value_kontrol#&is_paymethod_kontrol=#is_paymethod_kontrol#&is_operation_show_kdv=#is_operation_show_kdv#&is_operation_show_otv=#is_operation_show_otv#</cfoutput>','camp_operation_rows');
		}
	}
</script>