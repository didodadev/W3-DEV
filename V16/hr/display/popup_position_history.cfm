<cfinclude template="../query/get_position_history.cfm">
<cf_box title="#getLang('','Tarihçe',57473)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfset title_list = "">
    <cfif get_pos_history.recordcount>
        <cfset temp_ = 0>
        <cfoutput query="get_pos_history">
            <cfset temp_ = temp_ +1>
            <cf_seperator id="history_#temp_#" header="#dateformat(record_date,dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#) - #record_name#" is_closed="1">
            <cf_box_elements id="history_#temp_#" style="display:none;">
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57501.Başlama'></label>
                        <div class="col col-8 col-xs-12">
                            #dateformat(start_date,dateformat_style)#
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57502.Bitiş'></label>
                        <div class="col col-8 col-xs-12">
                            #dateformat(finish_date,dateformat_style)#
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                        <div class="col col-8 col-xs-12">
                            #employee_name# #employee_surname#
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='55266.Yetki Durumu'></label>
                        <div class="col col-8 col-xs-12">
                            #user_group_name#
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57500.Onay'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif valid EQ 0>
                                <cf_get_lang dictionary_id='57617.Reddedildi'>
                            <cfelseif valid eq 2>
                                <cf_get_lang dictionary_id='58699.Onaylandı'>
                            <cfelseif valid eq 1>
                                <cf_get_lang dictionary_id='57615.Onay Bekliyor'>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='55260.Onaylayan'></label>
                        <div class="col col-8 col-xs-12">
                            #valid_member_name#
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='55839.Onay T.'></label>
                        <div class="col col-8 col-xs-12">
                            <cfif len(valid_date)>#dateformat(valid_date,dateformat_style)#</cfif>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57574.şirket'></label>
                        <div class="col col-8 col-xs-12">
                            #nick_name#
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57453.şube'></label>
                        <div class="col col-8 col-xs-12">
                            #branch_name#
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-8 col-xs-12">
                            #department_head#
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                        <div class="col col-8 col-xs-12">
                            #position_name#
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            #position_cat#
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                        <div class="col col-8 col-xs-12">
                            #title#
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='55550.Gerekçe'></label>
                        <div class="col col-8 col-xs-12">
                            #reason#
                        </div>
                    </div>
                </div>
            </cf_box_elements>
        </cfoutput>
    </cfif>
</cf_box>
