
<cfobject name="hr_employee_mandate_component" component="V16.hr.cfc.hr_employee_mandate">
<cfset hr_employee_mandate_component.init()>
<cfif isDefined("attributes.searched")>
     <cfset mandate_query = hr_employee_mandate_component.mandate_list(argumentCollection=attributes)>
</cfif>
<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cfparam name="attributes.startdate" default="#dateformat(attributes.startdate,dateformat_style)#">
<cfelse>
	<cfparam name="attributes.startdate" default="#dateformat((date_add('m',-1,CreateDate(year(now()),month(now()),1))),dateformat_style)#">
</cfif>
<cfparam name="attributes.finishdate" default="#dateformat((Createdate(year(CreateDate(year(now()),month(now()),1)),month(CreateDate(year(now()),month(now()),1)),DaysInMonth(CreateDate(year(now()),month(now()),1)))),dateformat_style)#"> 

<cfif isdate(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="0">
<cfif isDefined("mandate_query")><cfset attributes.totalrecords = mandate_query.recordcount></cfif>
<cf_box title="#getlang_title#" closable="0">     
     <cfform method="POST" name="search_member">
          <input type="hidden" name="searched" value="1">  
          <cf_box_search more="0">
                    <cfif 1 eq 1 >
                         <div class="form-group" id="item-employee_name" data-formulacontainer="mandate">
                              <div class="input-group">
                                   <cfoutput><input type="hidden" name="employee_id" id="mandate_employee_id" value="#iif(isDefined("attributes.employee_id"), "attributes.employee_id", de(""))#" ></cfoutput>
                                   <cfoutput><input type="text" name="employee_name" id="mandate_employee_name" value="#iif(isDefined("attributes.employee_name"), "attributes.employee_name", de(""))#" placeholder="<cf_get_lang dictionary_id='30368.Çalışan'>"></cfoutput>
                                   <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_emps&field_id=mandate_employee_id&field_name=mandate_employee_name&select_list=1', 'list')"></span>
                              </div>
                         </div>
                    <cfelse>
                         <cfoutput><input type="hidden" name="employee_name" id="mandate_employee_name" value="#iif(isDefined("attributes.employee_name"), "attributes.employee_name", de(""))#" ></cfoutput>
                    </cfif>
                    <cfif 1 eq 1 >
                         <div class="form-group" id="item-mandate_name" data-formulacontainer="mandate">
                              <div class="input-group"><cfoutput>
                                 <cfoutput><input type="hidden" name="mandate_id" id="mandate_mandate_id" value="#iif(isDefined("attributes.mandate_id"), "attributes.mandate_id", de(""))#" ></cfoutput>
                                 <input type="text" name="mandate_name" id="mandate_mandate_name" value="#iif(isDefined("attributes.mandate_name"), "attributes.mandate_name", de(""))#" placeholder="<cf_get_lang dictionary_id='55573.Vekaleten'>"></cfoutput>
                                 <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_emps&field_id=mandate_mandate_id&field_name=mandate_mandate_name&select_list=1', 'list')"></span>
                              </div>
                         </div>
                    <cfelse>
                         <cfoutput><input type="hidden" name="mandate_name" id="mandate_mandate_name" value="#iif(isDefined("attributes.mandate_name"), "attributes.mandate_name", de(""))#" ></cfoutput>
                    </cfif>
                    <cfif 1 eq 1 >
                         <div class="form-group" id="item-startdate" data-formulacontainer="mandate">
                              <div class="input-group">
                                   <cfif isdefined('attributes.startdate') and len(attributes.startdate)>
                                        <cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#"  value="#dateformat(attributes.startdate,dateformat_style)#">
                                   <cfelse>
                                        <cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" >
                                   </cfif>
                                   <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                              </div>
                         </div>
                    <cfelse>
                         <cfoutput><input type="hidden" name="startdate" id="startdate" value="#iif(isDefined("attributes.startdate"), "attributes.startdate", de(""))#" ></cfoutput>
                    </cfif>
                    <cfif 1 eq 1 >
                         <div class="form-group" id="item-finishdate" data-formulacontainer="mandate">
                              <div class="input-group">
                                   <cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
                                        <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" value="#dateformat(attributes.finishdate,dateformat_style)#">
                                   <cfelse>
                                        <cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" >
                                   </cfif>
                                   <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                              </div>
                         </div>
                    <cfelse>
                         <cfoutput><input type="hidden" name="finishdate" id="finishdate" value="#iif(isDefined("attributes.finishdate"), "attributes.finishdate", de(""))#" ></cfoutput>
                    </cfif>
                    <div class="form-group">
                         <cf_wrk_search_button button_type="4">
                    </div>
          </cf_box_search>               
     </cfform>  
     <cf_flat_list>
          <thead>
               <tr>
                    <cfif 1 eq 1 ><th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th></cfif>
                    <cfif 1 eq 1 ><th><cf_get_lang dictionary_id='36841.İş Akışı'></th></cfif>
                    <cfif 1 eq 1 ><th><cf_get_lang dictionary_id='30368.Çalışan'></th></cfif>
                    <cfif 1 eq 1 ><th><cf_get_lang dictionary_id='55573.Vekaleten'></th></cfif>
                    <cfif 1 eq 1 ><th><cf_get_lang dictionary_id='58053.Başlangıç T'></th></cfif>
                    <cfif 1 eq 1 ><th><cf_get_lang dictionary_id='57700.Bitiş T'></th></cfif>
                    <cfif 1 eq 1 ><th width="20"><a href="<cfoutput>#attributes.add_href#</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th></cfif>
               <tr>
          </thead>
          <tbody>
               <cfif isDefined("attributes.searched") and attributes.totalrecords>
                    <cfoutput query="mandate_query" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                         <tr>
                              <cfif 1 eq 1 ><td width="20">#currentrow#</td></cfif>
                              <cfif 1 eq 1 ><td><span >#process_stage_title#</span></td></cfif>
                              <cfif 1 eq 1 ><td><span >#employee_name#</span></td></cfif>
                              <cfif 1 eq 1 ><td><span >#mandate_name#</span></td></cfif>
                              <cfif 1 eq 1 ><td><span >#Dateformat(startdate, dateformat_style)# (#TIMEFORMAT(startdate,timeformat_style)#)</span></td></cfif>
                              <cfif 1 eq 1 ><td><span >#Dateformat(finishdate, dateformat_style)# (#TIMEFORMAT(finishdate,timeformat_style)#)</span></td></cfif>
                              <cfif 1 eq 1 ><td width="20"><a href="/index.cfm?fuseaction=hr.employee_mandate&event=upd&id=#id#" ><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td></cfif>
                         </tr>
                    </cfoutput>
               <cfelse>
                    <tr>
                         <td colspan="7"><cfif isdefined("attributes.searched")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
               </cfif>
          </tbody>
     </cf_flat_list>
     <cfset address = "">
     <cfloop array="#structKeyArray(url)#" index="urlelm">
          <cfif len(url[urlelm]) and urlelm neq "FUSEACTION" and urlelm neq "FIELDNAMES" and urlelm neq "PAGE" and urlelm neq "MAXROWS">
               <cfset address = address & urlelm & "=" & url[urlelm] & "&">
          <cfelse>
               <cfset address = url.FUSEACTION & "&" & address>
          </cfif>
     </cfloop>
     <cfloop array="#structKeyArray(form)#" index="formelm">
          <cfif len(form[formelm]) and formelm neq "FIELDNAMES" and formelm neq "PAGE" and formelm neq "MAXROWS">
               <cfset address = address & formelm & "=" & form[formelm] & "&">
          </cfif>
     </cfloop>
     <cfset address = mid( address, 1, len( address ) -1 )>
     <cfif attributes.totalrecords>
          <cf_paging 
          page="#attributes.page#" 
          maxrows="#attributes.maxrows#" 
          totalrecords="#attributes.totalrecords#" 
          startrow="#attributes.startrow#" 
          adres="#address#">
     </cfif>
</cf_box>


