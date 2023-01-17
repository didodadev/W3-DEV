<cfquery name="GET_SERVICE_HISTORY" datasource="#DSN3#">
	SELECT
		SERVICE_HISTORY.*,
		SERVICE.SERVICE_NO,
		SERVICE.SERVICE_BRANCH_ID
	FROM
		SERVICE_HISTORY,
		SERVICE
	WHERE
        SERVICE_HISTORY.SERVICE_ID = #URL.SERVICE_ID# AND SERVICE.SERVICE_ID = #URL.SERVICE_ID#
</cfquery>

<cfquery name="get_cat" datasource="#DSN3#">
  SELECT SERVICECAT,SERVICECAT_ID FROM SERVICE_APPCAT 
</cfquery>
<cfif get_cat.recordcount>
  <CFSET cat_ids = valuelist(get_cat.SERVICECAT_ID)>
  <cfset cat_names = valuelist(get_cat.SERVICECAT)>
</cfif>
<cfquery name="GET_STATUS" datasource="#DSN#">
  SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS 
</cfquery>
<cfif GET_STATUS.recordcount>
  <cfset status_ids = valuelist(GET_STATUS.PROCESS_ROW_ID)>
  <cfset status_names = valuelist(GET_STATUS.STAGE)>
</cfif>



<table width="98%" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
	<td>
      <table width="100%" cellpadding="2" cellspacing="1">
        <tr class="color-header" height="22">
			<td class="form-title">
			<a href="javascript://" onclick="gizle_goster_img('orderp_img14','orderp_img24','list_offers_take_menu4');"><img src="/images/listele_down.gif" title="Ayrıntıları Gizle" width="12" height="7" border="0" align="absmiddle" id="orderp_img14" style="cursor:pointer;"></a>
		  	<a href="javascript://" onclick="gizle_goster_img('orderp_img14','orderp_img24','list_offers_take_menu4');"><img src="/images/listele.gif" title="Ayrıntıları Göster" width="7" height="12" border="0" align="absmiddle" id="orderp_img24" style="display:none;cursor:pointer;"></a>
			Servis Tarihçesi</td>
		</tr>
		<tr id="list_offers_take_menu4">
		<td class="color-row">		
		<table width="100%" cellpadding="2" cellspacing="1">
		<tr class="color-list" height="20">
		  <td width="50" class="formbold">No</td>
		  <td class="formbold" width="100">Tarih</td>
		  <td class="formbold" width="110">Şube</td>
          <td class="formbold"><cf_get_lang_main no='74.Kategori'></td>		  
		  <td class="formbold" width="75"><cf_get_lang_main no='70.Aşama'></td>
		  <td class="formbold" width="125">İşlem Yapan</td>
		  <td class="formbold">Açıklama</td>
		  <td width="15"></td>   
        </tr>
   <cfset counter = 1>
    <cfif GET_SERVICE_HISTORY.recordcount>
	    <cfoutput query="GET_SERVICE_HISTORY" > 
         <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			<td>
			#SERVICE_NO#
			</td>
			<td>
			<cfif len(GET_SERVICE_HISTORY.UPDATE_DATE)>
			  #dateformat(date_add('h',session.ep.time_zone,UPDATE_DATE),dateformat_style)# (#timeformatdate_add('h',session.ep.time_zone,(UPDATE_DATE),timeformat_style)#)
			  <cfelseif len(GET_SERVICE_HISTORY.record_date)>
			  #dateformat(date_add('h',session.ep.time_zone,GET_SERVICE_HISTORY.record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)
			  </cfif>
				  </td>
				  <td>
			<cfif len(SERVICE_BRANCH_ID)>
			  	<cfset attributes.branch_id = SERVICE_BRANCH_ID>
				<cfinclude template="../query/get_branch.cfm">
				#GET_BRANCH.BRANCH_NAME#
			  </cfif>
				  </td>
				  <td>
					<!---#GET_CAT.SERVICECAT#--->
					<cfif listfindnocase(cat_ids,SERVICECAT_ID) neq 0 and (listlen(cat_names) neq 0)>
					  #listgetat(cat_names,listfindnocase(cat_ids,SERVICECAT_ID))#
					</cfif>
				  </td>			  
				  <td>
				   <!---#GET_STATUS.SERVICE_STATUS#--->
				   <cfif listfindnocase(status_ids,SERVICE_STATUS_ID) neq 0 and (listlen(status_names) neq 0)>
					  #listgetat(status_names,listfindnocase(status_ids,SERVICE_STATUS_ID))#
					</cfif>
				  </td>
                  <td>
				   <cfif len(GET_SERVICE_HISTORY.UPDATE_MEMBER)>
					#get_emp_info(GET_SERVICE_HISTORY.UPDATE_MEMBER,0,0)#
				  <cfelseif len(GET_SERVICE_HISTORY.RECORD_MEMBER)>
				 	 #get_emp_info(GET_SERVICE_HISTORY.RECORD_MEMBER,0,0)#
				   </cfif>
			  </td>
			  <td>&nbsp;#service_detail#</td>
			  <td>
			  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=service.popup_upd_service_history_detail&service_history_id=#SERVICE_HISTORY_ID#','small');"><img src="/images/update_list.gif" border="0"></a>
			  </td>
		  </tr>
		   <cfset counter = counter +1>
        </cfoutput> 
	<cfelse>
          <tr class="color-row"> 
		  	<td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		  </tr>
	</cfif>
		</table>
		
		</td>
		</tr>
	
	
      </table>
	</td>
</tr>
</table>
