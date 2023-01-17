<cfset get_component = createObject("component","V16.hr.ehesap.cfc.hourly_addfare_percantege")>
<cfset get_component_info = createObject("component","V16.hr.cfc.project_allowance")>
<cfset get_branch = createObject("component","V16.hr.cfc.get_branches")>

<cfset get_general_paper = get_component.get_general_paper(paper_id: attributes.gp_id)>
<cfset get_info = deserializeJSON(get_general_paper.TOTAL_VALUES)>
<cfset get_stage_name = get_component.get_stage_name(process_id : get_general_paper.STAGE_ID)>

<cfset get_main_project_allowance = get_component_info.get_main_project_allowance(paper_no: get_general_paper.GENERAL_PAPER_NO,is_print: 1)>
<cfset get_project_det_employee = get_component_info.get_project_detail(paper_no: get_general_paper.GENERAL_PAPER_NO,is_print: 1,type:0)>
<cfset get_project_det_director = get_component_info.get_project_detail(paper_no: get_general_paper.GENERAL_PAPER_NO,is_print: 1,type:1)>

<cfif not get_main_project_allowance.recordcount>
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
                                    <td class="print_title"><cf_get_lang dictionary_id='57416.Proje'> : <cf_get_lang dictionary_id='63207.Ödenek Hakediş'></td>
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
                                        <td>: #get_main_project_allowance.PAPER_NO#</td>
                                    </tr>
                                    <tr>
                                        <td style="width:200px;"><b><cf_get_lang dictionary_id='58455.Yıl'></b></td>
                                        <td>:
                                            #get_main_project_allowance.sal_year#
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:200px;"><b><cf_get_lang dictionary_id='58724.Ay'></b></td>
                                        <td>:
                                            #listgetat(ay_list(),get_main_project_allowance.sal_mon,',')#
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:200px;"><b><cf_get_lang dictionary_id='57453.Şube'></b></td>
                                        <td>: 
                                            <cfset get_branch = get_branch.get_branch(branch_id : get_main_project_allowance.branch_id)>
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
                            <tr><td><b><cf_get_lang dictionary_id='57416.Proje'> : <cf_get_lang dictionary_id='63207.Ödenek Hakediş'></b></td></tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table class="print_border">
                                <tr>
                                    <th colspan="7"><cf_get_lang dictionary_id='58875.Çalışanlar'></th> 
                                </tr>
                                <tr>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='58487.Çalışan No'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='57576.Çalışan'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='55478.Rol'></b></th> 
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='53610.Ödenek'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='57491.Saat'> / <cf_get_lang dictionary_id='55123.Ücret'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='41730.adam'> / <cf_get_lang dictionary_id='57491.Saat'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='57673.Tutar'></b></th>
                                </tr>
                                <cfoutput query="get_project_det_employee">
                                    <tr>
                                        <td>
                                            #employee_no#
                                        </td>
                                        <td>
                                            #get_emp_info(employee_id,0,0)#
                                        </td>
                                        <td>
                                            #role_head#
                                        </td>
                                        <td>
                                            #COMMENT_PAY#
                                        </td>
                                        <td style="text-align:right; width:15mm;">
                                            #tlformat(HOUR_PAYMENT)#
                                        </td>
                                        <td style="text-align:right; width:15mm;">
                                            #tlformat(HOURLY_WORK)#
                                        </td>   
                                        <td style="text-align:right; width:15mm;">#tlformat(AMOUNT)#</td>               
                                    </tr>
                                </cfoutput>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table class="print_border">
                                <tr>
                                    <th colspan="7"><cf_get_lang dictionary_id='35313.Yöneticiler'></th> 
                                </tr>
                                <tr>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='58487.Çalışan No'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='57576.Çalışan'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='55478.Rol'></b></th> 
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='53610.Ödenek'></b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='57668.Pay'>%</b></th>
                                    <th style="width:150px"><b><cf_get_lang dictionary_id='57673.Tutar'></b></th>
                                </tr>
                                <cfoutput query="get_project_det_director">
                                    <tr>
                                        <td>
                                            #employee_no#
                                        </td>
                                        <td>
                                            #get_emp_info(employee_id,0,0)#
                                        </td>
                                        <td>
                                            #role_head#
                                        </td>
                                        <td>
                                            #COMMENT_PAY#
                                        </td>
                                        <td>
                                            #tlformat(SHARE)#
                                        </td>
                                        <td style="text-align:right; width:15mm;">#tlformat(AMOUNT)#</td>               
                                    </tr>
                                </cfoutput>
                            </table>
                        </td>
                    </tr>
                    
                    <tr class="print_footer" >
                        <td>
                            <table>
                                <cfoutput>
                                    <tr>
                                        <td><cf_get_lang dictionary_id='63145.Yönetim Payı'></td>
                                        <td style="text-align:right; width:15mm;"> #tlformat(get_main_project_allowance.DIRECTOR_SHARE)#</td>
                                    </tr>
                                    <tr>
                                        <td><cf_get_lang dictionary_id='61106.Dağıtım'>%</td>
                                        <td style="text-align:right; width:15mm;"> #tlformat(get_main_project_allowance.distribution)#</td>
                                    </tr> 
                                    <tr>
                                        <td><cf_get_lang dictionary_id='63146.Yönetim Tutarı'>%</td>
                                        <td style="text-align:right; width:15mm;"> #tlformat(get_main_project_allowance.director_amount)#</td>
                                    </tr>
                                    <tr>
                                        <td><cf_get_lang dictionary_id='63147.Çalışan Tutarı'></td>
                                        <td style="text-align:right; width:15mm;"> #tlformat(get_main_project_allowance.employee_amount)#</td>
                                    </tr>
                                    <tr>
                                        <td><cf_get_lang dictionary_id='57492.Toplam'></td>
                                        <td style="text-align:right; width:15mm;"> #tlformat(get_main_project_allowance.TOTAL_AMOUNT)#</td>
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