<!---Select ifadeleri düzenlendi E.A 19.07.2012--->
<cfset attributes.TABLE_NAME = "EMPLOYEES_PUANTAJ_CARI_ACTIONS">
<cfquery name="GET_ACTION_DETAIL" datasource="#dsn#">
	SELECT
		EC.PAPER_NO,
		EC.ACTION_DATE,
		EC.RECORD_DATE,
		EC.RECORD_EMP,
		'' UPDATE_DATE,
		'' UPDATE_EMP,
		ECR.ACTION_VALUE,
		ECR.OTHER_ACTION_VALUE,
		ECR.EXPENSE_CENTER_ID,
		ECR.EXPENSE_ITEM_ID,
		ECR.EMPLOYEE_ID,
		ECM.MONEY_TYPE,
		EC.ACTION_DETAIL,
		EC.DEKONT_ID,
		EC.PROCESS_TYPE,
		EC.PUANTAJ_ID
	FROM
		EMPLOYEES_PUANTAJ_CARI_ACTIONS EC,
		EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW ECR,
		EMPLOYEES_PUANTAJ_CARI_ACTIONS_MONEY ECM
	WHERE
		ECR.DEKONT_ROW_ID=#attributes.ID# AND
		ECR.DEKONT_ID = EC.DEKONT_ID AND
		EC.DEKONT_ID = ECM.ACTION_ID AND
		ECM.IS_SELECTED =1
</cfquery>
<cfif len(GET_ACTION_DETAIL.expense_center_id)>
  <cfquery name="GET_EXPENSE" datasource="#dsn2#">
	  SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID='#GET_ACTION_DETAIL.EXPENSE_CENTER_ID#'
  </cfquery>
</cfif>
<cfif len(GET_ACTION_DETAIL.expense_item_id)>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #GET_ACTION_DETAIL.EXPENSE_ITEM_ID#
</cfquery>
</cfif>

<cf_popup_box title="#getLang('main',2149)#">
	<table>
		<cfoutput>
			<tr height="20">
				<td width="100" class="txtbold"><cf_get_lang_main no='468.Belge No'></td>
				<td>: #get_action_detail.PAPER_NO#</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
				<td>: #dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang_main no ='164.Çalışan'></td>
				<td>: <cfif len(get_action_detail.employee_id)>#get_emp_info(get_action_detail.employee_id,0,0)#</cfif></td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang_main no='1048.Masraf Merkezi'></td>
				<td>: <cfif len(get_action_detail.expense_center_id)>#get_expense.expense#</cfif></td>
			</tr>
			<tr height="20">
				<td class="txtbold"><cf_get_lang_main no='1139.Gider Kalemi'></td>
				<td>: <cfif len(get_action_detail.expense_item_id)>#get_expense_item.expense_item_name#</cfif></td>
			</tr>
			<tr height="20">
				<td class="txtbold" height="20"><cf_get_lang_main no ='261.Tutar'></td>
				<td>: #TLFormat(get_action_detail.ACTION_VALUE)# #session.ep.money#</td>
			</tr>
			<tr height="20">
				<td class="txtbold" height="20"><cf_get_lang_main no ='644.Dövizli Tutar'></td>
				<td>: #TLFormat(get_action_detail.OTHER_ACTION_VALUE)# #get_action_detail.money_type#</td>
			</tr>
			<tr height="20">
				<td class="txtbold" height="20"><cf_get_lang_main no='217.Açıklama'></td>
				<td>: #get_action_detail.action_detail#</td>
			</tr>
		</cfoutput>
	</table>
	<cf_popup_box_footer>
		<cfif len(get_action_detail.RECORD_EMP)>
			<cf_record_info query_name="get_action_detail">
		</cfif>
		<cfif not len(get_action_detail.puantaj_id)>
			<cfsavecontent variable="message3"><cf_get_lang no='88.Bu Dekontu Silerseniz Bağlı Olduğu İşleme Ait Tüm Dekontlar Silinecektir Emin Misiniz'>?</cfsavecontent>
			<cf_workcube_buttons is_upd='1' is_delete='1' is_cancel='0' is_insert='0' delete_info="Sil" delete_alert='#message3#' delete_page_url='#request.self#?fuseaction=ch.emptypopup_del_collacted_dekont&dekont_id=#get_action_detail.dekont_id#&process_type=#get_action_detail.process_type#'>
		</cfif>
		<cf_workcube_buttons is_cancel="1" is_insert="0" cancel_info="Kapat">
	</cf_popup_box_footer>
</cf_popup_box>

