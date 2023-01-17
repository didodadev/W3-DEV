<cf_xml_page_edit fuseact="bank.list_pos_operation">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.pos_id" default="">
<cfparam name="attributes.schedule_id" default="">
<cfparam name="attributes.status" default=1>
<cfparam name="attributes.is_schedule" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfquery name="GET_POS_ALL" datasource="#DSN3#">
	SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE WITH (NOLOCK) WHERE POS_TYPE IS NOT NULL AND IS_ACTIVE = 1 ORDER BY (SELECT ACCOUNT_NAME FROM ACCOUNTS WHERE ACCOUNT_ID = BANK_ACCOUNT),LEFT(CARD_NO,3),ISNULL(NUMBER_OF_INSTALMENT,0)
</cfquery>
<cfquery name="getSchedule" datasource="#dsn#">
	SELECT SCHEDULE_NAME,SCHEDULE_ID FROM SCHEDULE_SETTINGS WHERE ISNULL(IS_POS_OPERATION,0) = 1
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>	
	<cfquery name="get_rule_row" datasource="#dsn3#">
		SELECT DISTINCT PO.POS_OPERATION_ID,
			(SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WITH (NOLOCK) WHERE PAYMENT_TYPE_ID = POS_ID) CARD_NO,
			IS_FLAG,
			ISNULL((SELECT COUNT(*) FROM POS_OPERATION_ROW WITH (NOLOCK) WHERE POS_OPERATION_ID = PO.POS_OPERATION_ID),0) COUNT_ROW,
			ISNULL((SELECT COUNT(*) FROM POS_OPERATION_ROW_HISTORY WITH (NOLOCK) WHERE POS_OPERATION_ID = PO.POS_OPERATION_ID AND ISNUMERIC(RESPONCE_CODE) = '00' AND IS_PAYMENT = 0),0) COUNT_ROW_REMAIN,
			PO.*
            <cfif len(attributes.is_schedule) or len(attributes.schedule_id)>
	            ,STR.SCHEDULE_ID,
    	        STR.ROW_NUMBER
            </cfif>
            ,E1.EMPLOYEE_NAME+' '+E1.EMPLOYEE_SURNAME RECORD_EMP_NAME
            ,E2.EMPLOYEE_NAME+' '+E2.EMPLOYEE_SURNAME UPDATE_EMP_NAME
		FROM 
			POS_OPERATION PO WITH (NOLOCK) 
        LEFT JOIN
        	#DSN_ALIAS#.EMPLOYEES E1
        ON
        	E1.EMPLOYEE_ID = PO.RECORD_EMP
        LEFT JOIN
        	#DSN_ALIAS#.EMPLOYEES E2
        ON
        	E2.EMPLOYEE_ID = PO.UPDATE_EMP 
            <cfif len(attributes.is_schedule) or len(attributes.schedule_id)>
	            LEFT JOIN #dsn_alias#.SCHEDULE_SETTINGS_ROW STR ON STR.POS_OPERATION_ID = PO.POS_OPERATION_ID
            </cfif>
		WHERE
			1 = 1
			<cfif isDefined("attributes.status") and len(attributes.status)>
				AND IS_ACTIVE = #attributes.status# 
			</cfif>
			<cfif isDefined("attributes.pos_id") and len(attributes.pos_id)>
				AND POS_ID = #attributes.pos_id# 
			</cfif>
            <cfif len(attributes.is_schedule) and attributes.is_schedule eq 1>
				AND STR.POS_OPERATION_ID IS NOT NULL
            <cfelseif len(attributes.is_schedule) and attributes.is_schedule eq 0>
            	AND STR.POS_OPERATION_ID IS NULL
			</cfif>
            <cfif len(attributes.schedule_id)>
				AND STR.SCHEDULE_ID = #attributes.schedule_id#
			</cfif>
            <cfif len(attributes.keyword)>
            	AND POS_OPERATION_NAME LIKE '#attributes.keyword#%'
            </cfif>
		ORDER BY
			<cfif len(attributes.schedule_id)>
				STR.ROW_NUMBER,
			</cfif>
			POS_OPERATION_NAME
	</cfquery>
