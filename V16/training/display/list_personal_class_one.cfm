<cfsavecontent variable="ocak"><cf_get_lang_main no='180.Ocak'></cfsavecontent> 
<cfsavecontent variable="subat"><cf_get_lang_main no='181.şubat'></cfsavecontent> 
<cfsavecontent variable="mart"><cf_get_lang_main no='182.mart'></cfsavecontent> 
<cfsavecontent variable="nisan"><cf_get_lang_main no='183.nisan'></cfsavecontent> 
<cfsavecontent variable="mayis"><cf_get_lang_main no='184.mayıs'></cfsavecontent> 
<cfsavecontent variable="haziran"><cf_get_lang_main no='185.haziran'></cfsavecontent> 
<cfsavecontent variable="temmuz"><cf_get_lang_main no='186.temmuz'></cfsavecontent> 
<cfsavecontent variable="agustos"><cf_get_lang_main no='187.ağustos'></cfsavecontent> 
<cfsavecontent variable="eylul"><cf_get_lang_main no='188.eylül'></cfsavecontent> 
<cfsavecontent variable="ekim"><cf_get_lang_main no='189.ekim'></cfsavecontent> 
<cfsavecontent variable="kasim"><cf_get_lang_main no='190.kasım'></cfsavecontent> 
<cfsavecontent variable="aralik"><cf_get_lang_main no='191.aralık'></cfsavecontent>
<cfset my_month_list="#ocak#,#subat#,#mart#,#nisan#,#mayis#,#haziran#,#temmuz#,#agustos#,#eylul#,#ekim#,#kasim#,#aralik#">
<cfparam name="attributes.keyword" default="">
<!--- <cfparam name="attributes.is_valid" default=""> --->
<cfif isdefined("attributes.is_submit")>
<cfinclude template="../query/get_trainin_join_requests.cfm">
<cfelse>
	<cfset get_training_join_requests.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_training_join_requests.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif fusebox.circuit is "myhome">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
<cfinclude template="../../objects/display/tree_back.cfm">
<td <cfoutput>#td_back#</cfoutput>>		
    <cfinclude template="../../myhome/display/position_left_menu.cfm">
</td>
<td valign="top">
</cfif>
<cfform name="form1" method="post" action="#request.self#?fuseaction=training.list_one_class_request">
<input type="hidden" name="is_submit" id="is_submit" value="1">
<cf_big_list_search title="#getLang('training',93)#"> 
	<cf_big_list_search_area>
		<table>
			<tr> 
				<td><cf_get_lang_main no='48.Filtre'></td>
				<td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" style="width:100px;"></td>
				<!--- <td>
					<select name="IS_VALID">
					<option value="-1" <cfif attributes.IS_VALID EQ -1>SELECTED</cfif>><cf_get_lang no ='116.Tüm Durumlar'></option>
					<option value="1" <cfif attributes.IS_VALID EQ 1>SELECTED</cfif>><cf_get_lang no ='129.Onaylanan'></option>
					<option value="0" <cfif attributes.IS_VALID EQ 0>SELECTED</cfif>><cf_get_lang no ='139.Reddedilen'></option>
					</select>
				</td> --->
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;"></td>
				<td><cf_wrk_search_button></td>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
			</tr>
		</table>
	</cf_big_list_search_area>
</cf_big_list_search> 
</cfform>
<cf_big_list>
	<thead>
		<tr> 
			<th width="35"><cf_get_lang_main no='1165.Sıra'></th>
			<!--- <th><cf_get_lang_main no='158.Ad Soyad'></th> --->
			<th><cf_get_lang_main no='7.Eğitim'></th>
			<th><cf_get_lang no='94.Eğitim Tarihi'></th>
			<th><cf_get_lang no='95.Talep  Tarihi'></th>
			<th>Tip</th>
			<th><cf_get_lang_main no='344.Durum'></th>
			<!--- <th><cf_get_lang_main no='344.Durumu'></th>
			<th><cf_get_lang no ='136.Onay Veya Red Tarihi'></th> --->
			<th  class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_form_add_class_join_request','small');"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></th> 

		</tr>
	</thead>
	<tbody>
		<cfif get_training_join_requests.recordcount>
			<cfset stage_id_list=''>
			<cfoutput query="get_training_join_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<cfif len(process_stage) and not listfind(stage_id_list,process_stage)>
					<cfset stage_id_list = Listappend(stage_id_list,process_stage)>
				</cfif>
			</cfoutput>
			<cfif len(stage_id_list)>
				<cfset stage_id_list=listsort(stage_id_list,"numeric","ASC",",")>
				<cfquery name="get_content_process_stage" datasource="#DSN#">
					SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stage_id_list#">) ORDER BY PROCESS_ROW_ID
				</cfquery>
				<cfset stage_id_list = listsort(listdeleteduplicates(valuelist(get_content_process_stage.process_row_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfoutput query="get_training_join_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<tr>
					<td width="35">#currentrow#</td>
					<td>
						<cfif request_type eq 2>
							#other_train_name# (Katalog Dışı)
						<cfelse>
							#train_name# <cfif request_type eq 1>(Katalog)</cfif>
						</cfif>
					</td>
					<td>
						<cfif len(start_date) and start_date gt '1/1/1900' and len(finish_date) and finish_date gt '1/1/1900'>
							<cfif dateformat(start_date,dateformat_style) eq dateformat(now(),dateformat_style) or dateformat(finish_date,dateformat_style) eq dateformat(now(),dateformat_style) ><font  color="##FF0000"> </cfif>
							  <cfset startdate = date_add('h', session.ep.time_zone, start_date)>
							  <cfset finishdate = date_add('h', session.ep.time_zone, finish_date)>
							#dateformat(startdate,dateformat_style)# (#timeformat(startdate,timeformat_style)#) - #dateformat(finishdate,dateformat_style)# (#timeformat(finishdate,timeformat_style)#) 
						<cfelseif len(MONTH_ID) and MONTH_ID>
							#ListGetAt(my_month_list,MONTH_ID)# - #SESSION.EP.PERIOD_YEAR#
						</cfif>
					</td>
					<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
					 <td>#type#</td>
					 <td><!---<cfif type eq 'Ders Talebi' or type eq 'Duyuru Talebi'>---><cfif process_stage eq 1>Onaylandı<cfelseif process_stage eq 0>Reddedildi<cfelse> - </cfif><!---<cfelse><cfif len(trim(process_stage)) and process_stage neq 0>#get_content_process_stage.stage[listfind(stage_id_list,process_stage,',')]#<cfelse>-</cfif></cfif>---></td>
					 <!-- sil -->
					<td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_form_upd_class_join_request&request_id=#REQUEST_ROW_ID#','small');" ><img src="/images/update_list.gif" title="<cf_get_lang no ='167.Ayrıntılar'>"></a></td> <!-- sil -->
				</tr>
			</cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="9"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset adres = "">
<cfif fusebox.circuit is "myhome">
	<cfset adres = "myhome.list_class_request">
</cfif>
<cfif fusebox.circuit is "training">
	<cfset adres = "training.list_one_class_request">
</cfif>
<cfif len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<!--- <cfif isdefined("attributes.valid") and len(attributes.valid)>
	<cfset adres = "#adres#&is_valid=#attributes.is_valid#">
</cfif> --->
<cfif isdefined("attributes.is_submit")>
	<cfset adres = "#adres#&is_submit=#attributes.is_submit#">
</cfif>
<cf_paging 
    page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
				adres="#adres#">
<cfif fusebox.circuit is "myhome">
</td></tr></table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
