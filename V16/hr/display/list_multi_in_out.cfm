<cf_xml_page_edit fuseact="hr.form_upd_emp">
<cfset attributes.xml_in_out = xml_in_out>
<cfinclude template="../query/get_in_out_other.cfm">
<cfinclude template="../query/get_eski_izinler.cfm">
<cf_ajax_list>
    <cfif get_in_out_other.recordcount>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57574.Sirket'></th>
            <th><cf_get_lang dictionary_id='57453.Şube'></th>
            <th><cf_get_lang dictionary_id ='57572.Departman'></th>
            <th><cf_get_lang dictionary_id='57554.Giriş'></th>
            <th><cf_get_lang dictionary_id='57431.Çıkış'></th>
            <cfif get_module_user(48)>
                <th width="20"><a href="javascript:void(0)"><i class="fa fa-money"></i></a></th>
                <th width="20"><a href="javascript:void(0)"><i class="fa fa-minus"></i></a></th>
                <th width="20"><a href="javascript:void(0)"><i class="fa fa-pencil"></i></a></th>
            </cfif>
                
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_in_out_other">
            <tr>
                <td>#nick_name#</td>
                <td>#branch_name#</td>
                <td>#department_head#</td>
                <td>#dateformat(start_date,dateformat_style)#</td>
                <td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
                <cfif get_module_user(48)>
                        <td><a href="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#in_out_id#&empName=#UrlEncodedFormat('#EMPLOYEE#')#"><i class="fa fa-money" title="<cf_get_lang dictionary_id ='55123.Ücret'>"></i></a></td>
                        <cfif attributes.xml_in_out eq 1 and not len(finish_date)><td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_fire&event=addOut&in_out_id=#in_out_id#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='29832.İşten Çıkış'>"></i></a></td></cfif>
                        <cfif len(FINISH_DATE)>
                            <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_fire&event=updOut&in_out_id=#in_out_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>	
                        <cfelse>
                            <td></td>
                        </cfif>
                </cfif>
            </tr>
        </cfoutput>
    </tbody>
    </cfif>
    <cfif get_eski_izinler.recordcount>
        <thead>
            <tr>
                <th colspan="6"><cf_get_lang dictionary_id ='56372.Geçmiş Çalışmalar'></th>
            </tr>
            <tr>
                <th><cf_get_lang dictionary_id='57574.Sirket'></th>
                <th><cf_get_lang dictionary_id='57453.Şube'></th>
                <th><cf_get_lang dictionary_id ='57572.Departman'></th>
                <th width="75"><cf_get_lang dictionary_id='57554.Giriş'></th>
                <th width="75"><cf_get_lang dictionary_id='57431.Çıkış'></th>
            </tr>
        </thead>
        <tbody>
        <cfoutput query="get_eski_izinler">
            <tr>
                <td>#nick_name#</td>
                <td>#branch_name#</td>
                <td>&nbsp;</td>
                <td>#dateformat(startdate,dateformat_style)#</td>
                <td>#dateformat(finishdate,dateformat_style)#</td>
            </tr>
        </cfoutput>
        </tbody> 
    </cfif>
    <cfif not get_in_out_other.recordcount and not get_eski_izinler.recordcount>
    <tbody>
        <tr>
            <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok '>!</td>
        </tr>
    </tbody>
    </cfif>
</cf_ajax_list>
