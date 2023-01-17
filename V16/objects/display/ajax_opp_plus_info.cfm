<cfsetting showdebugoutput="no">
<cfquery name="GET_OPPORTUNITY_PLUSES" datasource="#dsn3#">
	SELECT
		PLUS_DATE,
		EMPLOYEE_ID,
		RECORD_EMP,
		MAIL_SENDER,
		PLUS_CONTENT,
		OPP_PLUS_ID,
		MAIL_CC
	FROM
		OPPORTUNITIES_PLUS
	WHERE
		OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#opp_id#">
	ORDER BY
		RECORD_DATE DESC
</cfquery>

<cf_grid_list>
	<thead>
        <tr>
            <th colspan="5" width="700"><cf_get_lang dictionary_id='38497.Takipler' ></th>
        </tr>
		<tr>
			<th><cf_get_lang dictionary_id='57483.Kayit'></th>
			<th><cf_get_lang dictionary_id='29457.Mail Gonderilenler'></th>
			<th><cf_get_lang dictionary_id='58773.Bilgi Verilecekler'></th>
			<th><cf_get_lang dictionary_id='57653.İçerik'></th>
			<th width="30">
				<cfif isdefined("get_contact_simple")>
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=sales.popup_form_add_opp_plus&opp_id=#get_opportunity.opp_id#&header=upd_opp.opp_head&contact_mail=#get_contact_simple.email#&contact_person=#get_contact_simple.name# #get_contact_simple.surname#&contact_id=#get_contact_simple.id#</cfoutput>','grid');">
					<img src="/images/plus_square.gif" border="0"></a>
				</cfif>
			</th>
		</tr>
    </thead>
    <tbody>
		<cfif get_opportunity_pluses.recordcount>	
			<cfoutput query="get_opportunity_pluses">
				<tr>
					<td>#dateformat(plus_date,dateformat_style)# - #get_emp_info(record_emp,0,0)#</td>
					<td>#mail_sender#</td>
					<td>#mail_cc#</td>
					<td>#plus_content#</td>
					<td width="30"> <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=sales.popup_form_upd_opp_plus&opp_plus_id=#opp_plus_id#','','ui-draggable-box-medium');"><i class="fa fa-pencil"></i></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="5" ><cf_get_lang dictionary_id='57484.Kayit Yok'> !</td>
			</tr>
		</cfif>
    </tbody>
</cf_grid_list>
