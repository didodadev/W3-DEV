<cf_xml_page_edit fuseact="training_management.form_add_training_subject">
<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfset cfc = createObject('component','V16.training_management.cfc.trainingcat')>
<cfset GET_TRAINING_SUBJECT = cfc.GET_TRAINING_SUBJECT(
    TRAIN_ID:attributes.TRAIN_ID
)>
<cfset GET_MONEY = cfc.GET_MONEY()>
<cfset get_training_cat = cfc.get_training_cat()>
<cfset get_training_sec = cfc.get_training_sec()>
<cfset GET_TRAINING_STYLE = cfc.GET_TRAINING_STYLE()>
<cfset GET_STAGE = cfc.GET_STAGE()>
<cfset GET_LANGUAGE = cmp.GET_LANGUAGE_F()>
<cfscript>
    XFA.upd = "training_management.upd_training_subject";
    XFA.del = "training_management.del_training_subject";	
</cfscript>
<div style="display:none;z-index:999;" id="subs_team"></div>
<cf_catalystHeader>
<div class="col col-9 col-xs-12">
    <cf_box title="#getLang('','Temel Bilgiler',58131)#">
        <cfform  name="upd_training_form" action="V16/training_management/cfc/trainingcat.cfc?method=update&train_id=#attributes.TRAIN_ID#" enctype="multipart/form-data" method="post">
            <cf_box_elements>
                <div class="col col-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">	
                    <div class="form-group" id="item-subject_status">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="subject_status" id="subject_status" value="1" <cfif get_training_subject.subject_status eq 1>checked</cfif>>
                        </div>
                    </div>
                    <div class="form-group" id="item-training_stage">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' select_value='#get_training_subject.training_stage#' process_cat_width='300' is_detail='0'>
                        </div>
                    </div>

                    <div class="form-group" id="item-train_head">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57480.Konu'></cfsavecontent>
                            <input type="Hidden" name="train_id" id="train_id" value="<cfoutput>#attributes.train_id#</cfoutput>">
                            <cfinput type="text" name="train_head" id="train_head" style="width:423px;" message="#message#" value="#get_training_subject.train_head#" maxlength="125">
                        </div>
                    </div>
                    <div class="form-group" id="item-training_cat_id">				
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="training_cat_id" id="training_cat_id" size="1" onChange="get_tran_sec(this.value)">
                                <option value="0"><cf_get_lang dictionary_id='57486.Kategori'></option>
                                <cfoutput query="get_training_cat">
                                    <option value="#training_cat_id#"<cfif get_training_subject.training_cat_id eq training_cat_id>selected</cfif>>#training_cat#</option>
                                </cfoutput>
                            </select>								 
                        </div>
                    </div>
                    <div class="form-group" id="item-training_sec_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57995.Bölüm'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="training_sec_id" id="training_sec_id" size="1">
                                    <option value="0"><cf_get_lang dictionary_id='57995.Bölüm'></option>
                                </select>	
                            </div>
                    </div>
                    <div class="form-group" id="item-train_objective">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46007.Amaç'></label>
                        <div class="col col-8 col-xs-12"><textarea name="train_objective" id="train_objective"><cfoutput>#get_training_subject.train_objective#</cfoutput></textarea></div>
                    </div>
                    <div class="form-group" id="item-emp_par_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46051.Eğitimci'></label>		
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="cons_id" id="cons_id" value="<cfoutput>#get_training_subject.trainer_cons#</cfoutput>">
                                <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#get_training_subject.trainer_emp#</cfoutput>">
                                <input type="hidden" name="par_id" id="par_id" value="<cfoutput>#get_training_subject.trainer_par#</cfoutput>"> 
                                <input type="hidden" name="member_type" id="member_type" <cfif len(get_training_subject.trainer_emp)>value="employee"<cfelseif len(get_training_subject.trainer_par)>value="partner"</cfif>> 
                                <cfif len(get_training_subject.trainer_emp)>
                                    <cfset attributes.employee_id = get_training_subject.trainer_emp>
                                    <cfinclude template="../query/get_employee.cfm">
                                    <input type="text" name="emp_par_name" id="emp_par_name" value="<cfoutput>#get_employee.employee_name# #get_employee.employee_surname#</cfoutput>" readonly>
                                <cfelseif len(get_training_subject.trainer_par)>
                                    <cfset attributes.partner_id = get_training_subject.trainer_par>
                                    <cfinclude template="../query/get_partner.cfm">
                                    <input type="text" name="emp_par_name" id="emp_par_name" value="<cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname#</cfoutput>" readonly>
                                <cfelseif len(get_training_subject.trainer_cons)>
                                    <input type="text" name="emp_par_name" id="emp_par_name" value="<cfoutput>#get_cons_info(get_training_subject.trainer_cons,0,0)#</cfoutput>" readonly>
                                <cfelse>
                                    <input type="text" name="emp_par_name" id="emp_par_name" value="" readonly>
                                </cfif>
                                <span class="input-group-addon icon-ellipsis btnPointer"  onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_training_form.emp_id&field_consumer=upd_training_form.cons_id&field_name=upd_training_form.emp_par_name&field_partner=upd_training_form.par_id&field_type=upd_training_form.member_type&select_list=1,2,3</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>	
                </div>
                <div class="col col-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-user_friendly_url">								
                        <label class="col col-4 col-sm-6 col-xs-12"><cf_get_lang dictionary_id ='50659.Kullanıcı Dostu Url Adres'></label>
                        <div class="col col-8 col-sm-6 col-xs-12">
                            <cf_publishing_settings fuseaction="training_management.list_training_subjects" event="det" action_type="TRAIN_ID" action_id="#attributes.TRAIN_ID#">
                        </div>
                    </div>
                    <div class="form-group" id="item-language_id">
                        <label class="col col-4 col-sm-6 col-xs-12">
                            <cf_get_lang dictionary_id='58996.Dil'> *
                        </label>
                        <div class="col col-8 col-sm-6 col-xs-12">
                            <select name="language_id" id="language_id">
                                <cfoutput query="get_language">
                                    <option value="#language_short#"<cfif language_short is get_training_subject.language>selected</cfif>>#language_set#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-training_style">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46122.Eğitim Şekli'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="training_style" id="training_style">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_training_style">
                                    <option value="#TRAINING_STYLE_ID#"<cfif get_training_subject.training_style eq training_style_id>selected</cfif>>#TRAINING_STYLE#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-training_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46120.Eğitim Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="training_type" id="training_type">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1" <cfif get_training_subject.training_type eq 1>selected</cfif>><cf_get_lang dictionary_id='46647.Standart Eğitim'></option>
                                <option value="2" <cfif get_training_subject.training_type eq 2>selected</cfif>><cf_get_lang dictionary_id='46648.Teknik Gelişim Eğitimi'></option>
                                <option value="3" <cfif get_training_subject.training_type eq 3>selected</cfif>><cf_get_lang dictionary_id='46649.Zorunlu Eğitim'></option>
                                <option value="4" <cfif get_training_subject.training_type eq 4>selected</cfif>><cf_get_lang dictionary_id='46650.Yetkinlik Gelişim Eğitimi'></option>
                            </select>
                        </div>
                    </div>
                    <cfif isdefined('x_product_associate') and x_product_associate eq 1>
                        <div class="form-group" id="form_ul_product_name">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="product_id" id="product_id" value="<cfoutput><cfif len(get_training_subject.product_id)>#get_training_subject.product_id#</cfif></cfoutput>">
                                    <input type="text" name="product_name"  id="product_name" value="<cfoutput><cfif len(get_training_subject.product_id)>#get_product_name(get_training_subject.product_id)#</cfif></cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','225');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=upd_training_form.product_id&field_name=upd_training_form.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>');"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-totalday">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29513.Süre'>/<cf_get_lang dictionary_id='57490.Gün'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="totalday" id="totalday" value="#get_training_subject.total_day#" validate="integer" message="#getLang('','Süre Gün Cinsinden Olmalıdır',46644)#">
                        </div>
                    </div>
                    <div class="form-group" id="item-totalday">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46377.Toplam Saat'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="total_hours" id="total_hours" value="#get_training_subject.total_hours#" validate="integer">
                        </div>
                    </div>
                    <div class="form-group" id="item-expense">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46646.Tahmini Bedel'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            <cfinput type="text" name="expense" value="#tlformat(get_training_subject.training_expense)#"  onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                            <span class="input-group-addon width">
                                <select name="money" id="money">
                                    <cfoutput query="get_money">
                                        <option value="#money#" <cfif money eq get_training_subject.money_currency>selected</cfif>>#money#</option>
                                    </cfoutput>
                                </select>
                            </span>
                            </div>
                        </div>									
                    </div>	
                </div>	
                <div class="col col-12 col-sm-12 col-xs-12" type="column" index="3" sort="true">	
                    <cf_seperator id="item_train_detail" header="#getLang('','İçerik',57653)#" is_closed="0">
                    <div class="col col-12 col-xs-12" id="item_train_detail">
                        <!--- <label class="txtbold" height="20"><cf_get_lang dictionary_id='57653.İçerik'></label> --->	
                        <cfmodule
                            template="/fckeditor/fckeditor.cfm"
                            toolbarSet="WRKContent"
                            basePath="/fckeditor/"
                            instanceName="train_detail"
                            valign="top"
                            value="#get_training_subject.train_detail#"
                            width="530"
                            height="150">
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6 col-xs-12">
                    <cf_record_info query_name="get_training_subject">
                </div>
                <div class="col col-6 col-xs-12">
                    <cf_workcube_buttons type_format='1' is_upd='1' delete_page_url='#request.self#?fuseaction=#xfa.del#&train_id=#attributes.train_id#&head=#get_training_subject.train_head#' add_function='kontrol()'>
                </div>
            </cf_box_footer>	
        </cfform>
    </cf_box>
    <cf_box  title="#getLang('','Kimler İçin?',54997)#">
        <cfform name="upd_training" method="post"  action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_training_subject">
            <input type="hidden" id="train_id" name="train_id" value="<cfoutput>#attributes.train_id#</cfoutput>">
            <cfset select_list="">
            <cfif isdefined("x_organization_unit") and x_organization_unit eq 1>
                <cfset select_list = '1,2,7'>
            </cfif>
            <cfif isdefined("x_planned_roles") and x_planned_roles eq 1>
                <cfset select_list = '#select_list#,3,5,6,9'>
            </cfif>
            <cfif isdefined("x_corporate_members") and x_corporate_members eq 1>
                <cfset select_list = '#select_list#,4'>
            </cfif>
            <cfif isdefined("x_individual_members") and x_individual_members eq 1>
                <cfset select_list = '#select_list#,8'>
            </cfif>
            <cf_box_elements>
                <div class="col col-12 col-xs-12">
                    <div class="form-group" id="egitim_kategorisi_">	
                                <cf_relation_segment
                                            is_upd="1" 
                                            is_form="1" 
                                            field_id="#attributes.TRAIN_ID#" 
                                            table_name="TRAINING" 
                                            tag_head="<cf_get_lang dictionary_id='46651.Eğitim Kategorisinin geçerli olduğu koşullar'>" 
                                            action_table_name='RELATION_SEGMENT_TRAINING' 
                                            select_list='#select_list#'>	
                    </div>		
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6 col-xs-12">
                    <cf_record_info query_name="get_training_subject">
                </div>
                <div class="col col-6 col-xs-12">
                    <cf_workcube_buttons type_format='1' is_upd='1' delete_page_url='#request.self#?fuseaction=#xfa.del#&train_id=#attributes.train_id#&head=#get_training_subject.train_head#' add_function='kontrol()'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
    <!--- İçerikler --->
        <cf_get_workcube_content action_type ='train_id' action_type_id ='#attributes.train_id#' style='1' design='1' draggable="1">
    <!--- İçerikler --->
