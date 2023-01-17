<cfinclude template="../login/send_login.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.ship_method" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>	
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>
<cfparam name="attributes.ship_stage" default="">
<cfparam name="attributes.process_stage_type" default="">

<cfquery name="GET_SHIP_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		<cfif isdefined("session.pp")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined("session.ww")>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		<cfelse>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%stock.list_packetship%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_SHIP_RESULT" datasource="#DSN2#">
		SELECT 
			SR.SHIP_FIS_NO,
			SR.OUT_DATE,
			SR.DELIVERY_DATE,
			SR.SHIP_RESULT_ID,
			SR.SHIP_METHOD_TYPE,
			SR.SHIP_STAGE,
			SMT.SHIP_METHOD,
			SR.SERVICE_COMPANY_ID
		FROM 
			SHIP_RESULT SR,
			#dsn_alias#.SHIP_METHOD SMT
		WHERE 
			SR.SHIP_METHOD_TYPE = SMT.SHIP_METHOD_ID
		 <cfif len(session.pp.company_id) and len(session.pp.company_id)>
		  	AND SR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		 <cfelseif len(session.ww.userid) and len(session.ww.userid)>
		  	AND SR.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		  </cfif>
		  <cfif len(attributes.keyword)>
			AND (SR.SHIP_FIS_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR SR.REFERENCE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
		  </cfif>
		  <cfif len(attributes.process_stage_type)>
		    AND SR.SHIP_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_type#"></cfif>
		  <cfif len(attributes.start_date)>
			AND SR.OUT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		  </cfif>
		  <cfif len(attributes.finish_date)>
		  	AND SR.OUT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		  </cfif>
		ORDER BY 
			SR.SHIP_RESULT_ID DESC
	</cfquery>
<cfelse>
	<cfset get_ship_result.recordCount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_ship_result.recordcount#'>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
	    <td align="right" style="text-align:right;">
		<table>
		<cfform name="form" method="post" action="#request.self#?fuseaction=objects2.list_packetship">
		<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<tr>
				<td><cf_get_lang_main no='48.Filtre'></td>
				<td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" style="width:100px;"></td>
				<td>
					<select name="process_stage_type" id="process_stage_type" style="width:90px;">
					<option value=""><cf_get_lang_main no='70.Asama'></option>
					<cfoutput query="get_ship_stage">
						<option value="#process_row_id#" <cfif (attributes.process_stage_type eq process_row_id)>selected</cfif>>#stage#</option>
					</cfoutput>
					</select>
				</td>
				<td><cfinput value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" type="text" name="start_date" validate="eurodate" maxlength="10" message="Ltfen Tarih Formatini Dzeltiniz !" style="width:65px;">
					<cf_wrk_date_image date_field="start_date">
				</td>
				<td><cfinput value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" type="text" name="finish_date" style="width:65px;" validate="eurodate" maxlength="10" message="Ltfen Tarih Formatini Dzeltiniz !">
					<cf_wrk_date_image date_field="finish_date">
				</td>
				<td width="25">
				  <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				  <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
				<td><cf_wrk_search_button></td>
			</tr>
			</cfform>
		</table>
    	</td>
	</tr>
</table>

<table cellpadding="2" cellspacing="1" border="0" width="100%" align="center">
	<tr class="color-header" height="22">
		<td width="25" class="form-title"><cf_get_lang_main no='75.No'></td>
		<td class="form-title" width="70">Sevk No</td>
		<td class="form-title">Taşıyıcı</td>
		<td class="form-title">Sevk Yöntemi</td>
		<td class="form-title"><cf_get_lang_main no='70.Asama'></td>
		<td class="form-title">Depo Çıkış</td>
		<td class="form-title">Teslim</td>
	</tr>
	<cfif get_ship_result.recordcount>
	  <cfset process_list=''>
	  <cfset transport_comp_list = ''>
		<cfoutput query="get_ship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(get_ship_result.ship_stage) and not listfind(process_list,get_ship_result.ship_stage)>
				<cfset process_list = listappend(process_list,get_ship_result.ship_stage)>
			</cfif>
			<cfif len(get_ship_result.service_company_id) and not listfind(transport_comp_list,get_ship_result.service_company_id)>
				<cfset transport_comp_list = listappend(transport_comp_list,get_ship_result.service_company_id)>
			</cfif>
		</cfoutput>
		<cfif len(process_list)>
			<cfset process_list=listsort(process_list,"numeric","ASC",",")>
			<cfquery name="get_process_type" datasource="#dsn#">
				SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#)
			</cfquery>
			<cfset main_process_list = listsort(listdeleteduplicates(valuelist(get_process_type.process_row_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(transport_comp_list)>
			<cfset transport_comp_list=listsort(transport_comp_list,"numeric","ASC",",")>
			<cfquery name="get_trans_comp" datasource="#dsn#">
				SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#transport_comp_list#)
			</cfquery>
			<cfset main_transport_comp_list = listsort(listdeleteduplicates(valuelist(get_trans_comp.company_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfoutput query="get_ship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#currentrow#</td>
				<td><a href="#request.self#?fuseaction=objects2.dsp_packetship&ship_result_id=#ship_result_id#" class="tableyazi">#ship_fis_no#</a></td>
				<td>#get_trans_comp.fullname[listfind(main_transport_comp_list,service_company_id,',')]#</td>
				<td>#ship_method#</td>
				<td>#get_process_type.stage[listfind(main_process_list,ship_stage,',')]#</td>
				<td>#dateformat(out_date,'dd/mm/yyyy')# #timeformat(out_date,'HH:MM')#<!--- #timeformat(date_add('h',session.pp.time_zone,out_date),'HH:MM')# ---></td>
				<td>#dateformat(delivery_date,'dd/mm/yyyy')# #timeformat(delivery_date,'HH:MM')#<!--- #timeformat(date_add('h',session.pp.time_zone,delivery_date),'HH:MM')# ---></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row" height="20">
			<td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayit Bulunamadi'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
		</tr>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str="objects2.list_packetship">
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.ship_method)>
		<cfset url_str = "#url_str#&ship_method=#attributes.ship_method#">
	</cfif>
	<cfif len(attributes.form_submitted)>
		<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
	</cfif>
	<cfif len(attributes.start_date)>
		<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
	</cfif>
	<cfif len(attributes.finish_date)>
		<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
	</cfif>
	<cfif isdefined("attributes.process_stage_type") and len(attributes.process_stage_type)>
		<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#" >
    </cfif>
  <table width="98%" border="0" cellpadding="0" cellspacing="0" align="center" height="35">
    <tr>
      <td> 
	  <cf_pages page="#attributes.page#" 
		  maxrows="#attributes.maxrows#" 
		  totalrecords="#attributes.totalrecords#" 
		  startrow="#attributes.startrow#" 
		  adres="#url_str#&form_submitted=1"> 
	  </td>
      <!-- sil --><td height="35" align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayit'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
<br/>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
