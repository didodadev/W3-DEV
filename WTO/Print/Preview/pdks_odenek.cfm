<cfset get_component = createObject("component","V16.hr.ehesap.cfc.hourly_addfare_percantege")>
<cfset get_branch = createObject("component","V16.hr.cfc.get_branches")>
<cfset get_general_paper = get_component.get_general_paper(paper_id: attributes.gp_id)>
<cfset get_salaryparam_pay = get_component.get_salaryparam_pay(paper_no: get_general_paper.GENERAL_PAPER_NO)>
<cfset get_info = deserializeJSON(get_general_paper.TOTAL_VALUES)>
<cfset get_stage_name = get_component.get_stage_name(process_id : get_general_paper.STAGE_ID)>
<cfset get_allowance = get_component.get_allowance(ssk_statue: get_info.SSK_STATUE, statue_type: get_info.BORDRO_TYPE)>

<cfif not get_salaryparam_pay.recordcount>
    <cfset hata  = 10>
    <cfsavecontent variable="message"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
    <cfset hata_mesaj  = message>
<cfelse>
    <style>
        .print_title{font-size:16px;}
        table{border-collapse:collapse;border-spacing:0;}
        table tr td{padding:5px 3px;}
        .print_border tr th{border:1px solid #c0c0c0;padding:3px;color:#000}
        .print_border tr td{border:1px solid #c0c0c0;}
        .row_border{border-bottom:1px solid #c0c0c0;}
        table tr td img{max-width:50px;}
    </style>
    <table class="print_page">
        <tr>
            <td>
                <table width="100%">
                    <tr class="row_border">
                        <td style="padding:10px 0 0 0!important">
                            <table class="print_header">
                                <tr>
                                    <td class="print_title">PDKS ÖDENEK LİSTESİ</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <cfoutput>
                        <tr class="row_border"class="row_border">
                            <td>
                                <table>
                                    <tr>
                                        <td style="width:200px;"><b><cf_get_lang dictionary_id='57880.Document No.'></b></td>
                                        <td>: #get_general_paper.GENERAL_PAPER_NO#</td>
                                    </tr>
                                    <tr>
                                        <td style="width:200px;"><b><cf_get_lang dictionary_id='56589.SSA Status'></b></td>
                                        <td>:
                                            <cfif get_info.SSK_STATUE eq 1>
                                                <cf_get_lang dictionary_id='45049.Worker'>
                                            <cfelseif get_info.SSK_STATUE eq 2>
                                                <cf_get_lang dictionary_id='62870.Memur'>
                                            <cfelseif get_info.SSK_STATUE eq 3>
                                                <cf_get_lang dictionary_id='62871.Serbest Çalışan'>
                                            <cfelseif get_info.SSK_STATUE eq 4>
                                                <cf_get_lang dictionary_id='63103.Sanatçı'>
                                            <cfelseif get_info.SSK_STATUE eq 5>
                                                <cf_get_lang dictionary_id='30439.Dış Kaynak'>       
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:200px;"><b><cf_get_lang dictionary_id='63047.Bordro Tipi'></b></td>
                                        <td>:
                                            <cfif get_info.BORDRO_TYPE eq 1>
                                                <cf_get_lang dictionary_id='40071.Maaş'>
                                            <cfelseif get_info.BORDRO_TYPE eq 2>
                                                <cf_get_lang dictionary_id='62888.Döner Sermaye'>
                                            <cfelseif get_info.BORDRO_TYPE eq 3>
                                                <cf_get_lang dictionary_id='62956.Ek Ders'>
                                            <cfelseif get_info.BORDRO_TYPE eq 4>
                                                <cf_get_lang dictionary_id='58015.Projeler'>
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:200px;"><b><cf_get_lang dictionary_id='57453.Şube'></b></td>
                                        <td>: 
                                            <cfset get_branch = get_branch.get_branch(branch_id : get_info.branch_id)>
                                            #get_branch.BRANCH_NAME#
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:200px;"><b><cf_get_lang dictionary_id='55812.Recorded by'></b></td>
                                        <td>: #get_emp_info(get_general_paper.record_emp,0,0)#</td>
                                    </tr>
                                    <tr>
                                        <td style="width:200px;"><b><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></b></td>
                                        <td>: #dateFormat(get_general_paper.record_date,dateformat_style)#</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>

                        <tr>
                            <table width="100%">
                            <tr bgcolor="##eee" style="background-color:##eee;border-top:1px solid ##c0c0c0;border-bottom:1px solid ##c0c0c0">
                                <td style="width:200px"><b><cf_get_lang dictionary_id='58859.Süreç'>/<cf_get_lang dictionary_id='57482.Aşama'></b></td>
                                <td>: #get_stage_name.stage#</td>
                            </tr>
                            </table>
                        </tr>
                    </cfoutput>
                    <tr>
                        <td>
                            <table width="100%">
                            <tr><td><b><cf_get_lang dictionary_id='63094.PDKS Ödenek'> <cf_get_lang dictionary_id="37022.Bilgileri"></b></td></tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table class="print_border">
                                <tr>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='57576.Çalışan'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='58025.TC Kimlik No'></b></th> 
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='57453.Şube'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='35449.Departman'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='58724.Ay'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='58455.Yıl'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='53610.Ödenek'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='46377.Toplam Saat'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='29534.Toplam Tutar'></b></th> 
                                </tr>
                                <cfoutput query="get_salaryparam_pay">
                                    <tr>
                                        <td>
                                            #get_emp_info(employee_id,0,0)#
                                        </td>
                                        <td>
                                            #tc_identy_no#
                                        </td>
                                        <td>
                                            #branch_name#
                                        </td>
                                        <td>
                                            #department_head#
                                        </td>   
                                        <td>#START_SAL_MON#</td> 
                                        <td>#TERM#</td>
                                        <td>#COMMENT_PAY#</td>   
                                        <td>#tlformat(TOTAL_WORK_HOUR)#</td> 
                                        <td  style="text-align:right; width:15mm;">#tlformat(AMOUNT_PAY)# #MONEY#</td>                
                                    </tr>
                                </cfoutput>
                            </table>
                        </td>
                    </tr>
                    
                    <tr class="print_footer" align="right">
                        <td>
                            <table>
                                <cfoutput query="get_allowance">
                                    <tr>
                                        <td> #COMMENT_PAY#</td>
                                        <td style="text-align:right; width:15mm;"> #tlformat(evaluate('get_info.ALLOWANCE_EXPENSE_#ODKES_ID#'))#  #get_salaryparam_pay.MONEY#</td>
                                    </tr>
                                </cfoutput>
                                <cfoutput>
                                    <tr>
                                        <td> <cf_get_lang dictionary_id='46377.Total Hours'></td>
                                        <td style="text-align:right; width:15mm;"> #tlformat(get_info.total_hour)#</td>
                                    </tr>
                                </cfoutput>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>   
</cfif>
   
   
  
  
     
 