</div>
<div class="col col-3 col-xs-12">
    <cfset getComponent = createObject('component','V16.project.cfc.get_project_detail')>
    <cfset GET_ACTION_WORKGROUP = getComponent.GET_ACTION_WORKGROUP(action_field : "training_management", action_id : attributes.train_id)>
    <!--- Ekip --->
    <cf_box 
        id="workgroup" 
        title="#getLang('campaign',44)#" 
        widget_load="subscriberTeam&action_id=#attributes.train_id#&action_field=training_management"
        lock_href="openBoxDraggable('#request.self#?fuseaction=objects.popup_denied_pages_lock&pages_id=#GET_ACTION_WORKGROUP.WORKGROUP_ID#&act=#attributes.fuseaction#')"
        lock_href_title="#getLang('','Sayfa Kilidi',58041)#" 
        add_href="javascript:openBoxDraggable('#request.self#?fuseaction=project.popup_add_workgroup&action_id=#attributes.train_id#&action_field=training_management')">
    </cf_box>
    <!--- İmajlar --->
    <cf_wrk_images train_id="#attributes.train_id#" type="train_subject">
    <!--- Belgeler --->
    <cf_get_workcube_asset asset_cat_id="4" module_id='34' action_section='TRAIN_ID' action_id='#attributes.train_id#'>
