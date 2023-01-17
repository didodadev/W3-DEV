<!---
    File: list_flexible_worktime.cfm
    Controller: FlexibleWorkTimeController.cfm
    Author: Esma R. UYSAL
    Date: 07/12/2019 
    Description:
        HR modüülü esnek çalışma saatleri listeleme sayfasıdır.
--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_flexible_date" default="">
<cfparam name="attributes.finish_flexible_date" default="">
<cfsavecontent variable = "title">
    <cf_get_lang dictionary_id = "41573.Esnek Çalışma Taleplerim">
</cfsavecontent>
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Subat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayis'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Agustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasim'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralik'></cfsavecontent>
<cfset days_name = "">
<cfloop from="1" to="7" index="c">
	<cfif	c eq 1><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57604.Pazartesi"></cfsavecontent>
	<cfelseif c eq 2><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57605.Salı"></cfsavecontent>
	<cfelseif c eq 3><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57606.Çarşamba"></cfsavecontent>
	<cfelseif c eq 4><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57607.Perşembe"></cfsavecontent>
	<cfelseif c eq 5><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57608.Cuma"></cfsavecontent>
	<cfelseif c eq 6><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57609.Cumartesi"></cfsavecontent>
	<cfelseif c eq 7><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57610.Pazar"></cfsavecontent>
	</cfif>
	<cfset days_name = listappend(days_name,'#day_name#')>
</cfloop>
<cfset flex_component = createObject("component","V16.myhome.cfc.flexible_worktime")>
<cfset fuseaction = listFirst(attributes.fuseaction,".")>
<cfset get_flexible_worktime =  flex_component.GET_WORKTIME_FLEXIBLE(employee_id : session.ep.userid,start_flexible_date :  attributes.start_flexible_date,finish_flexible_date : attributes.finish_flexible_date)>
<cf_box id="list_worknet_list" closable="0" collapsable="1" title="#title#" add_href="#request.self#?fuseaction=#fuseaction#.flexible_worktime&event=add"> 
    <cf_ajax_list>
        <div id="Note_list">
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id = "57742.Tarih"></th>
                    <th><cf_get_lang dictionary_id = "57491.Saat"></th>
                    <th><cf_get_lang dictionary_id = "55285.Talep Tarihi"></th>
                    <th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
                    <th width="20"><i class="fa fa-pencil"></i></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query = "get_flexible_worktime">
                    <cfset get_flexible_worktime_row = flex_component.GET_WORKTIME_FLEXIBLE_ROW(flexible_id : get_flexible_worktime.worktime_flexible_id)>
                    <cfloop query = "get_flexible_worktime_row">
                        <tr>
                            <td>
                                <cfif len(get_flexible_worktime_row.FLEXIBLE_DATE)>
                                    #dateFormat(get_flexible_worktime_row.FLEXIBLE_DATE,dateformat_style)#
                                <cfelse>
                                    #get_flexible_worktime_row.FLEXIBLE_YEAR# - #Evaluate('ay#get_flexible_worktime_row.FLEXIBLE_MONTH#')# - #listGetAt(days_name,get_flexible_worktime_row.FLEXIBLE_DAY)#
                                </cfif>
                            </td>
                            <td>
                                <cfif #get_flexible_worktime_row.flexible_start_hour# lt 10>0</cfif>#get_flexible_worktime_row.flexible_start_hour#.<cfif #get_flexible_worktime_row.flexible_start_minute# lt 10>0</cfif>#get_flexible_worktime_row.flexible_start_minute# - <cfif #get_flexible_worktime_row.flexible_finish_hour# lt 10>0</cfif>#get_flexible_worktime_row.flexible_finish_hour#.<cfif #get_flexible_worktime_row.flexible_finish_minute# lt 10>0</cfif>#get_flexible_worktime_row.flexible_finish_minute#
                            </td>
                            <td>
                                #dateFormat(get_flexible_worktime.REQUEST_DATE,dateformat_style)#
                            </td>
                            <td>
                                <b><cfif get_flexible_worktime_row.IS_APPROVE eq 0><cf_get_lang dictionary_id ="57615.Onay Bekliyor"><cfelseif get_flexible_worktime_row.IS_APPROVE eq 1><cf_get_lang dictionary_id ="58699.Onaylandı"><cfelseif get_flexible_worktime_row.IS_APPROVE eq -1><cf_get_lang dictionary_id ="54645.Red Edildi"></cfif></b>
                            </td>
                            <td>
                                <cfsavecontent  variable="upd_title">
                                    <cf_get_lang dictionary_id = "57464.Güncelle">
                                </cfsavecontent>
                                <cfif get_flexible_worktime_row.IS_APPROVE eq 0>
                                    <cfsavecontent  variable="upd_title">
                                        <cf_get_lang dictionary_id = "57464.Güncelle">
                                    </cfsavecontent>
                                    <a href="javascript://" onclick="open_update_page('#contentEncryptingandDecodingAES(isEncode:1,content:get_flexible_worktime.worktime_flexible_id,accountKey:'wrk')#')" title ="#upd_title#"><i class="fa fa-pencil"></i></a>
                                </cfif>
                            </td>
                        </tr>
                    </cfloop>
                </cfoutput>
            </tbody>
        </div>
    <cf_ajax_list>
</cf_box>
<script>
    function open_update_page (flexible_id){
        window.open("<cfoutput>#request.self#?fuseaction=#fuseaction#.flexible_worktime&event=upd&flexible_id=</cfoutput>"+flexible_id, '_blank');
    }
</script>