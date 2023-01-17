<cfquery name="GET_VERSIYON" datasource="#DSN#">
	SELECT CONT_HEAD FROM CONTENT WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_id#">
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default="">
<cfparam name="attributes.totalrecords" default="">

<table cellpadding="0" cellspacing="0" border="0" style="width:100%; height:100%">
  	<tr>
    	<td style="vertical-align:top">
      		<table border="0" cellspacing="0" cellpadding="0" style="width:98%; height:35px; text-align:center">
        		<tr>
          			<td class="headbold"><cf_get_lang no='9.Versiyon Tarihçesi'> : <cfoutput>#get_versiyon.cont_head#</cfoutput> </td>
        		</tr>
      		</table>
      		<table cellSpacing="0" cellpadding="0" border="0" style="width:98%; text-align:center">
        		<tr class="color-border">
          			<td>
            			<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
              				<tr class="color-header" style="height:22px;">
                				<td class="form-title" style="width:100px;"><cf_get_lang no='147.Versiyon No'></td>
								<td class="form-title"><cf_get_lang no='148.Versiyon Tarihi'></td>
								<td class="form-title"><cf_get_lang_main no='479.Güncelleyen'></td>
              				</tr>
			 				<cfif get_versiyon.recordcount>
			 					<cfquery name="GET_VERSIYON_HISTORY" datasource="#DSN#">
									SELECT 
										UPDATE_MEMBER,
										WRITE_VERSION,
										VERSION_DATE 
									FROM 
										CONTENT_HISTORY 
									WHERE 
										CONTENT_HISTORY_ID IN 
										(
											SELECT MAX(CONTENT_HISTORY_ID) 
											FROM 
												CONTENT_HISTORY 
											WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_id#">
											GROUP BY VERSION_DATE,WRITE_VERSION
										)
									ORDER BY UPDATE_DATE DESC
								</cfquery>
								<cfoutput query="get_versiyon_history">
								 	<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
										<td>#write_version#</td>
										<td>#dateformat(version_date,dateformat_style)#</td>
										<td>#get_emp_info(get_versiyon_history.update_member,0,0,0)#</td>
								  	</tr>
								</cfoutput>
		   					<cfelse>
								<tr class="color-row" style="height:20px;">
			  						<td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
								</tr>
		  					</cfif>
            			</table>
          			</td>
        		</tr>
      		</table>
		  	<cfif attributes.totalrecords gt attributes.maxrows>
			  	<table cellpadding="0" cellspacing="0" border="0" style="width:98%; height:30px; text-align:center">
					<tr>
				  		<td> <cf_pages 
							page="#attributes.page#" 
							maxrows="#attributes.maxrows#" 
							totalrecords="#attributes.totalrecords#" 
							startrow="#attributes.startrow#" 
							adres="hr.popup_list_employees_app#url_str#"> </td>
					  <!-- sil --><td style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
					</tr>
				</table>
		  	</cfif>
		</td>
	</tr>
</table>