</div>
<script type="text/javascript">
    function get_tran_sec(cat_id)//bölümün içini dolduruyor
    {
        document.upd_training_form.training_sec_id.options.length = 0;
        var get_sec = wrk_safe_query('trn_get_sec','dsn',0,cat_id);
        document.upd_training_form.training_sec_id.options[0]=new Option('Bölüm !','0');
        for(var jj=0;jj<get_sec.recordcount;jj++)
            document.upd_training_form.training_sec_id.options[jj+1]=new Option(get_sec.SECTION_NAME[jj],get_sec.TRAINING_SEC_ID[jj])
        return true;
    }
    <cfif isDefined("get_training_subject.training_cat_id") and len(get_training_subject.training_cat_id)>//bölüme bu soruya ait kategori id yolluyor
        get_tran_sec(<cfoutput>#get_training_subject.training_cat_id#</cfoutput>);
    </cfif>
    
    <cfif isDefined("get_training_subject.training_sec_id") and len(get_training_subject.training_sec_id)>//konuya bu souya ait bölüm id yolluyor ve bu bölüme ait konular gelmiş oluyor
        document.upd_training_form.training_sec_id.value = <cfoutput>#get_training_subject.training_sec_id#</cfoutput>;
    </cfif>

    function kontrol()
    {
        upd_training_form.expense.value = filterNum(upd_training_form.expense.value);
        if(document.getElementById('train_head').value == "")
        {
            alert ("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57480.Konu'>!");
            return false;
        }
    }
</script>