<cfparam name="attributes.cutplan_id" default="#attributes.id#">
<cfobject name="cutplan" component="WBP.Fashion.files.cfc.cutplan">
<cfobject name="measure" component="WBP.Fashion.files.cfc.measure">
<cfobject name="stretchingtest" component="WBP.Fashion.files.cfc.stretching_test">
<cfset cuthead = cutplan.get_cutplan(attributes.cutplan_id)>
<cfset stestgroup = stretchingtest.get_stretching_test_groups(cuthead.stretching_test_id)>
<cfset qsizes = cutplan.get_stock_property(cuthead.ORDER_ID)>
<cfset cutrows = cutplan.get_cutplan_rows(attributes.cutplan_id)>
<cfset cutsizes = cutplan.get_cutplan_sizes(attributes.cutplan_id)>
<cf_catalystHeader>
    <div style="clear: both"></div>
<cfif isDefined("cuthead.req_id") and len(cuthead.req_id)>
<cfset attributes.req_id = cuthead.req_id>
<!---künye numune özet--->
<cfinclude template="../query/get_req.cfm">
<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_sample_request");
	getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.req_id#,action_section:'REQ_ID');
</cfscript>
<!---künye numune özet--->
<div class="row">
    <cf_box id="sample_request" closable="0" unload_body = "1"  title="Numune Özet" >
        <div class="col col-10 col-xs-12 ">
            <cfinclude template="../../common/get_opportunity_type.cfm">
            <cfinclude template="../display/dsp_sample_request.cfm">
        </div>
        <div class="col col-2 col-xs-2">
            <cfinclude template="../../objects/display/asset_image.cfm">
        </div>
    </cf_box>
</div>
<div style="clear: both"></div>
</cfif>

