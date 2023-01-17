<!---
File: budget_transfer_print.cfm
query:BudgetTransferDemand.cfc
Author: Workcube - Melek KOCABEY <melekkocabey@workcube.com>
Date: 02.02.2021
Description: Bütçe Aktarım Talepleri print dosyası.
---->
<cfset demand = createObject("component", "V16.budget.cfc.BudgetTransferDemand" )>
<cfset det_demand = demand.det_demand(
                                        demand_id : (not isdefined("attributes.action_id") ? attributes.iid : attributes.action_id)
                                     )>
<cfset det_demand = deserializeJSON(det_demand)>

<cfquery name="CHECK" datasource="#DSN#">
     SELECT 
         ASSET_FILE_NAME2,
         ASSET_FILE_NAME2_SERVER_ID,
     COMPANY_NAME
     FROM 
         OUR_COMPANY 
     WHERE 
         <cfif isdefined("attributes.our_company_id")>
             COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
         <cfelse>
             <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
                 COMP_ID = #session.ep.company_id#
             <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
                 COMP_ID = #session.pp.company_id#
             <cfelseif isDefined("session.ww.our_company_id")>
                 COMP_ID = #session.ww.our_company_id#
             <cfelseif isDefined("session.cp.our_company_id")>
                 COMP_ID = #session.cp.our_company_id#
             </cfif> 
         </cfif> 
</cfquery>
<cfquery name="Get_Upper_Position" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfif len (Get_Upper_Position.Upper_Position_Code)>
    <cfquery name="Get_Chief1_Name" datasource="#dsn#">
        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Upper_Position.Upper_Position_Code#">
    </cfquery>
