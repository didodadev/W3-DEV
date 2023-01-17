<!--- ************************************
STATUS = 0 -> REZERVASYON YAPILABİLİR
STATUS = 1 ->REZERVE EDİLDİ
STATUS = 2 ->TESLİM EDİLDİ
************************* --->
<cfquery name="GET_ASSET_NAME" datasource="#DSN#">
	SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE	ASSETP_ID = #attributes.asset_id#
</cfquery>
<cfquery name="GET_ASSETP_RESERVE" datasource="#dsn#">
	SELECT 
		ASSETP_ID, 
		ASSETP_RESID,
		EVENT_ID, 
		DETAIL,
		RECORD_EMP, 
		STARTDATE, 
		FINISHDATE,
		RETURN_DATE,
		STATUS
	FROM 
		ASSET_P_RESERVE
	WHERE 
		ASSETP_ID = #attributes.ASSET_ID#
	ORDER BY
		STARTDATE DESC,
		FINISHDATE DESC,
		RETURN_DATE DESC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_assetp_reserve.recordcount#'>
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="right">
</cfsavecontent>
<cf_box title="#getLang('main',61)#: <cfoutput>#GET_ASSET_NAME.ASSETP#</cfoutput>" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">

<cfform name="search" action="#request.self#?fuseaction=asset.popup_list_assetp_rezerve" method="post">
<input name="asset_id" id="asset_id" type="hidden" value="<cfoutput>#attributes.asset_id#</cfoutput>"> 
<cf_box_search>
	<div class="form-group small" id="item_maxrows">
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
		<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" >
	</div>
	<div class="form-group">
		<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
		
	</div>
	<div class="form-group">
		<a class="ui-btn ui-btn-gray2" alt="<cf_get_lang no='7.Rezervasyonlar'>" title="<cf_get_lang no='7.Rezervasyonlar'>" href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_form_assetp_reserve&assetp_id=#attributes.asset_id#&res_control=1</cfoutput>')">
		<i class="fa fa-address-book-o"></i></a>	
		
	</div>
	
</cf_box_search>
</cfform>

<cf_grid_list>
	<thead>
		<tr>
			<th width="243"><cf_get_lang_main no='1713.Olay'></th>
			<th width="219"><cf_get_lang_main no='89.Başlama'></th>
			<th width="342"><cf_get_lang_main no='90.Bitiş'></th>
			<th width="219"><cf_get_lang_main no ='233.Teslim Tarihi'></th>
			<th><cf_get_lang_main no ='217.Açıklama'></th>
			<th width="274"><cf_get_lang_main no='71.Kayıt'></th>
			<th width="55">&nbsp;</th>
		</tr>
	</thead>
	<tbody>
		<cfif GET_ASSETP_RESERVE.RECORDCOUNT>
		<cfoutput query="get_assetp_reserve" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td>
					<cfquery name="GET_ASSET_RESERVESS" datasource="#dsn#">
						SELECT 
							* 
						FROM 
							ASSET_P_RESERVE 
						WHERE 
							ASSETP_ID = #attributes.ASSET_ID#
					</cfquery>
					<cfif len(GET_ASSET_RESERVESS.EVENT_ID)>
					  <cfset attributes.EVENT_ID = GET_ASSET_RESERVESS.EVENT_ID>
					  <cfinclude template="../query/get_event_head.cfm">
						#EVENT_HEAD.EVENT_HEAD# (<cf_get_lang_main no='1713.Olay'>)
					<cfelseif len(GET_ASSET_RESERVESS.PROJECT_ID)>
					  <cfset attributes.PROJECT_ID = GET_ASSET_RESERVESS.PROJECT_ID>
					  <cfinclude template="../query/get_project_name.cfm">
						#GET_PROJECT_NAME.PROJECT_HEAD# (<cf_get_lang_main no='4.Proje'>)
					<cfelseif len(GET_ASSET_RESERVESS.CLASS_ID)>
					  <cfset attributes.CLASS_ID = GET_ASSET_RESERVESS.CLASS_ID>
					  <cfinclude template="../query/get_class_name.cfm">
						#GET_CLASS_NAMES.CLASS_NAME# (<cf_get_lang no='128.Ders'>)
					<cfelse>
					  <cf_get_lang no='73.Olaysız'>
					</cfif>
				</td>
				<td>#dateformat(STARTDATE,dateformat_style)#</td>
				<td>#dateformat(FINISHDATE,dateformat_style)#</td>
				<td><cfif LEN(GET_ASSETP_RESERVE.RETURN_DATE)>#dateformat(GET_ASSETP_RESERVE.RETURN_DATE,dateformat_style)#</cfif></td>
				<td><cfif len(GET_ASSETP_RESERVE.detail)>#GET_ASSETP_RESERVE.detail#</cfif></td>
				<td>#get_emp_info(GET_ASSETP_RESERVE.RECORD_EMP,0,0)#</td>
				<td>
					<cfif status eq 1>
						<a href="#request.self#?fuseaction=asset.emptypopup_upd_assetp_reserve&asset_id=#attributes.asset_id#&ASSETP_RESID=#ASSETP_RESID#" alt="<cf_get_lang no='17.Teslim Edildi'>" title="<cf_get_lang no='17.Teslim Edildi'>"><i class="fa fa-icon-check"></i></a>
					</cfif>
				</td>
			</tr>
		</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
 	 </tbody>
  </cf_grid_list>
<cfif attributes.totalrecords gt attributes.maxrows>	
				<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="asset.popup_list_assetp_rezerve&asset_id=#attributes.asset_id#&draggable=#attributes.draggable#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">	
</cfif>

</cf_box>