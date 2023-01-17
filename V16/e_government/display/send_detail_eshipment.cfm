<cfset common = createObject("Component","V16.e_government.cfc.eirsaliye.common")>
<cfset getDetail = common.eShipmentDetail(action_id:attributes.action_id, action_type:attributes.action_type)>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='60913.Gönderim Detayları'></cfsavecontent>
    
    <cf_box title="#title#">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='60911.E-İrlisaye'><cf_get_lang dictionary_id='58527.ID'></th>
                    <th><cf_get_lang dictionary_id='59825.Workcube Referans'> <cf_get_lang dictionary_id='58527.ID'></th>
                    <cfif len(getDetail.shipment_type_code)>
                        <th><cf_get_lang dictionary_id='57288.Fatura Tipi'></th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='60918.İrsaliye Durumu'></th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <cfif session.ep.admin>
                            <a href="javascript:void(0);" onclick="open_xml()" class="tableyazi"><cfoutput>#getDetail.integration_id#</cfoutput></a>
                        <cfelse>	
                            <cfoutput>#getDetail.integration_id#</cfoutput>
                        </cfif>
                    </td>
                    <td><cfoutput>#getDetail.eshipment_id#</cfoutput></td>
                    <cfif len(getDetail.shipment_type_code)>
                        <td><cfoutput>#getDetail.shipment_type_code#</cfoutput></td>
                    </cfif>
                    <td>
                        <cfif (len(getDetail.status) and getDetail.status)>
                            <cf_get_lang dictionary_id="60914.İrsaliye Gönderildi">
                        <cfelseif len(getDetail.status) and not getDetail.status>
                            <font color="FF0000"><cf_get_lang dictionary_id="60915.İrsaliye Red Edildi">!</font>
                        <cfelseif getDetail.recordcount>
                            <cf_get_lang dictionary_id="60916.İrsaliye Onay Bekliyor">                    
                        <cfelse>
                            <cf_get_lang dictionary_id="60917.İrsaliye Gönderilmedi">
                        </cfif>
                    </td>
                </tr>
            </tbody>
        </cf_grid_list>

    <cfoutput query="getDetail">
        <cfsavecontent variable="info_">#dateformat(record_date,dateformat_style)# #timeformat(dateadd('h', session.ep.time_zone, record_date),timeformat_style)#</cfsavecontent>
    <cf_seperator title="#info_#" id="eirsaliye_#currentrow#">
        <cf_medium_list id="eirsaliye_#currentrow#">
            <thead>
                <tr>
                    <th width="100"><b><cf_get_lang dictionary_id='57066.Gönderen'></b></th>
                    <th width="200"><b><cf_get_lang dictionary_id='60918.İrsaliye Durumu'></b></b></th>
                    <th width="150"><b><cf_get_lang dictionary_id='60911.İrsaliye'> <cf_get_lang dictionary_id='58685.Hata Açıklaması'></b></th>
                </tr>
            </thead>
            <tbody>
                <tr valign="top">
                    <td>#name#</td>
                    <td width="200"><cfif service_result neq 'Successful'><font color="FF0000">#status_description#</font><cfelse>#status_description#</cfif></td>
                    <td>#service_result_description#</td>
                </tr>
            </tbody>
        </cf_medium_list>

        </cfoutput>
        <div id="wrk_report_button_info_box" style="display:none;position:absolute;width:400px;" class="pod_box">
            <div id="wrk_report_button_info_box_header" class="header" style="height:15px;">
                <table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="font-weight:bold;"><cf_get_lang dictionary_id="29728.Dosya İndir"></td>
                        <td width="1px">
                            <table align="right">
                                <tr>
                                    <td><a href="javascript:void(0);" onclick="gizle(wrk_report_button_info_box);"><img src="/images/pod_close.gif" alt="<cf_get_lang dictionary_id='57553.Kapat'>" border="0" align="absmiddle"></a></td>
                                </tr>
                            </table>
                        </td>
                        <td width="1px" class="clearer"></td>
                    </tr>
                </table>
            </div>
            <div id="wrk_report_button_info_box_body" class="body">
                <div id="downloading" align="center"></div>
            </div>
        </div>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="29728.Dosya İndir"></cfsavecontent>
    <script type="text/javascript">
        function open_xml()
        {
            file_= "<cfoutput>documents/eshipment_send/#session.ep.company_id#/#year(getDetail.record_date)#/#numberformat(month(getDetail.record_date),00)#/#getDetail.ESHIPMENT_ID#</cfoutput>.xml";		
            get_wrk_message_div("<cfoutput>#message#</cfoutput>","XML",file_)
        }
    
        function open_zip()
        {
            file_= "<cfoutput>documents/eshipment_send/#session.ep.company_id#/#year(getDetail.record_date)#/#numberformat(month(getDetail.record_date),00)#/#getDetail.ESHIPMENT_ID#</cfoutput>.zip";
            get_wrk_message_div("<cfoutput>#message#</cfoutput>","Zip",file_)
        }
    
        $(document).keydown(function(e){
            // ESCAPE key pressed
            if (e.keyCode == 27) {
                window.close();
            }
        });
    </script>