</cfif>
<cfoutput>
    <style>
    .print_title{font-size:16px;}
    table{border-collapse:collapse;border-spacing:0;}
    table tr td{padding:5px 3px;}
    .print_border tr th{border:1px solid ##c0c0c0;padding:3px;color:##000}
    .print_border tr td{border:1px solid ##c0c0c0;}
    .row_border{border-bottom:1px solid ##c0c0c0;}
    table tr td img{max-width:50px;}
    </style>
   
    <table style="width:210mm">
        <tr>
            <td>
                <table width="100%">
                    <tr class="row_border">
                        <td style="padding:10px 0 0 0!important">
                            <table style="width:100%;">
                                <tr>
                                    <td class="print_title"><cf_get_lang dictionary_id='61325.Btçe Aktarım Talebi'></td>
                                    <td style="text-align:right;">
                                    <cfif len(check.asset_file_name2)>
                                        <cfset attributes.type = 1>
                                            <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr class="row_border"class="row_border">
                        <td>
                            <table>
                                <tr>
                                    <td style="width:100px;"><b><cf_get_lang dictionary_id='30770.Talep No'></b></td>
                                    <td>: #det_demand[1]["DEMAND_NO"]#</td>
                                </tr>
                                <tr>
                                    <td style="width:100px;"><b><cf_get_lang dictionary_id='30829.Talep Eden'></b></td>
                                    <td>: #det_demand[1]["DEMAND_EMP_ID"]#</td>
                                </tr>
                                <tr>
                                    <td style="width:100px;"><b><cf_get_lang dictionary_id="31023.Talep Tarihi"></b></td>
                                    <td>: #dateformat(det_demand[1]["DEMAND_DATE"],dateformat_style)#</td>
                                </tr>
                                <tr>
                                    <td style="width:100px;"><b><cf_get_lang dictionary_id="49179.İlişkili Bütçe"></b></td>
                                    <td>: #det_demand[1]["BUDGET_NAME"]#</td>
                                </tr>
                                <tr>
                                    <td style="width:100px"><b><cf_get_lang dictionary_id='36199.Açıklama'></b></td>
                                    <td>: #det_demand[1]["DETAIL"]#</td>
                                </tr>
                                <tr>
                                    <td style="width:100px"><b><cf_get_lang dictionary_id='57673.Tutar'></b></td>
                                    <td>: #tlformat(det_demand[1]["AMOUNT"])#</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='31181.Talep Edilen'><cf_get_lang dictionary_id='57559.Bütçe'></b></td>
                    </tr>
                    <tr>
                        <td>
                            <table class="print_border">
                                <tr>
                                    <th style="width:80px"><b><cf_get_lang dictionary_id='58460.Masraf Merkezi'></b></th>
                                    <th style="width:80px"><b><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'></b></th> 
                                    <th style="width:80px"><b><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></b></th>
                                    <th style="width:100px"><b><cf_get_lang dictionary_id='57416.Proje'></b></th>
                                    <th style="width:100px;"><cf_get_lang dictionary_id='31172.Aktivite Tipi'></th>
                                </tr>
                                <cfloop array="#det_demand#" index="item">
                                    <tr>
                                    <td>
                                        #item.EXPENSE#
                                    </td>
                                    <td>
                                        <cfset get_exp_detail = demand.get_exp_detail(expense_item_id:item.DEMAND_EXP_ITEM)>
                                        #get_exp_detail.EXPENSE_CAT_NAME#
                                    </td>
                                    <td>
                                        #item.EXPENSE_ITEM_NAME#
                                    </td>
                                    <td>
                                        #item.PROJECT_HEAD#
                                    </td>
                                        <td class="text-center">
                                            #item.DEMAND_ACTIVITY_TYPE#
                                        </td>
                                    </tr>
                                </cfloop>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='30829.Talep eden'><cf_get_lang dictionary_id='57559.Bütçe'></b></td>
                    </tr>
                    <tr class="row_border">
                       <td style="padding:5px 3px 10px 3px!important">
                            <table class="print_border">
                                <tr>
                                    <th style="width:80px"><b><cf_get_lang dictionary_id='58460.Masraf Merkezi'></b></th>
                                    <th style="width:80px"><b><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'></b></th> 
                                    <th style="width:80px"><b><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></b></th>
                                    <th style="width:100px"><b><cf_get_lang dictionary_id='57416.Proje'></b></th>
                                    <th style="width:100px;"><cf_get_lang dictionary_id='31172.Aktivite Tipi'></th>
                                </tr>
                                <cfloop array="#det_demand#" index="item">
                                    <tr>
                                    <td>
                                        #item.TRA_EXPENSE#
                                    </td>
                                    <td>
                                        <cfset get_exp_detail = demand.get_exp_detail(expense_item_id:item.TRANSFER_EXP_ITEM)>
                                        #get_exp_detail.EXPENSE_CAT_NAME#
                                    </td>
                                    <td>
                                        #item.TRA_EXPENSE_ITEM_NAME#
                                    </td>
                                    <td>
                                        #item.TRA_PROJECT_HEAD#
                                    </td>
                                        <td class="text-center">
                                            #item.TRANSFER_ACTIVITY_TYPE#
                                        </td>
                                    </tr>
                                </cfloop>
                            </table>
                        </td>
                    </tr>                
                    <tr>
                        <td>
                            <table border="0" cellpadding="0" width="100%">
                                <cfoutput>
                                    <tr><td colspan="3" style="height:5mm;">&nbsp;</td></tr>
                                    <tr style="height:7mm;">
                                        <td><b><cf_get_lang dictionary_id="33306.ONAYLAR"></b></td>
                                    </tr>
                                    <tr style="height:7mm;">
                                        <td style="width:50mm;"><b><cf_get_lang dictionary_id='29511.YÖNETİCİ'><cf_get_lang dictionary_id='57500.ONAY'></b></td>
                                        <td style="width:50mm;"><b><cf_get_lang dictionary_id='29511.YÖNETİCİ'><cf_get_lang dictionary_id='57500.ONAY'></b></td>
                                    </tr>
                                    <tr style="height:7mm;">
                                        <td><cfif Len(Get_Upper_Position.Upper_Position_Code)>
                                                #Get_Chief1_Name.EMPLOYEE_NAME# #Get_Chief1_Name.EMPLOYEE_SURNAME#
                                            </cfif>
                                        </td>
                                        <td>&nbsp;</td>
                                    </tr>
                                </cfoutput>
                            </table>
                        </td>
                    </tr>
	                <tr height="100%"><td>&nbsp;</td></tr>
                    <tr class="fixed">
                        <td style="font-size:9px!important;"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</cfoutput>
