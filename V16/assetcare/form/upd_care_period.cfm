<cf_xml_page_edit fuseact="assetcare.form_add_care_period">
    <cfinclude template="../form/care_period_options.cfm">
    <cfquery name="GET_CARE" datasource="#DSN#">
        SELECT 
            CARE_STATES.CARE_ID,
            CARE_STATES.ASSET_ID,
            CARE_STATES.CARE_STATE_ID,
            CARE_STATES.DETAIL,
            CARE_STATES.PLACE,
            CARE_STATES.PERIOD_ID,
            CARE_STATES.CARE_KM,
            CARE_STATES.PERIOD_TIME,
            CARE_STATES.OFFICIAL_EMP_ID,
            CARE_STATES.CARE_DAY,
            CARE_STATES.CARE_HOUR,
            CARE_STATES.CARE_MINUTE,
            CARE_STATES.STATION_ID,
            CARE_STATES.OUR_COMPANY_ID,
            ASSET_P.ASSETP,
            ASSET_P.ASSETP_ID,
            ASSET_CARE_CAT.ASSET_CARE,
            ASSET_CARE_CAT.IS_YASAL,
            CARE_STATES.PROCESS_STAGE,
            CARE_STATES.RECORD_EMP,
            CARE_STATES.UPDATE_EMP,
            CARE_STATES.RECORD_DATE,
            CARE_STATES.UPDATE_DATE
        FROM
            CARE_STATES,
            ASSET_P,
            ASSET_CARE_CAT
        WHERE
            CARE_ID = #attributes.care_id# AND
            ASSET_P.ASSETP_ID = CARE_STATES.ASSET_ID AND
            CARE_STATES.CARE_STATE_ID = ASSET_CARE_CAT.ASSET_CARE_ID
    </cfquery>
    <cfquery name="get_asset_report" datasource="#dsn#">
        SELECT CARE_REPORT_ID FROM ASSET_CARE_REPORT WHERE CARE_ID = #attributes.care_id#
    </cfquery>
    <cfquery name="get_asset_care_cat" datasource="#dsn#">
        SELECT 
            ACC.ASSET_CARE_ID, 
            ACC.ASSET_CARE,
            ACC.IS_YASAL
        FROM 
            ASSET_CARE_CAT ACC, 
            ASSET_P A 
        WHERE 
            <cfif len(get_care.asset_id)>A.ASSETP_ID = #get_care.asset_id#</cfif>
            <cfif len(get_care.is_yasal)>AND ACC.IS_YASAL = #get_care.is_yasal# AND</cfif>
            A.ASSETP_CATID = ACC.ASSETP_CAT
    </cfquery>
    <cfif get_care.is_yasal eq 1>
        <cfset son_deger=1>
    <cfelse>
        <cfset son_deger=0>
    </cfif>
     <cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfform name="upd_care" method="post"action="#request.self#?fuseaction=assetcare.emtypopup_upd_care_period" onsubmit="return(unformat_fields());">
            <cf_box>
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <input type="hidden" name="care_id" id="care_id" value="<cfoutput>#get_care.care_id#</cfoutput>">
                        <input type="hidden" name="failure_id" id="failure_id" value="<cfif isdefined("attributes.failure_id")><cfoutput>#attributes.failure_id#</cfoutput></cfif>">
                        <input type="hidden" name="is_detail" id="is_detail"  value="1">
                        <div class="form-group" id="item-assetp_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cfif xml_add_care_asset eq 0>
                                    <cf_get_lang dictionary_id='57420.Varlıklar'>
                                    <cfelseif xml_add_care_asset eq 1>
                                        <cf_get_lang dictionary_id='32654.IT Varlıklar'>
                                    <cfelseif xml_add_care_asset eq 2>
                                        <cf_get_lang dictionary_id='30004.Fiziki Varlıklar'>
                                    <cfelseif xml_add_care_asset eq 3>
                                        <cf_get_lang dictionary_id='57414.Araçlar'>
                                </cfif>
                            </label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_wrkAssetp asset_id="#get_care.asset_id#" fieldId='assetp_id' fieldName='assetp_name' form_name='upd_care' xmlvalue='#xml_add_care_asset#'>
                            </div>
                        </div>
                        <div class="form-group" id="item-care_type">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33171.Bakım Tipi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="care_type_id" id="care_type_id" value="<cfif isdefined("get_care.care_state_id") and len(get_care.care_state_id)><cfoutput>#get_care.care_state_id#</cfoutput></cfif>">
                                    <input type="text" name="care_type" id="care_type" <cfif not isdefined("get_care.asset_care")>readonly </cfif> value="<cfif isdefined("get_care.asset_care") and len(get_care.asset_care)><cfoutput>#get_care.asset_care#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id='33171.Bakım Tipi'>" onClick="pencere_ac();"></span>
                                </div>
                           </div>
                        </div>
                        <div class="form-group" id="item-care_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30631.Tarih'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="care_date" id="care_date" value="<cfif len(get_care.period_time)><cfoutput>#dateformat(get_care.period_time,dateformat_style)#</cfoutput></cfif>">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="care_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-official_emp_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44021.Görevli'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                               <div class="input-group">
                                    <input type="hidden" name="official_emp_id" id="official_emp_id" value="<cfoutput>#get_care.official_emp_id#</cfoutput>">
                                    <input type="text" name="official_emp" id="official_emp" value="<cfif len(get_care.official_emp_id)><cfoutput>#get_emp_info(get_care.official_emp_id,0,0)#</cfoutput></cfif>" onFocus="AutoComplete_Create('official_emp','MEMBER_NAME,MEMBER_ID','MEMBER_NAME,MEMBER_ID','get_member_autocomplete','3','EMPLOYEE_ID','official_emp_id','','3','125');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id='44021.Görevli'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=upd_care.official_emp_id&field_name=upd_care.official_emp');"></span>
                               </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-care_type_period">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32691.Periyot'>/<cf_get_lang dictionary_id='29513.Süre'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="care_type_period" id="care_type_period">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                       <cfloop array = "#period_list#" index="my_period_data">
                                           <cfoutput>
                                                   <option value="#my_period_data[1]#" <cfif get_care.period_id eq #my_period_data[1]#>selected</cfif>>#my_period_data[2]#</option>
                                           </cfoutput>
                                       </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-care_km_period">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32691.Periyot'> / <cf_get_lang dictionary_id='48157.Km'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input name="care_km_period" id="care_km_period" type="text" value="<cfoutput>#tlformat(get_care.care_km)#</cfoutput>" onKeyUp="FormatCurrency(this,event);">
                            </div>
                        </div>
                        <div class="form-group" id="item-gun_saat_dakika">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29513.Süre'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>
                                    <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                                        <select name="gun" id="gun">
                                            <option value=""><cf_get_lang dictionary_id='57490.Gün'></option>
                                            <cfloop from="1" to="31" index="i">
                                                <option value="#i#" <cfif get_care.care_day eq i>selected</cfif>>#NumberFormat(i,'00')#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                    <div class="col col-5 col-md-5 col-sm-5 col-xs-12">
                                        <select name="saat" id="saat">
                                            <option value=""><cf_get_lang dictionary_id='57491.Saat'></option>
                                            <cfloop from="0" to="23" index="i">
                                                <option value="#i#" <cfif get_care.care_hour eq i>selected</cfif>>#NumberFormat(i,'00')#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                        <select name="dakika" id="dakika">
                                            <option value=""><cf_get_lang dictionary_id='58827.Dk'></option>
                                            <cfloop from="0" to="55" index="i" step="5">
                                                <option value="#i#" <cfif get_care.care_minute eq i>selected</cfif>>#NumberFormat(i,'00')#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item_place">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60371.Mekan'></label>
                            <div class="col col-8 col-xs-12">
                                <input name="place" id="place" type="text" value="<cfoutput>#get_care.place#</cfoutput>">
                            </div>
                        </div>
                        <div class="form-group" id="item-station_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58834.İstasyon'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="hidden" name="station_id" id="station_id" <cfif isDefined("get_care.station_id") and len(get_care.station_id)>VALUE="<cfoutput>#get_care.station_id#</cfoutput>"</cfif>>
                                <input type="hidden" name="station_company_id" id="station_company_id" value="<cfoutput>#get_care.our_company_id#</cfoutput>">
                               <div class="input-group">
                                    <cfif LEN(get_care.STATION_ID)>
                                        <cfquery name="GET_STATION" datasource="#dsn3#">
                                           SELECT STATION_ID, STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = #get_care.STATION_ID#
                                        </cfquery>
                                        <input type="text" name="station_name" id="station_name" value="<cfoutput>#get_station.station_name#</cfoutput>">
                                    <cfelse>
                                        <input type="text" name="station_name" id="station_name" value="">
                                    </cfif>
                                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=prod.popup_list_workstation&field_name=upd_care.station_name&field_id=upd_care.station_id&field_comp_id=upd_care.station_company_id</cfoutput>')"></span>
                               </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-surec">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_workcube_process is_upd='0' select_value='#get_care.process_stage#' is_detail='1' >
                            </div>
                        </div>
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="detail" id="detail"><cfoutput>#get_care.detail#</cfoutput></textarea>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_record_info query_name='get_care'>
                    <cfif get_asset_report.recordcount>
                        <cf_workcube_buttons is_upd='1' is_delete='0'>
                    <cfelse>
                        <cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url="#request.self#?fuseaction=assetcare.emptypopup_del_asset_report&care_id=#attributes.care_id#">
                    </cfif>
                </cf_box_footer>
            </cf_box>
        </cfform>
        <cfif len(get_care.station_id)>
            <cf_box id="rel_phy_asset" title="#getLang('','İlişkili Fiziki Varlıklar','36950')#" box_page="#request.self#?fuseaction=assetcare.emptypopup_ajax_dsp_physical_assets&station_id=#get_care.station_id#" closable="0" style="width:99%;">
            </cf_box>
        </cfif>
        <cfset attributes.asset_id = get_care.assetp_id>
        <cfset attributes.asset = get_care.assetp>
        <cf_box id="list_member_rel" title="#getLang('','Bileşenler','35700')#" closable="0" style="width:99%;" box_page="#request.self#?fuseaction=assetcare.emptypopup_relation_phsical_asset&asset_id=#attributes.asset_id#&assetp=#attributes.asset#&hide_img=1">
        </cf_box>
         <!--- Bakım Sonucu --->
     <cf_get_assetcare_report action_section='asset_id' action_id='#attributes.care_id#' head="#getLang('assetcare',34)#" care_id='1' width='width:99%'><br/>
    </div>
    
    <script type="text/javascript">
        function unformat_fields()
        {
            if(document.upd_care.care_km_period != undefined) document.upd_care.care_km_period.value = filterNum(document.upd_care.care_km_period.value);
            return process_cat_control();
        }
        
        function pencere_ac()
        {
            
            assetp_id_ = $('#assetp_id').val();
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_care_type&field_id=upd_care.care_type_id&field_name=upd_care.care_type&asset_id=' + assetp_id_+ '&is_yasal=' + <cfoutput>#son_deger#</cfoutput> ,'list','popup_list_care_type');
        }
    
        
        function degistir_care_type()
        {
             // bakim tipinde select box ozelligi kaldirilip opup eklendi. fonksiyon ici kappatildi. sorun olmadigi takdirde 6 aya kdr silinsin. 20141020 
            
            /*for(j=document.getElementById("care_type_id").length; j>=0; j--)
                document.getElementById("care_type_id").options[j] = null;
            var get_care_type_id = wrk_query("SELECT ACC.ASSET_CARE_ID, ACC.ASSET_CARE FROM ASSET_CARE_CAT ACC, ASSET_P A WHERE A.ASSETP_ID = " + document.getElementById("assetp_id").value + " AND ACC.IS_YASAL = <cfoutput>#get_care.is_yasal#</cfoutput> AND A.ASSETP_CATID = ACC.ASSETP_CAT","dsn");
            if(get_care_type_id.recordcount != 0)
            {
                document.getElementById("care_type_id").options[0]=new Option('Seçiniz','');
                for(var jj=0;jj < get_care_type_id.recordcount; jj++)
                    document.getElementById("care_type_id").options[jj+1]=new Option(get_care_type_id.ASSET_CARE[jj],get_care_type_id.ASSET_CARE_ID[jj]);
            }
            else
                document.getElementById("care_type_id").options[0]=new Option('Seçiniz','');*/
        }
    </script>
    