<div id="cutplaning">
    <cfform name="cutplan" method="post">
        <input type="hidden" name="cutplan_id" value="<cfoutput>#attributes.cutplan_id#</cfoutput>">
        <div class="portBox portBottom">
            <div class="portHeadLight font-green-sharp">
                <span>Kesim Planlama Formu</span>
            </div>
            <div class="portBoxBodyStandart">
                <div style="width: 100%;">
                    <div class="row uniqueBox">
                        <div class="col col-12 uniqueRow">
                            <div class="row formContent">
                                <div class="row" type="row">
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="21" sort="true">
                                        <div class="form-group" id="item-consumer_id">
                                            <label class="col col-4 col-xs-12"><cf_get_lang_main no='45.Müşteri'></label>
                                            <div class="col col-8 col-xs-12">
                                                <div class="input-group">
                                                    <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#cuthead.COMPANY_ID#</cfoutput>">
                                                    <input type="hidden" name="member_type" id="member_type" value="">
                                                    <input name="member_name" type="text" id="member_name" style="width:110px;" value="<cfoutput>#cuthead.FULLNAME#</cfoutput>">
                                                    
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_all_pars&amp;field_consumer=cutplan.consumer_id&amp;field_comp_id=cutplan.company_id&amp;field_member_name=cutplan.member_name&amp;field_type=cutplan.member_type&amp;is_period_kontrol=0&amp;select_list=7,8&amp;keyword='+encodeURIComponent(document.cutplan.member_name.value),'list');"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-emp_id">
                                            <label class="col col-4 col-xs-12">Görevli</label>
                                            <div class="col col-8 col-xs-12">
                                                <div class="input-group">
                                                    <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#cuthead.EMP_ID#</cfoutput>">
                                                    <input type="text" name="emp_name" id="emp_name" value="<cfoutput>#cuthead.EMP_NAME#</cfoutput>">
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_positions&field_emp_id=cutplan.emp_id&field_name=cutplan.emp_name &select_list=1,2&is_form_submitted=1&keyword='+encodeURIComponent(cutplan.emp_name.value),'list');"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="22" sort="true">
                                        <div class="form-group" id="item-order_no">
                                            <label class="col col-4 col-xs-12">Sipariş No</label>
                                            <div class="col col-8 col-xs-12">
                                                <input type="hidden" name="order_id" id="order_id" value="<cfoutput>#cuthead.ORDER_ID#</cfoutput>">
                                                <input type="text" name="order_no" id="order_no" value="<cfoutput>#cuthead.ORDER_NUMBER#</cfoutput>" readonly>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-date_start">
                                            <label class="col col-4 col-xs-12">İş Başlangıç Zaman</label>
                                            <div class="col col-8 col-xs-12">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                                    <input type="text" name="date_start" id="date_start" value="<cfoutput>#dateformat(cuthead.START_DATE,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="date_start"></span>
                                                    <cfif len(cuthead.START_DATE)>
                                                        <cfset sdate=date_add("H",session.ep.time_zone,cuthead.START_DATE)>
                                                        <cfset shour=datepart("H",sdate)>
                                                        <cfset sminute=datepart("N",sdate)>
                                                    <cfelse>
                                                        <cfset sdate="">
                                                        <cfset shour="">
                                                        <cfset sminute="">                                           
                                                    </cfif>
                                                    <cfoutput>
                                                    <span class="input-group-addon">
                                                        <cf_wrkTimeFormat name="date_start_hour" value="#shour#">
                                                    </span>
                                                    <span class="input-group-addon">
                                                        <select name="date_start_minute" id="date_start_minute" style="width:38px;">
                                                            <cfloop from="0" to="59" index="sta_min">
                                                                <option value="#NumberFormat(sta_min,00)#" <cfif sta_min eq sminute>selected</cfif>>#NumberFormat(sta_min,00)#</option>
                                                            </cfloop>
                                                        </select>
                                                    </span>
                                                    </cfoutput>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="23" sort="true">
                                        <div class="form-group" id="item-process_id">
                                            <label class="col col-4 col-xs-12">Süreç</label>
                                            <div class="col col-8 col-xs-12">
                                                <cf_workcube_process is_upd='0' select_value='#cuthead.STAGE_ID#' is_detail='1'>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-date_finish">
                                            <label class="col col-4 col-xs-12">İş Bitiş Zamanı</label>
                                            <div class="col col-8 col-xs-12">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                                        <input type="text" name="date_finish" id="date_finish" value="<cfoutput>#dateformat(cuthead.FINISH_DATE,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
                                                        <span class="input-group-addon"><cf_wrk_date_image date_field="date_finish"></span>
                                                        <cfif len(cuthead.FINISH_DATE)>
                                                            <cfset sdate=date_add("H",session.ep.time_zone,cuthead.FINISH_DATE)>
                                                            <cfset shour=datepart("H",sdate)>
                                                            <cfset sminute=datepart("N",sdate)>
                                                        <cfelse>
                                                            <cfset sdate="">
                                                            <cfset shour="">
                                                            <cfset sminute="">                                           
                                                        </cfif>
                                                        <cfoutput>
                                                        <span class="input-group-addon">
                                                            <cf_wrkTimeFormat name="date_finish_hour" value="#shour#">
                                                        </span>
                                                        <span class="input-group-addon">
                                                            <select name="date_finish_minute" id="date_finish_minute" style="width:38px;">
                                                                <cfloop from="0" to="59" index="sta_min">
                                                                    <option value="#NumberFormat(sta_min,00)#" <cfif sta_min eq sminute>selected</cfif>>#NumberFormat(sta_min,00)#</option>
                                                                </cfloop>
                                                            </select>
                                                        </span>
                                                    </cfoutput>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="24" sort="true">
                                        <div class="form-group" id="item-plan_date">
                                            <label class="col col-4 col-xs-12">Tarih</label>
                                            <div class="col col-8 col-xs-12">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                                    <input type="text" name="plan_date" id="plan_date" value="<cfoutput>#dateformat( iif( len(cuthead.PLAN_DATE), de(cuthead.PLAN_DATE), de(now()) ) ,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="plan_date"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" style="margin-top: 6px;">
            <div class="col col-12 uniqueRow">
                <div class="row formContent">
                    <div class="row" type="row">
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="24" sort="true">
                            <div class="form-group" id="item-fabric_name">
                                <label class="col col-4 col-xs-12">Kumaş Adı</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="fabric_name" id="fabric_name" value="<cfoutput>#cuthead.FABRIC_NAME#</cfoutput>">
                                </div>
                            </div>
                            <div class="form-group" id="item-marker_meter">
                                <label class="col col-4 col-xs-12">Pastal Metraj</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="marker_meter" id="marker_meter" data-bind="value: self.sumOf_gross_marker_meter().toFixed(2)">
                                </div>
                            </div>
                            <div class="form-group" id="item-marker_size">
                                <label class="col col-4 col-xs-12">Pastal Boyutu</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="marker_size" id="marker_size" data-bind="value: self.planingdata.pastal_size">
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="25" sort="true">
                            <div class="form-group" id="item-plan_unit_meter">
                                <label class="col col-4 col-xs-12">Pl. Birim Metraj</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="plan_unit_meter" id="plan_unit_meter" value="<cfoutput>#cuthead.PLAN_UNIT_METER#</cfoutput>">
                                </div>
                            </div>
                            <div class="form-group" id="item-roll_count">
                                <label class="col col-4 col-xs-12">Top Sayısı</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="roll_count" id="roll_count" value="<cfoutput>#cuthead.ROLL_AMOUNT#</cfoutput>">
                                </div>
                            </div>
                            <div class="form-group" id="item-margin">
                                <label class="col col-4 col-xs-12">Marj</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="margin" id="margin" data-bind="value: self.planingdata.margin">
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="26" sort="true">
                            <div class="form-group" id="item-plan_arrive_meter">
                                <label class="col col-4 col-xs-12">Pl. Gelen Kumaş Metrajı</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="plan_arrive_meter" id="plan_arrive_meter" value="<cfoutput>#cuthead.PLAN_ARRIVAL_METER#</cfoutput>">
                                </div>
                            </div>
                            <div class="form-group" id="item-piece_count">
                                <label class="col col-4 col-xs-12">Parça Sayısı</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="piece_count" id="piece_count" value="<cfoutput>#cuthead.PIECE_COUNT#</cfoutput>">
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="27" sort="true">
                            <div class="form-group" id="item-plan_meter">
                                <label class="col col-4 col-xs-12">Pl. Metraj</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="plan_meter" id="plan_meter" value="<cfoutput>#cuthead.PLAN_METER#</cfoutput>">
                                </div>
                            </div>
                            <div class="form-group" id="item-total_piece_count">
                                <label class="col col-4 col-xs-12">Toplam Parça Sayısı</label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="total_piece_count" id="total_piece_count" value="<cfoutput>#cuthead.TOTAL_PIECE_COUNT#</cfoutput>">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
		
		
		
        <style>
            .form_list .no-cell, .form_list .no-cell:hover {
                border-color: transparent;
                background-color: transparent;
            }
            .form_list input {
                width: 100% !important;
                max-width: 100px !important;
                text-align: center;
            }
            .form_list td {
                background-color: transparent !important;
            }
        </style>
        <div class="row">
            <div class="col col-12" style="text-align: right">
                <a href="javascript:void(0)" class="label label-primary" style="color: white;" data-bind="click: function() { hiddenLeft(!hiddenLeft()); }"><i class="fa fa-arrows-h"></i><a>
            </div>
        </div>
        <div class="row">
            <div class="col col-8" data-bind="attr:{ style: hiddenLeft() ? 'display: none;' : '' }">
                <table class="form_list" style="float: right;">
                    <thead>
                        <tr>
                            <th class="no-cell">&nbsp;</th>
                            <th class="no-cell">&nbsp;&nbsp;&nbsp;</th>
                        </tr>
                        <tr>
                            <th class="no-cell">&nbsp;</th>
                            <th class="no-cell">&nbsp;&nbsp;&nbsp;</th>
                        </tr>
                        <tr>
                            <th>Sipariş Miktarı</th>
                            <td style="text-align: center;"><span data-bind="text: sumOfOrderAmounts"></span></td>
                        </tr>
                        <tr>
                            <th>Kesim Miktarı</th>
                            <td style="text-align: center;"><span data-bind="text: sumOfOrderCuts"></span></td>
                        </tr>
                        <tr>
                            <th>Fark</th>
                            <td style="text-align: center;"><span data-bind="text: sumOfOrderDiff, diffColor: sumOfOrderDiff"></span></td>
                        </tr>
                    </thead>
                </table>
            </div>
            <div data-bind="css: hiddenLeft() ? 'col col-12' : 'col col-4'" style="overflow: auto;" id="list_sizehead" onscroll="if(!window.list_vertical) { window.list_vertical=true; $('#list_sizes').scrollLeft($(this).scrollLeft()); setTimeout(function(){window.list_vertical=false}, 20); }">
                <table class="form_list" style="overflow: auto;">
                    <thead>
                        <tr data-bind="foreach: sizeHeads">
                            <th style="text-align: center;" data-bind="attr: { colspan: count }"><span data-bind="text: size"></span></th>
                        </tr>
                        <tr data-bind="foreach: ordersizes">
                            <th style="text-align: center;"><span data-bind="text: weight"></span></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr data-bind="foreach: ordersizes">
                            <td style="text-align: center;"><span data-bind="text: order_amount_margined"></span></td>
                        </tr>
                        <tr data-bind="foreach: ordersizes">
                            <td style="text-align: center;"><span data-bind="text: cut_amount"></span></td>
                        </tr>
                        <tr data-bind="foreach: ordersizes">
                            <td style="text-align: center;"><span data-bind="text: diff, diffColor: diff"></span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="row">
            <div style="max-height: 500px; overflow: auto;" data-bind="attr:{ class: hiddenLeft() ? 'col col-3' : 'col col-8' }" onscroll="if(!window.list_vertical) { window.list_vertical=true; $('#list_sizes').scrollTop($(this).scrollTop()); setTimeout(function(){window.list_vertical=false}, 20); }" id="list_main">
                <input type="hidden" name="mainlist_count" data-bind="value: mainlist().length">
                <table class="form_list">
                    <thead>
                        <tr style="height: 54px;">
                            <th>Pastal Adı</th>
                            <th data-bind="attr: { style: hiddenLeft() ? 'display: none' : 'width: 120px' }">Pastal Çıktısı</th>
                            <th style="display: none;">Kesim Adı</th>
                            <th>Pastal Boyu</th>
                            <th>Kat/Serim Sayısı</th>
                            <th data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }">Asorti Beden Adedi</th>
                            <th data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }">Net Pastal Metrajı</th>
                            <th data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }">Brüt Pastal Boyu</th>
                            <th data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }">Brüt Pastal Metrajı</th>
                            <th data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }">Birim Pastal Metrajı</th>
                            <th data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }">Verimlilik %</th>
                            <th style="display: none;">Kesimden Sonra Mtr</th>
                            <th data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }">Pastal Eni</th>
                            <th data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }">Çekme Rengi</th>
                            <th data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }">Çekme En</th>
                            <th data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }">Çekme Boy</th>
                            <th style="display: none;">Meto Rengi</th>
                            <th data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }">Kesim Adedi</th>
                            <th style="display: none;">Top Detayları</th>
                            <th><i data-bind="click: function() { self.addMainRow(); }" class="fa fa-plus"></i></th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- ko foreach: mainlist -->
                        <tr data-bind="colorline: draft_color" style="height: 40px;">
                            <td><input type="text" style="width: 100% !important; max-width: 100% !important" data-bind="value: marker_name, attr: { name: 'marker_name_' + $index(), id: 'marker_name_' + $index() }"></td>
                            <td  data-bind="attr: { style: hiddenLeft() ? 'display: none' : 'width: 120px; min-width: 120px;' }">
                                <input type="hidden" data-bind="value: marker_output, attr: { name: 'marker_output_' + $index(), id: 'marker_output_' + $index() }">
                                <input type="file" data-bind="attr: { 'data-idx': $index }" style="width: 75px !important;">
                                <a class="btn green-haze" data-bind="visible: marker_output() != '', attr: { href: '<cfoutput>/documents/</cfoutput>' + marker_output() }" target="_blank"><i class="fa fa-eye"></i></a>
                            </td>
                            <td style="display: none;"><input type="text" data-bind="value: cutplan_name, attr: { name: 'cutplan_name_' + $index(), id: 'cutplan_name_' + $index() }"></td>
                            <td><input type="text" data-bind="value: marker_height, attr: { name: 'marker_height_' + $index(), id: 'marker_height_' + $index() }"></td>
                            <td><input type="text" data-bind="value: layer_amount, attr: { name: 'layer_amount_' + $index(), id: 'layer_amount_' + $index() }"></td>
                            <td data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }"><input type="text" data-bind="value: assortment_size_amount, attr: { name: 'assortment_size_amount_' + $index(), id: 'assortment_size_amount_' + $index() }" readonly></td>
                            <td data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }"><input type="text" data-bind="value: net_marker_meter().toFixed(2), attr: { name: 'net_marker_meter_' + $index(), id: 'net_marker_meter_' + $index() }" readonly></td>
                            <td data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }"><input type="text" data-bind="value: gross_marker_height().toFixed(2), attr: { name: 'gross_marker_height_' + $index(), id: 'gross_marker_height_' + $index() }" readonly></td>
                            <td data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }"><input type="text" data-bind="value: gross_marker_meter().toFixed(2), attr: { name: 'gross_marker_meter_' + $index(), id: 'gross_marker_meter_' + $index() }" readonly></td>
                            <td data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }"><input type="text" data-bind="value: marker_unit_meter().toFixed(2), attr: { name: 'marker_unit_meter_' + $index(), id: 'marker_unit_meter_' + $index() }" readonly></td>
                            <td data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }"><input type="text" data-bind="value: productivity, attr: { name: 'productivity_' + $index(), id: 'productivity_' + $index() }"></td>
                            <td style="display: none;"><input type="text" data-bind="value: after_cut_meter, attr: { name: 'after_cut_meter_' + $index(), id: 'after_cut_meter_' + $index() }"></td>
                            <td data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }"><input type="text" data-bind="value: marker_width, attr: { name: 'marker_width_' + $index(), id: 'marker_width_' + $index() }"></td>
                            <td data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }">
                                <select data-bind="value: draft_color, attr: { name: 'draft_color_' + $index(), id: 'draft_color_' + $index() }">
                                    <option value="">SECINIZ</option>
                                    <option>SARI</option>
                                    <option>KIRMIZI</option>
                                    <option>MAVI</option>
                                    <option>MOR</option>
                                    <option>TURUNCU</option>
                                    <option>YESIL</option>
                                </select>
                            </td>
                            <td data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }"><input type="text" data-bind="value: draft_width, attr: { name: 'draft_width_' + $index(), id: 'draft_width_' + $index() }" readonly></td>
                            <td data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }"><input type="text" data-bind="value: draft_height, attr: { name: 'draft_height_' + $index(), id: 'draft_height_' + $index() }" readonly></td>
                            <td style="display: none;">
                                <select data-bind="value: meto_color, attr: { name: 'meto_color_' + $index(), id: 'meto_color_' + $index() }">
                                    <option value="">SECINIZ</option>
                                    <option>SARI</option>
                                    <option>KIRMIZI</option>
                                    <option>MAVI</option>
                                    <option>MOR</option>
                                    <option>TURUNCU</option>
                                    <option>YESIL</option>
                                </select>
                            </td>
                            <td data-bind="attr: { style: hiddenLeft() ? 'display: none' : '' }"><input type="text" data-bind="value: cut_amount, attr: { name: 'cut_amount_' + $index(), id: 'cut_amount_' + $index() }" readonly></td>
                            <td style="display: none;"><a data-bind="attr: { href: '<cfoutput></cfoutput>' }">Top Detayları</a></td>
                            <td data-bind="attr: { style: hiddenLeft() ? 'display: none' : 'text-align: center' }">
                                <i data-bind="click: function() { self.removeMainRow($data); }" class="fa fa-minus"></i>
                                <i data-bind="click: function() { self.cloneMainRow($data); }" class="fa fa-plus"></i>
                            </td>
                        </tr>
                        <!-- /ko -->
                        <!-- ko if: !hiddenLeft() -->
                        <tr>
                            <td colspan="5" style="text-align: right;">TOPLAM :</td>
                            <td style="text-align: center;"><span data-bind="text: sumOf_net_marker_meter().toFixed(2)"></span></td>
                            <td></td>
                            <td style="text-align: center;"><span data-bind="text: sumOf_gross_marker_meter().toFixed(2)"></span></td>
                            <td style="text-align: center;"><span data-bind="text: sumOf_marker_unit_meter().toFixed(2)"></span></td>
                            <td colspan="5"></td>
                            <td style="text-align: center;"><span data-bind="text: sumOf_cut_amount"></span></td>
                            <td colspan="2"></td>
                        </tr>
                        <!-- /ko -->
                    </tbody>
                </table>
            </div>
            <div data-bind="css: hiddenLeft() ? 'col col-9' : 'col col-4'" style="max-height: 500px; overflow: auto;" id="list_sizes" onscroll="if(!window.list_vertical) { window.list_vertical=true; $('#list_main').scrollTop($(this).scrollTop()); $('#list_sizehead').scrollLeft($(this).scrollLeft()); setTimeout(function(){window.list_vertical=false}, 20); }">
                <!-- ko foreach: sizeHeads -->
                <input type="hidden" name="size_list" data-bind="value: size">
                <!-- /ko -->
                <table class="form_list">
                    <thead>
                        <tr data-bind="foreach: ordersizes" id="list_resize" style="height: 54px;">
                            <th>
                                <input type="hidden" data-bind="value: weight, attr: { name: 'size_' + size() }">
                                <span data-bind="text: weight"></span><br>&nbsp;
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- ko foreach: mainlist -->
                        <tr data-bind="foreach: sizes, colorline: draft_color" style="height: 36px">
                            <td style="padding: 1px 0 0 0;">
                                <input type="text" data-bind="value: cut_amount, attr: { name: 'size_cut_amount_' + size() + '_' + weight() + '_' + $parentContext.$index() }" style="padding: 0; line-height: 10px; font-size: 10px; height: 15px; width: 27px !important; text-align: center;"><br />
                                <input type="text" data-bind="value: cut_fabric_amount" style="padding: 0; line-height: 10px; font-size: 10px; height: 15px; width: 27px !important; text-align: center;" readonly>
                            </td>
                        </tr>
                        <!-- /ko -->
                        <tr><td></td></tr>
                    </tbody>
                </table>
            </div>
            <div class="col col-12">
                <cf_workcube_buttons is_upd='0' type_format="1" add_function="formkontrol()">
            </div>
        </div>
    </cfform>
