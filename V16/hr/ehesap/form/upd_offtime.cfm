<cf_xml_page_edit fuseact='ehesap.form_add_offtime_popup'>
    <cf_get_lang_set module_name="ehesap">
    <cfinclude template="../query/get_offtime.cfm">
    <cfset xfa.del = "#request.self#?fuseaction=ehesap.emptypopup_del_offtime&OFFTIME_ID=#attributes.OFFTIME_ID#&head=#get_emp_info(get_offtime.employee_id,0,0)#">
    <cfset xfa.upd = "#request.self#?fuseaction=ehesap.emptypopup_upd_offtime">
    <cfif not get_offtime.recordcount>
        <cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../../../dsp_hata.cfm">
    <cfelse>
    <cfsavecontent variable="right_">
        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.offtime_id#&print_type=175</cfoutput>','page');"><img src="/images/print.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></a>
        <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.offtimes&event=add"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a>
    </cfsavecontent>
    <cfif session.ep.time_zone neq 0>
    <cfset record_=date_add('h',session.ep.time_zone,get_offtime.record_date)>
    <cfset start_=date_add('h',session.ep.time_zone,get_offtime.startdate)>
    <cfset end_=date_add('h',session.ep.time_zone,get_offtime.finishdate)>
    <cfelse>
    <cfset record_=get_offtime.record_date>
    <cfset start_=get_offtime.startdate>
    <cfset end_=get_offtime.finishdate>
    </cfif>
    
    <cfif len(get_offtime.work_startdate)>
    <cfif session.ep.time_zone neq 0>
        <cfset work_start_= date_add('h',session.ep.time_zone,get_offtime.work_startdate)>
    <cfelse>
        <cfset work_start_= get_offtime.work_startdate>
    </cfif>
    <cfelse>				
        <cfset work_start_= date_add('d',1,get_offtime.finishdate)>
        <cfif session.ep.time_zone neq 0>
            <cfset work_start_= date_add('h',session.ep.time_zone,work_start_)>
        <cfelse>
            <cfset work_start_= work_start_>
        </cfif>
    </cfif>
    
    <cfparam name="attributes.employee_id" default="#get_offtime.employee_id#">
    <cfset getEmp = CreateObject("component","V16.hr.cfc.get_employee")>
    <cfset empInformations = getEmp.get_employee(emp_id:attributes.employee_id)>
    <cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
    <cfif not isdefined("attributes.is_view_agenda")>
        <cfset xml_is_view_agenda = get_fuseaction_property.get_fuseaction_property(
            company_id : session.ep.company_id,
            fuseaction_name : 'ehesap.offtimes',
            property_name : 'is_view_agenda'
        )>
        <cfif xml_is_view_agenda.recordcount>
            <cfset attributes.is_view_agenda = xml_is_view_agenda.property_value>
        </cfif>
    </cfif>
    
    <cfif not isdefined("attributes.x_event_catid")>
        <cfset xml_event_cat_id = get_fuseaction_property.get_fuseaction_property(
            company_id : session.ep.company_id,
            fuseaction_name : 'ehesap.offtimes',
            property_name : 'x_event_catid'
        )>
        <cfif xml_event_cat_id.recordcount>
            <cfset attributes.x_event_catid = xml_event_cat_id.property_value>
        </cfif>
    </cfif>
    
    <cf_catalystHeader>
    <div class="col col-8 col-md-8 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="offtime_request" method="post" action="#xfa.upd#">
                <input type="hidden" name="offtime_id" id="offtime_id" value="<cfoutput>#get_offtime.offtime_id#</cfoutput>">
                <input type="hidden" name="is_view_agenda" id="is_view_agenda" value="<cfif isdefined("attributes.is_view_agenda")><cfoutput>#attributes.is_view_agenda#</cfoutput></cfif>">
                <input type="hidden" name="x_event_catid" id="x_event_catid" value="<cfif isdefined("attributes.x_event_catid")><cfoutput>#attributes.x_event_catid#</cfoutput></cfif>">
                <input type="hidden" name="valid" id="valid" value="<cfoutput>#get_offtime.valid#</cfoutput>">
                <input type="hidden" name="counter" id="counter">
                <cf_box_elements>
                    <div class="col col-8 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-is_puantaj_off">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53662.Puantajda Görüntülenmesin'></label>
                            <div class="col col-8 col-xs-12"> 
                                <input type="checkbox" value="1" name="is_puantaj_off" id="is_puantaj_off" <cfif get_offtime.is_puantaj_off>checked</cfif>>
                            </div>
                        </div>
                        <div class="form-group" id="item-employee_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                            <div class="col col-8 col-xs-12"> 
                                <cf_wrk_employee_in_out
                                    form_name="offtime_request"
                                    emp_id_fieldname="employee_id"
                                    emp_id_value="#get_offtime.employee_id#"
                                    in_out_value="#get_offtime.in_out_id#"
                                    in_out_id_fieldname="in_out_id"
                                    emp_name_fieldname="employee_name"
                                    width="188"> 
                            </div>
                        </div>
                        <div class="form-group" id="item-process">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
                            <div class="col col-8 col-xs-12"> 
                                <cf_workcube_process is_upd='0' select_value='#get_offtime.offtime_stage#' process_cat_width='188' is_detail='1'>
                            </div>
                        </div>
                        <div class="form-group" id="item-offtimecat_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                            <div class="col col-8 col-xs-12"> 
                                <cfquery name="GET_OFFTIME_CATS" datasource="#DSN#">
                                    SELECT 
                                        OFFTIMECAT,OFFTIMECAT_ID,IS_PUANTAJ_OFF
                                    FROM 
                                        SETUP_OFFTIME
                                    WHERE
                                        IS_ACTIVE = 1
                                        AND UPPER_OFFTIMECAT_ID = 0 
                                    UNION 
                                    SELECT
                                        OFFTIMECAT,OFFTIMECAT_ID,IS_PUANTAJ_OFF
                                    FROM 
                                        SETUP_OFFTIME 
                                    WHERE
                                        OFFTIMECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offtime.offtimecat_id#">
                                        AND UPPER_OFFTIMECAT_ID = 0 
                                </cfquery>
                                <select name="offtimecat_id" id="offtimecat_id" style="width:188px;" onchange="sub_category();">
                                    <option value="" onclick="change_puantaj(0);"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_offtime_cats">
                                        <option value="#offtimecat_id#"<cfif get_offtime.offtimecat_id eq offtimecat_id> selected</cfif> onclick="change_puantaj(#is_puantaj_off#);">#offtimecat#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <!---Alt Kategori 20191009ERU--->
                        <div class="form-group" id="item-sub_offtimecat_id" <cfif not len(get_offtime.sub_offtimecat_id) or get_offtime.sub_offtimecat_id eq 0> style="display:none"</cfif>>
                            <cfset setup_offtime = createObject("component","V16.settings.cfc.setup_offtime")>
                            <cfset get_sub_offtime = setup_offtime.get_setupofftime(upper_offtimecat_id : get_offtime.offtimecat_id)>
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49193.Alt Kategori'></label>
                            <div class="col col-8 col-xs-12"> 
                                <select name="sub_offtimecat_id" id="sub_offtimecat_id" style="width:188px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_sub_offtime">
                                        <option value="#offtimecat_id#"<cfif get_offtime.sub_offtimecat_id eq offtimecat_id> selected</cfif>>#offtimecat#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <!--- Kısa Çalışma Ödeneği Hesaplama Kuralları Esma R. Uysal 23.04.2020 --->
                        <cfif isdefined("x_show_short_work") and x_show_short_work eq 1>
                            <div class="form-group" id="item-short_working_rate" <cfif not((isdefined("get_offtime.short_working_rate") and len(get_offtime.short_working_rate)) or (isdefined("get_offtime.short_working_hours") and len(get_offtime.short_working_hours)))>style="display:none"</cfif>>
                                <cfif x_show_short_rate_select eq 0>
                                    <label class="col col-4 col-xs-12">Haftalık Çalışılacak Saat</label>
                                    <div class="col col-2 col-xs-12"> 
                                        <input type="text" name="short_working_hours" id="short_working_hours" value="<cfoutput>#tlFormat(get_offtime.short_working_hours,1)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,1))">
                                    </div>
                                <cfelse>
                                    <label class="col col-4 col-xs-12">Faliyetin Kısmen Durdurulma Oranı</label>
                                    <div class="col col-2 col-xs-12"> 
                                        <select name="short_working_rate" id="short_working_rate">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="1" <cfif get_offtime.short_working_rate eq 1>selected</cfif>>1/3</option>
                                            <option value="2" <cfif get_offtime.short_working_rate eq 2>selected</cfif>>2/3</option>
                                            <option value="3" <cfif get_offtime.short_working_rate eq 3>selected</cfif>>3/3</option>
                                            <option value="4" <cfif get_offtime.short_working_rate eq 4>selected</cfif>>1/2</option>
                                        </select>
                                    </div>
                                </cfif>
                                <label class="col col-4 col-xs-12">İlk hafta gerçek maaş üzerinden hesaplansın mı?</label>
                                <div class="col col-2 col-xs-12"> 
                                    <select name="first_week_calculation" id="first_week_calculation">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="1" <cfif get_offtime.first_week_calculation eq 1>selected</cfif>>Evet</option>
                                        <option value="0" <cfif get_offtime.first_week_calculation eq 0>selected</cfif>>Hayır</option>
                                    </select>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-offtime_deserve_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53623.İzin Hakediş Tarihi'></label>
                            <div class="col col-8 col-xs-12"> 
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id ='53623.İzin Hakediş Tarihi'></cfsavecontent>
                                    <cfif len(get_offtime.deserve_date)>
                                        <cfinput type="text" name="offtime_deserve_date" id="offtime_deserve_date"  value="#dateformat(get_offtime.deserve_date,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                    <cfelse>
                                        <cfinput type="text" name="offtime_deserve_date" id="offtime_deserve_date"  value="" validate="#validate_style#" message="#message#" maxlength="10">
                                    </cfif>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="offtime_deserve_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-startdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'>*</label>
                            <div class="col col-8 col-xs-12"> 
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                        <cfinput type="text" name="startdate" id="startdate"  value="#dateformat(start_,dateformat_style)#" validate="#validate_style#" message="#message#" required="yes" maxlength="10">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate" call_function="shift_control" call_parameter="1"></span>	
                                    </div>
                                </div>
                                <div class="col col-2 col-xs-12">
                                    <cf_wrkTimeFormat name="start_clock" value="#timeformat(start_,'HH')#">
                                </div>
                                <div class="col col-2 col-xs-12">
                                    <select name="start_minute" id="start_minute">
                                        <cfloop from="0" to="59" index="a" step="1">
                                            <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(start_,'MM') eq a> selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-finishdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                        <cfinput type="text" name="finishdate" id="finishdate"  value="#dateformat(end_,dateformat_style)#" validate="#validate_style#" message="#message#" required="yes" maxlength="10">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate" call_function="shift_control" call_parameter="2"></span>	
                                    </div>	
                                </div> 
                                <div class="col col-2 col-xs-12">
                                    <cf_wrkTimeFormat name="finish_clock" value="#timeformat(end_,'HH')#">
                                </div>
                                <div class="col col-2 col-xs-12">
                                    <select name="finish_minute" id="finish_minute">
                                        <cfloop from="0" to="59" index="a" step="1">
                                            <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(end_,'MM') eq a> selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                        </cfloop>
                                    </select> 
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-work_startdate">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53034.İşe Başlama'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='53034.İşe Başlama'></cfsavecontent>
                                        <cfinput type="text" name="work_startdate" id="work_startdate"  value="#dateformat(work_start_,dateformat_style)#" validate="#validate_style#" message="#message#" required="yes" maxlength="10">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="work_startdate" call_function="shift_control" call_parameter=""></span>
                                    </div>
                                </div>			
                                <div class="col col-2 col-xs-12">
                                    <cf_wrkTimeFormat name="work_start_clock" value="#timeformat(work_start_,'HH')#">
                                </div>
                                <div class="col col-2 col-xs-12">
                                    <select name="work_start_minute" id="work_start_minute">
                                        <cfloop from="0" to="59" index="a" step="1">
                                            <cfoutput><option value="#Numberformat(a,00)#" <cfif timeformat(work_start_,'MM') eq a> selected</cfif>>#Numberformat(a,00)#</option></cfoutput>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-tel_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53035.İzinde Ulaşılacak Telefon'></label>
                            <div class="col col-8 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57499.Telefon'></cfsavecontent>
                                <div class="col col-6 col-xs-12">
                                    <cfinput type="text" value="#get_offtime.tel_no#" name="tel_no" id="tel_no" style="width:137px;" validate="integer" message="#message#">
                                </div>
                                <div class="col col-6 col-xs-12">
                                    <!--- BURAYI NASIL YAPICAZ --->
                                    <cfinput type="text" value="#get_offtime.tel_code#" name="tel_code" id="tel_code" style="width:48px;" validate="integer" message="#message#">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-address">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53036.İzinde Geçirilecek Adres'></label>
                            <div class="col col-8 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                                <textarea name="address" id="address" style="width:188px;height:60px;" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_offtime.address#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12"> 
                                <textarea name="detail" id="detail" style="width:188px;height:60px;" rows="2"><cfoutput>#get_offtime.detail#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-document" class="item-document">
                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='279.Dosya'></label>
                            <div class="col col-8 col-xs-12">                              
                                <input type="file" name="template_file" id="template_file" value="<cfoutput>#get_offtime.file_name#</cfoutput>" onchange="checkExDocument()">
                                <cfif (isDefined("get_offtime.file_name") and (len(get_offtime.file_name)))>
                                    <a href="javascript://" onclick="windowopen('<cfoutput>/documents/hr/offtime/#get_offtime.file_name#</cfoutput>','medium');"><cf_get_lang dictionary_id='843.Yüklü Dosyayı Görüntüle'></a>
                                </cfif>
                                <input type="hidden" name="ex_doc_name" id="ex_doc_name" value="<cfoutput>#get_offtime.file_name#</cfoutput>">
                                <input type="hidden" name="doc_req" id="doc_req" value="<cfoutput>#get_offtime.is_document_required#</cfoutput>">
                            </div>
                        </div>
                        <cfif len(get_offtime.validator_position_code_1)>
                            <div class="form-group" id="item-validator_position_code_1">
                                <label class="col col-4 col-xs-12">1.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <cfif len(get_offtime.validator_position_code_1) and not len(get_offtime.valid_1)>
                                            <cfquery name="Get_Offtime_Valid" datasource="#dsn#">
                                                SELECT
                                                    O.EMPLOYEE_ID,
                                                    EP.POSITION_CODE
                                                FROM
                                                    OFFTIME O,
                                                    EMPLOYEE_POSITIONS EP
                                                WHERE
                                                    O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
                                                    O.VALID = 1 AND
                                                    #Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
                                            </cfquery>
                                            <cfset offtime_pos_code_list = valuelist(Get_Offtime_Valid.position_code)>
                                            <cfset extra_pos_code = ''>
                                            <cfif listfind(offtime_pos_code_list,get_offtime.validator_position_code_1)>
                                                <!--- Eğer 1.amir izindeyse 1.amirin yedekleri bulunuyor --->
                                                <cfquery name="Get_StandBy_Position_Other_Offtime" datasource="#dsn#">
                                                    SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 ,CANDIDATE_POS_3 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE = #get_offtime.validator_position_code_1#
                                                </cfquery>
                                                <cfif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1)>
                                                    <cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1>
                                                <cfelseif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2)>
                                                    <cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2>
                                                <cfelseif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2)>
                                                    <cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2>
                                                </cfif>
                                            </cfif>
                                            <cfoutput>#get_emp_info(get_offtime.validator_position_code_1,1,0)# <cfif len(extra_pos_code)>- #get_emp_info(extra_pos_code,1,0)#</cfif></cfoutput> <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>!
                                        <cfelseif len(get_offtime.validator_position_code_1) and len(get_offtime.valid_1) and get_offtime.valid_1 eq 1>
                                            <cfoutput>#get_emp_info(get_offtime.validator_position_code_1,1,0)#</cfoutput> <cf_get_lang dictionary_id='58699.Onaylandı'>
                                        <cfelseif len(get_offtime.validator_position_code_1) and len(get_offtime.valid_1) and get_offtime.valid_1 eq 0>
                                            <cfoutput>#get_emp_info(get_offtime.validator_position_code_1,1,0)#</cfoutput> <cf_get_lang dictionary_id ='57617.Reddedildi'>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                        <cfif len(get_offtime.validator_position_code_2)>
                            <div class="form-group" id="item-validator_position_code_2">
                                <label class="col col-4 col-xs-12">2.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <cfif len(get_offtime.validator_position_code_2) and not len(get_offtime.valid_2)>
                                        <cfquery name="Get_Offtime_Valid" datasource="#dsn#">
                                            SELECT
                                                O.EMPLOYEE_ID,
                                                EP.POSITION_CODE
                                            FROM
                                                OFFTIME O,
                                                EMPLOYEE_POSITIONS EP
                                            WHERE
                                                O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
                                                O.VALID = 1 AND
                                                #Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
                                        </cfquery>
                                        <cfset offtime_pos_code_list = valuelist(Get_Offtime_Valid.position_code)>
                                        <cfset extra_pos_code = ''>
                                        <cfif listfind(offtime_pos_code_list,get_offtime.validator_position_code_2)>
                                            <!--- Eğer 1.amir izindeyse 1.amirin yedekleri bulunuyor --->
                                            <cfquery name="Get_StandBy_Position_Other_Offtime" datasource="#dsn#">
                                                SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 ,CANDIDATE_POS_3 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE = #get_offtime.validator_position_code_2#
                                            </cfquery>
                                            <cfif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1)>
                                                <cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_1>
                                            <cfelseif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2)>
                                                <cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2>
                                            <cfelseif len(Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2) and not listfind(offtime_pos_code_list,Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2)>
                                                <cfset extra_pos_code = Get_StandBy_Position_Other_Offtime.CANDIDATE_POS_2>
                                            </cfif>
                                        </cfif>
                                        <cfoutput>#get_emp_info(get_offtime.validator_position_code_2,1,0)# <cfif len(extra_pos_code)>- #get_emp_info(extra_pos_code,1,0)#</cfif></cfoutput> <cf_get_lang dictionary_id='57615.Onay Bekliyor'> !
                                    <cfelseif len(get_offtime.validator_position_code_2) and len(get_offtime.valid_2) and get_offtime.valid_2 eq 1>
                                        <cfoutput>#get_emp_info(get_offtime.validator_position_code_2,1,0)#</cfoutput> <cf_get_lang dictionary_id='58699.Onaylandı'>
                                    <cfelseif len(get_offtime.validator_position_code_2) and len(get_offtime.valid_2) and get_offtime.valid_2 eq 0>
                                        <cfoutput>#get_emp_info(get_offtime.validator_position_code_2,1,0)#</cfoutput> <cf_get_lang dictionary_id='57617.Reddedildi'>
                                    </cfif>
                                </div>
                            </div>
                        </cfif>
                        <cfif len(get_offtime.valid)>
                            <div class="form-group" id="item-validate_status">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53042.Onay Durumu'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <cfif get_offtime.valid EQ 1 and len(get_offtime.validdate)>
                                        <cf_get_lang dictionary_id='58699.Onaylandı'> !
                                        <cfoutput>
                                        #get_emp_info(get_offtime.VALID_EMPLOYEE_ID,0,0)# 
                                        #dateformat(date_add('h',session.ep.time_zone,get_offtime.validdate),dateformat_style)#
                                        (#timeformat(date_add('h',session.ep.time_zone,get_offtime.validdate),timeformat_style)#)
                                        </cfoutput>
                                    <cfelseif get_offtime.valid EQ 0 and len(get_offtime.validdate)>
                                        <cf_get_lang dictionary_id='57617.Reddedildi'>!
                                        <cfoutput>#get_emp_info(get_offtime.VALID_EMPLOYEE_ID,0,0)#
                                        #dateformat(date_add('h',session.ep.time_zone,get_offtime.validdate),dateformat_style)#
                                        (#timeformat(date_add('h',session.ep.time_zone,get_offtime.validdate),timeformat_style)#)
                                        </cfoutput>
                                    </cfif>
                                </div>
                            </div>
                        </cfif>
                        <cfif get_offtime.IS_ADDED_OFFTIME eq 1>
                            <div class="form-group" id="item-cant_edit">
                                <label class="col col-12"><font color="red"><cf_get_lang dictionary_id ='53996.Bu İzin Başka Bir İzne Dönüştürüldüğü İçin Güncelleme Yapamazsınız'>!</font></label>
                            </div>
                        </cfif>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6"><cf_record_info query_name="get_offtime"></div>
                    <div class="col col-6">
                        <cfif not get_offtime.IS_ADDED_OFFTIME eq 1>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='53997.Kayıtlı İzini Siliyorsunuz Emin misiniz'></cfsavecontent>
                            <cf_workcube_buttons is_upd='1' add_function='check()' delete_alert='#message#'>
                        </cfif>	
                    </div> 
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
    <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
        <cf_box>
            <cfoutput query="empInformations">
                <div class="who_item_detail">
                    <div class="who_item_detail_img">
                        <cfif len(PHOTO)>
                            <img src="/documents/hr/#PHOTO#" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#">
                        <cfelseif SEX eq 1>
                            <img src="/images/maleicon.jpg" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#">
                        <cfelse>
                            <img src="/images/femaleicon.jpg" title="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#">
                        </cfif>
                    </div>	
                    <div class="who_item_detail_text">
                        <p>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</p>
                        <p><b><cf_get_lang dictionary_id='58497.Pozisyon'>  : </b>#POSITION_NAME#</p>
                        <p><b><cf_get_lang dictionary_id='57572.Departman'>  : </b>#DEPARTMENT_HEAD#</p>					
                    </div>
                </div>
            </cfoutput>
        </cf_box>
        <cf_box title="#getLang('contract',344,'İzin Hakedişleri')# - #session.ep.period_year#" closable="0" collapsable="0">
            <cfinclude  template="../../../myhome/display/offtimes_dashboard.cfm">
        </cf_box>
    </div>
    <script type="text/javascript">
    // Eski dosya kontrol
    function checkExDocument(){
        document.getElementById("ex_doc_name").value = '';
    }
    //Vardiya kontrolu 15.09.2020 Esma R. Uysal
    function shift_control(type)
    {
        if($("#employee_name").val() == '')
        {
            alert("<cf_get_lang dictionary_id = '56320.Lütfen Çalışan Giriniz'>");
            return false;
        }
        if(type == 1)
            start_date = $("#startdate").val();
        else if(type == 2)
            start_date = $("#finishdate").val();
        else
            start_date = $("#work_startdate").val();
        employee_id = $("#employee_id").val();
        $.ajax({ 
                type:'POST',  
                url:'V16/hr/cfc/get_employee_shift.cfc?method=get_emp_shift_json',  
                data: { 
                start_date : start_date,
                finish_date : start_date,
                employee_id : employee_id
                },
                success: function (returnData) {  
                    var jData = JSON.parse(returnData); 
                    if(jData['DATA'].length != 0)
                    {
                        if(type == 1)
                        {
                            if(jData['DATA'][0][0] < 10)
                                start_val = '0'+jData['DATA'][0][0];
                            else
                                start_val = jData['DATA'][0][0];
                            if(jData['DATA'][0][2] < 10)
                                start_min = '0'+jData['DATA'][0][2];
                            else
                                start_min = jData['DATA'][0][2];
                            $("#start_clock").val(start_val);
                            $("#start_minute").val(start_min);
                        }
                        else if(type == 2){
                            if(jData['DATA'][0][1] < 10)
                                finish_val = '0'+jData['DATA'][0][1];
                            else
                                finish_val = jData['DATA'][0][1];
                            
                            if(jData['DATA'][0][3] < 10)
                                finish_min = '0'+jData['DATA'][0][3];
                            else
                                finish_min = jData['DATA'][0][3];
                            $("#finish_clock").val(finish_val);
                            $("#finish_minute").val(finish_min);
                        }
                        else{
                            if(jData['DATA'][0][0] < 10)
                                start_val = '0'+jData['DATA'][0][0];
                            else
                                start_val = jData['DATA'][0][0];
                            if(jData['DATA'][0][2] < 10)
                                start_min = '0'+jData['DATA'][0][2];
                            else
                                start_min = jData['DATA'][0][2];
                            $("#work_start_clock").val(start_val);
                            $("#work_start_minute").val(start_min);
                        }	
                    }
                    else{
                        if(type == 1)
                        {
                            $("#start_clock").val('<cfoutput>#start_hour_info#</cfoutput>');
                            $("#start_minute").val('<cfoutput>#start_min_info#</cfoutput>');
                        }
                        else if(type == 2)
                        {
                            $("#finish_clock").val('<cfoutput>#finish_hour_info#</cfoutput>');
                            $("#finish_minute").val('<cfoutput>#finish_min_info#</cfoutput>');
                        }
                        else
                        {
                            $("#work_start_clock").val('<cfoutput>#work_start_hour_info#</cfoutput>');
                            $("#work_start_minute").val('<cfoutput>#work_start_min_info#</cfoutput>');
                        }
                    }				
                },
                error: function () 
                {
                    console.log('CODE:1 please, try again..');
                    return false; 
                }
        }); 
    }
    function check()
    {
        if(($("#doc_req").val() == 1) && $("#ex_doc_name").val() == ""){
                // belge ekleme zorunluluğu kontrolü
                if($("#template_file").val() == ""){
                    alert("<cf_get_lang_main no='59.Eksik Veri'> : " + "Belge Zorunludur");	
                    return false
                }
            }
        <cfif isdefined("x_show_short_work") and x_show_short_work eq 1 and x_show_short_rate_select eq 0>
            document.getElementById("short_working_hours").value=filterNum(document.getElementById("short_working_hours").value);
        </cfif>
        emp_id = $('#employee_id').val();
        if (document.getElementById('employee_id').value.length == 0)
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57576.Çalışan'>");
            return false;
        }
        if ($('#offtimecat_id').val().length == 0)
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57486.Kategori'>");
            return false;
        }
        <cfif not len(get_offtime.valid)>
        if (document.getElementById('validator_position_code') != undefined )
        {
            if(document.getElementById('validator_position_code').value.length == 0)
            {
                alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='53995.Onaylayacak'>");
                return false;
            }
        }
        </cfif>
        
        if ((offtime_request.startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
            if(!time_check(offtime_request.startdate,offtime_request.start_clock,offtime_request.start_minute,offtime_request.finishdate,offtime_request.finish_clock,offtime_request.finish_minute,"<cf_get_lang dictionary_id ='54148.Başlangıç Tarihi Bitiş Tarihinden Küçük olmalıdır'> !")) return false;
        
        if ((offtime_request.work_startdate.value.length != 0) && (offtime_request.finishdate.value.length != 0))
        {
        
            tarih1_ = offtime_request.finishdate.value.substr(6,4) + offtime_request.finishdate.value.substr(3,2) + offtime_request.finishdate.value.substr(0,2);
            tarih2_ = offtime_request.work_startdate.value.substr(6,4) + offtime_request.work_startdate.value.substr(3,2) + offtime_request.work_startdate.value.substr(0,2);
            
            if (offtime_request.finish_clock.value.length < 2) saat1_ = '0' + offtime_request.finish_clock.value; else saat1_ = offtime_request.finish_clock.value;
            if (offtime_request.finish_minute.value.length < 2) dakika1_ = '0' + offtime_request.finish_minute.value; else dakika1_ = offtime_request.finish_minute.value;
            if (offtime_request.work_start_clock.value.length < 2) saat2_ = '0' + offtime_request.work_start_clock.value; else saat2_ = offtime_request.work_start_clock.value;
            if (offtime_request.work_start_minute.value.length < 2) dakika2_ = '0' + offtime_request.work_start_minute.value; else dakika2_ = offtime_request.work_start_minute.value;
        
            tarih1_ = tarih1_ + saat1_ + dakika1_;
            tarih2_ = tarih2_ + saat2_ + dakika2_;
            
            if (tarih1_ > tarih2_) 
            {
                alert("<cf_get_lang dictionary_id='54628.İşe Başlama Tarihi İzin Bitiş Tarihinden Küçük olmamalıdır'> !");
                offtime_request.work_startdate.focus();
                return false;
            }
        }	
        return process_cat_control();
    }
        function change_puantaj(i)
        {
            if(i == 1)
                $("#is_puantaj_off").attr("checked",true);
            else
                $("#is_puantaj_off").attr("checked",false);
        }
        function sub_category(){//Alt Kategori 20191009ERU
            up_catid = $('#offtimecat_id').val();
            $('#sub_offtimecat_id').empty();
            $.ajax({ 
                type:'POST',  
                url:'V16/settings/cfc/setup_offtime.cfc?method=get_sub_setupofftime',  
                data: { 
                upper_offtimecat_id: up_catid,
                is_myhome:1
                },
                success: function (returnData) {  // alt kategori varsa burası çalışacak
                        var jData = JSON.parse(returnData);  
                        if(jData['DATA'].length != 0){
                            document.getElementById("item-sub_offtimecat_id").style.display='';
                            $("#doc_req").val(0);
                        }else{ // alt kategori yoksa burası çalışacak
                            document.getElementById("item-sub_offtimecat_id").style.display='none';
    
                            $.ajax({ 
                                type:'POST',  
                                url:'V16/settings/cfc/setup_offtime.cfc?method=get_sub_setupofftime',  
                                data: { 
                                upper_offtimecat_id: 0
                            },
                            success: function (returnData) {  // üst kategori için belge zorunluluğunu kontrol ediyor
                                    var jData = JSON.parse(returnData);  
                                    for(var i = 0; i < jData['DATA'].length; i++){
                                        if(jData['DATA'][i][0] == up_catid){ 
                                            /*
                                                üst satır, V16\settings\cfc\setup_offtime.cfc dosyasından gelen veriye göre işlem yapıyor. 
                                                Değişiklik durumunda diğer dosyada da güncelleme yapınız.
                                            */
                                            if(jData['DATA'][i][2] == true){
                                                $("#doc_req").val(1); // belge zorunluluğu varsa input'a 1 değeri atıyor
                                            }else{
                                                $("#doc_req").val(0);
                                            }
                                        }
                                    }
                            },
                                error: function () 
                                {
                                    console.log('CODE:8 please, try again..');
                                    return false; 
                                }
                            }); 
    
                        }
                        $('<option>').attr({value:0})
                                .append('<cfoutput>#getLang("main",322)#</cfoutput>').appendTo('#sub_offtimecat_id');  
                        $.each( jData['DATA'], function( index ) {                       
                                $('<option>').attr({value:this[0]})
                                .append(this[1]).appendTo('#sub_offtimecat_id');       		                           
                        });
                },
                error: function () 
                {
                    console.log('CODE:8 please, try again..');
                    return false; 
                }
        });  
        //18 kısa çalışma ödeneği için Esma R. Uysal - 23.04.2020
        <cfif isdefined("x_show_short_work") and x_show_short_work eq 1>
            get_bildirge_type = wrk_safe_query('get_ebildirge_type','dsn',0,up_catid);
            if(get_bildirge_type.recordcount > 0)
            {
                document.getElementById("item-short_working_rate").style.display='';
            }else{
                document.getElementById("item-short_working_rate").style.display='none';
            }
        </cfif>
    }
    </script>
    </cfif>
    <cf_get_lang_set module_name="#fusebox.circuit#">
    