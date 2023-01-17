<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.is_submitted")>
    <cfinclude template="../query/get_km_search.cfm">
	<cfquery dbtype="query" name="get_total_km">
		SELECT SUM(KM_FINISH - KM_START) AS TOTAL_KM FROM get_km_search 
	</cfquery>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default='#get_km_search.recordcount#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>
<cf_grid_list>
  <thead>
      <tr>
          <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
          <th><cf_get_lang dictionary_id='48229.Mesai Dışı'></th>	
          <th><cf_get_lang dictionary_id='29453.Plaka'></th>
          <th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
          <th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
          <th><cf_get_lang dictionary_id='47901.Kullanım Amacı'></th>
          <th><cf_get_lang dictionary_id='58140.İş Grubu'></th>		  
          <th><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></th>
          <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
          <th><cf_get_lang dictionary_id='48228.Önceki KM'></th>
          <th><cf_get_lang dictionary_id='48090.Son KM'></th>
          <th style="text-align:right;"><cf_get_lang dictionary_id='58583.Fark'></th>
          <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
          <th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_vehicles&event=add_km" target="blank_"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
      </tr>  
  </thead> 
  <tbody>  
      <cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1>
          <cfif get_km_search.recordcount>
              <cfset aratoplam = 0>	
              <cfoutput query="get_km_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                      <tr>
                          <td>#currentrow#</td>
                          <td><font color="red"><cfif is_offtime eq 1><cf_get_lang dictionary_id='48229.Mesai Dışı'> </cfif><cfif is_allocate eq 1 and is_residual neq 1>AT</font></td></cfif>
                          <td>#assetp#</td>
                          <td>#zone_name# / #branch_name# / #department_head#</td>
                          <td><a href="javascript://" class="tableyazi" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_km_search.employee_id#','medium');">#EMP_NAME#</a></td>
                          <td>#USAGE_PURPOSE#</td>
                          <td>#GROUP_NAME#</td>
                          <td>#dateformat(start_date,dateformat_style)#</td>
                          <td>#dateformat(finish_date,dateformat_style)#</td>
                          <td style="text-align:right;">#tlformat(km_start)#</td>
                          <td style="text-align:right;">#tlformat(km_finish)#</td>
                          <td style="text-align:right;">#tlformat(km_finish - km_start)#</td>
                          <td>#left(detail,30)#</td>
                          <td width="20"><a href="#request.self#?fuseaction=assetcare.list_vehicles&assetp_id=#assetp_id#&event=upd_km&km_control_id=#km_control_id#" target="blank_"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                      </tr>
                      <cfset aratoplam = aratoplam + (km_finish - km_start)>
                  <cfif isDefined("attributes.is_assetp") and attributes.is_assetp eq 1 and  ASSETP[currentrow] neq ASSETP[currentrow+1]>
                      <tr class="total">
                          <td colspan="14" style="text-align:right;"><strong><cf_get_lang dictionary_id='48239.Ara Toplam Km'> : #tlformat(aratoplam)#</strong></td>					
                      </tr>
                      <cfset aratoplam = 0>
                  </cfif>
              </cfoutput>
              <cfif not (isDefined("attributes.is_assetp") and attributes.is_assetp eq 1)>
                  <tr class="total">
                    <td colspan="14" style="text-align:right;"><strong><cf_get_lang dictionary_id='48239.Ara Toplam Km'> : <cfoutput>#tlformat(aratoplam)#</cfoutput></strong></td>
                  </tr>
              </cfif>
              <tr class="total">
                  <td colspan="14" style="text-align:right;"><strong><cf_get_lang dictionary_id='48244.Toplam Km'> : <cfoutput>#tlformat(get_total_km.total_km)#</cfoutput></strong></td>
              </tr>
                
          <cfelse>
              <tr>
                  <td colspan="14"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
              </tr>
          </cfif>
      <cfelse>
          <tr>
              <td colspan="14"><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</td>
          </tr>
      </cfif>
  </tbody>
</cf_grid_list>
<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif isdefined("attributes.branch_id")>
	  <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined("attributes.branch")>
	  <cfset url_str = "#url_str#&branch=#attributes.branch#">
	</cfif>
	<cfif isdefined("attributes.is_submitted")>
	  <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
	</cfif>
	<cfif isdefined("attributes.assetp_id")>
	  <cfset url_str = "#url_str#&assetp_id=#attributes.assetp_id#">
	</cfif>
	<cfif isdefined("attributes.assetp_name")>
	  <cfset url_str = "#url_str#&assetp_name=#attributes.assetp_name#">
	</cfif>
	<cfif isdefined("attributes.employee_id")>
	  <cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
	</cfif>
	<cfif isdefined("attributes.employee_name")>
	  <cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
	</cfif>
	<cfif isdefined("attributes.is_offtime")>
	  <cfset url_str = "#url_str#&is_offtime=#attributes.is_offtime#">
	</cfif>
	<cfif isdefined("attributes.usage_purpose_id")>
	  <cfset url_str = "#url_str#&usage_purpose_id=#attributes.usage_purpose_id#">
	</cfif>
	<cfif isdefined("attributes.assetp_group")>
	  <cfset url_str = "#url_str#&assetp_group=#attributes.assetp_group#">
	</cfif>
	<cfif isdefined("attributes.department_id")>
	  <cfset url_str = "#url_str#&department_id=#attributes.department_id#">
	</cfif>
	<cfif isdefined("attributes.department")>
	  <cfset url_str = "#url_str#&department=#attributes.department#">
	</cfif>
	<cfif isdefined("attributes.position_cat_id")>
	  <cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
	</cfif>
	<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	  <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date)#">
	</cfif>
	<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	  <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date)#">
	</cfif>	
    <cfif isdefined("attributes.is_assetp") and len(attributes.is_assetp)>
	  <cfset url_str = "#url_str#&is_assetp=#attributes.is_assetp#">
	</cfif>	
	<!-- sil -->
      <cf_paging 
        page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="assetcare.form_search_km#url_str#">
  <!-- sil -->
</cfif>
<cfsetting showdebugoutput="yes">