</div>
<script type="text/javascript" src="/WBP/Fashion/files/js/knockout.js"></script>
<script type="text/javascript">

    function arr_unique(arr) {
        return arr.filter(function (value, index, self) { 
            return self.indexOf(value) === index;
        });
    }

    function arr_diff(arr, a) {
        return arr.filter(function(i) {return a.indexOf(i) < 0;});
    }

    ko.bindingHandlers.diffColor = {
        update: function( element, valueAccessor, allBindings, viewModel, bindingContext ) {
            var value = ko.unwrap( valueAccessor() );
            if ( value < 0 ) {
                element.style.color = '#FF0000';
            } else if ( value > 0 ) {
                element.style.color = '#0000FF';
            } else {
                element.style.color = 'initial';
            }
        }
    }

    ko.bindingHandlers.colorline = {
        update: function( element, valueAccessor, allBindings, viewModel, bindingContext ) {
            var value = ko.unwrap( valueAccessor() );
            switch (value) {
                case 'SARI':
                    element.style.backgroundColor = 'yellow';
                    break;
                case 'KIRMIZI':
                    element.style.backgroundColor = '#FFB5C5';
                    break;
                case 'MAVI':
                    element.style.backgroundColor = '#C6E2FF';
                    break;
                case 'MOR':
                    element.style.backgroundColor = '#DDA0DD';
                    break;
                case 'TURUNCU':
                    element.style.backgroundColor = '#FFA07A';
                    break;
                case 'YESIL':
                    element.style.backgroundColor = '#C1FFC1';
                    break;
                default:
                    element.style.backgroundColor = 'initial';
                    break;
            }
        }
    };

    var cutplaningApp = function() {
        var self = this;

        self.planingdata = {
            pastal_size: ko.observable(  <cfoutput>#len(cuthead.MARKER_SIZE)?cuthead.MARKER_SIZE:0#</cfoutput> ),
            margin : ko.observable( <cfoutput>#len(cuthead.MARGIN)?cuthead.MARGIN:0#</cfoutput> )
        };
        self.mainlist = ko.observableArray([]);
        self.ordersizes = ko.observableArray([]);
        self.sttestgroup = ko.observableArray([]);

        self.hiddenLeft = ko.observable(false);

        self.createCutSize = function( parent, item ) {
            var sizeitem = {
                size: ko.observable( item.size ),
                weight: ko.observable( item.weight ),
                cut_amount: ko.observable( item.cut_amount )
            };
            
            sizeitem.cut_fabric_amount = ko.computed( function() {
                if ( 
                    parent.layer_amount() !== '' && !isNaN( parent.layer_amount() ) 
                    && sizeitem.cut_amount() !== '' && !isNaN( sizeitem.cut_amount() )
                ) 
                {
                    return parseInt( parent.layer_amount() ) * parseInt( sizeitem.cut_amount() );
                }
                return 0;
            });
            sizeitem.diff = ko.computed( function() {
                var differs = self.ordersizes().filter( function( elm ) {
                    return elm.size() == sizeitem.size() && elm.weight() == sizeitem.weight();
                });
                if (differs.length > 0) {
                    return parseFloat( differs[0].order_amount().toString().replace(",", ".") ) - sizeitem.cut_fabric_amount();
                }
                return 0;
            });
            return sizeitem;
        }

        self.createMainlist = function( item ) {
            
            var mainitem = {
                marker_name             : ko.observable( item == null ? '' : item.marker_name ),
                marker_output           : ko.observable( item == null ? '' : item.marker_output ),
                cutplan_name            : ko.observable( item == null ? '' : item.cutplan_name ),
                marker_height           : ko.observable( item == null ? '' : item.marker_height ),
                layer_amount            : ko.observable( item == null ? '0' : item.layer_amount ),
                productivity            : ko.observable( item == null ? '' : item.productivity ),
                after_cut_meter         : ko.observable( item == null ? '' : item.after_cut_meter ),
                marker_width            : ko.observable( item == null ? '' : item.marker_width ),
                draft_color             : ko.observable( item == null ? '' : item.draft_color ),
                meto_color              : ko.observable( item == null ? '' : item.meto_color ),
                roll_id                 : ko.observable( item == null ? '' : item.roll_id )
            };
            mainitem.sizes = ko.observableArray( item == null || item.sizes == null ? 
                self.ordersizes().map( function( elm ) { 
                        var tmpelm = {}; 
                        tmpelm.size = elm.size();
                        tmpelm.weight = elm.weight();
                        tmpelm.cut_amount = "0"; 
                        return self.createCutSize( mainitem, tmpelm );
                    } 
                ) 
                : item.sizes.map( function( elm ) { return self.createCutSize( mainitem, elm ); } ) 
            );
            mainitem.assortment_size_amount = ko.computed( function() {
                return mainitem.sizes().reduce( function( acc, val ) {
                    if ( val.cut_amount() !== '' && !isNaN( val.cut_amount() ) ) {
                        acc += parseInt( val.cut_amount() );
                    }
                    return acc;
                }, 0);
            });
            mainitem.net_marker_meter = ko.computed( function() {
                if ( 
                        ( mainitem.marker_height() !== '' && !isNaN( mainitem.marker_height().toString().replace(",", ".") ) ) 
                    &&  ( mainitem.layer_amount() !== '' && !isNaN( mainitem.layer_amount().toString().replace(",", ".") ) ) 
                ) 
                {
                    return parseFloat( mainitem.marker_height().toString().replace(",", ".") ) * parseFloat( mainitem.layer_amount().toString().replace(",", ".") );
                }
                return 0;
            });
            mainitem.gross_marker_height = ko.computed( function() {
                if (
                        ( mainitem.marker_height() !== '' && !isNaN( mainitem.marker_height().toString().replace(",", ".") ) )
                    &&  ( self.planingdata.pastal_size() !== '' && !isNaN( self.planingdata.pastal_size().toString().replace(",", ".") ) )
                )
                {
                    return parseFloat( mainitem.marker_height().toString().replace(",", ".") ) + parseFloat( self.planingdata.pastal_size().toString().replace(",", ".") );
                }
                return 0;
            });
            mainitem.gross_marker_meter = ko.computed( function () {
                if ( mainitem.layer_amount() !== '' && !isNaN( mainitem.layer_amount() ) ) {
                    return parseInt( mainitem.layer_amount() ) * mainitem.gross_marker_height();
                }
                return 0;
            });
            mainitem.cut_amount = ko.computed( function() {
                return mainitem.sizes().reduce( function( acc, val ) {
                    return acc + parseInt( val.cut_fabric_amount() );
                }, 0);
            });
            mainitem.marker_unit_meter = ko.computed( function() {
                if ( mainitem.cut_amount() != 0 ) {
                    return mainitem.gross_marker_meter() / parseInt( mainitem.cut_amount() );
                }
                return 0;
            });
            mainitem.draft_width = ko.computed( function() {
                var stg = self.sttestgroup().filter( function( elm ) { return elm.groupname == mainitem.draft_color(); });
                if ( stg.length > 0 ) {
                    return stg[0].width;
                } else {
                    return 0;
                }
            } );
            mainitem.draft_height = ko.computed( function() {
                var stg = self.sttestgroup().filter( function( elm ) { return elm.groupname == mainitem.draft_color(); });
                if ( stg.length > 0 ) {
                    return stg[0].height;
                } else {
                    return 0;
                }
            } );

            return mainitem;
        };

        self.createOrderSize = function( item ) {
            var sizeitem = {
                size: ko.observable( item.size ),
                weight: ko.observable( item.weight ),
                order_amount: ko.observable( item.order_amount ),
            };
            sizeitem.order_amount_margined = ko.computed( function() {
                if ( self.planingdata.margin() !== "" && !isNaN( self.planingdata.margin() ) ) {
                    return Math.round( ( parseInt( sizeitem.order_amount() ) * ( 100 + parseInt( self.planingdata.margin() ) ) / 100 ), 0 ); 
                } else {
                    return sizeitem.order_amount();
                }
            });
            sizeitem.cut_amount = ko.computed( function() {
                return self.mainlist().reduce( function( acc, elm ) {
                    var szlist = elm.sizes().filter( function( sz ) {
                        return sz.size() == sizeitem.size() && sz.weight() == sizeitem.weight();
                    });
                    if ( szlist.length > 0 ) {
                        acc += parseInt( szlist[0].cut_amount() ) * parseInt( elm.layer_amount() );
                    }
                    return acc;
                }, 0);
            });
            sizeitem.diff = ko.computed( function() {
                return sizeitem.order_amount_margined() - sizeitem.cut_amount();
                return 0;
            });
            return sizeitem;
        }

        self.addMainRow = function() {
            self.mainlist.push( self.createMainlist( null ) );
        }

        self.removeMainRow = function ( row ) {
            if (confirm('Bu satiri silmek istediginizden emin misiniz?')) {
                self.mainlist.remove(row);
            }
        }

        self.cloneMainRow = function ( row ) {
            self.mainlist.push( self.createMainlist( ko.toJS( row ) ) );
        }

        self.sizeHeads = ko.computed(function() {
            var distincatedSizes = arr_unique( self.ordersizes().map( function( elm ) {
                return elm.size();
            }));
            return distincatedSizes.map( function( elm ) {
                return {
                    size: elm,
                    count: self.ordersizes().filter( function( item ) {
                        return item.size() == elm;
                    }).length
                };
            });
        });

        self.sumOfOrderAmounts = ko.computed( function() {
            return self.ordersizes().reduce( function( acc, elm ) {
                return acc + parseInt( elm.order_amount_margined() );
            },0);
        });

        self.sumOfOrderCuts = ko.computed( function() {
            return self.ordersizes().reduce( function( acc, elm ) {
                return acc + elm.cut_amount();
            }, 0);
        });

        self.sumOfOrderDiff = ko.computed( function() {
            return self.ordersizes().reduce( function( acc, elm ) {
                return acc + elm.diff();
            }, 0);
        });

        self.sumOf_net_marker_meter = ko.computed( function () {
            return self.mainlist().reduce( function( acc, val ) {
                if ( val.net_marker_meter() !== '' && !isNaN(val.net_marker_meter() ) ) {
                    acc += val.net_marker_meter();
                }
                return acc;
            }, 0);
        });
        
        self.sumOf_gross_marker_meter = ko.computed( function () {
            return self.mainlist().reduce( function( acc, val ) {
                if ( val.gross_marker_meter() !== '' && !isNaN(val.gross_marker_meter() ) ) {
                    acc += val.gross_marker_meter();
                }
                return acc;
            }, 0);
        });
        
        self.sumOf_marker_unit_meter = ko.computed( function () {
            return self.mainlist().reduce( function( acc, val ) {
                if ( val.marker_unit_meter() !== '' && !isNaN(val.marker_unit_meter() ) ) {
                    acc += val.marker_unit_meter();
                }
                return acc;
            }, 0);
        });
        
        self.sumOf_cut_amount = ko.computed( function () {
            return self.mainlist().reduce( function( acc, val ) {
                if ( val.cut_amount() !== '' && !isNaN(val.cut_amount() ) ) {
                    acc += val.cut_amount();
                }
                return acc;
            }, 0);
        });

        self.initial = function () {
            <cfoutput query="qsizes">
                self.ordersizes.push( self.createOrderSize({ size: "#BOY_#", weight: "#BEDEN_#", order_amount: #QUANTITY# }) );
            </cfoutput>
            <cfoutput query="stestgroup">
                self.sttestgroup.push( { groupname: "#GROUP_NAME#", width: "#len(WIDTH)?WIDTH:0#", height: "#len(HEIGHT)?HEIGHT:0#" } );
            </cfoutput>
            <cfoutput>
            <cfloop query="cutrows">
                var cutrows = { 
                    marker_name: '#MARKER_NAME#',
                    marker_output: '#MARKER_OUTPUT#',
                    cutplan_name: '#CUTPLAN_NAME#',
                    marker_height: '#MARKER_HEIGHT#',
                    layer_amount: '#LAYER_AMOUNT#',
                    productivity: '#PRODUCTIVITY#',
                    after_cut_meter: '#AFTER_CUT_METER#',
                    marker_width: '#MARKER_WIDTH#',
                    draft_color: '#DRAFT_COLOR#',
                    meto_color: '#METO_COLOR#',
                    roll_id: ''
                };
                <cfset rowid = CUTPLAN_ROWID>
                <cfif cutsizes.recordcount>
                    cutrows.sizes = [
                    <cfloop query="cutsizes">
                    <cfif rowid eq CUTPLAN_ROWID>
                    { size: "#SIZE#", weight: "#WEIGHT#", cut_amount: "#CUT_AMOUNT#" },    
                    </cfif>
                    </cfloop>
                    ];
                </cfif>
                self.mainlist.push( self.createMainlist( cutrows ) );
            </cfloop>
            </cfoutput>
        };

        self.upload_files = function () {
            $("#working_div_main").show();
            $.each($("#cutplaning input[type='file']"), function( key, elm ) {
                if ($(elm).val() == '') return;
                var formData = new FormData();
                formData.append('docu_file', $(elm)[0].files[0]);
                var idx = $(elm).data('idx');
                var upload_result = $.ajax({
                    url : '<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&event=upload</cfoutput>',
                    type : 'POST',
                    data : formData,
                    processData: false,  // tell jQuery not to process the data
                    contentType: false,  // tell jQuery not to set contentType
                    async: false
                }).responseText;
                self.mainlist()[idx].marker_output(upload_result);
            });
        }
        
        return {
            init: function( target ) {
                self.initial();
                ko.applyBindings( self, document.getElementById( target ) );
            },
            doUpload: function() {
                self.upload_files();
                return true;
            }
        }

    }();

    cutplaningApp.init( 'cutplaning' );
    //cutplaningApp.sample();

    function formkontrol() {
        cutplaningApp.doUpload();
        return true;
    }

</script>