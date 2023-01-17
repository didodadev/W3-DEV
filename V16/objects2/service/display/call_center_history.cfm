<cfsetting showdebugoutput="no">
<cfquery name="GET_SERVICE_HISTORY" datasource="#DSN#">
	SELECT
		SH.*,
		S.SERVICE_NO,
		S.SERVICE_BRANCH_ID
	FROM
		G_SERVICE_HISTORY SH,
		G_SERVICE S
	WHERE
        SH.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SERVICE_ID#">  AND S.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SERVICE_ID#">
</cfquery>

<cfquery name="get_cat" datasource="#DSN#">
  SELECT SERVICECAT,SERVICECAT_ID FROM G_SERVICE_APPCAT 
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

	<table width="100%" cellpadding="2" cellspacing="1">
		<td class="color-row">		
		<table width="100%" cellpadding="2" cellspacing="1">
		<tr class="color-list" height="20">
		  <td width="50" class="formbold"><cf_get_lang_main no='75.No'></td>
		  <td class="formbold" width="100"><cf_get_lang_main no ='330.Tarih'></td>
          <td class="formbold"><cf_get_lang_main no='74.Kategori'></td>		  
		  <td class="formbold" width="75"><cf_get_lang_main no='70.Aşama'></td>
		  <td class="formbold" width="125"><cf_get_lang_main no ='1174.İşlem Yapan'></td>
		  <td class="formbold"><cf_get_lang_main no='217.Açıklama'></td>
        </tr>
   <cfset counter = 1>
    <cfif GET_SERVICE_HISTORY.recordcount>
	    <cfoutput query="GET_SERVICE_HISTORY" > 
         <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			<td>#SERVICE_NO#</td>
			<td>
			<cfif len(GET_SERVICE_HISTORY.UPDATE_DATE)>
			  #dateformat(date_add('h',session.ep.time_zone,UPDATE_DATE),'dd/mm/yyyy')# (#timeformat(date_add('h',session.ep.time_zone,UPDATE_DATE),'HH:MM')#)
			  <cfelseif len(GET_SERVICE_HISTORY.record_date)>
			  #dateformat(date_add('h',session.ep.time_zone,GET_SERVICE_HISTORY.record_date),'dd/mm/yyyy')# (#timeformat(date_add('h',session.ep.time_zone,record_date),'HH:MM')#)
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
			  <td title="#service_detail#">&nbsp;#left(service_detail,50)#</td>
		  </tr>
		   <cfset counter = counter +1>
        </cfoutput> 
	<cfelse>
          <tr class="color-row"> 
		  	<td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		  </tr>
	</cfif>
		</table>
		
	

