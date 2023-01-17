<cfset cfc = createObject("component","V16.hr.cfc.competencies")>
<cfset getReqTypeForEmp = cfc.getReqTypeForEmp(employee_id: attributes.employee_id)>
<cfif attributes.type eq 1>
    <cf_ajax_list>
        <tbody>
        <cfif getReqTypeForEmp.recordcount>
            <cfoutput query="getReqTypeForEmp">		
                <tr>
                    <td><a href="javascript://" class="tableyazi">#REQ_NAME#</a></td>
                    <td style="width:15px;"><a href="javascript://" onclick="del_competencies_from_emp(#COMPETENCIES_ID#)" class="tableyazi" title="<cf_get_lang dictionary_id='57463.Sil'>"><i class="fa fa-minus"></i></a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
        </tbody>
        <div id="competencies_del_div"></div>
    </cf_ajax_list>
<cfelseif attributes.type eq 2>
    <cfset get_competencies = cfc.get_competencies()>
    <cf_box title="#getLang('','Yetkinlikler',58709)#" closable="0" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="competencies_form" method="POST">
            <cfinput type="hidden" value="#attributes.employee_id#" name="employee_id" id="employee_id">
            <cf_box_elements>
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th width="15">No</th>
                            <th>Yetkinlik</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="get_competencies">
                            <tr>
                                <cfinput type="hidden" value="#get_competencies.req_id#" name="req_type_id" id="req_type_id">
                                <td>#currentrow#</td>
                                <td><a href="javascript://" onclick="add_competencies_to_emp(#req_id#)">#req_name#</a></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </cf_grid_list>
            </cf_box_elements>
            <cf_box_footer>
                <div class="bold" id="competencies_div"></div>
            </cf_box_footer>
        </cfform>		
    </cf_box>
</cfif>
<script>
    function add_competencies_to_emp(req_type_id){
        $.ajax({
            url: "/V16/hr/cfc/competencies.cfc?method=add_competencies_to_emp&employee_id=<cfoutput>#attributes.employee_id#</cfoutput>&req_type_id="+req_type_id,
            beforeSend: function(  ) {
                $("#competencies_div").html("<cf_get_lang dictionary_id='58889.Kaydediliyor'>");
            }
        })
        .done(function() {
            $("#competencies_div").html("<cf_get_lang dictionary_id='58890.Kaydedildi'>");
        });
        $("#emp_competencies .catalyst-refresh").click();
    }
    function del_competencies_from_emp(competencies_id){
        $.ajax({
            url: "/V16/hr/cfc/competencies.cfc?method=del_competencies_from_emp&competencies_id="+competencies_id,
            beforeSend: function(  ) {
                $("#competencies_del_div").html("<cf_get_lang dictionary_id='29726.Siliniyor'>");
            }
        })
        .done(function() {
            $("#competencies_del_div").html("<cf_get_lang dictionary_id='29721.Silindi'>");
        });
        $("#emp_competencies .catalyst-refresh").click();
    }
</script>