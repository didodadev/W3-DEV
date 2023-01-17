<cfparam name="attributes.project_id" default="0">
<cfparam name="attributes.opp_id" default="0">
<cfparam name="attributes.order_id" default="0">
<cfparam name="attributes.viewmode" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.lot" default="">

<cfif attributes.viewmode eq "lotfind">
    <cfobject name="product_lots" component="WBP.Fashion.files.cfc.product_lots">
    <cfset GetPageContext().getCFOutput().clear()>
    <cfset result = product_lots.GetList(attributes.product_id, attributes.lot)>
    <cfoutput>{ 
        "count": #result.recordCount#,
        "product_id": #len(result.product_id)?result.product_id:-1#,
        "envanter": #len(result.ENVANTER)?result.ENVANTER:0#
     }</cfoutput>
    <cfabort>
</cfif>

<cfobject name="stretching_test" component="WBP.Fashion.files.cfc.stretching_test">
<cfset stretching_test.dsn3 = dsn3>
<cfscript>
    attributes.checkTotal = attributes.project_id + attributes.opp_id + attributes.order_id;
</cfscript>

<cf_catalystHeader>
    <div style="clear: both"></div>

    <cfform name="stretching_test" method="post">
    
        <cf_box id="sample_request" closable="0" unload_body = "1"  title="Çekme Testi">
            <div class="row">
                <div class="col col-12 uniqueRow">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <!--- col 1 --->
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                <div class="form-group" id="item-process_id">
                                    <label class="col col-4 col-xs-12">Süreç</label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_workcube_process is_upd='0' is_detail='0'>
                                    </div>
                                </div>
                                <div class="form-group" id="item-order_id">
                                    <label class="col col-4 col-xs-12">Sipariş No</label>
                                    <div class="col col-8 col-xs-12">
                                        <!---<div class="input-group">--->
                                            <input type="hidden" name="order_id" id="order_id">
                                            <input type="text" name="order_title" id="order_title" style="width:100%;">
                                            <!---
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_orders_for_ship&is_from_invoice=1&order_id_liste=&is_purchase=0&is_return=0&company_id=&consumer_id=  index.cfm?fuseaction=objects.popup_list_projects&amp;project_id=stretching_test.project_id&amp;project_head=stretching_test.project_head','list');"></span>
                                        </div>
                                    --->
                                    </div>
                                </div>
                                <div class="form-group" id="item-production_orderid">
                                    <label class="col col-4 col-xs-12">Üretim Emir No</label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="production_orderid" id="production_orderid">
                                    </div>
                                </div>
                                <div class="form-group" id="item-emp_id">
                                    <label class="col col-4 col-xs-12">Görevli</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="emp_id" id="emp_id">
                                            <input type="text" name="emp_name" id="emp_name">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_positions&field_emp_id=stretching_test.emp_id&field_name=stretching_test.emp_name &select_list=1,2&is_form_submitted=1&keyword='+encodeURIComponent(stretching_test.emp_name.value),'list');"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!--- col 2 --->
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                <div class="form-group" id="item-stretching_test_id">
                                    <label class="col col-4 col-xs-12">Test No</label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="stretching_test_no" id="stretching_test_no" readonly="">
                                    </div>
                                </div>
                                <div class="form-group" id="item-purchasing_id">
                                    <label class="col col-4 col-xs-12">İrsaliye No</label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="waybill" id="waybill">
                                    </div>
                                </div>
                                <div class="form-group" id="item-required_fabric_meter">
                                    <label class="col col-4 col-xs-12">Kumaş İhtiyaç Metrajı</label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="required_fabric_meter" id="required_fabric_meter">
                                    </div>
                                </div>
                                <div class="form-group" id="item-date_start">
                                    <label class="col col-4 col-xs-12">İş Başlangıç Zaman</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                            <input type="text" name="date_start" id="date_start" validate="#validate_style#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="date_start"></span>
                                            <cfset sdate="">
                                            <cfset shour="">
                                            <cfset sminute="">
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
                            <!--- col 3 --->
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                <div class="form-group" id="item-test_date">
                                    <label class="col col-4 col-xs-12">Tarih</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                            <input type="text" name="test_date" id="test_date" value="<cfoutput>#dateformat( now() ,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="test_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-washing_id">
                                    <label class="col col-4 col-xs-12">Yıkama No</label>
                                    <div class="col col-8 col-xs-12">
                                        <cfobject name="washing_receipe" component="WBP.Fashion.files.cfc.washing_recepie">
                                        <cfset washing_recepie_query = washing_receipe.simple_recepie_head()>
                                        <div class="input-group">
                                            <select name="washing_id" id="washing_id">
                                                <option value="">Seçiniz</option>
                                                <cfoutput query="washing_recepie_query">
                                                <option value="#WASHING_RECEPIE_ID#">RN-#WASHING_RECEPIE_ID#</option>
                                                </cfoutput>
                                            </select>
                                            
                                            <div class="input-group-addon">
                                                <button type="button" class="btn green-haze" onclick="$('#washing_id').val() !== '' && windowopen('<cfoutput>#request.self#?fuseaction=textile.washing_recepie&event=upd&rid=</cfoutput>' + $('#washing_id').val(), 'wide')"><i class="fa fa-eye"></i></button>
                                            </div>
                                        </div>
                                        <script>
                                            $("#washing_id").select2();
                                        </script>
                                    </div>
                                </div>
                                <div class="form-group" id="item-fabric_arrival_date">
                                    <label class="col col-4 col-xs-12">Kumaş Geliş Tarihi</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                            <input type="text" name="fabric_arrival_date" id="fabric_arrival_date" value="<cfoutput>#dateformat( now() ,dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="fabric_arrival_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-date_finish">
                                    <label class="col col-4 col-xs-12">İş Bitiş Zamanı</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                                <input type="text" name="date_finish" id="date_finish" validate="#validate_style#" maxlength="10">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="date_finish"></span>
                                                <cfset sdate="">
                                                <cfset shour="">
                                                <cfset sminute="">                                           
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
                            <!--- col 4 --->
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                                <div class="form-group" id="item-project_id">
                                    <label class="col col-4 col-xs-12">Proje No</label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="project_id" id="project_id">
                                            <input name="project_head" type="text" id="project_head">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_projects&amp;project_id=stretching_test.project_id&amp;project_head=stretching_test.project_head','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-notes">
                                    <label class="col col-4 col-xs-12">Açıklama</label>
                                    <div class="col col-8 col-xs-12">
                                        <textarea name="notes" id="notes"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box>
        
        <cfinclude template="list_stretching_fabric.cfm">
</cfform>