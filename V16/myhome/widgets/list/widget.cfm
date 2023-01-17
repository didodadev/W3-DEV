
<cfobject name="myhome_employee_mandate_component" component="V16.myhome.cfc.myhome_employee_mandate">
<cfset myhome_employee_mandate_component.init()>
<cfset attributes.searched = 1>
<cfif isDefined("attributes.searched")>
<cfset mandate_query = myhome_employee_mandate_component.mandate_list(argumentCollection=attributes)>
</cfif>


<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="0">
<cfif isDefined("mandate_query")><cfset attributes.totalrecords = mandate_query.recordcount></cfif>
<cfif 1 eq 1  and isDefined("attributes.show_employee_name") and attributes.show_employee_name>
     <cfset attributes.is_mandate=1>
     <cfsavecontent  variable="header_"><cf_get_lang dictionary_id="58488.Alınan">
     </cfsavecontent>
     <cf_seperator id="veren" header="#header_#">
     <cfset table_id="veren">
</cfif>
<cfif 1 eq 1  and isDefined("attributes.show_mandate_name") and attributes.show_mandate_name>
     <cfset attributes.is_mandate=0>
     <cfsavecontent  variable="header_"><cf_get_lang dictionary_id="58490.Verilen">
     </cfsavecontent>
     <cf_seperator id="verilen" header="#header_#">
     <cfset table_id="verilen">
</cfif>
     <table class="ajax_list" id="<cfoutput>#table_id#</cfoutput>">
          <thead>
               <tr>
                    <cfif 1 eq 1  and isDefined("attributes.show_employee_name") and attributes.show_employee_name><th><cf_get_lang dictionary_id='59855.Vekalet Veren'></th></cfif>
                    <cfif 1 eq 1  and isDefined("attributes.show_mandate_name") and attributes.show_mandate_name><th><cf_get_lang dictionary_id='59856.Vekalet Verilen'></th></cfif>
                    <cfif 1 eq 1 ><th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th></cfif>
                    <cfif 1 eq 1 ><th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th></cfif>
                    <cfif 1 eq 1 ><th><cf_get_lang dictionary_id='58859.Süreç'></th></cfif>
                    <cfif 1 eq 1 and isDefined("attributes.show_mandate_name") and attributes.show_mandate_name><th width="20"><a href= "<cfoutput>#request.self#?fuseaction=myhome.employee_mandate&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id="59926.Vekalet Ver">"></i></a></th></cfif>
                    <cfif 1 eq 1 and isDefined("attributes.show_employee_name") and attributes.show_employee_name><th width="20"><a href= "<cfoutput>#request.self#?fuseaction=myhome.employee_mandate&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id="60288.Vekalet Al">"></i></a></th></cfif>
               <tr>
          </thead>
          <tbody>
          <cfif isDefined("attributes.searched") and attributes.totalrecords>
          <cfoutput query="mandate_query" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
               <tr>
                    <cfif 1 eq 1  and isDefined("attributes.show_employee_name") and attributes.show_employee_name><td><span >#employee_name#</span></td></cfif>
                    <cfif 1 eq 1  and isDefined("attributes.show_mandate_name") and attributes.show_mandate_name><td><span >#mandate_name#</span></td></cfif>
                    <cfif 1 eq 1 ><td><span >#Dateformat(startdate, dateformat_style)# (#TIMEFORMAT(startdate,timeformat_style)#)</span></td></cfif>
                    <cfif 1 eq 1 ><td><span >#Dateformat(finishdate, dateformat_style)# (#TIMEFORMAT(finishdate,timeformat_style)#)</span></td></cfif>
                    <cfif 1 eq 1 ><td><span >#process_stage_title#</span></td></cfif>
                    <cfif 1 eq 1 and isDefined("attributes.show_mandate_name") and attributes.show_mandate_name><td><a href="#request.self#?fuseaction=myhome.employee_mandate&event=upd&id=#id#" ><i class="fa fa-pencil" title="<cf_get_lang dictionary_id="57464.Güncelle">"></i></a></td></cfif>
                    <cfif 1 eq 1 and isDefined("attributes.show_employee_name") and attributes.show_employee_name><td><a href="#request.self#?fuseaction=myhome.employee_mandate&event=upd&id=#id#" ><i class="fa fa-pencil" title="<cf_get_lang dictionary_id="57464.Güncelle">"></i></a></td></cfif>
               </tr>
          </cfoutput>
          <cfelseif isDefined("attributes.searched")>
               <tr><td colspan="6"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></td></tr>
               <cfelse>
               <tr><td colspan="6"><cf_get_lang dictionary_id='57701.Filtre Ediniz'></td></tr>
          </cfif>
          </tbody>
     </table>
     <table style="width: 100%">
     <tr><td>
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
     <cfif attributes.totalrecords><!--- <cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#address#"> ---></cfif></td>
     <!-- sil --><!--- <cfoutput style="text-align:right;"><cfoutput><cf_get_lang_main no="128.Toplam Kayıt">:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no="169.Sayfa">:#attributes.page#/#int(ceiling(attributes.totalrecords/attributes.maxrows))#</cfoutput></td> ---><!-- sil -->
     </tr></table>

     


