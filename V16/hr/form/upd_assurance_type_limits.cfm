<!---
File: upd_assurance_type_limits.cfm
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 22.11.2019
Controller: AssuranceTypesController.cfm
Description: Sağlık Teminatı Tipi güncelleme sayfası limitler sekmesidir.
--->
<div id="item-limits" class="item-limits col col-9 col-md-9 col-sm-9 col-xs-12">
    <cf_grid_list>
        <thead>
            <th style="text-align:center;width:25px;"><input type="button" class="eklebuton" title="" onClick="add_row_limits('products_services')" value=""></th>
            <cfif get_assurance.working_type eq 4><!--- Çalışma Tipi Miktar sınırı --->
                <th><cf_get_lang dictionary_id = "57635.Miktar"></th>
            </cfif>
            <th><cf_get_lang dictionary_id = "40460.Tutar aralığı">(Min)</th>
            <th><cf_get_lang dictionary_id = "40460.Tutar aralığı">(Max)</th>
            <th><cf_get_lang dictionary_id = "57489.Para Birimi"></th>
            <th><cf_get_lang dictionary_id = "41536.Kamu">-<cf_get_lang dictionary_id = "58456.Oran">%</th>
            <th><cf_get_lang dictionary_id = "57979.Özel">-<cf_get_lang dictionary_id = "58456.Oran">%</th>
            <th><cf_get_lang dictionary_id = "49335.Yürürlük Tarihi"></th>
            <th><cfoutput>#left(getLang('main',81),1)#</cfoutput> </th>
            <th><cfoutput>#Left(getLang('main',672,'fiyat'),1)##Left(getLang('invoice',199,'Kontrol'),1)#</cfoutput></th>
        </thead>
        <tbody id="limits">
            <cfif get_assurance_support.recordcount>
                <cfset record_count_cf = get_assurance_support.recordcount>
                <cfoutput query = "get_assurance_support">
                    <tr>
                        <cfset money_type = money>
                        <td class="text-center"><a style="cursor:pointer" onclick="del_row('#currentrow#',#support_id#);" ><i class="fa fa-minus"></i></a></td>
                        <cfif get_assurance.working_type eq 4><!--- Çalışma Tipi Miktar sınırı--->
                            <td><input type="text" name="quantity_#currentrow#" id="quantity_#currentrow#" class="boxtext" value="#quantity#" onkeyup="return(FormatCurrency(this,event));"></td>
                        </cfif>
                        <td><input type="text" name="min_#currentrow#" id="min_#currentrow#" value="#TLFormat(min)#" class="boxtext text-right" onkeyup="return(FormatCurrency(this,event));" onchange="fieldCommaSplit(this)"></td>
                        <td><input type="text" name="max_#currentrow#" id="max_#currentrow#" value="#TLFormat(max)#" class="boxtext text-right" onkeyup="return(FormatCurrency(this,event));" onchange="fieldCommaSplit(this)"></td>
                        <td>
                            <select name="money_#currentrow#" id = "money_#currentrow#" class="boxtext">
                                <cfloop query="get_money">
                                    <option value="#money#" <cfif money eq money_type>selected</cfif>>#money#</option>
                                </cfloop>
                            </select>
                        </td>
                        <td><input type="text" name="rate_#currentrow#" id="rate_#currentrow#" value="#TLFormat(rate)#" class="boxtext text-right" onkeyup="return(FormatCurrency(this,event));" onchange="fieldCommaSplit(this)"></td>
                        <td><input type="text" name="private_rate_#currentrow#" id="private_rate_#currentrow#" value="#TLFormat(private_comp_rate)#" class="boxtext text-right" onkeyup="return(FormatCurrency(this,event));" onchange="fieldCommaSplit(this)"></td>
                        <td>
                            <div class="form-group" >  
                                <div class="input-group">
                                    <input type="text" name="effective_date_#currentrow#" id="effective_date_#currentrow#" value="#dateFormat(effective_date,dateformat_style)#" class="boxtext">   
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="effective_date_#currentrow#"></span>
                                </div>
                            </div>
                        </td>
                        <td><input type="checkbox" name="is_active_#currentrow#" id="is_active_#currentrow#" value="1" <cfif is_active eq 1>checked</cfif>></td>
                        <td nowrap style="text-align:center;">
                            <a href="javascript://" onclick="upd_row_limits(#currentrow#,#support_id#)"><i class="fa fa-refresh"></i></a><div id = "update_div_#currentrow#"></div>
                        </td>
                    </tr>
                </cfoutput>                            
            </cfif>
        </tbody>
    </cf_grid_list>
</div>