<cfelse>
	<cfset get_rule_row.recordcount = 0>
</cfif>
<cf_box >
	<cfform name="bank_list" action="#request.self#?fuseaction=bank.list_pos_operation" method="post">
	<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">

				<cf_box_search > 
			
				
					<div class="form-group">
						<div class="input-group x-15">
							<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('main','keyword',52574)#">
						</div>
					</div>
					<div class="form-group">
						<label><cfoutput>#getLang("bank",49,"Zaman Ayarlı Göreve Dahil")#</cfoutput></label>
					</div>
					<div class="form-group">
						<select name="is_schedule" id="is_schedule" style="width:55px;">
							<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
							<option value="1"<cfif isDefined("attributes.is_schedule") and (attributes.is_schedule eq 1)> selected</cfif>><cf_get_lang dictionary_id='57495.Evet'></option>
							<option value="0"<cfif isDefined("attributes.is_schedule") and (attributes.is_schedule eq 0)> selected</cfif>><cf_get_lang dictionary_id='57496.Hayır'></option>
						</select>
					</div> 
					<div class="form-group">
						<select name="schedule_id" id="schedule_id">
							<option value=""><cfoutput>#getLang("bank",60,"Zaman Ayarlı Göreve")#</cfoutput></option>
							<cfoutput query="getSchedule">
								<option value="#schedule_id#" <cfif attributes.schedule_id eq schedule_id>selected</cfif>>#schedule_name#</option>
							</cfoutput>
						</select>
					</div> 
					<div class="form-group">
						<select name="pos_id" id="pos_id">
							<option value=""><cf_get_lang dictionary_id='48952.Pos Tipi'></option>
							<cfoutput query="get_pos_all">
								<option value="#PAYMENT_TYPE_ID#" <cfif attributes.pos_id eq PAYMENT_TYPE_ID>selected</cfif>>#CARD_NO#</option>
							</cfoutput>
						</select>						 
					</div> 
					<div class="form-group">
						<select name="status" id="status">
							<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
							<option value="1"<cfif isDefined("attributes.status") and (attributes.status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
							<option value="0"<cfif isDefined("attributes.status") and (attributes.status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						</select>
					</div> 
					<div class="form-group">
						<div class="input-group small">
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" maxlength="3">						  					 
						</div>
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
					<div class="form-group">
						<a class="ui-btn ui-btn-update" href="<cfoutput>#request.self#?fuseaction=settings.list_schedule_settings</cfoutput>"><i class="fa fa-clock-o" alt="<cfoutput>#getLang("bank",159,"Zaman Ayarlı Görevler")#</cfoutput>" title="<cfoutput>#getLang("bank",159,"Zaman Ayarlı Görevler")#</cfoutput>"></i></a>
									
					</div>
				</cf_box_search> 
	</cfform>
</cf_box>
<cf_box title="#getLang('','Otomatik Sanal Pos Kuralları',48674)#">
	<cfparam name="attributes.totalrecords" default='#get_rule_row.recordcount#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cf_grid_list>
		<thead>
			<tr>
			<cfset colspan_info = 10>
			<th width="20"><<cf_get_lang dictionary_id='58577.Sıra'></th>
			<th width="150"><cf_get_lang dictionary_id='58233.Tanım'></th>
			<th width="100"><cf_get_lang dictionary_id='57679.POS'></th>
			<th width="100"><cf_get_lang dictionary_id='30114.Hacim'></th>
			<cfif x_show_record_emp eq 1>
				<cfset colspan_info = colspan_info + 1>
				<th width="100"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
			</cfif>
			<cfif x_show_record_date eq 1>
				<cfset colspan_info = colspan_info + 1>
				<th width="150"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
			</cfif>
			<cfif x_show_update_emp eq 1>
				<cfset colspan_info = colspan_info + 1>
				<th width="100"><cf_get_lang dictionary_id='57891.Güncelleyen'></th>
			</cfif>
			<cfif x_show_update_date eq 1>
				<cfset colspan_info = colspan_info + 1>
				<th width="150"><cf_get_lang dictionary_id='40479.Güncelleme Tarihi'></th>
			</cfif>
			<th width="100"><cf_get_lang dictionary_id='57756.Durum'></th>
			<!-- sil -->
			<th width="20" class="header_icn_none" nowrap="nowrap"><i class="wrk-uF0004"></i></th>
			<th width="20" class="header_icn_none">	<i class="fa fa-globe"></i></th>
			<th width="20" class="header_icn_none"><i class="fa fa-cube"  title="<cf_get_lang dictionary_id='51604.Sorunlu Kayıtları İmport Et'>"></i></th>
			<th  class="header_icn_none" width="20" nowrap="nowrap"><i class="fa fa-pencil-square-o"></i></th>
			<th class="header_icn_none" width="20" nowrap="nowrap"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=bank.list_pos_operation&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th><!-- sil -->
			</tr>
		</thead>
		<tbody>
			<cfif get_rule_row.recordcount>
				<cfset employee_id_list=''>
				<cfoutput query="get_rule_row" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td width="100"><a href="#request.self#?fuseaction=bank.list_pos_operation&event=upd&pos_operation_id=#pos_operation_id#" class="tableyazi">#pos_operation_name#</a></td>
						<td width="250">#card_no#</td>
						<td style="text-align:right;">#TLFormat(VOLUME)#</td>
						<cfif x_show_record_emp eq 1>
							<td><cfif len(record_emp)><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi"> #record_emp_name#</a></cfif></td>
						</cfif>
						<cfif x_show_record_date eq 1>
							<td><cfif len(record_date)>#dateformat(dateadd('h',session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#)</cfif></td>
						</cfif>
						<cfif x_show_update_emp eq 1>
							<td><cfif len(update_emp)><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#update_emp#','medium');" class="tableyazi"> #update_emp_name#</a></cfif></td>
						</cfif>
						<cfif x_show_update_date eq 1>
							<td><cfif len(update_date)>#dateformat(dateadd('h',session.ep.time_zone,update_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,update_date),timeformat_style)#)</cfif></td>
						</cfif>
						<td>
							<div id="pos_operation_action_#currentrow#">
								<cfif is_flag eq 1><cf_get_lang dictionary_id='40137.Çalışıyor'></cfif>
							</div>
						</td>
						<!-- sil -->
						<td>
							<cfif is_active eq 1 and not listfindnocase(denied_pages,'bank.emptypopup_add_pos_operation_row')>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='51589.Yapacağınız işlem otomatik sanal pos işlemi için operasyon satırlarını dolduracaktır'><cf_get_lang dictionary_id='48488.Emin misiniz!'></cfsavecontent>
								<a href="javascript://" onClick="if(confirm('#message#')) AjaxPageLoad('#request.self#?fuseaction=bank.emptypopup_add_pos_operation_row&pos_operation_id=#pos_operation_id#&pos_id=#attributes.pos_id#&status=#attributes.status#'); else return false;">
								<i class="wrk-uF0004" alt="<cf_get_lang dictionary_id="51591.Operasyon Satırlarını Yaz">" title="<cf_get_lang dictionary_id="51591.Operasyon Satırlarını Yaz">"></i>
								</a>
							</cfif>
						</td>
						<td width="20" align="center">
							<div id="pos_operation_td_#currentrow#" <cfif is_flag eq 1 or count_row eq 0>style="display:none;"</cfif>>
								<cfif is_active eq 1 and not listfindnocase(denied_pages,'bank.emptypopup_add_pos_operation_action')>
									<i class="fa fa-globe" alt="<cf_get_lang dictionary_id='51600.Sanal Pos Çekimi Yap'>" title="<cf_get_lang dictionary_id='51600.Sanal Pos Çekimi Yap'>" onclick="ajax_load(#currentrow#,#pos_operation_id#,0);"></i>
								</cfif>
							</div>
							<div id="pos_operation_td_2_#currentrow#" <cfif is_flag eq 0>style="display:none;"</cfif>>
								<cfif is_active eq 1 and not listfindnocase(denied_pages,'bank.emptypopup_stop_pos_operation_action')>
									<i class="fa fa-globe" alt="<cf_get_lang dictionary_id='51601.İşlemi Durdur'>" title="<cf_get_lang dictionary_id='51601.İşlemi Durdur'>" onclick="ajax_load_stop(#currentrow#,#pos_operation_id#);"></i>
								</cfif>
							</div>
						</td>
						<td>
							<div id="credit_card_td_#currentrow#" align="center" <cfif count_row_remain eq 0>style="display:none;"</cfif>>
								<i class="fa fa-cube"alt="<cf_get_lang dictionary_id='51604.Sorunlu Kayıtları İmport Et'>" title="<cf_get_lang dictionary_id='51604.Sorunlu Kayıtları İmport Et'>" onclick="ajax_load(#currentrow#,#pos_operation_id#,1);"></i>
							</div>
						</td>
						<td width="20" align="center">
							<cfif not listfindnocase(denied_pages,'bank.popup_pos_operation_report')>
								<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=bank.popup_pos_operation_report&pos_operation_id=#pos_operation_id#','small');" class="rowdelete" title="">
									<i class="fa fa-pencil-square-o" alt="<cf_get_lang dictionary_id='51605.Durum Raporu'>" title="<cf_get_lang dictionary_id='51605.Durum Raporu'>"></i>
								</a>
							</cfif>
						</td>
						<td style="text-align:center;">
							<a href="#request.self#?fuseaction=bank.list_pos_operation&event=upd&pos_operation_id=#pos_operation_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
						</td>
						<!-- sil -->
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="<cfoutput>#colspan_info#</cfoutput>"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfset adres="bank.list_pos_operation">
	<cfif isdefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
		<cfset adres = '#adres#&is_form_submitted=#attributes.is_form_submitted#'>
	</cfif>
	<cfif isdefined('attributes.status') and len(attributes.status)>
		<cfset adres = '#adres#&status=#attributes.status#'>
	</cfif>
	<cfif isdefined('attributes.pos_id') and len(attributes.pos_id)>
		<cfset adres = '#adres#&pos_id=#attributes.pos_id#'>
	</cfif>
	<cfif isdefined('attributes.is_schedule') and len(attributes.is_schedule)>
		<cfset adres = '#adres#&is_schedule=#attributes.is_schedule#'>
	</cfif>
	<cfif isdefined('attributes.schedule_id') and len(attributes.schedule_id)>
		<cfset adres = '#adres#&schedule_id=#attributes.schedule_id#'>
	</cfif>
	<cf_paging page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#"
		adres="#adres#">
</cf_box>
<script language="javascript">
	function ajax_load(row_no,pos_operation_id,type)
	{
		eval('pos_operation_td_'+row_no).style.display = 'none';
		if(type == 0)
		{
			eval('pos_operation_td_2_'+row_no).style.display = '';
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.emptypopup_add_pos_operation_action&row_no='+row_no+'&pos_operation_id='+pos_operation_id+'','pos_operation_action_'+row_no,'1','Çalışıyor');
		}
		else
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.emptypopup_add_pos_operation_action_remain&row_no='+row_no+'&pos_operation_id='+pos_operation_id+'','pos_operation_action_'+row_no,'1','Çalışıyor');
	}
	function ajax_load_stop(row_no,pos_operation_id)
	{
		eval('pos_operation_td_'+row_no).style.display = 'none';
		eval('pos_operation_td_2_'+row_no).style.display = 'none';
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=bank.emptypopup_stop_pos_operation_action&pos_operation_id='+pos_operation_id+'','pos_operation_action_'+row_no,'1','Durduruluyor');
	}
</script>
