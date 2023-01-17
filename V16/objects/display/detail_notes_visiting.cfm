<cfsetting showdebugoutput="no">
<cfparam name="attributes.keyword" default="">
<cfquery name="DETAIL_NOTES_VISITED" datasource="#DSN#">
	SELECT 
		RECORD_DATE,
		V_NOTE_ID,
		DETAIL,
		RECORD_EMP
	FROM 
		VISITING_NOTES 
	WHERE 
		<cfif isdefined("session.ep.userid")>
		NOTE_TAKEN_ID = #session.ep.userid#
		<cfelseif isdefined("session.pp.userid")>
		NOTE_TAKEN_ID = #session.pp.userid#
		</cfif>
		<cfif len(attributes.keyword)>
		AND DETAIL LIKE '%#attributes.keyword#%'
		</cfif>
	ORDER BY 
		V_NOTE_ID DESC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#detail_notes_visited.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Notlar',57422)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="notes_form" id="notes_form" method="post" action="#request.self#?fuseaction=objects.popup_all_visiting">
			<cf_box_search more="0">
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('notes_form' , #attributes.modal_id#)"),DE(""))#">
				</div>	
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th width="140"><cf_get_lang dictionary_id='32493.Not Bırakan'></th>
					<th width="70"><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='57491.Saat'></th>
					<th width="20"><a href="javascript://"><i class="fa fa-minus"></i></a></th>
				</tr>  
			</thead>
			<tbody>
				<cfif detail_notes_visited.recordcount>
					<cfoutput query="detail_notes_visited" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>
								<div id="notes_ajax#currentrow#">
									<a href="javascript://" onClick="connectAjax(#currentrow#,#V_NOTE_ID#);" class="tableyazi">#left(detail_notes_visited.detail,40)#...</a>
								</div> 
							</td>
							<td><cfif len(detail_notes_visited.record_emp)>#get_emp_info(detail_notes_visited.record_emp,0,0)#<cfelse>-</cfif></td>
							<td>#dateformat(detail_notes_visited.record_date,dateformat_style)#</td>
							<td>#timeformat(detail_notes_visited.record_date,timeformat_style)# </td>
								<cfsavecontent variable="delete_note"><cf_get_lang dictionary_id ='34188.Kayıtlı Notu Siliyorsunuz Emin misiniz'></cfsavecontent>
							<td><a style="cursor:pointer" onClick="if(confirm('#delete_note#')){AjaxPageLoad('#request.self#?fuseaction=objects.emptypopup_del_visiting_notes&note_id=#V_NOTE_ID#&draggable=#attributes.draggable?:""#&modal_id=#attributes.modal_id?:""#','notes_ajax#currentrow#',1,'Siliniyor...');gizle(notes_#currentrow#);gizle(NOTES_DETAIL_LIST#currentrow#);}else return false;"><i class="fa fa-minus"></i></a></td>
						</tr> 
						<tr id="NOTES_DETAIL_LIST#currentrow#" style="display:none;" class="nohover">
							<td colspan="5"><div id="show_notes_detail_list#currentrow#"></div></td>
						</tr>
					</cfoutput> 
					<cfelse>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>    
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects.popup_all_visiting"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#"> 
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
function connectAjax(row_id,v_note_id)
{
	$("#NOTES_DETAIL_LIST"+row_id+"").toggle();
	var bb = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_notes_visited&satir_id="+row_id+"&id="+v_note_id+"";
	AjaxPageLoad(bb,'show_notes_detail_list'+row_id+'',0);
}
</script>
