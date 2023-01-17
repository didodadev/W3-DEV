<!--- <style>
.cerceve {
    height:3px;
    width: 100%;
    border: 1px solid #000000;
    padding: 10px;
    background-color:#81D4FA;
}

table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
</style>
<br>
 --->

 <cfset attributes.flexible_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.iid,accountKey:'wrk')>
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
 <cfparam name="attributes.employee_id" default="#session.ep.userid#" />
 <cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
 <cfset GET_TITLES = createObject("component","V16.hr.cfc.get_titles_positions")>
 
 
 <cfset cmp_branch.dsn = dsn>
 <cfset GET_TITLES.dsn = dsn>
 <cfset flex_component = createObject("component","V16.myhome.cfc.flexible_worktime")>
 <cfset get_flexible_worktime = flex_component.GET_WORKTIME_FLEXIBLE(flexible_id : attributes.flexible_id)>
 <cfset get_flexible_worktime_row = flex_component.GET_WORKTIME_FLEXIBLE_ROW(flexible_id : attributes.flexible_id,is_period:0)>
 <cfset get_flexible_worktime_row_p = flex_component.GET_WORKTIME_FLEXIBLE_ROW(flexible_id : attributes.flexible_id , is_period:1)>
 
 <cfset GET_TITLE =GET_TITLES.get_titles_positions(position_id:get_flexible_worktime.position_id)>
 <cfset get_branches = cmp_branch.get_branch(branch_status:1)>
 <cfset cmp_department = createObject("component","V16.hr.cfc.get_departments")>
 <cfset cmp_department.dsn = dsn>
 <cfset get_department = cmp_department.get_department(department_id : get_flexible_worktime.department_id)>
 <cfset periods = createObject('component','V16.objects.cfc.periods')>
 <cfset period_years = periods.get_period_year()>
 <cfset days_name = "">
 <cfif isdefined("attributes.is_approve_page") and len(attributes.is_approve_page)>
     <cfset is_approve_page = 1>
 <cfelse>
     <cfset is_approve_page = 0>
 </cfif>
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
 <cfset record_count_row = 0>
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
       <input type = "hidden" name = "is_approve#get_flexible_worktime_row_p.WORKTIME_FLEXIBLE_ROW_ID#" id = "is_approve#get_flexible_worktime_row_p.WORKTIME_FLEXIBLE_ROW_ID#" value = "<cfif len(get_flexible_worktime_row_p.is_approve)>#get_flexible_worktime_row_p.is_approve#<cfelse>0</cfif>">
   <tr>
     <td>
       <table width="100%">
         <tr class="row_border">
           <td style="padding:10px 0 0 0!important">
             <table style="width:100%;">
               <tr>
                 <td class="print_title"><cf_get_lang dictionary_id='60179.Esnek Çalışma Talep Formu'></td>
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
                 <td style="width:100px;"><b><cf_get_lang dictionary_id='55247.Başvuru No'></b></td>
                 <td>: #attributes.flexible_id#</td>
               </tr>
               <tr>
                 <td style="width:100px;"><b><cf_get_lang dictionary_id='55434.Başvuru Tarihi'></b></td>
                 <td>: #dateformat(get_flexible_worktime.request_date,dateformat_style)#</td>
               </tr>
               <tr>
                 <td style="width:100px;"><b><cf_get_lang dictionary_id='29514.Başvuru Yapan'></b></td>
                 <td>: #get_emp_info(get_flexible_worktime.employee_id,0,0)#</td>
               </tr>
               <tr>
                 <td style="width:100px;"><b><cf_get_lang dictionary_id='58487.Çalışan No'></b></td>
                 <td>: #get_flexible_worktime.employee_id#</td>
               </tr>
               <tr>
                 <td style="width:100px;"><b><cf_get_lang dictionary_id='35449.İş Birimi'></b></td>
                 <td>: #get_department.department_head#</td>
               </tr>
               <tr>
                 <td style="width:100px"><b><cf_get_lang dictionary_id='36199.Açıklama'></b></td>
                 <td>: #get_flexible_worktime.worktime_flexible_notice#</td>
               </tr>
             </table>
           </td>
         </tr>
         <tr>
           <table width="100%">
             <tr bgcolor="##eee" style="background-color:##eee;border-top:1px solid ##c0c0c0;border-bottom:1px solid ##c0c0c0">
               <td style="width:100px"><b><cf_get_lang dictionary_id='58859.Süreç'>/<cf_get_lang dictionary_id='57482.Aşama'></b></td>
               <td>: İK Onayı</td>
             </tr>
           </table>
         </tr>
         <tr>
           <td><b><cf_get_lang dictionary_id='60181.Talep Edilen Aylara Göre Esnek Çalışma Zamanı'></b></td>
         </tr>
         <tr>
           <td>
             <table class="print_border">
               <tr>
                 <th style="width:80px"><b><cf_get_lang dictionary_id='58455.Yıl'></b></th>
                 <th style="width:80px"><b><cf_get_lang dictionary_id='58724.Ay'></b></th> 
                 <th style="width:80px"><b><cf_get_lang dictionary_id='57490.Gün'></b></th>
                 <th style="width:100px"><b><cf_get_lang dictionary_id='41014.Saat Aralığı'></b></th>
                 <th style="width:100px;"><cf_get_lang dictionary_id='58859.Süreç'>/<cf_get_lang dictionary_id='57482.Aşama'></th>
               </tr>
               <cfloop query="get_flexible_worktime_row_p">
                 <tr>
                   <td>
                     <cfif len(get_flexible_worktime_row_p.flexible_date)>
                       #dateformat(get_flexible_worktime_row_p.flexible_date,dateformat_style)#
                     <cfelse>
                       #get_flexible_worktime_row_p.flexible_year#  
                     </cfif>
                   </td>
                   <td>
                     #Evaluate('ay#get_flexible_worktime_row_p.flexible_month#')#
                   </td>
                   <td>
                     <cfif len(get_flexible_worktime_row_p.flexible_date)>
                       <cfset day_ = DayOfWeek(get_flexible_worktime_row_p.flexible_date)>
                       #listGetAt(days_name,day_)#
                     <cfelseif  len(get_flexible_worktime_row_p.flexible_day)>
                       <cfset day_ = get_flexible_worktime_row_p.flexible_day>
                       #listGetAt(days_name,day_)#
                     </cfif>
                   </td>
                   <td>
                     <cfif len(get_flexible_worktime_row_p.flexible_start_hour) eq 1>0</cfif>#get_flexible_worktime_row_p.flexible_start_hour#:<cfif len(get_flexible_worktime_row_p.flexible_start_minute) eq 1>0</cfif>#get_flexible_worktime_row_p.flexible_start_minute# - <cfif len(get_flexible_worktime_row_p.flexible_finish_hour) eq 1>0</cfif>#get_flexible_worktime_row_p.flexible_finish_hour#:<cfif len(get_flexible_worktime_row_p.flexible_finish_minute) eq 1>0</cfif>#get_flexible_worktime_row_p.flexible_finish_minute#
                   </td>
                     <td class="text-center">
                         <div id="approve_valid#get_flexible_worktime_row_p.WORKTIME_FLEXIBLE_ROW_ID#">              
                             <cfif get_flexible_worktime_row_p.IS_APPROVE eq 0>
                                 -
                             <cfelseif get_flexible_worktime_row_p.IS_APPROVE eq 1>
                                 <cf_get_lang dictionary_id ="58699.Onaylandı">
                             <cfelseif get_flexible_worktime_row_p.IS_APPROVE eq -1> 
                                 <cf_get_lang dictionary_id ="54645.Red Edildi">
                             </cfif>
                         </div>
                     </td>
                 </tr>
             </cfloop>
             </table>
           </td>
         </tr>
         <tr>
           <td><b><cf_get_lang dictionary_id='60183.Talep Edilen Günlere Göre Esnek Çalışma Zamanı'></b></td>
         </tr>
         <tr class="row_border">
           <td style="padding:5px 3px 10px 3px!important">
             <table class="print_border">
               <tr>
                 <th style="width:80px"><b><cf_get_lang dictionary_id='57742.Tarih'></b></th>
                 <th style="width:100px"><b><cf_get_lang dictionary_id='41014.Saat Aralığı'></b></th>
                 <th style="width:100px;"><cf_get_lang dictionary_id='58859.Süreç'>/<cf_get_lang dictionary_id='57482.Aşama'></th>
               </tr>
               <cfloop query="get_flexible_worktime_row">
                 <tr>
                   <td>
                     <cfif len(get_flexible_worktime_row.flexible_date)>
                       #dateformat(get_flexible_worktime_row.flexible_date,dateformat_style)#
                     <cfelse>
                       #dateformat(createdate(get_flexible_worktime_row.flexible_year,get_flexible_worktime_row.flexible_month,get_flexible_worktime_row.flexible_day),dateformat_style)#
                     </cfif>
                   </td>
                   <!----<td> 
                     <cfif len(get_flexible_worktime_row.flexible_date)>
                       <cfset i = MONTH(get_flexible_worktime_row.flexible_date)>
                       #Evaluate('ay#i#')#
                     <cfelseif  len(get_flexible_worktime_row.flexible_month)>
                       <cfset i = get_flexible_worktime_row.flexible_month>
                       #Evaluate('ay#i#')#
                     </cfif>
                   </td>
                   <td>
                     <cfif len(get_flexible_worktime_row.flexible_date)>
                       <cfset day_ = DayOfWeek(get_flexible_worktime_row.flexible_date)>
                       #listGetAt(days_name,day_)#
                     <cfelseif  len(get_flexible_worktime_row.flexible_day)>
                       <cfset day_ = get_flexible_worktime_row.flexible_day>
                       #listGetAt(days_name,day_)#
                     </cfif>
                   </td>---->
                   <td>
                     <cfif len(get_flexible_worktime_row.flexible_start_hour) eq 1>0</cfif>#get_flexible_worktime_row.flexible_start_hour#:<cfif len(get_flexible_worktime_row.flexible_start_minute) eq 1>0</cfif>#get_flexible_worktime_row.flexible_start_minute# - <cfif len(get_flexible_worktime_row.flexible_finish_hour) eq 1>0</cfif>#get_flexible_worktime_row.flexible_finish_hour#:<cfif len(get_flexible_worktime_row.flexible_finish_minute) eq 1>0</cfif>#get_flexible_worktime_row.flexible_finish_minute#
                   </td>
                       <td class="text-center">
                         <div id="approve_valid#WORKTIME_FLEXIBLE_ROW_ID#">  
                             <cfif get_flexible_worktime_row.IS_APPROVE eq 0>
                                -
                             <cfelseif get_flexible_worktime_row.IS_APPROVE eq 1>
                                 <cf_get_lang dictionary_id ="58699.Onaylandı">
                             <cfelseif get_flexible_worktime_row.IS_APPROVE eq -1> 
                                 <cf_get_lang dictionary_id ="54645.Red Edildi">
                             </cfif>
                         </div>
                     </td>
                 </tr>
             </cfloop>
             </table>
           </td>
         </tr>
         <tr>
           <td>
             <table style="width:100%">
               <tr>
                 <td style="height:80px;vertical-align:top;"><cf_get_lang dictionary_id='57570.Ad Soyad'><br/><b>#get_emp_info(get_flexible_worktime.employee_id,0,0)#</b></td>
                 <td style="height:80px;vertical-align:top;"><cf_get_lang dictionary_id='60184.Birim Onayı'></td>
                 <td style="height:80px;vertical-align:top;"><cf_get_lang dictionary_id='60185.İK Onayı'></td>
               </tr>
             </table>
           </td>
         </tr>
         <tr class="fixed">
           <td style="font-size:9px!important;"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
         </tr>
       </table>
     </td>
   </tr>
 </table>
  
 
 </cfoutput>